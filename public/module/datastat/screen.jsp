<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>${SYSTEM_TITLE}</title>
	<style>
	html, body {
       margin:0px;
       padding:0px;
       width:100%;
       height:100%;
       overflow-x: hidden;
       overflow-y: visible;
		background: #0f2a42;
	}
	iframe {
	   overflow:auto;
	   width:100%;
	   height:100%;
	   margin:0px;
	   padding:0px;
	   border-width:0px;
	   display: block;
	}
	
	#tip {
       position: absolute;
       top: 46px;
	   width: 260px;
	   height: 50px;
	   line-height: 50px;
	   color: white;
	   background: rgba(30, 30, 30, 0.4);
	   border-radius: 2px;
	   text-align: center;
	   font-size: 1em;
	   transition: all .4s;
	   opacity: 0;
	}
	</style>
</head>

<body>
	<iframe src=""></iframe>
	<div id="tip">按 F11  即可进入全屏模式</div>
	
	<script>
	    window.onload = init;
		function init() {
            initTip();

			var screenMap = {
			    user: {
			        url: 'https://datav.aliyun.com/share/8f71292c077eb14c8098598b4eaa2268',
			        title: '用户数据统计'
			    },
			    zxjk: {
			        url: 'https://datav.aliyun.com/share/46509f864800dbd955ab09c609aace01',
			        title: '指挥中心监控'
			    },
                fu_wu_shang: {
                    url: 'https://datav.aliyun.com/share/89e31a379f55cb6890981b064870affd',
                    title: '武汉市智慧养老服务商大数据'
                },
                fu_wu_zhan: {
                    url: 'https://datav.aliyun.com/share/b9d46583a462c91d30a0bb5931299ea2',
                    title: '武汉市智慧养老服务站点大数据'
                },
                fu_wu_ren: {
                    url: 'https://datav.aliyun.com/share/db1cd864a026f9f901059243c708338f',
                    title: '武汉市智慧养老服务人员大数据'
                },
                workorder: {
                    id: 185481,
                    title: '服务工单类型分布'
                },
                boss: {
                    id: 185482,
                    title: '服务商数据'
                }
			};
			var screen = screenMap['${n}'];
			if (!screen) {
			    alert('未找到大屏页(n=${n})');
			    return;
			}
			document.title = screen.title + ' - ${SYSTEM_TITLE}';
			var iframe = window.frames[0];
			if ('${n}' == 'user') {
			    iframe.location = '${urlPath}view/datastat/index.do';
			}
			else if ('${n}' == 'workorder') {
                iframe.location = '${urlPath}view/datastat/servicestat.do';
            }
			else if ('${n}' == 'boss') {
                iframe.location = '${urlPath}view/datastat/bossindex.do';
            }
			else {
			    iframe.location = screen.url;
	        }
		}
		
		function initTip() {
		    var tip = document.getElementById('tip');
		    tip.style.left = (window.innerWidth - 260) / 2 + 'px';
		    tip.style.opacity = 1;
		    setTimeout(function() {
		        tip.style.opacity = 0;
		    }, 5000);
		}
	</script>
</body>
</html>