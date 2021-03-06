<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateDepositPenaltiesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('7_deposit_penalties', function (Blueprint $table) {
            $table->increments('id');
            $table->integer('refund_id')->unsigned()->index();
            $table->foreign('refund_id')->references('id')->on('2_refunds')->onDelete('cascade');
            $table->string('deposit_no');
            $table->date('deposit_date');
            $table->double('amount');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('deposit_penalties');
    }
}
