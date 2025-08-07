<?php

namespace App\Filament\Admin\Resources\ProductResource\Api\Handlers;

use App\Filament\Admin\Resources\ProductResource;
use App\Models\Product;
use Rupadana\ApiService\Http\Handlers;
use Spatie\QueryBuilder\QueryBuilder;

class PaginationHandler extends Handlers
{
    public static ?string $uri = '/';
    public static ?string $resource = ProductResource::class;

    public function handler()
    {
        $query = QueryBuilder::for(static::getModel())
            ->allowedFilters(['name', 'description'])
            ->with([
                'company',
                'brand',
                'category',
                'orders',
                'garansis',
                'returns',
            ])
            ->withCount([
                'orders',
                'garansis',
                'returns',
            ])
            ->paginate(request()->query('per_page', 10))
            ->appends(request()->query());

        $query->getCollection()->transform(function (Product $product) {
            return array_merge(
                $product->toArray(),
                [
                    'company_name'   => $product->company?->name,
                    'brand_name'     => $product->brand?->name,
                    'category_name'  => $product->category?->name,
                    'image_url'      => $product->image ? asset('storage/' . $product->image) : null,
                    'orders'         => $product->orders,
                    'garansis'       => $product->garansis,
                    'returns'        => $product->returns,
                    'total_orders'   => $product->orders_count,
                    'total_garansis' => $product->garansis_count,
                    'total_returns'  => $product->returns_count,
                ]
            );
        });

        return static::sendSuccessResponse($query, 'Product List Retrieved Successfully');
    }
}
