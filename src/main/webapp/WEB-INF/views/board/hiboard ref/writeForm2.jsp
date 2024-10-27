<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head2.jsp"%>
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/lang/summernote-ko-KR.min.js"></script>
<style>
    .note-editor {
        border: 2px solid #1e88e5; 
        border-radius: 5px; 
        font-family: "GmarketSans"; 
    }
    
    .note-editable {
        border: 2px solid #1e88e5; 
        color: #7B8AB8; 
        min-height: 500px; 
        padding: 10px; 
        border-radius: 5px;
    }
    
    .note-editable:focus {
        border: 4px solid #abccee;
    }
        
    .note-toolbar {
        border-radius: 5px; 
        margin-bottom: 5px; 
    }
</style>
<script type="text/javascript">
    $(document).ready(function() {
        $("#hiBbsTitle").focus();
        $("#hiBbsContent").summernote({
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
            fontNames: ['GmarketSans', 'Nanum Gothic', 'Noto Sans KR', 'Spoqa Han Sans'],
            fontNamesIgnoreCheck: ['GmarketSans', 'Nanum Gothic', 'Noto Sans KR', 'Spoqa Han Sans'],
            callbacks: {
            	// 사진 업로드시 동작하는 콜백 함수
            	onImageUpload: function(files) {
            	    for (let i = 0; i < files.length; i++) {
            	    	uploadImage(files[i]);
            	    }
            	},
            	
            	// 붙여넣기로도 이미지 삽입이 가능한데, 이 기능을 사용하면 paste 한 이미지 (base 64 경로)
            	// onImageUpload에서 생성한 이미지 (대체된 경로)가 둘다 삽입되는 버그를 방지하기 위함
            	onPaste: function (e) {
            		// 클립보드 데이터 가져오기
            		var clipboardData = e.originalEvent.clipboardData;
            		
            		// 클립보드 데이터가 존재하고, 아이템이 있는 경우
            		if (clipboardData && clipboardData.items && clipboardData.items.length) {
            			var item = clipboardData.items[0];
            			
            			// 아이템이 파일이며, 타입이 이미지인 경우
            			if (item.kind === "file" && item.type.indexOf("image/") !== -1) {
            				e.preventDefault(); // 기본 붙여넣기 동작을 방지
            			}
            		}
            	}
            }
            
        });
        
        $("#btnWrite").on("click", function() {
        	$("#btnWrite").prop("disabled", true);
        	
        	if ($.trim($("#hiBbsTitle").val()).length === 0) {
        	    alert("제목을 입력해주세요.");
        		$("#hiBbsTitle").val("");
        		$("#hiBbsTitle").focus();
        		$("#btnWrite").prop("disabled", false);
        		return;
        	}
            
        	if ($.trim($("#hiBbsContent").val()).length === 0) {
        	    alert("내용을 입력해주세요.");
        		$("#hiBbsContent").val("");
        		$("#hiBbsContent").focus();
        		$("btnWrite").prop("disabled", false);
        	    return;
        	}
        	
        	// jQuery 객체에서 DOM 객체를 가져온다. jQuery 객체는 배열은 아니지만 배열처럼 동작하므로 가장 먼저 선택된 요소의 DOM객체를 [0] 으로 가져올 수 있다.
        	var form = $("#writeForm")[0] 
            var formData = new FormData(form);        	
        	
        	$.ajax({
        	    type : "POST",
        	    enctype : "multipart/form-data",
        	    url : "/board/writeProc2",
        	    data : formData,
        	    processData : false,
        	    contentType : false,
        	    cache : false,
        	    timeout : 600000,
        	    beforeSend : function(xhr) {
        	    	xhr.setRequestHeader("AJAX", "true");
        	    },
        	    success : function(response) {
        	    	if (response.code === 200) {
        	    		alert("게시글을 성공적으로 작성하였습니다.");
        	    		document.bbsForm.action = "/board/list2";
        	    		document.bbsForm.submit();
        	    	} else if (response.code === 500) {
        	    		alert("DB 정합성 오류가 발생하였습니다.");
        	    		$("#btnWrite").prop("disabled", false);
        	    	} else if (response.code === 400) {
        	    		alert("비정상적인 접근입니다.");
        	    		$("#btnWrite").prop("disabled", false);
        	    	} else {
        	    		alert("서버 응답 오류가 발생하였습니다.");
        	    		$("#btnWrite").prop("disabled", false);
        	    	}
        	    },
        	    complete : function(data) {
        	    	icia.common.log(data);
        	    },
        	    error : function(xhr, status, error) {
        	    	icia.common.error(error);
        	    	alert("게시물 등록중 오류가 발생하였습니다.");
        	    	$("#btnWrite").prop("disabled", false);
        	    }
        	});
        });

        $("#btnList").on("click", function() {
        	document.bbsForm.action = "/board/list2";
            document.bbsForm.submit();
        });
    });
    
    function uploadImage(file) {
    	var data = new FormData();
    	data.append("image", file);
    	
    	$.ajax({
            type: "POST",
            enctype : "multipart/form-data",
    		url: "/board/image",
    		data: data,
    		contentType: false,
    		processData: false,
    		cache: false,
            beforeSend : function(xhr) {
                xhr.setRequestHeader("AJAX", "true");
            },
    		success: function(src) {
    			$("#hiBbsContent").summernote("insertImage", src);
    		},
    		error: function(xhr, status, error) {
    	        icia.common.error(error);
    		}
    	});
    }
</script>
</head>
<body>
  <%@ include file="/WEB-INF/views/include/navigation2.jsp"%>
  <div class="container">
    <h2>게시물 쓰기</h2>
    <form name="writeForm" id="writeForm" method="post" enctype="multipart/form-data">
      <input type="text" name="userName" id="userName" maxlength="20" value="${user.userName}" style="ime-mode: active;" class="form-control mt-4 mb-2" placeholder="이름을 입력해주세요." readonly> 
      <input type="text" name="userEmail" id="userEmail" maxlength="30" value="${user.userEmail}" style="ime-mode: inactive;" class="form-control mb-2" placeholder="이메일을 입력해주세요." readonly>
      <input type="text" name="hiBbsTitle" id="hiBbsTitle" maxlength="100" style="ime-mode: active;" class="form-control mb-2" placeholder="제목을 입력해주세요." required>
      <div class="form-group">
        <textarea class="form-control" rows="10" name="hiBbsContent" id="hiBbsContent" style="ime-mode: active;" placeholder="내용을 입력해주세요" required></textarea>
      </div>
      <input type="file" id="hiBbsFile" name="hiBbsFile" class="form-control mb-2" placeholder="파일을 선택하세요." multiple required />
      <small class="form-text text-muted">여러 파일을 선택하려면 Ctrl(또는 Command) 키를 누르면서 선택하세요.</small><br>
      <div class="form-group row">
        <div class="col-sm-12">
          <button type="button" id="btnWrite" class="btn btn-primary" title="저장">저장</button>
          <button type="button" id="btnList" class="btn btn-secondary" title="리스트">리스트</button>
        </div>
      </div>
    </form>
  </div>
  <form name="bbsForm" id="bbsForm" method="post">
    <input type="hidden" name="searchType" value="${searchType}">
    <input type="hidden" name="searchValue" value="${searchValue}">
    <input type="hidden" name="curPage" value="${curPage}">
  </form>
</body>
</html>