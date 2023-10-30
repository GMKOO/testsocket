

const socket = new WebSocket("ws://localhost:8080/chat");

socket.onopen = function(event) {
    // 웹소켓이 연결되었을 때 실행할 공통 코드
 var mid = sessionStorage.getItem("mid");

if (mid === null || mid === "null") {
       console.log("세션이 없어 웹소켓 연결을 수행하지 않습니다.");
       
    } else {
	 console.log("커넥션이 만들어졌습니다.js");
        socket.send(JSON.stringify({ "mid": mid }));
           
    }

};


	// ##모든페이지에 입힐거 
	var msgcount = 0;

	socket.onmessage = function(event) {
		
	


	    // 웹소켓으로부터 메시지를 수신했을 때 실행할 공통 코드


	var socketdata = JSON.parse(event.data);
	
	var currentScreen = getCurrentScreen();
	var noteNumElement = document.querySelector('.note-num');
	if(currentScreen==1) {
		
	
if ("message" in socketdata && "sender" in socketdata && "time" in socketdata) {  //일반메시지전송
    	
    
	
		

		handleNewMessage(noteNumElement);
		noteNumElement.style.display = 'block';
		
	}
	}


noteNumElement.addEventListener('click', function() {
    // 클릭 이벤트 핸들러
    noteNumElement.style.display = 'none'; // 클릭 시 숨김
    noteNumElement.textContent = 0; // 텍스트 내용을 0으로 설정
    msgCount = 0; // 메시지 카운트 초기화
});
	


	};

	function handleNewMessage(noteNumElement) {
			
			if(msgcount<99) {
	    msgcount += 1;
}
	    noteNumElement.textContent = msgcount;
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



