/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9021Y 2.00.00.005 } /*** "010005" 12/12/2023 15:27:53  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9021y MBC}
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


&global-define ProgramName BC9021

&global-define TempTable tt-devolve-picking
{bcp/bc9021.i}
{bcp/bc9018h.i} /* definicao das procedures utilizadas para controle ean/dun */

DEFINE TEMP-TABLE tt-etiq-resumo NO-UNDO
            FIELD nr-resumo        LIKE wm-docto-itens-ped-etiqueta.nr-resumo
            FIELD nr-pedcli        LIKE wm-docto-itens-ped.nr-pedcli         
            FIELD nome-abrev       LIKE wm-docto-itens-ped.nome-abrev        
            FIELD num-seq-item     LIKE wm-docto-itens-ped.num-seq-item
            FIELD num-seq-item-ped LIKE wm-docto-itens-ped.num-seq-item-ped
            FIELD id-etiqueta      LIKE wm-docto-itens-ped-etiqueta.qtd-item
            FIELD cod-item         LIKE wm-docto-itens-ped-etiqueta.cod-item
            FIELD qtd-item         LIKE wm-docto-itens-ped-etiqueta.qtd-item
            INDEX id IS PRIMARY UNIQUE nr-resumo
                                       nr-pedcli
                                       nome-abrev
                                       num-seq-item
                                       id-etiqueta.

DEFINE QUERY qry-devol-picking FOR tt-etiq-resumo.

DEFINE BROWSE brw-devol-picking QUERY qry-devol-picking NO-LOCK
   DISPLAY tt-etiq-resumo.num-seq-item
           tt-etiq-resumo.qtd-item
           tt-etiq-resumo.nr-resumo
           tt-etiq-resumo.nr-pedcli
           tt-etiq-resumo.nome-abrev
           tt-etiq-resumo.num-seq-item-ped
     WITH NO-BOX SIZE 18 BY 4.5 NO-SCROLLBAR-VERTICAL.

DEFINE TEMP-TABLE ttWork LIKE {&TempTable}.

DEFINE INPUT PARAM TABLE FOR tt-etiq-resumo.
DEFINE INPUT-OUTPUT PARAM TABLE FOR ttWork.
DEFINE OUTPUT PARAM l-erro-qtd-picking AS LOGICAL INITIAL YES NO-UNDO.

FIND FIRST ttWork.

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 

&global-define Frame01Name   Frame01
&global-define Frame01Defs  'Devolu‡Æo Pick. WMS '   At Row 01 Col 01  ~
                            '--------------------'   At Row 02 Col 01  ~
                            brw-devol-picking          AT Row 03 Col 01  ~
&global-define Frame01Repeat NO

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields brw-devol-picking

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. If vLogFinaliza = Yes Then do: LEAVE _frame01. END.

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ~
                            ON 'Return':U OF brw-devol-picking In Frame {&Frame01Name} DO:  ~
                                   Apply 'Go' To This-procedure.                            ~
                            END.                                                            ~
                            ON 'ESC':U OF Frame Frame01 DO: ~
                                RETURN 'ESC':U.             ~
                            END.

/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */

PROCEDURE InicializaCamposFrame01:
/*------------------------------------------------------------------------------
  Purpose:     
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

   ASSIGN ttWork.cod-item         = '' 
          ttWork.cod-lote         = ''
          ttWork.cod-refer        = ''
          ttWork.dat-validade     = ? 
          ttWork.qtd-item         = 0
          ttWork.nr-resumo        = 0
          ttWork.nr-pedcli        = ''
          ttWork.nome-abrev       = ''
          ttWork.num-seq-item     = 0 
          ttWork.num-seq-item-ped = 0.
   
   OPEN QUERY qry-devol-picking
     FOR EACH tt-etiq-resumo
           BY tt-etiq-resumo.num-seq-item.

END PROCEDURE.

PROCEDURE GravaCamposFrame01:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF RETURN-VALUE = 'ESC' THEN
      RETURN .
  
   ASSIGN vLogErro     = NO
          vLogSai      = NO 
          vLogFinaliza = YES.
   
   IF NOT AVAIL tt-etiq-resumo THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "301" "Movimento Inv lido. (WMS)"}
      RETURN ERROR.
   END.
   
   ASSIGN ttWork.nr-resumo         = tt-etiq-resumo.nr-resumo
          ttWork.nr-pedcli         = tt-etiq-resumo.nr-pedcli
          ttWork.nome-abrev        = tt-etiq-resumo.nome-abrev
          ttWork.num-seq-item      = tt-etiq-resumo.num-seq-item
          ttWork.num-seq-item-ped  = tt-etiq-resumo.num-seq-item-ped
          ttWork.qtd-item          = tt-etiq-resumo.qtd-item
          l-erro-qtd-picking       = NO.
   RETURN 'OK':U.
END PROCEDURE.
