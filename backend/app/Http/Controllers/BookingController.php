<?php

namespace App\Http\Controllers;
use App\Models\Booking;
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

        \Log::info('✅ after Booking::create');
        // Push a notification to the driver
        // Notification::send($booking->driver, new NewBookingAlert($booking));
        return response()->json(['booking_id' => $booking->book_id], 201);
    }

    public function storePatients(Request $r, Booking $booking)
    {
        $this->authorize('handle', $booking); // or use user check instead

        foreach ($r->patients as $p) {
            $booking->patients()->create([
                'name' => $p['name'] ?? null,
                'blood_group' => $p['blood'] ?? null,
                'age' => $p['age'] ?? null,
            ]);
        }

        return response()->noContent();
    }
    public function respond(Request $r, Booking $booking)
    {
        $this->authorize('handle', $booking);        // driver safety check

        $booking->status = $r->action === 'confirm' ? 'confirmed' : 'cancelled';
        $booking->save();

        broadcast(new BookingUpdated($booking))->toOthers();  // push update
        return response()->noContent();
    }


    public function expireOldBookings()
    {
        $expired = \App\Models\Booking::where('b_status', 'pending')
            ->where('created_at', '<', now()->subMinutes(3))
            ->get();

        foreach ($expired as $booking) {
            $booking->b_status = 'expired';
            $booking->save();
            // You can also fire an event/notification here if needed
        }

        return response()->json(['expired_count' => count($expired)]);
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
        'b_status' => 'active', // still pending or already confirmed
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


}
