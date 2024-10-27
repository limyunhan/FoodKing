<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<script type="text/javascript">
$(document).ready(function() {
    $("#hiBbsTitle").focus();
   
    $("#btnUpdate").on("click", function() {
        $("#btnUpdate").prop("disabled", true);
      
        if ($.trim($("#hiBbsTitle").val()).length === 0) {
    	    alert("제목을 입력해주세요.");
    	    $("#hiBbsTitle").val("");
    	    $("#hiBbsTitle").focus();
    	    $("#btnUpdate").prop("disabled", false);
    	    return;
        }
      
        if ($.trim($("#hiBbsContent").val()).length === 0) {
    	    alert("내용을 입력해주세요.");
    	    $("#hiBbsCotnent").val("");
    	    $("#hiBbsCotnent").focus();
    	    $("#btnUpdate").prop("disabled", false);
    	    return;
        }
      
        var form = $("#updateForm")[0];
        var formData = new FormData(form); 
      
        $.ajax({
            type: "POST",
    	    enctype: "multipart/form-data",
    	    url: "/board/updateProc",
    	    data: formData,
    	    contentType: false,
    	    processData: false,
    	    cache: false,
    	    beforeSend: function(xhr) {
    	        xhr.setRequestHeader("AJAX", "true");
     	    },
     	    success: function(response) {
     	        if (response.code == 200) {
     	            alert("게시글이 수정되었습니다.");
     	    	    location.href = "/board/list";
     	        } else if (response.code == 400) {
     	            alert("비정상적인 접근입니다.");
     	    	    $("#btnUpdate").prop("disabled", false);
     	        } else if (response.code == 403) {
     	        	alert("로그인한 사용자의 게시글이 아닙니다.");
     	        	$("#btnUpdate").prop("disabled", false);
     	        } else if (response.code == 404) {
     	        	alert("게시글을 찾을 수 없습니다.");
     	        	location.href = "/board/list";
     	        } else {
     	        	alert("DB 정합성 오류가 발생하였습니다.");
     	        	$("#btnUpdate").prop("disabled", false);
     	        }
     	    },
     	    complete: function(data) {
     	        icia.common.log(data);
     	    },
     	    error: function(xhr, status, error) {
     	        icia.common.error(error);
     	        alert("서버 응답 오류가 발생하였습니다.");
                $("#btnUpdate").prop("disabled", false);
            }
        });
    });
   
    $("#btnList").on("click", function() {
	    document.bbsForm.action = "/board/list";
	    document.bbsForm.submit();
    });
});
</script>
</head>
<body>

  <%@ include file="/WEB-INF/views/include/navigation.jsp"%>
  <div class="container">
    <h2>게시물 수정</h2>
    <form name="updateForm" id="updateForm" method="post" enctype="multipart/form-data">
      <input type="text" name="userName" id="userName" maxlength="20" value="${hiBoard.userName}" style="ime-mode: active;" class="form-control mt-4 mb-2" placeholder="이름을 입력해주세요." readonly> 
      <input type="text" name="userEmail" id="userEmail" maxlength="30" value="${hiBoard.userEmail}" style="ime-mode: inactive;" class="form-control mb-2" placeholder="이메일을 입력해주세요." readonly>
      <input type="text" name="hiBbsTitle" id="hiBbsTitle" maxlength="100" style="ime-mode: active;" value="<c:out value='${hiBoard.hiBbsTitle}' />" class="form-control mb-2" placeholder="제목을 입력해주세요." required>
      <div class="form-group">
        <textarea class="form-control" rows="10" name="hiBbsContent" id="hiBbsContent" style="ime-mode: active;" placeholder="내용을 입력해주세요" required><c:out value="${hiBoard.hiBbsContent}" /></textarea>
      </div>
      <input type="file" name="hiBbsFile" id="hiBbsFile" class="form-control mb-2" placeholder="파일을 선택하세요." required>
      <c:if test="${!empty hiBoard.hiBoardFile}">
        <div style="margin-bottom: 0.3em;">[첨부파일 : ${hiBoard.hiBoardFile.fileOrgName}]</div>
      </c:if>
      <input type="hidden" name="hiBbsSeq" value="${hiBoard.hiBbsSeq}" > 
    </form>

    <div class="form-group row">
      <div class="col-sm-12">
        <button type="button" id="btnUpdate" class="btn btn-primary" title="수정">수정</button>
        <button type="button" id="btnList" class="btn btn-secondary" title="리스트">리스트</button>
      </div>
    </div>
  </div>
<form name="bbsForm" id="bbsForm" method="post">
  <input type="hidden" name="hiBbsSeq" value="${hiBoard.hiBbsSeq}" > 
  <input type="hidden" name="searchType" value="${searchType}" > 
  <input type="hidden" name="searchValue" value="${searchValue}" > 
  <input type="hidden" name="curPage" value="${curPage}" >
</form>
</body>
</html>