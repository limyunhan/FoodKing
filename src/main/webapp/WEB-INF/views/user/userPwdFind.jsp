<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html lang="ko">

<head>
<%@include file="/WEB-INF/views/include/head.jsp"%>
<style>
.invalid {
    border: 2px solid red; 
    background-color: #f8d7da; 
    color: #721c24; 
}
</style>
<script>
$(document).ready(function() {
    $("#find-btn").on("click", function() {
        if ($.trim($("#userEmail").val()).length === 0) {
            alert("사용자 이메일을 입력하세요.");
            $("#userEmail").focus();
            return;
        }

        if (!fn_validateEmail($("#userEmail").val())) {
            alert("이메일 형식이 올바르지 않습니다. 다시 입력하세요.");
            $("#userEmail").focus();
            return;
        }

        if ($.trim($("#userTel").val()).length === 0) {
            alert("전화번호를 입력하세요.");
            $("#userTel").focus();
            return;
        }

        if (!fn_validateTel($("#userTel").val())) {
            alert("전화번호 형식이 올바르지 않습니다. 11자리 숫자를 입력하세요.");
            $("#userTel").focus();
            return;
        }
        
        document.findIdForm.submit();
    });
	
    /*
    $("#userEmail, #userTel").on("input", function() {
        let input = $(this);
        if (input.attr("id") === "userEmail" && !fn_validateEmail(input.val())) {
            input.addClass("invalid");
        } else if (input.attr("id") === "userTel" && !fn_validateTel(input.val())) {
            input.addClass("invalid");
        } else {
            input.removeClass("invalid");
        }
    }); */
});

function fn_validateEmail(value) {
    var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
    return emailReg.test(value);
}

function fn_validateTel(value) {
    var telReg = /^[0-9]{11}$/;
    return telReg.test(value);
}
</script>
</head>
<body>
	<div class="find-id-body">
		<div class="find-id-container">
			<div class="find-id-header">
				<h2>비밀번호 찾기</h2>
				<p>가입하신 정보를 입력하세요.</p>
			</div>
			<form class="find-id-form" name="findIdForm" id="findIdForm" action="/user/userFindProc.jsp" method="post">
				<div class="input-group">
					<input type="text" id="userId" name="userId" placeholder="아이디" class="form-control">
				</div>
				<div class="input-group">
					<input type="text" id="userEmail" name="userEmail" placeholder="이메일" class="form-control">
				</div>
				<div class="input-group">
					<input type="text" id="userTel" name="userTel" placeholder="전화번호" class="form-control">
				</div>
				<div class="input-group">
					<input type="text" id="userName" name="userName" placeholder="이름" class="form-control">
				</div>
				<div class="find-form-actions">
					<button type="button" class="find-btn btn btn-primary" id="find-btn">비밀번호 찾기</button>
					<button type="button" class="find-cancel-btn btn btn-secondary" onclick="location.href='/'">취소</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>