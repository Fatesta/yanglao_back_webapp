function openBossSelectDialog(options) {
    var dlg = openDataSelectDialog({
        title: "选择商家",
        width: 804,
        height: 480,
        href: "view/shop/boss/dgBoss.do",
        onLoad: function() {
            boss.query();

            $("#dgBoss").datagrid('options').onSelect = function() {
                var boss = $("#dgBoss", dlg).datagrid('getSelected');
                if (!boss) return;
                
                options.onSelect(boss);
                
                dlg.dialog('destroy');
            };
        }
    });
}