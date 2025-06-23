<?php

namespace App\Http\Controllers;
use Illuminate\Validation\Rule;
use Illuminate\Support\Facades\Validator;
use App\Models\Facility;
use Illuminate\Http\Request;

class DriverProfileController extends Controller
{
     public function show(Request $request)
    {
        // eager-load facilities so Flutter gets the list
        return $request->user()->load('facilities:driver_id,facility');
    }

  public function update(Request $request)
    {
        $driver = $request->user();   // Sanctum token → Driver model

        $v = Validator::make($request->all(), [
            'name'       => 'required|string|max:255',
            'phone'      => [
                'required','regex:/^[0-9]{10}$/',
                Rule::unique('driver','driver_phone')
                    ->ignore($driver->driver_id,'driver_id'),
            ],
            'district'   => 'required|string',
            'vehno'      => ['required','regex:/^[A-Z]{2}[0-9]{2}[A-Z]{1,2}[0-9]{4}$/'],
            'capacity'   => 'required|string',
            'sector'     => 'required|string',
            'facilities' => 'required|array',
            'facilities.*' => 'required|string',
        ]);

        if ($v->fails()) {
            return response()->json([
                'status'  => 'error',
                'message' => $v->errors()->getMessages()
            ], 422);
        }

        $data = $v->validated();

        // ── update driver core columns ──
        $driver->update([
            'driver_name'     => $data['name'],
            'driver_phone'    => $data['phone'],
            'driver_district' => $data['district'],
            'driver_vehno'    => $data['vehno'],
            'driver_sector'   => $data['sector'],
            'driver_capacity' => $data['capacity'],
        ]);

        // ── sync facilities (delete-insert) ──
        Facility::where('driver_id', $driver->driver_id)->delete();
        foreach ($data['facilities'] as $f) {
            Facility::create(['driver_id' => $driver->driver_id, 'facility' => $f]);
        }

        return response()->json([
            'status'  => 'success',
            'message' => 'Profile updated',
            'driver'  => $driver->load('facilities:driver_id,facility')
        ]);
    }

}
