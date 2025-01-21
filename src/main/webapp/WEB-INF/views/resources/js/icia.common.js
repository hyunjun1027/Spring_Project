/**
 * 파일명 : icia.common.js
 * 작성일 : 2021. 1. 13.
 * 버전   : 1.0.1
 * 작성자 : daekk
 * 설명   : 자바 스크립트 공통모듈
 * 사용법 : jQuery 선언뒤에 선언 되어야 함.
 *                   
 */

// console 객체 지원하지 않는 브라우저 오류 방지 
var console = window.console || { log: function() {}, error: function() {} };
	
var icia = (function(icia, undefined)
{
	icia.common = icia.common || {};
	
	/**
	 * 콘솔에 로그를 남긴다 (파라미터는 자동으로 감지 함)
     */
	icia.common.log = function()
	{
		if(arguments != null && arguments.length > 0)
		{
			for(var i=0; i<arguments.length; i++)
			{
				console.log(arguments[i]);
			}	
		}	
	}
	
	/**
	 * 콘솔에 에러 로그를 남긴다 (파라미터는 자동으로 감지 함)
     */
	icia.common.error = function()
	{
		if(arguments != null && arguments.length > 0)
		{
			for(var i=0; i<arguments.length; i++)
			{
				console.error(arguments[i]);
			}	
		}	
	}
	
	/**
	 * val 이 숫자 인지 체크 (문자로된 숫자도 체크됨)
     * 
	 * @param val 변수
	 * @return boolean
	 */
	icia.common.isNumber = function(val)
	{
		var type = icia.common.type(val);
		
		return ( type === "number" || type === "string" ) && !isNaN( val - parseFloat( val ) );
	};
	
	/**
	 * obj의 타입을 얻는다
     * 
	 * @param obj 타입을 얻을 변수
	 * @return string
	 */
	icia.common.type = function(obj)
	{
		if ( obj == null ) 
		{
			return obj + "";
		}

		if(typeof(obj) === "object" || typeof(obj) === "function")
		{
			if(obj.constructor === Object)
			{
				return "object";
			}
			else if(obj.constructor === String)
			{
				return "string";
			}
			else if(obj.constructor === Number)
			{
				return "number";
			}
			else if(obj.constructor === Boolean)
			{
				return "boolean";
			}
			else if(obj.constructor === Array)
			{
				return "array";
			}
			else if(obj.constructor === RegExp)
			{
				return "regExp";
			}
			else if(obj.constructor === Function)
			{
				return "function";
			}
			else if(obj.constructor === Date)
			{
				return "date";
			}
			else
			{
				return typeof(obj);
			}
		}
		else
		{
			return typeof(obj);
		}
	};
		
	/**
	 * undefined 체크
     * (undefined : 변수는 존재하나, 어떠한 값으로도 할당되지 않아 자료형이 정해지지(undefined) 않은 상태)
     *
     * @param val
     * @return boolean
     */
	icia.common.isUndefined = function(val)
	{
		return (typeof(val) !== "undefined" ? false : true);
	};
	
	/**
	 * undefined + null 체크
     * (null : 변수는 존재하나, null 로 (값이) 할당된 상태. 즉 null은 자료형이 정해진(defined) 상태)
     * 
     * @param val
     * @return boolean
	 */
	icia.common.isNull = function(val)
	{
		return (icia.common.isUndefined(val) == false ? (val !== null ? false : true) : true);
	};
	
	/**
	 * val 이 undefined 이거나 또는 null 이거나 또는 값이 비어있는지 체크
     * 
     * @param val
     * @return boolean
	 */
	icia.common.isEmpty = function(val)
	{
		// val 이 undefined 또는 null 인지 체크
		if(icia.common.isNull(val) == false)
		{
			// val 타입이 문자열 또는 배열 이면
			if(icia.common.type(val) === "string" || icia.common.type(val) === "array")
			{
				// 길이로 체크한다.
				return (val.length > 0 ? false : true);
			}
			else if(icia.common.type(val) === "object") // val 객체이면
			{
				var name;

				// 객체가 비어 있는지 체크
				for ( name in val )  
				{
					return false;
				}
				
				return true;
			}	
			
			// 그 외는 비어있지 않음 (이미 위에서 icia.common.isNull(val) 체크 했기 때문)
			return false;
		}
		
		return true;
	};
	
	/**
	 * obj 객체에서 field 를 찾아 값을 얻는다.
     * ()obj가 undefined,null 또는 field가 없다면 defVal 값을 리턴) 
     * 
     * @param obj    객체
     * @param field  필드명
     * @param defVal 디폴트 값
     * @return (문자열, 숫자, 객체...)
	 */
	icia.common.objectValue = function(obj, field, defVal)
	{
		if(icia.common.isEmpty(obj) == false)
		{
			if(icia.common.type(obj) === "object")
			{
				if(!icia.common.isEmpty(obj[field]))
				{
					return obj[field];  
				}
				else
				{
					if(!icia.common.isUndefined(defVal))
					{
						return defVal;
					}
					else
					{
						return null;
					}	
				}
			}
			else
			{
				if(icia.common.isUndefined(defVal) == false)
				{	
					return defVal;
				}
				else
				{
					return null;
				}
			}
		}
		else
		{
			if(icia.common.isUndefined(defVal) == false)
			{	
				return defVal;
			}
			else
			{
				return null;
			}
		}
	}
	
	/**
	 * val에서 oldVal을 찾아 newVal로 변환 한다.
     * (문자열과 숫자만 됨)
     *
     * @param val    원본 값
     * @param oldVal 찾는 값
     * @param newVal 변경 값
     * @return string
	 */
	icia.common.replace = function(val, oldVal, newVal)
	{
		if(!icia.common.isNull(val) && (icia.common.type(val) === "string" ||  icia.common.type(val) === "number"))
		{	
			if(icia.common.type(val) === "string")
			{
				return value.split(oldVal).join(newVal);
			}
			else
			{
				return value.toString().split(oldVal).join(newVal);
			}
		}
		else
		{
			return "";
		}
	};	
	
	/**
	 * 문자열의 좌우 공백을 없앤다.
     *
     * @param val 문자열
     * @return string
	 */
	icia.common.trim = function(val)
	{
		if(!icia.common.isNull(val) && icia.common.type(val) === "string")
		{	
			return val.replace(/^\s+|\s+$/g, '');
		}
		else
		{
			return "";
		}
	};
	
	/**
	 * 문자열의 좌측 공백을 없앤다.
     *
     * @param val 문자열
     * @return string
	 */
	icia.common.ltrim = function(val)
	{
		if(!icia.common.isNull(val) && icia.common.type(val) === "string")
		{	
			return val.replace(/^\s+/g, '');
		}
		else
		{
			return "";
		}
	};
	
	/**
	 * 문자열의 우측 공백을 없앤다.
     *
     * @param val 문자열
     * @return string
	 */
	icia.common.rtrim = function(val)
	{
		if(!icia.common.isNull(val) && icia.common.type(val) === "string")
		{	
			return val.replace(/\s+$/g, '');
		}
		else
		{
			return "";
		}
	};
	
	/**
	 *
	 */
	icia.common.comma = function(val)
	{
		if(!icia.common.isNull(val) && (icia.common.type(val) === "string" ||  icia.common.type(val) === "number"))
		{	
			if(icia.common.type(val) === "number")
			{
				val += "";
			}
			
			var reg = /(^[+-]?\d+)(\d{3})/;
			
			while(reg.test(val))
		    {
		    	val = val.replace(reg, '$1' + ',' + '$2');
		    }
			
			return val;
		}
		else
		{
			return val;
		}
	};
	
	icia.common.lpad = function(val, len, pad)
	{
		if(!icia.common.isNull(val) && (icia.common.type(val) === "string" ||  icia.common.type(val) === "number"))
		{	
			if(icia.common.type(val) === "number")
			{
				val += "";
			}
			
			var strAdd = "";
			var diffLen = len - val.length;
			
			for(var i = 0; i < diffLen; i++) 
			{
				strAdd += pad;
			}

			val = strAdd + val;
			
			return val;
		}
		else
		{
			return val;
		}
	};
	
	icia.common.rpad = function(val, len, pad)
	{
		if(!icia.common.isNull(val) && (icia.common.type(val) === "string" ||  icia.common.type(val) === "number"))
		{	
			if(icia.common.type(val) === "number")
			{
				val += "";
			}
			
			var strAdd = "";
			var diffLen = len - val.length;
			
			for(var i = 0; i < diffLen; i++) 
			{
				strAdd += pad;
			}

			val = val + strAdd;
			
			return val;
		}
		else
		{
			return val;
		}
	};
	
	/**
	 * 이벤트 전파 중지 및 현 이벤트중지
     *
	 * @param obj 객체
	 */
	icia.common.stopEvent = function(obj)
	{
		if(icia.common.type(obj) === "object")
		{	
			if(obj.stopPropagation) 
		    {
				obj.stopPropagation();   // 이벤트 전파 방지 - W3C 표준
		    }
		    else 
		    { 
		    	obj.cancelBubble = true; // 이벤트 전파 방지 - 인터넷 익스플로러 방식
		    }
			
			if (obj.preventDefault) 
			{
				obj.preventDefault();    // 링크,폼등의 기본동작 중지 - W3C 표준
			} 
			else 
			{
				obj.returnValue = false; // 링크,폼등의 기본동작 중지 - 인터넷 익스플로러 방식
			}
		}
	}
    
    return icia;
	
})(window.icia = window.icia || {});