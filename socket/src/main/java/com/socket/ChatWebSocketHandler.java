package com.socket;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;




public class ChatWebSocketHandler extends TextWebSocketHandler{
	
	
	@Autowired
	SocketService socketService;

	// 연결된 WebSocket 세션을 저장할 컬렉션
	private Set<WebSocketSession> sessions = new ConcurrentHashMap().newKeySet();
	
	// 판매자와 구매자 각각의 클라이언트 연결을 저장하는 맵
    private Map<String, WebSocketSession> clients = new HashMap<>();

	
    
	 @Override
	    public void afterConnectionEstablished(WebSocketSession session) throws Exception {  //연결된 후 
		 if (session.isOpen()) {}
	
	    }

	    @Override
	    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
	    	String payload = message.getPayload();
	    	JSONObject jsonObject = new JSONObject();
	    	
	    	if (session.isOpen()) {
	    			payload = message.getPayload();
	    	 	jsonObject = new JSONObject(payload);

	    	 if (jsonObject.has("id")  && !jsonObject.has("toId") && !jsonObject.has("text")) {
	    		 
	    		 
	             handleInitialConnection(jsonObject, session);  // 처음 연결시 네임값만 확인하는 메서드
	             //System.out.println("네임만"+jsonObject.toString());
	             
	         } else if (jsonObject.has("toId") && jsonObject.has("id") && jsonObject.has("text")) {
	        	 
	        	  if(jsonObject.get("id").equals(jsonObject.get("toId"))) {
	        		  System.out.println("같은 사람에게는 보낼수 없습니다.");
	        	  } else {
	        		 
	             handleMessage(jsonObject, session); // 쪽지보낼때 보낼사람,메세지,보내는사람
	             int result=socketService.msginsert(jsonObject);
	    	//System.out.println("result1"+result);
	            // System.out.println("3가지"+jsonObject.toString());
	        	  	}
	         	}
	    	} else {  // 세션이 오프라인인 경우
	    		
	    		 if(jsonObject.get("id").equals(jsonObject.get("toId"))) {
	        		  System.out.println("같은 사람에게는 보낼수 없습니다.");
	        	  } else {
	    		int result=socketService.msginsert(jsonObject);
	    		//System.out.println("result2"+result);
	    		//연결이안됬을떄
	        	  }
	    	}
	    }
	    	
	 
	    //처음 웹소켓 연결된 사용자 이름, 세션 저장 메서드
	    private void handleInitialConnection(JSONObject jsonObject, WebSocketSession session) {
	        String id = jsonObject.optString("id", "");
	        clients.put(id, session);
	        sessions.add(session);
	       // System.out.println("초기연결아이디 :" +name);
	        // 초기 연결에 관한 로직 (예: 사용자 이름 저장)
	    }
	    //쪽지보낼떄 쪽지보낼때 보낼사람,메세지,보내는사람 저장 메서드 
	    private void handleMessage(JSONObject jsonObject, WebSocketSession session) {
	        String toId = jsonObject.optString("toId", "");
	        String id = jsonObject.optString("id", "");
	        //String message = jsonObject.optString("message", "");
	        String text = jsonObject.optString("text","");
	   	 JSONObject messageData = new JSONObject();
	   	 messageData.put("id", id); // 내 아이디
	   	 //messageData.put("message", message);
	   	 messageData.put("toId", toId);
	   	 messageData.put("text", text);
	   	 

	   	 TextMessage message1 = new TextMessage(messageData.toString());

	        
	        sendMessageToClient(toId, message1,session);
	        // 쪽지 보내기에 관한 로직
	       // System.out.println(fromname.toString());
	       // System.out.println(session.toString());
	    }
	    
   	
	    private void sendMessageToClient(String toId, TextMessage message1,WebSocketSession session) {
	    	if (session.isOpen()) {
	    		
	    		WebSocketSession clientSession = clients.get(toId);
	    		
	    		JSONObject jsonObject = new JSONObject(message1.getPayload());
	    		// "message" 필드에서 메시지 값을 추출
	    		String message = jsonObject.getString("text");
	    		String sender = jsonObject.getString("id");
	    	
	    		JSONObject messageObject = new JSONObject();
	    		
	    		messageObject.put("toId", toId);
	    		messageObject.put("message", message);
	    		messageObject.put("sender", sender);
	    		
	    		//TextMessage message2 = new TextMessage(message);
	    		TextMessage message2 = new TextMessage(messageObject.toString());
	    		//json객체로 toId까지보내주기
	    		
	    		
	    	    if (clientSession != null && clientSession.isOpen()) {
	    	        try {
	    	            // 메시지를 클라이언트에게 보냅니다.
	    	            // ...
	    	        	
	    	            clientSession.sendMessage(message2);
	    	            
	    	            
	    	        } catch (IOException e) {
	    	            e.printStackTrace();
	    	        }
	    	    } else {
	    	        // 클라이언트가 로그인되지 않았거나 연결이 끊어진 경우에 대한 처리
	    	    }
	    	}
	    		
		}

		@Override
	    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
	        // WebSocket 연결이 닫혔을 때 실행되는 로직을 여기에 추가
	        //System.out.println("클라이언트 연결 종료: " + session.getId());
	       // sessions.remove(session);
	        
	        String userId = session.getId();
	        clients.remove(userId);
	    }
	    
	    //public void sendMessageToClient(String clientId, String message) { //특정 아이디를 가진 클라이언트에게 메세지보내기
	      
	    //}
	    
	    public void sendMessageToAllClients(String message,WebSocketSession session) {  //모든 클라이언트에게 메시지보내기 
	    	if (session.isOpen()) {
	        TextMessage textMessage = new TextMessage(message);
	        System.out.println("textmessage"+textMessage);
	        for (WebSocketSession clientSession : clients.values()) {
	            try {
	                clientSession.sendMessage(textMessage);
	            } catch (IOException e) {
	                e.printStackTrace();
	            }
	        }
	    	}
	    }
}