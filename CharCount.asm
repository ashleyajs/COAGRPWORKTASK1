.model small
.stack 100h

.data
    inputMsg db "Enter 10 characters: $"
    outputMsg db 13,10,"Output: $"
    countMsg db ", count: $"
    counts db 26 dup(0) ; Array to store counts for each character
    inputBuffer db 10 dup(0) ; Buffer to store user input
    newline db 13, 10, '$' ; Newline characters for formatting

.code
start:
    ; Initialize data segment register
    mov ax, @data
    mov ds, ax

    ; Display message prompting user to enter 10 characters
    mov ah, 09h
    lea dx, inputMsg
    int 21h

    ; Read 10 characters from the user
    mov cx, 10  ; Number of characters to read
    lea si, inputBuffer  ; Pointer to input buffer
read_loop:
    mov ah, 01h  ; Function to read a character
    int 21h
    mov [si], al  ; Store the character in the buffer
    inc si  ; Move to the next position in the buffer
    loop read_loop  ; Repeat until all characters are read

    ; Initialize index for reverse printing
    mov si, 9

    ; Count repeated characters
    mov cx, 10 ; Number of characters to process
    mov di, 0  ; Initialize index for counts array
count_loop:
    mov al, [inputBuffer+di] ; Get current character
    sub al, 'a' ; Convert to lowercase if necessary
    cmp al, 'z' - 'a' ; Check if it's a lowercase letter
    ja not_lowercase
    add al, 'A' - 'a' ; Convert to uppercase
not_lowercase:
    mov bl, al ; Move character code into BL
    mov al, counts[di+bx] ; Get current count for this character
    inc al ; Increment count
    mov counts[di+bx], al ; Store updated count
    inc di ; Move to next character
    loop count_loop ; Repeat for all characters

    ; Display the output message
    mov ah, 09h
    lea dx, outputMsg
    int 21h

print_loop:
    ; Print the characters and their counts in reverse order
    mov dl, [inputBuffer+si] ; Get current character
    mov ah, 02h
    int 21h
    mov dl, ',' ; Print comma separator
    int 21h
    mov dl, ' ' ; Print space separator
    int 21h
    mov bl, dl ; Move character code into BL
    mov al, counts[di+bx] ; Get count for current character
    add al, '0' ; Convert count to ASCII
    mov ah, 02h
    int 21h
    dec si ; Move to previous character
    cmp si, -1 ; Check if all characters have been printed
    jge print_loop ; Repeat if not

    ; Print newline characters
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Terminate program
    mov ah, 4Ch
    int 21h

end start ; End of program
