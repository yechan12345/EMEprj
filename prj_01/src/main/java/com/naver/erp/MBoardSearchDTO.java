package com.naver.erp;

public class MBoardSearchDTO {

 	private String keyword;
	private int dep_no;
	private int jikup_code;
	private String room_code;
	private String room_name;

	private int begin_rowNo;
	private int end_rowNo;
	private int selectPageNo;
	private int rowCntPerPage;

	public String getKeyword() {
		return this.keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}

	public int getDep_no() {
		return this.dep_no;
	}

	public void setDep_no(int dep_no) {
		this.dep_no = dep_no;
	}

	public int getJikup_code() {
		return this.jikup_code;
	}

	public void setJikup_code(int jikup_code) {
		this.jikup_code = jikup_code;
	}

	public String getRoom_code() {
		return this.room_code;
	}

	public void setRoom_code(String room_code) {
		this.room_code = room_code;
	}

	public String getRoom_name() {
		return this.room_name;
	}

	public void setRoom_name(String room_name) {
		this.room_name = room_name;
	}

	public int getBegin_rowNo() {
		return this.begin_rowNo;
	}

	public void setBegin_rowNo(int begin_rowNo) {
		this.begin_rowNo = begin_rowNo;
	}

	public int getEnd_rowNo() {
		return this.end_rowNo;
	}

	public void setEnd_rowNo(int end_rowNo) {
		this.end_rowNo = end_rowNo;
	}

	public int getSelectPageNo() {
		return this.selectPageNo;
	}

	public void setSelectPageNo(int selectPageNo) {
		this.selectPageNo = selectPageNo;
	}

	public int getRowCntPerPage() {
		return this.rowCntPerPage;
	}

	public void setRowCntPerPage(int rowCntPerPage) {
		this.rowCntPerPage = rowCntPerPage;
	}




	

	
	
	
    
	
    
    
	
    
    
}
