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
				<div class="post-container">
					<div class="post-header">

						<div class="post-header-info">
							<h1>제목</h1>
							<p>
								<b>작성자:</b> 작성자
							</p>
							<p>
								<b>등록일:</b> 등록일
							</p>
							<p>
								<b>조회수:</b> 조회수
							</p>
						</div>
						<div style="display: flex; flex-direction: column;">
						<div class="post-header-buttons">
							<button class="list-btn" id="list-btn">리스트</button>

							<button class="edit-btn" id="edit-btn">수정</button>
							<button class="delete-btn" id="delete-btn">삭제</button>
 						</div>
 						<div style="margin-top:5px;"><a href="/board/download?보드아이디값=" style="color:#000; font-size: 18px;">[첨부파일] 파일명</a></div>
						</div>
					</div>

					<div class="post-content">
						<textarea readonly class="viewTextarea">내용</textarea>
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
			<%@ include file="/WEB-INF/views/include/footer.jsp"%>
		</div>
	</div>


<form name="viewForm" id="viewForm" method="post">
	<input type="hidden" name="boardSeq" value="">
	<input type="hidden" name="searchType" value="">
	<input type="hidden" name="searchValue" value="">
	<input type="hidden" name="curPage" value="">
	<input type="hidden" name="Catfirst" value="">
	<input type="hidden" name="firstName" value="">
	<input type="hidden" name="Catsecond" value="">
	<input type="hidden" name="secondName" value="">
</form>
</body>

</html>