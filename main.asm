    ; VRAM range $2000 - $3d4b
    ; Total resolution 1D4C 7500 bytes
    ; 100x75 resolution
    ; $ff -> P1 points
    ; $fe -> P2 points
    ; $fd -> End mach points
    ; $fc -> Border color
    ; $fb -> Player color
    ; [$00 - Stack Pointer) -> Temp memory
    ; ($fa - $f9) -> P1 UP border
    ; ($f8 - $f7) -> P1 DOWN border
    ; [$f6, $f5] -> Ball cords
    .org $8000
start:
mem_setup:
    ; Border color
    lda #$fa
    sta $fc

    ; Player color
    lda #$ff
    sta $fb
    ; P1 position
    lda #$80
    sta $f9
    lda #$2c
    sta $fa

    lda #$80
    sta $f7
    lda #$2f
    sta $f8
    ; Ball coords
    lda #$30
    ldy #$2e
    sty $f6
    sta $f5
video_setup:
    lda $fc ; Load the color
drawborders:
    sta $2000, x
    ;sta $2080, x
    sta $3d00, x
    sta $3d80, x
    inx
    cpx #$63
    bmi drawborders
drawplayers:
    lda $fb
    ; P1 Draw
    sta $2c80
    sta $2d00
    sta $2d80
    sta $2e00
    sta $2e80
    sta $2f00
    sta $2f80
    ; P2 Draw
    sta $2ce2
    sta $2d62
    sta $2de2
    sta $2e62
    sta $2ee2
    sta $2f62
    sta $2fe2
draw_ball:
    sta $2e30 ; position 0,0
    ldy #$00
    lda #$00
start_game:
await_event:
    lda $3fff
    cmp #$77
    beq p1_move_up
    cmp #$73
    beq p1_move_down

    jmp await_event

p1_move_up:
    lda $f8
    cmp #$23
    beq move_exit
    lda #$00
    sta ($f7), y
    clc
    lda $f7
    sbc #$7f
    cmp $00
    bmi dec_f8
con_f8:
    clc
    sta $f7
    lda $f9
    sbc #$7f
    cmp $00
    bmi dec_fa
con_fa:
    clc
    sta $f9
    lda $fb
    sta ($f9), y
    jmp move_exit
dec_fa dec $fa
    jmp con_fa

dec_f8 dec $f8
    jmp con_f8

p1_move_down:
    lda $fa
    cmp #$39
    beq move_exit
    lda #$00
    sta ($f9), y
    clc
    lda $f9
    adc #$80
    cmp #$ff
    bpl inc_fa
com_fa:
    clc
    sta $f9
    lda $f7
    adc #$80
    cmp #$ff
    bpl inc_f8
com_f8:
    sta $f7
    lda $fb
    sta ($f7), y
    jmp move_exit

inc_fa inc $fa
    jmp com_fa
inc_f8 inc $f8
    jmp com_f8

move_exit:
    ldy #$00
    sty $3fff
    jmp await_event

; ball_movement:
    ; Memory $f6 - $f5 -> Ball position

    ; lda #$00 ;
    ; sta ($f5), y ;Delete the previous ball

;    lda $f5 ; we load the previous position
;    sbc #$7f ; We add to make the constant
;    cmp #$ff
;    bpl increment_position
;    cmp #$00
;    bmi decrement_position
; print_ball:
;     sta $f5 ; We store the new position
;    lda $fb ; We load the color
;    sta ($f5) , y ; We paint the new ball
;    jmp ball_movement
; increment_position:
;    clc
;    inc $f6
;    jmp print_ball
; decrement_position:
;    clc
;    dec $f6
;    jmp print_ball
exit:
    .org $fffc
    .word start
    .word $0000