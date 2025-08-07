<?php

namespace App\Filament\Admin\Resources\EmployeeResource\Api\Handlers;

use App\Filament\Admin\Resources\EmployeeResource;
use App\Models\Employee;
use Rupadana\ApiService\Http\Handlers;
use Spatie\QueryBuilder\QueryBuilder;

class PaginationHandler extends Handlers
{
    public static ?string $uri = '/';
    public static ?string $resource = EmployeeResource::class;

    public function handler()
    {
        $query = QueryBuilder::for(static::getModel())
            ->allowedFilters(['name', 'email', 'phone', 'status'])
            ->with([
                'company',
                'department',
                'orders',
                'productReturns',
                'garansis',
                'customers',
            ])
            ->withCount([
                'orders',
                'productReturns',
                'garansis',
                'customers',
            ])
            ->paginate(request()->query('per_page', 10))
            ->appends(request()->query());

        $query->getCollection()->transform(function (Employee $employee) {
            return array_merge(
                $employee->toArray(),
                [
                    'full_address'     => $employee->full_address,
                    'photo_url'        => $employee->photo
                        ? asset('storage/' . $employee->photo)
                        : null,
                    'company_name'     => $employee->company?->name,
                    'department_name'  => $employee->department?->name,
                    'total_orders'     => $employee->orders_count,
                    'total_returns'    => $employee->product_returns_count,
                    'total_garansis'   => $employee->garansis_count,
                    'total_customers'  => $employee->customers_count,
                ]
            );
        });

        return static::sendSuccessResponse($query, 'Employee List Retrieved Successfully');
    }
}
