<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/include/taglib.jsp" %>    
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>

<!DOCTYPE html>
<html lang="ko">

<head>
  <%@include file="/WEB-INF/views/include/head.jsp" %>
</head>
<script>
</script>
<body id="index-body">
  <div class="Board-Main-Page">
    <div class="Board-Main">
      <%@include file="/WEB-INF/views/include/navigation.jsp"%>
      <div class="main-contanier">
        <%@include file="/WEB-INF/views/leftMainContent.jsp"%>
        <div class="post-container">
          <div class="post-header">
            <div class="post-header-info">
              <h1><c:out value="${bbs.bbsTitle}" /></h1>
              <p><b>작성자:</b> ${bbs.userName}</p>
              <p><b>등록일:</b> ${bbs.bbsRegDate}</p>
              <c:if test="${!empty bbs.bbsUpdateDate}"><p><b>최근 수정일:</b> ${bbs.bbsUpdateDate}</p></c:if>
              <p><b>조회수:</b> <fmt:formatNumber type="Number" maxFractionDigits="3" groupingUsed="true" value="${bbs.bbsReadCnt}" /></p>
            </div>
            <div style="display: flex; flex-direction: column;">
              <div class="post-header-buttons">
                <button class="list-btn" id="list-btn">리스트</button>
                <button class="edit-btn" id="edit-btn">수정</button>
                <button class="delete-btn" id="delete-btn">삭제</button>
              </div>
            </div>
          </div>

          <div class="post-content">
            <div class="viewContent" style="min-height: 400px; border: 1px solid #ddd; padding: 10px;">
              <c:out value="${bbs.bbsContent}" escapeXml="false" />
            </div>
          </div>
          
          <div class="comments-section">
            <h2>댓글</h2>
            <form name="commentForm" id="commentForm" method="post">
              <textarea name="boardComment" rows="4" cols="50" required></textarea>
              <button type="submit">댓글 달기</button>
            </form>
          </div>
        </div>
      </div>
      <%@ include file="/WEB-INF/views/include/footer.jsp"%>
    </div>
  </div>
  <form name="bbsForm" id="viewForm" method="post">
    <input type="hidden" name="bbsSeq" value="${bbsSeq}">
    <input type="hidden" name="bbsListCount" value="${bbsListCount}">
    <input type="hidden" name="bbsCurPage" value="${bbsCurPage}">
    <input type="hidden" name="cateNum" value="${cateNum}">
    <input type="hidden" name="cateFilter" value="${cateFilter}">
    <input type="hidden" name="periodFilter" value="${periodFilter}">
    <input type="hidden" name="bbsOrderBy" value="${bbsOrderBy}">  
    <input type="hidden" name="isSecret" value="${isSecret}">
    <input type="hidden" name="searchType" value="${searchType}">
    <input type="hidden" name="searchValue" value="${searchValue}">
  </form>
</body>
</html>