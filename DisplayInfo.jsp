<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.lang.*"%>

<!-- Db Connection  -->
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
<input type=submit value="Search">
</br>
</br></body></body>
</form>

<!-- Read Account Number Input -->
<%
String AccNoInput = request.getParameter("AccNo");

if (AccNoInput == null) {
// myText is null when the page is first requested, 
// so do nothing
}
else 
{ 
if (AccNoInput.length() == 0) 
{

%>
<b>Please enter a Valid Account number</b>
<% }

else { %>
<b>Transaction Details For Account Number <%=AccNoInput%></b>
<%
}
}
%>
<!-- Dispaly Total Balance  -->

<%
try{
String sq2 ="select Bal from Accinfo where AccNo=?";
connection = DriverManager.getConnection(connectionUrl+database, userid, password);
pstmt = connection.prepareStatement(sq2);
pstmt.setString(1,AccNoInput);
resultSet = pstmt.executeQuery();
if(resultSet.next())
{
	resultSet.previous();
	
while(resultSet.next()){
%>
<b> <br>Total Balance</b>
<%=resultSet.getString("Bal") %>


<%
}
}
else
	{%>
	</br>Enter a Valid Account No
		<% }
connection.close();
} catch (Exception e) {
e.printStackTrace();
}
%>




<!-- Display Transcaction Details  -->

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
String sql ="select * from Transactions where AccNo=? ORDER BY Date DESC Limit 5";
//String sq2 ="select Bal from Accinfo where AccNo=?";
connection = DriverManager.getConnection(connectionUrl+database, userid, password);
pstmt = connection.prepareStatement(sql);
pstmt.setString(1,AccNoInput);
resultSet = pstmt.executeQuery();
if(resultSet.next())
{
	resultSet.previous();
	
while(resultSet.next()){
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
	{%><b>No Transaction Details are Found</b>
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