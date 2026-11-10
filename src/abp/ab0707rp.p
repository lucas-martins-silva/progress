/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0707RP 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0707rp MAB}
&ENDIF



{include/i_fnctrad.i}
{include/i-epc200.i ab0707rp}
{abp/ab9004.i}
DEFINE VARIABLE cStatus AS CHARACTER FORMAT "x(70)" LABEL "Status" NO-UNDO.
DEFINE VARIABLE hDBOMotoris AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDBOFunc    AS HANDLE     NO-UNDO.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    field modelo           AS char format "x(35)":U
    field l-habilitaRtf    as LOG.

define temp-table tt-digita no-undo
    field ep-codigo        LIKE mab-motoris.ep-codigo
    field cod-estabel      LIKE mab-motoris.cod-estabel
    FIELD cod-matr         LIKE mab-motoris.cod-matr 
    FIELD nom-motoris      LIKE mab-motoris.nom-motoris
    index id ep-codigo  
             cod-estabel
             cod-matr.   

define SHARED temp-table tt-digita-func no-undo
    field ep-codigo        LIKE mmv-func-ofici.ep-codigo
    field cod-estabel      LIKE mmv-func-ofici.cod-estabel
    FIELD cod-matr         LIKE mmv-func-ofici.cod-matr
    FIELD nom-func         LIKE mmv-func-ofici.nom-func
    index id ep-codigo  
             cod-estabel
             cod-matr.   
    
def temp-table tt-raw-digita
   field raw-digita      as raw.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

RAW-TRANSFER raw-param TO tt-param.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER raw-digita TO tt-digita.
END.
    
{frbo~/bofr017.i tt-mab-motoris}
{frbo~/bofr032.i tt-mmv-func-ofici}

/***********************FORMS*******************************/
{include/i-rpvar.i}

FORM "-----------------------------------------------------------"
     "MOTORISTA"
     "-----------------------------------------------------------"
     WITH WIDTH 132 NO-LABEL FRAME f-cab-motoris STREAM-IO.

FORM tt-digita.ep-codigo
     tt-digita.cod-estabel
     tt-digita.cod-matr
     tt-digita.nom-motoris
     cStatus
     WITH NO-BOX WIDTH 132 DOWN FRAME f-dados STREAM-IO.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-dados:HANDLE).


FORM "----------------------------------------------------------"
     "FUNCIONµRIO"
     "----------------------------------------------------------"
     WITH WIDTH 132 NO-LABEL FRAME f-cab-func STREAM-IO.

FORM tt-digita-func.ep-codigo
     tt-digita-func.cod-estabel
     tt-digita-func.cod-matr FORMAT "x(11)" 
     tt-digita-func.nom-func
     cStatus
     WITH NO-BOX WIDTH 132 DOWN FRAME f-dados-func STREAM-IO.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-dados-func:HANDLE).

ASSIGN tt-digita-func.cod-matr:LABEL IN FRAME f-dados-func = "Funcion rio".
assign c-programa = "AB00701"
       c-versao   = "2.00"
       c-revisao  = "000"
       /** Define o destino do arquivo a ser gerado **/
       /*c-destino  = {varinc/var00002.i 04 integer(tt-param.destino)}*/
     .

/** Busca os parƒmetros criados na interface gr fica **/
find first tt-param.

/** Busca empresa padrÆo **/
find first param-global no-lock no-error.
if  available param-global then
    assign c-empresa = param-global.grupo.

/** Guarda valores para imprimir t¡tulos **/
{utp/ut-liter.i "Altera‡Æo Empresa Estabelecimento Motorista/Funcionario" *}
assign c-titulo-relat = trim(return-value).
{utp/ut-liter.i "ABASTECIMENTO E LUBRIFICA€ÇO" *}
assign c-sistema = trim(return-value).


{include/i-rpcab.i}    
{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape. 


/********************** Inicio ****************************/

RUN pi-motorista IN THIS-PROCEDURE.

PUT SKIP(2).

RUN pi-funcionario IN THIS-PROCEDURE.

{include/i-rpclo.i} 

RETURN "OK":U.

/************************PROCEDURES***************************/
PROCEDURE pi-motorista:
    IF NOT VALID-HANDLE(hDBOMotoris) OR 
             hDBOMotoris:TYPE <> "PROCEDURE":U OR
             hDBOMotoris:FILE-NAME <> "frbo/bofr017.p":U THEN DO:
            RUN frbo/bofr017.p PERSISTENT SET  hDBOMotoris.
    END.
    RUN openQueryStatic in   hDBOMotoris (input "Main":U) NO-ERROR.
    
    &IF "{&mguni_version}" >= "2.071" &THEN
        FOR FIRST tt-digita WHERE tt-digita.ep-codigo <> "" 
    &ELSE
        FOR FIRST tt-digita WHERE tt-digita.ep-codigo <> 0 
    &ENDIF
        AND tt-digita.cod-estabel <> "":U NO-LOCK:
    END.
    IF AVAIL tt-digita THEN DO:
        DISP "" WITH FRAME f-cab-motoris.
    
        &IF "{&mguni_version}" >= "2.071" &THEN
            FOR EACH tt-digita WHERE tt-digita.ep-codigo <> "" 
        &ELSE
            FOR EACH tt-digita WHERE tt-digita.ep-codigo <> 0 
        &ENDIF
            AND tt-digita.cod-estabel <> "":U NO-LOCK:
        
            FOR FIRST mab-motoris NO-LOCK
                 WHERE mab-motoris.cod-matr = tt-digita.cod-matr:
            END.
            IF AVAIL mab-motoris THEN DO:
                RUN setAtualizaTabelas IN hDBOMotoris (INPUT YES).
    
                RUN RepositionRecord IN hDBOMotoris(INPUT ROWID(mab-motoris)).
                RUN getRecord IN hDBOMotoris (OUTPUT TABLE tt-mab-motoris).
    
                FOR FIRST tt-mab-motoris NO-LOCK:
                    ASSIGN tt-mab-motoris.ep-codigo   = tt-digita.ep-codigo
                           tt-mab-motoris.cod-estabel = tt-digita.cod-estabel.
                END.
                
                RUN setRecord IN hDBOMotoris (INPUT TABLE tt-mab-motoris).
                RUN emptyRowErrors IN hDBOMotoris.
                RUN updateRecord IN hDBOMotoris.
                IF RETURN-VALUE = "OK":U THEN
                        ASSIGN cStatus = "Alterado com sucesso".
                ELSE DO:
                    RUN getRowErrors IN hDBOMotoris (OUTPUT TABLE RowErrors).
                    FOR FIRST RowErrors NO-LOCK:
                        ASSIGN cStatus = "ERRO: " + RowErrors.ErrorDescription.
                    END.
                END.
                 DISP tt-digita.ep-codigo
                     tt-digita.cod-estabel
                     tt-digita.cod-matr
                     tt-digita.nom-motoris 
                     cStatus WITH FRAME f-dados.
                DOWN WITH FRAME f-dados.
                RUN setAtualizaTabelas IN hDBOMotoris (INPUT NO).
            END.
        END.
    END.
    RETURN "OK":U.
END. /*END pi-motorista*/

PROCEDURE pi-funcionario:
    IF NOT VALID-HANDLE(hDBOFunc) OR 
             hDBOFunc:TYPE <> "PROCEDURE":U OR
             hDBOFunc:FILE-NAME <> "frbo/bofr032.p":U THEN DO:
            RUN frbo/bofr032.p PERSISTENT SET  hDBOFunc.
    END.
    RUN openQueryStatic in   hDBOFunc (input "Main":U) NO-ERROR.
    
    FOR FIRST tt-digita-func WHERE tt-digita-func.cod-estabel <> "":U NO-LOCK:
    END.
    
    IF AVAIL tt-digita-func THEN DO:
        DISP "" WITH FRAME f-cab-func.
    
        FOR EACH tt-digita-func WHERE tt-digita-func.cod-estabel <> "":U NO-LOCK:
            FOR FIRST mmv-func-ofici NO-LOCK
                 WHERE  mmv-func-ofici.ep-codigo   = tt-digita-func.ep-codigo
                   AND mmv-func-ofici.cod-matr     = tt-digita-func.cod-matr:
            END.
            
            IF AVAIL mmv-func-ofici THEN DO:
                RUN setAtualizaTabelas IN hDBOFunc (INPUT YES).
                RUN RepositionRecord IN hDBOFunc(INPUT ROWID(mmv-func-ofici)).
                RUN getRecord IN hDBOFunc (OUTPUT TABLE tt-mmv-func-ofici).
                FOR FIRST tt-mmv-func-ofici NO-LOCK:
                     ASSIGN tt-mmv-func-ofici.cod-estabel = tt-digita-func.cod-estabel.
                END.
                RUN setRecord IN hDBOFunc (INPUT TABLE tt-mmv-func-ofici).
                RUN emptyRowErrors IN hDBOFunc.
                RUN updateRecord IN hDBOFunc.
                IF RETURN-VALUE = "OK":U THEN
                    ASSIGN cStatus = "Alterado com sucesso".
                ELSE DO:
                    RUN getRowErrors IN hDBOFunc (OUTPUT TABLE RowErrors).
                    FOR FIRST RowErrors NO-LOCK:
                        ASSIGN cStatus = "ERRO: " + RowErrors.ErrorDescription.
                    END.
                END.
                DISP tt-digita-func.ep-codigo
                     tt-digita-func.cod-estabel
                     tt-digita-func.cod-matr
                     tt-digita-func.nom-func
                     cStatus WITH FRAME f-dados-func.
                DOWN WITH FRAME f-dados-func.
                RUN setAtualizaTabelas IN hDBOFunc (INPUT NO).
            END.
        END.
    END.
    RETURN "OK":U.
END. /*END pi-funcionario*/


