.model small
;Anna Tatinyan, Liana Minasyan, Knarik Manukyan

.stack 100H

.data
input db 01110101B
O1 db 
O2 db
.code 

START:
    mov ax, @data           ; initialize data
    mov ds, ax
    

    mov al,input            ; copy of the input bits into AL
    and al, 00000011B       ; mask off all bits except input bit 0 and bit 1 (the last two)
    call XNAND              ; call subroutine XNAND
    mov O1, ah              ; move the result of XNAND into the variable O1

    mov al,input            ; copy of the input bits into AL
    and al,00001100B        ; mask off all bits except input bit 2 and bit 3
    shr al,2                ; move bits 2 and 3 value into bit 1 and 0 of AL register
    call XNAND              ; call subroutine XNAND
    mov O2, ah              ; move the result of XNAND into the variable O2

    mov al, O2              ; copy the value of O2 into AL
    call XNOT               ; call subroutine XNOT
    mov O2, ah              ; move the result of XNOT into the variable O2

    mov al, input           ; copy of input bits into AL
    and al, 00010000B       ; mask off all bits except input bit 0 and bit 1
    shr al,3                ; move bits 5 value into bit 0 of AL register               
    mov bl, O2              ; copy the value of O2 into BL
    add al,bl               ; add AL to BL, now we have input bits in bit 0 and 1 in AL (the last two)
    call _OR;               ; call subroutine _OR
    mov O2, ah              ; move the result of _OR into the variable O2

    mov al, O1              ; copy of input bits into AL
    shl O1, 1               ; shift left bits in O1 by 1 bit
    mov bl, O2              ; copy the value of O2 into BL
    add al, bl              ; add AL to BL, now we have input bits in bit 0 and 1 in AL
    call XNOR               ; call subroutine XNOR
    mov O1, ah              ; copy the result of XNOR into the variable O1

    mov al, input           ; copy of input bits into AL
    and al, 00100000B           ; mask off all bits except input bit 6
    shr al, 5               ; shift right bits in AL by 5 bit
    call XNOT               ; XNAND insdead of copying the same value we just called Xnot
    mov O2, ah              ; copy the result of XNOT into the variable O2

    mov al, input           ; copy of input bits into AL
    and al, 01000000B       ; mask off all bits except input bit 7
    shr al, 5               ; shift right bits in O1 by 5 bit so that later we can add it to bl without the shift
    mov bl, O2              ; copy the value of O2 into BL
    add al, bl              ; add AL to BL, now we have input bits in bit 0 and 1 in AL
    call XAND               ; call subroutine XAND
    mov O2, ah              ; copy the result of XAND into the variable O2

    mov al,O2               ; copy the result of XNOT into the variable O2
    shl al,1                ; shift left bits in AL by 1 bit
    mov bl,O1               ; copy the value of O1 into BL
    add al,bl               ; add AL to BL, now we have input bits in bit 0 and 1 in AL
    call _OR                ; call subroutine _OR
    mov O1, ah              ; copy the result of XAND into the variable O1

    mov al, input           ; copy of input bits into AL
    and al, 10000000B       ; mask off all bits except input bit 8
    shr al,6                ; shift right bits in O1 by 6 bit
    mov bl, O1              ; copy the value of O1 into BL
    add al, bl              ; add AL to BL, now we have input bits in bit 0 and 1 in AL
    call XNOR               ; call subroutine XNOR

    mov dl, ah              ; copy result into DL for DOS ASCII printout
    add dl, 30H             ; comment out for subroutine
    mov ah ,2               ; print result
    int 21H                 ; to console via DOS call
    
    ;exit
    
    mov ah, 4CH             ; setup to terminate program and
    int 21H                 ; return to the DOC prompt


XAND:
    mov bl,al               ; copy of input bits into BL
    mov cl,al               ; and another in CL
    and bl, 00000001B       ; mask off all bits except input bit 0
    and cl, 00000010B       ; mask off all bits except input bit 1
    shr cl,1                ; move bit 1 value into bit 0 of CL register
                                                    ; now we have the binary value of each bit in BL and CL, in bit 0 location
    and bl,cl               ; AND these two registers, result in BL
    and bl, 00000001B       ; clear all upper bits positions leaving bit 0 either a zero or one

    mov ah, bl              ; copy answer into return value register
                            ; return

XNAND:
    mov bl,al               ; copy of input bits into BL
    mov cl,al               ; and another in CL
    and bl, 00000001B       ; mask off all bits except input bit 0
    and cl, 00000010B       ; mask off all bits except input bit 1
    shr cl,1                ; move bit 1 value into bit 0 of CL register
                                                    ; now we have the binary value of each bit in BL and CL, in bit 0 location
    and bl,cl               ; AND these two registers, result in BL
    not bl                  ; invert bits for the not part of nand
    and bl, 00000001B       ; clear all upper bits positions leaving bit 0 either a zero or one

    mov ah, bl              ; copy answer into return value register
    ret                     ; return

XNOR:
    mov bl, al              ; copy of input bits into BL
    mov cl, al              ; and another in CL
    and bl, 00000001B       ; mask off all bits except input bit 0
    and cl, 00000010B       ; mask off all bits except input bit 1
    shr cl, 1               ; move bit 1 value into bit 0 of CL register
                                                    ; now we have the binary value of each bit in BL and CL, in bit 0 location
    or  bl, cl              ; OR these two registers, result in BL
    not bl                  ; invert bits for the not part of nor
    and bl, 00000001B       ; clear all upper bits positions leaving bit 0 either a zero or one

    mov ah, bl              ; copy answer into return value register
    ret                     ; return

XXOR:
    mov bl, al              ; copy of input bits into BL
    mov cl, al              ; and another in CL
    and bl, 00000001B       ; mask off all bits except input bit 0
    and cl, 00000010B       ; mask off all bits except input bit 1
    shr cl, 1               ; move bit 1 value into bit 0 of CL register
                            ; now we have the binary value of each bit in BL and CL, in bit 0 location
    
    xor bl, cl              ; XOR these two registers, result in BL
    and bl, 00000001B       ; clear all upper bits positions leaving bit 0 either a zero or one
    mov ah, bl              ; copy answer into return value register
    ret                     ; return
_OR:
    mov bl, al              ; copy of input bits into BL
    mov cl, al              ; and another in CL
    and bl, 00000001B       ; mask off all bits except input bit 0
    and cl, 00000010B       ; mask off all bits except input bit 1
    shr cl, 1               ; move bit 1 value into bit 0 of CL register
                            ; now we have the binary value of each bit in BL and CL, in bit 0 location
    or  bl, cl          
    and bl, 00000001B       ; clear all upper bits positions leaving bit 0 either a zero or one
    mov ah, bl              ; copy answer into return value register
    ret                     ; return
XNOT:
    mov bl, al              ; copy of input bits into BL
    and bl, 00000001B       ; mask off all bits except input bit 0
    not  bl                 ; invert bits for the not part of nor
    and bl, 00000001B       ; clear all upper bits positions leaving bit 0 either a zero or one
    mov ah, bl              ; copy answer into return value register
    ret                     ; return
    

END START
