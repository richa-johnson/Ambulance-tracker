<?php

namespace App\Http\Controllers;
use App\Models\Booking;
use App\Models\ambulanceDriver;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class BookingController extends Controller
{
    public $timestamps = false;


    public function store(Request $r)
    { 
        \Log::info('🏁 before Booking::create');
        $booking = Booking::create([
            'driver_id' => $r->driver_id,
            'user_id' => auth()->id(),
            'p_location' => $r->p_location,
            'p_count' => $r->p_count,
            'b_status' => 'pending',
            'created_at' => now(), 
        ]);


        return response()->json(['booking_id' => $booking->book_id], 201);
    }
    

    public function pending(Request $request)
    {
        $driverId = auth()->id();

        \Log::info("Driver ID: {$driverId}");
        $bookings = Booking::with('user:user_id,user_name as name,user_phone as phone')
            ->where('driver_id', $driverId)    // integer, not object
            ->where('b_status', 'pending')       // use the real column name
            ->orderByDesc('created_at')
            ->get();

        \Log::info('pending() rows found: ' . $bookings->count());
        return response()->json($bookings);
    }
    public function allActivityHistory()
{
    \Log::info('🟡 Fetching bookings...');
    $bookings = Booking::with(['user', 'driver', 'patients'])->get();
    \Log::info('✅ Bookings fetched: ' . $bookings->count());

    $result = $bookings->map(function ($booking, $index) {
        \Log::info("🔍 Mapping booking ID: {$booking->book_id}");

        return [
            'slno' => $index + 1,
            'uname' => optional($booking->user)->user_name ?? 'N/A',
            'uphoneno' => optional($booking->user)->user_phone ?? 'N/A',
            'dname' => optional($booking->driver)->driver_name ?? 'N/A',
            'dphoneno' => optional($booking->driver)->driver_phone ?? 'N/A',
            'vehicleno' => optional($booking->driver)->driver_vehno ?? 'N/A',
            'pcount' => $booking->p_count ?? 0,
            'location' => $booking->p_location ?? 'N/A',
            'timestamp' => $booking->created_at ?? now(),
        ];
    });

    \Log::info('✅ Mapping completed.');

    return response()->json($result);
}



    public function confirm($id)
    {

          $driver = Auth::user()->driver;
          
        $booking = Booking::where('driver_id', auth()->id())
            ->findOrFail($id);        // uses book_id under the hood


        $booking->b_status = 'confirmed';
        $booking->save();


        Booking::where('driver_id', auth()->id())
            ->where('b_status', 'pending')
            ->where('book_id', '!=', $id)
            ->update(['b_status' => 'cancelled']);

        ambulanceDriver::where('driver_id', auth()->id())
            ->update(['driver_status' => 'busy']);

        Log::info('Booking confirmed', ['id' => $id]);

        return response()->json(['message' => 'Booking confirmed']);
    }

    public function cancel($id)
    {
        $driver = ambulanceDriver::find(Auth::id());

        $booking = Booking::where('driver_id', $driver->driver_id)
            ->where('b_status', 'pending')
            ->where('book_id', $id)        // real PK
            ->firstOrFail();

        $booking->b_status = 'cancelled';   // ← explicit
        $booking->save();                   // ← forces SQL UPDATE

        Log::info('Booking cancelled', ['id' => $id]);

        return response()->json(['message' => 'Booking cancelled']);
    }
    public function expireIfStillPending(Request $request)
{
    $userId = auth()->id();

    $booking = Booking::where('user_id', $userId)
        ->where('b_status', 'pending')
        ->where('created_at', '<', now()->subMinutes(2))
        ->latest('created_at')
        ->first();

    if ($booking) {
        $booking->b_status = 'expired';
        $booking->save();

        return response()->json([
            'message' => 'Booking expired successfully.',
            'booking_id' => $booking->book_id,
            'driver_id' => $booking->driver_id,
            'b_status' => 'expired',
        ]);
    }

    return response()->json([
        'message' => 'No expired bookings',
        'b_status' => 'active', 
    ]);
}

public function getBookingStatus(Request $request, $bookingId)
{
    $booking = Booking::find($bookingId);

    if (!$booking || $booking->user_id !== auth()->id()) {
        return response()->json(['message' => 'Booking not found'], 404);
    }

    return response()->json([
        'status' => $booking->b_status,
        'driver_id' => $booking->driver_id,
        'booking_id' => $booking->book_id,
    ]);
}



    public function complete($id)
    {
        // Only the booking that’s currently confirmed for this driver
        $booking = Booking::where('driver_id', auth()->id())
            ->where('b_status', 'confirmed')
            ->findOrFail($id);

        // 1) Mark booking done
        $booking->b_status = 'completed';
        $booking->save();

        // 2) Free the driver
        ambulanceDriver::where('id', auth()->id())
            ->update(['driver_status' => 'available']);

        Log::info('Ride completed', ['id' => $id]);

        return response()->json(['message' => 'Ride completed']);
    }

    public function storePatients(Request $request, $id)
{
    if (!$request->has('patients') || !is_array($request->patients)) {
        return response()->json(['message' => 'No patient data sent'], 200);
    }

    foreach ($request->patients as $patient) {
        \App\Models\Patient::create([
            'book_id' => $id,
            'p_name' => $patient['p_name'] ?? null,
            'p_blood' => $patient['p_blood'] ?? null,
            'p_age' => $patient['p_age'] ?? null,
        ]);
    }

    return response()->json(['message' => 'Patient data stored'], 204);
}
    public function getdriverHistory(Request $request)
{
    $driver = Auth::user(); // Gets the authenticated driver
    $driverId = $driver->driver_id;

    $bookings = Booking::with(['user']) // eager load user info
        ->where('driver_id', $driverId)
        ->get()
        ->map(function ($booking) {
            return [
                'uname'     => $booking->user->user_name,
                'phoneno'   => $booking->user->user_phone,
                'pcount'    => $booking->p_count,
                'location'  => $booking->p_location,
                'timestamp' => $booking->created_at,
            ];
        });

    return response()->json($bookings);
}
    public function getUserHistory(Request $request)
{
    $userId = auth()->id(); // Get authenticated user_id

    $bookings = Booking::with('driver') // eager load driver info
        ->where('user_id', $userId)
        ->orderByDesc('created_at') // sort latest first
        ->get()
        ->map(function ($booking) {
            return [
                'dname'     => optional($booking->driver)->driver_name ?? 'N/A',
                'phoneno'   => optional($booking->driver)->driver_phone ?? 'N/A',
                'vehicleNo' => optional($booking->driver)->driver_vehno ?? 'N/A',
                'location'  => $booking->p_location ?? 'N/A',
                'timestamp' => $booking->created_at,
            ];
        });

    return response()->json($bookings);
}


    public function driverStatus()
    {
        $status = ambulanceDriver::findOrFail(auth()->id())->driver_status;

        return response()->json(['status' => $status]);
    }


}