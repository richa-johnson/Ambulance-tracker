<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class DriverController extends Controller
{
    public function updateLocation(Request $request)
    {
        $request->validate([
            'latitude'  => 'required|numeric|between:-90,90',
            'longitude' => 'required|numeric|between:-180,180',
        ]);

        /** @var \App\Models\ambulanceDriver $driver */
        $driver = $request->user();        // current logged‑in driver

        $driver->driver_location = $request->latitude . ',' . $request->longitude;
        $driver->save();                   // updates that SAME row

        return response()->json(['status' => 'updated']);
    }
}
