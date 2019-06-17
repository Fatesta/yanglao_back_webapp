<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body class="easyui-layout">
	<div data-options="region:'center',split:true,collapsible:true,title:'学习课件'" style="height:70%;">
		<table id="dgRes" class="easyui-datagrid"
		    data-options="url:'${urlPath }info/page.do',
		                  queryParams: {status: 1},
		                  multiSort:true,
		                  sortOrder:'desc',
		                  rownumbers: true,
		                  fit:true,
		                  onSelect: resDgOnSelect">
		    <thead>
		        <tr>
		            <th data-options="field:'title',width:'20%',halign:'center'">标题</th>
		            <th data-options="field:'thumbnailUrl',width:'6%',halign:'center',formatter: UICommon.datagrid.formatter.generators.image({height:40})">缩略图</th>
                    <th data-options="field:'filename',width:'20%',halign:'center'">课件名</th>
		            <th data-options="field:'url',width:'30%',halign:'center',formatter:UICommon.datagrid.formatter.wraptip">URL</th>
                    <th data-options="field:'fileType',width:'4%',halign:'center', formatter: function(v) { return {1:'视频',2:'音频', 3:'图文'}[v]; }">文件类型</th>
                    <th data-options="field:'duration',width:'6%',halign:'center',formatter: formatters.duration">时长</th>
		        </tr>
		    </thead>
		</table>
	</div>
	<div data-options="region:'south',split:true,collapsible:true,title:'学习计划'" style="height:30%;">
        <div id="tbr">
            <form id="frmQuery">
	            <input name="classesId" type="hidden" value="${classesId}">
	            <table class="form">
	               <tr>
	                   <c:forEach var="func" items="${ROLE_FUNCS}">
	                       <td><a id="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a></td>
	                   </c:forEach>
	                </tr>
	            </table>
            </form>
        </div>
        <table id="dg" class="easyui-datagrid" toolbar="#tbr"
            data-options="url:'${urlPath}mbkf/classesLearningPlan/page.do',
                          fit:true">
            <thead>
                <tr>
                    <th data-options="field:'weekDay', width:'10%', halign:'center', formatter: formatters.weekDay">重复</th>
                    <th data-options="field:'weekTime', width:'10%', halign:'center', formatter: formatters.weekTime">时间</th>
                    <th data-options="field:'createTime', width:'10%', halign:'center'">创建时间</th>
                    </tr>
            </thead>
        </table>
	</div>
	
<script>
var PAGE_CONFIG = {classesId: '${classesId}'};
</script>
<script src="${modulePath}health/mbkf/learningplan.js"></script>

</body>
</html>