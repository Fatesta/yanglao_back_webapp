<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
    <link rel="stylesheet" type="text/css" href="${modulePath}health/house/plan/article/editor/s-article-editor.css?v=1">
    <style>
        html, body {
            background: rgba(250,250,250);
            overflow: hidden;
        }
        #planArticleEditorContainer {
            width: 422px;
            margin: 6px auto;
        }

    </style>
</head>
<body>
    <div style="width: 400px">
        <form id="frmArticle" style="float: left;">
            <input name="coverUrl" type="hidden"/>
            <table class="form">
                <tr>
                    <td>文章标题</td>
                    <td colspan="3"><input class="easyui-textbox" name="title" data-options="required:true,validType:'length[1,100]'"  style="width: 250px;"></td>
                </tr>
                <tr>
                    <td>文章封面</td>
                    <td colspan="3">
                        <a id="coverUpload" class="easyui-linkbutton" data-options="iconCls:'icon-edit'">${empty articleId ? "上传" : "修改"}</a>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td colspan="3">
                        <img id="imgCover" src="" style="width:140px;height:100px;display:none" />
                    </td>
                </tr>
            </table>
        </form>
    </div>

    <div id="planArticleEditorContainer"></div>

    <script src="${modulePath}health/house/plan/article/editor/s-article-editor.js?v=1"></script>
    <script>
        var PageConfig = {
            isAdd: !'${articleId}',
            articleId: '${articleId}',
            saveAfter: '${saveAfter}'
        };
    </script>
    <script src="${modulePath}health/house/plan/article/edit.js?v=1"></script>
</body>
</html>