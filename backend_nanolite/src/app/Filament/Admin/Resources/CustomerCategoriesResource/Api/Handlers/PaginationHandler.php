<?php

namespace App\Filament\Admin\Resources\CustomerCategoriesResource\Api\Handlers;

use App\Filament\Admin\Resources\CustomerCategoriesResource;
use App\Models\CustomerCategories;
use Rupadana\ApiService\Http\Handlers;
use Spatie\QueryBuilder\QueryBuilder;

class PaginationHandler extends Handlers
{
    public static ?string $uri = '/';
    public static ?string $resource = CustomerCategoriesResource::class;

    public function handler()
    {
        $query = QueryBuilder::for(static::getModel())
            ->allowedFilters(['name', 'deskripsi'])
            ->with([
                'company',
                'customers',
                'customerPrograms',
                'employees',
                'orders',
                'productReturns',
                'garansis',
            ])
            ->withCount([
                'customers',
                'customerPrograms',
                'employees',
                'orders',
                'productReturns',
                'garansis',
            ])
            ->paginate(request()->query('per_page', 10))
            ->appends(request()->query());

        $query->getCollection()->transform(function (CustomerCategories $category) {
            return array_merge(
                $category->toArray(),
                [
                    'company_name'      => $category->company?->name,
                    'program_names'     => $category->customerPrograms->pluck('name')->toArray(),
                    'customers'         => $category->customers,
                    'employees'         => $category->employees,
                    'orders'            => $category->orders,
                    'product_returns'   => $category->productReturns,
                    'garansis'          => $category->garansis,
                    'total_customers'   => $category->customers_count,
                    'total_employees'   => $category->employees_count,
                    'total_orders'      => $category->orders_count,
                    'total_returns'     => $category->productReturns_count,
                    'total_garansis'    => $category->garansis_count,
                    'total_programs'    => $category->customerPrograms_count,
                ]
            );
        });

        return static::sendSuccessResponse($query, 'Customer Categories List Retrieved Successfully');
    }
}
