<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<%@include file="/WEB-INF/views/include/head.jsp"%>
<script>
    $(document).ready(function() {
    	$("#userPwd1").focus();
    	
    	$("#userPwd1").on("input", function() {
            var userPwd1 = $.trim($("#userPwd1").val());

            if (userPwd1.length === 0) {
                $("#warningPwd1").text("비밀번호를 입력하세요.");

            } else if (fn_validateEmpty(userPwd1)) {
                $("#warningPwd1").text("비밀번호는 공백을 포함할수 없습니다.");

            } else if (!fn_validateIdPwd(userPwd1)) {
                $("#warningPwd1").text("비밀번호는 4 ~ 12자 영문 대소문자와 숫자로만 입력가능합니다.");

            } else {
                $("#warningPwd1").text("");
            }
            
            if ($.trim($("#userPwd2").val()) !== userPwd1) {
                $("#warningPwd2").text("비밀번호와 비밀번호 확인이 일치하지 않습니다.").css("color", "red");;
            } else {
            	$("#warningPwd2").text("비밀번호 일치").css("color", "blue");
            }
        });
        
        $("#userPwd2").on("input", function() {
            var userPwd2 = $.trim($("#userPwd2").val());

            if (userPwd2.length === 0) {
                $("#warningPwd2").text("비밀번호 확인을 입력하세요.").css("color", "red");

            } else if (userPwd2 !== $("#userPwd1").val()) {
                $("#warningPwd2").text("비밀번호와 비밀번호 확인이 일치하지 않습니다.").css("color", "red");

            } else {
                $("#warningPwd2").text("비밀번호 일치").css("color", "blue");
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
        
        $("#userTel").on("input", function() {
            var userTel = $.trim($("#userTel").val());

            if (userTel.length === 0) {
                $("#warningTel").text("전화번호를 입력하세요.");

            } else if (!fn_validateTel(userTel)) {
                $("#warningTel").text("전화번호는 11자리 숫자로 입력해주세요.");

            } else {
                $("#warningTel").text("");
            }
        });
    	
        $("#userName").on("input", function() {
            var userName = $.trim($("#userName").val());
            
            if (userName.length === 0) {
                $("#warningName").text("이름을 입력하세요.");
            } else {
                $("#warningName").text("");
            }
        });
        
        $("#update-btn").on("click", function() {
        	if ($.trim($("#userPwd1").val()).length === 0) {
                alert("비밀번호를 입력하세요.");
                $("#userPwd1").val("");
                $("#userPwd1").focus();
                return;
            }

            if (fn_validateEmpty($("#userPwd1").val())) {
                alert("비밀번호는 공백을 포함할 수 없습니다.");
                $("#userPwd1").val("");
                $("#userPwd1").focus();
            }

            if (!fn_validateIdPwd($("#userPwd1").val())) {
                alert("비밀번호는 4 ~ 12자의 영문 대소문자와 숫자로만 입력가능합니다.");
                $("#userPwd1").focus();
                return;
            }

            if ($.trim($("#userPwd2").val()).length === 0) {
                alert("비밀번호 확인을 입력하세요.");
                $("#userPwd2").val("");
                $("#userPwd2").focus();
                return;
            }
            
            if ($("#userPwd1").val() !== $("#userPwd2").val()) {
                alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
                $("#userPwd2").val("");
                $("#userPwd2").focus();
                return;
            }

            $("#userPwd").val($("#userPwd1").val());

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

            if ($.trim($("#userTel").val()).length === 0) {
                alert("전화번호를 입력하세요.");
                $("#userTel").val("");
                $("#userTel").focus();
                return;
            }

            if (!fn_validateTel($("#userTel").val())) {
                alert("전화번호는 11자리 숫자로 입력해주세요.");
                $("#userTel").focus();
                return;
            }

            if ($.trim($("#userName").val()).length === 0) {
                alert("이름을 입력하세요.");
                $("#userName").val("");
                $("#userName").focus();
                return;
            }
            
            if ($("#userGender").val() === "") {
                alert("성별을 선택해주세요.");
                $("#userGender").focus();
                return;
            }

            if ($("#userRegion").val() === "") {
                alert("사는 지역을 선택해주세요.");
                $("#userRegion").focus();
                return;
            }

            if ($("#userFood").val() === "") {
                alert("테마별 음식을 선택해주세요.");
                $("#userFood").focus();
                return;
            }

            var form = $("#updateForm")[0];
            var formData = new FormData(form);
            
            $.ajax({
                type: "POST",
                url: "/user/updateProc",
                data: formData,
                dataType: "JSON",
                contentType: false,
                processData: false, 
                cache: false,
                beforeSend: function(xhr) {
                    xhr.setRequestHeader("AJAX", "true");
                },
                success: function(response) {
                	if (response.code === 200) {
                		alert("정보가 수정되었습니다.");
                		location.href = "/user/update";
                		
                	} else if (response.code === 500) {
                		alert("DB 정합성 오류가 발생하였습니다.");
                		
                	} else if (response.code === 404) {
                		alert("존재하지 않는 사용자 입니다.");
                		location.href = "/";
                		
                	} else if (response.code === 400) {
                		alert("비정상적인 접근입니다.");
                		
                	} else {
                		alert("서버 응답 오류로 정보 수정에 실패하였습니다.");
                	}
                },
                error: function(error) {
                    alert("서버 응답 오류로 정보 수정에 실패하였습니다.");
                    icia.common.error(error);
                }
            });
        });

        $("#cancel-btn").on("click", function() {
            if (confirm("수정을 취소하고 이전 페이지로 돌아가시겠습니까?")) {
                history.back();
            }
        });
        
        $("#checkPasswordButton").on("click", function() {
        	if ($.trim($("#inputPassword").val()).length === 0) {
        		alert("비밀번호를 입력하세요");
        		return;
        	}
        	
            if (confirm("정말로 탈퇴하시겠습니까?")) {
            	$.ajax({
            		type: "POST",
            		url: "/user/delete",
            		data: {
            		    userPwd: $("#inputPassword").val()
            		},
            		dataType: "JSON",
            		beforeSend: function(xhr) {
            			xhr.setRequestHeader("AJAX", "true");
            		},
            		success: function(response) {
            			if (response.code === 200) {
            				alert("회원 탈퇴가 완료되었습니다.");
            				location.href = "/";
            				
            			} else if (response.code === 500) {
            				alert("DB 정합성 오류가 발생하였습니다.");
            				
            			} else if (response.code === 401) {
            				alert("비밀번호가 일치하지 않습니다.");
            				
            			} else if (response.code === 404) {
            				alert("존재하지 않는 사용자 입니다.");
            				location.href = "/";
            				
            			} else if (response.code === 400) {
            				alert("비정상적인 접근입니다.")
            				
            			} else {
            				alert("서버 응답 오류로 회원 탈퇴에 실패하였습니다.");
            			}
            		},
            		error: function(error) {
            			alert("서버 응답 오류로 회원 탈퇴에 실패하였습니다.");
            		}
            	});
            }
        });
    });

    function openPasswordModal(boardPwd) {
        $('#passwordModal').show();
    }

    function closePasswordModal() {
        $('#passwordModal').hide();
        $('#inputPassword').val('');
    }
       
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

    function fn_validateTel(value) {
        var telCheck = /^[0-9]{11}$/;
        return telCheck.test(value);
    }  
</script>
</head>
<body id="index-body">
  <div class="Board-Main-Page">
    <div class="Board-Main">
      <%@include file="/WEB-INF/views/include/navigation.jsp"%>

      <div class="main-contanier">
        <%@include file="/WEB-INF/views/leftMainContent.jsp"%>
        <div class="profile-update-page">
          <!-- Header -->
          <div class="update-header">
            <h1>회원정보 수정</h1>
          </div>

          <!-- Profile Update Form -->
          <form class="profile-form" name="updateForm" id="updateForm">
            <div class="form-group">
              <label for="userId">아이디:</label> 
              <input type="text"id="userId" name="userId" value="${user.userId}" readonly>
            </div>

            <div class="form-group">
              <label for="userPwd1">비밀번호 변경:</label> 
              <input type="password" id="userPwd1" name="userPwd1" value="${user.userPwd}" placeholder="새 비밀번호">
              <p class="warningText" id="warningPwd1"></p>
            </div>

            <div class="form-group">
              <label for="userPwd2">비밀번호 확인:</label> 
              <input type="password" id="userPwd2" name="userPwd2" value="${user.userPwd}" placeholder="비밀번호 확인" >
              <p class="warningText" id="warningPwd2"></p>
            </div>
            
            <div class="form-group">
              <label for="userEmail">이메일:</label> 
              <input type="text"id="userEmail" name="userEmail" value="${user.userEmail}" placeholder="이메일">
              <p class="warningText" id="warningEmail"></p>
            </div>
            
            <div class="form-group">
              <label for="userTel">전화번호:</label> 
              <input type="text" id="userTel" name="userTel" value="${user.userTel}" placeholder="전화번호">
              <p class="warningText" id="warningTel"></p>
            </div>

            <div class="form-group">
              <label for="userName">이름 변경:</label> 
              <input type="text" id="userName" name="userName" value="${user.userName}" placeholder="이름">
              <p class="warningText" id="warningName"></p>
            </div>
            <div class="form-group">
              <label for="userRegion">주소:</label> 
              <select id="userRegion" name="userRegion">
                <option value="">사는 지역</option>
                <option value="서울" <c:if test="${user.userRegion == '서울'}">selected</c:if>>서울</option>
                <option value="경기도" <c:if test="${user.userRegion == '경기도'}">selected</c:if>>경기도</option>
                <option value="강원도" <c:if test="${user.userRegion == '강원도'}">selected</c:if>>강원도</option>
                <option value="충정도" <c:if test="${user.userRegion == '충청도'}">selected</c:if>>충정도</option>
                <option value="전라도" <c:if test="${user.userRegion == '전라도'}">selected</c:if>>전라도</option>
                <option value="경상도" <c:if test="${user.userRegion == '경상도'}">selected</c:if>>경상도</option>
                <option value="제주도" <c:if test="${user.userRegion == '제주도'}">selected</c:if>>제주도</option>
              </select>
            </div>
            <div class="form-group">
              <label for="userFood">좋아하는 테마별 음식 변경:</label> 
              <select id="userFood" name="userFood">
                <option value="">좋아하는 테마별 음식</option>
                <option value="한식" <c:if test="${user.userFood == '한식'}">selected</c:if>>한식</option>
                <option value="중식" <c:if test="${user.userFood == '중식'}">selected</c:if>>중식</option>
                <option value="일식" <c:if test="${user.userFood == '일식'}">selected</c:if>>일식</option>
                <option value="양식" <c:if test="${user.userFood == '양식'}">selected</c:if>>양식</option>
                <option value="간식" <c:if test="${user.userFood == '간식'}">selected</c:if>>간식</option>
              </select>
            </div>

            <!-- Buttons -->
            <div class="form-actions">
              <button type="button" class="update-btn" id="update-btn">수정하기</button>
              <div>
                <button type="button" class="secession-btn" id="secession-btn" onclick="openPasswordModal('')">회원탈퇴</button>
                <button type="button" class="cancel-btn" id="cancel-btn">취소</button>
              </div>
            </div>
            <input type="hidden" id="userPwd" name="userPwd" value="">
          </form>
        </div>
      </div>
      <%@ include file="/WEB-INF/views/include/footer.jsp"%>
    </div>
  </div>
  
  <!-- 비밀번호 모달 -->
  <div id="passwordModal" style="display:none;">
    <div class="modal-content">
      <span class="close" onclick="closePasswordModal()">&times;</span>
      <h3>비밀번호 입력</h3>
      <input type="password" id="inputPassword" placeholder="비밀번호를 입력하세요" />
      <button id="checkPasswordButton">확인</button>
    </div>
  </div>
</body>
</html>