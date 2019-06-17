<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="easyui-tabs" data-options="fit:true">
    <div title="客户管理">
        <%@ include file="customer/index.jsp" %>
    </div>
</div>

<script src="${modulePath}crm/index.js"></script>
<script src="${modulePath}crm/customer.js"></script>