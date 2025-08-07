<?php
namespace App\Filament\Admin\Resources\CustomerCategoriesResource\Api\Transformers;

use Illuminate\Http\Resources\Json\JsonResource;
use App\Models\CustomerCategories;

/**
 * @property CustomerCategories $resource
 */
class CustomerCategoriesTransformer extends JsonResource
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
