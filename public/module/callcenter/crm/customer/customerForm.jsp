<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<style>
.customer-add-table {
    width: 100%;
}
.customer-add-table caption {
    margin-left: 4px;
    background-color: rgb(249, 249, 249);
    font-weight: bold;
    text-align: left;
    height: 20px;
    line-height: 20px;
}
</style>
<form id="customerAndLinkmanForm">
	<table class="form customer-add-table">
	   <tr>
	       <td style="width:36px">分类</td>
	       <td>
	           <label><input type="radio" name="type" value="2" checked="">公司</label>
	           <label><input type="radio" name="type" value="1">个人</label></span>
	       </td>
	   </tr>
	</table>

	<table id="companyTable" class="form customer-add-table">
	    <caption>客户信息</caption>
	    <tr id="companyTr">
	        <td style="width:50px">公司名称</td>
	        <td colspan="5"><input name="companyName" class="easyui-textbox" data-options="required: true" style="width: 120px"/></td>
	    </tr>
	    <tr>
	        <td>来源</td>
	        <td><input name="source" class="easyui-combobox" style="width:100px"/></td>
	        <td style="width:36px">类型</td>
	        <td colspan="3"><input name="category" class="easyui-combobox" style="width:60px"/></td>
	    </tr>
	    <tr>
	        <td>地址</td>
	        <td colspan="5"><input name="address" class="easyui-textbox" style="width:200px"/></td>
	    </tr>
	
	    <tr>
	        <td>备注</td>
	        <td colspan="5"><textarea name="address" class="easyui-validatebox" rows="2"  style="width:300px"></textarea></td>
	    </tr>
	</table>
	
	<table id="customerTable" class="form customer-add-table">
	    <caption>联系人</caption>
	    <tr>
	        <td>姓名</td>
	        <td colspan="5"><input name="linkmanName" class="easyui-textbox" data-options="required: true" style="width: 120px"/></td>
	    </tr>
	    <tr>
	        <td>性别</td>
	        <td><input name="gender" class="easyui-combobox" style="width:100px"/></td>
	        <td>手机</td>
	        <td><input name="mobile" class="easyui-textbox" style="width: 120px"/></td>
	        <td>固话</td>
	        <td><input name="telephone" class="easyui-textbox" style="width: 120px"/></td>
	    </tr>
	    <tr>
	        <td>类型</td>
	        <td><input name="linkmanType" class="easyui-combobox" style="width:100px"/></td>
	        <td>QQ</td>
	        <td><input name="qq" class="easyui-textbox" style="width: 120px"/></td>
	        <td>传真</td>
	        <td><input name="fax" class="easyui-textbox" style="width: 120px"/></td>
	    </tr>
	    <tr>
	        <td>邮箱</td>
	        <td colspan="5"><input name="email" class="easyui-textbox" style="width:200px"/></td>
	    </tr>
	</table>
</form>