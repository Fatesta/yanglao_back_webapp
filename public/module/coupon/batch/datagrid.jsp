<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div id="tbrCoupon">
    <form id="frmQuery">
    <input name="providerId" type="hidden">
	<table class="form">
	   <tr>
           <td>范围</td>
           <td>
               <input class="easyui-combobox" id="range"
                   data-options="
                       data: [{value: 0, text: '全部'}, {value: 1, text: '店铺'}, {value: 2, text: '平台劵'}]"
                   style="width:64px;"/>
           </td>
           <td id="selectProviderTr" style="margin-left: 0px;padding-left: 0px;display:none">
               <input class="easyui-textbox" id="providerName" data-options="readonly: true" type="text" style="width:100px;">
           </td>
           <td>类型</td>
           <td>
               <input class="easyui-combobox" id="type" name="type" style="width:70px;"/>
          </td>
          <td>支持自领</td>
           <td>
               <input class="easyui-combobox" name="isPublic" style="width:60px;"/>
          </td>
          <td>主题</td>
          <td>
              <input class="easyui-textbox" name="subject" type="text" style="width:100px;">
          </td>
          <td>
            <a id="query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a></td>
          <c:forEach var="func" items="${ROLE_FUNCS}">
              <td><a id="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a></td>
           </c:forEach>
		</tr>
	</table>
    </form>
</div>
<table id="dgCoupon" class="easyui-datagrid" toolbar="#tbrCoupon">
    <thead>
        <tr>
            <th data-options="field:'id', width:80, align:'center'">批次</th>
            <th data-options="field:'subject', width:110, halign:'center', formatter: UICommon.datagrid.formatter.wraptip">主题</th>
            <th data-options="field:'type', width:50, align:'center', formatter: formatters.type">类型</th>
            <th data-options="field:'isPublic', width:60, align:'center', formatter: UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('bool-yesno'))">支持自领</th>
            <th data-options="field:'createTime', width:130, align:'center'">提交时间</th>
            <th data-options="field:'startTime', width:130, align:'center'">开始时间</th>
            <th data-options="field:'endTime', width:130, align:'center'">结束时间</th>
            <th data-options="field:'couponQuantity', width:60, align:'center'">总数量</th>
            <th data-options="field:'restCouponQuantity', width:60, align:'center'">剩余数量</th>
            <th data-options="field:'lowestMoney', width:90, align:'center', formatter: UICommon.datagrid.formatter.money">条件最低金额</th>
            <th data-options="field:'discountAmount', width:70, align:'center', formatter: UICommon.datagrid.formatter.money">优惠金额</th>
            <th data-options="field:'content', width:130, halign:'center', formatter: UICommon.datagrid.formatter.generators.omit({dgId: 'dg', field: 'content'})">优惠内容</th>
            <th data-options="field:'providerName', width:130, halign:'center', formatter: formatters.providerName">申请者店铺</th>
            <th data-options="field:'adminRealName', width:100, halign:'center', formatter: UICommon.datagrid.formatter.wraptip">申请者</th>
            <th data-options="field:'status', width:50, align:'center', formatter: formatters.status">状态</th>
        	</tr>
    </thead>
</table>