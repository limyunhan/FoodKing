package com.sist.web.service;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.web.dao.UserDao;
import com.sist.web.model.User;

@Service
public class UserService {
	public static Logger logger = LoggerFactory.getLogger(UserService.class);
	
	@Autowired
	private UserDao userDao;
	
	// 사용자 조회
	public User userSelect(String userId) {
		User user = null;
		
		try {
			user = userDao.userSelect(userId);
			
		} catch (Exception e) {
			logger.error("[UserService] userSelect Exception", e);
		}
		
		return user;
	}
	
	// 회원가입
	public boolean userInsert(User user) {
		int cnt = 0;
		
		try {
			cnt = userDao.userInsert(user);
		} catch (Exception e) {
			logger.error("[UserService] userInsert Exception", e);
		}
		
		return (cnt == 1);
	}
	
	// 사용자 정보 수정
	public boolean userUpdate(User user) {
		int cnt = 0;
		
		try {
			cnt = userDao.userUpdate(user);
		} catch (Exception e) {
			logger.error("[UserService] userUpdate Exception", e);
		}
		
		return (cnt == 1);
	}
	
	// 회원 탈퇴
	public boolean userWithdraw(String userId) {
		int cnt = 0;
		
		try {
			cnt = userDao.userWithdraw(userId);
		} catch (Exception e) {
			logger.error("[UserService] userWithdraw Exception", e);
		}
		
		return (cnt == 1);
	}
	
	// 비밀번호 수정
	public boolean userPwdUpdate(Map<String, String> hashMap) {
		int cnt = 0;
		
		try {
			cnt = userDao.userPwdUpdate(hashMap);
		} catch (Exception e) {
			logger.error("[UserService] userPwdUpdate Exception", e);
		}
		
		return (cnt == 1);
	}
	
	// 유저 아이디 찾기
	public String userIdFind(Map<String, String> hashMap) {
		List<String> list = null;
		String userId = null;
		
		try {
			list = userDao.userIdFind(hashMap);
		} catch (Exception e) {
			logger.error("[UserService] userIdFind Exception", e);
		}
		
		userId = (list != null && list.size() == 1) ? list.get(0) : "";
		
		return userId;
	}
	
	// 유저 프로필 사진 업데이트
	public boolean userImageUpdate(User user) {
		int cnt = 0;
		
		try {
			cnt = userDao.userImageUpdate(user);
		} catch(Exception e) {
			logger.error("[UserService] userProfileUpdate Exception", e);
		}
		
		return (cnt == 1);
	}
}