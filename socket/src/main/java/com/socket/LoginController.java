package com.socket;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;





@Controller
public class LoginController {
	
	
	@Autowired
	private LoginService loginService;
	
	@GetMapping("/login")
	public String login() {
		
		
		
		return "login";
	}
	
	
	@GetMapping("/join")
	public String join() {
		return "join";
	}
	
	@GetMapping("/warning")
	public String warning() {
		return "warning";
	}
	
	@PostMapping("/login")
	public String login(@RequestParam("id") String id, @RequestParam("pw") String pw,HttpServletRequest request) {
	    Map<String, Object> map = new HashMap<>();

	    map.put("id", id);
	    map.put("pw", pw);

	    Map<String, Object> result = loginService.login(map);
	    System.out.println(result.toString());

	    System.out.println("로그인컨트롤러출력문 " + result.get("count"));
	    System.out.println("로그인컨트롤러출력문 " + result.get("m_name"));

	    
	    if (result.get("count").toString().equals("1")) {
	        HttpSession session = request.getSession();


	        session.setAttribute("mname", result.get("m_name"));
	        session.setAttribute("id", id);
	        
	        session.setAttribute("count", result.get("count"));
	      

	        System.out.println("세션 카운트 " + result.get("count"));
	   

	        return "login";
	    } else {
	    
	    
	        return "redirect:login";
	} 
	    }
	
	@GetMapping("/logout")
	public String logout(HttpSession session) {
		if (session.getAttribute("mname") != null) {
			// session.invalidate(); // 세션 삭제하기
			session.removeAttribute("mname");
		}
		if (session.getAttribute("id") != null) {

			session.removeAttribute("id");
		}
		session.setMaxInactiveInterval(0); // 세션 유지시간을 0으로 =종료시키기
		session.invalidate(); // 세션초기화 = 종료 = 세션의 모든속성 값을제거

		return "redirect:login";

	}

	
	
	
}
