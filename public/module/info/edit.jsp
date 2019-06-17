<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="infoFormLayout" class="easyui-layout">
	<div data-options="region:'west',title:'编辑基本信息',split:true,collapsible:true" style="width: 30%; height:100%;">
	    <form id="form" method="post"  enctype="multipart/form-data" style="padding-right: 10px;">
	        <input type="hidden" name="id" value="${id}" />
	        <input type="hidden" name="content" />
	        <input type="hidden" name="url" />
	        <input type="hidden" name="filename" />
	        <input type="hidden" name="fileType" />
	        <input type="hidden" name="duration" />
	        <input type="hidden" name="thumbnailUrl" />
	        <input type="hidden" name="status" value="0"/>
	        <table class="form">
	            <tr colspan="2">
	                <td>标题</td>
	                <td><input class="easyui-textbox" name="title" data-options="required:true,validType:['length[2,100]']" style="width:250px;"></td>
	            </tr>
	            <c:if test="${id == null}">
	            <tr>
	                <td>分类</td>
	                <td>
	                    <input class="easyui-combobox" id="category" name="category" style="width:100px;"/>
	                    <input class="easyui-combobox" id="category2" name="childCategory" style="width:100px;"/>
	                </td>
	            </tr>
	            </c:if>
	            <tr>
	                <td>简述</td>
	                <td><textarea rows="5" class="easyui-validatebox" name="remark" style="width:250px;"></textarea></td>
	            </tr>
	            <tr>
		            <td>缩略图</td>
		            <td>
                        <a class="easyui-linkbutton" data-options="iconCls:'icon-edit'" id="updateImg" href="#">上传</a>
                        <div style="color:red">提示：为了APP端显示美观，图片尺寸最好为正方形，建议尺寸：300x300、400x400</div>
		            </td>
		        </tr>
                <tr>
                    <td></td>
                    <td>
                        <img id="thumbnailImg" src="" style="max-width:300px;max-height:300px">
                    </td>
                </tr>
		        <c:if test="${empty id}">
	            <tr>
	                <td>同步社区论坛帖子</td>
	                <td>
	                    <input id="syncBbsPost" type="checkbox" checked='checked' />
	                </td>
	            </tr>
	            </c:if>
	            <tr>
	               <td></td>
	               <td>
	                   <span id="uploadMsg" style="color:red">
	                       <c:if test="${empty id}">注意：编辑图文中上传附件之前必须先选择资讯分类！</c:if></span>
	               </td>
	            </tr>
                <tr>
                    <td></td>
                    <td>
                        <a id="save" class="easyui-linkbutton" data-options="iconCls:'icon-save'"
                            style="margin-top: 20px;margin-right: 10px;float: right;">保存</a>
                    </td>
                </tr>
	        </table>
	    </form>
	</div>
	
	<div data-options="region:'center',title:'编辑图文', split:true,collapsible:true" style="width: 70%; height:100%;">
	    <script id="infoEditor" type="text/plain" style="width:100%;height:100%;"></script>
	</div>
</div>
<script>
window.UEDITOR_HOME_URL = '${libPath}ueditor1_4_3_3-utf8-jsp/';
</script>
<script src="${libPath}ueditor1_4_3_3-utf8-jsp/ueditor.config.js"></script>
<script src="${libPath}ueditor1_4_3_3-utf8-jsp/ueditor.all.js"> </script>
<script src="${modulePath}info/category/category.js"></script>
		<script src="/lib/utils/require.js"></script>

		<script src="${modulePath}info/edit.js"></script>
</body>
</html>