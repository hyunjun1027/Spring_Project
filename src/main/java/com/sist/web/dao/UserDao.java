package com.sist.web.dao;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.sist.web.model.User;

@Repository("userDao")
public interface UserDao {

	//사용자 정보 조회
	public User userSelect(String userId);
	
	//사용자 회원가입
	public int userInsert(User user);
	
	//사용자 정보 수정
	public int userUpdate(User user);
	
	//사용자 비밀번호 수정
	public int userPasswordUpdate(User user);
	
	//아이디 찾기
	public User userFindId(@Param("userName") String userName, @Param("userEmail") String userEmail);
	
	//비밀번호 찾기
	public User userFindPwd(@Param("userId") String userId, @Param("userName") String userName, @Param("userEmail") String userEmail);
	
	//회원탈퇴
	public int userDelete(User user);
	
}
