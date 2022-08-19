<%@page import="java.io.File"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>게시물 삭제</title>
</head>
<body>

<%
 	
	int seqno = Integer.parseInt(request.getParameter("seqno"));

	String url = "jdbc:mariadb://127.0.0.1:3306/webdev";
	String uid = "root";
	String pwd = "1234";

	Connection con = null;
	
	Statement stmt_file = null;
	Statement stmt = null;
	ResultSet rs_file = null;
		
	String query = "delete from tbl_m1board where seqno = " + seqno;
	String query_file = "select stored_filename from tbl_m1board where seqno = " + seqno;
    
	try{
	
		Class.forName("org.mariadb.jdbc.Driver");
		con = DriverManager.getConnection(url, uid, pwd);
	
		stmt_file = con.createStatement();
		rs_file = stmt_file.executeQuery(query_file);
		
		String store_filename = "";
		while(rs_file.next()) store_filename = rs_file.getString("stored_filename");
		
		//업로드 파일이 있으면 삭제
		File file = new File("c:\\Repository\\file\\" + store_filename);
		if(file.exists()) file.delete();
		
		stmt_file.close();
		rs_file.close();
		
		stmt = con.createStatement();
		stmt.executeUpdate(query);
		
		stmt.close();
		con.close();
		
%>
		<script>
			alert("삭제가 완료 되었습니다.");
			document.location.href='list.jsp';
		</script>
		
<% 
	}catch(Exception e){
		e.printStackTrace();
		stmt.close();
		con.close();

%>	

		<script>
			alert("에러가 발생하였습니다.");
			document.location.href='view.jsp?seqno=' + <%=seqno %>;
		</script>

<% 
	}

%>

</body>
</html>