/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9029E 2.00.00.006 } /*** "010006" 09/10/2025 11:26:33 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bc9029 MBC}
&ENDIF

{include/i_dbvers.i}  /* versao das bases e bases instaladas */
&IF '{&mgscm_version}' >= '2.04' &THEN

/***************************************************************************************************
** SECAO DE PRE-PROCESSADORES DA TEMPLATE                                                         **
** Nesta secao sao definidos os pre-processadores que serao usados na montagem da interface.      **
**                                                                                                **
** DESCRICAO DOS PREPROCESSADORES:                                                                **
** ProgramName          - Nome do programa e, tambem, do Codigo da transacao do Data Collection   **
**                        que sera acionada pela interface.                                       **
** TempTable            - Nome da Temp-Table da transacao de negocio para comunicacao com ERP.    **
**                        Ex: tt-recebe-wms.                                                      **
** FrameSize            - Tamanho da tela da interface. Deve-se observar este parametro quando da **
**                        definicao das telas, o espaco utilizado nao pode ultrapassar o limite   **
**                        estabelecido por este pre-processador.                                  **
** Frame99Name          - Nome da Tela. Sugestao "Frame" mais sequencia.                          **
**                        Ex. Frame01, Frame02, Frame03, etc.                                     **
** Frame99Defs          - Definicoes da tela onde a mesma deve conter:                            **
**                        .Titulo da Tela quando necessario.                                      **
**                        .Campos com a opcao no-label e sua localizacao Ex. At Row x Col y.      **
**                        .Literais que substituem os labels dos campos e sua localizacao.        **
**                        .Instrucoes de Navegacao quando houver espaco livre para o mesmo.       **
**                        Ex. "F4=Sair","ESC=Voltar","F2=Gravar" etc.                             **
** Frame99Repeat        - Indica se a tela tem caracteristica de repeticao. O Valor YES indica    **
**                        que ha repeticao e o valor NO indica que nao ha repeticao.              **
** Update99Fields       - Relaciona os campos que serao solicitados na tela.                      **
**                        OBS. Nao deve conter formatacao. Ex. ttWork.it-codigo no-label.         **
** TriggerBeforeFrame99 - Gatilho para ser executado antes da execucao da tela. Neste gatilho     **
**                        devem ser colocadas chamadas as procedures de inicializacao dos campos  **
**                        da tela.                                                                **
** TriggerAfterFrame99  - Gatilho para ser executado apos a execucao da tela. Neste gatilho       **
**                        dever ser colocada a chamada a procedures que devera armazenar  na      **
**                        temp-table {&TempTable} os campos da ttWork, que sao os campos          **
**                        solicitados em tela. Neste gatilho tambem, quando o mesmo se referir a  **
**                        ultima tela de entrada de dados, devera existir uma chamada a procedure **
**                        que executa a procedure _GenerateDCTransaction que eï responsavel por   **
**                        gerar a transacao no Coleta de Dados.                                   **
** UserTriggers         - Este pro-processador destina-se as triggers customizadas do usuario.    **
**                        Ex: Alimentar um campo da dela conforme o informado em outro campo.     **
**                            On Leave of ttWork.cod-depos in Frame Frame02                       **
**                            Do:                                                                 **
**                                Case ttWork.cod-depos:                                          **
**                                  When 'Pro' Then Assign ttWork.cod-local = 'Pro01'.            **
**                                  When 'Alm' Then Assign ttWork.cod-local = 'Alm01'.            **
**                                  When 'Exp' Then Assign ttWork.cod-local = 'Exp01'.            **
**                            End.                                                                **
** AtiveObject1         - Este pro-processador permite que se destruam os objetos persistentes    **
**                        no final da sessao progress.                                            **
**                        Ex: &global-define ActiveObject Hbosc074                               **
***************************************************************************************************/

DEFINE INPUT  PARAMETER pCod-usuario              AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pCod-coletor              AS INTEGER     NO-UNDO.
DEFINE INPUT  PARAMETER pCod-equipamento          AS INTEGER     NO-UNDO.
DEFINE INPUT  PARAMETER pRowid-tarefa-docto-itens AS ROWID       NO-UNDO.
DEFINE OUTPUT PARAMETER pLogEsc                   AS LOGICAL     NO-UNDO.

/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9029
/************************************************************/

DEFINE VARIABLE de-id-box       LIKE wm-box-movto.id-box NO-UNDO.
DEFINE VARIABLE c-cod-bloco     AS CHARACTER             NO-UNDO.
DEFINE VARIABLE c-desc-bloco    AS CHARACTER             NO-UNDO.
DEFINE VARIABLE c-cod-coluna    AS CHARACTER             NO-UNDO.
DEFINE VARIABLE c-desc-coluna   AS CHARACTER             NO-UNDO.
DEFINE VARIABLE c-cod-nivel     AS CHARACTER             NO-UNDO.
DEFINE VARIABLE c-desc-nivel    AS CHARACTER             NO-UNDO.
DEFINE VARIABLE c-cod-rua       AS CHARACTER             NO-UNDO.
DEFINE VARIABLE c-desc-rua      AS CHARACTER             NO-UNDO.
DEFINE VARIABLE c-desc-endereco AS CHARACTER             NO-UNDO.
DEFINE VARIABLE i-ind-pos-box   AS INTEGER               NO-UNDO.

{utp/utapi009.i} /* login */
{utp/ut-glob.i}

/* Definicao da temp-table de integracao ---                */
&global-define TEMPTABLE tt-storage-serial-wms
{bcp/bc9029.i}

DEFINE TEMP-TABLE ttwm-etiqueta            NO-UNDO LIKE wm-etiqueta.

DEFINE TEMP-TABLE tt-wm-movto-etiqueta     NO-UNDO LIKE wm-movto-etiqueta
    FIELD r-rowid  AS ROWID.

{scbo/bosc096.i tt-wm-tarefa-docto-itens}

{method/dbotterr.i}



DEFINE TEMP-TABLE ttWork NO-UNDO LIKE {&TempTable}.
CREATE ttWork.
ASSIGN ttWork.cod-usuario     = STRING(pCod-usuario)
       ttWork.cod-coletor     = STRING(pCod-coletor)
       ttWork.cod-equipamento = STRING(pCod-equipamento).
/************************************************************/

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8
/************************************************************/


/* ************************** Definitions ******************************** */
DEFINE VARIABLE vNomeUsuario           AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE c-cod-lote             AS CHARACTER FORMAT "x(40)"           NO-UNDO.
DEFINE VARIABLE de-num-serial-sugerido AS DECIMAL   FORMAT ">>>>>>>>>>>>>9"  NO-UNDO.
DEFINE VARIABLE c-referencia           AS CHARACTER FORMAT "x(08)"           NO-UNDO.
DEFINE VARIABLE c-endereco             AS CHARACTER FORMAT "x(20)"           NO-UNDO.
DEFINE VARIABLE c-desc-item            AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE l-log-picking          AS LOGICAL                            NO-UNDO.
DEFINE VARIABLE de-qtd                 AS DECIMAL   FORMAT ">>>,>>>,>>9.99"  NO-UNDO.
DEFINE VARIABLE h-bosc032              AS HANDLE                             NO-UNDO.
DEFINE VARIABLE h-bosc039              AS HANDLE                             NO-UNDO.
DEFINE VARIABLE h-bosc096              AS HANDLE                             NO-UNDO.
DEFINE VARIABLE Hbcapiwms              AS HANDLE                             NO-UNDO.
DEFINE VARIABLE Hbcapi9029             AS HANDLE                             NO-UNDO.
DEFINE VARIABLE Hbosc074               AS HANDLE                             NO-UNDO.



/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                             */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Armaz. WMS   '                                   AT ROW 01 COL 01          ~
                              ttWork.cod-item                                  AT ROW 02 COL 01 NO-LABEL ~
                             'Ref:'                                            AT ROW 03 COL 01          ~
                              c-referencia                                     AT ROW 03 COL 06 NO-LABEL ~
                             'Lt:'                                             AT ROW 04 COL 01          ~
                              c-cod-lote                                       AT ROW 04 COL 04 NO-LABEL FORMAT "x(40)" VIEW-AS FILL-IN SIZE 11 BY 0.88 ~
                             'Qt:'                                             AT ROW 05 COL 01          ~
                              de-qtd                                           AT ROW 05 COL 05 NO-LABEL ~
                              de-num-serial-sugerido                           AT ROW 06 COL 01 NO-LABEL ~
                             'Ser:'                                            AT ROW 07 COL 01          ~
                              ttWork.num-serial                                    AT ROW 08 COL 01 NO-LABEL ~
&global-define Frame01Repeat NO

/* Definicao da Frame02 ---                             */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Armaz. Serial WMS   '                            AT ROW 01 COL 01          ~
                             '--------------------'                            AT ROW 02 COL 01          ~
                             'Serial:'                                         AT ROW 03 COL 01          ~
                              ttWork.num-serial                                AT ROW 04 COL 01 NO-LABEL ~
                             'Item:'                                           AT ROW 05 COL 01          ~
                              ttWork.cod-item                                  AT ROW 06 COL 01 NO-LABEL ~
                              ttWork.des-endereco                              AT ROW 07 COL 01 NO-LABEL ~
                             'Box: '                                           AT ROW 08 COL 01          ~
                              ttWork.num-box-lido                              AT ROW 08 COL 05 NO-LABEL ~
&global-define Frame02Repeat NO
/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.num-serial
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01.
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02.
&global-define TriggerAfterFrame01  Run GravaCamposFrame01.
&global-define TriggerAfterFrame02  Run GravaCamposFrame02.


/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ~
                            ON 'ESC':U OF FRAME Frame01    ~
                            DO:                            ~
                               ASSIGN vlogerro     = NO    ~
                                      vLogsai      = YES   ~
                                      vLogfinaliza = YES   ~
                                      pLogEsc      = YES.  ~
                            END.                           ~
                            ON 'ESC':U OF FRAME Frame02    ~
                            DO:                            ~
                                ASSIGN vlogerro     = NO   ~
                                       vLogsai      = YES  ~
                                       vLogfinaliza = YES  ~
                                       pLogEsc      = YES. ~
                            END.
/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 Hbcapiwms
&global-define ActiveObject2 Hbcapi9029
&global-define ActiveObject3 h-bosc032
&global-define ActiveObject4 h-bosc039
&global-define ActiveObject5 h-bosc096


/************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */


/**************************************************************************************************/

/************************************* Codigo do Usuario Inicio ************************************
** Este local ‚ destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/


/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame01 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame01:

    ASSIGN vLogErro     = NO                               
           vLogsai      = NO                               
           vLogfinaliza = NO
           pLogEsc      = NO.

    FIND FIRST ttWork NO-ERROR.

    EMPTY TEMP-TABLE tt-wm-tarefa-docto-itens.
    EMPTY TEMP-TABLE tt-wm-movto-etiqueta.

    IF NOT VALID-HANDLE(h-bosc096) THEN DO:
        RUN scbo/bosc096.p PERSISTENT SET h-bosc096       NO-ERROR.
        RUN openQueryStatic IN h-bosc096 (INPUT "Main":U) NO-ERROR.
    END.

    IF VALID-HANDLE(h-bosc096) THEN DO:
        RUN repositionRecord IN h-bosc096 (INPUT pRowid-tarefa-docto-itens) NO-ERROR.
        IF RETURN-VALUE = "OK":U THEN
            RUN getRecord    IN h-bosc096 (OUTPUT TABLE tt-wm-tarefa-docto-itens).

        FIND FIRST tt-wm-tarefa-docto-itens NO-LOCK NO-ERROR.
        IF  AVAIL  tt-wm-tarefa-docto-itens THEN DO:
    
            IF NOT VALID-HANDLE(h-bosc032) THEN
               RUN scbo/bosc032.p PERSISTENT SET h-bosc032.

            IF VALID-HANDLE(h-bosc032) THEN DO:
                RUN getCamposTarefaDoctoItens IN h-bosc032 (INPUT  tt-wm-tarefa-docto-itens.cod-estabel,
                                                            INPUT  tt-wm-tarefa-docto-itens.cod-local,
                                                            INPUT  tt-wm-tarefa-docto-itens.id-movto,
                                                            INPUT  tt-wm-tarefa-docto-itens.ind-tipo-movto,
                                                            OUTPUT ttWork.cod-item,
                                                            OUTPUT de-qtd,
                                                            OUTPUT c-endereco,
                                                            OUTPUT l-log-picking,
                                                            OUTPUT c-desc-item).

                RUN getEtiquetaMovto          IN h-bosc032 (INPUT  tt-wm-tarefa-docto-itens.id-movto,
                                                            OUTPUT TABLE tt-wm-movto-etiqueta).

                FIND FIRST tt-wm-movto-etiqueta NO-LOCK NO-ERROR.
                ASSIGN de-num-serial-sugerido = IF AVAIL tt-wm-movto-etiqueta THEN tt-wm-movto-etiqueta.id-etiqueta ELSE 0.

                RUN getMovtoIn                IN h-bosc032 (INPUT  tt-wm-tarefa-docto-itens.cod-estabel,
                                                            INPUT  tt-wm-tarefa-docto-itens.cod-local,
                                                            INPUT  tt-wm-tarefa-docto-itens.id-movto,
                                                            OUTPUT de-id-box).

                RUN getDescriptionAddress     IN h-bosc032 (INPUT de-id-box,
                                                            INPUT tt-wm-tarefa-docto-itens.cod-estabel,
                                                            INPUT tt-wm-tarefa-docto-itens.cod-local,
                                                            OUTPUT c-cod-bloco,
                                                            OUTPUT c-desc-bloco,
                                                            OUTPUT c-cod-coluna,
                                                            OUTPUT c-desc-coluna,
                                                            OUTPUT c-cod-nivel,
                                                            OUTPUT c-desc-nivel,
                                                            OUTPUT c-cod-rua,
                                                            OUTPUT c-desc-rua,
                                                            OUTPUT i-ind-pos-box).

                ASSIGN c-desc-endereco = c-cod-bloco + "/" + c-cod-rua + "/" + c-cod-nivel + "/" + c-cod-coluna + "/" + IF i-ind-pos-box = 1 THEN "E" ELSE "D".
            END.

            IF NOT VALID-HANDLE(h-bosc039) THEN
                RUN scbo/bosc039.p PERSISTENT SET h-bosc039.

            IF  VALID-HANDLE(h-bosc039) THEN DO:
                RUN setConstraintDocto IN h-bosc039 (INPUT tt-wm-tarefa-docto-itens.cod-estabel,
                                                     INPUT tt-wm-tarefa-docto-itens.cod-local,
                                                     INPUT tt-wm-tarefa-docto-itens.id-docto).
                RUN openQueryStatic    IN h-bosc039 (INPUT "Docto":U) NO-ERROR.
                RUN goToKey            IN h-bosc039 (INPUT tt-wm-tarefa-docto-itens.cod-estabel,
                                                     INPUT tt-wm-tarefa-docto-itens.cod-local,
                                                     INPUT tt-wm-tarefa-docto-itens.id-docto,
                                                     INPUT tt-wm-tarefa-docto-itens.num-seq-item).

                RUN getCharField       IN h-bosc039 (INPUT "cod-lote":U,
                                                     OUTPUT c-cod-lote).
            END.
        END.
    END.

    DISPLAY ttWork.cod-item
            c-referencia
            c-cod-lote
            de-qtd
            de-num-serial-sugerido
            ttWork.num-serial
        WITH FRAME Frame01.

END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame02 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame02}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame02:

    IF pLogEsc THEN
        RETURN RETURN-VALUE.

    IF v_cod_usuar_corren = "" THEN RETURN ERROR.

    FIND FIRST ttWork NO-ERROR.

    ASSIGN ttWork.des-endereco = c-desc-endereco
           ttWork.num-box      = de-id-box.

    DISPLAY ttWork.num-serial  
            ttWork.cod-item    
            ttWork.des-endereco
            ttWork.num-box-lido
        WITH FRAME Frame02.

END PROCEDURE.



/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:

    ASSIGN vLogErro = NO.
        
    IF NOT VALID-HANDLE (Hbcapi9029) THEN DO:                             
        RUN bcp/bcapi9029.p PERSISTENT SET Hbcapi9029.  
    END.

    IF NOT VALID-HANDLE(Hbosc074) THEN DO:
       RUN scbo/bosc074.p PERSISTENT SET Hbosc074       NO-ERROR.
       RUN openQueryStatic IN Hbosc074 (INPUT "Main":U) NO-ERROR.
    END.

    EMPTY TEMP-TABLE rowerrors.

    RUN getInfoEtiqueta IN Hbosc074 (INPUT ttWork.num-serial,
                                     OUTPUT TABLE ttwm-etiqueta).
    IF RETURN-VALUE <> "OK":U THEN DO:
        RUN getrowErrors In Hbosc074 (OUTPUT TABLE RowErrors).
        FOR EACH Rowerrors NO-LOCK:
            RUN bcp/bc9115.p  (Rowerrors.ErrorNumber, Rowerrors.ErrorDescription,8,20,3).
        END.
        RETURN ERROR.
    END.

    FIND FIRST ttwm-etiqueta NO-LOCK NO-ERROR.

    IF AVAIL ttwm-etiqueta AND NOT(ttwm-etiqueta.log-reportada) THEN DO:
        ASSIGN vLogErro = YES.
        {bcp/bc9105.i "10" "Etiqueta nao reportada "}
        RETURN ERROR.
    END.

    IF VALID-HANDLE(Hbosc074) THEN
        DELETE OBJECT Hbosc074.

    EMPTY TEMP-TABLE tt-erro.

    RUN GetSerialStorageTask IN Hbcapi9029 (INPUT-OUTPUT TABLE ttWork,
                                            OUTPUT TABLE tt-erro).
    IF RETURN-VALUE <> 'OK':U THEN DO:
       FOR EACH tt-erro:
           RUN bcp/bc9115.p (tt-erro.cd-erro,tt-erro.mensagem,8,20,3).
       END.
       ASSIGN vLogErro = YES.
       RETURN ERROR.
    END.

    FIND FIRST ttWork NO-ERROR.

END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame02:

    /* Se foi dado "ESC", sai do programa */
    IF pLogEsc THEN DO:
        ASSIGN vLogsai      = YES
               vLogfinaliza = YES.
        RETURN "OK":U.
    END.

    IF NOT VALID-HANDLE(Hbcapiwms) THEN
       RUN bcp/bcapiwms.p PERSISTENT SET Hbcapiwms NO-ERROR.


    DO TRANSACTION ON ENDKEY UNDO, RETURN ERROR:
        FOR EACH tt-erro:
          DELETE tt-erro.
        END.

        RUN StartTask IN Hbcapiwms (INPUT ttWork.cod-usuario,
                                    INPUT ttWork.cod-coletor,
                                    INPUT ttWork.cod-equipamento,
                                    INPUT 13,
                                    INPUT ttWork.id-docto,
                                    INPUT ttWork.id-movto,
                                    INPUT ttWork.num-seq-item,
                                    OUTPUT TABLE tt-erro).

        IF RETURN-VALUE <> "OK" THEN DO:
           FOR EACH tt-erro:
               RUN bcp/bc9115.p (tt-erro.cd-erro,tt-erro.mensagem,8,20,3).
           END.
           ASSIGN vLogErro = YES.
           RETURN ERROR.
        END.

        ASSIGN ttWork.horario-inicio = TIME.

        RUN GetAddressDescription IN Hbcapiwms (INPUT  ttWork.num-box,
                                                INPUT  ttWork.cod-estabel,
                                                INPUT  ttWork.cod-local,
                                                OUTPUT ttWork.des-endereco).

        IF  RETURN-VALUE = 'NOK':U THEN DO:
            RUN bcp/bc9115.p (tt-erro.cd-erro,tt-erro.mensagem,8,20,3).
            UNDO, RETURN.
        END.

        DO WHILE vLogErro = NO ON ENDKEY UNDO, RETURN ERROR:
            UPDATE ttWork.num-box-lido NO-LABELS WITH FRAME {&Frame02Name}.

            IF ttWork.num-box-lido <> ttWork.num-box THEN DO:
                {bcp/bc9105.i "0" "Endere‡o inv lido "}
                ASSIGN vLogErro = NO.
            END.
            ELSE 
                ASSIGN vLogErro = YES.
        END.
        ASSIGN vLogErro = NO.
    END.

    ASSIGN {&TempTable}.num-box-lido   = ttWork.num-box-lido
           {&TempTable}.cod-item       = ttWork.cod-item
           {&TempTable}.num-serial     = ttWork.num-serial
           {&TempTable}.des-endereco   = ttWork.des-endereco
           {&TempTable}.cod-estabel    = ttWork.cod-estabel
           {&TempTable}.cod-local      = ttWork.cod-local
           {&TempTable}.num-box        = ttWork.num-box
           {&TempTable}.id-docto       = ttWork.id-docto
           {&TempTable}.id-movto       = ttWork.id-movto
           {&TempTable}.num-seq-item   = ttWork.num-seq-item
           {&TempTable}.horario-inicio = ttWork.horario-inicio.

    RUN GravaTransacao IN THIS-PROCEDURE.

    ASSIGN vLogsai      = YES
           vLogfinaliza = YES.

    RETURN "OK":U.
END PROCEDURE.


/*************************************************************************************************** 
** Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure      **
** _GenerateDCTransaction.                                                                        **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame04}.                       **
****************************************************************************************************/
PROCEDURE GravaTransacao:

    ASSIGN vTransDetail = VTransaction    +
                          " Serial: "     +  STRING({&TempTable}.num-serial)     + 
                          " id-Docto: "   +  STRING({&temptable}.id-docto)       +
                          " id-Movto: "   +  STRING({&temptable}.id-movto)       +
                          " NumSeqItem: " +  STRING({&TempTable}.num-seq-item)   +
                          " Item: "       +  STRING(TRIM({&TempTable}.cod-item)) +
                          " idBox: "      +  STRING({&TempTable}.num-box).

    RUN _RetornaUsuario (OUTPUT vNomeUsuario).

    ASSIGN {&TempTable}.dat-atualizacao         = TODAY
           {&TempTable}.dat-transacao           = TODAY
           {&TempTable}.cod-usuario             = vNomeUsuario.

    RAW-TRANSFER {&TempTable} TO vConteudoRaw.

    FOR EACH tt-erro-after-GenerateDC:
        DELETE tt-erro-after-GenerateDC.
    END.
    
    RUN _GenerateDCTransaction (INPUT vTransaction,   /* Codigo da Transacao                 */
                                INPUT vConteudoRaw,   /* Conteudo da temp-table {&TempTable} */
                                INPUT vTransDetail,   /* Cabecalho de detalhes da transacao  */
                                INPUT vNomeUsuario).  /* Usuario responsavel pela transacao  */

    FIND FIRST tt-erro-after-GenerateDC NO-LOCK NO-ERROR.

    IF AVAIL tt-erro-after-GenerateDC THEN DO:
        RUN bcp/bc9115.p (tt-erro-after-GenerateDC.cd-erro,tt-erro-after-GenerateDC.mensagem,8,20,3).
        HIDE ALL.

        RETURN "NOK":U.
    END.
    ELSE DO:
        RUN bcp/bc9115.p ("0", "Armazenamento efetuado com sucesso.",8,20,3).
        HIDE ALL.

        RETURN "OK":U.
    END.
    
END PROCEDURE.
/*************************************  Codigo do Usuario Fim   **********************************/
&ELSE 
    RUN utp/ut-msgs.p (INPUT "show", 
                       INPUT 28036,
                       INPUT "").
&ENDIF

