<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<div class="jksj">
    <div class="jksj-top">
        <div class="jksj-top-text"><p><span id="height" style="position: absolute; left: 44%;"> 身高：</span><span id="h_height" style="position: absolute; left: 55%;"></span>
            <span id="tizhongs" style="position: absolute; left: 70%;">体重：</span><span id="h_weight" style="padding-left: 82%;"></span></p></div>
        <div class="jksj-top-btn">
            <!--<button class="smtz-btn" onclick="chakana()">查看生命体征</button>-->
            <!--<button class="zytz-btn" id="zytz">中医体质辨识</button>-->
            <div class="sdlr" id="data-input"><img src="${modulePath}health/archive/img/jksj-xg.png" width="14" height="14" style="margin-right:5px;">手动录入</div>
        </div>
    </div>
    <div class="jksj-left">
        <div class="jksj-left-bg"></div>
        <div class="jksj-left-line"></div>
        <div class="jksj-left-text">
            <ul class="list-left-ul">
                <li class="list-left-li" style="padding-bottom:10px;">
                    <i class="icon_eye"></i>
                    <p class="icon_text" id="vision">左眼：<span id="h_SL_LeftVision"></span></p>
                    <p class="icon_text" id="vision">右眼：<span id="h_SL_RightVision"></span></p>
                </li>
                <li class="list-left-li">
                    <i class="icon_ears"></i>
                    <p class="icon_text" id="hear">左耳：<span id="h_LeftHear"></span></p>
                    <p class="icon_text" id="hear">右耳：<span id="h_RightHear"></span></p>
                </li>
            </ul>
            <ul class="list-left-ul" style="top:158px;">
                <li class="list-left-li" id="jiroulv">
                    <p style="padding-left:30px;">肌肉率：<span id="h_MuscleRate" style="margin-right:4px;"> </span><span id="h_Musclestae"> </span></p>
                </li>
                <li class="list-left-li" id="tizhilv">
                    <p style="padding-left:15px;">体脂率：<span id="h_BodyFatRate" style="margin-right:4px;"> </span><span id="h_BodyFatRateSta"> </span></p>
                </li>
                <li class="list-left-li" id="neizhiflv">
                    <p>内脏脂肪率：<span id="h_VisceralFatRate" style="margin-right:4px;"> </span><span id="h_VisceralFatRateSta"></span></p>
                </li>
            </ul>
            <ul class="list-left-ul" style="top: 235px; left: 45px;">
                <li class="list-left-li" id="waist">
                    <p>腰围：<span id="h_YaoWei"></span></p>
                </li>
                <li class="list-left-li" id="Hipline">
                    <p>臀围：<span id="h_TunWei"></span></p>
                </li>
            </ul>
            <ul class="list-left-ul" style="top: 378px;">
                <li class="list-left-li" id="waterrate">
                    <p style="padding-left:30px;">水份率：<span id="h_WaterRate" style="margin-right:4px;"> </span><span id="h_WaterRateSta"> </span></p>
                </li>
                <li class="list-left-li" id="bonemass">
                    <p style="padding-left:45px;">骨量：<span id="h_BoneMass" style="margin-right:4px;"> </span><span id="h_BoneMassSta"> </span></p>
                </li>
                <li class="list-left-li" id="bmi">
                    <p style="padding-left:15px;">体质指数：<span id="h_BMI" style="margin-right:4px;"> </span><span id="h_BMISta"></span></p>
                </li>
                <li class="list-left-li" id="bmr">
                    <p>基础代谢率：<span id="h_BMR" style="margin-right:4px;"> </span><span id="h_BMRSta"> </span></p>
                </li>
            </ul>
        </div>
    </div>
    <div class="jksj-right">
        <ul id="healthData" class="list-right-ul">
            <li class="list-right-li" id="temperature">
                <p>
                    <i class="icon_tiwen"></i>
                    <span class="icon-title">体温</span>
                    <span class="jksj-num"></span>
                    <span class="jksj-text"></span>
                    <span class="jksj-date"></span>

                </p>
            </li>
            <li class="list-right-li" id="heartrate">
                <p data-key="3">
                    <i class="icon_xinlv"></i>
                    <span class="icon-title">心率</span>
                    <span class="jksj-num"></span>
                    <span class="jksj-text"></span>
                    <span class="jksj-date"></span>

                </p>
            </li>
            <li class="list-right-li" id="xueya">
                <p data-key="4">
                    <i class="icon_xueya"></i>
                    <span class="icon-title">血压</span>
                    <span class="jksj-num"></span>
                    <span class="jksj-text"></span>
                    <span class="jksj-date"></span>

                </p>
            </li>
            <li class="list-right-li" id="xuetang">
                <p data-key="5">
                    <i class="icon_xuetang"></i>
                    <span class="icon-title">血糖</span>
                    <span class="jksj-num"></span>
                    <span class="jksj-text"></span>
                    <span class="jksj-date"></span>

                </p>
            </li>
            <li class="list-right-li" id="xueyang">
                <p>
                    <i class="icon_xueyang"></i>
                    <span class="icon-title">血氧</span>
                    <span class="jksj-num"></span>
                    <span class="jksj-text"></span>
                    <span class="jksj-date"></span>

                </p>
            </li>
            <li class="list-right-li" id="cholesterol1">
                <p>
                    <i class="icon_danguchun"></i>
                    <span class="icon-title">总胆固醇</span>
                    <span class="jksj-num"></span>
                    <span class="jksj-text"></span>
                    <span class="jksj-date"></span>

                </p>
            </li>
            <li class="list-right-li" id="niaosuans">
                <p>
                    <i class="icon_niaosuan"></i>
                    <span class="icon-title">尿酸</span>
                    <span class="jksj-num"></span>
                    <span class="jksj-text"></span>
                    <span class="jksj-date"></span>

                </p>
            </li>
            <li class="list-right-li" id="jibu">
                <p data-key="0">
                    <i class="icon_jibu"></i>
                    <span class="icon-title">计步</span>
                    <span class="jksj-num"></span>
                    <span class="jksj-text"></span>
                    <span class="jksj-date"></span>

                </p>
            </li>
        </ul>
        <!--
        <div class="jksj-bottom-btn">
            <button class="gmd-btn" id="gumidu" style=" border-radius: 20px;">骨密度</button>
            <button class="smtz-btn" id="feigongn" style=" border-radius: 20px;">肺功能</button>
            <button class="xdt-btn" id="xindaintu" style=" border-radius: 20px;"> 心电图</button>
            <button class="zytz-btn" id="xindaintu" style=" border-radius: 20px;">  B超</button>

        </div>-->
    </div>



    <div style="display:none">
        <div style="font-size:10px;">
	                <span>
	                最近一次血压测量结果(</span>
            <span id="datetime_stolic_latest">无</span>
            <span>)</span>
            <!--    <span>本月共测量血压</span>
                <span id="times_stolic">0</span>
                <span>次，</span>
                <span>正常次数</span>
                <span id="times_stolic_normal">0</span>
                <span>次，</span>
                <span>超标次数</span>
                <span id="times_stolic_abnormal">0</span>
                <span>次。</span>-->
            <a href="#" id="details_stolic" style="color:red" onclick="showdialog('1')">添加</a>
            <span style="font-size:8px;float:right;">
	                <a id="details_stolic" style="color:blue;" onclick="show4(guid,0)">查看详细</a>
	                </span>
        </div>

        <div style="color:#fff;font-size:12px;padding:10px;overflow:hidden;">
            <div style="padding:10px;margin-right:30px;float:left;background-color:#00CACA;">
	                    <span>
	                    高压：</span>
                <span id="Hsystolic"></span>
                <span>mmHg</span>
            </div>
            <div style="padding:10px;margin-right:30px;float:left;background-color:#00CACA;">
	                    <span>
	                    低压：</span>
                <span id="Hdiastolic"></span>
                <span>mmHg</span>
            </div>
            <div style="padding:10px;margin-right:30px;float:left;background-color:#00CACA;">
	                    <span>
	                    心率：</span>
                <span id="Hpluse"></span>
                <span>次/分</span>
            </div>
        </div>

        <div style="clear:left;font-size:10px;">
	                <span>
	                最近一次血糖测量结果(</span>
            <span id="datetime_Hbglucose_latest">无</span>
            <span>)</span>
            <!--<span>本月共测量血糖</span>
            <span id="times_Hbglucose">0</span>
            <span>次，</span>
            <span>正常次数</span>
            <span id="times_Hbglucose_normal">0</span>
            <span>次，</span>
            <span>超标次数</span>
            <span id="times_Hbglucose_abnormal">0</span>
            <span>次。</span>-->
            <a href="#" id="details_stolic" style="color:red" onclick="showdialog('2')">添加</a>
            <span style="font-size:8px;float:right;">
	                <a id="details_Hbglucose" style="color:blue;" onclick="show4(guid,1)">查看详细</a>
	                </span>
        </div>
        <div style="padding:10px;float:left;background-color:#00CACA;color:#fff;margin:10px 0px 10px 10px;font-size:12px;">
	                <span>
	                血糖值：</span>
            <span id="Hbglucose"></span>
            <span>mmol/L</span>
        </div>
        <div style="clear:both;font-size:10px;">
	                <span>
	                最近一次体重测量结果(</span>
            <span id="datetime_Hweight_latest">无</span>
            <span>)</span>
            <a href="#" id="details_stolic" style="color:red" onclick="showdialog('3')">添加</a>
            <span style="font-size:8px;float:right;">
	                <a id="details_Hbglucose" style="color:blue;" onclick="show4(guid,2)">查看详细</a>
	                </span>
        </div>

        <div style="clear:both;padding:10px;overflow:hidden;color:#fff;font-size:12px;">
            <div style="padding:10px;margin-right:30px;float:left;background-color:#00CACA;">
	                    <span>
	                    体重：</span>
                <span id="Hweight"></span>
                <span>Kg</span>
            </div>
            <div style="padding:10px;margin-right:30px;float:left;background-color:#00CACA;">
	                    <span>
	                    BMI值：</span>
                <span id="HBMI"></span>
                <span>mmol/L</span>
            </div>
        </div>

        <div style="clear:left;font-size:10px;">
	                <span>
	                最近一次运动测量结果</span>
            <span id="datetime_Sports_latest"></span>
            <span></span>
            <a href="#" id="details_stolic" style="color:red" onclick="showdialog('4')">添加</a>
            <span style="font-size:8px;float:right;">
	                <a id="details_Sports" style="color:blue;" onclick="show4(guid,3)">查看详细</a>
	                </span>
        </div>
        <div style="clear:both;color:#fff;font-size:12px;padding:10px;overflow:hidden;">
            <div style="padding:10px;margin-right:10px;float:left;background-color:#00CACA;">
	                    <span>
	                    计步值：</span>
                <span id="Hcountstep"></span>
                <span>步</span>
            </div>
            <div style="padding:10px;margin-right:10px;float:left;background-color:#00CACA;">
	                    <span>
	                    运动距离：</span>
                <span id="Hdistance"></span>
                <span>公里</span>
            </div>
            <div style="padding:10px;margin-right:10px;float:left;background-color:#00CACA;">
	                    <span>
	                    运动时长：</span>
                <span id="Hsporttime"></span>
            </div>
            <div style="padding:10px;float:left;background-color:#00CACA;">
	                    <span>
	                    燃烧热量：</span>
                <span id="Hcalories"></span>
                <span>大卡</span>
            </div>
        </div>

        <!--<div style="clear:both;font-size:10px;">
            <span>
            最近一次心电测量结果(</span>
            <span id="datetime_Hweight_latest">无</span>
            <span>)</span>
            <span style="font-size:8px;float:right;">
            <a id="details_Hbglucose" style="color:blue;" onclick="show4(guid,2)">查看详细</a>
            </span>
        </div>

        <div style="clear:both;padding:10px;overflow:hidden;color:#fff;font-size:12px;">
            <div style="padding:10px;margin-right:30px;float:left;background-color:#00CACA;">
                <span>
                体重：</span>
                <span id="Hweight"></span>
                <span>Kg</span>
            </div>

        </div>-->

        <div style="clear:both;font-size:10px;">
	                <span>
	                最近一次血氧测量结果</span>
            <a href="#" id="details_stolic" style="color:red" onclick="showdialog('5')">添加</a>
            <span style="font-size:8px;float:right;">
	                <a id="details_Hbglucose" style="color:blue;" onclick="show5(guid,5)">查看详细</a>
	                </span>
        </div>

        <div style="clear:both;padding:10px;overflow:hidden;color:#fff;font-size:12px;">
            <div style="padding:10px;margin-right:30px;float:left;background-color:#00CACA;">
	                    <span>
	                    血氧：</span>
                <span id="Oxygen"></span>
                <span>SaO2</span>
            </div>

        </div>
        <div style="clear:both;font-size:10px;">
	                <span>
	                最近一次尿酸测量结果</span>
            <a href="#" id="details_stolic" style="color:red" onclick="showdialog('6')">添加</a>
            <span style="font-size:8px;float:right;">
	                <a id="details_Hbglucose" style="color:blue;" onclick="show4(guid,6)">查看详细</a>
	                </span>
        </div>

        <div style="clear:both;padding:10px;overflow:hidden;color:#fff;font-size:12px;">
            <div style="padding:10px;margin-right:30px;float:left;background-color:#00CACA;">
	                    <span>
	                    尿酸：</span>
                <span id="uricacid"></span>
                <span>μmol/L</span>
            </div>

        </div>
        <div style="clear:both;font-size:10px;">
	                <span>
	                最近一次总胆固醇测量结果</span>
            <a href="#" id="details_stolic" style="color:red" onclick="showdialog('7')">添加</a>
            <span style="font-size:8px;float:right;">
	                <a id="details_Hbglucose" style="color:blue;" onclick="show4(guid,7)">查看详细</a>
	                </span>
        </div>

        <div style="clear:both;padding:10px;overflow:hidden;color:#fff;font-size:12px;">
            <div style="padding:10px;margin-right:30px;float:left;background-color:#00CACA;">
	                    <span>
	                    总胆固醇：</span>
                <span id="cholesterol"></span>
                <span>mmol/L</span>
            </div>

        </div>

        <div class="easyui-linkbutton l-btn l-btn-small" data-options="iconCls:'icon-edit'" style="padding:10px;margin:10px auto;" onclick="show3(guid)" id="btneva" group=""><span class="l-btn-left l-btn-icon-left"><span class="l-btn-text">填写健康评估报告</span><span class="l-btn-icon icon-edit">&nbsp;</span></span></div>
    </div>
</div>