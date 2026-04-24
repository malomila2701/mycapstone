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
         String url, user, pass;
         
        try {
            javax.naming.Context ctx = new javax.naming.InitialContext();
            url = (String) ctx.lookup("java:comp/env/JDBC_URL");
            user = (String) ctx.lookup("java:comp/env/DB_USER");
            pass = (String) ctx.lookup("java:comp/env/DB_PASS");
            System.out.println(">>> JNDI OK");
            return java.sql.DriverManager.getConnection(url, user, pass);

        } catch (javax.naming.NamingException e) {
            // Fallback sur variables d'environnement — Render
            url = System.getenv("JDBC_URL");
            user = System.getenv("DB_USER");
            pass = System.getenv("DB_PASS");

            System.out.println(">>> JDBC_URL = " + url);
            System.out.println(">>> DB_USER = " + user);
            System.out.println(">>> DB_PASS is null? " + (pass == null));

            return java.sql.DriverManager.getConnection(url, user, pass);

        }
    }
}
