package com.socket;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class RestCheckController {
	// 
	@Autowired
	LoginService loginService;
	
	
	@PostMapping("/checkID")
	public ResponseEntity<String> checkID(@RequestParam Map<String, String> map, HttpServletRequest request) {
		JSONObject json = new JSONObject();
		
	
		String id = map.get("id");
	    String pw = map.get("pw");
	    
	    int interval = 40; 
	    Map<String, Object> checkLogin = loginService.checkID(map);
	    json.put("result", checkLogin.get("count"));
	    json.put("interval", interval);
	    
	    if (checkLogin.get("count").equals(1)) {
	        // 세션을 만들어서 로그인 지정 시간동안 유지 시킵니다.
	        HttpSession session = request.getSession();
	        session.setMaxInactiveInterval(interval);
	        session.setAttribute("mname", checkLogin.get("m_name"));
	        session.setAttribute("id", id);
	        session.setAttribute("count", checkLogin.get("count"));
	        
	        System.out.println("세션id출력" + checkLogin.get("m_id"));
	        System.out.println("세션id출력1" + id);
	        
	        System.out.println("REST컨트롤러출력문" + checkLogin.get("m_name"));    
	        
	        return ResponseEntity.ok(json.toString());
	    } else { 
	        json.put("result", "0");
	        return ResponseEntity.ok(json.toString());
	    }
	} 
	
	@PostMapping(value="/name", produces = "application/json; charset=UTF-8")
	public ResponseEntity<String> name(HttpServletRequest request) {
		HttpSession session = request.getSession();
	    JSONObject json = new JSONObject();
	    String mname =(String) session.getAttribute("mname"); 
	 
	    json.put("mname", mname);
	        //json.put("mname", session.getAttribute("mname"));
	  
	        //String jsonString = json.toString();
	        //HttpHeaders headers = new HttpHeaders();
	       // headers.setContentType(MediaType.APPLICATION_JSON);
	        System.out.println("mname컨트롤러"+mname);
	        //return new ResponseEntity<>(mname, headers, HttpStatus.OK);
	        return ResponseEntity.ok(json.toString());
	}
	
	
	@PostMapping("/extendSession")
	public ResponseEntity<String> extendSession(HttpServletRequest request) {
		JSONObject json = new JSONObject();
		HttpSession session = request.getSession();
		
		
		if(session.getMaxInactiveInterval() != 0) {
			
		
		   // 현재 시간과 세션 만료 시간 사이의 차이를 계산
		long currentTimeMillis = System.currentTimeMillis();
        long sessionExpirationMillis = session.getLastAccessedTime() + session.getMaxInactiveInterval() * 1000;
        long remainingMillis = sessionExpirationMillis - currentTimeMillis;
        
     // 남은 시간을 초 단위로 계산
        long remainingSeconds = remainingMillis / 1000;

        json.put("remainingTime", remainingSeconds);
        
		}
  
         System.out.println("rest남은시간"+json.toString());
        
		return ResponseEntity.ok(json.toString());
	}
	
	@PostMapping("/sessionextend")
	public ResponseEntity<String> sessionextend(HttpServletRequest request ) {
		JSONObject json = new JSONObject();
	
		int interval = 600; 
		json.put("interval",interval);
		System.out.println("interval추가문"+json.toString());	
	
		return ResponseEntity.ok(json.toString());
		
		} 
	
	@PostMapping("/checkLoginStatus")
	public ResponseEntity<String> checkLoginStatus(HttpServletRequest request) {
		JSONObject json = new JSONObject();
		HttpSession session = request.getSession();
	
		String result = (String) session.getAttribute("id");
		json.put("session",result );
		
		
		System.out.println("새로고침시session값확인"+json.toString());
		
		
		return ResponseEntity.ok(json.toString());
	}
	

	
}
