package com.sist.web.model;

import java.io.Serializable;

public class BbsSearch implements Serializable {
	private static final long serialVersionUID = 1L;
	
	// 북마크, 추천 여부를 위한 로그인한 유저의 아이디 멤버
	private String loginUserId;
	
	// 카테고리 아이디를 위한 멤버 // empty : 모든 게시글 조회
	private String cateFilter;
	
	// 페이징 처리를 위한 멤버
	private long startRow;
	private long endRow;
	
	// 마이 페이지 게시글을 위한 멤버
	private String myPageUserId;
	private String recomUserId;
	private String bookmarkUserId;
		
	// 비밀글 필터링을 위한 멤버
	private String isSecret;    // empty : 필터링 안함 1 : 비밀 글, 2 : 비밀 글 아님
	
	// 날짜 필터링을 위한 멤버
	private String periodFilter; // 1 : 1년 전, 2 : 6개월 전, 3 : 3개월 전, 4 : 1개월 전, 5 : 7일 전
	
	// 검색을 위한 멤버 (검색 타입, 검색 조건)
	private String searchType;    // empty : 검색 조건 없음 1 : 제목, 2 : 제목 + 내용, 3 : 작성자
	private String searchValue;   // 입력 받은 값
	
	// 정렬 기준을 위한 멤버
	private String orderBy;
	
	public BbsSearch() {
		loginUserId = "";
		
		cateFilter = "";
		
		startRow = 0L;
		endRow = 0L;
		
		myPageUserId = "";
		recomUserId = "";
		bookmarkUserId = "";
		
		isSecret = "";
		
		periodFilter = "";
		
		searchType = "";
		searchValue = "";
		
		orderBy = "";
	}

	public long getStartRow() {return startRow;}
	public void setStartRow(long startRow) {this.startRow = startRow;}
	public long getEndRow() {return endRow;}
	public void setEndRow(long endRow) {this.endRow = endRow;}
	public String getMyPageUserId() {return myPageUserId;}
	public void setMyPageUserId(String myPageUserId) {this.myPageUserId = myPageUserId;}
	public String getRecomUserId() {return recomUserId;}
	public void setRecomUserId(String recomUserId) {this.recomUserId = recomUserId;}
	public String getBookmarkUserId() {return bookmarkUserId;}
	public void setBookmarkUserId(String bookmarkUserId) {this.bookmarkUserId = bookmarkUserId;}
	public String getIsSecret() {return isSecret;}
	public void setIsSecret(String isSecret) {this.isSecret = isSecret;}
	public String getSearchType() {return searchType;}
	public void setSearchType(String searchType) {this.searchType = searchType;}
	public String getSearchValue() {return searchValue;}
	public void setSearchValue(String searchValue) {this.searchValue = searchValue;}
	public String getOrderBy() {return orderBy;}
	public void setOrderBy(String orderBy) {this.orderBy = orderBy;}
	public String getperiodFilter() {return periodFilter;}
	public void setperiodFilter(String periodFilter) {this.periodFilter = periodFilter;}
	public String getLoginUserId() {return loginUserId;}
	public void setLoginUserId(String loginUserId) {this.loginUserId = loginUserId;}
	public String getCateFilter() {return cateFilter;}
	public void setCateFilter(String cateFilter) {this.cateFilter = cateFilter;}
}