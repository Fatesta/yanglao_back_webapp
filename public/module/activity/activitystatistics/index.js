/**
 * 活动统计
 * 
 * @author ccq
 * */

var formatters = {
		status : function(v) {
			return {
				0 : '取消',
				1 : '有效'
			}[v];
		},
		userType : function(v){
		    if(v=='user'){
		        return '前台用户';
		    }else if(v=='admin'){
		        return '系统用户';
		    }
		},
		title : UICommon.datagrid.formatter.generators.omit({
	        dgId: "dntegral", field: "title"
	    }),
		 description: UICommon.datagrid.formatter.generators.omit({
		        dgId: "dntegral", field: "description"
		    }),
		scope : function(v){
		    if(v == -1){
		        return '不限社区';
		    }
		    return v;
		},
		formatOper : function(value,row,index){
			return  row.signCount > 0 ?'<a   onclick = "signPeople('+index+')">查看参与人</a>' : '';
		
		}
};
$("#frmQuery [name = query]").click(function(){
	var params = $("#frmQuery").serializeObject();
	$("#dntegral").datagrid("load",params);
});



function signPeople(index){
	var row=$('#dntegral').datagrid('getRows')[index];
	if(row){
		parent.openTab({
			url : CONFIG.baseUrl +'view/activity/signInForm.do?activityId='+row.id,
			title : "参与人列表"
		});
	}
};