<?php
namespace App\Filament\Admin\Resources\CustomerProgramResource\Api\Transformers;

use Illuminate\Http\Resources\Json\JsonResource;
use App\Models\CustomerProgram;

/**
 * @property CustomerProgram $resource
 */
class CustomerProgramTransformer extends JsonResource
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
