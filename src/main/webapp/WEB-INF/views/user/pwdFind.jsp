<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>  

<!DOCTYPE html>
<html lang="ko">
<head>
  <%@ include file="/WEB-INF/views/include/head.jsp" %>
  <script>
      $(document).ready(function() {
          $("#find-btn").on("click", function() {
              var IdPwdCheck = /^[a-zA-Z0-9]{6,12}$/;
              var emptyCheck = /\s/g;
              var telCheck = /^[0-9]{11}$/;
              
              if ($.trim($("#userEmail").val()).length <= 0) {
                  alert("사용자 이메일을 입력하세요.");
                  $("#userEmail").val("");
                  $("#userEmail").focus();
                  return;
              }

              if (!fn_validateEmail($("#userEmail").val())) {
                  alert("사용자 이메일 형식이 올바르지 않습니다. 다시 입력하세요.");
                  $("#userEmail").focus();
                  return;
              }

              if ($.trim($("#userTel").val()).length <= 0) {
                  alert("전화번호를 입력하세요.");
                  $("#userTel").val("");
                  $("#userTel").focus();
                  return;
              }
              
              document.findIdForm.submit();
          });
      });

      function fn_validateEmail(value) {
          var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
          return emailReg.test(value);
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
          <input type="text" id="userId" name="userId" placeholder="아이디">
        </div>
        
        <div class="input-group" style="display: flex;">
          <input type="text" id="userEmail" name="userEmail" placeholder="이메일">
          <button type="button" id="emailAuthNum" class="emailAuthBtn">인증번호 받기</button>
        </div>
        
        <div style="display: flex; flex-direction: column;">
          <div class="input-group" style="display: flex;">
            <input type="text" id="authCode" name="authCode" placeholder="인증번호 입력">
            <button type="button" id="emailAuth" class="emailAuthBtn">인증하기</button>    
          </div>
          <p class="warningText" id="warningText" style="margin: 0 0 0 5px; display: flex; justify-content: flex-start;"></p>
        </div>
        
        <div class="input-group">
          <input type="text" id="userTel" name="userTel" placeholder="전화번호">
        </div>
        
        <div class="input-group">
          <input type="text" id="userName" name="userName" placeholder="이름">
        </div>
        
        <div class="find-form-actions">
          <button type="button" class="find-btn" id="find-btn">비밀번호 찾기</button>
          <button type="button" class="find-cancel-btn" onclick="location.href='/'">취소</button>
        </div>
      </form>
    </div>
  </div>
</body>
</html>