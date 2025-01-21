package com.sist.web.model;

import java.io.Serializable;

public class User implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private String userId;
	private String userPwd;
	private String userName;
	private String userEmail;
	private String status;
	private String regDate;
	private String addrCode;
	private String addrBase;
	private String addrDetail;
	private String rating;

	public User() {
		userId = "";
		userPwd = "";
		userName = "";
		userEmail = "";
		status = "N";
		regDate = "";
		addrCode = "";
		addrBase = "";
		addrDetail = "";
		rating = "3";
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserPwd() {
		return userPwd;
	}

	public void setUserPwd(String userPwd) {
		this.userPwd = userPwd;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserEmail() {
		return userEmail;
	}

	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public String getAddrCode() {
		return addrCode;
	}

	public void setAddrCode(String addrCode) {
		this.addrCode = addrCode;
	}

	public String getAddrBase() {
		return addrBase;
	}

	public void setAddrBase(String addrBase) {
		this.addrBase = addrBase;
	}

	public String getAddrDetail() {
		return addrDetail;
	}

	public void setAddrDetail(String addrDetail) {
		this.addrDetail = addrDetail;
	}

	public String getRating() {
		return rating;
	}

	public void setRating(String rating) {
		this.rating = rating;
	}


	
	
	
}
