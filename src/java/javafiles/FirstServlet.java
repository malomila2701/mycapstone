package javafiles;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import java.sql.*;
import javax.servlet.http.HttpSession;

@WebServlet("/FirstSevlet")
public class FirstServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(FirstServlet.class.getName());

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        response.getWriter().println("LoginServlet is working!");
    }

    // @param request servlet request
    // @param response servlet response
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            logger.error("ClassNotFound here: " + e.getMessage());
        }

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            java.sql.Connection conn = DBConnection.connect();

            String sql = "SELECT * FROM users WHERE username = ? and password = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {

                String role = rs.getString("role");
                int user_id = rs.getInt("user_id");
                String fullname = rs.getString("fullname");
                String email = rs.getString("email");

                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("role", role);
                session.setAttribute("user_id", user_id);
                session.setAttribute("fullname", fullname);
                session.setAttribute("email", email);

                // ✅ Role-based redirection happens here
                if ("admin".equals(role)) {
                    request.getRequestDispatcher("main_page.jsp").forward(request, response);
                    logger.info("================ADMIN===================");
                    logger.info("Session id is: " + session.getId());
                } else {
                    logger.info("================USER===================");
                    logger.info("Session id is: " + session.getId());
                    request.getRequestDispatcher("main_page.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("login_error", "Identifiants incorrects. Veuillez réessayer.");
                request.getRequestDispatcher("hello.jsp").forward(request, response);
                return;
            }
            rs.close();
            stmt.close();

        } catch (IOException | SQLException | ServletException e) {
            request.setAttribute("error", "server");
            request.getRequestDispatcher("hello.jsp").forward(request, response);
            logger.error("Error Log in: " + e.getMessage());
        } catch (Exception ex) {
            System.getLogger(FirstServlet.class.getName()).log(System.Logger.Level.ERROR, (String) null, ex);
        }
    }

}
