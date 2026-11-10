/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEPD159RP 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i anepd159rp MAN}
&ENDIF

/********************************************************************************
** Copyright Neogrid
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Neogrid, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/


/*********************************************************************************************
**
**    PROGRAMA: 
**
**    DATA....: 
**
**    AUTOR...: 
**
**    OBJETIVO: 
**
*********************************************************************************************/

DEFINE TEMP-TABLE tt-param NO-UNDO 
     FIELD destino          AS INTEGER 
     FIELD arquivo          AS CHAR FORMAT "x(35)":U
     FIELD usuario          AS CHAR FORMAT "x(12)":U
     FIELD data-exec        AS DATE 
     FIELD hora-exec        AS INTEGER 
     FIELD classifica       AS INTEGER 
     FIELD desc-classifica  AS CHAR FORMAT "x(40)":U
     FIELD num-dias         AS INT
     FIELD nome-abrev       AS CHAR
     FIELD cod-estab        AS CHAR     
     FIELD nr-tabpre        AS CHAR.

DEFINE TEMP-TABLE tt-digita NO-UNDO 
     FIELD ordem            AS INTEGER   FORMAT ">>>>9":U
     FIELD exemplo          AS CHARACTER FORMAT "x(30)":U
     INDEX id ordem.

DEF TEMP-TABLE tt-raw-digita
   FIELD raw-digita      AS RAW.

DEF INPUT PARAM raw-param AS RAW NO-UNDO.
DEF INPUT PARAM TABLE FOR tt-raw-digita.

DEF VAR c-moeda         AS CHAR   NO-UNDO.
DEF VAR h-acomp         AS HANDLE NO-UNDO.
DEF VAR v-num-reg-lidos AS INT    NO-UNDO.
DEF VAR l-imprime       AS LOG    NO-UNDO.

{include/i-rpvar.i}
{include/i-rpcab.i}

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST param-global NO-LOCK NO-ERROR.
FIND empresa 
    WHERE empresa.ep-codigo = param-global.empresa-prin NO-LOCK NO-ERROR.

ASSIGN c-empresa  = (IF AVAIL empresa THEN empresa.razao-social ELSE "")
       c-programa = "ANEPD159"
       c-versao   = "2.00"
       c-revisao  = "000".

{include/i-rpout.i }

VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Imprimindo").

ASSIGN v-num-reg-lidos = 0.

FIND tb-preco 
     WHERE tb-preco.nr-tabpre = tt-param.nr-tabpre NO-LOCK NO-ERROR.

FIND emitente  
     WHERE emitente.nome-abrev = tt-param.nome-abrev NO-LOCK NO-ERROR.

FIND estabelec 
    WHERE estabelec.cod-estabel = tt-param.cod-estab NO-LOCK NO-ERROR.

PUT "Tabelas enviadas para o Neogrid".

DISP tb-preco.nr-tabpre tb-preco.descricao WITH STREAM-IO DOWN .

IF AVAIL emitente THEN
    PUT  " Cliente         : "  Emitente.cod-emit  " - "  emitente.nome-emit SKIP.
ELSE
    PUT  " Cliente         : "  tt-param.nome-abrev SKIP.

PUT  " Estabelecimento : "  Estabelec.cod-estab  " - "  estabelec.nome SKIP.

IF AVAIL tb-preco THEN DO:
    RUN adapters/neogrid/pdp/anepd159a.p (INPUT ROWID(tb-preco), 
                                          INPUT tt-param.cod-estab,
                                          INPUT tt-param.nome-abrev).
END.


RUN pi-finalizar IN h-acomp.

{include/i-rpclo.i}

RETURN "OK":U. 
