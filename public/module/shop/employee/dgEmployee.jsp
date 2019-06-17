<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div id="tbrDgEmployee">
	<form id="frmSearchEmployee">
		<input name="roleId" type="hidden" value="${manager == null ? '' : '3'}"/> <!-- 员工角色. 如果是管理者登录,只显示员工(roleId=3) -->
		<input name="bossId" type="hidden" value="${boss.adminId}"/>
		<input name="providerId" type="hidden" value="${providerId}" />
		<input name="status" type="hidden" value="" />
		<table class="form">
			<tr>
				<td>
					工号
				</td>
				<td>
					<input class="easyui-textbox" name="username" type="text">
				</td>
				<td>
					姓名
				</td>
				<td>
					<input class="easyui-textbox" name="realName" type="text">
				</td>
                <td>状态</td>
                <td>
                    <select class="easyui-combobox" name="status" style="width: 80px;">
                        <option value="" selected="selected">全部</option>
                        <option value="1">激活</option>
                        <option value="0">禁用</option>
                    </select>
                </td>
               <td>
                   <a name="query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
               </td>
				<c:forEach var="fn" items="${ROLE_FUNC_MAP['shop.employee'].children}">
					<c:choose>
						<c:when test="${fn.code=='addManager' || fn.code=='addSalesman'}">
							<c:if test="${!hasAddFn}">
								<td>
									<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" name="addEmployee">增加员工</a>
								</td>
								<c:set var="hasAddFn" value="${true}" scope="page"/>
							</c:if>
						</c:when>
						<c:otherwise>
							<td>
								<a href="#" class="easyui-linkbutton" data-options="iconCls:'${fn.icon}'" name="${fn.code}">${fn.funcName}</a>
							</td>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</tr>
			
		</table>
	</form>
</div>
<table id="dgEmployee" class="easyui-datagrid" toolbar='#tbrDgEmployee'>
    <thead>
        <tr>
            <th data-options="field:'username',width:'10%',halign:'center'">工号</th>
            <th data-options="field:'realName',width:'6%',halign:'center'">姓名</th>
            <th data-options="field:'phone',width:'8%',halign:'center'">手机号码</th>
            <th data-options="field:'email',width:'12%',halign:'center'">邮箱地址</th>
            <th data-options="field:'roleId',width:'6%',halign:'center',align:'center',formatter:EmployeeManager.formatters.roleId">角色</th>
            <th data-options="field:'createTime',width:'10%',halign:'center'">注册时间</th>
            <th data-options="field:'providerNames',width:'30%',halign:'center',formatter:EmployeeManager.formatters.providerNames">属于店铺</th>
            <th data-options="field:'status',width:100,halign:'center',formatter:EmployeeManager.formatters.status">激活状态</th>
        </tr>
    </thead>
</table>