<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use PhpParser\Node\Expr\List_;

class Driver extends Authenticatable{
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
        'driver_status',
        'driver_capacity',
        'driver_license',
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

}