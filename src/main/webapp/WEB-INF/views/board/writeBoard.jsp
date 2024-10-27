<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
	Logger writeBoard_logger = LogManager.getLogger("/board/writeBoard.jsp");
	HttpUtil.requestLogString(request, writeBoard_logger);
	
	String cafeInfo = HttpUtil.get(request, "cafeInfo", "");
	writeBoard_logger.debug("cafeInfo" + cafeInfo);
	
	String Catfirst = HttpUtil.get(request, "Catfirst", "");
	String firstName = HttpUtil.get(request, "firstName", "");
	String Catsecond = HttpUtil.get(request, "Catsecond", "");
	String secondName = HttpUtil.get(request, "secondName", "");
	
	String searchType = HttpUtil.get(request, "searchType", "");
	String searchValue = HttpUtil.get(request, "searchValue", "");
	long boardSeq = HttpUtil.get(request, "boardSeq", (long)0);
	long curPage = HttpUtil.get(request, "curPage", (long)1);
	
	writeBoard_logger.debug("Catsecond : " + Catsecond);
	
	String writeBoard_cookieUserId = CookieUtil.getValue(request, "USER_ID");
	
	MiniUserDao writeBoard_userDao = new MiniUserDao();
	
	MiniBoardDao writeBoard_boardDao = new MiniBoardDao();
	MiniBoard writeBoard_board = null;
	
	if(boardSeq > 0)
	{
		if(!StringUtil.isEmpty(writeBoard_cookieUserId))
		{
			writeBoard_board = writeBoard_boardDao.boardSelect(boardSeq);
			writeBoard_logger.debug("test1 writeBoard_board");
		}
	}
	
	MiniUser writeBoard_user = null;
	
	writeBoard_user = writeBoard_userDao.userSelect(writeBoard_cookieUserId);
	//예외처리
%>

<!DOCTYPE html>
<html lang="ko">

<head>
<%@include file="/include/head.jsp"%>
<title>MiniProject</title>
</head>
<script>
	$(document).ready(function() {

		$("#boardTitle").focus();
		
		var text = $('textarea').val();
		text = text.replace(/(?:\r\n|\r|\n)/g, '<br>');
		
		$('#secretCheck').on('change', function() {
		    var passwordInput = $('#secretPassword');
		    if ($(this).is(':checked')) 
		    {
		    	$('#lockLabel').text('🔓'); 
		        passwordInput.prop('disabled', false);
		    } 
		    
		    else 
		    {
		    	$('#lockLabel').text('🔒');
		        passwordInput.prop('disabled', true);
		        passwordInput.val('');
		    }
		});

		
		$("select").on("change", function() {
            var selectedOption = $(this).val();

            if (selectedOption) 
            {
                var values = selectedOption.split(",");
                var Catfirst = values[0];
                var Catsecond = values[1];
                
                if(Catsecond == " ")
                {
                	document.writeForm.firstName.value = "공지사항";
                }
                
                document.writeForm.Catfirst.value = Catfirst;
                document.writeForm.Catsecond.value = Catsecond;
            }
        });

		$("#write-btn").on("click", function() {
			if ($.trim($("#boardTitle").val()).length <= 0) 
			{
				alert("제목을 입력하세요.");
				$("#boardTitle").val("");
				$("#boardTitle").focus();
				return;
			}

			if ($.trim($("#boardContent").val()).length <= 0) 
			{
				alert("내용을 입력하세요.");
				$("#boardContent").val("");
				$("#boardContent").focus();
				return;
			}
			
			if($("#write-category").val() == "")
			{
				alert("카테고리를 선택해주세요.");
				$("#write-category").focus();
				return;
			}
			
			if ($('#secretCheck').is(':checked')) {
	            var passwordValue = $('#secretPassword').val();
	            if ($.trim(passwordValue).length <= 0) {
	                alert("비밀번호를 입력하세요.");
	                $('#secretPassword').focus();
	                return;
	            }
			}
			<%
        		if(writeBoard_board != null)
        		{
        			writeBoard_logger.debug("test2 writeBoard_board");
        	%>
        	document.writeForm.action = "/board/updateContent.jsp";
			document.writeForm.submit();
        	<%
        		}
        	
        		else
        		{
			%>
			document.writeForm.action = "/board/writeBoardProc.jsp";
			document.writeForm.submit();
			<%
        		}
			%>

		});
		
		$("#listbtn").on("click", function() {
            <%	
            if(StringUtil.isEmpty(cafeInfo))
            {
            	if(writeBoard_board != null)
            	{
            %>
					document.writeForm.Catfirst.value = <%=writeBoard_board.getCatFirst()%>;
					document.writeForm.Catsecond.value = <%=writeBoard_board.getCatSecond()%>;
			<%
            	}
            	
            	else
            	{
			%>
					document.writeForm.Catfirst.value = Catfirst;
					document.writeForm.Catsecond.value = Catsecond;
			<%
           		}
	        %>
		        document.writeForm.action = "/board/list.jsp";
				document.writeForm.submit();
	        <%
           	}
            
            else
            {
            %>
            	location.href = "/index.jsp";
            <%
            }
			%>
			
		});
	});
</script>
<body id="index-body">
	<div class="Board-Main-Page">
		<div class="Board-Main">
			<%@include file="/include/navigation.jsp"%>

			<div class="main-contanier">
				<%@include file="/leftMainContent.jsp"%>
				<div class="write-container">
				
					<form name="writeForm" id="writeForm" method="post">
						<div class="write-header">
							<h1>글쓰기</h1>
							<!-- 등록 버튼 -->
							<div class="write-section">
								<button type="button" class="listbtn" id="listbtn">리스트</button>
								<button type="button" class="write-btn" id="write-btn">등록</button>
							</div>
						</div>
						<!-- 카테고리 및 말머리 선택 -->
						<div class="write-category">
							<select id="write-category">
								<option value="">게시판을 선택해 주세요.</option>
								<%	
								if(StringUtil.equals(cafeInfo, "cafe") || StringUtil.equals(Catsecond, "3"))
								{
									if(StringUtil.equals(writeBoard_user.getUserId(), "admin"))
									{
								%>
								<option value="1,1" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "1 ,1 ")){%>selected<%}%>>[추천] 관리자가 추천하는 맛집</option>
								<%
									}
								%>
								<option value="1,2" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "1 ,2 ")){%>selected<%}%>>[추천] 블로거 추천</option>
								<option value="2,4" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "2 ,4 ")){%>selected<%}%>>[커뮤니티] 자유게시판</option>
								<option value="3,6" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "3 ,6 ")){%>selected<%}%>>[지역별 맛집] 경기도</option>
								<option value="3,7" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "3 ,7 ")){%>selected<%}%>>[지역별 맛집] 서울</option>
								<option value="3,8" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "3 ,8 ")){%>selected<%}%>>[지역별 맛집] 강원도</option>
								<option value="3,9" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "3 ,9 ")){%>selected<%}%>>[지역별 맛집] 충정도</option>
								<option value="3,10" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "3 ,10")){%>selected<%}%>>[지역별 맛집] 전라도</option>
								<option value="3,11" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "3 ,11")){%>selected<%}%>>[지역별 맛집] 경상도</option>
								<option value="3,12" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "3 ,12")){%>selected<%}%>>[지역별 맛집] 제주도</option>
								<option value="4,13" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "4 ,13")){%>selected<%}%>>[테마별 맛집] 한식</option>
								<option value="4,14" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "4 ,14")){%>selected<%}%>>[테마별 맛집] 중식</option>
								<option value="4,15" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "4 ,15")){%>selected<%}%>>[테마별 맛집] 일식</option>
								<option value="4,16" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "4 ,16")){%>selected<%}%>>[테마별 맛집] 양식</option>
								<option value="4,17" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "4 ,17")){%>selected<%}%>>[테마별 맛집] 간식</option>
								<%
									if(StringUtil.equals(writeBoard_user.getUserId(), "admin"))
									{
								%>
								<option value="5,18" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "5 ,18")){%>selected<%}%>>[공지사항]</option>
								<%
									}
								}
								else if(StringUtil.equals(cafeInfo, ""))
								{
									if(StringUtil.equals(Catfirst, "1"))
									{
										if(StringUtil.equals(writeBoard_user.getUserId(), "admin"))
										{
								%>
								<option value="1,1" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "1 ,1 ")){%>selected<%}%>>[추천] 관리자가 추천하는 맛집</option>
								<%
										}
								%>
								<option value="1,2" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "1 ,2 ")){%>selected<%}%>>[추천] 블로거 추천</option>
								<%
									}
								
									else if(StringUtil.equals(Catfirst, "2"))
									{
								%>
								<option value="2,4" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "2 ,4 ")){%>selected<%}%>>[커뮤니티] 자유게시판</option>
								<%
									}
									
									else if(StringUtil.equals(Catfirst, "3"))
									{
								%>
								<option value="3,6" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "3 ,6 ")){%>selected<%}%>>[지역별 맛집] 경기도</option>
								<option value="3,7" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "3 ,7 ")){%>selected<%}%>>[지역별 맛집] 서울</option>
								<option value="3,8" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "3 ,8 ")){%>selected<%}%>>[지역별 맛집] 강원도</option>
								<option value="3,9" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "3 ,9 ")){%>selected<%}%>>[지역별 맛집] 충정도</option>
								<option value="3,10" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "3 ,10")){%>selected<%}%>>[지역별 맛집] 전라도</option>
								<option value="3,11" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "3 ,11")){%>selected<%}%>>[지역별 맛집] 경상도</option>
								<option value="3,12" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "3 ,12")){%>selected<%}%>>[지역별 맛집] 제주도</option>
								<%
									}
								
									else if(StringUtil.equals(Catfirst, "4"))
									{
								%>
								<option value="4,13" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "4 ,13")){%>selected<%}%>>[테마별 맛집] 한식</option>
								<option value="4,14" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "4 ,14")){%>selected<%}%>>[테마별 맛집] 중식</option>
								<option value="4,15" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "4 ,15")){%>selected<%}%>>[테마별 맛집] 일식</option>
								<option value="4,16" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "4 ,16")){%>selected<%}%>>[테마별 맛집] 양식</option>
								<option value="4,17" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "4 ,17")){%>selected<%}%>>[테마별 맛집] 간식</option>
								<%
									}
									else if(StringUtil.equals(Catfirst, "5") && StringUtil.equals(writeBoard_user.getUserId(), "admin"))
									{
								%>
								<option value="5,18" <%if(boardSeq > 0 && StringUtil.equals(writeBoard_board.getCatFirst() + "," + writeBoard_board.getCatSecond(), "5 ,18")){%>selected<%}%>>[공지사항]</option>
								<%
									}
								}
															%>
								
								
							</select>
							<div>
							
							    </div>
							<div class="write-pwd">
							    <!-- <label for="secretCheck">비밀글</label> -->
							    <label for="lockLabel" id="lockLabel">🔒</label>
							    <input type="checkbox" id="secretCheck" name="secretCheck" />
							    <input type="password" id="secretPassword" name="secretPassword" placeholder="비밀번호를 입력하세요." disabled />
							</div>
						</div>

						<!-- 제목 입력란 -->
						<div class="write-title">
							<input type="text" id="boardTitle" name="boardTitle"
								placeholder="제목을 입력해 주세요." <%if(boardSeq > 0){%>value="<%=writeBoard_board.getBoardTitle()%>"<%}%>/>
						</div>

						<!-- 본문 입력란 -->
						<div class="write-content">
							<textarea id="boardContent" name="boardContent"
								placeholder="내용을 입력하세요." ><%if(boardSeq > 0){%><%=writeBoard_board.getBoardContent()%><%}%></textarea>
						</div>
						<input type="hidden" name="Catfirst" id="Catfirst" value="<%=Catfirst%>">
						<input type="hidden" name="firstName" id="firstName" value="<%=firstName%>">
						<input type="hidden" name="Catsecond" id="Catsecond" value="<%=Catsecond%>">
						<input type="hidden" name="secondName" id="secondName" value="<%=secondName%>">
						<input type="hidden" name="boardName" id="boardName" value="<%=writeBoard_user.getUserName()%>">
						<%if(boardSeq > 0){%>
						<input type="hidden" name="boardSeq" id="boardSeq" value="<%=writeBoard_board.getBoardSeq()%>">
						<%}%>
						<input type="hidden" name="searchType" value="<%=searchType%>">
						<input type="hidden" name="searchValue" value="<%=searchValue%>">
						<input type="hidden" name="curPage" value="<%=curPage%>">
					</form>
				</div>
			</div>
			<%@ include file="/include/footer.jsp"%>
		</div>
	</div>
</body>

</html>