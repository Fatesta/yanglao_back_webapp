(function() {
    department.signals.selected.add(function(node) {
        employee.queryByDepartmentId(node.id);
        var title = '部门员工';
        if (node.id > 0) {
            var name = node.text;
            name = name.endWiths('部门') ? name.substring(0, name.length - 2) : name;
            title = name + title;
        }
        $('#panelEmployee').panel('setTitle', title);
    });
})();