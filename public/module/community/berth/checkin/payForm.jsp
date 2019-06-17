<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    <form id="frmCheckinPay" method="post">
        <input type="hidden" name="checkinId" value="${checkinRecord.id}"/>
        <table class="form">
            <tr>
                <td>操作床位</td>
                <td id="berthNo"></td>
            </tr>
            <tr>
                <td>已交金额</td>
                <td>${checkinRecord.paidMoney}</td>
            </tr>
            <tr>
                <td>本次交金额</td>
                <td><input class="easyui-numberbox" name="money" data-options="precision:2"  style="width: 80px;"></td>
            </tr>
        </table>
    </form>