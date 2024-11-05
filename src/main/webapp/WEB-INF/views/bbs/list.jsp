<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<%@include file="/WEB-INF/views/include/head.jsp" %>
<script>
    $(document).ready(function() {
        $("#write-button").on("click", function() {
            document.bbsForm.action = "/bbs/write";
            document.bbsForm.submit();
        });

        $("#btn-search").on("click", function() {
            document.bbsForm.searchType.value = $("#_searchType").val();
            document.bbsForm.searchValue.value = $("#_searchValue").val();
            document.bbsForm.periodFilter.value = $("#_periodFilter").val();
            document.bbsForm.curPage.value = "1";
            document.bbsForm.action = "/bbs/list?cateNum=" + "${cateNum}";
            document.bbsForm.submit();
        });

        $("#_searchType").on("change", function() {
            $("#_searchValue").val("");
            $("#_searchValue").focus();
        });

        <c:if test="${fn:length(cateNum) le 2}">
            $("#_cateFilter").on("change", function() {
                document.bbsForm.cateFilter.value = $("#_cateFilter").val();
                document.bbsForm.curPage.value = "1";
                document.bbsForm.action = "/bbs/list?cateNum=" + "${cateNum}";
                document.bbsForm.submit();
            });
        </c:if>

        $("#_listCount").on("change", function() {
            document.bbsForm.listCount.value = $("#_listCount").val();
            document.bbsForm.curPage.value = "1";
            document.bbsForm.action = "/bbs/list?cateNum=" + "${cateNum}";
            document.bbsForm.submit();
        });

        $("#_orderBy").on("change", function() {
            document.bbsForm.orderBy.value = $("#_orderBy").val();
            document.bbsForm.curPage.value = "1";
            document.bbsForm.action = "/bbs/list?cateNum=" + "${cateNum}";
            document.bbsForm.submit();
        });

        $("#_isSecret").on("change", function() {
            document.bbsForm.isSecret.value = $("#_isSecret").val();
            document.bbsForm.curPage.value = "1";
            document.bbsForm.action = "/bbs/list?cateNum=" + "${cateNum}";
            document.bbsForm.submit();
        });
    });
</script>
</head>
<body id="index-body">
  <div class="Board-Main-Page">
    <div class="Board-Main">
      <%@include file="/WEB-INF/views/include/navigation.jsp"%>
      <div class="main-contanier">
        <%@include file="/WEB-INF/views/leftMainContent.jsp"%>
        <div class="right-main-content">
          <div class="right-main-content-header">
            <div class="right-main-content-header-title">
              <h1>
                [${mainCateMap[fn:substring(cateNum, 0, 2)].mainCateName}]
                <c:if test="${fn:length(cateNum) gt 2}">${subCateMap[cateNum].subCateName}</c:if>
              </h1>
            </div>
            <div class="right-main-content-header-search">
              <c:if test="${fn:length(cateNum) le 2}">
                <select class="cateFilter" id="_cateFilter" name="_cateFilter">
                  <option value="${cateNum}">${mainCateMap[cateNum].mainCateName}</option>
                  <c:forEach var="subCate" items="${subCateListMap[cateNum]}" varStatus="status">
                    <option value="${subCate.subCateCombinedNum}" <c:if test="${cateFilter == subCate.subCateCombinedNum}">selected</c:if>>${subCate.subCateName}</option>
                  </c:forEach>
                </select>
              </c:if>
              <select class="listCount" id="_listCount" name="_listCount">
                <option value="10" <c:if test="${listCount == 10}">selected</c:if>>10개</option>
                <option value="20" <c:if test="${listCount == 20}">selected</c:if>>20개</option>
                <option value="50" <c:if test="${listCount == 50}">selected</c:if>>50개</option>
              </select>
              <select class="orderBy" id="_orderBy" name="_orderBy">
                <option value="1" <c:if test="${orderBy == '1'}">selected</c:if>>등록일 순</option>
                <option value="2" <c:if test="${orderBy == '2'}">selected</c:if>>조회수 순</option>
                <option value="3" <c:if test="${orderBy == '3'}">selected</c:if>>추천수 순</option>
                <option value="4" <c:if test="${orderBy == '4'}">selected</c:if>>댓글수 순</option>
              </select>      
              <select class="isSecret" id="_isSecret" name="_isSecret">
                <option value="" <c:if test="${isSecret == ''}">selected</c:if>>전체 보기</option>
                <option value="Y" <c:if test="${isSecret == 'Y'}">selected</c:if>>🔒 비밀글만</option>
                <option value="N" <c:if test="${isSecret == 'N'}">selected</c:if>>🔓 비밀글 제외</option>
              </select>
            </div>
          </div>

          <table class="notice-board">
            <thead>
              <tr>
                <th scope="col" class="text-center">번호</th>
                <th scope="col" class="text-center">제목</th>
                <th scope="col" class="text-center">작성자</th>
                <th scope="col" class="text-center">작성일</th>
                <th scope="col" class="text-center">조회</th>
                <th scope="col" class="text-center">좋아요</th>
              </tr>
            </thead>
            <tbody>
              <tr class="text-center-view" onclick="fn_view(); openPasswordModal('', ''); fn_view();">
                <td class="text-center">번호</td>
                <td class="text-center-title"><a href="javascript:void(0)">🔑비밀글 입니다.</a></td>
                <td class="text-center">작성자</td>
                <td class="text-center">작성일</td>
                <td class="text-center">조회</td>
                <td class="text-center">좋아요</td>
              </tr>
              <tr>
                <td class="text-center" colspan="4">해당 데이터가 존재하지 않습니다.</td>
              </tr>
            </tbody>
          </table>
          
          <c:choose>
            <c:when test="${!fn:startsWith(cateNum, '05') && !fn:startsWith(cateNum, '01')}">
              <div class="write-button-container">
                <a href="javascript:void(0)" class="write-button" id="write-button">글쓰기</a>
              </div>
            </c:when>
            <c:otherwise>
              <c:choose>
                    
              </c:choose>
            </c:otherwise>
          </c:choose>
         
          <!-- 페이징 처리 -->
          <div class="pagination">
            <ul>
              <li><a href="javascript:void(0)" onclick="fn_list()">이전</a></li>
              <li><a href="javascript:void(0)" onclick="fn_list()"></a></li>
              <li><a href="javascript:void(0)" onclick="fn_list()"></a></li>
              <li><a href="javascript:void(0)" onclick="fn_list()">다음</a></li>
            </ul>
          </div>
          
          <!-- 검색 바 -->
          <div class="search-bar">
            <select name="_periodFilter" id="_periodFilter">
              <option value="">전체</option>
              <option value="1">7일 전</option>
              <option value="2">1개월 전</option>
              <option value="3">3개월 전</option>
              <option value="4">6개월 전</option>
              <option value="5">1년 전</option>
            </select>
            <select name="_searchType" id="_searchType">
              <option value="">검색 타입</option>
              <option value="1">제목</option>
              <option value="2">제목 + 내용</option>
              <option value="3">작성자</option>
            </select> 
            <input type="text" name="_searchValue" id="_searchValue" value="" placeholder="검색어를 입력하세요">
            <button type="button" id="btnSearch">검색</button>
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
      </div>
      <%@ include file="/WEB-INF/views/include/footer.jsp"%>
    </div>
  </div>
  <form name="bbsForm" id="bbsForm" method="post">
    <input type="hidden" name="listCount" value="${listCount}">
    <input type="hidden" name="curPage" value="${curPage}">
    <input type="hidden" name="cateNum" value="${cateNum}">
    <input type="hidden" name="cateFilter" value="${cateFilter}">
    <input type="hidden" name="periodFilter" value="${periodFilter}">
    <input type="hidden" name="orderBy" value="${orderBy}">  
    <input type="hidden" name="isSecret" value="${isSecret}">
    <input type="hidden" name="searchType" value="${searchType}">
    <input type="hidden" name="searchValue" value="${searchValue}">
  </form>
</body>
</html>