package com.sist.web.model;

import java.io.Serializable;

public class Likey implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private String userId;
	private long brdSeq;
	
	private String regDate;
	
	private int boardType;
	
	public Likey() {
		userId = "";
		brdSeq = 0;
		boardType = 0;
		regDate = "";
	}
	
	



	public String getRegDate() {
		return regDate;
	}





	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}





	public int getBoardType() {
		return boardType;
	}



	public void setBoardType(int boardType) {
		this.boardType = boardType;
	}



	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public long getBrdSeq() {
		return brdSeq;
	}

	public void setBrdSeq(long brdSeq) {
		this.brdSeq = brdSeq;
	}
	
	
	

}
