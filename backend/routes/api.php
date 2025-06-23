<?php

use App\Http\Controllers\AuthManager;
use App\Http\Controllers\BookingController;
use App\Http\Controllers\DriverProfileController;
use App\Http\Controllers\ProfileController;
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
Route::get('/booking/activity-history', [BookingController::class, 'allActivityHistory']);

Route::middleware('auth:sanctum')->group(function () {

    Route::post('/auth/logout',[AuthManager::class,'logout']);
    Route::get('/auth/user',[AuthManager::class,'user']);
    Route::put('/driver/status',[DriverStatus::class,'updateDriverStatus']);
});
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/booking/store',[BookingController::class,'store']);
    Route::get('/booking/{booking}/response',[BookingController::class,'respond']);
    Route::get('/user/confirmed-booking', [BookingController::class, 'getConfirmedBooking']);
    Route::get('/driver/confirmed-booking', [BookingController::class, 'getDriverConfirmedBooking']);
    Route::post('/booking/{bookingId}/patients', [BookingController::class, 'storePatients']);
    Route::get('/booking/check-expiry', [BookingController::class, 'expireIfStillPending']);
    Route::get('/booking/{booking}/status', [BookingController::class, 'getBookingStatus']);
    Route::post('/booking/{id}/confirm', [BookingController::class, 'confirm']);
    Route::post('/booking/{id}/cancel', [BookingController::class, 'cancel']);
    Route::post('/booking/{id}/complete', [BookingController::class, 'complete']);
});



Route::middleware(['auth:sanctum'])->get('/admin/users',[AdminController::class,'getAllUsers']);
Route::get('/user/availableAmbulances',[DriverController::class,'getAvailabledrivers']);
Route::middleware(['auth:sanctum'])->get('/admin/drivers',[AdminController::class,'getAlldrivers']);

Route::middleware('auth:sanctum')         
      ->post('/driver/location', [DriverController::class, 'updateLocation']);
Route::get('/admin/trackAmbulance/driver/{query}',[DriverController::class, 'getDriverLocation']);

Route::middleware(['auth:sanctum'])->post('/bookings/{booking}/patients', [BookingController::class, 'storePatients']);
Route::middleware('auth:sanctum')->get('/user/UserDetails', [DriverController::class, 'getSignedInUserDetails']);

Route::middleware('auth:sanctum')->get('/driver/pending-bookings', [BookingController::class, 'pending']);


Route::middleware('auth:sanctum')->get('/booking/driver-history', [BookingController::class, 'getdriverHistory']);

Route::middleware('auth:sanctum')->get('/booking/user-history', [BookingController::class, 'getUserHistory']);

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/profile',  [ProfileController::class, 'show']);   // GET current data
    Route::put('/profile',  [ProfileController::class, 'update']); // PUT/PATCH update
});
Route::middleware('auth:sanctum')->get('/driver/status', [DriverController::class, 'status']);
Route::middleware('auth:sanctum')->group(function () {
    Route::get ('/driver/profile',  [DriverProfileController::class, 'show']);
    Route::put ('/driver/profile',  [DriverProfileController::class, 'update']);
});
