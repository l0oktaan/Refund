<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Form extends Model
{
    protected $table = "9_forms";
    protected $fillable = [
        'id',
        'name1',
        'name2',
        'name3',
        'order',
        'create_by',
        'status'
    ];

    public function form_rules(){
        return $this->hasMany(
            'App\FormRule','form_id','id')
            ->where('sub_of','=',0);

    }
    public function refund_forms(){
        return $this->hasMany('App\RefundForm');
    }
    public function form_conditions(){
        return $this->hasManyThrough(
            'App\FormCondition',
            'App\FormRule',
            'form_id',
            'form_rule_id'
        );
    }
    public function form_considers(){
        return $this->hasManyThrough(
            'App\Consider',
            'App\FormRule',
            'form_id',
            'form_rule_id'
        );
    }
}

