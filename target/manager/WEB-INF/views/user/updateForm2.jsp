<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head2.jsp"%>
<script type="text/javascript">
$(document).ready(function() {
    $("#btnUpdate").on("click", function() {
    	var emptyCheck = /\s/g;
    	var idPwdCheck = /^[A-Za-z0-9]{4,12}$/;
    	
    	if ($.trim($("#userPwd1").val()).length === 0) {
    		alert("사용자 비밀번호를 입력하세요.");
    		$("#userPwd1").val("");
    		$("#userPwd1").focus();
    		return;
    	}
    	
    	if (emptyCheck.test($("#userPwd1").val())) {
    		alert("비밀번호는 빈 칸을 포함할 수 없습니다.");
    		$("#userPwd1").val("");
    		$("#userPwd1").focus();
    		return;
    	}
    	
    	if (!idPwdCheck.test($("#userPwd1").val())) {
    		alert("비밀번호는 4 ~ 12자리의 영문 대소문자, 숫자만 입력가능합니다.");
    		$("#userPwd1").val("");
    		$("#userPwd1").focus();
    		return;
    	}
    	
        if ($.trim($("#userPwd2").val()).length === 0) {
            alert("비밀번호 확인을 입력하세요.");
            $("#userPwd1").val("");
            $("#userPwd1").focus();
            return;
        }
        
        if ($("#userPwd1").val() !== $("#userPwd2").val()) {
        	alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
        	$("#userPwd2").val("");
        	$("#userPwd2").focus();
        	return;
        }
        
        $("#userPwd").val($("#userPwd1").val());
    	
        if ($.trim($("#userName").val()).length === 0) {
            alert("사용자 이름을 입력하세요.");
            $("#userName").val("");
            $("#userName").focus();
            return;
        }    	
   
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
        
        $.ajax({
            type: "POST",
            url: "/user/updateProc2",
            data: {
            	userId: $("#userId").val(),
            	userPwd: $("#userPwd").val(),
            	userName: $("#userName").val(),
            	userEmail: $("#userEmail").val(),
            },
            dataType: "JSON",
            beforeSend: function(xhr) {
            	xhr.setRequestHeader("AJAX", "true");
            },
            success: function(response) {
            	if (response.code === 200) {
            		alert("회원 정보가 업데이트되었습니다.");
            		location.href = "/user/updateForm2";
            	} else if (response.code === 500) {
            		alert("회원 정보 업데이트중 문제가 발생하였습니다.");
            	} else if (response.code === 430) {
            	    alert("아이디 정보가 일치하지 않습니다.");
            	    location.href = "/index2"
            	} else if (response.code === 400) {
            		alert("비정상적인 접근입니다.");
            		$("#userPwd1").focus();
            	} else {
            		alert("서버 응답 오류가 발생하였습니다.");
            	}
            }, 
            complete: function(data) {
            	icia.common.log(data)
            },
            error: function(xhr, status, error) {
                icia.common.error(error);            	
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

<!-- 컨트롤러에서 항상 model을 설정해주고 이 페이지로 넘어오기 때문에 user를 쓰는 것이 굉장히 편하다 -->
<body>
  <%@ include file="/WEB-INF/views/include/navigation2.jsp"%>
  <div class="container">
    <div class="row mt-5">
      <h1>회원정보수정</h1>
    </div>
    <div class="row mt-2">
      <div class="col-12">
        <form>
          <div class="form-group">사용자 아이디 ${user.userId}</div>
          <div class="form-group">
            <label for="userPwd1">비밀번호</label> <input type="password" class="form-control" id="userPwd1" name="userPwd1" value="${user.userPwd}" placeholder="비밀번호" maxlength="12">
          </div>
          <div class="form-group">
            <label for="userPwd2">비밀번호 확인</label> <input type="password" class="form-control" id="userPwd2" name="userPwd2" value="${user.userPwd}" placeholder="비밀번호 확인" maxlength="12">
          </div>
          <div class="form-group">
            <label for="userName">사용자 이름</label> 
            <input type="text" class="form-control" id="userName" name="userName" value="${user.userName}" placeholder="사용자 이름" maxlength="15">
          </div>
          <div class="form-group">
            <label for="userEmail">사용자 이메일</label> 
            <input type="text" class="form-control" id="userEmail" name="userEmail" value="${user.userEmail}" placeholder="사용자 이메일" maxlength="30">
          </div>
          <input type="hidden" id="userId" name="userId" value="${user.userId}"> 
          <input type="hidden" id="userPwd" name="userPwd" value="${user.userPwd}">
          <button type="button" id="btnUpdate" class="btn btn-primary">수정</button>
        </form>
      </div>
    </div>
  </div>
</body>