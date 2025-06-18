<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Validator;

class userManager extends Controller
{
    function patientRegister(Request $request){
        $validate=Validator::make($request->all(),[
            'no_patients'=>'required|integer',
            'patient_details'  => 'array',
            'p_location'  => 'required|string'
        ]);

        
        if ($validate->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => $validate->errors()->getMessages(),
            ], 422);
        }
        $data = $validate->validated();

    }

}
