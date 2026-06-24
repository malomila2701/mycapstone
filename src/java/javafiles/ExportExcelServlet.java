package javafiles;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.TextStyle;
import java.util.*;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

@WebServlet("/ExportExcelServlet")
public class ExportExcelServlet extends HttpServlet {

    private static final Logger logger = LogManager.getLogger(ExportExcelServlet.class.getName());

    private static final double LEGAL_DAYS_PER_MONTH = 2.2;

    private static final String[] LEAVE_TYPES = {
        "Annual Leave", "Seniority", "Maternity Leave",
        "Birthday Leave", "Sick Leave", "Bereavement Leave", "Unpaid Leave", "Other"
    };

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        userdataDAO dao = new userdataDAO();
        Map<Integer, List<UserLeave>> grouped;
        try {
            grouped = dao.getMonthlyLeaveGroupedByUser();
        } catch (Exception e) {
            logger.error("Error fetching data: " + e.getMessage());
            return;
        }

        LocalDate today = LocalDate.now();
        String monthLabel = today.getMonth().getDisplayName(TextStyle.FULL, Locale.ENGLISH)
                            + " " + today.getYear();
        String filename = "leave_report_" + today.getYear() + "_"
                          + String.format("%02d", today.getMonthValue()) + ".xlsx";

        resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        resp.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

        try (XSSFWorkbook wb = new XSSFWorkbook();
             OutputStream out = resp.getOutputStream()) {

            Styles s = new Styles(wb);

            if (grouped.isEmpty()) {
                XSSFSheet empty = wb.createSheet("No Data");
                empty.createRow(0).createCell(0).setCellValue("No leave requests found for this month.");
            } else {
                for (Map.Entry<Integer, List<UserLeave>> entry : grouped.entrySet()) {
                    List<UserLeave> leaves = entry.getValue();
                    UserLeave first = leaves.get(0);
                    XSSFSheet sheet = wb.createSheet(sanitizeSheetName(first.getFullName()));
                    buildSheet(sheet, first, leaves, monthLabel, today, s);
                }
            }

            wb.write(out);
        }
    }

    // ── TOTAL COLUMNS: 0=Type, 1=Days, 2=Start, 3=End, 4=Status, 5=Motif ──
    private static final int TOTAL_COLS = 6; // for merges

    private void buildSheet(XSSFSheet sheet, UserLeave emp, List<UserLeave> leaves,
                            String monthLabel, LocalDate today, Styles s) {
        int row = 0;

        // ── Row 0: Main title ────────────────────────────────────────────────
        Row titleRow = sheet.createRow(row++);
        titleRow.setHeightInPoints(24);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("PRIME CONSULTING — STAFF LEAVE MANAGEMENT");
        titleCell.setCellStyle(s.title);
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, TOTAL_COLS - 1));

        // ── Row 1: Month subtitle ────────────────────────────────────────────
        Row subRow = sheet.createRow(row++);
        subRow.setHeightInPoints(18);
        Cell subCell = subRow.createCell(0);
        subCell.setCellValue("Report Period: " + monthLabel);
        subCell.setCellStyle(s.subtitle);
        sheet.addMergedRegion(new CellRangeAddress(1, 1, 0, TOTAL_COLS - 1));

        // ── Row 2: blank separator ───────────────────────────────────────────
        sheet.createRow(row++).setHeightInPoints(6);

        // ── Rows 3-5: Employee info card ─────────────────────────────────────
        row = writeEmployeeInfo(sheet, emp, s, row);

        // ── Row N: blank separator ───────────────────────────────────────────
        sheet.createRow(row++).setHeightInPoints(6);

        // ── Principles box ───────────────────────────────────────────────────
        row = writePrinciples(sheet, s, row);

        // ── blank separator ──────────────────────────────────────────────────
        sheet.createRow(row++).setHeightInPoints(8);

        // ── Table header ─────────────────────────────────────────────────────
        row = writeTableHeader(sheet, s, row);

        // ── Data rows ────────────────────────────────────────────────────────
        int dataStart = row;
        row = writeDataRows(sheet, leaves, s, row);

        // ── Summary rows ─────────────────────────────────────────────────────
        writeSummaryRows(sheet, dataStart, row, s);

        // ── Column widths ────────────────────────────────────────────────────
        sheet.setColumnWidth(0, 26 * 256); // Leave Type
        sheet.setColumnWidth(1, 12 * 256); // Days
        sheet.setColumnWidth(2, 16 * 256); // Start Date
        sheet.setColumnWidth(3, 16 * 256); // End Date
        sheet.setColumnWidth(4, 16 * 256); // Status
        sheet.setColumnWidth(5, 35 * 256); // Motif
    }

    // ── Employee info: 2-column card layout ─────────────────────────────────
    private int writeEmployeeInfo(XSSFSheet sheet, UserLeave emp, Styles s, int row) {

        // Label row background
        Row labelRow = sheet.createRow(row++);
        labelRow.setHeightInPoints(15);

        // Left side labels
        Cell lName  = labelRow.createCell(0); lName.setCellValue("Full Name");  lName.setCellStyle(s.infoLabel);
        Cell lId    = labelRow.createCell(3); lId.setCellValue("Employee ID");  lId.setCellStyle(s.infoLabel);

        sheet.addMergedRegion(new CellRangeAddress(row - 1, row - 1, 0, 2));
        sheet.addMergedRegion(new CellRangeAddress(row - 1, row - 1, 3, 5));

        // Value row
        Row valueRow = sheet.createRow(row++);
        valueRow.setHeightInPoints(18);

        Cell vName = valueRow.createCell(0);
        vName.setCellValue(emp.getFullName() != null ? emp.getFullName() : "—");
        vName.setCellStyle(s.infoValue);
        sheet.addMergedRegion(new CellRangeAddress(row - 1, row - 1, 0, 2));

        Cell vId = valueRow.createCell(3);
        vId.setCellValue(emp.getUserId());
        vId.setCellStyle(s.infoValueCenter);
        sheet.addMergedRegion(new CellRangeAddress(row - 1, row - 1, 3, 5));

        // Second label row
        Row labelRow2 = sheet.createRow(row++);
        labelRow2.setHeightInPoints(15);
        Cell lDate = labelRow2.createCell(0); lDate.setCellValue("Entrance Date"); lDate.setCellStyle(s.infoLabel);
        sheet.addMergedRegion(new CellRangeAddress(row - 1, row - 1, 0, 5));

        // Second value row
        Row valueRow2 = sheet.createRow(row++);
        valueRow2.setHeightInPoints(18);
        Cell vDate = valueRow2.createCell(0);
        if (emp.getEntranceDate() != null) {
            vDate.setCellValue(emp.getEntranceDate().toLocalDate()
                .format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        } else {
            vDate.setCellValue("—");
        }
        vDate.setCellStyle(s.infoValue);
        sheet.addMergedRegion(new CellRangeAddress(row - 1, row - 1, 0, 5));

        return row;
    }

    // ── Principles box ───────────────────────────────────────────────────────
    private int writePrinciples(XSSFSheet sheet, Styles s, int row) {
        String[] lines = {
            "Accrual Rules:",
            "  • 2.2 working days accrued per month worked",
            "  • Seniority bonus: +1 day at 5 yrs · +2 days at 10 yrs · +3 days at 15 yrs",
            "  • Other leave: recoveries, weddings, births, bereavements, relocations, etc."
        };

        for (int i = 0; i < lines.length; i++) {
            Row r = sheet.createRow(row++);
            r.setHeightInPoints(15);
            Cell c = r.createCell(0);
            c.setCellValue(lines[i]);
            c.setCellStyle(i == 0 ? s.principleTitle : s.principleBody);
            sheet.addMergedRegion(new CellRangeAddress(row - 1, row - 1, 0, TOTAL_COLS - 1));
        }
        return row;
    }

    // ── Table header ─────────────────────────────────────────────────────────
    private int writeTableHeader(XSSFSheet sheet, Styles s, int row) {
        Row hdr = sheet.createRow(row++);
        hdr.setHeightInPoints(20);

        String[] headers = { "Leave Type", "Days", "Start Date", "End Date", "Status", "Reason / Motif" };
        for (int i = 0; i < headers.length; i++) {
            Cell c = hdr.createCell(i);
            c.setCellValue(headers[i]);
            c.setCellStyle(s.tableHeader);
        }
        return row;
    }

    // ── Data rows ────────────────────────────────────────────────────────────
    private int writeDataRows(XSSFSheet sheet, List<UserLeave> leaves, Styles s, int row) {
        DateTimeFormatter fmt = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy");

        for (UserLeave ul : leaves) {
            Row r = sheet.createRow(row++);
            r.setHeightInPoints(16);

            double days = workingDaysBetween(ul.getStartDate(), ul.getEndDate());
            boolean isApproved = "approved".equalsIgnoreCase(ul.getStatus());
            boolean isPending  = "pending".equalsIgnoreCase(ul.getStatus());

            CellStyle rowStyle     = isApproved ? s.rowApproved : (isPending ? s.rowPending : s.rowRejected);
            CellStyle rowStyleNum  = isApproved ? s.rowApprovedNum : (isPending ? s.rowPendingNum : s.rowRejectedNum);

            Cell cType   = r.createCell(0); cType.setCellValue(mapType(ul.getType()));          cType.setCellStyle(rowStyle);
            Cell cDays   = r.createCell(1); cDays.setCellValue(days);                           cDays.setCellStyle(rowStyleNum);
            Cell cStart  = r.createCell(2);
            if (ul.getStartDate() != null) cStart.setCellValue(ul.getStartDate().toLocalDate().format(fmt));
            cStart.setCellStyle(rowStyle);
            Cell cEnd    = r.createCell(3);
            if (ul.getEndDate() != null) cEnd.setCellValue(ul.getEndDate().toLocalDate().format(fmt));
            cEnd.setCellStyle(rowStyle);
            Cell cStatus = r.createCell(4); cStatus.setCellValue(ul.getStatus());               cStatus.setCellStyle(rowStyle);
            Cell cMotif  = r.createCell(5); cMotif.setCellValue(ul.getMotif() != null ? ul.getMotif() : ""); cMotif.setCellStyle(rowStyle);
        }
        return row;
    }

    // ── Summary rows ─────────────────────────────────────────────────────────
    private void writeSummaryRows(XSSFSheet sheet, int dataStart, int row, Styles s) {
        // Excel rows are 1-indexed
        int exS = dataStart + 1;
        int exE = row;

        // Total Days Requested
        Row rTotal = sheet.createRow(row++);
        rTotal.setHeightInPoints(18);
        Cell lTotal = rTotal.createCell(0); lTotal.setCellValue("Total Days Requested"); lTotal.setCellStyle(s.summaryOrange);
        Cell vTotal = rTotal.createCell(1);
        vTotal.setCellFormula("SUM(B" + exS + ":B" + exE + ")");
        vTotal.setCellStyle(s.summaryOrangeNum);
        for (int i = 2; i < TOTAL_COLS; i++) rTotal.createCell(i).setCellStyle(s.summaryOrange);

        // Approved Days
        Row rAppr = sheet.createRow(row++);
        rAppr.setHeightInPoints(18);
        Cell lAppr = rAppr.createCell(0); lAppr.setCellValue("Approved Days"); lAppr.setCellStyle(s.summaryGreen);
        Cell vAppr = rAppr.createCell(1); vAppr.setCellStyle(s.summaryGreenNum);
        // Count approved only — we use SUMIF across the status column (col E = col index 4 = "E")
        vAppr.setCellFormula("SUMIF(E" + exS + ":E" + exE + ",\"approved\",B" + exS + ":B" + exE + ")");
        for (int i = 2; i < TOTAL_COLS; i++) rAppr.createCell(i).setCellStyle(s.summaryGreen);

        // Pending Days
        Row rPend = sheet.createRow(row++);
        rPend.setHeightInPoints(18);
        Cell lPend = rPend.createCell(0); lPend.setCellValue("Pending Days"); lPend.setCellStyle(s.summaryBlue);
        Cell vPend = rPend.createCell(1); vPend.setCellStyle(s.summaryBlueNum);
        vPend.setCellFormula("SUMIF(E" + exS + ":E" + exE + ",\"pending\",B" + exS + ":B" + exE + ")");
        for (int i = 2; i < TOTAL_COLS; i++) rPend.createCell(i).setCellStyle(s.summaryBlue);
    }

    // ── Helpers ──────────────────────────────────────────────────────────────
    private String mapType(String type) {
        if (type == null) return "Other";
        return switch (type.toLowerCase()) {
            case "annual leave"      -> "Annual Leave";
            case "seniority"         -> "Seniority";
            case "maternity leave"   -> "Maternity Leave";
            case "birthday leave"    -> "Birthday Leave";
            case "sick leave"        -> "Sick Leave";
            case "bereavement leave" -> "Bereavement Leave";
            case "unpaid leave"      -> "Unpaid Leave";
            default                  -> "Other";
        };
    }

    private double workingDaysBetween(java.sql.Date start, java.sql.Date end) {
        if (start == null || end == null) return 0;
        LocalDate s = start.toLocalDate();
        LocalDate e = end.toLocalDate();
        long days = 0;
        while (!s.isAfter(e)) {
            java.time.DayOfWeek dow = s.getDayOfWeek();
            if (dow != java.time.DayOfWeek.SATURDAY && dow != java.time.DayOfWeek.SUNDAY) days++;
            s = s.plusDays(1);
        }
        return days;
    }

    private String sanitizeSheetName(String name) {
        if (name == null) return "Employee";
        String clean = name.replaceAll("[\\[\\]*/\\\\?:]", "");
        return clean.length() > 31 ? clean.substring(0, 31) : clean;
    }

    // ── Styles ───────────────────────────────────────────────────────────────
    private static class Styles {
        final CellStyle title, subtitle;
        final CellStyle infoLabel, infoValue, infoValueCenter;
        final CellStyle principleTitle, principleBody;
        final CellStyle tableHeader;
        final CellStyle rowApproved, rowApprovedNum;
        final CellStyle rowPending,  rowPendingNum;
        final CellStyle rowRejected, rowRejectedNum;
        final CellStyle summaryOrange, summaryOrangeNum;
        final CellStyle summaryGreen,  summaryGreenNum;
        final CellStyle summaryBlue,   summaryBlueNum;

        Styles(XSSFWorkbook wb) {
            XSSFColor navy      = c(wb, 0x1F, 0x49, 0x7D);
            XSSFColor navyLight = c(wb, 0xD6, 0xE4, 0xF0);
            XSSFColor orange    = c(wb, 0xFF, 0xC0, 0x00);
            XSSFColor orangeLight = c(wb, 0xFF, 0xF2, 0xCC);
            XSSFColor greenFill = c(wb, 0xE2, 0xEF, 0xDA);
            XSSFColor greenDark = c(wb, 0x37, 0x86, 0x10);
            XSSFColor blueFill  = c(wb, 0xDD, 0xEB, 0xF7);
            XSSFColor redFill   = c(wb, 0xFF, 0xE0, 0xE0);
            XSSFColor pendFill  = c(wb, 0xFF, 0xF9, 0xE6);
            XSSFColor infoLabelBg = c(wb, 0x2E, 0x75, 0xB6);
            XSSFColor infoValueBg = c(wb, 0xF2, 0xF7, 0xFD);
            XSSFColor principleBg = c(wb, 0xF5, 0xF5, 0xF5);

            Font fTitleW = font(wb, "Calibri", 14, true, IndexedColors.WHITE.getIndex());
            Font fSubW   = font(wb, "Calibri", 11, false, IndexedColors.WHITE.getIndex());
            Font fBold   = font(wb, "Calibri", 10, true,  IndexedColors.AUTOMATIC.getIndex());
            Font fNorm   = font(wb, "Calibri", 10, false, IndexedColors.AUTOMATIC.getIndex());
            Font fWhite  = font(wb, "Calibri", 10, true,  IndexedColors.WHITE.getIndex());
            Font fPrinT  = font(wb, "Calibri", 10, true,  IndexedColors.AUTOMATIC.getIndex());
            Font fPrinB  = font(wb, "Calibri", 9,  false, IndexedColors.AUTOMATIC.getIndex());
            Font fGreenD = fontColor(wb, "Calibri", 10, true, greenDark);
            Font fNavy   = fontColor(wb, "Calibri", 10, true, navy);

            // ── Title / subtitle (solid navy background) ──────────────────────
            title    = fill(wb, navy, fTitleW, HorizontalAlignment.CENTER, 0);
            subtitle = fill(wb, navy, fSubW,   HorizontalAlignment.CENTER, 0);

            // ── Employee info card ────────────────────────────────────────────
            infoLabel       = fill(wb, infoLabelBg, fWhite, HorizontalAlignment.LEFT, BorderStyle.THIN.ordinal());
            infoValue       = fill(wb, infoValueBg, fBold,  HorizontalAlignment.LEFT, BorderStyle.THIN.ordinal());
            infoValueCenter = fill(wb, infoValueBg, fBold,  HorizontalAlignment.CENTER, BorderStyle.THIN.ordinal());

            // ── Principles ────────────────────────────────────────────────────
            principleTitle = fill(wb, principleBg, fPrinT, HorizontalAlignment.LEFT, 0);
            principleBody  = fill(wb, principleBg, fPrinB, HorizontalAlignment.LEFT, 0);

            // ── Table header ──────────────────────────────────────────────────
            tableHeader = fill(wb, navy, fWhite, HorizontalAlignment.CENTER, BorderStyle.THIN.ordinal());

            // ── Data rows by status ───────────────────────────────────────────
            rowApproved    = fill(wb, greenFill, fNorm, HorizontalAlignment.LEFT,   BorderStyle.THIN.ordinal());
            rowApprovedNum = fill(wb, greenFill, fNorm, HorizontalAlignment.CENTER, BorderStyle.THIN.ordinal());
            rowApprovedNum.setDataFormat(wb.createDataFormat().getFormat("0.0"));

            rowPending    = fill(wb, pendFill, fNorm, HorizontalAlignment.LEFT,   BorderStyle.THIN.ordinal());
            rowPendingNum = fill(wb, pendFill, fNorm, HorizontalAlignment.CENTER, BorderStyle.THIN.ordinal());
            rowPendingNum.setDataFormat(wb.createDataFormat().getFormat("0.0"));

            rowRejected    = fill(wb, redFill, fNorm, HorizontalAlignment.LEFT,   BorderStyle.THIN.ordinal());
            rowRejectedNum = fill(wb, redFill, fNorm, HorizontalAlignment.CENTER, BorderStyle.THIN.ordinal());
            rowRejectedNum.setDataFormat(wb.createDataFormat().getFormat("0.0"));

            // ── Summary rows ──────────────────────────────────────────────────
            summaryOrange    = fill(wb, orange,     fBold,   HorizontalAlignment.LEFT,   BorderStyle.MEDIUM.ordinal());
            summaryOrangeNum = fill(wb, orange,     fBold,   HorizontalAlignment.CENTER, BorderStyle.MEDIUM.ordinal());
            summaryOrangeNum.setDataFormat(wb.createDataFormat().getFormat("0.0"));

            summaryGreen    = fill(wb, greenFill,  fGreenD, HorizontalAlignment.LEFT,   BorderStyle.MEDIUM.ordinal());
            summaryGreenNum = fill(wb, greenFill,  fGreenD, HorizontalAlignment.CENTER, BorderStyle.MEDIUM.ordinal());
            summaryGreenNum.setDataFormat(wb.createDataFormat().getFormat("0.0"));

            summaryBlue    = fill(wb, blueFill,   fNavy,   HorizontalAlignment.LEFT,   BorderStyle.MEDIUM.ordinal());
            summaryBlueNum = fill(wb, blueFill,   fNavy,   HorizontalAlignment.CENTER, BorderStyle.MEDIUM.ordinal());
            summaryBlueNum.setDataFormat(wb.createDataFormat().getFormat("0.0"));
        }

        private XSSFCellStyle fill(XSSFWorkbook wb, XSSFColor bg, Font f,
                                   HorizontalAlignment align, int borderOrdinal) {
            XSSFCellStyle cs = wb.createCellStyle();
            cs.setFont(f);
            cs.setFillForegroundColor(bg);
            cs.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            cs.setAlignment(align);
            cs.setVerticalAlignment(VerticalAlignment.CENTER);
            BorderStyle border = borderOrdinal == BorderStyle.MEDIUM.ordinal()
                ? BorderStyle.MEDIUM : (borderOrdinal == 0 ? BorderStyle.NONE : BorderStyle.THIN);
            cs.setBorderTop(border); cs.setBorderBottom(border);
            cs.setBorderLeft(border); cs.setBorderRight(border);
            cs.setWrapText(false);
            return cs;
        }

        private Font font(XSSFWorkbook wb, String name, int size, boolean bold, short colorIdx) {
            XSSFFont f = wb.createFont();
            f.setFontName(name); f.setFontHeightInPoints((short) size); f.setBold(bold);
            f.setColor(colorIdx);
            return f;
        }

        private Font fontColor(XSSFWorkbook wb, String name, int size, boolean bold, XSSFColor color) {
            XSSFFont f = wb.createFont();
            f.setFontName(name); f.setFontHeightInPoints((short) size); f.setBold(bold);
            f.setColor(color);
            return f;
        }

        private XSSFColor c(XSSFWorkbook wb, int r, int g, int b) {
            return new XSSFColor(new byte[]{(byte) r, (byte) g, (byte) b}, null);
        }
    }
}