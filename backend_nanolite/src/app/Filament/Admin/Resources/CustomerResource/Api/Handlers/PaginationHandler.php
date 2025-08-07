<?php

namespace App\Filament\Admin\Resources\CustomerResource\Api\Handlers;

use App\Filament\Admin\Resources\CustomerResource;
use App\Models\Customer;
use Rupadana\ApiService\Http\Handlers;
use Spatie\QueryBuilder\QueryBuilder;

class PaginationHandler extends Handlers
{
    public static ?string $uri = '/';
    public static ?string $resource = CustomerResource::class;

    public function handler()
    {
        $query = QueryBuilder::for(static::getModel())
            ->allowedFilters(['name', 'email', 'phone', 'status'])
            ->with([
                'company',
                'customerCategory',
                'customerProgram',
                'employee',
                'orders',
                'garansis',
                'productReturns',
            ])
            ->withCount([
                'orders',
                'garansis',
                'productReturns',
            ])
            ->paginate(request()->query('per_page', 10))
            ->appends(request()->query());

        $query->getCollection()->transform(function (Customer $customer) {
            return array_merge(
                $customer->toArray(),
                [
                    'company_name'           => $customer->company?->name,
                    'category_name'          => $customer->customerCategories?->name,
                    'program_name'           => $customer->customerProgram?->name,
                    'employee_name'          => $customer->employee?->name,
                    'full_address'           => $customer->full_address,
                    'orders'                 => $customer->orders,
                    'garansis'               => $customer->garansis,
                    'product_returns'        => $customer->productReturns,
                    'total_orders'           => $customer->orders_count,
                    'total_garansis'         => $customer->garansis_count,
                    'total_product_returns'  => $customer->productReturns_count,
                ]
            );
        });

        return static::sendSuccessResponse($query, 'Customer List Retrieved Successfully');
    }
}
