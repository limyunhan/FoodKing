<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.sist.web.model.Paging"%>
<%@page import="java.util.List"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="com.sist.web.model.MiniBoard"%>
<%@ page import="com.sist.web.dao.MiniBoardDao"%>


<%
	Logger list_logger = LogManager.getLogger("/board/list.jsp");
	HttpUtil.requestLogString(request, list_logger);
	
	String cookieAdminId = CookieUtil.getValue(request, "USER_ID");
	
	String Catfirst = HttpUtil.get(request, "Catfirst", "");
	String firstName = HttpUtil.get(request, "firstName", "");
	
	String Catsecond = HttpUtil.get(request, "Catsecond", "");
	String secondName = HttpUtil.get(request, "secondName");
	
	String searchType = HttpUtil.get(request, "searchType", "");
	String searchValue = HttpUtil.get(request, "searchValue", "");
	
	String dateFilter = HttpUtil.get(request, "dateFilter", "");
	
	long curPage = HttpUtil.get(request, "curPage", (long) 1);
	
	long listCount = HttpUtil.get(request, "listCount", (long)5);
	String listSort = HttpUtil.get(request, "listSort", "BOARD_SEQ");
	
	list_logger.debug("Catfirst 리스트: " + Catfirst);
	list_logger.debug("firstName : " + firstName);
	list_logger.debug("Catsecond : " + Catsecond);
	list_logger.debug("secondName : " + secondName);
	
	List<MiniBoard> list = null;
	Paging paging = null;
	
	long totalCount = 0;
	
	MiniUser admin_user = null;
	MiniUserDao admin_UserDao = new MiniUserDao();
	
	admin_user = admin_UserDao.userSelect("admin");
	
	MiniBoard search = new MiniBoard();
	MiniBoardDao list_boardDao = new MiniBoardDao();
	
	if(!StringUtil.isEmpty(Catfirst) && !StringUtil.isEmpty(firstName)) 
	{	
		search.setCatFirst(Catfirst);
		search.setFirstName(firstName);
	
		if (!StringUtil.isEmpty(Catsecond) && !StringUtil.isEmpty(secondName))
		{
			if(StringUtil.equals(Catsecond, "3") && StringUtil.equals(secondName, "전체글") && StringUtil.equals(Catfirst, "2") && StringUtil.equals(firstName, "커뮤니티"))
			{
				list_logger.debug("test1");
				search.setCatFirst("");
				search.setFirstName(firstName);
				search.setCatSecond("");
				search.setSecondName(secondName);
			}
			else
			{
				search.setCatSecond(Catsecond);
				
				if(StringUtil.equals(secondName, "null"))
				{
					search.setSecondName("");
				}
				else
				{
					search.setSecondName(secondName);
				}
			}
		}
	}
	
	if(!StringUtil.isEmpty(Catfirst) && StringUtil.isEmpty(firstName))
	{
		if(!StringUtil.isEmpty(Catsecond) && StringUtil.isEmpty(secondName))
		{
			MiniBoard catName = list_boardDao.catBoard(Catsecond);
			
			search.setCatFirst(Catfirst);
			search.setFirstName(catName.getFirstName());
			search.setCatSecond(Catsecond);
			search.setSecondName(catName.getSecondName());
			
		}
	}
	
	if(!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue))
	{
		if(StringUtil.equals(searchType, "author"))
		{
			search.setBoardName(searchValue);
		}
		
		else if(StringUtil.equals(searchType, "title"))
		{
			search.setBoardTitle(searchValue);
		}
		
		else if(StringUtil.equals(searchType, "content"))
		{
			search.setBoardContent(searchValue);
		}
	}
	else
	{
		searchType = "";
		searchValue = "";
	}
	
	if(!StringUtil.isEmpty(dateFilter))
	{
		if(StringUtil.equals(dateFilter, "1"))
		{
			search.setDateFilter(dateFilter);
		}
		
		else if(StringUtil.equals(dateFilter, "7"))
		{
			search.setDateFilter(dateFilter);
		}
		
		else if(StringUtil.equals(dateFilter, "30"))
		{
			search.setDateFilter(dateFilter);
		}
	}
	else
	{
		dateFilter = "";
	}
	
	if(!StringUtil.isEmpty(listSort))
	{
		if(StringUtil.equals(listSort, "BOARD_SEQ"))
		{
			search.setListSort(listSort);
		}
		
		else if(StringUtil.equals(listSort, "BOARD_COUNT"))
		{
			search.setListSort(listSort);
		}
	}
	
	else
	{
		listSort = "";
	}

	totalCount = list_boardDao.totalBoardCount(search);

	if(totalCount > 0)
	{
		paging = new Paging(totalCount, listCount, 5, curPage);
		search.setStartRow(paging.getStartRow());
		search.setEndRow(paging.getEndRow());
		
		list = list_boardDao.boardList(search);
	}	
	
%>

<!DOCTYPE html>
<html lang="ko">

<head>
<title>MiniProject</title>
<%@ include file="/include/head.jsp"%>
</head>
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

    $("#pagingSelect").change(function() {
        var selectedValue = $(this).val();
        document.listForm.listCount.value = selectedValue;
        document.listForm.submit();
    });
    
    $("#sortSelect").change(function() {
        var selectedValue = $(this).val();
        document.listForm.listSort.value = selectedValue;
        document.listForm.submit();
    });
	
	$("#_searchType").change(function(){
		$("#_searchValue").val("");
	});
	
	$("#write-button").on("click", function(){
		document.listForm.action = "/board/writeBoard.jsp";
		document.listForm.submit();
	});
	
	$("#btnSearch").on("click", function(){
		if($("#_searchType").val() != "")
		{
			if($.trim($("#_searchValue").val()) == "")
			{
				alert("조회항목 선택시 조회값을 입력하세요");
				$("#_searchValue").val("");
				$("#_searchValue").focus();
				return;
			}
		}
		document.listForm.dateFilter.value = $("#_dateFilter").val();
		document.listForm.searchType.value = $("#_searchType").val();
		document.listForm.searchValue.value = $("#_searchValue").val();
		document.listForm.curPage.value = "";
		document.listForm.action = "/board/list.jsp";
		document.listForm.submit();
	});
});

function fn_list(curPage)
{
	document.listForm.curPage.value = curPage;
	document.listForm.action = "/board/list.jsp";
	document.listForm.submit();
}

function fn_view(boardSeq)
{
	document.listForm.boardSeq.value = boardSeq;
	document.listForm.action = "/board/viewContent.jsp";
	document.listForm.submit();
	
}
function openPasswordModal(boardSeq, boardPwd) {
    $('#passwordModal').data('boardSeq', boardSeq); // boardSeq를 모달에 저장
    $('#passwordModal').data('boardPwd', boardPwd); // boardPwd를 모달에 저장
    $('#passwordModal').show();
}

function closePasswordModal() {
    $('#passwordModal').hide();
    $('#inputPassword').val(''); // 입력된 비밀번호 초기화
}
</script>
<body id="index-body">
	<div class="Board-Main-Page">
		<div class="Board-Main">
			<%@include file="/include/navigation.jsp"%>

			<div class="main-contanier">
				<%@include file="/leftMainContent.jsp"%>
				<div class="right-main-content">
					<div class="right-main-content-header">
						<div class="right-main-content-header-title">
							<h1>
								[<%=search.getFirstName()%>]
								<%=search.getSecondName()%></h1>
						</div>
						<div class="right-main-content-header-search">
							<select class="pagingSelect" id="pagingSelect">
								<option value="5" <% if (listCount == 5) { %> selected <% } %>>5개씩</option>
								<option value="10" <% if (listCount == 10) { %> selected <% } %>>10개씩</option>
								<option value="15" <% if (listCount == 15) { %> selected <% } %>>15개씩</option>
							</select>
							<select class="sortSelect" id="sortSelect">
								<option value="BOARD_SEQ" <% if (StringUtil.equals(listSort, "BOARD_SEQ")) { %> selected <% } %>>등록일순</option>
								<option value="BOARD_COUNT" <% if (StringUtil.equals(listSort, "BOARD_COUNT")) { %> selected <% } %>>조회순</option>
								<option value="">좋아요순</option>
							</select>
						</div>
					</div>
					<table class="notice-board">
						<thead>
							<tr>
								<th scope="col" class="text-center">번호</th>
								<th scope="col" class="text-center">제목</th>
								<th scope="col" class="text-center">작성자</th>
								<th scope="col" class="text-center">작성일</th>
								<th scope="col" class="text-center">조회</th>
								<th scope="col" class="text-center">좋아요</th>
							</tr>
						</thead>
						<tbody>
<%
							if (list != null && list.size() > 0) 
							{
								long startNum = paging.getStartNum();								

								for (int i = 0; i < list.size(); i++) 
								{
									MiniBoard board = list.get(i);
%>
							<tr class="text-center-view" onclick="<%if(StringUtil.equals(admin_user.getUserId(), cookieAdminId)) { %>fn_view(<%=board.getBoardSeq()%>);<%}%><%else if (board.getBoardPwd() != null && !board.getBoardPwd().isEmpty()) { %>
                            openPasswordModal(<%=board.getBoardSeq()%>, '<%=board.getBoardPwd()%>');
                         <% } else { %>
                            fn_view(<%=board.getBoardSeq()%>);
                         <% } %>">
								<td class="text-center"><%=startNum%></td>
								<td class="text-center-title"><a href="javascript:void(0)"><%if (board.getBoardPwd() != null && !board.getBoardPwd().isEmpty()) { %>🔑비밀글 입니다.<%} else {%><%=board.getBoardTitle()%><%}%></a></td>
								<td class="text-center"><%=board.getBoardName()%></td>
								<td class="text-center"><%=board.getBoardDate()%></td>
								<td class="text-center"><%=board.getBoardCount()%></td>
								<td class="text-center">1</td>
							</tr>
<%
							startNum--;
								}
							}

							else 
							{
%>
							<tr>
								<td class="text-center" colspan="4">해당 데이터가 존재하지 않습니다.</td>
							<tr>
<%
							}
%>
							
						</tbody>
					</table>
<%
							if(StringUtil.equals(admin_user.getUserId(), cookieAdminId))
							{	list_logger.debug("admin_user.getUserId() : " + admin_user.getUserId());
%>
					<div class="write-button-container">
						<a href="javascript:void(0)" class="write-button" id="write-button">글쓰기</a>
					</div>
<%
							}
							
							else if(!StringUtil.equals(secondName, "관리자가 추천하는 맛집") && !StringUtil.equals(firstName, "공지사항"))
							{
%>
					<div class="write-button-container">
						<a href="javascript:void(0)" class="write-button" id="write-button">글쓰기</a>
					</div>
<%
							}
%>
					<!-- 페이징 처리 -->
					<div class="pagination">
						<ul>
<% 
							if(paging != null)
							{
								if(paging.getPrevBlockPage() > 0)
								{
%>
							<li><a href="javascript:void(0)" onclick="fn_list(<%=paging.getPrevBlockPage()%>)">이전</a></li>
<%
								}
								
								for(long i = paging.getStartPage(); i <= paging.getEndPage(); i++)
								{
									if(paging.getCurPage() != i)
									{
%>
							<li><a href="javascript:void(0)" onclick="fn_list(<%=i%>)"><%=i%></a></li>
<%
									}
									
									else
									{
%>
							<li><a href="javascript:void(0)" onclick="fn_list(<%=i%>)"><%=i%></a></li>
<%
									}
								}
									
								if(paging.getNextBlockPage() > 0)
								{
%>
							<li><a href="javascript:void(0)" onclick="fn_list(<%=paging.getNextBlockPage()%>)">다음</a></li>
<%
								}
							}
%>
						</ul>
					</div>

					<!-- 검색 바 -->
					<div class="search-bar ">
						<select name="_dateFilter" id="_dateFilter">
					        <option value="">전체</option>
					        <option value="1"<%if(StringUtil.equals(dateFilter, "1")){%>selected<%}%>>하루전</option>
					        <option value="7"<%if(StringUtil.equals(dateFilter, "7")){%>selected<%}%>>최근1주일</option>
					        <option value="30"<%if(StringUtil.equals(dateFilter, "30")){%>selected<%}%>>30일전</option>
					    </select>
						<select name="_searchType" id="_searchType">
							<option value="title"<%if(StringUtil.equals(searchType, "title")){%>selected<%}%>>제목</option>
							<option value="content"<%if(StringUtil.equals(searchType, "content")){%>selected<%}%>>내용</option>
							<option value="author"<%if(StringUtil.equals(searchType, "author")){%>selected<%}%>>작성자</option>
						</select> 
						<input type="text" name="_searchValue" id="_searchValue" value="<%=searchValue%>" placeholder="검색어를 입력하세요">
						<button type="button" id="btnSearch">검색</button>
					</div>
				</div>
				<div id="passwordModal" style="display:none;">
				    <div class="modal-content">
				        <h3>비밀번호 입력</h3>
				        <input type="password" id="inputPassword" placeholder="비밀번호를 입력하세요" />
				        <button id="checkPasswordButton">확인</button>
				        <button id="closeModalButton">취소</button>
				    </div>
				</div>
			</div>
			<%@ include file="/include/footer.jsp"%>
		</div>
	</div>

	<form name="listForm" id="listForm" method="post">
		<input type="hidden" name="searchType" value="<%=searchType%>">
		<input type="hidden" name="searchValue" value="<%=searchValue%>">
		<input type="hidden" name="curPage" value="<%=curPage%>">
		<input type="hidden" name="boardSeq" value="">
		<input type="hidden" name="Catfirst" value="<%=Catfirst%>">
		<input type="hidden" name="firstName" value="<%=firstName%>">
		<input type="hidden" name="Catsecond" value="<%=Catsecond%>">
		<input type="hidden" name="secondName" value="<%=secondName%>">
		<input type="hidden" name="dateFilter" value="<%=dateFilter%>">
		<input type="hidden" name="listCount" value="<%=listCount%>">
		<input type="hidden" name="listSort" value="<%=listSort%>">	
	</form>
</body>

</html>

