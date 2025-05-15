section .data
    inputBuf db 0x83, 0x6A, 0x88, 0xDE, 0x9A, 0xC3, 0x54, 0x9A
    input_length equ $ - inputBuf
    line_break db 0xa

section .bss
    outputBuf resb 80       

section .text
    global _start

_start:
    mov esi, 0              ; index for inputBuf
    mov edi, 0              ; index for outputBuf
    mov ecx, input_length   ; Counter for the loop

translation_loop:
    ; load the current byte from inputBuf
    mov al, byte [inputBuf + esi]
    
    ; Translate the byte
    cmp al, 0x83
    je .translate_83
    cmp al, 0x6A
    je .translate_6A
    cmp al, 0x88
    je .translate_88
    cmp al, 0xDE
    je .translate_DE
    cmp al, 0x9A
    je .check_9A           
    cmp al, 0xC3
    je .translate_C3
    cmp al, 0x54
    je .translate_54
    jmp .no_translation

.check_9A:
    ; determine if this is the first or second occurrence of 0x9A
    cmp esi, 4              
    je .translate_9A_1
    jmp .translate_9A_2     

.translate_83:
    mov bl, 0x5A           
    jmp .store_hex

.translate_6A:
    mov bl, 0x6C           
    jmp .store_hex

.translate_88:
    mov bl, 0x0A            
    jmp .store_hex

.translate_DE:
    mov bl, 0x1B           
    jmp .store_hex

.translate_9A_1:
    mov bl, 0x2C          
    jmp .store_hex

.translate_C3:
    mov bl, 0x3D            
    jmp .store_hex

.translate_54:
    mov bl, 0x4E            
    jmp .store_hex

.translate_9A_2:
    mov bl, 0x5F            
    jmp .store_hex

.no_translation:
    mov bl, al              ; use the original value

.store_hex:
    ; convert the translated byte (in bl) to ASCII hex
    mov al, bl
    shr al, 4               
    call hex_to_ascii
    mov [outputBuf + edi], al
    inc edi
    
    mov al, bl
    and al, 0x0F            
    call hex_to_ascii
    mov [outputBuf + edi], al
    inc edi
    
    ; Add space after each byte 
    cmp ecx, 1              
    je .next_byte           
    mov byte [outputBuf + edi], ' '
    inc edi

.next_byte:
    inc esi                 
    dec ecx                 
    jnz translation_loop    ; continue if there are more bytes

    ; Null-terminate the output string
    mov byte [outputBuf + edi], 0

    ; print the output buffer
    mov eax, 4              
    mov ebx, 1              
    mov ecx, outputBuf
    mov edx, edi            
    int 0x80

    ; Print newline
    mov eax, 4              
    mov ebx, 1              
    mov ecx, line_break
    mov edx, 1              
    int 0x80

    ; Exit program
    mov eax, 1              
    xor ebx, ebx            
    int 0x80

; convert value in AL (0-15) to ASCII hex character
hex_to_ascii:
    cmp al, 10
    jl .digit
    add al, 'A' - 10        ; Convert to A-F
    ret
.digit:
    add al, '0'             ; Convert to 0-9
    ret
