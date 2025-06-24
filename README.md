# Criando um Bootloader

## Assista ao vídeo:
- A imagem abaixo te redireciona para o vídeo explicativo do projeto:
<div align="center">
  <a href="https://youtu.be/1XoEUl4qwGY">
    <img src="https://files.tecnoblog.net/wp-content/uploads/2025/05/Capa-TBR-Bootloader-1060x596.png" alt="Vídeo do Projeto ULA Completa">
  </a>
</div>

- Você também pode assistir diretamente pelo [Google Drive](https://drive.google.com/file/d/1fOXH1N4PeIdMA2rLtqMHsjb19KXiw6pG/view?usp=sharing)

---

## Bootloader, o que é? 
Um bootloader é um programa que é executado sempre que um dispositivo é ligado/reiniciado. Ele é o intermediário entre o hardware e o sistema operacional, garantindo que o dispositivo inicie corretamente. Simplificando, um bootloader é um programa que prepara terreno para que o sistema operacional seja carregado e executado. 

---

## Como podemos fazer um Bootloader?
Para criá-lo, escrevemos o código em linguagem Assembly, usando interrupções da BIOS (como int 10h para exibir texto e int 16h para ler o teclado) e definimos a origem, que é onde a BIOS carrega o bootloader na memória. O programa deve terminar com a assinatura 0xAA55 nos dois últimos bytes, para que a BIOS o reconheça como um setor de boot válido. Com isso, é possível criar interações básicas com o usuário antes mesmo de carregar um sistema operacional.

--- 

## Ferramentas utilizadas para fazer essa atividade
- **EMU8086:** Utilizado inicialmente para testar e entender o comportamento do código Assembly em modo real, com foco em entrada de teclado e saída na tela de forma visual e didática. Como nossos primeiros passos em sala de aula foram dentro desse aambiente,  achei pertinente começar meu código por aqui.

- **Wine:** Utilizado para executar o EMU8086 no Linux, já que o programa foi desenvolvido originalmente para Windows.

- **NASM (Netwide Assembler):** Usado para compilar o código Assembly em um arquivo binário .bin, que pode ser interpretado diretamente pela BIOS como setor de boot.

- **QEMU:** Emulador de máquina virtual utilizado para simular o processo real de boot do computador, permitindo testar o bootloader de forma fiel ao hardware real.

---

## Quero rodar, como faço?
Pode ser que você queira executar a aplicação no seu computador ou utilizar o código como base para futuras modificações. Por isso, explicarei de forma simples como rodá-lo localmente.

> 💡 Durante o desenvolvimento, utilizei apenas o **Linux**, mais precisamente a distribuição **Ubuntu**. Se você estiver usando outro sistema operacional, talvez precise adaptar alguns comandos ou ferramentas.

---

### Editando o código
Há diversas formas de escrever código em Assembly. Uma alternativa prática no Linux é o uso do **nano**, um editor de texto acessível diretamente pelo terminal.

Certifique-se de estar no diretório desejado e, em seguida, crie/edite seu arquivo com:

```bash
nano boot.s
```

Escreva ou cole seu código Assembly. Após salvar (`Ctrl + O`) e sair (`Ctrl + X`), vamos compilá-lo.

### Compilando o código com NASM
Antes de compilar, certifique-se de ter o **NASM** instalado. Para isso, use:
```bash
sudo apt install nasm
```

Depois de instalado, compile seu arquivo `.s` para um binário `.bin` executável pela BIOS:
```bash
nasm -f bin boot.s -o boot.bin
```

### Rodando o código com QEMU
Agora que temos o binário gerado, vamos testá-lo com o **QEMU**, que emula o boot de um sistema real. Primeiro, instale o QEMU:
```bash
sudo apt install qemu-system-x86
```

Depois, rode seu bootloader com:
```bash
qemu-system-x86_64 -drive format=raw,file=boot.bin
```

### Código Assembly

Aqui está o código completo do bootloader:

```asm
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

msg_ola:     db 'Digite seu nome: ', 0
saudacao:    db 'Ola, ', 0
nome:        times 32 db 0
boasvindas:  db 'Seja bem vindo ao seu sistema operacional!', 13, 10, 0

times 510 - ($ - $$) db 0
dw 0xAA55
```

---

> ⚠️ **Atenção à arquitetura:**  
Esse código foi desenvolvido para rodar em modo real, especificamente com suporte à arquitetura usada pelo QEMU. Ele segue as exigências de um setor de boot: deve ter **512 bytes** e terminar com a assinatura `0xAA55`.

