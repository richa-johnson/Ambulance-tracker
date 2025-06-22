<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('user', function (Blueprint $table) {
            $table->id('user_id')->primary()->autoIncrement();
            $table->string('user_name')->nullable(false);
            $table->string('user_password')->nullable(false);
            $table->string('user_mail', 100)->nullable(false);
            $table->string('user_phone', 10)->nullable(false);
            $table->string('user_district')->nullable(false);
            $table->timestamps();
        });

        Schema::create('driver', function (Blueprint $table) {
            $table->id('driver_id')->primary()->autoIncrement();
            $table->string('driver_name')->nullable(false);
            $table->string('driver_mail', 100)->nullable(false);
            $table->string('driver_password')->nullable(false);
            $table->string('driver_phone', 10)->nullable(false);
            $table->string('driver_district')->nullable(false);
            $table->string('driver_vehno')->nullable(false);
            $table->string('driver_sector')->nullable(false);
            $table->string('driver_capacity')->nullable(false);
            $table->string('driver_license')->nullable(false);
            $table->string('driver_location')->nullable(true);
            $table->string('driver_status')->nullable(false);
            $table->timestamps();

        });
        Schema::create('admin', function (Blueprint $table) {
            $table->id('admin_id')->primary()->autoIncrement();
  
            $table->string('admin_password')->nullable(false);
            $table->string('admin_mail', 100)->nullable(false);
            
            $table->timestamps();
        });

        Schema::create('facility', function (Blueprint $table) {
            $table->unsignedBigInteger('driver_id')->nullable(false);
            $table->string('facility')->nullable(false);

            $table->foreign('driver_id')->references('driver_id')->on('driver')->onDelete('cascade');

            $table->primary(['driver_id', 'facility']);
            $table->timestamps();
        });

        Schema::create('booking', function (Blueprint $table) {
            $table->id('book_id')->primary()->autoIncrement();
            $table->unsignedBigInteger('driver_id')->nullable(false);
            $table->unsignedBigInteger('user_id')->nullable(false);
            $table->string('p_location')->nullable(false);
            $table->integer('p_count')->nullable(false);
            $table->enum('b_status', ['pending', 'confirmed', 'cancelled', 'expired'])->default('pending');

            $table->timestamp('created_at')->nullable(false);
            $table->timestamp('end_time')->nullable(true);


            $table->foreign('driver_id')->references('driver_id')->on('driver')->onDelete('cascade');
            $table->foreign('user_id')->references('user_id')->on('user')->onDelete('cascade');

        });

        Schema::create('patient', function (Blueprint $table) {
            $table->id('patient_id')->primary()->autoIncrement();
            $table->unsignedBigInteger('book_id')->nullable(false);

            $table->string('p_name')->nullable(true);
            $table->string('p_blood')->nullable(true);
            $table->integer('p_age')->nullable(true);

            $table->timestamps();

            $table->foreign('book_id')->references('book_id')->on('booking')->onDelete('cascade');

        });


    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('user');
        Schema::dropIfExists('driver');
        Schema::dropIfExists('facility');
        Schema::dropIfExists('booking');
        Schema::dropIfExists('patient');
    }
};
