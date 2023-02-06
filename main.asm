    ; VRAM range $2000 - $3d4b
    .org $8000
start:


    .org $fffc
    .word start
    .word $0000