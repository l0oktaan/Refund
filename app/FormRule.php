<?php

namespace App;
use FormCondition;
use Illuminate\Database\Eloquent\Model;

class FormRule extends Model
{
    protected $table = "10_form_rules";
    protected $fillable = [
        'id',
        'form_id',
        'order',
        'name',
        'sub_of',
        'rule_type',
        'result_type',
        'status'
    ];

    public function form(){
        return $this->belongsTo('App\Form');
    }

    public function form_conditions(){
        return $this->hasMany('App\FormCondition','form_rule_id','id');
    }

    public function considers(){
        return $this->hasMany('App\Consider','form_rule_id','id');
    }

    public function sub_rules(){
        return $this->hasMany('App\FormRule','sub_of','id');
    }
}
