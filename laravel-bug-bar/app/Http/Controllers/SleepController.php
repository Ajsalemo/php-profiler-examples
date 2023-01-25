<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class SleepController extends Controller
{
    public function sleepController() {
        sleep(5);
        return view('welcome');
    }
}
