package com.sist.web.dao;

import java.util.Map;

import com.sist.web.model.User;

public interface UserDao {
	public abstract User userSelect(String userId);
	public abstract int userInsert(User user);
	public abstract int userUpdate(User user);
	public abstract int userWithdraw(String userId);
	public abstract int userPwdUpdate(Map<String, String> hashMap);
}