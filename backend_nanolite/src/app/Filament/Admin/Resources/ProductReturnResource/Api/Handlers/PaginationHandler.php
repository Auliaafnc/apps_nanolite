<?php

namespace App\Filament\Admin\Resources\ProductReturnResource\Api\Handlers;

use App\Filament\Admin\Resources\ProductReturnResource;
use App\Support\ApiPaging;
use Rupadana\ApiService\Http\Handlers;
use Spatie\QueryBuilder\QueryBuilder;
use App\Filament\Admin\Resources\ProductReturnResource\Api\Transformers\ProductReturnTransformer;

class PaginationHandler extends Handlers
{
    use ApiPaging;

    public static ?string $uri = '/';
    public static ?string $resource = ProductReturnResource::class;

    public function handler()
    {
        $paginator = QueryBuilder::for(static::getModel())
            ->allowedFilters(['status','reason','phone'])
            ->with(['company','category','customer','employee','department'])
            ->paginate($this->perPage(request()))
            ->appends(request()->query())
            ->through(fn ($ret) => new ProductReturnTransformer($ret));

        return static::sendSuccessResponse($paginator, 'Product return list retrieved successfully');
    }
}
