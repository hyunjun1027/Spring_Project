package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.web.dao.LikeyDao;
import com.sist.web.model.Likey;

@Service("likeyService")
public class LikeyService {
	
	private static Logger logger = LoggerFactory.getLogger(LikeyService.class);
	
	@Autowired
	private LikeyDao likeyDao;
	
	public List<Likey> likeySelect(Likey likey) {
		
		List<Likey> list = null;
		
		try {
			
			list = likeyDao.likeySelect(likey);
		
		}catch(Exception e) {
			
			logger.error("[LikeyService] likeySelect Exception", e);
		
		}
		
		return list;
		
	}
	
	public int likeyInsert(Likey likey) {
		
		int count = 0;
		
		try {
			
			count = likeyDao.likeyInsert(likey);
		
		}catch(Exception e) {
			
			logger.error("[LikeyService] likeyInsert Exception", e);
		
		}
		
		return count;
		
	}
	
	public int likeyDelete(Likey likey) {
		
		int count = 0;
		
		try {
			
			count = likeyDao.likeyDelete(likey);
			
		}catch(Exception e) {
			
			logger.error("[LikeyService] likeyDelete Exception", e);
			
		}
		
		return count;
		
	}
	
	
	
	public long likeySelect2(Likey likey) {
		
		long count = 0;
		
		try {
			
			count = likeyDao.likeySelect2(likey);
			
		}catch(Exception e) {
			
			logger.error("[LikeyService] likeySelect2 Exception", e);
			
		}
		
		return count;
		
	}
	
}
