<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


    <form id="frmLocIcon" method="post">
        <table class="form">
            <tr>
                <td>区域名称</td>
                <td>
                    <input class="easyui-textbox" name="location" data-options="required: true" style="width: 200px;">
                </td>
            </tr>
            <tr>
                <td>图标</td>
                <td>
                    <input name="icon" type="hidden">
                    <a name="uploadButton" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" href="#">上传</a>
                    <span class="tip-info">(建议40x40)</span>
                </td>
            </tr>
            <tr>
                <td>图标预览</td>
                <td>
                    <img name="locIconImage" style="width:40px; height:40px; cursor:pointer;">
                </td>
            </tr>
            <tr>
                <td>选择颜色</td>
                <td>
                    <input id="telecare-locicon-form-color" name="color" type="text" style="width: 70px;">
                </td>
            </tr>
            <tr>
                <td>显示顺序</td>
                <td>
                    <input class="easyui-numberbox" name="orderno" data-options="required: true, precision: 0" style="width: 60px;">
                </td>
            </tr>
        </table>
    </form>
