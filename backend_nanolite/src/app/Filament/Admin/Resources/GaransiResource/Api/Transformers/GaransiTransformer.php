<?php
namespace App\Filament\Admin\Resources\GaransiResource\Api\Transformers;

use Illuminate\Http\Resources\Json\JsonResource;
use App\Models\Garansi;

/**
 * @property Garansi $resource
 */
class GaransiTransformer extends JsonResource
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
