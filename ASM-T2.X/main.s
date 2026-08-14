PROCESSOR 18F57Q43
    
#include <xc.inc>


PSECT var,class=RAM,space=SPACE_DATA,noexec
Time1: DS 1
Time2: DS 1
Time3: DS 1
    
PSECT resetVect,class=CODE,space=SPACE_CODE,reloc=2
    
resetVect:

    goto main	; Goto main program

PSECT code,class=CODE,space=SPACE_CODE,reloc=2

main:
    
    call GPIO_Config ; Call subroutine to config GPIO
    
    movlb 4	    ; Bank 4 (SFRs are located in bank 4)

Read_RB4:
    
    movlw 00h	    
    cpfseq PORTB,1	; Is switch on RB4 closed?
    goto RB4_closed	; Yes, jump to label RB4_closed
    goto RB4_opened	; No, jump to label RB4_opened
    
RB4_closed:
    movlw 00h	    
    movwf LATF,1    
    call Delay      ; Jump to Delay subroutine
           
    movlw 08h
    movwf LATF,1    
    call Delay      ; Jump to Delay subroutine
    goto Read_RB4
    
RB4_opened:
    movlw 08h
    movwf LATF,1    
    goto Read_RB4
            
GPIO_Config:
    movlb 4	    ; Bank 4 (SFRs are located in bank 4)
    
    movlw 10h	    ; Load working register with 10h
    movwf TRISB,1   ; RB4 configured as input; RB7:RB5 and RB3:RB0 as outputs (not used)
    
    movlw 00h	    ; Load working register with 00h
    movwf TRISA,1   ; PORTA configured as output (not used)
    movwf TRISC,1   ; PORTC configured as output (not used)
    movwf TRISD,1   ; PORTD configured as output (not used)
    movwf TRISE,1   ; PORTE configured as output (not used)
    movwf TRISF,1   ; RF3 configured as output; RF7:RF4 and RF2:RF0 as outputs (not used)

    movlw 00h	    ; Load working register with 00h
    movwf LATA,1    ; Clear port A
    movwf LATC,1    ; Clear port C
    movwf LATD,1    ; Clear port D
    movwf LATE,1    ; Clear port E
    movlw 08h
    movwf LATF,1    ; Clear port F   
    
    movlw 10h	    ; Load working register with 10h
    movwf WPUB,1    ; Rpull-up enabled on RB4; pull-ups on RB7:RB5 and RB3:RB0 disabled
    
    movlw 00h	    ; Load working register with 00h
    movwf WPUA,1    ; Rpull-up on portA disabled
    movwf WPUC,1    ; Rpull-up on portC disabled
    movwf WPUD,1    ; Rpull-up on portD disabled
    movwf WPUE,1    ; Rpull-up on portE disabled
    movwf WPUF,1    ; Rpull-up on portF disabled
    
    clrf ANSELA,1   ; Pins as digital I/O
    clrf ANSELB,1   ; Pins as digital I/O
    clrf ANSELC,1   ; Pins as digital I/O
    clrf ANSELD,1   ; Pins as digital I/O
    clrf ANSELE,1   ; Pins as digital I/O
    clrf ANSELF,1   ; Pins as digital I/O
    
    return	    ; Return from subroutine
    
Delay:
    movlb 06h       ; Bank 6
      
    movlw 7Fh       
    movwf Time1,1   ; Store 7Fh in Time1
    
Decre_Time1:
    dcfsnz Time1,1,1 ; Decrement Time1, end if = 0
    goto Delay_end
    
    movlw 0FFh       ; Store FFh in Time2
    movwf Time2,1
    
Decre_Time2:
    decfsz Time2,1,1 ; Decrement Time2, skip if = 0
    goto Decre_Time2       
    goto Decre_Time1 ; Repeat

Delay_end:    
    movlb 4
    return            ; Return to main program
    
END resetVect  