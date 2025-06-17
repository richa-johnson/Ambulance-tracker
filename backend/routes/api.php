<?php

use App\Http\Controllers\AuthManager;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AdminController;
use App\Http\Controllers\DriverController;
use App\Http\Controllers\UserController;

Route::post('/auth/userregister',[AuthManager::class,'userregister']);
Route::post('/auth/adminregister',[AuthManager::class,'adminregister']);

Route::post('/auth/login', [AuthManager::class, "login"]);
    
Route::post('/auth/driverregister',[AuthManager::class,'driverregister']);

Route::middleware('auth:sanctum')->group(function () {

    // // Admin-only routes
    // Route::middleware('ability:admin')->group(function () {
    //     Route::get('/admin/dashboard', [AdminController::class, 'dashboard']);
    // });

    // // Driver-only routes
    // Route::middleware('ability:driver')->group(function () {
    //     Route::get('/driver/requests', [DriverController::class, 'requests']);
    // });

    // // User-only routes
    // Route::middleware('ability:user')->group(function () {
    //     Route::get('/user/profile', [UserController::class, 'profile']);
    // });

    Route::post('/auth/logout',[AuthManager::class,'logout']);
    Route::get('/auth/user',[AuthManager::class,'user']);
  
});

Route::middleware(['auth:sanctum','ability:admin'])->get('/admin/users',[AdminController::class,'getAllUsers']);
 

