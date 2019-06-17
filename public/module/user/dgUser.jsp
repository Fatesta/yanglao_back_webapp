<!-- 用户选择器 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div id="userGridToolbar">
<form id="frmQuery">
	<table class="form">
		<tr>
			<td>昵称</td>
			<td>
				<input class="easyui-textbox filter" name="aliasName" type="text" style="width: 80px;">
			</td>
			<td>
				手机号码
			</td>
			<td>
				<input class="easyui-textbox filter" name="telphone" type="text" style="width: 100px;">
			</td>
			<td colspan="6">
				<a id="query" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
                <a id="userQuerier" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'">高级查询</a>
			</td>
		</tr>
	</table>
</form>
</div>
<table id="dgUser" class="easyui-datagrid"
	data-options="url:'${urlPath }user/listUser.do',
				  multiSort:true,
				  fit:true,
				  toolbar:'#userGridToolbar',
				  queryParams: {userType: ${empty userType ? -1 : userType}}">
    <thead>
        <tr>
            <th data-options="field:'aliasName',width:100,halign:'center'">昵称</th>
            <th data-options="field:'realName',width:60,halign:'center'">姓名</th>
            <th data-options="field:'sex',width:50,align:'center',formatter: UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('user.gender'))">性别</th>
            <th data-options="field:'telphone',width:100,halign:'center'">手机号码</th>
            <th data-options="field:'userType',width:100,align:'center',formatter:UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('user.type'))">用户类型</th>
            <th data-options="field:'deviceCode',width:140,align:'center',halign:'center',formatter: userSelector.formatters.deviceCode, hidden: true">设备号</th>
            <th data-options="field:'cardCode',width:140,align:'center',halign:'center',formatter: userSelector.formatters.deviceCode, hidden: true">会员卡号</th>
            <th data-options="field:'registerTime',width:130,halign:'center',align:'center'">注册时间</th>
        </tr>
    </thead>
</table>
<script src="${modulePath}user/querier.js"></script>
<script>
var userSelector = {
    formatters: {
	    deviceCode: function(value, user, rowIndex) {
	        return user.userType == 9 || user.userType == 2 ? user.deviceCode : '-';
	    }
    }
};
$(function() {
	initUserQuerier('#userQuerier', '#searchUser', '#dgUser');
	$('#userGridToolbar #query').click(function() {
	    var qparams = $('#userGridToolbar #frmQuery').serializeObject();
	    $('#dgUser').datagrid("load", qparams);
	});
});
</script>
