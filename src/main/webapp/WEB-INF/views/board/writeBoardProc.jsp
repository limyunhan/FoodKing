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
	Logger writeBoardProc_logger = LogManager.getLogger("/board/writeBoardProc.jsp");
	HttpUtil.requestLogString(request, writeBoardProc_logger);

	String Catfirst = HttpUtil.get(request, "Catfirst", "");
	String Catsecond = HttpUtil.get(request, "Catsecond", "");
	String firstName = HttpUtil.get(request, "firstName", "");
	String secondName = HttpUtil.get(request, "secondName", "");
	String boardTitle = HttpUtil.get(request, "boardTitle", "");
	String boardContent = HttpUtil.get(request, "boardContent", "");
	String boardName = HttpUtil.get(request, "boardName");
	String boardPwd = HttpUtil.get(request, "secretPassword");
	
	String writeBoardProc_cookieUserId = CookieUtil.getValue(request, "USER_ID");
	
	boolean flag = false;
	String errorMessage = "";
	
	writeBoardProc_logger.debug("Catfirst : " + Catfirst);
	writeBoardProc_logger.debug("Catsecond : " + Catsecond);
	writeBoardProc_logger.debug("boardTitle : " + boardTitle);
	writeBoardProc_logger.debug("boardContent : " + boardContent);
	writeBoardProc_logger.debug("boardPwd : " + boardPwd);
	
	if(!StringUtil.isEmpty(boardTitle) && !StringUtil.isEmpty(boardContent))
	{
		
		MiniBoard board = new MiniBoard();
		MiniBoardDao boardDao = new MiniBoardDao();
		
		board.setUserId(writeBoardProc_cookieUserId);
		board.setBoardTitle(boardTitle);
		board.setBoardContent(boardContent);
		board.setCatFirst(Catfirst);
		board.setCatSecond(Catsecond);
		board.setBoardName(boardName);
		board.setBoardPwd(boardPwd);
		
		if(boardDao.insertBoard(board) > 0)
		{
			flag = true;
		}
		
		else
		{
			errorMessage = "게시물 등록 중 오류가 발생하였습니다.";
		}
	}
	
	else
	{
		errorMessage = "게시물 등록시 필요한 값이 올바르지 않습니다.";
	}
%>

<!DOCTYPE html>
<html>
<head>
<%@include file="/include/head.jsp" %>
</head>
<script>
$(document).ready(function(){
	if(<%=flag%>)	
	{
		document.listForm.action = "/board/list.jsp";
		document.listForm.submit();
		alert("게시물이 등록되었습니다.");
	}
	
	else
	{
		alert("<%=errorMessage%>");
		location.href = "/board/writeBoard.jsp";
	}
});
</script>
<body>
<form name="listForm" id="listForm" method="post">
<input type="hidden" name="Catfirst" id="Catfirst" value="<%=Catfirst%>">
<input type="hidden" name="Catsecond" id="Catsecond" value="<%=Catsecond%>">
<input type="hidden" name="firstName" id="firstName" value="<%=firstName%>">
<input type="hidden" name="secondName" id="secondName" value="<%=secondName%>">
</form>
</body>
</html>