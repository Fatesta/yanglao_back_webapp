<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
</head>
<body>
    <form id="form" method="post"  enctype="multipart/form-data">
        <input type="hidden" name="courseId" value="${course.courseId}" />
        <input type="hidden" name="classesId" value="${course.classesId}" />
        <table class="form">
            <tr>
                <td>课程内容</td>
                <td>
                    <textarea style="width: 400px;" rows="4" class="easyui-validatebox" name="courseContent" data-options="validType:'length[0,500]'">${course.courseContent}</textarea>
                </td>
            </tr>
            <tr>
                <td>开课日期</td>
                <td>
                    <input class="easyui-datebox" data-options="required:true,editable:false" name="curriculaTime" value="${course.curriculaTime}"/></td>
            </tr>
        </table>
    </form>
</body>
</html>