<?php

namespace App\Http\Controllers;

use App\Office;
use App\Form;
use App\Refund;
use App\RefundForm;
use App\RefundDetail;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use App\Http\Resources\RefundFormResource;

class RefundFormController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Office $office, Refund $refund)
    {
        $refundForm = new RefundForm();

        $refundForm = $refund->refund_forms()->get();
        //return $refundForm;
        return RefundFormResource::collection($refundForm);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */

    public function store(Request $request,Office $office,Refund $refund)
    {
        // $refundForm = new RefundForm;
        // $refundForm->refund_id = $request->refund_id;
        // $refundForm->form_id = $request->form_id;
        // $refundForm->result = $request->result;
        // $refundForm->status = $request->status;
        // $refundForm->save();

        $refundForm = new RefundForm($request->all());
        $refund->refund_forms()->save($refundForm);

        //$this->createRefundDetail($refundForm);

        return response([
            'data' => new RefundFormResource($refundForm)
        ],Response::HTTP_CREATED);
        // $refund->approve_code = $request->approve_code;
        // $refund->create_date = date('Y-m-d');
        // $refund->status = "1";
        // $office->refunds()->save($refund);
        // return response([
        //     'data' => new RefundResource($refund)
        // ],Response::HTTP_CREATED);
    }
    private function createRefundDetail(RefundForm $refundForm)
    {
        $form = Form::find($refundForm->form_id);
        $considers = $form->considers();

    }
    /**
     * Display the specified resource.
     *
     * @param  \App\RefundForm  $refundForm
     * @return \Illuminate\Http\Response
     */
    public function show(Office $office, Refund $refund, RefundForm $refundForm)
    {
        return new RefundFormResource($refundForm);
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\RefundForm  $refundForm
     * @return \Illuminate\Http\Response
     */
    public function edit(RefundForm $refundForm)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\RefundForm  $refundForm
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, RefundForm $refundForm)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\RefundForm  $refundForm
     * @return \Illuminate\Http\Response
     */
    public function destroy(RefundForm $refundForm)
    {
        //
    }
}
