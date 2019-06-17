<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>

<p style="margin: 5px;font-size: 17px;">余额：${productProviderBalance.balance}</p>

<%@ include file="../../boss/frmBoss.jsp" %>
<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'"
				            onclick="save()">保存</a>
<div id="dlgBoss"></div>
<script src="${modulePath}shop/boss/boss.js"></script>
<script>
function save() {
	$("#frmBoss").form("submit", {
	    url:"${urlPath}shop/boss/saveBoss.do",
	    success:function(data){
	    	var data = str2Json(data);
	    	if (data.success) {
	    		showMessage('系统提示', data.message);
	    	} else {
	    		showAlert(data.title,data.message,'error');
	    	}
	    }
	});
}

</script>
</body>
</html>