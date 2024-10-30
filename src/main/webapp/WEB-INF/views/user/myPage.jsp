<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html lang="ko">

<head>
  <%@include file="/WEB-INF/views/include/head.jsp" %>
  <script>
    $(document).ready(function() {
        $('#checkPasswordButton').on('click', function() {
            var inputPwd = $('#inputPassword').val();
            var bbsPwd = $('#passwordModal').data('bbsPwd');
            var bbsSeq = $('#passwordModal').data('bbsSeq');

            if (inputPwd === bbsPwd) {
                fn_view(bbsSeq);
            } else {
                alert('비밀번호가 틀렸습니다.');
            }
            closePasswordModal();
        });

        $('#closeModalButton').on('click', closePasswordModal);
    });

    function fn_list(curPage) {
        document.listForm.curPage.value = curPage;
        document.listForm.action = "/user/myPage";
        document.listForm.submit();
    }

    function fn_view(bbsSeq) {
        document.listForm.bbsSeq.value = bbsSeq;
        document.listForm.action = "/bbs/viewContent";
        document.listForm.submit();
    }

    function openProfileModal() {
        $('#profileModal').show();
    }

    function closeProfileModal() {
        $('#profileModal').hide();
    }

    function openPasswordModal(bbsSeq, bbsPwd) {
        $('#passwordModal').data({ bbsSeq, bbsPwd }).show();
    }

    function closePasswordModal() {
        $('#passwordModal').hide();
        $('#inputPassword').val('');
    }
  </script>
</head>
<script>

</script>

<body id="index-body">
  <div class="Board-Main-Page">
    <div class="Board-Main">
      <%@include file="/WEB-INF/views/include/navigation.jsp"%>

      <div class="main-contanier">
        <%@include file="/WEB-INF/views/leftMainContent.jsp"%>
        <div class="profile-page">
          <!-- User Profile Section -->
          <div class="profile-header">
            <div class="profile-picture">
              <img src="/" alt="ProfilePicture" />
            </div>
            <div class="profile-info">
              <h2></h2>
              <p>
                작성글 <span>0</span> · 작성댓글 <span>0</span>
              </p>
            </div>
          </div>

          <!-- Navigation Section -->
          <div class="profile-nav">
            <ul>
              <li><a href="/user/myPage">작성글</a></li>
              <li><a href="/user/update">회원정보 수정</a></li>
              <!-- 프로필 사진 수정 -->
              <li><a href="javascript:void(0)" onclick="openProfileModal()">프로필 사진 수정</a></li>
            </ul>
          </div>

          <!-- Table Section -->
          <div class="post-table">
            <table>
              <thead>
                <tr>
                  <th>제목</th>
                  <th>작성일</th>
                  <th>조회</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td class="post-table_title"><a href="javascript:void(0)"
                      onclick="fn_view();openPasswordModal(, ''); fn_view();"></a></td>
                  <td class="post-table_date"></td>
                  <td class="post-table_view"></td>
                </tr>
              </tbody>
            </table>
          </div>
          <div class="pagination">
            <ul>
              <li><a href="javascript:void(0)" onclick="fn_list()">이전</a></li>
              <li><a href="javascript:void(0)" onclick="fn_list()"></a></li>
              <li><a href="javascript:void(0)" onclick="fn_list()"></a></li>
              <li><a href="javascript:void(0)" onclick="fn_list()">다음</a></li>
            </ul>
          </div>
        </div>
      </div>
      <%@ include file="/WEB-INF/views/include/footer.jsp"%>
    </div>
  </div>

  <form name="listForm" id="listForm" method="post">
    <input type="hidden" name="boardSeq" value="">
    <input type="hidden" name="curPage" value="">
  </form>
  
  <!-- 모달 창 HTML -->
  <div id="profileModal" class="modal" style="display:none;">
    <div class="modal-content">
      <span class="close" onclick="closeProfileModal()">&times;</span>
      <h2>프로필 사진 수정</h2>
      <form id="profileForm" method="post" enctype="multipart/form-data" action="/user/profile">
        <input type="file" name="profilePicture" accept="image/*">
        <button type="submit">변경</button>
      </form>
    </div>
  </div>

  <div id="passwordModal" style="display:none;">
    <div class="modal-content">
      <h3>비밀번호 입력</h3>
      <input type="password" id="inputPassword" placeholder="비밀번호를 입력하세요" />
      <button id="checkPasswordButton">확인</button>
      <button id="closeModalButton">취소</button>
    </div>
  </div>
</body>
</html>