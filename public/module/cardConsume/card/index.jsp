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
		  <tr>
              <c:forEach var="func" items="${ROLE_FUNCS}">
                  <td><a id="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a></td>
              </c:forEach>
           </tr>
		</table>
    </form>
</div>
<table id="dg" class="easyui-datagrid" toolbar="#tbr"
    data-options="url:'${urlPath}cardConsume/card/page.do',
                  fit:true">
    <thead>
        <tr>
            <th data-options="field:'cardName', width:'12%', halign:'center', align:'left'">卡名称</th>
            <th data-options="field:'coverImage', width:'5%', halign:'center', align:'center', formatter: UICommon.datagrid.formatter.generators.image({height: 30})">封面图片</th>
            <th data-options="field:'contactNumber', width:'8%', halign:'center', align:'left'">联系电话</th>
            <th data-options="field:'expirationDate', width:'6%', halign:'center', align:'left'">有效期限(天)</th>
            <th data-options="field:'price', width:'6%', halign:'center', align:'left', formatter: UICommon.datagrid.formatter.money">价格</th>
            <th data-options="field:'isvalid', width:'4%', halign:'center', align:'left', formatter: UICommon.datagrid.formatter.enable">状态</th>
<!--             <th data-options="field:'quantity', width:'7%', halign:'center', align:'left'">卡发行数量</th> -->
            <th data-options="field:'privilegeSpecification', width:'18%', halign:'center', align:'left', formatter: UICommon.datagrid.formatter.generators.omit({field: 'privilegeSpecification'})">特权说明</th>
            <th data-options="field:'description', width:'18%', halign:'center', align:'left', formatter: UICommon.datagrid.formatter.generators.omit({min: 15, field: 'description'})">描述</th>
            <th data-options="field:'useNotice', width:'18%', halign:'center', align:'left', formatter: UICommon.datagrid.formatter.generators.omit({field: 'useNotice'})">使用须知</th>
        	</tr>
    </thead>
</table>

<script src="${modulePath}cardConsume/card/index.js"></script>

</body>
</html>