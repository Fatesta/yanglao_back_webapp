<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="diseaseDrugLayout" class="easyui-layout" data-options="fit:true">
    <div data-options="region:'west',title:'疾病'" style="width:150px;">
    	<ul id="diseaseTree"></ul>
    </div>
    <div data-options="region:'center',title:'药品'">
		
    </div>
</div>
<script>

	function importDiseaseDrug() {
		submitForm("uploadDiseaseDrugForm", "${urlPath}diseaseDrug/importDiseaseDrug.do", function(data){
			var node = $("#diseaseTree").tree("getSelected");
			var params = {};
			if (node) {
				params.pid = node.id;
			}
			$("#drugGrid").datagrid("load", params);
		});
	}
	
	$('#diseaseTree').tree({
	    url:'${urlPath}diseaseDrug/listDiseaseTree.do',
	    onClick:function(node){
	    	// 获取疾病ID
	    	var diseaseId = node.id;
	    	// 获取药品Panel
	    	var center = $("#diseaseDrugLayout").layout("panel","center");
	    	$(center).panel("refresh", "${urlPath}diseaseDrug/drugGrid.do?_func_id=${ROLE_FUNC.id}&pid=" + diseaseId);
		}
	});

</script>
</body>
</html>