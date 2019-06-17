<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<div style="padding: 5px;">
    已选择订单项目:
    <table id="dgAddedProduct" class="easyui-datagrid" data-options="checkOnSelect:false,fitColumns:true,pagination:false,fit:false">
        <thead>
            <tr>
                <th data-options="field:'name',width:'80%',halign:'left'">名称</th>
                <th data-options="field:'-',width:'18%',halign:'left', formatter:orderAdd.formatters.addedProductOp">操作</th>
            </tr>
        </thead>
    </table>
</div>
<form id="frmOrder" method="post">
    <input type="hidden" name="providerId" />
    <input type="hidden" name="industryId" />
    <input type="hidden" name="productListJSON" />
    <input type="hidden" id="creator" name="creator" />
    <input type="hidden" name="cardId" />
    <input type="hidden" name="cardNumber" />
    <input type="hidden" name="serviceCode" />
    <table class="form">
        <tr>
            <td>支付方式</td>
            <td>
                <select id="payType" class="easyui-combobox" name="payType" style="width: 100px;">
                    <option value="33">货到付款</option>
                    <option value="34">消费卡</option>
                </select>
            </td>
        </tr>
        <tr id="trSelectedForCardPay" style="display:none">
            <td>消费卡支付方式-已选择</td>
            <td>
                        用户：<span name="user" style="display: inline;"></span>
               <br>
                        消费卡服务：<span name="cardService" style="display: inline;"></span></td>
        </tr>
        <tr id="trLinkphone">
            <td>联系电话</td>
            <td>
                <input class="easyui-numberbox" id="linkphone" name="linkphone" data-options="events:{blur:orderAdd.linkphoneOnBlur}, required:true,validType:'length[1,11]'" style="width: 200px;">
                <a id="selectUser" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-user'" onclick="orderAdd.selectUser()">选择用户</a>
            </td>
        </tr>
        <tr>
            <td>联系人</td>
            <td colspan="3" class="form"><input class="easyui-textbox" id="linkman" name="linkman" data-options="required:true,validType:'length[1,100]'"  style="width: 100px;"></td>
        </tr>
        <tr>
            <td>订单地址</td>
            <td colspan="3" class="form"><input class="easyui-textbox" id="address" name="address" data-options="required:true,validType:'length[1,200]'"  style="width: 400px;"></td>
        </tr>
        <tr>
            <td>订单备注</td>
            <td>
                <textarea style="width: 400px;" rows="4" class="easyui-validatebox" name="remark" data-options="validType:'length[0,500]'"></textarea>
            </td>
        </tr>
    </table>
</form>