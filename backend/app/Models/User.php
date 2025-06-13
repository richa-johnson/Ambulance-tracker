<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory, Notifiable, HasApiTokens;
    protected $table = 'user';

    protected $primaryKey = 'user_id';    // example
    public $incrementing = true;       // or false if it isn't auto‑inc
    // or 'string'

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */

    protected $fillable = [
        'user_name',
        'user_mail',
        'user_password',
        'user_phone',
        'user_district',

    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     * 
     * 
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }

    public function username()
    {
        return 'user_mail';
    }

    public function getAuthPassword()   // tells Auth where hashed pwd lives
{
    return $this->user_password;
}

}
