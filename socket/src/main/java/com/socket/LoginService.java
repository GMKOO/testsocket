package com.socket;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class LoginService {
	
	
	
	@Autowired
	private LoginDAO loginDAO;

	public Map<String, Object> login(Map<String, Object> map) {
		
		return loginDAO.login(map);
	}

	public int joinCreateID(Map<String, Object> map) {
		
		return loginDAO.joinCreateID(map);
	}

	public int joincheckID(String id) {
		
		return loginDAO.joincheckID(id);
	}


	public Map<String, Object> checkID(Map<String, String> map) {
		
		return loginDAO.checkID(map);
	}
	


	}


