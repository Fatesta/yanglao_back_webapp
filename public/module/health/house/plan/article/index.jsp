<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
    <link rel="stylesheet" type="text/css" href="${modulePath}health/house/plan/article/editor/s-article-editor.css?v=1">
    <style>
        #planArticleEditorContainer {
            width: 422px;
            margin: 6px auto;
        }
        .s-article-editor-content {
            box-shadow: none;
        }
    </style>
</head>
<body id="layout" class="easyui-layout">
    <c:if test="${not selectMode}"><div data-options="region:'west',split:true,collapsible:false,minWidth:240" style="width:100%;display:none;"></c:if>
    <div id="tbrHealthPlanArticle">
        <form id="frmQuery">
            <table class="form">
                <tr>
                    <td colspan="10">
                        <c:forEach var="func" items="${ROLE_FUNCS}">
                            <c:if test="${func.code != 'hh_plan_cycle_step'}">
                                <a id="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a>
                            </c:if>
                        </c:forEach>
                    </td>

                    <td>标题</td>
                    <td>
                        <input class="easyui-textbox" name="title" type="text" style="width:264px">
                    </td>
                    <td>未被引用</td>
                    <td>
                        <input name="refCount" type="checkbox" />
                    </td>
                    <td colspan="8">
                        <a id="query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
                    </td>
                </tr>
            </table>
        </form>
    </div>
    <table id="dgArticle" class="easyui-datagrid" toolbar="#tbrHealthPlanArticle"
           data-options="url:'${urlPath}health/house/plan/article/page.do',
						  fit:true,
                          onSelect: articleDatagridOnSelect,
                          onLoadSuccess: articleDatagridOnLoadSuccess">
        <thead>
        <tr>
            <th data-options="field:'coverUrl', width:60, halign: 'center', align:'left', formatter: UICommon.datagrid.formatter.generators.image({width: 60, height: 50})">文章封面</th>
            <th data-options="field:'title', width:200, halign: 'center', align:'left'">文章标题</th>
            <th data-options="field:'refCount', width:60, halign: 'center', align:'center', formatter: formatters.refCount">引用计数</th>
            <th data-options="field:'createTime', width:130, halign: 'center', align:'center'">创建时间</th>
            <th data-options="field:'updateTime', width:130, halign: 'center', align:'center'">修改时间</th>
        </tr>
        </thead>
    </table>
        <c:if test="${not selectMode}"></div></c:if>
    <c:if test="${not selectMode}">
        <div data-options="title: '预览文章内容', region:'east',collapsible:false" style="width:440px">
            <div id="planArticleEditorContainer"></div>
        </div>
    </c:if>

    <script>
        var selectMode = '${selectMode}' == 'true';
    </script>
    <script src="${modulePath}health/house/plan/article/editor/s-article-editor.js?v=1"></script>
    <script src="${modulePath}health/house/plan/article/index.js?v=1"></script>
</body>
</html>