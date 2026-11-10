/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9051 2.00.00.019 } /*** "010019" 25/07/2024 08:03:57  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9051 MBC}
&ENDIF
/********************************************************************************************
**   Programa..: bc9051.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000                                                               **
**                                                                                         **
**   Finalidade: Adapter da transacao de Transferencia e Requisicao de alocados            **
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
**                        Ex: tt-reporte-ordem-bc.                                                **
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
**                        que executa a procedure _GenerateDCTransaction que eï¿½ responsavel por   **
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
***************************************************************************************************/

/* Definicao global do nome da transacao ---                */
&global-define ProgramName bc9051
/************************************************************/

/* Definicao da temp-table de integracao ---                */
&global-define TempTable tt-transfere-prod-bc
{bcp/bc9051.i " "}
DEFINE TEMP-TABLE ttWork NO-UNDO LIKE {&TempTable}.
CREATE ttWork.
/************************************************************/

/* Propriedades globais para frames ---                     */
&global-define FrameSize    20 By 8
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'TranfMCP'                     At Row 01 Col 01          ~
                             '  Ordem:'                     At Row 02 Col 01          ~
                             ttWork.nr-ord-produ            At Row 02 Col 09 No-label VIEW-AS FILL-IN SIZE 11 BY 0.88 ~
                             'Dep Des:'                     At Row 03 Col 01          ~
                             ttWork.cod-depos-ent           At Row 03 Col 09 No-label ~
                             'Loc Des:'                     At Row 04 Col 01          ~
                             ttWork.cod-localiz-ent         At Row 04 Col 09 NO-LABELS VIEW-AS FILL-IN SIZE 11 BY 0.88
&global-define Frame01Repeat No
/************************************************************/

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'TranfMCP - itens'      At Row 01 Col 01          ~
                             '   Item:'              At Row 02 Col 01          ~
                             ttWork.it-codigo        At Row 02 Col 09 No-label VIEW-AS FILL-IN SIZE 11 BY 0.88 ~
                             '    Ref:'              At Row 03 Col 01          ~
                             ttWork.cod-refer        At Row 03 Col 09 No-label VIEW-AS FILL-IN SIZE 11 BY 0.88 ~
                             'Lot/Ser:'              At Row 04 Col 01          ~
                             ttWork.lote-serie       At Row 04 Col 09 No-label VIEW-AS FILL-IN SIZE 11 BY 0.88 ~
                             '  Depos:'              At Row 05 Col 01          ~
                             ttWork.cod-depos-sai    At Row 05 Col 09 No-label ~
                             'Localiz:'              At Row 06 Col 01          ~
                             ttWork.cod-localiz-sai  At Row 06 Col 09 NO-LABELS VIEW-AS FILL-IN SIZE 11 BY 0.88 ~
                             '   Qtde:'              At Row 07 Col 01          ~
                             ttWork.quantidade       At Row 07 Col 09 NO-LABELS VIEW-AS FILL-IN SIZE 11 BY 0.88
&global-define Frame02Repeat Yes
/************************************************************/


/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.nr-ord-produ ~
                              ttWork.cod-depos-ent ~
                              ttWork.cod-localiz-ent 
                              
&global-define Update02Fields ttWork.it-codigo ~
                              ttWork.cod-refer ~
                              ttWork.lote-serie ~
                              ttWork.cod-depos-sai ~
                              ttWork.cod-localiz-sai ~
                              ttWork.quantidade 

/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01.
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02.
&global-define TriggerAfterFrame01  Run GravaCamposFrame01.
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. ~
                                    Run GravaTransacao.
/************************************************************/

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers 

/************************************************************/

/*****************************************   Frames Fim ******************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï¿½ necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */

/**************************************************************************************************/

/************************************* Codigo do Usuario Inicio ************************************
** Este local ï¿½ destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/

/*************************************************************************************************** 
** Esta procedure esta inicializando o campo estabelecimento da tela Frame01 com o valor 1        **
** Os outros campos nao estao sendo inicializados pois os mesmos devem apresentar valor           **
** caso seja retornado a proxima tela para esta.                                                  **
** Esta procedure eï¿½ executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame01:
   
   ASSIGN ttWork.nr-ord-produ       = 0
          ttWork.cod-depos-ent      = '':U
          ttWork.cod-localiz-ent    = '':U.
           
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame02 com valores em branco              **
** Esta procedure eï¿½ executada pelo pre-processador {&TriggerBeforeFrame02}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame02:
   
   ASSIGN ttWork.it-codigo        = '':U
          ttWork.cod-refer        = '':U
          ttWork.lote-serie       = '':U
          ttWork.cod-depos-sai    = '':U
          ttWork.cod-localiz-sai  = '':U
          ttWork.quantidade       = 0.
          
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01.                                                                              **
** Esta procedure eï¿½ executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
   /* Validacoes Frame 01 Inicio --- */
   ASSIGN vLogErro = NO.
   IF ttWork.nr-ord-produ = 0 THEN DO:
      ASSIGN vLogErro = YES.
      {utp/ut-liter.i C¢digo_da_ordem_deve_ser_informado}
      {bcp/bc9105.i "0" RETURN-VALUE}
   END.
    
   IF vLogErro = YES THEN RETURN ERROR.
   /* Validacoes Frame 01 Fim    --- */
    
   ASSIGN {&TempTable}.nr-ord-produ    = INPUT FRAME Frame01 ttWork.nr-ord-produ
          {&TempTable}.cod-depos-ent   = INPUT FRAME Frame01 ttWork.cod-depos-ent
          {&TempTable}.cod-localiz-ent = INPUT FRAME Frame01 ttWork.cod-localiz-ent.
            
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 02.                                                                              **
** Esta procedure eï¿½ executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame02:
   /* Validacoes Frame 02 Inicio --- */
   ASSIGN vLogErro = NO.
   
   IF ttWork.it-codigo = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "0" "Codigo_do_item_deve_ser_informado!":U}
   END.
   
   IF ttWork.quantidade <= 0 THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "0" "Quantidade_deve_ser_maior_que_zero!":U}
   END.
    
   IF vLogErro = YES THEN
      RETURN ERROR.
      
   /* Validacoes Frame 02 Fim    --- */
   ASSIGN {&TempTable}.it-codigo       = INPUT FRAME Frame02 ttWork.it-codigo
          {&TempTable}.cod-refer       = INPUT FRAME Frame02 ttWork.cod-refer
          {&TempTable}.lote-serie      = INPUT FRAME Frame02 ttWork.lote-serie
          {&TempTable}.cod-depos-sai   = INPUT FRAME Frame02 ttWork.cod-depos-sai
          {&TempTable}.cod-localiz-sai = INPUT FRAME Frame02 ttWork.cod-localiz-sai
          {&TempTable}.quantidade      = INPUT FRAME Frame02 ttWork.quantidade. 
END PROCEDURE.


/*************************************************************************************************** 
** Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure      **
** _GenerateDCTransaction.                                                                        **
** Esta procedure eï¿½ executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
PROCEDURE GravaTransacao:
   DEF VAR vNomeUsuario            AS CHARACTER                NO-UNDO.

   ASSIGN vTransDetail = vTransaction + 
                         " Ordem: ":U       + Trim(STRING({&TempTable}.nr-ord-produ))   +
                         " Item: ":U        + Trim(STRING({&TempTable}.it-codigo))      +
                         " Depos Saida: ":U       + Trim({&TempTable}.cod-depos-sai)    +
                         " Local Saida: ":U       + Trim({&TempTable}.cod-localiz-sai).

   RUN _RetornaUsuario (OUTPUT vNomeUsuario).

   ASSIGN {&TempTable}.data-transacao          = TODAY
          {&TempTable}.cod-serie-documento     = "DC":U
          {&TempTable}.cod-usuario             = vNomeUsuario.

   RAW-TRANSFER {&TempTable} TO vConteudoRaw.

   RUN _GenerateDCTransaction (INPUT vTransaction,            /* Codigo da Transacao                   */
                               INPUT vConteudoRaw,            /* Conteudo da temp-table {&TempTable}   */
                               INPUT vTransDetail,            /* Cabecalho de detalhes da transacao    */
                               INPUT vNomeUsuario).           /* Usuario responsavel pela transacao    */
END PROCEDURE.

FINALLY:
   IF NOT lMenu AND THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
  
   RETURN 'OK':U.
END FINALLY.

/*************************************  Codigo do Usuario Fim   **********************************/

