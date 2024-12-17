<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
{
    Schema::create('event_enrollments', function (Blueprint $table) {
        $table->id(); // Auto-increment primary key
        $table->unsignedBigInteger('event_id'); // Foreign key for events
        $table->unsignedBigInteger('enrolled_by')->nullable(); // Foreign key for users (enrolled_by)

        $table->timestamps();

        // Foreign key constraints
        $table->foreign('event_id')->references('id')->on('events')->onDelete('cascade');
        $table->foreign('enrolled_by')->references('id')->on('users')->onDelete('set null');
    });
}


    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('event_enrollments');
    }
};
