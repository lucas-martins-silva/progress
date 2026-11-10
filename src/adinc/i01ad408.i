/******************************************************************
**
** i01ad408.i  Campo:movto-cobr-inadimp.idi-tip-contat
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Telefone
&glob val2 Fax
&glob val3 Email
&glob val4 Outros
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Tel‚fono
&glob val2 Fax
&glob val3 Email
&glob val4 Otros
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Telephone
&glob val2 Fax
&glob val3 Email
&glob val4 Others
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
