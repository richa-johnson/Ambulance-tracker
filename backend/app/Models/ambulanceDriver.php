<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use PhpParser\Node\Expr\List_;

class ambulanceDriver extends Authenticatable{
    use HasFactory, Notifiable, HasApiTokens;
    protected $table='driver';
    protected $primaryKey='driver_id';
    protected $keyType = 'int';
    public $incrementing =true;
    /**
    *@var list<string>
    */
    protected $fillable = [
        'driver_name',
        'driver_phone',
        'driver_district',
        'driver_mail',
        'driver_password',
        'driver_vehno',
        'driver_sector',
        'driver_capacity',
        'driver_license',
        'driver_status',
    ];
    protected $hidden = [
        'driver_password',
        'remember_token',
    ] ;

     public function username()
    {
        return 'driver_mail';
    }

    public function getAuthPassword()
    {
        return $this->driver_password;
    }
    public function facilities(){

    return $this->hasMany(Facility::class, 'driver_id', 'driver_id');
    }
    public function bookings()
{
    return $this->hasMany(Booking::class, 'driver_id', 'driver_id');
}

   
}