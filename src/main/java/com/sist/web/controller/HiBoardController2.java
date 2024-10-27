package com.sist.web.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.sist.common.model.FileData;
import com.sist.common.util.FileUtil;
import com.sist.common.util.StringUtil;
import com.sist.web.model.HiBoard2;
import com.sist.web.model.HiBoardFile2;
import com.sist.web.model.Paging;
import com.sist.web.model.Response;
import com.sist.web.model.User2;
import com.sist.web.service.HiBoardService2;
import com.sist.web.service.UserService2;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;

@Controller("hiBoardController2")
public class HiBoardController2 {
	public static Logger logger = LoggerFactory.getLogger(HiBoardController2.class);
	
	private static final int LIST_COUNT  = 20;
	private static final int PAGE_COUNT = 5;
	
	@Autowired
	private UserService2 userService;
	
	@Autowired
	private HiBoardService2 hiBoardService;
	
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
	
	@Value("#{env['upload.img.dir']}")
	private String UPLOAD_IMG_DIR;
	
	@RequestMapping(value = "/board/list2")
	public String list2(Model model, HttpServletRequest request, HttpServletResponse response) {
		
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", 1L);
		
		HiBoard2 search = new HiBoard2();
		if (!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) {
			search.setSearchType(searchType);
			search.setSearchValue(searchValue);
		}
		
		long totalCnt = hiBoardService.boardListCnt(search);
		List<HiBoard2> list = null;
		Paging paging = null;
		
		if (totalCnt > 0) {
			paging = new Paging("/board/list2", totalCnt, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
			search.setStartRow(paging.getStartRow());
			search.setEndRow(paging.getEndRow());
			list = hiBoardService.boardList(search);
		}
		
		model.addAttribute("list", list);
		model.addAttribute("paging", paging);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
			
		return "/board/list2";
	}
	
	@RequestMapping(value = "/board/writeForm2", method = RequestMethod.POST)
	public String writeForm2(Model model, HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		User2 user = userService.userSelect(cookieUserId);
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", 1L);
		
		model.addAttribute("user", user);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		
		return "/board/writeForm2";
	}
	
	@RequestMapping(value = "/board/writeProc2", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> writeProc2(MultipartHttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String hiBbsTitle = HttpUtil.get(request, "hiBbsTitle", "");
		String hiBbsContent = HttpUtil.get(request, "hiBbsContent", "");
		List<FileData> fileDataList = HttpUtil.getFiles(request, "hiBbsFile", UPLOAD_SAVE_DIR);		
		
		if (!StringUtil.isEmpty(hiBbsTitle) && !StringUtil.isEmpty(hiBbsContent)) {
			HiBoard2 hiBoard = new HiBoard2();
			hiBoard.setUserId(cookieUserId);
			hiBoard.setHiBbsTitle(hiBbsTitle);
			hiBoard.setHiBbsContent(hiBbsContent);
			
			if (fileDataList != null) {
				List<HiBoardFile2> hiBoardFileList = new ArrayList<>();
				
				for (FileData fileData : fileDataList) {
					if (fileData.getFileSize() > 0) {
						HiBoardFile2 hiBoardFile = new HiBoardFile2();
						hiBoardFile.setFileExt(fileData.getFileExt());
						hiBoardFile.setFileName(fileData.getFileName());
						hiBoardFile.setFileOrgName(fileData.getFileOrgName());
						hiBoardFile.setFileSize(fileData.getFileSize());
						hiBoardFileList.add(hiBoardFile);
					}
				}
				
				if (fileDataList.size() > 0) {
					hiBoard.setHiBoardFileList(hiBoardFileList);
				}
			}
			
			try {
				
				if (hiBoardService.boardInsert(hiBoard)) {
					ajaxResponse.setResponse(200, "게시글 작성 성공");
				} else {
					ajaxResponse.setResponse(500, "DB 정합성 오류");
				}
				
			} catch (Exception e) {
				logger.error("[HiBoardController2] writeProc2 Exception", e);
				ajaxResponse.setResponse(500, "DB 정합성 오류(롤백)");
			}
			
		} else {
			ajaxResponse.setResponse(400, "비정상적인 접근");
		}

		return ajaxResponse;
	}
	
	@RequestMapping(value = "/board/view2")
	public String view2(Model model, HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long hiBbsSeq = HttpUtil.get(request, "hiBbsSeq", -1L);
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", 1L);
		
		String myBoard = "N";
		String isCommentRefresh = HttpUtil.get(request, "isCommentRefresh", "false");
		HiBoard2 hiBoard = null;
		
		if (hiBbsSeq > 0) {
			hiBoard = hiBoardService.boardView(hiBbsSeq);
			
			if (hiBoard != null) {
				if (StringUtil.equals(isCommentRefresh, "false")) {
					hiBoardService.boardReadCntPlus(hiBbsSeq);
					hiBoard.setHiBbsReadCnt(hiBoard.getHiBbsReadCnt() + 1);
				}

				if (StringUtil.equals(hiBoard.getUserId(), cookieUserId)) {
					myBoard = "Y";
				}
			}
		}
		
		model.addAttribute("myBoard", myBoard);
		model.addAttribute("hiBbsSeq", hiBbsSeq);
		model.addAttribute("hiBoard", hiBoard);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		
		return "/board/view2";
	}
	
	@RequestMapping(value = "/board/replyForm2")
	public String replyForm2(Model model, HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long hiBbsSeq = HttpUtil.get(request, "hiBbsSeq", -1L);
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", 1L);
		
		HiBoard2 hiBoard = null;
		User2 user = null;
		
		if (hiBbsSeq > 0) {
			hiBoard = hiBoardService.boardSelect(hiBbsSeq);
			
			if (hiBoard != null) {
				user = userService.userSelect(cookieUserId);
			}
		}
		
		model.addAttribute("hiBbsSeq", hiBbsSeq);
		model.addAttribute("user", user);
		model.addAttribute("hiBoard", hiBoard);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		
		return "/board/replyForm2";
	}
	
	@RequestMapping(value = "/board/replyProc2", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> replyProc2(MultipartHttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long hiBbsSeq = HttpUtil.get(request, "hiBbsSeq", -1L);
		String hiBbsTitle = HttpUtil.get(request, "hiBbsTitle", "");
		String hiBbsContent = HttpUtil.get(request, "hiBbsContent", "");
		List<FileData> fileDataList = HttpUtil.getFiles(request, "hiBbsFile", UPLOAD_SAVE_DIR);
				
		if (hiBbsSeq > 0 && !StringUtil.isEmpty(hiBbsTitle) && !StringUtil.isEmpty(hiBbsContent)) {
			HiBoard2 parentHiBoard = hiBoardService.boardSelect(hiBbsSeq);
			
			if (parentHiBoard != null) {
				HiBoard2 childHiBoard = new HiBoard2(); 
				childHiBoard.setUserId(cookieUserId);
				childHiBoard.setHiBbsTitle(hiBbsTitle);
				childHiBoard.setHiBbsContent(hiBbsContent);
				childHiBoard.setHiBbsGroup(parentHiBoard.getHiBbsGroup());
				childHiBoard.setHiBbsOrder(parentHiBoard.getHiBbsOrder() + 1);
				childHiBoard.setHiBbsIndent(parentHiBoard.getHiBbsIndent() + 1);
				childHiBoard.setHiBbsParent(hiBbsSeq);
				
				if (fileDataList != null && fileDataList.size() > 0) {
					List<HiBoardFile2> hiBoardFileList = new ArrayList<>();
					
					for (FileData fileData : fileDataList) {
						
						if (fileData.getFileSize() > 0) {
							HiBoardFile2 hiBoardFile = new HiBoardFile2();
							hiBoardFile.setFileName(fileData.getFileName());
							hiBoardFile.setFileOrgName(fileData.getFileOrgName());
							hiBoardFile.setFileExt(fileData.getFileExt());
							hiBoardFile.setFileSize(fileData.getFileSize());
							hiBoardFileList.add(hiBoardFile);
						}
					}
					if (hiBoardFileList.size() > 0) {
						childHiBoard.setHiBoardFileList(hiBoardFileList);
					}
				}
				
				try {
					if (hiBoardService.boardReplyInsert(childHiBoard)) {
						ajaxResponse.setResponse(200, "자식 게시글 삽입 성공");
					} else {
						ajaxResponse.setResponse(500, "DB 정합성 오류");
					}
					
				} catch(Exception e) {
					logger.error("[HiBoardController2 replyProc Exception", e);
					ajaxResponse.setResponse(500, "DB 정합성 오류");
				}
				
			} else {
				ajaxResponse.setResponse(404, "부모 게시글 존재하지 않음");
			}
			
		} else {
			ajaxResponse.setResponse(400, "비정상적인 접근");
		}
				
		return ajaxResponse;
	}
	
	@RequestMapping(value = "/board/delete2", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> delete2(HttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long hiBbsSeq = HttpUtil.get(request, "hiBbsSeq", -1L);
		
		if (hiBbsSeq > 0) {
			HiBoard2 hiBoard = hiBoardService.boardSelect(hiBbsSeq);
			
			if (hiBoard != null) {
				if (StringUtil.equals(hiBoard.getUserId(), cookieUserId)) {
					if (hiBoardService.isBoardDeletable(hiBbsSeq)) {
						try {
							if (hiBoardService.boardDelete(hiBbsSeq)) {
								ajaxResponse.setResponse(200, "게시글 삭제 완료");
							} else {
								ajaxResponse.setResponse(500, "DB 정합성 오류");
							}
						} catch (Exception e) {
							logger.error("[HiBoardController2] delete2 Exception", e);
							ajaxResponse.setResponse(500, "DB 정합성 오류");
						}
					} else {
						ajaxResponse.setResponse(402, "답변 게시물 존재함");
					}
				} else {
					ajaxResponse.setResponse(403, "아이디 일치하지 않음");
				}
			} else {
				ajaxResponse.setResponse(404, "게시글이 존재하지 않음");
			}
			
		} else {
			ajaxResponse.setResponse(400, "비정상적인 접근");
		}
		
		return ajaxResponse;
	}
	
	@RequestMapping(value = "/board/updateForm2")
	public String updateForm2(Model model, HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long hiBbsSeq = HttpUtil.get(request, "hiBbsSeq", -1L);
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", 1L);
		
		HiBoard2 hiBoard = null;
		if (hiBbsSeq > 0) {
			hiBoard = hiBoardService.boardView(hiBbsSeq);
			
			if (hiBoard != null && !StringUtil.equals(hiBoard.getUserId(), cookieUserId)) {
				hiBoard = null;
			}
		}
		
		model.addAttribute("hiBoard", hiBoard);
		model.addAttribute("hiBbsSeq", hiBbsSeq);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		
		return "/board/updateForm2";
	}
	
	@RequestMapping(value = "/board/updateProc2", method = RequestMethod.POST)
	public Response<Object> updateProc2(MultipartHttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long hiBbsSeq = HttpUtil.get(request, "hiBbsSeq", -1L);
		String hiBbsTitle = HttpUtil.get(request, "hiBbsTitle", "");
		String hiBbsContent = HttpUtil.get(request, "hiBbsContent", "");
		List<FileData> fileDataList = HttpUtil.getFiles(request, "hiBbsFile", UPLOAD_SAVE_DIR);
		
		
		if (hiBbsSeq > 0 && !StringUtil.isEmpty(hiBbsTitle) && !StringUtil.isEmpty(hiBbsContent)) {
			HiBoard2 hiBoard = hiBoardService.boardSelect(hiBbsSeq);
			if (hiBoard != null) {
				if (StringUtil.equals(cookieUserId, hiBoard.getUserId())) {
					hiBoard.setHiBbsTitle(hiBbsTitle);
					hiBoard.setHiBbsContent(hiBbsContent);
					
					if (fileDataList != null && fileDataList.size() > 0) {
						List<HiBoardFile2> hiBoardFileList = new ArrayList<>();
						
						for (FileData fileData : fileDataList) {
							if (fileData.getFileSize() > 0) {
								HiBoardFile2 hiBoardFile = new HiBoardFile2();
								hiBoardFile.setFileName(fileData.getFileName());
								hiBoardFile.setFileOrgName(fileData.getFileOrgName());
								hiBoardFile.setFileExt(fileData.getFileExt());
								hiBoardFile.setFileSize(fileData.getFileSize());
								hiBoardFileList.add(hiBoardFile);
							}
						}
						
						if (fileDataList.size() > 0) {
							hiBoard.setHiBoardFileList(hiBoardFileList);
						}
					}
					
					try {
						if (hiBoardService.boardUpdate(hiBoard)) {
							ajaxResponse.setResponse(200, "게시글 수정 성공");
						} else {
							ajaxResponse.setResponse(500, "DB 정합성 오류");
						}
						
					} catch (Exception e) {
						logger.error("[HiBoardController2] updateProc2 Exception", e);
						ajaxResponse.setResponse(500, "DB 정합성 오류");
					}
					
				} else {
					ajaxResponse.setResponse(403, "아이디 일치하지 않음");
				}
			} else {
				ajaxResponse.setResponse(404, "게시글 존재하지 않음");
			}
		} else {
			ajaxResponse.setResponse(400, "비정상적인 접근");
		}
		
		return ajaxResponse;
	}
	
	@RequestMapping(value = "/board/download2")
	public ModelAndView download2(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView modelAndView = null;
		
		long hiBbsSeq = HttpUtil.get(request, "hiBbsSeq", -1L);
		short fileSeq = (short) HttpUtil.get(request, "fileSeq", -1);
		
		if (hiBbsSeq > 0) {
			
			if (fileSeq > 0) {
				HashMap<String, Object> map = new HashMap<>();
				map.put("hiBbsSeq", hiBbsSeq);
				map.put("fileSeq", fileSeq);
				logger.debug("fileSeq : " + fileSeq);
				HiBoardFile2 hiBoardFile = hiBoardService.boardFileSelect(map);
				
				if (hiBoardFile != null && hiBoardFile.getFileSize() > 0) {
					File file = new File(UPLOAD_SAVE_DIR + FileUtil.getFileSeparator() + hiBoardFile.getFileName());
					
					if (FileUtil.isFile(file)) {
						modelAndView = new ModelAndView();
						modelAndView.setViewName("fileDownloadView");
						modelAndView.addObject("file", file);
						modelAndView.addObject("fileName", hiBoardFile.getFileOrgName());
						
					}
				}
			
			} else {
				List<HiBoardFile2> hiBoardFileList = hiBoardService.boardFileList(hiBbsSeq);
				if (hiBoardFileList != null && hiBoardFileList.size() > 0) {
					
					Map<String, File> fileMap = new HashMap<>();
				
					for (HiBoardFile2 hiBoardFile : hiBoardFileList) {
						if (hiBoardFile != null && hiBoardFile.getFileSize() > 0) {
							File file = new File(UPLOAD_SAVE_DIR + FileUtil.getFileSeparator() + hiBoardFile.getFileName());
							
							if (FileUtil.isFile(file)) {
								fileMap.put(hiBoardFile.getFileOrgName(), file);
							}
						}
					}
					
					if (!fileMap.isEmpty()) {
						modelAndView = new ModelAndView();
						modelAndView.setViewName("zipFileDownloadView");
						modelAndView.addObject("zipFileName", ""); // 적당한 zipFileName 설정, default는 download.zip
						modelAndView.addObject("fileMap", fileMap);
					}
				}
			}
		}
		
		return modelAndView;
	}
	

	@RequestMapping(value = "/board/image2", method = RequestMethod.POST)
	public ResponseEntity<Map<String, String>> image(MultipartHttpServletRequest request) {
		Map<String , String> result = new HashMap<>();
		
		try {
			FileData fileData = HttpUtil.getFile(request, "image", UPLOAD_IMG_DIR);
			
			if (fileData != null && fileData.getFileSize() > 0) {
				String imageUrl = fileData.getFilePath();
		        HttpSession session = request.getSession();
		        
		        @SuppressWarnings("unchecked")
				List<String> tempImageList = (List<String>) session.getAttribute("tempImageList");
		        
		        if (tempImageList == null) {
		        	tempImageList = new ArrayList<>();
		        	session.setAttribute("tempImageList", tempImageList);
		        }
		        
		        tempImageList.add(imageUrl);
		        result.put("imageUrl", imageUrl);
		        return ResponseEntity.ok(result);
		        
			} else {
				return ResponseEntity.badRequest().body(null);
			}
		
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
		}
	}
}