<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>

<html lang="ko">
<head>
<%@include file="/WEB-INF/views/include/head.jsp"%>
<script>
	$(document).ready(function() {
		$("#userId").focus();

		$("#signup-btn").on("click", function() {
			var IdPwdCheck = /^[a-zA-Z0-9]{6,12}$/;
			var emptyCheck = /\s/g;
			var telCheck = /^[0-9]{11}$/;

			if ($.trim($("#userId").val()).length <= 0 || emptyCheck.test($("#userId").val())) {
				$("#warningText").text("아이디를 입력해주세요.");
				$("#userId").focus().val("");
				return;
			}

			if (!IdPwdCheck.test($("#userId").val())) {
				alert("사용자 아이디는 6~12자의 영문 대소문자와 숫자로만 입력가능합니다.");
				$("#userId").focus();
				return;
			}

			if ($.trim($("#userPwd1").val()).length <= 0 || emptyCheck.test($("#userPwd1").val())) {
				alert("비밀번호를 입력하세요.");
				$("#userPwd1").val("").focus();
				return;
			}

			if (!IdPwdCheck.test($("#userPwd1").val())) {
				alert("비밀번호는 6~12자의 영문 대소문자와 숫자로만 입력가능합니다.");
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

			if ($.trim($("#userTel").val()).length <= 0 || !telCheck.test($("#userTel").val())) {
				alert("전화번호는 11자리 숫자로 입력해주세요.");
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
			
			$.ajax({
				type: "POST",
				url: "/user/userIdCheckAjax.jsp",
				data: {
					userId: $("#userId").val()
				},
				dataType: "JSON",
				success: function(obj) {
					var data = JSON.parse(obj);
					if (data.flag == 0) {
						document.regForm.submit();
						alert("중복 아이디가 없습니다.");
					} else if (data.flag == 1) {
						alert("중복 아이디가 있습니다.");
						$("#userId").focus();
					} else {
						alert("아이디 값을 확인하세요.");
						$("#userId").focus();
					}
				},
				error: function(xhr, status, error) {
					alert("아이디 중복 체크 오류");
				}
			});
		});
	});

	function fn_validateEmail(value) {
		var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
		return emailReg.test(value);
	}
</script>
</head>
<body id="reg-body">
	<div class="signup-main-page">
		<div class="signup-container">
			<div class="signup-header">
				<h2>회원가입</h2>
				<p>아래의 양식을 작성해 회원가입을 완료하세요.</p>
			</div>
			<form action="/user/userProc.jsp" method="POST" id="regForm" name="regForm">
				<div class="input-group">
					<input type="text" id="userId" name="userId" placeholder="아이디">
					<p class="warningText" id="warningText"></p>
				</div>
				<div class="input-group">
					<input type="password" id="userPwd1" name="userPwd1" placeholder="비밀번호">
				</div>
				<div class="input-group">
					<input type="password" id="userPwd2" name="userPwd2" placeholder="비밀번호 확인">
				</div>
				<div class="input-group">
					<input type="text" id="userEmail" name="userEmail" placeholder="이메일">
				</div>
				<div class="input-group">
					<input type="text" id="userTel" name="userTel" placeholder="전화번호">
				</div>
				<div class="input-group">
					<input type="text" id="userName" name="userName" placeholder="이름">
				</div>
				<div class="input-group">
					<select id="userGender" name="userGender">
						<option value="M">남성</option>
						<option value="W">여성</option>
					</select>
				</div>
				<div class="input-group">
					<select id="userRegion" name="userRegion">
						<option value="">사는 지역</option>
						<option value="서울">서울</option>
						<option value="경기도">경기도</option>
						<option value="강원도">강원도</option>
						<option value="충정도">충정도</option>
						<option value="전라도">전라도</option>
						<option value="경상도">경상도</option>
						<option value="제주도">제주도</option>
					</select>
				</div>
				<div class="input-group">
					<select id="userFood" name="userFood">
						<option value="">좋아하는 테마별 음식</option>
						<option value="한식">한식</option>
						<option value="중식">중식</option>
						<option value="일식">일식</option>
						<option value="양식">양식</option>
						<option value="간식">간식</option>
					</select>
				</div>
				<button type="button" class="signup-btn" id="signup-btn">회원가입</button>
				<input type="hidden" name="userPwd" id="userPwd" value="">
			</form>
		</div>
	</div>
</body>
</html>