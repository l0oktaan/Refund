<?php

namespace App\Http\Controllers;

use App\Form;
use App\Office;
use App\Refund;
use App\RefundForm;
use App\RefundDetail;
use RefundFormController;
use App\Http\Resources\FormResource;
use App\Http\Requests\RefundDetailRequest;
use App\Http\Resources\RefundDetailResource;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;


class RefundDetailController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Office $office, Refund $refund, RefundForm $refund_form)
    {
        $detail = new RefundDetail();
        $detail = $refund_form->refund_details()->get();
        return RefundDetailResource::collection($detail);
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
    public function store(Request $request, Office $office, Refund $refund, RefundForm $refund_form)
     {
        // return response([
        //     'data' => $request->state
        // ],Response::HTTP_CREATED);
        //if ($request->has('data')){
            // $data = $request->data();
            // return response([
            //     'data' => $data
            // ],Response::HTTP_CREATED);
        //}else{
            // return response(null,Response::HTTP_NO_CONTENT);
       // }

        // $detail = new RefundDetail($request->all());
        // $refund_form->refund_details()->save($detail);
        // return response([
        //     'data' => $detail
        // ],Response::HTTP_CREATED);




            if ($request->has('detail')){


                //$data = json_encode($request->data);
                $data = $request->detail;

                // return response([
                //     'data' => $data[0]['consider_id']
                // ],Response::HTTP_CREATED);
                for ($i = 0; $i < count($data); $i++){

                    if ($request->state == "new"){
                        $detail = new RefundDetail;
                        $detail->consider_id = $data[$i]['consider_id'];
                        $detail->result_type = $data[$i]['result_type'];
                        $detail->value = $data[$i]['value'];
                        $detail->status = $data[$i]['status'];
                        $refund_form->refund_details()->save($detail);
                    }else if ($request->state == "update"){
                        $detail = RefundDetail::find($data[$i]['id']);
                        $detail->value = $data[$i]['value'];
                        $detail->status = $data[$i]['status'];
                        $detail->save();
                    }
                    $detail = null;
                }

                return response([
                    'data' => $data
                ],Response::HTTP_CREATED);

            }

        // if ($request->has('data'))
        // {
        //     $details = $request->data;
        //     foreach($details as $item)
        //     {
        //         if (!empty($item))
        //         {

        //             $detail = new RefundDetail($item);
        //             $refund_form->refund_details()->save($detail);
        //         }
        //     }
        //     return $details;
        // }

        /* $iform = new FormResource(Form::find($refund_form->form_id));
        $forms = array($iform);
        return $forms[0]['rules'];
        return array($forms->rules);
        foreach($forms as $form)
        {
            $rules = array($form->rules);
            return $rules;
            foreach($rule->considers as $consider)
            {
                $refundDetail = new RefundDetail();
                $refundDetail->rule_id = $rule->id;
                $refundDetail->consider_id = $consider->id;
                $refundDetail->value = '';
                $refundDetail->status = 0;
                $refund_form->refund_details()->save($refundDetail);
            }

        }
        return $forms; */




    }

    /**
     * Display the specified resource.
     *
     * @param  \App\RefundDetail  $refundDetail
     * @return \Illuminate\Http\Response
     */
    public function show(RefundDetail $refundDetail)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\RefundDetail  $refundDetail
     * @return \Illuminate\Http\Response
     */
    public function edit(RefundDetail $refundDetail)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\RefundDetail  $refundDetail
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, RefundDetail $refundDetail)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\RefundDetail  $refundDetail
     * @return \Illuminate\Http\Response
     */
    public function destroy(RefundDetail $refundDetail)
    {
        //
    }
}
