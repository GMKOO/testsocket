<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
	<head>
		<title>Chat</title>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
		<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.5.0/css/all.css" integrity="sha384-B4dIYHKNBt8Bc12p+WXckhzcICo0wtJAoU8YZTY5qE0Id1GSseTk6S+L3BlXeVIU" crossorigin="anonymous">
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
		<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.min.css">
		<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/malihu-custom-scrollbar-plugin/3.1.5/jquery.mCustomScrollbar.min.js"></script>
		<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
		<link rel="stylesheet" href="./css/chat.css">
<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
<style type="text/css">
	
</style>


	
<!------ Include the above in your HEAD tag ---------->
	</head>

	<!--Coded With Love By Mutiullah Samim-->
	<body>
		<div class="container-fluid h-100">
			<div class="row justify-content-center h-100">
			<!-- 대화방목록 시작단 -->
				
				
				<!-- 대화방목록 끝단 -->
				<div class="col-md-8 col-xl-6 chat" id="msgload">
				
				
					<div class="card msgload">
					
					<!-- 여기서부터 채팅창 내용 새로 동적생성 -->
						
					
					<!-- 여기서부터 채팅창 내용 새로 동적생성 끝단 -->
						<div class="card-footer">
							<div class="input-group">
								<div class="input-group-append">
									<span class="input-group-text attach_btn"><i class="fas fa-paperclip"></i></span>
								</div>
								<textarea name="" id="message" class="form-control type_msg" placeholder=""></textarea>
								<div class="input-group-append">
									<span class="input-group-text send_btn" type="button" id="send-button" onclick="sendMessage()"><i class="fas fa-location-arrow"></i></span>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		
			<script type="text/javascript">

	document.addEventListener('DOMContentLoaded', function() {
		  const messageInput = document.getElementById('message');
		  const sendButton = document.getElementById('send-button');
	
		  
		messageInput.addEventListener('keydown', function(event) {
		    if (event.key === 'Enter' && !event.shiftKey) {
		      // 엔터 키가 눌렸을 때 클릭 효과 추가
		      sendButton.classList.add('button-clicked');
		      
		      setTimeout(function() {
		          sendButton.classList.remove('button-clicked');
		        }, 100);
		      
	}
		});
	});
	/*
	
	$(document).ready(function(){
$('#action_menu_btn').click(function(){
	$('.action_menu').toggle();
});
	});
	*/
	
	//  ##대화창 메뉴바 출력##
	$(document).on('click', '#action_menu_btn', function(){
	    $('.action_menu').toggle();
	});
	


	 const socket = new WebSocket("ws://localhost:80/chat"); // 서버 주소로 변경
	 
	 
	 // ##소켓 연결##
     socket.onopen = function(event) {
       	console.log("커넥션이 만들어졌습니다.");

       	// ## 1.세션이 연결될때  세션에있는 사용자 이름을 담아서 보내준다.##  --첫연결--로그인세션아이디보냄-- ##
    	var clientId = sessionStorage.getItem("name"); 
    	
       	socket.send(JSON.stringify({ "name": clientId}));
    	//chat.scrollTop = chat.scrollHeight;
    	
    	
    	
    	// ## 2. 게시글에서 대화하기로 접속시 쿼리로 상대방 ID값 받고 그 값으로 queryserchid 함수 실행 ##
    	var queryString = window.location.search;
    	var urlParams = new URLSearchParams(queryString);
    	 var fromname = urlParams.get("fromname");

    	if (fromname==null || fromname ===null) {
    		
    	
    	} else {
    		
    		// ## 2-1 ##
    	   	queryserchid(fromname);
    		
    	}
    	

    
     };
     
 	//##.3 url에서 fromname 가져오는 함수##
 	function queryserchid(fromname) {
 		

 		
 		var myname = sessionStorage.getItem("name"); 
 		
 		 // 클릭한 li 요소에 "active" 클래스를 추가
    	
 		
 		if(fromname == null || fromname === "null") {
 			// 현재 페이지의 URL에서 쿼리 문자열을 가져옵니다.
     		var queryString = window.location.search;

     		// URLSearchParams를 사용하여 쿼리 문자열을 파싱합니다.
     		var urlParams = new URLSearchParams(queryString);

     		// "fromname" 파라미터 값을 가져옵니다.
     		 fromname = urlParams.get("fromname");

     	
 		      // 3-1 Ajax통신으로 serchid함수실행
     	  		serchidutil(fromname,myname);
    		 
				 
		
			
 			
 		} else if(fromname.toLowerCase()===myname.toLowerCase()) {
 			
 			//event.preventDefault();
 			alert("자기 자신과 대화를 할수 없습니다.");
 			  window.history.back();
 			
 			return false;
 		}
 		
 		serchidutil(fromname,myname);
 	

 	}
 	
 	// ## 3-2 서버에게 재생성할 데이터 요청 ## 소켓서비스에서 첫 대화인 경우 isFirstConversation함수로 체크 후 공백 메세지 저장 ##
   	// ## 8-1 이어서 실행##	
 	function serchidutil(fromname,myname) {
 		
    		$.ajax({
                type: "GET",
                url: "./serchid", // 폼의 action URL
                data: {
                	"fromname" : fromname,
                	"myname" : myname
                	},
                success: function(data) {
                	var jsonData = JSON.parse(data); 
   
                	$(".msgload").remove();
        		    
                	//## 3-3 대화창 재생성##
                	//## 8-2 대화창 재생성##
                	msgload(jsonData);
                	
                	
       
                	//jsonData.list.length 리스트에 담아서 이걸로 풀어내야됨 객체별로 나오니깐
                	//여기서 반복문을 시작해서 객체로받아와서 (1행씩) if문으로 from_user_id 세션 id랑 비교해서 같으면 
                	// function msgappendsend(event) 이함수실행 오른쪽채팅
                	// 다르면 왼쪽실행   중요한게 저장된 순서에 따라 글순서가 바뀌니 sql문에서 정렬기능 염두해야됨
                	
                	//그리고 대화방을 눌렀을때 선택된 css만 변경해서바꾸고 바뀌면 나머지는none로 바꾸고
                	//대화 채팅 동적 재생성을해서  상대별로 대화목록 리스트업 하기 
                	//순서를 1.가라데이터로 데이터불러와서 채팅방 재생성 만들고
                	//2.대화방 클릭시 class 변경해서 선택되게 바꾸기 선택해제된건 다시 class변경되게  css주고
                	//3.
                	
                	// 다시순서 상대방 닉네임을보고 대화하기 버튼클릭 > 새로운 대화방 생성 및 상대방 닉네임 보여주고 채팅내역은x 
                	// 채팅창에
            
   
                    // 서버 응답 처리
                },
                error: function() {
    		
    	}

});
 		
 	}
 	



 //## 6.서버로부터 메세지 수신##
socket.onmessage = function(event) {
	
	//## 6-1 ##
	msgappend(event.data);
	chat.scrollTop = chat.scrollHeight;
  
};


//const decoder = new TextDecoder('utf-8');
//const decodedString = decoder.decode(event);
//문자열을 UTF-8로 인코딩하는 함수
function utf8Encode(str) {
  const encoder = new TextEncoder('utf-8');
  return encoder.encode(str);
}



  // ## 5. 메시지전송 ##
function sendMessage() {

	 const messageInput = document.getElementById("message");
	 const chat = document.getElementById("chat");
	  const name = sessionStorage.getItem("name"); 
          const message = messageInput.value;
          
          
        
         //시간 포맷해서 가져오기
          const formattedTime = getCurrentTimeFormatted();
          
          content = '<div class="d-flex justify-content-end mb-4">';
          content += '<span class="msg_time_send">'+formattedTime+'</span>';
          content += '<div class="msg_cotainer_send">';
          content +=''+message+''; 
          content +='</div><div class="img_cont_msg">';
          content +='<img src="" class="rounded-circle user_img_msg"></div></div>';
		
		
          
          
          
          
          //var fromid= document.getElementById("fromid1").textContent;
    	  var fromname = document.querySelector(".fromname").textContent;
         
    	  //alert(fromid);
          var jsonmsg= {
        		  
        		  "message" : content,
        		  	"name" : name,
        		  	"fromname" : fromname,
        		  	"text" : message
        		  
          }

          if (message.trim() !== "") { // 메시지가 비어 있지 않은 경우에만 전송
              socket.send(JSON.stringify(jsonmsg));  //서버에 메시지 전달 
              
              //## 5-1 메시지전송 후 > 내 대화방에 내글추가 > 서버에서 메시지 전달  ##
              msgappendsend(content);  
              

           // 스크롤을 아래로 이동시킵니다.
           chat.scrollTop = chat.scrollHeight;
              
              messageInput.value = "";  // 대화창 다시 초기화 
          } else {
              alert("메시지를 입력하세요.");
          }
          
}        



				//## 6-1 메세지 수신시 보낸사람 글 대화창에 출력 ## 상대방쪽! 왼쪽!##프로필사진 변수 처리해야함!!
          function msgappend(event) {
        		
        	  //시간 포맷해서 가져오기
              const formattedTime = getCurrentTimeFormatted();
    		   
    		    const chat = document.getElementById("chat");
    		   var messageString= event; //채팅 내용
    		   
    	
    		 var content= '<div class="d-flex justify-content-start mb-4">';
    		 content += '<div class="img_cont_msg"><img src="https://static.turbosquid.com/Preview/001292/481/WV/_D.jpg"';
    		 content += 'class="rounded-circle user_img_msg"></div><div class="msg_cotainer">'+messageString+'</div>';
    		 content += '<span class="msg_time">'+formattedTime+'</span></div>';
				
    		 chat.insertAdjacentHTML('beforeend', content);
    		 
   		   //messages.innerHTML = content;
						 
    		   // 생성된 HTML을 채팅창에 추가
  		  // chat.append(messageDiv);
					
						
					
			
    		   
        	  /*
        		const messageContainer = document.createElement("div");
        		    messageContainer.className = "d-flex justify-content-start mb-4";

        		    const imgContainer = document.createElement("div");
        		    imgContainer.className = "img_cont_msg"; 

        		    const userImage = document.createElement("img");
        		    userImage.className = "rounded-circle user_img_msg";
        		    userImage.src = "https://static.turbosquid.com/Preview/001292/481/WV/_D.jpg";  //변수이미지

        		    const messageContent = document.createElement("div");
        		    messageContent.className = "msg_cotainer";
        		    //messageContent.textContent = ;    
        		 	messageContent.textContent = event; //대화내용
        		 	
        		    const messageTime = document.createElement("span");
        		    messageTime.className = "msg_time";
        		    messageTime.textContent = formattedTime;

        		    messageContainer.appendChild(imgContainer);
        		    imgContainer.appendChild(userImage);
        		    messageContainer.appendChild(messageContent);
        		    messageContainer.appendChild(messageTime);
        		    
        		    
        		  
        		    //const message = document.createElement("li");
        		     //chat.appendChild(message);
        		  const chat = document.getElementById("chat");
        		    chat.appendChild(messageContainer);
               */
            
        		
        	}

				
				
        	//## 5-2 메세지 발신시 내대화방 글 추가 함수## 오른쪽 채팅자! ## 프로필사진 변수 처리해야함!!##
        	function msgappendsend(event) {
        	     var formattedTime = getCurrentTimeFormatted();
        	     
        	     
        		    //const messageString = JSON.stringify({"message": event});
     		    const chat = document.getElementById("chat");
     		   var messageString= event; //채팅 내용
     		  chat.insertAdjacentHTML('beforeend', messageString);
     		   
     		   
     		   /*
				"beforebegin": 요소의 바로 앞에 추가합니다.
				"afterbegin": 요소의 첫 자식 요소로 추가합니다.
				"beforeend": 요소의 마지막 자식 요소로 추가합니다.
				"afterend": 요소의 바로 뒤에 추가합니다.
     		   
     		   */
     		
     	
 					
           	  
        	    
        	}
        	
         
        	//## 8.대화방을 클릭해서 접속시 실행## /chat 채팅방 리스트   /chat?fromname='' 개별 채팅방
		function serchid(clickedElement) {
        		
        		var roomid = clickedElement.querySelector(".roomid").textContent;
        		  var fromname= roomid;
        		var myname = sessionStorage.getItem("name"); 
        		
        		 // 클릭한 li 요소에 "active" 클래스를 추가
           		var liElements = document.querySelectorAll("li");
       			for (var i = 0; i < liElements.length; i++) {
          					 liElements[i].classList.remove("active");
       			}
      				 clickedElement.parentElement.classList.add("active");
        		
        		
        		
        	 if(fromname.toLowerCase()===myname.toLowerCase()) {
        			
        			alert("자기 자신과 대화를 할수 없습니다.");
        		
        			return false;
        		}
        		
        		serchidutil(fromname,myname);
        	
      
        	}
        	
        	
         //# 12시간 시간제 포맷함수
        	function getCurrentTimeFormatted() {
        	    const currentTime = new Date();
        	    const options = { hour: 'numeric', minute: 'numeric', hour12: true, hourCycle: 'h12' };
        	    return currentTime.toLocaleTimeString(undefined, options);
        	}
        	
        	
        	
        	// ## 7.처음 대화방 목록 디폴트 생성 함수 ( 예정)
        	function msgroomload(clickedElement){
        		
        	var	fromimg = "";
        	var	fromid = ""; // 대화상대 아이디 3개버전 신규 대화방 개설시 1개 , 기존대화방 로드시 1개 , 똑같은 상대방 일경우 기존 대화방으로 연결 
        	var status = ""; // 대화상대 접속중상태 표시 또는 글
        		  //var fromname= clickedElement.querySelector(".roomid").textContent; //사용자글에서 대화하기 누를경우 값 받고 이동
        		//프사자리참고
        		
        	var roomheader ='<div class="container-fluid h-100"><div class="row justify-content-center h-100">';
				roomheader +='<div class="col-md-4 col-xl-3 chat"><div class="card mb-sm-3 mb-md-0 contacts_card">';
				roomheader +='<div class="card-header"><div class="input-group">';
				roomheader +='<input type="text" placeholder="Search..." name="" class="form-control search">';
				roomheader +='<div class="input-group-prepend"><span class="input-group-text search_btn">';
				roomheader +='<i class="fas fa-search"></i></span></div></div></div><div class="card-body contacts_body">';	
				roomheader +='<ui class="contacts">';						
        		
				//프로필 사진 구간
        	var	roombody ='<li><div class="d-flex bd-highlight" type="button" onclick="serchid(this)">';
        		roombody +='<div class="img_cont"><img src="https://static.turbosquid.com/Preview/001292/481/WV/_D.jpg"';
        		roombody +='class="rounded-circle user_img"><span class="online_icon"></span></div><div class="user_info">';
        		roombody +='<span class="roomid">'+fromid+'</span><p>Kalid is online</p></div></div></li>';
					
			var roomfooter ='</ui></div><div class="card-footer"></div></div></div>'; 
        		
        	}
        	
        	
        	//## 4. DB자료로 이전 대화창 생성 함수 ##
        	function msgload(msg) {
        		var message = "";
        		
        		for (var i = 0; i < msg.result.length; i++) {
            		var result = msg.result[i];
            		//alert(msg.from_user_id);
            		
            	 	message += result.content;
            	}
        		var fromimg = result.fromimg;
        		var myimg = result.myimg;
        		var fromname = result.fromname;
        
        		
        		var parentContainer = document.getElementById("msgload"); // chatCard를 추가할 부모 요소를 가져옴
        		 var chatCard = document.createElement('div');
        		    chatCard.className = 'card msgload';
        		
        		    
        			
        		    
        		    var contenthead ='<div class="card-header msg_head">';
        		    		 
        		    contenthead +='<div class="d-flex bd-highlight">';
        		    contenthead +='<div class="msgback" id="goBack"><span><i class="xi-arrow-left"></i></span></div>';
        		    contenthead +='<div class="img_cont">';
        		    contenthead +='<img src="'+fromimg+'" class="rounded-circle user_img">';
        		    contenthead +='<span class="online_icon"></span></div>';
        		    contenthead +='<div class="user_info">';
        		    contenthead +='<span class="fromname">'+fromname+'</span></div>';
        		    
        		    contenthead +='</div><span id="action_menu_btn"><i class="fas fa-ellipsis-v"></i></span>';
        		    contenthead +='<div class="action_menu"><ul><li><i class="fas fa-user-circle"></i> 사용자정보</li>';
        		    contenthead +='<li><i class="fas fa-users"></i> 친구추가</li>';
        		    contenthead +='<li><i class="fas fa-plus"></i> 아무거나?</li>';
        		    contenthead +='<li><i class="fas fa-ban"></i> 차단하기</li></ul></div></div>';
        		    contenthead +='<div class="card-body msg_card_body" id="chat">';
						
						
						
		        		 
							
				var contentbody = message;	
			
					
				var contentfooter =	
	
				
				'</div><div class="card-footer">'+
					'<div class="input-group">'+
						'<div class="input-group-append">'+
							'<span class="input-group-text attach_btn"><i class="fas fa-paperclip"></i></span></div>'+
						'<textarea name="" spellcheck="false" id="message" class="form-control type_msg" placeholder=""></textarea>'+
						'<div class="input-group-append">'+
	             '<span class="input-group-text send_btn" type="button" id="send-button" onclick="sendMessage()">'+
						'<i class="fas fa-location-arrow"></i></span></div></div></div></div>';
						

						var cardContent = contenthead+contentbody+contentfooter;
						
        		    chatCard.innerHTML = cardContent;
        		    parentContainer.appendChild(chatCard); // chatCard를 부모 요소에 추가
        		    // 스크롤을 아래로 이동시킵니다.
        	           chat.scrollTop = chat.scrollHeight;
        		 
        			//console.log(chatCard);
        			
        			
        			//## 채팅방에서 이전페이지로 뒤로가기 함수
        	           function goBack() {
        	               window.history.back();
        	           }

        	           // 클릭 이벤트 처리
        	           const goBackButton = document.getElementById('goBack');
        	           goBackButton.addEventListener('click', goBack);
        			
        	}
    </script>
	</body>
</html>
