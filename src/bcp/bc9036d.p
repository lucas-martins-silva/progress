/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9036D 2.00.00.005 } /*** "010005" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC9036D MBC}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/********************************************************************************************
**   Programa..: bc9036d.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - agosto/2006 - Cria‡Æo do programa                           **
**                                                                                         **
**   Finalidade: Adapter da transacao de Conferˆncia Embarque                              ** 
**                                                                                         **
********************************************************************************************/
&if '{&mgscm_version}' >= '2.04' &then
{bcp/bc9102.i}     /* Definicao da temp-table de erros do coleta de dados         */
{bcp/bc9107.i}     /* Definicao dos campos de comunicacao com o adapter           */
{bcp/bc9036.i}     /* Definicao da temp-table de transferencia do coleta de dados */
/* DEFINICAO FIXA POIS A TABELA NAO EXISTE NA VERSAO 2.02 - FLAVIO.ARCEGA
{scbo/bosc156.i TtWms-conferen-packing }   /* TEMP-TABLE DE BOSC056 */ */
DEFINE TEMP-TABLE TtWms-conferen-packing
    FIELD cod-estabel        AS CHAR      FORMAT "X(3)":U               
    FIELD cod-local          AS CHAR      FORMAT "X(3)":U               
    FIELD id-docto           AS DECIMAL   FORMAT ">>>>>>>>>9":U DECIMALS 10        
    FIELD nr-leitura         AS INT       FORMAT ">>9":U                
    FIELD cod-usuario        AS CHAR      FORMAT "X(12)":U              
    FIELD val-etiq-packing   AS DECIMAL   FORMAT ">>>>>>>>>>>>>>9":U DECIMALS 0  
    FIELD cod-embalagem      AS CHAR      FORMAT "X(10)":U              
    FIELD nr-embarque        AS INT       FORMAT ">>>>>9":U             
    FIELD nr-resumo          AS INT       FORMAT ">>>>,>>9":U           
    FIELD nr-pedcli          AS CHAR      FORMAT "X(12)":U              
    FIELD nome-abrev         AS CHAR      FORMAT "X(12)":U              
    FIELD num-volume         AS INT       FORMAT ">>>>>>>>>9":U         
    FIELD cod-usuario-aprov  AS CHAR      FORMAT "X(12)":U              
    FIELD cod-livre-1        AS CHAR      FORMAT "X(100)":U             
    FIELD cod-livre-2        AS CHAR      FORMAT "X(100)":U             
    FIELD log-livre-1        AS LOGICAL   FORMAT "Sim/NÆo":U             
    FIELD log-livre-2        AS LOGICAL   FORMAT "Sim/NÆo":U            
    FIELD num-livre-1        AS INTEGER   FORMAT "->>>>>>>>9":U         
    FIELD num-livre-2        AS INTEGER   FORMAT "->>>>>>>>9":U
    FIELD val-livre-1        AS DECIMAL   FORMAT "->>>>>>>>>>>9.9999":U DECIMALS 10
    FIELD val-livre-2        AS DECIMAL   FORMAT "->>>>>>>>>>>9.9999":U DECIMALS 10
    FIELD dat-livre-1        AS DATE      FORMAT "99/99/9999":U         
    FIELD dat-livre-2        AS DATE      FORMAT "99/99/9999":U
    FIELD cdd-embarq         AS DEC       FORMAT ">>>>>>>>>>>>>>>9":U   
    FIELD r-Rowid            AS ROWID.


/*********************************************************************************/
/*********************************************************************************/
Define Input        Parameter pNumTrans    as integer No-undo.
Define Input        Parameter Table For ttIntegracao.
Define Input-Output Parameter Table For tt-erro.
/*********************************************************************************/
Define Variable vRaw                As Raw                  No-undo.
DEFINE VARIABLE vsequencia          AS INTEGER              NO-UNDO.
/*********************************************************************************/

DEF VAR hBosc156 AS HANDLE NO-UNDO.
DEF VAR hBosc095 AS HANDLE NO-UNDO.

DEF VAR iTipoConf               AS INT   NO-UNDO.
DEF VAR r-rowid-tabela          AS ROWID NO-UNDO.
DEF VAR cCodEquipamento         AS CHAR  NO-UNDO.
DEF VAR cCodColetor             AS CHAR  NO-UNDO.
DEF VAR deQtdTotalLeituras      AS DEC   NO-UNDO.
DEF VAR deQtdLeiturasEfetuadas  AS DEC   NO-UNDO.

DEF TEMP-TABLE RowErrors NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

DO TRANS:
    EMPTY TEMP-TABLE tt-erro.

    FIND FIRST ttIntegracao NO-LOCK NO-ERROR.
    IF NOT AVAIL ttIntegracao THEN DO:
        RUN utp/ut-msgs.p ( INPUT "msg",
                            INPUT 25346,
                            INPUT "bc9036d").
        CREATE tt-erro.
        ASSIGN tt-erro.cd-erro  = 25346
               tt-erro.i-sequen = vsequencia
               tt-erro.mensagem = TRIM(RETURN-VALUE) + "(DC)":U.
        RETURN "NOK":U.
    END.

    FIND FIRST tt-erro NO-LOCK NO-ERROR.
    IF AVAIL tt-erro THEN RETURN "NOK":U.

    ASSIGN deQtdLeiturasEfetuadas = _RetornaValDeci('qtd-leituras-efetuadas')
           deQtdTotalLeituras     = _RetornaValDeci('qtd-total-leituras')
           iTipoConf              = _RetornaValInte('tipo-conferencia')
           r-rowid-tabela         = TO-ROWID(_RetornaValChar('rowid-tabela'))
           cCodEquipamento        = _RetornaValChar('cod-equipamento')
           cCodColetor            = _RetornaValChar('cod-coletor').
    
    bc9036:
    DO ON ERROR  UNDO bc9036, LEAVE bc9036
       ON QUIT   UNDO bc9036, LEAVE bc9036
       ON STOP   UNDO bc9036, LEAVE bc9036
       ON ENDKEY UNDO bc9036, LEAVE bc9036:
       
        IF NOT VALID-HANDLE(hBosc156) THEN
            RUN scbo/bosc156.p PERSISTENT SET hBosc156.

        CREATE TtWms-conferen-packing.
        ASSIGN Ttwms-conferen-packing.cod-estabel       = _RetornaValChar('cod-estabel').
        ASSIGN Ttwms-conferen-packing.cod-local         = _RetornaValChar('cod-local').
        ASSIGN Ttwms-conferen-packing.id-docto          = _RetornaValDeci('id-docto').
        ASSIGN Ttwms-conferen-packing.val-etiq-packing  = _RetornaValDeci('num-etiqueta-packing').
        ASSIGN Ttwms-conferen-packing.cdd-embarq        = _RetornaValDeci('cdd-embarq').
        ASSIGN Ttwms-conferen-packing.cod-usuario       = _RetornaValChar('cod-usuario').
        ASSIGN Ttwms-conferen-packing.cod-embalagem     = _RetornaValChar('cod-embalagem').
        ASSIGN Ttwms-conferen-packing.nr-resumo         = _RetornaValInte('nr-resumo').
        ASSIGN Ttwms-conferen-packing.nr-pedcli         = _RetornaValChar('nr-pedcli').
        ASSIGN Ttwms-conferen-packing.nome-abrev        = _RetornaValChar('nome-abrev').
        ASSIGN Ttwms-conferen-packing.cod-usuario-aprov = "".

        /* Se for a primeira leitura, inicializa tarefa de conferˆncia */
        IF NOT VALID-HANDLE(hBosc095) THEN
            RUN scbo/bosc095.p PERSISTENT SET hBosc095.
        
        RUN iniciaTarefaDoctoConfEmb IN hBosc095 (INPUT  Ttwms-conferen-packing.cod-estabel,
                                                  INPUT  Ttwms-conferen-packing.cod-local,
                                                  INPUT  Ttwms-conferen-packing.id-docto,
                                                  INPUT  r-rowid-tabela,
                                                  INPUT  iTipoConf,
                                                  INPUT  Ttwms-conferen-packing.cod-usuario,
                                                  INPUT  cCodEquipamento,
                                                  INPUT  cCodColetor,
                                                  INPUT  Ttwms-conferen-packing.cdd-embarq,
                                                  OUTPUT Ttwms-conferen-packing.nr-leitura).

        IF RETURN-VALUE <> "OK":U THEN DO:
            RUN getRowErrors IN hBosc095 (OUTPUT TABLE RowErrors) NO-ERROR.
            FOR EACH RowErrors:
                CREATE tt-erro.
                ASSIGN tt-erro.i-sequen = 1
                       tt-erro.cd-erro  = ErrorNumber
                       tt-erro.mensagem = ErrorDescription + "(WMS)".
            END.
            DELETE OBJECT hBosc156.
            DELETE OBJECT hBosc095.
            UNDO, RETURN "NOK":U.
        END.
        DELETE OBJECT hBosc095.

        
        /* Cria registro de Conferˆncia de Packing */
        RUN createWm-conferencia-packing IN hBosc156 (INPUT TABLE TtWms-conferen-packing).
        IF RETURN-VALUE <> "OK":U THEN DO:
            RUN getRowErrors IN hBosc156 (OUTPUT TABLE RowErrors) NO-ERROR.
            FOR EACH RowErrors:
                CREATE tt-erro.
                ASSIGN tt-erro.i-sequen = 1
                       tt-erro.cd-erro  = ErrorNumber
                       tt-erro.mensagem = ErrorDescription + "(WMS)".
            END.
            DELETE OBJECT hBosc156.
            UNDO, RETURN "NOK":U.
        END.
        ELSE
            /* Verifica se ‚ a £ltima leitura, para finalizar conferˆncia */
            IF deQtdLeiturasEfetuadas >= deQtdTotalLeituras THEN DO:
                IF NOT VALID-HANDLE(hBosc095) THEN
                   RUN scbo/bosc095.p PERSISTENT SET hBosc095.
                
                /* Executa finaliza‡Æo da conferˆncia */
                RUN concluiTarefaDoctoConfEmb IN hBosc095 (INPUT Ttwms-conferen-packing.cod-estabel,
                                                           INPUT Ttwms-conferen-packing.cod-local, 
                                                           INPUT Ttwms-conferen-packing.id-docto,  
                                                           INPUT r-rowid-tabela,
                                                           INPUT iTipoConf,  
                                                           INPUT Ttwms-conferen-packing.nr-leitura,
                                                           INPUT Ttwms-conferen-packing.cod-usuario,
                                                           INPUT Ttwms-conferen-packing.cdd-embarq).
                IF RETURN-VALUE <> "OK":U THEN DO:
                    RUN getRowErrors IN hBosc095 (OUTPUT TABLE RowErrors) NO-ERROR.
                    FOR EACH RowErrors:
                        CREATE tt-erro.
                        ASSIGN tt-erro.i-sequen = 1
                               tt-erro.cd-erro  = ErrorNumber
                               tt-erro.mensagem = ErrorDescription + "(WMS)".
                    END.
                    RUN destroy IN hBosc156.
                    RUN destroy IN hBosc095.
                    IF VALID-HANDLE(hBosc156) THEN DELETE OBJECT hBosc156.
                    IF VALID-HANDLE(hBosc095) THEN DELETE OBJECT hBosc095.
                    UNDO, RETURN "NOK":U.
                END.
                RUN destroy IN hBosc095.
                IF VALID-HANDLE(hBosc095) THEN DELETE OBJECT hBosc095.
            END.
        RUN destroy IN hBosc156.
        IF VALID-HANDLE(hBosc156) THEN DELETE OBJECT hBosc156.
    END.
    
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "OK":U THEN DO:
        ASSIGN vsequencia = vsequencia + 1.
        FIND LAST tt-erro NO-LOCK NO-ERROR.
        IF AVAILABLE tt-erro THEN ASSIGN vsequencia = tt-erro.i-sequen + 1.
        CREATE tt-erro.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Problemas_no_processo_PRE-API" *}
        ASSIGN tt-erro.i-sequen = vsequencia
               tt-erro.cd-erro  = 999
               tt-erro.mensagem = RETURN-VALUE + " " + ERROR-STATUS:GET-MESSAGE(1) + "(DC)":U.
        UNDO, RETURN "NOK".
    END.
END.
&endif.
