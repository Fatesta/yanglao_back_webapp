<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

	    <div id="tbrQuestionOption">
			<table class="form">
			   <tr>
		           <c:forEach var="func" items="${ROLE_FUNC_MAP['manageQuestionOption'].children}">
		               <td><a id="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a></td>
		           </c:forEach>
				</tr>
			</table>
		</div>
		<table id="dgQuestionOption" class="easyui-datagrid" toolbar="#tbrQuestionOption">
		    <thead>
		        <tr>
		            <th data-options="field:'orderno', width:'3%', halign: 'center', align:'center'">序号</th>
		            <th data-options="field:'content', width:'50%', halign: 'center', align:'left', formatter: UICommon.datagrid.formatter.generators.omit({dgId: 'dgQuestionOption', min: 80, field: 'content'})">内容</th>
		        	</tr>
		    </thead>
		</table>
    </div>
    
