ORG 100h

; macro

; this macro prints a char in AL and advances
; the current cursor position:
PUTC    MACRO   char
        PUSH    AX
        MOV     AL, char
        MOV     AH, 0Eh
        INT     10h
        POP     AX
ENDM 

menu:     
CALL print
DB 0dh, 0ah, "------------MENU------------", 0
CALL print
DB 0dh, 0ah, "|   Tabela---------> 1     |", 0
CALL print
DB 0dh, 0ah, "|   Raiz Quadrada--> 2     |", 0  
CALL print
DB 0dh, 0ah, "|   Divisao--------> 3     |", 0 
CALL print
DB 0dh, 0ah, "|   Sobre----------> 0     |", 0
CALL print
DB 0dh, 0ah, "|--------------------------|", 0
 

CALL print
DB 0dh, 0ah, "Insira a sua opcao: ", 0
mov ah, 1
int 21h 
CMP AL,31h
JE tabela  
CMP AL,32h
JE raiz: 
CMP AL,33h
JE divisao 
CMP AL,30h
JE sobre

JMP saida 

sobre:
CALL print
DB 0dh, 0ah, "|------------SOBRE-------------|", 0
CALL print
DB 0dh, 0ah, "|Carolina Ferreira------->21071|", 0
CALL print
DB 0dh, 0ah, "|Jessica Henriques------->20068|", 0
CALL print
DB 0dh, 0ah, "|Jessica Maria----------->21074|", 0
CALL print
DB 0dh, 0ah, "|------------------------------|", 0
CALL saida
                

  
;----------------------------------MOSTRA MENU------------------------------------------- 
 
print PROC
MOV     CS:temp1, SI  ; store SI register.
POP     SI            ; get return address (IP).
PUSH    AX            ; store AX register.
next_char:
        MOV     AL, CS:[SI]
        INC     SI            ; next byte.
        CMP     AL, 0
        JZ      printed_ok
        MOV     AH, 0Eh       ; teletype function.
        INT     10h
        JMP     next_char     ; loop.
printed_ok:
POP     AX            ; re-store AX register.
; SI should point to next command after
; the CALL instruction and string definition:
PUSH    SI            ; save new return address into the Stack.
MOV     SI, CS:temp1  ; re-store SI register.
RET
temp1  DW  ?    ; variable to store original value of SI register.
ENDP

saida:
CALL print
DB 0dh, 0ah, "Pressione 's' se deseja voltar ao menu:", 0
mov ah, 1
int 21h
CMP AL,115
JE menu  
     
RET
    
    
;----------------------------------------TABELA-------------------------------------------    
      
tabela:
 
 ler:
 comment@
 mov ah,3dh          ;Open the file
    mov al,0            ;Open for reading
    lea dx,Filename     ;Presume DS points at filename
    int 21h             ; segment.
    jc  ReadError
    mov filehandle, ax  ;Save file handle
    
    LP:             
    mov ah,3fh          ;Read data from the file
    lea dx,Buffer       ;Address of data buffer
    mov cx,1            ;Read one byte
    mov bx,filehandle   ;Get file handle value
    int 21h
    jc  ReadError
    cmp ax,cx           ;EOF reached?
    jne EOF
    
    mov ah,2
    mov dl,Buffer       ;move dl letter in place [bx]
    int 21h @    
     
 xor ax, ax
 mov al, blocos
 div mapeamento
 mov numConj, ax
 
   ; call time

proc time 
     mov tempo, 0  
     cmp rw, 1
     je read 
     jmp write
     
read:
    cmp hm, 1
    je hitRead
    jmp missRead
hitRead:
  xor cx, cx
  mov ax, tempo
  mov bl, tCpu
  add ax, bx
  mov tempo, ax 
  jmp salta3
   

missRead:
 xor ax, ax
 mov al, mapeamento
 mul tCpu
 
 xor cx, cx
 mov bx, tempo 
 add ax, bx
 mov tempo, ax
 
 xor cx,cx     ; adiciona o tmpo da cache
 mov ax, tempo
 mov bx, tCache
 add ax, bx
 mov tempo, ax
 
 salta3:
    
  xor bx, bx
  xor cx, cx
  mov ax, tempo
  mov bl, tCpu
  add ax, bx
  mov tempo, ax
  
  jmp saltaW
  
  
    
write: 
    cmp hm, 1
    je hitWrite
    jmp missWrite 
    
hitWrite:
xor cx, cx
mov ax, tempo
mov bl, tCpu
add ax, bx
mov tempo, ax

jmp saltaW1 

missWrite:
 xor ax, ax
 mov al, mapeamento
 mul tCpu  
 
 xor cx, cx
 mov ax, tempo
 mov bl, tCpu
 add ax, bx
 mov tempo, ax
 
 
 cmp wanwa, 1
 je wa 
 jmp nwa
 
wa:
xor cx, cx
mov ax, tempo
mov bx, tCache
add ax, bx
mov tempo, ax

jmp saltaW1   
  
nwa:
xor cx, cx
mov ax, tempo
mov bx, wRam
add ax, bx
mov tempo, ax 

jmp saltaW
  
 saltaW1:
 cmp wtwb, 1
 je wt
 jmp wb 
 
 wt:
 xor cx, cx
 mov ax, tempo
 mov bx, wRam
 add ax, bx
 mov tempo, ax
 
 jmp saltaW
 
 wb:
  xor cx, cx
 mov ax, tempo
 mov bx, wCache
 add ax, bx
 mov tempo, ax
 
 
 saltaW:
 
 
 tempoTotal:
 xor cx, cx
 mov ax, tempoT 
 mov bx, tempo
 add ax, bx
 mov tempoT, ax
 
    
    ret
    time endp  

 ;-------------------------variaveis tabela---------------------------------
   tempoT dw 0
   tempo dw 0
   tCpu db 1
   tCache dw 2500
   wCache dw 10 
   wRam dw 4000
   
   wtwb db 0  ;se for 1 e wt se for 0 e wb

   wanwa db 0  ;se for 1 e wa se for 0 e nwa
    
   
   blocos db 64
   mapeamento db 4
   numConj dw 0  
   
   rw db 0 ; se for 1 e r se for 0 e w
   hm db 0 ; se for 1 e hit se for 0 e miss
   
    

;----------------------------------------DIVISAO----------------------------------------------------
divisao:
mov dx,offset mDividendo  ;            
    mov ah,09h                  ;Imprime a mensagem que pede o dividendo; AH = 09h - WRITE STRING TO STANDARD OUTPUT 
    int 21h                     ;  Mostrar consola
              
    mov dx,offset enter          
    mov ah,09h              ;Imprime a mensagem que pede o divisor; AH = 09h - WRITE STRING TO STANDARD OUTPUT 
    int 21h                 ;  Mostrar consola
              
    mov bx,dividendo 
    xor cx,cx         ; cx = 0 
    call pedir                                             
    mov dividendo,bx
      
    mov dx,offset enter      ;       
    mov ah,09h               ;
    int 21h                  ;Coloca espacos entre as linhas
    mov dx,offset enter      ;       
    mov ah,09h               ;
    int 21h                  ;
    
    mov dx,offset mDivis   ;            
    mov ah,09h               ;Imprime a mensagem que pede o divisor
    int 21h                  ;
    
    mov dx,offset enter
    mov ah,09h ; AH = 09h - WRITE STRING TO STANDARD OUTPUT
    int 21h    ;  Mostrar consola
              
    mov bx,divisor 
    xor cx,cx          
    call pedir
    mov divisor,bx       
    
    mov ax,dividendo
    mov dx,divisor
    
    xor cx,cx
    
    cmp ax,dx   ; se o ax < dx 
    jb consola
    cmp ax,dx
    cmp dx,0
    je erro
    
    ;cx volta como quociente
    ;ax vai como dividendo e volta resto
    ;dx vai como divisor  
    
    call dividir
    
    ;------------------------------------
    
    consola:
    
    mov resto,ax
    mov quociente,cx
    
    mov dx,offset enter     ;    
    mov ah,09h              ;
    int 21h                 ;Coloca espacos entre as linhas
    mov dx,offset enter     ;       
    mov ah,09h              ;
    int 21h                 ;
    
    mov dx,offset mQuoc   ;          
    mov ah,09h              ;Imprime a mensagem do quociente
    int 21h                 ;
              
    mov dx,offset enter     ;  
    mov ah,09h              ;Coloca espacos entre as linhas
    int 21h                 ;
                             
    
    mov ax, quociente       ;Imprime o quociente
    call print_al           ;
    
    
    mov dx,offset enter     ;    
    mov ah,09h              ;
    int 21h                 ;Coloca espacos entre as linhas
    mov dx,offset enter     ;       
    mov ah,09h              ;
    int 21h                 ;
    
    mov dx,offset mResto  ;           
    mov ah,09h              ;Imprime a mensagem do resto
    int 21h                 ;
    
    mov dx,offset enter     ;  
    mov ah,09h              ;Coloca espacos entre as linhas
    int 21h                 ;
    
    mov ax, resto           ;Imprime o resto
    call print_al           ;
    
    mov dx,offset enter     ;    
    mov ah,09h              ;
    int 21h
    mov dx,offset enter     ;    
    mov ah,09h              ;
    int 21h
    
    call saida 
    
   
           
    mov ah,01h     ; AH = 01h - READ CHARACTER FROM STANDARD INPUT, WITH ECHO
    int 21h   
    cmp al,0Dh 
    
    erro:   
         
    mov dx,offset mErro   ;            
    mov ah,09h              ;Imprime a mensagem de erro
    int 21h                 ;
    
     
    
    ret     
    
    ;-------------------------------------------
    
    
    pedir:
    mov ah,01h     ; AH = 01h - READ CHARACTER FROM STANDARD INPUT, WITH ECHO
    int 21h 
    
    cmp al,0Dh ;  Verifica se o digito colocado e 0 (0 = tecla enter)
    je sair     
    cmp al,30h ;verifica so o valor colocado e menor que 0
    jb pedir   
    cmp al,39h ;verifica so o valor colocado e maior que 9
    ja pedir   
          
    sub al,30h  ;subtrair 30 para ficar com o valor em decimal
          
    mov cl,al          
    mov ax,bx    ; bx= dividendo
    mov dx,10
    mul dx     
    add al,cl  
    
    mov bx,ax
    
    inc ch
    
    cmp ch,5 ; deixa apenas colocar 5 numeros (n pode ser maior que 65 535 = FF FF) 
    jae sair 
    jmp pedir
    
    sair:  
    ret        

    ;---------------------------------
                                         
    dividir:        ;                        
    sub ax,dx       ;
    inc cx          ;
                    ;Verifica quantas vezes o divisor cabe dentro do dividendo
    cmp ax,dx       ;Quociente encontra-se em cx
    jae dividir     ;Resto encontra-se em ax
                    ;
    ret             ;
                       
                       
                       
     ;imprimir:   
     
     print_al proc                  ;
    cmp al, 0                       ;
    jne print_al_r                  ;
        push ax                     ;
                                    ;
        mov al, '0'                 ;
        mov ah, 0eh                 ;
        int 10h                     ;
        pop ax                      ;
        ret                         ;
    print_al_r:                     ;imprime os valores 
        pusha                       ;
        mov dx, 0                   ;
        cmp ax, 0                   ;
        je pn_done                  ;
        mov bx, 10                  ;
        div bx                      ;
        call print_al_r             ;
        mov al, dl                  ;
        add al, 30h                 ;
        mov ah, 0eh                 ;
        int 10h                     ;
        jmp pn_done                 ;
    pn_done:                        ;
        popa                        ;
        ret                         ;
     endp
     
     ;-------------------------variaveis divisao---------------------------------
     
    enter db 0ah,0dh,"$"
    mDividendo db 0ah,0dh,"Inserir o dividendo: $"     
    mDivis db "Inserir o divisor: $"
    mErro db "Erro, o divisor nao pode ser 0 $"  
    mQuoc db "Quociente: $"
    mResto db "Resto: $" 
     
    divisor dw 0 
    dividendo dw 0
    quociente dw 0
    resto dw 0 
    
   ;----------------------------------------RAIZ QUADRADA-------------------------------------------------
   
     raiz:
                   
    ;coloca a msg de "abertura" da raiz
    mov dx,offset msgraiz
    mov ah,09h 
    int 21h
    
    xor ch,ch
    call pedir ; pede o numero
    mov cl,100
    mov ax, bx
    div cl    
    mov aux[2],ah  ;separa a parte final do numero
    xor ah,ah
    div cl 
    mov aux[1],ah  ;separa a parte do meio do numero
    mov aux[0],al  ; fica com o primeiro digito
    mov bx,-1
    xor cx,cx
    mov cl,aux[0]   
    
    loop1:         ;loop que encontra o primeiro valor
    inc bx
    mov ax,bx
    mul ax
    cmp ax,cx
    jbe loop1
    cmp bx,0
    je continua1
    dec bx
    continua1:
    mov ax,bx
    mul ax
    sub cl,al
    mov al,cl
    mov dl,100
    mul dl
    xor ah,ah
    add al, aux[1]
    mov vQP,ax
    mov quoc,bx 
    
    mov bx,0
    xor cx,cx
    mov ax, vQP
    mov ax,quoc
    mul dois
    mul dez
    mov bx,ax
    mov cx,-1
    
    loop2:         ;loop que encontra o segundo valor 
    inc cx
    mov ax,bx   
    add ax,cx
    mul cx        
    cmp ax,vQP
    jbe loop2
    
    cmp cx,0
    je continua2
    dec cx
    continua2:
    mov ax,bx   
    add ax,cx
    mul cx
    sub vQP,ax
    mov ax,vQP
    mul cem
    xor dx,dx
    mov dl,aux[2] 
    add ax,dx 
    mov vQP,ax
    mov ax,quoc
    mul dez
    add ax,cx
    mov quoc,ax
    
    mov bx,0
    xor cx,cx
    mov ax, vQP
    mov ax,quoc
    mul dois
    mul dez
    mov bx,ax
    mov cx,-1
    
    loop3:       ;loop que encontra o terceiro valor
    inc cx
    mov ax,bx   
    add ax,cx
    mul cx        
    cmp ax,vQP
    jbe loop3
    
    dec cx
    mov ax,quoc
    mul dez 
    add ax,cx
    mov quoc,ax    ;retorna o quociente final  
                  
    mov dx,offset enter     ;    
    mov ah,09h              ;
    int 21h                 ;Coloca espacos entre as linhas
    mov dx,offset enter     ;       
    mov ah,09h              ;
    int 21h     
    
    mov dx,offset mQuoc   ;          
    mov ah,09h              ;Imprime a mensagem do quociente
    int 21h                 ;
              
    mov dx,offset enter     ;  
    mov ah,09h              ;Coloca espacos entre as linhas
    int 21h                 ;
    
                 
    mov ax, quoc   ;Imprime o quociente
    call print_al 
    
    mov dx,offset enter     ;    
    mov ah,09h              ;
    int 21h
     
    
   call saida 
                  
                  
    mov ah,01h     ; AH = 01h - READ CHARACTER FROM STANDARD INPUT, WITH ECHO
    int 21h
    cmp al,0Dh
                         ;
 
    call stop 
    
    ;-------------------------variaveis raiz-----------------
    
    msgraiz db 0ah,0dh,"Inserir o radicando: $"
    aux db 0, 0, 0
    quoc dw ?
    vQP dw 0
    dois db 2
    dez db 10
    cem db 100
    
    ;--------------------------------------------------------

;Para o programa
stop:
    ret; return 
    
   