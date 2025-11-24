<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class HealthController extends Controller
{
    //
    public function __invoke()
    {
        return response()->json([
        'status' => 'OK',
        'app' => config('app.name'),
        'time' => now()->toISOString(),
    ]);
    }
}
