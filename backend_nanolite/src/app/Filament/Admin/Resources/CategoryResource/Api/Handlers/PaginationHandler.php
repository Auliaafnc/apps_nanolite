<?php

namespace App\Filament\Admin\Resources\CategoryResource\Api\Handlers;

use App\Filament\Admin\Resources\CategoryResource;
use App\Models\Category;
use Rupadana\ApiService\Http\Handlers;
use Spatie\QueryBuilder\QueryBuilder;

class PaginationHandler extends Handlers
{
    public static ?string $uri = '/';
    public static ?string $resource = CategoryResource::class;

    public function handler()
    {
        $query = QueryBuilder::for(static::getModel())
            ->allowedFilters(['name', 'deskripsi'])
            ->with([
                'brand',
                'brand.company', // relasi sampai ke perusahaan brand
                'products',
            ])
            ->withCount([
                'products',
            ])
            ->paginate(request()->query('per_page', 10))
            ->appends(request()->query());

        $query->getCollection()->transform(function (Category $category) {
            return array_merge(
                $category->toArray(),
                [
                    'brand_name'    => $category->brand?->name,
                    'company_name'  => $category->brand?->company?->name,
                    'total_products' => $category->products_count,
                    'image_url'     => $category->image ? asset('storage/' . $category->image) : null,
                ]
            );
        });

        return static::sendSuccessResponse($query, 'Category List Retrieved Successfully');
    }
}
