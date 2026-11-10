/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9020M 2.00.00.014 } /*** "010014" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9020m MBC}
&ENDIF


{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9020m.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - setembro/2002 - Karen - Cria‡Æo do programa                 **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Ressuprimento WMS                **
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
**                        Ex: tt-ressup-wms.                                                      **
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
**                        Ex: &global-define ActiveObject wgBOSC074                               **
***************************************************************************************************/

/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9020
/************************************************************/

/* Definicao da temp-table de integracao ---                */

&global-define TempTable tt-ressup-wms
{bcp/bc9020.i " "}
{bcp/bc9020.i1 " "}
{bcp/bc9015.i3}  /* def variaveis padroes */

Find Last ttWork NO-ERROR.

Define Input parameter IDttwm-box          As Rowid No-undo.
Define Input parameter IDttwm-box-movto    As Rowid No-undo.
Define Input parameter IDttwm-docto-itens  As Rowid No-undo.

Define SHARED VARIABLE vLogControla       As Logical              Init No  No-undo.
Define SHARED VARIABLE vLogemProcesso-aux As Logical              Init No  No-undo.
Define SHARED VARIABLE vEsc               As Logical              Init No  No-undo.

Find ttwm-box           No-lock Where Rowid(ttwm-box)           = IDttwm-box            No-error.
Find ttwm-box-movto     No-lock Where ttwm-box-movto.r-rowid    = IDttwm-box-movto      No-error.
Find ttwm-docto-itens   No-lock Where Rowid(ttwm-docto-itens)   = IDttwm-docto-itens    No-error.

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    21 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01

&GLOBAL-DEFINE Frame01Defs  'Ressuprimento WMS   '                              AT ROW 1 COL 1                           ~
                            '           /        ':U                            AT ROW 2 COL 1                           ~
                            'Box Sai:            '                              AT ROW 4 COL 1                           ~
                            'Ser:                '                              at row 5 col 1                           ~
                            'Qtd Lida:           '                              at row 6 col 1                           ~
                            'Box Ent:            '                              at row 8 col 1                           ~
                             ttwork.cod-item                                    at row 2 col 1  No-label Format 'x(8)'   ~
                             ttwork.qtd-item                                    at row 2 col 10 No-label                 ~
                             ttwork.des-endereco                                at row 3 col 1  No-label Format 'x(18)'  ~
                             ttwork.num-box-orig                                at row 4 col 9  No-label                 ~
                             ttwork.num-serial                                  at row 5 col 5  No-label                 ~
                             ttwork.qtd-item-digit                              AT ROW 6 COL 10 NO-LABEL                 ~
                             ttwork.des-endereco-entrada                        at row 7 col 1  No-label Format 'x(18)'  ~
                             ttwork.num-box-lido                                at row 8 col 9  No-label                 ~

&global-define Frame01Repeat No
/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.num-box-lido

/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. IF RETURN-VALUE = 'OK':U THEN RETURN RETURN-VALUE.

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers  ON 'ESC':U OF Frame Frame01 ~
                             DO:                         ~
                                 ASSIGN vEsc = YES.      ~
                             END.
                             ON 'ESC':U anywhere ~
                             DO: ~
                                Run inicializaTarefaMovtoNOK In wgbosc096 (INPUT ttwm-box-movto.id-docto,       ~
                                                                           Input 04,                                ~
                                                                           Input ttWork.cod-usuario,                ~
                                                                           Input ttWork.cod-equipamento,            ~
                                                                           Input ttWork.cod-coletor,                ~
                                                                           Input ttwm-box-movto.id-movto,       ~
                                                                           Input ttwm-box-movto.num-seq-item ). ~
                             END. ~
/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
/*&global-define ActiveObject1*/
/************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/
/*****************************************   Frames Fim ******************************************/

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
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame01:
    
    IF vLogControla = YES THEN RETURN error.

    ASSIGN vEsc = NO. 

    If  Not Avail ttwm-box-movto Then Do:
        Return 'OK':U.
    End.
    
    Run getMovtoIn In wgbosc032 (Input ttwm-box-movto.cod-estabel,
                                 Input ttwm-box-movto.cod-local,
                                 Input ttwm-box-movto.id-movto,
                                 Output vNumBoxMovto).
    /* Pegar Informacoes Box */
    Run SetConstraintBoxes  In wgbosc030 (Input ttwm-box-movto.cod-estabel,
                                          Input ttwm-box-movto.cod-local,
                                          Input vNumBoxMovto,
                                          Input vNumBoxMovto).
    
    Run openQueryStatic In wgbosc030 (Input 'Boxes':U).
    
    Run getBatchRecords IN wgbosc030 (Input  ?,
                                      Input  NO,
                                      Input  ?,
                                      Output vNumCont,
                                      Output Table ttwm-box).
    
    Find First ttwm-box No-error.
    If  Not Avail ttwm-box Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "504" "Box Movto Invalido. (WMS)"}
        Return Error.
    End.
    
   If ttWork.num-serial = 0 Then /* Se for via item x quantidade, atribuir a quantidade lida no zoom de saldos */
       assign ttWork.qtd-item-digit = ttWork.qtd-item * ttWork.qtd-embal-lidas.

   Assign ttWork.cod-item       :Screen-value In Frame {&Frame01Name} = ttwm-docto-itens.cod-item
          ttWork.qtd-item       :Screen-value In Frame {&Frame01Name} = String(ttwm-box-movto.qtd-item * ttwm-box-movto.qti-embalagem)
          ttWork.des-endereco   :Screen-value In Frame {&Frame01Name} = v-des-endereco-entrada
          ttWork.qtd-item-digit :Screen-value In FRAME {&Frame01Name} = String(ttWork.qtd-item-digit)  
          ttWork.num-box-orig   :Screen-value In Frame {&Frame01Name} = String(ttWork.num-box-orig)
          ttWork.num-serial     :Screen-value In Frame {&Frame01Name} = String(ttWork.num-serial)  
          ttWork.des-endereco-entrada:SCREEN-VALUE IN FRAME {&Frame01Name} = ttwm-box.cod-bloco  + '/':U + 
                                                                             ttwm-box.cod-rua    + '/':U + 
                                                                             ttwm-box.cod-nivel  + '/':U + 
                                                                             ttwm-box.cod-coluna + '/':U +
                                                                     If ttwm-box.ind-posicao-box = 1 Then 'E' Else 'D'
          ttWork.num-box-lido   :Screen-value In Frame {&Frame01Name} = '0'.

    Assign ttWork.num-box-lido = 0.
End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 05.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame01:

    If  ttWork.num-box-lido = 0 Then Do:
        {bcp/bc9105.i "505" "Box Invalido. (DC)"}
        Return Error.
    End.
    
    /* Valida Box */
    Run SetConstraintBoxes  In wgbosc030 (Input ttwm-box-movto.cod-estabel,
                                          Input ttwm-box-movto.cod-local,
                                          Input ttWork.num-box-lido,
                                          Input ttWork.num-box-lido).
    
    Run openQueryStatic In wgbosc030 (Input 'Boxes':U).
    
    RUN getBatchRecords IN wgbosc030 (Input   ?,
                                      Input  NO,
                                      Input  ?,
                                      Output vNumCont,
                                      Output Table ttwm-box).
    Find First ttwm-box No-error.
    If  Not Available ttwm-box Then do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "505" "Box Invalido. (WMS)"}
        Return Error.
    End. /* If  Return-value <> 'OK' Then do: */
    
    Run getMovtoIn In wgbosc032 (Input ttwm-box-movto.cod-estabel,
                                 Input ttwm-box-movto.cod-local,
                                 Input ttwm-box-movto.id-movto,
                                 Output vNumBoxMovto).
    
    If  Return-value <> 'OK' Or 
        vNumBoxMovto <> ttWork.num-box-lido Then Do:
         Assign vLogErro = Yes.
        {bcp/bc9105.i "506" "Box Invalido. (DC)"}
        Return Error.
    End.
    
    Run GravaTransacao.
    RETURN RETURN-VALUE.
End Procedure.

/*************************************************************************************************** 
** Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure      **
** _GenerateDCTransaction.                                                                        **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaTransacao:
    Def Var vNomeUsuario            As Character                No-undo.
    Def Var de-cdd-id-etiq          As Decimal                  No-undo.
    
    Assign vTransDetail = ' Usr: ' + String(ttWork.cod-usuario)                      +   
                          ' Col: ' + String(ttWork.cod-coletor)                      +
                          ' Eqp: ' + String(ttWork.cod-equipamento)                  +
                          ' Doc: ' + String(ttWork.num-documento)                    +
                          ' Ser: ' + String(ttWork.num-serial,'999999999999999':U)   +
                          ' Dat: ' + String(Today,'99/99/9999':U)                    +
                          ' Hor: ' + String(time,'hh:mm:ss':U).

    Assign vNomeUsuario = ttWork.cod-usuario.

    Raw-transfer ttWork To vConteudoRaw.

    Run _GenerateDCTransaction (Input vTransaction,            /* Codigo da Transacao                   */
                                Input vConteudoRaw,            /* Conteudo da temp-table ttWork         */
                                Input vTransDetail,            /* Cabecalho de detalhes da transacao    */
                                Input vNomeUsuario).           /* Usuario responsavel pela transacao    */ 
    
    If  Return-value <> 'NOK':U Then Do:
        ASSIGN vLogControla       = YES
               vLogEmProcesso-aux = YES.

        RUN valEndMaxRessup IN wgbosc032( INPUT ttwm-box-movto.cod-estabel,
                                          INPUT ttwm-box-movto.cod-local,
                                          INPUT ttwm-box-movto.id-movto).
        IF RETURN-VALUE = "OK":U THEN DO:
           RUN returnEtiqMovtoDestino IN wgbosc172(INPUT ttwm-box-movto.cod-estabel,
                                                   INPUT ttwm-box-movto.cod-local,
                                                   INPUT ttwm-box-movto.id-docto,
                                                   INPUT ttwm-box-movto.num-seq-item,
                                                   INPUT ttwm-box-movto.id-movto,
                                                   OUTPUT de-cdd-id-etiq).
           IF RETURN-VALUE = "OK":U
              AND de-cdd-id-etiq > 0
              AND NOT CAN-FIND( FIRST ttWork
                                WHERE ttWork.num-serial = de-cdd-id-etiq) THEN DO:
               RUN utp/ut-msgs.p (INPUT "help",
                                  INPUT 57300,
                                  INPUT STRING(de-cdd-id-etiq)).
               &global-define ErrorDisplaySeconds 20
               {bcp/bc9015.i2 STRING(57300) RETURN-VALUE}
               &global-define ErrorDisplaySeconds 3
           END.           
        END.
        ELSE DO:
           &global-define ErrorDisplaySeconds 20
           {bcp/bc9105.i1 "901" "Ressuprimento OK"}
           &global-define ErrorDisplaySeconds 3
        END.
        RETURN 'OK':U.
    END.
    else do:
        Run inicializaTarefaMovtoNOK In wgbosc096 (INPUT ttwm-box-movto.id-docto,       
                                                   Input 04,                            
                                                   Input ttWork.cod-usuario,            
                                                   Input ttWork.cod-equipamento,        
                                                   Input ttWork.cod-coletor,            
                                                   Input ttwm-box-movto.id-movto,       
                                                   Input ttwm-box-movto.num-seq-item ). 
    End.
    Assign vLogFinaliza = No
           vLogSai      = No.
    Return 'NOK':U.
End Procedure.
/*************************************  Codigo do Usuario Fim   **********************************/
&else 
    run utp/ut-msgs.p (input "show", 
                       input 28036,
                       INPUT "").
&endif
