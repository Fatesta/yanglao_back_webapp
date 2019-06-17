<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div data-options="region:'south',split:true,collapsible:true" style="height:40%;">
    <div id="tabs" class="easyui-tabs" data-options="fit:true">
        <div title="轮播图片" data-options="selected:true,closable:false">
		    <div id="tbrDgProductImage1">
		        <table class="form">
		            <tr>
		                <c:forEach var="fn" items="${session_role_leaf_fn_list}">
		                    <c:if test="${fn.parentId == 156}">
		                        <td>
		                            <a href="#" class="easyui-linkbutton" data-options="iconCls:'${fn.icon}'" name="${fn.code}">${fn.funcName}</a>
		                        </td>
		                    </c:if>
		                </c:forEach>
		            </tr>
		        </table>
		    </div>
		    <table id="dgProductImage1" class="easyui-datagrid" toolbar='#tbrDgProductImage1'>
		        <thead>
		            <tr>
		                <th data-options="field:'imgPath',width:'10%',halign:'center', formatter:ProductImageManager.formatters.imgPath">商品图片</th>
		                <th data-options="field:'createTime',width:'10%',halign:'center'">上传日期</th>
		            </tr>
		        </thead>
		    </table>
        </div>
        <div title="详情图片">
            <div id="tbrDgProductImage2">
                <table class="form">
                    <tr>
                        <c:forEach var="fn" items="${session_role_leaf_fn_list}">
                            <c:if test="${fn.parentId == 156}">
                                <td>
                                    <a href="#" class="easyui-linkbutton" data-options="iconCls:'${fn.icon}'" name="${fn.code}">${fn.funcName}</a>
                                </td>
                            </c:if>
                        </c:forEach>
                    </tr>
                </table>
            </div>
            <table id="dgProductImage2" class="easyui-datagrid" toolbar='#tbrDgProductImage2'> 
                <thead>
                    <tr>
                        <th data-options="field:'imgPath',width:'10%',halign:'center', formatter:ProductImageManager.formatters.imgPath">商品图片</th>
                        <th data-options="field:'createTime',width:'10%',halign:'center'">上传日期</th>
                    </tr>
                </thead>
            </table>
        </div>
    </div>
</div>