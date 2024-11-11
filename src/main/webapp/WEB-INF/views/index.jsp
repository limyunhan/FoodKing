<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">

<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<script>
$(document).ready(function(){
    	
	
	
	
	
	
	
});
</script>
</head>
<body id="index-body">
	<div class="Board-Main-Page">
		<div class="Board-Main">
			<%@include file="/WEB-INF/views/include/navigation.jsp"%>
			<div class="main-contanier">
				<%@include file="/WEB-INF/views/leftMainContent.jsp"%>
                <%@include file="/WEB-INF/views/bbs/rightMainContent.jsp"%>
			</div>
			<%@ include file="/WEB-INF/views/include/footer.jsp"%>
		</div>
	</div>
</body>
</html>