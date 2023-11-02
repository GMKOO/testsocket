package com.socket;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

@Configuration
@EnableWebSocket
public class ChatServer implements WebSocketConfigurer {
	
	
	

	 @Override
	    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
	        registry.addHandler(chatWebSocketHandler(), "/chat") // WebSocket 엔드포인트 및 핸들러 등록
	        .setAllowedOrigins("http://localhost:8080")
	        .withSockJS();
	        //.allowedOriginPatterns("*")
	    }

	    @Bean
	    public ChatWebSocketHandler chatWebSocketHandler() {
	        return new ChatWebSocketHandler(); // WebSocket 핸들러 빈 등록
	    }
	
	    
}
