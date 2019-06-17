<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<table id="dgConsumeCard" class="easyui-datagrid"
    data-options="url:'${urlPath}cardConsume/card/page.do',
                  queryParams: {isvalid: 1},
                  fit:true">
    <thead>
        <tr>
            <th data-options="field:'cardName', width:'14%', halign:'center', align:'left'">卡名称</th>
            <th data-options="field:'coverImage', width:'6%', halign:'center', align:'center', formatter: UICommon.datagrid.formatter.generators.image({height: 30})">封面图片</th>
            <th data-options="field:'contactNumber', width:'10%', halign:'center', align:'left'">联系电话</th>
            <th data-options="field:'expirationDate', width:'8%', halign:'center', align:'left'">有效期限(天)</th>
            <th data-options="field:'price', width:'8%', halign:'center', align:'left', formatter: UICommon.datagrid.formatter.money">价格</th>
            <th data-options="field:'privilegeSpecification', width:'18%', halign:'center', align:'left', formatter: UICommon.datagrid.formatter.generators.omit({field: 'privilegeSpecification'})">特权说明</th>
            <th data-options="field:'description', width:'20%', halign:'center', align:'left', formatter: UICommon.datagrid.formatter.generators.omit({min: 15, field: 'description'})">描述</th>
            </tr>
    </thead>
</table>
