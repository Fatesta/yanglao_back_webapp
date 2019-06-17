<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="broadcastMsgToolbar">
<form id="searchBroadcastMsg">
	<table class="form">
		<tr>
			<c:if test="${broadcastMsg.broadcastType == 0}">
			<td>
				分类
			</td>
			<td>
			    <select class="easyui-combobox" name="type" style="width: 120px;">
			        <option value="" selected="selected">全部</option>
			        <option value="0">文本</option>
			        <option value="2">语音</option>
			        <option value="1">图片</option>
			        <option value="4">链接</option>
			        <c:if test="${curAdmin.id==1 }">
			        <option value="5">版本强制升级</option>
			        </c:if>
			    </select>
			</td>
			<td>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
			            onclick="searchBroadcastMsg()">查询</a>
			</td>
			</c:if>
			<td>
				<c:if test="${not empty session_role_leaf_fn_map['63']}">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'"
			            onclick="showBroadcastMsgForm(false)">新增发布</a>
			    </c:if>
			    <c:if test="${not empty session_role_leaf_fn_map['172']}">
			    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit'"
			            onclick="showBroadcastMsgForm(true)">修改发布</a>
			    </c:if>
	   			<c:if test="${not empty session_role_leaf_fn_map['65']}">
			    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-delete'"
			            onclick="removeBroadcastMsg()">删除</a>
			    </c:if>
			</td>
		</tr>
	</table>
</form>
</div>
<table id="broadcastMsgGrid" class="easyui-datagrid"
	data-options="url:'${urlPath }broadcastMsg/listBroadcastMsg.do?broadcastType=${broadcastMsg.broadcastType}',
				  multiSort:true,
				  fit:true,
				  sortName:'m.createTime',
				  sortOrder:'desc',
				  toolbar:'#broadcastMsgToolbar'">
    <thead>
        <tr>
        	<c:if test="${broadcastMsg.broadcastType == 0}">
	            <th data-options="field:'msgId',checkbox:true">ID</th>
	            <th data-options="field:'title',width:'16%',halign:'center', formatter:UICommon.datagrid.formatter.wraptip">标题</th>
	            <th data-options="field:'type',width:'8%',halign:'center',formatter:formatType">分类</th>
	            <th data-options="field:'rangeType',width:'8%',halign:'center',formatter:formatRange">广播范围</th>
	            <th data-options="field:'weekDayAndTime',width:'14%',halign:'center',formatter:formatWeekDayAndTime">定时发送周期和时间</th>
	            <th data-options="field:'content',width:'6%',halign:'center', formatter:formatContent">文本内容</th>
	           	<th data-options="field:'fileName',width:'6%',halign:'center', formatter:UICommon.datagrid.formatter.wraptip">文件名</th>
	           	<th data-options="field:'linkUrl',width:'6%',halign:'center', formatter:UICommon.datagrid.formatter.wraptip">链接地址</th>
	            <th data-options="field:'publisher',width:'7%',halign:'center'">发布者</th>
	            <th data-options="field:'createTime',width:'10%',halign:'center'">发布时间</th>
	            <th data-options="field:'--',width:'12%',align:'center', formatter:formatters.sendTotal">已收听/未收听数</th>
            </c:if>
            <c:if test="${broadcastMsg.broadcastType == 1}">
	            <th data-options="field:'msgId',checkbox:true">ID</th>
	            <th data-options="field:'title',width:'16%',halign:'center', formatter:UICommon.datagrid.formatter.wraptip">标题</th>
	            <th data-options="field:'rangeType',width:'8%',halign:'center',formatter:formatRange">召集范围</th>
	            <th data-options="field:'weekDayAndTime',width:'14%',halign:'center',formatter:formatWeekDayAndTime">定时发送周期和时间</th>
	            <th data-options="field:'content',width:'12%',halign:'center', formatter:formatContent">内容</th>
	            <th data-options="field:'publisher',width:'7%',halign:'center'">发布者</th>
	            <th data-options="field:'createTime',width:'10%',halign:'center'">发布时间</th>
            </c:if>
			<th data-options="field:'-',width:'3%',align:'center', formatter:formatters.op">状态</th>
        </tr>
    </thead>
</table>
<div id="broadcastMsgDlg"></div>
<script>
var formatters = {
    sendTotal: function(value, rowData, rowIndex) {
        var htmlTpl = "<div style='float:left;width:100%;line-height:25px;color:white;'>{0}</div>"
            + "<div style='background-color:#9F2626;height:25px;width:100%;'>"
        	+ "<div style='width:{1}%;height:100%;background-color:#3A68D3;'></div></div>";
        if(rowData.sendTotal != 0) {
	        return htmlTpl.format(
	           (rowData.successTotal || 0) + " / " + (rowData.sendTotal - rowData.successTotal),
	           rowData.sendTotal != 0 ? Math.floor(rowData.successTotal / rowData.sendTotal * 100) : 0);
        } else {
            return htmlTpl.format("等待结果,请稍后重新查询", 0);
        }
    },
    op: function(value, rowData, rowIndex) {
        return '<a href="#" class="easyui-linkbutton" title="{0}" onclick=\'updateValid({1}, \"{2}\", {3})\'>'
        	.format(rowData.isvalid ? "已启用，点击禁用" : "已禁用，点击启用", rowIndex, rowData.msgId, rowData.isvalid)
        	+'<div class=\'icon-{0}\' style=\'float:left;width:20px;\'>&nbsp;</div></a>'.format(rowData.isvalid ? "enable" : "disable");
    }
};

	function formatRange(value,rowData,rowIndex) {
		if (value == 0) {
			return "所有";
		} else if (value == 1) {
			return "app用户";
		} else if (value == 2) {
			return "设备用户";
		} else if (value == 3) {
			return "指定设备用户";
		}
	}

	function formatType(value,rowData,rowIndex) {
		if (value == 0) {//0-文本 1-图片  4-链接
			return "文本";
		} else if (value == 1) {
			return "图片";
		} else if (value == 2) {
			return "语音";
		} else if (value == 4) {
			return "链接";
		} else if (value == 5) {
			return "版本强制升级";
		}
	}
	
	function formatWeekDayAndTime(value, rowData, rowIndex) {
		if(!value)
			return value;
		var str = "";
		if(rowData.sendMode == 0) {
			var weekDay = value.split("|")[0];
			var weekTime = value.split("|")[1];
			var weekDayText = weekDay.split("").map(function(v, i){
				return +v ? "日一二三四五六"[i] : null;
			}).filter(_.isString).join("");
			str = "周:" + weekDayText + ", 时间:" + weekTime;
		} else {
			str = rowData.weekTime;
		}
		return str;
	}

	function formatContent(value, rowData, rowIndex) {
		if(rowData.type == 0) {
			return '<a href="#" class="easyui-linkbutton" data-options="iconCls:\'color:fff\'" onclick="checkFullContent(' + rowIndex + ')">'
					+ (value.substring(0, 10) + (value.length > 10 ? " ..." : "")) + '</a>';
		} else {
			return value;
		}
	}
	
	function checkFullContent(rowIndex) {
		var row = $("#broadcastMsgGrid").datagrid("getRows")[rowIndex];
		var content = row.content;
		var title = String.format("[{0}] 的 完整内容", row.title);
		var divDlg = $("<div>" + content + "</div>");
		divDlg.appendTo($(document.body));
		divDlg.dialog({
		    title: title,    
		    width: 900,
		    height: 400,
		    closed: false,
		    cache: false,  
		    modal: true   
		});
	}
	
	function updateValid(index, id, isvalid) {
	    var revVal = +!isvalid;
		post("${urlPath }broadcastMsg/updateValid.do", {msgId: id, isvalid: revVal}, function(ret){
		    if(ret.success)
			    $("#broadcastMsgGrid").datagrid("updateRow", {
			    	index: index,
			    	row: {isvalid: revVal}
			    });
		    else
		        showAlert('提示', ret.message);
		});
	}
	
	function searchBroadcastMsg() {
		var d={};
		$("#searchBroadcastMsg").find('input,select')
						  .each(function(){
							  if (this.name) {
							  	d[this.name]=this.value
							  }
						  });
		$("#broadcastMsgGrid").datagrid("load", d);
	}
	
	function showBroadcastMsgForm(edit) {
	    var broadcastType = "${broadcastMsg.broadcastType}";
		var url = "${urlPath }broadcastMsg/showBroadcastMsgForm.do?broadcastType=" + broadcastType;
		var broadcastMsgGrid = $("#broadcastMsgGrid");
		if (edit) {
			var rows = broadcastMsgGrid.datagrid("getSelections");
			if (rows.length > 1) {
				showAlert('错误提示','不能同时编辑多行！','warning');
				return false;
			} else if (rows.length == 0) {
				showAlert('错误提示','必须选中一行才能进行编辑！','warning');
				return false;
			}
			url = url + "&msgId=" + rows[0].msgId;
			openTab("mainTab", url, "修改发布");
		} else {
		    openTab("mainTab", url, "新增发布");
		}
		
		
	}
	
	function removeBroadcastMsg() {
		var broadcastMsgGrid = $("#broadcastMsgGrid");
		var rows = broadcastMsgGrid.datagrid("getSelections");
		if (rows.length > 0) {
			var msgIds = getObjectsPropertyArray(rows, "msgId");
			showConfirm("确认操作", "确认删除选中的广播消息！", function(){
				post("${urlPath }broadcastMsg/deleteBroadcastMsg.do", {msgIds:msgIds,rangeType:3}, function(data){
					broadcastMsgGrid.datagrid("load");
				   	showMessage('系统提示', data.message);
				});
			});
		}
	}
	
</script>
</body>
</html>