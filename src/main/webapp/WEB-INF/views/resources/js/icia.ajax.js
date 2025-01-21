/**
 * 파일명 : icia.ajax.js
 * 작성일 : 2021. 1. 13.
 * 버전   : 1.0.1
 * 작성자 : daekk
 * 설명   : 자바 스크립트 ajax 공통
 * 사용법 : jQuery 선언 되어야 함.
 */
var icia = (function(icia, undefined)
{
	icia.ajax = icia.ajax || {};
	
	icia.ajax.call = function(options)
    {
    	if(!icia.common.isEmpty(options))
    	{
    		var config = {
    			async: true,
    			cache: false
    		};

            /**
             * 기존 헤더 전송을 SPRING CSRF로 변경하면서 추가됨
             */
            var token = $("meta[name='_csrf']").attr("content");
            var header = $("meta[name='_csrf_header']").attr("content");
    		/** 변경끝 */

    		if(icia.common.isEmpty(options.url))
    		{
    			icia.common.error("ajax url is not found.");
    			return;
    		}	
    		
    		if(icia.common.isEmpty(options.type))
    		{
    			icia.common.error("ajax type is not found.");
    			return;
    		}
    		
    		var _options = $.extend({}, config, options);
    		
    		_options["beforeSend"] = function(xhr) 
    		{
				if(!icia.common.isEmpty(header) && !icia.common.isEmpty(token))
				{
					// Spring Security AJAX 사용시 CSRF 헤더 전송
	                xhr.setRequestHeader(header, token);
				}
					
                // AJAX 통신 구분을 위한 헤더 값
				xhr.setRequestHeader("AJAX", "true");
				
    			if(icia.common.type(options.beforeSend) === "function")
    			{
    				options.beforeSend(xhr);
    			}
    		};

			if(!icia.common.isEmpty(options.progress))
			{
				if(icia.common.type(options.progress) === "function")
				{
					_options["xhr"] = function() 
					{
						var xhr = $.ajaxSettings.xhr();
						
						xhr.upload.onprogress = function(e)
						{
							var per = ( ( e.loaded * 100 ) / e.total );
							
							options.progress(per);
						};
						
						return xhr;
					};		
				}
			}

			if(!icia.common.isEmpty(options.success))
			{
				if(icia.common.type(options.success) === "function")
				{
					_options["success"] = function(result, status, xhr) 
					{
						options.success(result, status, xhr);
					};
				}
			}
    		
    		if(icia.common.type(options.dataType) === "string" && options.dataType.toLowerCase() === "jsonp")
    		{	
    			_options["type"] = "GET";
    			
	    		if(icia.common.type(options.jsonpCallback) === "function")
				{
					_options["jsonpCallback"] = function(result) 
					{
						options.jsonpCallback(result);
					};
				}
    		}
    		
    		_options["error"] = function(xhr, status, error) 
			{
    			if(icia.common.type(options.error) === "function")
    			{
    				options.error(xhr, status, error);
    			}
    			else
    			{
    				icia.common.error("#####################################################################################");
					icia.common.error("# icia.ajax error.                                                      #");
					icia.common.error("#####################################################################################");
					icia.common.error(xhr);
					icia.common.error(status);
					icia.common.error(error);
					icia.common.error("#####################################################################################");
    			}	
			};
    					
			if(icia.common.type(options.complete) === "function")
			{
				_options["complete"] = function(xhr, status) 
				{
					options.complete(xhr, status);
				};
			}
			
			icia.common.log("#####################################################################################");
			icia.common.log("# icia.ajax options.                                                           #");
			icia.common.log("#####################################################################################");
			icia.common.log(_options);
			icia.common.log("#####################################################################################");
			
			$.ajax(_options).done(function(result) 
			{
				if(icia.common.type(_options.done) === "function")
				{
					if(!icia.common.isNull(result))
					{	
						_options.done(result);
					}
					else 
					{
						_options.done(null);
					}
				}	
		    });
    	}	
    	else
    	{	
    		icia.common.eror("icia.ajax error : options null or empty.");
    	}
    };

	icia.ajax.post = function(options)
    {
    	if(!icia.common.isEmpty(options))
    	{
    		if(icia.common.isEmpty(options.url))
    		{
    			icia.common.error("[icia.ajax.post] url is not found.");
    			return;
    		}	
    		
			/*
			    - url (String)
                요청 URL
				기본 : 현재 페이지         
 
				- type (String)
				전송 방식 GET, POST
				기본 : GET
		
				- dataType (String : xml, json, script, or html)
				내가 보내는 데이터의 타입이 아니고 서버가 응답(response)할 때 보내줄 데이터의 타입
			    서버에서 받을 데이터 형식을 지적한다.
				지정하지 않으면 MIME 타입을 참고하여 자동 파싱된다.
				
				- contentType (Boolean or String)
				해더의 Content-Type을 설정한다.
                파일 업로드시 false 설정
				기본 : application/x-www-form-urlencoded; charset=UTF-8	
				
				- processData (Boolean)
				데이터를 query string 형태로 보내지 않고 DOMDocument 또는 다른 형태로 보내고 싶으면 false로 설정한다.
				파일 업로드시 false
				
				- method (String)
				요청할 HTTP 메서드 (POST, GET, PUT)
				기본 : GET
			*/
    		var dataType = "JSON";
			var contentType = "application/x-www-form-urlencoded; charset=UTF-8";
			var processData = true;
			
    		if(!icia.common.isEmpty(options.dataType))
    		{
    			dataType = options.dataType;
    		}

			if(!icia.common.isEmpty(options.contentType))
    		{
    			contentType = options.contentType;
    		}

			if(!icia.common.isEmpty(options.processData))
			{
				processData = options.processData;
			}
			
			options["type"] = "POST";
    		options["contentType"] = contentType;
    		options["dataType"] = dataType;
			options["processData"] = processData;
			options["method"] = "POST";
			    		
    		icia.ajax.call(options);
    	}
    	else
    	{	
    		icia.common.eror("[icia.ajax.post] error : options null or empty.");
    	}
    };

	icia.ajax.get = function(options)
    {
    	if(!icia.common.isEmpty(options))
    	{
    		if(icia.common.isEmpty(options.url))
    		{
    			icia.common.error("[icia.ajax.get] url is not found.");
    			return;
    		}	
    		
    		var dataType = "JSON";
			var contentType = "application/x-www-form-urlencoded; charset=UTF-8";
			var processData = true;
			
    		if(!icia.common.isEmpty(options.dataType))
    		{
    			dataType = options.dataType;
    		}

			if(!icia.common.isEmpty(options.contentType))
    		{
    			contentType = options.contentType;
    		}

			if(!icia.common.isEmpty(options.processData))
			{
				processData = options.processData;
			}
			
			options["type"] = "GET";
    		options["contentType"] = contentType;
    		options["dataType"] = dataType;
			options["processData"] = processData;
			options["method"] = "GET";
    		
    		icia.ajax.call(options);
    	}
    	else
    	{	
    		icia.common.eror("[icia.ajax.get] error : options null or empty.");
    	}
    };

	icia.ajax.put = function(options)
    {
    	if(!icia.common.isEmpty(options))
    	{
    		if(icia.common.isEmpty(options.url))
    		{
    			icia.common.error("[icia.ajax.put] url is not found.");
    			return;
    		}	
    		
    		var dataType = "JSON";
			var contentType = "application/json; charset=UTF-8";
			var processData = true;
			
    		if(!icia.common.isEmpty(options.dataType))
    		{
    			dataType = options.dataType;
    		}

			if(!icia.common.isEmpty(options.contentType))
    		{
    			contentType = options.contentType;
    		}

			if(!icia.common.isEmpty(options.processData))
			{
				processData = options.processData;
			}
			
			options["type"] = "PUT";
    		options["contentType"] = contentType;
    		options["dataType"] = dataType;
			options["processData"] = processData;
			options["method"] = "PUT";
    		
    		icia.ajax.call(options);
    	}
    	else
    	{	
    		icia.common.eror("[icia.ajax.put] error : options null or empty.");
    	}
    };

	icia.ajax.delete = function(options)
    {
    	if(!icia.common.isEmpty(options))
    	{
    		if(icia.common.isEmpty(options.url))
    		{
    			icia.common.error("[icia.ajax.delete] url is not found.");
    			return;
    		}	
    		
    		var dataType = "JSON";
			var contentType = "application/json; charset=UTF-8";
			var processData = true;
			
    		if(!icia.common.isEmpty(options.dataType))
    		{
    			dataType = options.dataType;
    		}

			if(!icia.common.isEmpty(options.contentType))
    		{
    			contentType = options.contentType;
    		}

			if(!icia.common.isEmpty(options.processData))
			{
				processData = options.processData;
			}
			
			options["type"] = "DELETE";
    		options["contentType"] = contentType;
    		options["dataType"] = dataType;
			options["processData"] = processData;
			options["method"] = "DELETE";
    		
    		icia.ajax.call(options);
    	}
    	else
    	{	
    		icia.common.eror("[icia.ajax.delete] error : options null or empty.");
    	}
    };
    
    return icia;
	
})(window.icia = window.icia || {});