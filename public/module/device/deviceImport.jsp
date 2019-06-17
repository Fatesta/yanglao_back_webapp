<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

    <form name="deviceImportForm" enctype="multipart/form-data" method="post">
	    <table class="form">
	        <tr>
                <td>
                    <a id="downloadFile" class="easyui-linkbutton" data-options="iconCls:'icon-download'">下载模板文件</a>
                </td>
	        </tr>
	        <tr>
	            <td>
	                <input class="easyui-filebox" name="file" data-options="buttonText:'选择文件'">
	            </td>
	        </tr>
	    </table>
    </form>