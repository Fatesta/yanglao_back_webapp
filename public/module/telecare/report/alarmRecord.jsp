<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<div id="telecare-alarmRecord-layout" class="easyui-layout">
    <div id="tbrAlarmRecord">
        <form>
        <table class="form">
            <tr>
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
                        " style="width: 80px"/>
                </td>
                <td>
                    <a id="query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
                    <a id="handleAlarm" class="easyui-linkbutton" data-options="iconCls:'icon-edit'">处理</a>
                    <a id="handleDetail" class="easyui-linkbutton" data-options="iconCls:'icon-detail'">处理详情</a>
                </td>
            </tr>
        </table>
        </form>
    </div>
    <table id="dgAlarmRecord" class="easyui-datagrid" toolbar="#tbrAlarmRecord">
        <thead>
        <tr>
            <th data-options="field:'time',width:130,halign:'center'">时间</th>
            <th data-options="field:'eventType',width:130,align:'center', formatter: UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('andaAlarm.event.type'))">事件</th>
            <th data-options="field:'state',width:100,align:'center', formatter: UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('andaAlarm.event.state'))">状态</th>
            <th data-options="field:'defenceArea',width:60,align:'center', formatter: function(v) { return v ? (v + '号') : '';  }">防区</th>
            <th data-options="field:'handleState',width:80,align:'center', formatter: alarmRecordManage.formatters.handleState">处理状态</th>
        </tr>
        </thead>
    </table>
</div>
<script>
    var alarmRecordManage = {
        formatters: {
            handleState: function(v) {
                return v == 0 ? '未处理' : '已处理';
            }
        }
    };
    $('#tbrAlarmRecord #query').click(function() {
        var queryParams = $.extend($('#dgAlarmRecord').datagrid('options').queryParams, $('#tbrAlarmRecord form').serializeObject());
        $('#dgAlarmRecord').datagrid('load', queryParams);
    });

    $('#tbrAlarmRecord #handleAlarm').click(function() {
        var row = $('#dgAlarmRecord').datagrid('getSelected');
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
    });

    $('#tbrAlarmRecord #handleDetail').click(function() {
        var row = $('#dgAlarmRecord').datagrid('getSelected');
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
    });

    define('telecare.report.alarmRecord', function() {
        var inited = false;
        return function (queryParams) {
            if (!inited) {
                $('#dgAlarmRecord').datagrid({
                    url: CONFIG.baseUrl + 'anda/event/records.do',
                    pagination: true,
                    queryParams: queryParams,
                    singleSelect: true
                });
                inited = true;
            } else {
                $('#dgAlarmRecord').datagrid('reload');
            }
        }
    });
</script>