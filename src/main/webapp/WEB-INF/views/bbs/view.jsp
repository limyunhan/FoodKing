<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/include/taglib.jsp" %>    

<!DOCTYPE html>
<html lang="ko">

<head>
<%@include file="/WEB-INF/views/include/head.jsp" %>
<script>
$(document).ready(function() {
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
              bbsSeq : "${bbs.bbsSeq}"
           },
           dataType: "JSON",
           beforeSend: function(xhr) {
              xhr.setRequestHeader("AJAX", "true");
           },
           success: function(response) {
               if (response.code === 201) {
                   alert("추천이 완료되었습니다.");
                   $("#recom-btn").removeClass('not-recommended').addClass('recommended');
                   var formattedRecomCnt = new Intl.NumberFormat().format(response.data);
                   $("#recom-btn").html("<i class='fas fa-thumbs-up'></i> 추천 (" + formattedRecomCnt + ")");
                   
               } else if (response.code === 200) {
                   alert("추천이 취소되었습니다.");
                   $("#recom-btn").removeClass('recommended').addClass('not-recommended');
                   var formattedRecomCnt = new Intl.NumberFormat().format(response.data);
                   $("#recom-btn").html("<i class='fas fa-thumbs-up'></i> 추천 (" + formattedRecomCnt + ")");
                   
               } else if (response.code === 404) {
                  alert("삭제된 게시글입니다.");
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
                userId: "${loginUser.userId}",
                bbsSeq: "${bbs.bbsSeq}"
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
              userId: "${loginUser.userId}",
              bbsSeq: "${bbs.bbsSeq}",
              comContent: $("#comContent").val(),   
              comOrderBy: $("#comOrderBy").val(),
              comCurPage: "${empty comPaging ? 1 : comPaging.endPage}"
          },
         dataType: "JSON",
         beforeSend: function(xhr) {
            xhr.setRequestHeader("AJAX", "true");
         },
         success: function(response) {
            if (response.code === 200) {
               alert("댓글이 작성되었습니다.");
                
                var comRefresh = response.data;
                
                if (comRefresh.bbsComCnt > 0) {
                    $(".comment-count").html("(" + comRefresh.bbsComCnt + ")");
                }
               
                $("#comCurPage").val(comRefresh.comCurPage);
                $("#comOrderBy").val(comRefresh.comOrderBy);
                
                var comPagingHtml = getComPagingHtml(comRefresh.comPaging);
                $(".pagination ul").html(comPagingHtml);
                
                var comListHtml = getComListHtml(comRefresh.comList);
                $(".comment-list").html(comListHtml);
                
                $("#comContent").val("");
               
            } else if (response.code === 500) {
               alert("DB 정합성 오류입니다.");
            
            } else if (response.code === 404) {
               alert("삭제된 게시글입니다.");
               document.bbsForm.action = "/bbs/list<c:if test="${!empty cateNum}">?cateNum=${cateNum}</c:if>";
               document.bbsForm.submit();
            
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
   
   $("#_comOrderBy").on("change", function() {
	   $("#comOrderBy").val($("#_comOrderBy").val());
	   $("#comCurPage").val("1");
	   
	   $.ajax({
	         type: "POST",
	         url: "/bbs/refreshCom",
	         data: {
	             userId: "${loginUser.userId}",
	             bbsSeq: "${bbs.bbsSeq}",
	             comOrderBy: $("#comOrderBy").val(),
	             comCurPage: $("#comCurPage").val()
	         },
	        dataType: "JSON",
	        beforeSend: function(xhr) {
	           xhr.setRequestHeader("AJAX", "true");
	        },
	        success: function(response) {
	           if (response.code === 200) {
	               
	               var comRefresh = response.data;
	               
	               if (comRefresh.bbsComCnt > 0) {
	                   $(".comment-count").html("(" + comRefresh.bbsComCnt + ")");
	               }
	               
	               $("#comCurPage").val(comRefresh.comCurPage);
	               $("#comOrderBy").val(comRefresh.comOrderBy);
	               
	               var comPagingHtml = getComPagingHtml(comRefresh.comPaging);
	               $(".pagination ul").html(comPagingHtml);
	               
	               var comListHtml = getComListHtml(comRefresh.comList);
	               $(".comment-list").html(comListHtml);
	               
	           } else if (response.code === 404) {
	               alert("삭제된 게시글입니다.");
                   document.bbsForm.action = "/bbs/list<c:if test="${!empty cateNum}">?cateNum=${cateNum}</c:if>";
                   document.bbsForm.submit();
	           
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

function getComPagingHtml(comPaging) {
    var comPagingHtml = "";
    
    if (comPaging.prevBlockPage > 0) {
        comPagingHtml += "<li><a href='javascript:void(0)' onclick='fn_list(" + comPaging.prevBlockPage + ")'>이전</a></li>";
    }
    
    for (var i = comPaging.startPage; i <= comPaging.endPage; i++) {
        if (i === comPaging.curPage) {
            comPagingHtml += "<li><a href='javascript:void(0)' style='cursor:default; color: #999;'>" + i + "</a></li>";
        } else {
            comPagingHtml += "<li><a href='javascript:void(0)' onclick='fn_list(" + i + ")'>" + i + "</a></li>";
        }
    }
    
    if (comPaging.nextBlockPage > 0) {
        comPagingHtml += "<li><a href='javascript:void(0)' onclick='fn_list(" + comPaging.nextBlockPage + ")'>다음</a></li>";
    }

    return comPagingHtml;
}

function getComListHtml(comList) {
	var loginUserId = "${loginUser.userId}";
    var comListHtml = "";

    comList.forEach(function(com) {
        var indentStyle = "style='margin-left: " + (com.comIndent * 20) + "px;'";

        var deletedClass = com.comStatus !== "Y" ? "deleted" : "";

        var commentBody = "";
        if (com.comStatus !== 'Y') {
            commentBody = 
                "<div class='comment-body deleted-comment'>" +
                "<p>삭제된 댓글입니다.</p>" +
                "</div>";
        } else {
            commentBody = 
                "<div class='comment-item-header'>" +
                    "<span class='comment-author'>" + com.userName + "</span>" +
                    "<span class='comment-date'>" + com.comRegDate + "</span>" +
                "</div>" +
                "<div class='comment-body'>" +
                    "<p>" + com.comContent + "</p>" +
                    "<div class='comment-action'>" +
                        "<button type='button' id='comReply-btn' class='action-btn' onclick='replyCom(" + com.comSeq + ")'>답글</button>" +
                        (com.userId === loginUserId ? 
                            "<button type='button' id='comEdit-btn' class='action-btn' onclick='editCom(" + com.comSeq + ")'>수정</button>" +
                            "<button type='button' id='comDelete-btn' class='action-btn' onclick='deleteCom(" + com.comSeq + ")'>삭제</button>" 
                            : '') +
                    "</div>" +
                "</div>";
        }

        comListHtml += 
            "<li data-seq='" + com.comSeq + "' class='comment-item " + deletedClass + "' " + indentStyle + ">" +
                commentBody +
            "</li>";
    });

    return comListHtml;
}

function fn_list(comSeq) {
	$.ajax({
         type: "POST",
         url: "/bbs/refreshCom",
         data: {
             userId: "${loginUser.userId}",
             bbsSeq: "${bbs.bbsSeq}",
             comOrderBy: $("#comOrderBy").val(),
             comCurPage: comSeq
         },
        dataType: "JSON",
        beforeSend: function(xhr) {
           xhr.setRequestHeader("AJAX", "true");
        },
        success: function(response) {
           if (response.code === 200) {
        	   
               var comRefresh = response.data;
               
               if (comRefresh.bbsComCnt > 0) {
                   $(".comment-count").html("(" + comRefresh.bbsComCnt + ")");
               }
               
               $("#comCurPage").val(comRefresh.comCurPage);
               $("#comOrderBy").val(comRefresh.comOrderBy);
               
               var comPagingHtml = getComPagingHtml(comRefresh.comPaging);
               $(".pagination ul").html(comPagingHtml);
               
               var comListHtml = getComListHtml(comRefresh.comList);
               $(".comment-list").html(comListHtml);

               $("html, body").animate({
                   scrollTop:  $(".comment-list .comment-item").offset().top
               }); 
               
               
           } else if (response.code === 404) {
        	   alert("삭제된 게시글입니다.");
               document.bbsForm.action = "/bbs/list<c:if test="${!empty cateNum}">?cateNum=${cateNum}</c:if>";
               document.bbsForm.submit();
           
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
}

function fn_refresh() {
	$.ajax({
        type: "POST",
        url: "/bbs/refreshCom",
        data: {
            userId: "${loginUser.userId}",
            bbsSeq: "${bbs.bbsSeq}",
            comOrderBy: $("#comOrderBy").val(),
            comCurPage: $("#comCurPage").val()
        },
       dataType: "JSON",
       beforeSend: function(xhr) {
          xhr.setRequestHeader("AJAX", "true");
       },
       success: function(response) {
          if (response.code === 200) {
              
              var comRefresh = response.data;
              
              if (comRefresh.bbsComCnt > 0) {
                  $(".comment-count").html("(" + comRefresh.bbsComCnt + ")");
              }
              
              $("#comCurPage").val(comRefresh.comCurPage);
              $("#comOrderBy").val(comRefresh.comOrderBy);
              
              var comPagingHtml = getComPagingHtml(comRefresh.comPaging);
              $(".pagination ul").html(comPagingHtml);
              
              var comListHtml = getComListHtml(comRefresh.comList);
              $(".comment-list").html(comListHtml);
              
          } else if (response.code === 404) {
              alert("삭제된 게시글입니다.");
              document.bbsForm.action = "/bbs/list<c:if test="${!empty cateNum}">?cateNum=${cateNum}</c:if>";
              document.bbsForm.submit();
              
          
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
}

function replyCom(comSeq) {
    var $comLi = $("li[data-seq='" + comSeq + "']");

    if ($comLi.find(".reply-box").length > 0) {
        return;
    }

    const replyBoxHTML = 
        "<div class='reply-box' style='margin-top: 10px;'>" +
          "<textarea class='reply-textarea' name='replyContent' rows='3' placeholder='답글을 작성하세요'></textarea>" +
            "<div class='reply-action' style='text-align: right; margin-top: 5px;'>" +  
              "<button type='button' class='action-btn' onclick='InsertReply(" + comSeq + ")'>작성</button>" +
              "<button type='button' class='action-btn' onclick='cancelReply(this)'>취소</button>" +
            "</div>" +
        "</div>";
        
    $comLi.append(replyBoxHTML);   
}

function InsertReply(comSeq) {
	var $comLi = $("li[data-seq='" + comSeq + "']");
	var replyContent = $.trim($comLi.find("textarea[name='replyContent']").val());
	    

    if (replyContent.length === 0) {
        alert("답글 내용을 입력하세요.");
        $comLi.find("textarea[name='replyContent']").val(""); 
        $comLi.find("textarea[name='replyContent']").focus(); 
        return;
    }

    
    $.ajax({
    	type: "POST",
    	url: "/bbs/writeComReply",
    	data: {
    		comSeq: comSeq,
    		userId: "${loginUser.userId}",
    		bbsSeq: $("#bbsSeq").val(),
    		comContent: replyContent
    	},
    	dataType: "JSON",
    	beforeSend: function(xhr) {
    		xhr.setRequestHeader("AJAX", "true");
    	},
    	success: function(response) {
    		if (response.code === 200) {
    			alert("답글을 성공적으로 작성하였습니다.");
    			fn_refresh();
    			
    		} else if (response.code === 500) {
    			alert("DB 정합성 오류가 발생하였습니다.");
   
    		} else if (response.code === 410) {
    			alert("삭제되거나 존재하지 않는 댓글입니다.");
    			
    		} else if (response.code === 404) {
    			alert("삭제된 게시글 입니다.");
    			
    		} else if (response.code === 400) {
    			alert("비정상적인 접근입니다.");
    			
    		} else {
    			alert("서버오류로 답글 작성에 실패하였습니다.");          
    		}
    	},
    	error: function(error) {
    	    alert("서버오류로 답글 작성에 실패하였습니다.");    		
    		icia.common.error(error);
    	}
    });
}

function cancelReply(button) {
    const $replyBox = $(button).closest(".reply-box");
    
    if ($replyBox.length) {
        $replyBox.remove(); 
    }
}

function editCom(comSeq) {
	
	
}

function deleteCom(comSeq) {
	
	
	
}
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
              <p><b>카테고리:</b> ${bbs.bbsSubCateName}</p>
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
                <i class="fa-solid fa-rotate-right refresh-icon" title="새로고침" onclick="fn_refresh()"></i>
              <div class="comment-sort">
                <select id="_comOrderBy" name="_comOrderBy">
                  <option value="1" <c:if test="${comOrderBy == '1'}">selected</c:if>>등록순</option>
                  <option value="2"> <c:if test="${comOrderBy == '2'}">selected</c:if>최신순</option>
                  <option value="3"> <c:if test="${comOrderBy == '3'}">selected</c:if>답글순</option>
                </select>
              </div>
            </div>
            <ul class="comment-list">
              <c:if test="${!empty comList}">
                <c:forEach var="com" items="${comList}">
                  <li data-seq="${com.comSeq}" class="comment-item <c:if test='${com.comStatus != "Y"}'>deleted</c:if>" style="margin-left: ${com.comIndent * 20}px;"> 
                    <c:choose>
                      <c:when test="${com.comStatus != 'Y'}">
                        <div class="comment-body deleted-comment">
                          <p>삭제된 댓글입니다.</p>
                        </div>
                      </c:when>
                      <c:otherwise>
                        <div class="comment-item-header">
                          <span class="comment-author">${com.userName}</span>
                          <span class="comment-date">${com.comRegDate}</span>
                        </div>
                        <div class="comment-body">
                          <p><c:out value="${com.comContent}" /></p>
                          <div class="comment-action">
                            <button type="button" id="comReply-btn" class="action-btn" onclick="replyCom(${com.comSeq})">답글</button>
                            <c:if test="${com.userId == loginUser.userId }">
                              <button type="button" id="comEdit-btn" class="action-btn" onclick="editCom(${com.comSeq})">수정</button>
                              <button type="button" id="comDelete-btn" class="action-btn" onclick="deleteCom(${com.comSeq})">삭제</button>
                            </c:if>
                          </div>
                        </div>
                      </c:otherwise>
                    </c:choose>
                  </li>
                </c:forEach>
              </c:if>
            </ul>

            <!-- 페이징 처리 -->
            <div class="pagination">
              <ul>
                <c:if test="${!empty comPaging}">
                  <c:if test="${comPaging.prevBlockPage gt 0}">
                    <li><a href="javascript:void(0)" onclick="fn_list(${comPaging.prevBlockPage})">이전</a></li>
                  </c:if>
                  <c:forEach var="i" begin="${comPaging.startPage}" end="${comPaging.endPage}" step="1" varStatus="status">
                    <c:choose>
                      <c:when test="${i ne comPaging.curPage}">
                        <li><a href="javascript:void(0)" onclick="fn_list(${i})">${i}</a></li>
                      </c:when>
                      <c:otherwise>
                        <li><a href="javascript:void(0)" style="cursor:default; color: #999;">${i}</a></li>
                      </c:otherwise> 
                    </c:choose>                  
                  </c:forEach>
                  <c:if test="${comPaging.nextBlockPage gt 0}">
                    <li><a href="javascript:void(0)" onclick="fn_list(${comPaging.nextBlockPage})">다음</a></li>
                  </c:if>
                </c:if>
              </ul>
            </div>
            
            <textarea id="comContent" name="comContent" rows="4" cols="50" placeholder="댓글을 작성해주세요" required></textarea>
            <button id="com-btn" class="com-btn">댓글 달기</button>
            
          </div>
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