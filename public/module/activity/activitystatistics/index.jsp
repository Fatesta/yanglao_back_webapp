<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/module/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
 <title>活动统计页面</title>
</head>
<body>

<div id="tbrActivitySts">
	<form id="frmQuery">	  
		<table class="form">
			<tr>
				<td>标题</td>
				<td><input class="easyui-textbox filter" name="title" type="text" style="width: 100px;"></td>
					<td>活动时间</td>
				<td><input class="easyui-datebox filter" name="time" type="text" style="width: 100px;"></td>
				<td>
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
				            name="query" >查询</a>
				</td>
			
			</tr>
		</table>
	</form>
</div>
	<table id="dntegral" class="easyui-datagrid"
		data-options="url:'${urlPath}activitystatistics/page.do',
				  toolbar:'#tbrActivitySts',				
				  fit:true
				  ">
		<thead>
		<tr>
			<th data-options="field:'title',width:'120',halign:'center',formatter:formatters.title">标题</th>
			<th data-options="field:'categoryName',width:'100',align:'center'">分类</th>
			<th data-options="field:'publisherName',width:'90',halign:'center'">发布者</th>
            <th data-options="field:'isLive',width:'60',align:'center', formatter: UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('bool-yesno'))">直播活动</th>
            <th data-options="field:'status',width:'50',align:'center', formatter: formatters.status">状态</th>
			<th data-options="field:'startTime',width:'130',align:'center',align:'center'">开始时间</th>
			<th data-options="field:'endTime',width:'130',align:'center',align:'center'">结束时间</th>
			<th data-options="field:'telephone',width:'100',halign:'center'">联系电话</th>
			<th data-options="field:'address',width:'200',halign:'center', formatter:formatters.description">活动地址</th>
			<th data-options="field:'orgName',width:'70',halign:'center',formatter:formatters.scope">活动范围</th>		
			<th data-options="field:'signCount',width:'58',halign:'center',align:'center'">参与人数</th>	
			<th data-options="field:'formatOper',width:'100',align:'center',halign:'center',formatter:formatters.formatOper">操作</th>
		</tr>
	</thead>
</table>

 <script >

 </script> 
 <script src="${modulePath}activitystatistics/index.js?v=1"></script>

</body>
</html>