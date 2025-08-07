<?php

namespace App\Filament\Admin\Resources\CustomerProgramResource\Api\Handlers;

use App\Filament\Admin\Resources\CustomerProgramResource;
use App\Models\CustomerProgram;
use Rupadana\ApiService\Http\Handlers;
use Spatie\QueryBuilder\QueryBuilder;

class PaginationHandler extends Handlers
{
    public static ?string $uri = '/';
    public static ?string $resource = CustomerProgramResource::class;

    public function handler()
    {
        $query = QueryBuilder::for(static::getModel())
            ->allowedFilters(['name', 'deskripsi'])
            ->with([
                'company',
                'customerCategories',
                'customers',
                'employees',
                'orders',
            ])
            ->withCount([
                'customerCategories',
                'customers',
                'employees',
                'orders',
            ])
            ->paginate(request()->query('per_page', 10))
            ->appends(request()->query());

        $query->getCollection()->transform(function (CustomerProgram $program) {
            return array_merge(
                $program->toArray(),
                [
                    'company_name'     => $program->company?->name,
                    'category_names'   => $program->customerCategories->pluck('name')->toArray(),
                    'customers'        => $program->customers,
                    'employees'        => $program->employees,
                    'orders'           => $program->orders,
                    'total_customers'  => $program->customers_count,
                    'total_employees'  => $program->employees_count,
                    'total_orders'     => $program->orders_count,
                    'total_categories' => $program->customerCategories_count,
                ]
            );
        });

        return static::sendSuccessResponse($query, 'Customer Programs List Retrieved Successfully');
    }
}
