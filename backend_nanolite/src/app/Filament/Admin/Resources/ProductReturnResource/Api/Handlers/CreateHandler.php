<?php

namespace App\Filament\Admin\Resources\ProductReturnResource\Api\Handlers;

use App\Filament\Admin\Resources\ProductReturnResource;
use App\Filament\Admin\Resources\ProductReturnResource\Api\Requests\CreateProductReturnRequest;
use Rupadana\ApiService\Http\Handlers;

class CreateHandler extends Handlers
{
    public static ?string $uri = '/';

    public static ?string $resource = ProductReturnResource::class;

    public static function getMethod()
    {
        return Handlers::POST;
    }

    public static function getModel()
    {
        return static::$resource::getModel();
    }

    /**
     * Create ProductReturn
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function handler(CreateProductReturnRequest $request)
    {
        $model = new (static::getModel());

        $model->fill($request->all());

        $model->save();

        return static::sendSuccessResponse($model, 'Successfully Create Resource');
    }
}