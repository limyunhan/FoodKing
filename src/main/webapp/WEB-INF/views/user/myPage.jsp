<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html lang="ko">

<head>
<%@include file="/WEB-INF/views/include/head.jsp" %>
<script>
$(document).ready(function(){
	$('#checkPasswordButton').on('click', function() {
	    var inputPwd = $('#inputPassword').val();
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

function fn_list(curPage) {
	document.listForm.curPage.value = curPage;
	document.listForm.action = "/user/myPage";
	document.listForm.submit();
}

function fn_view(boardSeq) {
	document.listForm.boardSeq.value = boardSeq;
	document.listForm.action = "/board/viewContent";
	document.listForm.submit();
}

function openProfileModal() {
    document.getElementById('profileModal').style.display = '';
}

function closeProfileModal() {
    document.getElementById('profileModal').style.display = 'none';
}

function openPasswordModal(boardSeq, boardPwd) {
    $('#passwordModal').data('boardSeq', boardSeq);
    $('#passwordModal').data('boardPwd', boardPwd);
    $('#passwordModal').show();
}

function closePasswordModal() {
    $('#passwordModal').hide();
    $('#inputPassword').val('');
}

</script>

</head>
<body id="index-body">
	<div class="Board-Main-Page">
		<div class="Board-Main">
			<%@include file="/WEB-INF/views/include/navigation.jsp"%>

			<div class="main-container">
				<%@include file="/WEB-INF/views/leftMainContent.jsp"%>
				<div class="profile-page">
					<!-- 사용자 프로필 섹션 -->
					<div class="profile-header">
						<div class="profile-picture">
							<img src="/${myPage_user.userImage}" alt="ProfilePicture" />
						</div>
						<div class="profile-info">
							<h2>${myPage_user.userName}</h2>
							<p>작성글 <span>${totalUser}</span> · 작성댓글 <span>0</span></p>
						</div>
					</div>

					<!-- 내비게이션 섹션 -->
					<div class="profile-nav">
					    <ul>
					        <li><a href="/user/myPage">작성글</a></li>
					        <li><a href="userUpdate.jsp">회원정보 수정</a></li>
					        <li><a href="javascript:void(0)" onclick="openProfileModal()">프로필 사진 수정</a></li>
					    </ul>
					</div>

					<!-- 게시글 목록 테이블 -->
					<div class="post-table">
						<table>
							<thead>
								<tr>
									<th>제목</th>
									<th>작성일</th>
									<th>조회</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="board" items="${myPage_list}">
									<tr>
										<td class="post-table_title">
											<a href="javascript:void(0)"
											   onclick="<c:choose>
                                                <c:when test="${admin_user.userId == myPage_cookieUserId}">
                                                    fn_view(${board.boardSeq});
                                                </c:when>
                                                <c:when test="${not empty board.boardPwd}">
                                                    openPasswordModal(${board.boardSeq}, '${board.boardPwd}');
                                                </c:when>
                                                <c:otherwise>
                                                    fn_view(${board.boardSeq});
                                                </c:otherwise>
                                            </c:choose>">
												<c:choose>
													<c:when test="${not empty board.boardPwd}">
														🔑비밀글 입니다.
													</c:when>
													<c:otherwise>
														${board.boardTitle}
													</c:otherwise>
												</c:choose>
											</a>
										</td>
										<td class="post-table_date"><fmt:formatDate value="${board.boardDate}" pattern="yyyy-MM-dd" /></td>
										<td class="post-table_view">${board.boardCount}</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>

					<!-- 페이징 처리 -->
					<div class="pagination">
						<ul>
							<c:if test="${paging.prevBlockPage > 0}">
								<li><a href="javascript:void(0)" onclick="fn_list(${paging.prevBlockPage})">이전</a></li>
							</c:if>
							<c:forEach var="page" begin="${paging.startPage}" end="${paging.endPage}">
								<li><a href="javascript:void(0)" onclick="fn_list(${page})">${page}</a></li>
							</c:forEach>
							<c:if test="${paging.nextBlockPage > 0}">
								<li><a href="javascript:void(0)" onclick="fn_list(${paging.nextBlockPage})">다음</a></li>
							</c:if>
						</ul>
					</div>
				</div>
			</div>
			<%@ include file="/WEB-INF/views/include/footer.jsp"%>
		</div>
	</div>
	
	<!-- 폼 및 모달 섹션 -->
	<form name="listForm" id="listForm" method="post">
		<input type="hidden" name="boardSeq" value="">
		<input type="hidden" name="curPage" value="${curPage}">
	</form>

	<div id="profileModal" class="modal" style="display:none;">
	    <div class="modal-content">
	        <span class="close" onclick="closeProfileModal()">&times;</span>
	        <h2>프로필 사진 수정</h2>
	        <form id="profileForm" method="post" enctype="multipart/form-data" action="/user/uploadImg">
	            <input type="file" name="profilePicture" accept="image/*">
	            <button type="submit">변경</button>
	        </form>
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
</body>
</html>