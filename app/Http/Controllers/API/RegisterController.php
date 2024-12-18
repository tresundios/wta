<?php
namespace App\Http\Controllers\API;

use Illuminate\Http\Request;
use App\Http\Controllers\API\BaseController as BaseController;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Validator;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class RegisterController extends BaseController
{
    /**
     * Register api
     *
     * @return \Illuminate\Http\Response
     */

     public function register(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required',
            'username' => 'required|unique:users,username',
            'email' => 'required|email|unique:users,email',
            'password' => 'required',
            'c_password' => 'required|same:password',
            'gender' => 'required|in:male,female,other',
            'status' => 'required|boolean',
            'role' => 'required|in:admin,moderator,member',
        ]);

        if ($validator->fails()) {
            return $this->sendError('Validation Error.', $validator->errors());
        }

        $input = $request->only(['name', 'username', 'email', 'password', 'gender', 'status']);
        $input['password'] = bcrypt($input['password']);

        // Create the user
        $user = User::create($input);

        // Fetch the role ID dynamically based on the role provided in the request
        $roleId = DB::table('roles')->where('name', $request->role)->value('id');

        if (!$roleId) {
            return $this->sendError('Invalid role specified.', []);
        }

        // Assign role to the user
        DB::table('user_roles')->insert([
            'user_id' => $user->id,
            'role_id' => $roleId,
        ]);

        // Assign additional roles for moderators if applicable
        if ($request->role === 'moderator') {
            $memberRoleId = DB::table('roles')->where('name', 'member')->value('id');
            if ($memberRoleId) {
                DB::table('user_roles')->insert([
                    'user_id' => $user->id,
                    'role_id' => $memberRoleId,
                ]);
            }
        }

        $success['token'] = $user->createToken('MyApp')->plainTextToken;
        $success['name'] = $user->name;

        return $this->sendResponse($success, 'User registered successfully.');
    }



    /**
     * Login api
     *
     * @return \Illuminate\Http\Response
     */
    public function login(Request $request): JsonResponse

    {
        if(Auth::attempt(['email' => $request->email, 'password' => $request->password])){
            $user = Auth::user();
            $success['token'] =  $user->createToken('MyApp')->plainTextToken;
            $success['name'] =  $user->name;
            return $this->sendResponse($success, 'User login successfully.');
        }
        else{
            return $this->sendError('Unauthorised.', ['error'=>'Unauthorised']);
        }
    }

    public function logout(Request $request): JsonResponse
    {
        //return $this->sendResponse([], 'Arrived to logout');

        $request->user()->tokens()->delete();

        return response()->json(['message' => 'Logged out successfully']);

    }
}
