<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <link rel="stylesheet" type="text/css" href="${libPath}spectrum/spectrum.css">

        <div id="tbrLocIcon">
	        <table class="form">
		        <tr>
		            <c:forEach var="func" items="${ROLE_FUNCS}">
		                <td><a name="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a></td>
		            </c:forEach>
		        </tr>
	        </table>
        </div>
		<table id="dgLocIcon" class="easyui-datagrid"
		    data-options="url:'${urlPath }telecare/locIcon/page.do',
		                  pageSize:10,
		                  fit: true,
		                  toolbar: '#tbrLocIcon'">
		    <thead>
		        <tr>
		            <th data-options="field:'location',width:150,halign:'center'">区域</th>
		            <th data-options="field:'icon',width:'50',align:'center', formatter: UICommon.datagrid.formatter.generators.image({width: 50, height: 30})">图标</th>
                    <th data-options="field:'color',width:'54',align:'center', formatter: locIconManage.formatters.color">颜色</th>
		        </tr>
		    </thead>
		</table>
		
		<script src="${modulePath}telecare/locIcon/locIcon.js?v=1"></script>
