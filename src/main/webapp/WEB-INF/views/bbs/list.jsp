<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/include/taglib.jsp" %>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>

<!DOCTYPE html>
<html lang="ko">

<head>
<%@include file="/WEB-INF/views/include/head.jsp" %>
</head>
<script>

</script>
<body id="index-body">
	<div class="Board-Main-Page">
		<div class="Board-Main">
			<%@include file="/WEB-INF/views/include/navigation.jsp"%>

			<div class="main-contanier">
				<%@include file="/WEB-INF/views/leftMainContent.jsp"%>
				<div class="right-main-content">
					<div class="right-main-content-header">
						<div class="right-main-content-header-title">
							<h1>
								[상위 카테고리명]
								하위 카테고리명</h1>
						</div>
						<div class="right-main-content-header-search">
							<select class="pagingSelect" id="pagingSelect">
								<option value="5" >5개</option>
								<option value="10">10개</option>
								<option value="15" >15개</option>
							</select>
							<select class="sortSelect" id="sortSelect">
								<option value="BOARD_SEQ" >등록일순</option>
								<option value="BOARD_COUNT" >조회순</option>
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
							<tr class="text-center-view" onclick="fn_view(); openPasswordModal(, ''); fn_view();">
								<td class="text-center">번호</td>
								<td class="text-center-title"><a href="javascript:void(0)">🔑비밀글 입니다.</a></td>
								<td class="text-center">작성자</td>
								<td class="text-center">작성일</td>
								<td class="text-center">조회</td>
								<td class="text-center">좋아요</td>
							</tr>
							<tr>
								<td class="text-center" colspan="4">해당 데이터가 존재하지 않습니다.</td>
							<tr>
							
						</tbody>
					</table>
					<div class="write-button-container">
						<a href="javascript:void(0)" class="write-button" id="write-button">글쓰기</a>
					</div>
					<div class="write-button-container">
						<a href="javascript:void(0)" class="write-button" id="write-button">글쓰기</a>
					</div>
					
					<!-- 페이징 처리 -->
					<div class="pagination">
						<ul>
							<li><a href="javascript:void(0)" onclick="fn_list()">이전</a></li>

							<li><a href="javascript:void(0)" onclick="fn_list()"></a></li>

							<li><a href="javascript:void(0)" onclick="fn_list()"></a></li>

							<li><a href="javascript:void(0)" onclick="fn_list()">다음</a></li>

						</ul>
					</div>

					<!-- 검색 바 -->
					<div class="search-bar ">
						<select name="_dateFilter" id="_dateFilter">
					        <option value="">전체</option>
					        <option value="1">하루전</option>
					        <option value="7">최근1주일</option>
					        <option value="30">한달전</option>
					    </select>
						<select name="_searchType" id="_searchType">
							<option value="title">제목</option>
							<option value="content">내용</option>
							<option value="author">작성자</option>
						</select> 
						<input type="text" name="_searchValue" id="_searchValue" value="" placeholder="검색어를 입력하세요">
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
			<%@ include file="/WEB-INF/views/include/footer.jsp"%>
		</div>
	</div>

	<form name="listForm" id="listForm" method="post">
		<input type="hidden" name="searchType" value="">
		<input type="hidden" name="searchValue" value="">
		<input type="hidden" name="curPage" value="">
		<input type="hidden" name="boardSeq" value="">
		<input type="hidden" name="Catfirst" value="">
		<input type="hidden" name="firstName" value="">
		<input type="hidden" name="Catsecond" value="">
		<input type="hidden" name="secondName" value="">
		<input type="hidden" name="dateFilter" value="">
		<input type="hidden" name="listCount" value="">
		<input type="hidden" name="listSort" value="">	
	</form>
</body>

</html>

