<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>

</head>
<body class="easyui-layout">
    <div id="tbr">
        <form id="frmQuery">
            <table class="form">
                <tr>
                    <td colspan="11">
                        <c:forEach var="func" items="${ROLE_FUNCS}">
                            <a id="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a>
                        </c:forEach>
                    </td>
                </tr>
                <tr>
                    <td>主机ID（智能电话机识别码）</td>
                    <td>
                        <input name="hostId" class="easyui-textbox" style="width:130px;"/>
                    </td>
                    <td>电话号码</td>
                    <td>
                        <input name="telNumber" class="easyui-textbox" style="width:100px;"/>
                    </td>
                    <td>绑定状态</td>
                    <td>
                        <input name="bounded" class="easyui-combobox"
                               data-options="
                                   data: [{text: '全部', value: -1}, {text: '未绑定', value: 0}, {text: '已绑定', value: 1}],
                                    value: -1"
                               style="width:70px;"/>
                    </td>
                    <td>
                        <a id="query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
                        <a id="add" class="easyui-linkbutton" data-options="iconCls:'icon-add'">增加</a>
                    </td>
                </tr>
            </table>
        </form>
    </div>
    <table id="dg" class="easyui-datagrid" toolbar="#tbr"
           data-options="
               url:'${urlPath }api/anda/host/page.do',
               pageSize: 30,
               fit:true">
        <thead>
        <tr>
            <th data-options="field:'hostId',width:130,halign:'center'">主机ID</th>
            <th data-options="field:'telNumber',width:100,align:'center',halign:'center'">电话号码</th>
            <th data-options="field:'bounded',width:100,align:'center',halign:'center', formatter: formatters.bounded">绑定状态</th>
            <th data-options="field:'bindUserInfo',width:260,halign:'center'">绑定对象信息</th>
            <th data-options="field:'-',width:300,align:'center', formatter: formatters.op">操作</th>
        </tr>
        </thead>
    </table>

    <script src="${modulePath}anda/host/index.js?v=1.1"></script>

</body>
</html>