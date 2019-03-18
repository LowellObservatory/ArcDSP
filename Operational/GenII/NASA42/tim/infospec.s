; General DSP info field specifications.
; These values are 'addresses' and used as the argument for the INF command.

GET_VERSION	EQU	0	; IVERSION field
GET_FLAVOR	EQU	1	; IFLAVOR field
GET_TIME0	EQU	2	; ITIME0 field (lo order, time of compile)
GET_TIME1	EQU	3	; ITIME1 field (hi order, time of compile)
GET_SVNREV	EQU	4       ; ISVNREV field (highest svn rev if available)

