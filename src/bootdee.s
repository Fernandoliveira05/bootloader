org 0x7C00

start:
    xor ax, ax
    mov ds, ax
    mov si, msg_ola
    call print_string

    ; leitura do nome
    mov di, nome
    
ler_nome:
    call ler_char
    cmp al, 13           
    je fim_nome
    mov [di], al
    inc di
    call print_char
    jmp ler_nome

fim_nome:
    call nova_linha

    ; imprimir saudação
    mov si, saudacao
    call print_string

    ; imprimir nome
    mov si, nome
    call print_string
    
    call nova_linha
    
    ; imprimir boas-vindas 
    mov si, boasvindas
    call print_string

print_string:
    lodsb
    cmp al, 0
    je ret_print
    call print_char
    jmp print_string
    
ret_print:
    ret

print_char:
    mov ah, 0x0E
    int 0x10
    ret

ler_char:
    mov ah, 0
    int 0x16
    ret

nova_linha:
    mov al, 13
    call print_char
    mov al, 10
    call print_char
    ret

msg_ola: db 'Digite seu nome: ', 0
saudacao: db 'Ola, ', 0
nome: times 32 db 0
boasvindas: db 'Seja bem vindo ao seu sistema operacional!', 13, 10, 0

times 510 - ($ - $$) db 0
dw 0xAA55
