<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<table id="dgQuestionForAnswererFilter" class="easyui-datagrid"
    data-options="url:'${urlPath}survey/question/allChoiceQuestionInfo.do',
                  queryParams: {surveyId: '${surveyId}'},
                  onLoadSuccess: onLoadSuccess,
                  pagination: false,
                  rownumbers: false,
                  fit:true">
    <thead>
        <tr>
            <th data-options="field:'orderno', width:'4%', halign: 'center', align:'center'">序号</th>
            <th data-options="field:'type', width:'4%', halign: 'center', align:'center', formatter: formatters.type">题型</th>
            <th data-options="field:'content', width:'15%', halign: 'center', align:'left', formatter: UICommon.datagrid.formatter.generators.omit({dgId: 'dgQuestionForAnswererFilter', min: 13, field: 'content'})">问题</th>
            <th data-options="field:'options', width:'76%', halign: 'center', align:'left', formatter: formatters.optionInputs">答案</th>
        	</tr>
    </thead>
</table>

<style>
.option_selected {
    color: red;
    font-weight: bold;
}
.question_selected {
    color: blue;
    font-weight: bold;
}
.question_option {
	padding: 10px 10px 10px 10px;
	float: left;
}
</style>
<script src="${modulePath}survey/question/formatters.js"></script>
<script>
var onLoadSuccess = function() {
    $(':checkbox, :radio').change(function(event){
        if ($(this).is(':radio')) {
            $(this).parents('tr').find('label').removeClass('option_selected');
        }
        var act = this.checked ? 'addClass' : 'removeClass';
        $(this).next('label')[act]('option_selected');
        $(this).parents('tr').find('[field=content]')[act]('question_selected');
        return false; // stopPropagation
    });
    $('.question_option').click(function(event){
        if ($(event.target).is('input'))
            return;
        var input = $(this).find('input');
        var checked = input.is(':radio') ? true : !input.prop('checked');
        input.prop('checked', checked).change();
    });
}

formatters.optionInputs = function(val, row) {
    return val.map((function(type) {
        return function(opt) {
            return '<div class="question_option"><input id="opt_' + opt.id + '" name="q_' + opt.questionId
                + '" data-question-id=' + opt.questionId
                + ' type="' + (type == 1 ? 'radio' : 'checkbox')  + '" value="' + opt.id + '"/>'
                + ' <label>' + opt.content + '</label></div>';
        }
    })(row.type)).join('');
};
</script>
</body>
</html>