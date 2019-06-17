<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
    <style>
        .section {
          margin-bottom: 10px;
        }
        .section h4 {
          font-size: 12px;
          font-weight: normal;
        }
    </style>
</head>
<body>
    <div class="easyui-accordion" data-options="fit:true,selected:-1" style="display:none">
	    <div data-options="title:'智能电话机',iconCls:'icon-set'" style="padding-left: 8px;">
		    <form id="frmHostUserConfig" method="post">
		        <input type="hidden" name="userId" value="${berthId}">
				<input type="hidden" name="bindUserType" value="2">
		        <table class="form">
		            <tr>
		                <td>主机ID</td>
		                <td><input class="easyui-textbox" name="hostId" data-options="validType:'length[16,16]'" style="width:140px" ></td>
		            </tr>
		        </table>
		    </form>
			<a id="bind" class="easyui-linkbutton" data-options="iconCls:'icon-set'">绑定</a>
			<a id="unbind" class="easyui-linkbutton" data-options="iconCls:'icon-set'">解绑</a>
	    </div>

		<div data-options="title:'报警通知手机号码',iconCls:'icon-set'">
			<div id="tbrAlarmNoticePhoneConfig">
				<table class="form">
					<tr>
						<td><a id="alarmNoticePhoneAdd" class="easyui-linkbutton" data-options="iconCls:'icon-add'">增加</a></td>
					</tr>
				</table>
			</div>
			<table id="dgAlarmNoticePhone" class="easyui-datagrid"
				   data-options="url:'${urlPath }anda/alarmNoticePhone/getByUserId.do',
			                  queryParams: {userId: '${berthId}'},
			                  pagination:false,
	                          fit: false,
			                  toolbar: '#tbrAlarmNoticePhoneConfig'" style="height:300px">
				<thead>
				<tr>
					<th data-options="field:'phone',width:'100',halign:'center'">手机号码</th>
					<th data-options="field:'memo',width:'300',halign:'center'">号码备注</th>
					<th data-options="field:'op',width:'60',halign:'center', formatter: AlarmNoticePhoneManage.formatters.op">操作</th>
				</tr>
				</thead>
			</table>
		</div>
    </div>
    
    <script>
    var berthId = '${berthId}';
    $('.easyui-accordion').show();
    </script>
	<script src="${modulePath}anda/config.js?v=1.1"></script>
    <script src="${modulePath}community/berth/berthDevice/config.js?v=1.1"></script>
</body>
</html>