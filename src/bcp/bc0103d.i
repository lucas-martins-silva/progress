/******************************************************************
**
**      i01cl001.i  - campo: cod-campo ( tipo-etiqueta-seq )
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 DD
&glob val2 MM
&glob val3 AA
&glob val4 AAAA
&glob val5 DD/MM/AA
&glob val6 DD/MM/AAAA
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 DD
&glob val2 MM
&glob val3 AA
&glob val4 AAAA
&glob val5 DD/MM/AA
&glob val6 DD/MM/AAAA
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 DD
&glob val2 MM
&glob val3 YY
&glob val4 YYYY
&glob val5 DD/MM/YY
&glob val6 DD/MM/YYYY
&ENDIF
{include/ind01-10.i {1} {2}}
/* Fim */
