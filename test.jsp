<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.lang.*"%>

<%
String driver = "com.mysql.jdbc.Driver";
String connectionUrl = "jdbc:mysql://localhost:3306/";
String database = "netbanking";
String userid = "root";
String password = "root";
try {
Class.forName(driver);
} catch (ClassNotFoundException e) {
e.printStackTrace();
}
Connection connection = null;
Statement statement = null;
PreparedStatement pstmt = null;
ResultSet resultSet = null;
%>

<!DOCTYPE html>
<html>
<body bgcolor="#F0B27A">

<h1>Please enter Account number to Display Balances and last 5 Transactions</h1>
</br></br></br>
<center><form method=post action="DisplayInfo.jsp">
<font size=2>Enter Account Number </font><input type=text align=center-left name=AccNo ID=AccNo> </br><font size=1>e.g 10002020 10002021 10002022</font>
</br>
<input type=submit>
</br>
</br></body></body>
</form>


<%
String AccNoInput = request.getParameter("AccNo");

if (AccNoInput == null) {
// myText is null when the page is first requested, 
// so do nothing
} else { 
if (AccNoInput.length() == 0) {
// There was a querystring like ?myText=
// but no text, so myText is not null, but 
// a zero length string instead.
%>
<b>Please enter a Valid Account number</b>
<% } else { %>
<b>Transaction Details For Account Number <%=AccNoInput%></b>
<%
}
}
%>



<br></br>
<table border="1">
<tr>
<td>AccNo</td>
<td>Transaction ID</td>
<td>Date</td>
<td>Amount</td>
<td>Type</td>
</tr>
<%
try{
String sql ="select * from Transactions where AccNo=? ORDER BY Date DESC";
connection = DriverManager.getConnection(connectionUrl+database, userid, password);
pstmt = connection.prepareStatement(sql);
pstmt.setString(1,AccNoInput);
resultSet = pstmt.executeQuery();
if(resultSet.next())
{
	
while(resultSet.last()){
%>
<tr>
<td><%=resultSet.getString("AccNo") %></td>
<td><%=resultSet.getString("TransID") %></td>
<td><%=resultSet.getString("Date") %></td>
<td><%=resultSet.getString("Tranvalue") %></td>
<td><%=resultSet.getString("Type") %></td>
</tr>
<%
}
}
else
	{%><b>The Entered Account Number was not Found</b>
	<% }
connection.close();
} catch (Exception e) {
e.printStackTrace();
}
%>
</table>
</center>
</body>
</html>