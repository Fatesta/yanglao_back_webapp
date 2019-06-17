function formatStatus(value,rowData,rowIndex) {
    return {
        1: "等待开始",
        2: "正在问诊",
        3: "等待结束",
        4: "完成",
        6: "取消"
    }[rowData.status];
}

function formatMedicalResult(value, rowData, rowIndex) {
    value = value || "";
    return '<a href="#" class="easyui-linkbutton" data-options="iconCls:\'color:fff\'" onclick="checkFullMedicalResult(' + rowIndex + ')">'
        + (value.substring(0, 10) + (value.length > 10 ? " ..." : "")) + '</a>';
}


function checkFullMedicalResult(rowIndex) {
    var row = $("#dgConsultation").datagrid("getRows")[rowIndex];
    var divDlg = $("<div>" + row.medicalResult + "</div>");
    divDlg.appendTo($(document.body));
    divDlg.dialog({
        title: "医生诊断意见",
        width: 600,
        height: 400,
        closed: false,
        cache: false,
        modal: true
    });
}

function searchA() {
    $("#dgConsultation").datagrid("load", $("#searchForm").serializeObject());
}