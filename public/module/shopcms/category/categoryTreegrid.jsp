<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<table id="dgCategory" class="easyui-treegrid" toolbar="#tbrCategory"
    data-options="url:'${urlPath}shopcms/category/page.do',
                  idField: 'id',
                  treeField: 'name',
                  onLoadSuccess: function() {
                      $(this).treegrid('collapseAll');
                  },
                  fit:true">
    <thead>
        <tr>
            <th data-options="field:'name', width:'20%', halign: 'center', align:'left'">名称</th>
            <th data-options="field:'pictureUrl', width:'6%', halign: 'center', align:'left', formatter: formatters.pictureUrl">图片</th>
            <th data-options="field:'isbottom', width:'6%', halign: 'center', align:'center', formatter: UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('yesnoempty'))">是否底层分类</th>
            <th data-options="field:'isvalid', width:'7%', halign: 'center', align:'center', formatter: UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('yesnoempty'))">是否显示</th>
            </tr>
    </thead>
</table>