<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head></head>
<body>
    <form id="frmscore" method="post">
        <input type="hidden" name="id" value="${id}"/>    
     
        <table class="form" >         
			<tr>
                <td>星级评分</td>
                <td>
                    <div id="score"  data-val="${returnvisit.score}">${returnvisit.score}</div>
                </td>
            </tr>
            <tr>
	            <td>回访结果</td>
				<td><textarea style="width: 360px;height:200px" rows="5"
						class="easyui-validatebox" name="result"
						data-options="validType:'length[0,500]'">${returnvisit.result}</textarea>
				</td>
			</tr>
        </table>
    </form>

    <script src="${libPath}jquery.raty.min.js"></script>
</body>
</html>