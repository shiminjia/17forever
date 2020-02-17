<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.lang.String" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="java.util.Scanner" %>
<%@ page import="java.util.TimeZone" %>

<%! String title = "永遠の17歳"; %>
<%!

    public static String CalculateDays(String str) throws ParseException {
        //check date
        String result = CheckDate(str);
        if (result != "") {
            return "";
        }

        //calculate the date of 17 years old
        str = Calculate17(str);

        //set date format
        SimpleDateFormat s1 = new SimpleDateFormat("yyyy/MM/dd");
        SimpleDateFormat s2 = new SimpleDateFormat("yyyyMMdd");
        s1.setTimeZone(TimeZone.getTimeZone("Asia/Tokyo"));  //set timezone
        s2.setTimeZone(TimeZone.getTimeZone("Asia/Tokyo"));  //set timezone

        //get date of now
        Date nowDate = new Date();

        //get 17th birthday
        Date birthdayDate;
        if (str.contains("/")) {
            birthdayDate = s1.parse(str);
        } else {
            birthdayDate = s2.parse(str);
        }

        long nowms = nowDate.getTime();
        long birthdayms = birthdayDate.getTime();
        long time = nowms - birthdayms;

        String res;
        long days = time / (1000 * 60 * 60 * 24);
        if (days < 0) {
            res = "17歳まで" + -days + "日です。";
        } else if (days == 0){
            res = "17歳の誕生日おめでとうございます。";
        } else {
            res = "17歳と" + days + "日です。";
        }
        return res;
    }

    public static String CheckDate(String str) {
        if (str == "") {
            return "誕生日をご入力ください。";
        }

        if (!str.matches("[0-9/]*$")) {
            return "数字0～9と/以外の文字が入っています";
        }

        int n = CountChar(str);
        if (n == 1 || n > 2) {
            return "入力値をご確認ください。";
        }

        if (n == 0) {
            if (str.length() != 8) {
                return "桁数をご確認ください。";
            }
            str = str.substring(0, 4) + "/" + str.substring(4, 6) + "/" + str.substring(6, 8);

        }

        if (str.length() != 8 && str.length() != 9 && str.length() != 10) {
            return "桁数をご確認ください。";
        }

        if (!IfDateExist(str)) {
            return "入力値が存在しません。";
        }

        return "";
    }

    public static int CountChar(String s) {
        int n = 0;
        for (int i = 0; i < s.length(); i++) {
            if (s.charAt(i) == '/') {
                n++;
            }
        }
        return n;
    }

    //To check this date exists or not.
    public static boolean IfDateExist(String date) {
        String[] YMD = date.split("/");

        Integer year = Integer.parseInt(YMD[0]);
        Integer month = Integer.parseInt(YMD[1]);
        Integer day = Integer.parseInt(YMD[2]);
        //System.out.printf("%d,%d,%d",year,month,day);

        if ((year < 1 || year > 9999) || (month < 1 || month > 12) || (day < 1 || day > 31)) {
            return false;
        }

        if ((month == 4 || month == 6 || month == 9 || month == 11) && (day > 30)) {
            return false;
        }

        if (month == 2 && day > 29) {
            return false;
        }

        if (month == 2 && day == 29) {
            if (IsLeapYear(year)) {
                return true;
            } else {
                return false;
            }
        }
        return true;
    }

    //To check this year is leap year or not.
    public static boolean IsLeapYear(Integer year) {
        if (year % 400 == 0) {
            return true;
        } else if (year % 100 == 0) {
            return false;
        } else if (year % 4 == 0) {
            return true;
        } else {
            return false;
        }
    }

    public static String Calculate17(String date) {
        if (CountChar(date)==0){
            date = date.substring(0, 4) + "/" + date.substring(4, 6) + "/" + date.substring(6, 8);
        }
        String[] YMD = date.split("/");
        Integer y = Integer.parseInt(YMD[0]);
        Integer m = Integer.parseInt(YMD[1]);
        Integer d = Integer.parseInt(YMD[2]);

        if (m == 2 && d == 29) {
            int i = 0;
            while (i < 17) {
                y += 1;
                String NextBirthday = y.toString();
                if (NextBirthday.length() == 1) {
                    NextBirthday = "000" + NextBirthday + "/02/29";
                } else if (y.toString().length() == 2) {
                    NextBirthday = "00" + NextBirthday + "/02/29";
                } else if (y.toString().length() == 3) {
                    NextBirthday = "0" + NextBirthday + "/02/29";
                } else {
                    NextBirthday += "/02/29";
                }
                if (IfDateExist(NextBirthday)) {
                    i++;
                }
            }
        } else {
            y += 17;
        }
        return y + "/" + m + "/" + d;
    }

%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8"/>
</head>
<style>
    .error_message {
        color: red;
    }

    .calculate {
        width: 350px;
        height: 300px;
        position: absolute;
        left: 0;
        top: 0;
        right: 0;
        bottom: 0;
        margin: auto;
        text-align: center;
    }

    .sub {
        margin-top: 30px;
        font-size: 20px;
        border: 1px solid #DDD;
        padding: 5px 10px;
    }

</style>
<body>

<%
    request.setCharacterEncoding("UTF-8");
    String birthday = request.getParameter("birthday");
%>

<div class="error_message">
    <h3><% if (birthday != null) {
        out.println(CheckDate(birthday));
    }%>&nbsp</h3>
</div>

<div class="calculate">
    <h1 style="font-size: 50px"><%= title %>
    </h1>
    <form method="post" action="index.jsp">
        <input type="text" name="birthday" style="width:200px;height:30px;font-size:20px;" value="<% if(birthday!=null){
                out.print(birthday);
            }%>">
        <br>
        <input type="submit" value="計算" class="sub"/>
    </form>
    <h3><% if (birthday != null) {
       out.println(CalculateDays(birthday));
    }%></h3>
</div>

<%--<div class="debug">--%>
<%--    <h3><% if (birthday != null) {--%>
<%--        out.println(Calculate17(birthday));--%>
<%--    }%>&nbsp</h3>--%>
<%--</div>--%>

</body>
</html>