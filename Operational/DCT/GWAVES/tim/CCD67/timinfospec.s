; TIM DSP info field specifications.
; These values are 'addresses' and used as the argument for the INF command.

GET_CAPABLE	EQU	$100	; ICAPABLE field (what dsp supports).
GET_INT_TIM     EQU	$101    ; Integration time per pixel in leach units
GET_R_DELAY     EQU	$102    ; Serial overlap in leach units
GET_SI_DELAY    EQU	$103    ; Parallel overlap in leach units

