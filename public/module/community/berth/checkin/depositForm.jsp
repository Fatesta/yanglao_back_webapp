<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    <form id="frmCheckinDeposit" method="post">
        <input type="hidden" name="checkinId" value="${checkinRecord.id}"/>
        <table class="form">
            <tr>
                <td>操作床位</td>
                <td id="berthNo"></td>
            </tr>
            <tr>
                <td>已交押金</td>
                <td>${checkinRecord.deposit}</td>
            </tr>
            <tr>
                <td>本次交押金</td>
                <td><input class="easyui-numberbox" name="deposit" data-options="precision:2"  style="width: 80px;"></td>
            </tr>
        </table>
    </form>