<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
	<div id="serviceResourceGridToolbar">
		<form id="searchServiceResourceForm">
			<table class="form">
				<tr>
					<td>城市</td>
					<td><input class="easyui-combobox filter"
						name="city" style="width: 80px;"
						data-options="valueField:'text',textField:'text',url:'${libPath}json/city.json'">
					</td>
					<td>服务类型</td>
					<td><select class="easyui-combobox filter"
						name="serviceType" style="width: 80px;"
            data-options="
                      url: '/dict/items.do?dictName=serviceResource.type',
          textField: 'value',
          valueField: 'key',
          loadFilter: function(data) {
            data.unshift({key: '', value: '全部'});
            return data;
          }"
            >
					</select></td>
					<td>资源名称</td>
					<td><input class="easyui-textbox filter"
						name="orgName" type="text"></td>
					<td><a href="#" class="easyui-linkbutton"
						data-options="iconCls:'icon-search'" onclick="searchQuery()"
						id="searchBtn">查询</a> <a href="#" id="clearStat"
						class="easyui-linkbutton" data-options="iconCls:'icon-clear'"
						onclick="clearQuery()">清空</a></td>
				</tr>
			</table>
		</form>
		<form id="uploadServiceResourceForm" enctype="multipart/form-data"
			method="post">
			<table class="form">
				<tr>
					<td><c:forEach var="func" items="${ROLE_FUNCS}">
							<c:if test="${func.code == 'serviceResource.import'}">
								<input class="easyui-filebox" name="file" style="width: 300px"
									data-options="buttonText:'选择文件'">
								<a href="#" class="easyui-linkbutton"
									data-options="iconCls:'icon-import'"
									onclick="importServiceResource()">导入</a>
								<a href="#" class="easyui-linkbutton"
									data-options="iconCls:'icon-download'"
									onclick="downloadTemplate()">下载模板</a>
							</c:if>
							<c:if test="${func.code != 'serviceResource.import'}">
								<a href="#" class="easyui-linkbutton"
									data-options="iconCls:'${func.icon}'" onclick="${func.code}()">${func.funcName}</a>
							</c:if>
						</c:forEach></td>
				</tr>
			</table>
		</form>
	</div>
	<div id="serviceResourceDlg"></div>
	<table id="serviceResourceGrid" class="easyui-datagrid"
		data-options="url:'${urlPath }serviceResource/listServiceResource.do',
				  singleSelect:false,
				  fit:true,
				  toolbar:'#serviceResourceGridToolbar'">
		<thead>
			<tr>
				<th data-options="field:'-',width:250,halign:'center',checkbox:true"></th>
				<th data-options="field:'orgName',width:250,halign:'center'">资源名称</th>
				<th
					data-options="field:'serviceType',width:100,halign:'center',align:'center',formatter:formatType">服务类型</th>
				<th data-options="field:'contactName',width:80,halign:'center'">联系人</th>
				<th data-options="field:'contactTel',width:120,halign:'center'">手机号</th>
				<th data-options="field:'contactFixPhone',width:120,halign:'center'">固话</th>
				<th data-options="field:'city',width:80,halign:'center'">城市</th>
				<th data-options="field:'address',width:300,halign:'center'">地址</th>
				<th
					data-options="field:'remark',width:300,halign:'center',formatter:formatRemark">备注</th>
			</tr>
		</thead>
	</table>
	<script>
	   
		function searchQuery() {
			$(this).linkbutton('search', {
				grid : '#serviceResourceGrid',
				form : '#searchServiceResourceForm'
			});
		}

		function clearQuery() {
			$(this).linkbutton('clearQuery', '#serviceResourceGrid');
		}

		function formatType(value, rowData, rowIndex) {
		    return DictMan.itemMap('serviceResource.type')[value];
		}

		function formatRemark(value, rowData, rowIndex) {
			return "<span title='" + (value == null ? "" : value) + "'>"
					+ (value == null ? "" : value) + "</span>";
		}
		
       var serviceResource = {};
       serviceResource.add = function() { showEditForm(false)  };
       serviceResource.update = function() { showEditForm(true);  };
       
		function showEditForm(edit) {
			var href = "${urlPath }serviceResource/serviceResourceForm.do";
			var serviceResourceGrid = $("#serviceResourceGrid");
			if (edit) {
				var rows = serviceResourceGrid.datagrid("getSelections");
				if (rows.length > 1) {
					showAlert('错误提示', '不能同时编辑多行！', 'warning');
					return false;
				} else if (rows.length == 0) {
					showAlert('错误提示', '必须选中一行才能进行编辑！', 'warning');
					return false;
				}
				href = href + "?id=" + rows[0].id;
			}
			var dlg = $("#serviceResourceDlg")
					.dialog(
							{
								title : "编辑服务资源",
								width : 500,
								height : 300,
								closed : false,
								cache : false,
								href : href,
								buttons : [
										{
											text : "提交",
											iconCls : "icon-save",
											handler : function() {
												$("#serviceResourceForm")
														.form(
																"submit",
																{
																	url : "${urlPath }serviceResource/saveServiceResource.do",
																	success : function(
																			data) {
																		var data = str2Json(data);
																		if (data.success) {
																			dlg
																					.dialog("close");
																			$(
																					"#searchBtn")
																					.trigger(
																							"click");
																			showMessage(
																					'系统提示',
																					data.message);
																		} else {
																			showAlert(
																					data.title,
																					data.message,
																					'error');
																		}
																	}
																});
											}
										}, {
											text : "取消",
											iconCls : 'icon-cancel',
											handler : function() {
												dlg.dialog("close");
											}
										} ],
								modal : true
							});
		}
		
		serviceResource['delete'] = function() {
			var serviceResourceGrid = $("#serviceResourceGrid");
			var rows = serviceResourceGrid.datagrid("getSelections");
			if (rows.length == 0) {
				showAlert('错误提示', '没有找到任何可以删除的记录！', 'warning');
				return false;
			}
			showConfirm("确认操作", "确认删除服务资源！", function() {
				var ids = getObjectsPropertyArray(rows, "id");
				post("${urlPath }serviceResource/deleteServiceResource.do", {
					ids : ids
				}, function(data) {
					$("#searchBtn").trigger("click");
					showMessage('系统提示', data.message);
				});
			});
		}

		function downloadTemplate() {
			location.href = CONFIG.modulePath + "serviceResource/serviceResource_template.xls";
		}

		function importServiceResource() {
			$.messager.progress();
			submitForm("uploadServiceResourceForm",
					"${urlPath}serviceResource/importServiceResource.do",
					function(data) {
						data = str2Json(data);
						if (data.success) {
							showMessage("操作提示", "操作成功");
						} else {
							showAlert("错误提示", data.message, "warning");
						}
						$("#searchBtn").trigger("click");
						$.messager.progress('close');
					});
		}
	</script>
</body>
</html>