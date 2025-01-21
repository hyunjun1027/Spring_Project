package com.sist.web.model;

import java.io.Serializable;

public class Comment implements Serializable{

	private static final long serialVersionUID = 1L;
	
	private long commSeq;				//댓글 번호
	private long brdSeq;				//게시글 번호
	private String userId;				//회원 아이디
	private String commContent;			//댓글 내용
	private String commRegDate;			//댓글 등록 날짜
	private String commModiDate;		//댓글 수정 날짜
	private long brdParent;  			//부모 댓글번호
	private long brdGroup;
	private long brdIndent;				//들여쓰기
	private long brdOrder;				//그룹순서
	private String status;

	
	private int boardType;

	
	public Comment() {
		commSeq = 0;
		brdSeq = 0;
		userId = "";
		commContent = "";	
		commRegDate = "";
		commModiDate = "";
		brdParent = 0;
		boardType = 0;
		brdGroup = 0;
		brdIndent = 0;
		brdOrder = 0;
		status = "Y";
	}
	
	
	

	
	public String getStatus() {
		return status;
	}





	public void setStatus(String status) {
		this.status = status;
	}





	public long getBrdIndent() {
		return brdIndent;
	}




	public void setBrdIndent(long brdIndent) {
		this.brdIndent = brdIndent;
	}




	public long getBrdOrder() {
		return brdOrder;
	}




	public void setBrdOrder(long brdOrder) {
		this.brdOrder = brdOrder;
	}




	public long getBrdGroup() {
		return brdGroup;
	}




	public void setBrdGroup(long brdGroup) {
		this.brdGroup = brdGroup;
	}




	public int getBoardType() {
		return boardType;
	}




	public void setBoardType(int boardType) {
		this.boardType = boardType;
	}




	public long getBrdParent() {
		return brdParent;
	}


	public void setBrdParent(long brdParent) {
		this.brdParent = brdParent;
	}


	public long getCommSeq() {
		return commSeq;
	}


	public void setCommSeq(long commSeq) {
		this.commSeq = commSeq;
	}


	public long getBrdSeq() {
		return brdSeq;
	}


	public void setBrdSeq(long brdSeq) {
		this.brdSeq = brdSeq;
	}


	public String getUserId() {
		return userId;
	}


	public void setUserId(String userId) {
		this.userId = userId;
	}


	public String getCommContent() {
		return commContent;
	}


	public void setCommContent(String commContent) {
		this.commContent = commContent;
	}


	public String getCommRegDate() {
		return commRegDate;
	}


	public void setCommRegDate(String commRegDate) {
		this.commRegDate = commRegDate;
	}


	public String getCommModiDate() {
		return commModiDate;
	}


	public void setCommModiDate(String commModiDate) {
		this.commModiDate = commModiDate;
	}
	
	
	
	
	
	
}
