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
	const bbsContent = "${fn:replace(bbs.bbsContent, '\"', '&quot;')}";

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
            	$("#bbsContent").summernote("code", bbsContent);
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
        var files = $(this).get(0).files;
        if (files.length > 0) {
            var fileName = files[0].name;
            var additionalFileCount = files.length - 1;
            var displayText = additionalFileCount > 0 ? fileName + " 외 " + additionalFileCount + "건" : fileName;
            $("#fileName").text(displayText);
            
        } else {
            $("#fileName").text("선택된 파일 없음");
        }
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
        
        var form = $("#updateForm")[0];
        var formData = new FormData(form);
        formData.append("bbsSeq", $("#bbsSeq").val());
        
        $.ajax({
            type: "POST",
            enctype: "multipart/form-data",
            url: "/bbs/updateProc",
            data: formData,
            processData: false,
            contentType: false,
            cache: false,
            beforeSend: function(xhr) {
                xhr.setRequestHeader("AJAX", "true");
            },
            success: function(response) {
                if (response.code === 200) {
                    alert("게시글을 성공적으로 수정하였습니다.");

                } else if (response.code === 500) {
                	alert("DB 정합성 오류가 발생하였습니다.");
                	
                } else if (response.code === 403) {
                	alert("수정 권한이 없는 게시글 혹은 카테고리 입니다.");
                
                } else if (response.code === 404) {
                	alert("게시글이 존재하지 않습니다.");
     
                } else if (response.code === 400) {
                	alert("비정상적인 접근입니다.");
                
                } else {
                	alert("서버 응답 오류로 게시글 수정에 실패하였습니다.");
                }
            },
            error: function(error) {
                alert("서버 응답 오류로 게시글 수정에 실패하였습니다.");
                icia.common.error(error);
            }
        });
    });
});

function fn_removeFile(bbsFileSeq) {
    if (confirm("정말로 이 파일을 삭제하시겠습니까?")) {
        $.ajax({
            type: "POST",
            url: "/bbs/deleteFile",
            data: {
            	bbsSeq: $("#bbsSeq").val(),
            	bbsFileSeq: bbsFileSeq
            },
            dataType: "JSON", 
            beforeSend: function(xhr) {
                xhr.setRequestHeader("AJAX", "true");
            },
            success: function(response) {
                if (response.code === 200) {
                	alert("파일을 삭제하였습니다.");
                	
                	let fileItem = $("button.delete-file[data-file-seq='" + bbsFileSeq + "']").closest("li.file-item");
                    fileItem.remove();

                    if ($(".file-list .file-item").length === 0) {
                        $(".file-list").remove();
                        $(".file-list-wrapper").append('<p class="no-files-message">현재 업로드된 파일이 없습니다.</p>');
                    }
                    
                } else if (response.code === 401) {
                	alert("삭제 권한이 없습니다.");
                	
                } else if (response.code === 500) {
                	alert("DB 정합성 오류가 발생하였습니다.");
                
                } else if (response.code === 404) {
                	alert("존재하지 않는 파일 삭제 혹은 게시글 입니다.");
                
                } else if (response.code === 400) {
                	alert("비정상적인 접근 입니다.");
                
                } else {
                	alert("서버 응답 오류로 파일 삭제에 실패하였습니다.");	
                }
            },
            error: function(error) {
                alert("서버 응답 오류로 파일 삭제에 실패하였습니다.");
                icia.common.error(error);
            }
        });
    }
}

</script>
</head>
<body id="index-body">
  <div class="bbs-Main-Page">
    <div class="bbs-Main">
      <%@include file="/WEB-INF/views/include/navigation.jsp"%>
      <div class="main-contanier">
        <%@include file="/WEB-INF/views/leftMainContent.jsp"%>
        <div class="update-container">
          <form name="updateForm" id="updateForm" method="post" enctype="multipart/form-data">
            <div class="write-header">
              <h1>글 수정</h1>
              <div class="update-section">
                <button type="button" class="listbtn" id="listbtn">리스트</button>
                <button type="button" class="write-btn" id="write-btn">수정</button>
              </div>
            </div>
            <div class="update-category">
              <select id="subCateCombinedNum" name="subCateCombinedNum">
                <option value="">게시판을 선택해 주세요.</option>
                  <c:forEach var="mainCate" items="${mainCateList}" varStatus="status">
                    <c:choose>
                      <c:when test="${loginUser.userType == 'USER'}">
                        <c:if test="${mainCate.mainCateNum != '01' && mainCate.mainCateNum != '05'}">
                          <optgroup label="${mainCate.mainCateName}">
                            <c:forEach var="subCate" items="${subCateListMap[mainCate.mainCateNum]}" varStatus="status">
                              <option value="${subCate.subCateCombinedNum}" <c:if test="${subCate.subCateCombinedNum == bbs.subCateCombinedNum}">selected</c:if>>${subCate.subCateName}</option>
                            </c:forEach>
                          </optgroup>
                        </c:if>
                      </c:when>
                      <c:when test="${loginUser.userType == 'BLOGGER'}">
                        <c:if test="${mainCate.mainCateNum != '05'}">
                          <optgroup label="${mainCate.mainCateName}">
                            <c:forEach var="subCate" items="${subCateListMap[mainCate.mainCateNum]}" varStatus="status">
                              <c:if test="${subCate.subCateCombinedNum != '0101'}">
                                <option value="${subCate.subCateCombinedNum}" <c:if test="${subCate.subCateCombinedNum == bbs.subCateCombinedNum}">selected</c:if>>${subCate.subCateName}</option>
                              </c:if>
                            </c:forEach>
                          </optgroup>
                        </c:if>
                      </c:when>
                      <c:otherwise>
                        <optgroup label="${mainCate.mainCateName}">
                          <c:forEach var="subCate" items="${subCateListMap[mainCate.mainCateNum]}" varStatus="status">
                            <option value="${subCate.subCateCombinedNum}" <c:if test="${subCate.subCateCombinedNum == bbs.subCateCombinedNum}">selected</c:if>>${subCate.subCateName}</option>
                          </c:forEach>
                        </optgroup>
                      </c:otherwise>
                    </c:choose>
                  </c:forEach>
              </select>
              <div></div>
              <div class="write-pwd">
                <label for="secretCheck" id="lockLabel">🔒</label> 
                <input type="checkbox" id="secretCheck" name="secretCheck">
                <input type="password" id="bbsPwd" name="bbsPwd" placeholder="비밀번호를 입력하세요." <c:choose><c:when test="${not empty bbs.bbsPwd}">value="${bbs.bbsPwd}"</c:when><c:otherwise>disabled</c:otherwise></c:choose>>
              </div>
            </div>

            <div class="file-list-wrapper">
              <p class="file-list-header">기존 파일 목록</p>
              <c:choose>
                <c:when test="${empty bbs.bbsFileList}">
                  <p class="no-files-message">기존에 업로드 되었던 파일이 없습니다.</p>
                </c:when>
                <c:otherwise>
                  <ul class="file-list">
                    <c:forEach var="bbsFile" items="${bbs.bbsFileList}">
                      <li class="file-item">
                        ${bbsFile.bbsFileOrgName}
                        <button type="button" class="delete-file" data-file-seq="${bbsFile.bbsFileSeq}" onclick="fn_removeFile('${bbsFile.bbsFileSeq}')">삭제</button>
                      </li>
                    </c:forEach>
                  </ul>
                </c:otherwise>
              </c:choose>
            </div>

            <div class="input-group" style="display: flex; align-items: center;">
              <label for="bbsFile" class="custom-file-upload" style="white-space: nowrap;">파일 선택</label> 
              <span class="file-name" id="fileName">선택된 파일 없음</span> 
              <input type="file" id="bbsFile" name="bbsFile" multiple style="display: none;">
            </div>
            <div class="update-title">
              <input type="text" id="bbsTitle" name="bbsTitle" placeholder="제목을 입력해 주세요." value="<c:out value='${bbs.bbsTitle}'/>" />
            </div>
            <div class="update-content">
              <textarea class="summernote" id="bbsContent" name="bbsContent" placeholder="내용을 입력하세요.">${bbs.bbsContent}</textarea>
            </div>
          </form>
        </div>
      </div>
      <%@ include file="/WEB-INF/views/include/footer.jsp"%>
    </div>
  </div>
  <form name="bbsForm" id="bbsForm" method="post">
    <input type="hidden" id="bbsSeq" name="bbsSeq" value="${bbsSeq}">
    <input type="hidden" id="bbsListCount" name="bbsListCount" value="${bbsListCount}">
    <input type="hidden" id="bbsCurPage" name="bbsCurPage" value="${bbsCurPage}">
    <input type="hidden" id="bbsOrderBy" name="bbsOrderBy" value="${bbsOrderBy}">  
    <input type="hidden" id="cateNum" name="cateNum" value="${cateNum}">
    <input type="hidden" id="cateFilter" name="cateFilter" value="${cateFilter}">
    <input type="hidden" id="periodFilter" name="periodFilter" value="${periodFilter}">
    <input type="hidden" id="isSecret" name="isSecret" value="${isSecret}">
    <input type="hidden" id="searchType" name="searchType" value="${searchType}">
    <input type="hidden" id="searchValue" name="searchValue" value="${searchValue}">
    <input type="hidden" id="comCurPage" name="comCurPage" value="${comCurPage}">
    <input type="hidden" id="comOrderBy" name="comOrderBy" value="${comOrderBy}">
  </form>
</body>
</html>