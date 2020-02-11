<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.GregorianCalendar" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%! String title = "永遠の17歳"; %>
<%!

    public String CalculateDate(String birthday) {
        if (CheckDate(birthday)!="") {
            return "";
        }

        String year = birthday.substring(0, 4);
        String month = birthday.substring(4, 6);
        String date = birthday.substring(6);

        Integer y = Integer.parseInt(year);
        Integer m = Integer.parseInt(month);
        Integer d = Integer.parseInt(date);

        if (m == 2 && d == 29 && (y + 68) % 400 == 0) {
            y += 68;
        } else if (m == 2 && d == 29 && (y + 68) % 100 == 0) {
            y += 72;
        } else if (m == 2 && d == 29) {
            y += 68;
        } else {
            y += 17;
        }

        Integer FromBirthday = CalculateDaysFromBirthday(y, m, d);
        Integer FromToday = CalculateDaysFromToday();

        String result = "";
        Integer days = FromToday - FromBirthday;
        if (days > 0) {
            result = "17歳と" + days.toString() + "日";
        } else if (days == 0) {
            result = "17歳と誕生日おめでとございます";
        } else if (days < 0) {
            days = -days;
            result = "17まであと" + days.toString() + "日";
        }
        return result;
    }

    public static boolean chkDateFormat(String date) {
        int year = Integer.parseInt(date.substring(0, 4));
        int month = Integer.parseInt(date.substring(4, 6));
        int day = Integer.parseInt(date.substring(6));

        if ((year<0||year>9999)||(month<1||month>12)||(day<1||day>31)){
            return false;
        }

        if ((month==4||month==6||month==9||month==11)&&(day>30)){
            return false;
        }

        if (month==2){
            if ((year%400==0)&&(day>29)){
                return false;
            }
            if ((year%400!=0)&&(year%100==0)&&(day>28)){
                return false;
            }
            if ((year%400!=0)&&(year%100!=0)&&(year%4==0)&&(day>29)) {
                return false;
            }
            if ((year%400!=0)&&(year%100!=0)&&(year%4!=0)&&(day>28)) {
                return false;
            }
        }

        return true;
    }

    public String CheckDate(String date) {
        if (date == null || date.equals("")) {
            return "誕生日をご入力ください";
        } else if (!date.matches("[0-9]{8}")) {
            return "桁数が間違ってるか、変な文字が入っています";
        } else if (!chkDateFormat(date)){
            return "誕生日は実在しません";
        }
        return "";
    }

    public Integer CalculateDaysFromBirthday(Integer y, Integer m, Integer d) {
        Integer day = 0;
        for (int i = 0; i < y; i = i + 1) {
            if (i % 400 == 0) {
                day += 366;
            } else if (i % 100 == 0) {
                day += 365;
            } else if (i % 4 == 0) {
                day += 366;
            } else {
                day += 365;
            }
        }

        for (int i = 1; i < m; i = i + 1) {
            if (i == 1 || i == 3 || i == 5 || i == 7 || i == 8 || i == 10 || i == 12) {
                day += 31;
            } else {
                day += 28;
            }
            if ((i == 2 && y % 400 == 0) || (i == 2 && y % 4 == 0 && y % 100 != 0)) {
                day += 1;
            }
        }

        day += d;
        return day;
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
<body>

<%
    request.setCharacterEncoding("UTF-8");
    String birthday = request.getParameter("birthday");
%>

<h3><% out.println(CheckDate(birthday)); %>&nbsp</h3>

<h1><%= title %></h1>

<form method="post" action="index.jsp">
    <input type="text" name="birthday" value="<%= birthday %>">
    <input type="submit" value="cal"/>
</form>

<h3><% out.println(CalculateDate(birthday)); %>&nbsp</h3>

</body>
</html>