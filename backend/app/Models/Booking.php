<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Booking extends Model
{
    protected $table = "booking";
    protected $primaryKey = 'book_id';
        public    $incrementing = true;      // if it’s auto‑increment
    protected $keyType    = 'int';
public $timestamps = false;
    protected $fillable = [
        'driver_id',
        'user_id',
        'p_location',
        'p_count',
        'b_status',
        'created_at',
        'end_time',
    ];


    public function user()
{
    return $this->belongsTo(User::class, 'user_id', 'user_id');
}
}
