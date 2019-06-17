var formatters = {
    reasonType: function(t) {
        return {1: '丢失', 2: '损坏', 3: '其它'}[t];
    },
    aliasName: function(v, row) {
        return v ? UICommon.linkHtml({
            text: v,
            clickCode: 'openUserBasicInfo("' + row.userId + '")'
        }) : '';
    }
};
(function(){
    $('#query').click(function(){
        var params = $('#frmQuery').serializeObject();
        $('#dgRecord').datagrid('load', params);
    });
})();