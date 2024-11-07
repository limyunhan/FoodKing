package com.sist.web.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.sist.web.model.Bbs;
import com.sist.web.model.BbsFile;
import com.sist.web.model.BbsImage;
import com.sist.web.model.BbsSearch;

@Repository
public interface BbsDao {
	public abstract List<Bbs> bbsList(BbsSearch bbsSearch);
	public abstract long bbsListCnt(BbsSearch bbsSearch);
	public abstract Bbs bbsSelect(HashMap<String, Object> hashMap);
	public abstract List<BbsFile> bbsFileList(long bbsSeq);
	public abstract BbsFile bbsFileSelect(HashMap<String, Object> hashMap);
	public abstract int bbsReadCntPlus(long bbsSeq);
	public abstract short bbsFileSeq(long bbsSeq);
	public abstract short bbsImageSeq(long bbsSeq);
	public abstract int bbsInsert(Bbs bbs);
	public abstract int bbsFileInsert(BbsFile bbsFile);
	public abstract int bbsImageInsert(BbsImage bbsImage);
	public abstract int bbsUpdate(Bbs bbs);
	public abstract int bbsDelete(long bbsSeq);
	public abstract int comDeleteByBbsDelete(long bbsSeq);
	public abstract int bbsFileDelete(long bbsSeq);
	public abstract int bbsImageDelete(long bbsSeq);
	public abstract List<BbsImage> bbsImageList(long bbsSeq);
	public abstract BbsImage bbsImageSelect(long bbsSq);
	public abstract int recomInsert(HashMap<String, Object> hashMap);
	public abstract int recomDelete(HashMap<String, Object> hashMap);
	public abstract int bookmarkInsert(HashMap<String, Object> hashMap);
	public abstract int bookmarkDelete(HashMap<String, Object> hashMap);
	public abstract int isRecommendable(HashMap<String, Object> hashMap);
	public abstract int isBookmarkable(HashMap<String, Object> hashMap);
}