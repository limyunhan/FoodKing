package com.sist.web.model;

import java.io.Serializable;
import java.util.List;

public class HiBoard2 implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private long hiBbsSeq;
	private String userId;
	private long hiBbsGroup;
	private int hiBbsOrder;
	private int hiBbsIndent;
	private String hiBbsTitle;
	private String hiBbsContent;
	private int hiBbsReadCnt;
	private String regDate;
	private long hiBbsParent;
	private String userName;
	private String userEmail;
	
	private String searchType;
	private String searchValue;
	
	private long startRow;
	private long endRow;
	private List<HiBoardFile2> hiBoardFileList;
	
	public HiBoard2() {
		hiBbsSeq = 0L;
		userId = "";
		hiBbsGroup = 0L;
		hiBbsOrder = 0;
		hiBbsIndent = 0;
		hiBbsTitle = "";
		hiBbsContent = "";
		hiBbsReadCnt = 0;
		regDate = "";
		hiBbsParent = 0L;
		
		userName = "";
		userEmail = "";
		
		searchType = "";
		searchValue = "";
		
		startRow = 0L;
		endRow = 0L;
		hiBoardFileList = null;
	}

	public long getHiBbsSeq() {return hiBbsSeq;}
	public void setHiBbsSeq(long hiBbsSeq) {this.hiBbsSeq = hiBbsSeq;}
	public String getUserId() {return userId;}
	public void setUserId(String userId) {this.userId = userId;}
	public long getHiBbsGroup() {return hiBbsGroup;}
	public void setHiBbsGroup(long hiBbsGroup) {this.hiBbsGroup = hiBbsGroup;}
	public int getHiBbsOrder() {return hiBbsOrder;}
	public void setHiBbsOrder(int hiBbsOrder) {this.hiBbsOrder = hiBbsOrder;}
	public int getHiBbsIndent() {return hiBbsIndent;}
	public void setHiBbsIndent(int hiBbsIndent) {this.hiBbsIndent = hiBbsIndent;}
	public String getHiBbsTitle() {return hiBbsTitle;}
	public void setHiBbsTitle(String hiBbsTitle) {this.hiBbsTitle = hiBbsTitle;}
	public String getHiBbsContent() {return hiBbsContent;}
	public void setHiBbsContent(String hiBbsContent) {this.hiBbsContent = hiBbsContent;}
	public int getHiBbsReadCnt() {return hiBbsReadCnt;}
	public void setHiBbsReadCnt(int hiBbsReadCnt) {this.hiBbsReadCnt = hiBbsReadCnt;}
	public String getRegDate() {return regDate;}
	public void setRegDate(String regDate) {this.regDate = regDate;}
	public long getHiBbsParent() {return hiBbsParent;}
	public void setHiBbsParent(long hiBbsParent) {this.hiBbsParent = hiBbsParent;}
	public String getSearchType() {return searchType;}
	public void setSearchType(String searchType) {this.searchType = searchType;}
	public String getSearchValue() {return searchValue;}
	public void setSearchValue(String searchValue) {this.searchValue = searchValue;}
	public long getStartRow() {return startRow;}
	public void setStartRow(long startRow) {this.startRow = startRow;}
	public long getEndRow() {return endRow;}
	public void setEndRow(long endRow) {this.endRow = endRow;}
	public String getUserName() {return userName;}
	public void setUserName(String userName) {this.userName = userName;}
	public String getUserEmail() {return userEmail;}
	public void setUserEmail(String userEmail) {this.userEmail = userEmail;}
	public List<HiBoardFile2> getHiBoardFileList() {return hiBoardFileList;}
	public void setHiBoardFileList(List<HiBoardFile2> hiBoardFileList) {this.hiBoardFileList = hiBoardFileList;}
}