<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateFormConditionsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('11_form_conditions', function (Blueprint $table) {
            $table->increments('id');
            $table->integer('form_rule_id')->unsigned()->index();
            $table->foreign('form_rule_id')->references('id')->on('10_form_rules')->onDelete('cascade');
            //$table->integer('order');
            $table->string('name');
            $table->string('description')->nullable();
            $table->integer('condition_type');
            $table->tinyInteger('status');
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
        Schema::dropIfExists('11_form_conditions');
    }
}
