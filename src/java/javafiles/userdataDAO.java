/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package javafiles;

/**
 *
 * @author JS
 */
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;

public class userdataDAO {

    private static final Logger logger = LogManager.getLogger(userdataDAO.class.getName());

    public boolean newEvent(int userId, String eventStart, String eventEnd, String eventType, String eventDescription) throws Exception {

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DBConnection.connect();
            PreparedStatement ps = con.prepareStatement("INSERT INTO holidays(user_id, start_date, end_date ,motif, type, status) VALUES (?,?,?,?,?,'pending') ");

            ps.setInt(1, userId);
            ps.setString(2, eventStart);
            ps.setString(3, eventEnd);
            ps.setString(4, eventDescription);
            ps.setString(5, eventType);

            
            int rows = ps.executeUpdate();
            return rows>0;
        } catch (ClassNotFoundException | SQLException e) {
            logger.error("ERROR CREATING A NEW REQUEST: " + e.getMessage());
            return false;
        }
    }

    /**
     * Retrive last (1) leave date taken by an user
     *
     * @param userId
     * @return
     */
    public String getInfo(int userId) {

        String end_date = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DBConnection.connect();
            PreparedStatement ps = con.prepareStatement("SELECT end_date FROM holidays WHERE user_id= ? "
                    + "AND status IN ('approved', 'rejected') ORDER BY end_date DESC LIMIT 1");

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                end_date = rs.getString("end_date");
            }

            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return end_date;
    }

    /**
     * Retrive pending requests made by an user
     *
     * @param userId
     * @return
     * @throws java.lang.Exception
     */
    public List<UserPending> getPending(int userId) throws Exception {
        List<UserPending> pendingList = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con2 = DBConnection.connect();
            PreparedStatement ps2 = con2.prepareStatement("SELECT *, users.fullname FROM holidays INNER JOIN users ON holidays.user_id = users.user_id WHERE users.user_id= ? AND status='pending' ORDER BY end_date DESC LIMIT 3");

            ps2.setInt(1, userId);
            ResultSet rs2 = ps2.executeQuery();

            while (rs2.next()) {
                UserPending h = new UserPending(
                        rs2.getInt("user_id"),
                        rs2.getInt("holidays_id"),
                        rs2.getString("fullname"),
                        rs2.getString("start_date"),
                        rs2.getString("end_date"),
                        rs2.getString("type"),
                        rs2.getString("status"),
                        rs2.getString("motif")
                );
                pendingList.add(h);
            }

        } catch (ClassNotFoundException | SQLException e) {
            logger.error("ERROR PENDING OV: " + e.getMessage());
        }

        return pendingList;
    }

    /**
     * Retrieve all latest leave taken by an user, limit 3
     *
     * @param userId
     * @return
     */
    public List<UserLeave> getUserLeave(int userId) throws Exception {
        List<UserLeave> leaveList = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DBConnection.connect();
            PreparedStatement ps = con.prepareStatement("SELECT holidays.user_id, holidays.holidays_id, holidays.start_date, holidays.end_date, holidays.type, holidays.status, holidays.motif, users.user_id, users.fullname FROM holidays INNER JOIN users ON holidays.user_id = users.user_id WHERE users.user_id= ? "
                    + "ORDER BY end_date DESC LIMIT 3");

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                UserLeave h = new UserLeave(
                        rs.getInt("user_id"),
                        rs.getInt("holidays_id"),
                        rs.getString("fullname"),
                        rs.getDate("start_date"),
                        rs.getDate("end_date"),
                        rs.getString("type"),
                        rs.getString("status"),
                        rs.getString("motif")
                );
                leaveList.add(h);
            }

            rs.close();
            ps.close();

        } catch (ClassNotFoundException | SQLException e) {
            logger.error("ERROR RETRIEVING INDIVIDUAL USER LEAVES: " + e.getMessage());
        }
        return leaveList;
    }

    /**
     * ADMIN Retrieve all leave taken by all employees
     *
     * @return
     */
    public List<UserLeave> getAdminAll() throws Exception {
        List<UserLeave> userList = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con2 = DBConnection.connect();

            PreparedStatement ps2 = con2.prepareStatement("SELECT holidays.user_id, holidays.holidays_id, holidays.start_date, holidays.motif, holidays.type, holidays.end_date, holidays.status,users.user_id, users.fullname "
                    + "FROM holidays "
                    + "INNER JOIN users ON holidays.user_id = users.user_id "
                    + "ORDER BY holidays.end_date;");
            ResultSet rs2 = ps2.executeQuery();

            while (rs2.next()) {
                UserLeave h = new UserLeave(
                        rs2.getInt("user_id"),
                        rs2.getInt("holidays_id"),
                        rs2.getString("fullname"),
                        rs2.getDate("start_date"),
                        rs2.getDate("end_date"),
                        rs2.getString("type"),
                        rs2.getString("status"),
                        rs2.getString("motif")
                );
                userList.add(h);
            }

        } catch (ClassNotFoundException | SQLException e) {
            logger.error("ERROR PENDING ADMIN RQ: " + e.getMessage());
        }

        return userList;
    }

    /**
     * ADMIN Retrieve all pending requests
     *
     * @return
     */
    public List<UserPending> getAdminPending() throws Exception {
        List<UserPending> allList = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con2 = DBConnection.connect();
            PreparedStatement ps1 = con2.prepareStatement("SELECT *,users.fullname FROM holidays INNER JOIN users ON holidays.user_id = users.user_id WHERE holidays.status = 'pending' ORDER BY holidays.end_date;");
            ResultSet rs1 = ps1.executeQuery();

            while (rs1.next()) {
                UserPending h = new UserPending(
                        rs1.getInt("user_id"),
                        rs1.getInt("holidays_id"),
                        rs1.getString("fullname"),
                        rs1.getString("start_date"),
                        rs1.getString("end_date"),
                        rs1.getString("type"),
                        rs1.getString("status"),
                        rs1.getString("motif")
                );
                allList.add(h);
            }
        } catch (ClassNotFoundException | SQLException e) {
            logger.error("ALL PENDING: " + e.getMessage());
        }
        return allList;
    }
    
    
    
    
    
    
    public List<UserPermission> getAdminPermissionAll() throws Exception {
        List<UserPermission> userList = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con2 = DBConnection.connect();

            PreparedStatement ps2 = con2.prepareStatement("SELECT permissions.user_id, permissions.permission_id, permissions.start_date, permissions.motif, permissions.end_date, permissions.start_time, permissions.end_time, permissions.status, users.user_id, users.fullname "
                    + "FROM permissions "
                    + "INNER JOIN users ON permissions.user_id = users.user_id "
                    + "ORDER BY permissions.end_date;");
            ResultSet rs2 = ps2.executeQuery();

            while (rs2.next()) {
                UserPermission p = new UserPermission(
                        rs2.getInt("user_id"),
                        rs2.getInt("permission_id"),
                        rs2.getString("fullname"),
                        rs2.getDate("start_date"),
                        rs2.getDate("end_date"),
                        rs2.getTime("start_time"),
                        rs2.getTime("end_time"),
                        rs2.getString("status"),
                        rs2.getString("motif")
                );
                userList.add(p);
            }

        } catch (ClassNotFoundException | SQLException e) {
            logger.error("ERROR PERMISSION ADMIN REQUESTS (ALL): " + e.getMessage());
        }

        return userList;
    }
    
    

    public List<EmployeeInfo> getEmployeeInfo() throws Exception {
        List<EmployeeInfo> employeesList = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con3 = DBConnection.connect();
            PreparedStatement pst = con3.prepareStatement("SELECT users.user_id, users.fullname, users.email, users.role, holidays.start_date, holidays.end_date, holidays.type,"
                    + "holidays.status FROM users LEFT JOIN holidays ON holidays.user_id = users.user_id AND "
                    + "holidays.holidays_id = (SELECT MAX(holidays_id) FROM holidays WHERE user_id = users.user_id)");

            ResultSet rs3 = pst.executeQuery();

            while (rs3.next()) {
                EmployeeInfo e = new EmployeeInfo(
                        rs3.getInt("user_id"),
                        rs3.getString("fullname"),
                        rs3.getString("email"),
                        rs3.getString("role"),
                        rs3.getString("start_date"),
                        rs3.getString("end_date"),
                        rs3.getString("type"),
                        rs3.getString("status")
                );
                employeesList.add(e);
            }

        } catch (ClassNotFoundException | SQLException e) {
            logger.error("ERROR ADMIN EMPLOYEE INFO: " + e.getMessage());
        }
        return employeesList;
    }

}
