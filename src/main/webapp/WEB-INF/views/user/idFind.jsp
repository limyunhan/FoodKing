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
        
        if ($.trim($("#authCode").val()).length === 0) {
        	alert("인증번호를 입력하세요.");
        	$("#authCode").focus();
        	return;
        }
        
        if ($.)
        
        document.findIdForm.submit();
    });
	
    $("#emailAuth").on("click", function() {
        var email = $("#userEmail").val();

        if (!fn_validateEmail(email)) {
            alert("올바른 이메일 주소를 입력하세요.");
            return;
        }

        $.ajax({
            type: "POST",
            url: "/user/sendAuthCode.jsp",
            data: { userEmail: email },
            success: function(response) {
                alert("인증번호가 이메일로 발송되었습니다.");
            },
            error: function(xhr, status, error) {
                alert("인증번호 발송에 실패했습니다. 다시 시도해주세요.");
            }
        });
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
    });
    */
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
                <h2>아이디 찾기</h2>
                <p>가입하신 이메일 또는 전화번호를 입력하세요.</p>
            </div>
            <form class="find-id-form" name="findIdForm" id="findIdForm" method="post">
                <div class="input-group" style="display:flex;">
                    <input type="text" id="userEmail" name="userEmail" placeholder="이메일">
                    <button type="button" id="emailAuthNum" class="emailAuthBtn">인증번호 받기</button>
                </div>
                <div style="display: flex; flex-direction: column;">
                <div class="input-group" style="display:flex; ">
                    <input type="text" id="authCode" name="authCode" placeholder="인증번호 입력">
                    <button type="button" id="emailAuth" class="emailAuthBtn">인증하기</button>    
                </div>
                <p class="warningText" id="warningText" style="margin-top:0; margin-bottom:0; margin-left: 5px; display:flex; justify-content: flex-start;"></p>
                </div>
                <div class="input-group">
                    <input type="text" id="userTel" name="userTel" placeholder="전화번호">
                </div>
                <div class="input-group">
                    <input type="text" id="userName" name="userName" placeholder="이름">
                </div>
                <div class="find-form-actions">
                    <button type="button" class="find-btn" id="find-btn">아이디 찾기</button>
                    <button type="button" class="find-cancel-btn" onclick="location.href='/'">취소</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>