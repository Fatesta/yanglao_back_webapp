<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div id="tbrServicePlanDetail">
    <form id="frmQuery">
		<table class="form">
		   <tr>
	           <c:forEach var="func" items="${ROLE_FUNC_MAP['serviceplan.template.detail'].children}">
	               <td><a id="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a></td>
	           </c:forEach>
                   <td><a id="expandAll" class="easyui-linkbutton" data-options="iconCls:'icon-search'">全部展开/折叠</a></td>
			</tr>
		</table>
    </form>
</div>
<table id="dgServicePlanDetail" class="easyui-datagrid" toolbar="#tbrServicePlanDetail">
    <thead>
        <tr>
            <th data-options="field:'planDate', width: '50%', formatter: UICommon.datagrid.formatter.generators.substring(0, 10)">日期</th>
        	</tr>
    </thead>
</table>