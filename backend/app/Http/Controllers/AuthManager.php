<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;            // ← add this

class AuthManager extends Controller
{
    /** POST /api/auth/userregister */
    public function userregister(Request $request)
    {
        $validate = Validator::make($request->all(), [
            'user_name'     => 'required|string|max:255',
            'user_mail'    => 'required|email|unique:user,user_mail',
            'user_password' => 'required|string|min:8',
            'user_phone'=>'required','regex:/^[0-9]{10}$/',
            'user_district'=>'required|string|max:255',
        ]);

        if ($validate->fails()) {
            return response()->json([
                'status'  => 'error',
                'message' => $validate->errors()->getMessages(),
            ], 422);
        }

        $data = $validate->validated();

        $user = User::create([
            'user_name'     => $data['user_name'],
            'user_mail'    => $data['user_mail'],
            'user_password' => Hash::make($data['user_password']),
            'user_phone'=>$data['user_phone'],
            'user_district'=>$data['user_district'],
        ]);

        // if you’re using Sanctum
        $token = $user->createToken('mobile_token')->plainTextToken;

        return response()->json([
            'status'  => 'success',
            'data'    => ['user' => $user, 'token' => $token],
            'message' => 'Registered successfully',
        ], 201);
    }

    /** POST /api/auth/login */
    public function login(Request $request)
    {
        $validate = Validator::make($request->all(), [
            'user_mail'    => 'required|email|exists:user,user_mail',
            'user_password' => 'required|string',
        ]);

        if ($validate->fails()) {
            return response()->json([
                'status'  => 'error',
                'message' => $validate->errors()->getMessages(),
            ], 422);
        }

         $credentials = [
        'user_mail' => $request->user_mail,
        'password'  => $request->user_password,  // ⚠️ must be 'password'
    ];

        if (!Auth::attempt($credentials)) {
            return response()->json([
                'status'  => 'error',
                'message' => 'Invalid credentials',
            ], 401);
        }

        $user  = Auth::user();
        $token = $user->createToken('mobile_token')->plainTextToken;

        return response()->json([
            'status'  => 'success',
            'data'    => ['user' => $user, 'token' => $token],
            'message' => 'Logged in successfully',
        ], 200);
    }

    public function driverregister(Request $request)
    {
        // TODO: implement
    }
}
