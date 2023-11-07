package com.socket;

import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
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
    
    //차단관리
    private Map<String,Set<String>> blockedClients = new ConcurrentHashMap<>();

 // 클라이언트 차단
    public void blockClient(String blockingClientId, String blockedClientId) {
    	blockedClients.computeIfAbsent(blockingClientId, k -> ConcurrentHashMap.newKeySet()).add(blockedClientId);
    //System.out.println("블럭"+getBlockedClients(blockingClientId));
    }

    // 클라이언트 차단 해제
    public void unblockClient(String blockingClientId, String blockedClientId) {
        Set<String> blockedClientsSet = blockedClients.get(blockingClientId);
        if (blockedClientsSet != null) {
            blockedClientsSet.remove(blockedClientId);
            if (blockedClientsSet.isEmpty()) {
                blockedClients.remove(blockingClientId);
            }
        }
    }
   
    //차단리스트불러오기 
    public Set<String> getBlockedClients(String blockingClientId) {
        return blockedClients.getOrDefault(blockingClientId, Collections.emptySet());
    }
    
    //접속중인 클라이언트들에키값으로 아이디찾아오는 메서드 
    private String getRecipientId(WebSocketSession session) {
        for (Map.Entry<String, WebSocketSession> entry : clients.entrySet()) {
            if (entry.getValue().equals(session)) {
                return entry.getKey();
            }
        }
        return null; // 예외 처리 필요
    }
    
	 @Override
	    public void afterConnectionEstablished(WebSocketSession session) throws Exception {  //연결된 후 
		
		 
		 if (session.isOpen()) {}
		 
	
	    }

	    @Override
	    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
	    	String payload = message.getPayload();
	    	JSONObject jsonObject = new JSONObject();
	    	CloseStatus status = null;
	    	
	    	List<Map<String,Object>> blockedUsers = socketService.blocklist();
	         //System.out.println(blockedUsers.toString());
	         
			 //웹소켓 연결후 전역으로 차단목록관리 
	         if(!blockedUsers.isEmpty()) {
	         for (Map<String, Object> blockedUser : blockedUsers) {
	        	    String blockerId = (String) blockedUser.get("blocker_id");
	        	    String blockedIds = (String) blockedUser.get("blocked_ids");

	        	  
	        	    String[] blockedIdArray = blockedIds.split(",");
	        	    for (String blockedId : blockedIdArray) {
	        	        blockClient(blockerId, blockedId);
	        	        
	        	    }
	        	    
	        	}
	         
	         }
	         System.out.println(blockedClients.toString()); 
	    	
	    	if (session.isOpen()) {
	    		
	    		
	    			payload = message.getPayload();
	    	 	jsonObject = new JSONObject(payload);
	    	

	    	 if (jsonObject.has("mid")  && !jsonObject.has("toId") && !jsonObject.has("text") 
	    	  && !jsonObject.has("close") && !jsonObject.has("exceptid") && !jsonObject.has("firstmsg")) {
	    	  
	       	
	    		 
	             handleInitialConnection(jsonObject, session);  // 처음 연결시 네임값만 확인하는 메서드
	             //String mid = jsonObject.optString("mid", "");
	      
	            
	             
	         } else if (jsonObject.has("toId") && jsonObject.has("mid") && jsonObject.has("text")
	        		 && !jsonObject.has("firstmsg")) {
	   
	        	  if(jsonObject.get("mid").equals(jsonObject.get("toId"))) {
	        		  System.out.println("같은 사람에게는 보낼수 없습니다.");
	        	  } else {
	        		  String toId = jsonObject.optString("toId"," ");
	        		  String mid = jsonObject.optString("mid"," ");
	        		  
	        		  Set<String> blockedClients = getBlockedClients(toId);
	  	    		
	      	    	if(!blockedClients.contains(mid)) {	
	             handleMessage(jsonObject, session); // 쪽지보낼때 보낼사람,메세지,보내는사람
	             int result=socketService.msginsert(jsonObject);
	            
	             
	             if (result==1) {
	            	 
	            	 socketService.chatcount(toId);
	            	 
	             }
	      
	    
	        	  	}
	        	  }
	        
	         	} else if (jsonObject.has("toId") && jsonObject.has("mid") && jsonObject.has("readmsg")
	         			&& !jsonObject.has("firstmsg")){
	        		  socketService.readupdate(jsonObject);
	         
	    	 
	         	}else if (jsonObject.has("mid") && jsonObject.has("sender") && jsonObject.has("firstmsg")) {
	         		//System.out.println("이거출력22");
	         		String sender = jsonObject.optString("sender", "");
	         		String mid = jsonObject.optString("mid", "");
	         		
	         		 JSONObject messageData = new JSONObject();
	        	   	 messageData.put("mid", mid); // 내 아이디
	        	   	 messageData.put("sender", sender);
	        	   	 messageData.put("firstmsg", sender+"님과 신규 대화가 시작 되었습니다.");
	        	   	 

	        	   	 TextMessage message1 = new TextMessage(messageData.toString());

	         		
	         		sendMessageToClient(mid,message1,session); //첫메시지  알람띄우기 
	         		
	         		
	         	
	         	
	        	}else if (jsonObject.has("mid") && jsonObject.has("close") && !jsonObject.has("firstmsg")) {
	         		
	         		afterConnectionClosed(session,status);
	         	} else if(jsonObject.has("mid") && jsonObject.has("toId") && jsonObject.has("exceptid") 
	         			&& !jsonObject.has("block") && !jsonObject.has("unblock") && !jsonObject.has("firstmsg")) {
	         	 int result = socketService.exceptid(jsonObject);
	         	
	   
	         	}  else if(jsonObject.has("mid") && jsonObject.has("toId") && jsonObject.has("exceptid") 
	         			&& jsonObject.has("block") && !jsonObject.has("unblock") && !jsonObject.has("firstmsg")) {
	         		 int result = socketService.block(jsonObject);
	         		int result1 = socketService.exceptid(jsonObject);
	         	
	         		 String blocked = jsonObject.optString("block", "");
	         		String mid = jsonObject.optString("mid", "");
	        
	         		blockClient(mid,blocked);
	         		 
	         	} else if(jsonObject.has("mid") && jsonObject.has("toId") && jsonObject.has("exceptid") 
	         			&& jsonObject.has("unblock") && !jsonObject.has("block") && !jsonObject.has("firstmsg")) {
	         		System.out.println("차단해제");
	         		
	         		int result = socketService.unblock(jsonObject);
		         	
	         		 String unblock = jsonObject.optString("unblock", "");
	         		String mid = jsonObject.optString("mid", "");
	        
	         		unblockClient(mid,unblock);
	         	
	         		
	         	}
	    	 }else {  // 세션이 오프라인인 경우
	    	
	    		 if(jsonObject.get("mid").equals(jsonObject.get("toId"))) {
	        		  System.out.println("같은 사람에게는 보낼수 없습니다.");
	        	  } else {
	        		  
	        		  String toId = jsonObject.optString("toId"," ");
	        		  String mid = jsonObject.optString("mid"," ");
	        		  
	        		  Set<String> blockedClients = getBlockedClients(toId);
	  	    		
	      	    	if(!blockedClients.contains(mid)) {	
	        		  
	    		int result=socketService.msginsert(jsonObject);
	    		//System.out.println("result2"+result);
	    		//연결이안됬을떄
	        	  }
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
	        
	        sendMessageToAllClients(mid,message,session);//접속알림
	        
	  
	        
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
	    		
	    		
	    		
	    		JSONObject jsonObject = new JSONObject(message1.getPayload());
	    		Set<String> blockedClients = getBlockedClients(toId);
	    		JSONObject messageObject = new JSONObject();
	    		
	    		if(jsonObject.has("mid") && jsonObject.has("sender") && jsonObject.has("firstmsg")) {
	    			
	    			System.out.println("이거출력");
	    			WebSocketSession clientSession = clients.get(toId);
	    			
	    			String sender = jsonObject.optString("sender", "");
	         		String mid = jsonObject.optString("mid", "");
	         		String firstmsg= jsonObject.optString("firstmsg", "");
	         		
	    			if(!blockedClients.contains(sender)) {	
	    		
	    			
	         		messageObject.put("mid", mid);
		    		messageObject.put("firstmsg", firstmsg);
		    		messageObject.put("sender", sender);
	    			
		    		TextMessage message2 = new TextMessage(messageObject.toString());
		    		
		    		
		    		
		    	    if (clientSession != null && clientSession.isOpen()) {
		    	        try {
		    	            clientSession.sendMessage(message2);
		    	        } catch (IOException e) {
		    	            e.printStackTrace();
		    	        }
		    	    } 
		    	    }else {
			    		   System.out.println("차단당해서못보냄2");
		    	    
		    	    } 
	    			}else {
	    		
	    		
	    		// "message" 필드에서 메시지 값을 추출
	    			
	    		WebSocketSession clientSession = clients.get(toId);
	    		
	    		String message = jsonObject.optString("text","");
	    		String sender = jsonObject.optString("mid","");
	    		String time = jsonObject.optString("time","");
	    		
	    	if(!blockedClients.contains(sender)) {	
	    		
	    		
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
	    	   }else {
	    		   System.out.println("차단당해서못보냄2");
	    	   }
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
			    	 clients.remove(sessionToRemove);
			    	   sendMessageToAllClients(sessionToRemove,message,session);
			    	
			        
			       
			        
			        System.out.println("WebSocket session closed for user: " + sessionToRemove);
			    
			
			    }
		}
  
	    
	    public void sendMessageToAllClients(String mid,String message,WebSocketSession session) {  //모든 클라이언트에게 메시지보내기 
	    	
	    	//System.out.println(mid);
	    	//System.out.println(message);
	    	if (session.isOpen()) {
	    		
	    		WebSocketSession senderSession = clients.get(mid);
	    		
	    		
	    	//System.out.println("1"+senderSession);
	    	//System.out.println("2"+senderSession1);
	    		JSONObject messageObject = new JSONObject();
	    		
	    		messageObject.put("sender", mid);
	    		messageObject.put("message", message);
	    		
	    
	    	
	    		
	    		
	    		TextMessage message2 = new TextMessage(messageObject.toString());
	    		
	    		
	    	
		        for (WebSocketSession clientSession : clients.values()) {
		        	
		        	if (clientSession != null && clientSession.isOpen() && !clientSession.equals(senderSession)) {
		        		 String recipientId = getRecipientId(clientSession); 
		        		 Set<String> blockedClients = getBlockedClients(recipientId);
		        		 
		        		  if (!blockedClients.contains(mid)) {
		        	   try {
			                clientSession.sendMessage(message2);
			               
	  
	    	            
	    	        } catch (IOException e) {
	    	            e.printStackTrace();
	    	        }
	    	    } else {
	    	       
	    	    	//차단당했을경우
	    	    	System.out.println("차단당해서못보냄");
	    	    }
	    		
	       
	    	}
		        }
		        }
}
	   
}