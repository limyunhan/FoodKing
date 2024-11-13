package com.sist.web.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

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
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.JsonObject;
import com.sist.common.model.FileData;
import com.sist.common.util.FileUtil;
import com.sist.common.util.StringUtil;
import com.sist.web.model.Bbs;
import com.sist.web.model.BbsFile;
import com.sist.web.model.BbsImage;
import com.sist.web.model.BbsSearch;
import com.sist.web.model.Com;
import com.sist.web.model.ComSearch;
import com.sist.web.model.Paging;
import com.sist.web.model.Response;
import com.sist.web.model.User;
import com.sist.web.service.BbsService;
import com.sist.web.service.ComService;
import com.sist.web.service.UserService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;

@Controller
public class BbsController {
	public static Logger logger = LoggerFactory.getLogger(BbsController.class);
	
	private static final int COM_PAGE_COUNT = 5;
	private static final int COM_LIST_COUNT = 10;
	private static final int BBS_PAGE_COUNT = 5;
	
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
	
	@Value("#{env['upload.img.temp.dir']}")
	private String UPLOAD_IMG_TEMP_DIR;
	
	@Value("#{env['upload.img.dir']}")
	private String UPLOAD_IMG_DIR;
	
	@Autowired
	private BbsService bbsService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private ComService comService;
	
	// 게시글 리스트 페이지
	@RequestMapping(value = "/bbs/list")
	public String list(Model model, HttpServletRequest request) {
		int bbsListCount = HttpUtil.get(request, "bbsListCount", 10);
		long bbsCurPage = HttpUtil.get(request, "bbsCurPage", 1L);
		
		String cateNum = HttpUtil.get(request, "cateNum", "");
		
		String cateFilter = HttpUtil.get(request, "cateFilter", "");
		String periodFilter = HttpUtil.get(request, "periodFilter", "");
		
		String bbsOrderBy = HttpUtil.get(request, "bbsOrderBy", "1");
		String isSecret = HttpUtil.get(request, "isSecret", "");
		
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		
		BbsSearch bbsSearch = new BbsSearch();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		bbsSearch.setUserId(cookieUserId);
		
		bbsSearch.setperiodFilter(periodFilter);
		bbsSearch.setCateFilter(cateFilter);
		
		if (!StringUtil.isEmpty(cateNum) && StringUtil.isEmpty(cateFilter)) {
			bbsSearch.setCateFilter(cateNum);
		}
		
		bbsSearch.setBbsOrderBy(bbsOrderBy);
		bbsSearch.setIsSecret(isSecret);
		bbsSearch.setSearchType(searchType);
		bbsSearch.setSearchValue(searchValue);
		
		long totalCnt = bbsService.bbsListCnt(bbsSearch);
		List<Bbs> bbsList = null;
		Paging bbsPaging = null;
		
		if (totalCnt > 0) {
			bbsPaging = new Paging("/bbs/list", totalCnt, bbsListCount, BBS_PAGE_COUNT, bbsCurPage, "bbsCurPage");
			bbsSearch.setStartRow(bbsPaging.getStartRow());
			bbsSearch.setEndRow(bbsPaging.getEndRow());
			bbsList = bbsService.bbsList(bbsSearch);
		}
		
		model.addAttribute("bbsListCount", bbsListCount);
		model.addAttribute("bbsCurPage", bbsCurPage);
		
		model.addAttribute("cateNum", cateNum);
		model.addAttribute("cateFilter", cateFilter);
		model.addAttribute("periodFilter", periodFilter);
		model.addAttribute("bbsOrderBy", bbsOrderBy);
		model.addAttribute("isSecret", isSecret);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		
		model.addAttribute("bbsList", bbsList);
		model.addAttribute("bbsPaging", bbsPaging);

		return "/bbs/list";
	}
	
	// 게시글 보기 페이지
	@RequestMapping(value = "/bbs/view")
	public String view(Model model, HttpServletRequest request) {
		int bbsListCount = HttpUtil.get(request, "bbsListCount", 10);
		long bbsCurPage = HttpUtil.get(request, "bbsCurPage", 1L);
		long comCurPage = HttpUtil.get(request, "comCurPage", 1L);
		long bbsSeq = HttpUtil.get(request, "bbsSeq", -1L);
		
		String cateNum = HttpUtil.get(request, "cateNum", "");
		String cateFilter = HttpUtil.get(request, "cateFilter", "");
		String periodFilter = HttpUtil.get(request, "periodFilter", "");
		String bbsOrderBy = HttpUtil.get(request, "bbsOrderBy", "1");
		String comOrderBy = HttpUtil.get(request, "comOrderBy", "1");
		String isSecret = HttpUtil.get(request, "isSecret", "");
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		Bbs bbs = null;
		List<Com> comList = null;
		Paging comPaging = null;
		
		if (bbsSeq > 0) {
			HashMap<String, Object> hashMap = new HashMap<>();
			hashMap.put("userId", cookieUserId);
			hashMap.put("bbsSeq", bbsSeq);
			
			bbs = bbsService.bbsView(hashMap);
			if (bbs != null && StringUtil.equals(bbs.getBbsStatus(), "Y")) {
				
				bbsService.bbsReadCntPlus(bbsSeq);
				bbs.setBbsReadCnt(bbs.getBbsReadCnt() + 1);

				ComSearch comSearch = new ComSearch();
				comSearch.setBbsSeq(bbsSeq);
				comSearch.setComOrderBy(comOrderBy);
				
				long totalCnt = comService.comListCnt(comSearch);
				
				if (totalCnt > 0) {
					comPaging = new Paging("/bbs/view", totalCnt, COM_LIST_COUNT, COM_PAGE_COUNT, comCurPage, "comCurPage");
					comSearch.setStartRow(comPaging.getStartRow());
					comSearch.setEndRow(comPaging.getEndRow());
					comList = comService.comList(comSearch);
				}
			}
		}
		
		model.addAttribute("bbs", bbs);
		model.addAttribute("comList", comList);
		model.addAttribute("bbsSeq", bbsSeq);
		model.addAttribute("bbsListCount", bbsListCount);
		model.addAttribute("bbsCurPage", bbsCurPage);
		model.addAttribute("bbsOrderBy", bbsOrderBy);
		
		model.addAttribute("cateNum", cateNum);
		model.addAttribute("cateFilter", cateFilter);
		model.addAttribute("periodFilter", periodFilter);
		
		model.addAttribute("isSecret", isSecret);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		
		model.addAttribute("comPaging", comPaging);
	    model.addAttribute("comCurPage", comCurPage);
		model.addAttribute("comOrderBy", comOrderBy);
		
		return "/bbs/view";
	}
	
	// 게시글 쓰기 페이지
	@RequestMapping(value = "/bbs/write")
	public String write(Model model, HttpServletRequest request) {
		int bbsListCount = HttpUtil.get(request, "bbsListCount", 10);
		long bbsCurPage = HttpUtil.get(request, "bbsCurPage", 1L);
		
		String cateNum = HttpUtil.get(request, "cateNum", "");
		String cateFilter = HttpUtil.get(request, "cateFilter", "");
		String periodFilter = HttpUtil.get(request, "periodFilter", "");
		String bbsOrderBy = HttpUtil.get(request, "bbsOrderBy", "1");
		String isSecret = HttpUtil.get(request, "isSecret", "");
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");

		
		model.addAttribute("bbsListCount", bbsListCount);
		model.addAttribute("bbsCurPage", bbsCurPage);
		
		model.addAttribute("cateNum", cateNum);
		model.addAttribute("cateFilter", cateFilter);
		model.addAttribute("periodFilter", periodFilter);
		model.addAttribute("bbsOrderBy", bbsOrderBy);
		model.addAttribute("isSecret", isSecret);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		
		return "/bbs/write";
	}
	
	// 게시글 작성 ajax 통신
	@RequestMapping(value = "/bbs/writeProc", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> writeProc(MultipartHttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String subCateCombinedNum = HttpUtil.get(request, "subCateCombinedNum", "");
		String bbsTitle = HttpUtil.get(request, "bbsTitle", "");
		String bbsContent = HttpUtil.get(request, "bbsContent", "");
		String bbsPwd = HttpUtil.get(request, "bbsPwd", "");
		
		if (!StringUtil.isEmpty(subCateCombinedNum) && !StringUtil.isEmpty(bbsTitle) && !StringUtil.isEmpty(bbsContent)) {
			User user = userService.userSelect(cookieUserId);
			if (((!subCateCombinedNum.startsWith("0101") && !subCateCombinedNum.startsWith("05")) || StringUtil.equals(user.getUserType(), "ADMIN")) && (!subCateCombinedNum.startsWith("0102") || !StringUtil.equals(user.getUserType(), "USER"))) {
				Bbs bbs = new Bbs();
				bbs.setUserId(cookieUserId);
				bbs.setSubCateCombinedNum(subCateCombinedNum);
				bbs.setBbsTitle(bbsTitle);
				bbs.setBbsContent(bbsContent);
				
				List<FileData> ImageDataList = moveTempImage(bbsContent, UPLOAD_IMG_TEMP_DIR, UPLOAD_IMG_DIR);
				
				if (ImageDataList != null) {
					bbs.setBbsContent(bbsContent.replace("/resources/bbs/temp/", "/resources/bbs/images/"));
					List<BbsImage> bbsImageList = new ArrayList<>();
					
					for (FileData ImageData : ImageDataList) {
						if (ImageData.getFileSize() > 0) {
							BbsImage bbsImage = new BbsImage();
							bbsImage.setBbsImageExt(ImageData.getFileExt());
							bbsImage.setBbsImageName(ImageData.getFileName());
							bbsImage.setBbsImageOrgName(ImageData.getFileOrgName());
							bbsImage.setBbsImageSize(ImageData.getFileSize());
							bbsImageList.add(bbsImage);
						}
						
					}
					
					if (ImageDataList.size() > 0) {
						bbs.setBbsImageList(bbsImageList);
					}
				}
				
				if (!StringUtil.isEmpty(bbsPwd)) {
					bbs.setBbsPwd(bbsPwd);
				}
				
				List<FileData> fileDataList = HttpUtil.getFiles(request, "bbsFile", UPLOAD_SAVE_DIR);
				
				if (fileDataList != null) {
					List<BbsFile> bbsFileList = new ArrayList<>();
					
					for (FileData fileData : fileDataList) {
						if (fileData.getFileSize() > 0) {
							BbsFile bbsFile = new BbsFile();
							bbsFile.setBbsFileExt(fileData.getFileExt());
							bbsFile.setBbsFileName(fileData.getFileName());
							bbsFile.setBbsFileOrgName(fileData.getFileOrgName());
							bbsFile.setBbsFileSize(fileData.getFileSize());
							bbsFileList.add(bbsFile);
						}
					}
					
					if (fileDataList.size() > 0) {
						bbs.setBbsFileList(bbsFileList);
					}

				}
							
				try {
					if (bbsService.bbsInsert(bbs)) {
						ajaxResponse.setResponse(200, "게시글 작성 성공");
						
					} else {
						ajaxResponse.setResponse(500, "DB 정합성 오류");
					}
					
				} catch (Exception e) {
					logger.error("[BbsController] writeProc Exception", e);
					ajaxResponse.setResponse(500, "DB 정합성 오류");
				}	    
					
			} else {
				ajaxResponse.setResponse(403, "접근권한이 없는 회원");
				
			}
		} else {
			ajaxResponse.setResponse(400, "비정상적인 접근");
			
		}

		return ajaxResponse;
	}
	
	// 게시글 추천
	@RequestMapping(value = "/bbs/recom", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> recom(HttpServletRequest request) {
	    Response<Object> ajaxResponse = new Response<>();

	    String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
	    long bbsSeq = HttpUtil.get(request, "bbsSeq", -1L);
	    
	    if (bbsSeq > 0) { 
	        HashMap<String, Object> hashMap = new HashMap<>();
	        hashMap.put("userId", cookieUserId);
	        hashMap.put("bbsSeq", bbsSeq);
	        
	        if (bbsService.isRecommendable(hashMap)) {
	        	// 추천을 하는 경우
	            if (bbsService.recomInsert(hashMap)) {
	                Bbs bbs = bbsService.bbsSelect(hashMap);
	                
	                if (bbs != null && StringUtil.equals(bbs.getBbsStatus(), "Y")) {
	                    int bbsReComCnt = bbs.getBbsRecomCnt();
	                    ajaxResponse.setResponse(201, "추천 성공", bbsReComCnt);
	                    
	                } else {
	                    ajaxResponse.setResponse(404, "게시글 삭제됨"); 
	                }
	                
	            } else {
	                ajaxResponse.setResponse(500, "추천 실패"); 
	            }
	            
	        } else {
	            // 추천을 취소하는 경우
	            if (bbsService.recomDelete(hashMap)) {
	                Bbs bbs = bbsService.bbsSelect(hashMap);
	                
	                if (bbs != null && StringUtil.equals(bbs.getBbsStatus(), "Y")) {
	                    int bbsRecomCnt = bbs.getBbsRecomCnt();
	                    ajaxResponse.setResponse(200, "추천 취소 성공", bbsRecomCnt);
	                    
	                } else {
	                    ajaxResponse.setResponse(404, "게시글 삭제됨");
	                }
	                
	            } else {
	                ajaxResponse.setResponse(500, "추천 취소 실패"); 
	            }
	            
	        }
	        
	    } else {
	        ajaxResponse.setResponse(400, "비정상적인 접근"); 
	    }
	    
	    return ajaxResponse;
	}
	
	
	// 게시글 북마크
	@RequestMapping(value = "/bbs/bookmark", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> bookmark(HttpServletRequest request) {
	    Response<Object> ajaxResponse = new Response<>();

	    String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
	    long bbsSeq = HttpUtil.get(request, "bbsSeq", -1L);
	    
	    if (bbsSeq > 0) { 
	        HashMap<String, Object> hashMap = new HashMap<>();
	        hashMap.put("userId", cookieUserId);
	        hashMap.put("bbsSeq", bbsSeq);
	        
	        if (bbsService.isBookmarkable(hashMap)) {
	        	if (bbsService.bookmarkInsert(hashMap)) {
	        		ajaxResponse.setResponse(200, "북마크 성공");
	        		
	        	} else {
	        		ajaxResponse.setResponse(500, "북마크 실패");
	        	}
	            
	        } else {
	        	if (bbsService.bookmarkDelete(hashMap)) {
		        	ajaxResponse.setResponse(201, "북마크 취소 성공");
		        	
	        	} else {
	        		ajaxResponse.setResponse(500, "북마크 취소 실패");
	        	}
	        }
	        
	    } else {
	        ajaxResponse.setResponse(400, "비정상적인 접근"); 
	    }
	    
	    return ajaxResponse;
	}
	
	@RequestMapping(value = "/bbs/update")
	public String update(Model model, HttpServletRequest request) {
		int bbsListCount = HttpUtil.get(request, "bbsListCount", 10);
		long bbsCurPage = HttpUtil.get(request, "bbsCurPage", 1L);
		long comCurPage = HttpUtil.get(request, "comCurPage", 1L);
		long bbsSeq = HttpUtil.get(request, "bbsSeq", -1L);
		
		String cateNum = HttpUtil.get(request, "cateNum", "");
		String cateFilter = HttpUtil.get(request, "cateFilter", "");
		String periodFilter = HttpUtil.get(request, "periodFilter", "");
		String bbsOrderBy = HttpUtil.get(request, "bbsOrderBy", "1");
		String comOrderBy = HttpUtil.get(request, "comOrderBy", "1");
		String isSecret = HttpUtil.get(request, "isSecret", "");
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		Bbs bbs = null;
		
		if (bbsSeq > 0) {
			HashMap<String, Object> hashMap = new HashMap<>();
			hashMap.put("userId", cookieUserId);
			hashMap.put("bbsSeq", bbsSeq);
			
			bbs = bbsService.bbsView(hashMap);
		}
		
		model.addAttribute("bbs", bbs);
		model.addAttribute("bbsSeq", bbsSeq);
		model.addAttribute("bbsListCount", bbsListCount);
		model.addAttribute("bbsCurPage", bbsCurPage);
		model.addAttribute("bbsOrderBy", bbsOrderBy);
		
		model.addAttribute("cateNum", cateNum);
		model.addAttribute("cateFilter", cateFilter);
		model.addAttribute("periodFilter", periodFilter);
		
		model.addAttribute("isSecret", isSecret);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);

	    model.addAttribute("comCurPage", comCurPage);
		model.addAttribute("comOrderBy", comOrderBy);
		
		return "/bbs/update";
	}
	
	@RequestMapping(value = "/bbs/updateProc", method = RequestMethod.POST)
	@ResponseBody	
	public Response<Object> updateProc(MultipartHttpServletRequest request) {
		Response<Object> ajaxResponse = new Response<>();
		
		long bbsSeq = HttpUtil.get(request, "bbsSeq", -1L);
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String subCateCombinedNum = HttpUtil.get(request, "subCateCombinedNum", "");
		String bbsTitle = HttpUtil.get(request, "bbsTitle", "");
		String bbsContent = HttpUtil.get(request, "bbsContent", "");
		String bbsPwd = HttpUtil.get(request, "bbsPwd", "");
		
		if (bbsSeq > 0 && !StringUtil.isEmpty(subCateCombinedNum) && !StringUtil.isEmpty(bbsTitle) && !StringUtil.isEmpty(bbsContent)) {
			HashMap<String, Object> hashMap = new HashMap<>();
			hashMap.put("userId", cookieUserId);
			hashMap.put("bbsSeq", bbsSeq);
			
			Bbs bbs = bbsService.bbsSelect(hashMap);
			
			if (bbs != null && StringUtil.equals(bbs.getBbsStatus(), "Y")) {
				
				User user = userService.userSelect(cookieUserId);
				
				if (!StringUtil.equals(cookieUserId, bbs.getUserId())) {
					
					if (user == null || StringUtil.equals(user.getUserStatus(), "Y") || !StringUtil.equals(user.getUserType(), "ADMIN")) {
						ajaxResponse.setResponse(403, "수정 권한이 없음");
						return ajaxResponse;
					}
				}
				
				if (((!subCateCombinedNum.startsWith("0101") && !subCateCombinedNum.startsWith("05")) || StringUtil.equals(user.getUserType(), "ADMIN")) && (!subCateCombinedNum.startsWith("0102") || !StringUtil.equals(user.getUserType(), "USER"))) {
					
					bbs.setSubCateCombinedNum(subCateCombinedNum);
					bbs.setBbsTitle(bbsTitle);
					bbs.setBbsContent(bbsContent);
					
					List<FileData> ImageDataList = moveTempImage(bbsContent, UPLOAD_IMG_TEMP_DIR, UPLOAD_IMG_DIR);
					
					if (ImageDataList != null) {
						bbs.setBbsContent(bbsContent.replace("/resources/bbs/temp/", "/resources/bbs/images/"));
						List<BbsImage> bbsImageList = new ArrayList<>();
						
						for (FileData ImageData : ImageDataList) {
							if (ImageData.getFileSize() > 0) {
								BbsImage bbsImage = new BbsImage();
								bbsImage.setBbsImageExt(ImageData.getFileExt());
								bbsImage.setBbsImageName(ImageData.getFileName());
								bbsImage.setBbsImageOrgName(ImageData.getFileOrgName());
								bbsImage.setBbsImageSize(ImageData.getFileSize());
								bbsImageList.add(bbsImage);
							}
							
						}
						
						if (ImageDataList.size() > 0) {
							bbs.setBbsImageList(bbsImageList);
						}
					}
					
					if (!StringUtil.isEmpty(bbsPwd)) {
						bbs.setBbsPwd(bbsPwd);
					}
					
					List<FileData> fileDataList = HttpUtil.getFiles(request, "bbsFile", UPLOAD_SAVE_DIR);
					
					if (fileDataList != null) {
						List<BbsFile> bbsFileList = new ArrayList<>();
						
						for (FileData fileData : fileDataList) {
							if (fileData.getFileSize() > 0) {
								BbsFile bbsFile = new BbsFile();
								bbsFile.setBbsFileExt(fileData.getFileExt());
								bbsFile.setBbsFileName(fileData.getFileName());
								bbsFile.setBbsFileOrgName(fileData.getFileOrgName());
								bbsFile.setBbsFileSize(fileData.getFileSize());
								bbsFileList.add(bbsFile);
							}
						}
						
						if (fileDataList.size() > 0) {
							bbs.setBbsFileList(bbsFileList);
						}

					}
					
					try {
						
						if (bbsService.bbsUpdate(bbs)) {
							ajaxResponse.setResponse(200, "게시글 수정 성공");
							
						} else {
							ajaxResponse.setResponse(500, "DB 정합성 오류");
						}
						
					} catch (Exception e) {
						logger.error("[BbsController] updateProc Exception", e);
						ajaxResponse.setResponse(500, "DB 정합성 오류");
					}	    
						
				} else {
					ajaxResponse.setResponse(403, "수정 권한이 없는 카테고리");
					
				}

			} else {
				ajaxResponse.setResponse(404, "게시글이 존재하지 않음");
			}
			
		} else {
			ajaxResponse.setResponse(400, "비정상적인 접근");
			
		}
		
		return ajaxResponse;
	}

	@RequestMapping(value = "/bbs/delete", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> delete(HttpServletRequest request) {
		Response<Object> ajaxResponse = new Response<>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long bbsSeq = HttpUtil.get(request, "bbsSeq", -1L);
		
		if (bbsSeq > 0) {
			HashMap<String, Object> hashMap = new HashMap<>();
			hashMap.put("userId", cookieUserId);
			hashMap.put("bbsSeq", bbsSeq);
			
			Bbs bbs = bbsService.bbsView(hashMap);
			
			if (bbs != null && StringUtil.equals(bbs.getBbsStatus(), "Y")) {
				
				if (!StringUtil.equals(cookieUserId, bbs.getUserId())) {
					User user = userService.userSelect(cookieUserId);
					
					if (user == null || StringUtil.equals(user.getUserStatus(), "Y") || !StringUtil.equals(user.getUserType(), "ADMIN")) {
						ajaxResponse.setResponse(403, "삭제 권한이 없음");
						return ajaxResponse;
					}
				}
					
				try {
					if (bbsService.bbsDelete(hashMap)) {
						ajaxResponse.setResponse(200, "게시글 삭제 성공");
						
					} else {
						ajaxResponse.setResponse(500, "DB정합성 오류");
					}
						
				} catch (Exception e) {
					ajaxResponse.setResponse(500, "DB정합성 오류");
				}
				
			} else {
				ajaxResponse.setResponse(404, "게시글 삭제됨");
			}
			
		} else {
			ajaxResponse.setResponse(400, "비정상적인 접근"); 
		}
		
		return ajaxResponse;
	}
	
	@RequestMapping(value = "/bbs/deleteFile", method = RequestMethod.POST) 
	@ResponseBody
	public Response<Object> deleteFile(HttpServletRequest request) {
		Response<Object> ajaxResponse = new Response<>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long bbsSeq = HttpUtil.get(request, "bbsSeq", -1L);
		short bbsFileSeq = (short) HttpUtil.get(request, "bbsFileSeq", -1);
		
		if (bbsSeq > 0 && bbsFileSeq > 0) {
			HashMap<String, Object> hashMap = new HashMap<>();
			hashMap.put("bbsSeq", bbsSeq);
			hashMap.put("bbsFileSeq", bbsFileSeq);
			hashMap.put("userId", cookieUserId);
			
			Bbs bbs = bbsService.bbsSelect(hashMap);
			
			if (bbs != null && StringUtil.equals(bbs.getBbsStatus(), "Y")) {
				if (!StringUtil.equals(cookieUserId, bbs.getUserId())) {
					User user = userService.userSelect(cookieUserId);
					
					if (user == null || StringUtil.equals(user.getUserStatus(), "Y") || !StringUtil.equals(user.getUserType(), "ADMIN")) {
						ajaxResponse.setResponse(401, "삭제 권한이 없음");
						return ajaxResponse;
					}
				}
				
				BbsFile bbsFile = bbsService.bbsFileSelect(hashMap);
				
				if (bbsFile != null && bbsFile.getBbsFileSize() > 0) {
					
					if (bbsService.bbsFileDelete(hashMap)) {
						ajaxResponse.setResponse(200, "파일 삭제 성공");
						
					} else {
						ajaxResponse.setResponse(500, "DB 정합성 오류");
					}
					
				} else {
					ajaxResponse.setResponse(404, "존재하지 않는 파일");
				}
				
			} else {
				ajaxResponse.setResponse(404, "존재하지 않는 게시글");
			}
			
		} else {
			ajaxResponse.setResponse(400, "비정상적인 접근");
		}
		
		return ajaxResponse;
	}
	
	@RequestMapping(value = "/bbs/download")
	public ModelAndView download(HttpServletRequest request) {
		ModelAndView modelAndView = null;
		
		long bbsSeq = HttpUtil.get(request, "bbsSeq", -1);
		short bbsFileSeq = (short) HttpUtil.get(request, "bbsFileSeq", -1);
		
		if (bbsSeq > 0) {
			// 개별 파일 다운로드
			if (bbsFileSeq > 0) {
				HashMap<String, Object> hashMap = new HashMap<>();
				hashMap.put("bbsSeq", bbsSeq);
				hashMap.put("bbsFileSeq", bbsFileSeq);
				
				BbsFile bbsFile = bbsService.bbsFileSelect(hashMap);
				
				if (bbsFile != null && bbsFile.getBbsFileSize() > 0) {
					File file = new File(UPLOAD_SAVE_DIR + FileUtil.getFileSeparator() + bbsFile.getBbsFileName());
				
					if (FileUtil.isFile(file)) {
						modelAndView = new ModelAndView();
						modelAndView.setViewName("fileDownloadView");
						modelAndView.addObject("file", file);
						modelAndView.addObject("fileName", bbsFile.getBbsFileOrgName());
					}
				
				}
				
			} else { // 파일 전체 다운로드
				List<BbsFile> bbsFileList = bbsService.bbsFileList(bbsSeq);
				
				Map<String, File> fileMap = new HashMap<>();
				
				for (BbsFile bbsFile : bbsFileList) {
					
					if (bbsFile != null && bbsFile.getBbsFileSize() > 0) {
						File file = new File(UPLOAD_SAVE_DIR + FileUtil.getFileSeparator() + bbsFile.getBbsFileName());
						
						if (FileUtil.isFile(file)) {
							fileMap.put(bbsFile.getBbsFileOrgName(), file);
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
		
		return modelAndView;
	}
	
	@RequestMapping(value = "/bbs/uploadImage", method = RequestMethod.POST)
	@ResponseBody
	public JsonObject uploadImage(MultipartHttpServletRequest request) {
		JsonObject jsonObject = new JsonObject();
		
		FileData fileData = HttpUtil.getFile(request, "file", UPLOAD_IMG_TEMP_DIR);
		StringBuilder srcFile = new StringBuilder();
		
		srcFile.append("/resources/bbs/temp/").append(fileData.getFileName());
		jsonObject.addProperty("url", srcFile.toString());
		jsonObject.addProperty("orgName", fileData.getFileOrgName());
	
		return jsonObject;
	}
	
	@RequestMapping(value = "/bbs/deleteImage", method = RequestMethod.POST) 
	@ResponseBody
	public Response<Object> deleteImage(HttpServletRequest request) {
		Response<Object> ajaxResponse = new Response<>();
		
        String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String delImageUrl = HttpUtil.get(request, "delImageUrl", "");
        long bbsSeq = HttpUtil.get(request, "bbsSeq", -1L);
        
		if (!StringUtil.isEmpty(delImageUrl)) {
	        if (delImageUrl.startsWith("/temp/")) {
	            String imageName = delImageUrl.substring("/temp/".length()); 
	            
	            StringBuilder srcFile = new StringBuilder();
	            srcFile.append(UPLOAD_IMG_TEMP_DIR).append(FileUtil.getFileSeparator()).append(imageName);
	            FileUtil.deleteFile(srcFile.toString());
	            
	            ajaxResponse.setResponse(200, "이미지 삭제 성공");
	         
	        } else if (delImageUrl.startsWith("/images/")) {
	            String imageName = delImageUrl.substring("/images/".length()); 

	            if (bbsSeq > 0) {
	    			HashMap<String, Object> hashMap = new HashMap<>();
	    			hashMap.put("bbsSeq", bbsSeq);
	    			hashMap.put("userId", cookieUserId);
	            	
	    			Bbs bbs = bbsService.bbsSelect(hashMap);
	    			
	    			if (bbs != null && StringUtil.equals(bbs.getBbsStatus(), "Y")) {
	    				if (!StringUtil.equals(cookieUserId, bbs.getUserId())) {
	    					User user = userService.userSelect(cookieUserId);
	    					
	    					if (user == null || StringUtil.equals(user.getUserStatus(), "Y") || !StringUtil.equals(user.getUserType(), "ADMIN")) {
	    						ajaxResponse.setResponse(401, "삭제 권한이 없음");
	    						return ajaxResponse;
	    					}
	    				}
	    				
	    				BbsImage bbsImage = bbsService.bbsImageSelect(imageName);
	    				String oldBbsContent = bbs.getBbsContent();
	    				String newBbsContent = oldBbsContent.replace("/resources/bbs" + delImageUrl, "");
	    				bbs.setBbsContent(newBbsContent);
	    				
	    				try {
							bbsService.bbsUpdate(bbs);
							
						} catch (Exception e) {
							ajaxResponse.setResponse(500, "DB 정합성 오류");
						}
	    				
	    				if (bbsImage != null && bbsImage.getBbsImageSize() > 0) {
	    					
	    					if (bbsService.bbsImageDelete(imageName)) {
	    						ajaxResponse.setResponse(200, "이미지 삭제 성공");
	    						
	    					} else {
	    						ajaxResponse.setResponse(500, "DB 정합성 오류");
	    					}
	    					
	    				} else {
	    					ajaxResponse.setResponse(404, "존재하지 않는 게시글 이미지");
	    				}
	    				
	    			} else {
	    				ajaxResponse.setResponse(404, "존재하지 않는 게시글");
	    			}
	            	
	            } else {
	            	ajaxResponse.setResponse(400, "비정상적인 접근");
	            }
	            
	        } else {
	            ajaxResponse.setResponse(400, "비정상적인 접근");
	        }
			
		} else {
			ajaxResponse.setResponse(400, "비정상적인 접근");
		}

		return ajaxResponse;
	}

	public static List<FileData> moveTempImage(String bbsContent, String tempDirectory, String actualDirectory) {
	    String imgTagPattern = "<img[^>]+src=\"/resources/bbs/temp/([^\"]+)\"[^>]*alt=\"([^\"]+)\"";
	    Pattern pattern = Pattern.compile(imgTagPattern);
	    Matcher matcher = pattern.matcher(bbsContent);

	    List<FileData> imageDataList = null;

	    if (matcher.find()) {
	        imageDataList = new ArrayList<>(); 

	        do {
	            String tempImageName = matcher.group(1);  
	            String originalImageName = matcher.group(2); 

	            File tempFile = new File(tempDirectory + FileUtil.getFileSeparator() + tempImageName);
	            File actualFile = new File(actualDirectory + FileUtil.getFileSeparator() + tempImageName);

	            if (tempFile.exists() && tempFile.renameTo(actualFile)) {
	                FileData imageData = new FileData();

	                imageData.setFileOrgName(originalImageName);  
	                imageData.setFileName(actualFile.getName()); 
	                imageData.setFileSize(actualFile.length());  
	                imageData.setFilePath(actualFile.getAbsolutePath());  

	                String strFileExt = FileUtil.getFileExtension(imageData.getFileOrgName());
	                if (!StringUtil.isEmpty(strFileExt)) {
	                    imageData.setFileExt(strFileExt);  // 파일 확장자
	                }

	                imageDataList.add(imageData);
	            }

	        } while (matcher.find());
	    }

	    return (imageDataList != null && !imageDataList.isEmpty()) ? imageDataList : null;
	}
}