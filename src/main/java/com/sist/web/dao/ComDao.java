package com.sist.web.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.sist.web.model.Com;
import com.sist.web.model.ComSearch;

@Repository
public interface ComDao {
	public abstract List<Com> comList(ComSearch comSearch);
	public abstract long comListCnt(ComSearch comSearch);
	public abstract Com comSelect(long comSeq);
	public abstract int comInsert(Com com);
	public abstract int comReplyInsert(Com com);
	public abstract int comGroupOrderUpdate(HashMap<String, Object> hashMap);
	public abstract int comReplyCnt(long comParent);
	public abstract int comGroupMaxOrder(long comGroup);
	public abstract int comUpdate(HashMap<String, Object> hashMap);
	public abstract int comDelete(long comSeq);
}