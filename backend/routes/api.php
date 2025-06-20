<?php

use App\Http\Controllers\AuthManager;
use App\Http\Controllers\BookingController;
use App\Models\Booking;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AdminController;
use App\Http\Controllers\DriverController;
use App\Http\Controllers\userManager;
use App\Http\Controllers\DriverStatus;

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
    Route::put('/driver/status',[DriverStatus::class,'updateDriverStatus']);
});

Route::middleware(['auth:sanctum'])->get('/admin/users',[AdminController::class,'getAllUsers']);
Route::get('/user/availableAmbulances',[DriverController::class,'getAvailabledrivers']);
Route::middleware(['auth:sanctum'])->get('/admin/drivers',[AdminController::class,'getAlldrivers']);

Route::middleware('auth:sanctum')         
      ->post('/driver/location', [DriverController::class, 'updateLocation']);

Route::middleware(['auth:sanctum'])->post('/booking/store',[BookingController::class,'store']);
Route::middleware(['auth:sanctum'])->get('/booking/{booking}/response',[BookingController::class,'respond']);
Route::middleware(['auth:sanctum'])->get('/booking/expire',[BookingController::class,'expireOldBookings']);
Route::middleware(['auth:sanctum'])->post('/bookings/{booking}/patients', [BookingController::class, 'storePatients']);
Route::middleware('auth:sanctum')->get('/user/UserDetails', [DriverController::class, 'getSignedInUserDetails']);
