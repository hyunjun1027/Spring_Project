package com.sist.web.service;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.web.dao.UserDao;
import com.sist.web.model.User;

@Service("userService")
public class UserService {
	
	private static Logger logger = LoggerFactory.getLogger(UserService.class);
	
	@Autowired
	private UserDao userDao;
	
	//회원 조회
	public User userSelect(String userId) {
		
		User user = null;
		
		try {
			
			user = userDao.userSelect(userId);
		
		}catch(Exception e) {
			
			logger.error("[UserService] userSelect Exception", e);
		
		}
		
		return user;
		
	}
	
	//회원 가입
	public int userInsert(User user) {
		
		int count = 0;
		
		try {
			
			count = userDao.userInsert(user);
		
		}catch(Exception e) {
			
			logger.error("[UserService] userInsert Exception", e);
		
		}
		
		return count;
		
	}
	
	
	//회원정보 수정
	public int userUpdate(User user) {
		
		int count = 0;
		
		try {
			
			count = userDao.userUpdate(user);
		
		}catch(Exception e) {
			
			logger.error("[UserService] userUpdate Exception", e);
		
		}
		
		return count;
	
	}
	
	//사용자 비밀번호 변경
	public int userPasswordUpdate(User user) {
		
		int count = 0;
		
		try {
			
			count = userDao.userPasswordUpdate(user);
		
		}catch(Exception e) {
			
			logger.error("[UserService] userUpdate Exception", e);
		}
		
		return count;
			
	}
	
	//아이디 찾기
	public User userFindId(String userName, String userEmail) {
		
		User user = null;
		
		try {
			
			user = userDao.userFindId(userName, userEmail);
			
		}catch(Exception e) {
			logger.error("[UserService]userFindId Exception", e);
		}

		return user;
		
	}
	
	//비밀번호 찾기
	public User userFindPwd(String userId, String userName, String userEmail) {
		
		User user = null;
		
		try {
			
			user = userDao.userFindPwd(userId, userName, userEmail);
			
		}catch(Exception e) {
			logger.error("[UserService]userFindPwd Exception", e);
		}

		return user;
		
	}
	
	
	//회원탈퇴
	public int userDelete(User user) {
		
		int count = 0;
		
		try {
			
			count = userDao.userDelete(user);
			
		}catch(Exception e) {
			logger.error("[UserService]userDelete Exception", e);
		}
		
		return count;
		
	}
	
	
	/*
	// 6자리 숫자 + 대문자영어 난수 생성
	public String randomCode2() {
		// 사용할 문자 집합 정의 (숫자 + 대문자)
		String characters = "abcdefghijklmnopqrstuvwxyz0123456789";
		SecureRandom random = new SecureRandom();
		StringBuilder code = new StringBuilder(6);

		for (int i = 0; i < 6; i++) {
			int index = random.nextInt(characters.length());
			code.append(characters.charAt(index));
		}

		return code.toString();
	}
	*/
	
	
	
	
	
	
}
