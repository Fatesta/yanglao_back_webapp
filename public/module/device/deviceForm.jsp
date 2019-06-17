<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
    <script src="${libPath}utils/require.js"></script>
    <script><%@ include file="/lib/utils/require-config.js" %></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
	td.form {
		padding-top: 10px;
		padding-bottom: 10px;
	}
</style>
</head>
<body>
<div class="easyui-accordion" data-options="fit:true" style="display:none">
    <div title="设备信息" data-options="iconCls:'icon-equipment',selected:true" style="overflow:auto;padding:10px;">
        <form id="deviceForm" method="post">
	    	<input type="hidden" name="id" value="${device.deviceId }">
		    <table class="form">
		    	<tr>
		    		<td><label for="deviceCode">设备号</label></td>
		    		<td><input class="easyui-textbox" name="deviceCode" value="${device.deviceCode}" data-options="readonly:true"></td>
		    		<td><label for="fwVersion">固件版本</label></td>
		    		<td><input class="easyui-textbox" name="fwVersion" value="${device.fwVersion}" data-options="readonly:true"></td>
		    	</tr>
                <tr>
                    <td><label for="fwVersion">设备类型</label></td>
                    <td><input class="easyui-textbox" name="deviceType" value="${device.deviceType}" data-options="readonly:true"></td>
                    <td></td>
                    <td></td>
                </tr>
		    	<tr>
		    		<td><label for="passwd">昵称</label></td>
		    		<td><input class="easyui-textbox" name="aliasName" value="${device.aliasName}" data-options="readonly:true"></td>
		    		<td><label for="telphone">手机号</label></td>
		    		<td><input class="easyui-textbox" name="telphone" value="${device.telphone}" data-options="readonly:true" ></td>
		    	</tr>
		    	<tr>
		    		<td><label for="registerTime">注册时间</label></td>
		    		<td><input class="easyui-datetimebox" type="text" name="registerTime" value="<fmt:formatDate value="${device.registerTime}" pattern="yyyy-MM-dd HH:mm:ss"/>" data-options="readonly:true"></td>
		    		<td><label for="updateTime">更新时间</label></td>
		    		<td><input class="easyui-datetimebox" name="updateTime" value="<fmt:formatDate value="${device.updateTime }" pattern="yyyy-MM-dd HH:mm:ss"/>" data-options="readonly:true"></td>
		    	</tr>
		    	<tr>
		    		<td><label for="isShutDown">定时开关机</label></td>
		    		<td><input type="checkbox" name="isTimingOnOff" <c:if test="${device.isTimingOnOff == 1}">checked="checked"</c:if> disabled="disabled" ></td>
		    		<td><label for="isShutDown">在线状态</label></td>
		    		<td><input class="easyui-textbox" name="isShutDown" value='${device.isShutDown == 0 ? "离线" : "在线"}' data-options="readonly:true" ></td>
		    	</tr>
		    	<tr>
		    		<td><label for="ontime">开机时间</label></td>
		    		<td><input class="easyui-timespinner" name="ontime" value='${device.ontime}' data-options="readonly:true,showSeconds:true" ></td>
		    		<td><label for="offtime">关机时间</label></td>
		    		<td><input class="easyui-timespinner" name="offtime" value='${device.offtime}' data-options="readonly:true,showSeconds:true" ></td>
		    	</tr>
		    	<tr>
		    		<td><label for="isOpenGps">开启GPS</label></td>
		    		<td><input type="checkbox" name="isOpenGps" <c:if test="${device.isOpenGps == 1}">checked="checked"</c:if> disabled="disabled" ></td>
		    		<td><label for="positionInterval">位置上传间隔</label></td> 
		    		<td><input class="easyui-numberbox" name="positionInterval" value='${device.positionInterval}' data-options="readonly:true,suffix:'秒'"></td>
		    	</tr>
		    	<tr>
		    		<td><label for="isUseWhitelist">启用白名单</label></td>
		    		<td><input type="checkbox" name="isUseWhitelist" <c:if test="${device.isUseWhitelist == 1}">checked="checked"</c:if> disabled="disabled" ></td>
		    		<td><label for="expectStep">期望计步数</label></td>
		    		<td><input class="easyui-numberbox" name="expectStep" value="${device.expectStep}" data-options="readonly:true,suffix:'步'"></td>
		    		<%-- <td><label for="isUseBlacklist">启用黑名单</label></td> 
		    		<td><input type="checkbox" name="isUseBlacklist" <c:if test="${device.isUseBlacklist == 1}">checked="checked"</c:if> disabled="disabled" ></td> --%>
		    	</tr>
		    	<tr>
		    		<td><label for="batteryStatus">充电状态</label></td>
		    		<td><input class="easyui-textbox" name="batteryStatus" value='${device.batteryStatus == 0 ? "未充电" : "充电中"}' data-options="readonly:true" ></td>
		    		<td><label for="battery">电量</label></td> 
		    		<td><input class="easyui-numberbox" name="battery" value='${device.battery}' data-options="readonly:true,suffix:'%'"></td>
		    	</tr>
		    	<tr>
		    		<td><label for="isMuteMode">开启静默模式</label></td>
		    		<td><input type="checkbox" name="isMuteMode" <c:if test="${device.isMuteMode == 1}">checked="checked"</c:if> disabled="disabled" ></td>
		    		<td><label for="muteModeStatus">是否静默</label></td>
		    		<td>
			    		<input type="radio" name="muteModeStatus" value="1" disabled="disabled" <c:if test="${device.muteModeStatus == 1}">checked="checked"</c:if>>是
			    		<input type="radio" name="muteModeStatus" value="0" disabled="disabled" <c:if test="${device.muteModeStatus == 0}">checked="checked"</c:if>>否
					</td>
		    	</tr>
		    	<tr>
		    		<td><label for="speechRecognitionStatus">开启语音识别</label></td> 
		    		<td><input type="checkbox" name="speechRecognitionStatus" <c:if test="${device.speechRecognitionStatus == 1}">checked="checked"</c:if> disabled="disabled" ></td>
		    		<td><label for="language">语言种类</label></td>
		    		<td>
		    			<c:choose>
		    				<c:when test="${device.language == 'zh'}">
		    					<input class="easyui-textbox" name="language" value='普通话' data-options="readonly:true" >		
		    				</c:when>
		    				<c:otherwise>
		    					<input class="easyui-textbox" name="language" value='粤语' data-options="readonly:true" >		
		    				</c:otherwise>
		    			</c:choose>
		    		</td>
		    	</tr>
		    	
		    	<tr>
		    		<td><label for="volume">音量</label></td> 
		    		<td>
		    			<input class="easyui-slider" name="volume" value='${device.volume}' style="width:300px" 
		    			data-options="min:0,max:100,disabled:true,showTip:true,rule: [0,1,2,3,4,5,6],converter:{
							toPosition:function(value, size){
								if (value == 0) {
									return 0;
								} else if (value == 33) {
									return 50;
								} else if (value == 50) {
									return 100;
								} else if (value == 67) {
									return 150;
								} else if (value == 84) {
									return 200;
								} else if (value == 99) {
									return 250;
								} else {
									return 300;
								}
							},
							toValue:function(pos, size){
								if (pos < 25) {
									return 0;
								} else if (pos < 75) {
									return 33;
								} else if (pos < 125) {
									return 50;
								} else if (pos < 175) {
									return 67;
								} else if (pos < 225) {
									return 84;
								} else if (pos < 275) {
									return 99;
								} else {
									return 100;
								}
							}
						},tipFormatter:function(value){
							if (value == 0) {
								return 0;
							} else if (value == 33) {
								return 1;
							} else if (value == 50) {
								return 2;
							} else if (value == 67) {
								return 3;
							} else if (value == 84) {
								return 4;
							} else if (value == 99) {
								return 5;
							} else {
								return 6;
							}
						}">
		    		</td>
		    		<td></td>
		    		<td></td>
		    	</tr>
                <tr>
                    <td colspan="4" rowdiv="8" class="form"><img src="${urlPath }device/getCodeImg.do?deviceCode=${device.deviceCode}"></td>
                </tr>
		    </table>
		</form>
    </div>
   	<div id="telBook" title="亲情号" data-options="iconCls:'icon-tel',onClickCell: device.telbook.onClickCell,onEndEdit: device.telbook.onEndEdit" style="padding: 10px;">
		<div id="telBookToolBar" style="height: auto">
		    <c:forEach var="func" items="${ROLE_FUNC_MAP['device.telbook'].children}">
			 <a href="javascript:void(0)" class="easyui-linkbutton"
				data-options="iconCls:'${func.icon}',plain:true" onclick="${func.code}()">${func.funcName}</a>
			</c:forEach>
		</div>
		<table id="dg" class="easyui-datagrid"
			data-options="
                iconCls: 'icon-edit',
                url:'${urlPath }device/listTelBook.do?deviceId=${device.deviceId }',
                method: 'get',
                toolbar:'#telBookToolBar'
                ">
			<thead>
				<tr>
					<th
						data-options="field:'telephone',halign:'center',width:200,editor:{type:'textbox',options:{required:true}}">手机号</th>
					<th
						data-options="field:'aliasName',halign:'center',width:150,editor:{type:'textbox',options:{required:true,validType:'length[1,50]'}}">昵称</th>
					<th
						data-options="field:'status',halign:'center',width:50,formatter:formatStatus">内置</th>
					<th
						data-options="field:'-',halign:'center',width:50,formatter:formatOp">操作</th>
				</tr>
			</thead>
		</table>
		<script>
		var device = {};
			function up(/*deviceId, telephone*/index) {
				$("#dg").datagrid("shiftRow", {
					index : index,
					direction : "up"
				});
			}

			function down(/*deviceId, telephone*/index) {
				$("#dg").datagrid("shiftRow", {
					index : index,
					direction : "down"
				});
			}

			function move(deviceId, telephone, direction) {
				/* post("${urlPath}device/moveTelBook.do", {
					deviceId : deviceId,
					telephone : telephone,
					direction : direction
				}, function() {
					$("#dg").datagrid("load", {});
				}, "json"); */
			}

			function formatOp(value, row, index) {
				var btn = '';
				/* var upBtn = '<a href="#" title="上移" class="easyui-linkbutton" data-options="iconCls:\'color:fff\'" onclick="up(\'${device.deviceId}\',\''
						+ row.telephone
						+ '\')"><div class=\'icon-up\'>&nbsp;</div></a>';
				var downBtn = '<a href="#" title="下移" class="easyui-linkbutton" data-options="iconCls:\'color:fff\'" onclick="down(\'${device.deviceId}\',\''
						+ row.telephone
						+ '\')"><div class=\'icon-down\'>&nbsp;</div></a>'; */
				var upBtn = '<a href="#" title="上移" class="easyui-linkbutton" data-options="iconCls:\'color:fff\'" onclick="up(\'' + index + '\')"><div class=\'icon-up\'>&nbsp;</div></a>';
				var downBtn = '<a href="#" title="下移" class="easyui-linkbutton" data-options="iconCls:\'color:fff\'" onclick="down(\'' + index + '\')"><div class=\'icon-down\'>&nbsp;</div></a>';
				var rowNums = $("#dg").datagrid("getRows").length;
				if (rowNums > 1) {
					if (index == 0) {
						btn = downBtn;
					} else if (index == rowNums - 1) {
						btn = upBtn;
					} else {
						btn = upBtn + downBtn;
					}
				}
				return btn;
			}

			function formatStatus(value, row, index) {
				if (value == 1) {
					return "<div class='icon-enable'>&nbsp</div>";
				}
				return "<div class='icon-disable'>&nbsp</div>";
			}

			device.telbook = {
				editIndex:undefined,
				endEditing:function () {
					if (device.telbook.editIndex == undefined) {
						return true
					}
					if ($('#dg').datagrid('validateRow', device.telbook.editIndex)) {
						$('#dg').datagrid('endEdit', device.telbook.editIndex);
						device.telbook.editIndex = undefined;
						return true;
					} else {
						return false;
					}
				},
				onClickCell:function (index, field) {
					if (device.telbook.editIndex != index) {
						if (device.telbook.endEditing()) {
							$('#dg').datagrid('selectRow', index).datagrid(
									'beginEdit', index);
							var ed = $('#dg').datagrid('getEditor', {
								index : index,
								field : field
							});
							if (ed) {
								($(ed.target).data('textbox') ? $(ed.target)
										.textbox('textbox') : $(ed.target))
										.focus();
							}
							device.telbook.editIndex = index;
						} else {
							setTimeout(function() {
								$('#dg').datagrid('selectRow', device.telbook.editIndex);
							}, 0);
						}
					}
				},onEndEdit:function (index, row) {
					var ed = $(this).datagrid('getEditor', {
						index : index,
						field : 'productid'
					});
					row.productname = $(ed.target).combobox('getText');
				},
				add:function () {
					if (device.telbook.endEditing()) {
						$('#dg').datagrid('appendRow', {
							status : '0',
							deviceId : '${device.deviceId }'
						});
						device.telbook.editIndex = $('#dg').datagrid('getRows').length - 1;
						$('#dg').datagrid('selectRow', device.telbook.editIndex).datagrid(
								'beginEdit', device.telbook.editIndex);
					}
				},
				'delete':function () {
					var row = $('#dg').datagrid('getSelected');
					if (!row) {
						showAlert("操作失败", "必须选中一行才能进行删除操作！");
						return false;
					}
					if (row['status'] == 1) {
						showAlert("操作失败", "不能删除系统内置号码！");
						return false;
					}
					var idx = $('#dg').datagrid('getRowIndex', row);
					$('#dg').datagrid('deleteRow', idx);
				},
				save:function () {
					if (device.telbook.endEditing()) {
						$('#dg').datagrid('acceptChanges');
						var rows = $('#dg').datagrid('getRows');
						var nums = "";
						for (var i = 0; i < rows.length; i++) {
							var clientId = rows[i].clientId;
							if (!rows[i].clientId) {
								clientId = "";
							}
							nums = nums + "{" + "\"clientId\":\"" + clientId
									+ "\"," + "\"name\":\""
									+ Base64.encode(rows[i].aliasName, true)
									+ "\"," + "\"phoneNumber\":\""
									+ rows[i].telephone + "\"," + "\"status\":"
									+ rows[i].status + "},";
						}
						if (nums.length > 0) {
							nums = nums.substring(0, nums.length - 1);
						}
						var json = "{"
								+ "\"groupId\":\"\","
								+ "\"devices\":[{\"deviceId\":\"${device.deviceId }\"}],"
								+ "\"phoneNumbers\":[" + nums + "]" + "}";

						post("${urlPath}device/setTelBook.do", {
							json : json
						}, function(data) {
							if (data.success) {
								showMessage("操作提示", "操作成功！");
								$('#dg').datagrid("reload");
							} else {
								showAlert("操作提示", "操作失败！");
							}
						}, "json");
					}
				},
				cancel:function () {
					$('#dg').datagrid('rejectChanges');
					device.telbook.editIndex = undefined;
				},
				getChanges:function () {
					var rows = $('#dg').datagrid('getChanges');
					alert(rows.length + ' rows are changed!');
				}
			}
		</script>
	</div>
	<div title="白名单" data-options="iconCls:'icon-whitelist'" style="overflow:auto;padding:10px;">
    	<div id="whiteListToolBar" style="height: auto">
			<table class="form">
				<tr>
                    <c:forEach var="func" items="${ROLE_FUNC_MAP['device.whitelist'].children}">
                     <c:if test="${func.code == 'device.whitelist.enable'}">
                       <c:set var="deviceWhiteListEnableFuncEnable" value="true"/>
                     </c:if>
                    </c:forEach>
				    <c:if test="${deviceWhiteListEnableFuncEnable}">
					<td style="width:50px">启用状态</td>
					<td>
						<input id="whiteListSwitchBtn" class="easyui-switchbutton" data-options="onText:'启用',offText:'禁用'" 
							<c:if test="${device.isUseWhitelist == 1}"> checked </c:if> >
					</td>
					</c:if>
				</tr>
				<tr><td colspan="2">
		            <c:forEach var="func" items="${ROLE_FUNC_MAP['device.whitelist'].children}">
		             <c:if test="${func.code != 'device.whitelist.enable'}">
		               <a href="javascript:void(0)" class="easyui-linkbutton"
		                  data-options="iconCls:'${func.icon}',plain:true" onclick="${func.code}()">${func.funcName}</a>
		             </c:if>
		            </c:forEach></td>
				</tr>
			</table>	
		</div>
		<table id="dg2" class="easyui-datagrid"
			data-options="
                iconCls: 'icon-edit',
                url:'${urlPath }device/listWhiteList.do?deviceId=${device.deviceId }',
                method: 'get',
                toolbar:'#whiteListToolBar',onClickCell: device.whitelist.onClickCell
                ">
			<thead>
				<tr>
					<th data-options="field:'telephone',halign:'center',width:200,editor:{type:'textbox',options:{required:true}}">手机号</th>
					<th data-options="field:'aliasName',halign:'center',width:150,editor:{type:'textbox',options:{required:true,validType:'length[1,50]'}}">昵称</th>
                    <th data-options="field:'status',halign:'center',width:50,formatter:formatStatus">内置</th>
				</tr>
			</thead>
		</table>
		<script>
			device.whitelist = {
				editIndex : undefined,
				endEditing : function () {
					if (device.whitelist.editIndex == undefined) {
						return true
					}
					if ($('#dg2').datagrid('validateRow', device.whitelist.editIndex)) {
						$('#dg2').datagrid('endEdit', device.whitelist.editIndex);
						device.whitelist.editIndex = undefined;
						return true;
					} else {
						return false;
					}
				},
				onClickCell:function (index, field) {
					if (device.whitelist.editIndex != index) {
						if (device.whitelist.endEditing()) {
							$('#dg2').datagrid('selectRow', index).datagrid(
									'beginEdit', index);
							var ed = $('#dg2').datagrid('getEditor', {
								index : index,
								field : field
							});
							if (ed) {
								($(ed.target).data('textbox') ? $(ed.target)
										.textbox('textbox') : $(ed.target))
										.focus();
							}
							device.whitelist.editIndex = index;
						} else {
							setTimeout(function() {
								$('#dg2').datagrid('selectRow', device.whitelist.editIndex);
							}, 0);
						}
					}
				},
				onEndEdit:function (index, row) {
					var ed = $(this).datagrid('getEditor', {
						index : index,
						field : 'productid'
					});
					row.productname = $(ed.target).combobox('getText');
				},add:function () {
					if (device.whitelist.endEditing()) {
						$('#dg2').datagrid('appendRow', {
							status : '0',
							deviceId : '${device.deviceId }'
						});
						device.whitelist.editIndex = $('#dg').datagrid('getRows').length - 1;
						$('#dg2').datagrid('selectRow', device.whitelist.editIndex).datagrid(
								'beginEdit', device.whitelist.editIndex);
					}
				},'delete':function () {
					var row = $('#dg2').datagrid('getSelected');
					if (!row) {
						showAlert("操作失败", "必须选中一行才能进行删除操作！");
						return false;
					}
					if (row['status'] == 1) {
						showAlert("操作失败", "不能删除系统内置号码！");
						return false;
					}
					var idx = $('#dg2').datagrid('getRowIndex', row);
					$('#dg2').datagrid('deleteRow', idx);
				},save:function () {
					if (device.whitelist.endEditing()) {
						$('#dg2').datagrid('acceptChanges');
						var rows = $('#dg2').datagrid('getRows');
						var records = [];
						var nums = "";
						for (var i = 0; i < rows.length; i++) {
							var clientId = rows[i].clientId;
							if (!rows[i].clientId) {
								clientId = "";
							}
							records.push({
							    clientId: clientId,
							    name: Base64.encode(rows[i].aliasName, true),
							    phoneNumber: rows[i].telephone,
							    status: rows[i].status
							});
						}

						
						var data = {
						    action: ($("#whiteListSwitchBtn").switchbutton("options").checked ? 1 : 0),
						    groupId: "",
						    devices: [{deviceId: '${device.deviceId }'}],
						    phoneNumbers: records
						};

						post("${urlPath}device/setWhiteList.do", {
							json : JSON.stringify(data)
						}, function(data) {
							if (data.success) {
								showMessage("操作提示", "操作成功！");
								$('#dg2').datagrid("reload");
							} else {
								showAlert("操作提示", "操作失败！");
							}
						}, "json");
					}
				},cancel:function () {
					$('#dg2').datagrid('rejectChanges');
					device.whitelist.editIndex = undefined;
				},getChanges:function () {
					var rows = $('#dg2').datagrid('getChanges');
					alert(rows.length + ' rows are changed!');
				}
			};
			
		</script>
    </div>
	<div title="定时开关机" data-options="iconCls:'icon-on-off'" style="overflow:auto;padding:10px;">
        <form id="timeSettingForm" method="post">
	    	<input type="hidden" name="deviceId" value="${device.deviceId }">
		    <table class="form">
		    	<tr>
		    		<td>
		    		    <c:if test="${not empty ROLE_FUNC_MAP['device.setTimeSetting']}">
		    			<a class="easyui-linkbutton" data-options="iconCls:'icon-save',onClick:setTimeSetting">保存</a>
		    			</c:if>
		    		</td>
		    		<td></td>
		    		<td></td>
		    		<td></td>
		    	</tr>
		    	<tr>
		    		<td><label for="isShutDown">定时开关机</label></td>
		    		<td><input type="checkbox" name="isTimingOnOff" <c:if test="${device.isTimingOnOff == 1}">checked="true"</c:if>></td>
		    		<td></td>
		    		<td></td>
		    	</tr>
		    	<tr>
		    		<td><label for="ontime">开机时间</label></td>
		    		<td><input class="easyui-timespinner" name="ontime" value='${device.ontime}' data-options="required:true,showSeconds:false" ></td>
		    		<td><label for="offtime">关机时间</label></td>
		    		<td><input class="easyui-timespinner" name="offtime" value='${device.offtime}' data-options="required:true,showSeconds:false" ></td>
		    	</tr>
		    </table>
		</form>
		<script>
			
			function setTimeSetting(){
				var $form = $("#timeSettingForm");
				var valid = $form.form("validate");
				if (valid) {
					var json = "{" + 
									"\"groupId\":\"\"," + 
					    			"\"action\":" + ($("#timeSettingForm [name=isTimingOnOff]").get(0).checked ? 1 : 0) + "," +
					    			"\"onTime\":\"" + $("#timeSettingForm [name=ontime]").val() + ":00" + "\"," + 
					    			"\"offTime\":\"" + $("#timeSettingForm [name=offtime]").val() + ":00" + "\"," + 
					    			"\"devices\":[" +
		          						"{" +
		            						"\"deviceId\":\"" + $("#timeSettingForm [name=deviceId]").val() + "\"" +
		        						"}" +
					    			"]" +
								"}";
					post("${urlPath}device/setTimeSetting.do", {json:json}, function(data){
						if (data.success) {
				    		showMessage('系统提示', data.message);
				    	} else {
				    		showAlert("错误提示", data.message, 'error');
				    	}
					}, "json");
				}
			}
		
		</script>
    </div>
    <div title="静默模式" data-options="iconCls:'icon-off-volume'" style="overflow:auto;padding:10px;">
        <form id="muteModeForm" method="post">
	    	<input type="hidden" name="deviceId" value="${device.deviceId }">
		    <table class="form">
		    	<tr>
		    		<td colspan="6">
		    		    <c:forEach var="func" items="${ROLE_FUNC_MAP['device.muteMode'].children}">
			    			<c:if test="${func.code == 'device.muteMode.save'}">
			    			<a class="easyui-linkbutton" data-options="iconCls:'icon-save',onClick:saveMuteMode">保存</a>
			    			</c:if>
			    			<c:if test="${func.code == 'device.muteMode.add'}">
			    			<a class="easyui-linkbutton" data-options="iconCls:'icon-add',onClick:addMuteMode">新增</a>
			    			</c:if>
		    			</c:forEach>
		    		</td>
		    	</tr>
		    	<tr>
		    		<td>
		    			<label>静默模式</label>
		    			<input id="muteModeSwitchBtn" class="easyui-switchbutton" data-options="onText:'开',offText:'关'" <c:if test="${device.isMuteMode == 1}"> checked </c:if> >
		    		</td>
		    		<td colspan="5">
		    			重复
			    		<input id="muteModeDay" type="hidden" name="weekDay" value="${muteModes.size() == 0 ? '0000000' :muteModes[0].weekDay }">
						<a href="#" data-options="text:'日'"></a>
						<a href="#" data-options="text:'一'"></a>
						<a href="#" data-options="text:'二'"></a>
						<a href="#" data-options="text:'三'"></a>
						<a href="#" data-options="text:'四'"></a>
						<a href="#" data-options="text:'五'"></a>
						<a href="#" data-options="text:'六'"></a>
		    		</td>
		    	</tr>
		    	<c:forEach items="${muteModes }" var="muteMode" varStatus="st">
			    	<tr>
			    		<td><label class="muteModeNum">模式${(st.index + 1)}</label></td>
			    		<td><label>时间:</label></td>
			    		<td><input class="easyui-timespinner" name="startTime" value="${muteMode.startTime }" data-options="required:true,showSeconds:false" ></td>
			    		<td><label>-</label></td>
			    		<td><input class="easyui-timespinner" name="endTime" value="${muteMode.endTime }" data-options="required:true,showSeconds:false" ></td>
			    		<td><a class="easyui-linkbutton" data-options="iconCls:'icon-delete',onClick:deleteMuteMode"></a></td>
			    	</tr>
		    	</c:forEach>
		    </table>
		    <%-- <div>
		    	重复
	    		<input id="muteModeDay" type="hidden" name="weekDay" value="${muteModes.size() == 0 ? '0000000' :muteModes[0].weekDay }">
				<a href="#" data-options="text:'日'"></a>
				<a href="#" data-options="text:'一'"></a>
				<a href="#" data-options="text:'二'"></a>
				<a href="#" data-options="text:'三'"></a>
				<a href="#" data-options="text:'四'"></a>
				<a href="#" data-options="text:'五'"></a>
				<a href="#" data-options="text:'六'"></a>
		    </div> --%>
		</form>
		<script>
			
			$(function(){
				
				var $day = $("#muteModeDay");
    			var day = $day.val();
    			var btns = $day.siblings("a");
    			$(btns).css("font-color", "white");
    			$(btns).css("background-color", "gray");
    			for (var i = 0; i < day.length; i++) {
    				var selected = day.charAt(i);
    				var $btn = $(btns[i]);
    				$btn.linkbutton({
    					selected : selected == 1,
						toggle : true,
    				    onClick : selectDay
    				});
    				$btn.css("background-color", "#01B468");
    				$(btns).css("font-weight", "bold");
    			}
				
			});
			
			function selectDay() {
    			var $input = $($(this).siblings("input")[0]);
    			var $btns = $input.siblings("a");
    			var text = "";
    			$btns.each(function (index, domEle){
    				var ops = $(domEle).linkbutton("options");
					text = text + (ops.selected ? '1' : '0');     				
    			});
    			$input.val(text);
    		}
		
			function addMuteMode() {
				var $tbody = $("#muteModeForm").children("table").children("tbody");
				var dom = "<tr>" + 
	    				  	"<td class=\"form\"><label class=\"muteModeNum\"></label></td>" +
	    					"<td class=\"form\"><label>时间:</label></td>" +
	    					"<td class=\"form\"><input class=\"easyui-timespinner\" name=\"startTime\" data-options=\"required:true,showSeconds:false\" ></td>" +
	    					"<td class=\"form\"><label>-</label></td>" +
	    					"<td class=\"form\"><input class=\"easyui-timespinner\" name=\"endTime\" data-options=\"required:true,showSeconds:false\" ></td>" +
	    					"<td class=\"form\"><a class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-delete',onClick:deleteMuteMode\"></a></td>" +
	    				   "</tr>";
				$tbody.append(dom);
				$.parser.parse($("#muteModeForm"));
				resetMuteModeNum();
			}
			
			function deleteMuteMode() {
				var $muteMode = $(this).parent().parent();
				$muteMode.remove();
				resetMuteModeNum();
			}
			
			function resetMuteModeNum() {
				$(".muteModeNum").each(function(idx, dom){
					$(dom).text("模式" + (idx + 1));
				});
			}
			
			function saveMuteMode() {
				var valid = $("#muteModeForm").form("validate");
				if (valid) {
					var arr = $("#muteModeForm").serializeArray();
					var params = {};
					$.each(arr, function(idx, val){
						var value = val.value;
						if (val.name == "startTime" || val.name == "endTime") {
							if (params[val.name]) {
								// 向数组中添加值
								params[val.name].push(value + ":00");
							} else {
								// 创建新数组
								params[val.name] = [value + ":00"];
							}
						} else {
							params[val.name] = value;
						}
					});
					
					// 修改节点
					params.devices = [{"deviceId" : params.deviceId}];
					delete params.deviceId
					params.muteModeList = [];
					if (params.startTime) {
						$.each(params.startTime, function(i, v){
							var o = {};
							o.startTime = v;
							o.endTime = params.endTime[i];
							params.muteModeList.push(o);
						});
						delete params.startTime;
						delete params.endTime;
					}
					params.groupId = "";
					params.action = $("#muteModeSwitchBtn").switchbutton("options").checked ? 1 : 0;
					
					post("${urlPath }device/saveMuteMode.do", {json:$.objToStr(params)}, function(data){
						if (data.success) {
				    		showMessage('系统提示', data.message);
				    	} else {
				    		showAlert("错误提示",data.message,'error');
				    	}
					}, "json");
				}
			}
			
		
		</script>
    </div>
    <div title="音量" data-options="iconCls:'icon-volume-setting'" style="overflow:auto;padding:10px;">
    	<form id="volumeForm" method="post">
	    	<input type="hidden" name="deviceId" value="${device.deviceId }">
	    	<table>
	    		<tr>
	    			<td><label for="volume">音量</label></td> 
		    		<td><input class="easyui-slider" name="volume" value='${device.volume}' style="width:300px" 
		    			data-options="min:0,max:100,showTip:true,rule: [0,1,2,3,4,5,6],converter:{
							toPosition:function(value, size){
								if (value == 0) {
									return 0;
								} else if (value == 33) {
									return 50;
								} else if (value == 50) {
									return 100;
								} else if (value == 67) {
									return 150;
								} else if (value == 84) {
									return 200;
								} else if (value == 99) {
									return 250;
								} else {
									return 300;
								}
							},
							toValue:function(pos, size){
								if (pos < 25) {
									return 0;
								} else if (pos < 75) {
									return 33;
								} else if (pos < 125) {
									return 50;
								} else if (pos < 175) {
									return 67;
								} else if (pos < 225) {
									return 84;
								} else if (pos < 275) {
									return 99;
								} else {
									return 100;
								}
							}
						},tipFormatter:function(value){
							if (value == 0) {
								return 0;
							} else if (value == 33) {
								return 1;
							} else if (value == 50) {
								return 2;
							} else if (value == 67) {
								return 3;
							} else if (value == 84) {
								return 4;
							} else if (value == 99) {
								return 5;
							} else {
								return 6;
							}
						},onChange:function(newValue, oldValue){
							var params = {};
							params.groupId = '';
							params.devices = [{'deviceId':'${device.deviceId }'}];
							params.volume = newValue;
							var json = $.objToStr(params);
							post('${urlPath }device/changeVolume.do', {json:json}, function(data){
								if (data.success) {
						    		showMessage('系统提示', data.message);
						    	} else {
						    		showAlert('错误提示',data.message,'error');
						    	}
							}, 'json');
						}">
					</td>
	    		</tr>
	    	</table>
	    </form>
    </div>
    <div title="定位模式" data-options="iconCls:'icon-location'" style="overflow:auto;padding:10px;">
    	<form id="positionModeForm">
    	<input type="hidden" name="deviceId" value="${device.deviceId }">
    	<table class="form">
    		<tr>
    		  <c:if test="${not empty ROLE_FUNC_MAP['device.savePositionMode']}">
    			<td>
    			<a class="easyui-linkbutton" data-options="iconCls:'icon-save',onClick:savePositionMode">保存</a></td>
    			</td>
    		  </c:if>
    		</tr>
    		<tr>
    			<td><input type="radio" name="positionMode" value="600" <c:if test="${device.positionInterval==600 }"> checked="checked" </c:if>>正常模式</td>
    			<td>定位频率正常，10分钟上传一次位置信息</td>
    		</tr>
    		<tr>
    			<td><input type="radio" name="positionMode" value="900" <c:if test="${device.positionInterval==900 }"> checked="checked" </c:if>>省电模式</td>
    			<td>定位频率低，15分钟上传一次位置信息</td>
    		</tr>
    	</table>
    	</form>
    	<script>
    		function savePositionMode() {
    			var arr = $("#positionModeForm").serializeArray();
    			if (arr.length == 1) {
    				showAlert("操作提示", "请选择定位模式！", "error");
    				return false;
    			}
    			var params = {};
    			params.groupId = "";
    			params.devices = [{"deviceId":arr[0].value}];
    			params.interval = arr[1].value;
    			var json = $.objToStr(params);
				post('${urlPath }device/savePositionMode.do', {json:json}, function(data){
					if (data.success) {
			    		showMessage('系统提示', data.message);
			    	} else {
			    		showAlert('错误提示',data.message,'error');
			    	}
				}, 'json');
    		}
    	
    	</script>
    </div>
    <div title="通话记录" data-options="iconCls:'icon-call-record'" style="overflow:auto;padding:10px;">
		<table id="callRecordGrid" class="easyui-datagrid"
			data-options="url:'${urlPath }device/listCallRecord.do?deviceCode=${device.deviceCode }',
						  fit:true,
						  singleSelect:true">
		    <thead>
		        <tr>
		            <th data-options="field:'phoneNumber',width:100,halign:'center'">手机号码</th>
		            <th data-options="field:'callType',width:60,align:'center',halign:'center',formatter:formatCallType">呼叫类型</th>
		            <th data-options="field:'callFlag',width:80,align:'center',halign:'center',formatter:formatCallFlag">接通标识</th>
		            <th data-options="field:'time',width:150,align:'center',halign:'center'">通话时间</th>
		            <th data-options="field:'timeLength',width:80,halign:'center',formatter:formatTimeLength">通话时长</th>
		        </tr>
		    </thead>
		</table>
		<script>
		
			function formatCallType(value,row,index) {
				if (value == 0) {
					return "呼入";
				} else if (value == 1) {
					return "呼出";
				}
			}
				
			function formatCallFlag(value,row,index) {
				if (value == 0) {
					return "<div title='未接通' class=\'icon-call-none\'>&nbsp;</div>";
				} else if (value == 1) {
					if (row.callType == 0) {
						return "<div title='接通' class=\'icon-call-in\'>&nbsp;</div>";
					} 
					return "<div title='接通' class=\'icon-call-out\'>&nbsp;</div>";
				} else if (value == 2) {
					return "<div title='拒接' class=\'icon-call-refuse\'>&nbsp;</div>";
				}
			}
			
			function formatTimeLength(value,row,index) {
				if (value < 60) {
					return value + "秒";
				} else if (value < 60 * 60) {
					return Math.floor(value / 60) + "分" + (value % 60) + "秒"; 
				} else {
					return Math.floor(date / 3600) + "小时" + Math.floor(value / 60) + "分" + (value % 60) + "秒";
				}
			}
			
		</script>
    </div>
    <div title="计步" data-options="iconCls:'icon-walk'" style="overflow:auto;padding:10px;">
    	<div style="width: 600px;text-align: center;">
    		<div>今日</div>
	    	<div id="todayStep" style="width: 600px;height:400px;"></div>
	    	<div>每日计划：${device.expectStep}步</div>
    	</div>
    	<div style="width: 600px;">
	    	<div id="historyStep" style="width: 600px;height:400px;"></div>
    	</div>
    	<script>
    	require(['/lib/echarts/echarts.min.js'], function(echarts) {
    		// 当天记步数仪表图
    		var todayStepChart = echarts.init(document.getElementById('todayStep'));
    		todayStepChartOption = {
    		    tooltip : {
    		        formatter: function(item) {
    		            return "{0} <br/>{1} : {2}%".format(item.seriesName, item.name,
    		                (item.value / parseInt('${device.expectStep}') * 100));
    		        }
    		    },
    		    toolbox: {
    		        feature: {
    		            
    		        }
    		    },
    		    grid : {
					left : '3%',
					right : '4%',
					bottom : '3%',
					containLabel : true
				},
    		    series: [
    		        {
    		            name: '今日计步',
    		            type: 'gauge',
    		            detail: {
    		            	formatter:function (value) {
    		                	var cur = new Date();
    		                	var hours = cur.getHours();
    		                	if (hours < 10) {
    		                		hours = "0" + hours;
    		                	}
    		                	var minutes = cur.getMinutes();
    		                	if (minutes < 10) {
    		                		minutes = "0" + minutes;
    		                	}
								if (!value) {
									value = 0;
								}
    		                	return "截止" + hours + ":" + minutes + "已走\n" + value + "\n步"
    		                		
    		            	},
    		            	textStyle: {
    		            		fontSize:12
    		            	}
    		        	},
    		            max: '${device.expectStep}',// 最大值
    		            data: [{value: '${todayStep}', name: '完成率'}]// 数据
    		        }
    		    ]
    		};
    		todayStepChart.setOption(todayStepChartOption, true);
    		
    		// 历史记步数矩形图
			var historyStepChart = echarts.init(document.getElementById('historyStep'));
			
			historyStepChartOption = {
				title : {
					show : true,
					text : '历史',
					left : 'center',
					textStyle : {
						color : '#00CCFF'
					}
				},
				tooltip : {
					trigger : 'axis',
					axisPointer : {
						type : 'shadow'
					}
				},
				grid : {
					left : '3%',
					right : '4%',
					bottom : '3%',
					containLabel : true
				},
				xAxis : [ {
					type : 'category',
					data : []
				} ],
				yAxis : [ {
					type : 'value'
				} ],
				series : [ {
					name : '步数',
					type : 'bar',
					label : {
						normal : {
							show : true,
							position : 'top'
						}
					},
					data : [ {
						itemStyle : {
							normal : {
								color : '#00CCFF'
							}
						}
					}, {
						itemStyle : {
							normal : {
								color : '#FFCC00'
							}
						}
					}, {
						itemStyle : {
							normal : {
								color : '#FF0033'
							}
						}
					}, {
						itemStyle : {
							normal : {
								color : '#FF9900'
							}
						}
					}, {
						itemStyle : {
							normal : {
								color : '#00CC00'
							}
						}
					} ]
				} ]
			};
			
			refreshChart(historyStepChartOption);
			historyStepChart.setOption(historyStepChartOption, true);
			
			function refreshChart(option) {
				post("${urlPath}device/listHistorySteps.do?days=5", {deviceCode:'${device.deviceCode}'}, function(data){
					if (data) {
						$.each(data, function(i, v){
							option.xAxis[0].data[i] = v.date + "日";
							option.series[0].data[i].value = v.stepCount; 
						})
					}
				}, "json");
			}
    	});
		</script>
    </div>
</div>
<script>
$('.easyui-accordion').show();
</script>
</body>
</html>