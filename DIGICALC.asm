;Computer Organization & Assembly 
; Task 4 - Group Members: Ashley Scott, Aaliyah Adebukunola, Shaqur Adair, Mikhail Webb

.model small
.stack 100h

.data
    ; Messages displayed to the user
    menuChoicePrompt db "Simple Calculator",13,10
                     db "1) Add",13,10
                     db "2) Multiply",13,10
                     db "3) Exit",13,10
                     db "Enter your choice: $"  ; Prompt for choice input
    numPrompt       db 13,10,"Enter two single digits (0-9) separated by space: $"  ; Prompt for numbers input
    resultMsg       db 13,10,"The result is: $"  ; Message to display result
    errMsg          db "Invalid input, please try again.",13,10,0  ; Error message

    ; Variables
    choice db ?        ; User's choice
    num1   db ?        ; First number
    num2   db ?        ; Second number
    buffer db 5        ; Buffer for user input
           db ?        ; DOS will fill this with the actual number of characters read
           db 5 dup(0); Characters read from console

.code
start:
    ; Initialize data segment register
    mov ax, @data
    mov ds, ax

main_menu:
    ; Display the menu and get user's choice
    call getChoice

processChoice:
    ; Process user's choice
    cmp choice, '1'  ; Check if choice is '1'
    je addNumbers    ; Jump to addNumbers if true
    cmp choice, '2'  ; Check if choice is '2'
    je multiplyNumbers  ; Jump to multiplyNumbers if true
    cmp choice, '3'  ; Check if choice is '3'
    je endProgram   ; Jump to endProgram if true

    ; If none of the above valid choices were made, display error.
    jmp displayError

endProgram:
    ; Terminate program
    mov ah, 4Ch
    int 21h
    ret

displayError:
    ; Display error message
    mov ah, 09h
    lea dx, errMsg
    int 21h
    jmp main_menu  ; Jump back to the main menu

addNumbers:
    ; Add two numbers
    call getNumbers
    mov al, [buffer+2] ; Adjusted to correctly reference the input
    sub al, '0'
    mov bl, [buffer+4] ; Adjusted for second number
    sub bl, '0'
    add al, bl
    mov num1, al ; Store result in num1 for display
    call displayResult
    jmp main_menu

multiplyNumbers:
    ; Multiply two numbers
    call getNumbers
    mov al, [buffer+2] ; Correct reference to buffer
    sub al, '0'
    mov bl, [buffer+4]
    sub bl, '0'
    mul bl ; AL * BL, result in AX
    mov num1, al ; Store low byte of result for display
    call displayResult
    jmp main_menu

getChoice:
    ; Get user's choice
    mov ah, 09h
    lea dx, menuChoicePrompt
    int 21h
    mov ah, 01h
    int 21h
    mov choice, al
    ret

getNumbers:
    ; Get two numbers from user
    mov ah, 09h
    lea dx, numPrompt
    int 21h
    lea dx, buffer
    mov ah, 0Ah
    int 21h
    ret

displayResult:
    ; Display the result
    mov ah, 09h
    lea dx, resultMsg
    int 21h
    mov dl, num1
    add dl, '0'
    mov ah, 02h
    int 21h
    mov dl, 13 ; Carriage return
    mov ah, 02h
    int 21h
    mov dl, 10 ; Line feed
    mov ah, 02h
    int 21h
    ret

end start ; End of program
