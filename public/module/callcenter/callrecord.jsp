<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
      <div id="tbrCallRecord">
        <form id="frmQuery">
            <input name="orderBy" type="hidden" value="DESC">
            <input name="startTime" type="hidden" value="0">
            <input name="stopTime" type="hidden" value="0">
            <table class="form">
               <tr>
                   <td>时间范围</td>
                   <td colspan="7">
                       <select id="days" class="easyui-combobox" type="text"
                            data-options="editable: false"
                            style="width:60px;">
                            <option value="">&nbsp;</option>
                            <option value="0">今天</option>
                            <option value="1">昨天</option>
                            <option value="7" selected>7天</option>
                            <!--<option value="30">30天</option>  -->
                       </select>
                       <span>或</span>
                       <input id="startDate" class="easyui-datebox filter" type="text" style="width:90px;">
                       <span>到</span>
                       <input id="endDate" class="easyui-datebox filter" type="text" style="width:90px;">
                   </td>
               </tr>
               <tr>
                   <td>呼叫类型</td>
                   <td>
                       <input id="contactType" name="contactType" class="easyui-combobox" type="text"
                            data-options="editable: false"
                            style="width:80px;">
                   </td>
                   
                   <td>挂断原因</td>
                   <td>
                       <input id="contactDisposition" name="contactDisposition" class="easyui-combobox" type="text"
                            data-options="editable: false"
                            style="width:100px;">
                   </td>
                   
                   <td>客户电话/客服/技能组</td>
                   <td>
                       <input class="easyui-textbox" name="criteria" type="text" style="width:100px">
                   </td>
                   
                   <td>
                       <a id="query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
                   </td>
                   <td>
                       <a id="order" class="easyui-linkbutton" data-options="iconCls:'icon-order'">快速下单</a>
                       <a id="openLocation" class="easyui-linkbutton" data-options="iconCls:'icon-location'">查看位置</a>
                   </td>
                </tr>
            </table>
        </form>
      </div>
      <table id="dgRecord" class="easyui-datagrid" toolbar="#tbrCallRecord">
	    <thead>
	        <tr>
	            <th data-options="field:'startTime', width: 130, halign: 'center', align:'left', formatter: callcenterCallRecordManage.formatters.startTime">时间</th>
                <th data-options="field:'customerNumber', width: 130, halign: 'center', align:'left', formatter: callcenterCallRecordManage.formatters.customerNumber">客户电话</th>
	            <th data-options="field:'aliasName', width: 90, halign: 'center', align:'left', formatter: callcenterCallRecordManage.formatters.userAliasName">昵称</th>
	            <th data-options="field:'sex', width: 40, align: 'center', formatter: UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('user.gender'))">性别</th>
	            <th data-options="field:'age', width: 40, align: 'center'">年龄</th>
	            <th data-options="field:'contactType', width: 60, align: 'center', formatter: callcenterCallRecordManage.formatters.contactType">呼叫类型</th>
	            <th data-options="field:'duration', width: 70, halign: 'center', formatter: callcenterCallRecordManage.formatters.duration">通话时长</th>
	            <th data-options="field:'contactDisposition', width: 100, halign: 'center', formatter: callcenterCallRecordManage.formatters.contactDisposition">挂断原因</th>
	            <th data-options="field:'agentNames', width: 100, halign: 'center', align:'left'">客服</th>
	            <th data-options="field:'skillGroupNames', width: 80, halign: 'center', align:'left'">技能组</th>
	            <th data-options="field:'-', width: 160, halign: 'center', align:'left', formatter: callcenterCallRecordManage.formatters.op">操作</th>
	            </tr>
	    </thead>
    </table>