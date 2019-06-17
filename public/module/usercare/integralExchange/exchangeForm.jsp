<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

    <style>
        .section {
          margin-bottom: 10px;
        }
        .section h4 {
          background: #e7e7e7;
        }
    </style>

	<div>
		<div id="userForm" class="section">
		    <h4>选择用户</h4>
			<input type="hidden" name="accountId"/>
			<table class="form" style="margin-left: 4px;">
				<tr>
					<td>用户昵称</td>
					<td name="selectUser">
					   <input class="easyui-textbox" name="userName" data-options="disabled:true" style="width: 100px"/>
					</td>
                    <td>姓名</td>
                    <td>
                       <input class="easyui-textbox" name="realName" data-options="disabled:true" style="width: 70px"/>
                    </td>
					<td>电话号码</td>
					<td><input class="easyui-textbox" name="telphone" data-options="disabled:true" style="width: 90px" /></td>
					<td>当前积分</td>
					<td><input class="easyui-numberbox" name="integral" data-options="disabled:true" style="width: 60px" /></td>
					<td>
					   <a name="selectUser" class="easyui-linkbutton" data-options="iconCls: 'icon-choose'"></a></td>
				</tr>
			</table>
		</div>

		<div class="section">
		    <h4>选择商品</h4>
		    <div id="tbrProduct">
				<form id="frmProductQuery">
					<table class="form">
						<tr>
							<td>商品名称</td>
							<td><input class="easyui-textbox filter" name="productName" style="width: 216px;" /></td>
							<td><a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" name="query">查询</a></td>
						<tr>
					</table>
				</form>
			</div>
			<table id="dgProduct" toolbar='#tbrProduct' style="height: 222px">
				<thead>
					<tr>
						<th data-options="field:'name',width:260,align:'left'">商品名称</th>
						<th data-options="field:'imageFile',width:80,align:'center',formatter:formatters.imageFile">缩略图</th>
						<th data-options="field:'providerName',width:180,halign:'center'">属于店铺</th>
						<th data-options="field:'price',width:70,align:'center'">积分</th>
						<th data-options="field:'stock',width:60,align:'center'">库存数量</th>
						<th data-options="field:'op',width:66,align:'center',formatter:formatters.addOp">操作</th>
					</tr>
				</thead>
			</table>
		</div>
		
		<div class="section">
			<h4>已选择商品和兑换数量</h4>
	        <table id="dgSelectedProduct" class="easyui-datagrid"
	           data-options="fit:false, pagination:false, idField: 'productId'">
	            <thead>
	                <tr>
                        <th data-options="field:'name',width:260,align:'left'">商品名称</th>
                        <th data-options="field:'imageFile',width:80,align:'center',formatter:formatters.imageFile">缩略图</th>
                        <th data-options="field:'providerName',width:180,halign:'center'">属于店铺</th>
                        <th data-options="field:'price',width:70,align:'center'">积分</th>
                        <th data-options="field:'stock',width:60,align:'center'">库存数量</th>
	                    <th data-options="field:'quantityOp',width:66,align:'center',formatter:formatters.quantityOp">数量</th>
	                </tr>
	            </thead>
	        </table>
        </div>
		<div class="section">
			<table class="form" style="float: right;">
				<td>已选择商品总积分</td>
					<td><input class="easyui-numberbox" id="totalIntegral" disabled='true' style="width:70px;"/></td>
				</tr>
	            <td>实付积分</td>
	                <td><input class="easyui-numberbox" id="exchangeIntegral" disabled='true' style="width:70px;"/></td>
	            </tr>
			</table>
		</div>
		
	</div>

	<script src="${modulePath}usercare/integralExchange/exchangeForm.js?v=1"></script>
	<script src="${modulePath}user/select.js"></script>
