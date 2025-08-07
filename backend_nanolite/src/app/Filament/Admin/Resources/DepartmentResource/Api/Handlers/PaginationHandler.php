<?php

namespace App\Filament\Admin\Resources\DepartmentResource\Api\Handlers;

use App\Filament\Admin\Resources\DepartmentResource;
use App\Models\Department;
use Rupadana\ApiService\Http\Handlers;
use Spatie\QueryBuilder\QueryBuilder;

class PaginationHandler extends Handlers
{
    public static ?string $uri = '/';
    public static ?string $resource = DepartmentResource::class;

    public function handler()
    {
        $query = QueryBuilder::for(static::getModel())
            ->allowedFilters(['name', 'status'])
            ->with([
                'company',
                'employees',
            ])
            ->withCount([
                'employees',
            ])
            ->paginate(request()->query('per_page', 10))
            ->appends(request()->query());

        $query->getCollection()->transform(function (Department $dept) {
            return array_merge(
                $dept->toArray(),
                [
                    'company_name'     => $dept->company?->name,
                    'total_employees'  => $dept->employees_count,
                ]
            );
        });

        return static::sendSuccessResponse($query, 'Department List Retrieved Successfully');
    }
}
