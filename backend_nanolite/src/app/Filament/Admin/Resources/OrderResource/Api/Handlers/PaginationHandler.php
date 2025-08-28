<?php

namespace App\Filament\Admin\Resources\OrderResource\Api\Handlers;

use App\Filament\Admin\Resources\OrderResource;
use App\Support\ApiPaging;
use Rupadana\ApiService\Http\Handlers;
use Spatie\QueryBuilder\QueryBuilder;
use App\Filament\Admin\Resources\OrderResource\Api\Transformers\OrderTransformer;
use App\Models\CustomerProgram;
use App\Models\Customer;

class PaginationHandler extends Handlers
{
    use ApiPaging;

    public static ?string $uri = '/';
    public static ?string $resource = OrderResource::class;

    public function handler()
    {
        switch (request('type')) {
            case 'departments':
                return \App\Models\Department::select('id','name')
                    ->orderBy('name')
                    ->get();

            case 'employees':
                return \App\Models\Employee::select('id','name')
                    ->when(request('department_id'), function ($q) {
                        $q->where('department_id', request('department_id'));
                    })
                    ->orderBy('name')
                    ->get();

            case 'customer-categories':
                $employeeId = request('employee_id');
                return \App\Models\CustomerCategory::query()
                    ->when($employeeId, function ($q) use ($employeeId) {
                        $q->whereHas('customers', fn($sub) => $sub->where('employee_id', $employeeId));
                    })
                    ->select('id','name')
                    ->orderBy('name')
                    ->get();

            case 'customers':
                $employeeId   = request('employee_id');
                $categoryId   = request('customer_categories_id');
                $departmentId = request('department_id');

                return \App\Models\Customer::query()
                    ->where('status', 'active')
                    ->when($employeeId, fn($q) => $q->where('employee_id', $employeeId))
                    ->when($categoryId, fn($q) => $q->where('customer_categories_id', $categoryId))
                    ->when($departmentId, fn($q) => $q->where('department_id', $departmentId))
                    ->select('id','name','phone','address','customer_program_id','employee_id','department_id','customer_categories_id')
                    ->orderBy('name')
                    ->distinct()
                    ->get();


            case 'customer-programs':
                $customerId = request('customer_id');
                if ($customerId) {
                    $customer = \App\Models\Customer::with('customerProgram')->find($customerId);
                    return $customer && $customer->customerProgram
                        ? collect([$customer->customerProgram->only('id','name')])
                        : collect([]);
                }
                return \App\Models\CustomerProgram::select('id','name')
                    ->orderBy('name')
                    ->get();

        }

        // default pagination
        $paginator = QueryBuilder::for(static::getModel())
            ->allowedFilters([
                'status',
                'status_pembayaran',
                'payment_method',
                'customer_id',
                'employee_id',
                'department_id',
                'customer_categories_id',
            ])
            ->with([
                'department:id,name',
                'employee:id,name',
                'customer:id,name',
                'customerCategory:id,name',
                'customerProgram:id,name',
            ])
            ->latest('id')
            ->paginate($this->perPage(request()))
            ->appends(request()->query())
            ->through(fn ($row) => new OrderTransformer($row));

        return static::sendSuccessResponse($paginator, 'Order list retrieved successfully');
    }
}
