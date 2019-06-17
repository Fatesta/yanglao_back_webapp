<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<div style="padding: 5px;">
    已选择订单商品:
    <table id="dgAddedProduct" class="easyui-datagrid" data-options="checkOnSelect:false,fitColumns:true,pagination:false,fit:false">
        <thead>
            <tr>
                <th data-options="field:'name',width:'56%',halign:'left'">名称</th>
                <th data-options="field:'price',width:'14%',align:'center', formatter:orderAdd.formatters.price">单价(¥)</th>
                <th data-options="field:'quantity',width:'8%',align:'center'">数量</th>
                <th data-options="field:'totalPrice',width:'14%',align:'center'">价格(¥)</th>
                <th data-options="field:'-',width:'6%',halign:'left', formatter:orderAdd.formatters.addedProductOp">操作</th>
            </tr>
        </thead>
    </table>
    <p style="font-weight:bold">总价(¥)：<span id="spanTotalFee" style="display:inline"></span></p>
</div>
<form id="frmOrder" method="post">
    <input type="hidden" name="providerId" />
    <input type="hidden" name="industryId" />
    <input type="hidden" id="totalFee" name="totalFee" />
    <input type="hidden" id="paymentFee" name="paymentFee" />
    <input type="hidden" name="productListJSON" />
    <input type="hidden" name="productImgurl" />
    <input type="hidden" id="creator" name="creator" />
    <table class="form">
        <tr>
            <td>联系电话</td>
            <td>
                <input class="easyui-numberbox" id="linkphone" name="linkphone" data-options="events:{blur:orderAdd.linkphoneOnBlur}, required:true,validType:'length[1,11]'" style="width: 200px;">
                <a id="selectUser" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-user'" onclick="orderAdd.selectUser()">选择用户</a>
            </td>
        </tr>
        <tr>
            <td>收货人</td>
            <td colspan="3" class="form"><input class="easyui-textbox" id="linkman" name="linkman" data-options="required:true,validType:'length[1,100]'"  style="width: 100px;"></td>
        </tr>
        <tr>
            <td>送货地址</td>
            <td colspan="3" class="form"><input class="easyui-textbox" id="address" name="address" data-options="required:true,validType:'length[1,200]'"  style="width: 400px;"></td>
        </tr>
<!--            <tr> -->
<!--                <td>可获积分</td> -->
<!--                <td colspan="3" class="form"><input class="easyui-numberbox" name="sendIntegral" value=0 data-options="min:0,precision:0,required:true"  style="width: 50px;"></td> -->
<!--            </tr> -->
        <tr>
            <td>支付方式</td>
            <td>
                <select class="easyui-combobox" name="payType" style="width: 100px;">
                    <option value='33'>货到付款</option>
                </select>
            </td>
        </tr>
        <tr></tr>

        <tr>
            <td>实付款(¥)</td>
            <td>
                <span id="spanPaymentFee"></span>
            </td>
        </tr>
        <tr>
            <td>订单备注</td>
            <td>
                <textarea style="width: 400px;" rows="4" class="easyui-validatebox" name="remark" data-options="validType:'length[0,500]'"></textarea>
            </td>
        </tr>
    </table>
</form>