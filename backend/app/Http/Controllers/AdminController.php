<?php

namespace App\Http\Controllers;

use App\Models\User;
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
    public function getAlldriver() {
        $users = ambulanceDriver::all([
            'driver_id as slno',
            'driver_name as name',
            'driver_phone as phoneno',
            'driver_mail as emailid',
            'driver_district as district',
            'driver_vehno as vehicleno',
            'driver_capacity as capacity',
            'driver_sector as sector',
        ]);

        return response()->json($users);
    }
}
