/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package javafiles;

/**
 *
 * @author HP
 */
public class DBConnection {

    public static java.sql.Connection connect() throws Exception {
        String url = System.getenv("JDBC_URL");
        String user = System.getenv("DB_USER");
        String pass = System.getenv("DB_PASS");
        return java.sql.DriverManager.getConnection(url, user, pass);
    }
}
