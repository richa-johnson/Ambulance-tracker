<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Facility extends Model
{
    use HasFactory;

    protected $table = 'facility'; // or your actual table name
    public $timestamps = false;

    protected $fillable = [
        'driver_id',
        'facility',
    ];

    protected $primaryKey = null;
    public $incrementing = false;
    public function driver()
    {
        return $this->belongsTo(ambulanceDriver::class, 'driver_id', 'driver_id');
    }
}
