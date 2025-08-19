<?php

namespace App\Filament\Admin\Resources\CustomerResource\Api\Transformers;

use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Storage;
use Laravolt\Indonesia\Models\Provinsi;
use Laravolt\Indonesia\Models\Kabupaten;
use Laravolt\Indonesia\Models\Kecamatan;
use Laravolt\Indonesia\Models\Kelurahan;
use App\Models\PostalCode;

class CustomerTransformer extends JsonResource
{
    public function toArray($request): array
    {
        $this->resource->loadMissing([
            'department:id,name',
            'employee:id,name',
            'customerCategory:id,name',
            'customerProgram:id,name',
        ]);

        $statusPengajuanLabel = match ($this->status_pengajuan) {
            'approved' => 'Disetujui',
            'rejected' => 'Ditolak',
            default    => 'Pending',
        };

        $imageUrl = $this->image ? Storage::url($this->image) : null;
        $alamatReadable = $this->mapAddressesReadable($this->address);

        return [
            'department'            => $this->department?->name ?? '-',
            'employee'              => $this->employee?->name ?? '-',
            'name'                  => $this->name ?? '-',
            'category_name'         => $this->customerCategory?->name ?? '-',
            'phone'                 => $this->phone ?? '-',
            'email'                 => $this->email, // null kalau kosong, terisi kalau ada
            'alamat'                => $this->full_address
                                       ?? ($alamatReadable[0]['detail_alamat'] ?? null),
            'alamat_detail'         => $alamatReadable,
            'maps'                  => $this->gmaps_link,
            'customer_program_name' => $this->customerProgram?->name ?? '-',
            'program_point'         => (int)($this->jumlah_program ?? 0),
            'reward_point'          => (int)($this->reward_point ?? 0),
            'image'                 => $imageUrl,
            'status'                => $statusPengajuanLabel,
            'created_at'            => optional($this->created_at)->format('d/m/Y'),
            'updated_at'            => optional($this->updated_at)->format('d/m/Y'),
        ];
    }

    /* ---------- Helpers: address mapping ---------- */

    private function mapAddressesReadable($address): array
    {
        $items = is_array($address) ? $address : json_decode($address ?? '[]', true);
        if (!is_array($items)) $items = [];

        return array_map(function ($a) {
            $provCode = $a['provinsi']  ?? null;
            $kabCode  = $a['kota_kab']  ?? null;
            $kecCode  = $a['kecamatan'] ?? null;
            $kelCode  = $a['kelurahan'] ?? null;

            return [
                'detail_alamat' => $a['detail_alamat'] ?? null,
                'provinsi'      => ['code' => $provCode, 'name' => $this->nameFromCode(Provinsi::class,  $provCode)],
                'kota_kab'      => ['code' => $kabCode,  'name' => $this->nameFromCode(Kabupaten::class, $kabCode)],
                'kecamatan'     => ['code' => $kecCode,  'name' => $this->nameFromCode(Kecamatan::class, $kecCode)],
                'kelurahan'     => ['code' => $kelCode,  'name' => $this->nameFromCode(Kelurahan::class, $kelCode)],
                'kode_pos'      => $a['kode_pos'] ?? $this->postalByVillage($kelCode),
            ];
        }, $items);
    }

    private function nameFromCode(string $model, ?string $code): ?string
    {
        if (!$code) return null;
        return optional($model::where('code', $code)->first())->name;
    }

    private function postalByVillage(?string $villageCode): ?string
    {
        if (!$villageCode) return null;
        return optional(PostalCode::where('village_code', $villageCode)->first())->postal_code;
    }
}
