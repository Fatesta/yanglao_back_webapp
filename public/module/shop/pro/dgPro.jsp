<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div id="tbrDgPro">
	<form id="frmSearchPro">
		<input name="managerId" type="hidden" value="${manager.adminId}"/>
		<input name="bossId" type="hidden" value="${boss.adminId}"/>
		<input name="getUnprocessedOrderCount" type="hidden" value="${getUnprocessedOrderCount}"/>
		<table class="form">
			<tr>
			    <c:if test="${communityManager.adminId != null or sysAdmin.adminId != null}">
                <td>商家工号</td>
                <td>
                    <input class="easyui-textbox" name="adminUsername" type="text" style="width:100px;">
                    <a id="selectBoss" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"></a>
                </td>
                </c:if>
				<td>店铺名称</td>
				<td>
					<input class="easyui-textbox" name="name" type="text">
				</td>
				<td>行业</td>
	    		<td>
					<input id="industryId" class="easyui-combobox" name="industryId"
	   					data-options="
	   					required:true,
	   					data: DictMan.items('product.industry'),
	   					loadFilter: function(arr){
	   					  <c:if test="${not disableAllOption}">
	   					  arr.unshift({value: '', text: '全部行业'});
	   					  </c:if>
	   					  return arr;
	   					},
				        onChange: function() {
				            pro.query();
				        },
	   					value: ''">
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
				<c:forEach var="fn" items="${ROLE_FUNC_MAP['shop.provider'].children}">
					<td colspan="7" >
						<a class="easyui-linkbutton" data-options="iconCls:'${fn.icon}'" name="${fn.code}" href="#">${fn.funcName}</a>
					</td>
				</c:forEach>
				<c:forEach var="fn" items="${funcs}">
                    <td>
                        <a class="easyui-linkbutton" data-options="iconCls:'${fn.icon}'" name="${fn.code}" href="#">${fn.funcName}</a>
                    </td>
				</c:forEach>
			</tr>
		</table>
	</form>
</div>
<table id="dgPro" toolbar='#tbrDgPro'></table>
<div id="dlgPro"></div>