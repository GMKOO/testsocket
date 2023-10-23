
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>

<html>
<meta charset="UTF-8">
<link rel="stylesheet" href="./css/login.css">
<script src="./js/jquery-3.7.0.min.js"></script>
<head>
<title>로그인</title>


<script type="text/javascript">
//int count =Integer.parseInt(String.valueOf(result.get("count")));
	//모달사용하기위한링크 <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	//모달사용하기위한스크립 <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js">

	//Jquery 
	
  	//## 페이지 새로고침 이벤트가 발생할 때 실행할 코드


		document.addEventListener('DOMContentLoaded', function () {
			event.preventDefault(); 
			//세션에 저장된 count를 storage에 저장
			sessionStorage.setItem("reloadData", <%=session.getAttribute("count")%> );
			sessionStorage.setItem("id",  "<%=session.getAttribute("id")%>" );
			sessionStorage.setItem("name",  "<%=session.getAttribute("mname")%>" );
			
			const id = sessionStorage.getItem("id"); 	
			//storage에 저장된 숫자를 countStorage 저장
			const countStorage = sessionStorage.getItem("reloadData");  // 
			

			
		 if (countStorage == 1 && id != null ) {
			 
			 $(".loginForm").hide(); 
			   // reload(id); // #6. 로그인후 페이지 새로 고치면 로그인화면 그대로 보여주기 
				   //accountInfo(id);   // 계좌 정보 함수 호출
				   //extendSession(); // 세션 연장 함수 호출
			 
		 }
		   });
		

	

	//##여기가 main 시작##
	$(function() {
		$(".login").click(function() {
			event.preventDefault(); // 기본 동작을 막음. 폼 action 기능 새로고침을 막아준다.*중요*
			let id = $("#id").val();
			let pw = $("#pw").val();
			
			//#0. 로그인 length검사 함수 
				if (id.length < 2) {
					//alert(id.length);
					alert("아이디가 잘못 입력되었습니다.");
					$("#id").focus();
				} else if (pw.length < 4) {
					//alert(pw.length);
					alert("아이디와 비밀번호를 잘못 입력되었습니다.");
					$("#pw").focus();

				} else {
					
					$.ajax({
		                type: "POST",
		                url: "./login", // 폼의 action URL
		                data: $(".loginForm").serialize(), // 폼 데이터 직렬화
		                success: function(data) {
		               
		               	 window.location.href = "./login";
		               	 
		                    // 서버 응답 처리
		                },
		                error: function() {
		                    // 에러 처리
		                }
		            });
					
					
				}
			});
	});
			
	//버튼을 클릭해서 사용자 정보를 받아서 채팅 페이지로 이동 
	function navigateToChatPage(button) {
		  var toId = button.textContent;
			

	window.location.href = "/chat1?toId=" + toId;

	}
				
</script>
</head>

<div id="popupContent" style="display: none;">
	<p>로그인을 지속하실려면 연장버튼을 클릭해주세요.</p>
	<p>
		남은 시간: <span id="remainingTime">0</span>초
	</p>

</div>


<div id="exitContent" style="display: none;">
	<p>안내</p>
	<p>장시간 이용하시지 않아 로그아웃 되었습니다.</p>
	<p>
		남은 시간: <span id="exitTime">0</span>초
	</p>

</div>









<nav>

	<c:choose>
		<c:when test="${sessionScope.id eq null }">
			<li class="log1" onclick="location.href='./login'">로그인</li>

		</c:when>
		<c:otherwise>
			<li class="log2" onclick="">${sessionScope.id }님
				반갑습니다.</li>
			<li class="log1" type="button" onclick="location.href='./logout'"
				>로그아웃</li>
		</c:otherwise>
	</c:choose>
</nav>
<body>

<%
	String userId = null;

if (session.getAttribute("id") != null) {
	userId = (String) session.getAttribute("id");
}

%>
	<p style="text-align: center; border: medium;">
	<h1>로그인테스트페이지 </h1>
	</p>



	<form name="loginForm" class="loginForm" action="./login" method="post">

		<input type="text"  maxlength="20" placeholder="아이디"
			required="required" name="id" class="loginID" id="id"
			oninput="" /> <input type="password" name="pw"
			id="pw" class="loginPW" maxlength="12"
			required="required" placeholder="********"
			oninput="" /> <span>
			<button class="login" type="submit" onclick="">로그인
			</button>
		</span>
		<div class=loginOption>
			<a class="join" href="/join">회원가입</a> 
			<button class="serchID" type="button" onclick="" oninput="serchid()">ID찾기</button> 
			<a class="resetPW" href="비밀번호찾기주소">비밀번호초기화(재설정)</a>
		</div>
		<div>
		
	</div>

	</form>



	<button type="button" onclick="location.href='./'">홈으로</button>

    <button type="button" onclick="location.href='./chat1'">채팅</button>
    <div>
    <c:choose>
		<c:when test="${sessionScope.id eq null }">
		</c:when>
		<c:otherwise>
			
			<button class="menuname" type="button" onclick="navigateToChatPage(this)">상민</button>
			<button class="menuname" type="button" onclick="navigateToChatPage(this)">대규</button>
			<button class="menuname" type="button" onclick="navigateToChatPage(this)">재윤</button>
			<button class="menuname" type="button" onclick="navigateToChatPage(this)">종휘</button>
			<button class="menuname" type="button" onclick="navigateToChatPage(this)">관모</button>
			
		</c:otherwise>
	</c:choose>
</div>
</body>
</html>
