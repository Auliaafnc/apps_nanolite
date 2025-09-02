<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\Product;
use Illuminate\Support\Facades\Storage;
use Barryvdh\DomPDF\Facade\Pdf;
use Maatwebsite\Excel\Facades\Excel;
use App\Exports\GaransiExport;
use Illuminate\Support\Str;
use App\Models\Concerns\OwnedByEmployee;
use App\Models\Concerns\LatestFirst;

class Garansi extends Model
{
    use HasFactory, OwnedByEmployee, LatestFirst;

    protected $fillable = [
        'no_garansi',
        'company_id',
        'customer_categories_id',
        'employee_id',
        'customer_id',
        'department_id',
        'address',
        'phone',
        'products',
        'purchase_date',
        'claim_date',
        'reason',
        'note',
        'image',
        'status',
        'garansi_file',
        'garansi_excel',
    ];

    protected $casts = [
        'company_id'             => 'integer',
        'customer_id'            => 'integer',
        'employee_id'            => 'integer',
        'department_id'          => 'integer',
        'customer_categories_id' => 'integer',
        'address'                => 'array',
        'products'               => 'array',
        'purchase_date'          => 'date',
        'claim_date'             => 'date',
    ];

    public function company(){ return $this->belongsTo(Company::class); }
    public function customerCategory(){ return $this->belongsTo(CustomerCategories::class, 'customer_categories_id'); }
    public function department(){ return $this->belongsTo(Department::class, 'department_id'); }
    public function employee(){ return $this->belongsTo(Employee::class); }
    public function customer(){ return $this->belongsTo(Customer::class); }

    protected static function booted()
    {
        static::creating(function (Garansi $garansi) {
            // simpan image base64 jika ada
            self::consumeImageString($garansi);

            // konversi warna index -> label agar konsisten
            self::normalizeProductColors($garansi);

            $garansi->no_garansi = 'GAR-' . now()->format('Ymd') . strtoupper(Str::random(4));
        });

        static::saving(function (Garansi $garansi) {
            // berjaga-jaga saat update
            self::consumeImageString($garansi);
            self::normalizeProductColors($garansi);
        });

        static::saved(function (Garansi $garansi) {
            // generate PDF & Excel
            $html = view('invoices.garansi', compact('garansi'))->render();
            $pdf = Pdf::loadHtml($html)->setPaper('a4', 'portrait');

            $pdfFileName = "Garansi-{$garansi->no_garansi}.pdf";
            Storage::disk('public')->put($pdfFileName, $pdf->output());
            $garansi->updateQuietly(['garansi_file' => $pdfFileName]);

            $excelFileName = "Garansi-{$garansi->no_garansi}.xlsx";
            Excel::store(new GaransiExport($garansi), $excelFileName, 'public');
            $garansi->updateQuietly(['garansi_excel' => $excelFileName]);
        });
    }

    /**
     * Normalisasi: jika pada products[*][warna_id] masih angka/index,
     * konversi ke label string berdasarkan $product->colors.
     */
    protected static function normalizeProductColors(Garansi $garansi): void
    {
        $items = $garansi->products;

        if (is_string($items)) {
            $items = json_decode($items, true) ?: [];
        }
        if (!is_array($items)) {
            $items = [];
        }

        foreach ($items as &$it) {
            $pid = $it['produk_id'] ?? null;
            if (!$pid) {
                continue;
            }

            $product = Product::find($pid);
            if (!$product) {
                continue;
            }

            // jika warna angka -> ubah ke label
            if (array_key_exists('warna_id', $it) && is_numeric($it['warna_id'])) {
                $idx = (int) $it['warna_id'];
                $colors = $product->colors ?? [];
                if (isset($colors[$idx])) {
                    $it['warna_id'] = $colors[$idx]; // simpan label, contoh "3000K"
                }
            }
        }

        $garansi->products = $items;
    }

    /**
     * Jika kolom image berisi data URI base64, simpan ke disk dan set jadi path file.
     */
    protected static function consumeImageString(Garansi $garansi): void
    {
        $img = (string) ($garansi->image ?? '');
        if ($img === '') return;

        // jika sudah URL http/https, biarkan
        if (str_starts_with($img, 'http://') || str_starts_with($img, 'https://')) {
            return;
        }

        // Data URI? "data:image/png;base64,AAAA..."
        if (preg_match('/^data:image\/([a-zA-Z0-9.+-]+);base64,/', $img, $m)) {
            $ext  = strtolower($m[1] ?? 'png');
            $data = substr($img, strpos($img, ',') + 1);
            $bin  = base64_decode($data, true);
            if ($bin === false) return;

            $name = 'garansi-photos/' . now()->format('Ymd_His') . '_' . Str::random(8) . '.' . $ext;
            Storage::disk('public')->put($name, $bin);
            $garansi->image = $name;
        }
    }

    // ================= PRODUK =================
    public function productsWithDetails(): array
    {
        $raw = $this->products;
        if (is_string($raw)) $raw = json_decode($raw, true) ?: [];
        elseif (!is_array($raw)) $raw = [];

        return array_map(function ($item) {
            $product = Product::find($item['produk_id'] ?? null);
            return [
                'brand_name'    => $product?->brand?->name ?? '(Brand hilang)',
                'category_name' => $product?->category?->name ?? '(Kategori hilang)',
                'product_name'  => $product?->name ?? '(Produk hilang)',
                'color'         => $item['warna_id'] ?? '-',
                'quantity'      => $item['quantity'] ?? 0,
            ];
        }, $raw);
    }

    public function getProductsDetailsAttribute(): string
    {
        $items = $this->productsWithDetails();
        if (empty($items)) return '';
        return collect($items)->map(fn ($i) =>
            "{$i['brand_name']} – {$i['category_name']} – {$i['product_name']} – {$i['color']} – Qty: {$i['quantity']}"
        )->implode('<br>');
    }

    // ================= ALAMAT =================
    public function getAddressTextAttribute(): string
    {
        if (is_array($this->address) && count($this->address) > 0) {
            $addr = $this->address[0];

            $parts = [
                $addr['detail_alamat'] ?? '',
                $addr['kelurahan'] ?? '',
                $addr['kecamatan'] ?? '',
                $addr['kota_kab'] ?? '',
                $addr['provinsi'] ?? '',
                $addr['kode_pos'] ?? '',
            ];

            $cleaned = array_filter($parts, function ($v) {
                $v = trim((string) $v);
                return $v !== '' && $v !== '-';
            });

            return implode(', ', $cleaned);
        }

        return '-';
    }
}
