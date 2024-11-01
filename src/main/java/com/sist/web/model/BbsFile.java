package com.sist.web.model;

import java.io.Serializable;

public class BbsFile implements Serializable {
	private static final long serialVersionUID = 1L;
	private short bbsFileSeq;
	private long bbsSeq;
	private String bbsFileOrgName;
	private String bbsFileName;
	private String bbsFileExt;
	private long bbsFileSize;
	private String bbsFileRegDate;
	
	public BbsFile() {
	    bbsFileSeq = 0;
		bbsSeq = 0L;
		bbsFileOrgName = "";
		bbsFileName = "";
		bbsFileExt = "";
		bbsFileSize = 0L;
		bbsFileRegDate = "";
	}

	public short getBbsFileSeq() {return bbsFileSeq;}
	public void setBbsFileSeq(short bbsFileSeq) {this.bbsFileSeq = bbsFileSeq;}
	public long getBbsSeq() {return bbsSeq;}
	public void setBbsSeq(long bbsSeq) {this.bbsSeq = bbsSeq;}
	public String getBbsFileOrgName() {return bbsFileOrgName;}
	public void setBbsFileOrgName(String bbsFileOrgName) {this.bbsFileOrgName = bbsFileOrgName;}
	public String getBbsFileName() {return bbsFileName;}
	public void setBbsFileName(String bbsFileName) {this.bbsFileName = bbsFileName;}
	public String getBbsFileExt() {return bbsFileExt;}
	public void setBbsFileExt(String bbsFileExt) {this.bbsFileExt = bbsFileExt;}
	public long getBbsFileSize() {return bbsFileSize;}
	public void setBbsFileSize(long bbsFileSize) {this.bbsFileSize = bbsFileSize;}
	public String getBbsFileRegDate() {return bbsFileRegDate;}
	public void setBbsFileRegDate(String bbsFileRegDate) {this.bbsFileRegDate = bbsFileRegDate;}
}
