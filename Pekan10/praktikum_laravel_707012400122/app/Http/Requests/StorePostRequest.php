<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StorePostRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'title' => ['required', 'string', 'max:200'],
            'content' => ['required', 'string'],
            'file' => [
                'nullable',
                'file',
                'max:5120',
                'mimes:jpg,jpeg,png,gif,webp,pdf,doc,docx,xls,xlsx,ppt,pptx,txt,zip',
            ],
        ];
    }

    public function messages(): array
    {
        return [
            'file.max' => 'Ukuran file maksimal 5 MB.',
            'file.mimes' => 'Tipe file harus gambar, PDF, dokumen Office, txt, atau zip.',
            'file.uploaded' => 'File gagal diunggah, periksa ukuran file.',
        ];
    }
}
