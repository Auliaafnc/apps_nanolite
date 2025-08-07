<?php

namespace App\Filament\Admin\Resources\BannerResource\Api\Handlers;

use App\Filament\Admin\Resources\BannerResource;
use App\Models\Banner;
use Rupadana\ApiService\Http\Handlers;
use Spatie\QueryBuilder\QueryBuilder;

class PaginationHandler extends Handlers
{
    public static ?string $uri = '/';
    public static ?string $resource = BannerResource::class;

    public function handler()
    {
        $perPage = (int) request()->query('per_page', 10);

        $paginator = QueryBuilder::for(Banner::query())
            ->allowedFilters([
                'image_1',
                'image_2',
                'image_3',
                'image_4',
                'company_id', // jika kamu mau filter berdasarkan perusahaan
            ])
            ->allowedSorts([
                'created_at',
                'updated_at',
            ])
            ->with(['company']) // pastikan relasi 'company' ada di model
            ->paginate($perPage)
            ->appends(request()->query());

        $paginator->getCollection()->transform(function (Banner $banner) {
            return array_merge(
                $banner->toArray(),
                [
                    'company_name' => $banner->company->name ?? null,
                    'images' => array_filter([
                        $banner->image_1,
                        $banner->image_2,
                        $banner->image_3,
                        $banner->image_4,
                    ]),
                ]
            );
        });

        return static::sendSuccessResponse(
            $paginator,
            'Banner list retrieved successfully.'
        );
    }
}
