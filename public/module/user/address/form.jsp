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
        <input type="hidden" name="id" value="${userAddress.id}" />
        <input type="hidden" name="userId" value="${userAddress.userId}" />
        <input type="hidden" name="isvalid" value="${empty userAddress.isvalid ? true : userAddress.isvalid}" />
        <table class="form">
	        <tr>
	            <td>所在地区</td>
	            <td>
	                <input id="province" name="province" class="easyui-combobox" value="${userAddress.province}" style="width: 135px;" 
	                    data-options="required:true">
	            </td>
	            <td>
	                <input id="city" name="city" class="easyui-combobox" value="${userAddress.city}" style="width: 135px;"
	                    data-options="required:true">
	            </td>
	            <td>
	                <input id="area" name="area" class="easyui-combobox" value="${userAddress.area}" style="width: 135px;"
	                    data-options="required:true">
	            </td>
	        </tr>
	        <tr>
	            <td>地址</td>
	            <td colspan="3" class="form">
	                <input class="easyui-textbox" name="address" data-options="required:true,validType:'length[0,255]'" value="${userAddress.address}" style="width: 250px;"/>
	            </td>
	        </tr>
            <tr>
                <td>收货人</td>
                <td  colspan="3" class="form">
                    <input class="easyui-textbox" id="linkman" name="linkman" value="${userAddress.linkman}" data-options="required:true,validType:'length[1,100]'"  style="width: 100px;">
                    </td>
            </tr>
            <tr>
                <td>收货人性别</td>
                <td  colspan="3" class="form">
                    <input id="sex-m" name="sex" type="radio" value="1"><label for="sex-m">男</label>
                    &nbsp;&nbsp;
                    <input id="sex-w" name="sex" type="radio" value="0"><label for="sex-w">女</label>
                    </td>
            </tr>
            </tr>
            <tr>
                <td>手机</td>
                <td colspan="3" class="form">
                    <input class="easyui-numberbox" id="linkphone" name="linkphone"  value="${userAddress.linkphone}" data-options="required:true,validType:'length[1,11]'" style="width: 100px;">
                </td>
            </tr>
        </table>
    </form>
    <script>
      var sex = '${userAddress.sex}' || 1;
      $('input[name=sex][value=' + sex + ']').prop('checked', true);
    </script>
</body>
</html>