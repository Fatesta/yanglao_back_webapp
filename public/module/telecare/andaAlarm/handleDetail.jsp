<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<form id="handleNoteForm" method="post">
    <table class="form">
        <tr>
            <td>时间</td>
            <td name="time"></td>
        </tr>
        <tr>
            <td>事件</td>
            <td name="eventType"></td>
        </tr>
        <tr>
            <td>处理记录</td>
            <td>
                <text name="note" style="width: 400px;height:100px"  class="easyui-textbox" data-options="multiline: true, readonly:true"></text>
            </td>
        </tr>

    </table>
</form>

