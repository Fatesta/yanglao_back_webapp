crm.customerManage = (function() {
    $('#tbrCustomer [name=add]').click(function() {
        var dialog = openEditDialog({
            width: 540,
            height: 500,
            title: '新增客户',
            href: 'view/callcenter/crm/customer/customerForm.do',
            onLoad: function() {
                initCustomerForm(dialog);
            },
            onSave: function() {/*
                formSubmit('#customerAndLinkmanForm', {
                });*/
            }
        });
    });

    return {
        formatters: {
            customerName: function(v) {
                return v;
            }
        }
    }
    
    function initCustomerForm(ctx) {
        $('[name=type]', ctx).change(function() {
            switch (+this.value) {
            case 1:
                $('#companyTr', ctx).hide();
                $('[textboxname=companyName]', ctx).textbox({required: false});
                break;
            case 2:
                $('#companyTr', ctx).show();
                $('[textboxname=companyName]', ctx).textbox({required: true});
                break;
            }
        });
        
        $('[comboname=source]', ctx).comboboxFromDict({
            dict: DictMan.items('crm.customer.source'),
            emptyItem: {value: '', text: '未知'}
        });
        $('[comboname=category]', ctx).comboboxFromDict({
            dict: DictMan.items('crm.customer.category'),
            emptyItem: {value: '', text: '未知'}
        });
        $('[comboname=linkmanType]', ctx).comboboxFromDict({
            dict: DictMan.items('crm.customer.linkmanType'),
            enableEmptyItem: false
        });
        $('[comboname=gender]', ctx).comboboxFromDict({
            dict: DictMan.items('crm.customer.gender').sort(function(x, y) { return y.value - x.value }),
            enableEmptyItem: false,
            value: 1,
        });
    }
})();