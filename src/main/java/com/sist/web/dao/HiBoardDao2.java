package com.sist.web.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.sist.web.model.HiBoard2;
import com.sist.web.model.HiBoardFile2;

@Repository
public interface HiBoardDao2 {
	// 게시글 작성
	public abstract int boardInsert(HiBoard2 hiBoard);
	
	// 첨부파일 등록
	public abstract int boardFileInsert(HiBoardFile2 hiBoardFile);
	
	// 게시글 리스트
	public abstract List<HiBoard2> boardList(HiBoard2 search);
	
	// 페이징 처리를 위한 게시글 수 조회
	public abstract long boardListCnt(HiBoard2 search); 
	
	// 단일 게시글 조회
	public abstract HiBoard2 boardSelect(long hiBbsSeq);
	
	// 특정 게시글의 특정 첨부파일 조회
	public abstract HiBoardFile2 boardFileSelect(HashMap<String, Object> map);
	
	// 특정 게시글의 첨부파일 리스트 조회
	public abstract List<HiBoardFile2> boardFileList(long hiBbsSeq);
	
	// 게시글 조회수 증가
	public abstract int boardReadCntPlus(long hiBbsSeq);
	
	// 답글 작성 전 hiBbsOrder 업데이트
	public abstract int boardGroupOrderUpdate(HiBoard2 childHiboard);
	
	// 답글 작성
	public abstract int boardReplyInsert(HiBoard2 childHiBoard);
	
	// 기존 답글의 개수 구하기
	public abstract int boardReplyCnt(long hiBbsParent);
	
	// indent가 0인 댓글 삽입시 maxOrder 조회
	public abstract int boardGroupMaxOrder(long hiBbsGroup);
	
	// 직속 자식글 개수 조회
	public abstract int isBoardDeletable(long hiBbsSeq);
	
	// 게시글 삭제
	public abstract int boardDelete(long hiBbsSeq);
	
	// 게시글 파일 삭제
	public abstract int boardFileDelete(long hiBbsSeq);
	
	// 게시글 수정
	public abstract int boardUpdate(HiBoard2 hiBoard);
	
}