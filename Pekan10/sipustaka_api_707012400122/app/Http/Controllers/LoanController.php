<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreLoanRequest;
use App\Http\Requests\UpdateLoanRequest;
use App\Models\Loan;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class LoanController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json(
            Loan::with(['book', 'user:id,name,email'])->latest()->get()
        );
    }

    public function store(StoreLoanRequest $request): JsonResponse
    {
        $data = $request->validated();
        $data['user_id'] = $request->user()->id;
        $data['status'] = $data['status'] ?? 'Dipinjam';

        $loan = Loan::create($data);

        return response()->json($loan->load(['book', 'user:id,name,email']), 201);
    }

    public function show(int|string $id): JsonResponse
    {
        return response()->json(
            $this->findLoan($id)->load(['book', 'user:id,name,email'])
        );
    }

    public function update(UpdateLoanRequest $request, int|string $id): JsonResponse
    {
        $loan = $this->findOwnedLoan($request, $id);
        $loan->update($request->validated());

        return response()->json($loan->load(['book', 'user:id,name,email']));
    }

    public function destroy(Request $request, int|string $id): JsonResponse
    {
        $this->findOwnedLoan($request, $id)->delete();

        return response()->json(['message' => 'Data peminjaman berhasil dihapus']);
    }

    private function findLoan(int|string $id): Loan
    {
        $loan = Loan::find($id);
        if (! $loan) {
            abort(404, 'Data peminjaman tidak ditemukan');
        }

        return $loan;
    }

    private function findOwnedLoan(Request $request, int|string $id): Loan
    {
        $loan = $this->findLoan($id);
        if ($loan->user_id != $request->user()->id) {
            abort(403, 'Anda tidak memiliki izin untuk mengubah peminjaman ini');
        }

        return $loan;
    }
}
