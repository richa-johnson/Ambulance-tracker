<?php

use App\Http\Controllers\AuthManager;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;


Route::post('/auth/userregister',[AuthManager::class,'userregister']);

Route::post('/auth/login', [AuthManager::class, "login"]);
    