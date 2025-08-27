<?php

namespace App\Filament\Admin\Resources\ProductReturnResource\Api\Requests;

use Illuminate\Foundation\Http\FormRequest;

class CreateProductReturnRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true; // bisa diatur policy kalau perlu
    }

    public function rules(): array
    {
        return [
            'company_id'             => 'required|exists:companies,id',
            'customer_categories_id' => 'required|exists:customer_categories,id',
            'customer_id'            => 'required|exists:customers,id',
            'employee_id'            => 'required|exists:employees,id',
            'department_id'          => 'required|exists:departments,id',

            'reason'  => 'required|string',
            'amount'  => 'required|numeric|min:0',
            'phone'   => 'required|string|max:20',
            'note'    => 'nullable|string',

            // ✅ alamat (bisa lebih dari 1 karena repeater)
            'address'                       => 'required|array|min:1',
            'address.*.detail_alamat'       => 'required|string',
            'address.*.kelurahan'           => 'required|string',
            'address.*.kecamatan'           => 'required|string',
            'address.*.kota_kab'            => 'required|string',
            'address.*.provinsi'            => 'required|string',
            'address.*.kode_pos'            => 'required|string',

            // ✅ produk wajib ada minimal 1
            'products'                      => 'required|array|min:1',
            'products.*.produk_id'          => 'required|integer|exists:products,id',
            'products.*.warna_id'           => 'required|string',
            'products.*.quantity'           => 'required|integer|min:1',

            // ✅ multi foto
            'image'   => 'nullable',
            'image.*' => 'file|image|max:2048', // max 2MB per foto

            'status'  => 'nullable|string|in:pending,approved,rejected',
        ];
    }
}
