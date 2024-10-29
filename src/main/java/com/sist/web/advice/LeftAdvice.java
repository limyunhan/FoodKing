package com.sist.web.advice;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.sist.common.util.StringUtil;
import com.sist.web.model.User;
import com.sist.web.service.UserService;
import com.sist.web.util.CookieUtil;

@ControllerAdvice
public class LeftAdvice {
	
	@Autowired
	private UserService userService;
	
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	
	@ModelAttribute("loginUser")
	public User getUser(HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		User loginUser = null;
		
		if (!StringUtil.isEmpty(cookieUserId)) {
			if (userService.userSelect(cookieUserId) != null) {
				if (StringUtil.equals(userService.userSelect(cookieUserId).getUserStatus(), "Y")) {
					loginUser = userService.userSelect(cookieUserId);
				} else {
					CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
				}
			} else {
				CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
			}
		}
		
		return loginUser;
	}
}