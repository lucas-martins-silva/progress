/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9041 2.00.00.005 } /*** "010005" 23/07/2024 07:02:27  ***/




&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9041 MBC}
&ENDIF

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
**   Programa..: bc9041.p                                                                  **
**                                                                                         **
**   Versao....: 1.00.00.000 - julho/2009 - Jonas Gozddecki - Cria‡Æo do programa          **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Consulta de Endere‡o WMS         **
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
&global-define ProgramName BC9041
&global-define TempTable ttWork
/************************************************************/

/* Definicao da temp-table de integracao ---                */
{bcp/bc9041.i} /*Botar o BCP na frente*/

DEFINE TEMP-TABLE ttWork NO-UNDO
    FIELD cod-estabel     LIKE wm-box.cod-estabel    INITIAL ""
    FIELD cod-local       LIKE wm-box.cod-local      INITIAL ""
    FIELD id-box          AS CHARACTER FORMAT 'x(18)':U.

CREATE ttWork.

DEFINE TEMP-TABLE RowErrors NO-UNDO 
    FIELD ErrorSequence    AS INTEGER 
    FIELD ErrorNumber      AS INTEGER 
    FIELD ErrorDescription AS CHARACTER 
    FIELD ErrorParameters  AS CHARACTER 
    FIELD ErrorType        AS CHARACTER 
    FIELD ErrorHelp        AS CHARACTER 
    FIELD ErrorSubType     AS CHARACTER.
/************************************************************/
/* Variáveis de Trabalho-- */
DEFINE NEW SHARED VARIABLE wgbosc035 AS WIDGET-HANDLE NO-UNDO. 
DEFINE NEW SHARED VARIABLE wgbosc050 AS WIDGET-HANDLE NO-UNDO. 

DEFINE VARIABLE vCodLocal     LIKE wm-box.cod-local NO-UNDO.
DEFINE VARIABLE vCodEstab     LIKE wm-box.cod-estabel NO-UNDO. 
DEFINE VARIABLE vEnder        LIKE wm-box.id-box NO-UNDO.

DEFINE VARIABLE vDesEndereco AS CHARACTER FORMAT 'x(14)':U NO-UNDO. 
DEFINE VARIABLE vCodLote     AS CHARACTER FORMAT 'x(40)':U NO-UNDO.
DEFINE VARIABLE vQtdBox      AS CHARACTER FORMAT 'x(14)':U NO-UNDO.

DEFINE VARIABLE l-controla   AS LOGICAL NO-UNDO.



DEFINE QUERY qry-ttConsulta FOR ttConsulta.
DEFINE BROWSE brw-ttConsulta 
       QUERY qry-ttConsulta NO-LOCK
       DISPLAY ttConsulta.cod-item
               ttConsulta.cod-refer
               WITH NO-BOX No-labels SIZE 20 BY 3 NO-SCROLLBAR-VERTICAL. 
/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgbosc035
&global-define ActiveObject2 wgbosc050

/************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
{bcp/bc9015.i3}  /* def variaveis padroes */
/****************************************************************************************/

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Consulta Saldo End. '                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Estab:'                                           At Row 03 Col 01          ~
                             vCodEstab                                          At Row 03 Col 07 No-label ~
                             'Local:'                                           AT ROW 04 COL 01          ~
                             vCodLocal                                          AT ROW 04 COL 07 No-label ~
                             'Ender:'                                           At Row 05 Col 01          ~
                             vEnder                                      At Row 05 Col 07 No-label 

&global-define Frame01Repeat YES

/* Definicao da Frame02 ---  */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Consulta Saldo End. '                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'End:'                                             At Row 03 Col 01          ~
                             vDesEndereco                                       At Row 03 Col 05 No-label ~
                             brw-ttConsulta                                     At Row 04 Col 01          ~
                             'Lt:'                                              At Row 07 Col 01          ~
                             vCodLote                                           At Row 07 Col 04 NO-LABEL FORMAT "x(40)" VIEW-AS FILL-IN SIZE 11 BY 0.88 ~
                             'QtL:'                                             At Row 08 Col 01          ~
                             vQtdBox                                            At Row 08 Col 05 No-label
&global-define Frame02Repeat NO
/************************************************************/
/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields vCodEstab WHEN vCodEstab = '' ~
                              vCodLocal WHEN vCodLocal = '' vEnder WHEN vEnder = 0 ~    
&global-define Update02Fields brw-ttConsulta
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. IF vLogSai = Yes Then do: LEAVE _frame01. END.
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. 
&global-define TriggerAfterFrame02  Run GravaCamposFrame02.   
               
/************************************************************/


/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/

/**************************************************************************************************/

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ~
                ON 'value-changed':U OF brw-ttConsulta IN FRAME {&Frame02Name} DO: ~
                     ASSIGN vCodBloco  = String(ttConsulta.cod-bloco)    ~
                            vCodRua   = String(ttConsulta.cod-rua)    ~
                            vCodNivel  = String(ttConsulta.cod-nivel)        ~
                            vCodColuna  = String(ttConsulta.cod-coluna)        ~
                            vLado = String(ttConsulta.ind-posicao-box) ~
                            vQtdBox:SCREEN-VALUE IN FRAME {&frame02name} = STRING(ttConsulta.qtd-item) ~
                            vCodLote:SCREEN-VALUE IN FRAME {&frame02name} = STRING(ttConsulta.cod-lote) ~
                            vDesEndereco:SCREEN-VALUE IN FRAME {&frame02name} = trim(vCodBloco) + '/' + trim(vCodRua) + '/' + trim(vCodNivel) + '/' +  trim(vCodColuna) + '/' + TRIM(SUBSTR(vLado,1,1)). ~
                END.

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
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
   
   ASSIGN vLogErro    = NO
          vLogCancela = NO
          vCodEstab:SCREEN-VALUE IN FRAME Frame01 = '':U 
          vCodLocal:SCREEN-VALUE IN FRAME Frame01 = '':U 
          vEnder:SCREEN-VALUE IN FRAME Frame01 = '':U
          vCodEstab = ""
          vCodLocal = ""
          vEnder = 0.
          
END PROCEDURE.


/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame03 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame03}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame02:   
   ASSIGN vLogErro    = NO
          vLogCancela = NO.

   IF NOT VALID-HANDLE(wgbosc035)  THEN DO:
      RUN scbo/bosc035.p PERSISTENT SET wgbosc035.
      RUN openQueryStatic IN wgbosc035 (INPUT "Main":U) NO-ERROR. 
   END.  
   IF VALID-HANDLE(wgbosc035) THEN DO:
      
      EMPTY TEMP-TABLE ttConsulta. 
            
      EMPTY TEMP-TABLE ttResumo.     

      RUN getOcupacaoBox IN wgbosc035 (INPUT vCodEstab,
                                       INPUT vCodLocal,
                                       INPUT vEnder,
                                       OUTPUT table ttResumo).    
      IF NOT CAN-FIND(FIRST ttResumo) THEN DO:    
         {bcp/bc9105.i "303" "NÆo h  itens neste endere‡o (WMS)"}    
         RETURN ERROR.
      END.
      ELSE DO:          
         RUN retornaLocalizacaoBrowser IN wgbosc035 (INPUT vCodEstab,
                                                     INPUT vCodLocal,
                                                     INPUT vEnder,
                                                     OUTPUT vCodBloco, 
                                                     OUTPUT vCodRua, 
                                                     OUTPUT vCodNivel, 
                                                     OUTPUT vCodColuna,
                                                     OUTPUT vLado).
                        
         IF NOT VALID-HANDLE(wgbosc050)  THEN DO:
            RUN scbo/bosc050.p PERSISTENT SET wgbosc050.
         END.
           
         IF VALID-HANDLE(wgbosc050) THEN DO:
            RUN getControlaPosicao IN wgbosc050 (OUTPUT l-controla).
         END.

         IF NOT l-controla THEN
            ASSIGN vLado ="".

         FOR EACH ttResumo NO-LOCK:

            CREATE ttConsulta.
            ASSIGN ttConsulta.cod-estabel = ttResumo.cod-estabel
                   ttConsulta.cod-local = ttResumo.cod-local
                   ttConsulta.cod-item = ttResumo.cod-item
                   ttConsulta.cod-refer = "Rf:" + STRING(ttResumo.cod-refer)
                   ttConsulta.cod-lote = ttResumo.cod-lote
                   ttConsulta.cod-bloco = vCodBloco 
                   ttConsulta.cod-rua = vCodRua
                   ttConsulta.cod-nivel = vCodNivel
                   ttConsulta.cod-coluna = vCodColuna
                   ttConsulta.cod-embalagem = ttResumo.cod-embalagem
                   ttConsulta.qtd-item = IF ind-status-saldo = 3 THEN ((ttResumo.qti-embalagem * ttResumo.qtd-item) - ttResumo.qtd-item-bloq) ELSE 0.
                   ttConsulta.ind-posicao-box = vLado.
         END.
      END.
   END.

   FIND FIRST ttConsulta NO-ERROR.  

   OPEN QUERY qry-ttConsulta
      FOR EACH ttConsulta NO-LOCK
            BY ttConsulta.cod-bloco
            BY ttConsulta.cod-rua
            BY ttConsulta.cod-nivel
            BY ttConsulta.cod-coluna
            BY ttConsulta.ind-posicao-box.

   APPLY 'value-changed':U TO brw-ttConsulta IN FRAME {&Frame02Name}.
    
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores    **
** na tela Frame 01. Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.     **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
   /* Validacoes Frame 01 Inicio --- */
   ASSIGN vLogErro     = NO
          vLogsai      = NO
          vLogfinaliza = YES.
   RETURN RETURN-VALUE.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores    **
** na tela Frame 02.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame02:
   ASSIGN vLogErro     = NO
          vLogsai      = YES
          vLogfinaliza = NO.
   RETURN 'OK':U.
END PROCEDURE.

FINALLY:
   IF NOT lMenu AND THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
  
   RETURN 'OK':U.
END FINALLY.







