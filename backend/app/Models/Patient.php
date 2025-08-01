<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Patient extends Model
{
    protected $table='patient';

    protected $primaryKey='patient_id';

    protected $fillable = ['book_id', 'p_name', 'p_blood', 'p_age'];
    public $timestamps = true;
     public function booking()
    {
        return $this->belongsTo(Booking::class, 'book_id', 'book_id');
    }
}
