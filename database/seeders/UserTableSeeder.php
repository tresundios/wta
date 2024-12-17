<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;

class UserTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Fetch role IDs dynamically
        $adminRoleId = DB::table('roles')->where('name', 'admin')->value('id');
        $moderatorRoleId = DB::table('roles')->where('name', 'moderator')->value('id');
        $memberRoleId = DB::table('roles')->where('name', 'member')->value('id');

        // Insert users
        $users = [
            // Admin User
            [
                'name' => 'Admin',
                'username' => 'admin',
                'email' => 'admin@gmail.com',
                'password' => Hash::make('111'),
                'gender' => 'male',
                'status' => '1',
            ],
            // Moderator User
            [
                'name' => 'Moderator',
                'username' => 'moderator',
                'email' => 'moderator@gmail.com',
                'password' => Hash::make('111'),
                'gender' => 'male',
                'status' => '1',
            ],
            // Normal Member User
            [
                'name' => 'Member',
                'username' => 'member',
                'email' => 'member@gmail.com',
                'password' => Hash::make('111'),
                'gender' => 'male',
                'status' => '1',
            ],
        ];

        // Insert users and assign roles
        foreach ($users as $user) {
            // Insert the user into the `users` table
            $userId = DB::table('users')->insertGetId($user);

            // Assign roles in the `user_roles` pivot table
            if ($user['username'] === 'admin') {
                DB::table('user_roles')->insert([
                    'user_id' => $userId,
                    'role_id' => $adminRoleId,
                ]);
            } elseif ($user['username'] === 'moderator') {
                // Moderators can have both 'moderator' and 'member' roles
                DB::table('user_roles')->insert([
                    ['user_id' => $userId, 'role_id' => $moderatorRoleId],
                    ['user_id' => $userId, 'role_id' => $memberRoleId],
                ]);
            } else {
                // Normal member role
                DB::table('user_roles')->insert([
                    'user_id' => $userId,
                    'role_id' => $memberRoleId,
                ]);
            }
        }
    }
}
