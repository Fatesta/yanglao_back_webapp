<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="userGridToolbar${viewType}">
<form id="searchUser">
	<table class="form">
	    <c:if test="${viewType ==0}">
	    <tr>
	        <td colspan="10">
            <c:forEach var="func" items="${ROLE_FUNCS}">
                <c:choose>
	                <c:when test="${func.code == 'user.address'}">
                        <a id="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a>
	                </c:when>
	                <c:when test="${func.children.size() > 0}">
	                    <a href="javascript:void(0)" id="${func.code}" class="easyui-menubutton" data-options="menu:'#${func.code}-menu',iconCls:'${func.icon}'">${func.funcName}</a>   
						<div id="${func.code}-menu" style="width:150px;">
						    <c:forEach var="func" items="${func.children}">
						        <div id="${func.code}" data-options="iconCls:'${func.icon}'">${func.funcName}</div>
						    </c:forEach>
						</div>
	                </c:when>
	                <c:otherwise>
	                   <a id="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a>
	                </c:otherwise>
                </c:choose>
            </c:forEach>
                    <a id="user-export" class="easyui-linkbutton" data-options="iconCls:'icon-export'">导出</a>
            </td>
        </tr>
        </c:if>
		<tr>
			<td>
				昵称
			</td>
			<td>
				<input class="easyui-textbox filter" name="aliasName" type="text"  style="width:100px;">
			</td>
			<td>
				手机号码
			</td>
			<td>
				<input class="easyui-textbox filter" name="telphone" type="text"  style="width: 100px;">
			</td>
            <td>设备号</td>
            <td>
                <input class="easyui-textbox filter" name="deviceCode" style="width: 120px;">
            </td>
            <td>会员卡号</td>
            <td>
                <input class="easyui-textbox filter" name="cardCode" style="width: 120px;">
            </td>
            <td>用户类型</td>
            <td>
                <input class="easyui-combobox filter" name="userType" style="width: 100px;">
            </td>
			<td colspan="2">
				<a id="user.query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
                <a id="userQuerier" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'">高级查询</a>
			    <a id="user.resetQuery" class="easyui-linkbutton" data-options="iconCls:'icon-clear'">清空</a>
			</td>
		</tr>
	</table>
</form>
</div>
<table id="userGrid${viewType}" class="easyui-datagrid" toolbar="#userGridToolbar${viewType}"
    data-options="pageSize: 30">
    <thead>
        <tr>
            <th data-options="field:'userId',width:110,halign:'center',hidden:true">UID</th>
            <th data-options="field:'aliasName',width:80,halign:'center'">昵称</th>
            <th data-options="field:'realName',width:70,halign:'center',formatter: userManage.formatters.unknownIfEmpty">姓名</th>
            <th data-options="field:'sex',width:50,halign:'center',align:'center',formatter: userManage.formatters.sex">性别</th>
            <th data-options="field:'age',width:50,halign:'center',align:'center',formatter: userManage.formatters.age">年龄</th>
            <th data-options="field:'idcard',width:140,align:'center',halign:'center',formatter: userManage.formatters.unknownIfEmpty">身份证号码</th>
            <th data-options="field:'telphone',width:90,halign:'center',formatter: userManage.formatters.unknownIfEmpty">电话</th>
            <th data-options="field:'orgName',width:120,halign:'center',formatter: userManage.formatters.unknownIfEmpty">社区</th>
            <th data-options="field:'applyTypesText',width:160,halign:'center', formatter: userManage.formatters.applyTypesText">评估对象类型</th>
            <th data-options="field:'evalScore',width:60,align:'center', formatter: userManage.formatters.evalScore">评估分数</th>
            <th data-options="field:'allowanceMoney',width:90,align:'center', formatter: userManage.formatters.allowanceMoney">拟享受市补贴</th>
            <th data-options="field:'userType',width:90,align:'center',halign:'center',formatter:UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('user.type'))">用户类型</th>
            <th data-options="field:'cardCode',width:140,align:'center',halign:'center',formatter: userManage.formatters.deviceCode, hidden: true">会员卡号</th>
            <th data-options="field:'deviceCode',width:140,align:'center',halign:'center',formatter: userManage.formatters.deviceCode, hidden: true">设备号</th>
            <th data-options="field:'onLine',width:60,halign:'center',align:'center',formatter: userManage.formatters.onLine">在线状态</th>
            <th data-options="field:'registerTime',width:130,halign:'center',align:'right', formatter: userManage.formatters.registerTime">注册时间</th>
            <c:if test="${viewType == 1 || viewType == 2}">
            <th data-options="field:'-',width:40,align:'center',halign:'center',formatter: userManage.formatters.op">操作</th>
            </c:if>
        </tr>
    </thead>
</table>
    <script>
        var viewType = '${viewType}';
    </script>
    <script src="${modulePath}user/querier.js?v=2.4"></script>
    <script src="${modulePath}user/basicInfo.js?v=1"></script>
    <script src="${modulePath}user/formatters.js?v=1.3"></script>
    <script src="${modulePath}user/vipcard/change/change.js?v=1"></script>
    <script src="${libPath}utils/require.js"></script>
<script>
    $('#userGridToolbar0').dblclick(function(e) {
        if (e.target.tagName == 'INPUT') return;
        var dg = $('#userGrid0');
        var hidden = dg.datagrid('getColumnOption', 'userId').hidden;
        var msg = hidden ? '进入开发者视图' : '退出开发者视图';
        $.messager.show({
            msg: '<p style="text-align:center;line-height:46px;">' + msg + '</p>',
            showSpeed: 100,
            timeout: 600,
            showType:'fade',
            style: {
                height: '50px'
            }
        });
        setTimeout(function() {
            dg.datagrid(hidden ? 'showColumn' : 'hideColumn', 'userId');
        }, 200);
    });

    require([CONFIG.modulePath + 'user/index.js?v=7.4'], function(f) {
        f('${viewType}');
    });
    
    function showCareGrid(rowIndex) {
        var row = $('#userGrid${viewType}').datagrid('getRows')[rowIndex];
        openTab("mainTab", CONFIG.baseUrl + "care/careGrid.do?deviceId=" + row.userId, '用户[' + row.aliasName + "]关爱");
    }
    
    function showSafePositions(rowIndex) {
        var row = $('#userGrid${viewType}').datagrid('getRows')[rowIndex];
        openTab("mainTab", CONFIG.baseUrl + "view/device/safePositionGrid.do?deviceId=" + row.userId + '&aliasName=' + row.aliasName, "用户[" + row.aliasName + "]安全定位");
    }
</script>
</body>
</html>