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
        $("#update-btn").on("click", function() {
            var IdPwdCheck = /^[a-zA-Z0-9]{6,12}$/;
            var emptyCheck = /\s/g;
            var telCheck = /^[0-9]{11}$/;

            if ($.trim($("#userPwd1").val()).length <= 0) {
                alert("비밀번호를 입력하세요.");
                $("#userPwd1").val("");
                $("#userPwd1").focus();
                return;
            }

            if (emptyCheck.test($("#userPwd1").val())) {
                alert("비밀번호는 공백을 포함할 수 없습니다.");
                $("#userPwd1").focus();
                $("#userPwd1").val("");
                return;
            }

            if (!IdPwdCheck.test($("#userPwd1").val())) {
                alert("비밀번호는 4~12자의 영문 대소문자와 숫자로만 입력가능합니다.");
                $("#userPwd1").focus();
                return;
            }

            if ($("#userPwd1").val() != $("#userPwd2").val()) {
                alert("비밀번호가 일치하지 않습니다.");
                $("#userPwd2").val("");
                $("#userPwd2").focus();
                return;
            }

            $("#userPwd").val($("#userPwd1").val());

            if ($.trim($("#userEmail").val()).length <= 0) {
                alert("사용자 이메일을 입력하세요.");
                $("#userEmail").val("");
                $("#userEmail").focus();
                return;
            }

            if (!fn_validateEmail($("#userEmail").val())) {
                alert("사용자 이메일 형식이 올바르지 않습니다. 다시입력하세요.");
                $("#userEmail").focus();
                return;
            }

            if ($.trim($("#userTel").val()).length <= 0) {
                alert("전화번호를 입력하세요.");
                $("#userTel").val("");
                $("#userTel").focus();
                return;
            }

            if (!telCheck.test($("#userTel").val())) {
                alert("전화번호는 숫자로 입력해주세요.");
                $("#userTel").val("");
                $("#userTel").focus();
                return;
            }

            if ($.trim($("#userName").val()).length <= 0) {
                alert("사용자 이름을 입력하세요.");
                $("#userName").val("");
                $("#userName").focus();
                return;
            }

            if ($("#userRegion").val() == "") {
                alert("사는 지역을 선택해주세요.");
                $("#userRegion").focus();
                return;
            }

            if ($("#userFood").val() == "") {
                alert("테마별 음식을 선택해주세요.");
                $("#userFood").focus();
                return;
            }

            document.updateForm.submit();
        });

        $("#cancel-btn").on("click", function() {
            if (confirm("수정을 취소하고 이전 페이지로 돌아가시겠습니까?")) {
                history.back();
            }
        });

        $('#checkPasswordButton').on('click', function() {
            var inputPwd = $('#inputPassword').val();

            var boardPwd = $('#passwordModal').data('boardPwd');

            if (inputPwd == boardPwd) {
                document.pwdForm.inputPassword.val() = inputPwd;
                document.pwdForm.submit();
            }

            else {
                alert('비밀번호가 틀렸습니다.');
            }
            closePasswordModal();
        });

        $('#closeModalButton').on('click', function() {
            closePasswordModal();
        });
    });

    function fn_validateEmail(value) {
        var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;

        return emailReg.test(value);
    }

    function openPasswordModal(boardPwd) {
        $('#passwordModal').data('boardPwd', boardPwd);
        $('#passwordModal').show();
    }

    function closePasswordModal() {
        $('#passwordModal').hide();
        $('#inputPassword').val('');
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
              <label for="userId">아이디:</label> <input type="text"
                id="userId" name="userId" value="" readonly>
            </div>

            <div class="form-group">
              <label for="userEmail">이메일:</label> <input type="text"
                id="userEmail" name="userEmail" value="" required>
            </div>

            <div class="form-group">
              <label for="userPwd1">비밀번호 변경:</label> <input
                type="password" id="userPwd1" name="userPwd1"
                placeholder="새 비밀번호">
            </div>

            <div class="form-group">
              <label for="userPwd2">비밀번호 확인:</label> <input
                type="password" id="userPwd2" name="userPwd2"
                placeholder="비밀번호 확인">
            </div>

            <div class="form-group">
              <label for="userName">이름 변경:</label> <input type="text"
                id="userName" name="userName" value="" placeholder="이름">
            </div>

            <div class="form-group">
              <label for="userTel">전화번호:</label> <input type="text"
                id="userTel" name="userTel" value="">
            </div>

            <div class="form-group">
              <label for="userRegion">주소:</label> <select
                id="userRegion" name="userRegion">
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

            <div class="form-group">
              <label for="userFood">좋아하는 테마별 음식 변경:</label> <select
                id="userFood" name="userFood">
                <option value="">좋아하는 테마별 음식</option>
                <option value="한식">한식</option>
                <option value="중식">중식</option>
                <option value="일식">일식</option>
                <option value="양식">양식</option>
                <option value="간식">간식</option>
              </select>
            </div>


            <!-- Buttons -->
            <div class="form-actions">
              <button type="button" class="update-btn" id="update-btn">수정하기</button>
              <div>
                <button type="button" class="secession-btn"
                  id="secession-btn" onclick="openPasswordModal('')">회원탈퇴</button>
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
  <form name="pwdForm" id="pwdForm" method="post" action="/user/delete">
    <div id="passwordModal" style="display: none;">
      <div class="modal-content">
        <h3>비밀번호 입력</h3>
        <input type="password" id="inputPassword" name="inputPassword"
          placeholder="비밀번호를 입력하세요" />
        <button id="checkPasswordButton">확인</button>
        <button id="closeModalButton">취소</button>
      </div>
    </div>
  </form>
</body>

</html>