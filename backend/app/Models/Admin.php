<?php

namespace App\Models;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class Admin extends Authenticatable
{

    use HasApiTokens, Notifiable;

    protected $table = 'admin';
    protected $primaryKey = 'admin_id';
    protected $keyType = 'int';
    protected $fillable = ['admin_mail', 'admin_password'];

    public function username()
    {
        return 'admin_mail';
    }

    public function getAuthPassword()
    {
        return $this->admin_password;
    }
}
