package com.socket;

import java.util.Map;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class JoinController {

	@Autowired
	LoginService loginService;
	
	
	

		
		@PostMapping("/joincheckid")
		
		public ResponseEntity<String> joincheckID(@RequestParam("id") String id) {
		JSONObject json = new JSONObject();
					
		 
			int checkid = loginService.joincheckID(id);
			json.put("result", checkid);
			
			return ResponseEntity.ok(json.toString());
		}
		
		@PostMapping("/joincreateid")
		public ResponseEntity<String> joinCreateID(@RequestParam Map<String, Object> map) {
		 
			JSONObject json = new JSONObject();
			int result = loginService.joinCreateID(map);
			
			System.out.println(map.toString());
			
			
			HttpHeaders headers = new HttpHeaders();
		    headers.add("Content-Type", "application/json; charset=UTF-8");

			json.put("result", result);
			System.out.println(json.toString());
		    
			return new ResponseEntity<>(json.toString(), headers, HttpStatus.OK);
		}
		
		
			

}

