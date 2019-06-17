<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- 查询条件 -->
<div>
	<form id="frmQuery">
		<table class="form">
			<tr>
				<%@ include file="adminAndProviderTds.jsp" %>
				<%@ include file="timeRangeAndQueryTds.jsp" %>
			</tr>
		</table>
	</form>
</div>
<!-- Canvas -->
<!--<div id="salesVolumeCanvasDiv"></div>-->
<div id="countCanvasDiv"></div>