package com.sist.web.model;

import java.io.Serializable;
import java.util.List;

public class Bbs implements Serializable {

	private static final long serialVersionUID = 1L;
	
	// DB 멤버
	private long bbsSeq;
	private String subCateCombinedNum;
	private String userId;
	private String bbsTitle;
	private String bbsContent;
	private String bbsPwd;
	private int bbsReadCnt;
	private String bbsStatus;
	private String bbsRegDate;
	private String bbsUpdateDate;
	
	// select 조인으로 생성되는 멤버
	private String userName;
	private int bbsComCnt;
	private int bbsRecomCnt;
	private String bbsMainCateName;
	private String bbsSubCateName;
	private String isBookmarked;
	private String isRecommended;
	
	// 구조상 게시글이 포함하고 있는 멤버
	private List<BbsFile> bbsFileList;
	private List<BbsImage> bbsImageList;
	
	public Bbs() {
	    bbsSeq = 0L;
		subCateCombinedNum = "";
		userId = "";
		bbsTitle = "";
		bbsContent = "";
		bbsPwd = "";
		bbsReadCnt = 0;
		bbsStatus = "";
		bbsRegDate = "";
		bbsUpdateDate = "";

		userName = "";
		bbsComCnt = 0;
		bbsRecomCnt = 0;
		bbsMainCateName = "";
		bbsSubCateName = "";
		isBookmarked = "";
		isRecommended = "";
		
		bbsFileList = null;
		bbsImageList = null;		
	}
	
	// Getters and Setters
	public long getBbsSeq() {return bbsSeq;}
	public void setBbsSeq(long bbsSeq) {this.bbsSeq = bbsSeq;}
	public String getSubCateCombinedNum() {return subCateCombinedNum;}
	public void setSubCateCombinedNum(String subCateCombinedNum) {this.subCateCombinedNum = subCateCombinedNum;}
	public String getUserId() {return userId;}
	public void setUserId(String userId) {this.userId = userId;}
	public String getBbsTitle() {return bbsTitle;}
	public void setBbsTitle(String bbsTitle) {this.bbsTitle = bbsTitle;}
	public String getBbsContent() {return bbsContent;}
	public void setBbsContent(String bbsContent) {this.bbsContent = bbsContent;}
	public String getBbsPwd() {return bbsPwd;}
	public void setBbsPwd(String bbsPwd) {this.bbsPwd = bbsPwd;}
	public int getBbsReadCnt() {return bbsReadCnt;}
	public void setBbsReadCnt(int bbsReadCnt) {this.bbsReadCnt = bbsReadCnt;}
	public int getBbsComCnt() {return bbsComCnt;}
	public void setBbsComCnt(int bbsComCnt) {this.bbsComCnt = bbsComCnt;}
	public int getBbsRecomCnt() {return bbsRecomCnt;}
	public void setBbsRecomCnt(int bbsRecomCnt) {this.bbsRecomCnt = bbsRecomCnt;}
	public String getBbsStatus() {return bbsStatus;}
	public void setBbsStatus(String bbsStatus) {this.bbsStatus = bbsStatus;}
	public String getBbsRegDate() {return bbsRegDate;}
	public void setBbsRegDate(String bbsRegDate) {this.bbsRegDate = bbsRegDate;}
	public String getBbsUpdateDate() {return bbsUpdateDate;}
	public void setBbsUpdateDate(String bbsUpdateDate) {this.bbsUpdateDate = bbsUpdateDate;}
	public List<BbsFile> getBbsFileList() {return bbsFileList;}
	public void setBbsFileList(List<BbsFile> bbsFileList) {this.bbsFileList = bbsFileList;}
	public List<BbsImage> getBbsImageList() {return bbsImageList;}
	public void setBbsImageList(List<BbsImage> bbsImageList) {this.bbsImageList = bbsImageList;}
	public String getUserName() {return userName;}
	public void setUserName(String userName) {this.userName = userName;}
	public String getBbsMainCateName() {return bbsMainCateName;}
	public void setBbsMainCateName(String bbsMainCateName) {this.bbsMainCateName = bbsMainCateName;}
	public String getBbsSubCateName() {return bbsSubCateName;}
	public void setBbsSubCateName(String bbsSubCateName) {this.bbsSubCateName = bbsSubCateName;}
	public String getIsBookmarked() {return isBookmarked;}
	public void setIsBookmarked(String isBookmarked) {this.isBookmarked = isBookmarked;}
	public String getIsRecommended() {return isRecommended;}
	public void setIsRecommended(String isRecommended) {this.isRecommended = isRecommended;}
}