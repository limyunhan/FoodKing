<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<%@include file="/WEB-INF/views/include/head.jsp" %>
<script>
$(document).ready(function() {
	$("#checkPasswordButton").on("click", function() {
        var inputPwd = $("#inputPassword").val();
        var bbsPwd = $("#passwordModal").data("bbsPwd");
        var bbsSeq = $("#passwordModal").data("bbsSeq");
  
        if (inputPwd === bbsPwd) {
            fn_view(bbsSeq);
          
        } else {
            alert("비밀번호가 틀렸습니다.");
        }
    });
  
    $("#btnSearch").on("click", function() {
        document.bbsForm.searchType.value = $("#_searchType").val();
        document.bbsForm.searchValue.value = $("#_searchValue").val();
        document.bbsForm.periodFilter.value = $("#_periodFilter").val();
        document.bbsForm.bbsCurPage.value = "1";
        document.bbsForm.action = "/bbs/list<c:if test="${!empty cateNum}">?cateNum=${cateNum}</c:if>";
        document.bbsForm.submit();
    });

    $("#_searchType").on("change", function() {
        $("#_searchValue").val("");
        $("#_searchValue").focus();
    });
    
    $("#checkImageButton").on("click", function() {
        var form = $("#profileForm")[0];
        var formData = new FormData(form);
    	
        $.ajax({
            type: "POST",
            enctype: "multipart/form-data",
            url: "/bbs/updateImage",
            data: formData,
            processData: false,
            contentType: false,
            cache: false,
            beforeSend: function(xhr) {
                xhr.setRequestHeader("AJAX", "true");
            },
            success: function(response) {
                if (response.code === 200) {
                    alert("프로필 사진을 업데이트 하였습니다.");
                    location.href = "/user/myPage";
                    
                } else if (response.code === 500) {
                    alert("DB정합성 오류 입니다.");            
                    
                } else if (response.code === 404) {
                	alert("존재하지 않는 사용자 입니다.");
                	
                } else if (response.code === 400) {
                    alert("비정상적인 접근입니다.");
                    
                }  else {
                    alert("서버 응답 오류로 프로필 사진 수정에 실패하였습니다.");
                }
                
            },
            error: function(error) {
                alert("서버 응답 오류로 프로필 사진 수정에 실패하였습니다.");
                icia.common.error(error);
            }
        });
    });
});
    
function fn_view(bbsSeq) {
    document.bbsForm.bbsSeq.value = bbsSeq;
    document.bbsForm.action = "/bbs/view";
    document.bbsForm.submit();
}

function fn_list(bbsCurPage) {
    document.bbsForm.bbsCurPage.value = bbsCurPage;
    document.bbsForm.action = "/user/myPage";
    document.bbsForm.submit();
}

function fn_myPage(myPage) {
	document.bbsForm.myPage.value = myPage;
	document.bbsForm.bbsCurPage.value = "1";
	document.bbsForm.action = "/user/myPage";
	document.bbsForm.submit();
}

function openProfileModal() {
    $("#profileModal").show();
}

function closeProfileModal() {
    $("#profileModal").hide();
}

function openPasswordModal(bbsSeq, bbsPwd) {
    $("#passwordModal").data("bbsSeq", bbsSeq); 
    $("#passwordModal").data("bbsPwd", bbsPwd); 
    $("#passwordModal").show();
}

function closePasswordModal() {
    $("#passwordModal").hide();
    $("#inputPassword").val(""); 
}
  </script>
</head>
<body id="index-body">
  <div class="Board-Main-Page">
    <div class="Board-Main">
      <%@include file="/WEB-INF/views/include/navigation.jsp"%>
      <div class="main-contanier">
        <%@include file="/WEB-INF/views/leftMainContent.jsp"%>
        <div class="profile-page">
        
          <div class="profile-header">
            <div class="profile-picture">
              <c:set var="profileImage" value="${not empty user.userImageName ? user.userImageName : 'defaultProfile.png'}"/>
              <img src="/resources/profile/${profileImage}" alt="프로필 사진" class="profile-image">
            </div>
            <div class="profile-info">
              <h2>${user.userName}</h2>
              <p>작성글 <span><fmt:formatNumber type="Number" maxFractionDigits="3" groupingUsed="true" value="${user.userBbsCnt}" /></span> / 작성댓글 <span><fmt:formatNumber type="Number" maxFractionDigits="3" groupingUsed="true" value="${user.userComCnt}" /></span></p>
            </div>
          </div>
          
          <div class="profile-nav">
            <ul>
              <li><a href="javascript:void(0)" <c:if test="${myPage == '1'}">class="active"</c:if> onclick="fn_myPage(1)"><i class="fas fa-pencil-alt"></i> 작성글</a></li>
              <li><a href="javascript:void(0)" <c:if test="${myPage == '2'}">class="active"</c:if> onclick="fn_myPage(2)"><i class="fas fa-thumbs-up"></i> 추천한 게시글</a></li>
              <li><a href="javascript:void(0)" <c:if test="${myPage == '3'}">class="active"</c:if> onclick="fn_myPage(3)"><i class="fas fa-bookmark"></i> 북마크한 게시글</a></li>
              <li><a href="/user/update"><i class="fas fa-user-edit"></i> 회원정보 수정</a></li>
              <li><a href="javascript:void(0)" onclick="openProfileModal()"><i class="fas fa-camera"></i> 프로필 사진 수정</a></li>
            </ul>
          </div>
          
          <div class="post-table">
            <table>
              <thead>
                <tr>
                  <th scope="col" class="text-center" style="width: 8%">북마크</th>
                  <th scope="col" class="text-center" style="width: 5%">번호</th>
                  <th scope="col" class="text-center" style="width: 21%">카테고리</th>
                  <th scope="col" class="text-center" style="width: 30%">제목</th>
                  <th scope="col" class="text-center" style="width: 6%">작성자</th>
                  <th scope="col" class="text-center" style="width: 20%">작성일</th>
                  <th scope="col" class="text-center" style="width: 5%">조회</th>
                  <th scope="col" class="text-center" style="width: 5%">추천</th>
                </tr>
              </thead>
              <tbody>
                <c:choose>
                  <c:when test="${!empty bbsList}">
                    <c:forEach var="bbs" items="${bbsList}" varStatus="status">
                      <tr class="post-table_view" onclick="<c:choose><c:when test='${empty bbs.bbsPwd or loginUser.userType == "ADMIN" or loginUser.userId == bbs.userId}'>fn_view(${bbs.bbsSeq})</c:when><c:otherwise>openPasswordModal(${bbs.bbsSeq}, '${bbs.bbsPwd}')</c:otherwise></c:choose>">
                        <td class="text-center">
                          <c:choose>
                            <c:when test="${bbs.isBookmarked == 'Y' }"><i class="fa-solid fa-bookmark"></i></c:when>
                            <c:otherwise><i class="fa-regular fa-bookmark"></i></c:otherwise>
                          </c:choose>
                        </td>
                        <td class="text-center">${bbs.bbsSeq}</td>
                        <td class="text-center">${bbs.bbsSubCateName}</td>
                        <td class="post-table_title">
                          <a href="javascript:void(0)"><c:if test="${!empty bbs.bbsPwd}"><%= "\uD83D\uDD11" %></c:if><c:out value="${bbs.bbsTitle}" /><c:if test="${bbs.bbsComCnt != 0}">(<fmt:formatNumber type="Number" maxFractionDigits="3" groupingUsed="true" value="${bbs.bbsComCnt}"/>)</c:if></a>                   
                        </td>
                        <td class="text-center">${bbs.userName}</td>
                        <td class="text-center">${bbs.bbsRegDate}</td>
                        <td class="text-center"><fmt:formatNumber type="Number" maxFractionDigits="3" groupingUsed="true" value="${bbs.bbsReadCnt}"/></td>
                        <td class="text-center"><fmt:formatNumber type="Number" maxFractionDigits="3" groupingUsed="true" value="${bbs.bbsRecomCnt}"/></td>
                      </tr>
                    </c:forEach>
                  </c:when>
                  <c:otherwise>
                    <tr>
                      <td colspan="8" class="text-center">게시글이 존재하지 않습니다.</td>
                    </tr>
                  </c:otherwise>
                </c:choose>
              </tbody>
            </table>
          </div>
          
          <!-- 페이징 처리 -->
          <div class="pagination">
            <ul>
              <c:if test="${!empty bbsPaging}">
                <c:if test="${bbsPaging.prevBlockPage gt 0}">
                  <li><a href="javascript:void(0)" onclick="fn_list(${bbsPaging.prevBlockPage})">이전</a></li>
                </c:if>
                <c:forEach var="i" begin="${bbsPaging.startPage}" end="${bbsPaging.endPage}" step="1" varStatus="status">
                  <c:choose>
                    <c:when test="${i ne bbsPaging.curPage}">
                      <li><a href="javascript:void(0)" onclick="fn_list(${i})">${i}</a></li>
                    </c:when>
                    <c:otherwise>
                      <li><a href="javascript:void(0)" style="cursor:default; color: #999;">${i}</a></li>
                    </c:otherwise> 
                  </c:choose>                  
                </c:forEach>
                <c:if test="${bbsPaging.nextBlockPage gt 0}">
                  <li><a href="javascript:void(0)" onclick="fn_list(${bbsPaging.nextBlockPage})">다음</a></li>
                </c:if>
              </c:if>
            </ul>
          </div>
          
          <!-- 검색 바 -->
          <div class="search-bar">
            <select name="_periodFilter" id="_periodFilter">
              <option value="">전체</option>
              <option value="1" <c:if test="${periodFilter == '1'}">selected</c:if>>7일 전</option>
              <option value="2" <c:if test="${periodFilter == '2'}">selected</c:if>>1개월 전</option>
              <option value="3" <c:if test="${periodFilter == '3'}">selected</c:if>>3개월 전</option>
              <option value="4" <c:if test="${periodFilter == '4'}">selected</c:if>>6개월 전</option>
              <option value="5" <c:if test="${periodFilter == '5'}">selected</c:if>>1년 전</option>
            </select>
            <select name="_searchType" id="_searchType">
              <option value="">검색 타입</option>
              <option value="1" <c:if test="${searchType == '1'}">selected</c:if>>제목</option>
              <option value="2" <c:if test="${searchType == '2'}">selected</c:if>>제목 + 내용</option>
              <option value="3" <c:if test="${searchType == '3'}">selected</c:if>>작성자</option>
            </select> 
            <input type="text" name="_searchValue" id="_searchValue" value="${searchValue}" placeholder="검색어를 입력하세요">
            <button type="button" id="btnSearch">검색</button>
          </div>
          
        </div>
      </div>
      <%@ include file="/WEB-INF/views/include/footer.jsp"%>
    </div>
  </div>

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
  <form name="bbsForm" id="bbsForm" method="post">
    <input type="hidden" name="bbsSeq" value="">
    <input type="hidden" name="myPage" value="${myPage}">
    <input type="hidden" name="periodFilter" value="${periodFilter }">
    <input type="hidden" name="searchType" value="${searchType}">
    <input type="hidden" name="searchValue" value="${searchValue}">
    <input type="hidden" name="bbsCurPage" value="${bbsCurPage}">
  </form>
</body>
</html>