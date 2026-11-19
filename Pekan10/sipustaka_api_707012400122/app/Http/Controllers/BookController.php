<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreBookRequest;
use App\Http\Requests\UpdateBookRequest;
use App\Models\Book;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Symfony\Component\HttpFoundation\StreamedResponse;

class BookController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json(Book::latest()->get());
    }

    public function store(StoreBookRequest $request): JsonResponse
    {
        $data = $request->safe()->only([
            'judul',
            'penulis',
            'penerbit',
            'tahun_terbit',
            'stok',
        ]);

        if ($request->hasFile('cover')) {
            $data = [...$data, ...$this->storeCover($request->file('cover'))];
        }

        $book = Book::create($data);

        return response()->json($book, 201);
    }

    public function show(int|string $id): JsonResponse
    {
        return response()->json($this->findBook($id));
    }

    public function update(UpdateBookRequest $request, int|string $id): JsonResponse
    {
        $book = $this->findBook($id);
        $data = $request->safe()->only([
            'judul',
            'penulis',
            'penerbit',
            'tahun_terbit',
            'stok',
        ]);

        if ($request->hasFile('cover')) {
            $this->deleteCover($book);
            $data = [...$data, ...$this->storeCover($request->file('cover'))];
        } elseif ($request->boolean('remove_cover')) {
            $this->deleteCover($book);
            $data = [...$data, 'cover' => null, 'cover_name' => null];
        }

        $book->update($data);

        return response()->json($book);
    }

    public function destroy(int|string $id): JsonResponse
    {
        $book = $this->findBook($id);
        $this->deleteCover($book);
        $book->delete();

        return response()->json(['message' => 'Buku berhasil dihapus']);
    }

    public function cover(int|string $id): StreamedResponse
    {
        $book = $this->findBook($id);
        if (! $book->cover || ! Storage::disk('local')->exists($book->cover)) {
            abort(404, 'Sampul buku tidak ditemukan');
        }

        return Storage::disk('local')->response($book->cover, $book->cover_name, [], 'inline');
    }

    private function findBook(int|string $id): Book
    {
        $book = Book::find($id);
        if (! $book) {
            abort(404, 'Buku tidak ditemukan');
        }

        return $book;
    }

    private function storeCover(UploadedFile $file): array
    {
        return [
            'cover' => $file->store('covers', 'local'),
            'cover_name' => $file->getClientOriginalName(),
        ];
    }

    private function deleteCover(Book $book): void
    {
        if ($book->cover) {
            Storage::disk('local')->delete($book->cover);
        }
    }
}
