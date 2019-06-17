<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div id="tbrDgTradeDetail">
	<form id="frmQuery">
		<input name="providerAccount" type="hidden" value="${boss.adminId}">
		<input name="managerId" type="hidden" value="${manager.adminId}"/>
		<input name="bossId" type="hidden" value="${boss.adminId}"/>

		<table class="form">
			<tr>
				<td>商户操作工号</td>
				<td>
					<input class="easyui-textbox" name="operationAccountUsername" type="text" style="width:100px">
				</td>
                <td>店铺</td>
                <td colspan="8">
                    <input class="easyui-combobox" id="cboProvider" name="providerId" style="width: 270px;">
                </td>
			</tr>
			<tr>
				<td>
					交易类型
				</td>
				<td>
				    <select class="easyui-combobox" id="cboTradeType" name="tradeType" style="width: 120px;">
				    </select>
				</td>

                <td>支付方式</td>
                <td>
                    <select class="easyui-combobox" id="cboPayType" name="payType" style="width: 90px;">
                    </select>
                </td>
				<td>优惠方式</td>
				<td>
					<select class="easyui-combobox" id="yhType" name="yhType" style="width: 120px;">
						<option value="">全部</option>
						<option value="0">无优惠</option>
						<option value="-1">店铺充值赠送</option>
						<option value="2">店铺优惠劵抵扣</option>
						<option value="1">平台优惠劵抵扣</option>
						<option value="-2">老年卡补贴</option>
					</select>
				</td>

				<td>
					交易时间
				</td>
				<td>
					<input class="easyui-datebox filter" name="startCreateTime" type="text" style="width:100px">
					<span>到</span>
					<input class="easyui-datebox filter" name="endCreateTime" type="text" style="width:100px">
				</td>
				<td colspan="8">
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" name="query">查询</a>

                    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-export'" name="export">导出为Excel</a>
                </td>
			</tr>
		</table>
	</form>
</div>
<table id="dgTradeDetail" class="easyui-datagrid" toolbar='#tbrDgTradeDetail'>
    <thead>
        <tr>
			<th data-options="field:'createTime',width:130,halign:'center',align:'center'">交易时间</th>
            <th data-options="field:'formattedTradeType',width:100,halign:'center',align:'center'">交易类型</th>
            <th data-options="field:'formattedPayType',width:100,halign:'center',align:'center'">支付方式</th>
            <th data-options="field:'totalFee',width:60,halign:'center',align:'center', formatter: UICommon.datagrid.formatter.money">原价</th>
            <th data-options="field:'tradePrice',width:60,halign:'center',align:'center', formatter: UICommon.datagrid.formatter.money">实收</th>
            <th data-options="field:'formattedCouponAmount',width:200,halign:'center',align:'left'">优惠</th>
            <th data-options="field:'userAccountAliasName',width:100,halign:'center'">买家昵称</th>
            <th data-options="field:'userAccountDeviceCode',width:120,halign:'center'">设备号</th>
            <th data-options="field:'operationAccountUsername',width:100,align:'center'">商户操作工号</th>
            <th data-options="field:'operationPhoneLogo',width:100,halign:'center', formatter: UICommon.datagrid.formatter.wraptip">商户操作手机标识</th>
            <th data-options="field:'providerName',width:160,halign:'center'">店铺</th>
			<th data-options="field:'orderno',width:160,halign:'center', formatter: tradeDetailManager.formatters.orderno">订单号</th>
        </tr>
    </thead>
</table>
