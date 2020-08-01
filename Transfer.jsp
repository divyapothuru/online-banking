<%@page import="java.sql.*"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.lang.*"%>
<%@page import="java.lang.Object.*"%>

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
int SB=0;
int DB=0;
%>


<!-- Read Account Number Input  and update Balances-->
<%

String DAccNoInput = request.getParameter("DbAccnt");
String CAccNoInput = request.getParameter("CrAccnt");
String amount=request.getParameter("Amount");
int Amt=Integer.parseInt(amount);


//int temp1=Integer.parseInt(DAccNoInput);
//int temp2=Integer.parseInt(CAccNoInput);
//  Debit Accoutn number isto be deducted and Credi tAccount number to Added - First Accinfo Table to update and Trasnacation table update
//Place Condtion if Source Account is Zero- Display error Insufficent Balance
//update Transactions SET TransID=(CURRENT_TIMESTAMP()+1),CURRENT_DATE(),Tansvalue=? where AccNo=?;
String DA ="select Bal from Accinfo where AccNo=?";
String CA ="select Bal from Accinfo where AccNo=?";
String UpdateBal1="update Accinfo SET Bal=? where AccNo=?";
String UpdateBal2="update Accinfo SET Bal=? where AccNo=?";
String Trans1="insert into Transactions (AccNo,TransID,Date,Tranvalue,Type)values(?,CURRENT_TIMESTAMP()+1,CURRENT_DATE(),?,?)";
String Trans2="insert into Transactions (AccNo,TransID,Date,Tranvalue,Type)values(?,CURRENT_TIMESTAMP()+2,CURRENT_DATE(),?,?)";
connection = DriverManager.getConnection(connectionUrl+database, userid, password);
pstmt = connection.prepareStatement(DA);
pstmt.setString(1,DAccNoInput);
resultSet = pstmt.executeQuery();

if(resultSet.next())
{
	resultSet.previous();
	
while(resultSet.next())
{

	SB=resultSet.getInt("Bal");
	

	SB=SB-Amt;
	}
}

pstmt = connection.prepareStatement(CA);
pstmt.setString(1,CAccNoInput);
resultSet = pstmt.executeQuery();

if(resultSet.next())
{
	resultSet.previous();
	
while(resultSet.next())
{

	DB=resultSet.getInt("Bal");
	

	DB=DB+Amt;
	
	}
}
// Deduct Balace from Source Account
pstmt = connection.prepareStatement(UpdateBal1);
pstmt.setInt(1,SB);
pstmt.setString(2,DAccNoInput);
int rowsAffected1 = pstmt.executeUpdate();
//Update transaction table
pstmt = connection.prepareStatement(Trans1);
pstmt.setString(1,DAccNoInput);
pstmt.setString(3,"Debit");
pstmt.setInt(2,Amt);
pstmt.executeUpdate();




//Add Balace to TO Account
pstmt = connection.prepareStatement(UpdateBal2);
pstmt.setInt(1,DB);
pstmt.setString(2,CAccNoInput);
int rowsAffected3 = pstmt.executeUpdate();

//Update transaction table
pstmt = connection.prepareStatement(Trans2);
pstmt.setString(1,CAccNoInput);
pstmt.setString(3,"Credit");
pstmt.setInt(2,Amt);
pstmt.executeUpdate();


%>
 
<html><body bgcolor="#F0B27A">


Transactions Success 
</br>
</br>

<b>New Balance in From Account  <%=DAccNoInput%></b> : is <%=SB%></br>
<b>New Balance in From Account <%=CAccNoInput%></b> : is<%=DB%>
</body></html>
