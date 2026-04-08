package javafiles;

/**
 *
 * @author JS
 */
public class EmployeeInfo {

    private int user_id;
    private String fullname;
    private String email;
    private String role;
    private String start_date;
    private String end_date;
    private String type;
    private String status;

    public EmployeeInfo(int user_id, String fullname, String email, String role, String startDate, String endDate, String type, String status) {
        this.user_id = user_id;
        this.fullname = fullname;
        this.email = email;
        this.role = role;
        this.start_date = startDate;
        this.end_date = endDate;
        this.type = type;
        this.status = status;

    }
    
    public int getUserId() {
        return user_id;
    }
    
    public String getFullName() {
        return fullname;
    }
    
    public String getEmail() {
        return email;
    }
    
    public String getRole() {
        return role;
    }

    public String getStartDate() {
        return start_date;
    }
    
    public String getEndDate() {
        return end_date;
    }

    public String getType() {
        return type;
    }

    public String getStatus() {
        return status;
    }
}
