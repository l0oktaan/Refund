<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateRefundDetailsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('13_refund_details', function (Blueprint $table) {
            $table->increments('id');
            $table->integer('refund_form_id')->unsigned()->index();
            $table->foreign('refund_form_id')->references('id')->on('12_refund_forms')->onDelete('cascade');
            $table->integer('condition_id')->unsigned()->index();
            $table->foreign('condition_id')->references('id')->on('11_form_conditions')->onDelete('cascade');
            $table->string('value')->nullable();
            $table->tinyInteger('status')->nullable();
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
        Schema::dropIfExists('13_refund_details');
    }
}
