<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/include/taglib.jsp" %>

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
});

function fn_view(bbsSeq) {
    document.bbsForm.bbsSeq.value = bbsSeq;
    document.bbsForm.action = "/bbs/view";
    document.bbsForm.submit();
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
<div class="content">
  <article class="bbs">
    <h3>
      <a href="javascript:void(0)">공지사항</a>
    </h3>
    <c:if test="${!empty noticeList}">
      <a href="/bbs/list?cateNum=05" class="view-all">전체보기</a>
    </c:if>
    <table>
      <tbody>
        <c:choose>
          <c:when test="${!empty noticeList}">
            <c:forEach var="bbs" items="${noticeList}" varStatus="status">
              <tr class="rightMain" onclick="<c:choose><c:when test='${empty bbs.bbsPwd or loginUser.userType == "ADMIN" or loginUser.userId == bbs.userId}'>fn_view(${bbs.bbsSeq})</c:when><c:otherwise>openPasswordModal(${bbs.bbsSeq}, '${bbs.bbsPwd}')</c:otherwise></c:choose>">
                <td>
                  <c:choose>
                    <c:when test="${empty bbs.bbsPwd}">
                      <a href="javascript:void(0)"><c:out value="${bbs.bbsTitle}" /><c:if test="${bbs.bbsComCnt != 0}">(<fmt:formatNumber type="Number" maxFractionDigits="3" groupingUsed="true" value="${bbs.bbsComCnt}"/>)</c:if></a>
                    </c:when>
                    <c:otherwise>
                      <c:choose>
                        <c:when test="${loginUser.userId == bbs.userId}"><%= "\uD83D\uDD11" %> <c:out value="${bbs.bbsTitle}" /><c:if test="${bbs.bbsComCnt != 0}">(<fmt:formatNumber type="Number" maxFractionDigits="3" groupingUsed="true" value="${bbs.bbsComCnt}"/>)</c:if></c:when>
                        <c:otherwise>
                          <a href="javascript:void(0)">🔑 비밀글 입니다.</a>     
                        </c:otherwise>  
                      </c:choose>                     
                    </c:otherwise>
                  </c:choose>
                </td>
              </tr>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <tr class="text-center">
              <td>게시글이 존재하지 않습니다.</td>
            </tr>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </article>

  <article class="bbs">
    <h3>
      <a href="javascript:void(0)">커뮤니티</a>
    </h3>
    <c:if test="${!empty communityList}">
      <a href="/bbs/list?cateNum=02" class="view-all">전체보기</a>
    </c:if>
    <table>
      <tbody>
        <c:choose>
          <c:when test="${!empty communityList}">
            <c:forEach var="bbs" items="${communityList}" varStatus="status">
              <tr class="rightMain" onclick="<c:choose><c:when test='${empty bbs.bbsPwd or loginUser.userType == "ADMIN" or loginUser.userId == bbs.userId}'>fn_view(${bbs.bbsSeq})</c:when><c:otherwise>openPasswordModal(${bbs.bbsSeq}, '${bbs.bbsPwd}')</c:otherwise></c:choose>">
                <td>
                  <c:choose>
                    <c:when test="${empty bbs.bbsPwd}">
                      <a href="javascript:void(0)"><c:out value="${bbs.bbsTitle}" /><c:if test="${bbs.bbsComCnt != 0}">(<fmt:formatNumber type="Number" maxFractionDigits="3" groupingUsed="true" value="${bbs.bbsComCnt}"/>)</c:if></a>
                    </c:when>
                    <c:otherwise>
                      <c:choose>
                        <c:when test="${loginUser.userId == bbs.userId}"><%= "\uD83D\uDD11" %> <c:out value="${bbs.bbsTitle}" /><c:if test="${bbs.bbsComCnt != 0}">(<fmt:formatNumber type="Number" maxFractionDigits="3" groupingUsed="true" value="${bbs.bbsComCnt}"/>)</c:if></c:when>
                        <c:otherwise>
                          <a href="javascript:void(0)">🔑 비밀글 입니다.</a>     
                        </c:otherwise>  
                      </c:choose>                     
                    </c:otherwise>
                  </c:choose>
                </td>
              </tr>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <tr class="text-center">
              <td>게시글이 존재하지 않습니다.</td>
            </tr>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </article>

  <article class="bbs">
    <h3>
      <a href="javascript:void(0)">지역별 맛집</a>
    </h3>
    <c:if test="${!empty restoListByRegion}">
      <a href="/bbs/list?cateNum=03" class="view-all">전체보기</a>
    </c:if>
    <table>
      <tbody>
        <c:choose>
          <c:when test="${!empty restoListByRegion}">
            <c:forEach var="bbs" items="${restoListByRegion}" varStatus="status">
              <tr class="rightMain" onclick="<c:choose><c:when test='${empty bbs.bbsPwd or loginUser.userType == "ADMIN" or loginUser.userId == bbs.userId}'>fn_view(${bbs.bbsSeq})</c:when><c:otherwise>openPasswordModal(${bbs.bbsSeq}, '${bbs.bbsPwd}')</c:otherwise></c:choose>">
                <td>
                  <c:choose>
                    <c:when test="${empty bbs.bbsPwd}">
                      <a href="javascript:void(0)"><c:out value="${bbs.bbsTitle}" /><c:if test="${bbs.bbsComCnt != 0}">(<fmt:formatNumber type="Number" maxFractionDigits="3" groupingUsed="true" value="${bbs.bbsComCnt}"/>)</c:if></a>
                    </c:when>
                    <c:otherwise>
                      <c:choose>
                        <c:when test="${loginUser.userId == bbs.userId}"><%= "\uD83D\uDD11" %> <c:out value="${bbs.bbsTitle}" /><c:if test="${bbs.bbsComCnt != 0}">(<fmt:formatNumber type="Number" maxFractionDigits="3" groupingUsed="true" value="${bbs.bbsComCnt}"/>)</c:if></c:when>
                        <c:otherwise>
                          <a href="javascript:void(0)">🔑 비밀글 입니다.</a>     
                        </c:otherwise>  
                      </c:choose>                     
                    </c:otherwise>
                  </c:choose>
                </td>
              </tr>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <tr class="text-center">
              <td>게시글이 존재하지 않습니다.</td>
            </tr>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </article>

  <article class="bbs">
    <h3>
      <a href="javascript:void(0)">테마별 맛집</a>
    </h3>
    <c:if test="${!empty restoListByTheme}">
      <a href="/bbs/list?cateNum=04" class="view-all">전체보기</a>
    </c:if>
    <table>
      <tbody>
        <c:choose>
          <c:when test="${!empty restoListByTheme}">
            <c:forEach var="bbs" items="${restoListByTheme}" varStatus="status">
              <tr class="rightMain" onclick="<c:choose><c:when test='${empty bbs.bbsPwd or loginUser.userType == "ADMIN" or loginUser.userId == bbs.userId}'>fn_view(${bbs.bbsSeq})</c:when><c:otherwise>openPasswordModal(${bbs.bbsSeq}, '${bbs.bbsPwd}')</c:otherwise></c:choose>">
                <td>
                  <c:choose>
                    <c:when test="${empty bbs.bbsPwd}">
                      <a href="javascript:void(0)"><c:out value="${bbs.bbsTitle}" /><c:if test="${bbs.bbsComCnt != 0}">(<fmt:formatNumber type="Number" maxFractionDigits="3" groupingUsed="true" value="${bbs.bbsComCnt}"/>)</c:if></a>
                    </c:when>
                    <c:otherwise>
                      <c:choose>
                        <c:when test="${loginUser.userId == bbs.userId}"><%= "\uD83D\uDD11" %> <c:out value="${bbs.bbsTitle}" /><c:if test="${bbs.bbsComCnt != 0}">(<fmt:formatNumber type="Number" maxFractionDigits="3" groupingUsed="true" value="${bbs.bbsComCnt}"/>)</c:if></c:when>
                        <c:otherwise>
                          <a href="javascript:void(0)">🔑 비밀글 입니다.</a>     
                        </c:otherwise>  
                      </c:choose>                     
                    </c:otherwise>
                  </c:choose>
                </td>
              </tr>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <tr class="text-center">
              <td>게시글이 존재하지 않습니다.</td>
            </tr>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </article>
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
</form>