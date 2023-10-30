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
		 
		 //String mid = session.getId();
		//System.out.println("접속세션"+mid);
	
	//
	    }

	    @Override
	    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
	    	String payload = message.getPayload();
	    	JSONObject jsonObject = new JSONObject();
	    	
	    	if (session.isOpen()) {
	    			payload = message.getPayload();
	    	 	jsonObject = new JSONObject(payload);

	    	 if (jsonObject.has("mid")  && !jsonObject.has("toId") && !jsonObject.has("text")) {
	    		 
	    		 
	             handleInitialConnection(jsonObject, session);  // 처음 연결시 네임값만 확인하는 메서드
	             //System.out.println("네임만"+jsonObject.toString());
	             
	         } else if (jsonObject.has("toId") && jsonObject.has("mid") && jsonObject.has("text")) {
	        	 
	        	  if(jsonObject.get("mid").equals(jsonObject.get("toId"))) {
	        		  System.out.println("같은 사람에게는 보낼수 없습니다.");
	        	  } else {
	        		 
	             handleMessage(jsonObject, session); // 쪽지보낼때 보낼사람,메세지,보내는사람
	             int result=socketService.msginsert(jsonObject);
	    
	        	  	}
	         	}
	    	} else {  // 세션이 오프라인인 경우
	    		
	    		 if(jsonObject.get("mid").equals(jsonObject.get("toId"))) {
	        		  System.out.println("같은 사람에게는 보낼수 없습니다.");
	        	  } else {
	    		int result=socketService.msginsert(jsonObject);
	    		//System.out.println("result2"+result);
	    		//연결이안됬을떄
	        	  }
	    	}
	    }
	    	
	 
	    //처음 웹소켓 연결된 사용자 이름, 세션 저장 메서드
	    private void handleInitialConnection(JSONObject jsonObject, WebSocketSession session) throws IOException {
	    	
	    	//##1 온라인,오프라인 업데이트표시
	        String mid = jsonObject.optString("mid", "");
	        String message = "연결";
	        String clientStatus ="연결불러오기";
	        //String message = mid+"님이 접속 하셨습니다";
	        clients.put(mid, session);
	        sessions.add(session);
	        
	        sendMessageToAllClients(mid,message,session);
	        
	  
	        
	        //## 온라인,오프라인 초기 생성
	        
	        JSONObject statusObject = new JSONObject();
            for (String clientName : clients.keySet()) {
                // 상태 정보를 가져오는 로직을 추가해야 합니다.
            	   clientStatus = "연결불러오기"; // 접속중인 사용자 key,value로 "연결불러오기" 값 저장
            	    statusObject.put(clientName, clientStatus);
            	
            	}
          
            	TextMessage statusMessage = new TextMessage(statusObject.toString());
            		session.sendMessage(statusMessage);
    	
            	
            	
            		WebSocketSession senderSession = clients.get(mid);
            		
            		 for (WebSocketSession clientSession : clients.values()) {
     		        	
     		        	if (clientSession != null && clientSession.isOpen() && !clientSession.equals(senderSession)) {
     		        	   try {
     			                clientSession.sendMessage(statusMessage);
     			               
     	    	    
     	    	   
     	    	            
     	    	        } catch (IOException e) {
     	    	            e.printStackTrace();
     	    	        }
     	    	    } else {
     	    	        // 클라이언트가 로그인되지 않았거나 연결이 끊어진 경우에 대한 처리
     	    	    }
     	    		
     	       
     	    	}
            		 
            		
	   	 //System.out.println("접속아이디"+clients.size());
		 System.out.println("현재접속자수"+clients.size());
			System.out.println("현재접속자리스트"+clients.toString());
			//System.out.println("clients.values"+clients.values());
			//System.out.println("clients.keySet"+clients.keySet());
	   	 //System.out.println(clients.toString());
	       // System.out.println("초기연결아이디 :" +name);
	        // 초기 연결에 관한 로직 (예: 사용자 이름 저장)
	    }
	    
	    //쪽지보낼떄 쪽지보낼때 보낼사람,메세지,보내는사람 저장 메서드 
	    private void handleMessage(JSONObject jsonObject, WebSocketSession session) {
	        String toId = jsonObject.optString("toId", "");
	        String mid = jsonObject.optString("mid", "");
	       
	        String text = jsonObject.optString("text","");
	        String time = jsonObject.optString("time","");
	   	 JSONObject messageData = new JSONObject();
	   	 messageData.put("mid", mid); // 내 아이디
	  
	   	 messageData.put("toId", toId);
	   	 messageData.put("text", text);
	   	 messageData.put("time", time);
	   	 

	   	 TextMessage message1 = new TextMessage(messageData.toString());

	        
	        sendMessageToClient(toId, message1,session);
	     
	    }
	    
   	
	    private void sendMessageToClient(String toId, TextMessage message1,WebSocketSession session) {
	    	if (session.isOpen()) {
	    		
	    		WebSocketSession clientSession = clients.get(toId);
	    		
	    		JSONObject jsonObject = new JSONObject(message1.getPayload());
	    		// "message" 필드에서 메시지 값을 추출
	    		String message = jsonObject.getString("text");
	    		String sender = jsonObject.getString("mid");
	    		String time = jsonObject.getString("time");
	    	
	    		JSONObject messageObject = new JSONObject();
	    		
	    		messageObject.put("toId", toId);
	    		messageObject.put("message", message);
	    		messageObject.put("sender", sender);
	    		messageObject.put("time", time);
	    		
	    		//TextMessage message2 = new TextMessage(message);
	    		TextMessage message2 = new TextMessage(messageObject.toString());
	    		
	    		
	    		
	    	    if (clientSession != null && clientSession.isOpen()) {
	    	        try {
	    	        
	    	        	
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
	      
				String message = "연결해제";
			    String sessionToRemove = null;
			    for (Map.Entry<String, WebSocketSession> entry : clients.entrySet()) {
			        if (entry.getValue().equals(session)) {
			            sessionToRemove = entry.getKey();
			            break;
			        }
			    }

			    if (sessionToRemove != null) {
			    	
			    	
				        sendMessageToAllClients(sessionToRemove,message,session);
				        
			        clients.remove(sessionToRemove);
			        
			        System.out.println("WebSocket session closed for user: " + sessionToRemove);
			    }
			
			
	//System.out.println(" 이거 :"+session.getId());
	        //String userId = clients.
	        //System.out.println(userId);
	        //sessions.remove(session);
	        //clients.remove(userId);
	    }
	    
	    //public void sendMessageToClient(String clientId, String message) { //특정 아이디를 가진 클라이언트에게 메세지보내기
	      
	    //}
	    
	    public void sendMessageToAllClients(String mid,String message,WebSocketSession session) {  //모든 클라이언트에게 메시지보내기 
	    	
	    	if (session.isOpen()) {
	    		
	    		WebSocketSession senderSession = clients.get(mid);
	    		
	    	
	    		JSONObject messageObject = new JSONObject();
	    		
	    		messageObject.put("sender", mid);
	    		messageObject.put("message", message);
	    
	    	
	    		
	    		
	    		TextMessage message2 = new TextMessage(messageObject.toString());
	    		
	    		
	    	
		        for (WebSocketSession clientSession : clients.values()) {
		        	
		        	if (clientSession != null && clientSession.isOpen() && !clientSession.equals(senderSession)) {
		        	   try {
			                clientSession.sendMessage(message2);
			               
	    	    
	    	   
	    	            
	    	        } catch (IOException e) {
	    	            e.printStackTrace();
	    	        }
	    	    } else {
	    	        // 클라이언트가 로그인되지 않았거나 연결이 끊어진 경우에 대한 처리
	    	    }
	    		
	       
	    	}
	    }
}
}