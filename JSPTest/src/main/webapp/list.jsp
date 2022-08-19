<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta charset="UTF-8">
<head>
<script src="http://code.jquery.com/jquery-1.11.3.js"></script>

<title>게시물 목록</title>

<style>
body { font-family: "나눔고딕", "맑은고딕" }
h1 { font-family: "HY견고딕" }
a:link { color: black; }
a:visited { color: black; }
a:hover { color: red; }
a:active { color: red; }
#hypertext { text-decoration-line: none; cursor: hand; }

.tableDiv {
	text-align: center;
}

.InfoTable {
      border-collapse: collapse;
      border-top: 3px solid #168;
      width: 800px;  
      margin-left: auto; margin-right: auto;
    }  
    .InfoTable th {
      color: #168;
      background: #f0f6f9;
      text-align: center;
    }
    .InfoTable th, .InfoTable td {
      padding: 10px;
      border: 1px solid #ddd;
    }
    .InfoTable th:first-child, .InfoTable td:first-child {
      border-left: 0;
    }
    .InfoTable th:last-child, .InfoTable td:last-child {
      border-right: 0;
    }
    .InfoTable tr td:first-child{
      text-align: center;
    }
    .InfoTable caption{caption-side: top; }

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

</head>

<%

	String userid = (String)session.getAttribute("userid");
	if(userid == null) response.sendRedirect("index.jsp");

	request.setCharacterEncoding("utf-8");
%>	

<body>

<div class="tableDiv">

	<h1>게시물 목록 보기</h1>
	<table class="InfoTable">
  		<tr>
   			<th>번호</th>
   			<th>제목</th>
   			<th>작성자</th>
   			<th>조회수</th>
   			<th>작성일</th>
  		</tr>

 		<tbody>

<%  
 	String url = "jdbc:mariadb://127.0.0.1:3306/webdev";
	String uid = "root";
	String pwd = "1234";
	String query = "select @rownum:=@rownum+1 as seq, seqno, mtitle, mwriter, to_char(mregdate,'YYYY-MM-DD HH24:MI:SS') as mregdate," 
			+ "hitno from (select @rownum:=0) a, tbl_m1board b order by seqno desc";
	
	Connection con = null;
    Statement stmt = null;
    ResultSet rs = null;
        
	try{
		
		Class.forName("org.mariadb.jdbc.Driver");
		con = DriverManager.getConnection(url, uid, pwd);

		stmt = con.createStatement();
		rs = stmt.executeQuery(query);
		
		while(rs.next()) {
			 
%>
 	<tr onMouseover="this.style.background='#46D2D2';" onmouseout="this.style.background='white';">
		<td><%=rs.getInt("seq") %></td>
		<td style="text-align:left;">
			<a id="hypertext" href="view.jsp?seqno=<%=rs.getInt("seqno") %>" onMouseover='this.style.textDecoration="underline"' 
			  onmouseout="this.style.textDecoration='none';"><%=rs.getString("mtitle") %></a>
		</td>  
		<td><%=rs.getString("mwriter") %></td>
		<td><%=rs.getInt("hitno") %></td>
		<td><%=rs.getString("mregdate") %></td> 
	</tr>
<% 
		}
	}catch(Exception e)	 {
		e.printStackTrace();
	}
	
	stmt.close();
	rs.close();
	con.close();
	
%>
			
	</tbody>

	</table>
	<br>
<br><br>	

	<div class="bottom_menu">
		<a href="#">처음으로</a>&nbsp;&nbsp;
		<a href="write.jsp">글쓰기</a>&nbsp;&nbsp;
		<a href="#">사용자관리</a>&nbsp;&nbsp;
		<a href="logout.jsp">로그아웃</a>&nbsp;&nbsp; 
	</div>
</div>
</body>
</html>