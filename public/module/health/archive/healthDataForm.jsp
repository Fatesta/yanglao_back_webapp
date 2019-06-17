<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="/module/common.jsp" %>
	<style>
		.model-form {
			width: 500px !important;
		}
	</style>
</head>
<body>
<div class="model-form-panel">
    <form id="healthDataForm" method="post" >
    	<input type="hidden" name="userId" value="${userId }" >
	    <table class="model-form form"  border:"2px">
			<tr>
				<th style="text-align: center">检测项</th>
				<th style="text-align: center">数值</th>
				<th style="text-align: center">正常值范围及单位</th>
			</tr>
	    	<tr>
				<th colspan="3" style="text-align: left">基本</th>
    		</tr>
			<tr>
	    		<td style="width: 100px">身高：</td>
	    		<td style="width: 100px"><input class="easyui-numberbox" name="height" data-options="required:false,precision:1" style="width: 60px;"></td>
	    		<td style="width: 300px">cm</td>
	    	</tr>
	    	<tr>	
	    		<td>体重：</td>
	    		<td><input class="easyui-numberbox" name="weight" data-options="required:false,precision:1" style="width: 60px;"></td>	    		
	    		<td>kg</td>
	    	</tr>
			<tr>
	    		<td>睡眠：</td>
	    		<td><input class="easyui-numberbox" name="sleep" data-options="required:false,precision:0" style="width: 60px;"></td>
	    		<td>分钟</td>	    		
	    	</tr>
	    	<tr>
	    		<td>心率：</td>
	    		<td><input class="easyui-numberbox" name="heartBeat" data-options="required:false,precision:0" style="width: 60px;"></td>
	    		<td>(60~100)次/分钟</td>
	    	</tr>
	    	<tr >
	    		<th colspan="3" style="text-align: left">血压</th>
    		</tr>
    		<tr>	
    			<td>舒张压：</td>
	    		<td><input class="easyui-numberbox" name="diastolicPressure" data-options="required:false,precision:0" style="width: 60px;"></td>
    			<td>(60~100)mmHg</td>
            </tr>
            <tr>
	    		<td>收缩压：</td>
	    		<td><input class="easyui-numberbox" name="systolicPressure" data-options="required:false,precision:0" style="width: 60px;"></td>
	    		<td>(110~150)mmHg</td>
	    	</tr>

	    	<tr >
				<th colspan="3" style="text-align: left">血糖</th>
    		</tr>
	    	
	    	<tr>
	    		<td>血糖：</td>
	    		<td><input class="easyui-numberbox" name="bloodSugar" data-options="required:false,precision:1" style="width: 60px;"></td>
	    		<td>(3.9~6.1)mmol/L</td>
	    	</tr>
	    	
	    	<tr >
	    		<th colspan="3" style="text-align: left">肝功能</th>
    		</tr>
	    	
	    	<tr>
	    		<td>肝蛋白：</td>
	    		<td><input class="easyui-numberbox" name="liverProtein" data-options="required:false,precision:0" style="width: 60px;"></td>
	    		<td>(129~216)g/L</td>
	    	</tr>
	    	
	    	<tr>
	    		<td>血红蛋白：</td>
	    		<td><input class="easyui-numberbox" name="hemoglobin" data-options="required:false,precision:0" style="width: 60px;"></td>
	    		<td>(110~160)g/L</td>
	    	</tr>
	    	
	    	<tr>
	    		<td>谷丙转氨酶：</td>
	    		<td><input class="easyui-numberbox" name="glutamicPyruvicTransaminase" data-options="required:false,precision:0" style="width: 60px;"></td>
	    		<td>(9~50)U/L</td>
	    	</tr>

	</table>
	</form>
	<div class="form-submit-buttons">
		<a id="submit" class="easyui-linkbutton" data-options="iconCls:'icon-save'">提交</a>
		<a id="back" class="easyui-linkbutton" data-options="iconCls:'icon-back'">返回</a>
	</div>
</div>

<script src="${modulePath}health/archive/healthDataForm.js"></script>
</body>
</html>