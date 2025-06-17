<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Booking extends Model
{
    protected $table="booking";
    protected $primaryKey='book_id';

    protected $fillable=['p_location','p_count',];

}
