<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html lang="ko">

<head>
<%@include file="/WEB-INF/views/include/head.jsp"%>
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/lang/summernote-ko-KR.min.js"></script>
<script>
$(document).ready(function() {
	$("#bbsContent").summernote({
	    lang: 'ko-KR',
	    toolbar: [
	        ["insert", ['picture']],
	        ["fontname", ["fontname"]],
	        ["fontsize", ["fontsize"]],
	        ["color", ["color"]],
	        ["style", ["style"]],
	        ["font", ["strikethrough", "superscript", "subscript"]],
	        ["table", ["table"]],
	        ["para", ["ul", "ol", "paragraph"]],
	        ["height", ["height"]],
	    ],
	    fontNames: ['을지로체', 'Nanum Gothic', 'Noto Sans KR', 'Spoqa Han Sans'],
	    fontNamesIgnoreCheck: ['을지로체', 'Nanum Gothic', 'Noto Sans KR', 'Spoqa Han Sans'], 
	    callbacks: {
	        onInit: function() {
	            // 초기 폰트 및 폰트 크기 설정
	            $("#bbsContent").summernote("fontName", "을지로체");
	            $("#bbsContent").summernote("fontSize", "18");
	            $("#bbsTitle").focus();
	        },
	        onImageUpload: function(files) {
	            for (let i = 0; i < files.length; i++) {
	                uploadImage(files[i]);
	            }
	        },
	        onPaste: function(e) {
	            var clipbbsData = e.originalEvent.clipboardData;

	            if (clipbbsData && clipbbsData.items && clipbbsData.items.length) {
	                var item = clipbbsData.items[0];

	                if (item.kind === "file" && item.type.indexOf("image/") !== -1) {
	                    e.preventDefault();
	                }
	            }
	        }
	    }
	});
	
	$("#bbsFile").on("change", function() {
	    var fileName = $(this).get(0).files.length > 0 ? $(this).get(0).files[0].name : "선택된 파일 없음";
	    $('#fileName').text(fileName);
	});
	
	
	$("#secretCheck").on("change", function(){
	    $("#bbsPwd").prop("disabled", !this.checked);		
	});
	
	$("#write-btn").on("click", function() {
        if ($("#subCateCombinedNum").val() === "") {
        	alert("게시판을 선택해주세요.");
        	$("#subCateCombinedNum").focus();
        	return;
        }
		
	    if ($.trim($("#bbsTitle").val()).length === 0) {
	        alert("제목을 입력해주세요.");
	        $("#bbsTitle").val("");
	        $("#bbsTitle").focus();
	        return;
	    }
	    
	    var content = $("#bbsContent").summernote("code");
	    var strippedContent = content.replace(/<[^>]+>/g, ""); // HTML 태그 제거

	    if ($.trim(strippedContent).length === 0) {
	        alert("내용을 입력해주세요.");
	        $("#bbsContent").summernote("focus"); // 서머노트 에디터에 포커스
	        return; 
	    }

	    if ($("#secretCheck").prop("checked") && $.trim($("#bbsPwd").val()).length === 0) {
	        alert("게시글 비밀번호를 입력해주세요.");
	        $("#bbsPwd").val("");
	        $("#bbsPwd").focus();
	        return;
	    }
	    
	    var form = $("#writeForm")[0];
	    var formData = new FormData(form);
	    
	    $.ajax({
	        type: "POST",
	        enctype: "multipart/form-data",
	        url: "/bbs/writeProc",
	        data: formData,
	        processData: false,
	        contentType: false,
	        cache: false,
	        beforeSend: function(xhr) {
	        	xhr.setRequestHeader("AJAX", "true");
	        },
	        success: function(response) {
	        	if (response.code === 200) {
	        	    alert("게시글을 성공적으로 작성하였습니다.");
	        	    document.bbsForm.action = "/bbs/list" 
	        	    document.bbsForm.action = "/bbs/list?cateNum=" + "${cateNum}";
	                document.bbsForm.submit();
	        	} else if (response.code === 500) {
	        		alert("DB정합성 오류로 게시글 작성에 실패하였습니다.");      		
	        		
	        	} else if (response.code === 400) {
	        		alert("비정상적인 접근입니다.");
	        		location.href = "/";
	        		
	        	} else {
	        		alert("서버 응답 오류로 게시글 작성에 실패하였습니다.");
	        	}
	        	
	        },
	        error: function(error) {
	        	alert("서버 응답 오류로 게시글 작성에 실패하였습니다.");
	        	icia.common.error(error);
	        }
	    });
	});
});
</script>
</head>
<body id="index-body">
  <div class="bbs-Main-Page">
    <div class="bbs-Main">
      <%@include file="/WEB-INF/views/include/navigation.jsp"%>
      <div class="main-contanier">
        <%@include file="/WEB-INF/views/leftMainContent.jsp"%>
        <div class="write-container">
          <form name="writeForm" id="writeForm" method="post" enctype="multipart/form-data">
            <div class="write-header">
              <h1>글쓰기</h1>
              <div class="write-section">
                <button type="button" class="listbtn" id="listbtn">리스트</button>
                <button type="button" class="write-btn" id="write-btn">등록</button>
              </div>
            </div>
            <div class="write-category">
              <select id="subCateCombinedNum">
                <option value="">게시판을 선택해 주세요.</option>
                <c:forEach var="mainCate" items="${mainCateList}" varStatus="status">
                  <c:if test="${mainCate.mainCateNum != '06' && mainCate.mainCateNum != '01' && mainCate.mainCateNum != '05'}">
                    <optgroup label="${mainCate.mainCateName}">
                    <c:forEach var="subCate" items="${subCateListMap[mainCate.mainCateNum]}" varStatus="status">
                      <option value="${subCate.subCateCombinedNum}" <c:if test="${subCate.subCateCombinedNum == cateNum}">selected</c:if>>${subCate.subCateName}</option>   
                    </c:forEach>
                    </optgroup>
                  </c:if>
                </c:forEach>
              </select>
              <div></div>
              <div class="write-pwd">
                <label for="secretCheck" id="lockLabel">🔒</label> 
                <input type="checkbox" id="secretCheck" name="secretCheck">
                <input type="password" id="bbsPwd" name="bbsPwd" placeholder="비밀번호를 입력하세요." disabled>
              </div>
            </div>
            <div class="input-group" style="display: flex; align-items: center;">
              <label for="bbsFile" class="custom-file-upload" style="white-space: nowrap;">파일 선택</label> 
              <span class="file-name" id="fileName">선택된 파일 없음</span> 
              <input type="file" id="bbsFile" name="bbsFile" multiple style="display: none;">
            </div>
            <div class="write-title">
              <input type="text" id="bbsTitle" name="bbsTitle" placeholder="제목을 입력해 주세요." value="" />
            </div>
            <div class="write-content">
              <textarea class="summernote" id="bbsContent" name="bbsContent" placeholder="내용을 입력하세요."></textarea>
            </div>
          </form>
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