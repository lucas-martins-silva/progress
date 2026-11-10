/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9029F 2.00.00.006 } /*** "010006" 09/10/2025 11:26:33 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bc9029f MBC}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i_dbvers.i}  /* versao das bases e bases instaladas */
/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/********************************************************************************************
**   Programa..: bc9029.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - Maio de 2012 - Cria‡Æo do programa                          **
**                                                                                         **
**                                                                                         **
********************************************************************************************/
&if '{&mgscm_version}' >= '2.04' &then

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

/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9029
/************************************************************/

{utp/utapi009.i} /* login */
{utp/ut-glob.i}

/* Definicao da temp-table de integracao ---                */

&global-define TEMPTABLE tt-storage-serial-wms
{bcp/bc9029.i}

DEFINE TEMP-TABLE ttwm-etiqueta NO-UNDO LIKE wm-etiqueta.
{method/dbotterr.i}

Define Temp-table ttWork    NO-UNDO like {&TempTable}.
Define Temp-table ttWorkAux NO-UNDO like {&TempTable}.

DEFINE TEMP-TABLE tt-etiqueta-lida NO-UNDO
    FIELD id-etiqueta LIKE wm-etiqueta.id-etiqueta
    FIELD qtd-item    LIKE wm-etiqueta.qtd-item.

DEFINE INPUT PARAMETER TABLE FOR ttWork.
DEFINE INPUT PARAMETER TABLE FOR tt-etiqueta-lida.
DEFINE OUTPUT PARAMETER l-ok AS LOGICAL NO-UNDO.

FIND FIRST ttWork NO-ERROR.
/************************************************************/

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/


/* ************************** Definitions ******************************** */
DEFINE VARIABLE vcod-senha        AS CHARACTER FORMAT 'x(14)':U              NO-UNDO.
DEFINE VARIABLE vNomeUsuario      AS CHARACTER           NO-UNDO.
DEFINE VARIABLE vLogControlaLogin AS LOGICAL INITIAL NO  NO-UNDO.

DEFINE VARIABLE l-leitura   AS LOGICAL                           NO-UNDO.
DEFINE VARIABLE d-id-movto  LIKE wm-box-movto.id-movto INITIAL 0 NO-UNDO.

DEFINE VARIABLE Hbosc038   AS HANDLE.
DEFINE VARIABLE Hbosc109   AS HANDLE.
DEFINE VARIABLE Hbcapiwms  AS HANDLE.
DEFINE VARIABLE Hbcapi9029 AS HANDLE.
DEFINE VARIABLE Hbosc074   AS HANDLE.


/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                             */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Armaz. Serial WMS   '                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Serial:'                                          AT ROW 03 COL 01          ~
                              ttWork.num-serial                                 AT ROW 04 COL 01 NO-LABEL ~
                             'It:'                                              AT ROW 05 COL 01          ~
                              ttWork.cod-item                                   AT ROW 05 COL 04 FORMAT "x(14)" NO-LABEL ~
                              'Qt Lida:'                                        AT ROW 06 COL 01          ~
                              ttWork.dec-livre-1                                AT ROW 06 COL 09 FORMAT ">>>>>>>>>9" NO-LABEL ~
                              ttWork.des-endereco                               At Row 07 Col 01 NO-LABEL ~
                              'Box: '                                           At Row 08 Col 01          ~
                              ttWork.num-box-lido                               At Row 08 Col 05 No-label ~
&global-define Frame01Repeat YES

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.num-serial 
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. If vLogSai = Yes Then do: LEAVE _frame01. END. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01.

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ~
                            ON 'ESC':U OF Frame Frame01 ~
                            DO:                         ~
                                ASSIGN vlogerro = YES      ~
                                       vLogSai  = YES      ~
                                       vLogFinaliza = YES  ~
                                       vLogCancela = YES.  ~
                                Return 'NOK':U.            ~
                            END.
/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 Hbcapiwms
&global-define ActiveObject2 Hbcapi9029

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
** Esta procedure esta inicializando o campo tipo-trans da tela Frame01 com o valor 1             **
** Os outros campos nao estao sendo inicializados pois os mesmos devem apresentar valor           **
** caso seja retornado a proxima tela para esta.                                                  **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame01:
    
    ASSIGN vLogErro     = NO                               
           vLogSai      = NO                               
           vLogFinaliza = NO.              

    ASSIGN ttWork.num-serial    = 0                         
           ttWork.des-endereco  = ""
           ttWork.num-box-lido  = 0
           l-ok = NO.

    DISPLAY ttWork.num-serial  
            ttWork.cod-item    
            ttWork.des-endereco
            ttWork.num-box-lido 
            ttwork.dec-livre-1 WITH FRAME frame01.
/*
    IF NOT VALID-HANDLE(Hbosc038)  THEN DO:
       Run scbo/bosc038.p Persistent Set Hbosc038.
       Run openQueryStatic In Hbosc038 (Input "Main":U) No-error.
    END.

    if NOT valid-handle(Hbosc109) THEN DO:
        Run scbo/bosc109.p Persistent Set Hbosc109.
        Run openQueryStatic In Hbosc109 (Input "Main":U) No-error.
    END.
*/
    IF NOT VALID-HANDLE (Hbcapiwms) THEN
        RUN bcp/bcapiwms.p PERSISTENT SET Hbcapiwms.

End Procedure.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame01:
    
    ASSIGN vLogErro     = NO
           vLogSai      = NO
           vLogFinaliza = NO
           l-leitura    = NO.
        
    IF NOT VALID-HANDLE (Hbcapi9029) THEN DO:                             
        RUN bcp/bcapi9029.p PERSISTENT SET Hbcapi9029.  
    END.

    IF NOT VALID-HANDLE(Hbosc074) THEN DO:
       Run scbo/bosc074.p Persistent Set Hbosc074       No-error.
       Run openQueryStatic In Hbosc074 (Input "Main":U) No-error.
    END.

    EMPTY TEMP-TABLE rowerrors.
    EMPTY TEMP-TABLE ttwm-etiqueta.

    RUN getInfoEtiqueta IN Hbosc074 (INPUT ttwork.num-serial,
                                     OUTPUT TABLE ttwm-etiqueta).

    IF RETURN-VALUE <> "OK":U THEN DO:

        Run getrowErrors In Hbosc074 (output Table RowErrors).
        FOR EACH Rowerrors NO-LOCK:
            RUN bcp/bc9115.p  (Rowerrors.ErrorNumber, Rowerrors.ErrorDescription,8,20,3).
        END.
        RETURN ERROR.
    END.

    FIND FIRST ttwm-etiqueta NO-LOCK NO-ERROR.

    IF ttwm-etiqueta.log-reportada = NO THEN DO:
        ASSIGN VlogErro = YES.
        {bcp/bc9105.i "101" "Etiqueta nÆo reportada "}
        RETURN ERROR.
    END.

    IF CAN-FIND (FIRST tt-etiqueta-lida
                 WHERE tt-etiqueta-lida.id-etiqueta = ttwm-etiqueta.id-etiqueta) THEN DO:

        {bcp/bc9105.i "102" "Etiqueta j  foi lida."}
        ASSIGN VlogErro = YES.
        RETURN ERROR.
    END.

    FIND FIRST wm-movto-etiqueta NO-LOCK
         WHERE wm-movto-etiqueta.id-etiqueta = ttwm-etiqueta.id-etiqueta NO-ERROR.

    IF NOT AVAIL wm-movto-etiqueta THEN DO:
        {bcp/bc9105.i "103" "NÆo encontrado movimento de armazenamento para esta etiqueta."}
        
        ASSIGN VlogErro = YES.
        RETURN ERROR.
    END.

    EMPTY TEMP-TABLE tt-erro.
    EMPTY TEMP-TABLE ttWorkAux.

    CREATE ttWorkAux.
    BUFFER-COPY ttWork TO ttWorkAux.

    RUN GetSerialStorageTask IN Hbcapi9029 (INPUT-OUTPUT TABLE ttWorkAux,
                                            OUTPUT TABLE tt-erro).

    IF RETURN-VALUE <> 'OK':U THEN DO:
       FOR EACH tt-erro
           WHERE tt-erro.cd-erro <> 3
             AND tt-erro.cd-erro <> 8:
           RUN bcp/bc9115.p (tt-erro.cd-erro,tt-erro.mensagem,8,20,3).

       END.
       ASSIGN VlogErro = YES.
       RETURN ERROR.
    END.

    FIND FIRST ttWorkAux NO-ERROR.

    IF ttWork.id-movto <> ttWorkAux.id-movto 
        OR ttWork.id-movto <> wm-movto-etiqueta.id-movto THEN DO:

        {bcp/bc9105.i "104" "Tarefa de armazenamento diferente da etiqueta anterior."}

        ASSIGN VlogErro = YES.
        RETURN ERROR.
    END.
    
    FOR FIRST wm-box-movto NO-LOCK
        WHERE wm-box-movto.cod-estabel = ttWork.cod-estabel
          AND wm-box-movto.cod-local   = ttWork.cod-local
          AND wm-box-movto.id-movto    = ttWork.id-movto:

        IF (wm-box-movto.qtd-item * wm-box-movto.qti-embalagem) <> (ttwm-etiqueta.qtd-item + ttWork.dec-livre-1) THEN DO:

            IF ttWork.cod-livre-1 = "" THEN
                ASSIGN ttWork.cod-livre-1 = STRING(ttWork.num-serial).
            ELSE
                ASSIGN ttWork.cod-livre-1 = ttWork.cod-livre-1 + ";" + STRING(ttWork.num-serial).

            ASSIGN l-leitura = NO 
                   ttWork.dec-livre-1 = ttWork.dec-livre-1 + ttwm-etiqueta.qtd-item.

            DISPLAY ttWork.dec-livre-1 WITH FRAME {&Frame01Name}.
        END.
        ELSE DO:
            IF ttWork.cod-livre-1 = "" THEN
                ASSIGN ttWork.cod-livre-1 = STRING(ttWork.num-serial).
            ELSE
                ASSIGN ttWork.cod-livre-1 = ttWork.cod-livre-1 + ";" + STRING(ttWork.num-serial).
                
            ASSIGN l-leitura = YES
                   ttWork.dec-livre-1 = ttWork.dec-livre-1 + ttwm-etiqueta.qtd-item.

            DISPLAY ttWork.dec-livre-1 WITH FRAME {&Frame01Name}.
        END.

        CREATE tt-etiqueta-lida.
        ASSIGN tt-etiqueta-lida.id-etiqueta = ttwm-etiqueta.id-etiqueta
               tt-etiqueta-lida.qtd-item    = ttwm-etiqueta.qtd-item.
    END.

    IF VALID-HANDLE(Hbosc074) THEN
        DELETE OBJECT Hbosc074.

    ASSIGN vLogErro = NO.

    IF l-leitura = YES THEN DO:
    
        DO TRANSACTION ON ENDKEY UNDO, RETURN ERROR:      
            FOR EACH tt-erro:
              DELETE tt-erro.
            END.
            
            /* Pede o box */
            RUN GetAddressDescription IN Hbcapiwms (INPUT  ttWork.num-box,
                                                    INPUT  ttWork.cod-estabel,
                                                    INPUT  ttWork.cod-local,
                                                    OUTPUT ttWork.des-endereco).
    
            If  RETURN-VALUE = 'NOK':U Then Do:
                RUN bcp/bc9115.p (tt-erro.cd-erro,tt-erro.mensagem,8,20,3).
                UNDO, RETURN.
            END.
    
            ASSIGN ttWork.num-box-lido = 0.
    
            ASSIGN  ttwork.cod-item:SCREEN-VALUE IN FRAME {&Frame01Name}     = ttwork.cod-item
                    ttwork.num-serial:SCREEN-VALUE IN FRAME {&Frame01Name}   = string(ttwork.num-serial)
                    ttwork.des-endereco:SCREEN-VALUE IN FRAME {&Frame01Name} = ttwork.des-endereco.
    
           DO WHILE VlogErro = NO ON ENDKEY UNDO, RETURN ERROR:

               ASSIGN vLogSai = YES.

               UPDATE ttWork.num-box-lido NO-LABELS WITH FRAME {&Frame01Name}.
               
               IF ttWork.num-box-lido <> ttWork.num-box THEN DO:
                  {bcp/bc9105.i "105" "Endere‡o inv lido "}
                  ASSIGN vLogErro = NO.
               
               END.
               ELSE 
                   ASSIGN vLogErro = YES
                          vLogSai  = NO.
           END.
           VlogErro = NO.
        END.
    
        ASSIGN {&TempTable}.num-box-lido     = ttWork.num-box-lido
               {&TempTable}.cod-item         = ttWork.cod-item
               {&TempTable}.num-serial       = ttWork.num-serial
               {&TempTable}.cod-livre-1      = ttWork.cod-livre-1
               {&TempTable}.des-endereco     = ttWork.des-endereco
               {&TempTable}.cod-estabel      = ttWork.cod-estabel
               {&TempTable}.cod-local        = ttWork.cod-local
               {&TempTable}.num-box          = ttWork.num-box
               {&temptable}.id-docto         = ttWork.id-docto
               {&temptable}.id-movto         = ttWork.id-movto
               {&TempTable}.num-seq-item     = ttWork.num-seq-item
               {&TempTable}.horario-inicio   = ttWork.horario-inicio
               {&TempTable}.cod-usuario      = ttWork.cod-usuario 
               {&TempTable}.cod-coletor      = ttWork.cod-coletor
               {&TempTable}.cod-equipamento  = ttWork.cod-equipamento
               {&TempTable}.tipo-equipamento = ttWork.tipo-equipamento.

        ASSIGN ttWork.dec-livre-1 = 0
               ttWork.cod-livre-1 = ""
               ttWork.cod-item    = ""
               d-id-movto         = 0.
    
        RUN GravaTransacao.
        
        ASSIGN vLogSai      = YES
               vLogFinaliza = YES
               l-ok         = YES.

        RETURN "OK":U.
    END.

End Procedure.                                                                 

/*************************************************************************************************** 
** Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure      **
** _GenerateDCTransaction.                                                                        **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame04}.                       **
****************************************************************************************************/
Procedure GravaTransacao:

    ASSIGN vTransDetail = VTransaction   +
                          " Serial: "     +  STRING({&TempTable}.num-serial)     + 
                          " id-Docto: "   +  STRING({&temptable}.id-docto)       +
                          " id-Movto: "   +  STRING({&temptable}.id-movto)       +
                          " NumSeqItem: " +  STRING({&TempTable}.num-seq-item)   +
                          " Item: "       +  STRING(TRIM({&TempTable}.cod-item)) +
                          " idBox: "      +  STRING({&TempTable}.num-box).

    Run _RetornaUsuario (Output vNomeUsuario).

    Assign {&TempTable}.dat-atualizacao         = Today
           {&TempTable}.dat-transacao           = Today
           {&TempTable}.cod-usuario             = vNomeUsuario.

    Raw-transfer {&TempTable} To vConteudoRaw.

    FOR EACH tt-erro-after-GenerateDC:
        DELETE tt-erro-after-GenerateDC.
    END.
    
    Run _GenerateDCTransaction (Input vTransaction,            /* Codigo da Transacao                   */
                                Input vConteudoRaw,            /* Conteudo da temp-table {&TempTable}   */
                                Input vTransDetail,            /* Cabecalho de detalhes da transacao    */
                                Input vNomeUsuario).           /* Usuario responsavel pela transacao    */

    FIND FIRST tt-erro-after-GenerateDC NO-LOCK NO-ERROR.

    IF AVAIL tt-erro-after-GenerateDC THEN DO:
        RUN bcp/bc9115.p (tt-erro-after-GenerateDC.cd-erro,tt-erro-after-GenerateDC.mensagem,8,20,3).
        HIDE ALL.
    END.
    ELSE DO:
        RUN bcp/bc9115.p ("0", "Armazenamento efetuado com sucesso.",8,20,3).
        HIDE ALL.
    END.

End Procedure.
/*************************************  Codigo do Usuario Fim   **********************************/
&else 
    run utp/ut-msgs.p (input "show", 
                       input 28036,
                       INPUT "").
&endif

