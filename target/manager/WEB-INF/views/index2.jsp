<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head2.jsp" %>
<style>
body {
  /* padding-top: 40px; */
  padding-bottom: 40px;
  /* background-color: #eee; */
}

.form-signin {
  max-width: 330px;
  padding: 15px;
  margin: 0 auto;
}

.form-signin .form-signin-heading, .form-signin .checkbox {
  margin-bottom: 10px;
}

.form-signin .checkbox {
  font-weight: 400;
}

.form-signin .form-control {
  position: relative;
  -webkit-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
  height: auto;
  padding: 10px;
  font-size: 16px;
}

.form-signin .form-control:focus {
  z-index: 2;
}

.form-signin input[type="text"] {
  margin-bottom: 5px;
  border-bottom-right-radius: 0;
  border-bottom-left-radius: 0;
}

.form-signin input[type="password"] {
  margin-bottom: 10px;
  border-top-left-radius: 0;
  border-top-right-radius: 0;
}
</style>
<script>
$(document).ready(function() {
	$("#userId").focus();
	$("#userId").on("keypress", function(e) {
		if(e.which === 13) {
			fn_login_check();
		}
	});
	
	$("#userPwd").on("keypress", function(e) {
		if(e.which === 13) {
			fn_login_check();
	    }
	});
	
	$("#btnLogin").on("click", function() {
		fn_login_check();
	});
	
	$("#btnReg").on("click", function() {
	    location.href = "/user/regForm2";		
	});
});

function fn_login_check() {
   if ($.trim($("#userId").val()).length === 0) {
	   alert("아이디를 입력하세요");
	   $("#userId").val("");
	   $("#userId").focus();
	   return;
   }
   
   if ($.trim($("#userPwd").val()).length === 0) {
       alert("비밀번호를 입력하세요");
       $("#userPwd").val("");
       $("#userPwd").focus();
       return;
   }
   
   $.ajax({
	    type: "POST",
	    url: "/user/login2",
	    data: {
	    	userId : $("#userId").val(),
	    	userPwd : $("#userPwd").val()
	    },
	    dataType: "JSON",
	    beforeSend: function(xhr){
	    	xhr.setRequestHeader("AJAX", "true");
	    },
	    success: function(response) {
	    	if (!icia.common.isEmpty(response)) {
	    		var code = icia.common.objectValue(response, "code", -500);
	    	    
	    		if (code === 1) {
	    			alert("로그인에 성공하였습니다.");
	    			location.href = "/index2";
	    		} else if (code === -1) {
	    		    alert("비밀번호가 일치하지 않습니다.");
	    		    $("#userPwd").val("");
	    		    $("#userPwd").focus();
	    		} else if (code === 404) {
                    alert("존재하지 않는 아이디입니다.");
                    $("#userId").val("");
                    $("#userPwd").val("");
                    $("#userId").focus();
                } else if (code === -99) {
                	alert("정지된 사용자 입니다.");
	    		    $("#userId").val("");
	    		    $("#userPwd").val("");
	    		    $("#userId").focus();
	    		} else if (code === 400) {
	    			alert("비정상적인 접근입니다.");
                    $("#userId").val("");
                    $("#userPwd").val("");
                    $("#userId").focus();
	    		} else {
	    			alert("서버 응답 오류가 발생하였습니다.");
	    		}
	    	} else {
	    		alert("서버 응답 오류가 발생하였습니다.");
	    		$("#userId").focus();
	    	}
	    },
	    complete: function(data) {
	    	icia.common.log(data);
	    }, 
	    error: function(xhr, status, error) {
	    	alert("서버 오류가 발생하였습니다.");
	        icia.common.error(error);           
        }
   });
}
</script>
</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation2.jsp" %>
  <div class="container">
    <form class="form-signin">
      <h2 class="form-signin-heading m-b3">로그인</h2>
      <label for="userId" class="sr-only">아이디</label> <input type="text" id="userId" name="userId" class="form-control" maxlength="20" placeholder="아이디"> 
      <label for="userPwd" class="sr-only">비밀번호</label>
      <input type="password" id="userPwd" name="userPwd" class="form-control" maxlength="20" placeholder="비밀번호">
      <button type="button" id="btnLogin" class="btn btn-lg btn-primary btn-block">로그인</button>
      <button type="button" id="btnReg" class="btn btn-lg btn-primary btn-block">회원가입</button>
    </form>
  </div>
</body>
</html>