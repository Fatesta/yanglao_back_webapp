<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<div id="tbrCustomer">
    <form id="frmQuery">
        <table class="form">
            <tr>
                <td>按时间</td>
                <td colspan="3">
                    <select id="timeCond" class="easyui-combobox" style="width: 80px;" >
                        <option value="0" selected="selected">全部</option>
                        <option value="1">今日新增</option>
                        <option value="2">昨日新增</option>
                        <option value="3">7天内新增</option>
                        <option value="4">今日联系</option>
                        <option value="5">昨日联系</option>
                        <option value="6">7天内联系</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td>关键字</td>
                <td>
                    <select id="keywordType" class="easyui-combobox" style="width: 80px;" >
						<option value="companyName" selected="selected">公司名</option>
						<option value="linkmanName">姓名</option>
						<option value="mobile">手机</option>
						<option value="telephone">固话</option>
						<option value="QQ">QQ</option>
						<option value="email">邮箱</option>
                    </select>
                    <input id="keywordValue" class="easyui-textbox" style="width: 200px"/>
                </td>
                <td colspan="2">
                    <a name="query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
                </td>
            </tr>
            
            <tr>
                <td colspan="4">

                    <a name="add" class="easyui-linkbutton" data-options="iconCls:'icon-add'">新增客户及联系人</a>

                    <a name="transfer" class="easyui-linkbutton" data-options="iconCls:'icon-set'">转移</a>

                    <a name="delete" class="easyui-linkbutton" data-options="iconCls:'icon-delete'">删除</a>
                </td>
            </tr>
        </table>
    </form>
</div>
<table id="dgCustomer" class="easyui-datagrid" toolbar="#tbrCustomer"
    data-options="
        url:'${urlPath}crm/customer/page.do',
        fit:true">
    <thead>
        <tr>
            <th data-options="field:'customerName', width: 130, halign: 'center', align:'left', formatter: crm.customerManage.formatters.customerName">客户名称</th>
            <th data-options="field:'linkmanName', width: 100, halign: 'center', align:'left'">联系人</th>
            <th data-options="field:'createTime', width: 100, halign: 'center', align:'left'">创建时间</th>
            <th data-options="field:'ownerUsername', width: 100, halign: 'center'">所有者</th>
       </tr>
    </thead>
</table>