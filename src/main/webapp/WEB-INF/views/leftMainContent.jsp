<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>

<div class="left-main-content">
  <c:choose>
    <c:when test="${empty loginUser}">
      <div class="member-info">
        <button name="btnLogin" id="btnLogin" onclick="location.href='/user/login'">로그인</button>
        <div class="member-links">
          <a href="/user/register">회원가입</a> <span>|</span> <a href="/user/idFind">아이디 찾기</a> <span>|</span> <a href="/user/pwdFind"> 비밀번호 찾기 </a>
        </div>
      </div>
    </c:when>
    <c:otherwise>
      <c:set var="profileImage" value="defaultProfile.png" />
      <c:if test="${!empty loginUser.userImageName}">
        <c:set var="profileImage" value="${loginUser.userImageName}" />
      </c:if>
      <div class="member-info-user">
        <div class="user-info">
          <img src="/resources/profile/${profileImage}" alt="프로필 사진" class="profile-image">
          <div class="user-details">
            <h3 class="user-info-h3">${loginUser.userName}</h3>
            <p class="user-info-p">가입일: ${fn:substring(loginUser.userRegDate, 0, 10)}</p>
            <p class="user-info-p">#${loginUser.userRegion} #${loginUser.userFood}</p>
          </div>
        </div>
        <button id="cafeBtn" onclick="location.href='/bbs/write'">카페 글쓰기</button>
        <button onclick="location.href='/user/myPage'">마이페이지</button>
      </div>
    </c:otherwise>
  </c:choose>
  <div class="left-main-content-ad">
    <h2>광고</h2>
    <img class="leftlogo" src="/resources/images/logo3.png">
  </div>
</div>