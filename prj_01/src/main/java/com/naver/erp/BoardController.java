package com.naver.erp;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller

public class BoardController {


	// 12/16 오후 7시 05분 상경 워크스페이스 얼림확인.
	
	//+++++++++++++++++++++++++++++++++++++++
	// <입사 시험문제 타켓>
	// BoardDAO 인터페이스 구현한 클래스를 찾아서 객체화 해서  속변 boardDAO 에 객체의 메위주를 저장.
	// BoardDAO 인터페이스 구현한 클래스를 찾을때 그 클래스의 이름은 무었이든 상관없다.
	// 단 BoardDAO 인터페이스 구현한 클래스는 한개만 만들어야한다.
	// <주의> 관용적으로 클래스 이름에 DAO 가 들어 있으면 직접 DB 연동을 하는 메소드를 소유한 클래스이다.
	//+++++++++++++++++++++++++++++++++++++++
	@Autowired
	private BoardDAO boardDAO;
	
	

	//+++++++++++++++++++++++++++++++++++++++
	// <입사 시험문제 타켓>
	// BoardService 인터페이스 구현한 클래스를 찾아서 객체화 해서  속변 boardService 에 객체의 메위주를 저장.
	// BoardService 인터페이스 구현한 클래스를 찾을때 그 클래스의 이름은 무었이든 상관없다.
	// 단 BoardService 인터페이스 구현한 클래스는 한개만 만들어야한다.
	// <주의> 관용적으로 클래스 이름에 DAO 가 들어 있으면 직접 DB 연동을 하는 메소드를 소유한 클래스이다.
	//+++++++++++++++++++++++++++++++++++++++
	@Autowired
	private BoardService  boardService;
	
	
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// 가상주소 /boardList.do 로 접근하면 호출되는 메소드 선언
	//		@RequestMapping 내부에, method="ReqeustMethod.POST  가 없으므로
	//		가상주소 /boardList.do로 접근 시 get 또는 post 방식 접근 모두 허용한다.
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	@RequestMapping( value="/boardList.do")
	public ModelAndView boardList( 
		BoardSearchDTO 	boardSearchDTO
		
	){
		
	   
		//*******************************************
		// 게시판의 총개수 구하기. 검색물의 총개수가 아닌 모든 총개수 구하기
		//*******************************************
			// BoardDAOImpl 객체의 getBoardListAllTotCnt 메소드 호출하여 게시판의 총개수 구하기
		int boardAllTotCnt =  this.boardDAO.getBoardListAllTotCnt(  );

		//*******************************************
		// 게시판의 검색 결과물의 총개수 구하기. 검색된 놈의 총개수 구하기
		//*******************************************
		int boardTotCnt =  this.boardDAO.getBoardListTotCnt( boardSearchDTO );

		
		
		
		//*******************************************
		// 페이징 처리 관련 데이터와 기타 데이터(DB 연동시 필요한 데이터,보정된 선택 페이지 번호 등)가 저장된 HashMap 객체 얻기
		// Util 객체의 getPagingMap 라는 메소드 호출로 얻는다.
		//*******************************************
		Map<String,Integer> pagingMap = Util.getPagingMap(
				boardSearchDTO.getSelectPageNo()       // 선택한 페이지 번호
				, boardSearchDTO.getRowCntPerPage()    // 한 화면에 보여지는 행의 개수
				, boardTotCnt                          // 검색된 게시판의 총개수
		);

		//*******************************************
		// BoardSearchDTO 객체의 selectPageNo 속성변수 보정된 선택페이지 번호 재 저장하기
		// BoardSearchDTO 객체의 begin_rowNo 속성변수에 검색 결과물에서 페이지번호 맞게 부분을 가져올 때 시작행 번호를 저장하기
		// BoardSearchDTO 객체의 end_rowNo 속성변수에 검색 결과물에서 페이지번호 맞게 부분을 가져올 때 끝행 번호를 저장하기
		//*******************************************
		boardSearchDTO.setSelectPageNo( (int)pagingMap.get("selectPageNo")  );
		boardSearchDTO.setBegin_rowNo( (int)pagingMap.get("begin_rowNo")  ); 
		boardSearchDTO.setEnd_rowNo( (int)pagingMap.get("end_rowNo")  );

		
		
		
		
		
		//*******************************************
		// 검색된 게시판의 목록을 얻기
		//*******************************************
		List<Map<String,String>> boardList =  this.boardDAO.getBoardList( boardSearchDTO );
		
		//*******************************************
		// [ModelAndView 객체] 생성하기
		// [ModelAndView 객체]에 [게시판 목록 검색 결과]를 저장하기
				// [ModelAndView 객체]에 저장된 객체는  [HttpServletRequest 객체] 에도 저장된다.
		// [ModelAndView 객체]에 [게시판 목록 검색 결과 개수]를 저장하기
		// [ModelAndView 객체]에 [게시판 목록 총 개수]를 저장하기
		// [ModelAndView 객체]에 [페이징 처리 관련 HashMap 객체]를 저장하기
		// [ModelAndView 객체]에 [보정된 선택페이지 번호]를 저장하기
		//*******************************************
		ModelAndView mav = new ModelAndView();
		mav.addObject(  "boardList" , boardList );
		mav.addObject(  "boardTotCnt" , boardTotCnt );
		mav.addObject(  "boardAllTotCnt" , boardAllTotCnt );
		mav.addObject(  "pagingMap" , pagingMap );
		
		mav.addObject(  "selectPageNo" , (int)pagingMap.get("selectPageNo") );
		
		//*******************************************
		// [ModelAndView 객체]의 setViewName 메소드 호출하여  
		// [호출할 JSP 페이지명]을 문자로 저장하기
		// [호출할 JSP 페이지명] 앞에 붙는 위치 경로는 
		// application.properties   에서 
		// spring.mvc.view.prefix=/WEB-INF/views/     에 설정한다.
		// [호출할 JSP 페이지명] 뒤에 붙는 확장자는 
		// application.properties   에서 
		// spring.mvc.view.suffix=.jsp     에 설정한다. 근데 이거는 여기서 생략했다.
		// <참고>기본적으로 저장 경로에서 webapp 폴더까지는 자동으로 찾아간다. (정민규 주석작품)
		//*******************************************
		mav.setViewName( "boardList.jsp" );
		//*******************************************
		// [ModelAndView 객체] 리턴하기
		//*******************************************
			// 스프링은 [ModelAndView 객체] 리턴하면 이 객체 안의
			// 저장된 [JSP 페이지명]에 해당하는 [JSP 페이지]를 호출한다.
		return  mav;
	}


	
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// 가상주소 /boardRegForm.do 로 접근하면 호출되는 메소드 선언
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	@RequestMapping( value="/boardRegForm.do")
	public ModelAndView boardRegForm( HttpServletRequest request ){
		//*******************************************
		// [ModelAndView 객체] 생성하기
		// [ModelAndView 객체]에 [호출 JSP 페이지명]을 저장하기
		// [ModelAndView 객체] 리턴하기
		//*******************************************
		ModelAndView mav = new ModelAndView( );
		mav.setViewName( "boardRegForm.jsp");
		return mav;
	}
	
	
	
	
	
	
	
	
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// /boardRegProc.do 로 접근하면 호출되는 메소드 선언하기
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	@RequestMapping( 
			value="/boardRegProc.do" 
			,method=RequestMethod.POST
			,produces="application/json;charset=UTF-8"
	)
	@ResponseBody
	public int boardRegProc(    
			// 파라미터값을 저장할 [BoardDTO 객체]를 매개변수로 선언
			BoardDTO boardDTO
			,@RequestParam(value = "subject") String subject
            ,@RequestParam(value = "content") String content
			// [파라미터명]과 [BoardDTO 객체]의 [속성변수명]이 같을 경우
			// setter 메소드가 작동되어 [파라미터값]이 [속성변수]에 저장된다.		
	){
			
		int	boardRegCnt = this.boardService.insertBoard(boardDTO);
		
		return boardRegCnt;
	}
	
			

	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// /boardDetailForm.do 접속 시 호출되는 메소드 선언
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	@RequestMapping( value="/boardDetailForm.do" )
	public ModelAndView boardDetailForm( 	
			//---------------------------------------
			// "b_no" 라는 파라미터명의 파라미터값이 저장되는 매개변수 b_no 선언
			// 싱세보기할 게시판 고유 번호가 들어오는 매개변수선언
			//---------------------------------------
			@RequestParam(value="b_no") int b_no
			,HttpServletRequest request	        
	){
		//System.out.println( "BoardController.boardDetailForm 메소 호출 시작!");
		//*******************************************
		// [BoardServiceImpl 객체]의 getBoard 메소드 호출로 [1개의 게시판 글]을 BoardDTO 객체에 담아오기
		//*******************************************
		BoardDTO boardDTO = this.boardService.getBoard(b_no,true);  
		
		String referer = request.getHeader("referer");
		
		//*******************************************
		// [ModelAndView 객체] 생성하기
		// [ModelAndView 객체]에 [호출 JSP 페이지명]을 저장하기
		// [ModelAndView 객체]에 1개의 게시판 글을 저장한 BoardDTO 객체 저장하기
		//*******************************************
		ModelAndView mav = new ModelAndView( );
		mav.setViewName( "boardDetailForm.jsp");
		mav.addObject("boardDTO", boardDTO);
		mav.addObject("referer", referer);

		//System.out.println( "BoardController.boardDetailForm 메소 호출 종료!");
		//*******************************************
		// [ModelAndView 객체] 리턴하기
		//*******************************************
		return mav;
	}
	
	
	
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// /boardUpDelForm.do 접속 시 호출되는 메소드 선언
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	@RequestMapping(value="boardUpDelForm.do" )
	public ModelAndView boardUpDelForm( 
			//---------------------------------------
			// "b_no" 라는 파라미터명의 파라미터값이 저장되는 매개변수 b_no 선언
			// 수정 또는 삭제할 게시판 고유 번호가 들어오는 매개변수선언
			//---------------------------------------
			@RequestParam(value="b_no") int b_no
			,HttpServletRequest request	 
	) {
		//*******************************************
		// [BoardServiceImpl 객체]의 getBoard 메소드 호출로 [1개의 게시판 글]을 BoardDTO 객체에 담기
		//*******************************************
		BoardDTO boardDTO = this.boardService.getBoard(b_no,false);  
		String referer = request.getHeader("referer");
		//*******************************************
		// [ModelAndView 객체] 생성하기
		// [ModelAndView 객체]에 [호출 JSP 페이지명]을 저장하기
		// [ModelAndView 객체]에 BoardDTO 객체 저장하기
		//*******************************************
		ModelAndView mav = new ModelAndView( );
		mav.setViewName("boardUpDelForm.jsp");
		mav.addObject("boardDTO",boardDTO);
		mav.addObject("referer", referer);
		//*******************************************
		// [ModelAndView 객체] 리턴하기
		//*******************************************
		return mav;
	}
	
		
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// /boardUpProc.do.do 로 접근하면 호출되는 메소드 선언하기
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	@RequestMapping( 
			value="/boardUpProc.do" 
			,method=RequestMethod.POST
			,produces="application/json;charset=UTF-8"
	)
	@ResponseBody
	public int boardUpProc( 
			//*******************************************
			// 파라미터값을 저장할 [BoardDTO 객체]를 매개변수로 선언
			//*******************************************
			BoardDTO boardDTO
	) {
		System.out.println( "boardDTO.getB_no() => " + boardDTO.getB_no() );
		//-----------------------------------------------------
		// BoardServeImpl 객체의 updateBoard 메소드 호출로 업데이트된 행의 개수얻기
		//-----------------------------------------------------
		int updateBoardcnt = this.boardService.updateBoard(boardDTO);
		//-----------------------------------------------------
		// 업데이트된 행의 개수 리턴하기
		//-----------------------------------------------------
		return updateBoardcnt;
	}
	
	
	

	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// /boardDelProc.do 로 접근하면 호출되는 메소드 선언하기
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	@RequestMapping( 
			value="/boardDelProc.do" 
			,method=RequestMethod.POST
			,produces="application/json;charset=UTF-8"
	)
	@ResponseBody
	public int boardDelProc( 
			//*******************************************
			// 파라미터값을 저장할 [BoardDTO 객체]를 매개변수로 선언
			//*******************************************
			BoardDTO boardDTO
	) {

		//-----------------------------------------------------
		// BoardServeImpl 객체의 deleteBoard 메소드 호출로 게시판글을 삭제하고 삭제된 행의 개수얻기
		//-----------------------------------------------------
		int deleteBoardcnt = this.boardService.deleteBoard(boardDTO);
		//-----------------------------------------------------
		// 업데이트된 행의 개수 리턴하기
		//-----------------------------------------------------
		return deleteBoardcnt;
	}
	

	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	// 게시판 입력 또는 수정 시 게시판 입력글의 입력양식의 유효성을 검사하고 
	// 문제가 있으면 경고 문자를 리턴하는 메소드 선언.
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	public String check_BoardDTO( BoardDTO boardDTO, BindingResult bindingResult , String upRegMode ){
		String msg = "";
		//*******************************************
		// BoardDTO 객체에 저장된 데이터의 유효성 체크할 BoardValidator 객체 생성하기
		// BoardValidator 객체의 validate 메소드 호출하여 유효성 체크 실행하기.
		//*******************************************
		BoardValidator boardValidator = new BoardValidator(upRegMode);
		boardValidator.validate(
				boardDTO           // 유효성 체크할 DTO 객체
				, bindingResult    // 유효성 체크 결과를 관리하는 BindingResult 객체
		);
		//*******************************************
		// 만약 BindingResult 객체의 hasErrors() 메소드 호출하여 true 값을 얻으면
		//*******************************************
		if( bindingResult.hasErrors() ) {
			// 변수 msg 에 BoardValidator 객체에 저장된 경고문구 얻어 저장하기
			msg = bindingResult.getFieldError().getCode();
		}
		//*******************************************
		// msg 안의 문자 리턴하기
		//*******************************************
		return msg;
	}
	
	
	
	
	
	
	
	
//////////////////////////////////////////////////////////////////////////////////
}  // BoardController 클래스 닫기
//////////////////////////////////////////////////////////////////////////////////
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
