<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html lang="ko">

<head>
  <%@include file="/WEB-INF/views/include/head.jsp"%>
  <style>
    #timerText{
      margin-top: 5px;
      margin-bottom: 0;
      margin-left: 5px;
      float: left;
      color: blue;
    }
  </style>
  <script>
    $(document).ready(function() {
    	var isAuthCodeSent = false; // 인증번호 발급 여부를 저장
    	
        $("#find-btn").on("click", function() {
            if ($.trim($("#userEmail").val()).length === 0) {
                alert("사용자 이메일을 입력하세요.");
                $("#userEmail").val("");
                $("#userEmail").focus();
                return;
            }

            if (!fn_validateEmail($("#userEmail").val())) {
                alert("이메일 형식이 올바르지 않습니다.");
                $("#userEmail").focus();
                return;
            }
            
            if ($.trim($("#userTel").val()).length === 0) {
                alert("전화번호를 입력하세요.");
                $("#userTel").val("");
                $("#userTel").focus();
                return;
            }

            if (!fn_validateTel($("#userTel").val())) {
                alert("전화번호 형식이 올바르지 않습니다. 11자리 숫자를 입력하세요.");
                $("#userTel").focus();
                return;
            }
            
            if (!isAuthCodeSent) {
                alert("인증번호를 발급받아야 합니다.");
                $("#emailAuth").focus();
                return;
            }
            
            if ($.trim($("#authCode").val()).length === 0) {
                alert("인증번호를 입력하세요.");
                $("#authCode").focus();
                return;
            }

            document.findIdForm.submit();
        });

        $("#emailAuth").on("click", function() {
            var email = $("#userEmail").val();

            if (!fn_validateEmail(email)) {
                alert("이메일 형식이 올바르지 않습니다.");
                return;
            }
            
            $.ajax({
                type: "POST",
                url: "/user/idFindSendAuth",
                data: { 
                    userEmail: email 
                },
                dataType: "JSON",
                beforeSend: function(xhr) {
                    xhr.setRequestHeader("AJAX", "true");
                },
                success: function(response) {
                    if (response.code === 200) {
                        alert("인증번호가 이메일로 발송되었습니다.");
                        
                        isAuthCodeSent = true;
                        $("#emailAuth").prop("disabled", true); // '인증번호 받기' 버튼 비활성화
                        
                        let countdown = 300; // 타이머 300초(5분) 설정
                        if (timer) clearInterval(timer); // 이전 타이머 정지
                        
                        timer = setInterval(function() {
                            const minutes = Math.floor(countdown / 60);
                            const seconds = countdown % 60;
                            $("#timerText").text("남은 시간: " + minutes + ":" + (seconds < 10 ? '0' : '') + seconds);
                            
                            countdown--;

                            // 타이머 종료 시 버튼 활성화 및 타이머 초기화
                            if (countdown < 0) {
                                clearInterval(timer);
                                $("#emailAuth").prop('disabled', false); // 버튼 다시 활성화
                                $("#timerText").text('인증 시간이 만료되었습니다. 다시 요청해주세요.');
                            }
                        }, 1000);  // 1초마다 업데이트

                    } else if (response.code === 404) {
                        alert("입력하신 정보에 해당하는 사용자가 없습니다.");
                        
                    } else if (response.code === 400) {
                        alert("비정상적인 접근입니다.");
                        
                    } else {
                        alert("서버 응답 오류로 이메일 발송에 실패했습니다.");
                    }
                },
                error: function(error) {
                    alert("인증번호 발송에 실패했습니다. 다시 시도해주세요.");
                }
            });
        });

        
        $("#userEmail").on("input", function() {
            var userEmail = $.trim($("#userEmail").val());
            
            if (userEmail.length === 0) {
                $("#warningText").text("이메일을 입력하세요.").css("color", "red");
                
            } else if (!fn_validateEmail(userEmail)) {
                $("#warningText").text("이메일 형식이 올바르지 않습니다.").css("color", "red");
            
            } else {
                $("#warningText").text("");
            }
        });
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
        <div class="input-group">
          <input type="text" id="userName" name="userName" placeholder="이름">
        </div>
        <div class="input-group">
          <input type="text" id="userTel" name="userTel" placeholder="전화번호">
        </div>
        
        <div class="input-group" style="display: flex; flex-direction: column; align-items: flex-start;">
          <div style="display: flex; align-items: center; width: 100%;">
            <input type="text" id="userEmail" name="userEmail" placeholder="이메일" style="flex: 1;">
            <button type="button" id="emailAuthNum" class="emailAuthBtn">인증번호 받기</button>
          </div>
          <p class="warningText" id="warningText">이메일을 입력하세요</p>
        </div>
        <div class="input-group" style="display: flex; flex-direction: column; align-items: flex-start;">
          <div style="display: flex; align-items: center; width: 100%;">
            <input type="text" id="authCode" name="authCode" placeholder="인증번호 입력" style="flex: 1;">
            <button type="button" id="emailAuth" class="emailAuthBtn">인증하기</button>
          </div>
          <p id="timerText" id="warstyle="margin-top: 5px;">남은 시간: 05:00</p>
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