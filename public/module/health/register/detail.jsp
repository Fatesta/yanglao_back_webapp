<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

	<table class="form">
    	<tr>
    		<td>挂号手机号：</td>
    		<td>${reg.phone }</td>
    	</tr>
    	<tr>
    		<td>医院名称：</td>
    		<td>${reg.hospital }</td>
    	</tr>
    	<tr>
    		<td>医院负责人手机号：</td>
    		<td>${reg.doctor}</td>
    	</tr>
    	<tr>
    		<td>预约时间：</td>
    		<td>${reg.reservationTime}</td>
    	</tr>
    	<%
    	request.setAttribute("newline", "\n");   
        %>
    	<tr>
    		<td>病因：</td>
    		<td>${fn:replace(reg.illness, newline, "<br>")}</td>
    	</tr>
    	<tr>
    		<td>备注：</td>
    		<td>${fn:replace(reg.remark, newline, "<br>")}</td>
    	</tr>
    </table>
