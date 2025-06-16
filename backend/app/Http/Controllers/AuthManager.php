<?php

namespace App\Http\Controllers;

use App\Models\Admin;
use App\Models\ambulanceDriver;
use App\Models\Facility;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;         // ← add this

class AuthManager extends Controller
{
    /** POST /api/auth/userregister */
    public function userregister(Request $request)
    {
        $validate = Validator::make($request->all(), [
            'user_name' => 'required|string|max:255',
            'user_mail' => 'required|email|unique:user,user_mail',
            'user_password' => 'required|string|min:8',
            'user_phone' => 'required',
            'regex:/^[0-9]{10}$/',
            'user_district' => 'required|string|max:255',
        ]);

        if ($validate->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => $validate->errors()->getMessages(),
            ], 422);
        }

        $data = $validate->validated();

        $user = User::create([
            'user_name' => $data['user_name'],
            'user_mail' => $data['user_mail'],
            'user_password' => Hash::make($data['user_password']),
            'user_phone' => $data['user_phone'],
            'user_district' => $data['user_district'],
        ]);

        // if you’re using Sanctum
        $token = $user->createToken('mobile_token')->plainTextToken;

        return response()->json([
            'status' => 'success',
            'data' => ['user' => $user, 'token' => $token],
            'message' => 'Registered successfully',
        ], 201);
    }



    public function driverregister(Request $request)
    {
        $validate = Validator::make(
            $request->all(),
            [
                'name' => 'required',
                'phone_no' => ['required', 'regex:/^[0-9]{10}$/', 'unique:driver,driver_phone',],
                'password' => ['required',],
                'email' => ['required', 'email', 'unique:driver,driver_mail'],
                'district' => ['required',],
                'vehicle_no' => ['required', 'regex:/^[A-Z]{2}[0-9]{2}[A-Z]{1,2}[0-9]{4}$/',],
                'capacity' => 'required',
                'sector' => ['required',],
                'facilities' => 'required|array',
                'facilities.*' => ['required',],
                'license'=>'required|image|mimes:jpg,jpeg,png|max:5120'
            ]
        );
        if ($validate->fails()) {
            return response()->json(["status" => "error", "message" => $validate->errors()->getMessages()], status: 200);
        }
        $data = $validate->validated();
        $licensePath = $request->file('license')->store('licenses', 'public');

        $driver = Driver::create([
            'driver_name' => $data['name'],
            'driver_mail' => $data['email'],
            'driver_password' => Hash::make($data['password']),
            'driver_phone' => $data['phone_no'],
            'driver_district' => $data['district'],
            'driver_vehno' => $data['vehicle_no'],
            'driver_status' => 'unavailable',
            'driver_capacity' => $data['capacity'],
            'driver_license' => $licensePath,
        ]);
        foreach ($data['facilities'] as $facility) {
            Facility::create([
                'driver_id' => $driver->driver_id,
                'facility' => $facility,
            ]);
        }
        $token = $driver->createToken('mobile_token')->plainTextToken;

        return response()->json([
            'status' => 'success',
            'data' => ['user' => $driver, 'token' => $token],
            'message' => 'Registered successfully',
        ], 201);
    }
    /** POST /api/auth/login */





    public function adminregister(Request $request)
    {
        $validate = Validator::make($request->all(), [

            'admin_mail' => 'required|email|unique:admin,admin_mail',
            'admin_password' => 'required|string|min:8',

        ]);
        if ($validate->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => $validate->errors()->getMessages(),
            ], 422);
        }

        $data = $validate->validated();


        $admin = Admin::create([

            'admin_mail' => $data['admin_mail'],
            'admin_password' => Hash::make($data['admin_password']),

        ]);

        // if you’re using Sanctum
        $token = $admin->createToken('mobile_token')->plainTextToken;

        return response()->json([
            'status' => 'success',
            'data' => ['user' => $admin, 'token' => $token],
            'message' => 'Registered successfully',
        ], 201);
    }










    /** POST /api/auth/login */
    public function login(Request $request)
    {

        // dd(get_class(Auth::guard('admin')));

        $request->validate([
            'email' => 'required|email',
            'password' => 'required|string',
        ]);

        $email = $request->email;
        $password = $request->password;

        $map = [
            'admin' => 'admin_mail',   // try admin first (optional order)
            'driver' => 'driver_mail',
            'user' => 'user_mail',
        ];

        foreach ($map as $guard => $column) {
            $ok = Auth::guard($guard)->attempt([
                $column => $email,
                'password' => $password,      // IMPORTANT: key must be literally "password"
            ]);

            if ($ok) {
                $user = Auth::guard($guard)->user();
                //   dd($user);
                $token = $user->createToken("{$guard}_token", [$guard])->plainTextToken;

                return response()->json([
                    'status' => 'success',
                    'role' => $guard,
                    'data' => ['user' => $user, 'token' => $token],
                    'message' => 'Logged in successfully',
                ]);
            }
        }
        return response()->json([
            'status' => 'error',
            'message' => 'Invalid credentials',
        ], 401);




    }


}
