<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/module/common.jsp" %>
<script src="${libPath}cloud.js"></script>
<script>
$(function(){
	$('.loginbox').css({'position':'absolute','left':($(window).width()-692)/2});
	$(window).resize(function(){  
    	$('.loginbox').css({'position':'absolute','left':($(window).width()-692)/2});
    });
	
	// 绑定事件
	$(document).keypress(function(e){
		if (e.keyCode == 13) {
			doLogin();
		}
	});
	
	// 老版本IE显示升级提示信息
	if ($.browser.isIE && $.browser.isOldIE) {
		showAlert("系统提示", "您的浏览器版本过低，可能会导致部分功能不正常，要想得到更好的体验效果，请升级浏览器！", "warnning");
	}
});
</script>
<style type="text/css">
	.findPwdbox {
		background: url(../images/findPwd_bg.png) no-repeat;
		width: 692px;
		height: 380px;
		padding: 0px;
		margin-top:30px;
		margin-left: auto;
		margin-right: auto;
	}
	.username {
		position: relative;
		top: 90px;
		left: 350px;
		width: 250px;
		height: 35px;
		font-size: 14px;
	}
	.captcha {
		position: relative;
		top: 105px;
		left: 350px;
		width: 130px;
		height: 35px;
		font-size: 14px;
	}
	.get_captcha_btn {
		position: relative;
		top: 105px;
		left: 360px;
		width: 110px;
		height: 35px;
		font-size: 14px;
		background-color: #ECECEC;
	}
	.password {
		position: relative;
		top: 145px;
		left: 350px;
		width: 250px;
		height: 35px;
		font-size: 14px;
	}
	.repassword {
		position: relative;
		top: 160px;
		left: 350px;
		width: 250px;
		height: 35px;
		font-size: 14px;
	}
	.alterPwdBtn {
		position: relative;
		top: 175px;
		left: 350px;
		width: 250px;
		height: 35px;
		font-size: 14px;
		color: white;
		background-color: #429ACA;
	}
</style>
</head>
<body style="background-color: #1c77ac; background-image: url(../images/light.png); background-repeat: no-repeat; background-position: center top; overflow: hidden;">

	<div class="loginbody">
		<form id="findPwdForm" method="post">
			<div class="systemlogo"></div>
			<div class="findPwdbox">
				<ul>
					<li><input id="username" name="username" type="text" class="username" onclick="JavaScript:this.value=''" placeholder="请输入用户名" /></li>
					<li><input id="captcha" name="captcha" type="text" class="captcha" onclick="JavaScript:this.value=''" placeholder="请输入验证码" /><input id="captchaBtn" type="button" class="get_captcha_btn" value="获取验证码" onclick="getCaptcha()" /></li>
					<li><input id="password" name="password" type="password" class="password" onclick="JavaScript:this.value=''" placeholder="请输入密码" /></li>
					<li><input id="repassword" name="repassword" type="password" class="repassword" onclick="JavaScript:this.value=''" placeholder="请重新输入密码" /></li>
					<li>
						<input type="button" class="alterPwdBtn" value="修改密码" onclick="alterPwd()" />
					</li>
				</ul>
			</div>
		</form>
	</div>

	<script>
		var time = 0;	
	
		function alterPwd() {
			var username = $("#username").val();
			var captcha = $("#captcha").val();
			var password = $("#password").val();
			var repassword = $("#repassword").val();
			if (!captcha || captcha == "") {
				showAlert("操作提示", "验证码不能为空！");
				return false;
			}
			if (!password || password == "") {
				showAlert("操作提示", "密码不能为空！");
				return false;
			}
			if (password.length < 6) {
				showAlert("操作提示", "密码至少包含6个以上的字符！");
				return false;
			}
			if (password != repassword) {
				showAlert("操作提示", "两次输入密码不一致！");
				return false;
			}
			post("${urlPath}admin/findPassword.do", {username:username,captcha:captcha,password:password}, function(data){
				if (data.success) {
					// 跳转到登录界面
					showAlert("操作提示", "修改密码成功系统将自动跳转至登录界面！", "info");
					setTimeout('gotoLogin()', 3000);
					return;
				} else {
					showAlert(data.title, data.message);
				}
			}, "json");
		}
		
		function gotoLogin() {
			window.location.href = "${urlPath}login.do";
		}
		
		function getCaptcha() {
			$("#captchaBtn").attr("disabled", "disabled");
			var username = $("#username").val();
			if (!username || username == "") {
				$("#captchaBtn").removeAttr("disabled");
				showAlert("操作提示", "用户名不能为空！");
				return false;
			}
			post("${urlPath}admin/getCaptcha.do", {username:username}, function(data){
				if (data.success) {
					time = 120;
					setTimeout('setTime()', 1000);
				} else {
					$("#captchaBtn").removeAttr("disabled");
					showAlert(data.title, data.message);	
				}
			}, "json");
			
		}
		
		function setTime() {
			if (time > 1) {
				time = time - 1;
				$("#captchaBtn").val(time + "s后重新获取");				
				setTimeout('setTime()', 1000);
			} else {
				$("#captchaBtn").removeAttr("disabled");
				$("#captchaBtn").val("获取验证码");
			}
		}
	</script>
</body>
</html>
