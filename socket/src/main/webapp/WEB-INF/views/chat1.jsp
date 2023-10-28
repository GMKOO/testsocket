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
	

			<script type="text/javascript">

	
	//  ##대화창 메뉴바 출력##
	$(document).on('click', '#action_menu_btn', function(){
	    $('.action_menu').toggle();
	});
	

	const socket = new WebSocket("ws://localhost:80/chat");
	 // ##소켓 연결##
     socket.onopen = function(event) {
       	console.log("커넥션이 만들어졌습니다.1");
    	
       	// ## 1.세션이 연결될때  세션에있는 사용자 이름을 담아서 보내준다.##  --첫연결--로그인세션아이디보냄-- ##
    	var mid = sessionStorage.getItem("mid"); 
    	
      	socket.send(JSON.stringify({ "mid": mid}));
      	msgroomload();
    	//chat.scrollTop = chat.scrollHeight;

    	
    	
    	// ## 2. 게시글에서 대화하기로 접속시 쿼리로 상대방 ID값 받고 그 값으로 queryserchid 함수 실행 ##
    	var queryString = window.location.search;
    	var urlParams = new URLSearchParams(queryString);
    	 var toId = urlParams.get("toId");

    	if (toId  ===null) {
    		
    	
    	} else {
    		
    		// ## 2-1 ##
    	   	queryserchid(toId);
    		
    	}
    	

    
     };
     
 	//##.3 url에서 fromname 가져오는 함수##
 	function queryserchid(toId) {
 		

 		
 		var mid = sessionStorage.getItem("mid"); 
 		
 		 // 클릭한 li 요소에 "active" 클래스를 추가
    	
 		
 		if(toId === null) {
 			// 현재 페이지의 URL에서 쿼리 문자열을 가져옵니다.
     		var queryString = window.location.search;

     		// URLSearchParams를 사용하여 쿼리 문자열을 파싱합니다.
     		var urlParams = new URLSearchParams(queryString);

     		// "fromname" 파라미터 값을 가져옵니다.
     		 toId = urlParams.get("toId");

     	
 		      // 3-1 Ajax통신으로 serchid함수실행
     	  		serchidutil(toId,mid);
    		 
				 
		
			
 			
 		} else if(toId.toLowerCase()===mid.toLowerCase()) {
 			
 			//event.preventDefault();
 			alert("자기 자신과 대화를 할수 없습니다.");
 			  window.history.back();
 			
 			return false;
 		}
 		
 		serchidutil(toId,mid);
 	

 	}
 	
 	// ## 3-2 서버에게 재생성할 데이터 요청 ## 소켓서비스에서 첫 대화인 경우 isFirstConversation함수로 체크 후 공백 메세지 저장 ##
   	// ## 8-1 이어서 실행##	
 	function serchidutil(toId,mid) {
 		
    		$.ajax({
                type: "GET",
                url: "./serchid", // 폼의 action URL
                data: {
                	"toId" : toId,
                	"mid" : mid
                	},
                success: function(data) {
                	var jsonData = JSON.parse(data); 
   
                	
                	$(".msgload").remove();
                	$(".contacts_card").remove();
        		    
                	//## 3-3 대화창 재생성##
                	//## 8-2 대화창 재생성##
                	msgload(jsonData);
                },
                error: function() {
    		
    	}

});
 		
 	}
 	
 	
 	//##현재화면을 확인후 메시지 전달 할지 체크
 	function getCurrentScreen() {
 	    if (document.querySelector('.contacts_card')) {
 	        return 'contacts_card';
 	    } else if (document.getElementById('msgload')) {
 	        return 'msgload';
 	    }
 	    // 다른 상태에 따른 처리 추가 가능
 	    return '1';
 	}

 	
 //## 6.서버로부터 메세지 수신##
socket.onmessage = function(event) {
	 

var data = JSON.parse(event.data);

  
var currentScreen = getCurrentScreen();

for (var key in data) {
    var value = data[key];
    
 
        
    } 

       
    

      
    if ("message" in data && "sender" in data && "time" in data) {  //일반메시지전송
    	
        var message =data.message;
        var sender = data.sender;
        var time = data.time;
  
        if (currentScreen === 'contacts_card') {
        	
        	updateMessage(sender, time, message);

        } else if (currentScreen === 'msgload') {
        	
        	msgappend(message,sender);
        	
        } else {
        	
        	// 다른페이지에는 추가하지않음 여기에 알림 모달 넣는방법도?
        	
        }
    	
    } else if ("sender" in data && "message" in data && !("time" in data) ) { //접속알림
    	
    	
    	 var sender = data.sender;
         var message = data.message;
       
         if(message ==="연결") { 
         
    	  if (currentScreen === 'contacts_card') {
          	
    		onlineupdate(sender);

          } else if (currentScreen === 'msgload') {
          	
        	  msgonlineupdate(sender);
          	
          } else {
          	
          	// 다른페이지에는 추가하지않음 여기에 알림 모달 넣는방법도?
          	
          }
    	  
         }else if(message ==="연결해제") {
        	 
        	 if (currentScreen === 'contacts_card') {
               	
        		 
         		offupdate(sender);

               } else if (currentScreen === 'msgload') {
               	
            	   msgoffupdate(sender);
               	
               } else {
               	
               	// 다른페이지에는 추가하지않음 여기에 알림 모달 넣는방법도?
               	
               }
        	 
        	 
        	 
         }
    
    } 
    
    
	 //alert(currentScreen);
    if(value ==="연결불러오기") {  // 로그인시 기존접속자 온라인,오프라인 표시하기
    	
 	      if (currentScreen === 'contacts_card') {
 	    	  
 	    	 for (var userName in data) {
 	  	       var sender = userName;
 	  	   	 onlineupdate(sender);
 	     	   }
 	   
 	    		

 	          } else if (currentScreen === 'msgload') {
 	    
 	        	 for (var userName in data) {
 	  	  	       var sender = userName;
 	  	  	 		 msgonlineupdate(sender);
 	  	     	   }
 	       
 	          } else {
 	     
 	          	// 다른페이지에는 추가하지않음 여기에 알림 모달 넣는방법도?
 	          	
 	          }
    }
      

};


	//## 6-1 ##
	
	
	//chat.scrollTop = chat.scrollHeight;
  



// ## 클라이언트 온라인 연결
function onlineupdate(sender) {
    // 모든 user_info1 엘리먼트를 찾기
      var userList = document.querySelectorAll('.user_info1');
   		 var imgList = document.querySelectorAll('.img_cont');
       var imgElement;
       var toIdElement;

    for (var i = 0; i < userList.length; i++) {
        toIdElement = userList[i].querySelector('.toId');
        imgElement =imgList[i];
       
        //나를 제외한 모든사람사람채팅창에 내가 접속여부를보여주는거!
        if (toIdElement.textContent === sender) {
        
        
        	imgElement.querySelector('.status').classList.replace('offline', 'online_icon');
        	
        } 
    }
}
		//## 오프라인 업데이트 
	function offupdate(sender) {
		
	
		    // 모든 user_info1 엘리먼트를 찾기
		      var userList = document.querySelectorAll('.user_info1');
		   		 var imgList = document.querySelectorAll('.img_cont');
		       var imgElement;
		       var toIdElement;

		    for (var i = 0; i < userList.length; i++) {
		        toIdElement = userList[i].querySelector('.toId');
		        imgElement =imgList[i];
		       
		        //나를 제외한 모든사람사람채팅창에 내가 접속여부를보여주는거!
		        if (toIdElement.textContent === sender) {
		        
		        
		        	imgElement.querySelector('.status').classList.replace('online_icon', 'offline');
		        }
		       
		    }
		}
		
		//## 메세지방 접속상태 off 업데이트
	function msgoffupdate(sender) { 
		
		   // 모든 user_info1 엘리먼트를 찾기
	      var userList = document.querySelectorAll('.user_info');
	   		 var imgList = document.querySelectorAll('.img_cont');
	       var imgElement;
	       var toIdElement;

	       for (var i = 0; i < userList.length; i++) {
	        toIdElement = userList[i].querySelector('.toId');
	        imgElement =imgList[i];
	    
	       }
	        //나를 제외한 모든사람사람채팅창에 내가 접속여부를보여주는거!
	        if (toIdElement.textContent === sender) {
	        
	        
	        	imgElement.querySelector('.status').classList.replace('online_icon', 'offline');
	        }
	       
	    }
		
	//## 메세지방 접속상태 online 업데이트
	function msgonlineupdate(sender) { 
		
		  var userList = document.querySelectorAll('.user_info');
	   		 var imgList = document.querySelectorAll('.img_cont');
	       var imgElement;
	       var toIdElement;

	       for (var i = 0; i < userList.length; i++) {
	        toIdElement = userList[i].querySelector('.toId');
	        imgElement =imgList[i];
       //나를 제외한 모든사람사람채팅창에 내가 접속여부를보여주는거!
       if (toIdElement.textContent === sender) {
       
       
    	   imgElement.querySelector('.status').classList.replace('offline', 'online_icon');
       }
		 
	     }	 
	 }
	 
	
	
  



 //## 대화목록리스트 메세지업데이트
function updateMessage(sender, time, message) {
    // 모든 user_info1 엘리먼트를 찾기
    var userList = document.querySelectorAll('.user_info1');
    var roomlist = document.getElementById("roomlist");
    // toId와 일치하는 엘리먼트 찾기
     var initid= document.querySelector(".toId").textContent;
       var timeElement;
       var messageElement;
       var toIdElement;
       var status=false;
    for (var i = 0; i < userList.length; i++) {
        toIdElement = userList[i].querySelector('.toId');
        
        if (toIdElement.textContent === sender) {
            // sender가 일치하는 경우에만 time 및 message 업데이트
            timeElement = userList[i].querySelector('.time');
            messageElement = userList[i].querySelector('.roommessage');
            
            timeElement.textContent = time;
            messageElement.textContent = message;
            status=true;
        } 
        	
    }
      if(!status){
    	  
       		//온라인 ,오프라인 메서드 만들어서 변수화시키기 
    	  var chatcreate ='<li><div class="d-flex bd-highlight" type="button"'; 
    	      chatcreate+='onclick="serchid(this)"><div class="img_cont">';
    	  	  chatcreate+='<img src="" class="rounded-circle user_img">';
    	      chatcreate+='<span class="online_icon"></span></div>';
    	      chatcreate+='<div class="user_info1"><span class="toId">'+sender+'';
    	      chatcreate+='</span><span class="time">'+time+'</span><p ';
    	      chatcreate+='class="roommessage">'+message+'</p></div></div></li>';
        	
  	    
  	    roomlist.insertAdjacentHTML('afterbegin', chatcreate);
  	    status=false;
      } 
    	  
      
        }
    
    
    
    







// html 삽입공격 방지
function escapeHtml(input) {
    return input.replace(/</g, '&lt;').replace(/>/g, '&gt;');
}
  // ## 5. 메시지전송 ##
function sendMessage() {
	var img="";
	 const messageInput = document.getElementById("message");
	 const chat = document.getElementById("chat");
	  const mid = sessionStorage.getItem("mid"); 
          const message = escapeHtml(messageInput.value);
          const formattedTime = getCurrentTimeFormatted();
          //var myimg = document.getElementById('myimg').src;
          
        	imgserch(mid, function(result) {
  				img= result;
  				
  				var content = '<div class="d-flex justify-content-end mb-4">';
  	          content += '<span class="msg_time_send">'+formattedTime+'</span>';
  	          content += '<div class="msg_cotainer_send">';
  	          content +=''+message+''; 
  	          content +='</div><div class="img_cont_msg">';
  	          content +='<img src="'+img+'" class="rounded-circle user_img_msg myimg"></div></div>';
  			
  			
  	          
  	          
  	          
  	          
  	          //var fromid= document.getElementById("fromid1").textContent;
  	    	  var toId = document.querySelector(".toId").textContent;
  	         
  	    	  //alert(fromid);
  	          var jsonmsg= {
  	        		  
  	        		  "message" : content,
  	        		  	"mid" : mid,
  	        		  	"toId" : toId,
  	        		  	"text" : message,
  	        		  	"time":formattedTime
  	        		 
  	        		  
  	          }

  	          if (message.trim() !== "") { // 메시지가 비어 있지 않은 경우에만 전송
  	              socket.send(JSON.stringify(jsonmsg));  //서버에 메시지 전달 
  	              
  	              //## 5-1 메시지전송 후 > 내 대화방에 내글추가 > 서버에서 메시지 전달  ##
  	              msgappendsend(content);  
  	              

  	           // 스크롤을 아래로 이동시킵니다.
  	           chat.scrollTop = chat.scrollHeight;
  	              
  	              messageInput.value = "";  // 대화창 다시 초기화 
  	              
  	           var sendButton = document.getElementById("send-button");
  	          sendButton.style.display = "none";
  	        hideandshow.style.display = "none";
  	      
  	              
  	          } else {
  	              alert("메시지를 입력하세요.");
  	          }
  				
  				
});
         //시간 포맷해서 가져오기
      
          
        
      
          
}        

  	function imgserch (mid,callback){
 
  		
  		$.ajax({
            type: "GET",
            url: "./imgserch", // 폼의 action URL
            data: {
            	
            	"mid" : mid
            	},
           	
            success: function(data) {
            	var jsonData = JSON.parse(data); 
            var	img = jsonData.result;
       	
            callback(img); 
         

         
  	},
    error: function() {
		
	}

});
  	 
 		
  	}

  	//#대화목록리스트 프사 ajax 동기처리
  	function imgserch1(mid,callback) {
  	
  		
  		$.ajax({
            type: "GET",
            url: "./imgserch", // 폼의 action URL
            async: false,
            data: {
            	
            	"mid" : mid
            	},
           	
            success: function(data) {
              	var jsonData = JSON.parse(data); 
                var	img = jsonData.result;
           	
                callback(img); 
   
 
            },
            error: function() {
        		
        	}
            
});

  	}



				//## 6-1 메세지 수신시 보낸사람 글 대화창에 출력 ## 상대방쪽! 왼쪽!##프로필사진 변수 처리해야함!!
          function msgappend(message,sender) {
        		var img ='';
        	  var mid = sessionStorage.getItem("mid"); 
        	  //시간 포맷해서 가져오기
              const formattedTime = getCurrentTimeFormatted();
    		   var message1 = escapeHtml(message);
    		    const chat = document.getElementById("chat");
    	
    		    var initid= document.querySelector(".toId").textContent;
    		    
    		
    			imgserch(sender, function(result) {
    				img= result;
      				
    			    //#채팅 수신시 보낸사람과 현재 대화하는상대과 일치해야 대화내용생성
    	    		if(initid===sender) { 
    	    		   
    	    		
    	    			 //console.log(img);
    	      		    
    	      	  var conversationHTML='<div class="d-flex justify-content-start mb-4" >';
    	              conversationHTML+='<div class="img_cont_msg"><img src="'+img+'" class="rounded-circle user_img_msg toimg">';
    	              conversationHTML+='</div><div class="msg_cotainer">'+message+'</div>';
    	              conversationHTML+='<span class="msg_time">'+formattedTime+'</span></div>';		
    	    		 chat.insertAdjacentHTML('beforeend', conversationHTML);
    	    		 
    	    		 chat.scrollTop = chat.scrollHeight;
    	    		} else {
    	    			
    	    		}
      				 
   });
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
        	
         
        	//## 8.대화방을 클릭해서 접속시 실행## /chat1 채팅방 리스트   /chat?fromname='' 개별 채팅방
		function serchid(clickedElement) {
        		
        		
        		
        		var toId = clickedElement.querySelector(".toId").textContent;
        		  
        		var mid = sessionStorage.getItem("mid"); 
        		
        		 // 클릭한 li 요소에 "active" 클래스를 추가
           		var liElements = document.querySelectorAll("li");
       			for (var i = 0; i < liElements.length; i++) {
          					 liElements[i].classList.remove("active");
       			}
      				 clickedElement.parentElement.classList.add("active");
        		
        		
        		
        	 if(mid.toLowerCase()===toId.toLowerCase()) {
        			
        			alert("자기 자신과 대화를 할수 없습니다.");
        		
        			return false;
        		}
        		
        		serchidutil(toId,mid);
        	
      
        	}
        	
        	
         //# 12시간 시간제 현재시간 출력함수
        	function getCurrentTimeFormatted() {
        	    const currentTime = new Date();
        	    const options = { hour: 'numeric', minute: 'numeric', hour12: true, hourCycle: 'h12' };
        	    return currentTime.toLocaleTimeString(undefined, options);
        	}
        	
         //# 입력된 시간을 포맷 출력함수
        	function formatTime(inputTime) {
        	    const time = new Date(inputTime);
        	    const options = { hour: 'numeric', minute: 'numeric', hour12: true, hourCycle: 'h12' };
        	    return time.toLocaleTimeString(undefined, options);
        	}

        	
         
        	
        	
        	// ## 7.처음 대화방 목록 디폴트 생성 함수 ( 예정)
        function msgroomload(){
        		
        		
        		var status = "";
        		var toimg = ""; // ajax로 마지막 메세지 아이디를 통신해서 그사람 사진가져오기
        		
        		var toimg1="";
        		
            	var	toId = ""; // 대화상대 아이디 3개버전 신규 대화방 개설시 1개 , 기존대화방 로드시 1개 , 똑같은 상대방 일경우 기존 대화방으로 연결 
            
            	var mid =sessionStorage.getItem("mid"); // 조건문에 나랑 대화하는 상대 인걸 가져와야됨
            	var lastmessage="";
            	var lastmsgtime="";
            	
            	var	roombody="";
           
                	
        		$.ajax({
                    type: "GET",
                    url: "./roomload", // 폼의 action URL
                    async: false,
                    data: {
                    	
                    	"mid" : mid
                    	},
                   	
                    success: function(data) {
                    	
                        
                    	
                    	var jsonData = JSON.parse(data); 
                    var json= jsonData.result;
                    var roomContent='';
             		
                  	var roomheader ='<div class="container-fluid h-100"><div class="row justify-content-center h-100">';
            				roomheader +='<div class="col-md-4 col-xl-3 chat" id="chat3"><div class="card mb-sm-3 mb-md-0 contacts_card">';
            				roomheader +='<div class="msgback roomback" id="roomback"><span><i class="xi-arrow-left"></i></span></div>';
            				roomheader +='<div class="card-header"><div class="input-group">';
            				roomheader +='<input type="text" placeholder="Search..." name="" class="form-control search">';
            				roomheader +='<div class="input-group-prepend"><span class="input-group-text search_btn">';
            				roomheader +='<i class="fas fa-search"></i></span></div></div></div><div class="card-body contacts_body" id="contacts_body">';	
            				roomheader +='<ui class="contacts" id="roomlist">';						
            				
            				// 데이터베이스에서 불러온 시간을 가정합니다. 예를 들어, "2023-10-24T10:20:00" 형식으로 가져온다고 가정합니다.
            				let dbTime = new Date("2023-10-24T10:20:00");

            				// 현재 날짜와 시간을 가져옵니다.
            				let currentTime = new Date();

            				// 현재 날짜와 불러온 시간 간의 차이를 계산합니다.
            			
            				let formattedTime;
            			
                    for (var i = 0; i < json.length; i++) {
                		var result = json[i];
                		
                lastmsgtime =result.latest_timestamp;
                lastmessage =result.content;
                
                formattedTime = formatTimestamp(lastmsgtime);
                
                //대화방 목록에서 받는사람이 자기 자신이라면 상대방에 아이디를 저장한다.
                if(result.to_user_id === mid) {
                	
                	toId =result.from_user_id;
                	
                	
                          
             
                } else {
                	
                	toId =result.to_user_id;
                
                
                          
                }
                
                

            
                imgserch1(toId, function (img) {
                    toimg=img;
                  
                    });
                
       
                //여기에 프사불러와서 들어갈 함수가 들어가야됨 
  
      		roombody ='<li><div class="d-flex bd-highlight" type="button" onclick="serchid(this)">';
      		roombody +='<div class="img_cont"><img src="'+toimg+'"class="rounded-circle user_img">';
      		roombody +='<span class="status offline"></span></div><div class="user_info1">';
      		roombody +='<span class="toId">'+toId+'</span><span class="time">'+ formattedTime+'</span><p class="roommessage">'+lastmessage+'</p></div></div></li>';
			
		 roomContent += roombody;
      		
             
           
                    }
                    
                	var roomfooter ='</ui></div><div class="card-footer"></div></div></div></div></div>'; 
                	
                    var parentContainer = document.body; 
             
                	var roombody1=roomheader+roomContent+roomfooter;
                	
                	   parentContainer.innerHTML = roombody1;
                	
                    //var roomlist = document.getElementById("roomlist");
    			    //roomlist.insertAdjacentHTML('beforeend', roombody1);
                	
                    var roomgoBackButton = document.getElementById('roomback');
     	           roomgoBackButton.addEventListener('click', goHome);
     	          //var contacts_body = document.getElementById("contacts_body");
          		//contacts_body.scrollTop = contacts_body.scrollHeight;
                 
          	},
            error: function() {
        		
        	}

        });
        	
        		  
        	}
        	
        	//#채팅창 시간 날짜 포맷 함수
        function formatTimestamp(timestamp) {
            // 데이터베이스에서 불러온 시간을 가정합니다. 예를 들어, "2023-10-24T10:20:00" 형식으로 가져온다고 가정합니다.
            let dbTime = new Date(timestamp);

            // 현재 날짜와 시간을 가져옵니다.
            let currentTime = new Date();

            // 현재 날짜와 불러온 시간 간의 차이를 계산합니다.
            let formattedTime;
            let timeDifferenceInMilliseconds;
            let timeDifferenceInDays;

            timeDifferenceInMilliseconds = currentTime - dbTime;

            timeDifferenceInDays = timeDifferenceInMilliseconds / (24 * 60 * 60 * 1000);

            // 현재 시간과 데이터베이스 시간이 같은 날이며, 현재 시간이 "24:00" 이후가 아닌 경우 당일 시간으로 처리
            if (currentTime.getDate() === dbTime.getDate() && dbTime.getHours() >= 0) {
                let hours = dbTime.getHours();
                let minutes = dbTime.getMinutes();
                let ampm = hours >= 12 ? '오후' : '오전';
                hours = hours % 12;
                hours = hours ? hours : 12;
                formattedTime = ampm + ' ' + hours + ':' + (minutes < 10 ? '0' : '') + minutes;
            } else {
                // 1일 이상 또는 24:00 이후인 경우 어제로 처리
                let month = dbTime.getMonth() + 1;
                let day = dbTime.getDate();
                formattedTime = month + '월 ' + day + '일';
            }

            return formattedTime;
        }
        


        	
        	
        	//## 4. DB자료로 이전 대화창 생성 함수 ##
        	function msgload(msg) {
        		
        		var conversationHTML = "";
        		var message = "";
        		var toimg = "";
        		var myimg = "";
        		var toId = msg.result[0].toId;
        		var timestamp = "";
        		var touserid= "";
        		
        		// 특정 시간을 입력으로 받아 서식화된 문자열로 반환
            	var formattedTime = "";
            	var inputTime ="";
            	var fromuserid="";
            	var mid = sessionStorage.getItem("mid"); 
        		
        		for (var i = 0; i < msg.result.length; i++) {
            		var result = msg.result[i];
            		//alert(msg.from_user_id);
            		
            	 	message = result.content;
            	  	touserid = result.to_user_id;
            	  	toimg = result.toimg;
            		myimg = result.myimg;
            		timestamp= result.timestamp;
            		formattedTime = formatTimestamp(timestamp);
            		
            		//inputTime = new Date(timestamp);
            		//formattedTime = formatTime(inputTime);
            		fromuserid= result.from_user_id;
            		
            		// 첫대화 공백 출력 제외 
            		if(message === "" || message === " ") {
            			
            		}else { 
            	
            		if(mid===touserid) {
         			//조건문으로 내아이디랑 비교해서 발신,수신 비교 후 출력하기 왼쪽	(반복)		
           conversationHTML+='<div class="d-flex justify-content-start mb-4" >';
           conversationHTML+='<div class="img_cont_msg"><img src="'+toimg+'" class="rounded-circle user_img_msg toimg">';
           conversationHTML+='</div><div class="msg_cotainer">'+message+'</div>';
           conversationHTML+='<span class="msg_time">'+formattedTime+'</span></div>';		
            
            		}	else if (mid===fromuserid) {		
            						
            			//조건문으로 내아이디랑 비교해서 발신,수신 비교 후 출력하기 오른쪽(반복)		
            conversationHTML+='<div class="d-flex justify-content-end mb-4" >';
            conversationHTML+='<span class="msg_time_send">'+formattedTime+'</span>';		
            conversationHTML+='<div class="msg_cotainer_send" >'+message+'</div><div class="img_cont_msg">';
            conversationHTML+='<img src="'+myimg+'" class="rounded-circle user_img_msg myimg"></div></div>';
            		
        
            	}
            		}
        				
        		}	
        		
        	
        		
      
        		    var contenthead ='<div class="col-md-8 col-xl-6 chat" id="msgload">';
        		    contenthead +='<div class="card msgload"><div class="card-header msg_head">';
        		    contenthead +='<div class="d-flex bd-highlight">';
        		    contenthead +='<div class="msgback" id="goBack"><span><i class="xi-arrow-left"></i></span></div>';
        		    contenthead +='<div class="img_cont">';
        		    contenthead +='<img src="'+toimg+'" class="rounded-circle user_img">';
        		    contenthead +='<span class="status offline"></span></div>';
        		    contenthead +='<div class="user_info">';
        		    contenthead +='<span class="toId">'+toId+'</span></div>';
        		    contenthead +='</div><span id="action_menu_btn"><i class="fas fa-ellipsis-v"></i></span>';
        		    contenthead +='<div class="action_menu"><ul><li><i class="fas fa-user-circle"></i> 사용자정보</li>';
        		    contenthead +='<li><i class="fas fa-users"></i> 친구추가</li>';
        		    contenthead +='<li><i class="fas fa-plus"></i> 아무거나?</li>';
        		    contenthead +='<li><i class="fas fa-ban"></i> 차단하기</li></ul></div></div>';
        		    contenthead +='<div class="card-body msg_card_body" id="chat">';
        		    
        
				var contentbody =conversationHTML;
					
				
			
					
		var contentfooter =	'</div><div class="card-footer">';
		contentfooter+='<div class="input-group">';
		contentfooter+='<div class="input-group-append">';
		contentfooter+='<span class="input-group-text attach_btn"><i class="fas fa-paperclip"></i></span></div>';
		contentfooter+='<textarea oninput="toggleSendButton()" spellcheck="false" id="message" class="form-control type_msg" placeholder=""></textarea>';
		contentfooter+='<div class="input-group-append" id="input-group-append">';		
		contentfooter+='<span class="input-group-text send_btn" type="button" id="send-button" onclick="sendMessage()">';				
		contentfooter+='<i id="hideandshow" style="display: none;" class="fas fa-location-arrow"></i></span></div></div></div></div>';				
						
	             
		var parentContainer = document.getElementById("chat3"); // chatCard를 추가할 부모 요소를 가져옴
		
						var cardContent =contenthead+contentbody+contentfooter;
						
						parentContainer.insertAdjacentHTML('afterend', cardContent);
        		   
        		    
        		 
        		    // 스크롤을 아래로 이동시킵니다.
        	          chat.scrollTop = chat.scrollHeight;
        		 
        		
        	           const goBackButton = document.getElementById('goBack');
        	           goBackButton.addEventListener('click', goBack);
        	           
        	}
        			
        	//접속경로에따라 뒤로가기버튼을 다르게 줘야됨.
        	 function goBack() {
        		
        		 var currentPath = window.location.href;
        		 
        		 var regex =/\/chat1\?/;
        		 var match = currentPath.match(regex);

        		 if (match) {
        		     var result = match[0];
        		     window.history.back();
        		     
                    } else { 
                    
                    	$(".msgload").remove();
                      	msgroomload();
                    	
                    	
                    }
        		 }
        
        		
        	 function goHome() {
         		
        		
                 
                     window.history.back();
               
             }
	             
	               
	             
	      
	           // 클릭 이벤트 처리
	          
	           // 대화목록 > 대화창에서 > 다시 대화목록으로 돌아가는거 
	
			
        	function toggleSendButton() {
        	    const messageInput = document.getElementById("message");
        	    const hideandshow = document.getElementById("hideandshow");
        	    const sendButton = document.getElementById("send-button");
        	    
        	    if (messageInput.value.trim() === "") {
        	        // 입력이 비어있을 때 버튼을 숨깁니다.
        	        sendButton.style.display = "none";
        	        hideandshow.style.display = "none";
        	    } else {
        	        // 입력이 있을 때 버튼을 표시합니다.
        	        sendButton.style.display = "block";
        	        hideandshow.style.display = "block";
        	    }
        	}
        	          
        	
    </script>
	</body>
</html>
