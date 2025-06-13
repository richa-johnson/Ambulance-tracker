<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class AuthManager extends Controller
{
    function userregister(Request $request){

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

    function login  (Request $request){

    }
}
