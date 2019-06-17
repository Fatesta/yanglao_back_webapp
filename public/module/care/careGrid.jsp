<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
</head>
<body>
<div class="easyui-accordion" data-options="fit:true">
    <div title="关爱总览" data-options="iconCls:'icon-care',selected:true,onExpand:refreshCareGrid" style="overflow:auto;padding:10px;">
		<div id="careGridToolbar">
		</div>
		<table id="careGrid" class="easyui-datagrid"
			data-options="url:'${urlPath }care/listCare.do?deviceId=${deviceId }',
						  fit:true,
						  toolbar:'#careGridToolbar'">
		    <thead>
		        <tr>
		            <th data-options="field:'title',width:250,halign:'center'">标题</th>
		            <th data-options="field:'type',width:60,halign:'center',formatter:formatType">类型</th>
		            <th data-options="field:'weekTime',width:500,halign:'center',formatter:formatWeekTime">时间</th>
		            <th data-options="field:'weekDay',width:130,halign:'center',formatter:formatWeekDay">重复</th>
		            <th data-options="field:'isvalid',width:60,halign:'center',formatter:formatStatus">是否启用</th>
		            <th data-options="field:'-',width:60,halign:'center',formatter:formatOp">操作</th>
		        </tr>
		    </thead>
		</table>
		<script>
		
			function refreshCareGrid() {
				$("#careGrid").datagrid("reload");
			}
		
			function formatOp(value,rowData,rowIndex) {
				if (rowData.isvalid == 1) {
					return '<a title="禁用" href="#" class="easyui-linkbutton" data-options="iconCls:\'color:fff\'" onclick="disable(\'' + rowData.careId + '\')"><div class=\'icon-disable\'>&nbsp;</div></a>';
				}
				return '<a title="激活" href="#" class="easyui-linkbutton" data-options="iconCls:\'color:fff\'" onclick="enable(\'' + rowData.careId + '\')"><div class=\'icon-enable\'>&nbsp;</div></a>';
			}
			
			function enable(careId) {
				showConfirm("确认操作", "确认激活关爱", function(){
					post("${urlPath}care/toggleStatus.do", {careId:careId,isvalid:1}, function(){
						$("#careGrid").datagrid("load",{});
					}, "json");
				});
			}
			
			function disable(careId) {
				showConfirm("确认操作", "确认禁用关爱", function(){
					post("${urlPath}care/toggleStatus.do", {careId:careId,isvalid:0}, function(){
						$("#careGrid").datagrid("load",{});
					}, "json");
				},"json");
			}
		
			function formatWeekDay(value) {
				var result = "";
				var day = ['sun','mon','tue','wed','tus','fri','sat'];
				for (var i = 0; i < value.length; i++) {
    				var selected = value.charAt(i) == 1 ? 'y' : 'n';
    				var text = day[i];
    				result = result + "<div class='icon-date-ic-" + day[i] + "-" + selected + "' style='float:left;width:16px;'>&nbsp;</div>";
    			}
				return result;				
			}
		
			function formatType(value,rowData,rowIndex) {
				if (value == 1) {
					return "闹钟";
				} else if (value == 2) {
					return "吃药";
				} else if (value == 3) {
					return "喝水";
				} else if (value == 4) {
					return "天气";
				} else if (value == 5) {
					return "新闻资讯";
				} else if (value == 6) {
					return "健康养生";
				} else if (value == 8) {
                    return "慢病康复";
                }  
			}
			
			function formatStatus(value,rowData,rowIndex) {
				if (value == 1) {
					return "<div class='icon-enable'>&nbsp</div>";
				}
				return "<div class='icon-disable'>&nbsp</div>";
			}
		
			function formatWeekTime(value,rowData,rowIndex) {
			    return !value ? "" : value.split(",").map(function(t) { return t.substring(0,5) }).join("、");
			}
		</script>
    </div>
    <div id="weather" title="天气提醒" data-options="iconCls:'icon-weather'" style="overflow:auto;padding:10px;">
    	<form id="weatherForm">
    	<input type="hidden" name="deviceId" value="${deviceId }">
    	<div>
			<a id="weather_weekTime_add" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add',onClick:addWeather">添加</a>
			<a id="weather_weekTime_save" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save',onClick:saveWeather">保存</a>
    	</div>
    	<div>
    		<table id="weather_weekTimes">
    			<c:forEach items="${weather.weekTimes }" var="time" varStatus="st">
    			<tr id="weather_weekTime_${st.index }">
    				<td><label>第${st.index + 1 }次</label></td>
    				<td><input name="weekTimes" value="${time }" class="easyui-timespinner" style="width:80px;" data-options="showSeconds:false,required:true"></td>
    				<td><a id="weather_weekTime_delete_${st.index }" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-delete',onClick:deleteWeather"></a></td>
    			</tr>
    			</c:forEach>
    		</table>
    		<div>
	    		重复
	    		<input id="weatherDay" type="hidden" name="weekDay" value="${weather.weekDay == null ? '0000000' :weather.weekDay }">
				<a href="#" data-options="text:'日'"></a>
				<a href="#" data-options="text:'一'"></a>
				<a href="#" data-options="text:'二'"></a>
				<a href="#" data-options="text:'三'"></a>
				<a href="#" data-options="text:'四'"></a>
				<a href="#" data-options="text:'五'"></a>
				<a href="#" data-options="text:'六'"></a>
			</div>
    	</div>
    	</form>
    	<script>
    		
    		$(function(){
    			
    			initDay("weatherDay");
    			
    		});

    		function initDay(id) {
    			var $day = $("#" + id);
    			var day = $day.val();
    			var btns = $day.siblings("a");
    			$(btns).css("font-color", "white");
    			$(btns).css("background-color", "gray");
    			
    			for (var i = 0; i < day.length; i++) {
    				var selected = day.charAt(i);
    				var $btn = $(btns[i]);
    				$btn.linkbutton({
    					selected : selected == 1,
						toggle : true,
    				    onClick : selectDay
    				});
    				$btn.css("background-color", "#01B468");
    				$(btns).css("font-weight", "bold");
    			}
    		}
    	
    		function selectDay() {
    			var $input = $($(this).siblings("input")[0]);
    			var $btns = $input.siblings("a");
    			var text = "";
    			$btns.each(function (index, domEle){
    				var ops = $(domEle).linkbutton("options");
					text = text + (ops.selected ? '1' : '0');     				
    			});
    			$input.val(text);
    		}
    		
    		function checkeWeekTimes() {
		        // 获取所有的WeekTime对象
		    	var $weekTimes = $("[name=weekTimes]");
		        for (var i = 0; i < $weekTimes.length; i ++) {
		        	for (var j = i + 1; j < $weekTimes.length; j ++) {
		        		if ($($weekTimes.get(i)).val() == $($weekTimes.get(j)).val()) {
		        			showAlert("操作提示", "不能设置重复的提醒时间！", "warning");
		        			return false;
		        		}
		        	}
		        }
    		}
    	
    		function saveWeather() {
    		    formSubmit('#weatherForm', {
    			    url:"care/saveWeather.do",
    			    onSubmit: checkeWeekTimes,
    			    success:function(data){
    			        showMessage("操作提示", "保存成功");
    			    }
    			});
    		}
    	
    		function addWeather() {
    			// 获取Week Time容器对象
    			var $weekTimes = $("#weather_weekTimes");
    			// 计算添加的Week Time控件的ID
    			var weekTimeId = $weekTimes.children("tbody").children("tr").length;
    			// 计算当前时间
    			var date = new Date();
    			var weekTime = date.getHours()+ ":" + date.getMinutes(); 
    			// 构建Week Time DOM
    			var weekTimeDom = "<tr id='weather_weekTime_" + weekTimeId + "' >" +
    									"<td>" +
    										"<label>第" + (weekTimeId + 1) + "次</label>" +
    									"</td>" +
    									"<td>" +
    										"<input id=\"weather_weekTime_input_"+ weekTimeId +"\" name=\"weekTimes\" class=\"easyui-timespinner\" value=\"" + weekTime + "\" style=\"width:80px;\"  data-options=\"showSeconds:false,required:true\">" +
										"</td>" +
										"<td>" +
											"<a id=\"weather_weekTime_delete_" + weekTimeId + "\" href=\"#\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-delete',onClick:deleteWeather\"></a>" +
										"</td>" +
    							  "</tr>";
    			$weekTimes.append(weekTimeDom);
    			// 初始化Week Time插件
    			$.parser.parse($("#weather"));
    		}
    		
    		function deleteWeather() {
    			// 获取要删除的Week Time组件
    			var weekTime = $(this).parent("td").parent("tr");
    			// 删除
    			$(weekTime).remove();
    			// 重新计算label值
    			$("#weather_weekTimes label").each(function(idx, dom){
    				$(dom).html("第" + (idx + 1) + "次");
    			});
    		}
    	
    	</script>
    </div>
    
    <div id="mbkf" title="慢病康复提醒" data-options="iconCls:'icon-health'" style="overflow:auto;padding:10px;">
        <form id="mbkfForm">
            <input type="hidden" name="deviceId" value="${deviceId }">
	        <table>
                <tr>
	                <td>学习课件</td>
	                <td><input id="mbkfResource" name="resourceId" class="easyui-combobox"></td>
	            </tr>
	        </table>
	        <div>
	            <table id="mbkf_weekTimes">
	            </table>
	            <div>
	                重复:
	                <input id="mbkfDay" type="hidden" name="weekDay" value="${mbkf.weekDay == null ? '0000000' :mbkf.weekDay }">
	                <a href="#" data-options="text:'日'"></a>
	                <a href="#" data-options="text:'一'"></a>
	                <a href="#" data-options="text:'二'"></a>
	                <a href="#" data-options="text:'三'"></a>
	                <a href="#" data-options="text:'四'"></a>
	                <a href="#" data-options="text:'五'"></a>
	                <a href="#" data-options="text:'六'"></a>
	            </div>
		        <div style="margin-top:10px">
		            <a id="mbkf_weekTime_add" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add',onClick:addMbkf">添加时间点</a>
		            <a id="mbkf_weekTime_save" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save',onClick:saveMbkf">保存</a>
		        </div>
		            
	        </div>
        </form>
        <script>
            $(function(){
                initDay("mbkfDay");
                $('#mbkf_weekTime_add').linkbutton({disabled: true});
                $('#mbkf_weekTime_save').linkbutton({disabled: true});
                $('#mbkfResource').combobox({
                    valueField:'id',
                    textField:'title',
                    url:'${urlPath }info/page.do?status=1',
                    loadFilter: function(page) {
                        return page.rows;
                    },
                    onSelect: function(item) {
                        $('#mbkf_weekTime_add').linkbutton({disabled: false});
                        $('#mbkf_weekTime_save').linkbutton({disabled: false});
                        $("#mbkf_weekTimes").empty();
                        $('#mbkfDay').val("0000000");
                        initDay('mbkfDay');
                        $.get('${urlPath}care/getMbkfNotification.do?userId=${deviceId }', function(notifs){
                            var notif = notifs.filter(function(notif){ return notif.resourcePath == item.url })[0];
                            if (notif) {
	                            $('#mbkfDay').val(notif.weekDay);
	                            initDay('mbkfDay');
	                            var times = notif.weekTime.split(',');
	                            times.forEach(function(time){
	                                addMbkf(time);
	                            });
                            }
                        });
                    }
                });
            });
            function initDay(id) {
                var $day = $("#" + id);
                var day = $day.val();
                var btns = $day.siblings("a");
                $(btns).css("font-color", "white");
                $(btns).css("background-color", "gray");
                
                for (var i = 0; i < day.length; i++) {
                    var selected = day.charAt(i);
                    var $btn = $(btns[i]);
                    $btn.linkbutton({
                        selected : selected == 1,
                        toggle : true,
                        onClick : function() {
                            var $input = $($(this).siblings("input")[0]);
                            var $btns = $input.siblings("a");
                            var text = "";
                            $btns.each(function (index, domEle){
                                var ops = $(domEle).linkbutton("options");
                                text = text + (ops.selected ? '1' : '0');                   
                            });
                            $input.val(text);
                        }
                    });
                    $btn.css("background-color", "#01B468");
                    $(btns).css("font-weight", "bold");
                }
            }

            function saveMbkf() {
                formSubmit('#mbkfForm', {
                    url:"care/saveMbkf.do",
                    onSubmit: function() {
                        if($('#mbkf_weekTimes tr').length == 0) {
                            showAlert("操作提示", "未设置提醒时间点！", "warning");
                            return false;
                        }
                        // 获取所有的WeekTime对象
                        var $weekTimes = $("[name=weekTimes]");
                        for (var i = 0; i < $weekTimes.length; i ++) {
                            for (var j = i + 1; j < $weekTimes.length; j ++) {
                                if ($($weekTimes.get(i)).val() == $($weekTimes.get(j)).val()) {
                                    showAlert("操作提示", "不能设置重复的提醒时间点！", "warning");
                                    return false;
                                }
                            }
                        }
                    },
                    success:function(data){
                        showMessage("操作提示", "保存成功");
                    }
                });
            }
        
            function addMbkf(time) {
                // 获取Week Time容器对象
                var $weekTimes = $("#mbkf_weekTimes");
                // 计算添加的Week Time控件的ID
                var weekTimeId = $weekTimes.children("tbody").children("tr").length;
                // 计算当前时间
                var weekTime = time || (new Date().getHours()+ ":" + new Date().getMinutes()); 
                // 构建Week Time DOM
                var weekTimeDom = "<tr id='mbkf_weekTime_" + weekTimeId + "' >" +
                                        "<td>" +
                                            "<label>第" + (weekTimeId + 1) + "次</label>" +
                                        "</td>" +
                                        "<td>" +
                                            "<input id=\"mbkf_weekTime_input_"+ weekTimeId +"\" name=\"weekTimes\" class=\"easyui-timespinner\" value=\"" + weekTime + "\" style=\"width:80px;\"  data-options=\"showSeconds:false,required:true\">" +
                                        "</td>" +
                                        "<td>" +
                                            "<a id=\"mbkf_weekTime_delete_" + weekTimeId + "\" href=\"#\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-delete',onClick:deleteMbkf\"></a>" +
                                        "</td>" +
                                  "</tr>";
                $weekTimes.append(weekTimeDom);
                // 初始化Week Time插件
                $.parser.parse($("#mbkf_weekTimes"));
            }
            
            function deleteMbkf() {
                // 获取要删除的Week Time组件
                var weekTime = $(this).parent("td").parent("tr");
                // 删除
                $(weekTime).remove();
                // 重新计算label值
                $("#mbkf_weekTimes label").each(function(idx, dom){
                    $(dom).html("第" + (idx + 1) + "次");
                });
            }
        
        </script>
    </div>
    
    <div id="medicine" title="吃药提醒" data-options="iconCls:'icon-medicine'" style="overflow:auto;padding:10px;">
    	<form id="medicineForm">
    	<input type="hidden" name="deviceId" value="${deviceId }" >
    	<table class="form">
    		<tr>
	    		<td>需要服用的药品</td>
	    		<td><a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-medicine',onClick:showSelectMedicineForm">选药</a></td>
    		</tr>
    		<tr>
	    		<td>
	    			<label>A</label>
	    			<input class="easyui-textbox" id="medicineAName" name="name" data-options="required:true" value="${medicines[0].name }" style="width:300px">
	    		</td>
	    		<td>
	    			<input class="easyui-numberspinner" name="num" value="${medicines[0].num==null?'1':medicines[0].num}" style="width:150px;"
        				data-options="required:true,min:0">
        			<input class="easyui-combobox" name="unit"
    					data-options="required:true,valueField:'id',textField:'text',data:[{id: '颗',text: '颗'},{id: '袋',text: '袋'},{id: '毫升',text: '毫升'}]" value="${medicines[0].unit== null?'颗':medicines[0].unit}" style="width:80px;">
	    		</td>
    		</tr>
    		<tr>
	    		<td>
	    			<label>B</label>
	    			<input class="easyui-textbox" id="medicineBName" name="name" data-options="required:true" value="${medicines[1].name }" style="width:300px">
	    		</td>
	    		<td>
	    			<input class="easyui-numberspinner" name="num" value="${medicines[1].num==null?'1':medicines[1].num}" style="width:150px;"
        				data-options="required:true,min:0">
        			<input class="easyui-combobox" name="unit"
    					data-options="required:true,valueField:'id',textField:'text',data:[{id: '颗',text: '颗'},{id: '袋',text: '袋'},{id: '毫升',text: '毫升'}]" value="${medicines[1].unit== null?'颗':medicines[1].unit}" style="width:80px;">
	    		</td>
    		</tr>
    		<tr>
	    		<td>
	    			<label>C</label>
	    			<input class="easyui-textbox" id="medicineCName" name="name" data-options="required:true" value="${medicines[2].name }" style="width:300px">
	    		</td>
	    		<td>
	    			<input class="easyui-numberspinner" name="num" value="${medicines[2].num==null?'1':medicines[2].num}" style="width:150px;"
        				data-options="required:true,min:0">
        			<input class="easyui-combobox" name="unit"
    					data-options="required:true,valueField:'id',textField:'text',data:[{id: '颗',text: '颗'},{id: '袋',text: '袋'},{id: '毫升',text: '毫升'}]" value="${medicines[2].unit== null?'颗':medicines[2].unit}" style="width:80px;">
	    		</td>
    		</tr>
    		<tr>
	    		<td>
	    			<label>D</label>
	    			<input class="easyui-textbox" id="medicineDName" name="name" data-options="required:true" value="${medicines[3].name }" style="width:300px">
	    		</td>
	    		<td>
	    			<input class="easyui-numberspinner" name="num" value="${medicines[3].num==null?'1':medicines[3].num}" style="width:150px;"
        				data-options="required:true,min:0">
        			<input class="easyui-combobox" name="unit"
    					data-options="required:true,valueField:'id',textField:'text',data:[{id: '颗',text: '颗'},{id: '袋',text: '袋'},{id: '毫升',text: '毫升'}]" value="${medicines[3].unit== null?'颗':medicines[3].unit}" style="width:80px;">
	    		</td>
    		</tr>
    		<tr>
	    		<td>
	    			<label>E</label>
	    			<input class="easyui-textbox" id="medicineEName" name="name" data-options="required:true" value="${medicines[4].name }" style="width:300px">
	    		</td>
	    		<td>
	    			<input class="easyui-numberspinner" name="num" value="${medicines[4].num==null?'1':medicines[4].num}" style="width:150px;"
        				data-options="required:true,min:0">
        			<input class="easyui-combobox" name="unit"
    					data-options="required:true,valueField:'id',textField:'text',data:[{id: '颗',text: '颗'},{id: '袋',text: '袋'},{id: '毫升',text: '毫升'}]" value="${medicines[4].unit== null?'颗':medicines[4].unit}" style="width:80px;">
	    		</td>
    		</tr>
    	</table>
    	<div id="plans">
    		<div>
    			服用计划
	    		<a id="medicinePlan_add" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add',onClick:addPlan">添加</a>
				<a id="medicinePlan_save" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save',onClick:savePlan">保存</a>
    		</div>
    		<c:forEach items="${medicationPlans }" var="plan" varStatus="st">
    			<div>
    				<label>第${st.index + 1 }次</label>
					<input name="weekTimes" value="${plan.weekTime }" class="easyui-timespinner" style="width:80px;" data-options="showSeconds:false,required:true">
					<input name="orders" value="${plan.orders }" type="hidden">
    				<a href="#" class="easyui-linkbutton medicine-btn" data-options="text:'A',toggle:true,selected:${fn:contains(plan.orders,'0') },onClick:changeOrders"></a>
					<a href="#" class="easyui-linkbutton medicine-btn" data-options="text:'B',toggle:true,selected:${fn:contains(plan.orders,'1') },onClick:changeOrders"></a>
					<a href="#" class="easyui-linkbutton medicine-btn" data-options="text:'C',toggle:true,selected:${fn:contains(plan.orders,'2') },onClick:changeOrders"></a>
					<a href="#" class="easyui-linkbutton medicine-btn" data-options="text:'D',toggle:true,selected:${fn:contains(plan.orders,'3') },onClick:changeOrders"></a>
					<a href="#" class="easyui-linkbutton medicine-btn" data-options="text:'E',toggle:true,selected:${fn:contains(plan.orders,'4') },onClick:changeOrders"></a>
					<a id="medicinePlan_delete_${st.index }" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-delete',onClick:deleteMedicine"></a>
    			</div>
    		</c:forEach>
    	</div>
    	<div id="selectMedicineDlg"></div>
    	</form>
		<script>
			
			function showSelectMedicineForm() {
				var href = "${urlPath }care/showSelectMedicineForm.do";
				var dlg = $("#selectMedicineDlg").dialog({
				    title: "选择药品",
				    width: 450,
				    height: 300,
				    closed: false,
				    cache: false,
				    href: href,
				    buttons:[{
						text:"提交",
						iconCls:"icon-save",
						handler:function(){
							var text = $("#drugCombobox").combobox("getText");
							if (text != "") {
								var names = text.split(",");
								var map = ["medicineAName", "medicineBName", "medicineCName", "medicineDName", "medicineEName"];
								for (var i = 0; i < names.length; i++) {
									var id = map[i];
									$("#" + id).textbox("setValue", names[i]);
								}
							}
							dlg.dialog("close");
						}
					},{
						text:"取消",
						iconCls:'icon-cancel',
						handler:function(){
							dlg.dialog("close");	
						}
					}],
				    modal: true
				});
			}
		
			function changeOrders() {
				var $btn = $(this);
				var id = "medicine" + $btn.linkbutton("options").text + "Name";
				var value = $("#" + id).textbox("getValue");
				if (value == "") {
					showAlert("错误提示", "请填写药品名称");
					$btn.linkbutton("unselect");
					return false;
				}
				var medicineBtnArr = $btn.parent().children("a.medicine-btn");
				var orders = "";
				if (medicineBtnArr.length > 0) {
					for (var i = 0; i < medicineBtnArr.length; i++) {
						if ($(medicineBtnArr[i]).linkbutton("options").selected) {
							orders = orders.concat(i).concat(",");
						}
					}
					orders = orders.substring(0, orders.length - 1);
				}
				$($(this).siblings("[name=orders]")[0]).val(orders);
			}
		
			function savePlan() {
			    formSubmit('#medicineForm', {
    			    url:"care/saveMedicine.do",
    			    onSubmit: checkeWeekTimes,
    			    success:function(data){
    			        showMessage("操作提示", "保存成功");
    			    }
    			});
			}
			
			function addPlan() {
				// 获取Plan容器对象
    			var $plans = $("#plans");
    			// 计算添加的Plan控件的ID
    			var planId = $plans.children("div").length;
    			// 计算当前时间
    			var date = new Date();
    			var weekTime = date.getHours()+ ":" + date.getMinutes(); 
    			// 构建Plan DOM
    			var planDom = "<div>" +
   										"<label>第" + planId + "次</label>" +
   										"<input name=\"weekTimes\" value=\"" + weekTime + "\" class=\"easyui-timespinner\" style=\"width:80px;\" data-options=\"showSeconds:false,required:true\">" +
   										"<input name=\"orders\" value=\"" + planId + "\" type=\"hidden\">" +
   										"<a href=\"#\" class=\"easyui-linkbutton medicine-btn\" data-options=\"text:'A',toggle:true,selected:false,onClick:changeOrders\"></a>" +
										"<a href=\"#\" class=\"easyui-linkbutton medicine-btn\" data-options=\"text:'B',toggle:true,selected:false,onClick:changeOrders\"></a>" +
										"<a href=\"#\" class=\"easyui-linkbutton medicine-btn\" data-options=\"text:'C',toggle:true,selected:false,onClick:changeOrders\"></a>" +
										"<a href=\"#\" class=\"easyui-linkbutton medicine-btn\" data-options=\"text:'D',toggle:true,selected:false,onClick:changeOrders\"></a>" +
										"<a href=\"#\" class=\"easyui-linkbutton medicine-btn\" data-options=\"text:'E',toggle:true,selected:false,onClick:changeOrders\"></a>" +
										"<a id=\"medicinePlan_delete_" + planId + " href=\"#\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-delete',onClick:deleteMedicine\"></a>" +
   							  "</div>";
   				$plans.append(planDom);
    			// 初始化Plan插件
    			$.parser.parse($("#medicine"));
			}
		
			function deleteMedicine() {
				// 获取要删除的Week Time组件
    			var plan = $(this).parent("div");
    			// 删除
    			$(plan).remove();
    			// 重新计算label值
    			$("#plans label").each(function(idx, dom){
    				$(dom).html("第" + (idx + 1) + "次");
    			});
			}
		
		</script>
    </div>
    <div id="drink" title="饮水提醒" data-options="iconCls:'icon-drink'" style="overflow:auto;padding:10px;">
    	<form id="drinkForm">
    	<input type="hidden" name="deviceId" value="${deviceId }">
    	<div>
			<a id="drink_weekTime_add" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add',onClick:addDrink">添加</a>
			<a id="drink_weekTime_save" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save',onClick:saveDrink">保存</a>
    	</div>
    	<div>
    		<table id="drink_weekTimes">
    			<c:forEach items="${drink.weekTimes }" var="time" varStatus="st">
    			<tr id="drink_weekTime_${st.index }">
    				<td><label>第${st.index + 1 }次</label></td>
    				<td><input name="weekTimes" value="${time }" class="easyui-timespinner" style="width:80px;" data-options="showSeconds:false,required:true"></td>
    				<td><a id="drink_weekTime_delete_${st.index }" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-delete',onClick:deleteDrink"></a></td>
    			</tr>
    			</c:forEach>
    		</table>
    		<div>
	    		重复
	    		<input id="drinkDay" type="hidden" name="weekDay" value="${drink.weekDay == null ? '0000000' :drink.weekDay }">
				<a href="#" data-options="text:'日'"></a>
				<a href="#" data-options="text:'一'"></a>
				<a href="#" data-options="text:'二'"></a>
				<a href="#" data-options="text:'三'"></a>
				<a href="#" data-options="text:'四'"></a>
				<a href="#" data-options="text:'五'"></a>
				<a href="#" data-options="text:'六'"></a>
			</div>
    	</div>
    	</form>
    	<script>
    		
    		$(function(){
    			
    			initDay("drinkDay");
    			
    		});

    		function saveDrink() {
    			formSubmit('#drinkForm', {
    			    url:"care/saveDrink.do",
    			    onSubmit: checkeWeekTimes,
    			    success:function(data){
    			        showMessage("操作提示", "保存成功");
    			    }
    			});
    		}
    	
    		function addDrink() {
    			// 获取Week Time容器对象
    			var $weekTimes = $("#drink_weekTimes");
    			// 计算添加的Week Time控件的ID
    			var weekTimeId = $weekTimes.children("tbody").children("tr").length;
    			// 计算当前时间
    			var date = new Date();
    			var weekTime = date.getHours()+ ":" + date.getMinutes(); 
    			// 构建Week Time DOM
    			var weekTimeDom = "<tr id='drink_weekTime_" + weekTimeId + "' >" +
    									"<td>" +
    										"<label>第" + (weekTimeId + 1) + "次</label>" +
    									"</td>" +
    									"<td>" +
    										"<input id=\"drink_weekTime_input_"+ weekTimeId +"\" name=\"weekTimes\" class=\"easyui-timespinner\" value=\"" + weekTime + "\" style=\"width:80px;\"  data-options=\"showSeconds:false,required:true\">" +
										"</td>" +
										"<td>" +
											"<a id=\"drink_weekTime_delete_" + weekTimeId + "\" href=\"#\" class=\"easyui-linkbutton\" data-options=\"iconCls:'icon-delete',onClick:deleteDrink\"></a>" +
										"</td>" +
    							  "</tr>";
    			$weekTimes.append(weekTimeDom);
    			// 初始化Week Time插件
    			$.parser.parse($("#drink"));
    		}
    		
    		function deleteDrink() {
    			// 获取要删除的Week Time组件
    			var weekTime = $(this).parent("td").parent("tr");
    			// 删除
    			$(weekTime).remove();
    			// 重新计算label值
    			$("#drink_weekTimes label").each(function(idx, dom){
    				$(dom).html("第" + (idx + 1) + "次");
    			});
    		}
    	
    	</script>
    </div>
    <div title="新闻资讯" data-options="iconCls:'icon-news'" style="overflow:auto;padding:10px;">
    	<form id="newsForm">
    	<input type="hidden" name="deviceId" value="${deviceId }">
    	<table>
    		<tr>
    			<td>已订阅</td>
    			<td>
    				<input name="category" class="easyui-combobox" data-options="valueField:'id',textField:'text',multiple:true,url:'${urlPath }care/listCategory.do?type=5',value:'${news.category }'">
    			</td>
    		</tr>
    		<tr>
    			<td>播报时间</td>
    			<td>
    				<input name="weekTime" value="${news.weekTime }" class="easyui-timespinner" style="width:80px;" data-options="showSeconds:false,required:true">
    			</td>
    		</tr>
    		<tr>
    			<td>重复</td>
    			<td>
    				<input id="newsDay" type="hidden" name="weekDay" value="${news.weekDay == null ? '0000000' :news.weekDay }">
					<a href="#" data-options="text:'日'"></a>
					<a href="#" data-options="text:'一'"></a>
					<a href="#" data-options="text:'二'"></a>
					<a href="#" data-options="text:'三'"></a>
					<a href="#" data-options="text:'四'"></a>
					<a href="#" data-options="text:'五'"></a>
					<a href="#" data-options="text:'六'"></a>
    			</td>
    		</tr>
    		<tr>
    			<td>
    				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save',onClick:saveNews">保存</a>
    			</td>
    			<td></td>
    		</tr>
    	</table>
    	</form>
    	<script>
    	
	    	$(function(){
				
				initDay("newsDay");
				
			});
    	
    		function saveNews() {
    			formSubmit('#newsForm', {
    			    url:"care/saveNews.do",
    			    onSubmit: checkeWeekTimes,
    			    success:function(data){
    			        showMessage("操作提示", "保存成功");
    			    }
    			});
    		}
    	
    	</script>
    </div>
    <div title="健康养生" data-options="iconCls:'icon-health'" style="overflow:auto;padding:10px;">
    	<form id="healthForm">
    	<input type="hidden" name="deviceId" value="${deviceId }">
    	<input name="category" value="health_care" type="hidden">
    	<table>
    	    <%--
    		<tr>
    			<td>已订阅</td>
    			<td>
    				<input name="category" class="easyui-combobox" data-options="valueField:'id',textField:'text',multiple:true,url:'${urlPath }care/listCategory.do?type=6',value:'${health.category }'">
    			</td>
    		</tr>
    		 --%>
    		<tr>
    			<td>播报时间</td>
    			<td>
    				<input name="weekTime" value="${health.weekTime }" class="easyui-timespinner" style="width:80px;" data-options="showSeconds:false,required:true">
    			</td>
    		</tr>
    		<tr>
    			<td>重复</td>
    			<td>
    				<input id="healthDay" type="hidden" name="weekDay" value="${health.weekDay == null ? '0000000' :health.weekDay }">
					<a href="#" data-options="text:'日'"></a>
					<a href="#" data-options="text:'一'"></a>
					<a href="#" data-options="text:'二'"></a>
					<a href="#" data-options="text:'三'"></a>
					<a href="#" data-options="text:'四'"></a>
					<a href="#" data-options="text:'五'"></a>
					<a href="#" data-options="text:'六'"></a>
    			</td>
    		</tr>
    		<tr>
    			<td>
    				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save',onClick:saveHealth">保存</a>
    			</td>
    			<td></td>
    		</tr>
    	</table>
    	</form>
    	<script>
    	
	    	$(function(){
				
				initDay("healthDay");
				
			});
    	
    		function saveHealth() {
    		    formSubmit('#healthForm', {
    			    url:"care/saveHealth.do",
    			    onSubmit: checkeWeekTimes,
    			    success:function(data){
    			        showMessage("操作提示", "保存成功");
    			    }
    			});
    		}
    	
    	</script>
    </div>
</div>
</body>
</html>