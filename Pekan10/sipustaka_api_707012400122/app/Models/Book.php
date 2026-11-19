<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Book extends Model
{
    protected $fillable = [
        'judul',
        'penulis',
        'penerbit',
        'tahun_terbit',
        'stok',
        'cover',
        'cover_name',
    ];

    protected $hidden = ['cover'];

    protected $appends = ['cover_url'];

    public function loans(): HasMany
    {
        return $this->hasMany(Loan::class);
    }

    protected function coverUrl(): Attribute
    {
        return Attribute::get(
            fn (): ?string => $this->cover
                ? url("/api/books/{$this->id}/cover")
                : null
        );
    }
}
