package com.sist.web.controller;

import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
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
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.sist.common.model.FileData;
import com.sist.common.util.FileUtil;
import com.sist.common.util.StringUtil;
import com.sist.web.model.Bbs;
import com.sist.web.model.BbsSearch;
import com.sist.web.model.Paging;
import com.sist.web.model.Response;
import com.sist.web.model.User;
import com.sist.web.service.BbsService;
import com.sist.web.service.UserService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;
import com.sist.web.util.JsonUtil;

import io.lettuce.core.api.sync.RedisCommands;

@Controller
public class UserController {
	public static Logger logger = LoggerFactory.getLogger(UserController.class);
	
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Value("#{env['profile.img.dir']}")
	private String PROFILE_IMG_DIR;
	
	@Value("#{env['html.template.dir']}")
	private String HTML_TEMPLATE_DIR;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private BbsService bbsService;
	
	@Autowired
	private RedisCommands<String, String> redisCommands;
	
	@Autowired
	JavaMailSenderImpl mailSender;
	
	private static final int MY_LIST_COUNT = 10;
	private static final int MY_PAGE_COUNT = 5;
	
	// 회원 가입 페이지
	@RequestMapping(value = "/user/register")
	public String regForm(HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		if (!StringUtil.isEmpty(cookieUserId)) {
			CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
			return "redirect:/";
		} else {
			return "/user/register";
		}
	}
	
	// 회원 가입시 ID 중복 체크 ajax 
	@RequestMapping(value = "/user/idCheck", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> idCheck(HttpServletRequest request, HttpSession session) {
		Response<Object> ajaxResponse = new Response<>();
		
		String userId = HttpUtil.get(request, "userId");
		
		if (!StringUtil.isEmpty(userId)) {
			if (userService.userSelect(userId) == null) {
				ajaxResponse.setResponse(200, "사용 가능한 아이디");
				
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
	
	// 회원가입 ajax 
	@RequestMapping(value = "/user/registerProc", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> registerProc(MultipartHttpServletRequest request, HttpSession session) {
		Response<Object> ajaxResponse = new Response<>();
		
		String userId = HttpUtil.get(request, "userId", "");
		String userPwd = HttpUtil.get(request, "userPwd", "");
		String userEmail = HttpUtil.get(request, "userEmail", "");
		String userTel = HttpUtil.get(request, "userTel", "");
		String userName = HttpUtil.get(request, "userName", "");
		String userGender = HttpUtil.get(request, "userGender", "");
		String userRegion = HttpUtil.get(request, "userRegion", "");
		String userFood = HttpUtil.get(request, "userFood", "");
		
		FileData fileData = HttpUtil.getFile(request, "userImage", PROFILE_IMG_DIR);
				
		if (!StringUtil.isEmpty(userId)) {
			if (!StringUtil.isEmpty(userPwd) && !StringUtil.isEmpty(userEmail) && !StringUtil.isEmpty(userTel) && !StringUtil.isEmpty(userName) && !StringUtil.isEmpty(userGender) && !StringUtil.isEmpty(userRegion) && !StringUtil.isEmpty(userFood)) {
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
	
	// 로그인 ajax  
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
						CookieUtil.addCookie(response, "/", -1, AUTH_COOKIE_NAME, CookieUtil.stringToHex(userId));
						ajaxResponse.setResponse(200, "로그인 성공");
						
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
	
	// 이메일 인증번호 발송 ajax (아이디 찾기 페이지)
	@RequestMapping(value = "/user/idFindSendAuth", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> idFindSendAuth(HttpServletRequest request) {
	    Response<Object> ajaxResponse = new Response<>();
	    
	    String userName = HttpUtil.get(request, "userName", "");
	    String userTel = HttpUtil.get(request, "userTel", "");
	    String userEmail = HttpUtil.get(request, "userEmail", "");

	    if (!StringUtil.isEmpty(userEmail) && !StringUtil.isEmpty(userTel) && !StringUtil.isEmpty(userName)) {
	        Map<String, String> hashMap = new HashMap<>();
	        hashMap.put("userName", userName);
	        hashMap.put("userEmail", userEmail);
	        hashMap.put("userTel", userTel);
	        
	        String userId = userService.userIdFind(hashMap);
	        if (!StringUtil.isEmpty(userId)) {
	            String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
	            StringBuilder authCode = new StringBuilder();
	            Random random = new Random();

	            for (int i = 0; i < 6; i++) {
	                int idx = random.nextInt(chars.length());
	                authCode.append(chars.charAt(idx));
	            }

	            // 이메일 보낼 양식
	            String setFrom = "lim9807@naver.com";
	            String title = "[FoodKing] 아이디 찾기 인증 메일";
	            
	            try {
	            	String template = new String(Files.readAllBytes(Paths.get(HTML_TEMPLATE_DIR + FileUtil.getFileSeparator() + "mail.html")), StandardCharsets.UTF_8);
                    template = template.replace("${type}", "인증 번호")
                                       .replace("${value}", authCode.toString());
                    
	                MimeMessage message = mailSender.createMimeMessage();
	                MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
	                helper.setFrom(setFrom);
	                helper.setTo(userEmail);
	                helper.setSubject(title);
	                helper.setText(template, true);
	                mailSender.send(message);

	                // Redis에 인증 코드와 인증 여부 저장
	                redisCommands.set("idFind:" + userId, "unverified");  
	                String redisKey = "idFindAuthCode:" + userId; 
	                redisCommands.set(redisKey, authCode.toString()); 
	                redisCommands.expire(redisKey, 5 * 60); 
	                ajaxResponse.setResponse(200, "인증 코드가 발송됨");

	            } catch (Exception e) {
	                logger.error("[UserController] idFindSendAuth Exception", e);
	                ajaxResponse.setResponse(503, "메일 서버 오류");
	            }
	            
	        } else {
	            ajaxResponse.setResponse(404, "사용자 존재하지 않음");
	        }

	    } else {
	        ajaxResponse.setResponse(400, "비정상적인 접근");
	    }

	    return ajaxResponse;
	}
	
	// 이메일 인증번호 검증 ajax (아이디 찾기 페이지)
	@RequestMapping(value = "/user/idFindVerifyAuth", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> idFindVerifyAuth(HttpServletRequest request) {
		Response<Object> ajaxResponse = new Response<>();
		
	    String userName = HttpUtil.get(request, "userName", "");
	    String userTel = HttpUtil.get(request, "userTel", "");
	    String userEmail = HttpUtil.get(request, "userEmail", "");
		String authCode = HttpUtil.get(request, "authCode", "");
		
		if (!StringUtil.isEmpty(userEmail) && !StringUtil.isEmpty(userTel) && !StringUtil.isEmpty(userName)) {
			Map<String, String> hashMap = new HashMap<>();
	        hashMap.put("userName", userName);
	        hashMap.put("userEmail", userEmail);
	        hashMap.put("userTel", userTel);
	        
	        String userId = userService.userIdFind(hashMap);
	        
			if (!StringUtil.isEmpty(userId)) {
	        	String redisAuthCode = redisCommands.get("idFindAuthCode:" + userId);
	        	
	        	if (!StringUtil.isEmpty(redisAuthCode)) {
	        		
			        if (StringUtil.equals(authCode, redisAuthCode)) {
			        	ajaxResponse.setResponse(200, "인증코드가 일치합니다.");
			        	redisCommands.set("idFind:" + userId, "verified");
			        	redisCommands.del("idFindAuthCode:" + userId);
			        	
			        } else {
			        	ajaxResponse.setResponse(403, "인증코드 불일치");
			        }
			        
	        	} else {
	        		ajaxResponse.setResponse(410, "만료되거나 존재하지 않는 인증코드");
	        	}
	        	
			} else {
				ajaxResponse.setResponse(404, "사용자 존재하지 않음");
			}
			
		} else {
			ajaxResponse.setResponse(400, "비정상적인 접근");
		}
	
		return ajaxResponse;
	}
	
	// 아이디 찾기 Proc ajax 
	@RequestMapping(value = "/user/idFindProc", method = RequestMethod.POST) 
	@ResponseBody
	public Response<Object> idFindProc(HttpServletRequest request) {
		Response<Object> ajaxResponse = new Response<>();
		
		String userName = HttpUtil.get(request, "userName", "");
	    String userTel = HttpUtil.get(request, "userTel", "");
	    String userEmail = HttpUtil.get(request, "userEmail", "");
	    
	    
	    if (!StringUtil.isEmpty(userEmail) && !StringUtil.isEmpty(userTel) && !StringUtil.isEmpty(userName)) {
	        Map<String, String> hashMap = new HashMap<>();
	        hashMap.put("userName", userName);
	        hashMap.put("userEmail", userEmail);
	        hashMap.put("userTel", userTel);
	        
	        String userId = userService.userIdFind(hashMap);
	        if (!StringUtil.isEmpty(userId)) {
	        	
	        	String isVerified = redisCommands.get("idFind:" + userId);
	        	
	        	if (!StringUtil.isEmpty(isVerified)) {
	        		
	        		if (StringUtil.equals(isVerified, "verified")) {
		        		ajaxResponse.setResponse(200, "인증됨", userId);
		        		redisCommands.del("idFind:" + userId);
		        		
	        		} else {
	        			ajaxResponse.setResponse(403, "인증 되지 않음");
	        		}
	        		
	        	} else {
	        		ajaxResponse.setResponse(428, "인증코드를 발급하지 않음");
	        	}
	        	
	        } else {
	        	ajaxResponse.setResponse(404, "사용자 존재하지 않음");
	        }
	        
	    } else {
	    	ajaxResponse.setResponse(400, "비정상적인 접근");
	    }
		
		return ajaxResponse;
	}
	
	// 비밀번호 찾기 페이지
	@RequestMapping(value = "/user/pwdFind")
	public String pwdFind(HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		if (!StringUtil.isEmpty(cookieUserId)) {
			CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
			return "redirect:/";
		} else {
			return "/user/pwdFind";
		}
	}
	
	// 이메일 인증번호 발송 ajax (비밀번호 찾기 페이지)
	@RequestMapping(value = "/user/pwdFindSendAuth", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> pwdFindSendAuth(HttpServletRequest request) {
		Response<Object> ajaxResponse = new Response<>();
		
		String userId = HttpUtil.get(request, "userId", "");
		String userEmail = HttpUtil.get(request, "userEmail", "");
		
		if (!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userEmail)) {
			User user = userService.userSelect(userId);
			
			if (user != null && StringUtil.equals(user.getUserStatus(), "Y")) {
				if (StringUtil.equals(userEmail, user.getUserEmail())) {
				
		            String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
		            StringBuilder authCode = new StringBuilder();
		            Random random = new Random();
	
		            for (int i = 0; i < 6; i++) {
		                int idx = random.nextInt(chars.length());
		                authCode.append(chars.charAt(idx));
		            }
		            
		            String setFrom = "lim9807@naver.com";
		            String title = "[Food King] 비밀번호 찾기 인증 메일";

		            try {
		            	String template = new String(Files.readAllBytes(Paths.get(HTML_TEMPLATE_DIR + FileUtil.getFileSeparator() + "mail.html")), StandardCharsets.UTF_8);
	                    template = template.replace("${type}", "인증 번호")
	                                       .replace("${value}", authCode.toString());
	                    
		                MimeMessage message = mailSender.createMimeMessage();
		                MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
		                helper.setFrom(setFrom);
		                helper.setTo(userEmail);
		                helper.setSubject(title);
		                helper.setText(template, true);
		                mailSender.send(message);
		                
		                // Redis에 인증 코드와 인증 여부 저장
		                redisCommands.set("pwdFind:" + userId, "unverified");   
		                String redisKey = "pwdFindAuthCode:" + userId; 
		                redisCommands.set(redisKey, authCode.toString()); 
		                redisCommands.expire(redisKey, 5 * 60); 
		                
		                ajaxResponse.setResponse(200, "인증 코드가 발송됨");
	
		            } catch (Exception e) {
		                logger.error("[UserController] pwdFindSendAuth Exception", e);
		                ajaxResponse.setResponse(503, "메일 서버 오류");
		            }
		            
				} else {
					ajaxResponse.setResponse(401, "이메일 일치하지 않음");
				}
				
			} else {
				ajaxResponse.setResponse(404, "사용자 존재하지 않음");
			}
			
		} else {
			ajaxResponse.setResponse(400, "비정상적인 접근");
		}
		
		return ajaxResponse;
	}
	
	// 이메일 인증번호 검증 ajax (비밀번호 찾기 페이지)
	@RequestMapping(value = "/user/pwdFindVerifyAuth", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> pwdFindVerifyAuth(HttpServletRequest request) {
		Response<Object> ajaxResponse = new Response<>();
		
		String userId = HttpUtil.get(request, "userId", "");
	    String userEmail = HttpUtil.get(request, "userEmail", "");
		String authCode = HttpUtil.get(request, "authCode", "");
		
		if (!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userEmail) && !StringUtil.isEmpty(authCode)) {
			User user = userService.userSelect(userId);
			
			if (user != null && StringUtil.equals(user.getUserStatus(), "Y")) {
				
				if (StringUtil.equals(userEmail, user.getUserEmail())) {
				
					String redisAuthCode = redisCommands.get("pwdFindAuthCode:" + userId);
					
					if (!StringUtil.isEmpty(redisAuthCode)) {
						
						if (StringUtil.equals(authCode, redisAuthCode)) {
				        	ajaxResponse.setResponse(200, "인증코드 일치");
				        	redisCommands.set("pwdFind:" + userId, "verified");
				        	redisCommands.del("pwdFindAuthCode:" + userId);
				        	
						} else {
							ajaxResponse.setResponse(403, "인증코드 불일치");
						}
						
					} else {
						ajaxResponse.setResponse(410, "만료되거나 존재하지 않는 인증코드");
					}
					
				} else {
					ajaxResponse.setResponse(401, "이메일 일치하지 않음");
				}
				
			} else {
				ajaxResponse.setResponse(404, "사용자 존재하지 않음");
			}

		} else {
			ajaxResponse.setResponse(400, "비정상적인 접근");
		}
	
		return ajaxResponse;
	}
	
	// 비밀번호 찾기 Proc ajax (임시 비밀번호 발급)
	@RequestMapping(value = "/user/pwdFindProc", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> pwdFindProc(HttpServletRequest request) {
		Response<Object> ajaxResponse = new Response<>();
		
		String userId = HttpUtil.get(request, "userId", "");
		String userEmail = HttpUtil.get(request, "userEmail", "");
		
		if (!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userEmail)) {
			User user = userService.userSelect(userId);
			
			if (user != null && StringUtil.equals(user.getUserStatus(), "Y")) {
				
				if (StringUtil.equals(user.getUserEmail(), userEmail)) {
		        	String isVerified = redisCommands.get("pwdFind:" + userId);
		        	
		        	if (!StringUtil.isEmpty(isVerified)) {
		        		
		        		if (StringUtil.equals(isVerified, "verified")) {
		        			String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
				            Random random = new Random();
			        		
				            int length = random.nextInt(7) + 6; // 6 ~ 12자리 사이의 임시 비밀번호 발급
				            
				            StringBuilder password = new StringBuilder();
				            for (int i = 0; i < length; i++) {
				            	int index = random.nextInt(chars.length());
				            	password.append(chars.charAt(index));
				            }
				            
				            String setFrom = "lim9807@naver.com";
				            String title = "[Food King] 임시 비밀번호 발급 메일";
				            
				            try {
				            	String template = new String(Files.readAllBytes(Paths.get(HTML_TEMPLATE_DIR + FileUtil.getFileSeparator() + "mail.html")), StandardCharsets.UTF_8);
	                            template = template.replace("${type}", "임시 비밀번호")
	                                               .replace("${value}", password.toString());

				                MimeMessage message = mailSender.createMimeMessage();
				                MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
				                helper.setFrom(setFrom);
				                helper.setTo(userEmail);
				                helper.setSubject(title);
				                helper.setText(template, true);
				                mailSender.send(message);
				                
					            Map<String, String> hashMap = new HashMap<>();
					            hashMap.put("userId", userId);
					            hashMap.put("userPwd", password.toString());
					            
					            if (userService.userPwdUpdate(hashMap)) {
					            	
					            	ajaxResponse.setResponse(200, "임시 비밀번호가 발급됨");
					            	
					            } else {
					            	ajaxResponse.setResponse(500, "DB 정합성 오류");
					            }
				                
				            } catch (Exception e) {
				                logger.error("[UserController] pwdFindProc Exception", e);
				                ajaxResponse.setResponse(503, "메일 발송 오류");
				            }
				            
		        		} else {
		        			ajaxResponse.setResponse(403, "인증 되지 않음");
		        		}
		        		
		        	} else {
		        		ajaxResponse.setResponse(428, "인증코드를 발급하지 않음");
		        	}
					
				} else {
					ajaxResponse.setResponse(401, "이메일 일치하지 않음");
				}
				
			} else {
				ajaxResponse.setResponse(404, "사용자 존재하지 않음");
			}
			
		} else {
			ajaxResponse.setResponse(400, "비정상적인 접근");
		}
		
		return ajaxResponse;
	}
	
	// 마이 페이지
	@RequestMapping(value = "/user/myPage")
	public String myPage(Model model, HttpServletRequest request) {
		long bbsCurPage = HttpUtil.get(request, "bbsCurPage", 1L);
		
		String myPage = HttpUtil.get(request, "myPage", "1");
		String periodFilter = HttpUtil.get(request, "periodFilter", "");
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		User user = userService.userSelect(cookieUserId);
		model.addAttribute("user", user);
		
		BbsSearch bbsSearch = new BbsSearch();
		bbsSearch.setUserId(user.getUserId());
		bbsSearch.setMyPage(myPage);
		bbsSearch.setperiodFilter(periodFilter);
		bbsSearch.setBbsOrderBy("1");
		bbsSearch.setSearchType(searchType);
		bbsSearch.setSearchValue(searchValue);
		
		long totalCnt = bbsService.bbsListCnt(bbsSearch);
		List<Bbs> bbsList = null;
		Paging bbsPaging = null;
		
		if (totalCnt > 0) {
			bbsPaging = new Paging("/user/myPage", totalCnt, MY_LIST_COUNT, MY_PAGE_COUNT, bbsCurPage, "bbsCurPage");
			bbsSearch.setStartRow(bbsPaging.getStartRow());
			bbsSearch.setEndRow(bbsPaging.getEndRow());
			bbsList = bbsService.bbsList(bbsSearch);
		}
		
		model.addAttribute("myPage", myPage);
		model.addAttribute("bbsCurPage", bbsCurPage);
		model.addAttribute("periodFilter", periodFilter);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("bbsList", bbsList);
		model.addAttribute("bbsPaging", bbsPaging);
		
		return "/user/myPage";
	}
	
	// 사용자 업데이트 페이지
	@RequestMapping(value = "/user/update")
	public String update(Model model, HttpServletRequest request, HttpServletResponse response) {
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		User user = userService.userSelect(cookieUserId);
		model.addAttribute("user", user);
		
		return "/user/update";
	}
	
	// 사용자 업데이트 ajax 
	@RequestMapping(value = "/user/updateProc", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> updateProc(HttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String userPwd = HttpUtil.get(request, "userPwd", "");
		String userEmail = HttpUtil.get(request, "userEmail", "");
		String userTel = HttpUtil.get(request, "userTel", "");
		String userName = HttpUtil.get(request, "userName", "");
		String userRegion = HttpUtil.get(request, "userRegion", "");
		String userFood = HttpUtil.get(request, "userFood", "");
		
		if (!StringUtil.isEmpty(userPwd) && !StringUtil.isEmpty(userEmail) && !StringUtil.isEmpty(userTel) && !StringUtil.isEmpty(userName) && !StringUtil.isEmpty(userRegion) && !StringUtil.isEmpty(userFood)) {
			
			User user = userService.userSelect(cookieUserId);
			
			if (user != null && StringUtil.equals(user.getUserStatus(), "Y")) {
				user.setUserPwd(userPwd);
				user.setUserEmail(userEmail);
				user.setUserTel(userTel);
				user.setUserName(userName);
				user.setUserRegion(userRegion);
				user.setUserFood(userFood);
				
				if (userService.userUpdate(user)) {
					ajaxResponse.setResponse(200, "유저 정보 수정됨");
					
				} else {
					ajaxResponse.setResponse(500, "DB 정합성 오류");
				}
				
			} else {
				CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
				ajaxResponse.setResponse(404, "사용자 존재하지 않음");
			}
			
		} else {
			ajaxResponse.setResponse(400, "비정상적인 접근");
		}
				
		return ajaxResponse;
	}
	
	// 사용자 회원탈퇴 ajax
	@RequestMapping(value = "/user/delete", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> delete(HttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String userPwd = HttpUtil.get(request, "userPwd", "");
		
		if (!StringUtil.isEmpty(userPwd)) {
			User user = userService.userSelect(cookieUserId);
			
			if (user != null && StringUtil.equals(user.getUserStatus(), "Y")) {
				if (StringUtil.equals(user.getUserPwd(), userPwd)) {
					if (userService.userWithdraw(cookieUserId)) {
						CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
						ajaxResponse.setResponse(200, "회원 탈퇴 완료");
						
					} else {
						ajaxResponse.setResponse(500, "DB 정합성 오류");
					}
					
				} else {
					ajaxResponse.setResponse(401, "비밀번호 일치하지 않음");
				}
				
			} else {
				CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
				ajaxResponse.setResponse(404, "사용자 존재하지 않음");
			}
			
		} else {
			ajaxResponse.setResponse(400, "비정상적인 접근");
		}

		return ajaxResponse;
	}
	
	// 사용자 프로필 사진 수정 ajax
	@RequestMapping(value = "/user/updateImage", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> updateImage(MultipartHttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		FileData fileData = HttpUtil.getFile(request, "userImage", PROFILE_IMG_DIR);
		if (fileData != null && fileData.getFileSize() > 0) {
			User user = userService.userSelect(cookieUserId);
			
			if (user != null && StringUtil.equals(user.getUserStatus(), "Y")) {
				
				if (!StringUtil.isEmpty(user.getUserImageName())) {
					StringBuilder srcFile = new StringBuilder();
					srcFile.append(PROFILE_IMG_DIR).append(FileUtil.getFileSeparator()).append(user.getUserImageName());
					FileUtil.deleteFile(srcFile.toString());
				}
				
				user.setUserImageName(fileData.getFileName());
				user.setUserImageOrgName(fileData.getFileOrgName());
				user.setUserImageSize(fileData.getFileSize());
				user.setUserImageExt(fileData.getFileExt());
				
				if (userService.userImageUpdate(user)) {
					ajaxResponse.setResponse(200, "사진 업데이트 완료");
					
				} else {
					ajaxResponse.setResponse(500, "DB 정합성 오류");
				}
				
			} else {
				CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
				ajaxResponse.setResponse(404, "존재하지 않는 사용자");
			}
			
		} else {
			ajaxResponse.setResponse(400, "비정상적인 접근");
		}
		
		return ajaxResponse;
	}
}