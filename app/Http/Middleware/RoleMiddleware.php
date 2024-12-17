<?php
// app/Http/Middleware/RoleMiddleware.php
namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class RoleMiddleware
{
    public function handle(Request $request, Closure $next, ...$roles)
    {
        if (!Auth::check()) {
            return redirect('/login'); // Redirect to login if not authenticated
        }
        // Check if the user role matches any of the provided roles
        /*
        if (in_array(Auth::user()->roles->pluck('name'), $roles)) {
            abort(403, 'Unauthorized'); // Return 403 if role does not match
        }
        */

        $user = Auth::user();

        // Check if user exists and has any of the roles passed
        if (!$user || !$user->roles->pluck('name')->intersect($roles)->count()) {
            // If the role is 'moderator', allow 'admin' to access too
            if (in_array('moderator', $roles) && $user->roles->pluck('name')->contains('admin')) {
                return $next($request);
            }

            abort(403, 'Unauthorized: You do not have the required role.');
        }



        return $next($request);
    }
}
