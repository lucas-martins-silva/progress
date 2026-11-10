/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IMR001RP 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i imr001rp MIM}
&ENDIF

/********************************************************************************
***
*** IMR001RP - Listagem de Usu rios de Importa‡Æo
***
********************************************************************************/
define temp-table tt-param no-undo
       field destino          as integer
       field arquivo          as char format "x(35)":U
       field usuario          as char format "x(12)":U
       field data-exec        as date
       field hora-exec        as integer
       FIELD cod-usuar-ini    AS CHAR FORMAT "x(12)"
       FIELD cod-usuar-fim    AS CHAR FORMAT "x(12)".

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.   

/******************************* Recebimento de Parƒmetros *****************************************/
DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

/******************************* Defini‡Æo de Vari veis ********************************************/
{include/i-rpvar.i}
{utp/ut-glob.i}

DEF VAR c-sel            AS CHAR FORMAT "x(25)" NO-UNDO. 
DEF VAR c-impressao      AS CHAR FORMAT "x(15)" NO-UNDO.
DEF VAR c-saida          AS CHAR FORMAT "x(40)" NO-UNDO.
DEF VAR c-des            AS CHAR FORMAT "x(50)" NO-UNDO.
DEFINE VARIABLE c-acompanhar AS CHARACTER  NO-UNDO.
DEFINE VARIABLE h-acomp AS HANDLE     NO-UNDO.


FORM c-sel                           COLON  1 NO-LABEL SKIP(1)
     tt-param.cod-usuar-ini          COLON  14
     SPACE (2) "|<   >|" AT 30  tt-param.cod-usuar-fim NO-LABEL COLON 36 SKIP(1)
     c-impressao                     COLON  1 NO-LABEL SKIP(1)
     c-saida                         COLON  14       
     tt-param.usuario                COLON  14
     WITH STREAM-IO SIDE-LABELS WIDTH 132 FRAME f-param. 
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-param:HANDLE).


FORM usuar-import.cod-usuar                      COLUMN-LABEL "Usu rio"
     usuar-import.log-permite-alter-cotac-despes COLUMN-LABEL "Perm Alt Cotac Desp Contr"
     WITH DOWN STREAM-IO  WIDTH 132 FRAME f-registros. 

/********************************** Literais ********************************************************/    

{utp/ut-liter.i SELE€ÇO * L}
assign c-sel = trim(return-value). 

{utp/ut-liter.i Usu rio * L}
assign tt-param.usuario:label in frame f-param = trim(return-value)
       tt-param.cod-usuar-ini:label in frame f-param = trim(return-value).

{utp/ut-liter.i IMPRESSÇO * L}
assign c-impressao = trim(return-value).

{utp/ut-liter.i Destino *}
assign c-saida:label in frame f-param = trim(return-value).

CASE tt-param.destino:
    WHEN 1 THEN {utp/ut-liter.i "Impressora"}
    WHEN 2 THEN {utp/ut-liter.i "Arquivo"}
    WHEN 3 THEN {utp/ut-liter.i "Terminal"}
END CASE.
assign c-des = trim(return-value).

{include/i-rpout.i}
{include/i-rpcab.i}
/************************************ Bloco Principal *************************************************/

FOR FIRST empresa FIELDS (ep-codigo razao-social) 
    WHERE empresa.ep-codigo = i-ep-codigo-usuario NO-LOCK:
    ASSIGN c-empresa = empresa.razao-social.
END.

{utp/ut-liter.i "Listagem Usu rio Importa‡Æo" *}

ASSIGN c-programa     = "IMr001rp"
       c-versao       = "2.00"
       c-revisao      = ".00.000"
       c-sistema      = "IMP"
       c-titulo-relat = trim(return-value).

RUN utp/ut-trfrrp.p (INPUT FRAME f-registros:HANDLE).

view frame f-cabec.      


IF NOT VALID-HANDLE(h-acomp) THEN run utp/ut-acomp.p persistent set h-acomp. 
{utp/ut-liter.i Lendo_Usu rios *}.
run pi-inicializar in h-acomp (input return-value). 

view frame f-rodape. 

{utp/ut-liter.i Listagem Usu rio Importa‡Æo *}
assign c-acompanhar = return-value.
                                                          
FOR EACH usuar-import NO-LOCK
   WHERE usuar-import.cod-usuar >= tt-param.cod-usuar-ini
   AND   usuar-import.cod-usuar <= tt-param.cod-usuar-fim.

    run pi-acompanhar in h-acomp (input usuar-import.cod-usuar). 

    DISP usuar-import.cod-usuar                         
         usuar-import.log-permite-alter-cotac-despes  WITH FRAME f-registros.
    DOWN WITH FRAME f-registros.

END.

PAGE.
DISP c-sel    
     tt-param.cod-usuar-ini  
     tt-param.cod-usuar-fim
     c-impressao
     TRIM(c-des) + '  -  ' + tt-param.arquivo @ c-saida
     tt-param.usuario WITH FRAME f-param.


/************************************ Fechamento do relat¢rio ******************************************/
{include/i-rpclo.i}

 IF VALID-HANDLE(h-acomp) THEN RUN pi-finalizar IN h-acomp. 

RETURN "OK":U.






