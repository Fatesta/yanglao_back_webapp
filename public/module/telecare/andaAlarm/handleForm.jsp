<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<form id="handleNoteForm" method="post">
    <input type="hidden" name="eventTime">
    <input type="hidden" name="hostId">
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
                <textarea name="note" style="width: 400px;" rows="8" class="easyui-validatebox" data-options="validType:'length[0,1000]'"></textarea>
            </td>
        </tr>

    </table>
</form>

