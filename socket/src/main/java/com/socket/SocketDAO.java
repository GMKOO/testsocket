package com.socket;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface SocketDAO {



	List<Map<String, Object>> serchid(Map<String, Object> map);



	int msginsert(Map<String, Object> map);







	void Firstmsg(Map<String, Object> map);



	int isFirstConversation(Map<String, Object> map);



	String imgserch(Map<String, Object> map);



	List<Map<String, Object>> roomload(Map<String, Object> map);

}
