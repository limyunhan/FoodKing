<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head2.jsp" %>
<script type="text/javascript">
$(document).ready(function() {
    $("#userId").focus();
    
    $("#btnReg").on("click", function () {
        var emptyCheck = /\s/g;
        var idPwdCheck = /^[a-zA-Z0-9]{4,12}$/;
           
        
        if ($.trim($("#userId").val()).length === 0) {
        	alert("사용자 아이디를 입력하세요.");
        	$("#userId").val("");
        	$("#userId").focus();
        	return;
        }
        
        if (emptyCheck.test($("#userId").val())) {
        	alert("아이디는 빈 칸을 포함할 수 없습니다.");
        	$("#userId").val("");
        	$("#userId").focus();
        	return;
        }
        
        if (!idPwdCheck.test($("#userId").val())) {
        	alert("아이디는 4 ~ 12자리의 영문 대소문자, 숫자만 입력가능합니다.");
        	$("#userId").focus();
        	return;
        }
        
        
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
        	alert("비밀번호와 비밀번호확인이 일치하지 않습니다.");
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
        	url: "/user/idCheck2",
        	data: {
        	    userId: $("#userId").val()
        	},
        	dataType: "JSON",
        	beforeSend: function(xhr) {
        		xhr.setRequestHeader("AJAX", "true");
        	}, 
        	success: function(response) {
        	    if (response.code === 404) {
        	    	alert("사용가능한 아이디입니다");
        	        fn_userReg();        	    	
        	    } else if (response.code === 200) {
        	    	alert("중복된 아이디입니다.");
        	    	$("#userId").focus();
        	    } else if (response.code === 400) {
        	    	alert("비정상적인 접근입니다.");
        	    	$("#userId").focus();
        	    } else { 
        	        alert("서버 응답 오류가 발생했습니다.");        	    	
        	    }
        	},
        	complete: function(data) { 
        		icia.common.log(data);
        	},
        	error: function(xhr, status, error) {
        		icia.common.error(error);
        	}
        });
    });
});

function fn_userReg() {
    $.ajax({
    	type: "POST",
    	url: "/user/regProc2",
    	data: {
    		userId: $("#userId").val(),
            userPwd: $("#userPwd").val(),
            userName: $("#userName").val(),
            userEmail: $("#userEmail").val()
    	},
    	dataType: "JSON",
    	beforeSend: function(xhr) {
    		xhr.setRequestHeader("AJAX", "true");
    	},
    	success: function(response) {
    		if (response.code === 201) {
    			alert("회원가입이 완료되었습니다.");
    			location.href = "/index2";
    		} else if(response.code === 500) {
    			alert("회원가입중 오류가 발생하였습니다.");
    		} else if(response.code === 401) {
    			alert("아이디가 중복되어 가입에 실패했습니다.");
    			$("#userId").focus();
    		} else if(response.code === 400) {
    		    alert("비정상적인 접근입니다.");    			
    		} else {
    			alert("서버 응답 오류가 발생했습니다.");
    		}
    	},
    	complete: function(data) {
    	    icia.common.log(data);
    	},
    	error: function(xhr, status, error) {
    		icia.common.error(error);
    	}        
    });
}
    
function fn_validateEmail(value) {
    var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;

    return emailReg.test(value);
}
</script>
</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation2.jsp" %>
  <div class="container">
    <div class="row mt-5">
      <h1>회원가입</h1>
    </div>
    <div class="row mt-2">
      <div class="col-12">
        <form id="regForm" method="post">
          <div class="form-group">
            <label for="userId">사용자 아이디</label> 
            <input type="text" class="form-control" id="userId" name="userId" placeholder="사용자 아이디" maxlength="12">
          </div>
          <div class="form-group">
            <label for="userPwd1">비밀번호</label> 
            <input type="password" class="form-control" id="userPwd1" name="userPwd1" placeholder="비밀번호" maxlength="12">
          </div>
          <div class="form-group">
            <label for="userPwd2">비밀번호 확인</label> 
            <input type="password" class="form-control" id="userPwd2" name="userPwd2" placeholder="비밀번호 확인" maxlength="12">
          </div>
          <div class="form-group">
            <label for="userName">사용자 이름</label> 
            <input type="text" class="form-control" id="userName" name="userName" placeholder="사용자 이름" maxlength="15">
          </div>
          <div class="form-group">
            <label for="userEmail">사용자 이메일</label> 
            <input type="text" class="form-control" id="userEmail" name="userEmail" placeholder="사용자 이메일" maxlength="30">
          </div>
          <button type="button" id="btnReg" class="btn btn-primary">등록</button>
          <input type="hidden" id="userPwd" name="userPwd" value="">
        </form>
      </div>
    </div>
  </div>
</body>
</html>