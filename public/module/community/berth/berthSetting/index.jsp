<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
</head>
<body id="layout" class="easyui-layout">
	<div class="easyui-layout" data-options="fit:true">
		<div data-options="region:'west',split:true,collapsible:true" title="布局" style="width:300px">
			<ul id="treePlace"></ul>
		</div>

		<div id="panelPlace" data-options="region:'center'" title="-">
			<div id="tbrPlace">
			    <form name="frmQuery">
			        <table class="form">
			           <tr>
                            <td><a name="add" class="easyui-linkbutton" data-options="iconCls:'icon-add'">增加</a></td>
                            <td><a name="update" class="easyui-linkbutton" data-options="iconCls:'icon-edit'">修改</a></td>
                            <td><a name="delete" class="easyui-linkbutton" data-options="iconCls:'icon-delete'">删除</a></td>
			            </tr>
			        </table>
			    </form>
			</div>
			<table id="dgPlace" class="easyui-datagrid" toolbar="#tbrPlace">
			</table>

		</div>
	</div>

	<script>
	var resthomeId = '${resthome_id}';
	</script>
<script src="${modulePath}community/berth/berthSetting/berthSetting.js?v=1.3"></script>
</body>
</html>