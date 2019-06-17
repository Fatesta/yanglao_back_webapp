<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

	<script id="editor" type="text/plain" style="width:100%;height:100%;"></script>

	<script>
	window.UEDITOR_HOME_URL = '${libPath}ueditor1_4_3_3-utf8-jsp/';
	</script>
	<script src="${libPath}ueditor1_4_3_3-utf8-jsp/ueditor.config.js"></script>
	<script src="${libPath}ueditor1_4_3_3-utf8-jsp/ueditor.all.js"></script>
	<script src="${modulePath}scan/edit.js?v=1"></script>