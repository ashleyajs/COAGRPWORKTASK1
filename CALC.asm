;Computer Organization & Assembly 
; Task 4 - Group Members: Ashley Scott, Aaliyah, Shaqur Adair ....
.model small
.stack 100h
.data
    menuMsg db "Simple Calculator",13,10
            db "1) Add",13,10
            db "2) Multiply",13,10
            db "3) Exit",13,10,0
    choicePrompt db "Enter your choice: $"
    numPrompt db "Enter two single digits (0-9) separated by space: $"
    resultMsg db "The result is: $"
    errMsg db "Invalid input, please try again.",13,10,0

    choice db ?
    num1 db ?
    num2 db ?
    buffer db 3 dup(0)

.code
start:
    mov ax, @data
    mov ds, ax

main_menu:
    call displayMenu
    call getChoice

processChoice:
    cmp choice, '3'
    je endProgram
    cmp choice, '1'
    je addNumbers
    cmp choice, '2'
    je multiplyNumbers

displayError:
    mov ah, 09h
    lea dx, errMsg
    int 21h
    jmp main_menu

addNumbers:
    call getNumbers
    mov al, buffer
    sub al, '0'
    mov num1, al
    mov al, buffer+2
    sub al, '0'
    mov num2, al
    add num1, num2
    call displayResult
    jmp main_menu

multiplyNumbers:
    call getNumbers
    mov al, buffer
    sub al, '0'
    mov bl, buffer+2
    sub bl, '0'
    mov num1, al
    mov num2, bl
    mov ah, 0
    mul bl
    mov num1, al
    call displayResult
    jmp main_menu

getChoice:
    mov ah, 09h
    lea dx, choicePrompt
    int 21h
    mov ah, 01h
    int 21h
    mov choice, al
    ret

getNumbers:
    mov ah, 09h
    lea dx, numPrompt
    int 21h
    mov ah, 0Ah
    lea dx, buffer
    int 21h
    ret

displayMenu:
    mov ah, 09h
    lea dx, menuMsg
    int 21h
    ret

displayResult:
    mov ah, 09h
    lea dx, resultMsg
    int 21h
    mov dl, num1
    add dl, '0'
    mov ah, 02h
    int 21h
    mov dl, 13
    mov ah, 02h
    int 21h
    mov dl, 10
    mov ah, 02h
    int 21h
    ret

endProgram:
    mov ah, 4Ch
    int 21h
    ret
end start

