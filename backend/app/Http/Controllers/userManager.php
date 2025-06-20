<?php

namespace App\Http\Controllers;
use Illuminate\Support\Facades\Auth;

use App\Models\User;
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
    public function getSignedInUserDetails()
{
    // Get the currently authenticated user
    $user = Auth::user();


    // Return the details you need
    return response()->json([
        'id'   => $user->user_id,
        'name'      => $user->user_name,
        'phone_no'  => $user->user_phone,
        'district'  => $user->user_district,
        'mail'  => $user->user_mail,
    ]);
}

}
