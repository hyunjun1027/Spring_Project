<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link rel="stylesheet" href="/resources/css/navigation.css"
	type="text/css">
<link rel="stylesheet" href="/resources/css/footer.css" type="text/css">
<link rel="stylesheet" href="/resources/css/board.css" type="text/css">
<script type="text/javascript">
	
	function replyopen(commSeq){
		
		//댓글의 답글 작성 버튼 클릭 시
		
		if($(".com-reply" + commSeq).css('display') == 'none') {
		   $(".com-reply" + commSeq).css('display', 'block');
		   $(".com-reply" + commSeq).css('height', '100px');
		} else {
		   $(".com-reply" + commSeq).css('display', 'none');
		   $(".com-reply" + commSeq).css('height', '0px');
		}

	}
	

	function replydeleteBtn(commSeq){
		
		$("#replydeleteBtn" + commSeq).prop("disabled", true);
		$.ajax({
			
			type:"POST",
			url:"/comment/commentDelete",
			data:{
				brdSeq:${brdSeq},
				commSeq:commSeq,
				boardType:${boardType}
			},			
			datatype:"JSON",
			beforeSend:function(xhr){
			  	xhr.setRequestHeader("AJAX", "true");
			},
			success:function(response){
				
				if(response.code == 0){
					alert("삭제가 완료되었습니다.");
					document.commentForm.action="/board/view";
					document.commentForm.submit();
				}else if(response.code == 403){
					alert("사용자의 댓글이 아닙니다.");
					$("#replydeleteBtn" + commSeq).prop("disabled", false);
				}else if(response.code == 404){
					alert("존재하지 않는 댓글입니다.");
					$("#replydeleteBtn" + commSeq).prop("disabled", false);
				}else if(response.code == 500){
					alert("파라미터 값이 올바르지 않습니다.");
					$("#replydeleteBtn" + commSeq).prop("disabled", false);
				}
				
			},
			error:function(error){
				icia.common.error(error);
				alert("삭제 중 오류가 발생하였습니다.");
				$("#replydeleteBtn" + commSeq).prop("disabled", false);
			}
			
			
		});
		
	}
	
	function replyInput(commSeq){
		//댓글의 답글 작성 버튼 클릭 시
		$("#comreplyBtn" + commSeq).prop("disabled", true);  // 답변 버튼 비활성화
		
		
		if($.trim($("#comreplyinput" + commSeq).val()).length <= 0){
			alert("내용을 입력하세요.");
			$("#comreplyBtn" + commSeq).prop("disabled", false);
			$("#comreplyinput" + commSeq).val("");
			$("#comreplyinput" + commSeq).focus();
			return;
			
		}

		
		$.ajax({
			type:"POST",
			url:"/comment/commentreplyProc",
			data:{
				brdSeq:${brdSeq},
				commSeq:commSeq,
				boardType:${boardType},
				comreplyinput:$("#comreplyinput" + commSeq).val()
			},
			datatype:"JSON",
			beforeSend:function(xhr){
			  	xhr.setRequestHeader("AJAX", "true");
			},
			success:function(response){
				
				if(response.code == 0){
					alert("답변이 완료되었습니다.");
					document.commentForm.action="/board/view";
					document.commentForm.submit();
				}else if(response.code == 400){
					alert("파라미터 값이 올바르지 않습니다.");
					$("#comreplyBtn" + commSeq).prop("disabled", false);
					$("#comreplyinput" + commSeq).focus();
				}else{
					alert("댓글 답변 중 오류가 발생하였습니다.(2)");
					$("#comreplyBtn" + commSeq).prop("disabled", false);
					$("#comreplyinput" + commSeq).focus();
				}
				
			},
			error:function(error){
				icia.common.error(error);
				alert("댓글 답변 중 오류가 발생하였습니다.");
				$("#comreplyBtn" + commSeq).prop("disabled", false);
			}
			
		});

	}

   $(document).ready(function() {


      // 햄버거 버튼 클릭 이벤트
      $('nav ul li a img[alt="햄버거버튼"]').on('click', function(event) {
         event.preventDefault();
         $('.dropdown-menu').toggle();
      });

      // 메뉴 외부를 클릭했을 때 드롭다운 메뉴 숨기기
      $(document).on('click', function(event) {
         if (!$(event.target).closest('nav').length) {
            $('.dropdown-menu').hide();
         }
      });

      //좋아요 버튼 클릭 시
      $("#recomBtn").on("click", function() {
		 fn_likeyCheck();
      });

      //답글 버튼 클릭 시
      $("#writeBtn").on("click", function() {
	   	   document.bbsForm.action = "/board/replyForm";
	   	   document.bbsForm.brdSeq.value = ${board.brdSeq};
		   document.bbsForm.submit();
      });

      //수정 버튼 클릭 시
      $("#updateBtn").on("click", function() {
	   	   document.bbsForm.action = "/board/update";
		   document.bbsForm.submit();
      });

      //삭제 버튼 클릭 시
      $("#deleteBtn").on("click", function() {
			fn_deleteCheck();
      });

      //목록 버튼 클릭 시
      $("#listBtn").on("click", function() {
         document.bbsForm.action = "/board/list";
         document.bbsForm.submit();
      });

      //댓글 작성 버튼 클릭 시
      $("#comBtn").on("click", function() {
    	  fn_CommentCheck();
      });
	   
	   	$("#btnList").on("click", function() {
			
	   		document.bbsForm.action="/board/list";
	   		document.bbsForm.submit();
	   		
	   	});



   });


   function fn_CommentCheck(){

		if ($.trim($("#commContent").val()).length <= 0) {
			alert("내용을 입력해주세요.");
			$("#commContent").val("");
			$("#commContent").focus();
			return;
		}

		var form = $("#commentForm")[0];
		var formData = new FormData(form);

	    $.ajax({
			  
	 	   type:"POST",
		   enctype:"multipart/form-data",
		   url:"/comment/commentProc",
		   data:formData,
		   processData:false,	
		   contentType:false,	
		   cache:false,
		   timeout:600000,		
		   beforeSend:function(xhr){
		  	   xhr.setRequestHeader("AJAX", "true");
		   },
		   success:function(response){
			  
			   if(response.code == 0){
				   alert("댓글이 등록 되었습니다.");
				   document.commentForm.action="/board/view";
				   document.commentForm.submit();

			   }else if(response.code == 400){
			 	   alert("파라미터 값이 올바르지 않습니다.");
				   $("#comBtn").prop("disabled", false);
				   $("#comContent").focus();
			   }else{
				   alert("댓글 등록중 오류가 발생하였습니다.(2)");
				   $("#comBtn").prop("disabled", false);
				   $("#comContent").focus();
			   }
			  
		   },
		   error:function(xhr, status, error){
			   icia.common.error(error);
			   alert("댓글 등록 중 오류가 발생하였습니다.");
			   $("#comBtn").prop("disabled", false);
		   }
		   
	    });

	   
   }
   
   function fn_likeyCheck(){
		$.ajax({
		   type:"POST",
		   url:"/likey/likeyInsertProc",
		   data:{
			   brdSeq:<c:out value="${brdSeq}" />,
			   boardType:${boardType}
		   },
		   datatype:"JSON",
		   beforeSend:function(xhr){
			   xhr.setRequestHeader("AJAX", "true");
		   },
		   success:function(response){
			   
			   if(response.code == 0){
				   alert("좋아요 완료");
				   $("#recomBtn").html("좋아요 " + response.data);
			   }else if(response.code == -1){
				   alert("좋아요 취소");
				   $("#recomBtn").html("좋아요 " + response.data);
			   }else if(response.code == -99){
				   alert("알수없는 오류가 발생하였습니다.");
			   }else if(response.code == 404){
				   alert("게시글을 찾을 수 없습니다.");
				   location.href = "/board/list";
			   }else if(response.code == 400){
				   alert("존재하지 않는 게시글 입니다.");
				   location.href = "/board/list";
			   }else if(response.code == 500){
				   alert("로그인 후 이용이 가능합니다.");
				   location.href = "/user/userForm";
			   }
			   
			   
		   },
		   error:function(xhr, status, error){
			   icia.common.error(error);
		   }
			   
			   
		});
   }
   
   function fn_deleteCheck(){
	   
		if(confirm("정말 삭제하시겠습니까?") == true){
			
			$.ajax({
				
			   type:"POST",
			   url:"/board/delete",
			   data:{
				   brdSeq:<c:out value="${brdSeq}" />,
				   boardType:${boardType}
			   },
			   datatype:"JSON",
			   beforeSend:function(xhr){
				   xhr.setRequestHeader("AJAX", "true");
			   },
			   success:function(response){
				   
				   if(response.code == 0){
					   
					   alert("게시물이 삭제 되었습니다.");
					   document.bbsForm.action = "/board/list";
					   document.bbsForm.boardType.value = ${boardType};
					   document.bbsForm.submit();
					   
				   }else if(response.code == 400){
					   
					   alert("파라미터 값이 올바르지 않습니다.");
					   
				   }else if(response.code == 403){
					   
					   alert("본인글이 아니므로 삭제할 수 없습니다.");
					   
				   }else if(response.code == 404){
					   
					   alert("해당 게시물을 찾을 수 없습니다.");
					   location.href = "/board/list";
					   
				   }else if(response.code == -999){
					   
					   alert("답글이 존재하여 삭제할 수 없습니다.");
					   
				   }else if(response.code == -998){
					   
					   alert("댓글이 존재하여 삭제할 수 없습니다.");
					   
				   }else{
					   alert("게시물 삭제중 오류가 발생하였습니다.");
				   }
				   
			   },
			   error:function(xhr, status, error){
				   icia.common.error(error);
			   }
				   
				   
			});
			   
				
		};
			
       
   }

   function fn_list(boardType) {
      document.bbsForm.action = "/board/list";
      document.bbsForm.boardType.value = boardType;
      document.bbsForm.submit();
   }
   
</script>
</head>
<body>
	<!-- 헤더 영역 -->
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>

	<!-- 배너 사진 -->
	<div class="banner-container">
		<img alt="" src="/resources/images/list_banner.jpg">
	</div>

	<!-- 메인 컨테이너 -->
	<div class="main-container write-main-cont">
		<div class="title-container" style="cursor: pointer;">
			<h1 onclick="fn_list(${boardType})">${boardTitle}</h1>
		</div>

		<div class="list-container">
			<div class="write-title-container">
				<span>상세보기</span>
			</div>
			<form name="viewForm" id="viewForm" method="post"
				enctype="multipart/form-data">
				<div class="write-container">
					<div class="view-header">
						<div class="view-title">
							<h3>${board.brdTitle}</h3>
						</div>
						<div class="view-info">${board.userName}&nbsp;&nbsp;|&nbsp;&nbsp;${board.modDate}&nbsp;&nbsp;|&nbsp;&nbsp;조회수
							: ${board.brdReadCnt}</div>
					</div>
					<div class="view-content">
						<c:if test="${!empty board.fileName}">
							<img src="/resources/upload/${board.fileName}"
								style="width: 100%; margin-bottom: 20px;">
						</c:if>
						<pre>${board.brdContent}</pre>
					</div>
				</div>
				<div class="write-btn-container" style="padding-bottom: 120px;">
					<!-- 좋아요 버튼 하실 분 사용하세요 -->
					<div class="view-left" style="float: left;">
						<button type="button" id="recomBtn" class="writeBtn">좋아요
							${board.likeCnt}</button>

						<c:if test="${(boardType eq 4) and user.rating eq 1}">
							<button type="button" id="writeBtn" class="writeBtn">답글</button>
						</c:if>

					</div>
					<div class="view-right" style="float: right;">
						<c:if test="${boardMe eq 'Y'}">
							<button type="button" id="updateBtn" class="writeBtn">수정</button>
						</c:if>
						<c:if test="${(boardMe eq 'Y') or user.rating eq 1}">
							<button type="button" id="deleteBtn" class="writeBtn">삭제</button>
						</c:if>
						<button type="button" id="listBtn" class="writeBtn">목록</button>
					</div>
				</div>

			</form>


			<c:if test="${boardType eq 2 or boardType eq 3}">
				<!-- 댓글창 -->
				<form name="commentForm" id="commentForm" method="post"
					enctype="multipart/form-data">
					<div class="comment-container">
						<div class="com-cnt">댓글 수 : ${commentTotalCount}</div>
						<input type="text" name="commContent" id="commContent"
							class="com-input" placeholder="내용을 입력하세요"> <input
							type="button" id="comBtn" class="com-btn" value="댓글 작성">
					</div>
					<input type="hidden" name="boardType" value="${boardType}">
					<input type="hidden" name="brdSeq" value="${brdSeq}">
				</form>



				<c:if test="${!empty commentList}">
					<div class="comment-list-container">
						<c:forEach var="comment" items="${commentList}" varStatus="status">

							<div class="com-item-container" style="clear: both; padding-left:${comment.brdIndent}em;">
							<c:if test="${comment.status eq 'N'}">
								<div class="com-content">
									<span>삭제된 댓글입니다.</span>
								</div>
						    </c:if>			
   							<c:if test="${comment.status eq 'Y'}">			
								<div class="com-info">
										<c:if test="${comment.brdIndent > 0}">
											<span><img src="/resources/images/right-arrow.png" style="width: 15px;" /></span>
										</c:if>
										
										<span class="com-user">${comment.userId}</span> | <span class="com-date">${comment.commModiDate}</span>
							<c:if test="${(comment.userId eq user.userId) or user.rating eq 1}">	
										<button type="button" onclick="replydeleteBtn(${comment.commSeq})" class="replydeleteBtn" id="replydeleteBtn" class="writeBtn" style="background-color: transparent; float: right; border: none; border-radius: 100px; padding: 3px; cursor: pointer;">삭제</button>
										<!-- <button type="button" onclick="replyupdateBtn(${comment.commSeq})" id="replyupdateBtn" class="writeBtn" style="background-color: transparent; float: right; border: none; border-radius: 100px; padding: 3px; cursor: pointer;">수정</button> -->
							</c:if>
								</div>	
														
								<div class="com-content">
									<pre>${comment.commContent}</pre>
								</div>
								<!-- 답글 작성 버튼 -->
								<div class="com-reply-add com-reply-add${comment.commSeq}">
									<span onclick="replyopen(${comment.commSeq})">답글 달기</span>
								</div>		
								<!-- 답글 입력창 -->
								<div class="com-reply com-reply${comment.commSeq}"
									style="clear: both; display: none;">
									<input type="text" class="com-reply-input" id="comreplyinput${comment.commSeq}" placeholder="내용을 입력하세요">
									<input onclick="replyInput(${comment.commSeq})" type="button" id="comreplyBtn${comment.commSeq}" class="com-reply-btn" value="답글 작성" style="background: #604f47;">
								</div>
							</c:if>
							</div>
						</c:forEach>
					
					</div>
					</c:if>
			


				<c:if test="${empty commentList}">

					<div class="comment-list-container">
						<div class="com-item-container" style="clear: both;">
							<div class="com-info">
								<span class="com-user">작성된 댓글이 없습니다.</span>
							</div>
						</div>
					</div>

				</c:if>
			</c:if>
		</div>
	</div>

	<!-- 푸터 영역 -->
	<%@ include file="/WEB-INF/views/include/footer.jsp"%>

	<form id="bbsForm" name=bbsForm method="post">
		<input type="hidden" name="boardType" value="${boardType}"> <input
			type="hidden" name="brdSeq" value="${brdSeq}"> <input
			type="hidden" name="searchType" value="${searchType}"> <input
			type="hidden" name="searchValue" value="${searchValue}"> <input
			type="hidden" name="curPage" value="${curPage}">
	</form>
</body>
</html>