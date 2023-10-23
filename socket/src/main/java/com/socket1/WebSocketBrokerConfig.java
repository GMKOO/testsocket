package com.socket1;

import javax.servlet.http.HttpSession;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.stereotype.Controller;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketBrokerConfig implements WebSocketMessageBrokerConfigurer{
	

	 // 메시지 브로커를 설정
    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        config.enableSimpleBroker("queue","/topic"); // 토픽 메시지 브로커 설정
        config.setApplicationDestinationPrefixes("/app"); // 클라이언트에서 서버로 메시지를 보낼 때 사용할 접두사
    }

	
	// 클라이언트에서 WebSocket 연결을 수립할 엔드포인트를 설정
    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/chat") // WebSocket URL 경로 설정
                .setAllowedOrigins("*") // CORS 설정 (모든 도메인 허용)
                .withSockJS(); // SockJS 지원 (WebSocket을 지원하지 않는 브라우저와의 호환성을 위해)
    }
/*
    @Controller
    public class ChatController {
        @MessageMapping("/sendMessage")
        public void sendMessage(String message, HttpSession httpSession) {
            // 사용자의 WebSocket 세션을 얻어오기 위해 HttpSession 사용
            WebSocketSession webSocketSession = (WebSocketSession) httpSession.getAttribute("session");
            
            System.out.println("web"+webSocketSession.toString());
            /*
            if (webSocketSession != null) {
                // WebSocket 세션을 이용해 메시지 전송
                messagingTemplate.convertAndSendToUser(webSocketSession.getPrincipal().getName(), "/queue/message", message);
            }
            
        }

}
*/
}
