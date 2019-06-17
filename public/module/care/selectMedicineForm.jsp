<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/module/common.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
	<table class="form">
		<tr>
			<td><label for="disease">疾病</label></td>
			<td><input class="easyui-combobox" id="diseaseCombobox" style="width: 300px;"
				data-options="multiple:true,editable:false,valueField:'id',textField:'text',url:'${urlPath }diseaseDrug/listDiseaseTree.do',onChange:changeDrugCombo">
			</td>
		</tr>
		<tr>
			<td><label for="drug">药品</label></td>
			<td><input class="easyui-combobox" id="drugCombobox" style="width: 300px;"
				data-options="multiple:true,editable:false,valueField:'id',textField:'text',url:'${urlPath }diseaseDrug/listDrugOptions.do',onSelect:selectDrug">
			</td>
		</tr>
	</table>
	<script>
	
		function changeDrugCombo(newValue,oldValue) {
			var values = $(this).combobox("getValues");
			if (values != null && values.length > 0) {
				var ids = "";
				for (var i = 0; i < values.length; i++) {
					ids = ids + values[i] + ",";
				}
				if (ids.length > 0) {
					ids = ids.substring(0, ids.length - 1);
				}
				$("#drugCombobox").combobox("reload", "${urlPath }diseaseDrug/listDrugOptions.do?ids=" + ids);
			}
		}
		
		function selectDrug(record) {
			if ($(this).combobox("getValues").length > 5) {
				$(this).combobox("unselect", record.id);
				showAlert("错误提示", "最多只能选择五种药品！");
			}
		}
	
	</script>
</body>
</html>