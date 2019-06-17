<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:if test="${adminRole.id == 1 or adminRole.id == 14 or adminRole.id == 15}">
	<td>社区</td>
	<td>
		<input id="orgId" name="orgId" class="easyui-combobox"/>
	</td>
</c:if>
<c:if test="${adminRole.id == 1 or adminRole.id == 9 or adminRole.id == 14 or adminRole.id == 15}">
	<td>商家</td>
	<td>
		<input class="easyui-combobox" id="cboBoss" name="bossId" style="width: 150px;">
	</td>
</c:if>
<c:if test="${empty sysAdmin}">
	<input name="bossId" type="hidden" value="${boss.adminId}"/>
</c:if>
<td>店铺</td>
<td>
	<input class="easyui-combobox" id="cboProvider" name="providerId" style="width: 220px;">
</td>