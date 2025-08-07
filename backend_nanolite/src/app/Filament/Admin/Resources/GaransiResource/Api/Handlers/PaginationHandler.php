<?php

namespace App\Filament\Admin\Resources\GaransiResource\Api\Handlers;

use App\Models\Garansi;
use App\Filament\Admin\Resources\GaransiResource;
use Rupadana\ApiService\Http\Handlers;
use Spatie\QueryBuilder\QueryBuilder;

class PaginationHandler extends Handlers
{
    public static ?string $uri = '/';
    public static ?string $resource = GaransiResource::class;

    public function handler()
    {
        $query = QueryBuilder::for(Garansi::class)
            ->allowedFilters(['status', 'phone', 'reason','purchase_date', 'claim_date', 'customer'])
            ->with([
                'company',
                'customerCategory',
                'employee',
                'customer',
            ])
            ->paginate(request()->query('per_page', 10))
            ->appends(request()->query());

        // Transformasi hasil
        $query->getCollection()->transform(function (Garansi $garansi) {
            return array_merge(
                $garansi->toArray(),
                [
                    'company_name'        => $garansi->company?->name,
                    'customer_name'       => $garansi->customer?->name,
                    'employee_name'       => $garansi->employee?->name,
                    'category_name'       => $garansi->customerCategory?->name,
                    'products_detail'     => $garansi->productsWithDetails(),
                    'full_address'        => $garansi->address ? implode(', ', array_filter($garansi->address)) : null,
                    'purchase_date'       => optional($garansi->purchase_date)->format('d-m-Y'),
                    'claim_date'          => optional($garansi->claim_date)->format('d-m-Y'),
                    'garansi_pdf_file'      => $garansi->garansi_file,
                    'garansi_excel_file'    => $garansi->garansi_excel,
                ]
            );
        });

        return static::sendSuccessResponse($query, 'Garansi list retrieved successfully');
    }
}
