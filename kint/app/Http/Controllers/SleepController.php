<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Kint\Kint;

class SleepController extends Controller
{
    public function sleepController() {
        sleep(5);
        return view('welcome');
    }
}
