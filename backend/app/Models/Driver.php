<?php

namespace App\Models;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

use Illuminate\Database\Eloquent\Model;

use function PHPUnit\Framework\returnArgument;

class Driver extends Model
{
    //
    use HasApiTokens,Notifiable;

    protected $table='driver';
    protected $primaryKey='driver_id';
    protected $fillable=['driver_name','driver_mail','driver_password'];

    public function username(){
        return 'driver_mail';
    }

    public function getAuthPassword(){
        return $this->driver_password;
    }



}
