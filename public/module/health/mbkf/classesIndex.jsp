<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="tbr">
    <form id="frmQuery">
	<table class="form">
		<tr><td colspan="6">
	           <c:forEach var="func" items="${ROLE_FUNCS}">
              <a id="${func.code}" data-id="${func.id}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a>
          </c:forEach></td>
           </tr>
	   <tr>
	    <td>班级名称</td>
           <td>
               <input class="easyui-textbox" name="className" type="text">
           </td>

                <td>分类</td>
                <td>
                    <input class="easyui-combobox" name="category"
                        data-options="
                            url: '${urlPath }dict/listByPid.do?pid=information_health',
                            valueField: 'did',
                            textField: 'name',
                            loadFilter: function(arr) {
                              arr.unshift({did: '', name: '全部'});
                              return arr;
                            }"
                        style="width:100px;"/>
                </td>

                <td>课程分类</td>
                <td>
                    <input class="easyui-combobox" name="courseType"
                        data-options="
                            url: '${urlPath }dict/listByPid.do?pid=learning_class',
                            valueField: 'did',
                            textField: 'name',
                            loadFilter: function(arr) {
                              arr.unshift({did: '', name: '全部'});
                              return arr;
                            }"
                        style="width:100px;"/>
                </td>

           <td colspan="7">
               <a id="query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
           </td>
		</tr>
	</table>
    </form>
</div>
<table id="dg" class="easyui-datagrid" toolbar="#tbr"
    data-options="url:'${urlPath}mbkf/classes/page.do',
                  singleSelect:false,
                  fit:true">
    <thead>
        <tr>
        	<th data-options="field:'thumbnailUrl',width:'9%',halign:'center',formatter: formatters.thumbnailUrl">封面图片</th>
            <th data-options="field:'className', width:'8%', halign:'center'">班级名</th>
            <th data-options="field:'startDate', width:'6%', halign:'center'">开班日期</th>
            <th data-options="field:'endDate', width:'6%', halign:'center'">结束日期</th>
            <th data-options="field:'remark', width:'12%', halign:'center', formatter: UICommon.datagrid.formatter.generators.omit({dgId:'dg',field:'remark',min:40})">开班简介</th>
            <th data-options="field:'summary', width:'12%', halign:'center', formatter: UICommon.datagrid.formatter.generators.omit({dgId:'dg',field:'summary',min:40})">课程小结</th>
            <th data-options="field:'category', width:'10%', halign:'center'">分类</th>
            <th data-options="field:'courseType', width:'10%', halign:'center'">课程分类</th>
            <th data-options="field:'coursePrice', width:'10%', halign:'center', formatter: UICommon.datagrid.formatter.money">价格(元)</th>
        	</tr>
    </thead>
</table>

<script src="${modulePath}health/mbkf/classes.js"></script>

</body>
</html>