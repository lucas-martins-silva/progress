/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9038 2.00.00.007 } /*** "010007" 07/11/2023 14:11:52  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9038 MBC}
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
/********************************************************************************
** Copyright DATASUL S.A. (2002)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/********************************************************************************************
**   Programa..: bc9038.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - agosto/2006 - Thiago Bravo - Cria‡Æo do programa          **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Consulta de Caixa Resumo WMS     **
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
**                        Ex: &global-define ActiveObject wgBOSC074                               **
***************************************************************************************************/

/* Definicao global do nome da transacao ---                */
&global-define ProgramName bc9038
/************************************************************/

{utp/utapi009.i} /* login */
/* Definicao da temp-table de integracao ---                */
{bcp/bc9038.i}

DEFINE TEMP-TABLE tt-wms-etiq-packing NO-UNDO LIKE wms-etiq-packing 
            FIELD r-Rowid AS ROWID.

DEFINE TEMP-TABLE tt-wm-packing-item NO-UNDO LIKE wm-packing-item.

DEFINE TEMP-TABLE tt-resumo-packing NO-UNDO
            FIELD cod-item     LIKE tt-wm-packing-item.cod-item
            FIELD cdd-embarq   LIKE tt-wm-packing-item.cdd-embarq    
            FIELD nr-pedido    LIKE tt-wm-packing-item.nr-pedido  
            FIELD qtd-item     AS DECIMAL
            FIELD qtd-embal    AS DECIMAL
            FIELD cod-lote     LIKE tt-wm-packing-item.cod-lote
            FIELD cod-refer    LIKE tt-wm-packing-item.cod-refer.

&global-define TempTable tt-consulta

DEFINE TEMP-TABLE ttWork NO-UNDO LIKE {&TempTable}.

CREATE ttWork.
DEFINE TEMP-TABLE RowErrors NO-UNDO 
            FIELD ErrorSequence    AS INTEGER 
            FIELD ErrorNumber      AS INTEGER 
            FIELD ErrorDescription AS CHARACTER 
            FIELD ErrorParameters  AS CHARACTER 
            FIELD ErrorType        AS CHARACTER 
            FIELD ErrorHelp        AS CHARACTER 
            FIELD ErrorSubType     AS CHARACTER.


DEFINE VARIABLE vcod-lote               AS CHARACTER FORMAT 'x(40)':U       INIT ''  NO-UNDO.
DEFINE VARIABLE vcod-refer              AS CHARACTER FORMAT 'x(08)':U       INIT ''  NO-UNDO.
DEFINE VARIABLE vqtd-item               AS DECIMAL                          INIT  0  NO-UNDO.
DEFINE VARIABLE vqtd-emb                AS DECIMAL                          INIT  0  NO-UNDO.
DEFINE VARIABLE vnom-abrev              AS CHARACTER FORMAT 'x(18)':U       INIT ''  NO-UNDO. 
DEFINE VARIABLE c-item                  AS CHARACTER                                 NO-UNDO.
DEFINE VARIABLE de-etiq-packing         AS DECIMAL   FORMAT '>>>>>>>>>>>>>>>'        NO-UNDO.
DEFINE VARIABLE vqtd-item-etq           AS DECIMAL   FORMAT ">>>>>9.9999"   INIT  0  NO-UNDO.
DEFINE VARIABLE iQtdVolumes             AS INTEGER                                   NO-UNDO.
DEFINE VARIABLE wgbcapiwms              AS HANDLE                                    NO-UNDO. 

DEFINE BUFFER b-tt-packing-item FOR tt-wm-packing-item.

DEFINE QUERY qry-wm-packing-item  FOR tt-resumo-packing.
DEFINE QUERY qry-etiquetas-item FOR b-tt-packing-item.

DEFINE BROWSE brw-wm-packing-item QUERY qry-wm-packing-item NO-LOCK
      DISPLAY tt-resumo-packing.cod-item    FORMAT "x(16)"            LABEL "Item"
              tt-resumo-packing.cdd-embarq  FORMAT '>>>>>>>>>>>>>>>9' LABEL "Nr Emb"
              tt-resumo-packing.nr-pedido   FORMAT '>>>>>>9'          LABEL "Pedido"
              tt-resumo-packing.qtd-item    FORMAT ">>>>>9.9999"      LABEL "Qtd It"
              tt-resumo-packing.qtd-embal   FORMAT ">>>>>9.9999"      LABEL "Qtd Emb It"
              tt-resumo-packing.cod-lote    FORMAT "x(40)"            LABEL "Lote"
              tt-resumo-packing.cod-refer   FORMAT "x(8)"             LABEL "Refer"
         WITH NO-BOX NO-LABELS SIZE 20 BY 4 NO-SCROLLBAR-VERTICAL.

DEFINE BROWSE brw-etiquetas-item QUERY qry-etiquetas-item NO-LOCK
      DISPLAY b-tt-packing-item.id-etiqueta       FORMAT '>>>>>>>>>>>>>9'  LABEL "Etiqueta"
              b-tt-packing-item.cod-item          FORMAT "x(16)"           LABEL "Item"
              b-tt-packing-item.cod-embalagem     FORMAT 'x(10)'           LABEL "Embalagem"
              b-tt-packing-item.cod-lote          FORMAT "x(40)"           LABEL "Lote"
              b-tt-packing-item.cod-refer         FORMAT "x(8)"            LABEL "Refer"
         WITH NO-BOX NO-LABELS SIZE 20 BY 4 NO-SCROLLBAR-VERTICAL.

/************************************************************/

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Consulta Caixa WMS  '                            At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Usr:'                                             At Row 03 Col 01          ~
                             ttWork.cod-usuario                                 At Row 03 Col 05 No-label FORMAT "x(25)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             'Sen:'                                             AT ROW 04 COL 01          ~
                             vcod-senha                                         AT ROW 04 COL 05 NO-LABEL FORMAT "x(18)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             'Col:'                                             At Row 05 Col 01          ~
                             ttWork.cod-coletor                                 At Row 05 Col 05 No-label ~
                             'Equ:'                                             At Row 06 Col 01          ~
                             ttWork.cod-equipamento                             At Row 06 Col 05 No-label
&global-define Frame01Repeat No


/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Consulta Caixa WMS  '                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Etiqueta Packing:   '                             At Row 03 Col 01          ~
                             de-etiq-packing                                    At Row 04 Col 01 No-label ~

&global-define Frame02Repeat NO
/************************************************************/
/* Definicao da Frame03 ---                                 */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Consulta Caixa WMS '                              At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             brw-wm-packing-item                                At Row 03 Col 01          ~
                             'TotIt:'                                           AT ROW 07 COL 01          ~
                             vqtd-item                                          AT ROW 07 COL 07 NO-LABEL ~
                             'TotEmb:'                                          AT ROW 08 COL 01          ~
                             vqtd-emb                                           AT ROW 08 COL 08  NO-LABEL ~
                             
&global-define Frame03Repeat YES

/* Definicao da Frame04 ---                                 */
&global-define Frame04Name   Frame04
&global-define Frame04Defs   'Consulta Caixa WMS '                              At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             brw-etiquetas-item                                 At Row 03 Col 01          ~
                             'Item:'                                            AT ROW 07 COL 01          ~
                             c-item                                             AT ROW 07 COL 09 NO-LABEL ~
                             'Qt Etq:'                                          AT ROW 08 COL 01          ~
                             vqtd-item-etq                                      AT ROW 08 COL 08 NO-LABEL ~
                             
&global-define Frame04Repeat YES

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-usuario WHEN ttWork.cod-usuario = ''  ~
                              vcod-senha WHEN ttWork.cod-usuario = ''          ~
                              ttWork.cod-coletor ttWork.cod-equipamento        ~

&global-define Update02Fields de-etiq-packing

&global-define Update03Fields brw-wm-packing-item

&global-define Update04Fields brw-etiquetas-item

/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. IF vLogSai = Yes Then do: LEAVE _frame01. END.
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02.
&global-define TriggerBeforeFrame03 Run InicializaCamposFrame03. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. 
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. 
&global-define TriggerAfterFrame03  Run GravaCamposFrame03. Empty Temp-table tt-wm-packing-item.

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ON 'ESC':U OF Frame Frame01    ~
                            DO:                            ~
                                ASSIGN  vlogerro = YES     ~
                                       vLogSai  = YES      ~
                                       vLogFinaliza = YES. ~
                                       vLogCancela = YES.  ~
                                Return 'ESC':U.            ~
                            END. ~
                            ON 'Return':U        OF brw-wm-packing-item In Frame {&Frame03Name}     ~
                            DO:                                                                     ~
                                   Apply 'Go' To This-procedure.                                    ~
                            END.                                                                    ~
                            ON 'value-changed':U OF brw-wm-packing-item In Frame {&Frame03Name}     ~
                            DO:                                                                     ~
                                                                                                    ~
                            END.                                                                    ~
                            On 'RETURN':U of brw-wm-packing-item in Frame {&Frame03Name} DO: ~
                                ~
                                VIEW FRAME {&Frame04Name}. ~
                                RUN InicializaCamposFrame04. ~
                                UPDATE brw-etiquetas-item WITH FRAME {&Frame04Name}. ~
                            END.~
                            ON 'value-changed':U OF brw-etiquetas-item In Frame {&Frame04Name}     ~
                            DO:                                                                     ~
                                RUN piAtualizaFrame04. ~
                            END.

/************************************************************/

/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgBOSC092
&global-define ActiveObject2 wgBOSC079
&global-define ActiveObject3 wgBOSC100
&global-define ActiveObject4 wgBOSC152
&global-define ActiveObject5 wgbcapiwms

/************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
/*RUN pi-return-value.*/
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
PROCEDURE InicializaCamposFrame01:

   IF RETURN-VALUE = 'ESC':U  THEN DO:
      ASSIGN vlogerro = YES     
             vLogSai  = YES      
             vLogFinaliza = YES
             vLogCancela = YES. 
      HIDE ALL NO-PAUSE.
      RETURN  ERROR.
   END.
   ASSIGN vLogErro     = NO
          vLogsai      = NO
          vLogfinaliza = NO.
   
   EMPTY TEMP-TABLE ttWork.
   CREATE ttWork.

   IF v_cod_usuar_corren <> '' THEN DO: 
       ASSIGN vcod-senha:BLANK IN FRAME frame01 = NO.
       ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = v_cod_usuar_corren
              ttWork.cod-usuario                               = v_cod_usuar_corren
              vcod-senha                                       = '****************':U /* login autom tico */
              vcod-senha:SCREEN-VALUE IN FRAME frame01         = '****************':U. /* login autom tico */
   END.
   ELSE DO:
      ASSIGN vcod-senha:BLANK IN FRAME frame01 = YES.
      ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = '' 
             ttWork.cod-usuario = ''
             vcod-senha = ''  
             vcod-senha:SCREEN-VALUE IN FRAME Frame01 = ''.
   END.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame02 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame03}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame02:   

   ASSIGN vLogErro     = NO
          vLogsai      = NO
          vLogfinaliza = NO.
   ASSIGN ttWork.des-endereco = ''
          vtexto = '' .

END PROCEDURE.


/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame03 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame03}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame03:
    
   ASSIGN vLogErro        = NO
          vLogCancela     = NO.
   
   RUN pi-totaliza-itens-packing. /* Sumariza itens do Packing */
   
   OPEN QUERY qry-wm-packing-item
     FOR EACH tt-resumo-packing 
           BY tt-resumo-packing.cod-item     
           BY tt-resumo-packing.cdd-embarq.
       
   ASSIGN vqtd-item:SCREEN-VALUE IN FRAME Frame03 = TRIM(STRING(vqtd-item))
          vqtd-emb:SCREEN-VALUE IN FRAME Frame03 = TRIM(STRING(vqtd-emb)).
   
   APPLY 'VALUE-CHANGED':U TO brw-wm-packing-item IN FRAME {&Frame03Name}.
END.


/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame04 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame04}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame04:
    
   ASSIGN vLogErro        = NO
          vLogCancela     = NO.
   
   FIND FIRST b-tt-packing-item NO-LOCK NO-ERROR.
   IF NOT AVAIL b-tt-packing-item THEN DO:
      CREATE b-tt-packing-item.
      ASSIGN b-tt-packing-item.id-etiqueta   = 999
             b-tt-packing-item.cod-item      = 'Sem Etiq'.
   END.
   
   IF NOT AVAIL tt-resumo-packing THEN
      RETURN "NOK".
   
   OPEN QUERY qry-etiquetas-item
     FOR EACH b-tt-packing-item
        WHERE b-tt-packing-item.cod-item = tt-resumo-packing.cod-item
          AND b-tt-packing-item.cod-lote = tt-resumo-packing.cod-lote
           BY b-tt-packing-item.cod-item
           BY b-tt-packing-item.id-etiqueta.
   
   APPLY 'VALUE-CHANGED':U TO brw-etiquetas-item IN FRAME {&Frame04Name}.
END.



/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01. Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.     **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:

   /* Validacoes Frame 01 Inicio --- */
   ASSIGN vLogErro     = NO
          vLogsai      = NO
          vLogfinaliza = NO.
   
   /* VALIDA€AO USUµRIO */
   IF INPUT FRAME Frame01 ttWork.cod-usuario = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "201" "Usu rio Inv lido (DC)"}
   END. 
   IF v2_cod_usuar_corren = '' THEN DO:
      EMPTY TEMP-TABLE tt-erros.

      login:
      DO ON ERROR  UNDO login, LEAVE login
         ON QUIT   UNDO login, LEAVE login
         ON STOP   UNDO login, LEAVE login
         ON ENDKEY UNDO login, LEAVE login: 
         RUN btb/btapi910za.p (INPUT INPUT FRAME frame01 ttWork.cod-usuario, 
                               INPUT INPUT FRAME frame01 vCod-Senha, 
                               OUTPUT TABLE tt-erros) NO-ERROR.        
      END.
      IF CAN-FIND(FIRST tt-erros
                  WHERE tt-erros.cod-erro = 4753) THEN DO:
         {bcp/bc9105.i "4753" "Usu rio nÆo encontrado!(DC)"}
         ASSIGN vLogErro           = YES
                v_cod_usuar_corren = ''.
         RETURN ERROR.
      END.
      ELSE DO:
         IF CAN-FIND(FIRST tt-erros
                     WHERE tt-erros.cod-erro = 4758) THEN DO:
            {bcp/bc9105.i "4758" "Senha para o usu rio nÆo est  correta!(DC)"} 
            ASSIGN vLogErro           = YES
                   v_cod_usuar_corren = ''.
            RETURN ERROR.
         END.
      END.
      IF NOT VALID-HANDLE(wgbcapiwms) THEN
         RUN bcp/bcapiwms.p PERSISTENT SET wgbcapiwms NO-ERROR.
   
      RUN piValidaUsuario IN wgbcapiwms (INPUT INPUT FRAME frame01 ttWork.cod-usuario,
                                         OUTPUT ttWork.cod-usuario).
                                         
      IF VALID-HANDLE(wgbcapiwms) THEN
         DELETE PROCEDURE wgbcapiwms NO-ERROR.
                                          
      ASSIGN vLogControlaLogin = YES.
   END.
   
   IF NOT VALID-HANDLE(wgbosc079)  THEN DO:
      RUN scbo/bosc079.p PERSISTENT SET wgbosc079.
      RUN openQueryStatic IN wgbosc079 (INPUT "Main":U) NO-ERROR.
   END.
   RUN validaUsuario IN wgbosc079 (INPUT INPUT FRAME Frame01 ttWork.cod-usuario,
                                   OUTPUT vLogUtilizaColetor,
                                   OUTPUT vLogAprovaFatura).
   IF RETURN-VALUE <> 'OK' THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN
      ASSIGN v_cod_usuar_corren  = ''
             v2_cod_usuar_corren = ''.
      RUN getrowErrors IN wgbosc079 (OUTPUT TABLE RowErrors).
      FOR EACH RowErrors:
          ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
          {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription)}
      END.                                           
   END.
   IF vLogUtilizaColetor = NO THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN
      ASSIGN v_cod_usuar_corren  = ''
             v2_cod_usuar_corren = ''.
      {bcp/bc9105.i "202" "Usu rio sem permissÆo para Coletor (WMS)"}
   END.
   IF vLogErro = YES THEN
      RETURN ERROR.
   
   IF ttWork.cod-coletor = ''  THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "102" "Coletor Inv lido (DC)"}
   END.
   IF ttWork.cod-equipamento = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "103" "Equipamento Inv lido (DC)"}
   END.
   IF vLogErro = YES THEN
      RETURN ERROR.
   
   /* instancia as BOs de forma persistente */
   IF NOT VALID-HANDLE(wgBOSC092) THEN
      RUN scbo/bosc092.p PERSISTENT SET wgbosc092.
   
   /* valida se equipamento ‚ do tipo coletor */
   RUN validaEquipColetor IN wgbosc092 (INPUT ttWork.cod-coletor,
                                        OUTPUT vCodTipoEquip,
                                        OUTPUT vLogAtivo,
                                        OUTPUT vLogProcesso).
   IF RETURN-VALUE <> 'OK' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "102" "Coletor Inv lido (WMS)"}
      RETURN ERROR.
   END.
   
   /* valida se existe equipamento e se est  ativo */
   RUN validaEquipTransportador IN wgbosc092  (INPUT ttWork.cod-equipamento,
                                               OUTPUT vCodTipoEquip,
                                               OUTPUT vLogAtivo,
                                               OUTPUT vLogProcesso).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "103" "Equipamento Inv lido (WMS)"}
   END.
   IF vlogAtivo = NO THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "104" "Equipamento Desativado (WMS)"}
   END.
   IF vLogErro = YES THEN
      RETURN ERROR.
   
   RETURN RETURN-VALUE.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 02.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame02:

   DEFINE VARIABLE l-efetua-pack AS LOGICAL    NO-UNDO.
    
   IF NOT VALID-HANDLE(wgbosc152) THEN DO:
      RUN scbo/bosc152.p PERSISTENT SET wgbosc152 NO-ERROR.
      RUN openQueryStatic IN wgbosc152 (INPUT "Main":U) NO-ERROR.
   END.
   
    /* Valida o codigo da Etiqueta de Packing informado */
   IF LENGTH(STRING(de-etiq-packing)) = 0 THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "000" "Etiqueta deve ser informada"}
      RETURN.
   END.
   
   IF LENGTH(STRING(de-etiq-packing)) <> 15 THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "000" "Etiqueta informada deve ser de Embalagem"}
      ASSIGN de-etiq-packing = 0.
      UNDO,RETRY.
   END.
   
   RUN getInfPackItemEtiqueta IN wgbosc152 (INPUT de-etiq-packing,
                                            OUTPUT l-efetua-pack).
   
   IF RETURN-VALUE = "NOK":U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "000" "Etiqueta de embalagem nÆo foi encontrada"}
      ASSIGN de-etiq-packing = 0.
      UNDO,RETRY.
   END.
   
   /* Carrega as TempTables necess rias para exibi‡Æo dos dados … partir do frame03 */
   
   EMPTY TEMP-TABLE tt-resumo-packing.
   EMPTY TEMP-TABLE tt-wms-etiq-packing.
   EMPTY TEMP-TABLE tt-wm-packing-item.
   
   RUN getItensPacking IN wgbosc152 (INPUT de-etiq-packing,
                                     OUTPUT TABLE tt-wms-etiq-packing,
                                     OUTPUT TABLE tt-wm-packing-item).
   
   /* Se nÆo retornou nenhuma informa‡Æo nas TempTables, 
      apresenta erro e solicita leitura de outro serial */
   FIND FIRST tt-wm-packing-item NO-LOCK NO-ERROR.
   IF NOT AVAIL tt-wm-packing-item THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "000" "NÆo existem Itens para este Packing (WMS)"}
      UNDO,RETRY.
   END.
END PROCEDURE.

PROCEDURE pi-return-value:
   RETURN 'OK':U.
END PROCEDURE.

PROCEDURE piAtualizaFrame03:
    
END.           

PROCEDURE piAtualizaFrame04:
    
   ASSIGN  c-item:SCREEN-VALUE IN FRAME Frame04        = TRIM(STRING(b-tt-packing-item.cod-item))
           vqtd-item-etq:SCREEN-VALUE IN FRAME Frame04 = TRIM(STRING(b-tt-packing-item.qtd-item)).

END.

PROCEDURE pi-totaliza-itens-packing:

   DEFINE VARIABLE i-total-item AS INTEGER    NO-UNDO.
   DEFINE VARIABLE i-total-emb  AS INTEGER    NO-UNDO.

   FIND FIRST tt-wms-etiq-packing NO-LOCK NO-ERROR.

   ASSIGN vqtd-item = 0
          vqtd-emb  = 0.

   FOR EACH tt-wm-packing-item 
      WHERE tt-wm-packing-item.cod-estabel    = tt-wms-etiq-packing.cod-estabel
        AND tt-wm-packing-item.cod-local      = tt-wms-etiq-packing.cod-local
        AND tt-wm-packing-item.cdd-embarq     = tt-wms-etiq-packing.cdd-embarq
        AND tt-wm-packing-item.nr-resumo      = tt-wms-etiq-packing.nr-resumo
        AND tt-wm-packing-item.nr-pedcli      = tt-wms-etiq-packing.nr-pedcli
        AND tt-wm-packing-item.nome-abrev     = tt-wms-etiq-packing.nome-abrev
      BREAK BY tt-wm-packing-item.cod-item:

      ASSIGN i-total-item = i-total-item + tt-wm-packing-item.qtd-item
             i-total-emb  = i-total-emb + 1.

      IF LAST-OF(tt-wm-packing-item.cod-item) THEN DO:
          CREATE tt-resumo-packing.
          ASSIGN tt-resumo-packing.cod-item    = tt-wm-packing-item.cod-item
                 tt-resumo-packing.cdd-embarq  = tt-wm-packing-item.cdd-embarq
                 tt-resumo-packing.nr-pedido   = tt-wm-packing-item.nr-pedido  
                 tt-resumo-packing.cod-lote    = tt-wm-packing-item.cod-lote
                 tt-resumo-packing.cod-refer   = tt-wm-packing-item.cod-refer
                 tt-resumo-packing.qtd-item    = i-total-item
                 tt-resumo-packing.qtd-embal   = i-total-emb.

          ASSIGN vqtd-item = vqtd-item + i-total-item
                 vqtd-emb  = vqtd-emb + i-total-emb.

          ASSIGN i-total-item = 0
                 i-total-emb  = 0.
      END.
   END. 
END PROCEDURE.


PROCEDURE GravaCamposFrame03:

END PROCEDURE.
