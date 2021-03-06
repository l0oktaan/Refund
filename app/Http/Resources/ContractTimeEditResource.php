<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class ContractTimeEditResource extends JsonResource
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
            'refund_id' => $this->refund_id,
            'approve_date' => $this->approve_date,
            'edit_type' => $this->edit_type,
            'edit_detail' => $this->edit_detail,
            'edit_days' => $this->edit_days,
            'edit_budget' => $this->edit_budget,
            'contract_end_date' => $this->contract_end_date,
            'approve_type' => $this->approve_type,
            'approve_case' => $this->approve_case,
            'problem_end_date' => $this->problem_end_date,
            'book_date' => $this->book_date,
        ];
    }
}
