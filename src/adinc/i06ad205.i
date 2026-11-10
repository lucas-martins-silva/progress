/******************************************************************
**
**  i06ad205.i Campo: idi-aviso-recebto (param-global)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 NÆo Avisa
&glob val2 Solicitante
&glob val3 Planejador
&glob val4 Ambos
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 No Avisa
&glob val2 Solicitante
&glob val3 Planeador
&glob val4 Ambos
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Do Not Warm
&glob val2 Requisitor
&glob val3 Planner
&glob val4 Both
&ENDIF

{include/ind01-10.i {1} {2}}
