/**
 * 订单管理
 * @author: hulang
 *
 */

function OrderManager() {
	var self = this;

	this.query = function() {
		var params = $("#frmQueryOrder").serializeObject();
        // 设置时间为当天
        params.startCreateTime = params.startCreateTime && params.startCreateTime + " 00:00:00";
        params.endCreateTime = params.endCreateTime && params.endCreateTime + " 23:59:59";
        
		if($("#dgOrder").datagrid("options").url == null) {
			$("#dgOrder").datagrid({
				url: CONFIG.baseUrl + 'shop/order/orderPage.do',
				multiSort:true,
				fit:true,
				queryParams: params,
				onSelect: function(rowIndex, rowData){
					self.setChanged().notifyObservers({
						event: "onSelect",
						args: {rowIndex: rowIndex, rowData: rowData}});
				},
				onLoadSuccess: function(data){
					self.setChanged().notifyObservers({event: "onLoadSuccess", args: data});
				}
			});
		}
		else {
			$("#dgOrder").datagrid("load", params);
		}
	}
	
	this.addOrder = function() {
		editOrder();
	}
	
	this.addOrderDetail = function() {
		alert('addOrderDetail')
	}
	
	$("#tbrDgOrder [name=query]").click(function(){
		self.query();
	});
	
	$("#tbrDgOrder [name=add]").click(function(){
		self.addOrder();
	});
	
	$("#tbrDgOrderDetail [name=add]").click(function(){
		self.addOrderDetail();
	});
	
	$('#tbrDgOrder [name=viewOrderFlow]').click(function() {
	    var order = $("#dgOrder").datagrid('getSelected');
	    if (!order) return;
        openTab({
            title: '跟踪订单 - ' + order.orderno,
            url: CONFIG.baseUrl + 'view/shop/workOrder/orderDetail.do?orderCode=' + order.orderno,
        });
	});
	
	$('#tbrDgOrder [name=comment]').click(function() {
        var order = $("#dgOrder").datagrid('getSelected');
        if (!order) return;
        openEditDialog({
            href: 'view/shop/order/comment.do?orderno=' + order.orderno,
            title: "评价 订单[" + order.orderno + "]",
            width: 600,
            height: 260,
            onLoad: function() {
                $('#selectUser').click(function() {
                    openUserSelectDialog({
                        onSelectDone: function(user){
                            $('#frmComment [name=feedbackPerson]').val(user.userId);
                            $('#frmComment #userName').text(user.aliasName);
                            return true;
                        }
                    });
                });
            },
            onSave: function(dialog) {
                if (!$('#frmComment [name=feedbackPerson]').val()) return;
                
                formSubmit('#frmComment', {
                    url: '/shop/order/comment.do',
                    success: function(ret) {
                        dialog.dialog("destroy");
                        $("#dgOrder").datagrid('reload');
                        showOpResultMessage(ret);
                    }
                });
            }
        });

	});
	
	
	function editOrder(orderno) {
		var url = CONFIG.baseUrl + "shop/order/frmOrder.do";
		if (orderno)
			url = url + "?orderno=" + orderno;
		var dlg = $("#dlgOrder").dialog({
		    title: "编辑订单",
		    width: 700,
		    height: 600,
		    closed: false,
		    cache: false,
		    href: url,
		    buttons:[{
				text:"提交",
				iconCls:"icon-save",
				handler:function(){
					$("#frmOrder").form("submit", {
					    url:CONFIG.baseUrl + "shop/order/saveOrder.do",
					    success:function(data){
					    	var data = str2Json(data);
					    	if (data.success) {
					    		dlg.dialog('close');
					    		$("#dgOrder").datagrid("load");
					    	}
				    		showMessage('提示', data.message);
					    }
					});
				}
			},{
				text:"取消",
				iconCls:'icon-cancel',
				handler:function(){
					dlg.dialog('close');
				}
			}],
		    modal: true
		});
	}
}
OrderManager.prototype = new Observable();

OrderManager.formatters = {
    status: UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('productOrder.status')),
    payStatus: UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('payStatus')),
    payType: UICommon.datagrid.formatter.generators.dict(DictMan.itemMap('payType')),
    remark: UICommon.datagrid.formatter.generators.omit({
        dgId: "dgOrder", field: "remark"
    }),
    address: UICommon.datagrid.formatter.generators.omit({dgId: 'dgOrder', field: 'address'}),
    useTime: function(_, order) {
        if (order.startFlowTime && order.endFlowTime) {
            return TimeUtils.formatToDurationText(order.endFlowTimestamp - order.startFlowTimestamp);
        } else {
            return '';
        }
    },
    starLevel: function(val, order) {
        val = val || 0;
        var html = '';
        for (var n = 0; n < 5; n++) {
            html += '<img src="' + CONFIG.baseUrl + 'images/stars/star-'
                + (n < val ? 'on' : 'off') + '.png">';
        }
        return html;
    }
}

function OrderDetailManager() {
	this.update = function(obable, data) {
		if(window["OrderManager"] && obable instanceof OrderManager) {
			switch(data.event) {
			case "onSelect":
				$("#frmQueryOrderDetail [name=orderno]").val(data.args.rowData.orderno);
				this.query();
				break;
			case "onLoadSuccess":
				$("#frmQueryOrderDetail [name=orderno]").val("");
				$("#dgOrderDetail").datagrid("loadData", {total:0,rows:[]});
				break;
			}
		}
	};

	this.query = function() {
		var params = $("#frmQueryOrderDetail").serializeObject();
		if($("#dgOrderDetail").datagrid("options").url == null) {
			$("#dgOrderDetail").datagrid({
				url: CONFIG.baseUrl + 'shop/order/orderDetailPage.do',
				cache: false,
				multiSort:true,
				fit:true,
				queryParams: params
			});
		}
		else {
			$("#dgOrderDetail").datagrid("load", params);
		}
	};
}


OrderDetailManager.formatters = {};
formatter:OrderManager.formatters.money = function(value,rowData,rowIndex) {
	return value.toString().indexOf(".") == -1 ? value + ".00" : value;
};
OrderDetailManager.formatters.imageFile = function(value,rowData,rowIndex) {
	return value == null ? "" :'<img src="' + value + '" width="100%" height="30px" />';
};
OrderDetailManager.formatters.orderDesc = UICommon.datagrid.formatter.generators.omit({
    dgId: "dgOrderDetail", field: "orderDesc"
});

$(function(){
    $('#status').comboboxFromDict({
        dict: DictMan.items('productOrder.status')
    });
    $('#payStatus').comboboxFromDict({
        dict: DictMan.items('payStatus')
    });
    $('#payType').comboboxFromDict({
        dict: DictMan.items('payType')
    });
    
	var orderManager = new OrderManager();
	var orderDetailManager = new OrderDetailManager();
	orderManager.addObserver(orderDetailManager);
	orderManager.query();
});
