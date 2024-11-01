package com.sist.web.model;

import java.io.Serializable;

public class BbsImage implements Serializable {
	private static final long serialVersionUID = 1L;
	private short bbsImageSeq;
	private long bbsSeq;
	private String bbsImageOrgName;
	private String bbsImageName;
	private String bbsImageExt;
	private long bbsImageSize;
	private String bbsImageRegDate;

	public BbsImage() {
		bbsImageSeq = 0;
		bbsSeq = 0L;
		bbsImageOrgName = "";
		bbsImageName = "";
		bbsImageExt = "";
		bbsImageSize = 0L;
		bbsImageRegDate = "";
	}
	
	public short getBbsImageSeq() {return bbsImageSeq;}
	public void setBbsImageSeq(short bbsImageSeq) {this.bbsImageSeq = bbsImageSeq;}
	public long getBbsSeq() {return bbsSeq;}
	public void setBbsSeq(long bbsSeq) {this.bbsSeq = bbsSeq;}
	public String getBbsImageOrgName() {return bbsImageOrgName;}
	public void setBbsImageOrgName(String bbsImageOrgName) {this.bbsImageOrgName = bbsImageOrgName;}
	public String getBbsImageName() {return bbsImageName;}
	public void setBbsImageName(String bbsImageName) {this.bbsImageName = bbsImageName;}
	public String getBbsImageExt() {return bbsImageExt;}
	public void setBbsImageExt(String bbsImageExt) {this.bbsImageExt = bbsImageExt;}
	public long getBbsImageSize() {return bbsImageSize;}
	public void setBbsImageSize(long bbsImageSize) {this.bbsImageSize = bbsImageSize;}
	public String getBbsImageRegDate() {return bbsImageRegDate;}
	public void setBbsImageRegDate(String bbsImageRegDate) {this.bbsImageRegDate = bbsImageRegDate;}
}