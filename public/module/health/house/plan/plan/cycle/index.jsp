<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<div class="easyui-layout">
    <div data-options="title: '周期每日配置', region: 'north'" style="height: 30%">
        <table id="dgPlanDay" class="easyui-datagrid" data-options="pagination:false">
            <thead>
                <tr>
                    <th data-options="field:'day', width:60, halign: 'center', align:'center'">第几天</th>
                    <th data-options="field:'stepCount', width:60, halign: 'center', align:'center'">总步数</th>
                </tr>
            </thead>
        </table>
    </div>
    <div data-options="title: '单日配置', region: 'south'" style="height: 70%">
        <%@ include file="step.jsp" %>
    </div>
    </div>