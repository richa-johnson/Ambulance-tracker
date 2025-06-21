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

    // POST /booking/{id}/cancel
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


    public function expireOldBookings()
    {
        $expired = Booking::where('status', 'pending')
            ->where('created_at', '<', now()->subMinutes(3))
            ->get();

        foreach ($expired as $booking) {
            $booking->status = 'expired';
            $booking->save();
            // You can also fire an event/notification here if needed
        }


        return response()->json(['expired_count' => count($expired)]);
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
        Driver::where('id', auth()->id())
            ->update(['driver_status' => 'available']);

        Log::info('Ride completed', ['id' => $id]);

        return response()->json(['message' => 'Ride completed']);
    }

    public function driverStatus()
    {
        $status = Driver::findOrFail(auth()->id())->driver_status;

        return response()->json(['status' => $status]);
    }


}
