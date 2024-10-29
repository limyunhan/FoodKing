<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html lang="ko">
  <head>
    <%@ include file="/WEB-INF/views/include/head.jsp" %>
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
            $('#passwordModal').data({bbsSeq, bbsPwd}).show();
        }

        function closePasswordModal() {
            $('#passwordModal').hide();
            $('#inputPassword').val('');
        }
    </script>
  </head>
  <body id="index-body">
    <div class="bbs-Main-Page">
      <div class="bbs-Main">
        <%@ include file="/WEB-INF/views/include/navigation.jsp" %>

        <div class="main-container">
          <%@ include file="/WEB-INF/views/leftMainContent.jsp" %>

          <div class="profile-page">
            <!-- Profile Section -->
            <div class="profile-header">
              <div class="profile-picture">
                <img src="/${myPage_user.userImage}" alt="Profile Picture" />
              </div>
              <div class="profile-info">
                <h2>${myPage_user.userName}</h2>
                <p>작성글 <span>${totalUser}</span> · 작성댓글 <span>0</span></p>
              </div>
            </div>

            <!-- Navigation Section -->
            <div class="profile-nav">
              <ul>
                <li><a href="/user/myPage">작성글</a></li>
                <li><a href="userUpdate.jsp">회원정보 수정</a></li>
                <li><a href="javascript:void(0)" onclick="openProfileModal()">프로필 사진 수정</a></li>
              </ul>
            </div>

            <!-- Post Table -->
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
                  <c:forEach var="bbs" items="${myPage_list}">
                    <tr>
                      <td class="post-table_title">
                        <a href="javascript:void(0)"
                           onclick="<c:choose>
                                        <c:when test='${admin_user.userId == myPage_cookieUserId}'>
                                          fn_view(${bbs.bbsSeq});
                                        </c:when>
                                        <c:when test='${not empty bbs.bbsPwd}'>
                                          openPasswordModal(${bbs.bbsSeq}, '${bbs.bbsPwd}');
                                        </c:when>
                                        <c:otherwise>
                                          fn_view(${bbs.bbsSeq});
                                        </c:otherwise>
                                     </c:choose>">
                          <c:choose>
                            <c:when test="${not empty bbs.bbsPwd}">
                              🔑 비밀글 입니다.
                            </c:when>
                            <c:otherwise>
                              ${bbs.bbsTitle}
                            </c:otherwise>
                          </c:choose>
                        </a>
                      </td>
                      <td class="post-table_date">
                        <fmt:formatDate value="${bbs.bbsRegDate}" pattern="YYYY-MM-DD" />
                      </td>
                      <td class="post-table_view">${bbs.bbsReadCnt}</td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>

            <!-- Pagination -->
            <div class="pagination">
              <ul>
                <c:if test="${paging.prevBlockPage > 0}">
                  <li><a href="javascript:void(0)" onclick="fn_list(${paging.prevBlockPage})">이전</a></li>
                </c:if>
                <c:forEach var="page" begin="${paging.startPage}" end="${paging.endPage}">
                  <li><a href="javascript:void(0)" onclick="fn_list(${page})">${page}</a></li>
                </c:forEach>
                <c:if test="${paging.nextBlockPage > 0}">
                  <li><a href="javascript:void(0)" onclick="fn_list(${paging.nextBlockPage})">다음</a></li>
                </c:if>
              </ul>
            </div>
          </div>
        </div>
        <%@ include file="/WEB-INF/views/include/footer.jsp" %>
      </div>
    </div>

    <!-- Forms and Modals -->
    <form name="listForm" id="listForm" method="post">
      <input type="hidden" name="bbsSeq" value="">
      <input type="hidden" name="curPage" value="${curPage}">
    </form>

    <div id="profileModal" class="modal" style="display:none;">
      <div class="modal-content">
        <span class="close" onclick="closeProfileModal()">&times;</span>
        <h2>프로필 사진 수정</h2>
        <form id="profileForm" method="post" enctype="multipart/form-data" action="/user/uploadImg">
          <input type="file" name="profilePicture" accept="image/*">
          <button type="submit">변경</button>
        </form>
      </div>
    </div>

    <div id="passwordModal" style="display:none;">
      <div class="modal-content">
        <h3>비밀번호 입력</h3>
        <input type="password" id="inputPassword" placeholder="비밀번호를 입력하세요">
        <button id="checkPasswordButton">확인</button>
        <button id="closeModalButton">취소</button>
      </div>
    </div>
  </body>
</html>