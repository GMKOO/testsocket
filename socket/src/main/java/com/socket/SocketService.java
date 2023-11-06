package com.socket;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class SocketService {
	
	@Autowired
	SocketDAO socketDAO;


	public List<Map<String, Object>> serchid(Map<String, Object> map) {
		
		 String toId = (String) map.get("toId");
	        String mid = (String) map.get("mid");
	    
		if (isFirstConversation(toId, mid)) {
            // 첫 대화인 경우 초기 메시지를 데이터베이스에 삽입
     
			
		//System.out.println("첫대화");
			map.put("toId", toId); // f
			map.put("mid", mid); // f
			map.put("message", "");
			map.put("read_status", 0);
			map.put("deletemsg", 2);
			map.put("exceptid", "제외");
			//System.out.println(map.toString());
		int result=socketDAO.Firstmsg(map);
		//System.out.println("첫메시지 반환"+result);
	
		socketDAO.Firstupdate(map);
		
			
        }
		
		
		
		return socketDAO.serchid(map);
	}


	public int msginsert(JSONObject jsonObject) {
		
		  Map<String, Object> map = new HashMap<>();
		    jsonObject.keys().forEachRemaining(key -> map.put(key, jsonObject.get(key)));
	
		
		return socketDAO.msginsert(map);
	}
	
	public boolean isFirstConversation(String toId,String mid) {
		  Map<String, Object> map = new HashMap<>();
		  map.put("toId", toId);
		  map.put("mid", mid);
		  map.put("read_status", 0);
		
		  
		
			int result =socketDAO.isFirstConversation(map);
			
			if(result ==0) {
				//System.out.println("firstmsg0 :"+result);
				return true;
			}
			
			//System.out.println("firstmsg1 :"+result);
			
				
		return false;
		
		
	}


	public String imgserch(Map<String, Object> map) {
		
		return socketDAO.imgserch(map);
	}


	public List<Map<String, Object>> roomload(Map<String, Object> map) {
	
		return socketDAO.roomload(map);
	}


	public void readupdate(JSONObject jsonObject) {
		
		  Map<String, Object> map = new HashMap<>();
 jsonObject.keys().forEachRemaining(key -> map.put(key, jsonObject.get(key)));
	
		
	
		socketDAO.readupdate(map);
	}


	public void chatcount(String toId) {
		socketDAO.chatcount(toId);
		
	}


	public Integer msgcount(String mid) {
		
		return socketDAO.msgcount(mid);
	}


	



	


	public int exceptid(JSONObject jsonObject) {
		  Map<String, Object> map = new HashMap<>();
		  jsonObject.keys().forEachRemaining(key -> map.put(key, jsonObject.get(key)));
		return socketDAO.exceptid(map);
	}


	public int block(JSONObject jsonObject) {
		 Map<String, Object> map = new HashMap<>();
		  jsonObject.keys().forEachRemaining(key -> map.put(key, jsonObject.get(key)));

		return socketDAO.block(map);
	}


	public List<Map<String, Object>> blocklist() {
		
		return socketDAO.blocklist();
	}


	public int blockchk(Map<String, Object> map) {
		
		return socketDAO.blockchk(map);
	}


	public int unblock(JSONObject jsonObject) {
		 Map<String, Object> map = new HashMap<>();
		  jsonObject.keys().forEachRemaining(key -> map.put(key, jsonObject.get(key)));

		return socketDAO.unblock(map);
	}


	public int firstmsgchk(Map<String, Object> map) {
		

		return socketDAO.firstmsgchk(map);
		
		
	}


	public void bnosave(Map<String, Object> map) {
		socketDAO.bnosave(map);
		
	}


	

	public int bnoload(Map<String, Object> paramMap) {
	
		return socketDAO.bnoload(paramMap);
	}


	

}
