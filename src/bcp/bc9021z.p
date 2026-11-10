/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9021Z 2.00.00.034 } /*** "010034" 12/12/2023 15:27:53 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9021z MBC}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i_dbinst.i}  /* versao das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9021z.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - fevereiro/2003 - karla Klemke - Cria‡Æo do programa         **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Devolu‡Æo de Picking             **
**                                                                                         **
********************************************************************************************/
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
**                        Ex: &global-define ActiveObject wgbosc074                               **
***************************************************************************************************/

/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9021
/************************************************************/

/* Definicao da temp-table de integracao ---                */

&global-define TempTable tt-devolve-picking
{bcp/bc9021.i}
{bcp/bc9018h.i} /*fk - definicao das procedures utilizadas para controle ean/dun */

DEFINE TEMP-TABLE tt-itens NO-UNDO
            FIELD cod-item    LIKE wm-docto-itens.cod-item
            FIELD cod-lote    LIKE wm-docto-itens.cod-lote
            FIELD cod-refer   LIKE wm-docto-itens.cod-refer
            FIELD dt-validade LIKE wm-docto-itens.dt-validade
            FIELD qtd-item    LIKE wm-docto-itens.qtd-item.

DEFINE TEMP-TABLE tt-devol-picking NO-UNDO
            FIELD cod-estabel        LIKE wm-box-movto.cod-estabel 
            FIELD cod-local          LIKE wm-box-movto.cod-local
            FIELD cod-item           LIKE wm-box-movto.cod-item
            FIELD cod-refer          LIKE wm-box-movto.cod-refer
            FIELD cod-lote           LIKE wm-box-movto.cod-lote
            FIELD cod-embalagem      LIKE wm-box-movto.cod-embalagem
            FIELD qtd-item           LIKE wm-box-movto.qtd-item
            FIELD qtd-devol          LIKE wm-box-movto.qtd-devol
            FIELD qtd-a-devolver     LIKE wm-box-movto.qtd-devol LABEL "Qtd a Devolver"
            FIELD num-seq-item       LIKE wm-box-movto.num-seq-item
            FIELD rownum             AS INTEGER
            FIELD r-rowid            AS ROWID
            FIELD nr-entrega         LIKE wm-docto-itens-ped.nr-entrega
            FIELD cdd-embarq         LIKE wm-docto-itens-ped.cdd-embarq
            FIELD nr-resumo          LIKE wm-docto-itens-ped.nr-resumo
            FIELD nr-pedcli          LIKE wm-docto-itens-ped.nr-pedcli
            INDEX codigo cod-estabel
                         cod-local
                         nr-pedcli
                         num-seq-item
                         cod-item
                         cod-refer
                         cod-lote
                         cod-embalagem
                         nr-entrega. 

DEFINE TEMP-TABLE tt-devol-picking-bkp NO-UNDO LIKE tt-devol-picking.

DEF VAR de-qtd-item-devol     LIKE wm-docto-itens-devol.qtd-item NO-UNDO.
DEF VAR de-qtd-item-pick      LIKE wm-docto-itens-devol.qtd-item NO-UNDO.
DEF VAR l-primeira-vez        AS LOGICAL                         NO-UNDO.

DEFINE TEMP-TABLE ttwm-pedidos NO-UNDO LIKE wm-pedidos
            FIELD rownum AS INTEGER INIT 1
            FIELD r-rowid AS ROWID.

DEFINE QUERY qry-devol-picking FOR tt-devol-picking.

DEFINE BROWSE brw-devol-picking QUERY qry-devol-picking NO-LOCK
   DISPLAY tt-devol-picking.cod-item    
           tt-devol-picking.nr-entrega
           tt-devol-picking.cod-refer
           tt-devol-picking.cod-lote
           tt-devol-picking.qtd-item
           tt-devol-picking.nr-pedcli
      WITH NO-BOX NO-LABELS SIZE 18 BY 4.5 NO-SCROLLBAR-VERTICAL.

DEFINE VARIABLE wgbosc032   AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE i-registros AS INTEGER NO-UNDO.

DEFINE NEW GLOBAL SHARED VAR iIndTipoLeitura            AS INTEGER            NO-UNDO. 
DEFINE NEW GLOBAL SHARED VAR v_log_control_lista_tarefa AS LOGICAL INITIAL NO NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR iIndTipoVisualiza          AS INTEGER            NO-UNDO.

DEFINE NEW SHARED VARIABLE wgbosc145 AS WIDGET-HANDLE NO-UNDO. 

DEFINE VARIABLE iLogHabilitaUn AS LOGICAL     NO-UNDO.
DEFINE VARIABLE p-qtd-item     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE h-bosc044      AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bosc109      AS HANDLE      NO-UNDO.

{scbo/bosc145.i ttWm-item-embalagem-local}

DEFINE TEMP-TABLE ttWork NO-UNDO LIKE {&TempTable}.

DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttWork.
DEFINE OUTPUT PARAMETER l-erro-qtd-picking AS LOGICAL INITIAL NO          NO-UNDO.
DEFINE OUTPUT PARAMETER p-num-seq-item     LIKE wm-box-movto.num-seq-item NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-devol-picking. 

FIND FIRST ttWork NO-ERROR.

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs  'Devolu‡Æo Pick. WMS '   At Row 01 Col 01  ~
                            '--------------------'   At Row 02 Col 01  ~
                            brw-devol-picking          AT Row 03 Col 01  ~
&global-define Frame01Repeat NO

/* Definicao da Frame02 ---                             */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Devolu‡Æo Pick. WMS '    At Row 01 Col 01           ~
                             'Item:'                   AT ROW 02 COL 01           ~
                             ttWork.cod-item           At Row 03 Col 01 No-label  ~
                             'Lt:'                     At Row 04 Col 01           ~
                             ttWork.cod-lote           At Row 04 Col 04 NO-LABEL FORMAT "x(40)"  VIEW-AS FILL-IN SIZE 11 BY 0.88 ~
                             'Ref:'                    At Row 05 Col 01           ~
                             ttWork.cod-refer          AT ROW 05 COL 05 NO-LABEL  ~
                             'Val:'                    AT ROW 06 COL 01           ~
                             ttWork.dat-validade       AT ROW 06 COL 05 NO-LABEL  ~
                             'Quantidade:        '     AT ROW 07 COL 01           ~
                             ttWork.qtd-item           at row 08 col 01 no-label  ~
                             
&global-define Frame02Repeat NO

/* FK INICIO - projeto parati ********************************************************************/
/* Definicao da Frame03 ---                                 */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Devolu‡Æo Pick. WMS '                            At Row 01 Col 01                         ~
                             'Tipo leitura?      '                             At Row 02 Col 01                         ~
                             '2 - Por quantidade '                             At Row 03 Col 01                         ~
                             '3 - Por EAN/DUN    '                             At Row 04 Col 01                         ~
                             '4 - Por Emb/Un     '                             AT ROW 05 COL 01                         ~
                             'Opcao              '                             At Row 08 Col 01                         ~
                             iIndTipoLeitura                                   At Row 08 Col 14 No-label Format '9'
                             
&global-define Frame03Repeat NO .

/* Definicao da Frame04 ---                             */
&global-define Frame04Name   Frame04
&global-define Frame04Defs   'Devolu‡Æo Pick. WMS '    At Row 01 Col 01           ~
                             'Item:'                   AT ROW 02 COL 01           ~
                             ttWork.cod-item           At Row 03 Col 01 No-label  ~
                             'Lt:'                     At Row 04 Col 01           ~
                             ttWork.cod-lote           At Row 04 Col 04 NO-LABEL FORMAT "x(40)" VIEW-AS FILL-IN SIZE 11 BY 0.88 ~
                             'Ref:'                    At Row 05 Col 01           ~
                             ttWork.cod-refer          AT ROW 05 COL 05 NO-LABEL  ~
                             'Val:'                    AT ROW 06 COL 01           ~
                             ttWork.dat-validade       AT ROW 06 COL 05 NO-LABEL  ~
                             'CB:'                     AT ROW 07 COL 01           ~
                             ttWork.cod-livre-1        At Row 07 Col 04 No-label Format 'x(15)'  ~
                             'Qtd:'                    AT ROW 08 COL 01           ~
                             ttWork.qtd-item           AT ROW 08 COL 05 NO-LABEL FORMAT ">>>>>>>>9" ~
                             
&global-define Frame04Repeat YES

/* FK FIM - projeto parati **********************************************************************/
/* mk *******************************************************************************************/

/* Definicao da Frame05 ---                             */
&global-define Frame05Name   Frame05
&global-define Frame05Defs   'Devolu‡Æo Pick. WMS '    At Row 01 Col 01           ~
                             'Item:'                   AT ROW 02 COL 01           ~
                             ttWork.cod-item           At Row 03 Col 01 No-label  ~
                             'Lt:'                     At Row 04 Col 01           ~
                             ttWork.cod-lote           At Row 04 Col 04 NO-LABEL FORMAT "x(40)" VIEW-AS FILL-IN SIZE 11 BY 0.88 ~
                             'Ref:'                    At Row 05 Col 01           ~
                             ttWork.cod-refer          AT ROW 05 COL 05 NO-LABEL  ~
                             'Val:'                    AT ROW 06 COL 01           ~
                             ttWork.dat-validade       AT ROW 06 COL 05 NO-LABEL  ~
                             'Quantidade:'             AT ROW 07 COL 01           ~
                             'Emb:'                    AT ROW 08 COL 01           ~
                             ttWork.cod-livre-1        At Row 08 Col 05 No-label Format "x(4)" ~
                             'Un:'                     AT ROW 08 COL 11           ~
                             ttWork.cod-livre-2        AT ROW 08 COL 15 NO-LABEL FORMAT "x(4)" ~
                             
&global-define Frame05Repeat YES


/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields brw-devol-picking
/*&global-define Update02Fields ttWork.qtd-item*/ /*fk comentado*/
                                  
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. If vLogFinaliza = Yes Then do: LEAVE _frame01. END.
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02. 
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. IF vLogFinaliza = YES THEN LEAVE _frame02.
&global-define TriggerAfterFrame04  If return-value = "ESC":U then return return-value. ~

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ~
                            ON 'Return':U OF brw-devol-picking In Frame {&Frame01Name}        ~
                            DO:                                                             ~
                                   Apply 'Go' To This-procedure.                            ~
                            END.                                                            ~
                            ON 'ESC':U OF Frame Frame01 ~
                            DO:                         ~
                                RETURN 'ESC':U.         ~
                            END.                        ~
                            ON 'ESC':U OF Frame Frame02 ~
                            DO:                         ~
                                RETURN 'ESC':U.         ~
                            END.                        ~
                            ON 'END-ERROR':U OF iIndTipoLeitura IN FRAME frame03 ~
                            DO:                                                  ~
                                    RETURN NO-APPLY.                             ~
                            END.                                                 ~
                            ON 'ESC':U OF ttwork.cod-livre-1 IN FRAME frame04 ~
                            DO:                         ~
                                RETURN 'ESC'.           ~
                            END.                        ~
                            ON 'END-ERROR':U OF ttwork.cod-livre-1 IN FRAME frame04 ~
                            DO:                                                  ~
                                    RETURN NO-APPLY.                             ~
                            END.                                                 ~
                            ON 'ESC':U OF ttwork.cod-livre-1 IN FRAME frame05 ~
                            DO:                         ~
                                RETURN 'ESC'.           ~
                            END.                        ~
                            ON 'END-ERROR':U OF ttwork.cod-livre-1 IN FRAME frame05 ~
                            DO:                                                  ~
                                    RETURN NO-APPLY.                             ~
                            END.                                                 ~

/************************************************************/
/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgbosc032
/************************************************************/

/*****************************************   Frames Fim ******************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/

/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */

/**************************************************************************************************/

/************************************* Codigo do Usuario Inicio ************************************
** Este local ‚ destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame01:
/*------------------------------------------------------------------------------
  Purpose: Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
   IF RETURN-VALUE = 'ESC':U THEN DO:
      ASSIGN vlogfinaliza = YES.
      RETURN.
   END.
   
   EMPTY TEMP-TABLE tt-devol-picking.
   EMPTY TEMP-TABLE tt-devol-picking-bkp.
   
   ASSIGN vLogErro     = NO
          vLogsai      = NO
          vLogfinaliza = NO.
   
   ASSIGN ttWork.cod-item         = '' 
          ttWork.cod-lote         = ''
          ttWork.cod-refer        = ''
          ttWork.dat-validade     = ? 
          ttWork.qtd-item         = 0
          ttWork.nr-resumo        = 0
          ttWork.nr-pedcli        = ''
          ttWork.nome-abrev       = '' 
          ttWork.num-seq-item-ped = 0.
   
   IF RETURN-VALUE = 'ESC' THEN
      RETURN.
   
   IF NOT VALID-HANDLE(wgbosc032) THEN DO:
      RUN scbo/bosc032.p PERSISTENT SET wgbosc032.
      RUN openQueryStatic IN wgbosc032 (INPUT "Main":U) NO-ERROR.
   END.
   
   IF NOT VALID-HANDLE(h-bosc109) THEN
      RUN scbo/bosc109.p PERSISTENT SET h-bosc109.
   
   RUN setConstraintFaixa IN h-bosc109 (INPUT ttWork.cod-estabel,         
                                        INPUT ttWork.cod-estabel,         
                                        INPUT ttWork.cod-local,           
                                        INPUT ttWork.cod-local,           
                                        INPUT "",                         
                                        INPUT "zzzzzzzzz",                
                                        INPUT "",                         
                                        INPUT "zzzzzzzzz",                
                                        INPUT ttWork.cdd-embarq,         
                                        INPUT ttWork.cdd-embarq,         
                                        INPUT 0,                          
                                        INPUT 99999999).           
   
   RUN openQueryStatic IN h-bosc109 (INPUT "Faixa2":U) NO-ERROR.
   
   RUN getbatchRecords IN h-bosc109 (INPUT ?,
                                     INPUT NO,
                                     INPUT ? ,
                                     OUTPUT i-registros,
                                     OUTPUT TABLE ttwm-pedidos).
   
   FOR EACH ttwm-pedidos:
      RUN getMovtoDevolPickingNew IN wgbosc032 (INPUT ttWork.cod-estabel,
                                                INPUT ttWork.cod-local,
                                                INPUT ttWork.cdd-embarq,
                                                INPUT ttwm-pedidos.nr-resumo,
                                                INPUT ttwm-pedidos.nr-pedcli,
                                                INPUT ttwm-pedidos.nome-abrev,
                                                OUTPUT TABLE tt-devol-picking-bkp).
   
   
      FOR EACH tt-devol-picking-bkp
         WHERE tt-devol-picking-bkp.cod-estabel = ttwm-pedidos.cod-estabel
           AND tt-devol-picking-bkp.cod-local   = ttwm-pedidos.cod-local
           AND tt-devol-picking-bkp.nr-pedcli   = ttwm-pedidos.nr-pedcli:
   
         IF tt-devol-picking-bkp.qtd-item = tt-devol-picking-bkp.qtd-devol THEN DO:
            DELETE tt-devol-picking-bkp.
            NEXT.
         END.
         ASSIGN tt-devol-picking-bkp.qtd-item = tt-devol-picking-bkp.qtd-item - tt-devol-picking-bkp.qtd-devol.
   
         FIND FIRST tt-devol-picking 
              WHERE tt-devol-picking.cod-estabel   = tt-devol-picking-bkp.cod-estabel
                AND tt-devol-picking.cod-local     = tt-devol-picking-bkp.cod-local  
                AND tt-devol-picking.nr-pedcli     = tt-devol-picking-bkp.nr-pedcli  
                AND tt-devol-picking.num-seq-item  = tt-devol-picking-bkp.num-seq-item  
                AND tt-devol-picking.cod-item      = tt-devol-picking-bkp.cod-item      
                AND tt-devol-picking.cod-refer     = tt-devol-picking-bkp.cod-refer     
                AND tt-devol-picking.cod-lote      = tt-devol-picking-bkp.cod-lote      
                AND tt-devol-picking.cod-embalagem = tt-devol-picking-bkp.cod-embalagem  
                AND tt-devol-picking.cdd-embarq    = tt-devol-picking-bkp.cdd-embarq
                AND tt-devol-picking.nr-resumo     = tt-devol-picking-bkp.nr-resumo NO-LOCK NO-ERROR.   
         IF NOT AVAIL tt-devol-picking THEN DO:
            CREATE tt-devol-picking.
            BUFFER-COPY tt-devol-picking-bkp EXCEPT r-rowid qtd-devol TO tt-devol-picking 
            ASSIGN tt-devol-picking.r-rowid   = ROWID(ttwm-pedidos)
                   tt-devol-picking.qtd-devol = 0.    
         END.
      END.
   END.
   
   FIND FIRST tt-devol-picking NO-LOCK NO-ERROR.   
   IF NOT AVAIL tt-devol-picking THEN DO:
      CREATE tt-devol-picking.
      ASSIGN tt-devol-picking.cod-item = 'Tarefa Inexistente (WMS)'
             v_log_control_lista_tarefa = YES.
   END.
   OPEN QUERY qry-devol-picking
     FOR EACH tt-devol-picking
           BY tt-devol-picking.cod-item.
           
   IF VALID-HANDLE (h-bosc109) THEN
      DELETE OBJECT h-bosc109.
END PROCEDURE.

PROCEDURE InicializaCamposFrame02:
/*------------------------------------------------------------------------------
  Purpose: Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
   IF RETURN-VALUE = 'ESC':U THEN DO:
      ASSIGN vlogfinaliza = YES.
      RETURN.
   END.
   
   ASSIGN vLogErro     = NO
          vLogsai      = NO
          vLogfinaliza = NO.  
   
   ASSIGN ttWork.qtd-item = tt-devol-picking.qtd-item.
   
   DISPLAY ttWork.cod-item
           ttWork.cod-lote
           ttWork.cod-refer
           ttWork.dat-validade
           ttWork.qtd-item
      WITH FRAME frame02.
   
   /* Identifica o tipo de leitura a ser feita (1:pede em tela, 2:por qtd, 3:por ean/dun) */
   RUN pi-getTipoLeitura IN THIS-PROCEDURE.
   
   /* Verifica qual o tipo de visualiza‡Æo do campo quantidade (2: Quantidade, 4: Emb~\Un) */
   RUN pi-getIndTipoVisualiza IN THIS-PROCEDURE.
   
   /* Se for por codigo ean/dun, chama outra procedure */
   IF iIndTipoLeitura = 3 THEN DO:
      /* Pega a qtd pelas etiquetas ean-dun lidas */
      RUN getInfoCodigoEanDun IN THIS-PROCEDURE.
   END.
   ELSE IF iIndTipoLeitura = 4 THEN DO:
      /* Usuario informa Emb~\Un (Obs: Un se parametrizado para Habilitar Unidades) */
      RUN getInfoEmbUn IN THIS-PROCEDURE.
   END.
   ELSE
      UPDATE ttwork.qtd-item  WITH FRAME frame02.
END PROCEDURE.

PROCEDURE GravaCamposFrame01:
/*------------------------------------------------------------------------------
  Purpose: Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
   IF RETURN-VALUE = 'ESC' THEN
      RETURN.
   
   ASSIGN vLogErro     = NO
          vLogSai      = NO 
          vLogFinaliza = NO.
   
   IF NOT AVAIL tt-devol-picking
      OR tt-devol-picking.cod-item = 'Item Inexistente (WMS)'
      OR tt-devol-picking.cod-item = 'Tarefa Inexistente (WMS)' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "301" "Movimento Inv lido. (WMS)"}
      RETURN ERROR.
   END.

   FIND ttwm-pedidos WHERE ROWID(ttwm-pedidos) = tt-devol-picking.r-rowid no-error.

   ASSIGN ttWork.cod-item         = tt-devol-picking.cod-item
          ttWork.cod-lote         = tt-devol-picking.cod-lote
          ttWork.cod-refer        = tt-devol-picking.cod-refer
          ttWork.qtd-item         = INPUT FRAME Frame02 ttWork.qtd-item
          ttWork.nome-abrev       = ttwm-pedidos.nome-abrev       
          ttWork.nr-pedcli        = ttwm-pedidos.nr-pedcli
          ttWork.nr-resumo        = ttwm-pedidos.nr-resumo  
          ttWork.num-seq-item-ped = tt-devol-picking.num-seq-item. 
   
   IF NOT VALID-HANDLE(h-bosc044) THEN DO:
      RUN scbo/bosc044.p PERSISTENT SET h-bosc044.
      RUN openQueryStatic IN h-bosc044 (INPUT "Main":U) NO-ERROR.
   END.
   RUN emptyRowErrors IN h-bosc044.
   
   RUN getTipoControle IN h-bosc044 (INPUT ttWork.cod-item, 
                                     OUTPUT ttWork.ind-tipo-contr-est).

   IF ttWork.ind-tipo-contr-est = 2 THEN DO:
      /* controle de estoque do item por serie */
      ASSIGN ttWork.qtd-item = 1
             vLogSai         = YES
             vLogFinaliza    = YES.
   END.
   IF VALID-HANDLE (h-bosc044) THEN
      DELETE OBJECT h-bosc044.
         
   RETURN 'OK':U.
END PROCEDURE.

Procedure GravaCamposFrame02:
/*------------------------------------------------------------------------------
  Purpose: Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
   IF RETURN-VALUE = 'ESC' THEN DO:
       ASSIGN vLogSai             = YES 
              ttWork.cod-item     = ''
              ttWork.cod-lote     = '' 
              ttWork.cod-refer    = '' 
              ttWork.dat-validade = ?  
              ttWork.qtd-item     = 0
              l-primeira-vez      = NO. 
       RETURN.
   END.
   
   ASSIGN vLogErro     = NO
          vLogSai      = No 
          vLogFinaliza = NO.
   
   IF ttWork.qtd-item = 0 THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "302" "Quantidade Inv lida. (DC)"}
      RETURN ERROR.
   END.

   /* verifica se o item selecionado est  com o movimento conclu¡do,
      se nÆo estiver conclu¡do, a vari vel de-qtd-item-devol ser  maior
      que de-qtd-item-pick e ocorrer  erro, pois de-qtd-item-pick ser  0 */
   FIND FIRST wm-docto
        WHERE wm-docto.nr-embarque       = 0
          AND wm-docto.cdd-embarq        = ttWork.cdd-embarq
          AND wm-docto.nr-resumo         = ttwm-pedidos.nr-resumo     
          AND wm-docto.nr-pedcli         = ttwm-pedidos.nr-pedcli     
          AND wm-docto.nome-abrev        = ttwm-pedidos.nome-abrev
          AND (wm-docto.ind-origem-docto = 4
           OR wm-docto.ind-origem-docto  = 9) NO-LOCK NO-ERROR.
   IF AVAIL wm-docto THEN DO:
      FIND FIRST wm-docto-itens
           WHERE wm-docto-itens.cod-local   = wm-docto.cod-local 
            AND  wm-docto-itens.cod-estabel = wm-docto.cod-estabel
            AND  wm-docto-itens.id-docto    = wm-docto.id-docto NO-LOCK NO-ERROR.      
      IF AVAIL wm-docto-itens THEN DO:
         ASSIGN de-qtd-item-devol = tt-devol-picking.qtd-a-devolver + ttWork.qtd-item
                de-qtd-item-pick  = 0
                p-num-seq-item    = tt-devol-picking.nr-entrega. 
      
         FOR EACH wm-docto-itens-ped  
            WHERE wm-docto-itens-ped.nr-embarque      = 0
              AND wm-docto-itens-ped.cdd-embarq       = Wm-docto.cdd-embarq
              AND wm-docto-itens-ped.nr-resumo        = Wm-docto.nr-resumo   
              AND wm-docto-itens-ped.nr-pedcli        = Wm-docto.nr-pedcli   
              AND wm-docto-itens-ped.nome-abrev       = Wm-docto.nome-abrev  
              AND wm-docto-itens-ped.num-seq-item-ped = tt-devol-picking.num-seq-item
              AND wm-docto-itens-ped.num-seq-item     = tt-devol-picking.nr-entrega
              AND wm-docto-itens-ped.log-devol-cancel = NO NO-LOCK: 
      
            /* ir  verificar se a quantidade digitada ‚ maior que a quantidade do item no documento de sa¡da */
            FOR EACH wm-box-movto 
               WHERE wm-box-movto.cod-estabel      = wm-docto-itens-ped.cod-estabel 
                 AND wm-box-movto.cod-local        = wm-docto-itens-ped.cod-local   
                 AND wm-box-movto.id-docto         = wm-docto-itens-ped.id-docto    
                 AND wm-box-movto.num-seq-item     = wm-docto-itens-ped.num-seq-item
                 AND wm-box-movto.ind-tipo-movto   = 2                              
                 AND wm-box-movto.ind-status-movto = 3 NO-LOCK :
      
               IF CAN-FIND(FIRST wm-box-movto-lote 
                           WHERE wm-box-movto-lote.cod-estabel = wm-box-movto.cod-estabel 
                             AND wm-box-movto-lote.cod-local   = wm-box-movto.cod-local   
                             AND wm-box-movto-lote.id-movto    = wm-box-movto.id-movto    
                             AND wm-box-movto-lote.cod-cliente = wm-box-movto.cod-cliente 
                             AND wm-box-movto-lote.cod-item    = wm-box-movto.cod-item    
                             AND wm-box-movto-lote.cod-refer   = wm-box-movto.cod-refer) THEN DO:
                  FOR EACH wm-box-movto-lote 
                     WHERE wm-box-movto-lote.cod-estabel = wm-box-movto.cod-estabel 
                       AND wm-box-movto-lote.cod-local   = wm-box-movto.cod-local   
                       AND wm-box-movto-lote.id-movto    = wm-box-movto.id-movto    
                       AND wm-box-movto-lote.cod-cliente = wm-box-movto.cod-cliente 
                       AND wm-box-movto-lote.cod-item    = wm-box-movto.cod-item    
                       AND wm-box-movto-lote.cod-refer   = wm-box-movto.cod-refer   
                       AND wm-box-movto-lote.cod-lote    = tt-devol-picking.cod-lote NO-LOCK:
      
                     ASSIGN de-qtd-item-pick = de-qtd-item-pick + wm-box-movto-lote.qtd-item.
                  END.  
               END.
               ELSE DO:
                  IF wm-box-movto.cod-lote <> tt-devol-picking.cod-lote THEN
                     NEXT.
                  
                  ASSIGN de-qtd-item-pick = de-qtd-item-pick + (wm-box-movto.qtd-item * wm-box-movto.qti-embalagem).
               END.
            END.
      
            /* se j  existe um documento de devolu‡Æo criado com uma quantidade parcial do item,
               ele verifica este documento, e a quantidade devolvida, sera o
               armazenado na variaval + o que ja foi devolvido +  o digitado em tela */
            IF l-primeira-vez = NO THEN DO:
               FOR EACH wm-docto-itens-devol 
                  WHERE wm-docto-itens-devol.cod-estabel      = wm-docto-itens-ped.cod-estabel 
                    AND wm-docto-itens-devol.cod-local        = wm-docto-itens-ped.cod-local   
                    AND wm-docto-itens-devol.nr-embarque      = 0
                    AND wm-docto-itens-devol.cdd-embarq       = wm-docto.cdd-embarq
                    AND wm-docto-itens-devol.nr-resumo        = wm-docto.nr-resumo             
                    AND wm-docto-itens-devol.nr-pedcli        = wm-docto.nr-pedcli             
                    AND wm-docto-itens-devol.nome-abrev       = wm-docto.nome-abrev            
                    AND wm-docto-itens-devol.num-seq-item-ped = tt-devol-picking.num-seq-item 
                    AND wm-docto-itens-devol.cod-item         = wm-docto-itens-ped.cod-item
                    AND wm-docto-itens-devol.cod-refer        = wm-docto-itens-ped.cod-refer
                    AND wm-docto-itens-devol.cod-lote         = wm-docto-itens-ped.cod-lote NO-LOCK:

                  ASSIGN de-qtd-item-devol = de-qtd-item-devol + wm-docto-itens-devol.qtd-item.
               END.
            END.
         END.    
      END.
   END.

   /* se o valor digitado em tela for maior do que o valor do item no documento de sa¡da do wms,
      ou se o item deste documeto, nÆo tiver a aloca‡Æo do saldo conclu¡da ir  gerar erro */
   IF de-qtd-item-devol > de-qtd-item-pick THEN DO:   
      ASSIGN vLogErro           = YES
             l-erro-qtd-picking = YES.
      {bcp/bc9105.i "304" "Quantidade a devolver nÆo pode ser superior a movimenta‡Æo.(DC)"}
      RETURN ERROR.
   END.
   ELSE
      ASSIGN l-erro-qtd-picking = NO.
   
   ASSIGN vLogSai      = YES
          vLogFinaliza = YES.
   
   RETURN 'OK':U.
END PROCEDURE.

PROCEDURE pi-getTipoLeitura:
/*------------------------------------------------------------------------------
  Purpose: Busca o parametro da bc-param-ext conforme o tipo de endereco (BC9018h.i)    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
   RUN pi-getValorParametro (ttWork.cod-item,
                             "wmsai004",
                             ("LEIT-QTD-DEVOL-PICK"),
                             OUTPUT iIndTipoLeitura).
   
   /* Se nÆo achar o parametro, assume o valor 2 */
   IF iIndTipoLeitura = 0 THEN DO:
      {bcp/bc9105.i "104" "Parametros nao foram inicializados (DC)"}
      ASSIGN iIndTipoLeitura = 2.
   END.
   
   /* Caso o parametro seja informado incorretamente, informa ao usuario */
   IF iIndTipoLeitura < 0 OR iIndTipoLeitura > 4  THEN DO:
      {bcp/bc9105.i "104" "Valor do parametro incorreto para o item/familia/transacao (DC)"}
      ASSIGN iIndTipoLeitura = 2.
   END.
   
   /* Se o tipo de leitura for igual a 1, pede em tela */
   HIDE ALL NO-PAUSE.
   IF iIndTipoLeitura = 1 THEN DO:
      REPEAT:
         UPDATE iIndTipoLeitura WITH FRAME Frame03.
      
         /* S¢ aceita valores 2 e 3 digitados em tela */
         IF iIndTipoLeitura = 2 OR iIndTipoLeitura = 3 OR iIndTipoLeitura = 4 THEN
            LEAVE.
      END.
   END.
END PROCEDURE.

PROCEDURE pi-getIndTipoVisualiza:
/*------------------------------------------------------------------------------
  Purpose: Verifica tipo de visualiza‡Æo    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
   RUN pi-getValorParametro (ttWork.cod-item,
                             "wmsai004",
                             "DISP-QTDE",
                             OUTPUT iIndTipoVisualiza).
   
   /* Se nÆo achar o parametro, assume o valor 2 */
   IF iIndTipoVisualiza = 0 THEN DO:
      {bcp/bc9105.i "104" "Parametros nao foram inicializados (DC)"}
      ASSIGN iIndTipoVisualiza = 2.
   END.
   
   /* Caso o parametro seja informado incorretamente, informa ao usuario */
   IF iIndTipoVisualiza <> 2 AND iIndTipoVisualiza <> 4 THEN DO:
      {bcp/bc9105.i "104" "Valor do parametro incorreto para o item/familia/transacao (DC)"}
      ASSIGN iIndTipoVisualiza = 2.
   END. 
END PROCEDURE.

PROCEDURE getInfoCodigoEanDun:
/*------------------------------------------------------------------------------
  Purpose: Busca as informacoes do codigo ean/dun    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
   DEFINE VARIABLE iTipoInformacao  AS INTEGER    NO-UNDO.
   DEFINE VARIABLE cCodItem         AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cCodEmbalagem    AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE deQtdInformacao  AS DECIMAL    NO-UNDO.
   DEFINE VARIABLE deQtdItemPicking AS DECIMAL    NO-UNDO. /*Armazena a quantidade maxima a ser devolvida*/
   DEFINE VARIABLE hbosc148         AS HANDLE     NO-UNDO.
   
   RUN scbo/bosc148.p PERSISTENT SET hbosc148.
   
   HIDE ALL NO-PAUSE.
   
   ASSIGN deQtdItemPicking   = ttwork.qtd-item
          ttwork.qtd-item    = 0
          ttwork.cod-livre-1 = "".
   
   DISPLAY ttWork.cod-item
           ttWork.cod-lote
           ttWork.cod-refer
           ttWork.dat-validade
      WITH FRAME frame04.
   
   /* Faz a leitura at‚ a qtd de itens seja igual a qtd da etiqueta */
   REPEAT:
      /* Habilita para digitacao do codigo ean-dun*/
      REPEAT ON ERROR UNDO, NEXT:
         UPDATE ttwork.cod-livre-1 WITH FRAME Frame04.
         LEAVE.
      END.
      IF RETURN-VALUE = "ESC":U THEN
         RETURN RETURN-VALUE.
      
      /* Se o usuario digitar 999999, confirma */
      IF ttwork.cod-livre-1 = "999999" THEN
         LEAVE.
      
      /* Busca as informacoes referente ao codigo ean */
      RUN EmptyRowErrors IN hbosc148.
      RUN readBarCode IN hbosc148 (INPUT ttwork.cod-estabel,
                                   INPUT ttwork.cod-local,
                                   INPUT ttwork.cod-livre-1, /*codigo ean/dun lido*/
                                   OUTPUT iTipoInformacao,
                                   OUTPUT cCodItem, 
                                   OUTPUT cCodEmbalagem,
                                   OUTPUT deQtdInformacao,
                                   OUTPUT TABLE RowErrors).
      
      /* Tratamento de erro */
      RUN getRowErrors IN hbosc148 (OUTPUT TABLE RowErrors) NO-ERROR.
      FOR EACH RowErrors:
         HIDE ALL NO-PAUSE.
         ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
         RUN bcp/bc9115.p (errornumber, errordescription,8,20,3).
         HIDE ALL NO-PAUSE.
         NEXT.
      END.
      
      /* Verifica se o item do codigo ean/dun eh o mesmo item do serial */
      IF cCodItem <> ttwork.cod-item THEN DO:
         {bcp/bc9105.i "507" "Item do codigo ean/dun lido nÆo confere com o item do c¢digo serial (DC)"}
         NEXT.
      END.
      
      /* Incrementa a qtd de item digitado para os dois campos em tela  */
      ASSIGN ttwork.qtd-item = ttwork.qtd-item + deQtdInformacao.
      
      /* Se a quantidade lida for maior que a solicitada, considera apenas a quantidade do movimento */
      IF ttWork.qtd-item > deQtdItemPicking THEN DO:
         {bcp/bc9105.i "509" "Quantidade lida maior que a quantidade do movimento (DC)"}
      
         /* Retorna o valor anterior */
         ASSIGN ttwork.qtd-item = ttwork.qtd-item - deQtdInformacao.
      END.
      
      DISP ttwork.qtd-item WITH FRAME frame04.
   END.
    
   IF VALID-HANDLE (hbosc148) THEN
      DELETE OBJECT hbosc148.

   RETURN 'OK':U.
END PROCEDURE.

PROCEDURE getInfoEmbUn:
/*------------------------------------------------------------------------------
  Purpose: Busca as informacoes do codigo emb/un    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
   DEFINE VARIABLE iTipoInformacao AS INTEGER    NO-UNDO.
   DEFINE VARIABLE cCodItem        AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cCodEmbalagem   AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE deQtdInformacao AS DECIMAL    NO-UNDO.
   DEFINE VARIABLE hbosc148        AS HANDLE     NO-UNDO.
   
   IF NOT VALID-HANDLE (wgbosc145) THEN
      RUN scbo/bosc145.p PERSISTENT SET wgbosc145.
   
   /* Nao deixa sair do campo */
   ON END-ERROR OF ttwork.cod-livre-1 IN FRAME {&Frame05Name}
   DO:
      ASSIGN vLogErro = YES.
   END.
   
   /* Faz a leitura at‚ a qtd de itens for igual a qtd da etiqueta */
   REPEAT:
      /* Busca o valor do codigo emb~\un da tela */
      DISP ttWork.cod-item
           ttWork.cod-livre-1
           ttWork.cod-livre-2
         WITH FRAME {&Frame05Name}.
   
      DISPLAY ttWork.cod-item
              ttWork.cod-lote
              ttWork.cod-refer
              ttWork.dat-validade
         WITH FRAME frame05.
   
      /* Habilita para digitacao do codigo emb e un (se parametrizado)*/
      RUN pi-getLogHabilitaUn IN THIS-PROCEDURE.
   
      HIDE ALL NO-PAUSE.
      ASSIGN ttwork.cod-livre-1 = "".
      DO ON ENDKEY UNDO, RETURN "ESC":      
         IF iLogHabilitaUn THEN DO:
            UPDATE ttwork.cod-livre-1
                   ttWork.cod-livre-2
               WITH FRAME {&Frame05Name}.
         END.
         ELSE
            UPDATE ttwork.cod-livre-1 WITH FRAME {&Frame05Name}.
      END.
   
      RUN returnTableEmbItemLocal IN wgbosc145 (INPUT ttWork.cod-item,
                                                OUTPUT TABLE ttWm-item-embalagem-local).
   
      FIND FIRST ttWm-item-embalagem-local
           WHERE ttWm-item-embalagem-local.cod-estabel = ttWork.cod-estabel
             AND ttWm-item-embalagem-local.cod-local   = ttWork.cod-local
             AND ttWm-item-embalagem-local.log-padrao  = YES NO-ERROR.
          
      /* Metodo para transformar a emb/un em quantidade */
      Run EmptyRowErrors In wgbosc145.
      RUN piConverteCaixaQtde IN wgbosc145 (INPUT ttWork.cod-estabel, 
                                            INPUT ttWork.cod-local,   
                                            INPUT ttWork.cod-item,    
                                            INPUT IF AVAIL ttWm-item-embalagem-local THEN ttWm-item-embalagem-local.cod-embalagem ELSE "",
                                            INPUT ttWork.cod-livre-1,  
                                            INPUT ttWork.cod-livre-2,
                                            OUTPUT p-qtd-item).
      IF RETURN-VALUE <> "OK" THEN DO:
         RUN getRowErrors IN wgbosc145 (OUTPUT TABLE RowErrors) NO-ERROR.
         FOR EACH RowErrors:
            HIDE ALL NO-PAUSE.
            ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
            RUN bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,3).
            HIDE ALL NO-PAUSE.
            NEXT.
         END. 
      END.
      ELSE DO:
         IF p-qtd-item > tt-devol-picking.qtd-item THEN DO:
            {bcp/bc9105.i "602" "Quantidade lida maior que a quantidade do movimento (WMS)"}
            NEXT.
         END.
         IF p-qtd-item < tt-devol-picking.qtd-item THEN DO:
            {bcp/bc9105.i "602" "Quantidade lida deve ser igual a pedida (WMS)"}
            NEXT.
         END.
         IF p-qtd-item = tt-devol-picking.qtd-item THEN DO:
            LEAVE.
         END.
      END.
   END.
   
   IF VALID-HANDLE (wgbosc145) THEN
      DELETE OBJECT wgbosc145.
   
   RETURN 'OK'.
END PROCEDURE.

PROCEDURE pi-getLogHabilitaUn:
/*------------------------------------------------------------------------------
  Purpose: Busca Parametro HABILITA-UNIDADE    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
   DEFINE VARIABLE iNumLogHabilitaUn AS INTEGER     NO-UNDO.
   
   /* Busca o parametro da bc-param-ext conforme o tipo de endereco (BC9018h.i) */
   RUN pi-getValorParametro (ttWork.cod-item,
                             "wmsai004",
                             "HABILITA-UNIDADE",
                             OUTPUT iNumLogHabilitaUn).
   
   /* Se nÆo achar o parametro, assume o valor 1 - Habilita Unidade */
   IF iNumLogHabilitaUn = 0 THEN DO:
      ASSIGN iLogHabilitaUn = NO.
   END.
   
   /* Caso o parametro seja informado incorretamente, informa ao usuario */
   IF iNumLogHabilitaUn <> 1 AND iNumLogHabilitaUn <> 2 AND iNumLogHabilitaUn <> 0  THEN DO:
      {bcp/bc9105.i "104" "Valor do parametro incorreto para o item/familia/transacao (DC)"}
      ASSIGN iLogHabilitaUn = YES.
   END.
   
   IF iNumLogHabilitaUn = 1 THEN
      ASSIGN iLogHabilitaUn = YES.

   IF iNumLogHabilitaUn = 2 THEN
      ASSIGN iLogHabilitaUn = NO. 
END PROCEDURE.
