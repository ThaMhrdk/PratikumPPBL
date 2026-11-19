<?php

namespace App\Http\Controllers;

use App\Http\Requests\StorePostRequest;
use App\Http\Requests\UpdatePostRequest;
use App\Models\Post;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Symfony\Component\HttpFoundation\StreamedResponse;

class PostController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json(Post::latest()->get());
    }

    public function store(StorePostRequest $request): JsonResponse
    {
        $data = $request->safe()->only(['title', 'content']);

        if ($request->hasFile('file')) {
            $data = [...$data, ...$this->storeFile($request->file('file'))];
        }

        $post = $request->user()->posts()->create($data);

        return response()->json($post, 201);
    }

    public function show(int|string $id): JsonResponse
    {
        return response()->json($this->findPost($id));
    }

    public function update(UpdatePostRequest $request, int|string $id): JsonResponse
    {
        $post = $this->findOwnedPost($request, $id);
        $data = $request->safe()->only(['title', 'content']);

        if ($request->hasFile('file')) {
            $this->deleteFile($post);
            $data = [...$data, ...$this->storeFile($request->file('file'))];
        } elseif ($request->boolean('remove_file')) {
            $this->deleteFile($post);
            $data = [...$data, 'file_path' => null, 'file_name' => null];
        }

        $post->update($data);

        return response()->json($post);
    }

    public function destroy(Request $request, int|string $id): JsonResponse
    {
        $post = $this->findOwnedPost($request, $id);
        $this->deleteFile($post);
        $post->delete();

        return response()->json(['message' => 'Post berhasil dihapus']);
    }

    public function file(int|string $id): StreamedResponse
    {
        $post = $this->findPost($id);
        if (! $post->file_path || ! Storage::disk('local')->exists($post->file_path)) {
            abort(404, 'File tidak ditemukan');
        }

        return Storage::disk('local')->response($post->file_path, $post->file_name, [], 'inline');
    }

    private function findPost(int|string $id): Post
    {
        $post = Post::find($id);
        if (! $post) {
            abort(404, 'Post tidak ditemukan');
        }

        return $post;
    }

    private function findOwnedPost(Request $request, int|string $id): Post
    {
        $post = $this->findPost($id);
        if ($post->user_id != $request->user()->id) {
            abort(403, 'Anda tidak memiliki izin untuk mengubah post ini');
        }

        return $post;
    }

    private function storeFile(UploadedFile $file): array
    {
        return [
            'file_path' => $file->store('posts', 'local'),
            'file_name' => $file->getClientOriginalName(),
        ];
    }

    private function deleteFile(Post $post): void
    {
        if ($post->file_path) {
            Storage::disk('local')->delete($post->file_path);
        }
    }
}
