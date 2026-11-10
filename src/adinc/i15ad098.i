/******************************************************************
**
** i15ad098.i  Campo: tp-pagto (emitente)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Doc
&glob val2 Cred CC
&glob val3 Cheque Adm
&glob val4 Cobran‡a
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Doc
&glob val2 Cr‚d CC
&glob val3 Cheque Adm
&glob val4 Cobro
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Doc
&glob val2 Credit
&glob val3 Adm Check
&glob val4 Bill-To
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

