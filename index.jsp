<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.lang.String" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.ParseException" %>

<%! String title = "永遠の17歳"; %>
<%!

    public String CalculateDays(String birthday) {
        //To Check birthday to ensure it is valid.
        if (CheckDate(birthday) != "") {
            return "";
        }

        birthday = Format(birthday);

        //To parse birthday to y(year), m(month), d(date).
        Integer y = Integer.parseInt(birthday.substring(0, 4));
        Integer m = Integer.parseInt(birthday.substring(4, 6));
        Integer d = Integer.parseInt(birthday.substring(6, 8));

        //To calculate 17th birthday year.
        if (m == 2 && d == 29) {
            int i = 0;
            while (i < 17) {
                y += 1;
                String NextBirthday = y.toString();
                if (NextBirthday.length() == 1) {
                    NextBirthday = "000" + NextBirthday + "0229";
                } else if (y.toString().length() == 2) {
                    NextBirthday = "00" + NextBirthday + "0229";
                } else if (y.toString().length() == 3) {
                    NextBirthday = "0" + NextBirthday + "0229";
                } else if (y.toString().length() == 4) {
                    NextBirthday += "0229";
                } else {
                    NextBirthday += "0229";
                }
                if (CheckDate(NextBirthday) == "") {
                    i++;
                }
            }
        } else {
            y += 17;
        }

        //To calculate days'number from 0000/01/01 to 17th birthday.
        Integer FromBirthday = CalculateDaysFromBirthday(y, m, d);

        //To calculate days'number from 0000/01/01 to today.
        Integer FromToday = CalculateDaysFromToday();

        //To calculate the difference between FromBirthday and FromToday.
        Integer days = FromToday - FromBirthday;

        //To make result for output.
        String result = "";
        if (days > 0) {
            result = "17歳と" + days.toString() + "日";
        } else if (days == 0) {
            result = "17歳の誕生日おめでとございます";
        } else if (days < 0) {
            days = -days;
            result = "17歳まで" + days.toString() + "日";
        }
        return result;
    }

    public static String Format(String birthday) {
        if (birthday.contains("/")) {
            DateFormat format = new SimpleDateFormat("yyyy/MM/dd");
            Date date = null;
            try {
                date = format.parse(birthday);
            } catch (ParseException e) {
                e.printStackTrace();
            }
            DateFormat sdf = new SimpleDateFormat("yyyyMMdd");
            String dateStr = "";
            try {
                dateStr = sdf.format(date);
            } catch (Exception e) {
                e.printStackTrace();
            }
            return dateStr;
        }
        return birthday;
    }

    //To check Date of birthday is valid or not.
    public String CheckDate(String date) {
        if (date == null || date.equals("")) {
            return "誕生日をご入力ください";
        }
        if (!date.matches("[0-9/]*$")) {
            return "数字0～9と/以外の文字が入っています";
        }
        if (date.contains("/")){
            if (date.length() != 5 && date.length() != 6 && date.length() != 7 && date.length() != 8 && date.length() != 9 && date.length() != 10) {
                return "桁数が間違っています";
            }
        } else {
            if (date.length() == 8) {
                return "桁数が間違っています";
            }
        }

        //To format input to YYYYMMDD
        date = Format(date);

        if (date == null || date == ""){
            return "正しい誕生日をご入力ください";
        }
        if (!IfDateExist(date)) {
            return "誕生日は実在しませんか、計算範囲を超えています";
        }

        if (date.length() != 8 ) {
            return "桁数が間違っています";
        }

        return "";
    }

    //To check this date exists or not.
    public boolean IfDateExist(String date) {
        int year = Integer.parseInt(date.substring(0, 4));
        int month = Integer.parseInt(date.substring(4, 6));
        int day = Integer.parseInt(date.substring(6, 8));

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
    public boolean IsLeapYear(Integer year) {
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

    public Integer CalculateDaysFromBirthday(Integer y, Integer m, Integer d) {
        Integer days = 0;
        for (int i = 0; i < y; i = i + 1) {
            if (IsLeapYear(i)) {
                days += 366;
            } else {
                days += 365;
            }
        }

        for (int i = 1; i < m; i = i + 1) {
            if (i == 1 || i == 3 || i == 5 || i == 7 || i == 8 || i == 10 || i == 12) {
                days += 31;
            } else {
                days += 28;
            }
            if (i == 2 && IsLeapYear(y)) {
                days += 1;
            }
        }

        days = days + d;
        return days;
    }

    public Integer CalculateDaysFromToday() {
        Calendar now = Calendar.getInstance();
        Integer y = now.get(Calendar.YEAR);
        Integer m = now.get(Calendar.MONTH) + 1;
        Integer d = now.get(Calendar.DAY_OF_MONTH);

        Integer day = CalculateDaysFromBirthday(y, m, d);
        return day;
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

<div class="debug">
    <h3><% if (birthday != null) {
        out.println(Format(birthday));
    }%>&nbsp</h3>
</div>

</body>
</html>