/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9025J 2.00.00.012 } /*** "010012" 01/04/2024 13:31:18  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9025j MBC}
&ENDIF


{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9025.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - Janeiro/2004 - Farley - Criaá∆o do programa                **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Transferància WMS                **
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
**                        Ex: tt-transf-wms.                                                      **
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
**                        que executa a procedure _GenerateDCTransaction que e responsavel por    **
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
&global-define ProgramName BC9025

/* Definicao da temp-table de integracao ---                */
&global-define TempTable tt-transf-wms
{bcp/bc9025.i " "}

DEFINE SHARED TEMP-TABLE ttWork NO-UNDO LIKE {&TempTable}.
DEFINE SHARED TEMP-TABLE tt-transf-wms-bkp NO-UNDO LIKE tt-transf-wms.

/************************************************************/

/* Variaveis de trabalho ---                                */              
DEFINE NEW SHARED VARIABLE vNumLidos    AS INTEGER                                  NO-UNDO.
DEFINE NEW SHARED VARIABLE vLogProcesso AS LOGICAL                      INITIAL NO  NO-UNDO.
                                                                                 
DEFINE VARIABLE vLogUtilizaColetor      AS LOGICAL                      INITIAL NO  NO-UNDO.
DEFINE VARIABLE vLogAprovaFatura        AS LOGICAL                      INITIAL NO  NO-UNDO.
DEFINE VARIABLE vLogControlaLogin       AS LOGICAL                      INITIAL NO  NO-UNDO.
DEFINE VARIABLE vCodTipoEquip           AS CHARACTER                    INITIAL ''  NO-UNDO.
DEFINE VARIABLE vLogOk                  AS LOGICAL                      INITIAL NO  NO-UNDO.
DEFINE VARIABLE vLogAnswer              AS LOGICAL                      INITIAL YES NO-UNDO.
DEFINE VARIABLE vLogAnswer-esc          AS LOGICAL                      INITIAL NO  NO-UNDO.
DEFINE VARIABLE vLogAtivo               AS LOGICAL                      INITIAL NO  NO-UNDO.
DEFINE VARIABLE vLogFirstTime           AS LOGICAL                      INITIAL YES NO-UNDO.
DEFINE VARIABLE c-ind-tipo-contr-est    AS INTEGER                                  NO-UNDO.
DEFINE VARIABLE vLogFimTran             AS LOGICAL                      INITIAL NO  NO-UNDO.
DEFINE VARIABLE vCodSenha               AS CHARACTER FORMAT 'x(12)':U               NO-UNDO.
DEFINE VARIABLE vEndereco               AS CHARACTER FORMAT 'x(12)':U               NO-UNDO.
DEFINE VARIABLE vCodBloco               AS CHARACTER                                NO-UNDO.
DEFINE VARIABLE vCodRua                 AS CHARACTER                                NO-UNDO.
DEFINE VARIABLE vCodNivel               AS CHARACTER                                NO-UNDO.
DEFINE VARIABLE vCodColuna              AS CHARACTER                                NO-UNDO. 
DEFINE VARIABLE wgbosc030               AS HANDLE                                   NO-UNDO.       

{bcp/bc9015.i3} /* def variaveis padroes */
{utp/utapi009.i} /* login */

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Transferància WMS'                                At Row 01  Col 01          ~
                             '--------------------':U                           At Row 02  Col 01          ~
                             'Box Sai:'                                         At Row 03  Col 01          ~
                             ttwork.num-box-orig                                At Row 03  Col 09 No-label ~
                             'End:'                                             at row 04  col 01          ~
                             vEndereco                                          at row 04  col 05 no-label ~
                             'Lidos:'                                           at row 05  col 01          ~
                             vNumLidos                                          at row 05  col 07 no-label ~
                             'Box Sai = 999999'                                 At Row 6   Col 01          ~
                             '(Encerra Sa°da)'                                  at row 7   col 01

&global-define Frame01Repeat yes 

/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields                               ~
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 

&global-define TriggerAfterFrame01  Run GravaCamposFrame01. If Return-value = 'OK' or vLogFinaliza = YES Then RETURN 'OK':U. ~
                                                            If Return-value = 'NOK'Then RETURN 'NOK':U. ~

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers                                                   ~
                            ON 'ESC':U OF Frame Frame01                       ~
                            DO:                                               ~
                               FIND FIRST tt-transf-wms-bkp NO-LOCK NO-ERROR. ~
                               hide all no-pause.                             ~
                               IF AVAIL tt-transf-wms-bkp THEN DO:            ~
                                  Disp 'Existem Sa°das.'   At Row 01 Col 01   ~
                                       'Deseja Desfazer?'  AT ROW 02 COL 01   ~
                                       '1=Sim 2=N∆o'       At Row 03 Col 01 With Frame f-conf Font 2 Size 20 By 8 No-box. ~
                                  Update vLogAnswer-esc    At Row 03 Col 13 No-label Format '1/2':U With Frame f-conf Font 2 Size 20 By 8. ~
                                  hide all no-pause. ~
                                  If  vLogAnswer-esc = YES Then do:       ~
                                      ASSIGN ttWork.num-box-orig = 0      ~
                                             ttWork.cod-item     = ""     ~
                                             vNumLidos           = 0.     ~
                                      EMPTY TEMP-TABLE tt-transf-wms-bkp. ~
                                      assign vLogFimTran         = yes            ~
                                             vLogFinaliza        = yes.           ~
                                  END.                                    ~
                                  ELSE DO:                                ~
                                      disp ttWork.num-box-orig with frame frame01. ~
                                      pause 0 before-hide. ~
                                      RETURN NO-APPLY.                    ~
                                  END.                                    ~
                               END.    ~
                               else assign vLogFimTran         = yes            ~
                                           vLogFinaliza        = yes.           ~
                            END.                                              ~
                            ON 'leave':U OF ttwork.num-box-orig IN Frame Frame01     ~
                            DO:                                                      ~
                                ASSIGN INPUT FRAME frame01 ttwork.num-box-orig.      ~
                                IF ttWork.num-box-orig = 999999 THEN do:             ~
                                     APPLY 'go':U TO FRAME frame01.                  ~
                                End.                                                 ~
                                IF NOT VALID-HANDLE(wgbosc030)  THEN DO:             ~
                                   Run scbo/bosc030.p Persistent SET wgbosc030.      ~
                                   Run openQueryStatic In wgbosc030 (Input "Main":U) No-error.  ~
                                END.                                                            ~
                                Run retornaEnderecoBox In wgbosc030 (Input ttWork.cod-estabel,  ~
                                                                     Input ttWork.cod-local,    ~
                                                                     Input ttWork.num-box-orig:SCREEN-VALUE IN FRAME Frame01, ~
                                                                     OUTPUT vCodBloco,          ~
                                                                     OUTPUT vCodRua,            ~
                                                                     OUTPUT vCodNivel,          ~
                                                                     OUTPUT vCodColuna).        ~
                                IF vCodBloco = ''                                               ~
                                   THEN ASSIGN vEndereco:SCREEN-VALUE IN FRAME Frame01 = ''.    ~
                                   ELSE ASSIGN vEndereco:SCREEN-VALUE IN FRAME Frame01 = vCodBloco  + "/":U + ~
                                                                                         vCodRua    + "/":U + ~
                                                                                         vCodNivel  + "/":U + ~
                                                                                         vCodColuna.          ~
                            END.  ~

/************************************************************/
/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgbosc030
/************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/
/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao e necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
RUN scbo/bosc030.p PERSISTENT SET wgbosc030 NO-ERROR.
RUN openQueryStatic IN wgbosc030 (INPUT "Main":U) NO-ERROR.

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */
/**************************************************************************************************/

/************************************* Codigo do Usuario Inicio ************************************
** Este local ≤ destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame01 com valores em branco              **
** Esta procedure e executada pelo pre-processador {&TriggerBeforeFrame01}.                       **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame01:    
   HIDE ALL NO-PAUSE.
     
   IF vLogFirstTime THEN DO:
      FIND FIRST ttWork NO-ERROR.
      DISP ttWork.num-box-orig
           vNumLidos
         WITH FRAME Frame01. 
   END.
   ELSE DO:
      ASSIGN ttWork.des-endereco = '' 
             vEndereco           = ''.
      
      IF vLogOk = YES THEN 
         ASSIGN ttWork.cod-item  = ""    
                ttWork.cod-refer = ""    
                ttWork.cod-lote  = ""    
                ttWork.qtd-item  = 0     
                vNumLidos        = 0.    
      
      DISP ttWork.num-box-orig WITH FRAME Frame01. 
   END.
   
   IF vLogFimTran = NO THEN DO:
      IF vLogFinaliza = NO THEN DO:
         IF vLogFirstTime = NO THEN DO:
            ASSIGN ttWork.cod-item = "777777":U
                   vEndereco:SCREEN-VALUE IN FRAME Frame01 = "".
            
            UPDATE ttWork.num-box-orig WITH FRAME Frame01.
            IF ttWork.num-box-orig <> 999999 THEN DO:
               RUN retornaEnderecoBox IN wgbosc030 (INPUT ttWork.cod-estabel, 
                                                    INPUT ttWork.cod-local,   
                                                    INPUT ttWork.num-box-orig,
                                                    OUTPUT vCodBloco,         
                                                    OUTPUT vCodRua,           
                                                    OUTPUT vCodNivel,         
                                                    OUTPUT vCodColuna).       
            IF vCodBloco = '' THEN DO:
               ASSIGN vLogErro = YES.
               {bcp/bc9105.i "301" "Box Inv†lido. (WMS)"}
               RETURN ERROR.
               END. 
            END.
         END.
         ELSE
            APPLY 'LEAVE' TO ttWork.num-box-orig IN FRAME Frame01.
         
         IF ttWork.num-box-orig <> 999999 THEN DO:
             HIDE ALL NO-PAUSE.
             RUN bcp/bc9025h.p. /* Chamando o zoom de saldos do item no Box Informado */ 
             HIDE ALL NO-PAUSE.
             PAUSE 0.
             ASSIGN vLogFirstTime = NO  
                    vLogFinaliza  = NO  
                    vLogSai       = NO.    
             
             DISP vNumLidos WITH FRAME Frame01.  
             PAUSE 0 BEFORE-HIDE.
         END.
      END.
   END.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure e executada pelo pre-processador {&TriggerAfterFrame03}.                        **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
   DEFINE VARIABLE cTotalQtde AS INTEGER            NO-UNDO.
   DEFINE VARIABLE lSai       AS LOGICAL INITIAL NO NO-UNDO.
   DEFINE VARIABLE cNumEmbal  AS INTEGER            NO-UNDO.
   DEFINE VARIABLE i          AS INTEGER            NO-UNDO.
   
   IF vlogFinaliza OR vLogFimTran THEN DO:
      LEAVE.
      RETURN.
   END.
   
   ASSIGN vLogErro = YES.
   
   ASSIGN vLogErro     = NO
          vLogOk       = NO
          vLogFinaliza = NO.
   
   IF ttWork.num-box-orig = 999999 THEN DO:
      IF NOT CAN-FIND(FIRST tt-transf-wms-bkp) THEN DO:
         Assign vLogErro = YES.
         {bcp/bc9105.i "401" "N∆o existem movtos para Transferància. (DC)"}
         RETURN ERROR.
      END.
      HIDE ALL NO-PAUSE.
      RUN bcp/bc9025f.p. 
      HIDE ALL NO-PAUSE.
      ASSIGN vLogFinaliza = YES.
      IF RETURN-VALUE = 'NOK':U THEN DO:
         {bcp/bc9105.i "900" "Problemas na Efetivaá∆o. (WMS)"}
      END.
      ELSE DO:
         IF RETURN-VALUE = 'CAN':U THEN DO:
            {bcp/bc9105.i "900" "Transferància Cancelada. (bc9025j)"}
         END.
      END.
   END. 
END PROCEDURE.
