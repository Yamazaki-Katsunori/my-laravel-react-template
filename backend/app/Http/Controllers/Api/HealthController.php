<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;

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
