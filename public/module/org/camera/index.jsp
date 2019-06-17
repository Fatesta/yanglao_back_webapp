<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/module/common.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body class="easyui-layout">
	<div data-options="region:'center',split:true" style="height:40%;">
		<div id="tbrDgOrgCamera">
			<form id="frmQuery">
				<input name="orgId" type="hidden" value="${orgId}"/>
				<table class="form">
					<tr>
						<td>
							设备序列号
						</td>
						<td>
							<input class="easyui-textbox" name="deviceSerial" type="text" style="width:100px;">
						</td><!--
						<td>
							设备IP
						</td>
						<td>
							<input class="easyui-textbox" name="ip" type="text">
						</td>-->
						<td>
							名称
						</td>
						<td>
							<input class="easyui-textbox" name="note" type="text">
						</td>
						<!-- 
						<td>
							类型
						</td>
			    		<td>
							<input class="easyui-combobox" name="type" style="width: 135px;"
			   					data-options="valueField:'id',textField:'name',required:true,
			   					data:[{id:'', name:'全部'}, {id:3, name: '萤石云摄像头'}, {id:1, name:'单路摄像头'}, {id:2, name: '多路摄像头'}]">
			    		</td>
			    		 -->
						<td colspan="7" >
							<a class="easyui-linkbutton" data-options="iconCls:'icon-search'" name="query" href="#">查询</a>
						</td>
						<td colspan="7" >
							<a class="easyui-linkbutton" data-options="iconCls:'icon-add'" name="add" href="#">增加</a>
						</td>
						<td colspan="7" >
							<a class="easyui-linkbutton" data-options="iconCls:'icon-edit'" name="update" href="#">修改</a>
						</td>
						<td colspan="7" >
							<a class="easyui-linkbutton" data-options="iconCls:'icon-delete'" name="delete" href="#">删除</a>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<table id="dgOrgCamera" class="easyui-datagrid" toolbar='#tbrDgOrgCamera'>
			<thead>
				<tr>
		            <th data-options="field:'note',width:300,halign:'center'">名称</th>
		            <th data-options="field:'deviceSerial',width:100,halign:'center'">设备序列号</th>
		            <th data-options="field:'validateCode',width:100,halign:'center'">设备验证码</th>
		            <!--<th data-options="field:'ip',width:'16%',halign:'center'">设备IP</th>
		            <th data-options="field:'port',width:'16%',halign:'center'">HTTP端口</th>
		            <th data-options="field:'username',width:'16%',halign:'center'">用户名</th>
			        <th data-options="field:'type',width:'16%',halign:'center', formatter:function(value){ return {1:'单路摄像头',2:'多路摄像头'}[value]; }">类型</th>  -->
				</tr>
			</thead>
		</table>
	</div>
	
	<div id="panelMutilCameraNode" data-options="title:'多路摄像头节点', region:'south',split:true,collapsible:true,collapsed:true" style="height:60%">
		<div id="tbrDgMutilCameraNode">
			<form id="frmQuery">
				<input name="orgId" type="hidden" value="${orgId}"/>
				<table class="form">
					<tr>
						<td colspan="7" >
							<a class="easyui-linkbutton" data-options="iconCls:'icon-search'" name="get" href="#">自动获取</a>
						</td>
						<td colspan="7" >
							<a class="easyui-linkbutton" data-options="iconCls:'icon-add'" name="add" href="#">增加</a>
						</td>
						<td colspan="7" >
							<a class="easyui-linkbutton" data-options="iconCls:'icon-edit'" name="update" href="#">修改</a>
						</td>
						<td colspan="7" >
							<a class="easyui-linkbutton" data-options="iconCls:'icon-delete'" name="delete" href="#">删除</a>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<table id="dgMutilCameraNode" class="easyui-datagrid" toolbar='#tbrDgMutilCameraNode'>
			<thead>
				<tr>
		            <th data-options="field:'nodeno',width:'5%',halign:'center'">编号</th>
		            <th data-options="field:'desc',width:'60%',halign:'center'">描述</th>
				</tr>
			</thead>
		</table>
	</div>
	
	<div id="dlg"></div>
<script>
var PAGE_CONFIG = {};
PAGE_CONFIG['orgId'] = '${orgId}';
</script>
<script src="${libPath}webVideoCtrl.js"></script>
<script src="${modulePath}org/camera/manager.js?v=1"></script>
</body>
</html>