<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body class="easyui-layout">

	<div id="tbrDgOrder" style="display: none">
		<form id="frmQueryOrder">
			<input name="providerId" type="hidden"/>
			<input name="creator" type="hidden"/>
			<table class="form">
				<tr>
					<td>
						工单号
					</td>
					<td>
						<input class="easyui-textbox" name="orderno" type="text" style="width: 150px;">
					</td>
					<td>
						工单状态
					</td>
                    <td>
                        <select class="easyui-combobox" id="statuses" name="statuses" style="width: 80px;"></select>
                    </td>
                    <td>线上/线下</td>
                    <td colspan="8">
                        <input id="industryId" class="easyui-combobox" name="lineState" style="width: 60px"
                            data-options="
                            required:true,
                            data: [{text: '全部', value: 2}, {text: '线上', value: 1}, {text: '线下', value: 0}],
                            value: 2"
                    </td>
                </tr>
                <tr>
                    <td>下单用户</td>
                    <td id="selectUser">
                        <input class="easyui-textbox" id="creatorName" data-options="readonly:true" style="width: 70px;" />
                    </td>
                    <td>商家店铺</td>
                    <td id="selectProvider"><input class="easyui-textbox filter" id="providerName"  style="width: 180px;" 
                    data-options="readonly:true"></td>
                    <td>行业</td>
                    <td colspan="8">
                        <input id="industryId" class="easyui-combobox" name="industryId" style="width: 100px"
                            data-options="
                            required:true,
                            data: DictMan.items('product.industry'),
                            loadFilter: function(arr){
                              arr.unshift({value: '', text: '全部行业'});
                              return arr.filter(function(item){ return item.value != 'integral_mall' });
                            }">
                    </td>
					<td>
						开始日期
					</td>
					<td>
						<input class="easyui-datebox filter" name="startCreateTime" type="text" style="width:100px;">
					</td>
					<td>
						结束日期
					</td>
					<td>
						<input class="easyui-datebox filter" name="endCreateTime" type="text" style="width:100px;">
					</td>

					<td>
						<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" name="query">查询</a>
					</td>
				</tr>
			</table>
		</form>
	</div>
	<table id="dgOrder" class="easyui-datagrid" toolbar='#tbrDgOrder' style="display: none" >
	    <thead>
	        <tr>
	        	<th data-options="field:'orderno',width: 150,halign:'center'">工单号</th>
	            <th data-options="field:'status',width:80,halign:'center', align:'center', formatter: formatters.status">工单状态</th>
	            <th data-options="field:'lineState',width:70,align:'center', align:'center', formatter: formatters.lineState">线上/线下</th>
				<th data-options="field:'linkman',width:100,halign:'center'">联系人</th>
				<th data-options="field:'linkphone',width:90,halign:'center'">联系电话</th>
	            <th data-options="field:'creatorOrgName',width:120,halign:'center'">下单人所属社区</th>
                <th data-options="field:'providerName',width:160,halign:'center', formatter:UICommon.datagrid.formatter.wraptip">商家店铺</th>
                <th data-options="field:'industryId',width:80,align:'center', align:'center', formatter: formatters.industryId">行业</th>
				<th data-options="field:'creatorName',width:100,halign:'center'">下单人</th>
				<th data-options="field:'createTime',width:132,align:'center'">下单时间</th>
				<th data-options="field:'-',width:140,align:'center', formatter: formatters.op">操作</th>
	        </tr>
	    </thead>
	</table>


 
<script src="${modulePath}user/select.js"></script>
<script src="${modulePath}shop/pro/select.js?v=1.2"></script>
<script src="${modulePath}shop/workOrder/common.js?v=1"></script>
<script src="${modulePath}shop/workOrder/index.js?v=2.2"></script>
</body>
</html>