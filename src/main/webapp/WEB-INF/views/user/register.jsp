<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>

<html lang="ko">
<head>
  <%@include file="/WEB-INF/views/include/head.jsp"%>
  <script>
    $(document).ready(function() {
    	var isUserIdChecked = false;
    	
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
            } else{
            	$("#warningPwd2").text("비밀번호 일치").css("color", "blue");
            }
        });
        
        $("#userPwd2").on("input", function() {
            var userPwd2 = $.trim($("#userPwd2").val());

            if (userPwd2.length === 0) {
                $("#warningPwd2").text("비밀번호 확인을 입력하세요.").css("color", "red");;

            } else if (userPwd2 !== $("#userPwd1").val()) {
                $("#warningPwd2").text("비밀번호와 비밀번호 확인이 일치하지 않습니다.").css("color", "red");;

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

        $("#userImage").on("change", function() {
            var fileName = this.files[0] ? this.files[0].name : "선택된 이미지 없음";
            $("#fileName").text(fileName);

            if (this.files && this.files[0]) {
                var fileType = this.files[0].type; 
                var fileSize = this.files[0].size; 

                if (!fileType.match('image.*')) {
                    alert("이미지 파일만 업로드할 수 있습니다.");
                    $(this).val(""); 
                    $("#fileName").text("선택된 이미지 없음"); 
                    $("#imagePreview").attr("src", "/resources/profile/defaultProfile.jpg");
                    return;
                }

                if (fileSize > 5 * 1024 * 1024) { 
                    alert("파일 크기는 5MB 이하로 설정해야 합니다.");
                    $(this).val(""); 
                    $("#fileName").text("선택된 이미지 없음"); 
                    $("#imagePreview").attr("src", "/resources/profile/defaultProfile.jpg");
                    return;
                }

                var reader = new FileReader();
                reader.onload = function(e) {
                    $("#imagePreview").attr("src", e.target.result).show();  
                }
                reader.readAsDataURL(this.files[0]);  
            } else {
                $("#fileName").text("선택된 이미지 없음"); 
                $("#imagePreview").attr("src", "/resources/profile/defaultProfile.jpg");
            }
        });

        $("#id-btn").on("click", function() {
            var userId = $.trim($("#userId").val());

            if (userId.length === 0) {
                alert("아이디를 입력해주세요.");
                $("#userId").focus();
                $("#userId").val("");
                return;
            }

            if (fn_validateEmpty(userId)) {
                alert("아이디는 공백을 포함할수 없습니다.");
                $("#userId").focus();
                $("#userId").val("");
                return;
            }

            if (!fn_validateIdPwd(userId)) {
                alert("아이디는 4 ~ 12자의 영문 대소문자와 숫자로만 입력가능합니다.");
                $("#userId").focus();
                return;
            }
            
            $.ajax({
                type: "POST",
                url: "/user/idCheck",
                data: {
                    userId: $("#userId").val() 
                },
                dataType: "JSON",
                beforeSend: function(xhr) {
                    xhr.setRequestHeader("AJAX", "true");               
                },
                success : function(response){
                    if (response.code === 200) {
                        $("#warningId").text("사용 가능한 아이디입니다.").css("color", "blue");
                        $("#userId").attr("readonly", true);
                        $("#id-btn").prop("disabled", true);
                        isUserIdChecked = true;
                    } else if (response.code === 409) {
                        $("#warningId").text("이미 사용중인 아이디입니다.");
                        $("#userId").focus();

                    } else if (response.code === 400) {
                        $("#warningId").text("아이디가 정상적으로 입력되지 않았습니다.");
                        $("#userId").focus();

                    } else {
                        alert("서버 응답 오류 또는 네트워크 오류가 발생했습니다.");
                    }
                },
                error : function(error) {
                    alert("서버 응답 오류 또는 네트워크 오류가 발생했습니다.");
                    icia.common.error(error);
                }
            });
        });

        $("#signup-btn").on("click", function() {
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
            
            if (!isUserIdChecked) {
            	alert("아이디 중복체크를 진행해주세요.");
            	$("#id-btn").focus();
            	return;
            }
        	
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

            var form = $("#regForm")[0];
            var formData = new FormData(form);

            $.ajax({
                type: "POST",
                url: "/user/registerProc",
                enctype: "multipart/form-data",
                data: formData,
                contentType: false,
                processData: false,
                cache: false,
                beforeSend: function(xhr) {
                    xhr.setRequestHeader("AJAX", "true");
                },
                success: function(response) {
                    if (response.code === 200) {
                        alert("회원가입이 완료되었습니다.");
                        location.href = "/index";

                    } else if (response.code === 500) {
                        alert("DB 정합성 오류가 발생하였습니다.");

                    } else if (response.code === 409) {
                        alert("중복된 아이디입니다.");
                        locaion.href = "/user/regForm";
                    } else if (response.code === 400) {
                        alert("비정상적인 접근입니다.");

                    } else if (response.code === 412) {
                        alert("아이디 중복체크를 해주세요.");

                    } else {
                        alert("서버 응답 오류 또는 네트워크 오류가 발생했습니다.");
                    }
                },
                error: function(error) {
                    alert("서버 응답 오류 또는 네트워크 오류가 발생했습니다.");
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

    function fn_validateTel(value) {
        var telCheck = /^[0-9]{11}$/;
        return telCheck.test(value);
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
        <div class="input-group" style="display: flex; flex-direction: column; align-items: flex-start;">
          <div style="display: flex; align-items: center; width: 100%;">
            <input type="text" id="userId" name="userId" placeholder="아이디" style="flex: 1;">
            <button type="button" class="id-btn" id="id-btn" style="background-color: #f2b048; border: none; border-radius: 8px; margin-left: 5px; margin-top: 5px; width: 60px; height: 45px;">
                중복 체크
            </button>
          </div>
          <p class="warningText" id="warningId">아이디를 입력하세요.</p>
        </div>
        
        <div class="input-group">
          <input type="password" id="userPwd1" name="userPwd1" placeholder="비밀번호">
          <p class="warningText" id="warningPwd1">비밀번호를 입력하세요.</p>
        </div>
        <div class="input-group">
          <input type="password" id="userPwd2" name="userPwd2" placeholder="비밀번호 확인">
          <p class="warningText" id="warningPwd2">비밀번호 확인을 입력하세요.</p>
        </div>
        <div class="input-group">
          <input type="text" id="userEmail" name="userEmail" placeholder="이메일">
          <p class="warningText" id="warningEmail">이메일을 입력하세요.</p>
        </div>
        <div class="input-group">
          <input type="text" id="userTel" name="userTel" placeholder="전화번호">
          <p class="warningText" id="warningTel">전화번호를 입력하세요.</p>
        </div>
        <div class="input-group">
          <input type="text" id="userName" name="userName" placeholder="이름">
          <p class="warningText" id="warningName">이름을 입력하세요.</p>
        </div>
        <div class="input-group">
          <select id="userGender" name="userGender">
            <option value="">성별</option>
            <option value="M">남성</option>
            <option value="F">여성</option>
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
        <div id="profileBox" style="width: 120px; height: 120px; border: 5px solid #F2B048; border-radius: 50%; box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2); display: flex; align-items: center; justify-content: center; background-color: #f8f9fa; overflow: hidden;">
          <img id="imagePreview" src="/resources/profile/defaultProfile.png" alt="Profile Image" style="width: 100%; height: 100%; object-fit: cover; border-radius: 10px;">
        </div>
        <div class="input-group" style="display: flex; align-items: center;">
          <label for="userImage" class="custom-file-upload" style="white-space: nowrap;">이미지 선택</label>
          <span class="file-name" id="fileName">선택된 이미지 없음</span>
          <input type="file" id="userImage" name="userImage">
        </div>
        <button type="button" class="signup-btn" id="signup-btn">회원가입</button>
        <input type="hidden" name="userPwd" id="userPwd" value="">
      </form>
    </div>
  </div>
</body>
</html>