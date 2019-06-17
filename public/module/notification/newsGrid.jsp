<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="newsGridToolbar">
<form id="searchNews">
	<table class="form">
		<tr>
			<td>
				新闻类别
			</td>
			<td>
			    <select class="easyui-combobox filter" name="category" style="width: 80px;">
			        <option value="" selected="selected">全部</option>
			        <option value="news_headline">头条</option>
			        <option value="news_entertainment">娱乐</option>
			        <option value="news_technology">科技</option>
			        <option value="news_financial">财经</option>
			        <option value="news_sports">体育</option>
			    </select>
			</td>
			<td>
				日期
			</td>
			<td>
				<input class="easyui-datebox filter" name="logdate" type="text" data-options="editable:false">
			</td>
			
			<td colspan="6">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
			            onclick="searchNews()">查询</a>
			    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-clear'"
			            onclick="clearQuery()">清空</a>
			    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-export'"
			            onclick="exportNews()">导出</a>
			    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-download'"
			            onclick="downloadTemplate()">下载模板</a>
			</td>
		</tr>
	</table>
</form>
<form id="uploadNewsForm" enctype="multipart/form-data" method="post">
<table class="form">
	<tr>
		<td>
			<c:if test="${not empty ROLE_FUNC_MAP['notification.importNews']}">
			<input class="easyui-filebox" name="file" style="width:300px" data-options="buttonText:'选择文件'">
			 <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-import'"
			            onclick="importNews()">导入</a>
			</c:if>
		</td>
	</tr>
</table>
</form>
</div>
<table id="newsGrid" class="easyui-datagrid"
	data-options="url:'${urlPath }notification/listNews.do',
				  fit:true,
				  fitColumns:true,
				  toolbar:'#newsGridToolbar'">
    <thead>
        <tr>
            <th data-options="field:'logdate',width:35,halign:'center'">日期</th>
            <th data-options="field:'category',width:35,halign:'center'">新闻类别</th>
            <th data-options="field:'txtMessage',width:500,halign:'center',formatter:showTip">新闻内容</th>
        </tr>
    </thead>
</table>
<div id="adminDlg"></div>
<script>

	function showTip(value) {
		return "<span title='" + value + "'>" + value + "</span>";
	}

	function clearQuery() {
		$(".filter").each(function(){
		  	$(this).filebox("clear");
		});
		$("#newsGrid").datagrid("load", {});
	}

	function searchNews() {
		var d={};
		$("#searchNews").find('input,select')
						  .each(function(){
							  if (this.name) {
							  	d[this.name]=this.value
							  }
						  });
		$("#newsGrid").datagrid("load", d);
	}
	
	function downloadTemplate() {
		location.href = CONFIG.modulePath + "notification/news_template.xls";
	}
	
	function exportNews() {
		var d={};
		$("#searchNews").find('input,select')
						  .each(function(){
							  if (this.name) {
							  	d[this.name]=this.value
							  }
						  });
		$("#newsGrid").datagrid("load", d);
		location.href = "${urlPath}notification/exportNews.do?time=" + new Date().getMilliseconds() + "&category=" + d.category + "&logdate=" + d.logdate;
	}
	
	function importNews() {
		$.messager.progress();
		var d={};
		$("#searchNews").find('input,select')
						  .each(function(){
							  if (this.name) {
							  	d[this.name]=this.value
							  }
						  });
		submitForm("uploadNewsForm", "${urlPath}notification/importNews.do", function(data){
			data = str2Json(data);
			if (data.success) {
				showMessage("操作提示", "操作成功");
			} else {
				showAlert("错误提示", data.message, "warning");
			}
			$("[name=file]").filebox("clear");
			$("#newsGrid").datagrid("load", d);
			$.messager.progress('close');
		});
	}
	
</script>
</body>
</html>