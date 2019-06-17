<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
    <%@ include file="dgBoss.jsp" %>
    
<script>
$(function(){
    boss.query();
});

</script>
</body>
</html>