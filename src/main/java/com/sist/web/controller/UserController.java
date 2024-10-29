package com.sist.web.controller;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
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

@Controller
public class UserController {
	public static Logger logger = LoggerFactory.getLogger(UserController.class);
	
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Value("#{env['profile.img.dir']}")
	private String PROFILE_IMG_DIR;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	JavaMailSenderImpl mailSender;
	
	// 회원 가입 페이지
	@RequestMapping(value = "/user/regForm")
	public String regForm(HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		if (!StringUtil.isEmpty(cookieUserId)) {
			CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
			return "redirect:/";
		} else {
			return "/user/regForm";
		}
	}
	
	// 회원 가입시 ID 중복 체크 ajax 통신
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
	@RequestMapping(value = "/user/login") 
	public String login(HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		if (!StringUtil.isEmpty(cookieUserId)) {
			CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
			return "redirect:/";
		} else {
			return "/user/login";
		}
	}
	
	// 로그인 ajax 통신 
	@RequestMapping(value = "/user/loginProc", method = RequestMethod.POST) 
	@ResponseBody
	public Response<Object> loginProc(HttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<>();
		
		String userId = HttpUtil.get(request, "userId", "");
		String userPwd = HttpUtil.get(request, "userPwd", "");
		
		if (!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd)) {
			User user = userService.userSelect(userId);
			
			if (user != null) {
				if (StringUtil.equals(user.getUserStatus(), "Y")) {
					if (StringUtil.equals(userPwd, user.getUserPwd())) {
						
					} else {
						ajaxResponse.setResponse(401, "비밀번호 불일치");
					}
					
				} else {
					ajaxResponse.setResponse(403, "정지된 사용자");
				}
				
			} else {
				ajaxResponse.setResponse(404, "아이디 일치하지 않음");
			}
			
		} else {
			ajaxResponse.setResponse(400, "비정상적인 접근");
		}
		
		return ajaxResponse;
	}
	
	// 로그아웃
	@RequestMapping(value = "/user/logOut") 
	public String logOut(HttpServletRequest request, HttpServletResponse response) {
		if (CookieUtil.getCookie(request, AUTH_COOKIE_NAME) != null) {
			CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
		}
		
		return "redirect:/";
	}
	
	// 아이디 찾기 페이지
	@RequestMapping(value = "/user/idFind")
	public String idFind(HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		if (!StringUtil.isEmpty(cookieUserId)) {
			CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
			return "redirect:/";
		} else {
			return "/user/idFind";
		}
	}
	
	// email 인증번호 발송 ajax 통신
	@RequestMapping(value = "/user/idFindSendAuth")
	public Response<Object> idFindSendAuth(HttpServletRequest request, HttpSession session) {
		Response<Object> ajaxResponse = new Response<>();
		
		String userEmail = HttpUtil.get(request, "userEmail", "");
		String userTel = HttpUtil.get(request, "userTel", "");
		
		if (!StringUtil.isEmpty(userEmail) && !StringUtil.isEmpty(userTel)) {
			
			Map<String, String> hashMap = new HashMap<>();
			hashMap.put("userEmail", userEmail);
			hashMap.put("userTel", userTel);
			
			if (userService.userIdFind(hashMap)) {
				
		        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
		        StringBuilder authCode = new StringBuilder();
		        Random random = new Random();

		        for (int i = 0; i < 6; i++) {
		            int idx = random.nextInt(chars.length());
		            authCode.append(chars.charAt(idx));
		        }
				
		        LocalDateTime expireTime = LocalDateTime.now().plusMinutes(5); // 만료 시간 5분 설정

		        // 이메일 보낼 양식
		        String setFrom = "lim9807@naver.com";
		        String title = "[FoodKing] 아이디 찾기 인증 메일";
		        String content = "인증 코드는 " + authCode.toString() + "입니다.";
		        
		        try {
		        	MimeMessage message = mailSender.createMimeMessage();
		        	MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
		        	helper.setFrom(setFrom);
		        	helper.setTo(userEmail);
		        	helper.setSubject(title);
		        	helper.setText(content, true);
		        	mailSender.send(message);
		        	  	
		        } catch (Exception e) {
		        	logger.error("[UserController] idFindProc Exception", e);
		        }
		        
	            // 세션의 기존 인증 코드와 만료 시간 초기화
	            session.removeAttribute("authCode");
	            session.removeAttribute("expireTime");
	            
	            // 새로운 인증 코드와 만료 시간 세션에 저장
	            session.setAttribute("authCode", authCode.toString());
	            session.setAttribute("expireTime", expireTime);
		        
		        ajaxResponse.setResponse(200, "인증 코드가 발송됨");
		        
			} else {
				ajaxResponse.setResponse(404, "사용자 존재하지 않음");
			}
			
		} else {
			ajaxResponse.setResponse(400, "비정상적인 접근");
		}
		
		return ajaxResponse;
	}
	
	// 아이디 찾기 
	
}
	