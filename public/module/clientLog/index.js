var clientLog = (function(){
    var platformTypeDictItemMap = {"0":"PC端","1":"Android端","2":"iOS端","3":"微信端"};
    var roleDictItemMap = ['老人App', '微信小程序', '服务机构App'].reduce(function(m, i) { m[i] = i; return m; }, {});

    $(function() {
        $('[comboname=platformType]').comboboxFromDict({
            dict: platformTypeDictItemMap
        });
        $('[comboname=roleName]').comboboxFromDict({
            dict: roleDictItemMap
        });

        $('#query').click(function() {
            var qparams = $('#frmQuery').serializeObject();
            $('#dgClientLog').datagrid('load', qparams);
        });
    });

    return {
        formatters: {
            platformType: UICommon.datagrid.formatter.generators.dict(platformTypeDictItemMap)
        }
    }
})();