<?php

namespace App;
use Refund;
use Illuminate\Database\Eloquent\Model;

class DepositPenalty extends Model
{
    protected $table = "7_deposit_penalties";
    protected $fillable = [
        'id',
        'refund_id',
        'order',
        'no',
        'date',
        'amount'
    ];

    public function refund(){
        return $this->belongsTo(Refund::class);
    }
}
