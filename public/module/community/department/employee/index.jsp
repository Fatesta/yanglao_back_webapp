<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div id="tbrCommunityDepartmentEmployee">
    <form name="frmQuery">
        <input type="hidden" name="communityId" value="${communityId}">
        <input type="hidden" name="departmentId">
		<table class="form">
		   <tr>
	            <td>姓名</td>
	            <td>
	                <input class="easyui-textbox filter" name="name" type="text"  style="width:80px;">
	            </td>
                <td>
                    <a name="query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
                </td>
	            <c:forEach var="func" items="${ROLE_FUNC_MAP['community.department.employee'].children}">
					<td><a name="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a></td>
	            </c:forEach>
			</tr>
		</table>
    </form>
</div>
<table id="dgCommunityDepartmentEmployee" class="easyui-datagrid" toolbar="#tbrCommunityDepartmentEmployee">
    <thead>
        <tr>
            <!--<th data-options="field:'imagePath', width:'50', halign: 'center', align:'left', formatter: employee.formatters.imagePath">照片</th>-->
            <th data-options="field:'name', width:'80', halign: 'center', align:'left'">姓名</th>
            <!--<th data-options="field:'sex', width:'40', halign: 'center', align:'center', formatter: employee.formatters.sex">性别</th>-->
            <!--<th data-options="field:'birthday', width:'100', halign: 'center', align:'center'">生日</th>-->
            <!--<th data-options="field:'idcard', width:'140', halign: 'center', align:'left'">身份证号码</th>-->
            <th data-options="field:'mobile', width:'100', halign: 'center', align:'left'">移动电话</th>
            <th data-options="field:'telephone', width:'100', halign: 'center', align:'left'">办公电话</th>
            <th data-options="field:'departmentName', width:'200', halign: 'center', align:'left'">部门</th>
            <th data-options="field:'position', width:'200', halign: 'center', align:'left'">职务</th>
            <!--<th data-options="field:'createTime', width:'130', halign: 'center', align:'left'">录入时间</th>-->
        	</tr>
    </thead>
</table>
