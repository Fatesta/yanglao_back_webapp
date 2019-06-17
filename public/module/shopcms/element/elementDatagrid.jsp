<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div id="tbrElement">
    <form id="frmQuery">
        <table class="form">
            <tr>
		        <c:forEach var="func" items="${ROLE_FUNCS}">
		            <td><a id="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a></td>
		        </c:forEach>
            </tr>
        </table>
    </form>
</div>
<table id="dgElement">
    <thead>
        <tr>
            <th data-options="field:'elementName', width:'20%', halign:'center', align:'left'">名称</th>
            <th data-options="field:'elementUrl', width:'8%', halign:'center', align:'center', formatter: UICommon.datagrid.formatter.generators.image({height: 60})">图片</th>
            <th data-options="field:'elementType', width:'6%', halign: 'center', align:'center', formatter: ElementManage.formatters.elementType">类别</th>
            <th data-options="field:'isvalid', width:'6%', halign: 'center', align:'center', formatter: UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('bool-yesno'))">是否显示</th>
        </tr>
    </thead>
</table>
