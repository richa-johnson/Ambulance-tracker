<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
class ProfileController extends Controller
{
    public function show(Request $request)
    {
        return $request->user();          // current user via token
    }


    public function update(Request $request)
    {
        $user = $request->user();

        
    $validated = $request->validate([
        'name'     => ['required','string','max:255'],
        'phone'    => [
            'required','string','max:15',
            Rule::unique('user', 'user_phone')->ignore($user->user_id, 'user_id'),   // ← real column
        ],
        'district' => ['required','string'],
    ]);
        $user->user_name = $validated['name'];
        $user->user_phone = $validated['phone'];
        $user->user_district = $validated['district'];
        $user->save();

        return response()->json(['message' => 'Profile updated', 'user' => $user]);
    }
}
