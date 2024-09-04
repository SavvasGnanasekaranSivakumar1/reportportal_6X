package com.pearson.ras.controller;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class OracleTest {
    public static void main(String ar[]) throws ClassNotFoundException, SQLException {
        Connection conn=null;

        Class.forName("oracle.jdbc.driver.OracleDriver");
        String url = "jdbc:oracle:thin:@//chddevrasxdb01.lsk12.com:1521/RASDEV";//"jdbc:oracle:thin:@//chddevrasxdb01.lsk12.com:1521/RASDEV";
        String username = "roy_reports";
        String password = "roy_reports";
        System.out.println(" Before connection object " + username);
        System.out.println(" Before connection object " + password);
        conn = DriverManager.getConnection(url, username, password);
        System.out.println(" After connection object " + username);
        System.out.println(" After connection object " + password);
    }
}
