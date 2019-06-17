var returnvisit = (function(){
    var datagrid = $("#dgReturnvisit");
    
    $('#tbrReturnvisit [name=query]').click(function(){
        datagrid.datagrid("load", $('#tbrReturnvisit [name=frmQuery]').serializeObject());
    });

    $('#tbrReturnvisit [name=add]').click(function(){
    	openTab("mainTab",CONFIG.baseUrl +'community/returnvisit/form.do',"增加回访");
    });

    $('#tbrReturnvisit [name=update]').click(function(){
        edit(true);
    });
    
    $('#tbrReturnvisit [name=delete]').click(function(){
        var row = datagrid.datagrid('getSelected');
        if(!row) return;
        openConfirmDeleteDialog(function(){
            $.post(CONFIG.baseUrl + 'community/returnvisit/delete.do?id=' + row.id, function(ret){
                showOpResultMessage(ret);
                datagrid.datagrid('load');
            });
        });
    });
    
     /*function edit(isUpdate) { 	
        var url = 'community/returnvisit/form.do';
        if (isUpdate) {
            var row = datagrid.datagrid('getSelected')
            if (!row) return;
            url += '?id=' + row.id;
        };
        
    		openTab("mainTab",CONFIG.baseUrl +'community/returnvisit/form.do?id='+row.id,"增加回访");
   
      var dlg = openEditDialog({
            width: 500,
            height: 440,
            href: url,
            title: '编辑回访记录',
            onLoad: function() {
                $('#selectUser').click(function() {
                    openUserSelectDialog({
                        onSelectDone: function(user){
                            $('#frmReturnvisit [name=userId]').val(user.userId);
                            $('#frmReturnvisit #userName').textbox('setValue', user.aliasName);
                            return true;
                        }
                    });
                });
            },
            onSave: function() {
                formSubmit('#frmReturnvisit', {
                    url: 'community/returnvisit/save.do',
                    success: function(success) {
                        if (success) {
                            dlg.dialog('destroy');
                            datagrid.datagrid('load');
                        }
                        showOpResultMessage(success);
                    }
                });
            }
        });
    }*/
    return {
        formatters: {
            subject: UICommon.datagrid.formatter.generators.omit({dgId: 'dgReturnvisit', field: 'subject', min: 50}),
            result: UICommon.datagrid.formatter.generators.omit({dgId: 'dgReturnvisit', field: 'result'}),
            score: function(val) { 
            	var html ='';
                if(val == -1){
                	html = '未评分';
                }else{                	
	                for (var n = 0; n < val; n++) {	              
	                 html += '<img src="'+CONFIG.baseUrl+'images/stars/star-'+(n<val?'on':'off')+'.png">';
	                }
                }
                return html;
            },
    		oper:function(value,data,rowindex){
    			return data.score ==-1 ?'<a href="#" class="datagrid-tail-button" data-options="iconCls:\'color:fff\'"  onclick = "starlevel('+rowindex+')" style = "margin: 0 auto;">评价</a>':
    				'<a  class="datagrid-tail-button"href="#" data-options="iconCls:icon-detail\'color:fff\'"  onclick = "lookup('+rowindex+')" style="margin: 0 auto;">查看</a>';   		
    		}			
        }
    }
})();


function starlevel(index){
	$("#dgReturnvisit").datagrid('selectRow',index);
	var row=$('#dgReturnvisit').datagrid('getSelected');
	if(row.score != -1){
		$.messager.show({
			title:'提示消息',
			msg:'您已经评分了，谢谢！',
			timeout:1000,
			style:{
				right:'',
				top:document.body.scrollTop+document.documentElement.scrollTop,
				bottom:''
			}
		});
		return;
	};	
	var dlg = openEditDialog({
		title: "评价",
		width: 500,
		height: 350,
		href: 'view/community/returnvisit/starscore.do?id=' + row.id,
		onLoad:function(){				
			$('#score').raty({
                score: $('#score').data('val'),
                scoreName: 'score',
                path: CONFIG.imagePath + 'stars'
            });
		},	
		onSave: function(){				
			formSubmit('#frmscore', {
				url: "community/returnvisit/savesubject.do",
				 
				success:function(data){
					if(data){
						dlg.dialog('destroy');
						$("#dgReturnvisit").datagrid('load');
					}
					showOpResultMessage(true); 
				}
			});
		}
	});	
};

function lookup(index){
	$("#dgReturnvisit").datagrid('selectRow',index);
	var row=$('#dgReturnvisit').datagrid('getSelected');
	var dlg = openSimpleDialog({
		title: "访问结果",
		width: 380,
		height: 380,
		href: 'view/community/returnvisit/lookup.do?id=' + row.id,
		onLoad:function(){	
			$.post(CONFIG.baseUrl +'community/returnvisit/get.do',{id:row.id},function(returnvisit){
				$("#lookupfrm [name=result]").val(returnvisit.result);
				$("#lookupfrm [name=userName]").val(returnvisit.userName);
				$("#lookupfrm [name=score]").val(returnvisit.score);
				$("#lookupfrm [name=visitTime]").text(returnvisit.visitTime);
				$("#lookupfrm [name=subject]").val(returnvisit.subject);
				$("#lookupfrm #score").raty({
					score:returnvisit.score,
					scoreName: 'score',
					path: CONFIG.imagePath + 'stars'
				});
			});
	
		}	
});
}
