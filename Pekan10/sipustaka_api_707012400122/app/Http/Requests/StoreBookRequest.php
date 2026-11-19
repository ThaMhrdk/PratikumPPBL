<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreBookRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'judul' => ['required', 'string', 'max:200'],
            'penulis' => ['required', 'string', 'max:150'],
            'penerbit' => ['required', 'string', 'max:150'],
            'tahun_terbit' => ['required', 'integer', 'min:1900', 'max:2100'],
            'stok' => ['required', 'integer', 'min:0'],
            'cover' => ['nullable', 'file', 'max:2048', 'mimes:jpg,jpeg,png'],
        ];
    }

    public function messages(): array
    {
        return [
            'cover.max' => 'Ukuran sampul buku maksimal 2 MB.',
            'cover.mimes' => 'Format sampul buku harus berupa jpg, jpeg, atau png.',
            'cover.uploaded' => 'Sampul buku gagal diunggah, periksa ukuran file.',
        ];
    }
}
