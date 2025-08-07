<?php

namespace App\Filament\Admin\Resources\CustomerResource\Api\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateCustomerRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'company_id'             => 'sometimes|exists:companies,id',
            'customer_categories_id' => 'sometimes|exists:customer_categories,id',
            'employee_id'            => 'nullable|exists:employees,id',
            'customer_program_id'    => 'nullable|exists:customer_programs,id',
            'name'                   => 'sometimes|string|max:255',
            'phone'                  => 'sometimes|string|max:20',
            'email'                  => 'nullable|email',
            'address'                => 'nullable|array',
            'gmaps_link'             => 'nullable|string',
            'jumlah_program'         => 'nullable|integer',
            'reward_point'           => 'nullable|integer',
            'image'                  => 'nullable|string',
            'status'                 => 'nullable|string|in:active,inactive',
        ];
    }
}
