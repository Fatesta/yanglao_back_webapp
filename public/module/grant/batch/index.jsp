<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="tbr">
    <form id="frmQuery">
		<table class="form">
		   <tr>
	           <td>标题</td>
	           <td>
	               <input class="easyui-textbox" name="title" type="text">
	           </td>
	           <td>账单日期</td>
	           <td>
	               <input class="easyui-textbox filter" name="beginLogDate" type="text" style="width: 60px">
	                            至
	               <input class="easyui-textbox filter" name="endLogDate" type="text" style="width: 60px">(格式YYYYMM)
	           </td>
	           <td>
	               <a id="query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
	           </td>
	           <c:forEach var="func" items="${ROLE_FUNCS}">
	               <td><a id="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a></td>
	           </c:forEach>
               <td><a id="downloadTemplate" class="easyui-linkbutton" data-options="iconCls:'icon-download'">下载数据文件模板</a></td>
			</tr>
		</table>
    </form>
</div>
<table id="dg" class="easyui-datagrid" toolbar="#tbr"
    data-options="url:'${urlPath}grant/batch/page.do',
                  fit:true">
    <thead>
        <tr>
            <th data-options="field:'batch', width:70, halign: 'center', align:'left', formatter: formatters.batch">批次编号</th>
            <th data-options="field:'logDate', width:70, halign: 'center', align:'center'">账单日期</th>
            <th data-options="field:'title', width:200, halign: 'center', align:'left', formatter: UICommon.datagrid.formatter.wraptip">标题</th>
            <th data-options="field:'state', width:60, align: 'center', formatter: formatters.state">状态</th>
            <th data-options="field:'totalPeopleNum', width:60, align: 'center'">总人数</th>
            <th data-options="field:'intoAccountSuccesses', width:90, align: 'center'">入账成功人数</th>
            <th data-options="field:'intoAccountFailNum', width:90, align: 'center'">入账失败人数</th>
            <th data-options="field:'note', width:160, halign: 'center', align:'left', formatter: UICommon.datagrid.formatter.generators.omit({field: 'note'})">备注</th>
            <th data-options="field:'creatorName', width:100, halign: 'center', align:'left'">创建者</th>
            <th data-options="field:'createDate', width:130, halign: 'center', align:'center'">创建时间</th>
            <th data-options="field:'originFileUrl', width:70, align: 'center',formatter: formatters.url">原始文件</th>
        	</tr>
    </thead>
</table>

<script src="${modulePath}grant/batch/index.js?v=1"></script>

</body>
</html>