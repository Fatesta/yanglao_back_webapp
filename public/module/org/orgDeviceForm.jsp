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
    <div id="orgDeviceTab" class="easyui-tabs" data-options="fit:true">
        <div title="已分配的呼贝(${org.name })" style="display:none;">
        	<div id="orgDeviceImportToolbar">
        		<form id="uploadDeviceForm" method="post" enctype="multipart/form-data">
			    	<input type="hidden" id="myOrgId2" name="orgId" value="${org.id }">
				    <table class="form">
				    	<tr>
				    		<td><label for="name">上传文件</label></td>
				    		<td>
				    			<input class="easyui-filebox" name="file" required="required" style="width:300px" data-options="buttonText:'选择文件'">
                                <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-download'"
                                    onclick="downloadTemplate()">下载模板</a>
						 		<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-import'"
						            onclick="importDevice()">导入</a>
				    		</td>
				    	</tr>
				    </table>
				</form>
				<form id="addDeviceForm" method="post">
					<table class="form">
						<tr>
				    		<td><label for="myDeviceCode">设备号&nbsp;&nbsp;&nbsp;</label></td>
				    		<td>
					    		<input class="easyui-numberbox" id="myDeviceCode" name="myDeviceCode" style="width: 300px;"
			    					data-options="required:true,validType:'length[13,15]'">
			    				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'"
						            onclick="addDevice()">添加</a>
		    				</td>
				    	</tr>
			    	</table>
				</form>
        	</div>
        	<table id="orgDeviceGrid" class="easyui-datagrid"
				data-options="url:'${urlPath }org/listDevice.do?orgId=${org.id }',
							  fit:true,
							  toolbar:'#orgDeviceImportToolbar',
							  fitColumns:true">
			    <thead>
			        <tr>
			            <!-- <th data-options="field:'id',checkbox:true"></th> -->
			            <th data-options="field:'deviceCode',width:200,halign:'center'">设备号</th>
			            <th data-options="field:'aliasName',width:150,halign:'center'">昵称</th>
			            <th data-options="field:'telphone',width:120,halign:'center'">手机号</th>
			            <th data-options="field:'-',width:100,halign:'center',formatter:formatOp">操作</th>
			        </tr>
			    </thead>
			</table>
        </div>
        <c:if test="${curAdmin.id==1 }"><!-- 非亲情互联用户不能看到该tab -->
        <div title="未分配的呼贝">
        	<div id="unmanageOrgDeviceToolbar">
	        	<form id="searchUnmanageOrgDeviceForm" method="post">
			    	<input type="hidden" id="myOrgId" name="orgId" value="${org.id }">
				    <table class="form">
				   		<tr>
				    		<td>
								设备号
							</td>
							<td style="width: 550px;">
								<input class="easyui-textbox filter" name="deviceCode" type="text">
								<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'"
				            		onclick="searchUnmanageOrgDevice()">查询</a>
				            	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'"
				            		onclick="addOrgDevice()">分配</a>
							</td>
						</tr>
				    </table>
				</form>
        	</div>
        	<table id="unmanageOrgDeviceGrid" class="easyui-datagrid"
				data-options="url:'${urlPath }org/listUnmanageDevice.do',
							  fit:true,
							  fitColumns:true,
							  queryParams:{
							  	orgId:'${org.id }'
							  },
							  toolbar:'#unmanageOrgDeviceToolbar'">
			    <thead>
			        <tr>
			        	<th data-options="field:'id',checkbox:true"></th>
			            <th data-options="field:'deviceCode',width:600,halign:'center'">设备号</th>
			        </tr>
			    </thead>
			</table>
        </div>
        </c:if>
    </div>
</body>
</html>