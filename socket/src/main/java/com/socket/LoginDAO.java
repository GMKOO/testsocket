package com.socket;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LoginDAO {

	Map<String, Object> login(Map<String, Object> map);

	int joinCreateID(Map<String, Object> map);

	int joincheckID(String id);

	Map<String, Object> checkID(Map<String, String> map);



}
