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
        <div data-options="title:'摄像头',iconCls:'icon-camera'" style="padding-left: 8px;">
		    <form id="cameraForm" method="post">
		        <input type="hidden" name="deviceCode">
		        <table class="form">
		            <tr>
		                <td>设备序列号</td>
		                <td><input class="easyui-textbox" name="cameraNo" data-options="validType:'length[0,40]'" ></td>
		            </tr>
		            <tr>
		                <td>设备9位序列号</td>
		                <td><input class="easyui-textbox" name="deviceSerial" data-options="validType:'length[9,9]'" ></td>
		            </tr>
		            <tr>
		                <td>设备6位验证码</td>
		                <td><input class="easyui-textbox" name="validateCode" data-options="validType:'length[6,6]'" ></td>
		            </tr>
		            <tr>
		                <td>查看权限</td>
		                <td><input class="easyui-combobox" name="isvalid" value="1"
		                    data-options="required:true,editable:false,valueField:'value',textField:'text',
		                                data:[{text:'无',value:0},{text:'有',value:1}]">
		                </td>
		            </tr>
		        </table>
		    </form>
            <a name="submit" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
        </div>
	    <div data-options="title:'智能电话机',iconCls:'icon-set'" style="padding-left: 8px;">
		    <form id="frmHostUserConfig" method="post">
		        <input type="hidden" name="userId" value="${userId}">
				<input type="hidden" name="bindUserType" value="1">
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
			                  queryParams: {userId: '${userId}'},
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
	    
	    <div data-options="title: '全天活动-区域项目',iconCls:'icon-set'">
	        <div id="tbrUserSensorLocConfig">
	            <table class="form">
	                <tr>
	                    <c:forEach var="func" items="${ROLE_FUNCS}">
	                        <c:if test="${func.code != 'user-setCamera'}">
	                        <td><a id="dailyActivity-${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a></td>
	                        </c:if>
	                    </c:forEach>
	                </tr>
	            </table>
	        </div>
			<table id="dgUserSensorConfig" class="easyui-datagrid"
			    data-options="url:'${urlPath }telecare/userConfig/sensorConfig/list.do',
			                  queryParams: {userId: '${userId}', sceneId: 1},
			                  pagination:false,
	                          fit: false,
			                  toolbar: '#tbrUserSensorLocConfig'" style="height:300px">
			    <thead>
			        <tr>
			            <th data-options="field:'location',width:'200',halign:'center'">区域</th>
			            <th data-options="field:'sensorType',width:'200',halign:'center', formatter: formatters.sensorTypes">传感器类型</th>
			            <th data-options="field:'defenceArea',width:'100',halign:'center'">防区编号</th>
			        </tr>
			    </thead>
			</table>
	    </div>
	    
	    <div data-options="title: '大门进出记录',iconCls:'icon-set'" style="padding-left: 8px;">
            <form id="frmUserDoorSensorConfig" method="post">
                <input type="hidden" name="sceneId" value="2">
                <input type="hidden" name="userId" value="${userId}">
                <input type="hidden" name="sensorType" value="MAGNETOMETER">
				<input type="hidden" name="defenceArea" value="9">
                <table class="form">
                    <tr>
                        <td>使用门磁传感器</td>
                        <td><input id="useDoorSensor" class="easyui-switchbutton" data-options="checked:false, onText:'是',offText:'否'" ></td>
                    </tr>
                </table>
            </form>
	    </div>
    </div>
    
    <script>
    var userId = '${userId}';
    var deviceCode = '${deviceCode}';
    $('.easyui-accordion').show();
    </script>
	<script src="${modulePath}anda/config.js?v=1.1"></script>
    <script src="${modulePath}telecare/userConfig/userConfig.js?v=1.1"></script>
</body>
</html>