<?php

namespace App\Filament\Admin\Resources\OrderResource\Api\Handlers;

use App\Models\Order;
use App\Filament\Admin\Resources\OrderResource;
use Rupadana\ApiService\Http\Handlers;
use Spatie\QueryBuilder\QueryBuilder;

class PaginationHandler extends Handlers
{
    public static ?string $uri = '/';
    public static ?string $resource = OrderResource::class;

    public function handler()
    {
        $query = QueryBuilder::for(Order::class)
            ->allowedFilters(['no_order', 'status', 'payment_method'])
            ->with([
                'customer',
                'company',
                'employee',
                'customer.category',
                'customerProgram',
            ])
            ->paginate(request()->query('per_page', 10))
            ->appends(request()->query());

        $query->getCollection()->transform(function (Order $order) {
            return array_merge(
                $order->toArray(),
                [
                    'customer_name'       => $order->customer?->name,
                    'company_name'        => $order->company?->name,
                    'employee_name'       => $order->employee?->name,
                    'category_name'       => $order->customer->category?->name,
                    'program_name'        => $order->customerProgram?->name,
                    'products_detail'     => $order->productsWithDetails(),

                    // Data langsung dari tabel order
                    'phone'               => $order->phone,
                    'address'             => $order->address,
                    'full_address'        => $order->full_address ?? null,

                    'diskon_1'            => $order->diskon_1,
                    'diskon_2'            => $order->diskon_2,
                    'diskons_enabled'     => $order->diskons_enabled,
                    'penjelasan_diskon_1' => $order->penjelasan_diskon_1,
                    'penjelasan_diskon_2' => $order->penjelasan_diskon_2,

                    'total_discount'      => $order->total_discount,
                    'after_discount'      => $order->total_after_discount,
                    'total_harga'         => $order->total_harga,
                    'total_harga_after_tax' => $order->total_harga_after_tax,
                ]
            );
        });

        return static::sendSuccessResponse($query, 'Order list retrieved successfully');
    }
}
