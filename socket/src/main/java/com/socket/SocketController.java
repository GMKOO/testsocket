package com.socket;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class SocketController {
		private SimpMessagingTemplate template;
		
		@Autowired
		SocketService socketService;
	
	@GetMapping(value = { "/", "/index" })
	public String index() {
		
		return "index";
	}
	
	@GetMapping("/chat1")
	public String chat1() {
		
		return "chat1";
	}
	
	@MessageMapping("/event")
	public void stomp(Map map) {
		
	this.template.convertAndSend("/topic/message", "hello");	
	
		
		
	}
	
	
	@ResponseBody
	@GetMapping("/serchid")
	public String serchid(@RequestParam Map<String,Object> map) {
		
		//System.out.println(map.get("fromname"));
		//System.out.println(map.get("myname"));
	
		
		
		List<Map<String, Object>> result = socketService.serchid(map);  // 여기에서 리스트로 이사람과 대화한 내역에 메세지를불러와야됨.
		
		JSONObject json = new JSONObject();
		
		/*
		 for (Map<String, Object> msg : result) {
	        
		
		 }
		
		*/
		//System.out.println(result.toString());
		 json.put("result", result);
		
		
		return json.toString();
	}
	
	@ResponseBody
	@GetMapping("/imgserch")
	public String imgserch(@RequestParam Map<String,Object> map) {
		
		String result = socketService.imgserch(map);
		JSONObject json = new JSONObject();
	
		 json.put("result", result);
		
		return json.toString();
	}
		
	@ResponseBody
	@GetMapping("/roomload")
	public String roomload(@RequestParam Map<String,Object> map) {
		
		
		List<Map<String, Object>> result = socketService.roomload(map);
		JSONObject json = new JSONObject();
	
	
		 json.put("result", result);
		
		 
		 //System.out.println(result.toString());
		return json.toString();
	}

	@ResponseBody
	@GetMapping("/msgcount")
	public String msgcount(@RequestParam String mid) {
		System.out.println("왜안줘?"+mid);
		
		int result = socketService.msgcount(mid);
		JSONObject json = new JSONObject();
		if(result!=0){	
			
			
			 json.put("result", result);
		} else {
			 json.put("result", 0);
			
		}
	
		 //System.out.println("0일거야 "+result);
		return json.toString();
	}

	
	
	
}
