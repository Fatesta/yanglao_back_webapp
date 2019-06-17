<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="healthGridToolbar">
<form id="searchHealth">
	<table class="form">
		<tr>
			<td>
				养生类别
			</td>
			<td>
			    <select class="easyui-combobox filter" name="category" style="width: 80px;">
			        <option value="" selected="selected">全部</option>
			        <option value="health_outdoors">运动健身</option>
			        <option value="health_diet">健康饮食</option>
			        <option value="health_care">保健养生</option>
			        <!-- 
			        <option value="health_hypertension">高血压</option>
			        <option value="health_diabetes">糖尿病</option>
			        <option value="health_heart">心脏病</option>
			        <option value="health_bonesporous">骨质疏松</option>
			        <option value="health_periarthritis">肩周炎</option>
			        <option value="health_rheumatoidarthritis">风湿性关节炎</option>
			         -->
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
			            onclick="searchHealth()">查询</a>
			    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
			            onclick="clearQuery()">清空</a>
			    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-export'"
			            onclick="exportHealth()">导出</a>
			    <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-download'"
			            onclick="downloadTemplate()">下载模板</a>
			</td>
		</tr>
	</table>
</form>
<form id="uploadHealthForm" enctype="multipart/form-data" method="post">
<table class="form">
	<tr>
		<td>
		 	<c:if test="${not empty ROLE_FUNC_MAP['notification.importHealth']}">
			 <input class="easyui-filebox" name="file" style="width:300px" data-options="buttonText:'选择文件'">
			 <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-import'"
			            onclick="importHealth()">导入</a>
			 </c:if>
		</td>
	</tr>
</table>
</form>
</div>
<table id="healthGrid" class="easyui-datagrid"
	data-options="url:'${urlPath }notification/listHealth.do',
				  fit:true,
				  fitColumns:true,
				  toolbar:'#healthGridToolbar'">
    <thead>
        <tr>
            <th data-options="field:'logdate',width:35,halign:'center'">日期</th>
            <th data-options="field:'category',width:35,halign:'center'">新闻类别</th>
            <th data-options="field:'txtMessage',width:500,halign:'center',formatter:showTip">新闻内容</th>
        </tr>
    </thead>
</table>
<script>

	function showTip(value) {
		return "<span title='" + value + "'>" + value + "</span>";
	}

	function clearQuery() {
		$(".filter").each(function(){
		  	$(this).filebox("clear");
		});
		$("#healthGrid").datagrid("load", {});
	}

	function searchHealth() {
		var d={};
		$("#searchHealth").find('input,select')
						  .each(function(){
							  if (this.name) {
							  	d[this.name]=this.value
							  }
						  });
		$("#healthGrid").datagrid("load", d);
	}
	
	function downloadTemplate() {
		location.href = CONFIG.modulePath + "notification/health_template.xls";
	}
	
	function exportHealth() {
		var d={};
		$("#searchHealth").find('input,select')
						  .each(function(){
							  if (this.name) {
							  	d[this.name]=this.value
							  }
						  });
		$("#healthGrid").datagrid("load", d);
		location.href = "${urlPath}notification/exportHealth.do?time=" + new Date().getMilliseconds() + "&category=" + d.category + "&logdate=" + d.logdate;
	}
	
	function importHealth() {
		$.messager.progress();
		var d={};
		$("#searchHealth").find('input,select')
						  .each(function(){
							  if (this.name) {
							  	d[this.name]=this.value
							  }
						  });
		submitForm("uploadHealthForm", "${urlPath}notification/importHealth.do", function(data){
			data = str2Json(data);
			if (data.success) {
				showMessage("操作提示", "操作成功");
			} else {
				showAlert("错误提示", data.message, "warning");
			}
			$("[name=file]").filebox("clear");
			$("#healthGrid").datagrid("load", d);
			$.messager.progress('close');
		});
	}
	
</script>
</body>
</html>