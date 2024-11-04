<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>

<script>
function fn_selectCategory(cateNum) {
    window.location.href = "/bbs/list?cateNum=" + cateNum;
} 
</script>

<header>
  <div style="flex-grow: 1;">
    <a href="/" style="color: white; font-family: '을지로체'; font-size: 20px; line-height: 30px;">Food King</a> 
    <img src="/resources/images/smile.png" style="max-width: 35px; max-height: 35px; vertical-align: middle;">
  </div>

  <div class="header-menu-btn">
    <% if (com.sist.web.util.CookieUtil.getCookie(request, (String)request.getAttribute("AUTH_COOKIE_NAME")) == null) { %>
    <button id="btnLogin" onclick="location.href='/user/login'">로그인</button>
    <button id="btnReg" onclick="location.href='/user/regForm'">회원가입</button>
    <% } else { %>
    <button id="btnLogin" onclick="location.href='/user/logOut'">로그아웃</button>
    <% } %>
  </div>
</header>

<div class="logo">
  <img src="/resources/images/logo1.png" class="logo-left" alt="Logo"> 
  <img src="/resources/images/logo.png" class="logo-center" alt="Logo"> 
  <img src="/resources/images/logo2.png" class="logo-right" alt="Logo">
</div>

<div class="navbar">
  <ul>
    <c:forEach var="mainCate" items="${mainCateList}" varStatus="status">
      <li>
        <a href="javascript:void(0)" onclick="fn_selectCategory('${mainCate.mainCateNum}')">${mainCate.mainCateName}</a>
        <ul>
          <c:forEach var="subCate" items="${subCateListMap[mainCate.mainCateNum]}" varStatus="status"> 
            <li>
              <a href="javascript:void(0)" onclick="fn_selectCategory('${subCate.subCateCombinedNum}')">${subCate.subCateName}</a>
            </li>
          </c:forEach>
        </ul>
      </li>
    </c:forEach>
  </ul>
</div>