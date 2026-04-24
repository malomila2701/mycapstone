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
        
        // Essaie d'abord les variables Tomcat (JNDI) — local
        try {
            javax.naming.Context ctx = new javax.naming.InitialContext();
            String url  = (String) ctx.lookup("java:comp/env/JDBC_URL");
            String user = (String) ctx.lookup("java:comp/env/DB_USER");
            String pass = (String) ctx.lookup("java:comp/env/DB_PASS");
            return java.sql.DriverManager.getConnection(url, user, pass);
            
        } catch (javax.naming.NamingException e) {
            // Fallback sur variables d'environnement — Render
            String url  = System.getenv("JDBC_URL");
            String user = System.getenv("DB_USER");
            String pass = System.getenv("DB_PASS");
            return java.sql.DriverManager.getConnection(url, user, pass);
        }
    }
}
