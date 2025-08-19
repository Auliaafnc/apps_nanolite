<?php

namespace App\Filament\Admin\Resources\CustomerResource\Api\Handlers;

use App\Filament\Admin\Resources\CustomerResource;
use App\Support\ApiPaging;
use Rupadana\ApiService\Http\Handlers;
use Spatie\QueryBuilder\QueryBuilder;
use App\Filament\Admin\Resources\CustomerResource\Api\Transformers\CustomerTransformer;

class PaginationHandler extends Handlers
{
    use ApiPaging;

    public static ?string $uri = '/';
    public static ?string $resource = CustomerResource::class;

    public function handler()
    {
        $paginator = QueryBuilder::for(static::getModel())
            ->allowedFilters(['name','email','phone','status'])
            ->with(['company','customerCategory','customerProgram','employee','orders','garansis','productReturns'])
            ->withCount(['orders','garansis','productReturns'])
            ->paginate($this->perPage(request()))
            ->appends(request()->query())
            ->through(fn ($cust) => new CustomerTransformer($cust));

        return static::sendSuccessResponse($paginator, 'Customer list retrieved successfully');
    }
}
