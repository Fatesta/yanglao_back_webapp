<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="feedbackGridToolbar">
<form id="searchFeedback">
	<table class="form">
		<tr>
			<td colspan="9" class="form">
              <c:forEach var="func" items="${ROLE_FUNCS}">
                <a href="javascript:void(0)" class="easyui-linkbutton"
                    data-options="iconCls:'${func.icon}'" onclick="${func.code}()">${func.funcName}</a>
              </c:forEach>
			</td>			
		</tr>
		<tr>
			<td>
				类型
			</td>
			<td>
				<select class="easyui-combobox filter" name="type" style="width: 80px;">
			        <option value="" selected="selected">全部</option>
			        <option value="1">BUG</option>
			        <option value="2">建议</option>
			    </select>
			</td>
			<td>
				状态
			</td>
			<td>
			    <select class="easyui-combobox filter" name="status" style="width: 80px;">
			        <option value="" selected="selected">全部</option>
			        <option value="1">已解决</option>
			        <option value="0">未解决</option>
			    </select>
			</td>
			<td>
				联系方式
			</td>
			<td>
				<select class="easyui-combobox filter" name="contactType" style="width: 80px;">
			        <option value="" selected="selected">全部</option>
			        <option value="1">QQ</option>
			        <option value="2">微信</option>
			        <option value="3">手机</option>
			    </select>
			</td>
			<td>
				联系号码
			</td>
			<td>
				<input class="easyui-textbox filter" name="contactNumber" type="text">
			</td>
			<td colspan="6">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
			            onclick="searchFeedback()">查询</a>
			    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-clear'"
			            onclick="clearQuery()">清空</a>
			</td>
		</tr>
	</table>
</form>
</div>
<table id="feedbackGrid" class="easyui-datagrid"
	data-options="url:'${urlPath }feedback/listFeedback.do',
				  multiSort:true,
				  sortName:'f.createTime',
				  sortOrder:'desc',
				  fit:true,
				  fitColumns:true,
				  toolbar:'#feedbackGridToolbar'">
    <thead>
        <tr>
            <!-- <th data-options="field:'serialId',width:60,halign:'center',checkbox:true">ID</th> -->
            <th data-options="field:'aliasName',width:60,halign:'center'">反馈者</th>
            <th data-options="field:'type',width:40,halign:'center',align:'center',formatter:formatType">类型</th>
            <th data-options="field:'status',width:40,halign:'center',align:'center',formatter:formatStatus">状态</th>
            <th data-options="field:'contactType',width:40,halign:'center',align:'center',formatter:formatContactType">联系方式</th>
            <th data-options="field:'contactNumber',width:50,halign:'center'">联系号码</th>
            <th data-options="field:'phoneModel',width:50,halign:'center'">手机型号</th>
            <th data-options="field:'createTime',width:60,halign:'center'">反馈时间</th>
            <th data-options="field:'remark',width:150,halign:'center'">备注</th>
            <th data-options="field:'processResult',width:100,halign:'center'">处理结果</th>
        </tr>
    </thead>
</table>
<div id="feedbackDlg"></div>
<script>
var feedback = {};
feedback.back = function() {
	var feedbackGrid = $("#feedbackGrid");
	var rows = feedbackGrid.datagrid("getSelections");
	if (rows.length == 0) {
		showAlert('错误提示','至少选中一行才能进行编辑！','warning');
		return false;
	}
	for (var i = 0; i < rows.length; i++) {
		if (rows[i].status == 0) {
			showAlert("错误提示", "不能回退未解决的问题！", "warning");
			return false;
		}
	}
	var serialIds = getObjectsPropertyArray(rows, "serialId");
	post("${urlPath }feedback/back.do", {serialIds:serialIds}, function(data){
		feedbackGrid.datagrid("load");
	   	showMessage('系统提示', data.message);
	});		
}

feedback.fix = function() {
	var feedbackGrid = $("#feedbackGrid");
	var rows = feedbackGrid.datagrid("getSelections");
	if (rows.length == 0) {
		showAlert('错误提示','至少选中一行才能进行编辑！','warning');
		return false;
	}
	
	if (rows[0].status == 1) {
		showAlert("错误提示", "不能修复已解决的问题！", "warning");
		return false;
	}
	
	$.messager.confirmInput("操作确认", "处理意见：", function(r, input){
		if (r) {
			
			if (input.substring(input.length - 1) != "。") {
				input += "。";
			}
			
			var processResult = "亲爱的【" + rows[0].aliasName + "】用户，您好：您的反馈已经收到，" + input + "祝您生活愉快!【亲情互联】";
			
			var params = {
					serialId:rows[0].serialId,
					contactType:rows[0].contactType,
					contactNumber:rows[0].contactNumber,
					processResult:processResult
			};
			
			if (params.contactType != 3) {
				params.contactNumber = rows[0].appUserId;
			}
			post("${urlPath }feedback/fix.do", params, function(data){
				feedbackGrid.datagrid("load");
			   	showMessage('系统提示', data.message);
			});
		}
	},{required:true,validType:'maxLength[1000]'},true);
}

feedback.add = function() {
    showFeedbackForm(false);
}

feedback.update = function() {
    showFeedbackForm(true);
}

function showFeedbackForm(edit) {
	var href = "${urlPath }feedback/showFeedbackForm.do";
	var feedbackGrid = $("#feedbackGrid");
	if (edit) {
		var rows = feedbackGrid.datagrid("getSelections");
		if (rows.length > 1) {
			showAlert('错误提示','不能同时编辑多行！','warning');
			return false;
		} else if (rows.length == 0) {
			showAlert('错误提示','必须选中一行才能进行编辑！','warning');
			return false;
		}
		href = href + "?serialId=" + rows[0].serialId;
	}
	var dlg = $("#feedbackDlg").dialog({
	    title: "编辑反馈消息",
	    width: 480,
	    height: 260,
	    closed: false,
	    cache: false,
	    href: href,
	    buttons:[{
			text:"提交",
			iconCls:"icon-save",
			handler:function(){
				$("#feedbackForm").form("submit", {
				    url:"${urlPath }feedback/saveFeedback.do",
				    success:function(data){
				    	var data = str2Json(data);
				    	if (data.success) {
				    		dlg.dialog("close");
				    		feedbackGrid.datagrid("load");
				    		showMessage('系统提示', data.message);
				    	} else {
				    		showAlert(data.title,data.message,'error');
				    	}
				    }
				});
			}
		},{
			text:"取消",
			iconCls:'icon-cancel',
			handler:function(){
				dlg.dialog("close");	
			}
		}],
	    modal: true
	});
}

function clearQuery() {
	$(".filter").each(function(){
	  	$(this).textbox("clear");
	});
	$("#feedbackGrid").datagrid("load", {});
}

function formatType(value,rowData,rowIndex){
	// 1-我要反馈BUG 2-我要提建议
	if (value == 1) {
		return "BUG";
	}
	return "建议";
}

function formatStatus(value,rowData,rowIndex) {
	// 0-未解决 1-已解决
	if (value == 1) {
		return "已解决";
	}
	return "未解决";
}

function formatContactType(value,rowData,rowIndex) {
	// 1-QQ 2-微信 3-手机
	if (value == 1) {
		return "QQ";
	} else if (value == 2) {
		return "微信";
	}
	return "手机";
}

function searchFeedback() {
	var d={};
	$("#searchFeedback").find('input,select')
					  .each(function(){
						  if (this.name) {
						  	d[this.name]=this.value
						  }
					  });
	$("#feedbackGrid").datagrid("load", d);
}

</script>
</body>
</html>