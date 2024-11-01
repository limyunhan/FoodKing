<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html lang="ko">

<head>
  <%@include file="/WEB-INF/views/include/head.jsp" %>
  <script>
    $(document).ready(function() {
    	$("#user")
    	
    	
    	
    	
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
        
        $('#closeModalButton').on('click', closePasswordModal());
        
        
        
        
        
        
        
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
          <div class="profile-header">
            <div class="profile-picture">
              <c:set var="profileImage" value="${not empty user.userImageName ? user.userImageName + '.' + user.userImageExt : 'defaultProfile.png'}"/>
              <img src="/resources/profile/${profileImage}" alt="프로필 사진" class="profile-image">
            </div>
            <div class="profile-info">
              <h2>${user.userName}</h2>
              <p>
                작성글 <span><fmt:formatNumber type="Number" maxFractionDigits="3" groupingUsed="true" value="${user.userBbsCnt}" /></span> / 작성댓글 <span><fmt:formatNumber type="Number" maxFractionDigits="3" groupingUsed="true" value="${user.userComCnt}" /></span>
              </p>
            </div>
          </div>
          <div class="profile-nav">
            <ul>
              <li><a href="/user/myPage">작성글</a></li>
              <li><a href="/user/update">회원정보 수정</a></li>
              <li><a href="javascript:void(0)" onclick="openProfileModal()">프로필 사진 수정</a></li>
            </ul>
          </div>
          <div class="post-table">
            <table>
              <thead>
                <tr>
                  <th>제목</th>
                  <th>작성일</th>
                  <th>조회수</th>
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
    <input type="hidden" name="bbsSeq" value="">
    <input type="hidden" name="curPage" value="">
  </form>
  
  <!-- 모달 창 HTML -->
  <div id="profileModal" style="display:none;">
    <div class="modal-content">
      <span class="close" onclick="closeProfileModal()">&times;</span>
      <h2>프로필 사진 수정</h2>
      <form id="profileForm" method="post" enctype="multipart/form-data" action="/user/updateImage">
        <input type="file" name="userImage" accept="image/*">
        <button id="checkImageButton">변경</button>
      </form>
    </div>
  </div>

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