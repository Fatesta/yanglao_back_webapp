<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/module/common.jsp" %>
    <style>
        .details {
            margin: 8px 0px 4px 8px;
            border: 1px solid #ccc;
        }
        .details th {
            font-weight: bold;
            background: #eee;
            border: 1px solid #ccc;
        }
        .details td {
            border: 1px solid #ccc;
        }
        .details .textbox {
            border: none;
        }
    </style>
</head>
<body class="easyui-layout">
    <div data-options="region: 'north'" style="height: 58%;">
        <div id="tbr">
            <form id="frmQuery">
                <table class="form">
                    <tr>
                        <td colspan="11">
                            <c:forEach var="func" items="${ROLE_FUNCS}">
                                <a id="${func.code}" class="easyui-linkbutton" data-options="iconCls:'${func.icon}'">${func.funcName}</a>
                            </c:forEach>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <select id="oldmanKey" class="easyui-combobox" style="width:90px">
                                <option value="name">姓名</option>
                                <option value="phone">联系电话</option>
                                <option value="idcard">身份证号码</option>
                            </select>
                        </td>
                        <td>
                            <input id="oldmanValue" name="name" class="easyui-textbox" style="width:212px;"/>
                        </td>
                        <td>年龄>=</td>
                        <td>
                            <input name="gteqAge" class="easyui-combobox"
                                   data-options="
                                       data: [0,60,70,80,90,100].map(function(n){ return {text: n, value: n} }),
                                       editable: true"
                                   style="width:50px;"/>
                        </td>
                        <td>所在社区</td>
                        <td>
                            <input name="communityName" class="easyui-combobox"
                                   data-options="
                                       editable: true,
                                       url: '${urlPath}user/evalOldman/dictByName.do?name=community_name',
                                       loadFilter: function(texts) {
                                           return [{text: '全部', value: ''}].concat(texts.map(function(t){ return {text: t, value: t} }));
                                       }"
                                   style="width:140px;"/>
                        </td>
                        <td>居住街道</td>
                        <td colspan="4">
                            <input name="street" class="easyui-combobox"
                                   data-options="
                                           editable: true,
                                           url: '${urlPath}user/evalOldman/dictByName.do?name=street',
                                           loadFilter: function(texts) {
                                               return [{text: '全部', value: ''}].concat(texts.map(function(t){ return {text: t, value: t} }));
                                           }"
                                   style="width:100px;"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="width:90px">申请对象类型</td>
                        <td colspan="3">
                            <select name="applyTypeJoinPredicate" class="easyui-combobox" style="width: 100px;">
                                <option value="or">至少符合一个</option>
                                <option value="and">同时符合全部</option>
                            </select>
                            <input name="applyTypes" class="easyui-combogrid"
                                   data-options="
                                           editable: false,
                                           multiple: true,
                                           singleSelect: false,
                                           idField:'value',
                                           textField: 'text',
                                           separator: '、',
                                           data: DictMan.items('evalOldman.applyType'),
                                           columns:[[
                                               {field: 'value', width: '100%', checkbox: true},
                                               {field: 'text', width: '100%'}
                                           ]]"
                                   style="width:220px;"/>
                        </td>
                        <!--
                        <td>能力等级</td>
                        <td colspan="3">
                            <input name="disabilityLevel" class="easyui-combobox"
                                   data-options="
                                           data: [],
                                           loadFilter: function(texts) {
                                               return [{text: '全部', value: ''}].concat(DictMan.items('evalOldman.disabilityLevel'));
                                           }"
                                   style="width:100px;"/>
                        </td>
                        -->
                        <td>评估状态</td>
                        <td>
                            <input name="evalState" class="easyui-combobox"
                                   data-options="
                                           data: [],
                                           loadFilter: function(texts) {
                                               return [{text: '全部', value: ''}].concat(DictMan.items('evalOldman.evalState'));
                                           }"
                                   style="width:100px;"/>
                        </td>
                        <td>评估分数>=</td>
                        <td colspan="2">
                            <input name="evalScore" class="easyui-textbox" style="width:50px;"/>
                        </td>
                        <td>
                            <a id="query" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
        <table id="dg" class="easyui-datagrid" toolbar="#tbr"
               data-options="
                   url:'${urlPath }user/evalOldman/findAll.do',
                   onLoadSuccess: onLoadSuccess,
                   onSelect: onSelect,
                   fit:true">
            <thead>
            <tr>
                <th data-options="field:'name',width:60,halign:'center'">姓名</th>
                <th data-options="field:'idcard',width:150,align:'center',halign:'center'">身份证号码</th>
                <th data-options="field:'age',width:50,halign:'center',align:'center'">年龄</th>
                <th data-options="field:'applyTypesText',width:160,halign:'center'">申请对象类型</th>
                <th data-options="field:'phone',width:100,halign:'center'">联系电话</th>
                <th data-options="field:'communityName',width:140,halign:'center'">所在社区</th>
                <th data-options="field:'street',width:100,halign:'center'">居住街道</th>
                <th data-options="field:'address',width:180,halign:'center'">居住住址</th>
                <th data-options="field:'evalScore',width:60,align:'center'">评估分数</th>
		        <th data-options="field:'evalStateText',width:80,align:'center'">评估状态</th>
                <th data-options="field:'allowanceMoney',width:130,align:'center'">拟享受市补贴（元）</th>
            </tr>
            </thead>
        </table>
    </div>
    <div data-options="region: 'south'" style="height: 42%" >
        <div class="easyui-tabs" data-options="fit:true">
            <div data-options="title: '详细信息'">
                <table id="details_part0" class="form details">
                    <tr>
                        <th style="width: 76px">申请对象姓名</th>
                        <td><input name="name" class="easyui-textbox" data-options="readonly:true" style="width: 60px"/></td>
                        <th>身份证号码</th>
                        <td><input name="idcard" class="easyui-textbox" data-options="readonly:true" style="width: 140px"/></td>
                        <th>年龄</th>
                        <td><input name="age" class="easyui-textbox" data-options="readonly:true" style="width: 50px"/></td>
                        <th>申请对象类型</th>
                        <td><input name="applyTypesText" class="easyui-textbox" data-options="readonly:true" style="width: 300px"/></td>
                    </tr>
                </table>
                <table id="details_part2" class="form details">
                    <tr>
                        <th style="width: 76px">代理人姓名</th>
                        <td><input name="agentName" class="easyui-textbox" data-options="readonly:true" style="width: 60px"/></td>
                        <th>与代理人关系</th>
                        <td><input name="agentRelation" class="easyui-textbox" data-options="readonly:true" style="width: 60px"/></td>
                        <th>代理人联系电话</th>
                        <td><input name="agentPhone" class="easyui-textbox" data-options="readonly:true" style="width: 100px"/></td>
                    </tr>
                </table>
                <table id="details_part1" class="form details">
                    <tr>
                        <th style="width: 76px">评估机构</th>
                        <td><input name="institutions" class="easyui-textbox" data-options="readonly:true" style="width: 500px"></td>
                    </tr>
                    <tr>
                        <th>疾病诊断类别</th>
                        <td><input name="diseases" class="easyui-textbox" data-options="readonly:true" style="width: 400px"></td>
                    </tr>
                </table>
                <table id="details_part3" class="form details">
                    <tr>
                        <th style="width: 76px">评估分数</th>
                        <td><input name="evalScore" class="easyui-textbox" data-options="readonly:true" style="width: 100px"></td>

                        <th>拟享受市补贴</th>
                        <td><input name="allowanceMoney" class="easyui-textbox" data-options="readonly:true" style="width: 106px"></td>
                    </tr>
                </table>
                <table id="details_part4" class="form details">
                    <tr>
                        <th style="width: 76px">养老需求</th>
                        <td><input name="needsText" class="easyui-textbox" data-options="readonly:true" style="width: 300px"/></td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script src="${modulePath}user/evalOldman/evalOldman.js?v=1.4"></script>

</body>
</html>
