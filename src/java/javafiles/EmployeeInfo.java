package javafiles;

/**
 *
 * @author JS
 */
public class EmployeeInfo {

    private int user_id;
    private byte[] avatar;
    private String avatar_type;
    private String fullname;
    private String email;
    private String role;
    private String start_date;
    private String end_date;
    private String type;
    private String status;

    public EmployeeInfo(int user_id, byte[] avatar, String avatar_type, String fullname, String email, String role, String startDate, String endDate, String type, String status) {
        this.user_id = user_id;
        this.avatar = avatar;
        this.avatar_type = avatar_type;
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
    
    public byte[] getAvatar() {
        return avatar;
    }
    
    public String getAvatarType() {
        return avatar_type;
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
