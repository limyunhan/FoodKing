<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html lang="ko">

<head>
<%@include file="/WEB-INF/views/include/head.jsp" %>
<script>
    $(document).ready(function () {
        $("#userId").focus();

        $("#userId").on("keypress", function (e) {
            if (e.which === 13) {
                fn_loginCheck();
            }
        });

        $("#userPwd").on("keypress", function (e) {
            if (e.which === 13) {
                fn_loginCheck();
            }
        });

        $("#login-btn").on("click", function () {
            fn_loginCheck();

        });
    });

    function fn_loginCheck() {
        if ($.trim($("#userId").val()).length === 0) {
            alert("아이디를 입력하세요.");
            $("#userId").val("");
            $("#userId").focus();
            return;
        }

        if ($.trim($("#userPwd").val()).length === 0) {
            alert("비밀번호를 입력하세요.");
            $("#userPwd").val("");
            $("#userPwd").focus();
            return;
        }

        $.ajax({
            type: "POST",
            url: "/user/loginProc",
            data: {
                userId: $("#userId").val(),
                userPwd: $("#userPwd").val()
            },
            dataType: "JSON",
            beforeSend: function (xhr) {
                xhr.setRequestHeader("AJAX", "true");
            },
            success: function (response) {
                if (!icia.common.isEmpty(response)) {
                    icia.common.log(response);

                    var code = icia.common.objectValue(response, "code", -500);

                    if (code === 200) {
                        alert("로그인 성공");
                        location.href = "/index";
                    } else {
                        if (code === 401) {
                            alert("비밀번호가 올바르지 않습니다.");
                            $("#userPwd").focus();
                        } else if (code === 403) {
                            alert("정지된 사용자 입니다.");
                            $("#userId").focus();
                        } else if (code === 404) {
                            alert("아이디와 일치하는 사용자 정보가 없습니다.");
                            $("#userId").focus();
                        } else if (code === 400) {
                            alert("파라미터 값이 올바르지 않습니다.");
                            $("#userId").focus();
                        } else {
                            alert("서버 응답 오류가 발생하였습니다.");
                            $("#userId").focus();
                        }
                    }
                    
                } else {
                    alert("서버 응답 오류가 발생하였습니다.");
                    $("#userId").focus();
                }
            },
            complete: function () {
                icia.common.log(data);
            },
            error: function (xhr, status, error) {
                icia.common.error(error);
            }
        });
    }
</script>
</head>
<body id="login-body">
    <div class="login-main-page">
        <div class="login-container">
            <div class="login-header">
                <h2>로그인</h2>
            </div>
            <form name="loginForm" id="loginForm">
                <div class="input-groups">
                    <label for="userId">아이디</label>
                    <input type="text" id="userId" name="userId" placeholder="아이디를 입력하세요">
                </div>
                <div class="options">
                    <a href="/user/idFind">아이디를 잊으셨나요?</a>
                </div>
                <div class="input-groups">
                    <label for="userPwd">비밀번호</label>
                    <input type="password" id="userPwd" name="userPwd" placeholder="비밀번호를 입력하세요">
                </div>
                <div class="options">
                    <a href="/user/pwdFind">비밀번호를 잊으셨나요?</a>
                </div>
                <button type="button" id="login-btn">로그인</button>
            </form>
            <div class="signup-link">
                <p>계정이 없으신가요? <a href="/user/regForm">회원가입</a></p>
            </div>
        </div>
    </div>
</body>
</html>