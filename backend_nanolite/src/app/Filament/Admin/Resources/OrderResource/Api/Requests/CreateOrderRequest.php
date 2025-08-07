<?php

namespace App\Filament\Admin\Resources\OrderResource\Api\Requests;

use Illuminate\Foundation\Http\FormRequest;

class CreateOrderRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'company_id'              => 'required|exists:companies,id',
            'customer_id'             => 'required|exists:customers,id',
            'employee_id'             => 'required|exists:employees,id',
            'customer_categories_id' => 'nullable|exists:customer_categories,id',
            'customer_program_id'     => 'nullable|exists:customer_programs,id',

            'products'                => 'required|array|min:1',
            'products.*.produk_id'    => 'required|exists:products,id',
            'products.*.warna_id'     => 'nullable|string',
            'products.*.quantity'     => 'required|numeric|min:1',
            'products.*.price'        => 'required|numeric|min:0',

            'diskon_1'                => 'nullable|numeric|min:0|max:100',
            'diskon_2'                => 'nullable|numeric|min:0|max:100',
            'penjelasan_diskon_1'    => 'nullable|string',
            'penjelasan_diskon_2'    => 'nullable|string',
            'diskons_enabled'        => 'boolean',

            'jumlah_produk'          => 'nullable|integer',
            'program_enabled'        => 'boolean',
            'reward_enabled'         => 'boolean',
            'reward_point'           => 'nullable|integer',

            'total_harga'            => 'required|numeric|min:0',
            'total_harga_after_tax'  => 'nullable|numeric|min:0',

            'payment_method'         => 'nullable|string',
            'status_pembayaran'      => 'nullable|string',
            'status'                 => 'required|string|in:pending,processing,completed,cancelled',
        ];
    }
}
