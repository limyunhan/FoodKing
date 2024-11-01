<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>  

<!DOCTYPE html>
<html lang="ko">
<head>
  <%@ include file="/WEB-INF/views/include/head.jsp" %>
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
  	      let isAuthCodeSent = false; 
          let isVerified = false;
    	  let timer;
          
    	  $("#userId").focus();
    	  
          $("#userId").on("input", function() {
              var userId = $.trim($("#userId").val());

              if (userId.length === 0) {
                  $("#warningId").text("아이디를 입력하세요.");

              } else if (fn_validateEmpty(userId)) {
                  $("#warningId").text("아이디는 공백을 포함할수 없습니다.");

              } else if (!fn_validateIdPwd(userId)) {
                  $("#warningId").text("아이디는 4 ~ 12자 영문 대소문자와 숫자로만 입력가능합니다.");

              } else {
                  $("#warningId").text("");
              }
          });
          
          $("#userEmail").on("input", function() {
              var userEmail = $.trim($("#userEmail").val());

              if (userEmail.length === 0) {
                  $("#warningEmail").text("이메일을 입력하세요.");

              } else if (!fn_validateEmail(userEmail)) {
                  $("#warningEmail").text("이메일 형식이 올바르지 않습니다.");

              } else {
                  $("#warningEmail").text("");
              }
          });
          
          $("#emailAuthNum").on("click", function() {
              if ($.trim($("#userId").val()).length === 0) {
                  alert("아이디를 입력해주세요.");
                  $("#userId").focus();
                  $("#userId").val("");
                  return;
              }

              if (fn_validateEmpty($("#userId").val())) {
                  alert("아이디는 공백을 포함할수 없습니다.");
                  $("#userId").focus();
                  $("#userId").val("");
                  return;
              }

              if (!fn_validateIdPwd($("#userId").val())) {
                  alert("아이디는 4 ~ 12자의 영문 대소문자와 숫자로만 입력가능합니다.");
                  $("#userId").focus();
                  return;
              }
              
              if ($.trim($("#userEmail").val()).length === 0) {
                  alert("이메일을 입력하세요.");
                  $("#userEmail").val("");
                  $("#userEmail").focus();
                  return;
              }

              if (!fn_validateEmail($("#userEmail").val())) {
                  alert("이메일 형식이 올바르지 않습니다. 다시입력하세요.");
                  $("#userEmail").focus();
                  return;
              }
              
              $.ajax({
                  type: "POST",
                  url: "/user/pwdFindSendAuth",
                  data: { 
                      userId: $("#userId").val(),
                      userEmail: $("#userEmail").val()
                  },
                  dataType: "JSON",
                  beforeSend: function(xhr) {
                      xhr.setRequestHeader("AJAX", "true");
                  },
                  success: function(response) {
                	  if (response.code === 200) {
                		  alert("인증번호가 이메일로 발송되었습니다.");
                		  
                		  isAuthCodeSent = true;
                		  $("#emailAuthNum").prop("disabled", true);
                		  
                		  let countdown = 300; 
                          if (timer) clearInterval(timer); 
                          
                          timer = setInterval(function() {
                              const minutes = Math.floor(countdown / 60);
                              const seconds = countdown % 60;
                              $("#timerText").text("남은 시간: " + minutes + ":" + (seconds < 10 ? '0' : '') + seconds);
                              
                              countdown--;

                              if (countdown < 0) {
                                  clearInterval(timer);
                                  $("#emailAuthNum").prop('disabled', false); 
                                  $("#timerText").text('인증 시간이 만료되었습니다. 다시 요청해주세요.');
                                  isAuthCodeSent = false;
                              }
                          }, 1000);  
                		  
                	  } else if (response.code === 503) {
                		  alert("메일 서버 오류로 메일 발송에 실패하였습니다.");
                		  
                	  } else if (response.code === 401) {
                		  alert("이메일 정보가 일치하지 않습니다.");
                		  
                	  } else if (response.code === 404) {
                		  alert("입력하신 정보에 해당하는 사용자가 없습니다.");
                		  
                	  } else if (response.code === 400) {
                		  alert("비정상적인 접근입니다.");
                		  
                	  } else {
                		  alert("서버 응답 오류로 이메일 발송에 실패했습니다.");
                	  }
                  },
                  error: function(error) {
                	  alert("서버 응답 오류로 이메일 발송에 실패했습니다.");
                  }
              });
          });
          
          $("#emailAuth").on("click", function() {
              if ($.trim($("#userId").val()).length === 0) {
                  alert("아이디를 입력해주세요.");
                  $("#userId").focus();
                  $("#userId").val("");
                  return;
              }

              if (fn_validateEmpty($("#userId").val())) {
                  alert("아이디는 공백을 포함할수 없습니다.");
                  $("#userId").focus();
                  $("#userId").val("");
                  return;
              }

              if (!fn_validateIdPwd($("#userId").val())) {
                  alert("아이디는 4 ~ 12자의 영문 대소문자와 숫자로만 입력가능합니다.");
                  $("#userId").focus();
                  return;
              }
        	 
              if ($.trim($("#userEmail").val()).length === 0) {
                  alert("이메일을 입력하세요.");
                  $("#userEmail").val("");
                  $("#userEmail").focus();
                  return;
              }

              if (!fn_validateEmail($("#userEmail").val())) {
                  alert("이메일 형식이 올바르지 않습니다. 다시입력하세요.");
                  $("#userEmail").focus();
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
              
              $.ajax({
                  type: "POST",
                  url: "/user/pwdFindVerifyAuth",
                  data: { 
                	  userId: $("#userId").val(),
                      userEmail: $("#userEmail").val(),
                      authCode: $("#authCode").val()
                  },
                  dataType: "JSON",
                  beforeSend: function(xhr) {
                      xhr.setRequestHeader("AJAX", "true");
                  },
                  success: function(response) {
                      if (response.code === 200) {
                          alert("인증이 완료되었습니다.");
                          $("#emailAuth").prop("disabled", true); 
                          $("#emailAuth").text("인증 완료");
                          isVerified = true;
                          if (timer) clearInterval(timer); 

                      } else if (response.code === 403) {
                          alert("인증코드가 일치하지 않습니다.");
                          
                      } else if (response.code === 410) {
                          alert("만료되거나 존재하지 않는 인증코드 입니다.");
                          
                      } else if (response.code === 401) {
                    	  alert("이메일이 일치하지 않습니다.");
                    	  
                      } else if (response.code === 404) {
                    	  alert("입력하신 정보에 해당하는 사용자가 없습니다.");
                    	  
                      } else if (response.code === 400) {
                    	  alert("비정상적인 접근입니다.");
                    	  
                      } else {
                          alert("서버 응답 오류로 인증코드 확인에 실패하였습니다.");
                      }
                  },
                  error: function(error) {
                      alert("서버 응답 오류로 인증코드 확인에 실패하였습니다.");
                      icia.common.error(error);
                  }
              });
          });
          
          $("#find-btn").on("click", function() {
        	  if ($.trim($("#userId").val()).length === 0) {
                  alert("아이디를 입력해주세요.");
                  $("#userId").focus();
                  $("#userId").val("");
                  return;
              }

              if (fn_validateEmpty($("#userId").val())) {
                  alert("아이디는 공백을 포함할수 없습니다.");
                  $("#userId").focus();
                  $("#userId").val("");
                  return;
              }

              if (!fn_validateIdPwd($("#userId").val())) {
                  alert("아이디는 4 ~ 12자의 영문 대소문자와 숫자로만 입력가능합니다.");
                  $("#userId").focus();
                  return;
              }
              
              if ($.trim($("#userEmail").val()).length === 0) {
                  alert("이메일을 입력하세요.");
                  $("#userEmail").val("");
                  $("#userEmail").focus();
                  return;
              }

              if (!fn_validateEmail($("#userEmail").val())) {
                  alert("이메일 형식이 올바르지 않습니다. 다시입력하세요.");
                  $("#userEmail").focus();
                  return;
              }
              
              if (!isVerified) {
                  alert("이메일 인증이 완료되지 않았습니다. 인증을 완료해주세요.");
                  return;
              }
              
              $.ajax({
                  type: "POST",
                  url: "/user/pwdFindProc",
                  data: { 
                	  userId: $("#userId").val(),
                      userEmail: $("#userEmail").val(),
                  },
                  dataType: "JSON",
                  beforeSend: function(xhr) {
                      xhr.setRequestHeader("AJAX", "true");
                  },
                  success: function(response) {
                	  if (response.code === 200) {
                		  alert("메일로 임시 비밀번호가 발급되었습니다.");
                		  location.href = "/";
                		  
                	  } else if (response.code === 500) {
                		  alert("DB 정합성 오류가 발생하였습니다.");
                	  
                	  } else if (response.code === 503) {
                		  alert("메일 서버 오류로 발송에 실패하였습니다.");
                		  
                	  } else if (response.code === 403) {
                		  alert("인증이 완료되지 않았습니다.");
                		  
                	  } else if (response.code === 428) {
                		  alert("인증코드를 발급하지 않았습니다.");
                		  
                	  } else if (response.code === 401) {
                		  alert("이메일 정보가 일치하지 않습니다.");
                		 
                	  } else if (response.code === 404) {
                	      alert("입력하신 정보에 해당하는 사용자가 없습니다.");
                	  
                	  } else if (response.code === 400) {
                	      alert("비정상적인 접근입니다.");
                	  
                	  } else {
                		  alert("서버 응답 오류로 비밀번호 찾기에 실패하였습니다.");
                	  }
                  },
                  error: function(error) {
                      alert("서버 응답 오류로 비밀번호 찾기에 실패하였습니다.");
                      icia.common.error(error);
                  }
              });
              
          });
          
      });
      
      function fn_validateEmail(value) {
          var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
          return emailReg.test(value);
      }

      function fn_validateIdPwd(value) {
          var idPwdCheck = /^[a-zA-Z0-9]{4,12}$/;
          return idPwdCheck.test(value);
      }

      function fn_validateEmpty(value) {
          var emptyCheck = /\s/g;
          return emptyCheck.test(value);
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
      
      <form class="find-id-form" name="findIdForm" id="findIdForm" method="post">
        <div class="input-group">
          <input type="text" id="userId" name="userId" placeholder="아이디">
          <p class="warningText" id="warningId">아이디를 입력하세요.</p>
        </div>
        <div class="input-group" style="display: flex; flex-direction: column; align-items: flex-start;">
          <div style="display: flex; align-items: center; width: 100%;">
            <input type="text" id="userEmail" name="userEmail" placeholder="이메일" style="flex: 1;">
            <button type="button" id="emailAuthNum" class="emailAuthBtn">인증번호 받기</button>
          </div>
          <p class="warningText" id="warningEmail">이메일을 입력하세요.</p>
        </div>
        <div class="input-group" style="display: flex; flex-direction: column; align-items: flex-start;">
          <div style="display: flex; align-items: center; width: 100%;">
            <input type="text" id="authCode" name="authCode" placeholder="인증번호 입력" style="flex: 1;">
            <button type="button" id="emailAuth" class="emailAuthBtn">인증하기</button>
          </div>
          <p id="timerText" style="margin-top: 5px;">남은 시간: 05:00</p>
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