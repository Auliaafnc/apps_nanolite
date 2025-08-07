<?php

namespace App\Filament\Admin\Resources\CompanyResource\Api\Handlers;

use App\Filament\Admin\Resources\CompanyResource;
use App\Models\Company;
use Rupadana\ApiService\Http\Handlers;
use Spatie\QueryBuilder\QueryBuilder;

class PaginationHandler extends Handlers
{
    public static ?string $uri = '/';
    public static ?string $resource = CompanyResource::class;

    public function handler()
    {
        $query = QueryBuilder::for(static::getModel())
            ->allowedFilters(['name', 'email', 'phone', 'status'])
            ->with([
                'departemen',
                'employees',
                'brands',
                'categories',
                'products',
                'customerCategories',
                'customerPrograms',
                'customers',
                'orders',
                'productReturns',
                'garansis',
            ])
            ->withCount([
                'departemen',
                'employees',
                'brands',
                'categories',
                'products',
                'customerCategories',
                'customerPrograms',
                'customers',
                'orders',
                'productReturns',
                'garansis',
            ])
            ->paginate(request()->query('per_page', 10))
            ->appends(request()->query());

        $query->getCollection()->transform(function (Company $company) {
            return array_merge(
                $company->toArray(),
                [
                    'full_address' => $company->full_address,
                    'departemen' => $company->departemen,
                    'employees' => $company->employees,
                    'brands' => $company->brands,
                    'categories' => $company->categories,
                    'products' => $company->products,
                    'customer_categories' => $company->customerCategories,
                    'customer_programs' => $company->customerPrograms,
                    'customers' => $company->customers,
                    'orders' => $company->orders,
                    'product_returns' => $company->productReturns,
                    'garansis' => $company->garansis,
                    'total_departemen' => $company->departemen_count,
                    'total_employees' => $company->employees_count,
                    'total_brands' => $company->brands_count,
                    'total_categories' => $company->categories_count,
                    'total_products' => $company->products_count,
                    'total_customer_categories' => $company->customerCategories_count,
                    'total_customer_programs' => $company->customerPrograms_count,
                    'total_customers' => $company->customers_count,
                    'total_orders' => $company->orders_count,
                    'total_product_returns' => $company->productReturns_count,
                    'total_garansis' => $company->garansis_count,
                ]
            );
        });

        return static::sendSuccessResponse($query, 'Company List Retrieved Successfully');
    }
}
