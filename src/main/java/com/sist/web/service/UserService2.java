package com.sist.web.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.web.dao.UserDao2;
import com.sist.web.model.User2;

// 1. @Controller, @Repository와 마찬가지로 자동으로 Spring의 Bean으로 등록되어 의존성 주입이 가능해짐
// 2. 명확한 역할 구분 
/*
 * Controller가 사용자로부터 입력을 받고 결과를 뷰페이지에 보여주는 역할을 담당한다면
 * Service 는 여러 데이터 소스에서 데이터를 가져오거나 트랜잭션을 관리하는 비즈니스 로직 처리 역할을 한다.
 * Repository는 DB와 직접 상호작용하며 쿼리 실행 및 결과처리를 수행하며 mybatis를 사용중이므로 인터페이스로 작성한다.
 */

@Service("userService2")
public class UserService2 {
	public static Logger logger = LoggerFactory.getLogger(UserService2.class);
	
	@Autowired 
	UserDao2 userDao; // 생성된 빈 객체를 자동으로 할당해준다.
	
	// 에러처리까지 완료된 이 메소드를 최종적으로 사용해야한다. (userDao의 userSelect를 사용하면 안됨, 에러처리가 안되어있음, 서비스를 사용하는 이유)
	public User2 userSelect(String userId) {
		User2 user = null;
		
		try {
			user = userDao.userSelect(userId); // userDao에서 Repository 어노테이션을 적용했고, 이는 mybatis에 의해 구현되었으므로 에러처리는 여기서 수행해야한다.
		} catch (Exception e) {
			logger.error("[UserService2] userSelect Exception", e);
		}
		
		return user;
	}
	
	public boolean userInsert(User2 user) {
		int cnt = 0;
		
		try {
			cnt = userDao.userInsert(user);
		} catch (Exception e) {
			logger.error("[UserService2] userInsert Exception", e);
		} 
		
		return (cnt == 1);		
	}
	
	public boolean userUpdate(User2 user) {
		int cnt = 0;
		
		try {
			cnt = userDao.userUpdate(user);
		} catch (Exception e) {
			logger.error("[UserService2] userUpdate Exception", e);
		}
		
		return (cnt == 1);		
	}
}