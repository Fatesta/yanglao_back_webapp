<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<form id="userQuerierForm">
	<table class="form">
	    <tr>
	        <td>昵称</td>
	        <td>
	            <input class="easyui-textbox filter" name="aliasName" type="text" style="width: 80px;">
	        </td>
	    </tr>
	    <tr>
	        <td>姓名</td>
	        <td>
	            <input class="easyui-textbox filter" name="realName" type="text"  style="width:80px;">
	        </td>
	    </tr>
        <tr>
            <td>身份证号码</td>
            <td>
                <input class="easyui-textbox filter" name="idcard" type="text" style="width: 140px;">
            </td>
        </tr>
	    <tr>
	        <td>手机号码</td>
	        <td>
	            <input class="easyui-textbox filter" name="telphone" type="text" style="width: 100px;">
	        </td>
        </tr>
		<tr>
            <td>用户类型</td>
            <td>
                <input class="easyui-combobox filter" name="userType" style="width: 100px;">
            </td>
        </tr>
        <tr name="deviceCondTr" style="display:none">
            <td>设备号</td>
            <td>
                <input class="easyui-textbox filter" name="deviceCode" style="width: 120px;">
            </td>
        </tr>
        <tr name="cardUserCondTr" style="display:none">
            <td>卡号</td>
            <td>
                <input class="easyui-textbox" name="cardCode" style="width: 120px;">
            </td>
        </tr>
        <c:if test="${curAdmin.roleId == 1 || curAdmin.roleId == 13 || curAdmin.roleId == 14 || curAdmin.roleId == 15}">
        <tr>
            <td><label for="orgId">社区</label></td>
            <td>
                <input class="easyui-combotree" name="orgId" style="width:308px;"
                    data-options="
                            valueField:'id',
                            textField:'name',
                            url:'${urlPath }org/listOrg.do',
                            checkbox: true,
                            multiple: false,
                            cascadeCheck: false,
                            loadFilter: function(arr) {
                              arr.unshift({id: '', text: '全部', iconCls: 'icon-blank'});
                              return arr;
                            }" />
            </td>
        </tr>
        </c:if>
        <c:if test="${not disableApplyTypes}">
        <tr>
            <td style="width:90px">申请对象类型</td>
            <td colspan="3">
                <select name="applyTypeJoinPredicate" class="easyui-combobox" style="width: 100px;">
                    <option value="or">至少符合一个</option>
                    <option value="and">同时符合全部</option>
                </select>
                <input name="applyTypes" class="easyui-combogrid"
                       data-options="
                                               editable: false,
                                               multiple: true,
                                               singleSelect: false,
                                               idField:'value',
                                               textField: 'text',
                                               separator: '、',
                                               data: DictMan.items('evalOldman.applyType'),
                                               columns:[[
                                                   {field: 'value', width: '100%', checkbox: true},
                                                   {field: 'text', width: '100%'}
                                               ]]"
                       style="width:220px;"/>
            </td>
        </tr>
        </c:if>
        <tr>
            <td style="width:90px">特殊老人</td>
            <td colspan="3">
                <input name="role" type="hidden" />
                <input id="specialFilter" type="checkbox" />
            </td>
        </tr>
        <tr>
            <td>在线状态</td>
            <td>
                <select class="easyui-combobox filter" name="onLine" style="width: 80px;">
                    <option value="" selected="selected">全部</option>
                    <option value="1">在线</option>
                    <option value="0">离线</option>
                </select>
             </td>
        </tr>
        <tr>
            <td>注册时间</td>
            <td>
                <input class="easyui-datebox filter" name="minRegisterTime" type="text" style="width: 100px;">&nbsp;至&nbsp;
                <input class="easyui-datebox filter" name="maxRegisterTime" type="text" style="width: 100px;">
            </td>
		</tr>
	</table>
</form>
