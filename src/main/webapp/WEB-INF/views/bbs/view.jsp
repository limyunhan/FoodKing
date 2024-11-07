<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/include/taglib.jsp" %>    
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>

<!DOCTYPE html>
<html lang="ko">

<head>
<%@include file="/WEB-INF/views/include/head.jsp" %>
<script>
$(document).ready(function() {
	if ($("#isRefresh").val() === "false") {
		
	}
	
	
	$("#list-btn").on("click", function(){
	    document.bbsForm.action = "/bbs/list<c:if test="${!empty cateNum}">?cateNum=${cateNum}</c:if>";
        document.bbsForm.submit();
	});
	
	<c:if test="${loginUser.userId == bbs.userId }">
  	$("#bbsEdit-btn").on("click", function() {
  		
  		
  		
  	});
  	
  	$("#bbsDelete-btn").on("click", function() {
  		
  		
  		
  	});
	</c:if>
	
	$("#recom-btn").on("click", function() {
	    $.ajax({
	        type: "POST",
	        url: "/bbs/recom",
	        data: {
	        	userId : "${loginUser.userId}",
	        	bbsSeq : ${bbs.bbsSeq}
	        },
	        dataType: "JSON",
	        beforeSend: function(xhr) {
	        	xhr.setRequestHeader("AJAX", "true");
	        },
	        success: function(response) {
	            if (response.code === 201) {
	                alert("추천이 완료되었습니다.");
	                $('#recom-btn').removeClass('not-recommended').addClass('recommended');
	                var formattedRecomCnt = new Intl.NumberFormat().format(response.data);
	                $('#recom-btn').html("<i class='fas fa-thumbs-up'></i> 추천 (" + formattedRecomCnt + ")");
	                
	            } else if (response.code === 200) {
	                alert("추천이 취소되었습니다.");
	                $("#recom-btn").removeClass('recommended').addClass('not-recommended');
	                var formattedRecomCnt = new Intl.NumberFormat().format(response.data);
	                $("#recom-btn").html("<i class='fas fa-thumbs-up'></i> 추천 (" + formattedRecomCnt + ")");
	                
	            } else if (response.code === 404) {
	            	alert("삭제된 게시글입니다.");
	                document.bbsForm.bbsCurPage.value = "1";
	                document.bbsForm.action = "/bbs/list<c:if test="${!empty cateNum}">?cateNum=${cateNum}</c:if>";
	                document.bbsForm.submit();
	                
	            } else if (response.code === 500) {
	            	alert("DB 정합성 오류가 발생하였습니다.");
	            	
	            } else if (response.code === 400){
	            	alert("비정상적인 접근입니다.");
	            
	            } else {
	            	alert("서버 응답오류가 발생하였습니다.");
	            }
	        },
	        error: function(error) {
	        	alert("서버 응답오류가 발생하였습니다.");
	        	icia.common.error(error);	
	        }
	    });
	});
	
	$("#bookmark-btn").on("click", function() {
        $.ajax({
            type: "POST",
            url: "/bbs/bookmark",
            data: {
                userId : "${loginUser.userId}",
                bbsSeq : ${bbs.bbsSeq}
            },
            dataType: "JSON",
            beforeSend: function(xhr) {
                xhr.setRequestHeader("AJAX", "true");
            },
            success: function(response) {
                if (response.code === 200) {
                	alert("북마크에 추가되었습니다.");
                	$("h1 .fa-bookmark").show(); 
                } else if (response.code === 201) {
                	alert("북마크에서 삭제되었습니다.");
                	$("h1 .fa-bookmark").hide(); 
                	
                } else if (response.code === 500) {
                	alert("DB 정합성 오류입니다.");
                
                } else if (response.code === 400) {
                	alert("비정상적인 접근입니다.");
                
                } else {
                	alert("서버 응답오류가 발생하였습니다.");
                }
                
            },
            error: function(error) {
                alert("서버 응답오류가 발생하였습니다.");
                icia.common.error(error);   
            }
        });
    });
	
	$("#com-btn").on("click", function() {
		if ($.trim($("#comContent").val()).length === 0) {
			alert("댓글 내용을 입력하세요.");
			$("#comContent").val("");
			$("#comContent").focus();
			return;
		}
		
		$.ajax({
		    type: "POST",
		    url: "/bbs/writeCom",
		    data: {
		        userId: ${loginUser.userId},
		        bbsSeq: document.bbsForm.bbsSeq.value,
		        comContent: $("#comContent").val(),   
		        comOrderBy: $("#comOrderBy").val(),
		        comCurPage: ${empty comPaging ? 1 : comPaging.endPage}
		    },
			dataType: "JSON",
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", "true");
			},
			success: function(response) {
				if (response.code === 200) {
					alert("댓글이 작성되었습니다.");
					document.bbsForm.comCurPage.value = response.data;
				    document.bbsForm.action = "/bbs/view";
					
				} else if (response.code === 500) {
					alert("DB 정합성 오류입니다.");
				
				} else if (response.code === 404) {
					alert("삭제된 게시글입니다.");
				
				} else if (response.code === 400) {
				    alert("비정상적인 접근입니다.");
				
				} else {
				    alert("서버 응답 오류가 발생하였습니다.")    					
				}
			},
			error: function(error) {
			    alert("서버 응답 오류가 발생하였습니다.");
			    icia.common.error(error);
			}
		});
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
        <div class="post-container">
          <div class="post-header">
            <div class="post-header-info">
              <h1>
                <c:choose>
                  <c:when test="${bbs.isBookmarked == 'Y' }">
                    <i class="fa-solid fa-bookmark" style="display: inline;"></i> 
                  </c:when>
                  <c:otherwise>
                    <i class="fa-solid fa-bookmark" style="display: none;"></i> 
                  </c:otherwise>
                </c:choose>
                <c:out value="${bbs.bbsTitle}" />
              </h1>
              <p><b>작성자:</b> ${bbs.userName}</p>
              <p><b>등록일:</b> ${bbs.bbsRegDate}</p>
              <c:if test="${!empty bbs.bbsUpdateDate}"><p><b>최근 수정일:</b> ${bbs.bbsUpdateDate}</p></c:if>
              <p><b>조회수:</b> <fmt:formatNumber type="Number" maxFractionDigits="3" groupingUsed="true" value="${bbs.bbsReadCnt}" /></p>
            </div>
            <div style="display: flex; flex-direction: column;">
              <div class="post-header-buttons">
                <button class="list-btn" id="list-btn">리스트</button>
                <button class="bookmark-btn" id="bookmark-btn">북마크</button>
                <c:if test="${loginUser.userId == bbs.userId }">
                  <button class="edit-btn" id="bbsEdit-btn">수정</button>
                  <button class="delete-btn" id="bbsDelete-btn">삭제</button>
                </c:if>
              </div>
            </div>
          </div>
          <div class="post-content" style="position: relative;">
            <div class="viewContent">
              <c:out value="${bbs.bbsContent}" escapeXml="false" />
              <div class="recom-container">
                <button type="button" id="recom-btn" class="recom-btn ${bbs.isRecommended == 'Y' ? 'recommended' : 'not-recommended'}">
                  <i class='fas fa-thumbs-up'></i> 추천 (<fmt:formatNumber type="Number" maxFractionDigits="3" groupingUsed="true" value="${bbs.bbsRecomCnt}" />)
                </button>
              </div>
            </div>
          </div> 
          
          <div class="comments-section">
            <div class="comments-header" style="display: flex; justify-content: space-between; align-items: center;">
              <h3>전체 댓글</h3>
                <span class="comment-count">
                  <c:if test="${bbs.bbsComCnt != 0}">
                    (<fmt:formatNumber type="Number" maxFractionDigits="3" groupingUsed="true" value="${bbs.bbsComCnt}" />)
                  </c:if>
                </span>
                <i class="fa-solid fa-rotate-right refresh-icon" title="새로고침"></i>
              <div class="comment-sort">
                <select id="comOrderBy" name="comOrderBy">
                  <option value="1">등록순</option>
                  <option value="2">최신순</option>
                  <option value="3">답글순</option>
                </select>
              </div>
            </div>
            <ul class="comment-list">
              <c:if test="${!empty comList}">
                <c:forEach var="com" items="${comList}">
                  <li class="comment-item">
                    <div class="comment-item-header">
                      <span class="comment-author">${com.userName}</span>
                      <span class="comment-date">${com.comRegDate}</span>
                    </div>
                    <div class="comment-body">
                      <p>${com.comContent}</p>
                    </div>
                  </li>
                </c:forEach>
              </c:if>
            </ul>
            <form id="comForm" method="post">
              <textarea id="comContent" name="comContent" rows="4" cols="50" placeholder="댓글을 작성해주세요" required></textarea>
              <button type="submit" id="com-btn" class="com-btn">댓글 달기</button>
            </form>
          </div>
          
        </div>
      </div>
      <%@ include file="/WEB-INF/views/include/footer.jsp"%>
    </div>
  </div>
  <form name="bbsForm" id="bbsForm" method="post">
    <input type="hidden" name="bbsSeq" value="${bbsSeq}">
    <input type="hidden" name="bbsListCount" value="${bbsListCount}">
    <input type="hidden" name="bbsCurPage" value="${bbsCurPage}">
    <input type="hidden" name="bbsOrderBy" value="${bbsOrderBy}">  
    <input type="hidden" name="cateNum" value="${cateNum}">
    <input type="hidden" name="cateFilter" value="${cateFilter}">
    <input type="hidden" name="periodFilter" value="${periodFilter}">
    <input type="hidden" name="isSecret" value="${isSecret}">
    <input type="hidden" name="searchType" value="${searchType}">
    <input type="hidden" name="searchValue" value="${searchValue}">
    <input type="hidden" name="comCurPage" value="${comCurPage}">
    <input type="hidden" name="comOrderBy" value="${comOrderBy}">
    <input type="hidden" name="isRefresh" value="${isRefresh}">
  </form>
</body>
</html>