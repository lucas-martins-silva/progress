/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0670RP 2.00.00.002 } /*** 010002 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0670rp MIM}
&ENDIF

/* Vari veis Globais */
{utp/ut-glob.i}
{include/i-rpvar.i}

/* Parameters Definitions ---                                           */

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHAR format "x(35)":U
    FIELD usuario          AS CHAR format "x(12)":U
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD c-cod-docto-ini  AS CHAR FORMAT "x(16)":U    
    FIELD c-cod-docto-fim  AS CHAR FORMAT "x(16)":U
    FIELD classifica       AS INTEGER
    FIELD desc-classifica  AS CHAR FORMAT "x(40)":U.
  
define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def temp-table tt-raw-digita
   field raw-digita      as raw.

def stream s-imp.

/*Recebimento de parƒmetros*/

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

DEFINE VARIABLE c-traduz                AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-por-cod               AS CHARACTER FORMAT "x(10)"   NO-UNDO.
DEFINE VARIABLE c-por-des               AS CHARACTER FORMAT "x(13)"   NO-UNDO.

FORM docto-import.cod-docto              column-label "C¢digo"         format "x(16)":U
     docto-import.des-docto              column-label "Descri‡Æo"      format "x(50)":U
     docto-import.qti-docto-origin       column-label "Qtd Orig"       format ">>9":U
     docto-import.qti-docto-cop-bco      column-label "Qtd Copias Bco" format ">>9":U
     docto-import.qti-docto-cop-imptdor  column-label "Qtd Copias Imp" format ">>9":U
     WITH DOWN NO-BOX width 132 STREAM-IO FRAME f-cod-docto.

/* include com a defini‡Æo da frame de cabe‡alho e rodap‚ */
{include/i-rpcab.i}
{include/i-rpout.i}

RUN utp/ut-trfrrp.p (INPUT FRAME f-cod-docto:HANDLE).

/* bloco principal do programa */
FOR FIRST empresa FIELDS (ep-codigo razao-social) WHERE empresa.ep-codigo = i-ep-codigo-usuario NO-LOCK.
    ASSIGN c-empresa = empresa.razao-social.
END.

{utp/ut-liter.i Documento_Importa‡Æo *}
ASSIGN c-titulo-relat = RETURN-VALUE.

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.


IF  tt-param.classifica = 1 THEN DO:
    FOR EACH docto-import 
        WHERE docto-import.cod-docto >= tt-param.c-cod-docto-ini 
        AND   docto-import.cod-docto <= tt-param.c-cod-docto-fim NO-LOCK 
        BY docto-import.cod-docto: 
        DISPLAY  docto-import.cod-docto
                 docto-import.des-docto            
                 docto-import.qti-docto-origin     
                 docto-import.qti-docto-cop-bco    
                 docto-import.qti-docto-cop-imptdor
                 WITH FRAME f-cod-docto.
                 DOWN WITH FRAME f-cod-docto.
    END.
END.
ELSE DO:
    FOR EACH docto-import 
        WHERE docto-import.cod-docto >= tt-param.c-cod-docto-ini 
        AND   docto-import.cod-docto <= tt-param.c-cod-docto-fim NO-LOCK 
        BY docto-import.des-docto: 
        DISPLAY  docto-import.cod-docto
                 docto-import.des-docto            
                 docto-import.qti-docto-origin     
                 docto-import.qti-docto-cop-bco    
                 docto-import.qti-docto-cop-imptdor
                 WITH FRAME f-cod-docto.
                 DOWN WITH FRAME f-cod-docto.
    END.                                 
END.

PAGE.

/*** FOLDER SELE€ÇO ***/
{utp/ut-liter.i "SELE€ÇO" * r}
ASSIGN c-traduz = RETURN-VALUE.
PUT c-traduz AT 05 SKIP(1).

{utp/ut-liter.i "Documento:" * r}
ASSIGN c-traduz = RETURN-VALUE.
PUT c-traduz                    AT 010 FORMAT "x(9)"
   tt-param.c-cod-docto-ini     AT 022 FORMAT "x(16)"
   "|<   >|"                    AT 042
   tt-param.c-cod-docto-fim     AT 068 FORMAT "x(16)".
PUT UNFORMATTED SKIP(1).

/*** FOLDER CLASSIFICA€ÇO ***/
{utp/ut-liter.i "PAR¶METROS" * r}
ASSIGN c-traduz = RETURN-VALUE.
PUT c-traduz at 05 FORMAT "x(10)" SKIP(1).

CASE tt-param.classifica:
   WHEN 1 THEN DO:
       {utp/ut-liter.i "Por_C¢digo" * r}
       ASSIGN c-por-cod = RETURN-VALUE.
       PUT c-por-cod AT 10 SKIP(1).
   END.
   WHEN 2 THEN DO:
       {utp/ut-liter.i "Por_Descri‡Æo" * r}
       ASSIGN c-por-des = RETURN-VALUE.
       PUT c-por-des AT 10 SKIP(1).
   END.
END CASE.

/*** FOLDER IMPRESSÇO ***/
{utp/ut-liter.i "IMPRESSÇO" * r}.
ASSIGN c-traduz = RETURN-VALUE.
PUT c-traduz AT 05 FORMAT "x(15)" SKIP(1).

{utp/ut-liter.i "Usu rio:" * r}.
ASSIGN c-traduz = RETURN-VALUE.

PUT c-traduz         AT 10  FORMAT "x(08)"
   tt-param.usuario  AT 019 FORMAT "x(20)".

{utp/ut-liter.i "Destino:" * r}
ASSIGN c-traduz = RETURN-VALUE.

PUT c-traduz         AT 10  FORMAT "x(08)"
   tt-param.arquivo  AT 019 FORMAT "x(40)".

/* fechamento do output do relat¢rio */
{include/i-rpclo.i}
RETURN "OK":U.

/* Fim IM0016RP.P */
