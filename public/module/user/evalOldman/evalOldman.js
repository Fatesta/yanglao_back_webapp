$(function() {
    $('#oldmanKey').combobox({
        onChange: function(value) {
            $('#oldmanValue').next().find('input:hidden').attr('name', value);
        }
    });

    $('#query').click(function () {
        var params = $('#frmQuery').serializeObject();
        params.applyTypes = $('[comboname=applyTypes]').combobox('getValues').filter(Boolean).join(',');
        $('#dg').datagrid('load', params);
    });

    $('#delete').click(function () {
        var row = $('#dg').datagrid('getSelected');
        if (!row) return;
        openConfirmDeleteDialog(function () {
            $.post(CONFIG.baseUrl + 'user/evalOldman/delete.do?idcard=' + row.idcard, function (ret) {
                showOpResultMessage(ret);
                $('#dg').datagrid('reload');
            });
        });
    });
});

function onLoadSuccess() {
    [0,1,2].forEach(function(id) {
        $('#details_part' + id).form('clear');
    });
}
function onSelect(_, row) {
    [0,1,2,3,4].forEach(function(id) {
        $('#details_part' + id).form('load', row);
    });
}