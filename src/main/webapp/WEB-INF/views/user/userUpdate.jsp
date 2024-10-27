<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<!-- 컨트롤러에서 처리
	Logger userUpdate_logger = LogManager.getLogger("/user/userUpdate.jsp");
	HttpUtil.requestLogString(request, userUpdate_logger);

	MiniUser userUpdate_user = null;
	String userUpdate_cookieUserId = CookieUtil.getValue(request, "USER_ID");

	if (!StringUtil.isEmpty(userUpdate_cookieUserId)) {
		MiniUserDao userUpdate_userDao = new MiniUserDao();
		userUpdate_user = userUpdate_userDao.userSelect(userUpdate_cookieUserId);

		if (userUpdate_user == null || !StringUtil.equals(userUpdate_user.getUserStatus(), "Y")) {
			CookieUtil.deleteCookie(request, response, "/", "USER_ID");
			response.sendRedirect("/");
			return; // Make sure to return after redirect to prevent further processing
		}
	}
	userUpdate_logger.debug("userUpdate_user : " + userUpdate_user.getUserId());
	if (userUpdate_user != null) {
-->

<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<script>
$(document).ready(function(){
	$("#update-btn").on("click", function(){
		var IdPwdCheck = /^[a-zA-Z0-9]{6,12}$/;
		var emptyCheck = /\s/g;
		var telCheck = /^[0-9]{11}$/;

		if ($.trim($("#userPwd1").val()).length <= 0) {
			alert("비밀번호를 입력하세요.");
			$("#userPwd1").val("").focus();
			return;
		}

		if (emptyCheck.test($("#userPwd1").val())) {
			alert("비밀번호는 공백을 포함할 수 없습니다.");
			$("#userPwd1").focus().val("");
			return;
		}

		if (!IdPwdCheck.test($("#userPwd1").val())) {
			alert("비밀번호는 4~12자의 영문 대소문자와 숫자로만 입력가능합니다.");
			$("#userPwd1").focus();
			return;
		}

		if ($("#userPwd1").val() != $("#userPwd2").val()) {
			alert("비밀번호가 일치하지 않습니다.");
			$("#userPwd2").val("").focus();
			return;
		}

		$("#userPwd").val($("#userPwd1").val());

		if ($.trim($("#userEmail").val()).length <= 0) {
			alert("사용자 이메일을 입력하세요.");
			$("#userEmail").val("").focus();
			return;
		}

		if (!fn_validateEmail($("#userEmail").val())) {
			alert("사용자 이메일 형식이 올바르지 않습니다. 다시입력하세요.");
			$("#userEmail").focus();
			return;
		}

		if ($.trim($("#userTel").val()).length <= 0) {
			alert("전화번호를 입력하세요.");
			$("#userTel").val("").focus();
			return;
		}
		
		if(!telCheck.test($("#userTel").val())) {
			alert("전화번호는 숫자로 입력해주세요.");
			$("#userTel").val("").focus();
			return;
		}
		
		if ($.trim($("#userName").val()).length <= 0) {
			alert("사용자 이름을 입력하세요.");
			$("#userName").val("").focus();
			return;
		}

		if ($("#userRegion").val() == "") {
			alert("사는 지역을 선택해주세요.");
			$("#userRegion").focus();
			return;
		}
		
		if ($("#userFood").val() == "") {
			alert("테마별 음식을 선택해주세요.");
			$("#userFood").focus();
			return;
		}
		
		document.updateForm.submit();
	});
	
	$("#cancel-btn").on("click", function(){
		if(confirm("수정을 취소하고 이전 페이지로 돌아가시겠습니까?")) {
			history.back();
		}
	});
	
	$('#checkPasswordButton').on('click', function() {
	    var inputPwd = $('#inputPassword').val();
	    var boardPwd = $('#passwordModal').data('boardPwd');

	    if (inputPwd === boardPwd) {
	    	document.pwdForm.inputPassword.value = inputPwd;
	        document.pwdForm.submit();
	    } else {
	        alert('비밀번호가 틀렸습니다.');
	    }
	    closePasswordModal();
	});

	$('#closeModalButton').on('click', function() {
	    closePasswordModal();
	});
});

function fn_validateEmail(value) {
   var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
   return emailReg.test(value);
}

function openPasswordModal(boardPwd) {
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
			<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

			<div class="main-contanier">
				<%@ include file="/WEB-INF/views/leftMainContent.jsp" %>
				<div class="profile-update-page">
					<!-- Header -->
					<div class="update-header">
						<h1>회원정보 수정</h1>
					</div>

					<!-- Profile Update Form -->
					<form action="/user/userProc.jsp" method="post" class="profile-form" name="updateForm" id="updateForm">
						<div class="form-group">
							<label for="userId">아이디:</label>
							<input type="text" id="userId" name="userId" value="${userUpdate_user.userId}" readonly>
						</div>

						<div class="form-group">
							<label for="userEmail">이메일:</label>
							<input type="text" id="userEmail" name="userEmail" value="${userUpdate_user.userEmail}" required>
						</div>

						<div class="form-group">
							<label for="userPwd1">비밀번호 변경:</label>
							<input type="password" id="userPwd1" name="userPwd1" placeholder="새 비밀번호">
						</div>

						<div class="form-group">
							<label for="userPwd2">비밀번호 확인:</label>
							<input type="password" id="userPwd2" name="userPwd2" placeholder="비밀번호 확인">
						</div>

						<div class="form-group">
							<label for="userName">이름 변경:</label>
							<input type="text" id="userName" name="userName" value="${userUpdate_user.userName}" placeholder="이름">
						</div>

						<div class="form-group">
							<label for="userTel">전화번호:</label>
							<input type="text" id="userTel" name="userTel" value="${userUpdate_user.userTel}">
						</div>

						<div class="form-group">
							<label for="userRegion">주소:</label>
							<select id="userRegion" name="userRegion">
								<option value="">사는 지역</option>
								<option value="서울" <c:if test="${userUpdate_user.userRegion == '서울'}">selected</c:if>>서울</option>
								<option value="경기도" <c:if test="${userUpdate_user.userRegion == '경기도'}">selected</c:if>>경기도</option>
								<option value="강원도" <c:if test="${userUpdate_user.userRegion == '강원도'}">selected</c:if>>강원도</option>
								<option value="충정도" <c:if test="${userUpdate_user.userRegion == '충정도'}">selected</c:if>>충정도</option>
								<option value="전라도" <c:if test="${userUpdate_user.userRegion == '전라도'}">selected</c:if>>전라도</option>
								<option value="경상도" <c:if test="${userUpdate_user.userRegion == '경상도'}">selected</c:if>>경상도</option>
								<option value="제주도" <c:if test="${userUpdate_user.userRegion == '제주도'}">selected</c:if>>제주도</option>
							</select>
						</div>

						<div class="form-group">
							<label for="userFood">선호 음식:</label>
							<select id="userFood" name="userFood">
								<option value="">음식 선택</option>
								<option value="한식" <c:if test="${userUpdate_user.userFood == '한식'}">selected</c:if>>한식</option>
								<option value="중식" <c:if test="${userUpdate_user.userFood == '중식'}">selected</c:if>>중식</option>
								<option value="양식" <c:if test="${userUpdate_user.userFood == '양식'}">selected</c:if>>양식</option>
								<option value="일식" <c:if test="${userUpdate_user.userFood == '일식'}">selected</c:if>>일식</option>
								<option value="디저트" <c:if test="${userUpdate_user.userFood == '디저트'}">selected</c:if>>디저트</option>
							</select>
						</div>

						<div class="form-group">
							<button type="button" id="update-btn">수정하기</button>
							<button type="button" id="cancel-btn">취소하기</button>
						</div>
					</form>
					<div id="passwordModal" style="display:none;">
					    <div>
					        <label for="inputPassword">비밀번호 확인:</label>
					        <input type="password" id="inputPassword" />
					        <button id="checkPasswordButton">확인</button>
					        <button id="closeModalButton">닫기</button>
					    </div>
					</div>
				</div>
			</div>
			<%@ include file="/WEB-INF/views/include/footer.jsp" %>
		</div>
	</div>
</body>
</html>