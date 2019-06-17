$("#query").click(function(){
	var param = $("#frmQuery").serializeObject();	
	$("#dgIntegralExchangeRecord").datagrid('load', param);
});

$("#selectProvider").click(function(){
    $("#providerName").textbox('clear');
    $("[name=providerId]").val('');
	 openProviderSelectDialog({
	     displayIndustries: ['integral_mall'],
	     defaultSelectIndustry: 'integral_mall',
         onDone: function(provider) {     	   	
      	   $("#providerName").textbox('setValue', provider.name);
      	   $("[name=providerId]").val(provider.providerId);
      	   return true;
         }
     });
});

$("#selectUser").click(function(){
    $("#userName").textbox('clear');
    $("[name=userId]").val('');
	openUserSelectDialog({
		onSelectDone:function(user){
			$("#userName").textbox('setValue',user.aliasName);
			$("[name=userId]").val(user.userId);
			return true;
		}
	})
});

$("#exchange").click(function(){
	var dlg = openEditDialog({
		href : 'view/usercare/integralExchange/exchangeForm.do',
		title : "积分兑换",
		width:758,
		height: '90%',
		onSave: function() {
		    submit(dlg);
		}
	});
})