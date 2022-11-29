.model small

    printaPonto macro X, Y, cor
        mov bh, 0 ;seleciona a primeira página
        mov cx, X ;define o X
        mov dx, Y ;define o Y
        mov ah, 0ch ;função de printar o ponto
        mov al, cor ;define a cor
        int 10h
    endm
    
    printaLinha macro Xi, Yi, quantidade, direcao, cor
        mov cx, Xi
        mov dx, Yi
        mov bl, quantidade
        mov si, direcao
        
        cmp bh, 0
        jz direita
        cmp bh, 1
        jz esquerda
        cmp bh, 2
        jz cima
        cmp bh, 3
        jz baixo
        
        direita:
            printaPonto cx, dx, cor
            inc cx
            dec bl
            jnz direita
            jmp fim_linha
            
        esquerda:
            printaPonto cx, dx, cor
            dec cx
            dec bl
            jnz esquerda
            jmp fim_linha
        
        cima:
            printaPonto cx, dx, cor
            dec dx
            dec bl
            jnz cima
            jmp fim_linha
        
        baixo:
            printaPonto cx, dx, cor
            inc dx
            dec bl
            jnz baixo
            jmp fim_linha
        
        fim_linha:
    
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
    
    printaLinha 1, 100, 10, 3, 3
    
    ;termina o programa
    mov ah, 4ch
    int 21h
main endp
end main