<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
    <table id="dgConsumeCard" class="easyui-datagrid"
        data-options="
            url: '${urlPath}user/purse/get.do?userId=${userId}',
            fit: true,
            pagination: false,
            loadFilter: function(data) {
                return {rows: data.cardList, total: data.cardList.length};
            }">
        <thead>
            <tr>
                <th data-options="field:'cardName', width:'16%', halign:'center', align:'left'">卡名称</th>
                <th data-options="field:'cardNumber',width:'100px',halign:'center'">卡号</th>
                <th data-options="field:'coverImage', width:'6%', halign:'center', align:'center', formatter: UICommon.datagrid.formatter.generators.image({height: 30})">封面图片</th>
                <th data-options="field:'contactNumber', width:'10%', halign:'center', align:'left'">联系电话</th>
                <th data-options="field:'price', width:'6%', halign:'center', align:'left', formatter: UICommon.datagrid.formatter.money">价格</th>
                <th data-options="field:'startTime', width:'14%', halign:'center', align:'left', formatter: UICommon.datagrid.formatter.generators.substring(0, 19)">有效开始时间</th>
                <th data-options="field:'endTime', width:'14%', halign:'center', align:'left', formatter: UICommon.datagrid.formatter.generators.substring(0, 19)">有效结束时间</th>
            </tr>
        </thead>
    </table>
</body>
</html>