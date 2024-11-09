# DNI 45396777
# El mayor numero representable en 16 bits es 9677 
# Legajo 03358/8
# El mayor numero es 3588
    .data
operador1: .hword 9677
operador2: .hword 3588
operador_xnor: .byte 10101110
segundo_operador_xnor: .hword 0xB5C9

resultado_resta1: .hword 0
resultado_resta2: .hword 0
resultado_xnor1: .hword 0
resultado_xnor2: .hword 0

    .text
lh r1, operador1(r0)
lh r2, operador2(r0)
lb r3, operador_xnor(r0)
lh r4, segundo_operador_xnor(r0)
daddi r15, 0, 0

dsubi r5, r1, 3588 # r5 = 9677 - 3588
sh r5, resultado_resta1(r0)
slti r9, r5, 0
beqz r9, esPositivo
jmp esNegativo


segundaResta: dsubi r5, r2, 9677 # r5 = 3588 - 9677
              sh r5, resultado_resta2(r0)
              sh r14, resultado_xnor1(r0)
              slti r9, r5, 0
              beqz r9, esPositivo
              daddi r15, 0, 1
              jmp esNegativo


esPositivo: xnorr r14, r5, r4

            beqz r15, segundaResta
            jmp fin

esNegativo: xnorr r14, r5, r3
            beqz r15, segundaResta
            jmp fin

fin: sh r14, resultado_xnor2(r0)
     halt

