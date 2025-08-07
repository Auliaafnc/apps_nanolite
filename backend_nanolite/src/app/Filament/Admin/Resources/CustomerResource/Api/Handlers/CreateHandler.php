<?php

namespace App\Filament\Admin\Resources\CustomerResource\Api\Handlers;

use App\Filament\Admin\Resources\CustomerResource;
use App\Filament\Admin\Resources\CustomerResource\Api\Requests\CreateCustomerRequest;
use Rupadana\ApiService\Http\Handlers;

class CreateHandler extends Handlers
{
    public static ?string $uri = '/';

    public static ?string $resource = CustomerResource::class;

    public static function getMethod()
    {
        return Handlers::POST;
    }

    public static function getModel()
    {
        return static::$resource::getModel();
    }

    /**
     * Create Customer
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function handler(CreateCustomerRequest $request)
    {
        $model = new (static::getModel());

        $model->fill($request->all());

        $model->save();

        return static::sendSuccessResponse($model, 'Successfully Create Resource');
    }
}