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
}
