<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\ambulanceDriver;

class DriverController extends Controller
{
    public function updateLocation(Request $request)
    {
        $request->validate([
            'latitude'  => 'required|numeric|between:-90,90',
            'longitude' => 'required|numeric|between:-180,180',
        ]);

        /** @var \App\Models\ambulanceDriver $driver */
        $driver = $request->user();       

        $driver->driver_location = $request->latitude . ',' . $request->longitude;
        $driver->save();                 

        return response()->json(['status' => 'updated']);
    }

    public function getDriverLocation($query)
{
    $driver = ambulanceDriver::where('driver_id', $query)
        ->orWhere('driver_name', 'LIKE', "%$query%")
        ->first();

    if (!$driver || !$driver->driver_location) {
        return response()->json(['error' => 'Driver not found'], 404);
    }

    $parts = explode(',', $driver->driver_location);
    if (count($parts) !== 2) {
        return response()->json(['error' => 'Invalid location format'], 400);
    }

    return response()->json([
        'driver_id' => $driver->driver_id,
        'driver_name' => $driver->driver_name,
        'latitude' => (float) $parts[0],
        'longitude' => (float) $parts[1],
    ]);
}



    public function getAvailabledrivers() {
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
            'status'=>$driver->driver_status,
            'location' => $driver->driver_location,
        ];
    });

    return response()->json($data);
    }
}
