<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
</head>
<body>
    <div id="tbrAlarmRecord">
        <form>
        <table class="form">
            <tr>
                <td>时间</td>
                <td>
                    <input class="easyui-datebox" name="date" style="width: 100px;">
                </td>
                <td>主机ID</td>
                <td>
                    <input class="easyui-textbox" name="hostId" value="${hostId}" style="width: 130px;" />
                </td>
                <td>事件类型</td>
                <td>
                    <input name="eventType" class="easyui-combobox" data-options="
                        data: DictMan.items('andaAlarm.event.type'),
                        loadFilter: function(data) {
                            return [{text: '全部', value: ''}].concat(data);
                        }
                        " style="width: 130px"/>
                </td>
                <td>处理状态</td>
                <td>
                    <input name="handleState" class="easyui-combobox" data-options="
                        data: [{text: '全部', value: '-1'}, {text: '已处理', value: 1}, {text: '未处理', value: 0}],
                        value: -1" style="width: 80px"/>
                </td>
                <td>
                    <a id="query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
                </td>
            </tr>
        </table>
        </form>
    </div>
    <table id="dgAlarmRecord" class="easyui-datagrid" toolbar="#tbrAlarmRecord"
        data-options="
            url:'${urlPath}anda/event/records.do',
            queryParams: {hostId: '${hostId}'},
            pagination: true,
            pageSize: 30,
            singleSelect: true">
        <thead>
        <tr>
            <th data-options="field:'time',width:130,halign:'center'">时间</th>
            <th data-options="field:'hostId',width:130,halign:'center'">主机ID</th>
            <th data-options="field:'eventType',width:130,align:'center', formatter: alarmRecordManage.formatters.eventType">事件</th>
            <th data-options="field:'state',width:100,align:'center', formatter: UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('andaAlarm.event.state'))">状态</th>
            <th data-options="field:'defenceArea',width:60,align:'center', formatter: function(v) { return v ? (v + '号') : '';  }">防区</th>
            <th data-options="field:'handleState',width:80,align:'center', formatter: alarmRecordManage.formatters.handleState">处理状态</th>
            <th data-options="field:'op',width:80,align:'center', formatter: alarmRecordManage.formatters.op">操作</th>
        </tr>
        </thead>
    </table>
<script>
    var alarmRecordManage = {
        formatters: {
            eventType: (function() {
                var formatter = UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('andaAlarm.event.type'));
                return function(v) {
                    return [4369, 4384, 4400, 4450, 4423, 4866].indexOf(v) > -1 ?
                        '<span style="color:orangered">' + formatter(v) + '</span>' : formatter(v);
                }
            })(),
            handleState: function(v) {
                return v == 0 ? '未处理' : '<span style="color:forestgreen">已处理</span>';
            },
            op: function(v, row, index) {
                var html = '';
                if (row.handleState == 0) {
                    html += UICommon.buttonHtml({
                        text: '处理',
                        icon: 'edit',
                        clickCode: 'handleAlarm(' + index + ')'
                    });
                }
                if (row.handleState == 1) {
                    html += UICommon.buttonHtml({
                        text: '处理详情',
                        icon: 'detail',
                        clickCode: 'handleDetail(' + index + ')'
                    });
                }
                return html;
            }
        }
    };

    function handleAlarm(index) {
        var row = $('#dgAlarmRecord').datagrid('getRows')[index];
        if (!row) return;

        var dialog = openEditDialog({
            width: 500,
            height: 300,
            title: '处理报警',
            href: 'view/telecare/andaAlarm/handleForm.do',
            onLoad: function() {
                dialog.find('[name=eventTime]').val(row.time);
                dialog.find('[name=hostId]').val(row.hostId);
                dialog.find('[name=time]').text(row.time);
                dialog.find('[name=eventType]').text(DictMan.itemMap('andaAlarm.event.type')[row.eventType]);

            },
            onSave: function() {
                formSubmit('#handleNoteForm', {
                    url: 'anda/eventHandle/saveNote.do',
                    success: function(ret) {
                        showOpResultMessage(ret);
                        if (ret.success) {
                            $('#dgAlarmRecord').datagrid('reload');
                            dialog.dialog('destroy');
                        }
                    }
                });
            }
        });
    }
    function handleDetail(index) {
        var row = $('#dgAlarmRecord').datagrid('getRows')[index];
        if (!row) return;

        var dialog = openSimpleDialog({
            width: 500,
            height: 300,
            title: '报警处理详情',
            href: 'view/telecare/andaAlarm/handleDetail.do',
            onLoad: function () {
                axios.get('anda/eventHandle/getDetail.do?eventTime=' + row.time + '&hostId=' + row.hostId)
                    .then(function(info) {
                        dialog.find('[name=time]').text(row.time);
                        dialog.find('[name=eventType]').text(
                            DictMan.itemMap('andaAlarm.event.type')[row.eventType]);
                        dialog.find('[textboxname=note]').textbox('setValue', info.note);
                    });
            }
        });
    }

    $('#tbrAlarmRecord #query').click(function() {
        var queryParams = $.extend($('#dgAlarmRecord').datagrid('options').queryParams, $('#tbrAlarmRecord form').serializeObject());
        $('#dgAlarmRecord').datagrid('load', queryParams);
    });

</script>
</body>
</html>