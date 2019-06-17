<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<div id="tbrCoupon">
    <form>
        <input name="providerId" type="hidden">
        <input name="accountId" type="hidden" value="${userType == 9 ? deviceCode : userId}"/>
        <table class="form">
            <tr>
	            <td>范围</td>
	            <td>
	               <input class="easyui-combobox" id="range"
	                   data-options="
	                       data: [{value: 0, text: '全部'}, {value: 1, text: '店铺'}, {value: 2, text: '平台劵'}]"
	                   style="width:64px;"/>
	            </td>
	            <td id="selectProviderTr" style="margin-left: 0px;padding-left: 0px;display:none">
	               <input class="easyui-textbox" id="providerName" data-options="readonly: true" type="text" style="width:100px;">
	            </td>
                <td>劵类型</td>
                <td>
                    <input class="easyui-combobox" name="type" style="width: 80px;" />
                </td>
                <td>劵状态</td>
                <td>
                    <input class="easyui-combobox" name="scope" style="width: 80px;" />
                </td>
                <td>
                    <a name="query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
                </td>
            </tr>
        </table>
    </form>
</div>
<table id="dgCoupon" class="easyui-datagrid" toolbar="#tbrCoupon">
    <thead>
        <tr>
            <th data-options="field:'batchId', width:80, align:'center'">批次</th>
            <th data-options="field:'couponNumber', width:100, align:'center'">劵编号</th>
            <th data-options="field:'subject', width:120, halign:'center', formatter: UICommon.datagrid.formatter.wraptip">主题</th>
            <th data-options="field:'type', width:50, align:'center', formatter: formatters.type">类型</th>
            <th data-options="field:'startTime', width:130, align:'center', formatter: UICommon.datagrid.formatter.generators.substring(0, 19)">开始时间</th>
            <th data-options="field:'endTime', width:130, align:'center', formatter: UICommon.datagrid.formatter.generators.substring(0, 19)">结束时间</th>
            <th data-options="field:'lowestMoney', width:90, align:'center', formatter: UICommon.datagrid.formatter.money">条件最低金额</th>
            <th data-options="field:'discountAmount', width:70, align:'center', formatter: UICommon.datagrid.formatter.money">优惠金额</th>
            <th data-options="field:'content', width:150, halign:'center', formatter: UICommon.datagrid.formatter.generators.omit({dgId: 'dgCoupon', field: 'content'})">优惠内容</th>
            <th data-options="field:'providerName', width:150, halign:'center', formatter: UICommon.datagrid.formatter.generators.omit({dgId: 'dgCoupon', field: 'providerName'})">店铺</th>
            <th data-options="field:'createTime', width:130, align:'center', formatter: UICommon.datagrid.formatter.generators.substring(0, 19)">领取时间</th>
            <th data-options="field:'status', width:50, align:'center', formatter: formatters.couponUser.status">状态</th>
            </tr>
    </thead>
</table>

<script src="${modulePath}coupon/batch/formatters.js?v=1.2"></script>
<script src="${modulePath}shop/pro/select.js?v=1.2"></script>