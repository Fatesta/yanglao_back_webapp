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
	           <td>身份证号码</td>
	           <td>
	               <input class="easyui-textbox" name="idcard" type="text">
	           </td>
               <td>姓名</td>
               <td>
                   <input class="easyui-textbox" name="realName" type="text" style="width:70px;">
               </td>
               <td>状态</td>
               <td>
                   <input class="easyui-combobox" name="status" type="text"
                        data-options="
                            editable: false,
                            textField: 'text',
                            valueField: 'value',
                            data: [{value: 1, text: '入账成功'}, {value: 2, text: '入账失败'}]"
                        style="width:80px;">
               </td>
	           <td>
	               <a id="query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
	           </td>
			</tr>
		</table>
    </form>
</div>
<table id="dg" class="easyui-datagrid" toolbar="#tbr"
    data-options="url:'${urlPath}grant/account/page.do?batch=${batch}',
                  fit:true">
    <thead>
        <tr>
            <th data-options="field:'batch', width:'5%', halign: 'center', align:'left'">批次编号</th>
            <th data-options="field:'idcard', width:'10%', halign: 'center', align:'left'">身份证号码</th>
            <th data-options="field:'realName', width:'5%', halign: 'center', align:'left'">姓名</th>
            <th data-options="field:'money', width:'6%', align: 'center', formatter: UICommon.datagrid.formatter.money">补助金额</th>
            <th data-options="field:'status', width:80, align: 'center', formatter: formatters.status">状态</th>
            <th data-options="field:'updateTime', width:'10%', halign: 'center', align:'left'">入账时间</th>
            <th data-options="field:'-', width:'120px', halign: 'center', align:'left', formatter: formatters.op">操作</th>
        	</tr>
    </thead>
</table>

<script>
var formatters = {
    status: function(v) {
        return {0: '待执行', 1: '入账成功', 2: '入账失败'}[v];
    },
    op: function(_, __, index) {
        return UICommon.buttonHtml({icon: 'consume-record', text: '服务站消费记录', clickCode: 'openConsumeRecord(' + index + ')'})
    }
}

function openConsumeRecord(index) {
    var row = $('#dg').datagrid('getRows')[index];
    if (!row.userId) {
        alertInfo('未查找到平台用户');
        return;
    }
    openTab("mainTab","view/user/userTradeRecord.do?accountId="+row.userId + '&startCreateTime=' + row.updateTime.substring(0, 10),
        "用户[{0}] - 服务站消费记录".format(row.realName));
}

$('#query').click(function(){
    $('#dg').datagrid('load', $('#frmQuery').serializeObject()); 
});
</script>

</body>
</html>