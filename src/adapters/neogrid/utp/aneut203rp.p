/********************************************************************************
** Copyright Neogrid
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Neogrid, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i aneut203RP 2.02.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i aneut203RP MUT}
&ENDIF


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

    define temp-table tt-param no-undo
        field destino          as integer
        field arquivo          as char format "x(35)":U
        field usuario          as char format "x(12)":U
        field data-exec        as date
        field hora-exec        as integer
        field classifica       as integer
        field desc-classifica  as char format "x(40)":U
        FIELD num-dias         AS INT.

    define temp-table tt-digita no-undo
        field ordem            as integer   format ">>>>9":U
        field exemplo          as character format "x(30)":U
        index id ordem.

    def temp-table tt-raw-digita
   field raw-digita      as raw.

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

def var c-moeda         as char.
def var h-acomp         as handle.
def var v-num-reg-lidos as int.
def var l-imprime       as log.

{include/i-rpvar.i}
{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param.

find first param-global no-lock no-error.
find empresa where empresa.ep-codigo = param-global.empresa-prin no-lock.

assign c-empresa  = (if avail empresa then empresa.razao-social else "")
       c-programa = "AneUt203"
       c-versao   = "1.00"
       c-revisao  = "000".

{include/i-rpout.i }

view frame f-cabec.
view frame f-rodape.

run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Imprimindo").

assign v-num-reg-lidos = 0.



/***********************************************************
*  Programa: ANEUT201.P                                    *
*  Objetivo: Executar o message processor em background    *
************************************************************/

DEF VAR i-delay                     AS INT  NO-UNDO.
DEF VAR c-hour                      AS CHAR NO-UNDO.
DEF VAR i-aux                       AS INT  NO-UNDO.
DEF NEW GLOBAL SHARED VAR c-id      LIKE _user._userid.
DEF NEW GLOBAL SHARED VAR c-senha   LIKE _user._password.


FIND FIRST ngadapterparms NO-LOCK NO-ERROR.

DEFINE VARIABLE dt-apaga AS DATE       NO-UNDO.
DEFINE VARIABLE c-format AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i-msg-id         AS INTEGER    NO-UNDO.

ASSIGN dt-apaga = TODAY - tt-param.num-dias
       c-format = IF SESSION:DATE-FORMAT = "dmy" THEN "99/99/9999" ELSE "99/99/9999" .

FOR LAST NGMessageQueue EXCLUSIVE-LOCK
    WHERE NGMessageQueue.Done = True
      AND  DATE(integer(SUBSTRING(ngmessagequeue.datetime,4,2)),
                integer(SUBSTRING(ngmessagequeue.datetime,1,2)),
                integer(SUBSTRING(ngmessagequeue.datetime,7,4))) <= dt-apaga:
    ASSIGN i-msg-id = ngmessagequeue.ngmessagequeueid.
END.  

FOR EACH ngmessagequeue EXCLUSIVE-LOCK
    WHERE ngmessagequeue.ngmessagequeueid <= i-msg-id
      AND NGMessageQueue.Done = True:
    DISP ngmessagequeue.ngmessagequeueid ngmessagequeue.datetime WITH STREAM-IO FRAME f-relat DOWN.
    DELETE ngmessagequeue.
END.

run pi-finalizar in h-acomp.

{include/i-rpclo.i}

RETURN "OK":U. 

