SetKeyDelay, 0, 100  ; Set delay between keystrokes to 0ms, and delay between key press and release to 100ms

running := false  ; Initialize the running flag as false

F1::  ; Press F1 to toggle the start/stop state of the loop
    running := !running  ; Toggle the running state between true and false
    if (running) {
        ToolTip, Script started...  ; Show a message indicating that the script has started
        Gosub, StartLoop  ; Go to StartLoop label and start the script
    } else {
        ToolTip, Script stopped.  ; Show a message indicating that the script has stopped
    }
return

StartLoop:
CoordMode, Pixel, Screen  ; Set pixel color coordinates relative to the entire screen

Loop {  ; Infinite loop that continues while the script is running

    DisplayStep("PART 1: Check Cell (Processed Box)")
    ; PART 1: Check if the current cell (Processed Box) is processed
    if (!CheckCellProcessed())  ; If the cell is not processed
        continue  ; Skip to the next iteration of the loop

    DisplayStep("PART 2: Check Selected Cell (Username)")
    ; PART 2: Check if the selected cell contains a username
    If (CheckSelectedCellUsername()) {
        DisplayStep("Action - Copy Username and go to Login Page")
        ; Action - Copy the username and switch to the login page
        CopyUsernameAndGoLoginPage()

        DisplayStep("PART 3: Check Page (Login Page)")
        ; PART 3: Ensure we are on the login page
        if (!CheckPageLogin()) {
            continue  ; Skip to the next iteration if not on the login page
        }
        
        DisplayStep("Action - Paste Username")
        ; Action - Paste the copied username into the login field
        PasteUsernameOnLoginPage()

        DisplayStep("PART 4: Check Page (Spreadsheet)")
        ; PART 4: Ensure we are back on the spreadsheet page
        If (!CheckPageSpreadsheet()) {
            continue  ; Skip to the next iteration if not on the spreadsheet page
        }

        DisplayStep("Action - Select Password")
        ; Action - Select the password from the spreadsheet
        SelectPasswordInSpreadsheet()

        DisplayStep("Action - Copy Password and go to Login Page")
        ; Action - Copy the password and switch to the login page
        CopyPasswordAndGoLoginPage()

        DisplayStep("PART 6: Check Page (Login Page)")
        ; PART 6: Ensure we are on the login page again
        if (!CheckPageLogin()) {
            continue  ; Skip to the next iteration if not on the login page
        }
        
        DisplayStep("Action - Enter Password and login")
        ; Action - Enter the password and log in
        EnterPasswordAndLogin()

        DisplayStep("PART 7: Check Page (Dashboard)")
        ; PART 7: Ensure we are on the dashboard page
        if (!CheckPageDashboard()) {
            continue  ; Skip to the next iteration if not on the dashboard page
        }

        DisplayStep("Action - Open Developer Dashboard")
        ; Action - Navigate to the Developer Dashboard via key presses
        Send, {Tab}  ; Press Tab to move through the fields
        Sleep, 75  ; Wait 75ms between actions
        ; Continue pressing Tab until reaching the target field
        Send, {Tab 5}
        Sleep, 75
        Send, {Enter}  ; Press Enter to open the Developer Dashboard

        DisplayStep("Action - Enter API Page")
        ; Action - Navigate to the API page
        EnterAPIPage()

        DisplayStep("PART 8: Check Page (API Page)")
        ; PART 8: Ensure we are on the API page
        If (!CheckPageAPI()) {
            continue  ; Skip to the next iteration if not on the API page
        }

        DisplayStep("Action - Go to Spreadsheet")
        ; Action - Return to the spreadsheet
        GoToSpreadsheet()

        DisplayStep("PART 9: Check Page (Spreadsheet)")
        ; PART 9: Ensure we are back on the spreadsheet
        if (!CheckPageSpreadsheet()) {
            continue  ; Skip to the next iteration if not on the spreadsheet
        }
        
        DisplayStep("Action - Hover username")
        ; Action - Hover over the username cell
        HoverUsernameInSpreadsheet()

        DisplayStep("Action - Copy Username")
        ; Action - Copy the username and navigate to the API Token page
        CopyUsernameAndGoAPIToken()

        DisplayStep("PART 11: Check Page (API Token)")
        ; PART 11: Ensure we are on the API Token page
        If (!CheckPageAPIToken()) {
            continue  ; Skip to the next iteration if not on the API Token page
        }

        DisplayStep("Action - Enter username as API note and create API")
        ; Action - Enter the username into the API note and create the API
        EnterUsernameAndCreateAPIpt1()

        If (!CheckAPILoad()) {
            continue  ; If the API load check fails, skip to the next iteration
        }
        EnterUsernameAndCreateAPIpt2()

        DisplayStep("PART 12: Check Page (Dashboard)")
        ; PART 12: Ensure we are back on the dashboard
        If (!CheckPageAPIToken()) {
            continue  ; Skip to the next iteration if not on the dashboard
        }

        DisplayStep("Action - Open TOS Page")
        ; Action - Open the Terms of Service (TOS) page
        OpenTOSPage()

        If (!CheckPageTOS()) {
            continue  ; Skip to the next iteration if not on the TOS page
        }
        
        SubmitTOS()  ; Submit the TOS

    DisplayStep("PART 14: Check Page (Dashboard 2)")
    ; PART 14: Check if the second dashboard is displayed
    state := CheckPageDashboard()
    if (state == "state1") {
        ; Handle actions specific to state1
        DisplayStep("Action - Return to Spreadsheet for State 1")
        ReturnToSpreadsheet_State1()
    } else if (state == "state2") {
        ; Handle actions specific to state2
        DisplayStep("Action - Return to Spreadsheet for State 2")
        ReturnToSpreadsheet()
    }
		
    ; PART 15: Return to spreadsheet and paste API
    If (!CheckPageSpreadsheet()) {
        continue  ; Skip to the next iteration if not on the spreadsheet
    }
        
    DisplayStep("Action - Paste API and select next cell")
    ; Action - Paste the API and move to the next cell in the spreadsheet
    PasteAPIAndSelectNextCell()
}
return

; Function Definitions

DisplayStep(step) {
    ToolTip, %step%  ; Display the current step in a tooltip
    Sleep, 1000  ; Show the tooltip for 1 second
    ToolTip  ; Hide the tooltip
}

CheckCellProcessed() {
    ; Check if the "Processed" cell is white (0xFFFFFF) using PixelGetColor
    Loop {
        PixelGetColor, color, 1603, 1236  ; Get the pixel color at the specified coordinates
        if (color == 0xFFFFFF) {
            return true  ; Return true if the cell is processed
        }
        Sleep, 100  ; Wait 100ms before rechecking
    }
    return false  ; Return false if the loop exits without finding the condition
}

; Additional functions follow similar commenting patterns, explaining the checks, actions, and logic.
