<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <%@ include file="/module/common.jsp" %>
    </head>
    <body>
	    <form id="profileForm" enctype="multipart/form-data" method="post">
	        <table class="form">
	          <tr>
	              <td>姓名</td>
	              <td><input class="easyui-textbox" required="required" name="userName"
	                      data-options="validType:length[1,50]" style="width: 100px"></td>
	          </tr>
	          <tr>
	              <td>年龄</td>
                  <td><input class="easyui-numberbox" name="age" data-options="min:1,precision:0,required:true"  style="width: 50px;"></td>
	          </tr>
              <tr>
                  <td>性别</td>
                  <td>
                    <input id="m" name="sex" value="0" type="radio" checked><label for="m">男</label>
                    <input id="w" name="sex" value="1" type="radio"><label for="w">女</label>
                  </td>
              </tr>
	          <tr>
	              <td>联系电话</td>
	              <td><input class="easyui-textbox" required="required" name="telephone"
	                      data-options="validType:length[1,120]" style="width: 100px"></td>
	          </tr>
	          <tr>
	              <td>病史</td>
	              <td><textarea class="easyui-validatebox" name="remark" rows="4" cols="30" style="width: 300px"></textarea></td>
	          </tr>
	        </table>
	    </form>
    </body>
</html>
<script>
</script>