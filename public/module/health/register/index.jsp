<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>

<%@ include file="/module/common.jsp" %>

</head>
<body>
<div id="tbrDgReg">
<form id="frmQuery">
	<table class="form">
		<tr>
			<td>挂号时间</td>
			<td>
				<input class="easyui-datebox filter" name="reservationTime" type="text">
			</td>
			<td>身份证号</td>
			<td>
				<input class="easyui-textbox filter" name="idcard" type="text">
			</td>
<!-- 			<td>社区名称</td> -->
<!-- 			<td> -->
<!-- 				<input class="easyui-textbox filter" name="orgName" type="text"> -->
<!-- 			</td> -->
            <td>
                        状态
            </td>
            <td>
                <select class="easyui-combobox filter" name="status" style="width: 100px;">
                    <option value="" selected="selected">全部</option>
                    <option value="1">等待</option>
                    <option value="2">成功</option>
                    <option value="0">取消</option>
                </select>
            </td>
			<td colspan="6">
				<a name="query" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
			    <a name="add" class="easyui-linkbutton" data-options="iconCls:'icon-add'">代挂号</a>
			    <a name="delete" class="easyui-linkbutton" data-options="iconCls:'icon-delete'">删除</a>
			</td>
		</tr>
	</table>
</form>
</div>
<table id="dgReg" class="easyui-datagrid"
	data-options="url:'${urlPath }health/register/list.do',
				  multiSort:true,
				  fit:true,
				  toolbar:'#tbrDgReg'">
    <thead>
        <tr>
            <th data-options="field:'aliasName',width:'100',align:'left'">昵称</th>
            <th data-options="field:'age',width:'50',align:'center'">年龄</th>
            <th data-options="field:'sex',width:'3%',align:'center',formatter:UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('user.gender'))">性别</th>
            <th data-options="field:'userType',width:'8%',align:'center', formatter: UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('user.type'))">用户类型</th>
<!--             <th data-options="field:'orgName',width:'10%',align:'left'">所属社区</th> -->
            <th data-options="field:'phone',width:'100',halign:'center'">挂号手机号</th>
            <th data-options="field:'idcard',width:'140',halign:'center'">身份证号</th>
            <th data-options="field:'reservationTime',width:'150',align:'center'">挂号时间</th>
            <!--<th data-options="field:'illness',width:'10%',halign:'center'">症状描述</th>-->
            <th data-options="field:'status',width:'4%',align:'center',formatter:formatters.status">状态</th>
            <th data-options="field:'--',width:'10%',align:'left',formatter:formatters.op">操作</th>
        </tr>
    </thead>
</table>
<script src="${modulePath}health/register/index.js?v=1.3"></script>
</body>
</html>