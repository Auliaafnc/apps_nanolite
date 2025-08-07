<?php

namespace App\Filament\Admin\Resources\CustomerResource\Api\Requests;

use Illuminate\Foundation\Http\FormRequest;

class CreateCustomerRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'company_id'             => 'required|exists:companies,id',
            'customer_categories_id' => 'required|exists:customer_categories,id',
            'department_id' => 'required|exists:departments,id',
            'employee_id'            => 'nullable|exists:employees,id',
            'customer_program_id'    => 'nullable|exists:customer_programs,id',
            'name'                   => 'required|string|max:255',
            'phone'                  => 'required|string|max:20',
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
