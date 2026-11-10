/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI010 2.00.00.017 } /*** "010017" ***/


&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BCAPI010 MUT}
&ENDIF


/************************************************************************************************************
**
**   Programa: BCAPI010 - API Verificaá‰es de Diversas Tabelas Coleta de Dados
**
**   Versao de Integracao: 1 - Luciano - Criacao da API (07/99)
**
*************************************************************************************************************/

{bcp/bcapi010.i}    /* definiá∆o das temp-tables    */
{cdp/cd0666.i}      /* definiá∆o temp-table tt-erro */

/************************************************************************************************************/
Procedure Pi-bc-trans:
def input-output    param table for tt-bc-trans.
def input-output    param table for tt-erro.
def var             i-versao-integracao     as inte initial 001.

find first tt-bc-trans no-lock no-error.

if  avail tt-bc-trans
then do:
    /*** Teste da versao de integracao ***/
    if  tt-bc-trans.cod-versao-integracao <> i-versao-integracao
    then do:
        run utp/ut-msgs.p (input "msg",
                           input 3941,
                           input "").

        run  pi-cria-erro ( input-output table  tt-erro,
                            input               3941,
                            input               1,
                            input               return-value).

        return "NOK".
    end.

    find first bc-trans
         where bc-trans.nr-trans = tt-bc-trans.nr-trans
         no-lock no-error.

    if  not avail bc-trans
    then do:
        {utp/ut-table.i mgcld bc-trans 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).

        run  pi-cria-erro ( input-output table  tt-erro,
                            input               2,
                            input               1,
                            input               return-value).

        return "NOK".
    end.

    buffer-copy bc-trans to tt-bc-trans.
end.

return "OK".

END PROCEDURE.

/************************************************************************************************************/
Procedure Pi-bc-tipo-trans:
def input-output    param table for tt-bc-tipo-trans.
def input-output    param table for tt-erro.
def var             i-versao-integracao     as inte initial 001.

find first tt-bc-tipo-trans no-lock no-error.

if  avail tt-bc-tipo-trans
then do:
    /*** Teste da versao de integracao ***/
    if  tt-bc-tipo-trans.cod-versao-integracao <> i-versao-integracao
    then do:
        run utp/ut-msgs.p (input "msg",
                           input 3941,
                           input "").

        run  pi-cria-erro ( input-output table  tt-erro,
                            input               3941,
                            input               1,
                            input               return-value).

        return "NOK".
    end.

    find first bc-tipo-trans
         where bc-tipo-trans.cd-trans = tt-bc-tipo-trans.cd-trans
         no-lock no-error.

    if  not avail bc-tipo-trans
    then do:
        {utp/ut-table.i mgcld bc-tipo-trans 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).


        run  pi-cria-erro ( input-output table  tt-erro,
                            input               2,
                            input               1,
                            input               return-value).

        return "NOK".
    end.

    buffer-copy bc-tipo-trans to tt-bc-tipo-trans.
end.

return "OK".
end.

/************************************************************************************************************/
Procedure Pi-Cria-Erro:
def input-output    param table         for tt-erro.
def input           param i-cod-erro    as integer  no-undo.
def input           param i-seq         as integer  no-undo.
def input           param c-descricao   as char     format "X(100)".

    create  tt-erro.
    assign  tt-erro.i-sequen    = i-seq
            tt-erro.cd-erro     = i-cod-erro
            tt-erro.mensagem    = c-descricao.

END.

Procedure pi-save-bc-ext-item:

    DEFINE INPUT PARAMETER c-it-codigo       LIKE ITEM.it-codigo                NO-UNDO.
    DEFINE INPUT PARAMETER c-it-cod-ext-1    LIKE bc-ext-item.it-codigo-ext-1   NO-UNDO.
    DEFINE INPUT PARAMETER c-it-cod-ext-2    LIKE bc-ext-item.it-codigo-ext-2   NO-UNDO.
    DEFINE INPUT PARAMETER c-it-cod-ext-3    LIKE bc-ext-item.it-codigo-ext-3   NO-UNDO.
    DEFINE INPUT PARAMETER c-it-cod-ext-4    LIKE bc-ext-item.it-codigo-ext-4   NO-UNDO.
    DEFINE INPUT PARAMETER imprime-etiq      LIKE bc-ext-item.imprime-etiq      NO-UNDO.
    DEFINE INPUT PARAMETER qt-etiq-total     LIKE bc-ext-item.qt-etiq-total     NO-UNDO.
    DEFINE INPUT PARAMETER qt-etiq-item      LIKE bc-ext-item.qt-etiq-item      NO-UNDO.
    DEFINE INPUT PARAMETER tipo-etiq         LIKE bc-ext-item.tipo-etiq         NO-UNDO.
    DEFINE INPUT PARAMETER tipo-etiq-total   LIKE bc-ext-item.tipo-etiq-total   NO-UNDO.
    DEFINE INPUT PARAMETER cod-integr-rfid   LIKE bc-ext-item.cod-integr-rfid   NO-UNDO.
    DEFINE INPUT PARAMETER p-rfidAtivo       AS LOGICAL                         NO-UNDO.
    DEFINE OUTPUT PARAMETER cMsgErro         AS CHARACTER                       NO-UNDO.
    
    DEFINE BUFFER bf-bc-ext-item FOR bc-ext-item.

    /* Logica n∆o mais necess†rio, visto que as informaá‰es de RFID precisam ser feitas pelo progama bc0106.*/
    IF p-rfidAtivo
    AND cod-integr-rfid <> 0
    THEN DO:
        FIND FIRST bf-bc-ext-item
             WHERE bf-bc-ext-item.it-codigo <> c-it-codigo
               AND bf-bc-ext-item.cod-integr-rfid = cod-integr-rfid
            NO-LOCK NO-ERROR.
        IF AVAIL bf-bc-ext-item
        THEN DO:
            ASSIGN cMsgErro = "C¢digo Integraá∆o " + STRING(cod-integr-rfid) + " j† cadastrado para o item:" + bf-bc-ext-item.it-codigo + ". Tente novamente!".
            RETURN "NOK":U.
        END.
    END.

    FOR FIRST bc-ext-item WHERE bc-ext-item.it-codigo = c-it-codigo EXCLUSIVE-LOCK:

        ASSIGN bc-ext-item.it-codigo-ext-1 = c-it-cod-ext-1 
               bc-ext-item.it-codigo-ext-2 = c-it-cod-ext-2 
               bc-ext-item.it-codigo-ext-3 = c-it-cod-ext-3 
               bc-ext-item.it-codigo-ext-4 = c-it-cod-ext-4 
               bc-ext-item.imprime-etiq    = imprime-etiq   
               bc-ext-item.qt-etiq-total   = qt-etiq-total  
               bc-ext-item.qt-etiq-item    = qt-etiq-item   
               bc-ext-item.tipo-etiq       = tipo-etiq
               bc-ext-item.tipo-etiq-total = tipo-etiq-total
               bc-ext-item.cod-integr-rfid = IF (DEC(bc-ext-item.cod-integr-rfid) = 0 OR DEC(bc-ext-item.cod-integr-rfid) = ?)
                                             THEN cod-integr-rfid
                                             ELSE bc-ext-item.cod-integr-rfid.
    END.
    IF NOT AVAILABLE bc-ext-item THEN DO:    

        CREATE bc-ext-item.
        ASSIGN bc-ext-item.it-codigo       = c-it-codigo
               bc-ext-item.it-codigo-ext-1 = c-it-cod-ext-1
               bc-ext-item.it-codigo-ext-2 = c-it-cod-ext-2
               bc-ext-item.it-codigo-ext-3 = c-it-cod-ext-3
               bc-ext-item.it-codigo-ext-4 = c-it-cod-ext-4
               bc-ext-item.imprime-etiq    = imprime-etiq
               bc-ext-item.qt-etiq-total   = qt-etiq-total
               bc-ext-item.qt-etiq-item    = qt-etiq-item
               bc-ext-item.tipo-etiq       = tipo-etiq
               bc-ext-item.tipo-etiq-total = tipo-etiq-total
               bc-ext-item.cod-integr-rfid = cod-integr-rfid.

        &IF "{&mgcld_dbtype}" <> "PROGRESS" &THEN
            RELEASE bc-ext-item.
        &ENDIF
    END.
    RETURN "OK".
END.

Procedure pi-busca-bc-ext-item:

    DEFINE INPUT  PARAMETER c-it-codigo      LIKE item.it-codigo                NO-UNDO.
    DEFINE OUTPUT PARAMETER c-it-cod-ext-1   LIKE bc-ext-item.it-codigo-ext-1   NO-UNDO.
    DEFINE OUTPUT PARAMETER c-it-cod-ext-2   LIKE bc-ext-item.it-codigo-ext-2   NO-UNDO.
    DEFINE OUTPUT PARAMETER c-it-cod-ext-3   LIKE bc-ext-item.it-codigo-ext-3   NO-UNDO.
    DEFINE OUTPUT PARAMETER c-it-cod-ext-4   LIKE bc-ext-item.it-codigo-ext-4   NO-UNDO.
    DEFINE OUTPUT PARAMETER imprime-etiq     LIKE bc-ext-item.imprime-etiq      NO-UNDO.
    DEFINE OUTPUT PARAMETER qt-etiq-total    LIKE bc-ext-item.qt-etiq-total     NO-UNDO.
    DEFINE OUTPUT PARAMETER qt-etiq-item     LIKE bc-ext-item.qt-etiq-item      NO-UNDO.
    DEFINE OUTPUT PARAMETER tipo-etiq        LIKE bc-ext-item.tipo-etiq         NO-UNDO.
    DEFINE OUTPUT PARAMETER tipo-etiq-total  LIKE bc-ext-item.tipo-etiq-total   NO-UNDO.
    DEFINE OUTPUT PARAMETER cod-integr-rfid  LIKE bc-ext-item.cod-integr-rfid   NO-UNDO.
    DEFINE OUTPUT PARAMETER log-rfid         LIKE bc-ext-item.log-rfid          NO-UNDO.
    
    FIND FIRST bc-ext-item WHERE bc-ext-item.it-codigo = c-it-codigo NO-LOCK NO-ERROR.

    IF AVAILABLE bc-ext-item THEN DO:
        ASSIGN c-it-cod-ext-1  = bc-ext-item.it-codigo-ext-1
               c-it-cod-ext-2  = bc-ext-item.it-codigo-ext-2
               c-it-cod-ext-3  = bc-ext-item.it-codigo-ext-3
               c-it-cod-ext-4  = bc-ext-item.it-codigo-ext-4
               imprime-etiq    = bc-ext-item.imprime-etiq
               qt-etiq-total   = bc-ext-item.qt-etiq-total
               qt-etiq-item    = bc-ext-item.qt-etiq-item
               tipo-etiq       = bc-ext-item.tipo-etiq
               tipo-etiq-total = bc-ext-item.tipo-etiq-total
               cod-integr-rfid = bc-ext-item.cod-integr-rfid.
    END.
    ELSE 
        RETURN "NOK":U.

    RETURN "OK".
END.


Procedure pi-busca-etiq-padrao:

    DEFINE OUTPUT PARAMETER param-bc-tp-etiq-padrao     LIKE param-bc.tp-etiq-padrao   NO-UNDO.
    DEFINE OUTPUT PARAMETER tipo-etiqueta-titulo        LIKE tipo-etiqueta.titulo   NO-UNDO.
    
    FIND FIRST param-bc NO-LOCK NO-ERROR.

    IF AVAILABLE param-bc THEN DO:
        ASSIGN param-bc-tp-etiq-padrao = param-bc.tp-etiq-padrao.
        
        FIND FIRST tipo-etiqueta where tipo-etiqueta.tipo-etiq = param-bc.tp-etiq-padrao NO-LOCK NO-ERROR.
        IF AVAILABLE tipo-etiqueta THEN 
            ASSIGN tipo-etiqueta-titulo = tipo-etiqueta.titulo.
        ELSE 
            ASSIGN tipo-etiqueta-titulo = "".
            
    END.
    ELSE 
        RETURN "NOK":U.

    RETURN "OK".
END.

