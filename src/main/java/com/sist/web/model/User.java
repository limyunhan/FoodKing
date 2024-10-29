package com.sist.web.model;

import java.io.Serializable;

public class User implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String userId;
	private String userPwd;
	private String userName;
	private String userEmail;
	private String userGender;
	private String userStatus;
	private String userRegion;
	private String userFood;
	private String userTel;
	private String userRegDate;
	private String userImageName;
	private String userImageOrgName;
	private String userImageExt;
	private long userImageSize;
	
	public User() {
		userId = "";
		userPwd = "";
		userName = "";
		userEmail = "";
		userGender = "";
		userStatus = "";
		userRegion = "";
		userFood = "";
		userTel = "";
		userRegDate = "";
		userImageName = "";
		userImageOrgName = "";
		userImageExt = "";
		userImageSize = 0L;
	}

	public String getUserId() {return userId;}
	public void setUserId(String userId) {this.userId = userId;}
	public String getUserPwd() {return userPwd;}
	public void setUserPwd(String userPwd) {this.userPwd = userPwd;}
	public String getUserName() {return userName;}
	public void setUserName(String userName) {this.userName = userName;}
	public String getUserEmail() {return userEmail;}
	public void setUserEmail(String userEmail) {this.userEmail = userEmail;}
	public String getUserGender() {return userGender;}
	public void setUserGender(String userGender) {this.userGender = userGender;}
	public String getUserStatus() {return userStatus;}
	public void setUserStatus(String userStatus) {this.userStatus = userStatus;}
	public String getUserRegion() {return userRegion;}
	public void setUserRegion(String userRegion) {this.userRegion = userRegion;}
	public String getUserFood() {return userFood;}
	public void setUserFood(String userFood) {this.userFood = userFood;}
	public String getUserRegDate() {return userRegDate;}
	public void setUserRegDate(String userRegDate) {this.userRegDate = userRegDate;}
	public String getUserImageName() {return userImageName;}
	public void setUserImageName(String userImageName) {this.userImageName = userImageName;}
	public String getUserImageOrgName() {return userImageOrgName;}
	public void setUserImageOrgName(String userImageOrgName) {this.userImageOrgName = userImageOrgName;}
	public String getUserImageExt() {return userImageExt;}
	public void setUserImageExt(String userImageExt) {this.userImageExt = userImageExt;}
	public long getUserImageSize() {return userImageSize;}
	public void setUserImageSize(long userImageSize) {this.userImageSize = userImageSize;}
	public String getUserTel() {return userTel;}
	public void setUserTel(String userTel) {this.userTel = userTel;}
}
