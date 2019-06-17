<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<div id="telecare-doorOpen-layout" class="easyui-layout">
	<table id="dgDoorOpenAlarm" class="easyui-datagrid">
	    <thead>
	        <tr>
	            <th data-options="field:'alarmDateTime',width:130,halign:'center'">大门打开时间</th>
	        </tr>
	    </thead>
	</table>
</div>
<script>
define('telecare.report.doorOpen', function() {
    var inited = false;
    return function (queryParams) {
        if (!inited) {
	        $('#dgDoorOpenAlarm').datagrid({
	            url: CONFIG.baseUrl + 'telecare/alarmPage.do?alarmType=10004',
	            pagination: true,
	            queryParams: queryParams,
	            singleSelect: true
	        });
	        inited = true;
	    } else {
	        $('#dgDoorOpenAlarm').datagrid('reload');
	    }
    }
});
</script>