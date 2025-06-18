<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use App\Models\ambulanceDriver;

class DriverStatus extends Controller
{
    public function updateDriverStatus(Request $request)
    {
        $user = Auth::user();

        if (!$user instanceof ambulanceDriver) {
            return response()->json([
            'status' => 'error',
            'message' => 'Unauthorized',
            ], 403);
        }

        $request->validate([
            'status' => 'required|in:available,unavailable',
        ]);

        $user->driver_status = $request->status;
        $user->save();

        return response()->json([
            'status' => 'success',
            'message' => 'Status updated successfully',
        ],200);
    }
}
