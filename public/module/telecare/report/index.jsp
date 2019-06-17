<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
	<script src="${modulePath}video/VideoArrayWindow.js?v=1"></script>
	<script src="${libPath}socket.io.js"></script>
	<script src="${libPath}utils/require.js"></script>
	<script><jsp:include page="/lib/utils/require-config.js" /></script>

	<style>
	#telecare-report-layout [name=date],
	#telecare-report-layout [name=date] .validatebox-text {
		display: inline-block;
		font-weight: bold;
	}
	#telecare-report-layout .user-info,
	#telecare-report-layout .user-info .item {
	    margin-right: 20px;
	}
	#telecare-report-layout .ops {
		float: left;
		width: 150px;
		margin-top: 50px;
	}
	#telecare-report-layout .ops a {
		margin: 10px 0px 10px 0px;
	}
	</style>
</head>
<body id="telecare-report-layout" class="easyui-layout">
    <div data-options="region:'north'" data-options="border:false" style="height: 180px;display:none">
        <div class="user-info" style="float: left;line-height: 30px;margin-left: 4px">
			<table class="info-form">
				<tr style="font-size:1.25em;">
					<th style="width: 80px;">姓名：</th>
					<td colspan="3" style="width:40px;font-weight: bold;">
						<span name="realName" class="value"></span>
					</td>
				</tr>
				<tr>
					<th style="width: 60px">性别：</th>
					<td name="gender" class="value" style="width:40px"></td>
					<th style="width: 60px">年龄：</th>
					<td name="age" class="value" style="width:40px"></td>
				</tr>
				<tr>
					<th>身份证号码：</th>
					<td name="idcard" class="value" style="width:150px"></td>
					<th style="width: 60px">出生日期：</th>
					<td name="birthday" class="value"  style="width:90px"></td>
				</tr>
				<tr>
					<th>联系电话：</th>
					<td name="telphone" class="value" style="width:100px"></td>
					<th>所属社区：</th>
					<td name="orgName" class="value" style="width:140px"></td>
				</tr>
				<tr>
					<th>家庭地址：</th>
					<td colspan="3" name="address" class="value" style="width:400px"></td>
				</tr>
				<tr>
					<th>紧急联系人：</th>
					<td name="contactName" class="value" style="width:140px"></td>
					<th style="width: 80px">紧急联系电话：</th>
					<td name="contactTel" class="value" style="width:100px"></td>
				</tr>

			</table>
        </div>
		<div class="ops">
			<!--<a id="openHealthArchive" class="easyui-linkbutton" data-options="iconCls:'icon-health'">查看健康档案</a>-->
			<a id="openVideo" class="easyui-linkbutton" data-options="iconCls:'icon-camera'">实时视频监控</a>
		</div>
		<div name="date" style="float: right;margin: 4px 10px 4px 0">
			报告日期：<input class="easyui-datebox" name="date"
						data-options="value: moment().subtract(0, 'days').format('YYYY-MM-DD')"
						style="width: 100px;">
		</div>
    </div>
    <div data-options="region:'center'" data-options="border:false" style="display:none">
		<div id="telecare-report-tabs" class="easyui-tabs" data-options="fit:true,border:false">
			<!--<div title="全天活动">
				<%@ include file="dailyActivities.jsp" %>
			</div>-->
			<div title="活动水平">
				<%@ include file="activityLevel.jsp" %>
			</div>
		    <div title="步数与睡眠">
		        <%@ include file="stepAndSleep.jsp" %>
			</div>
			<div title="周报">
		        <%@ include file="weekStat.jsp" %>
			</div>
			<div title="大门打开记录">
				<%@ include file="doorOpen.jsp" %>
			</div>
			<div title="智能电话报警记录">
				<%@ include file="alarmRecord.jsp" %>
			</div>
		</div>
	</div>

    <script>
    var user = {
        userId: '${userId}',
		deviceCode: '${deviceCode}'
    };
    $(function() {
        require(['${modulePath}telecare/report/report.js?v=1'], function(m) {
            m({userId: user.userId});
        });
    });
    </script>
</body>
</html>