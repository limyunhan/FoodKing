package com.sist.web.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

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

import com.sist.common.model.FileData;
import com.sist.common.util.StringUtil;
import com.sist.web.model.Bbs;
import com.sist.web.model.BbsFile;
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

	    String userId = HttpUtil.get(request, "userId", ""); 
	    long bbsSeq = HttpUtil.get(request, "bbsSeq", -1L);
	    
	    if (!StringUtil.isEmpty(userId) && bbsSeq > 0) { 
	        HashMap<String, Object> hashMap = new HashMap<>();
	        hashMap.put("userId", userId);
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

	    String userId = HttpUtil.get(request, "userId", ""); 
	    long bbsSeq = HttpUtil.get(request, "bbsSeq", -1L);
	    
	    if (!StringUtil.isEmpty(userId) && bbsSeq > 0) { 
	        HashMap<String, Object> hashMap = new HashMap<>();
	        hashMap.put("userId", userId);
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

}