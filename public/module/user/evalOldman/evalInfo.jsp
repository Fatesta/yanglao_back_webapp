<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <table id="eval_info" class="form">
        <tr>
            <th>评估机构</th>
            <td name="institutions"></td>
        </tr>
        <tr>
            <th>申请对象类型</th>
            <td name="applyTypesText"></td>
        </tr>
        <tr>
            <th>评估分数</th>
            <td name="evalScore"></td>
        </tr>
        <tr>
            <th>拟享受市补贴（元）</th>
            <td name="allowanceMoney"></td>
        </tr>
        <tr>
            <th>疾病诊断类别</th>
            <td name="diseases"></td>
        </tr>
        <tr>
            <th>养老需求</th>
            <td name="needsText"></td>
        </tr>
    </table>

<script>
    loadEvalInfo('${idcard}');
    function loadEvalInfo(idcard) {
        $.get(CONFIG.baseUrl + 'user/evalOldman/get.do?idcard=' + idcard, function(info) {
            if (!info) return;
            $('#eval_info [name=diseases]').text(info.diseases);
            $('#eval_info [name=needsText]').text(info.needsText || '');
            $('#eval_info [name=institutions]').text(info.institutions);
            $('#eval_info [name=applyTypesText]').text(info.applyTypesText || '');
            $('#eval_info [name=evalScore]').text(info.evalScore);
            $('#eval_info [name=allowanceMoney]').text(info.allowanceMoney);
        });
    }
</script>