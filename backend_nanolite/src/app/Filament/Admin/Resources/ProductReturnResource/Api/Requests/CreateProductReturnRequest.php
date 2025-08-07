<?php

namespace App\Filament\Admin\Resources\ProductReturnResource\Api\Requests;

use Illuminate\Foundation\Http\FormRequest;

class CreateProductReturnRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'company_id'              => ['required', 'integer', 'exists:companies,id'],
            'customer_categories_id'  => ['required', 'integer', 'exists:customer_categories,id'],
            'customer_id'             => ['required', 'integer', 'exists:customers,id'],
            'employee_id'             => ['required', 'integer', 'exists:employees,id'],
            'reason'                  => ['required', 'string'],
            'amount'                  => ['required', 'numeric', 'min:0'],
            'image'                   => ['nullable', 'string'],
            'phone'                   => ['required', 'string'],
            'note'                    => ['nullable', 'string'],
            'address'                 => ['required', 'array'],
            'address.detail_alamat'   => ['required', 'string'],
            'address.kelurahan'       => ['required', 'string'],
            'address.kecamatan'       => ['required', 'string'],
            'address.kota_kab'        => ['required', 'string'],
            'address.provinsi'        => ['required', 'string'],
            'address.kode_pos'        => ['required', 'string'],
            'products'                => ['required', 'array', 'min:1'],
            'products.*.produk_id'    => ['required', 'integer', 'exists:products,id'],
            'products.*.warna_id'     => ['required', 'string'],
            'products.*.quantity'     => ['required', 'integer', 'min:1'],
            'status'                  => ['required', 'in:pending,approved,rejected'],
        ];
    }
}
