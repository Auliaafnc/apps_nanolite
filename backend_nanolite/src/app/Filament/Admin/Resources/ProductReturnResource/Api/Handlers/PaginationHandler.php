<?php

namespace App\Filament\Admin\Resources\ProductReturnResource\Api\Handlers;

use App\Filament\Admin\Resources\ProductReturnResource;
use App\Models\ProductReturn;
use Rupadana\ApiService\Http\Handlers;
use Spatie\QueryBuilder\QueryBuilder;

class PaginationHandler extends Handlers
{
    public static ?string $uri = '/';
    public static ?string $resource = ProductReturnResource::class;

    public function handler()
    {
        $query = QueryBuilder::for(ProductReturn::class)
            ->allowedFilters(['status', 'reason', 'phone'])
            ->with([
                'company',
                'category',
                'customer',
                'employee',
            ])
            ->paginate(request()->query('per_page', 10))
            ->appends(request()->query());

        $query->getCollection()->transform(function (ProductReturn $return) {
            return array_merge(
                $return->toArray(),
                [
                    'company_name'     => $return->company?->name,
                    'category_name'    => $return->category?->name,
                    'customer_name'    => $return->customer?->name,
                    'employee_name'    => $return->employee?->name,
                    'products_detail'  => $return->productsWithDetails(),
                    'full_address'     => $return->address ? implode(', ', array_filter($return->address)) : '-',
                    'return_pdf_file'  => $return->return_file,
                    'return_excel_file'=> $return->return_excel,
                    'created_at'       => optional($return->created_at)->format('Y-m-d H:i'),
                ]
            );
        });

        return static::sendSuccessResponse($query, 'Product Return list retrieved successfully');
    }
}
