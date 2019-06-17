<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div id="tbrDgBoss">
	<form id="frmSearchBoss">
		<table class="form">
			<tr>
				<td>
					工号
				</td>
				<td>
					<input class="easyui-textbox" name="username" type="text" style="width:100px">
				</td>
				<td>
					姓名
				</td>
				<td>
					<input class="easyui-textbox" name="realName" type="text" style="width:200px">
				</td>
				<c:if test="${curAdmin.roleId == 1 || curAdmin.roleId == 13 || curAdmin.roleId == 14 || curAdmin.roleId == 15}">
					<td><label for="orgId">社区</label></td>
					<td>
						<input class="easyui-combobox" name="orgId" style="width:200px;"
							   data-options="required:true,
		                            valueField:'id',
		                            textField:'name',
		                            url:'${urlPath }org/communities.do',
		                            checkbox: true,
		                            loadFilter: function(arr) {
		                              arr.unshift({id: '', name: '全部'});
		                              return arr;
		                            },
		                            value: '${empty orgId ? '' : orgId}'" />
					</td>
				</c:if>
               <td>
                   <a name="query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
               </td>
               <c:if test="${ROLE_FUNC.code == 'shop.boss' || ROLE_FUNC.code == 'shop.financeManager'}">
	               <c:forEach var="fn" items="${ROLE_FUNCS}">
	               <td colspan="7">
	                   <a href="#" class="easyui-linkbutton" data-options="iconCls:'${fn.icon}'" name="${fn.code}">${fn.funcName}</a>
	               </td>
	               </c:forEach>
               </c:if>
			</tr>
		</table>
	</form>
</div>
<table id="dgBoss" toolbar='#tbrDgBoss'>
    <thead>
        <tr>
			<th data-options="field:'username',width:'100',align:'center'">工号</th>
			<th data-options="field:'realName',width:'150',halign:'center'">姓名</th>
			<th data-options="field:'phone',width:'100',halign:'center'">手机号码</th>
			<th data-options="field:'email',width:'180',halign:'center'">邮箱地址</th>
			<th data-options="field:'createTime',width:'130',halign:'center'">注册时间</th>
			<th data-options="field:'balance',width:'90',halign:'center', halign:'center', formatter: boss.formatters.balance">余额</th>
			<th data-options="field:'oldCardBalance',width:'90',halign:'center', halign:'center', formatter: function(v) { return '¥ ' + v; }">老年卡余额</th>
	   </tr>
	</thead>
</table>
<script src="${modulePath}shop/boss/boss.js?v=1.3"></script>
