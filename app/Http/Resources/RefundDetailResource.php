<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\Resource;

class RefundDetailResource extends Resource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array
     */
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'refund_form_id' => $this->refund_form_id,
            'condition_id' => $this->condition_id,
            'value' => $this->value,
            'status' => $this->status
        ];
    }
}