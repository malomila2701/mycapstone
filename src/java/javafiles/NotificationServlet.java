import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javafiles.NewPermissionServlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/NotificationServlet")
public class NotificationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
     private static final Logger logger = LogManager.getLogger(NotificationServlet.class.getName());

    // GET : récupérer les notifications non lues
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        int unreadCount = 0;
        JSONArray notificationsArray = new JSONArray();

        try (java.sql.Connection conn = java.sql.DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/capstone_project", "root", "admin")) {
            String sql = "SELECT id, message, created_at FROM notifications WHERE status = 'unread' ORDER BY created_at DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                JSONObject notif = new JSONObject();
                notif.put("id", rs.getInt("id"));
                notif.put("message", rs.getString("message"));
                notif.put("created_at", rs.getTimestamp("created_at").toString());
                notificationsArray.put(notif);
                unreadCount++;
            }
        } catch (Exception e) {
            logger.error("Error NotificationServlet" + e.getMessage());
        }

        JSONObject json = new JSONObject();
        json.put("unreadCount", unreadCount);
        json.put("notifications", notificationsArray);

        out.print(json.toString());
        out.flush();
    }

    // POST : marquer les notifications comme lues
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try (java.sql.Connection conn = java.sql.DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/capstone_project", "root", "admin")) {
            String sql = "UPDATE notifications SET status = 'read' WHERE status = 'unread'";
            PreparedStatement ps = conn.prepareStatement(sql);
            int updated = ps.executeUpdate();

            JSONObject json = new JSONObject();
            json.put("updatedCount", updated);
            out.print(json.toString());
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
