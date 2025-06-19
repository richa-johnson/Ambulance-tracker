<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\ambulanceDriver;
use Illuminate\Http\Request;

class AdminController extends Controller
{
    public function getAllUsers() {
        $users = User::all([
            'user_id as slno',
            'user_name as name',
            'user_phone as phoneno',
            'user_mail as emailid',
            'user_district as district',
        ]);

        return response()->json($users);
    }
    public function getAlldrivers() {
    $drivers = ambulanceDriver::with('facilities')->get()
        ->makeHidden(['driver_password', 'remember_token']);

    $data = $drivers->map(function ($driver) {
        return [
            'slno' => $driver->driver_id,
            'name' => $driver->driver_name,
            'phoneno' => $driver->driver_phone,
            'emailid' => $driver->driver_mail,
            'district' => $driver->driver_district,
            'vehicleno' => $driver->driver_vehno,
            'sector' => $driver->driver_sector,
            'capacity' => $driver->driver_capacity,
            'license' => $driver->driver_license,
            'facilities' => $driver->facilities->pluck('facility')->toArray(),
        ];
    });

    return response()->json($data);
}

}
