<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<title>게시물 내용 보기</title>
</head>

<style>
body { font-family: "나눔고딕", "맑은고딕" }
h1 { font-family: "HY견고딕" }
a:link { color: black; }
a:visited { color: black; }
a:hover { color: red; }
a:active { color: red; }
#hypertext { text-decoration-line: none; cursor: hand; }

.boardView {
  width:900px;
  height:auto;
  padding: 20px, 20px;
  background-color:#FFFFFF;
  border:4px solid gray;
  border-radius: 20px;
}

.mwriter, .mtitle, .mregDate, .mcontent, .filename {
  width: 90%;
  height:25px;
  outline:none;
  color: #636e72;
  font-size:16px;
  background: none;
  border-bottom: 2px solid #adadad;
  margin: 30px;
  padding: 10px 10px;
  text-align: left;
}

.textArea {
  width: 90%;
  height: 350px;
  overflow: auto;
  margin: 22px;
  padding: 10px;
  box-sizing: border-box;
  border: solid #adadad;
  text-align: left;
  font-size: 16px;
  resize: both;
}

.bottom_menu { margin-top: 20px; }

.bottom_menu > a:link, .bottom_menu > a:visited {
			background-color: #FFA500;
			color: maroon;
			padding: 15px 25px;
			text-align: center;	
			display: inline-block;
			text-decoration : none; 
}
.bottom_menu > a:hover, .bottom_menu > a:active { 
	background-color: #1E90FF;
	text-decoration : none; 
}


</style>

<%

	String session_userid = (String)session.getAttribute("userid");
	if(session_userid == null) response.sendRedirect("index.jsp");
	
	int seqno = Integer.parseInt(request.getParameter("seqno"));
	

%>

<script>

$(document).ready(function(){
	
	
}); //End of $(document).ready(function)

function mDelete(){
	if(confirm("정말 삭제 하시겠습니까?")==true) location.href='/delete.jsp?seqno=<%=seqno %>'
}

function fileDownload(){
	
	location.href="/fileDownload.jsp?seqno=<%=seqno %>"
}

</script>
<body>

<%

	String url = "jdbc:mariadb://127.0.0.1:3306/webdev";
	String uid = "root";
	String pwd = "1234";
	
	String query = "select userid, mwriter,mtitle,mcontent,hitno,to_char(mregdate,'YYYY-MM-DD HH24:MI:SS') as mregdate,org_filename from tbl_m1board where seqno = " + seqno;
	//게시물 이전글 보기
	String query_pre = "select max(seqno) as seqno from tbl_m1board where seqno < " + seqno;
	//게시물 다음글 보기
	String query_next = "select min(seqno) as seqno from tbl_m1board where seqno > " + seqno;
	
	Connection con = null;
	Statement stmt = null;
	ResultSet rs = null;
	
	Statement stmt_pre = null;
	ResultSet rs_pre = null;
	
	Statement stmt_next = null;
	ResultSet rs_next = null;
	
	Statement stmt_hitno = null;
	
	String db_userid = "";
	String mwriter = "";
	String mtitle = "";
	String mcontent = "";
	String mregdate = "";
	String filename = "";
	int hitno = 0;
	int pre_seqno = 0;
	int next_seqno = 0;
	
	try{
		
		Class.forName("org.mariadb.jdbc.Driver");
		con = DriverManager.getConnection(url, uid, pwd);
	
		stmt = con.createStatement();
		rs = stmt.executeQuery(query);
		
		while(rs.next()) {
			db_userid = rs.getString("userid");
			mwriter = rs.getString("mwriter");
			mtitle = rs.getString("mtitle");
			mcontent = rs.getString("mcontent");
			hitno = rs.getInt("hitno");
			mregdate = rs.getString("mregdate");
			filename = rs.getString("org_filename");
		}
		//이전 게시물 보기 실행에 필요한 이전 seqno 값 가져 오기
		stmt_pre = con.createStatement();
		rs_pre = stmt_pre.executeQuery(query_pre);
		
		//다음 게시물 보기 실행에 필요한 다음 seqno 값 가져 오기
		stmt_next = con.createStatement();
		rs_next = stmt_next.executeQuery(query_next);
		
		while(rs_pre.next()) pre_seqno = rs_pre.getInt("seqno");
		while(rs_next.next()) next_seqno = rs_next.getInt("seqno");
		
		//조회수 증가 시키기
		
		if(!session_userid.equals(db_userid)){
			hitno++;
			String query_hitno = "update tbl_m1board set hitno = " + hitno + " where seqno = " + seqno;
			System.out.println("[조회수 증가 쿼리] : " + query_hitno);
			stmt_hitno = con.createStatement();
			stmt_next.executeUpdate(query_hitno);
			stmt_hitno.close();
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}
	
	stmt.close();
	stmt_pre.close();
	stmt_next.close();
	rs.close();
	rs_pre.close();
	rs_next.close();
	con.close();
%>

<div class="main" align="center">
	<h1>게시물 내용 보기</h1>
	<br>
	<div class="boardView">
		<div class="mwriter">이름 : <%=mwriter %></div>
		<div class="mtitle">제목 : <%=mtitle %></div>
		<div class="mregDate">날짜 : <%=mregdate %></div>
		<div class="textArea"><pre><%=mcontent %></pre></div>
	<% if(!filename.equals("null")){ %>
		<div class="filename">파일명 : <a href="javascript:fileDownload()"><%=filename %></a></div>
	<% } else {%>
		<div class="filename">업로드된 파일이 없습니다.</div>
	<% } %>
	
	</div>

	<div class="bottom_menu">
	<%if(pre_seqno != 0){ %>
				&nbsp;&nbsp;<a href="view.jsp?seqno=<%=pre_seqno %>" onMouseover="this.style.textDecoration='underline';" 
					onmouseout="this.style.textDecoration='none';">이전글 ▼</a> &nbsp;&nbsp;
	<% } %>			
			<a href="list.jsp" onMouseover="this.style.textDecoration='underline';" 
					onmouseout="this.style.textDecoration='none';">목록보기</a> &nbsp;&nbsp;
	<%if(next_seqno != 0){ %>
			<a href="view.jsp?seqno=<%=next_seqno %>" onMouseover="this.style.textDecoration='underline';" 
						onmouseout="this.style.textDecoration='none';">다음글 ▲</a> &nbsp;&nbsp;
	<% } %>		
			<a href="write.jsp" onMouseover="this.style.textDecoration='underline';" 
					onmouseout="this.style.textDecoration='none';">글 작성</a> &nbsp;&nbsp;

	<% if(session_userid.equals(db_userid)) { %>
			<a href="modify.jsp?seqno=<%=seqno %>" onMouseover="this.style.textDecoration='underline';" 
					onmouseout="this.style.textDecoration='none';">글 수정</a> &nbsp;&nbsp;

			<a href="delete.jsp?seqno=<%=seqno %>" onMouseover="this.style.textDecoration='underline';" 
						onmouseout="this.style.textDecoration='none';">글 삭제</a> &nbsp;&nbsp;
	<%} %>						
	</div>
</div>
</body>
</html>