<?php

namespace App\Filament\Admin\Resources\OrderResource\Api\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateOrderRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'company_id'              => 'sometimes|exists:companies,id',
            'customer_id'             => 'sometimes|exists:customers,id',
            'employee_id'             => 'sometimes|exists:employees,id',
            'customer_categories_id' => 'sometimes|exists:customer_categories,id',
            'customer_program_id'     => 'sometimes|exists:customer_programs,id',

            'products'                => 'sometimes|array|min:1',
            'products.*.produk_id'    => 'required_with:products|exists:products,id',
            'products.*.warna_id'     => 'nullable|string',
            'products.*.quantity'     => 'required_with:products|numeric|min:1',
            'products.*.price'        => 'required_with:products|numeric|min:0',

            'diskon_1'                => 'nullable|numeric|min:0|max:100',
            'diskon_2'                => 'nullable|numeric|min:0|max:100',
            'penjelasan_diskon_1'    => 'nullable|string',
            'penjelasan_diskon_2'    => 'nullable|string',
            'diskons_enabled'        => 'boolean',

            'jumlah_produk'          => 'nullable|integer',
            'program_enabled'        => 'boolean',
            'reward_enabled'         => 'boolean',
            'reward_point'           => 'nullable|integer',

            'total_harga'            => 'sometimes|numeric|min:0',
            'total_harga_after_tax'  => 'nullable|numeric|min:0',

            'payment_method'         => 'nullable|string',
            'status_pembayaran'      => 'nullable|string',
            'status'                 => 'sometimes|string|in:pending,processing,completed,cancelled',
        ];
    }
}
