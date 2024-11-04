package com.sist.web.service;

import java.util.HashMap;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sist.web.dao.ComDao;
import com.sist.web.model.Com;
import com.sist.web.model.ComSearch;

@Service
public class ComService {
	public static Logger logger = LoggerFactory.getLogger(ComService.class);
	
	@Autowired
	private ComDao comDao;
	
	
	public List<Com> comList(ComSearch comSearch) {
		List<Com> list = null;
		
		try {
			list = comDao.comList(comSearch);
		
		} catch (Exception e) {
			logger.error("[ComService] comList Exception", e);
		}
		
		
		return list;
	}
	
	public long comListCnt(ComSearch comSearch) {
		long cnt = 0;
		
		try {
			cnt = comDao.comListCnt(comSearch);
	
		} catch (Exception e) {
			logger.error("[ComService] comListCnt Exception", e);
		}
		
		return cnt;
	}
	
	public Com comSelect(long comSeq) {
		Com com = null;
		
		try {
			com = comDao.comSelect(comSeq);
			
		} catch (Exception e) {
			logger.error("[ComService] comSelect Exception", e);
		}
		
		return com;
	}
	
	public boolean comInsert(Com com) {
		int cnt = 0;
		
		try {
			cnt = comDao.comInsert(com);
			
		} catch (Exception e) {
			
			logger.error("[ComService] comInsert Exception", e);
		}
		
		return (cnt == 1);
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public boolean comReplyInsert(Com com) throws Exception {
		int cnt = 0;
		
		if (com.getComParent() == 0) {
			com.setComOrder(comDao.comGroupMaxOrder(com.getComGroup()));
			
		} else {
			int replyCnt = comDao.comReplyCnt(com.getComParent());
			com.setComOrder(com.getComOrder() + replyCnt);
			
			HashMap<String, Object> hashMap = new HashMap<>();
			hashMap.put("comGroup", com.getComGroup());
			hashMap.put("comOrder", com.getComOrder());
			
			comDao.comGroupOrderUpdate(hashMap);
		}
		
		cnt = comDao.comReplyInsert(com);
				
		return (cnt == 1);
	}
	
	public boolean comUpdate(HashMap<String, Object> hashmap) {
		int cnt = 0;
		
		try {
			cnt = comDao.comUpdate(hashmap);
			
		} catch (Exception e) {
			logger.error("[ComService] comUpdate Exception", e);
		}
		
		return (cnt == 1);
	}
	
	public boolean comDelete(long comSeq) {
		int cnt = 0;
		
		try {
			cnt = comDao.comDelete(comSeq);
			
		} catch (Exception e) {
			logger.error("[ComService] comDelete Exception", e);
		}
		
		return (cnt == 1);
	}
}
