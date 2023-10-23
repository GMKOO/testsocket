<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<%
	String userId = null;

if (session.getAttribute("id") != null) {
	userId = (String) session.getAttribute("id");
}

%>

<h2>이거되야지</h2>
    <button type="button" onclick="location.href='./login'">로그인</button>
    <button type="button" onclick="location.href='./'">홈으로</button>
    <button type="button" onclick="location.href='./chat1'">채팅</button>
</body>
</html>