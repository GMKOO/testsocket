package com.socket;

import java.security.Principal;

import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageExceptionHandler;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.annotation.SendToUser;
import org.springframework.stereotype.Controller;

@Controller
@MessageMapping("ksug")
public class HelloController {
	private SimpMessagingTemplate template;
	/*
	@MessageMapping("springcamp.{year}")
	@SendTo("/topic/message")
	public String message1(@DestinationVariable int year) {
		return "";
		
	}
	
	@MessageMapping("echo")
	@SendTo("/queue/message")
	public String message2(String message) {
		return "";
	
	}
	csrf
	*/
	@MessageExceptionHandler
	@SendToUser("/queue/error")
	public String handleException(Exception exception) {
		
		return exception.toString();
	}
	
	@MessageMapping("echo-every")
	public void echoToEvery(String echo) {
		this.template.convertAndSend("/topic/message",echo);
	}
	
	@MessageMapping("echo-one")
	public void echoToOne(Principal principal,String echo) {
		this.template.convertAndSendToUser(principal.getName(),"/queue/message",echo);
	}
	
}
