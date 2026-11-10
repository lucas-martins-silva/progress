/******************************************************************
**  Objeto: i02ad039.i
**  Campo: cond-pagto.idi-forma-avaliac-cr
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Avalia‡Æo Normal
&glob val2 Aprova‡Æo Autom tica
&glob val3 Reprova‡Æo Autom tica
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Evaluaci¢n Normal
&glob val2 Aprobaci¢n Autom tica
&glob val3 Reprobaci¢n Autom tica
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Regular Evaluation
&glob val2 Automatic Approval
&glob val3 Automatic Reproval
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */



