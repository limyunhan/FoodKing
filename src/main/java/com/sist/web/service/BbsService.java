package com.sist.web.service;

import java.util.HashMap;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sist.common.util.FileUtil;
import com.sist.common.util.StringUtil;
import com.sist.web.dao.BbsDao;
import com.sist.web.model.Bbs;
import com.sist.web.model.BbsFile;
import com.sist.web.model.BbsImage;
import com.sist.web.model.BbsSearch;

@Service
public class BbsService {
	public static Logger logger = LoggerFactory.getLogger(BbsService.class);
	
	@Autowired
	private BbsDao bbsDao;
	
	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
	
	@Value("#{env['upload.img.dir']}")
	private String UPLOAD_IMG_DIR;
	
	// 게시글 리스트
	public List<Bbs> bbsList(BbsSearch bbsSearch) {
		List<Bbs> list = null;
		
		try {
			list = bbsDao.bbsList(bbsSearch);
			
		} catch (Exception e) {
			logger.error("[BbsService] bbsList Exception", e);
		}
		
		return list;
	}
	
	public long bbsListCnt(BbsSearch bbsSearch) {
		long cnt = 0;
		
		try {
			cnt = bbsDao.bbsListCnt(bbsSearch);
			
		} catch (Exception e) {
			logger.error("[BbsService] bbsListCnt Exception", e);
		}
		
		
		return cnt;
	}
	
	public Bbs bbsSelect(HashMap<String, Object> hashMap) {
		Bbs bbs = null;
		
		try {
			bbs = bbsDao.bbsSelect(hashMap);
			
		} catch (Exception e) {
	        logger.error("[BbsService] bbsSelect Exception", e);
		}
		
		return bbs;
	}
	
	public List<BbsFile> bbsFileList(long bbsSeq) {
		List<BbsFile> list = null;
		
		try {
			list = bbsDao.bbsFileList(bbsSeq);
			
		} catch (Exception e) {
			logger.error("[BbsService] bbsFileList Exception", e);
		}
		
		return list;
	}
	
	public BbsFile bbsFileSelect(HashMap<String, Object> hashMap) {
		BbsFile bbsFile = null;
		
		try {
			bbsFile = bbsDao.bbsFileSelect(hashMap);
			
		} catch (Exception e) {
			logger.error("[BbsService] bbsFileSelect Exception", e);
		}
		
		return bbsFile;
	}
	
	public List<BbsImage> bbsImageList(long bbsSeq) {
		List<BbsImage> list = null;
		
		try {
			list = bbsDao.bbsImageList(bbsSeq);
			
		} catch (Exception e) {
			logger.error("[BbsService] bbsImageList Exception", e);
		}
		
		return list;
	}
	
	public BbsImage bbsImageSelect(HashMap<String, Object> hashMap) {
		BbsImage bbsImage = null;
		
		try {
			bbsImage = bbsDao.bbsImageSelect(hashMap);
			
		} catch (Exception e) {
			logger.error("[BbsService] bbsImageSelect Exception", e);
		}
		
		return bbsImage;
	}
	
	
	public Bbs bbsView(HashMap<String, Object> hashMap) {
		Bbs bbs = null;
		
		try {
			bbs = bbsDao.bbsSelect(hashMap);
			
			if (bbs != null) {
				List<BbsFile> bbsFileList = bbsDao.bbsFileList((long)hashMap.get("bbsSeq"));
				
				if (bbsFileList != null && bbsFileList.size() > 0) {
					bbs.setBbsFileList(bbsFileList);
				}
				
				List<BbsImage> bbsImageList = bbsDao.bbsImageList((long)hashMap.get("bbsSeq"));
				
				if (bbsImageList != null && bbsImageList.size() > 0) {
					bbs.setBbsImageList(bbsImageList);
				}
			}
			
		} catch (Exception e) {
			logger.error("[BbsService] bbsView Exception", e);
		}
		
		return bbs;
	}
	
	public boolean bbsReadCntPlus(long bbsSeq) {
		int cnt = 0;
		
		try {
			cnt = bbsDao.bbsReadCntPlus(bbsSeq);
			
		} catch (Exception e) {
			logger.error("[BbsService] bbsReadCntPlus Exception", e);
		}
		
		return (cnt == 1);
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public boolean bbsInsert(Bbs bbs) throws Exception {
		int cnt = 0;
		
		cnt = bbsDao.bbsInsert(bbs);
		
		if (cnt == 1) {
			if (bbs.getBbsFileList() != null) {
				List<BbsFile> bbsFileList = bbs.getBbsFileList();
				
				for (BbsFile bbsFile : bbsFileList) {
					bbsFile.setBbsSeq(bbs.getBbsSeq());
					short bbsFileSeq = bbsDao.bbsFileSeq(bbs.getBbsSeq());
					bbsFile.setBbsFileSeq(bbsFileSeq);
					bbsDao.bbsFileInsert(bbsFile);
				}
			}
			
			if (bbs.getBbsImageList() != null) {
				List<BbsImage> bbsImageList = bbs.getBbsImageList();

				for (BbsImage bbsImage : bbsImageList) {
					bbsImage.setBbsSeq(bbs.getBbsSeq());
					short bbsImageSeq = bbsDao.bbsImageSeq(bbs.getBbsSeq());
					bbsImage.setBbsImageSeq(bbsImageSeq);
					bbsDao.bbsImageInsert(bbsImage);
				}
			}
		}
		
		return (cnt == 1);
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public boolean bbsUpdate(Bbs bbs) throws Exception {
		int cnt = 0;
		
		cnt = bbsDao.bbsUpdate(bbs);
		
		if (cnt == 1) {
			
			List<BbsFile> newFileList = bbs.getBbsFileList();
			if (newFileList != null && newFileList.size() > 0) {
				for (BbsFile newFile : newFileList) {
					newFile.setBbsSeq(bbs.getBbsSeq());
					short bbsFileSeq = bbsDao.bbsFileSeq(bbs.getBbsSeq());
					newFile.setBbsFileSeq(bbsFileSeq);
					bbsDao.bbsFileInsert(newFile);
				}
			}
			
		}
		
		return (cnt == 1);
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public boolean bbsDelete(HashMap<String, Object> hashMap) throws Exception {
		int cnt = 0;

		Bbs bbs = bbsView(hashMap);
		
		if (bbs != null && StringUtil.equals(bbs.getBbsStatus(), "Y")) {
			
			if (bbs.getBbsComCnt() > 0) {
				bbsDao.comDeleteByBbsDelete(bbs.getBbsSeq());
			}
			
			if (bbs.getBbsFileList() != null && bbs.getBbsFileList().size() > 0) {
				for (BbsFile bbsFile : bbs.getBbsFileList()) {
					StringBuilder srcFile = new StringBuilder();
					srcFile.append(UPLOAD_SAVE_DIR).append(FileUtil.getFileSeparator()).append(bbsFile.getBbsFileName());
					FileUtil.deleteFile(srcFile.toString());
				}
				
				bbsDao.bbsFileDeleteByBbsDelete(bbs.getBbsSeq());
			}
			
			if (bbs.getBbsImageList() != null && bbs.getBbsImageList().size() > 0) {
				for (BbsImage bbsImage : bbs.getBbsImageList()) {
					StringBuilder srcFile = new StringBuilder();
					srcFile.append(UPLOAD_IMG_DIR).append(FileUtil.getFileSeparator()).append(bbsImage.getBbsImageName());
					FileUtil.deleteFile(srcFile.toString());
				}
				
				bbsDao.bbsFileDeleteByBbsDelete(bbs.getBbsSeq());
			}
			
			cnt = bbsDao.bbsDelete(bbs.getBbsSeq());
		}
	
		return (cnt == 1);
	}
	
	public boolean recomInsert(HashMap<String, Object> hashMap) {
		int cnt = 0;
		
		try {
			cnt = bbsDao.recomInsert(hashMap);
			
		} catch (Exception e) {
			logger.error("[BbsService] recomInsert Exception", e);
		}
		
		return (cnt == 1);
	}
	
	public boolean recomDelete(HashMap<String, Object> hashMap) {
		int cnt = 0;
		
		try {
			cnt = bbsDao.recomDelete(hashMap);
			
		} catch (Exception e) {
			logger.error("[BbsService] recomDelete Exception", e);
		}
		
		return (cnt == 1);
	}
	
	public boolean bookmarkInsert(HashMap<String, Object> hashMap) {
		int cnt = 0;
		
		try {
			cnt = bbsDao.bookmarkInsert(hashMap);
		} catch (Exception e) {
			logger.error("[BbsService] bookmarkInsert Exception", e);
		}
		
		return (cnt == 1);
	}
	
	public boolean bookmarkDelete(HashMap<String, Object> hashMap) {
		int cnt = 0;
		
		try {
			cnt = bbsDao.bookmarkDelete(hashMap);
			
		} catch (Exception e) {
			logger.error("[BbsService] bookmarkDelete Exception", e);
		}
		
		return (cnt == 1);
	}
	
	public boolean isBookmarkable(HashMap<String, Object> hashMap) {
		int cnt = -1;
		
		try {
			cnt = bbsDao.isBookmarkable(hashMap);
			
		} catch (Exception e) {
			logger.error("[BbsService] isBookmarkable Exception", e);
		}
		
		return (cnt == 0);
	}
	
	public boolean isRecommendable(HashMap<String, Object> hashMap) {
		int cnt = -1;
		
		try {
			cnt = bbsDao.isRecommendable(hashMap);
			
		} catch (Exception e) {
			logger.error("[BbsService] isRecommendable Exception", e);
		}
		
		return (cnt == 0);
	}
	
	// 게시글 리스트
	public List<Bbs> bbsListForIndex(BbsSearch bbsSearch) {
		List<Bbs> list = null;
		
		try {
			list = bbsDao.bbsListForIndex(bbsSearch);
			
		} catch (Exception e) {
			logger.error("[BbsService] bbsListForIndex Exception", e);
		}
		
		return list;
	}
	
	public boolean bbsFileDelete(HashMap<String, Object> hashMap) {
		int cnt = 0;
		
		try {
			BbsFile bbsFile = bbsDao.bbsFileSelect(hashMap);
			cnt = bbsDao.bbsFileDelete(hashMap);
			
			if (cnt == 1) {
				StringBuilder srcFile = new StringBuilder();
				srcFile.append(UPLOAD_SAVE_DIR).append(FileUtil.getFileSeparator()).append(bbsFile.getBbsFileName());
				FileUtil.deleteFile(srcFile.toString());
			}
			
		} catch (Exception e) {
			logger.error("[BbsService] bbsFileDelete Exception", e);
		}
		
		return (cnt == 1);
	}
	
	public boolean bbsImageDelete(HashMap<String, Object> hashMap) {
		int cnt = 0;
		
		try {
			BbsImage bbsImage = bbsDao.bbsImageSelect(hashMap);
			cnt = bbsDao.bbsImageDelete(hashMap);
			
			if (cnt == 1) {
				StringBuilder srcFile = new StringBuilder();
				srcFile.append(UPLOAD_IMG_DIR).append(FileUtil.getFileSeparator()).append(bbsImage.getBbsImageName());
				FileUtil.deleteFile(srcFile.toString());
			}
			
		} catch (Exception e) {
			logger.error("[BbsService] bbsImageDelete Exception", e);
		}
		
		return (cnt == 1);
	}
}
