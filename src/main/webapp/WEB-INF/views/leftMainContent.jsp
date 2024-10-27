<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.dao.MiniUserDao" %>
<%@ page import="com.sist.web.model.MiniUser" %>
<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<%@ page import="com.sist.web.util.HttpUtil" %>

<div class="left-main-content">
<%
    Logger leftMainContent_logger = LogManager.getLogger("/leftMainContent.jsp");
    HttpUtil.requestLogString(request, leftMainContent_logger);
    String leftMainContent_cookieUserId = CookieUtil.getValue(request, "USER_ID");
    request.setAttribute("cookieUserId", leftMainContent_cookieUserId);

    if (StringUtil.isEmpty(leftMainContent_cookieUserId)) { 
%>
    <c:set var="isLoggedIn" value="false" />
<%
    } else { 
        MiniUserDao leftMainContent_userDao = new MiniUserDao();
        MiniUser leftMainContent_user = leftMainContent_userDao.userSelect(leftMainContent_cookieUserId);
        request.setAttribute("user", leftMainContent_user);
        request.setAttribute("isLoggedIn", "true");
    }
%>

<c:choose>
    <c:when test="${isLoggedIn == 'false'}">
        <div class="member-info">
            <button name="btnLogin" id="btnLogin" onclick="location.href='loginForm.jsp'">로그인</button>
            <div class="member-links">
                <a href="/user/userRegForm.jsp">회원가입</a> <span>|</span> <a href="/user/userFind.jsp">아이디 찾기</a>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <c:if test="${not empty user}">
            <div class="member-info-user">
                <div class="user-info">
                    <img src="/${user.userImage}" alt="프로필 사진" class="profile-image">
                    <div class="user-details">
                        <h3 class="user-info-h3">${user.userName}</h3>
                        <p class="user-info-p">가입일: ${user.userDate}</p>
                        <p class="user-info-p">#${user.userRegion} #${user.userFood}</p>
                    </div>
                </div>

                <button id="cafeBtn" onclick="location.href='/board/writeBoard.jsp'">카페 글쓰기</button>
                <button onclick="location.href='/user/myPage.jsp'">마이페이지</button>
                
                <form name="cafeForm" id="cafeForm" method="post" action="/board/writeBoard.jsp">
                    <input type="hidden" name="cafeInfo" id="cafeInfo" value="cafe">
                </form>
                <script>
                    $(document).ready(function() {
                        $("#cafeBtn").on("click", function() {
                            document.cafeForm.submit();
                        });
                    });
                </script>
            </div>
        </c:if>
    </c:otherwise>
</c:choose>

<div class="left-main-content-ad">
    <h2>광고</h2>
    <img class="leftlogo" src="/img/logo3.png">
</div>
</div>