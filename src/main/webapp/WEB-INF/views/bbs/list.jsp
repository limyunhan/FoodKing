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

        <c:if test="${fn:length(cateNum) le 2}">
            $("#_cateFilter").on("change", function() {
                document.bbsForm.cateFilter.value = $("#_cateFilter").val();
                document.bbsForm.bbsCurPage.value = "1";
                document.bbsForm.action = "/bbs/list<c:if test="${!empty cateNum}">?cateNum=${cateNum}</c:if>";
                document.bbsForm.submit();
            });
        </c:if>

        $("#_bbsListCount").on("change", function() {
            document.bbsForm.bbsListCount.value = $("#_bbsListCount").val();
            document.bbsForm.bbsCurPage.value = "1";
            document.bbsForm.action = "/bbs/list<c:if test="${!empty cateNum}">?cateNum=${cateNum}</c:if>";
            document.bbsForm.submit();
        });

        $("#_bbsOrderBy").on("change", function() {
            document.bbsForm.bbsOrderBy.value = $("#_bbsOrderBy").val();
            document.bbsForm.bbsCurPage.value = "1";
            document.bbsForm.action = "/bbs/list<c:if test="${!empty cateNum}">?cateNum=${cateNum}</c:if>";
            document.bbsForm.submit();
        });

        $("#_isSecret").on("change", function() {
            document.bbsForm.isSecret.value = $("#_isSecret").val();
            document.bbsForm.bbsCurPage.value = "1";
            document.bbsForm.action = "/bbs/list<c:if test="${!empty cateNum}">?cateNum=${cateNum}</c:if>";
            document.bbsForm.submit();
        });
    });
    
    function fn_view(bbsSeq) {
        document.bbsForm.bbsSeq.value = bbsSeq;
        document.bbsForm.action = "/bbs/view";
        document.bbsForm.submit();
    }

    function fn_list(bbsCurPage) {
        document.bbsForm.bbsCurPage.value = bbsCurPage;
        document.bbsForm.action = "/bbs/list";
        document.bbsForm.submit();
    }
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
               <c:choose>
                <c:when test="${!empty cateNum}">
                  [${mainCateMap[fn:substring(cateNum, 0, 2)].mainCateName}]
                  <c:if test="${fn:length(cateNum) gt 2}">${subCateMap[cateNum].subCateName}</c:if>
                </c:when>
                <c:otherwise>
                  [전체 글]
                </c:otherwise>
               </c:choose>
              </h1>
            </div>
            <div class="right-main-content-header-search">
              <c:choose>
                <c:when test="${!empty cateNum}">
                  <c:if test="${fn:length(cateNum) le 2}">
                    <select class="cateFilter" id="_cateFilter" name="_cateFilter">
                      <option value="${cateNum}" style="font-weight: bold;">${mainCateMap[cateNum].mainCateName}</option>
                      <c:forEach var="subCate" items="${subCateListMap[cateNum]}" varStatus="status">
                        <option value="${subCate.subCateCombinedNum}" <c:if test="${cateFilter == subCate.subCateCombinedNum}">selected</c:if>>${subCate.subCateName}</option>
                      </c:forEach>
                    </select>
                  </c:if>
                </c:when>
                <c:otherwise>
                  <select class="cateFilter" id="_cateFilter" name="_cateFilter">
                   <option value="">카테고리 선택</option>
                   <c:forEach var="mainCate" items="${mainCateList}" varStatus="status">
                     <option value="${mainCate.mainCateNum}" style="font-weight: bold;" <c:if test="${cateFilter == mainCate.mainCateNum}">selected</c:if>>${mainCate.mainCateName}</option>
                     <c:forEach var="subCate" items="${subCateListMap[mainCate.mainCateNum]}" varStatus="status"> 
                       <option value="${subCate.subCateCombinedNum}" <c:if test="${cateFilter == subCate.subCateCombinedNum}">selected</c:if>>${subCate.subCateName}</option>
                     </c:forEach>
                   </c:forEach>
                  </select>
                </c:otherwise>
              </c:choose>
              <select class="bbsListCount" id="_bbsListCount" name="_bbsListCount">
                <option value="10" <c:if test="${bbsListCount == 10}">selected</c:if>>10개</option>
                <option value="20" <c:if test="${bbsListCount == 20}">selected</c:if>>20개</option>
                <option value="50" <c:if test="${bbsListCount == 50}">selected</c:if>>50개</option>
              </select>
              <select class="bbsOrderBy" id="_bbsOrderBy" name="_bbsOrderBy">
                <option value="1" <c:if test="${bbsOrderBy == '1'}">selected</c:if>>등록일 순</option>
                <option value="2" <c:if test="${bbsOrderBy == '2'}">selected</c:if>>조회수 순</option>
                <option value="3" <c:if test="${bbsOrderBy == '3'}">selected</c:if>>추천수 순</option>
                <option value="4" <c:if test="${bbsOrderBy == '4'}">selected</c:if>>댓글수 순</option>
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
                    <tr class="text-center-view" onclick="fn_view(${bbs.bbsSeq})">
                      <td class="text-center">
                        <c:choose>
                          <c:when test="${bbs.isBookmarked == 'Y' }"><i class="fa-solid fa-bookmark"></i></c:when>
                          <c:otherwise><i class="fa-regular fa-bookmark"></i></c:otherwise>
                        </c:choose>
                      </td>
                      <td class="text-center">${bbs.bbsSeq}</td>
                      <td class="text-center">${bbs.bbsSubCateName}</td>
                      <td class="text-center-title">
                        <c:choose>
                          <c:when test="${empty bbs.bbsPwd}">
                            <a href="javascript:void(0)"><c:out value="${bbs.bbsTitle}" /><c:if test="${bbs.bbsComCnt != 0}">(<fmt:formatNumber type="Number" maxFractionDigits="3" groupingUsed="true" value="${bbs.bbsComCnt}"/>)</c:if></a>
                          </c:when>
                          <c:otherwise>
                            <a href="javascript:void(0)">🔑비밀글 입니다.</a>                            
                          </c:otherwise>
                        </c:choose>
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
                    <td colspan="7" class="text-center" colspan="4">게시글이 존재하지 않습니다.</td>
                  </tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
          
          <c:choose>
            <c:when test="${!empty cateNum}">
              <c:choose>
                <c:when test="${loginUser.userType == 'USER'}">
                  <c:if test="${!fn:startsWith(cateNum, '05') && !fn:startsWith(cateNum, '01')}">
                    <div class="write-button-container">
                      <a href="javascript:void(0)" class="write-button" id="write-button">글쓰기</a>
                    </div>
                  </c:if>
                </c:when>
                <c:when test="${loginUser.userType == 'BLOGGER'}">
                  <c:if test="${!fn:startsWith(cateNum, '05') && !fn:startsWith(cateNum, '0101')}">
                    <div class="write-button-container">
                      <a href="javascript:void(0)" class="write-button" id="write-button">글쓰기</a>
                    </div>
                  </c:if>            
                </c:when>
                <c:when test="${loginUser.userType == 'ADMIN'}">
                  <div class="write-button-container">
                    <a href="javascript:void(0)" class="write-button" id="write-button">글쓰기</a>
                  </div>
                </c:when>
              </c:choose>
            </c:when>         
            <c:otherwise>
              <div class="write-button-container">
                <a href="javascript:void(0)" class="write-button" id="write-button">글쓰기</a>
              </div>
            </c:otherwise>
          </c:choose>
          
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
    <input type="hidden" name="bbsSeq" value="">
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