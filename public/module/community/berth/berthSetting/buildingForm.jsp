<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    <form id="frmCommunityBuilding" method="post">
        <input type="hidden" name="id" value="${building.id}">
        <input type="hidden" name="communityId" value="${building.communityId}" />
        <table class="form">
            <tr>
                <td>楼房编号</td>
                <td>
                    <input class="easyui-textbox" name="buildingNo" value="${building.buildingNo}" style="width: 100px;"
                        data-options="required:true,validType:'length[1,20]'">
                </td>
            </tr>
            <tr>
                <td>楼房名称</td>
                <td>
                    <input class="easyui-textbox" name="name" value="${building.name}" style="width: 250px;"
                        data-options="required:true,validType:'length[1,100]'">
                </td>
            </tr>
            <tr>
                <td>楼层数</td>
                <td>
                    <input class="easyui-numberbox" name="floorsNum" value="${building.floorsNum}" style="width: 50px;"
                        data-options="required:true,precision:0">
                </td>
            </tr>
        </table>
    </form>
