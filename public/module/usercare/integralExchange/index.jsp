<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="tbrIntegralExchangeRecord">
    <form id="frmQuery">
    	<input type="hidden" name="providerId"/>
    	<input type="hidden" name="userId"/>
		<table class="form">
  		   <tr>
	           <td>店铺</td>
	           <td id="selectProvider">
	               <input class="easyui-textbox filter"  id="providerName" data-options="readonly:true"   style="width:120px;"/>
	           </td>
	           <td>用户名</td>
	           <td id="selectUser" >
	               <input class="easyui-textbox filter" id="userName"  data-options="readonly:true"  style="width:100px;"/>
	              
	           </td>
	           <td colspan="7">
	               <a id="query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
	           </td>
	           <c:forEach var="func" items="${ROLE_FUNCS}">
	               <td><a id="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a></td>
	           </c:forEach>
				 </tr>
		</table>
    </form>
</div>
<table id="dgIntegralExchangeRecord" class="easyui-datagrid" toolbar="#tbrIntegralExchangeRecord"
    data-options="url:'${urlPath }integralExchange/recordPage.do',
                  multiSort:true,
                  sortOrder:'desc',
                  rownumbers: true,
                  pageSize: 30,
                  fit:true">
    <thead>
        <tr>
			<th data-options="field:'createTime',width:130,align:'center'">兑换时间</th>
			<th data-options="field:'userName',width:80,halign:'center'">兑换用户名</th>
            <th data-options="field:'telephone',width:100,halign:'center'">联系电话</th>
            <th data-options="field:'productName',width:500,halign:'center'">兑换商品</th>
			<th data-options="field:'providerName',width:220,halign:'center'">店铺名</th>
            <th data-options="field:'totalPrice',width:60,align:'center'">消费积分</th>
        </tr>
    </thead>
</table>

<script src="${modulePath}shop/pro/select.js?v=1.2"></script>
<script src="${modulePath}user/select.js"></script>
<script src="${modulePath}usercare/integralExchange/index.js"></script>
</body>
</html>