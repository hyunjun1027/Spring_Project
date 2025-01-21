package com.sist.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.sist.web.model.Likey;

@Repository("likeyDao")
public interface LikeyDao {
	
	public List<Likey> likeySelect(Likey likey);
	
	public int likeyInsert(Likey likey);
	
	public int likeyDelete(Likey likey);
	
	public long likeySelect2(Likey likey);
	
}
