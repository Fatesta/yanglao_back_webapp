<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
    <form id="form" method="post">
        <c:if test="${not empty serviceDetail.serviceCode}">
            <input name="serviceCode" value="${serviceDetail.serviceCode}" type="hidden" />
        </c:if>
        <table class="form">
            <tr>
                <td>服务名称</td>
                <td>
                    <input id="serviceName" class="easyui-textbox" name="serviceName" value="${serviceDetail.serviceName}" style="width: 300px;"
                        data-options="<c:if test='${empty serviceDetail.serviceCode}'>events:{blur:serviceNameOnBlur},</c:if>required:true,validType:'length[1,100]'">
                </td>
            </tr>
            <c:if test="${empty serviceDetail.serviceCode}">
            <tr>
                <td>服务编码</td>
                <td>
                    <input id="serviceCode" class="easyui-textbox" name="serviceCode" value="${serviceDetail.serviceCode}" style="width: 300px;"
                        data-options="required:true,validType:'length[1,100]'">
                </td>
            </tr>
            </c:if>
            <tr>
                <td>服务单位</td>
                <td>
                    <select name="unit" class="easyui-combobox" value="${serviceDetail.unit}" data-options="required: true" style="width:100px;">
                        <option value="">无单位</option>
                        <option value="次" >次</option>
                        <option value="套">套</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td>服务类别</td>
                <td>
                    <select id="categoryCode" name="categoryCode" class="easyui-combobox"
                        data-options="
                        required: true,
                        url: '/cardConsume/serviceCategory/list.do',
                        valueField: 'categoryCode',
                        textField: 'categoryName',
                        value: '${serviceDetail.categoryCode}'"
                        style="width:100px;">
                    </select>
                </td>
            </tr>
            <tr id="serviceDescTr">
                <td>服务介绍</td>
                <td><textarea rows="6" cols="70" class="easyui-validatebox" name="serviceDesc" data-options="validType:'length[0,500]'"></textarea></td>
            </tr>
            <tr>
                <td>显示顺序</td>
                <td>
                    <input class="easyui-numberbox" name="sort" value="${serviceDetail.sort}" style="width: 100px;"
                        data-options="required:true,precision:0">
                    (数值越小表示越靠前)
                </td>
            </tr>
        </table>
    </form>
</body>
</html>