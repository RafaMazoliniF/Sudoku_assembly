.model small

    printaPonto macro X, Y, cor
        mov bh, 0 ;seleciona a primeira página
        mov cx, X ;define o X
        mov dx, Y ;define o Y
        mov ah, 0ch ;função de printar o ponto
        mov al, cor ;define a cor
        int 10h
    endm

.stack 100h
.data
    quantidadeLinha db ?
    direcaoLinha db ?

.code

main proc

    mov ax, @data
    mov ax, ds
    
    ;define como video mode
    mov ah, 00
    mov al, 12h ;
    int 10h
    
    ;S do sudoku
    mov cx, 10
    mov dx, 200
    mov bl, 15
    mov quantidadeLinha, 30
    mov direcaoLinha, 0
    call printaLinha
    
    mov cx, 10
    mov dx, 200
    mov bl, 15
    mov quantidadeLinha, 30
    mov direcaoLinha, 3
    call printaLinha
    
    mov cx, 10
    mov dx, 230
    mov bl, 15
    mov quantidadeLinha, 30
    mov direcaoLinha, 0
    call printaLinha
    
    mov cx, 40
    mov dx, 230
    mov bl, 15
    mov quantidadeLinha, 30
    mov direcaoLinha, 3
    call printaLinha
    
    mov cx, 40
    mov dx, 260
    mov bl, 15
    mov quantidadeLinha, 30
    mov direcaoLinha, 1
    call printaLinha
    
    ;U do sudoku
    mov cx, 40
    mov dx, 230
    mov bl, 15
    mov quantidadeLinha, 30
    mov direcaoLinha, 3
    call printaLinha
    
    ;termina o programa
    mov ah, 4ch
    int 21h
main endp

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
