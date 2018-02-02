********************************
*                              *
* DELKEYHANDLERGID - MAKES THE *
*   DELETE KEY WORK LIKE THE   *
*   BACKSPACE ON A PC          *
*                              *
* AUTHOR: gid...@sasktel.net   *
* MERLINIFY: Bill Chatfield    *
* LICENSE: GPL2                *
*                              *
********************************

        ORG $803

********************************
*                              *
* CONSTANTS                    *
*                              *
********************************

VECTOUT EQU $BE30       ;VECTOUT LOW
VECTIN  EQU $BE32       ;VECTIN LOW
VECTINH EQU $BE33       ;VECTIN HIGH

* FOR PRODOS
* setup Basic.system vectors for input
        LDA #<DELETE
        STA VECTIN
        LDA #>DELETE
        STA VECTIN+1
        RTS

* FOR DOS 3.3
* setup Dos vectors to get a keypress
*        LDA #<DELETE
*        STA $38
*        LDA #>DELETE
*        STA $39
*        JMP $3EA

DELETE  BIT $C01F      ; are we in 80-col mode?
        BMI COL80      ; branch if yes
        JSR $FD1B      ; changed from $FD0C
        BNE DEL2

COL80   JSR $C305      ; for 80-col input

DEL2    CMP #$FF       ; is the Delete key pressed; change to something else for the Apple II or II+
        BNE RETURN     ; if not then let DOS or Basic.sys handle the keypress
        LDA #$88       ; go back one space; same action as the left arrow
        JSR $FDED      ; print it
        LDA #$A0       ; print a space
        JSR $FDED
        LDA #$88       ; go back over the space
RETURN  RTS            ; let Dos or BS handle the last character 
