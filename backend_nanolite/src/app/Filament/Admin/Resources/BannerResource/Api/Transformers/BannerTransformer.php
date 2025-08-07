<?php
namespace App\Filament\Admin\Resources\BannerResource\Api\Transformers;

use Illuminate\Http\Resources\Json\JsonResource;
use App\Models\Banner;

/**
 * @property Banner $resource
 */
class BannerTransformer extends JsonResource
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
