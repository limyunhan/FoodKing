<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="com.sist.web.model.MiniUser"%>
<%@ page import="com.sist.web.dao.MiniUserDao"%>
<%@ page import="com.sist.web.model.MiniBoard"%>
<%@ page import="com.sist.web.dao.MiniBoardDao"%>

<%
	Logger rightMainContent_logger = LogManager.getLogger("/board/rightMainContent.jsp");
	HttpUtil.requestLogString(request, rightMainContent_logger);
	
	List<MiniBoard> list1 = null;
	MiniBoard search1 = new MiniBoard();
	MiniBoard search2 = new MiniBoard();
	MiniBoard search3 = new MiniBoard();
	MiniBoard search4 = new MiniBoard();
	MiniBoardDao rightMainContent_boardDao = new MiniBoardDao();
	
	MiniUser admin_user = null;
	MiniUserDao admin_UserDao = new MiniUserDao();
	
	String cookieAdminId = CookieUtil.getValue(request, "USER_ID");
	admin_user = admin_UserDao.userSelect("admin");
	
	search1.setCatFirst("5");
	search1.setFirstName("공지사항");
	search1.setCatSecond("18");
	search1.setStartRow(1);
	search1.setEndRow(5);
	
	search2.setCatFirst("2");
	search2.setFirstName("자유게시판");
	search2.setCatSecond("4");
	search2.setStartRow(1);
	search2.setEndRow(5);
	
	search3.setCatFirst("4");
	search3.setFirstName("테마별 맛집");
	search3.setStartRow(1);
	search3.setEndRow(5);
	
	search4.setCatFirst("3");
	search4.setFirstName("지역별 맛집");
	search4.setStartRow(1);
	search4.setEndRow(5);
%>


<div class="content">
	<article class="board">
		<h3>
			<a href="javascript:void(0)" onclick="fn_firstList(<%=search1.getCatFirst()%>,'<%=search1.getFirstName()%>')">공지사항</a>
		</h3>
		<table>
			<tbody>
<%
		list1 = rightMainContent_boardDao.boardList(search1);
		if(list1 != null && list1.size() > 0)
		{
			for(int i = 0; i <list1.size(); i++)
			{
				MiniBoard board = list1.get(i);
%>
				<tr class="rightMain" onclick="<%if(StringUtil.equals(admin_user.getUserId(), cookieAdminId)) { %>fn_view(<%=board.getBoardSeq()%>);<%}%><%else if (board.getBoardPwd() != null && !board.getBoardPwd().isEmpty()) { %>
                            openPasswordModal(<%=board.getBoardSeq()%>, '<%=board.getBoardPwd()%>');
                         <% } else { %>
                            fn_view(<%=board.getBoardSeq()%>);
                         <% } %>">
					
					<td><a href="javascript:void(0)"><%if (board.getBoardPwd() != null && !board.getBoardPwd().isEmpty()) { %>🔑비밀글 입니다.<%} else {%><%=board.getBoardTitle()%><%}%></a></td>
					
				</tr>

<%
			}
		}
%>
			</tbody>
		</table>
	</article>



	<article class="board">
		<h3>
			<a href="javascript:void(0)" onclick="fn_firstList(<%=search2.getCatFirst()%>,'<%=search2.getFirstName()%>')">자유게시판</a>
		</h3>
		<table>
			<tbody>
<%
		list1 = rightMainContent_boardDao.boardList(search2);
		if(list1 != null && list1.size() > 0)
		{
			for(int i = 0; i <list1.size(); i++)
			{
				MiniBoard board = list1.get(i);
%>
				<tr class="rightMain" onclick="<%if(StringUtil.equals(admin_user.getUserId(), cookieAdminId)) { %>fn_view(<%=board.getBoardSeq()%>);<%}%><%else if (board.getBoardPwd() != null && !board.getBoardPwd().isEmpty()) { %>
                            openPasswordModal(<%=board.getBoardSeq()%>, '<%=board.getBoardPwd()%>');
                         <% } else { %>
                            fn_view(<%=board.getBoardSeq()%>);
                         <% } %>">
					
					<td><a href="javascript:void(0)"><%if (board.getBoardPwd() != null && !board.getBoardPwd().isEmpty()) { %>🔑비밀글 입니다.<%} else {%><%=board.getBoardTitle()%><%}%></a></td>
					
				</tr>

<%
			}
		}
%>
			</tbody>
		</table>
	</article>

	<article class="board">
		<h3>
			<a href="javascript:void(0)" onclick="fn_firstList(<%=search4.getCatFirst()%>,'<%=search4.getFirstName()%>')">지역별 맛집</a>
		</h3>
		<table>
			<tbody>
<%
		list1 = rightMainContent_boardDao.boardList(search4);
		if(list1 != null && list1.size() > 0)
		{
			for(int i = 0; i <list1.size(); i++)
			{
				MiniBoard board = list1.get(i);
%>
				<tr class="rightMain" onclick="<%if(StringUtil.equals(admin_user.getUserId(), cookieAdminId)) { %>fn_view(<%=board.getBoardSeq()%>);<%}%><%else if (board.getBoardPwd() != null && !board.getBoardPwd().isEmpty()) { %>
                            openPasswordModal(<%=board.getBoardSeq()%>, '<%=board.getBoardPwd()%>');
                         <% } else { %>
                            fn_view(<%=board.getBoardSeq()%>);
                         <% } %>">
					
					<td><a href="javascript:void(0)"><%if (board.getBoardPwd() != null && !board.getBoardPwd().isEmpty()) { %>🔑비밀글 입니다.<%} else {%><%=board.getBoardTitle()%><%}%></a></td>
					
				</tr>

<%
			}
		}
%>
			</tbody>
		</table>
	</article>

	<article class="board">
		<h3>
			<a href="javascript:void(0)" onclick="fn_firstList(<%=search3.getCatFirst()%>,'<%=search3.getFirstName()%>')">테마별 맛집</a>
		</h3>
		<table>
			<tbody>
<%
		list1 = rightMainContent_boardDao.boardList(search3);
		if(list1 != null && list1.size() > 0)
		{
			for(int i = 0; i <list1.size(); i++)
			{
				MiniBoard board = list1.get(i);
%>
				<tr class="rightMain" onclick="<%if(StringUtil.equals(admin_user.getUserId(), cookieAdminId)) { %>fn_view(<%=board.getBoardSeq()%>);<%}%><%else if (board.getBoardPwd() != null && !board.getBoardPwd().isEmpty()) { %>
                            openPasswordModal(<%=board.getBoardSeq()%>, '<%=board.getBoardPwd()%>');
                         <% } else { %>
                            fn_view(<%=board.getBoardSeq()%>);
                         <% } %>">
					
					<td><a href="javascript:void(0)"><%if (board.getBoardPwd() != null && !board.getBoardPwd().isEmpty()) { %>🔑비밀글 입니다.<%} else {%><%=board.getBoardTitle()%><%}%></a></td>
					
				</tr>

<%
			}
		}
%>
			</tbody>
		</table>
	</article>
</div>
<div id="passwordModal" style="display:none;">
				    <div class="modal-content">
				        <h3>비밀번호 입력</h3>
				        <input type="password" id="inputPassword" placeholder="비밀번호를 입력하세요" />
				        <button id="checkPasswordButton">확인</button>
				        <button id="closeModalButton">취소</button>
				    </div>
				</div>
<form name="listForm" id="listForm" method="post">
		<input type="hidden" name="boardSeq" value="">	
</form>

<form name="rightForm" id="rightForm" method="POST">
	<input type="hidden" name="Catfirst" id="Catfirst" value="">
	<input type="hidden" name="Catsecond" id="Catsecond" value="">
	<input type="hidden" name="firstName" id="firstName" value="">
	<input type="hidden" name="secondName" id="secondName" value="">
</form>

<script>
$(document).ready(function(){
	$('#checkPasswordButton').on('click', function() {
	    var inputPwd = $('#inputPassword').val();
	    console.log("비밀번호 : " + inputPwd);
	    var boardPwd = $('#passwordModal').data('boardPwd');
	    var boardSeq = $('#passwordModal').data('boardSeq');

	    if (inputPwd === boardPwd) {
	        fn_view(boardSeq);
	    } else {
	        alert('비밀번호가 틀렸습니다.');
	    }
	    closePasswordModal();
	});

	$('#closeModalButton').on('click', function() {
	    closePasswordModal();
	});
});

function openPasswordModal(boardSeq, boardPwd) {
    $('#passwordModal').data('boardSeq', boardSeq); // boardSeq를 모달에 저장
    $('#passwordModal').data('boardPwd', boardPwd); // boardPwd를 모달에 저장
    $('#passwordModal').show();
}

function closePasswordModal() {
    $('#passwordModal').hide();
    $('#inputPassword').val(''); // 입력된 비밀번호 초기화
}

function fn_view(boardSeq)
{
	document.listForm.boardSeq.value = boardSeq;
	document.listForm.action = "/board/viewContent.jsp";
	document.listForm.submit();
	
}

function fn_firstList(Catfirst, firstName) {
	document.rightForm.Catfirst.value = Catfirst;
	document.rightForm.firstName.value = firstName;
	document.rightForm.action = "/board/list.jsp";
	document.rightForm.submit();
}
</script>