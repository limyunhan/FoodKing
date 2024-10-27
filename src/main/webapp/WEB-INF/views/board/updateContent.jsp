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
	Logger updateContent_logger = LogManager.getLogger("/board/updateContent.jsp");
	HttpUtil.requestLogString(request, updateContent_logger);
	
	String updateContent_Catfirst = HttpUtil.get(request, "Catfirst");
	String updateContent_Catsecond = HttpUtil.get(request, "Catsecond");
	String updateContent_firstName = HttpUtil.get(request, "firstName");
	String updateContent_secondName = HttpUtil.get(request, "secondName");
	String updateContent_boardTitle = HttpUtil.get(request, "boardTitle", "");
	String updateContent_boardContent = HttpUtil.get(request, "boardContent", "");
	String updateContent_boardName = HttpUtil.get(request, "boardName");
	
	long updateContent_boardSeq = HttpUtil.get(request, "boardSeq", (long) 0);
	String searchType = HttpUtil.get(request, "searchType", "");
	String searchValue = HttpUtil.get(request, "searchValue", "");
	long updateContent_curPage = HttpUtil.get(request, "curPage", (long) 1);
	
	String writeBoardProc_cookieUserId = CookieUtil.getValue(request, "USER_ID");
	
	updateContent_logger.debug("updateContent_boardSeq : " + updateContent_boardSeq);
	updateContent_logger.debug("Catfirst : " + updateContent_Catfirst);
	updateContent_logger.debug("updateContent_secondName : " + updateContent_secondName);
	
	updateContent_logger.debug("updateContent_firstName : " + updateContent_firstName);
	updateContent_logger.debug("Catsecond : " + updateContent_Catsecond);
	
	updateContent_logger.debug("searchType : " + searchType);
	updateContent_logger.debug("searchValue : " + searchValue);
	
	MiniBoard updateContent_board = null;
	
	boolean bSuccess = false;
	String errorMessage = "";
	
	if (updateContent_boardSeq > 0) 
	{
		MiniBoardDao boardDao = new MiniBoardDao();
		updateContent_board = boardDao.boardSelect(updateContent_boardSeq);
	
		if (updateContent_board != null)
		{
			if (StringUtil.equals(writeBoardProc_cookieUserId, updateContent_board.getUserId())) 
			{
				updateContent_board.setBoardSeq(updateContent_boardSeq);
				updateContent_board.setBoardTitle(updateContent_boardTitle);
				updateContent_board.setBoardContent(updateContent_boardContent);
				updateContent_board.setCatFirst(updateContent_Catfirst);
				updateContent_board.setFirstName(updateContent_firstName);
				updateContent_board.setCatSecond(updateContent_Catsecond);
				updateContent_board.setSecondName(updateContent_secondName);
		
				if (boardDao.boardUpdate(updateContent_board) > 0) 
				{
					bSuccess = true;
				} 
				
				else 
				{
					errorMessage = "오류발생하였습니다.";
				}
			}
			
			else 
			{
				errorMessage = "사용자 정보가 일치하지 않습니다.";
			}
		} 
		
		else 
		{
			errorMessage = "게시물이 존재하지 않습니다.";
		}
	} 
	
	else 
	{
		errorMessage = "게시물 수정 값이 올바르지 않습니다.";
	}
%>

<!DOCTYPE html>
<html>

<title>Insert title here</title>
</head>
<%@ include file="/include/head.jsp"%>
<script>
$(document).ready(function(){
	
	if(<%=bSuccess%>)
	{
      alert("게시물 수정이 완료되었습니다.");
      document.updateForm.action = "/board/viewContent.jsp";
      document.updateForm.submit();

	} 
	
	else 
	{
    	alert("<%=errorMessage%>");
		location.href = "/board/viewContent.jsp";

	}
	});
</script>
<body>
	<form name="updateForm" id="updateForm" method="post" action="/board/viewContent.jsp">
		<input type="hidden" id="boardSeq" name="boardSeq" value="<%=updateContent_boardSeq%>" /> 
		<input type="hidden" id="searchType" name="searchType" value="<%=searchType%>" /> 
		<input type="hidden" id="searchValue" name="searchValue" value="<%=searchValue%>" /> 
		<input type="hidden" id="curPage" name="curPage" value="<%=updateContent_curPage%>" />
		<input type="hidden" id="Catfirst" name="Catfirst" value="<%=updateContent_Catfirst%>" />
		<input type="hidden" id="Catsecond" name="Catsecond" value="<%=updateContent_Catsecond%>" />
	</form>
</body>
</html>


