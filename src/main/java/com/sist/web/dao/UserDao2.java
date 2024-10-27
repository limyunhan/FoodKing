package com.sist.web.dao;

import org.springframework.stereotype.Repository;

import com.sist.web.model.User2;

//1. DB에서 발생하는 예외를 Spring의 DAOException으로 변환하여 처리하게 함
//2. 객체는 자바 빈으로 등록됨
//3. 구현 클래스는 mybatis에 의하여 자동으로 만들어짐

@Repository("userDao2")
public interface UserDao2 {
	public abstract User2 userSelect(String userId);
	public abstract int userInsert(User2 user);
	public abstract int userUpdate(User2 user);
}