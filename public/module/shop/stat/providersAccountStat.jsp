<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 查询条件 -->
<div>
	<form id="frmQuery">
		<table class="form">
			<tr>
				<%@ include file="adminAndProviderTds.jsp" %>
				<td>类型</td>
				<td>
					<select class="easyui-combobox" id="tradeType" name="tradeType" style="width:100px;">   
					    <option value="3">销售额</option>
					    <option value="4">用户充值</option>   
					</select>
				</td>
				<%@ include file="timeRangeAndQueryTds.jsp" %>
			</tr>
		</table>
	</form>
</div>
<!-- Canvas -->
<div id="accountCanvasDiv"></div>
