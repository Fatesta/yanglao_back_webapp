<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
</head>
<body>
      <div id="tbrRecord">
        <form id="frmQuery">
            <table class="form">
               <tr>
                   <td>卡号</td>
                   <td>
                       <input name="cardCode" class="easyui-textbox" value="${cardCode}" />
                   </td>

                   <td>更换时间</td>
                   <td>
                       <input name="startCreateTime" class="easyui-datebox" style="width:90px;">
                       <span>到</span>
                       <input name="endCreateTime" class="easyui-datebox" style="width:90px;">
                   </td>
                   <td>
                       <a id="query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
                   </td>
               </tr>
            </table>
        </form>
      </div>
      <table id="dgRecord" class="easyui-datagrid" toolbar="#tbrRecord"
        data-options="
            url: '${urlPath}/user/vipcard/change/record.do',
            queryParams: {cardCode: '${cardCode}'}">
	    <thead>
	        <tr>
	            <th data-options="field:'aliasName', width: 100, halign: 'center', align:'left', formatter: formatters.aliasName">用户昵称</th>
	            <th data-options="field:'oldCardCode', width: 140, halign: 'center', align:'left'">旧卡号</th>
                <th data-options="field:'newCardCode', width: 140, halign: 'center', align:'left'">新卡号</th>
                <th data-options="field:'reasonType', width: 80, halign: 'center', align:'center', formatter: formatters.reasonType">更换原因</th>
                <th data-options="field:'createTime', width: 130, halign: 'center', align:'center'">更换时间</th>
                <th data-options="field:'operatorUsername', width: 100, halign: 'center', align:'left'">操作账号</th>
	            </tr>
	    </thead>
    </table>
      <script src="${modulePath}user/basicInfo.js?v=1"></script>
      <script src="${modulePath}user/vipcard/change/changeRecord.js?v=1"></script>
</body>
</html>