<?php

namespace App\Filament\Admin\Resources\CustomerCategoriesResource\Api\Handlers;

use App\Filament\Admin\Resources\CustomerCategoriesResource;
use App\Support\ApiPaging;
use Rupadana\ApiService\Http\Handlers;
use Spatie\QueryBuilder\QueryBuilder;
use App\Filament\Admin\Resources\CustomerCategoriesResource\Api\Transformers\CustomerCategoriesTransformer;

class PaginationHandler extends Handlers
{
    use ApiPaging;

    public static ?string $uri = '/';
    public static ?string $resource = CustomerCategoriesResource::class;

    public function handler()
    {
        $paginator = QueryBuilder::for(static::getModel())
            ->allowedFilters(['name','deskripsi'])
            ->with(['company','customers','customerPrograms','employees','orders','productReturns','garansis'])
            ->withCount(['customers','customerPrograms','employees','orders','productReturns','garansis'])
            ->paginate($this->perPage(request()))
            ->appends(request()->query())
            ->through(fn ($cat) => new CustomerCategoriesTransformer($cat));

        return static::sendSuccessResponse($paginator, 'Customer categories list retrieved successfully');
    }
}
