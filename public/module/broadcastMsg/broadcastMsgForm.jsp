<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
	<style>
	#textcount { font-style:italic; font-size:15px; width:100px;}
	textarea[name=content] {overflow-y:visible; }
	</style>
</head>
<body class="model-form-panel">
    <form id="broadcastMsgForm" method="post" enctype="MULTIPART/FORM-DATA">
    	<input type="hidden" name="specifiedDevs" value="">
    	 
    	<input type="hidden" name="broadcastType" value="${broadcastMsg.broadcastType}">
    	<input type="hidden" value="${curAdmin.id }" id="publisher" name="publisher">
    	<c:if test="${broadcastMsg.broadcastType == 1}">
    		<input type="hidden" name="type" value="0">
    	</c:if>
	    <table class="form model-form">
	    	<tr>
	    		<td style="min-width:60px">
	    			<c:if test="${broadcastMsg.broadcastType == 0}">
	    				<label for="title">标题</label>
	    			</c:if>
	    			<c:if test="${broadcastMsg.broadcastType == 1}">
	    				<label for="title">活动主题</label>
	    			</c:if>
	    		</td>
	    		<td colspan="3"><input class="easyui-textbox" name="title" value="${broadcastMsg.title}" style="width: 320px;" data-options="required:true,validType:'length[1,100]'" ></td>
	    	</tr>
	    	<c:if test="${broadcastMsg.broadcastType == 0}">
		    	<tr>
		    		<td><label for="type">类型</label></td>
		    		<td>
		    			<input id="type" class="easyui-combobox" name="type" value="${broadcastMsg.type}" style="width: 120px;"
		    				data-options="required:true,editable:false,valueField:'label',textField:'value',
									data:[{label:'0',value:'文本'},{label:'2',value:'语音'},{label:'1',value:'图片'},{label:'4',value:'链接'}<c:if test="${curAdmin.id==1 }">,{label:'5',value:'版本强制升级'}</c:if>],
									onChange:toggleInput,onLoadSuccess:toggleInput" />
					</td>
		    	</tr>
	    	</c:if>
	    	<tr>
	    		<td><label for="sendMode">发送方式</label></td>
	    		<td>
	    			<input id="sendMode" class="easyui-combobox" name="sendMode" value="${broadcastMsg.sendMode}" style="width: 120px;"
	    				data-options="required:true,editable:false,valueField:'id',textField:'value',
								data:[{id:'1',value:'立即发送'},{id:'0',value:'定时发送'}],onChange:sendModeOnChange" />
				</td>
				
				<td name="timeInput" style="display:none">
					时间:
					<input class="easyui-timespinner" id="weekTime" name="weekTime" value="${broadcastMsg.weekTime}" style="width:80px;" data-options="showSeconds:false,required:true">
				</td>
				<td name="timeInput" style="display:none">	
		    		周期:
		    		<input type="hidden" id="weekDay" name="weekDay" value="${broadcastMsg.weekDay}">
					<a href="#" data-options="text:'日'"></a>
					<a href="#" data-options="text:'一'"></a>
					<a href="#" data-options="text:'二'"></a>
					<a href="#" data-options="text:'三'"></a>
					<a href="#" data-options="text:'四'"></a>
					<a href="#" data-options="text:'五'"></a>
					<a href="#" data-options="text:'六'"></a>
				</td>
	    	</tr>
	    	<tr>
				<td class="form change rangeType">
	    		<c:if test="${broadcastMsg.broadcastType == 0}">
	    			<label for="rangeType">广播范围</label>
	    		</c:if>
	    		<c:if test="${broadcastMsg.broadcastType == 1}">
	    			<label for="rangeType">召集范围</label>
	    		</c:if>
				</td>
	    		<td class="form change rangeType">
	    			<input id="rangeType" class="easyui-combobox" name="rangeType" value="${broadcastMsg.rangeType}" data-options="required:true,editable:false,valueField:'label',textField:'value',
								data:[{label:'0',value:'所有'},{label:'1',value:'app用户'},{label:'2',value:'设备用户'},{label:'3',value:'指定设备用户'}],onChange:rangeTypeOnChange" style="width: 120px;" />
	    			<a href="#" id="openDeviceSelectDialog" class="easyui-linkbutton" onclick="openDeviceSelectDialog()"
	    			<c:if test="${broadcastMsg.rangeType != 3}">
	    				style="display:none"
	    			</c:if>
	    			>查看和编辑</a>
	    		</td>
	    		
	    	</tr>
	    	<tr id="tr_content" class="change">
	    		<td>
	    		<c:if test="${broadcastMsg.broadcastType == 0}">
	    			<label for="content">广播文本</label>
	    		</c:if>
	    		<c:if test="${broadcastMsg.broadcastType == 1}">
	    			<label for="content">活动内容</label>
	    		</c:if>
	    		</td>
	    		<td colspan="3">
	    			<textarea rows="10" cols="160" class="easyui-validatebox" id="content" name="content" data-options="required:true,validType:'length[0,800]'" data-max="800">${broadcastMsg.content}</textarea>
	    			<span id="textcount"></span>
	    		</td>
	    	</tr>
	    	<tr id="tr_fileName" class="change">
	    		<td><label for="file">资源文件</label></td>
	    		<td colspan="3">
	    			<input id="fileName" class="easyui-filebox resource" name="fileName" style="width: 320px;" data-options="required:true,buttonText:'选择文件',accept:'image/gif, image/jpeg, image/png'">
	    		</td>
	    	</tr>
	    	<tr id="tr_voiceFileName" class="change">
	    		<td><label for="file">资源文件</label></td>
	    		<td colspan="3">
	    			<input id="voiceFileName" class="easyui-filebox resource" name="voiceFileName" style="width: 320px;" data-options="required:true,buttonText:'选择文件',accept:'audio/mpeg',validType:'fileSize[5,\'MB\']'">
	    			(请上传小于5MB的mp3文件)
	    		</td>
	    	</tr>
	    	<tr id="tr_linkUrl" class="change">
	    		<td><label for="linkUrl">链接地址</label></td>
	    		<td colspan="3"><input id="linkUrl" class="easyui-textbox resource" name="linkUrl" value="${broadcastMsg.linkUrl}" style="width: 320px;" data-options="required:true,validType:'length[1,1024]'" ></td>
	    	</tr>
	    </table>
	</form>
    <div class="form-submit-buttons">
        <a id="btnSubmit" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="submit()">提交</a>
    </div>
<div id="dlgDeviceSelect"></div>	
<script>
$(function(){
    toggleInput();
    
	//内容字数计数
	var input = $("[name=content]");
	var countDisplay = $("#textcount");
	var max = input.data("max");
	input.keydown(update);
	input.keyup(update);
	input.focus(update);
	update();
	function update() {
		var cnt = calcCount(this);
		if (cnt <= max) {
			countDisplay.text(String.format("{0}/{1}", cnt, max));
		} else {
			input.val(input.val().substring(0, max));
		}
	}
	function calcCount(textarea) {
		return input.val().length;
	}
});

var selectedDeviceGridData = null;
var deviceSelectDialog = null;//全局

$(function(){
    var broadcastMsgId = "${broadcastMsg.msgId}";
    if(broadcastMsgId) {
        $.getJSON("${urlPath }broadcastMsg/listBroadcastMsgChild.do", {broadcastId:broadcastMsgId}, function(data){
            selectedDeviceGridData = data;
        });

        if("${broadcastMsg.sendMode}"=="0") {
			$("[name=timeInput]").show();
        } else {
			$("#weekDay").val("");
        }
    }
    
    $("#weekTime").timespinner({required:true});
	initWeekDay();
	
	function initWeekDay() {
		var input;
		var btnDays;
		
		init();

		function setBit(index, value) {
			var vals = input.val().split("");
			vals[index] = + value;
			input.val(vals.join(""));
		}
		
		function init() {
			input = $("input[name=weekDay]");
			var val = input.val() || "1111111";
			btnDays = input.siblings("a");
			
			$(btnDays).css("font-color", "white");
			$(btnDays).css("background-color", "gray");
			
			for (var i = 0; i < 7; i++) {
				var btn = $(btnDays[i]);
				var selected = + val.charAt(i);
				btn.linkbutton({
					selected : selected,
					toggle : true,
				    onClick : function(){
						var index = $(this).index() - 1;
						var selected = $(this).linkbutton("options").selected;
						setBit(index, selected);
				    }
				});
				btn.css("background-color", "#01B468");
				btn.css("font-weight", "bold");
				!selected && btn.linkbutton("unselect");
			}
		}
	}
})

/**
	广播类型值发生变化时触发该方法
	[{label:'0',value:'文本'},{label:'1',value:'图片'},{label:'2',value:'语音'},{label:'4',value:'链接'},{label:'5',value:'版本强制升级'}]
	值为0（文本消息）时，显示并启用广播文本框和广播范围框，禁用图片资源文件框和链接地址框、语言资源文件框
	值为1（图片消息）时，显示并启用图片资源文件框，禁用广播文本框、广播范围框、链接地址框、语言资源文件框
	值为2（语言消息）时，显示并启用语言资源文件框，禁用图片资源文件框、广播文本框、广播范围框、链接地址框
	值为4（链接消息）时，显示并启用图片资源文件框和链接地址框，禁用广播文本框、广播范围框、语言资源文件框
	值为5（强制升级）时，显示并启用广播文本框，禁用广播范围框、图片资源文件框和链接地址框、语言资源文件框
*/
function toggleInput() {
	$(".change").hide();
	$("#rangeType").combobox({required:false});
	$("#linkUrl").textbox({required:false});
	$("#voiceFileName").filebox({required:false});
	$("#fileName").filebox({required:false});
	$("#content").validatebox({required:false});
	// 获取广播类型
	var type = $("#type").length ? $("#type").combobox("getValue") : 0;
	if (type == 0) {// 值为0（文本消息）时，显示并启用广播文本框和广播范围框
		$("#rangeType").combobox({required:true});
		$(".rangeType").show();
		$("#content").validatebox({required:true});
		$("#tr_content").show();
	} else if (type == 1) {// 值为1（图片消息）时，显示并启用图片资源文件框
		$("#fileName").filebox({required:true});
		$("#tr_fileName").show();
	} else if (type == 2) {// 值为2（语言消息）时，显示并启用语言资源文件框 广播范围框
		$("#rangeType").combobox({required:true});
		$(".rangeType").show();
		$("#voiceFileName").filebox({required:true});
		$("#tr_voiceFileName").show();
	} else if (type == 4) {// 值为4（链接消息）时，显示并启用图片资源文件框和链接地址框
		$("#fileName").filebox({required:true});
		$("#tr_fileName").show();
		$("#linkUrl").textbox({required:true});
		$("#tr_linkUrl").show();
	} else if (type == 5) {// 值为5（强制升级）时，显示并启用广播文本框
		$("#content").validatebox({required:true});
		$("#tr_content").show();
	}
}

function openDeviceSelectDialog() {
	deviceSelectDialog = $("#dlgDeviceSelect").dialog({
	    title: "指定设备用户",
	    width: 650,
	    height: 480,
	    closed: false,
	    cache: false,
	    href: "${urlPath }broadcastMsg/deviceForm.do",
	    modal: true,
	    onClose: function(){
	    	doneSelectDevice();
	    }
	});
}

function doneSelectDevice() {
	var devices = $("#selectedDeviceGrid").datagrid("getRows");
	if(devices.length == 0) {
		addSelectedDevices();
		devices = $("#selectedDeviceGrid").datagrid("getRows");
	}
	selectedDeviceGridData = devices;
	var deviceCodes = devices.map(function(dev){ return dev.deviceCode; });
	$("[name=specifiedDevs]").val(deviceCodes.join(","));
	//$("#selectedDeviceUser").text(deviceCodes.slice(0, 5).join(", "));
	//$("#selectedDeviceUser").show();
	$("#openDeviceSelectDialog").show();
}
		
function submit() {
	//验证
	if(!$("#broadcastMsgForm").form("validate"))
		return;
	var rangeType = $("#rangeType").combobox("getValue");
	if(rangeType == 3 && !$("[name=specifiedDevs]").val()) {
		showAlert("提示", "请至少选择一个设备");
		return;
	}
	
	var time = $("#weekTime").val();
	$('#weekTime').timespinner({ showSeconds: true });
	$("#weekTime").timespinner("setValue", time + ":00");

	var type = $("#type").length ? $("#type").combobox("getValue") : 0;
	if (type == 0) {// 文本消息，不校验直接发送
		sendMsg();
	} else {
		post("${urlPath}broadcastMsg/validMemberNumber.do", null, function(data){
			if (data.success) {
				sendMsg();
			} else {
				showAlert('错误提示',data.message);
				return false;
			}
		});
	}
}

function sendMsg() {
	$("#btnSubmit").linkbutton("disable");
	$("#broadcastMsgForm").form("submit", {
	    url:"${appServiceUrl}sendBroadcastMsg",
	    //ajax:false,
	    success:function(data){
	    	$("#btnSubmit").linkbutton("enable");
    		showMessage('系统提示', '发布成功！');
    		$("#broadcastMsgForm").form("clear");
    		$("#type").length && $("#type").combobox("setValue", 0);
    		$("#sendMode").combobox("setValue", 1);
    		$("#rangeType").combobox("setValue", 0);
	    }
	});
}

function rangeTypeOnChange(newValue, oldValue) {
	if(newValue != 3) {
		//$("#selectedDeviceUser").hide();
		$("#openDeviceSelectDialog").hide();
		return;
	}
	//指定设备用户,选择窗口
	openDeviceSelectDialog();
}

function sendModeOnChange(newValue, oldValue) {
	if(newValue != 0) {
		$("[name=timeInput]").hide();
		$("#weekTime").timespinner({required:false}).timespinner("setValue", moment().format('HH:mm'));
		$("#weekDay").val("");
	} else {
		//定时发送
		$("#weekTime").timespinner({required:true}).timespinner("setValue", moment().add(15, 'minutes').format('HH:mm'));
		$("#weekDay").val("1111111");
		$("[name=timeInput]").show();
	}
}
</script>
</body>
</html>