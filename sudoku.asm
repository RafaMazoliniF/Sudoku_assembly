title Rafael Mazolini Fernandes 22007411

.model small

    printaPonto macro X, Y, cor
        mov bh, 0 ;seleciona a primeira página
        mov cx, X ;define o X
        mov dx, Y ;define o Y
        mov ah, 0ch ;função de printar o ponto
        mov al, cor ;define a cor
        int 10h
    endm
    
    printaNumero macro numero, X, Y, cor
        mov ah, 02 ;posiciona cursos
        mov bh, 0
        mov dl, X
        mov dh, Y
        int 10h
        
        mov ah, 09 ;printa a letra
        mov al, numero
        mov bl, cor
        mov cx, 1
        int 10h
    endm
    
    ;Compara um valor de uma matriz com 0 => bx = 0 se igual,  bx = 1 se diferente
    comparaNumero0 macro matriz, i, j
        local diferente
        mov bx, 1
        cmp matriz[i][j], 12
        jnz diferente
        mov bx, 0
        diferente:
    endm
    ;180, 212, 244, 276, 308, 340, 372, 404, 436
    ;28, 172
    descobreElemento macro X, Y
        local denovoDescobreHorizontal, errouHorizontal, achouHorizontal, denovoDescobreVertical, errouVertical, achouVertical
        
        mov di, X
        mov si, Y
    
        xor cx, cx
        mov ax, 180 ;mínimo horizontal
        mov bx, 212 ;mínimo vertical
        denovoDescobreHorizontal:
        cmp di, ax ;se X < mínimo, denovo
        jb errouHorizontal
        cmp di, bx  ;se mínimo < X < máximo, achou
        jb achouHorizontal
        errouHorizontal:
        add ax, 32
        add bx, 32
        inc cx
        cmp cx, 8
        je achouHorizontal
        jmp denovoDescobreHorizontal
        achouHorizontal:
        
        xor dx, dx
        mov ax, 28 ;mínimo vertical
        mov bx, 44 ;máximo vertical
        denovoDescobreVertical:
        cmp si, ax ;se Y < mínimo, denovo
        jb errouVertical
        cmp si, bx  ;se mínimo < Y < máximo, achou
        jb achouVertical
        errouVertical:
        add ax, 16
        add bx, 16
        add dx, 9
        cmp dx, 72
        je achouVertical
        jmp denovoDescobreVertical
        achouVertical:
        
        mov bx, cx ;bx = coluna
        mov si, dx ;si = linha
        
    endm
    
    insereNumero macro matriz, i, j
        local naoVale, digita, fim_insere
        
        ;modo de video
        mov ah, 0
        mov al, 13
        int 10h
    
        ;printa a frase
        lea dx, digiteNumero
        mov ah, 9
        int 21h
        
        digita:
        ;le o numero
        mov ax, 0
        int 16h
        
        ;transforma em inteiro
        sub al, 48
        
        ;valida a entrada
        cmp al, 27 - 48
        je fim_insere
        cmp al, 0
        jl naoVale
        cmp al, 9
        jg naoVale
        
        ;salva o numero na matriz
        mov matriz[i][j], al 
        jmp fim_insere
        
        naoVale:
        
        jmp digita
    
        fim_insere:
    endm
    
    limpaRegistradores macro
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
    endm
    
    ;compara os valores, um a um, das matrizes inicial e resposta => bx = 0 se igual, bx = 1 se diferente
    verificaFim macro
        local denovo, diferente, igual
        ;faz o loop 81x
        mov cx, 80
        denovo:
        mov si, cx
        ;pega os valores
        mov al, facilResposta[si]
        mov ah, facil[si]
        ;compara
        cmp al, ah
        jne diferente
        loop denovo
        mov bx, 0
        jmp igual
        diferente:
        mov bx, 1
        igual:
    endm

.stack 100h
.data
    quantidadeLinha db ?
    direcaoLinha db ?
    facil db 3, 4, 0, 7, 0, 6, 0, 0, 1
          db 8, 7, 0, 0, 0, 0, 9, 0, 6
          db 0, 0, 0, 8, 9, 1, 0, 0, 3
          db 0, 0, 0, 0, 0, 3, 5, 6, 8
          db 6, 8, 0, 0, 5, 4, 0, 0, 7
          db 9, 1, 0, 6, 0, 0, 0, 0, 0
          db 0, 3, 0, 4, 0, 0, 0, 8, 0
          db 5, 9, 0, 0, 0, 0, 7, 3, 0
          db 7, 0, 0, 5, 3, 8, 0, 1, 9
          
    facilCores db 12, 12, 15, 12, 15, 12, 15, 15, 12
               db 12, 12, 15, 15, 15, 15, 12, 15, 12
               db 15, 15, 15, 12, 12, 12, 15, 15, 12
               db 15, 15, 15, 15, 15, 12, 12, 12, 12
               db 12, 12, 15, 15, 12, 12, 15, 15, 12
               db 12, 12, 15, 12, 15, 15, 15, 15, 15
               db 15, 12, 15, 12, 15, 15, 15, 12, 15
               db 12, 12, 15, 15, 15, 15, 12, 12, 15
               db 12, 15, 15, 12, 12, 12, 15, 12, 12
          
    
    facilResposta db 3, 4, 9, 7, 2, 6, 8, 5, 1
                  db 8, 7, 1, 3, 4, 5, 9, 2, 6
                  db 2, 5, 6, 8, 9, 1, 4, 7, 3
                  db 4, 2, 7, 9, 1, 3, 5, 6, 8
                  db 6, 8, 3, 2, 5, 4, 1, 9, 7
                  db 9, 1, 5, 6, 8, 7, 3, 4, 2
                  db 1, 3, 2, 4, 7, 9, 6, 8, 5
                  db 5, 9, 8, 1, 6, 2, 7, 3, 4
                  db 7, 6, 4, 5, 3, 8, 2, 1, 9
    numero db ?
    coluna db ?
    linha db ?
    
    digiteNumero db 10, 10, 10, 10, 10, '    Digite o numero a ser inserido: ', 10, '   esc para sair do jogo.$'
    aponte db 'Aponte com o mouse no local desejado, e pressione espaco para digitar um numero.$'
    naoVale db 'Digite apenas valores numericos de 0 a 9!$'
    mensagemFinal db 10, 10, 10, '               FIM DE JOGO!', 10, 10, 10, ' Aperte enter para ver a resposta final, ou qualquer outra tecla para fechar o programa: $'

.code

main proc

    mov ax, @data
    mov ds, ax
    mov es, ax
    
    ;define como video mode
    mov ah, 00
    mov al, 13
    int 10h
    
    call telaInicial
    
    ;Começa o jogo ao clicar em qualquer tecla
    mov ah, 01
    int 21h
    
    call tabuleiro
    
    call mouse
    
    call fimDeJogo
    
    ;termina o programa
    mov ah, 4ch
    int 21h
main endp

fimDeJogo proc
    ;inicia novo modo de video
    mov ah, 0
    mov al, 13
    int 10h
    
    ;printa a frase final
    lea dx, mensagemFinal
    mov ah, 09
    int 21h
    
    ;le um caracter para trocar de pagina
    mov ax, 0
    int 16h
    
    ;se for enter, mostra a resposta esperada
    cmp al, 13
    jne naoMostraResposta
    
    ;copia a resposta para a matriz principal
    cld 
    lea si, facilResposta
    lea di, facil
    cld
    mov cx, 81
    repete:
    movsb
    loop repete
    
    ;printa o tabuleiro com a resposta
    call tabuleiro
    
    naoMostraResposta:
    
    ret
fimDeJogo endp

mouse proc
    ;inicia o mouse 
    mov ax, 0
    int 33h
    
    ;mostra o mouse
    mov ax, 1
    int 33h
    
    ;sensibilidade do mouse
    mov cx, 8*2
    mov dx, 16*2
    mov ax, 0fh
    int 33h
    
    ;pega a localizacao do mouse
    mov ax, 3
    int 33h
    
    ;limita horizontalmente
    mov cx, 180
    mov dx, 470
    mov ax, 7
    int 33h
    
    ;limita verticalmente
    mov cx, 27
    mov dx, 173
    mov ax, 8
    int 33h
    denovoPosicaoMouse:
    
    ;Lê a posição do mouse => se clicar 'espaço' para.
    mov ax, 3
    int 33h
    
    ;Le um caracter. Se for espaço, pega a localização do mouse
    mov ax, 0
    int 16h
    cmp al, 32
    
    mov ax, 3
    int 33h 
    
    
    jnz denovoPosicaoMouse
    
    ;valida a entrada (somente espaços que iniciaram em branco podem ser editados)
    descobreElemento cx, dx
    xor cx, cx
    mov cl, facilCores[bx][si]
    cmp cl, 15
    jnz naoPodeTrocar
    insereNumero facil, bx, si
    ;se o valor inserido for esc -> termina o programa
    cmp al, 27 - 48
    je insere
    naoPodeTrocar:
    
    ;Ve se a matriz principal é igual a resposta, se sim -> termina o programa
    verificaFim
    cmp bx, 0
    je insere
    
    call tabuleiro
    call mouse
    
    
    insere:

    ret
mouse endp

;Coordenada 0 = (12, 4) => Soma 2 em qualquer direção
tabuleiro PROC
    mov ah, 00
    mov al, 13
    int 10h
    
    lea dx, aponte
    mov ah, 09
    int 21h
    
    limpaRegistradores
    
    ;Colunas
    mov cx, 91
    denovoColuna:
    mov bl, 15
    mov dx, 27
    mov quantidadeLinha, 144
    mov direcaoLinha, 3
    call printaLinha
    add cx, 16
    cmp cx, 236
    jb denovoColuna
    
    
    ;Linhas
    mov dx, 27
    denovoLinha:
    mov cx, 91
    mov bl, 15
    mov quantidadeLinha, 144    
    mov direcaoLinha, 0
    call printaLinha
    add dx, 16
    cmp dx, 173
    jb denovoLinha
    
    mov cx, 91
    mov dx, 27
    mov bl, 14
    mov quantidadeLinha, 48
    mov direcaoLinha, 0
    call printaLinha
    
    mov cx, 138
    mov dx, 27
    mov bl, 14
    mov quantidadeLinha, 48
    mov direcaoLinha, 3
    call printaLinha
    
    mov cx, 91
    mov dx, 74
    mov bl, 14
    mov quantidadeLinha, 48
    mov direcaoLinha, 0
    call printaLinha
    
    mov cx, 91
    mov dx, 75
    mov bl, 14
    mov quantidadeLinha, 48
    mov direcaoLinha, 2
    call printaLinha
    
    mov cx, 139
    mov dx, 27
    mov bl, 13
    mov quantidadeLinha, 48
    mov direcaoLinha, 0
    call printaLinha
    
    mov cx, 139
    mov dx, 27
    mov bl, 13
    mov quantidadeLinha, 48
    mov direcaoLinha, 3 
    call printaLinha
    
    mov cx, 139
    mov dx, 74
    mov bl, 13
    mov quantidadeLinha, 48
    mov direcaoLinha, 0
    call printaLinha
    
    mov cx, 187
    mov dx, 74
    mov bl, 13
    mov quantidadeLinha, 48
    mov direcaoLinha, 2
    call printaLinha
    
    mov cx, 187
    mov dx, 27
    mov bl, 12
    mov quantidadeLinha, 48
    mov direcaoLinha, 0
    call printaLinha
    
    mov cx, 188
    mov dx, 27
    mov bl, 12
    mov quantidadeLinha, 48
    mov direcaoLinha, 3
    call printaLinha
    
    mov cx, 187
    mov dx, 74
    mov bl, 12
    mov quantidadeLinha, 48
    mov direcaoLinha, 0
    call printaLinha
    
    mov cx, 235
    mov dx, 27
    mov bl, 12
    mov quantidadeLinha, 48
    mov direcaoLinha, 3
    call printaLinha
    
    mov cx, 91
    mov dx, 75
    mov bl, 11
    mov quantidadeLinha, 48
    mov direcaoLinha, 0
    call printaLinha
    
    mov cx, 91
    mov dx, 75
    mov bl, 11
    mov quantidadeLinha, 48
    mov direcaoLinha, 3
    call printaLinha
    
    mov cx, 138
    mov dx, 75
    mov bl, 11
    mov quantidadeLinha, 48
    mov direcaoLinha, 3
    call printaLinha
    
    mov cx, 91
    mov dx, 122
    mov bl, 11
    mov quantidadeLinha, 48
    mov direcaoLinha, 0
    call printaLinha
    
    mov cx, 139
    mov dx, 75
    mov bl, 10
    mov quantidadeLinha, 48
    mov direcaoLinha, 3
    call printaLinha
    
    mov cx, 139
    mov dx, 75
    mov bl, 10
    mov quantidadeLinha, 48
    mov direcaoLinha, 0
    call printaLinha
    
    mov cx, 186
    mov dx, 75
    mov bl, 10
    mov quantidadeLinha, 48
    mov direcaoLinha, 3
    call printaLinha
    
    mov cx, 139
    mov dx, 122
    mov bl, 10
    mov quantidadeLinha, 48
    mov direcaoLinha, 0
    call printaLinha
    
    mov cx, 187
    mov dx, 75
    mov bl, 9
    mov quantidadeLinha, 48
    mov direcaoLinha, 0
    call printaLinha
    
    mov cx, 187
    mov dx, 75
    mov bl, 9
    mov quantidadeLinha, 48
    mov direcaoLinha, 3
    call printaLinha
    
    mov cx, 235
    mov dx, 75
    mov bl, 9
    mov quantidadeLinha, 48
    mov direcaoLinha, 3
    call printaLinha
    
    mov cx, 187
    mov dx, 122
    mov bl, 9
    mov quantidadeLinha, 48
    mov direcaoLinha, 0
    call printaLinha
    
    mov cx, 91
    mov dx, 123
    mov bl, 6
    mov quantidadeLinha, 48
    mov direcaoLinha, 0
    call printaLinha
    
    mov cx, 91
    mov dx, 123
    mov bl, 6
    mov quantidadeLinha, 48
    mov direcaoLinha, 3
    call printaLinha
    
    mov cx, 138
    mov dx, 123
    mov bl, 6
    mov quantidadeLinha, 48
    mov direcaoLinha, 3
    call printaLinha
    
    mov cx, 91
    mov dx, 171
    mov bl, 6
    mov quantidadeLinha, 48
    mov direcaoLinha, 0
    call printaLinha
    
    mov cx, 139
    mov dx, 123
    mov bl, 2
    mov quantidadeLinha, 48
    mov direcaoLinha, 0
    call printaLinha
    
    mov cx, 139
    mov dx, 171
    mov bl, 2
    mov quantidadeLinha, 48
    mov direcaoLinha, 0
    call printaLinha
    
    mov cx, 139
    mov dx, 123
    mov bl, 2
    mov quantidadeLinha, 48
    mov direcaoLinha, 3
    call printaLinha
    
    mov cx, 186
    mov dx, 123
    mov bl, 2
    mov quantidadeLinha, 48
    mov direcaoLinha, 3
    call printaLinha
    
    
    ;Configuração inicial
    limpaRegistradores
    xor si, si
    mov coluna, 12
    mov linha, 4
    
    denovoSi:
    xor bx, bx
    mov coluna, 12
    
    denovoBx:
    mov ah, facil[bx][si]
    mov numero, ah
    add numero, 48
    push bx
    cmp ah, 0
    jz naoPrinta
    printaNumero numero, coluna, linha, facilCores[bx][si]
    naoPrinta:
    add coluna, 2
    pop bx
    inc bx
    cmp bx, 9
    jb denovoBx
    add si, 9
    add linha, 2
    cmp si, 81
    jb denovoSi
    
    ret
tabuleiro ENDP

telaInicial proc
    ;S do sudoku
    mov cx, 10
    mov dx, 70
    mov bl, 15
    mov quantidadeLinha, 30
    mov direcaoLinha, 0
    call printaLinha
    
    mov cx, 10
    mov dx, 70
    mov bl, 15
    mov quantidadeLinha, 30
    mov direcaoLinha, 3
    call printaLinha
    
    mov cx, 10
    mov dx, 100
    mov bl, 15
    mov quantidadeLinha, 30
    mov direcaoLinha, 0
    call printaLinha
    
    mov cx, 40
    mov dx, 100
    mov bl, 15
    mov quantidadeLinha, 30
    mov direcaoLinha, 3
    call printaLinha
    
    mov cx, 40
    mov dx, 130
    mov bl, 15
    mov quantidadeLinha, 30
    mov direcaoLinha, 1
    call printaLinha
    
    ;U do sudoku
    mov cx, 60
    mov dx, 70
    mov bl, 15
    mov quantidadeLinha, 60
    mov direcaoLinha, 3
    call printaLinha
    
    mov cx, 60
    mov dx, 130
    mov bl, 15
    mov quantidadeLinha, 30
    mov direcaoLinha, 0
    call printaLinha
    
    mov cx, 90
    mov dx, 130
    mov bl, 15
    mov quantidadeLinha, 60
    mov direcaoLinha, 2
    call printaLinha
    
    ;D do sudoku
    mov cx, 110
    mov dx, 70
    mov bl, 15
    mov quantidadeLinha, 60
    mov direcaoLinha, 3
    call printaLinha
    
    mov cx, 105
    mov dx, 130
    mov bl, 15
    mov quantidadeLinha, 35
    mov direcaoLinha, 0
    call printaLinha
    
    mov cx, 140
    mov dx, 130
    mov bl, 15
    mov quantidadeLinha, 60
    mov direcaoLinha, 2
    call printaLinha
    
    mov cx, 140
    mov dx, 70
    mov bl, 15
    mov quantidadeLinha, 35
    mov direcaoLinha, 1
    call printaLinha
    
    ;O do sudoku
    mov cx, 160
    mov dx, 70
    mov bl, 15
    mov quantidadeLinha, 60
    mov direcaoLinha, 3
    call printaLinha
    
    mov cx, 160
    mov dx, 130
    mov bl, 15
    mov quantidadeLinha, 30
    mov direcaoLinha, 0
    call printaLinha
    
    mov cx, 190
    mov dx, 130
    mov bl, 15
    mov quantidadeLinha, 60
    mov direcaoLinha, 2
    call printaLinha
    
    mov cx, 190
    mov dx, 70
    mov bl, 15
    mov quantidadeLinha, 30
    mov direcaoLinha, 1
    call printaLinha
    
    ;K do sudoku
    mov cx, 210
    mov dx, 70
    mov bl, 15
    mov quantidadeLinha, 60
    mov direcaoLinha, 3
    call printaLinha
    
    mov cx, 210
    mov dx, 100
    mov quantidadeLinha, 30
    diagonalCima:
        printaPonto cx, dx, bl
        inc cx
        dec dx
        dec quantidadeLinha
        jnz diagonalCima
    
    mov cx, 210
    mov dx, 100
    mov quantidadeLinha, 30    
    diagonalBaixo:
        printaPonto cx, dx, bl
        inc cx
        inc dx
        dec quantidadeLinha
        jnz diagonalBaixo
        
    ;U do sudoku
    mov cx, 260
    mov dx, 70
    mov bl, 15
    mov quantidadeLinha, 60
    mov direcaoLinha, 3
    call printaLinha
    
    mov cx, 260
    mov dx, 130
    mov bl, 15
    mov quantidadeLinha, 30
    mov direcaoLinha, 0
    call printaLinha
    
    mov cx, 290
    mov dx, 130
    mov bl, 15
    mov quantidadeLinha, 60
    mov direcaoLinha, 2
    call printaLinha
    
    ret
telaInicial endp

printaLinha proc 
        ; cx = X inicial
        ; dx = Y inicial
        ; bl = cor
        ; quantidadeLinha = n de pixels printados
        ; direcaoLinha = direção que a reta toma
        
        cmp direcaoLinha, 0
        jz direita
        cmp direcaoLinha, 1
        jz esquerda
        cmp direcaoLinha, 2
        jz cima
        cmp direcaoLinha, 3
        jz baixo
        
        direita:
            printaPonto cx, dx, bl
            inc cx
            dec quantidadeLinha
            jnz direita
            jmp fim_linha
            
        esquerda:
            printaPonto cx, dx, bl
            dec cx
            dec quantidadeLinha
            jnz esquerda
            jmp fim_linha
        
        cima:
            printaPonto cx, dx, bl
            dec dx
            dec quantidadeLinha
            jnz cima
            jmp fim_linha
        
        baixo:
            printaPonto cx, dx, bl
            inc dx
            dec quantidadeLinha
            jnz baixo
            jmp fim_linha
        
        fim_linha:
        
        ret
printaLinha endp

end main
