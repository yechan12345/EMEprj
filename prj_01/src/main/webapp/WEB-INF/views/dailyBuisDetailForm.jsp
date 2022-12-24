<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.naver.erp.Next_App_Emp_List" %>    
<%@ page import="java.util.*" %>    


<%ArrayList<Next_App_Emp_List> next_app_list = (ArrayList<Next_App_Emp_List>)request.getAttribute("next_app_list"); %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
		<script src="/ckeditor/ckeditor.js"></script>
		<script src="/ckeditor/ko.js"></script>
		<title>일일보고서 상세보기 화면</title>	
		<link rel="stylesheet" href="/css/main.css" />
		<!-- ******************************************************** -->
		<!--  JQuery 라이브러리 수입하기 -->
		<!-- ******************************************************** -->
		<script src="/js/jquery-1.11.0.min.js"></script>
		<script type="text/javascript" src="/resources/ckeditor/ckeditor.js"></script>


    	<script>
    		$(function(){
				//로그아웃
				$(".logoutBtn").click(
				function(){
					if( confirm("로그아웃 하시겠습니까?")==false ) { return; }
					location.replace("/logout.do");
				});					

				
    			var formObj = $("[name=dailyBusiAppYesNoForm]");

    			var approval_yesNo = formObj.find(".approval_yesNo_tr")
    			var next_app_yesOrNoObj = $(".next_app_No");	
    			//-----------------------------------------------------------------------------------------------------
    			// 로그인한 사원번호와 작성한 업무보고서의 사원번호가 같으면
    			//-----------------------------------------------------------------------------------------------------
    			if("${requestScope.dailyBusiDTO.emp_no}"=="${sessionScope.uid}"){
    				$(".approval_yesNoBtn").remove(); //[결재/반려 버튼] 삭제
    				approval_yesNo.remove();	// 라디오박스 결재/반려 삭제

        			document.getElementById('next_app_emp_no').disabled = true; // 다음 결재자 비활성화
        			document.getElementById('next_app_No').disabled = true;	// 체크박스 [다음결재자 없음] 비활성화
        			if("${requestScope.lastAppMan.last_sign_code}"==0){
        				$(".next_app_emp_no").val("${requestScope.nextAppMan.next_emp_no}");
    					$(".button_span").prepend("<h2>최종 결재 완료된 보고서입니다.</h2>");
        			}
        			else if("${requestScope.lastAppMan.last_sign_code}"==-1){
    					$(".button_span").prepend("<h2>결재 진행중인 보고서입니다.</h2>");
    					$(".next_app_emp_no").val("${requestScope.nextAppMan.next_emp_no}");
        			}
        			else if("${requestScope.lastAppMan.last_sign_code}"==1){
                        $(".next_app_emp_no").val("${requestScope.nextAppMan.next_emp_no}");
        				if("${requestScope.nextAppMan.next_sign_code}"==1){
                            $(".button_span").prepend("<input type='button' value='수정' class='alterBtn' name='alterBtn'>");
                            document.getElementById('busi_content').disabled = false;
                            document.getElementById('busi_type_code').disabled = false;
                			document.getElementById('min_year').disabled = false;
                			document.getElementById('min_month').disabled = false;
                			document.getElementById('min_date').disabled = false;
                			document.getElementById('min_hour').disabled = false;
            	    		document.getElementById('min_minute').disabled = false;	
                			document.getElementById('max_year').disabled = false;
                			document.getElementById('max_month').disabled = false;
                			document.getElementById('max_date').disabled = false;
                			document.getElementById('max_hour').disabled = false;
                			document.getElementById('max_minute').disabled = false;
                			            				                   				           				
                            
                        }
                        else{
                            $(".button_span").prepend("<h2>결재 진행중인 보고서입니다.</h2>");
                        }
        			}
    			}
    			
    			
    			
	
    			//-----------------------------------------------------------------------------------------------------
    			//-----------------------------------------------------------------------------------------------------
    			//생성된 수정버튼을 누르면	
    			//-----------------------------------------------------------------------------------------------------
    			$(".alterBtn").click(function(){ 
    				var formObj = $("[name=dailyBusiAppYesNoForm]");
    				
    				var startDateObj = formObj.find("[name=busi_start_date]"); // 시작날짜
    				var endDateObj = formObj.find("[name=busi_end_date]"); // 끝날짜
    				var emp_no = formObj.find("[name=emp_no]");		// 세셔에서 가져온 로그인한 사원번호
    				var busiType = formObj.find("[name=busi_type_code]"); // 업무분야 코드 
    				var busi_content = formObj.find("[name=busi_content]"); // 업무내용 
    				var next_app_emp_no = formObj.find("[name=next_app_emp_no]"); // 다음 결재자
    				
    				
    				//-------------------------------------------------------------
    				// 업무분야 유효성 검사
    				var busiTypeVal = busiType.val();
    				if( busiTypeVal == "" ){
    					alert("업문분야를 선택해야 합니다.");
    					busiType.focus();
    					return;
    				}
    				//-------------------------------------------------------------
    				// 업무내용 유효성 검사
    				var busi_contentVal = busi_content.val();
    				if( typeof(busi_contentVal)!="string" ){busi_contentVal="";}
    				busi_contentVal = busi_contentVal.trim();
    				busi_content.val(busi_contentVal);
    				
    				if( busi_contentVal.length==0 ){
    					alert("내용을 입력해야 합니다.");
    					busi_content.val("");
    					busi_content.focus();
    					return;
    				}
    				//-------------------------------------------------------------
    				// 날짜 유효성 검사
    				var formObj = $("[name='dailyBusiAppYesNoForm']");
    				//-------------------------------------------------------------
    				var min_yearVal = formObj.find(".min_year").val();
    				var min_monthVal = formObj.find(".min_month").val();
    				var min_dateVal = formObj.find(".min_date").val();
    				var min_hourVal = formObj.find(".min_hour").val();				
    				var min_minuteVal = formObj.find(".min_minute").val();				
    				//-----------------------------------------------------
    				var max_yearVal = formObj.find(".max_year").val();
    				var max_monthVal = formObj.find(".max_month").val();
    				var max_dateVal = formObj.find(".max_date").val();
    				var max_hourVal = formObj.find(".max_hour").val();				
    				var max_minuteVal = formObj.find(".max_minute").val();	
    				//-----------------------------------------------------
    				if( min_yearVal=="" || min_monthVal=="" || min_dateVal=="" || min_hourVal=="" || min_minuteVal=="" ||
    						max_yearVal=="" || max_monthVal=="" || max_dateVal=="" || max_hourVal=="" || max_minuteVal=="" ){
    					alert("업무시간을 모두 작성해주십시오.");
    					return;
    				}
    			
    				
    				var startDateObj = formObj.find("[name=busi_start_date]");
    				var endDateObj = formObj.find("[name=busi_end_date]");
    				var min_yearVal = formObj.find(".min_year").val();
    				var min_monthVal = formObj.find(".min_month").val();
    				var min_dateVal = formObj.find(".min_date").val();
    				var min_hourVal = formObj.find(".min_hour").val();				
    				var min_minuteVal = formObj.find(".min_minute").val();				
    				//-----------------------------------------------------
    				var max_yearVal = formObj.find(".max_year").val();
    				var max_monthVal = formObj.find(".max_month").val();
    				var max_dateVal = formObj.find(".max_date").val();
    				var max_hourVal = formObj.find(".max_hour").val();				
    				var max_minuteVal = formObj.find(".max_minute").val();	
    				
    				if( min_yearVal!="" && min_monthVal!="" ){
    					startDateObj.val( min_yearVal + "-" + min_monthVal + "-"  + min_dateVal + "-" + min_hourVal + "-" + min_minuteVal);
    				}
    				if( max_yearVal!="" && max_monthVal!="" ){
    					endDateObj.val( max_yearVal + "-" + max_monthVal + "-" + max_dateVal+ "-" + max_hourVal+ "-" + max_minuteVal);
    				}
    				
					$(".button_span").prepend("<input type='hidden' value='${requestScope.nextAppMan.next_emp_no}' name='next_app_emp_no'>");
    				$(".next_app_emp_no").val("${requestScope.nextAppMan.next_emp_no}");
					$.ajax({
						url:"/dailyAlterProc.do"	
						,type:"post"
						,data:$("[name='dailyBusiAppYesNoForm']").serialize()
						,success:function(regCnt){
							if(regCnt==1){
								alert("업무일지 수정 성공");
								location.replace("/dailyListForm.do")
							}
						}
						,error:function(){
							alert("웹서버 접속 실패! 관리자에게 문의 바람");
						}					
					})
    				
    			})
    			
    			
    			

    			//-----------------------------------------------------------------------------------------------------
    			// 로그인한 사원번호와 작성한 업무보고서의 사원번호가 다르고
    			// 작성한 업무보고서의 결재코드가 -1이 아니면 즉 미결재가 아니면
    			//-----------------------------------------------------------------------------------------------------
    			if(("${requestScope.dailyBusiDTO.emp_no}"!="${sessionScope.uid}") && ("${requestScope.dailyBusiDTO.sign_code}"=="1"||"${requestScope.dailyBusiDTO.sign_code}"=="0")){
        			document.getElementById('next_app_emp_no').disabled = true;
    				approval_yesNo.remove();
    				$(".approval_yesNoBtn").remove();
    				if("${requestScope.dailyBusiDTO.sign_code}"==1){
    					$(".button_span").prepend("<h2>반려되어 결재할 수 없습니다.</h2>");
    					$(".next_app_emp_no").val("${requestScope.nextAppMan.next_emp_no}");
            			document.getElementById('next_app_No').disabled = true;
    				}
    				else if("${requestScope.dailyBusiDTO.sign_code}"==0 && "${requestScope.dailyBusiDTO.sign_code}"!="${requestScope.lastAppMan.last_sign_code}"){
    					$(".button_span").prepend("<h2>결재한 보고서 입니다.</h2>");
    					$(".next_app_emp_no").val("${requestScope.nextAppMan.next_emp_no}");
            			document.getElementById('next_app_No').disabled = true;
    				}
    				else if("${requestScope.dailyBusiDTO.sign_code}"==0 && "${requestScope.dailyBusiDTO.sign_code}"=="${requestScope.lastAppMan.last_sign_code}"){
    					$(".button_span").prepend("<h2>최종 결재 완료된 보고서입니다.</h2>");
    					$(".next_app_emp_no").val("${requestScope.nextAppMan.next_emp_no}");
            			document.getElementById('next_app_No').disabled = true;
    				}
    				
    			}   
    
    			//===========================================================================================================================================================================
                //===========================================================================================================================================================================
                if(("${requestScope.dailyBusiDTO.emp_no}"!="${sessionScope.uid}") && ("${requestScope.dailyBusiDTO.sign_code}"=="-1"&&"${requestScope.lastAppMan.last_sign_code}"=="1")){
                    //alert("${requestScope.nextAppManEmp_no}")
                     $(".next_app_emp_no").val("${requestScope.nextAppManEmp_no}");
                    $("select[name=next_app_emp_no]").attr('onFocus', 'this.initialSelect = this.selectedIndex;');
                    $("select[name=next_app_emp_no]").attr('onChange', 'this.selectedIndex = this.initialSelect;');
                    $("[name=next_app_emp_no]").change(function(){
                        alert("결재순서에 맞게 선택되어야 합니다.");
                        $(".next_app_emp_no").val("${requestScope.nextAppManEmp_no}");
                    }) 
                    
                    if("${requestScope.dailyBusiDTO.emp_no}"!="${requestScope.lastAppMan.emp_no}"){
                    	document.getElementById('next_app_No').disabled = true;	
                    }


                }
                //===========================================================================================================================================================================
                //===========================================================================================================================================================================
    			
    			
    			//-----------------------------------------------------------------------------------------------------
    			//  결재/반려 버튼이 바뀌면 실행되는 함수
    			//-----------------------------------------------------------------------------------------------------
    			formObj.find("[name=approval_yesNo]").change(function(){
				    var approval_yesNo = $(":input:radio[name=approval_yesNo]:checked").val();	
				    
				    if(approval_yesNo==1){
	        			document.getElementById('next_app_emp_no').disabled = true;	
	        			next_app_yesOrNoObj.prop("checked",true);
	        			document.getElementById('next_app_No').disabled = true;	
	        			$(".next_app_emp_no").val("");
	        			$(".approval_yesNo_td").append("<textarea name='return_result' placeholder='반려사유작성'></textarea>");	    	
				    }
				    else if(approval_yesNo==0){ 
				    	if(("${requestScope.dailyBusiDTO.emp_no}"!="${sessionScope.uid}") && ("${requestScope.dailyBusiDTO.sign_code}"=="-1"&&"${requestScope.lastAppMan.last_sign_code}"=="1")){
		                    //alert("${requestScope.nextAppManEmp_no}")
		                    $(".next_app_emp_no").val("${requestScope.nextAppManEmp_no}");
		                    $("select[name=next_app_emp_no]").attr('onFocus', 'this.initialSelect = this.selectedIndex;');
		                    $("select[name=next_app_emp_no]").attr('onChange', 'this.selectedIndex = this.initialSelect;');
		                    $("[name=next_app_emp_no]").change(function(){
		                        alert("결재순서에 맞게 선택되어야 합니다.");
		                        $(".next_app_emp_no").val("${requestScope.nextAppManEmp_no}");
		                        

		                    }) 		                    		                    
		                }
	        			document.getElementById('next_app_emp_no').disabled = false;
	        			next_app_yesOrNoObj.prop("checked",false);
	        			document.getElementById('next_app_No').disabled = false;	
	        			$(".approval_yesNo_td").find("[name=return_result]").remove();
	        			
		                   if("${sessionScope.uid}"!="${requestScope.lastAppMan.last_emp_no}"){
		                   		document.getElementById('next_app_No').disabled = true;	
		                   } 
				    }
				    

                    
    				
    			})
    			
    			//-----------------------------------------------------------------------------------------------------
    			// 다음결재자 없음을 누르면 벌어지는일
    			//-----------------------------------------------------------------------------------------------------
    			next_app_yesOrNoObj.change(function(){
				    
    				
    				if(next_app_yesOrNoObj.prop("checked")){
	        			document.getElementById('next_app_emp_no').disabled = true;	
	        			$(".next_app_emp_no").val("");
	        			
    				}
    				if(next_app_yesOrNoObj.prop("checked")==false){
	        			document.getElementById('next_app_emp_no').disabled = false;
    				}

    			})


    			
				$(".salesListForm").click(function(){
					location.replace("/salesListForm.do");
				})
				$(".dailyListForm").click(function(){
					location.replace("/dailyListForm.do");
				})
				$(".expenseListForm").click(function(){
					location.replace("/expenseListForm.do");
				})
				$(".dashboard").click(function(){
					location.replace("/dashboard.do");
				})
    			
				// 업문분야 코드
    			 var busi_type_code = $("[name=busi_type_code]");
    			busi_type_code.val(${requestScope.dailyBusiDTO.busi_type_code});
    			/*document.getElementById('busi_type_code').disabled = true; */
    			//-----------------------------------------------------------------------------------------------------
    			// 날짜
    			//-----------------------------------------------------------------------------------------------------
    			var busi_start_date = "${requestScope.dailyBusiDTO.busi_start_date}"; 
    			var busi_end_date = "${requestScope.dailyBusiDTO.busi_end_date}"; 
    			
    			var min_year = busi_start_date.substr(0,4);
    			var min_month = busi_start_date.substr(5,2); 
    			var min_date = busi_start_date.substr(8,2); 
    			var min_hour = busi_start_date.substr(11,2); 
    			var min_minute = busi_start_date.substr(14,2);  

       			var max_year = busi_end_date.substr(0,4); 
       			var max_month = busi_end_date.substr(5,2);  
       			var max_date = busi_end_date.substr(8,2);  
       			var max_hour = busi_end_date.substr(11,2);  
       			var max_minute = busi_end_date.substr(14,2);  


       			formObj.find(".min_year").val(min_year); 
				formObj.find(".min_month").val(min_month);
				formObj.find(".min_date").val(min_date);
				formObj.find(".min_hour").val(min_hour);				
				formObj.find(".min_minute").val(min_minute);	
				//-----------------------------------------------------
				formObj.find(".max_year").val(max_year);
				formObj.find(".max_month").val(max_month);
				formObj.find(".max_date").val(max_date);
				formObj.find(".max_hour").val(max_hour);				
				formObj.find(".max_minute").val(max_minute);
    			
    			
    			//----------------------------------------------------------
    			// 결재/반려 결과
    			//----------------------------------------------------------
    			$(".approval_yesNoBtn").click(function(){
						         
    				
				    var approval_yesNo = $(":input:radio[name=approval_yesNo]:checked").val();

				    if(approval_yesNo==null){
				    	alert("결재/반려를 선택해주세요")
				    }
				    
				    var next_app_No = $(":input:checkbox[name=next_app_No]:checked").val();

				    var nextAppNo = $("[name=nextAppNoPerson]");
				    
				    if(next_app_No!=""){
				    	nextAppNo.val(next_app_No);
				    }
				    
				    // 라디오버튼 결재에 체크했으면
					if(approval_yesNo=="0"){		
						
						if($(".next_app_emp_no").val()=="" && next_app_yesOrNoObj.prop("checked")==false){
                            alert("다음결재자를 선택하거나 다음결재자없음을 선택해주세요.");
                            return;
                        }
						
						
						$.ajax({
							url:"/dailyUpdelProc.do"	
							,type:"post"
							,data:$("[name='dailyBusiAppYesNoForm']").serialize()
							,success:function(regCnt){
								if(regCnt==1){
									alert("업무일지 결재 성공");
									location.replace("/dailyListForm.do")
								}
							}
							,error:function(){
								alert("웹서버 접속 실패! 관리자에게 문의 바람");
							}
						
						})
						
						
					}
				    
					
				    
				    
					
				    // 라디오버튼 반려에 체크했으면
					if(approval_yesNo=="1"){	
						$.ajax({
							url:"/dailyUpdelProc.do"	
							,type:"post"
							,data:$("[name='dailyBusiAppYesNoForm']").serialize()
							,success:function(regCnt){
								if(regCnt>0){
									alert("업무일지 반려 성공");
									location.replace("/dailyListForm.do")
								}
								else{
									alert(regCnt);
								}
							}
							,error:function(){
								alert("웹서버 접속 실패! 관리자에게 문의 바람");
							}
						
						})
					}
					
					
    			})
    		})
    		
    			//-------------------------------------------------------------
				// 유효한 날짜 세팅 함수
				 function setYMD( formName,yearName,monthName,dateName){
		                try{
		                    var formObj = $("[name='"+formName+"']");
		                    if(formObj.length==0){
		                        alert("setYMD 함수 호출 시 1번째 매개변수로 들어온 form 태그의 name 값이 없습니다.");
		                        return;
		                    }
		                    var yearObj = formObj.find("[name='"+yearName+"']");
		                    var monthObj = formObj.find("[name='"+monthName+"']");
		                    var dateObj = formObj.find("[name='"+dateName+"']");

		                    var year = yearObj.val();
		                    var month = monthObj.val();
		                    var date = dateObj.val();

		                    if( year!="" && month!=""){
		                        year = parseInt(year,10);
		                        month = parseInt(month,10);

		                        var last_date = new Date(year,month,0).getDate();

		                        dateObj.empty();
		                        dateObj.append("<option value=''>");
		                        for(var i=1; i<=last_date; i++){
		                            if(i<10){
		                                dateObj.append("<option value='0"+i+"'>0"+i);
		                            }
		                            else{
		                                dateObj.append("<option value='"+i+"'>"+i);
		                            }
		                        }
		                        if(date!=""){
		                            dateObj.val(date);
		                        }
		                    }
		                }
		                catch(e){
		                    alert("setYMD 함수 호출 시 예외발생!!"+e.message);
		                }
		            }
				//-------------------------------------------------------------
				// 날짜가 변경되는 실행되는 함수 
				function checkYMRange(){
					setYMD( "dailyBusiAppYesNoForm","min_year","min_month","min_date");
					setYMD( "dailyBusiAppYesNoForm","max_year","max_month","max_date");
					
					var now = new Date();

					var now_year = now.getFullYear();
					var now_month = now.getMonth()+1;
					if(now_month<10){now_month= "0"+now_month}
					var now_day = now.getDate();
					if(now_day<10){now_day= "0"+now_day}
					var now_hour = now.getHours();
					if(now_hour<10){now_hour= "0"+now_hour}
					var now_min = now.getMinutes();
					if(now_min<10){now_min= "0"+now_min}
					

					
					var formObj = $("[name='dailyBusiAppYesNoForm']");
					//---------------------------------------------
					var min_yearObj = formObj.find(".min_year");
					var min_monthObj = formObj.find(".min_month");
					var min_dateObj = formObj.find(".min_date");
					var min_hourObj = formObj.find(".min_hour");
					var min_minuteObj = formObj.find(".min_minute");
					
					var max_yearObj = formObj.find(".max_year");
					var max_monthObj = formObj.find(".max_month");
					var max_dateObj = formObj.find(".max_date");
					var max_hourObj = formObj.find(".max_hour");
					var max_minuteObj = formObj.find(".max_minute");
					//---------------------------------------------
					var min_yearVal = min_yearObj.val();
					var min_monthVal = min_monthObj.val();
					var min_dateVal = min_dateObj.val();
					var min_hourVal = min_hourObj.val();
					var min_minuteVal = min_minuteObj.val();
					
					var max_yearVal = max_yearObj.val();
					var max_monthVal = max_monthObj.val();
					var max_dateVal = max_dateObj.val();
					var max_hourVal = max_hourObj.val();
					var max_minuteVal = max_minuteObj.val();
					//-------------------------------------------------
					if( min_yearVal=="" && min_monthVal!="" ){
						alert("년도가 없으면 월을 선택할 수 없습니다.");
						min_monthObj.val("");
						return;
					}
					if( min_monthVal=="" && min_dateVal!="" ){
						alert("월이 없으면 일을 선택할 수 없습니다.");
						min_dateObj.val("");
						return;
					}
					if( min_dateVal=="" && min_hourVal!="" ){
						alert("일이 없으면 시간을 선택할 수 없습니다.");
						min_hourObj.val("");
						return;
					}
					if( min_hourVal=="" && min_minuteVal!="" ){
						alert("시간이 없으면 분을 선택할 수 없습니다.");
						min_minuteObj.val("");
						return;
					}
					
					//-------------------------------------------------
					
					if( max_yearVal=="" && max_monthVal!="" ){
						alert("년도가 없으면 월을 선택할 수 없습니다.");
						max_monthObj.val("");
						return;
					}
					if( max_monthVal=="" && max_dateVal!="" ){
						alert("월이 없으면 일을 선택할 수 없습니다.");
						max_dateObj.val("");
						return;
					}
					if( max_dateVal=="" && max_hourVal!="" ){
						alert("일이 없으면 시간을 선택할 수 없습니다.");
						max_hourObj.val("");
						return;
					}
					if( max_hourVal=="" && max_minuteVal!="" ){
						alert("시간이 없으면 분을 선택할 수 없습니다.");
						max_minuteObj.val("");
						return;
					}
					if( min_yearVal!="" && min_monthVal!=""	&& min_dateVal!=""	&& min_hourVal!=""	&& min_minuteVal!="" 
							&&  max_yearVal!="" && max_monthVal!="" && max_dateVal!="" && max_hourVal!="" && max_minuteVal!=""){
						
						if( min_yearVal+min_monthVal+min_dateVal+min_hourVal+min_minuteVal > max_yearVal+max_monthVal+max_dateVal+max_hourVal+max_minuteVal ){
							alert("업무 시작 날짜가 끝나는 날짜보다 크면 안 됩니다!");
							max_yearObj.val("");
							max_monthObj.val("");
							max_dateObj.val("");
							max_hourObj.val("");
							max_minuteObj.val("");
							return;
						}
						if( min_yearVal+min_monthVal+min_dateVal+min_hourVal+min_minuteVal > now_year+""+now_month+""+now_day+""+now_hour+""+now_min){
							alert("업무 시작 날짜가 현재 날짜보다 크면 안 됩니다!");
							min_yearObj.val("");
							min_monthObj.val("");
							min_dateObj.val("");
							min_hourObj.val("");
							min_minuteObj.val("");
							return;
						}
						if( max_yearVal+max_monthVal+max_dateVal+max_hourVal+max_minuteVal > now_year+""+now_month+""+now_day+""+now_hour+""+now_min){
							alert("업무 끝나는 날짜가 현재 날짜보다 크면 안 됩니다!");
							max_yearObj.val("");
							max_monthObj.val("");
							max_dateObj.val("");
							max_hourObj.val("");
							max_minuteObj.val("");
							return;
						}
					}
				}
    		
    		
    	</script>
	</head>
	<body class="is-preload">

		<!-- Wrapper -->
			<div id="wrapper">

				<!-- Main -->
					<div id="main">
						<div class="inner">

							<!-- Header -->
								<header id="header">
									<strong>일일업무보고서</strong>
									<span align="right"><strong> ${sessionScope.emp_name} ${sessionScope.jikup_name}님</strong></span>
									
								</header>

							<!-- Content -->
							<form name="dailyBusiAppYesNoForm">
								<section>
									<table border=1 cellpadding="5" cellspacing="1" >
										<tr>
											<th>작성자</td><td>${requestScope.dailyBusiDTO.emp_name} </th>
										</tr>
										<tr>
											<th>업무 분야</th>
											<td>
												<select name="busi_type_code" id="busi_type_code" disabled>
													<option value="">
													<option value="10">행정
													<option value="20">사무
													<option value="30">구매
													<option value="40">접대
													<option value="50">회계
													<option value="60">기타
												</select>
											</td>
										</tr>
										<tr>
											<th>업무 내용</th>
											<td>
												<textarea name="busi_content" rows="10" cols="25" id="busi_content" disabled>${requestScope.dailyBusiDTO.busi_content}</textarea>
											</td>
										</tr>
										<tr>
											<th>시간</th>
											<td>							
												<select class="min_year" id="min_year"  name="min_year"  onChange="checkYMRange()" disabled>
													<option value="">
													<option value="2022">2022
													<option value="2021">2021
													<option value="2020">2020
												</select>년
												<select  class="min_month" id="min_month"  name="min_month"  onChange="checkYMRange()" disabled>
													<option value="">
													<option value="01">01
													<option value="02">02
													<option value="03">03
													<option value="04">04
													<option value="05">05
													<option value="06">06
													<option value="07">07
													<option value="08">08
													<option value="09">09
													<option value="10">10
													<option value="11">11
													<option value="12">12
												</select>월
												<select  class="min_date" id="min_date" name="min_date" onChange="checkYMRange()" disabled> 
													<option value="">
													<%for( int i=1; i<32; i++) {%>
														<%if(i<10){ %>
															<option value="0<%= i %>">0<%= i %>
														<% } %>
														<% if(i>=10){ %>
															<option value="<%= i %>"><%= i %>
														<% } %>
																
													<% } %>		
												</select>일
												<select  class="min_hour" id="min_hour"  name="min_hour"  onChange="checkYMRange()" disabled>
													<option value="">
													<%for( int i=1; i<25; i++) {%>
														<%if(i<10){ %>
															<option value="0<%= i %>">0<%= i %>
														<% } %>
														<% if(i>=10){ %>
															<option value="<%= i %>"><%= i %>
														<% } %>
																
													<% } %>		
												</select>시
												<select  class="min_minute"  id="min_minute" name="min_minute" onChange="checkYMRange()" disabled>
													<option value="">
													<%for( int i=0; i<60; i++) {%>
														<%if(i<10){ %>
															<option value="0<%= i %>">0<%= i %>
														<% } %>
														<% if(i>=10){ %>
															<option value="<%= i %>"><%= i %>
														<% } %>
																
													<% } %>		
												</select>
												
												분 부터<div style="height:10px"></div>		
																			
												<select  class="max_year" id="max_year" name="max_year" onChange="checkYMRange()" disabled>
													<option value="">
													<option value="2022">2022
													<option value="2021">2021
													<option value="2020">2020
												</select>년
												<select  class="max_month" id="max_month" name="max_month"  onChange="checkYMRange()" disabled>
													<option value="">
													<option value="01">01
													<option value="02">02
													<option value="03">03
													<option value="04">04
													<option value="05">05
													<option value="06">06
													<option value="07">07
													<option value="08">08
													<option value="09">09
													<option value="10">10
													<option value="11">11
													<option value="12">12
												</select>월
												<select  class="max_date" id="max_date"  name="max_date"  onChange="checkYMRange()" disabled>
													<option value="">
													<%for( int i=1; i<32; i++) {%>
														<%if(i<10){ %>
															<option value="0<%= i %>">0<%= i %>
														<% } %>
														<% if(i>=10){ %>
															<option value="<%= i %>"><%= i %>
														<% } %>
																
													<% } %>	
												</select>일
												<select  class="max_hour"  id="max_hour" name="max_hour"   onChange="checkYMRange()" disabled>
													<option value="">
													<option value="01">01
													<%for( int i=1; i<25; i++) {%>
														<%if(i<10){ %>
															<option value="0<%= i %>">0<%= i %>
														<% } %>
														<% if(i>=10){ %>
															<option value="<%= i %>"><%= i %>
														<% } %>
																
													<% } %>		
												</select>시
												<select  class="max_minute" id="max_minute" name="max_minute"    onChange="checkYMRange()" disabled>
													<option value="">
													<%for( int i=0; i<60; i++) {%>
														<%if(i<10){ %>
															<option value="0<%= i %>">0<%= i %>
														<% } %>
														<% if(i>=10){ %>
															<option value="<%= i %>"><%= i %>
														<% } %>
																
													<% } %>		
												</select> 분 까지
											</td>											
										</tr>
											
											<tr class="approval_yesNo_tr">
												<th>결재/반려</th>
												<td class="approval_yesNo_td">
													<input type="radio" name="approval_yesNo" value="0">결재
													<input type="radio" name="approval_yesNo" value="1">반려
												</td>
											</tr>
										
										<tr>
											<th>다음 결재자</th>
											<td>
												<select name="next_app_emp_no" class="next_app_emp_no" id="next_app_emp_no">
													<option value="">
													<% for (int i=0; i<next_app_list.size(); i++){ %>	
															<option value="<%= next_app_list.get(i).getEmp_no()  %>">
													   <%= next_app_list.get(i).getDep_name()%>부
													   <%= next_app_list.get(i).getEmp_name()%>
													   <%= next_app_list.get(i).getJikup_name()%>
													<% } %>											
												</select>
												<input type="checkbox" class="next_app_No" id="next_app_No" name="next_app_No" value="No"> 다음결재자 없음
											</td>    
										</tr>
										<tr>
											<th> 결재 내역</th>
											<td>
												<table border=1 cellpadding=5 cellspacing=0>
													<tr>
														<th>결재순서</th>
														<th>결재자명</th>
														<th>부서명</th>
														<th>직책</th>
														<th>결재여부</th>
														<th>결재일</th>
														<th>반려사유</th>
													</tr>
													<tr>
														<td>1
														<td>${requestScope.dailyBusiDTO.emp_name}
														<td>${requestScope.dailyBusiDTO.dep_name}
														<td>${requestScope.dailyBusiDTO.jikup_name}
														<td><c:if test="${requestScope.lastAppMan.last_sign_code==0}">최종</c:if><c:if test="${requestScope.nextAppMan.next_sign_code==-1||requestScope.nextAppMan.next_sign_code==0}">결재</c:if><c:if test="${requestScope.lastAppMan.last_sign_code==0}">완료</c:if>
															<c:if test="${requestScope.nextAppMan.next_sign_code==1 && requestScope.lastAppMan.last_sign_code==1}">반려처리중</c:if>
														<td>${requestScope.nextAppMan.next_sign_date}
														<td>
													</tr>
													 <c:forEach var="xxx" items="${requestScope.appList}" varStatus="loopTagStatus">
														<tr 
															bgcolor="${loopTagStatus.index%2==1?'white':'lightgray'}"
														>
															<td>${loopTagStatus.index+2}
															<td>${xxx.app_emp_name}
															<td>${xxx.app_dep_name}						
															<td>${xxx.app_jikup_name}
															<td><c:if test="${requestScope.lastAppMan.last_sign_code==0}">최종</c:if>${xxx.app_sign_name}<c:if test="${requestScope.lastAppMan.last_sign_code==0}">완료</c:if><c:if test="${xxx.app_sign_name=='반려'}"> 처리 대기중</c:if>
															<td>${xxx.next_app_date}			
															<td>${xxx.app_return_result}
														</tr>
													</c:forEach> 
												</table>
											</td>
										</tr>
									</table>
									<center>
										<br><br>
										<span class="button_span">
											<input type="button" value="결재/반려" class="approval_yesNoBtn">
											<input type="button" value="화면닫기" class="dailyListForm">
											<input type="hidden" value="${requestScope.dailyBusiDTO.emp_no}" name="emp_no">
											<input type="hidden" value="${requestScope.dailyBusiDTO.report_no}" name="report_no">
											<input type="hidden" value="${requestScope.dailyBusiDTO.report_code}" name="report_code">
											<input type="hidden" name="busi_start_date">
											<input type="hidden" name="busi_end_date">
											<input type="hidden" name="nextAppNoPerson">
										</span>
									</center>
								</form>
									
									
								</section>

						</div>
					</div>

				<!-- Sidebar -->
					<div id="sidebar">
						<div class="inner">

							<%@include file="/WEB-INF/views/sideBar.jsp" %>
						
						</div>
					</div>

			</div>

		<!-- Scripts -->
		<script src="/js/jquery.min.js"></script>
		<script src="/js/browser.min.js"></script>
		<script src="/js/breakpoints.min.js"></script>
		<script src="/js/util.js"></script>
		<script src="/js/main.js"></script>

	</body>
</html>