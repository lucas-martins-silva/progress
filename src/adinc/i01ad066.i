/******************************************************************
**
**      i01ad066.i - campo origem (originado do arquivo demon-cb)
**
******************************************************************/
{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1  RE
&glob val2  EM
&glob val3  AF
&glob val4  PG
&glob val5  AP
&glob val6  CR
&glob val7  CB
&glob val8  MA
&glob val9  CC
&glob val10 PD
&glob val11 CV
&glob val12 PV
&glob val13 PL
&glob val14 PE
&glob val15 OU
&glob val16 MD
&glob val17 MR
&glob val18 RH
&glob val19 DI
&glob val20 TR
&glob val21 OC
&glob val22 CAP
&glob val23 CCR
&IF DEFINED(BF_FIN_INTEGRAPLEMS2) &THEN
    &glob val24 APL
    &glob val25 RES
    &glob val26 EQL
    &glob val27 IMP
    &glob val28 DBC
    &glob val29 LIB
    &glob val30 PGT
&ENDIF
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1  RE
&glob val2  EM
&glob val3  AF
&glob val4  PG
&glob val5  PP
&glob val6  CC
&glob val7  CB
&glob val8  MA
&glob val9  CO
&glob val10 PD
&glob val11 CV
&glob val12 PV
&glob val13 PL
&glob val14 PE
&glob val15 O
&glob val16 MD
&glob val17 MR
&glob val18 RH
&glob val19 DI
&glob val20 TR
&glob val21 OC
&glob val22 CAP
&glob val23 ARC
&IF DEFINED(BF_FIN_INTEGRAPLEMS2) &THEN
    &glob val24 APL
    &glob val25 RES
    &glob val26 EQL
    &glob val27 IMP
    &glob val28 DBC
    &glob val29 LIB
    &glob val30 PGT
&ENDIF
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1  RC
&glob val2  EM
&glob val3  AF
&glob val4  PM
&glob val5  AP
&glob val6  AR
&glob val7  CM
&glob val8  MM
&glob val9  PO
&glob val10 CO
&glob val11 SQ
&glob val12 SF
&glob val13 MR
&glob val14 PE
&glob val15 OU
&glob val16 MD
&glob val17 MR
&glob val18 HR
&glob val19 DI
&glob val20 TR
&glob val21 PR
&glob val22 CAP
&glob val23 ARC
&IF DEFINED(BF_FIN_INTEGRAPLEMS2) &THEN
    &glob val24 APL
    &glob val25 RES
    &glob val26 EQL
    &glob val27 IMP
    &glob val28 DBC
    &glob val29 LIB
    &glob val30 PGT
&ENDIF
&ENDIF

{include/ind11-50.i {1} {2}}
/* Fim */

