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

    function driverregister(Request $request){
        $validate= Validator::make($request->all(),
            [
                'name'=> 'required',
                'phone_no'=> ['required','regex:/^[0-9]{10}$/','unique:driver',],
                'email'=>['required','email','unique:driver'],
                'district'=>['required',Rule::in($alloweddistricts),],
                'vehicle no'=>['required','regex:/^[A-Z]{2}[0-9]{2}[A-Z]{1,2}[0-9]{4}$/',],
                'capacity'=>'required',
                'sector'=>['required',Rule::in($allowedsector),],
                'facilities'=>'required|array',
                'facilities.*'=>['required',Rule::in($alloedFacilities),],
                'license'=>'required|image|mimes:jpg,jpeg,png|max:5120'
            ]);
        if ($validate->fails()){
            return response()->json(["status"=>"error","message"=>$validate->errors()->getMessages()],status:200);
        }
    }
    /** POST /api/auth/login */
    public function login(Request $request)
    {
        $validate = Validator::make($request->all(), [
            'user_email'    => 'required|email|exists:user,user_email',
            'user_password' => 'required|string',
        ]);

        if ($validate->fails()) {
            return response()->json([
                'status'  => 'error',
                'message' => $validate->errors()->getMessages(),
            ], 422);
        }

        $credentials = $validate->validated();

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

    
}
