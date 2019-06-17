<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp"%>
<script src="${libPath}utils/require.js"></script>
<script><%@ include file="/lib/utils/require-config.js" %></script>
</head>
<body>

	<div id="bbsPostFormLayout" class="easyui-layout">
		<div data-options="region:'south',split:true,collapsible:true"
			style="width: 10%; height: 10%;">
			<form id="form" method="post" enctype="multipart/form-data">
			
				<input type="hidden" name="activityId" value="${activity.id}" /> 
				<input type="hidden" name="content" />
			    <input type="hidden"	class="easyui-datebox" name="createTime"/>  
				<input type="hidden"	name="updateTime" />
				<tr>
					<td></td>
					<td><a id="save" class="easyui-linkbutton"
						data-options="iconCls:'icon-save'"
						style="margin-top: 20px; margin-right: 10px; float: right;">保存</a>
					</td>
				</tr>
				</table>
			</form>
		</div>

		<div
			data-options="region:'center',title:'图文回顾', split:true,collapsible:true"
			style="width: 100%; height: 90%;">
			<script id="bbsPostEditor" type="text/plain"
				style="width: 100%; height: 100%;"></script>
		</div>
	</div>

	<script>
		window.UEDITOR_HOME_URL = '${libPath}ueditor1_4_3_3-utf8-jsp/';
	</script>
	<script src="${libPath}ueditor1_4_3_3-utf8-jsp/ueditor.config.js"></script>
	<script src="${libPath}ueditor1_4_3_3-utf8-jsp/ueditor.all.js">
		
	</script>
	<script src="${modulePath}activity/review.js?v=1"></script>
</body>
</html>
