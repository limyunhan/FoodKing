<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>

<!DOCTYPE html>
<html lang="ko">

<head>
<%@include file="/WEB-INF/views/include/head.jsp"%>
<link
  href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css"
  rel="stylesheet">
<script
  src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
<script
  src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/lang/summernote-ko-KR.min.js"></script>
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
  background-color: #FFFFFF;
}

.note-editable:focus {
  border: 4px solid #abccee;
}

.note-toolbar {
  border-radius: 5px;
  margin-bottom: 5px;
}
</style>
<script>
$(document).ready(function() {
    $("#bbsTitle").focus();
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
            onImageUpload: function(files) {
                for (let i = 0; i < files.length; i++) {
                    uploadImage(files[i]);
                }
            },
            onPaste: function(e) {
                var clipbbsData = e.originalEvent.clipbbsData;

                if (clipbbsData && clipbbsData.items && clipbbsData.items.length) {
                    var item = clipbbsData.items[0];

                    if (item.kind === "file" && item.type.indexOf("image/") !== -1) {
                        e.preventDefault();
                    }
                }
            }
        }
    }).summernote('fontName', '을지로체')
      .summernote('fontSize', '18px');
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
          <form name="writeForm" id="writeForm" method="post">
            <div class="write-header">
              <h1>글쓰기</h1>
              <div class="write-section">
                <button type="button" class="listbtn" id="listbtn">리스트</button>
                <button type="button" class="write-btn" id="write-btn">등록</button>
              </div>
            </div>
            <div class="write-category">
              <select id="write-category">
                <option value="">게시판을 선택해 주세요.</option>
                <option value="1,1">[추천] 관리자가 추천하는 맛집</option>
                <option value="1,2">[추천] 블로거 추천</option>
                <option value="2,4">[커뮤니티] 자유게시판</option>
                <option value="3,6">[지역별 맛집] 경기도</option>
                <option value="3,7">[지역별 맛집] 서울</option>
                <option value="3,8">[지역별 맛집] 강원도</option>
                <option value="3,9">[지역별 맛집] 충청도</option>
                <option value="3,10">[지역별 맛집] 전라도</option>
                <option value="3,11">[지역별 맛집] 경상도</option>
                <option value="3,12">[지역별 맛집] 제주도</option>
                <option value="4,13">[테마별 맛집] 한식</option>
                <option value="4,14">[테마별 맛집] 중식</option>
                <option value="4,15">[테마별 맛집] 일식</option>
                <option value="4,16">[테마별 맛집] 양식</option>
                <option value="4,17">[테마별 맛집] 간식</option>
                <option value="5,18">[공지사항]</option>
                <option value="1,1">[추천] 관리자가 추천하는 맛집</option>
                <option value="1,2">[추천] 블로거 추천</option>
              </select>
              <div></div>
              <div class="write-pwd">
                <label for="lockLabel" id="lockLabel">🔒</label> <input
                  type="checkbox" id="secretCheck" name="secretCheck" />
                <input type="password" id="secretPassword"
                  name="secretPassword" placeholder="비밀번호를 입력하세요."
                  disabled />
              </div>
            </div>

            <div class="input-group"
              style="display: flex; align-items: center;">
              <label for="userImage" class="custom-file-upload"
                style="white-space: nowrap;">파일 선택</label> <span
                class="file-name" id="fileName">선택된 파일 없음</span> <input
                type="file" id="userImage" name="userImage">
            </div>

            <div class="write-title">
              <input type="text" id="bbsTitle" name="bbsTitle"
                placeholder="제목을 입력해 주세요." value="" />
            </div>

            <div class="write-content">
              <textarea id="bbsContent" name="bbsContent"
                placeholder="내용을 입력하세요."></textarea>
            </div>
            <input type="hidden" name="Catfirst" id="Catfirst" value="">
            <input type="hidden" name="firstName" id="firstName"
              value=""> <input type="hidden" name="Catsecond"
              id="Catsecond" value=""> <input type="hidden"
              name="secondName" id="secondName" value=""> <input
              type="hidden" name="bbsName" id="bbsName" value="">
            <input type="hidden" name="bbsSeq" id="bbsSeq" value="">
            <input type="hidden" name="searchType" value=""> <input
              type="hidden" name="searchValue" value=""> <input
              type="hidden" name="curPage" value="">
          </form>
        </div>
      </div>
      <%@ include file="/WEB-INF/views/include/footer.jsp"%>
    </div>
  </div>
</body>
</html>