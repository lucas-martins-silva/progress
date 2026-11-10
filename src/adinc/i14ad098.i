/******************************************************************
**
** i14ad098.i  Campo: tp-inspecao (emitente)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Severa
&glob val2 Normal
&glob val3 Atenuada
&glob val4 Preferencial N¡vel 1
&glob val5 Preferencial N¡vel 2
&glob val6 Preferencial N¡vel 3
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Severa
&glob val2 Normal
&glob val3 Atenuada
&glob val4 Preferencial Nivel 1
&glob val5 Preferencial Nivel 2
&glob val6 Preferencial Nivel 3
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Rigorous
&glob val2 Normal
&glob val3 Reduced
&glob val4 Preference Level 1
&glob val5 Preference Level 2
&glob val6 Preference Level 3
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

