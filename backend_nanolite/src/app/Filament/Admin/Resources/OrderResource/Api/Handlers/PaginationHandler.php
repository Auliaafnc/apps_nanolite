<?php

namespace App\Filament\Admin\Resources\OrderResource\Api\Handlers;

use App\Filament\Admin\Resources\OrderResource;
use App\Support\ApiPaging;
use Rupadana\ApiService\Http\Handlers;
use Spatie\QueryBuilder\QueryBuilder;
use App\Filament\Admin\Resources\OrderResource\Api\Transformers\OrderTransformer;

class PaginationHandler extends Handlers
{
    use ApiPaging;

    public static ?string $uri = '/';
    public static ?string $resource = OrderResource::class;

    public function handler()
    {
        $paginator = QueryBuilder::for(static::getModel())
            ->allowedFilters(['no_order','status','payment_method'])
            ->with([
                'company',
                'employee',
                'department',
                'customer',
                'customer.customerCategory',
                'customerProgram',
            ])
            ->paginate($this->perPage(request()))
            ->appends(request()->query())
            ->through(fn ($order) => new OrderTransformer($order));

        return static::sendSuccessResponse($paginator, 'Order list retrieved successfully');
    }
}
