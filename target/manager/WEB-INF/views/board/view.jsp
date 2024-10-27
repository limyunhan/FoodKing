<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%
// 개행문자 값을 저장한다.
pageContext.setAttribute("newLine", "\n");
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		$("#btnList").on("click", function() {
			document.bbsForm.action = "/board/list";
			document.bbsForm.submit();
		});

		$("#btnReply").on("click", function() {
			document.bbsForm.action = "/board/replyForm";
			document.bbsForm.submit();
		});
	    
		<c:if test="${myBoard eq 'Y'}">
    		$("#btnUpdate").on("click", function() {
    			document.bbsForm.action = "/board/updateForm";
    			document.bbsForm.submit();
    		});
    
    		$("#btnDelete").on("click", function() {
    			if (confirm("해당 게시물을 삭제하시겠습니까?")) {
    				$.ajax({
    					type: "POST",
    					url: "/board/delete",
    					data: {
    						hiBbsSeq : ${hiBbsSeq}
    					},
    					dataType: "JSON",
    					beforeSend: function(xhr) {
    						xhr.setRequestHeader("AJAX", "true");
    					},
    					success: function(response) {
    						if (response.code === 200) {
    							alert("게시글이 삭제되었습니다.");
    							location.href = "/board/list"
    						} else if (response.code === 400) {
    							alert("비정상적인 접근입니다.");
    						} else if (response.code === 403) {
    							alert("자신의 게시글만 삭제가 가능합니다.");
    						} else if (response.code === 404) {
    							alert("해당 게시물을 찾을 수 없습니다.");
    							location.href = "/board/list";
    						} else if (response.code === -999) {
    							alert("답변 게시물이 존재하여 삭제할 수 없습니다.");
    						} else {
    							alert("서버 응답 오류가 발생하였습니다.");
    						}
    					},
    					complete: function(data) {
    						icia.common.log(data);
    					},
    					error: function(xhr, status, error) {
    						icia.common.error(error);
    					}
    				})
    			}
    		});
		</c:if>
	});
</script>
</head>
<body>

  <%@ include file="/WEB-INF/views/include/navigation.jsp"%>
  <div class="container">
    <h2>게시물 보기</h2>
    <div class="row" style="margin-right: 0; margin-left: 0;">
      <table class="table">
        <thead>
          <tr class="table-active">
            <th scope="col" style="width: 60%"><c:out value="${hiBoard.hiBbsTitle}" /><br><c:out value="${hiBoard.userName}" />&nbsp;&nbsp;&nbsp; 
              <a href="mailto:메일주소" style="color: #828282;"><c:out value="${hiBoard.userEmail}" /></a>&nbsp;&nbsp;&nbsp;
              <c:if test="${!empty hiBoard.hiBoardFile}">
                <a href="/board/download?hiBbsSeq=${hiBoard.hiBoardFile.hiBbsSeq}" style="color: #000;">[첨부파일]</a>
              </c:if>
            </th>
            <th scope="col" style="width: 40%" class="text-right">
              조회 : <fmt:formatNumber type="number" maxFractionDigits="3" groupingUsed="true" value="${hiBoard.hiBbsReadCnt}" /><br> 
              ${hiBoard.regDate}
            </th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td colspan="2"><pre><c:out value="${hiBoard.hiBbsContent}" /></pre></td>
          </tr>
        </tbody>
        <tfoot>
          <tr>
            <td colspan="2"></td>
          </tr>
        </tfoot>
      </table>
    </div>

    <button type="button" id="btnList" class="btn btn-secondary">리스트</button>
    <button type="button" id="btnReply" class="btn btn-secondary">답변</button>
    <c:if test="${myBoard eq 'Y'}">
      <button type="button" id="btnUpdate" class="btn btn-secondary">수정</button>
      <button type="button" id="btnDelete" class="btn btn-secondary">삭제</button>
    </c:if>
    <br><br>
  </div>
  <form name="bbsForm" method="post">
    <input type="hidden" name="hiBbsSeq" value="${hiBbsSeq}">
    <input type="hidden" name="searchType" value="${searchType}">
    <input type="hidden" name="searchValue" value="${searchValue}">
    <input type="hidden" name="curPage" value="${curPage}">
    <input type="hidden" name="isCommentRefresh" value="false">
  </form>  
</body>
</html>