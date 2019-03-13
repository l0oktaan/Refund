<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class ContractBudgetEditRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    /* public function authorize()
    {
        return false;
    } */

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'order' => 'required',
            'budget_new' => 'required',
            'penalty_new' => 'required',
            'contract_edit_date' => 'required'
        ];
    }
}
