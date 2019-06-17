"use strict";
(function(){

function PeopleList(socket) {
    var userTable = {};
    var orgInfo;
    
    /**
     用户表 userId -> user, user -> orgData
     */
    this.getUserTable = function() { return userTable; }
    this.getOrgInfo = function() { return orgInfo; }

    this.onStart = function(userId) {
        userTable[userId].status = 2;
        changeUserStatus(userId, 2);
        setAllInquiryStartButtonDisplay('hide');
    }
    
    this.onEnd = function(userId) {
        if(userTable[userId])
            userTable[userId].status = 7;
        changeUserStatus(userId, 7);
        for (var userId in userTable) {
            changeStartButtonDisplay(userId, userTable[userId].status);
        }
    }
    
    this.load = function(continu) {
        $.get(CONFIG.baseUrl + 'health/getCurrentOrgDoctorAdminCameraConfigList.do?t=' + new Date().getTime(), function(ret){
            var userPage = {rows: []};
            ret.adminCameraConfigList.rows.forEach(function(row){
                var user = {};
                user.headUrl = null;
                user.userId = row.adminId;
                user.userName = row.adminRealName;
                user.status = row.status;
                user.doctorCameraCfg = row;
                
                userPage.rows.push(user);
            });
            userPage.total = userPage.rows.length;
            
            var orgData = [];
            orgData.push(ret.orgData);
            ret.orgData.users = userPage;
            
            makeUserTableAndRender(orgData);
        });
        
        function makeUserTableAndRender(data) {
            //构造用户表
            userTable = {};
            orgInfo = data[0];
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
                   img.src = user.headUrl || '../../images/doctor.png';
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
                   $(divStatus).addClass('status ');
                   setUserStatus(divStatus, user.status);
                   divTop.appendChild(divStatus);
                   content.appendChild(divTop);
                   
                   var divButton = document.createElement('div');
                   $(divButton).addClass('botton');
                   
                   var divBtn3 = document.createElement('div');
                   $(divBtn3).addClass('btn3');
                   divBtn3.title = '开始咨询';
                   setStartButtonDisplayByStatus(divBtn3, user.status);
                   // 开始问诊
                   $(divBtn3).click(function(){
                       setAllInquiryStartButtonDisplay("hide");
                       var userId = $(this).parents("div.item").attr("id");
                       socket.emit("intent",
                           {type: 'start', from: 'org_' + orgData.orgId, to: userId, data: {userId: userId}});
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

    function setAllInquiryStartButtonDisplay(fn) {
        $(".type-list .btn3").each(function(){
            $.fn[fn].call($(this));
        });
    }
}

function setUserStatus(div, status) {
    var USER_STATUS_STYLE_CLASS_MAP = {
        "1": "status-confirm_waitting",
        "2": "status-doing",
        "3": "status-confirm_end",
        "4": "status-done",
        '6': 'status-offline',
        '7': 'status-pause',
        '8': 'status-talking'
    };
    var USER_STATUS_COLOR_MAP = {
        "1": "#000000",
        "2": "#ff0048",
        "3": "#000000",
        "4": "#000000",
        '6': 'gray',
        '7': 'lightgreen',
        '8': '#ff0048'
    };
    var USER_STATUS_STRING_MAP = {
        "1": "等待开始",
        "2": "咨询中",
        "3": "等待结束",
        "4": "结束",
        '6': '离线',
        '7': '空闲',
        '8': '咨询中'
    };
    
    if (status != 4) {
        $(div).text('[' + USER_STATUS_STRING_MAP[status] + ']');
        $(div).css('color', USER_STATUS_COLOR_MAP[status]);
    } else {
        $(div).empty();
    }
}

function changeUserStatus(userId, status) {
    setUserStatus($("#" + userId + " .status"), status);
}

function setStartButtonDisplayByStatus(button, status) {
    if (status == 4 || status == 7 || status == 5) {
        $(button).show();
    } else {
        $(button).hide();
    }
}

function changeStartButtonDisplay(userId, status) {
    setStartButtonDisplayByStatus($("#" + userId + " .btn3"), status);
}

function showMedicalUserDetail(userId) {
    window.open(CONFIG.baseUrl + "health/medicalUserDetail.do?userId=" + userId);
}

function ActiveDoctorInfoPanel() {
    this.loadDoctor = function(doctor) {
        $("#doctor").show();
        $("#doctor #realName").text(doctor.realName);
        $("#doctor #remark").text(doctor.remark);
        $("#doctor #professor").text(doctor.professor);
        $("#doctor #department").text(doctor.department);
    }
    
    this.clear = function() {
        $("#doctor").hide();
        $("#doctor #realName").empty();
        $("#doctor #remark").empty();
        $("#doctor #professor").empty();
        $("#doctor #department").empty();
    }
}

function PatientSide() {
    var socket;
    socket = window.socket = socket = io.connect('wss://service.loveonline.net.cn:9093');
    socket.on('connect', function() {
       console.info('socket connected');
    });
    socket.on('disconnect', function() {
        console.info('socket disconnected');
     });
    socket.on("intent.start", function(data){
        peopleList.onStart(data.userId);
        
        activeUserId = data.userId;
        $.get(CONFIG.baseUrl + "admin/getById.do?id=" + data.userId, function(doctor){
            activeDoctorInfoPanel.loadDoctor(doctor);
            $("#videoOtherSideName").text(doctor.realName);
            $("#videoTitle").show();
        });
        
        setDisplayEndButton(true);
        
        $("#medicalResult").text("");
        
        var toUser = peopleList.getUserTable()[data.userId];
        open2Video(toUser.doctorCameraCfg);
        // 如果来自其它方,发送已处理事件
        if ('org_' + peopleList.getOrgInfo().orgId != data.from) {
            socket.emit('intent', {type: 'startRequestHandled'});
        }
        if (activeUserInfoPanel.getUser()) {
            socket.emit('message',
                {to: data.userId, type: 'otherInfo', content: JSON.stringify(activeUserInfoPanel.getUser()) });
        }
    });

    socket.on("intent.end", function(){        
        end();
    });
    
    socket.on("message", function(data){
        switch (data.type) {
        case 'editing':
            $('#otherSideAction').text('(对方正在输入)');
            break;
        case 'unedit':
            $('#otherSideAction').text('');
            break;
        case 'js':
            eval('(' + data.content + ')');
            break;
        default: 
            $("#medicalResult").text(data.content);
        }
    });
    
    socket.on('online', function(id){
        showMessage('您已上线');
        var friendIds = [];
        for (var userId in peopleList.getUserTable()) {
            friendIds.push(userId);
        }
        socket.emit('intent', {type: 'addFriends', data: {friendIds: friendIds.join(',')}});
    });
    
    socket.on('friendOnline', function(id){
        peopleList.getUserTable()[id].status = 7;
        changeUserStatus(id, 7);
        if (!activeUserId)
            changeStartButtonDisplay(id, 7);
        
        $.messager.show({
            title: '提示',
            width: 300,
            height: 120,
            msg: '<strong>' + peopleList.getUserTable()[id].userName + ' 上线' + '</strong>',
            timeout: 8000,
            showType:'slide'
        });
    });
    socket.on('friendOffline', function(id){
        peopleList.getUserTable()[id].status = 6;
        changeUserStatus(id, 6);
        changeStartButtonDisplay(id, 6);
        
        $.messager.show({
            title: '提示',
            msg: peopleList.getUserTable()[id].userName + ' 离线',
            timeout: 2000,
            showType:'slide'
        });
    });
    
	var videoCtrlMaster = null;
	var videoCtrl = null, videoCtrl2 = null;
	var activeUserId = null;
	
	var peopleList = new PeopleList(socket);
	
	var activeUserInfoPanel = new ActiveUserInfoPanel();
	var activeDoctorInfoPanel = new ActiveDoctorInfoPanel();
	
	activeUserInfoPanel.signals.updated.add(function() {
	    if (activeUserId == null)
	        return;
        socket.emit('message',
            {to: activeUserId, type: 'otherInfo', content: JSON.stringify(activeUserInfoPanel.getUser()) });
	});
	
	$(function(){
		peopleList.load(function() {
		    socket.emit('login', {id: 'org_' + peopleList.getOrgInfo().orgId});

			videoCtrlMaster = new VideoCtrlMaster({talkButton: false});
			videoCtrl = new VideoCtrl($('#mainVideoObject').get(0), {cameraCfg: peopleList.getOrgInfo().cameraCfg, streamType: 1, local:true});
			videoCtrlMaster.addMe(videoCtrl);
		});
	});
    
    function end() {
        activeDoctorInfoPanel.clear();
        peopleList.onEnd(activeUserId);
        activeUserId = null;
        setDisplayEndButton(false);
        setDoctorDefHeadVisible(false);

        $('#otherSideAction').text('');
        $("#medicalResult").text("");
        $("#videoTitle").hide();
        $("#videoOtherSideName").empty();
        
        videoCtrlMaster.closeHe();
    }

	function setDisplayEndButton(b) {
	    var btnEnd;
	    if ($('#end').length == 0) {
	        btnEnd = $("<button id=end class=titleBtn title='结束会诊'>结束会诊</button>");
	        btnEnd.click(function(){
	            socket.emit("intent", {type: 'end'});
	            end();
	        });
	        btnEnd.insertBefore(".title #msg");
	    } else {
	        btnEnd = $('#end');
	    }
	    
	    b ? btnEnd.show() : btnEnd.hide();
	}
	
	function open2Video(cameraCfg) {
		if(videoCtrl2 == null) {
		    videoCtrl2 = new VideoCtrl($('#otherVideoObject').get(0),
		        {cameraCfg: cameraCfg, streamType: 1, hasActionUI: false});
		}
		setDoctorDefHeadVisible(false);
		if (!videoCtrl2.opened) {
			videoCtrlMaster.addHe(videoCtrl2, function(){
			    videoCtrl2.startVoiceTalk();
			}, function() {
	             videoCtrlMaster.switchMain();
			});
		}
	}

	function setDoctorDefHeadVisible(b) {
		if(b) {
			if($("#doctorDefHead").length == 0)
				$("#videoSmallColl").prepend('<img id="doctorDefHead" class="head2" src="../../images/doctor.png"/>');
		} else {
			$("#doctorDefHead").remove();
		}
	}
}
if (supportRole)
    new PatientSide();

})();
