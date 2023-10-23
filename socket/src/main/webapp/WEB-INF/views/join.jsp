<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 화면</title>

<script src="https://code.jquery.com/jquery-3.7.0.min.js"
	integrity="sha256-2Pmvv0kuTBOenSvLm6bvfBSSHrUJ+3A7x6P5Ebd07/g="
	crossorigin="anonymous"></script>

<link rel="stylesheet"
	href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<script type="text/javascript">




	// 아이디 중복검사사용
	 $(function(){
		 $("#idCheck").click(function(){
			let id = $("#id").val();
			
			if(id == ""|| id.length <2) {
				
				$("#id").focus();
				$("#resultMSG").text("아이디는 2글자 이상이어야 합니다.");
				$("#resultMSG").css("color","red").css("font-weight","bold").css("font-size","15pt");
				
			} else { 
				$.ajax({
					
					url : "./joincheckid", //
					type : "post",
					data : {"id" : id},
				
					dataType : "json", // {result : 0}
					success : function(data) {
					
					
						
					if(data.result==1) { 
						$("#resultMSG").text("이미 등록된 아이디 입니다.");
						$("#resultMSG").css("color","red");
						
						$("#id").focus();
					} else {
						$("#resultMSG").css("color","green");
						$("#resultMSG").text("가입할 수 있습니다.");
			
						}
					
					},
					
					error: function(request,status,error){
						$("#resultMSG").text("오류가 발생 했습니다. 가입할 수 없습니다.");
					}
					
					
			
				}); //  ajax 시작 선언
			
			}
			return false; //  멈추기 
		 
		 });
	 });

	// 비밀번호 일치함수
	function joinpwck() {
		let pw = $(".joinPw").val();
		let id = $("#id").val();
		let pwck = $(".joinPwck").val();
		let name = $("#koreanInput").val();
	
		//var formData = $("#joinform").serialize(); // 폼 데이터를 직렬화 키,값으로 보낸다

		var formData= {
				"pw":pw, 
			 	"id":id,
			
				"name":name	
		};
		
		//주소는 나중에 그 선택하는거 사용하도록 업그레이드하자
		
		if(pw !== pwck) {
			
			$(".joinPwck").focus();
			$(".joinckMSG").text("비밀번호가 일치하지 않습니다.");
			alert("비밀번호가 일치 하지 않습니다.");
			$(".joinckMSG").css("color","red").css("font-weight","bold").css("font-size","15pt");
			return false;
		}else if(pw == pwck) {
			$(".joinckMSG").text("비밀번호가 일치 합니다.");
	
		$(".joinckMSG").css("color","green").css("font-weight","bold").css("font-size","15pt");
			
		}
		
		
		if(pw.length < 4) {
			
		
			$(".joinPwck").focus();
			$(".joinckMSG").text("비밀번호 길이를 확인해주세요.");
			alert("비밀번호 길이를 확인해주세요.");
			$(".joinckMSG").css("color","red").css("font-weight","bold").css("font-size","15pt");
			return false;
			
		
		}
		
		
		if(name.length < 2 ) {
			
			$("#name").focus();
			
			
			alert("이름을 정확히 입력해주세요");
			
			return false;
		}
		
	
		if( id.length < 2 ) {  //db에서아이디 같은지 다시확인?
			$("#id").focus();
			alert("id를 정확하게 입력해주세요.");
			return false;
		}
		
		//var formElement = document.getElementById("joinform");
		//var formData = new FormData(formElement);
	
		 
		
				
		
			
		joincreateid (formData); ////db에 신규회원 insert문
			
			return true;
			
	
	}
	
	//db에 신규회원 insert문
	function joincreateid (formData) {
		
	   
		
		

		
		 
	
			//db에 신규회원 insert문
			$.ajax({
				
				url : "./joincreateid", //
				type : "post",
				dataType : "json", // {result : 0}
				data : formData,
			
				success : function(data) {   
		
					 window.location.href = "./login";
		
			
				},
				
				error: function(request,status,error){
					$("#resultMSG").text("오류가 발생 했습니다. 가입할 수 없습니다.");
					
					return false;
				}
				
				
		
			}); //  ajax 끝
		
		
		}
		
	

</script>

</head>

<body>


	<div class="container">
		<form action="./join" method="post" name="joinform" id="joinform">
		<h1>회원가입</h1>
		<div>
			<input class="joinId" id="id" name="id" type="text" placeholder="아이디"
				required="required" maxlength="20" oninput=""/>
			
				<button id="idCheck"> 중복검사 </button>
				<P><span id="resultMSG"></span></p>
				
		</div>
		<div>
			<input class="joinPw"  required="required" name="pw1" type="password" placeholder="비밀번호"
				required="required" maxlength="20" oninput=""/>
		</div>
		<div>
			<input class="joinPwck"  required="required" name="pw2" type="password" placeholder="비밀번호확인"
				required="required" maxlength="20" oninput=""/>
				
				<P><span class="joinckMSG" id="joinckMSG"></span></p>
		</div>
		<div>
			<input class="joinName" id="koreanInput" required="required" name="name" type="text" placeholder="이름"
				required="required" maxlength="20" oninput=""/>
		</div>
		
		<div class="button1">
			<button type="submit" class="login" onclick="joinpwck()">가입하기</button>
			<button type="reset" class="login" >취소</button>
		</div>
		</form>
		</div>
	 
	


</body>
</html>