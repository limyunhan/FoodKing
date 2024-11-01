<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@include file="/WEB-INF/views/include/taglib.jsp" %>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>

<div class="content">
	<article class="board">
		<h3>
			<a href="javascript:void(0)" onclick="fn_firstList(,'')">공지사항</a>
		</h3>
		<table>
			<tbody>
				<tr class="rightMain" onclick=");
                            openPasswordModal(, '');
                            fn_view();">
					
					<td><a href="javascript:void(0)">🔑비밀글 입니다.</a></td>
					
				</tr>
			</tbody>
		</table>
	</article>



	<article class="board">
		<h3>
			<a href="javascript:void(0)" onclick="fn_firstList(,'')">자유게시판</a>
		</h3>
		<table>
			<tbody>
				<tr class="rightMain" onclick="fn_view();
                            openPasswordModal(, '');fn_view();">
					<td><a href="javascript:void(0)">🔑비밀글 입니다.</a></td>
					
				</tr>
			</tbody>
		</table>
	</article>

	<article class="board">
		<h3>
			<a href="javascript:void(0)" onclick="fn_firstList(,'')">지역별 맛집</a>
		</h3>
		<table>
			<tbody>
				<tr class="rightMain" onclick="fn_view();
                            openPasswordModal(, '');fn_view();">
					<td><a href="javascript:void(0)">🔑비밀글 입니다.</a></td>
					
				</tr>
			</tbody>
		</table>
	</article>

	<article class="board">
		<h3>
			<a href="javascript:void(0)" onclick="fn_firstList(,'')">테마별 맛집</a>
		</h3>
		<table>
			<tbody>
				<tr class="rightMain" onclick="fn_view();
                            openPasswordModal(, '');fn_view();">
					<td><a href="javascript:void(0)">🔑비밀글 입니다.</a></td>
					
				</tr>
			</tbody>
		</table>
	</article>
</div>
<div id="passwordModal" style="display:none;">
				    <div class="modal-content">
				        <h3>비밀번호 입력</h3>
				        <input type="password" id="inputPassword" placeholder="비밀번호를 입력하세요" />
				        <button id="checkPasswordButton">확인</button>
				        <button id="closeModalButton">취소</button>
				    </div>
				</div>
<form name="listForm" id="listForm" method="post">
		<input type="hidden" name="boardSeq" value="">	
</form>

<form name="rightForm" id="rightForm" method="POST">
	<input type="hidden" name="Catfirst" id="Catfirst" value="">
	<input type="hidden" name="Catsecond" id="Catsecond" value="">
	<input type="hidden" name="firstName" id="firstName" value="">
	<input type="hidden" name="secondName" id="secondName" value="">
</form>

<script>
