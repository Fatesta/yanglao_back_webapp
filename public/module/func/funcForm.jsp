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
	<form id="funcForm" method="post">
	    <input type="hidden" name="id" value="${func.id}" />
	    <table class="form">
	       <%--
	           现在已有代码依赖于功能id，因暂不支持修改id
            <tr>
                <td>ID</td>
                <td>
                    <input class="easyui-numberbox" name="id" value="${func.id}" style="width: 250px;"
                        data-options="precision:0,editable:false">
                </td>
            </tr>
             --%>
            <tr>
                <td>父ID</td>
                <td>
                    <input class="easyui-numberbox" name="parentId" value="${func.parentId}" style="width: 250px;"
                        data-options="required:true,precision:0">
                </td>
            </tr>
	    	<tr>
	    		<td><label for="funcName">功能名称</label></td>
	    		<td>
	    			<input class="easyui-textbox" name="funcName" value="${func.funcName}" style="width: 250px;"
	    				data-options="required:true,validType:'length[1,20]'">
	    		</td>
	    	</tr>
	    	<tr>
	    		<td><label for="code">Code</label></td>
	    		<td>
	    			<input class="easyui-textbox" name="code" value="${func.code}" style="width: 250px;" 
	    				data-options="validType:'length[0,200]'">
	    		</td>
	    	</tr>
	    	<tr>
	    	  <td></td>
	    	  <td>
	              <c:if test="${func.id != null}">
	              <span class="warning-text">(修改前请检查引用)</span></c:if>
	    	  </td>
	    	</tr>
	    	<tr>
	    		<td><label for="url">URL</label></td>
	    		<td>
	    			<input class="easyui-textbox" name="url" value="${func.url}" style="width: 250px;" 
	    				data-options="validType:'length[0,300]'">
	    		</td>
	    	</tr>
	    	<tr>
	    		<td><label for="icon">图标</label></td>
	    		<td>
	    			<input class="easyui-combobox" name="icon" value="${func.icon}" style="width: 250px;" 
        				data-options="valueField:'id',textField:'text',url:'${urlPath }func/listIcon.do',editable:true,showItemIcon:true">
	    		</td>
	    	</tr>
            <tr>
                <td>序号</td>
                <td>
                    <input class="easyui-numberbox" name="orderno" value="${func.orderno}" style="width: 250px;"
                        data-options="precision:0">
                </td>
            </tr>
	    	<tr>
	    		<td><label for="isMenu">是否菜单</label></td>
	    		<td><input id="isMenu" type="checkbox" name="isMenu" <c:if test="${func.isMenu}">checked="checked"</c:if>></td>
	    	</tr>
            <tr>
                <td><label for="isShow">是否显示</label></td>
                <td><input id="isShow" type="checkbox" name="isShow" <c:if test="${empty func.isShow ? true : func.isShow}">checked="checked"</c:if>></td>
            </tr>
	    </table>
	</form>
</body>
</html>