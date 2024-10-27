<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="com.sist.web.model.MiniBoard"%>
<%@ page import="com.sist.web.dao.MiniBoardDao"%>

<%
	Logger viewContent_logger = LogManager.getFormatterLogger("/board/viewContent.jsp");
	HttpUtil.requestLogString(request, viewContent_logger);

	long boardSeq = HttpUtil.get(request, "boardSeq", (long)0);
	long curPage = HttpUtil.get(request, "curPage", (long)1);
	String searchType = HttpUtil.get(request, "searchType", "");
	String searchValue = HttpUtil.get(request, "searchValue", "");
	
	String Catfirst = HttpUtil.get(request, "Catfirst");
	String firstName = HttpUtil.get(request, "firstName");
	
	String Catsecond = HttpUtil.get(request, "Catsecond");
	String secondName = HttpUtil.get(request, "secondName");
	
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	
	viewContent_logger.debug("boardSeq : " + boardSeq);
	viewContent_logger.debug("Catfirst2 : " + Catfirst);
	viewContent_logger.debug("firstName2 : " + firstName);
	viewContent_logger.debug("Catsecond2 : " + Catsecond);
	viewContent_logger.debug("secondName2 : " + secondName);
	
	MiniBoardDao viewContent_boardDao = new MiniBoardDao();
	MiniBoard viewContent_board = null;
	
	viewContent_board = viewContent_boardDao.boardSelect(boardSeq);
	
	if(viewContent_board != null)
	{
		viewContent_boardDao.boardReadCount(boardSeq);
	}
	
%>

<!DOCTYPE html>
<html lang="ko">

<head>
<title>MiniProject</title>
<%@include file="/include/head.jsp" %>
</head>
<script>
$(document).ready(function(){
	
	//<br> => enter
	var text = $('textarea').val();
	text = text.split('<br>').join("\r\n");
<% 
	if(viewContent_board == null)
	{
%>
		alert("조회 하신 게시물이 존재하지 않습니다.");
		document.viewForm.action = "/board/list.jsp";
		document.viewForm.submit();
<%
	}

	else
	{
%>
		$("#list-btn").on("click", function(){
			document.viewForm.action = "/board/list.jsp";
			document.viewForm.submit();
		});		
<%
		if(StringUtil.equals(cookieUserId, viewContent_board.getUserId()))
		{
%>		
			$("#edit-btn").on("click", function(){
				document.viewForm.action = "/board/writeBoard.jsp";
				document.viewForm.submit();
			});
			
			$("#delete-btn").on("click", function(){
				if(confirm("게시물을 삭제 하시겠습니까?") == true)
				{
					document.viewForm.action = "/board/deleteContent.jsp";
					document.viewForm.submit();
				}
			});
<%
		}
	}
%>
});
</script>
<body id="index-body">
<% 
	if(viewContent_board != null)
	{ 
%>
	<div class="Board-Main-Page">
		<div class="Board-Main">
			<%@include file="/include/navigation.jsp"%>

			<div class="main-contanier">
				<%@include file="/leftMainContent.jsp"%>
				<div class="post-container">
					<div class="post-header">

						<div class="post-header-info">
							<h1><%=viewContent_board.getBoardTitle()%></h1>
							<p>
								<b>작성자:</b> <%=viewContent_board.getBoardName()%>
							</p>
							<p>
								<b>등록일:</b> <%=viewContent_board.getBoardDate()%>
							</p>
							<p>
								<b>조회수:</b> <%=viewContent_board.getBoardCount() %>
							</p>
						</div>
						<div class="post-header-buttons">
							<button class="list-btn" id="list-btn">리스트</button>
<%
		if(StringUtil.equals(cookieUserId, viewContent_board.getUserId()))
		{
%>
							<button class="edit-btn" id="edit-btn">수정</button>
							<button class="delete-btn" id="delete-btn">삭제</button>
<%
		}
%>   
						</div>
					</div>

					<div class="post-content">
						<textarea readonly class="viewTextarea"><%=viewContent_board.getBoardContent()%></textarea>
					</div>
					
					<div class="comments-section">
						<h2>댓글</h2>
						<form name="commentForm" id="commentForm" method="post">
							<textarea name="boardComment" rows="4" cols="50" required></textarea>
							<button type="submit">댓글 달기</button>
						</form>
					</div>
				</div>
			</div>
			<%@ include file="/include/footer.jsp"%>
		</div>
	</div>
<%
	}
%>

<form name="viewForm" id="viewForm" method="post">
	<input type="hidden" name="boardSeq" value="<%=boardSeq%>">
	<input type="hidden" name="searchType" value="<%=searchType%>">
	<input type="hidden" name="searchValue" value="<%=searchValue%>">
	<input type="hidden" name="curPage" value="<%=curPage%>">
	<input type="hidden" name="Catfirst" value="<%=viewContent_board.getCatFirst()%>">
	<input type="hidden" name="firstName" value="<%=viewContent_board.getFirstName()%>">
	<input type="hidden" name="Catsecond" value="<%=viewContent_board.getCatSecond()%>">
	<input type="hidden" name="secondName" value="<%=viewContent_board.getSecondName()%>">
</form>
</body>

</html>