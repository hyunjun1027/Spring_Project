<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link rel="stylesheet" href="/resources/css/navigation.css" type="text/css">
<link rel="stylesheet" href="/resources/css/footer.css" type="text/css">
<link rel="stylesheet" href="/resources/css/board.css" type="text/css">
<!-- SweetAlert2 CSS -->
<link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.5.4/dist/sweetalert2.min.css" rel="stylesheet">

<!-- SweetAlert2 JS -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.5.4/dist/sweetalert2.all.min.js"></script>

<script type="text/javascript">
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
		
		//조회버튼 클릭시
		$("#btnSearch").on("click", function() {
		
			 document.bbsForm.brdSeq.value = "";
			 document.bbsForm.searchType.value = $("#_searchType").val();
			 document.bbsForm.searchValue.value = $("#_searchValue").val();
			 document.bbsForm.curPage.value = "1";
			 document.bbsForm.action = "/board/list";
			 document.bbsForm.submit();
			 
		});
	});
	
	function fn_write(boardType){
		
		<c:choose>
			<c:when test="${empty user.userId}">
		   		alert("로그인 후 이용해 주세요.");
		   		location.href = "/user/userForm";
			</c:when>
			<c:otherwise>
				document.bbsForm.brdSeq.value = "";
				document.bbsForm.boardType.value = boardType;
				document.bbsForm.action = "/board/write";
				document.bbsForm.submit();
			</c:otherwise>
		</c:choose>


	
	}
	
	function fn_view(brdSeq){
		document.bbsForm.brdSeq.value = brdSeq;
		document.bbsForm.action = "/board/view";
		document.bbsForm.submit();
	}

	async function fn_viewPwd(brdSeq, brdPwd) {
	    console.log("비밀번호 확인 시작");

	    if (brdPwd != null && ${user.rating ne 1}) {

	        const { value: userPwd } = await Swal.fire({
	            title: "비밀번호를 입력하세요",
	            input: "password",
	            inputLabel: "비밀번호",
	            inputPlaceholder: "비밀번호를 입력하세요",
	            inputAttributes: {
	                maxlength: "10",
	                autocapitalize: "off",
	                autocorrect: "off"
	            },
	            showCancelButton: true, 
	            confirmButtonText: '확인',
	            cancelButtonText: '취소'
	        });

	        console.log("입력된 비밀번호:", userPwd);

	        if (userPwd) {
	            const brdPwdStr = String(brdPwd).trim();
	            if (brdPwdStr === userPwd.trim()) {
	                document.bbsForm.brdSeq.value = brdSeq;
	                document.bbsForm.boardType.value = ${boardType};
	                document.bbsForm.action = "/board/view";
	                document.bbsForm.submit();
	            } else {

	                Swal.fire({
	                    title: "비밀번호가 틀렸습니다.",
	                    icon: "error",
	                    showConfirmButton: true,
	                    timer: 3000,
	                    timerProgressBar: true 
	                }).then(() => {
	                    document.bbsForm.action = "/board/list";
	                    document.bbsForm.submit();
	                });
	            }
	        } else {
	            Swal.fire("비밀번호 입력을 취소했습니다.");
	        }
	    } else {
	        document.bbsForm.brdSeq.value = brdSeq;
	        document.bbsForm.action = "/board/view";
	        document.bbsForm.submit();
	    }
	}

	
   // 네비게이션 and 게시판 메뉴바의 카테고리 클릭 시 실행
   function fn_list(boardType) {
	   
      document.bbsForm.curPage.value = "1";
      document.bbsForm.searchType.value = "";
      document.bbsForm.searchValue.value = "";
      document.bbsForm.boardType.value = boardType;
      document.bbsForm.action = "/board/list";
      document.bbsForm.submit();
   }
	
	function fn_listview(curPage) {
		document.bbsForm.curPage.value = curPage;
		document.bbsForm.brdSeq.value = "";
		document.bbsForm.action = "/board/list";
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
	<div class="main-container">
		<div class="title-container">
			<h1>${boardTitle}</h1>
		</div>

		<div class="list-container">
			<div class="menu-container">
				<ul>
					<li><a href=# class="${boardType == 1 ? 'active' : ''}" onclick="fn_list(1)">공지사항</a></li>
					<li><a href=# class="${boardType == 2 ? 'active' : ''}" onclick="fn_list(2)">자유 게시판</a></li>
					<li><a href=# class="${boardType == 3 ? 'active' : ''}" onclick="fn_list(3)">전시 게시판</a></li>
					<li><a href=# class="${boardType == 4 ? 'active' : ''}" onclick="fn_list(4)">문의사항</a></li>
				</ul>
			</div>


			<div class="board-container">
<c:if test="${boardType ne 3}">
				<table>
					<thead>
						<tr>
							<th style="width: 10%">NO</th>
							<th style="width: 55%">제목</th>
							<th style="width: 10%">작성자</th>
							<th style="width: 15%">날짜</th>
							<th style="width: 10%">조회수</th>
						</tr>
					</thead>
					
<c:if test='${!empty list}'>
	<c:forEach var="Board" items="${list}" varStatus="status">
		<tbody>
			<tr>
				<c:choose>
					<c:when test="${Board.brdIndent eq 0}">
						<td>${Board.brdSeq}</td>
					</c:when>
					<c:otherwise>	      
						<td><img src="/resources/images/right-arrow.png" style="margin-left:${Board.brdIndent}em; width: 15px;" /></td>
					</c:otherwise>		
				</c:choose>

				<!-- 비밀번호가 있을 때 '비밀글입니다'로 표시 -->
				<td style="cursor:pointer;" onclick="fn_viewPwd(${Board.brdSeq}, ${Board.brdPwd})" >
					<c:if test="${not empty Board.brdPwd}">
						🔒 비밀글입니다
					</c:if>
					<c:if test="${empty Board.brdPwd}">
						${Board.brdTitle}
					</c:if>
				</td>

				<td>${Board.userName}</td>
				<td>${Board.regDate}</td>
				<td>${Board.brdReadCnt}</td>
			</tr>
		</tbody>
	</c:forEach>
</c:if>
				
					<tfoot>
<c:if test='${empty list}'>
					<tbody>
						<tr>
							<td colspan="5">작성된 게시글이 없습니다.</td>
						</tr>
					</tbody>
</c:if>
					</tfoot>
			
				</table>
</c:if>


<c:if test="${boardType eq 3}">
					<c:if test="${!empty list}">
					   <div class="exhibi-container">
					      <c:forEach var="board" items="${list}" varStatus="status">
					         <div class="exhibi-item-box" onclick="fn_view(${board.brdSeq})">
					            <div class="exhibi-img">
					               <img alt="" src="/resources/upload/${board.fileName}" onerror="this.onerror=null; this.src='/resources/images/default-img.jpg';" style="cursor: pointer;">
					            </div>
					            <div class="exhibi-title">
					               <div><span>${board.brdTitle}</span></div>
					            </div>
					         </div>
					      </c:forEach>
					   </div>
					</c:if>
</c:if>
			</div>

<c:if test="${boardType eq 2 or boardType eq 4}">

			<div class="writeBtn-container">
				<button type="button" id="writeBtn" class="writeBtn" onclick="fn_write(${boardType})">글쓰기</button>
			</div>

</c:if>
<c:if test="${(boardType eq 1 or boardType eq 3) and user.rating eq 1}">
	<div class="writeBtn-container">
		<button type="button" id="writeBtn" class="writeBtn" onclick="fn_write(${boardType})">글쓰기</button>
	</div>
</c:if>
			<nav>
				<ul class="pagination">

<c:if test="${!empty paging}">
	<c:if test="${paging.prevBlockPage gt 0}">
					<li class="page-item"><a class="page-link" href="#" onclick="fn_listview(${paging.prevBlockPage})"> <img alt="" src="/resources/images/prev.png" style="margin-left: -4px;">
					</a></li>
	</c:if>
	
	
	<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
	
		<c:choose>
						
			<c:when test="${i ne curPage}">
				<li class="page-item"><a class="page-link" href="#" onclick="fn_listview(${i})">${i}</a></li>
			</c:when>
			
			<c:otherwise>
				<li class="page-item active"><a class="page-link" href="#" style="cursor: default;">${i}</a></li>
			</c:otherwise>
			
		</c:choose>
		
	</c:forEach>
	
	
	<c:if test="${paging.nextBlockPage gt 0}">
					<li class="page-item"><a class="page-link" href="#" onclick="fn_listview(${paging.nextBlockPage})"> <img alt="" src="/resources/images/next.png" style="margin-right: -6px;">
					</a></li>
	</c:if>
</c:if>
				</ul>
			</nav>

			<div class="searchBar">
				<select name="_searchType" id="_searchType" class="custom-box" style="width: auto;">
					<option value="">조회 항목</option>
					<option value="1" <c:if test='${searchType eq "1"}'>selected</c:if>>작성자</option>
					<option value="2" <c:if test='${searchType eq "2"}'>selected</c:if>>제목</option>
					<option value="3" <c:if test='${searchType eq "3"}'>selected</c:if>>내용</option>
				</select>
				<input type="text" name="_searchValue" id="_searchValue" class="custom-box" maxlength="20" style="ime-mode: active;" value="${searchValue}" size="40" placeholder="조회값을 입력하세요." />
				<button type="button" id="btnSearch" class="custom-box">
					<img alt="검색 버튼" src="/resources/images/search.png" style="height: 18px;">
				</button>
			</div>
		</div>
	</div>

	<!-- 푸터 영역 -->
	<%@ include file="/WEB-INF/views/include/footer.jsp"%>


	<form id="bbsForm" name=bbsForm method="post">
		<input type="hidden" name="boardType" value="${boardType}">
		<input type="hidden" name="brdSeq" value="">
   		<input type="hidden" name="searchType" value="${searchType}">
   		<input type="hidden" name="searchValue" value="${searchValue}">
   		<input type="hidden" name="curPage" value="${curPage}">
	</form>
</body>
</html>