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
import com.sist.web.dao.HiBoardDao2;
import com.sist.web.model.HiBoard2;
import com.sist.web.model.HiBoardFile2;

@Service("hiBoardService2")
public class HiBoardService2 {
	public static Logger logger = LoggerFactory.getLogger(HiBoardService2.class);
	
	@Autowired
	private HiBoardDao2 hiBoardDao;
	
	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
	
	// 게시글 작성
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public boolean boardInsert(HiBoard2 hiBoard) throws Exception {
		int cnt = 0;
		
		cnt = hiBoardDao.boardInsert(hiBoard);
		if (cnt == 1 && hiBoard.getHiBoardFileList() != null) {
			List<HiBoardFile2> hiBoardFileList = hiBoard.getHiBoardFileList();
			
			short i = 1;
			
			for (HiBoardFile2 hiBoardFile : hiBoardFileList) {
				hiBoardFile.setHiBbsSeq(hiBoard.getHiBbsSeq());
				hiBoardFile.setFileSeq(i++);
				hiBoardDao.boardFileInsert(hiBoardFile);
			}
		}
		
		return (cnt == 1);
	}
	
	// 게시글 리스트 조회
	public List<HiBoard2> boardList(HiBoard2 search) {
		List<HiBoard2> list = null;
		
		try {
			list = hiBoardDao.boardList(search);
		} catch (Exception e) {
			logger.error("[HiBoardService] boardList Exception", e);
		}
		
		return list;
	}
	
	// 페이징 처리를 위한 게시글 수 조회
	public long boardListCnt(HiBoard2 search) {
		long cnt = 0;
		
		try {
			cnt = hiBoardDao.boardListCnt(search);
		} catch (Exception e) {
			logger.error("[HiBoardService2] boardListCnt Exception", e);
		}
		
		return cnt;
	}
	
	// 게시글 보기 (첨부파일 포함)
	public HiBoard2 boardView(long hiBbsSeq) {
		HiBoard2 hiBoard = null;
		
		try {
			hiBoard = hiBoardDao.boardSelect(hiBbsSeq);
			
			if (hiBoard != null) {
				List<HiBoardFile2> hiBoardFileList = hiBoardDao.boardFileList(hiBbsSeq);
				
				if (hiBoardFileList != null && hiBoardFileList.size() > 0) {
					hiBoard.setHiBoardFileList(hiBoardFileList);
				}
			}
			
		} catch (Exception e) {
			logger.error("[HiBoardService2] boardView Exception", e);
		}
		
		return hiBoard;
	}
	
	// 단일 게시글 조회 (첨부파일 미포함)
	public HiBoard2 boardSelect(long hiBbsSeq) {
		HiBoard2 hiBoard = null;
		
		try {
			hiBoard = hiBoardDao.boardSelect(hiBbsSeq);
		} catch (Exception e) {
			logger.error("[HiBoardService2] boardSelect Exception", e);
		}
		
		return hiBoard;
	}
	
	// 게시글 조회수 증가
	public boolean boardReadCntPlus(long hiBbsSeq) {
		int cnt = 0;
		
		try {
			cnt = hiBoardDao.boardReadCntPlus(hiBbsSeq);
		} catch (Exception e) {
			logger.error("[HiBoardService2] boardReadCntPlus Exception", e);
		}
		
		return (cnt == 1);
	}
	
	// 답글 작성
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public boolean boardReplyInsert(HiBoard2 childHiBoard) throws Exception {
		int cnt = 0;
		
		if (childHiBoard.getHiBbsParent() == 0 ) {
			childHiBoard.setHiBbsOrder(hiBoardDao.boardGroupMaxOrder(childHiBoard.getHiBbsGroup()));
		} else {
			int replyCnt = hiBoardDao.boardReplyCnt(childHiBoard.getHiBbsParent());
			childHiBoard.setHiBbsOrder(childHiBoard.getHiBbsOrder() + replyCnt);
			hiBoardDao.boardGroupOrderUpdate(childHiBoard);
		}
		
		cnt = hiBoardDao.boardReplyInsert(childHiBoard);
		
		if (cnt == 1 && childHiBoard.getHiBoardFileList() != null) {
			List<HiBoardFile2> hiBoardFileList = childHiBoard.getHiBoardFileList();
			
			short i = 1;
			
			for (HiBoardFile2 hiBoardFile : hiBoardFileList) {
				hiBoardFile.setHiBbsSeq(childHiBoard.getHiBbsSeq());
				hiBoardFile.setFileSeq(i++);
				hiBoardDao.boardFileInsert(hiBoardFile);
			}
		}

		return (cnt == 1);
	}
	
	// 게시글 삭제 가능 여부 반환
	public boolean isBoardDeletable(long hiBbsSeq) {
		int cnt = 0;
		
		try {
			cnt = hiBoardDao.isBoardDeletable(hiBbsSeq);
		} catch (Exception e) {
			logger.error("[HiBoardService2] isBoardDeletable Exception", e);
		}
		
		return (cnt == 0);
	}
	
	// 게시글 삭제
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public boolean boardDelete(long hiBbsSeq) throws Exception {
		int cnt = 0;
		
		HiBoard2 hiBoard = boardView(hiBbsSeq);
		
		if (hiBoard != null) {
			if (hiBoard.getHiBoardFileList() != null) {
				if (hiBoardDao.boardFileDelete(hiBbsSeq) > 0) {
					for (HiBoardFile2 hiBoardFile : hiBoard.getHiBoardFileList()) {
						StringBuilder srcFile = new StringBuilder();
						srcFile.append(UPLOAD_SAVE_DIR)
						       .append(FileUtil.getFileSeparator())
						       .append(hiBoardFile.getFileName());
						FileUtil.deleteFile(srcFile.toString());
					}
				}
			}
			
			cnt = hiBoardDao.boardDelete(hiBbsSeq);
		}
				
		return (cnt == 1);
	}
	
	// 게시글 수정하기
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public boolean boardUpdate(HiBoard2 hiBoard) throws Exception {
		int cnt = 0;
		
		cnt = hiBoardDao.boardUpdate(hiBoard);
		
		if (cnt > 0 && hiBoard.getHiBoardFileList() != null) {
			
			List<HiBoardFile2> hiBoardFileList = hiBoardDao.boardFileList(hiBoard.getHiBbsSeq());
			if (hiBoardFileList != null && hiBoardFileList.size() > 0) {
				
				// 기존 파일들 삭제
				for (HiBoardFile2 hiBoardFile : hiBoardFileList) {
					StringBuilder srcFile = new StringBuilder();
					srcFile.append(UPLOAD_SAVE_DIR)
				       .append(FileUtil.getFileSeparator())
				       .append(hiBoardFile.getFileName());
					FileUtil.deleteFile(srcFile.toString());
				}
				
				// 업로드된 파일 리스트 가져옴
				hiBoardFileList = hiBoard.getHiBoardFileList();
				short i = 1;
				
				for (HiBoardFile2 hiBoardFile : hiBoardFileList) {
					hiBoardFile.setHiBbsSeq(hiBoard.getHiBbsSeq());
					hiBoardFile.setFileSeq(i++);
					hiBoardDao.boardFileInsert(hiBoardFile);
				}
			}
		}
		
		return (cnt == 1);
	}
	
	// 특정 게시글의 첨부파일 리스트 조회
	public List<HiBoardFile2> boardFileList(long hiBbsSeq) {
		List<HiBoardFile2> list = null;
		
		try {
			list = hiBoardDao.boardFileList(hiBbsSeq);
		} catch (Exception e) {
			logger.error("[HiBoardService2] boardFileList Exception", e);
		}
		
		return list;
	}
	
	// 특정 게시글의 첨부파일 조회
	public HiBoardFile2 boardFileSelect(HashMap<String, Object> map) {
		HiBoardFile2 hiBoardFile = null;
		
		try {
			hiBoardFile = hiBoardDao.boardFileSelect(map);
		} catch (Exception e) {
			logger.error("[HiBoardService2] boardFileSelect Exception", e);
		}
		
		return hiBoardFile;
	}
}
