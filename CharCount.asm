; Computer Organization & Assembly 
; Task 1 - Group Members: Ashley Scott 2005752, Aaliyah Adebukunola 2103579, Shaqur Adair 1901884, Mikhail Webb 1102702
; Character Count Program

.model small          ; Sets the memory model to small
.stack 100h           ; Defines a stack size of 256 bytes

.data                 ; Start of the data segment
    inputMsg db "Enter 10 characters: $"  ; Message prompt for user input
    counts db 256 dup(0)                  ; Array to store counts for each character
    inputBuffer db 10 dup(0)              ; Buffer to store user input
    outputBuffer db 20 dup('$')           ; Buffer for output
    newline db 13, 10, '$'                ; Newline characters for formatting

.code                 ; Start of the code segment
start:
    ; Initialize data segment register
    mov ax, @data       ; Load address of data segment into AX
    mov ds, ax          ; Move content of AX into DS register

    ; Display message prompting user to enter 10 characters
    mov ah, 09h         ; DOS function to write a string to standard output
    lea dx, inputMsg    ; Load effective address of inputMsg into DX
    int 21h             ; DOS interrupt

    ; Read 10 characters from the user
    mov cx, 10          ; Set CX to 10, number of characters to read
    lea di, inputBuffer ; Load effective address of inputBuffer into DI
read_loop:
    mov ah, 01h         ; DOS function to read character to AL
    int 21h             ; DOS interrupt
    mov [di], al        ; Move character in AL to address pointed by DI
    inc di              ; Increment DI to point to the next position
    loop read_loop      ; Loop until CX is 0

    ; Count repeated characters
    lea si, inputBuffer ; Load effective address of inputBuffer into SI
    mov cx, 10          ; Set CX to 10, number of characters to process
count_loop:
    mov al, [si]        ; Move character at address pointed by SI to AL
    mov bl, al          ; Move character code from AL into BL for indexing
    inc counts[bx]      ; Increment count for character at index in BL
    inc si              ; Increment SI to point to the next character
    loop count_loop     ; Loop until CX is 0

    ; Display the output message
    mov ah, 09h         ; DOS function to write a string to standard output
    lea dx, newline     ; Load effective address of newline into DX
    int 21h             ; DOS interrupt

    ; Initialize index for reverse printing
    mov si, 9           ; Initialize SI to index 9 (last character entered)
    lea di, outputBuffer ; Load effective address of outputBuffer into DI

reverse_print_loop:
    ; Check if character has been handled
    mov al, [inputBuffer+si] ; Get character from inputBuffer at index SI
    mov bl, al               ; Use character ASCII for index
    cmp byte ptr counts[bx], 0 ; Compare count at index BL to 0
    je skip_character         ; Jump if zero (character already handled)

    ; Print the characters and their counts in reverse order
    mov dl, al               ; Move character into DL for printing
    mov ah, 02h              ; DOS function to write character in DL to standard output
    int 21h                  ; DOS interrupt

    mov ah, 02h              ; DOS function to write character in DL to standard output
    mov dl, '-'              ; Move '-' into DL for separator
    int 21h                  ; DOS interrupt

    mov al, counts[bx]       ; Get count for character from counts array
    add al, '0'              ; Convert count to ASCII character
    mov dl, al               ; Move ASCII character into DL
    mov ah, 02h              ; DOS function to write character in DL to standard output
    int 21h                  ; DOS interrupt

    xor al, al               ; Zero out AL to reset count
    mov counts[bx], al       ; Set count for this character to zero in counts array

    ; Print comma if not the last character
    dec si                   ; Decrement SI to move to the previous character
    jge print_comma          ; Jump if SI >= 0 (more characters to print)

    jmp finish_printing      ; Jump to finish printing if all characters handled

print_comma:
    mov ah, 02h              ; DOS function to write character in DL to standard output
    mov dl, ','              ; Move ',' into DL for separator
    int 21h                  ; DOS interrupt
    jmp reverse_print_loop   ; Jump back to start of reverse_print_loop

skip_character:
    dec si                   ; Decrement SI to move to the previous character
    jge reverse_print_loop   ; Continue loop if SI >= 0

finish_printing:
    ; Print newline characters
    mov ah, 09h              ; DOS function to write a string to standard output
    lea dx, newline          ; Load effective address of newline into DX
    int 21h                  ; DOS interrupt

    ; Terminate program
    mov ah, 4Ch              ; DOS function to terminate program
    int 21h                  ; DOS interrupt

end start                   ; End of program
