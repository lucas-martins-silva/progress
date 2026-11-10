{include/i_fnctrad.i}
/********************************************************************************
** Copyright Neogrid
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Neogrid, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i aneut202RP 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i aneut202RP MUT}
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
    field desc-classifica  as char format "x(40)":U.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

def var c-moeda         as char.
def var v-num-reg-lidos as int.
def var l-imprime       as log.

{include/i-rpvar.i}
{include/i-rpcab.i}

create tt-param.
raw-transfer raw-param to tt-param.

find first param-global no-lock no-error.
find empresa where empresa.ep-codigo = param-global.empresa-prin no-lock.

assign c-empresa  = (if avail empresa then empresa.razao-social else "")
       c-programa = "AneUt202"
       c-versao   = "1.00"
       c-revisao  = "000".

{include/i-rpout.i &APPEND=APPEND}


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

DISP "Start :" STRING(TIME,"HH:MM:SS")  "-"  TODAY WITH  SIDE-LABELS STREAM-IO WIDTH 132 FRAME f-ini.

 IF  AVAIL ngadapterparms THEN
    ASSIGN i-delay = IF  INTEGER(SUBSTR(ngadapterparms.queuename,1,5)) >= 1 THEN 
                         INTEGER(SUBSTR(ngadapterparms.queuename,1,5)) ELSE 5.

    IF  AVAIL ngadapterparms THEN DO:
        IF  (NUM-ENTRIES(ngadapterparms.queuemanager,",") = 3 
        OR   NUM-ENTRIES(ngadapterparms.char-1,",") = 3)
        AND (ENTRY(1,ngadapterparms.queuemanager,",") = "MQ"
        OR   ENTRY(1,ngadapterparms.char-1,",") = "MQ") THEN DO:
            RUN adapters/neogrid/utp/aneut102.p.
            RUN adapters/neogrid/utp/aneut103.p. 
        END.
        ELSE DO:
            IF  (NUM-ENTRIES(ngadapterparms.queuemanager,",") >= 3
            OR   NUM-ENTRIES(ngadapterparms.char-1,",") >= 3)
            AND (ENTRY(1,ngadapterparms.queuemanager,",") = "HTTP"
            OR   ENTRY(1,ngadapterparms.char-1,",") = "HTTP") THEN DO:
                IF  INTEGER(SUBSTR(PROVERSION,1,R-INDEX(PROVERSION,".") - 1)) >= 9 THEN
                PUT "Buscando Mensagens e enviando Mensagens!" .
                RUN adapters/neogrid/utp/aneut112.p.
                PUT "Processando Mensagens !".
                RUN adapters/neogrid/utp/aneut103.p.
            END.
            ELSE DO:
                IF  (NUM-ENTRIES(ngadapterparms.queuemanager,",") = 4 
                OR   NUM-ENTRIES(ngadapterparms.char-1,",") = 4)
                AND (ENTRY(1,ngadapterparms.queuemanager,",") = "FILE"
                OR   ENTRY(1,ngadapterparms.char-1,",") = "FILE") THEN DO:
                    PUT "Buscando Mensagens e enviando Mensagens!" SKIP.
                    RUN adapters/neogrid/utp/aneut122.p.
                    PUT "Processando Mensagens !" SKIP.
                    RUN adapters/neogrid/utp/aneut103.p.
                END.
                ELSE DO:
                    PUT "Connection Parameters incorrect" SKIP.
                END.
            END.
        END. 
    END.
    ELSE DO:
        PUT "Falta configuracao da conexao" SKIP.
    END. 


DISP "Finish :" STRING(TIME,"HH:MM:SS") WITH  SIDE-LABELS STREAM-IO FRAME f-fim.

{include/i-rpclo.i}

RETURN "OK":U. 

