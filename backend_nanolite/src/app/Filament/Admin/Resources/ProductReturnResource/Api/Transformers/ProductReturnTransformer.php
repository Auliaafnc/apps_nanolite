<?php
namespace App\Filament\Admin\Resources\ProductReturnResource\Api\Transformers;

use Illuminate\Http\Resources\Json\JsonResource;
use App\Models\ProductReturn;

/**
 * @property ProductReturn $resource
 */
class ProductReturnTransformer extends JsonResource
{

    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array
     */
    public function toArray($request)
    {
        return $this->resource->toArray();
    }
}
