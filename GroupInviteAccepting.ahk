#Persistent
#SingleInstance force

; Set up hotkeys
F11:: ; When F11 is pressed, start running the code
    SetTimer, CheckAndRun, 100  ; Start the loop
    return

CheckAndRun:
    if (CheckColour_SpreadsheetOpen() && CheckColour_OuraLoginPage() && CheckColour_ShareDataPage() && CheckColour_OuraDashboard()) {
        RunScript() ; Call the main script function if all checks pass
    }
    return

RunScript() {
    ; Step 1: Open Link
    StepIndicator("Action: Open Link")
    Send !{Enter} ; Alt + Enter
    Sleep, 100
    Send ^{Tab} ; Control + Tab
    Sleep, 100

    ; Step 2: Check Spreadsheet Open
    While (!CheckColour_SpreadsheetOpen()) {
        Sleep, 100
    }

    ; Step 3: Copy Username
    StepIndicator("Action: Copy Username")
    Send {Left} ; Move 6 steps to the left
    Sleep, 100
    Send {Left} ; Move 6 steps to the left
    Sleep, 100
    Send {Left} ; Move 6 steps to the left
    Sleep, 100
    Send {Left} ; Move 6 steps to the left
    Sleep, 100
    Send {Left} ; Move 6 steps to the left
    Sleep, 100
    Send {Left} ; Move 6 steps to the left
    Sleep, 100
    Send ^c ; Control + C
    Sleep, 100
    Send ^{Tab} ; Control + Tab
    Sleep, 100

    ; Step 4: Check Oura Login Page
    While (!CheckColour_OuraLoginPage()) {
        Sleep, 100
    }

    ; Step 5: Enter Username
    StepIndicator("Action: Enter Username")
    Send {Tab} ; Press Tab twice
    Sleep, 100
    Send {Tab} ; Press Tab twice
    Sleep, 100
    Send ^v ; Control + V to paste the username
    Sleep, 100
    Send ^{Tab} ; Control + Tab
    Sleep, 100

    ; Step 6: Check Spreadsheet Open Again
    While (!CheckColour_SpreadsheetOpen()) {
        Sleep, 100
    }

    ; Step 7: Copy and Enter Password
    StepIndicator("Action: Copy and Enter Password")
    Send {Right} ; Move 1 step to the right
    Sleep, 100
    Send ^c ; Control + C to copy the password
    Sleep, 100
    Send ^{Tab} ; Control + Tab
    Sleep, 100
    Send {Tab} ; Tab
    Sleep, 100
    Send ^v ; Control + V to paste the password
    Sleep, 100
    Send {Tab} ; Tab twice
    Sleep, 100
    Send {Tab} ; Tab twice
    Sleep, 100
    Send {Enter} ; Enter to log in
    Sleep, 100

    ; Step 8: Check Share Data Page
    While (!CheckColour_ShareDataPage()) {
        Sleep, 100
    }

    ; Step 9: Share Data
    StepIndicator("Action: Share Data")
    Send {Tab} ; Press Tab five times
    Sleep, 100
    Send {Tab} ; Press Tab five times
    Sleep, 100
    Send {Tab} ; Press Tab five times
    Sleep, 100
    Send {Tab} ; Press Tab five times
    Sleep, 100
    Send {Tab} ; Press Tab five times
    Sleep, 100
    Send ^{Tab} ; Control + Tab
    Sleep, 100

    ; Step 10: Check Spreadsheet Again
    While (!CheckColour_SpreadsheetOpen()) {
        Sleep, 100
    }

    ; Step 11: Paste Share Data
    StepIndicator("Action: Paste Share Data")
    Send {Left} ; Move 3 steps to the left
    Sleep, 100
    Send {Left} ; Move 3 steps to the left
    Sleep, 100
    Send {Left} ; Move 3 steps to the left
    Sleep, 100
    Send ^c ; Control + C
    Sleep, 100
    Send ^{Tab} ; Control + Tab
    Sleep, 100
    Send ^v ; Control + V to paste the data
    Sleep, 100
    MouseClick, Left, 831, 554 ; Perform a click action
    Sleep, 100
    Mouseclick, Left, 1646, 875 ; Perform a second click action
    Sleep, 100

    ; Step 12: Check Share Data Page Again
    While (!CheckColour_ShareDataPage()) {
        Sleep, 100
    }

    ; Step 13: Enter Dashboard
    StepIndicator("Action: Enter Dashboard")
    Send {Tab} ; Press Tab
    Sleep, 100
    Send {Enter} ; Press Enter to enter the dashboard
    Sleep, 100

    ; Step 14: Check Oura Dashboard
    While (!CheckColour_OuraDashboard()) {
        Sleep, 100
    }

    ; Step 15: Sign Out
    StepIndicator("Action: Sign Out")
    MouseClick, Left, 2450, 229; Click to sign out
    Sleep, 100
    MouseClick, Left, 2328,418; Confirm the sign-out
    Sleep, 100

    ; Step 16: Check Oura Login Page Again
    While (!CheckColour_OuraLoginPage()) {
        Sleep, 100
    }

    ; Step 17: Record Change and Reset
    StepIndicator("Action: Record Change and Reset")
    Send ^w ; Control + W to close the current tab
    Sleep, 100
    Send {Left} ; Move left
    Sleep, 100
    Send y ; Press Y
    Sleep, 100
    Send {Enter} ; Press Enter
    Sleep, 100
    Send {Right} ; Move 3 steps to the right
    Sleep, 100
    Send {Right} ; Move 3 steps to the right
    Sleep, 100
    Send {Right} ; Move 3 steps to the right
    Sleep, 100

    ; Script loops back to the start
    SetTimer, CheckAndRun, 100
}

; Define color check functions below

CheckColour_SpreadsheetOpen() {
    ; Placeholder for color-checking logic for the spreadsheet (e.g., PixelGetColor)
    return true ; Replace with actual logic
}

CheckColour_OuraLoginPage() {
    ; Placeholder for color-checking logic for Oura Login Page
    return true ; Replace with actual logic
}

CheckColour_ShareDataPage() {
    ; Placeholder for color-checking logic for Share Data Page
    return true ; Replace with actual logic
}

CheckColour_OuraDashboard() {
    ; Placeholder for color-checking logic for Oura Dashboard
    return true ; Replace with actual logic
}

; Show the current step as an indicator near the cursor
StepIndicator(stepText) {
    MouseGetPos, x, y
    ToolTip, %stepText%, x + 10, y + 10
    Sleep, 500
    ToolTip  ; Turn off tooltip after showing
}

; Close the script (optional)
Esc::ExitApp
