package com.sist.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sist.common.util.StringUtil;
import com.sist.web.model.Response;
import com.sist.web.model.User2;
import com.sist.web.service.UserService2;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;
import com.sist.web.util.JsonUtil;

/**
 * 차이점 : 사용자의 요청을 처리하는 프레젠테이션 계층으로 주로 웹 애플리케이션에서 HTTP 요청을 받아 그에 대한 응답을 처리하는 역할을 한다.
 * 주요 기능은 HTTP 요청(GET, POST 등)을 처리하고, 알맞은 뷰(View)로 데이터를 전달한다. 
 * 또 @RequestMapping, @GetMapping, @PostMapping 등과 함께 사용되어, 특정 URL에 매핑되는 메서드를 정의한다.
 * 주로 요청과 응답 처리에 초점을 맞추고 있어 비즈니스 로직은 서비스 계층에서 처리한다.
 */

@Controller("userConroller2")
public class UserController2 {
	public static Logger logger = LoggerFactory.getLogger(UserController2.class);
	
	@Autowired
	private UserService2 userService;
	
	/**
	 * @Value 어노테이션은 Spring 프레임워크에서 주로 사용하는 어노테이션으로, 
	 * 외부 설정 파일 (예: application.properties 또는 application.yml)이나 시스템 속성, 환경 변수 등에 정의된 값을 
	 * 스프링 빈(Bean)의 필드에 주입하는 데 사용된다.
	 */
	
	// 컨트롤러가 사용자의 요청에 대한 대부분의 응답을 처리하고, 로그인 과정에서 쿠키값을 설정하거나 바꾸기 때문에 일단 환경변수에 선언된 쿠키 이름을 가져와야한다.
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	// ajax 통신으로 로그인 로직을 처리해야함
	// @ResponseBody를 이용하여 ViewResolver가 아닌 HttpMessageConverter가 동작하도록 해야 한다. 주로 객체를 반환하고자 할 때 사용, 받아주는 쪽에서 JSON으로 파싱
	@RequestMapping(value = "/user/login2", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> login2(HttpServletRequest request, HttpServletResponse response){ // 매개변수는 request와 response임에 유의할 것
		Response<Object> ajaxResponse = new Response<>();
		String userId = HttpUtil.get(request, "userId");
		String userPwd = HttpUtil.get(request, "userPwd");
		
		if (!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd)) {
			User2 user = userService.userSelect(userId);
			if (user != null) {
				if (StringUtil.equals(user.getStatus(), "Y")) {
					if (StringUtil.equals(user.getUserPwd(), userPwd)) {
						CookieUtil.addCookie(response, "/", -1, AUTH_COOKIE_NAME, CookieUtil.stringToHex(userId));
						ajaxResponse.setResponse(1, "로그인 성공", user);
					} else {
						ajaxResponse.setResponse(-1, "비밀번호 불일치");
					}
				} else {
					ajaxResponse.setResponse(-99, "정지된 사용자");
				}
			} else {
				ajaxResponse.setResponse(404, "존재하지 않는 아이디");
			}
		} else {
			ajaxResponse.setResponse(400, "비정상적인 접근");
		}
		
		if (logger.isDebugEnabled()) {
			logger.debug("[UserController] /user/login2 response \n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}
	
	// 로그아웃 로직 처리
	// 쿠키 삭제후 리다이렉트 처리만 할 것이다.
	// 리다이렉트 처리를 위해서는 redirect:/ 문자열을 반환해야한다.
	/* 리턴 문자열의 의미: 스프링 컨트롤러에서 반환된 DispatcherServlet은 보통 뷰의 이름(뷰 리졸버가 찾아주는 논리적인 뷰 이름)을 문자열로 반환하는데, 
	 * 스프링은 이 반환된 문자열을 해석하여 해당 뷰를 사용자에게 렌더링한다.
	 * 여기서 redirect 와 같은 특정 문자열들이 포함되어 있으면 이를 특정 뷰의 이름이 아니라 명령으로 해석하게 된다.
	 */
	@RequestMapping(value = "/user/logout2", method = RequestMethod.GET)
	public String logout2(HttpServletRequest request, HttpServletResponse response) {
		if (CookieUtil.getCookie(request, AUTH_COOKIE_NAME) != null) {
			CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
		}
		
		return "redirect:/index2";
	}
	
	@RequestMapping(value = "/user/regForm2", method = RequestMethod.GET)
	public String regForm2(HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		if (!StringUtil.isEmpty(cookieUserId)) {
			CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
			return "redirect:/";
		} else {
			return "/user/regForm2";
		}
	}
	
	@RequestMapping(value = "/user/idCheck2", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> idCheck2(HttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<>();
		
		String userId = HttpUtil.get(request, "userId");
		
		if (!StringUtil.isEmpty(userId)) {
			if (userService.userSelect(userId) == null) {
				ajaxResponse.setResponse(404, "아이디 사용 가능");
			} else {
				ajaxResponse.setResponse(200, "아이디 중복");
			}
		} else {
			ajaxResponse.setResponse(400, "비정상적인 접근");
		}
		
		
		if (logger.isDebugEnabled()) {
			logger.debug("[UserController2] /user/idCheck2 response \n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}
	
	@RequestMapping(value = "/user/regProc2", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> regProc2(HttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<>();
		
		String userId = HttpUtil.get(request, "userId");
		String userPwd = HttpUtil.get(request, "userPwd");
		String userName = HttpUtil.get(request, "userName");
		String userEmail = HttpUtil.get(request, "userEmail");
	
		if (!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd) && !StringUtil.isEmpty(userName) && !StringUtil.isEmpty(userEmail)) {
			if (userService.userSelect(userId) == null) {
				User2 user = new User2();
				user.setUserId(userId);
				user.setUserPwd(userPwd);
				user.setUserName(userName);
				user.setUserEmail(userEmail);
				user.setStatus("Y");
				if (userService.userInsert(user)) {
					ajaxResponse.setResponse(201, "회원가입 성공");
				} else {
					ajaxResponse.setResponse(500, "DB 정합성 오류");
				}
			} else {
				ajaxResponse.setResponse(401, "중복된 아이디");
			}
		} else {
			ajaxResponse.setResponse(400, "비정상적인 접근");
		}
		
		if (logger.isDebugEnabled()) {
			logger.debug("[UserController2] /user/regProc2 response \n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}
	

	@RequestMapping(value = "/user/updateForm2", method = RequestMethod.GET)
	public String updateForm2(Model model, HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		User2 user = userService.userSelect(cookieUserId);
		model.addAttribute("user", user);
		
		return "/user/updateForm2";
	}
	
	@RequestMapping(value = "/user/updateProc2", method = RequestMethod.POST) 
	@ResponseBody
	public Response<Object> updateProc2(HttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String userId = HttpUtil.get(request, "userId");
		String userPwd = HttpUtil.get(request, "userPwd");
		String userName = HttpUtil.get(request, "userName");
		String userEmail = HttpUtil.get(request, "userEmail");
		
		if (!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd) && !StringUtil.isEmpty(userName) && !StringUtil.isEmpty(userEmail)) {
			if (StringUtil.equals(userId, cookieUserId)) {
				User2 user = userService.userSelect(userId);
				user.setUserPwd(userPwd);
				user.setUserName(userName);
				user.setUserEmail(userEmail);
				if (userService.userUpdate(user)) {
					ajaxResponse.setResponse(200, "회원 정보 업데이트");
				} else {
					ajaxResponse.setResponse(500, "DB 정합성 오류");
				}
			} else {
				ajaxResponse.setResponse(430, "아이디 정보 일치하지 않음");
			}
		} else {
			ajaxResponse.setResponse(400, "비정상적인 접근");
		}
			
		if (logger.isDebugEnabled()) {
			logger.debug("[UserController2] /user/updateProc2 response \n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}
}