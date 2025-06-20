<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Booking extends Model
{
    protected $table = "booking";
    protected $primaryKey = 'book_id';
public $timestamps = false;
    protected $fillable = [
        'driver_id',
        'user_id',
        'p_location',
        'p_count',
        'status',
        'created_at',
        'end_time',
    ];

}
