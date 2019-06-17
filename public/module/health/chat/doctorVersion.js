"use strict";

(function(){
    Array.prototype.forEach = Array.prototype.forEach || function(func) {
        var array = this;
        for (var index = 0; index < array.length; index++) {
            func(array[index], index, array);
        }
    };
})();

(function(){

function PeopleList(socket) {
    var userTable = {};
    
    /**
     用户表 userId -> user, user -> orgData
     */
    this.getUserTable = function() { return userTable; }
    
    this.onStart = function(userId) {
        changeStatusStyle(userId, 2);
        setAllInquiryStartButtonDisplay('hide');
    }
    
    this.onEnd = function(userId) {
        changeStatusStyle(userId, 4);
        setAllInquiryStartButtonDisplay('show');
    }
    
    this.load = function(continu) {
        $.get(CONFIG.baseUrl + "health/getInquiryPeoples.do?t=" + new Date().getTime(), function(data){
            makeUserTableAndRender(data);
        });
        
        function makeUserTableAndRender(data) {
            //构造用户表
            userTable = {};
            userTable.orgData = data[0];
            for(var oi = 0; oi < data.length; oi++){
                var orgData = data[oi];
                for(var orgUsers = orgData.users.rows, ui = 0; ui < orgUsers.length; ui++) {
                    var user = orgUsers[ui];
                    userTable[user.userId] = user;
                    user.orgData = orgData;
                }
            }
            drawUsers(data);
            
            continu && continu();
        }
        
        function drawUsers(orgDataList) {
            function expandOnClick() {
                var typeLi = $(this).parent();
                var ul = typeLi.find("ul");
                var jt = typeLi.find(".jt");
                if (ul.hasClass("hidden")) {
                    ul.removeClass("hidden");
                    jt.removeClass("jt-zuo");
                    jt.addClass("jt-xia");
                } else {
                    ul.addClass("hidden");
                    jt.addClass("jt-zuo");
                    jt.removeClass("jt-xia");
                }
            }
            var fragment = document.createDocumentFragment();
            orgDataList.forEach(function(orgData, index){
                var li = document.createElement('li');
                $(li).addClass('type');
                
                var spanExpand =  document.createElement('span');
                $(spanExpand).addClass('jt jt-xia');
                $(spanExpand).click(expandOnClick);
                li.appendChild(spanExpand);
                
                var spanName =  document.createElement('span');
                $(spanName).addClass('type-name');
                spanName.innerHTML = orgData.name;
                $(spanName).click(expandOnClick);
                li.appendChild(spanName);
                
                var ul = document.createElement('ul');
                orgData.users.rows.forEach(function(user, index){
                   var li = document.createElement('li');
                   
                   var div = document.createElement('div');
                   div.id = user.userId;
                   $(div).addClass('item');
                   
                   var img = document.createElement('img');
                   img.src = user.headUrl || "../../images/doc_head2.png";
                   div.appendChild(img);
                   
                   var content = document.createElement('div');
                   $(content).addClass('content');
                   
                   var divTop = document.createElement('div');
                   $(divTop).addClass('top');
                   
                   var divUserName = document.createElement('div');
                   $(divUserName).addClass('name');
                   divUserName.innerHTML = divUserName.title = user.userName;
                   divTop.appendChild(divUserName);
                   
                   var divStatus = document.createElement('div');
                   $(divStatus).addClass('status ' + {
                       "1": "status-confirm_waitting",
                       "2": "status-doing",
                       "3": "status-confirm_end",
                       "4": "status-done",
                       '5': ''
                   }[user.status]);
                   divTop.appendChild(divStatus);
                   content.appendChild(divTop);
                   
                   var divButton = document.createElement('div');
                   $(divButton).addClass('botton');
                   
                   var divBtn1 = document.createElement('div');
                   $(divBtn1).addClass('btn1');
                   divBtn1.title = '查看个人详细信息';
                   // 查看档案
                   $(divBtn1).click(function(){
                       var userId = $(this).parents(".item").attr("id");
                       showMedicalUserDetail(userId);
                   });
                   divButton.appendChild(divBtn1);
                   
                   var divBtn3 = document.createElement('div');
                   $(divBtn3).addClass('btn3');
                   divBtn3.title = '开始咨询';
                   $(divBtn3).css('display', user.status == 2 ? 'none' : 'block');
                   // 开始问诊
                   $(divBtn3).click(function(){
                       var userId = $(this).parents("div.item").attr("id");
                       var doctorId = userTable[userId].doctorCameraCfg.adminId;
                       socket.emit("intent",
                           {type: 'start', from: doctorId, to: 'org_' + orgData.id, data: {userId: userId, doctorId: doctorId}});
                   });
                   divButton.appendChild(divBtn3);
                   
                   content.appendChild(divButton);
                   div.appendChild(content);
                   li.appendChild(div);
                   ul.appendChild(li);
                });

                li.appendChild(ul);
                fragment.appendChild(li);
            });
            
            $('#userList').append(fragment);

        }
    }
    
    function changeStatusStyle(userId, status) {
        var elem = $("#" + userId + " .status");
        if(1 <= status && status <= 4) {
            var sc = {
                "1": "status-confirm_waitting",
                "2": "status-doing",
                "3": "status-confirm_end",
                "4": "status-done"
            }[status];
            if(! elem.hasClass("." + sc))
                elem.removeClass().addClass("status " + sc);
        } else {
            elem.removeClass().addClass("status");
        }
    }
}


function setAllInquiryStartButtonDisplay(fn) {
    $(".type-list .btn3").each(function(){
        $.fn[fn].call($(this));
    });
}

function DoctorSide(){
    var socket;
    var loginTimeoutTimer;
    socket = window.socket = io.connect('wss://service.loveonline.net.cn:9093');
    socket.on('connect', function() {
        console.info('socket connected');
     });
    
    socket.on("message", function(data){
        switch (data.type) {
        case 'otherInfo':
            var user = JSON.parse(data.content);
            activeUserInfoPanel.loadUser(user);
            break;
        default:
            eval('(' + data.content + ')');
        }
        
    });
    
    socket.on('connect_failed', function() {
        console.log('onconnect_failed')
        socket.connect();
    });
    socket.on("online", function(){
        showMessage('您已上线');
        clearTimeout(loginTimeoutTimer);
    });
    socket.on("intent.start", function onStart(data) {
        activeInquiry = data;
        activeUserId = data.userId;

        $("#videoOtherSideName").text(peopleList.getUserTable().orgData.name);
        setAllInquiryStartButtonDisplay("hide");
        setDisplayEndButton(true);
        
        $("#medicalResult").val('').prop('disabled', false);
        
        $("#videoTitle").show();
        var cameraCfg = peopleList.getUserTable().orgData.cameraCfg;
        open2Video(cameraCfg);
        // 如果来自其它方,发送已处理事件
        if (pageConfig.doctor.id != data.from) {
            socket.emit('intent', {type: 'startRequestHandled'});
        }
    });
    
    socket.on("intent.end", function(){
        end();
    });
    
    socket.on('system.result', function(code) {
       if (code == 6)
           showMessage('对方正在与其他人进行咨询,请稍等');
    });
    
	var videoCtrlMaster = null;
	var videoCtrl = null, videoCtrl2 = null;
	var activeUserId = null;
	var activeInquiry = null;
	
    var peopleList = new PeopleList(socket);
    
    window.activeUserInfoPanel = new ActiveUserInfoPanel();
    
	$(function(){
		$("#submitInquiryResult").click(function(){
			if(!activeInquiry) {
				showMessage("还没有会诊进行中"); 
				return;
			}
		    showMessage('已发送');
		});
		
		peopleList.load(function() {
		    $("[name=medicalResult]").focus(function(){
		        socket.emit('message', {to: 'org_' + peopleList.getUserTable().orgData.id, type: 'editing', content: this.value});
		    }).blur(function(){
		        socket.emit('message', {to: 'org_' + peopleList.getUserTable().orgData.id, type: 'unedit', content: this.value});
		    }).keyup(function(){
		        //socket.emit('message', {to: 'org_' + peopleList.getUserTable().orgData.id, type: 'text', content: this.value});
		    }).change(function(){
		        socket.emit('message', {to: 'org_' + peopleList.getUserTable().orgData.id, type: 'text', content: this.value});
		    });
		    
	        socket.emit('login', {id: window.pageConfig.doctor.id});

			videoCtrlMaster = new VideoCtrlMaster({talkButton: false});
			videoCtrl = new VideoCtrl($('#mainVideoObject').get(0), {cameraCfg: window.pageConfig.doctor.cameraCfg, streamType: 1});
			videoCtrlMaster.addMe(videoCtrl);
		});
	});
	
	
	function end() {
        setDisplayEndButton(false);
        $("#medicalResult").val('').prop('disabled', true);
        $("#videoTitle").hide();
        $("#videoOtherSideName").empty();
        activeUserInfoPanel.clear();
        activeInquiry = null;
        videoCtrlMaster.closeHe();
	}
	
    function setDisplayEndButton(b) {
        if ($('#end').length == 0) {
            var btnEnd = $("<button id=end class=titleBtn title='结束会诊'>结束会诊</button>");
            btnEnd.click(function(){
                socket.emit("intent", {type: 'end'});
                end();
            });
            btnEnd.insertBefore(".title #msg");
        } else
            var btnEnd = $('#end');
        
        b ? btnEnd.show() : btnEnd.hide();
    }
    
	function open2Video(cameraCfg) {
		if(videoCtrl2 == null) {
		    videoCtrl2 = new VideoCtrl($('#otherVideoObject').get(0), {cameraCfg: cameraCfg, streamType: 1, hasActionUI: false});
		}
	    setDoctorDefHeadVisible(false);
		if (!videoCtrl2.opened) {
		    videoCtrlMaster.addHe(videoCtrl2, null, function() {
	            videoCtrlMaster.switchMain();
			});
		}
	}
	
	function setDoctorDefHeadVisible(b) {
		if(b) {
			if($("#doctorDefHead").length == 0) {
				$("#videoSmallColl").prepend('<img id="doctorDefHead" class="head2" src="../../images/doctor.png"/>');
				$('#videoSmallColl .plugin').hide();
			}
		} else {
			$("#doctorDefHead").remove();
			$('#videoSmallColl .plugin').show();
		}
	}

    function showMedicalUserDetail(userId) {
        window.open(CONFIG.baseUrl + "health/medicalUserDetail.do?userId=" + userId);
    }
}

new DoctorSide();

})();