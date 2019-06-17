<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div id="tabs" class="easyui-tabs" data-options="fit:true">
    <div id="lunbo" title="轮播图管理" data-options="selected:true,closable:false">
        <%@ include file="../element/elementDatagrid.jsp" %>
	</div>
	
    <div id="guanggaowei" title="广告位管理">
        <%@ include file="../element/elementDatagrid.jsp" %>
	</div>
    <div id="categoryRecommend" title="一级分类推荐资源管理">
        <div class="easyui-layout" data-options="fit:true">
            <div data-options="region:'west',title:'',split:true" style="width:30%;">
				<table id="dgCategory" class="easyui-treegrid" toolbar="#tbr"
				    data-options="url:'${urlPath}shopcms/category/page.do',
				                  idField: 'id',
				                  treeField: 'name',
				                  onLoadSuccess: function() {
				                      $(this).treegrid('collapseAll');
				                  },
				                  onSelect: categoryOnSelect,
				                  fit:true">
				    <thead>
				        <tr>
				            <th data-options="field:'name', width:'90%', halign: 'center', align:'left'">分类名称</th>
				            </tr>
				    </thead>
				</table>
            </div>
            <div data-options="region:'center',title:'',split:true" style="width:70%;">
		        <%@ include file="../element/elementDatagrid.jsp" %>
            </div>
        </div>
	</div>
</div>
<script src="${modulePath}shop/pro/providerToProductSelect.js"></script>
<script src="${modulePath}shopcms/category/category.js"></script>
<script src="${modulePath}shopcms/element/element.js"></script>
<script>
var lunboElementManage = new ElementManage({
    parent: '#lunbo',
    pageLevel: 1,
    blockType: ElementManage.blockType.lunbo
});
lunboElementManage.query();

var guanggaoweiElementManage = new ElementManage({
    parent: '#guanggaowei',
    pageLevel: 1,
    blockType: ElementManage.blockType.guanggaowei
});
guanggaoweiElementManage.query();

var categoryRecommendElementManage = new ElementManage({
    parent: '#categoryRecommend',
    pageLevel: 1,
    blockType: ElementManage.blockType.categoryRecommend,
    enableElementTypes: [ElementManage.elementType.product, ElementManage.elementType.web],
    preconds: {
        add: function() {
            var cg = $('#dgCategory').treegrid('getSelected');
            if (cg.categoryId <= 0 && cg.industryId) {
                alertInfo('请选择子类别');
                return false;
            }
            return true;
        }
    }
});

function categoryOnSelect(cg) {
    var industryId;
    if (cg.categoryId <= 0 && cg.industryId)
        industryId = cg.industryId;
    
    categoryRecommendElementManage.query({industryId: industryId, categoryId: cg.categoryId, categoryRecursive: true});
    categoryRecommendElementManage.setFields({categoryId: cg.categoryId});
}
</script>
</body>
</html>