<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="versionGridToolbar">
<form id="searchVersion">
	<table class="form">
		<tr>
			<td colspan="3" class="form">
            <c:forEach var="func" items="${ROLE_FUNCS}">
                <a href="#" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'" onclick="${func.code}()">${func.funcName}</a>
            </c:forEach>
			</td>
		</tr>
		<tr>
			<td>
				版本类型
			</td>
			<td>
				<input class="easyui-combobox filter" name="type" />
			</td>
			<td class="form role" style="display: none;">
				角色类型
			</td>
			<td class="form role" style="display: none;">
				<select id="roleFilter" class="easyui-combobox filter" name="role" style="width: 80px;">
			        <!-- <option value="teacher" selected="selected">教师</option>
			        <option value="family">家长</option> -->
			    </select>
			</td>
			<td>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
			            onclick="searchVersion()">查询</a>
			</td>
		</tr>
	</table>
</form>
</div>
<table id="versionGrid" class="easyui-datagrid"
	data-options="url:'${urlPath }version/listVersion.do',
				  multiSort:true,
				  sortName:'create_time',
				  sortOrder:'desc',
				  fit:true,
				  toolbar:'#versionGridToolbar'">
    <thead>
        <tr>
            <th data-options="field:'versionCode',width:80,halign:'center'">版本号</th>
            <th data-options="field:'versionName',width:100,halign:'center'">版本名称</th>
            <th data-options="field:'type',width:100,align:'center',halign:'center',formatter:formatVersion">版本类型</th>
            <th data-options="field:'phoneType',width:70,align:'center',halign:'center',formatter:formatPhoneType">终端类型</th>
            <th data-options="field:'flag',width:80,align:'center',halign:'center',formatter:formatFlag">升级类型</th>
            <th data-options="field:'createTime',width:150,halign:'center'">发布时间</th>
           <!--  <th data-options="field:'remark',width:250,halign:'center'">备注</th> -->
        </tr>
    </thead>
</table>
<div id="versionDlg"></div>
<script>
$(function() {
    $('[comboname=type]').comboboxFromDict({
        dict: DictMan.items('appVersion')
    });
});


    var version = {};
    version.add = function() { showVersionForm(false)  };
    version.update = function() { showVersionForm(true)  };
    
	function showVersionForm(edit) {
		var href = "${urlPath }version/showVersionForm.do";
		var versionGrid = $("#versionGrid");
		if (edit) {
			var rows = versionGrid.datagrid("getSelections");
			if (rows.length > 1) {
				showAlert('错误提示','不能同时编辑多行！','warning');
				return false;
			} else if (rows.length == 0) {
				showAlert('错误提示','必须选中一行才能进行编辑！','warning');
				return false;
			}
			href = href + "?versionId=" + rows[0].versionId;
		}
		var dlg = $("#versionDlg").dialog({
		    title: "编辑版本",
		    width: 560,
		    height: 380,
		    closed: false,
		    cache: false,
		    href: href,
		    onClose:function(){
		    	$.messager.progress('close');
		    },
		    buttons:[{
				text:"提交",
				iconCls:"icon-save",
				handler:function(){
					$("#versionForm").form("submit", {
					    url:"${urlPath }version/saveVersion.do",
						onSubmit: function(){
							var isValid = $(this).form('validate');
							if (!isValid){
								$.messager.progress('close');	// hide progress bar while the form is invalid
							} else {
								$.messager.progress();
							}
							return isValid;	// return false will stop the form submission
						},
					    success:function(data){
					    	$.messager.progress('close');
					    	var data = str2Json(data);
					    	if (data.success) {
					    		dlg.dialog("close");
					    		versionGrid.datagrid("load");
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
					$.messager.progress('close');
				}
			}],
		    modal: true
		});
	}
	
	version['delete'] = function() {
		var versionGrid = $("#versionGrid");
		var rows = versionGrid.datagrid("getSelections");
		if (rows.length == 0) {
			return false;
		}
		showConfirm("确认操作", "确认删除版本", function(){
			post("${urlPath}version/deleteVersion.do", {versionId:rows[0].versionId}, function(){
				versionGrid.datagrid("load");
			}, "json");
		});
	}

	function searchVersion() {
		var d={};
		$("#searchVersion").find('input,select')
						  .each(function(){
							  if (this.name) {
							  	d[this.name]=this.value
							  }
						  });
		$("#versionGrid").datagrid("load", d);
	}
	
	formatVersion = UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('appVersion'));
	
	function formatPhoneType(value, row, idx) {
		if (value == "android") {
			return "Android";
		} else if (value == "ios") {
			return "iOS";
		} else if (value == "wx_health" || value == "weixin") {
            return "微信小程序";
        }
	}
	
	function formatRole(value, row, idx) {
		if (value == "teacher") {
			return "教师端";
		} else if (value == "family") {
			return "家长端";
		}
		return "";
	}

	function formatFlag(value, row, idx) {
		if (value == 1) {
			return "强制升级";
		}
		return "非强制升级";
	}
	
</script>
</body>
</html>