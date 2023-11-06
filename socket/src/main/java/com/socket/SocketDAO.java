package com.socket;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface SocketDAO {



	List<Map<String, Object>> serchid(Map<String, Object> map);



	int msginsert(Map<String, Object> map);







	int Firstmsg(Map<String, Object> map);



	int isFirstConversation(Map<String, Object> map);



	String imgserch(Map<String, Object> map);



	List<Map<String, Object>> roomload(Map<String, Object> map);



	void readupdate(Map<String, Object> map);



	void chatcount(String toId);



	Integer msgcount(String mid);












	int toexit(Map<String, Object> map);



	int exceptid(Map<String, Object> map);






	void Firstupdate(Map<String, Object> map);



	int block(Map<String, Object> map);



	List<Map<String, Object>> blocklist();



	int blockchk(Map<String, Object> map);



	int unblock(Map<String, Object> map);



	int firstmsgchk(Map<String, Object> map);



	void bnosave(Map<String, Object> map);







	int bnoload(Map<String, Object> paramMap);



	;

}
