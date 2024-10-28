package com.sist.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.sist.common.model.FileData;
import com.sist.common.util.StringUtil;
import com.sist.web.model.Response;
import com.sist.web.model.User;
import com.sist.web.service.UserService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;
import com.sist.web.util.JsonUtil;

@Controller("userController")
public class UserController {
	public static Logger logger = LoggerFactory.getLogger(UserController.class);
	
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Value("#{env['profile.img.dir']}")
	private String PROFILE_IMG_DIR;
	
	@Autowired
	private UserService userService;
	
	// 회원 가입 페이지
	@RequestMapping(value = "/user/regForm", method = RequestMethod.POST)
	public String regForm(HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		if (!StringUtil.isEmpty(cookieUserId)) {
			CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
			return "redirect:/";
		} else {
			return "/user/regForm";
		}
	}
	
	// 회원 가입 페이지 ID 중복 체크 ajax 통신
	@RequestMapping(value = "/user/idCheck", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> idCheck(HttpServletRequest request, HttpSession session) {
		Response<Object> ajaxResponse = new Response<>();
		
		String userId = HttpUtil.get(request, "userId");
		
		if (!StringUtil.isEmpty(userId)) {
			if (userService.userSelect(userId) == null) {
				ajaxResponse.setResponse(200, "사용 가능한 아이디");
				session.setAttribute("userId", userId);
				
			} else {
				ajaxResponse.setResponse(409, "아이디 중복");
			}
		} else {
			ajaxResponse.setResponse(400, "비정상적인 접근");
		}
		
		if (logger.isDebugEnabled()) {
			logger.debug("[UserController] /user/idCheck response \n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}
	
	// 회원가입 ajax 통신
	@RequestMapping(value = "/user/regProc", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> regProc(MultipartHttpServletRequest request, HttpSession session) {
		Response<Object> ajaxResponse = new Response<>();
		
		String userId = (String) session.getAttribute("userId");
		String userPwd = HttpUtil.get(request, "userPwd", "");
		String userEmail = HttpUtil.get(request, "userEmail", "");
		String userTel = HttpUtil.get(request, "userTel", "");
		String userName = HttpUtil.get(request, "userName", "");
		String userGender = HttpUtil.get(request, "userGender", "");
		String userRegion = HttpUtil.get(request, "userRegion", "");
		String userFood = HttpUtil.get(request, "userFood", "");
		
		FileData fileData = HttpUtil.getFile(request, "userImage", PROFILE_IMG_DIR);
				
		if (userId != null) {
			if (!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd) && !StringUtil.isEmpty(userEmail) && !StringUtil.isEmpty(userTel) && !StringUtil.isEmpty(userName) && !StringUtil.isEmpty(userGender) && !StringUtil.isEmpty(userRegion) && !StringUtil.isEmpty(userFood)) {
				if (userService.userSelect(userId) == null) {
					User user = new User();
					user.setUserId(userId);
					user.setUserPwd(userPwd);
					user.setUserEmail(userEmail);
					user.setUserTel(userTel);
					user.setUserName(userName);
					user.setUserGender(userGender);
					user.setUserRegion(userRegion);
					user.setUserFood(userFood);
					
					if (fileData != null && fileData.getFileSize() > 0) {
						user.setUserImageName(fileData.getFileName());
						user.setUserImageOrgName(fileData.getFileOrgName());
						user.setUserImageExt(fileData.getFileExt());
						user.setUserImageSize(fileData.getFileSize());
					}
					
					if (userService.userInsert(user)) {
						ajaxResponse.setResponse(200, "회원 가입 성공");
						
					} else {
						ajaxResponse.setResponse(500, "DB 정합성 오류");
					}
					
				} else {
					ajaxResponse.setResponse(409, "아이디 중복");
				}
				
			} else {
				ajaxResponse.setResponse(400, "비정상적인 접근");
			}
			
		} else {
			ajaxResponse.setResponse(412, "아이디 중복체크 수행하지 않음");
			
		}
		
		session.removeAttribute("userId"); 
		return ajaxResponse;
	}
	
	// 로그인 페이지
	@RequestMapping(value = "/user/login", method = RequestMethod.POST) 
	public String login(HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		if (!StringUtil.isEmpty(cookieUserId)) {
			CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
			return "redirect:/";
		} else {
			return "/user/regForm";
		}
	}
	
	// 로그인 ajax 통신 
	@RequestMapping(value = "/user/loginProc", method = RequestMethod.POST) 
	@ResponseBody
	public Response<Object> loginProc(HttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<>();
		
		
		return ajaxResponse;
	}
}
	