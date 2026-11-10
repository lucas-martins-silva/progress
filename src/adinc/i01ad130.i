/******************************************************************
**
** i01ad130.i  Campo: tipo-grupo-bem (grupo-bem)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Ativo
&glob val2 Passivo
&glob val3 Passivo n∆o Ded£tivel
&glob val4 Ativo n∆o Imobilizado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Activo
&glob val2 Pasivo
&glob val3 Pasivo no Deducible
&glob val4 Activo no Inmovilizdo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Active
&glob val2 Liability
&glob val3 Asset To Call
&glob val4 Non-Fixed Asset
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

