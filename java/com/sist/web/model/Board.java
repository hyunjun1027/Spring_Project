package com.sist.web.model;

import java.io.Serializable;

public class Board implements Serializable{

	private static final long serialVersionUID = 1L;

	private long brdSeq;			//게시물 번호
	private String userId;			//아이디
	private long brdGroup;			//그룹번호
	private int brdOrder;			//그룹순서
	private int brdIndent;			//들여쓰기
	private String brdTitle;		//게시물 제목
	private String brdContent;		//게시물 내용
	private int brdReadCnt;			//게시물 조회수
	private String regDate;			//게시물 등록일
	private long brdParent;			//부모게시물 번호
	private String modDate;			//수정일
	
	private int likeCnt;
	
	private String brdPwd;
	
	private String fileOrgName;		//원본파일명
	private String fileName;	    //서버파일명
	
	private String searchType;		//검색타입 (1:이름, 2:제목, 3:내용)
	private String searchValue;		//검색값
	
	private String userName;		//사용자명
	private String userEmail;		//사용자 이메일
	private String rating; 
	
	private long startRow;			//시작페이지 rownum
	private long endRow;			//끝페이지 rownum
	
	private BoardFile boardFile;
	
	private int boardType;
	
	
	public Board() {
		
		brdSeq = 0;				//게시물 번호
		userId = "";			//아이디
		brdGroup = 0;			//그룹번호
		brdOrder = 0;			//그룹순서
		brdIndent = 0;			//들여쓰기
		brdTitle = "";			//게시물 제목
		brdContent = "";		//게시물 내용
		brdReadCnt = 0;			//게시물 조회수
		regDate = "";			//게시물 등록일
		brdParent = 0;			//부모게시물 번호
		modDate = "";			//수정일
		userName = "";			//사용자명
		userEmail = "";			//사용자 이메일
		likeCnt = 0;
		
		fileOrgName = "";
		fileName = "";
		rating = "3";
		
		searchType = "";
		searchValue = "";
		boardType = 1;
		
		startRow = 0;			//시작페이지 rownum
		endRow = 0;				//끝페이지 rownum
		
		boardFile = null;
		
		brdPwd = "";
		
	}
	
	
	



	public String getBrdPwd() {
		return brdPwd;
	}






	public void setBrdPwd(String brdPwd) {
		this.brdPwd = brdPwd;
	}






	public String getRating() {
		return rating;
	}




	public void setRating(String rating) {
		this.rating = rating;
	}




	public int getLikeCnt() {
		return likeCnt;
	}

	public void setLikeCnt(int likeCnt) {
		this.likeCnt = likeCnt;
	}


	public String getFileOrgName() {
		return fileOrgName;
	}




	public void setFileOrgName(String fileOrgName) {
		this.fileOrgName = fileOrgName;
	}




	public String getFileName() {
		return fileName;
	}




	public void setFileName(String fileName) {
		this.fileName = fileName;
	}




	public int getBoardType() {
		return boardType;
	}




	public void setBoardType(int boardType) {
		this.boardType = boardType;
	}




	public BoardFile getBoardFile() {
		return boardFile;
	}




	public void setBoardFile(BoardFile boardFile) {
		this.boardFile = boardFile;
	}




	public String getSearchType() {
		return searchType;
	}




	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}




	public String getSearchValue() {
		return searchValue;
	}




	public void setSearchValue(String searchValue) {
		this.searchValue = searchValue;
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


	public long getBrdGroup() {
		return brdGroup;
	}


	public void setBrdGroup(long brdGroup) {
		this.brdGroup = brdGroup;
	}


	public int getBrdOrder() {
		return brdOrder;
	}


	public void setBrdOrder(int brdOrder) {
		this.brdOrder = brdOrder;
	}


	public int getBrdIndent() {
		return brdIndent;
	}


	public void setBrdIndent(int brdIndent) {
		this.brdIndent = brdIndent;
	}


	public String getBrdTitle() {
		return brdTitle;
	}


	public void setBrdTitle(String brdTitle) {
		this.brdTitle = brdTitle;
	}


	public String getBrdContent() {
		return brdContent;
	}


	public void setBrdContent(String brdContent) {
		this.brdContent = brdContent;
	}


	public int getBrdReadCnt() {
		return brdReadCnt;
	}


	public void setBrdReadCnt(int brdReadCnt) {
		this.brdReadCnt = brdReadCnt;
	}


	public String getRegDate() {
		return regDate;
	}


	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}


	public long getBrdParent() {
		return brdParent;
	}


	public void setBrdParent(long brdParent) {
		this.brdParent = brdParent;
	}


	public String getModDate() {
		return modDate;
	}


	public void setModDate(String modDate) {
		this.modDate = modDate;
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


	public long getStartRow() {
		return startRow;
	}


	public void setStartRow(long startRow) {
		this.startRow = startRow;
	}


	public long getEndRow() {
		return endRow;
	}


	public void setEndRow(long endRow) {
		this.endRow = endRow;
	}
	
	
	
}
