<?php

namespace App\Filament\Admin\Resources\BrandResource\Api\Handlers;

use App\Filament\Admin\Resources\BrandResource;
use App\Models\Brand;
use Rupadana\ApiService\Http\Handlers;
use Spatie\QueryBuilder\QueryBuilder;

class PaginationHandler extends Handlers
{
    public static ?string $uri = '/';
    public static ?string $resource = BrandResource::class;

    public function handler()
    {
        $query = QueryBuilder::for(static::getModel())
            ->allowedFilters(['name', 'deskripsi'])
            ->with([
                'company',
                'categories',
                'products',
            ])
            ->withCount([
                'categories',
                'products',
            ])
            ->paginate(request()->query('per_page', 10))
            ->appends(request()->query());

        $query->getCollection()->transform(function (Brand $brand) {
            return array_merge(
                $brand->toArray(),
                [
                    'company_name'     => $brand->company?->name,
                    'total_categories' => $brand->categories_count,
                    'total_products'   => $brand->products_count,
                ]
            );
        });

        return static::sendSuccessResponse($query, 'Brand List Retrieved Successfully');
    }
}
