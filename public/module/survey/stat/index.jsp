<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body class="easyui-layout">
    <div data-options="region:'center',split:true" style="height:60%;">
		<div id="tbrQuestion">
		    <form id="frmQuery">
				<table class="form">
				   <tr>
			           <td>内容</td>
			           <td>
			               <input class="easyui-textbox" name="content" type="text">
			           </td>
			           <td>
			               <a id="query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
			           </td>
                       <td>
                           <a id="expandAll" data-expanded='1' class="easyui-linkbutton" data-options="iconCls:'icon-search'">全部展开/折叠</a>
                       </td>
                       <td>
                           <a id="export" class="easyui-linkbutton" data-options="iconCls:'icon-export'">导出</a>
                       </td>
					</tr>
				</table>
		    </form>
		</div>
		<table id="dgQuestion" class="easyui-datagrid" toolbar="#tbrQuestion">
		    <thead>
		        <tr>
		            <th data-options="field:'orderno', width:10, halign: 'center', align:'center'">序号</th>
		            <th data-options="field:'content', width:60, halign: 'center', align:'left', formatter: UICommon.datagrid.formatter.generators.omit({dgId: 'dgQuestion', min: 80, field: 'content'})">内容</th>
                    <th data-options="field:'type', width:10, halign: 'center', align:'center', formatter: formatters.type">题型</th>
                    <th data-options="field:'-', width:10, halign: 'center', align:'center', formatter: formatters.op"></th>
		        	</tr>
		    </thead>
		</table>
    </div>
    
    <div id="statDialog"></div>

	<script>
	var PAGE_CONFIG = {surveyId: '${surveyId}'};
	</script>
	<script src="${libPath}easyui/plugins/datagrid-detailview.js"></script>
	<script src="${modulePath}survey/question/formatters.js"></script>
	<script src="${modulePath}survey/stat/stat.js"></script>
</body>
</html>