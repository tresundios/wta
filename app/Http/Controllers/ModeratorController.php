<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ModeratorController extends Controller
{
    public function ModeratorDashboard() {
        return view('moderator.index');
    }

    public function ModeratorLogout(Request $request)
    {
        Auth::guard('web')->logout();

        $request->session()->invalidate();

        $request->session()->regenerateToken();

        return redirect('/moderator/login');
    }

    public function ModeratorLogin() {
        return view('moderator.moderator_login');
    }
}
