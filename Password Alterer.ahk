; ===============================================
; AutoHotkey Script for Automating Google Sheets Task
; ===============================================

; ============================
; ===== Configuration ========
; ============================

; Coordinates and Colors
SpreadsheetLogoX := 40
SpreadsheetLogoY := 141
SpreadsheetLogoColor := 0x00AC47

; Password Reset Status Cell Check
RowStatusX := 738
RowStatusY := 1284
YellowColor := 0xFFFF00
GreenColor := 0xB7E1CD

; Password Select Cell Check
TabBoxX := 657
TabBoxY := 1276
TabBoxColor := 0x1A73E8

; Website Select Cell Check Ensure Correct Cell is Selected
CellSelectionX := 474    ; Updated X coordinate
CellSelectionY := 1309   ; Updated Y coordinate
CellSelectionColor := 0x1A73E8  ; Updated color

; Unique Spots on Oura Password Reset
WebsiteLoadColor1X := 1968
WebsiteLoadColor1Y := 1311
WebsiteLoadColor1 := 0xADB7CC

WebsiteLoadColor2X := 201
WebsiteLoadColor2Y := 190
WebsiteLoadColor2 := 0x24477B

WebsiteLoadColor3X := 377
WebsiteLoadColor3Y := 620
WebsiteLoadColor3 := 0x8D9DB5

WebsiteLoadColor4X := 1920
WebsiteLoadColor4Y := 733
WebsiteLoadColor4 := 0xEFEBE5

; Unique Spot after Oura Password Reset
DataEntryX := 224
DataEntryY := 533
DataEntryColor := 0x2F4A73

; Log File Path
LogFilePath := A_ScriptDir . "\ScriptLog.txt"

; ============================
; ===== Global Variables =====
; ============================

global running := false         ; Flag to indicate if the script is running

; ============================
; ===== Coordinate Mode =====
; ============================

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

; ============================
; ===== Hotkey Definitions =====
; ============================

; Hotkey to start the script: Press "." to initiate
.::  
    if (!running)
    {
        running := true
        SetGUIColor("Green")
        UpdateStepStatus("Automation Started")
        Log("Automation Started")
        StartAutomation()
    }
    Return

; Hotkey to stop the script: Press "," to terminate
,::
    if (running)
    {
        running := false
        SetGUIColor("Red")
        UpdateStepStatus("Automation Stopped")
        Log("Automation Stopped")
    }
    Return

; ============================
; ===== Function Definitions =====
; ============================

; Function to set the GUI color (Top-Left Indicator) (I took this out but I don't want to take it out of the code just in case it breaks)
SetGUIColor(color)
{
    Gui, ScriptStatus:Color, % color
}

; Function to update the step status (Bottom-Right Indicator) and log the step (I took this out but I don't want to take it out of the code just in case it breaks)
UpdateStepStatus(text)
{
    GuiControl,, StepText, % "Step: " . text
    Log("Step: " . text)
}

; Function to log messages to a file
Log(message)
{
    FormatTime, TimeString,, yyyy-MM-dd HH:mm:ss
    FileAppend, [%TimeString%] %message%`n, %LogFilePath%
}

; Function to start the main automation script
StartAutomation()
{
    ; ====================
    ; ===== Check 1 ======
    ; ====================
    UpdateStepStatus("Check 1: Ensure Spreadsheet is Open")
    Log("Performing Check 1: Ensure Spreadsheet is Open")
    while (running and !CheckSpreadsheet())
    {
        Log("Error: Spreadsheet not detected. Retrying Check 1...")
        Sleep, 1000
    }
    if (!running)
        return
    Log("Check 1 Passed: Spreadsheet is open.")
    UpdateStepStatus("Check 1 Passed: Spreadsheet is open.")

    ; ====================
    ; ===== Main Loop ======
    ; ====================
    Loop
    {
        if (!running)
            break

        ; ====================
        ; ===== Check 2 ======
        ; ====================
        UpdateStepStatus("Check 2: Determine if Row Needs Processing")
        Log("Performing Check 2: Determine if Row Needs Processing")
        while (running and !CheckRowProcessed())
        {
            Log("Row already processed. Skipping to next row.")
            ; Move to the next row
            Send, {Down}
            Sleep, 500
            ; Recheck if the new row needs processing
            if (!CheckRowProcessed())
                continue
        }
        if (!running)
            break
        Log("Row needs processing.")
        UpdateStepStatus("Check 2 Passed: Row needs processing.")

        ; ====================
        ; ===== Check 3 ======
        ; ====================
        UpdateStepStatus("Check 3: Ensure Correct Tab is Selected")
        Log("Performing Check 3: Ensure Correct Tab is Selected")
        while (running and !CheckTabSelected())
        {
            Log("Error: Incorrect tab selected. Retrying Check 3...")
            Sleep, 1000
        }
        if (!running)
            break
        Log("Check 3 Passed: Correct tab selected.")
        UpdateStepStatus("Check 3 Passed: Correct tab selected.")

        ; ====================
        ; ===== Copy & Navigate ======
        ; ====================
        UpdateStepStatus("Copying Data and Navigating")
        Log("Performing Copy & Navigate")
        Send, ^c         ; Copy current cell data (Ctrl+C)
        Sleep, 200       ; Brief pause to ensure copy operation completes
        Send, {Left}     ; Move left to the adjacent cell
        Sleep, 200
        Log("Copied data and moved left to adjacent cell.")
        UpdateStepStatus("Copying Data and Navigating Completed")

        ; ====================
        ; ===== Check 4 ======
        ; ====================
        UpdateStepStatus("Check 4: Ensure Correct Cell is Selected")
        Log("Performing Check 4: Ensure Correct Cell is Selected")
        while (running and !CheckCellSelected())
        {
            Log("Error: Incorrect cell selection at (" . CellSelectionX . ", " . CellSelectionY . "). Retrying Check 4...")
            Sleep, 1000
        }
        if (!running)
            break
        Log("Check 4 Passed: Correct cell selected.")
        UpdateStepStatus("Check 4 Passed: Correct cell selected.")

        ; ====================
        ; ===== Open Link ======
        ; ====================
        UpdateStepStatus("Opening Link")
        Log("Opening Link")
        Send, !{Enter}   ; Press Alt+Enter to open the link in a new tab
        Sleep, 1000        ; Wait for the tab to open
        Log("Opened link in new browser tab.")
        UpdateStepStatus("Opening Link Completed")

        ; ====================
        ; ===== Check 5 ======
        ; ====================
        UpdateStepStatus("Check 5: Ensure Website is Loaded")
        Log("Performing Check 5: Ensure Website is Loaded")
        while (running and !CheckWebsiteLoading())
        {
            Log("Error: Website not loaded properly. Retrying Check 5...")
            Sleep, 1000
        }
        if (!running)
            break
        Log("Check 5 Passed: Website loaded successfully.")
        UpdateStepStatus("Check 5 Passed: Website loaded successfully.")

        ; ====================
        ; ===== Perform Actions on Website ======
        ; ====================
		; Perform a left-click to focus on the input field
		Click, left

		; Optional: Add a brief pause to ensure the click is registered
		Sleep, 200
        UpdateStepStatus("Performing Actions on Website")
        Log("Performing Actions on Website")
        Send, {Tab}      ; Move to first input field
        Sleep, 200
        Send, ^v         ; Paste data (Ctrl+V)
        Sleep, 200
        Send, {Tab}      ; Move to next field
        Sleep, 200
        Send, {Tab}      ; Move to third field
        Sleep, 200
        Send, ^v         ; Paste data again if needed (Ctrl+V)
        Sleep, 200
        Send, {Tab}      ; Move to next field
        Sleep, 200
        Send, {Tab}      ; Move to fifth field
        Sleep, 200
        Send, {Enter}    ; Submit form or confirm action
        Sleep, 500
        Log("Performed actions on website.")
        UpdateStepStatus("Performing Actions on Website Completed")

        ; ====================
        ; ===== Check 6 ======
        ; ====================
        UpdateStepStatus("Check 6: Verify Data Entry")
        Log("Performing Check 6: Verify Data Entry")
        while (running and !CheckDataEntry())
        {
            Log("Error: Data entry verification failed. Retrying Check 6...")
            Sleep, 1000
        }
        if (!running)
            break
        Log("Check 6 Passed: Data entry verified.")
        UpdateStepStatus("Check 6 Passed: Data entry verified.")

        ; ====================
        ; ===== Close Tab ======
        ; ====================
        UpdateStepStatus("Closing Website Tab")
        Log("Closing Website Tab")
        Send, ^w         ; Close the current browser tab (Ctrl+W)
        Sleep, 500        ; Brief pause to ensure tab closes
        Log("Closed website tab.")
        UpdateStepStatus("Closing Website Tab Completed")

        ; ====================
        ; ===== Return to Spreadsheet & Mark Processed ======
        ; ====================
        UpdateStepStatus("Marking Row as Processed")
        Log("Marking Row as Processed")
        Send, {Right}     ; Move right to designated cell
        Sleep, 200
		Send, {Right}     ; Move right to designated cell
        Sleep, 200
        Send, Y           ; Enter "Y" in the cell
        Sleep, 200
        Send, {Enter}     ; Press Enter to confirm and move down to the next row
		Sleep, 200
		Send, {Left}
        Sleep, 500        ; Brief pause to ensure the selection moves down
        Log("Marked row as processed.")
        UpdateStepStatus("Marking Row as Processed Completed")

        ; Proceed to the next iteration (next row)
        Log("Cycle Completed: Moving to the next row.")
        UpdateStepStatus("Cycle Completed: Moving to the next row.")
        Sleep, 500        ; Brief pause before the next cycle
    }
}

; ============================
; ===== Check Functions ======
; ============================

; Check 1: Ensure Spreadsheet is Open
CheckSpreadsheet()
{
    global SpreadsheetLogoX, SpreadsheetLogoY, SpreadsheetLogoColor
    PixelSearch, Px, Py, SpreadsheetLogoX, SpreadsheetLogoY, SpreadsheetLogoX, SpreadsheetLogoY, SpreadsheetLogoColor, 20, Fast RGB
    if (ErrorLevel = 0)
    {
        Log("Spreadsheet logo detected at (" . Px . ", " . Py . ").")
        return true  ; Spreadsheet is open
    }
    return false   ; Spreadsheet not detected
}

; Check 2: Determine if Row Needs Processing
CheckRowProcessed()
{
    global RowStatusX, RowStatusY, YellowColor, GreenColor
    PixelSearch, Px, Py, RowStatusX, RowStatusY, RowStatusX, RowStatusY, YellowColor, 20, Fast RGB  ; Check for Yellow
    if (ErrorLevel = 0)
    {
        Log("Row status: Yellow (Needs Processing).")
        return true  ; Row needs processing
    }
    PixelSearch, Px, Py, RowStatusX, RowStatusY, RowStatusX, RowStatusY, GreenColor, 20, Fast RGB  ; Check for Green
    if (ErrorLevel = 0)
    {
        Log("Row status: Green (Already Processed).")
        return false  ; Row already processed
    }
    return false   ; Neither color detected
}

; Check 3: Ensure Correct Tab is Selected
CheckTabSelected()
{
    global TabBoxX, TabBoxY, TabBoxColor
    PixelSearch, Px, Py, TabBoxX, TabBoxY, TabBoxX, TabBoxY, TabBoxColor, 20, Fast RGB  ; Check for Blue
    if (ErrorLevel = 0)
    {
        Log("Correct tab selected at (" . Px . ", " . Py . ").")
        return true  ; Correct tab selected
    }
    return false   ; Incorrect tab selection
}

; Check 4: Ensure Correct Cell is Selected
CheckCellSelected()
{
    global CellSelectionX, CellSelectionY, CellSelectionColor
    PixelSearch, Px, Py, CellSelectionX, CellSelectionY, CellSelectionX, CellSelectionY, CellSelectionColor, 20, Fast RGB  ; Check for Updated Color
    if (ErrorLevel = 0)
    {
        Log("Correct cell selected at (" . Px . ", " . Py . ").")
        return true  ; Correct cell selected
    }
    return false   ; Incorrect cell selection
}

; Check 5: Ensure Website is Loaded
CheckWebsiteLoading()
{
    ; Check four separate pixels (including the new one)
    global WebsiteLoadColor1X, WebsiteLoadColor1Y, WebsiteLoadColor1
    global WebsiteLoadColor2X, WebsiteLoadColor2Y, WebsiteLoadColor2
    global WebsiteLoadColor3X, WebsiteLoadColor3Y, WebsiteLoadColor3
    global WebsiteLoadColor4X, WebsiteLoadColor4Y, WebsiteLoadColor4  ; New pixel

    ; Check WebsiteLoadColor1
    PixelSearch, Px, Py, WebsiteLoadColor1X, WebsiteLoadColor1Y, WebsiteLoadColor1X, WebsiteLoadColor1Y, WebsiteLoadColor1, 20, Fast RGB
    if (ErrorLevel != 0)
        return false
	Sleep, 200
    ; Check WebsiteLoadColor2
    PixelSearch, Px, Py, WebsiteLoadColor2X, WebsiteLoadColor2Y, WebsiteLoadColor2X, WebsiteLoadColor2Y, WebsiteLoadColor2, 20, Fast RGB
    if (ErrorLevel != 0)
        return false
	Sleep, 200
    ; Check WebsiteLoadColor3
    PixelSearch, Px, Py, WebsiteLoadColor3X, WebsiteLoadColor3Y, WebsiteLoadColor3X, WebsiteLoadColor3Y, WebsiteLoadColor3, 20, Fast RGB
    if (ErrorLevel != 0)
        return false
	Sleep, 200
    ; **New Addition:** Check WebsiteLoadColor4
    PixelSearch, Px, Py, WebsiteLoadColor4X, WebsiteLoadColor4Y, WebsiteLoadColor4X, WebsiteLoadColor4Y, WebsiteLoadColor4, 20, Fast RGB
    if (ErrorLevel != 0)
        return false

    Log("All website load indicators detected successfully.")
    return true  ; All required colors found, website loaded
}

; Check 6: Verify Data Entry
CheckDataEntry()
{
    global DataEntryX, DataEntryY, DataEntryColor
    PixelSearch, Px, Py, DataEntryX, DataEntryY, DataEntryX, DataEntryY, DataEntryColor, 20, Fast RGB  ; Check for confirmation color
    if (ErrorLevel = 0)
    {
        Log("Data entry confirmed at (" . Px . ", " . Py . ").")
        return true  ; Data entry confirmed
    }
    return false   ; Data entry not confirmed
}

; ============================
; ===== Script End ======
; ============================
