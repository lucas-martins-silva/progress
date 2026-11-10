/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/********************************************************************************************
**   Programa..: bc9008.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - jun/2000 - John Cleber Jaraceski                            **
**                                                                                         **
**   Objetivo..: Template DB Interface para transacao de Aviso de Embarque                 **
**                                                                                         **
**   Includes..: bc9105.i, bc9101.i, bc9100.i, bc9008.i                                    **
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
**                        Ex: tt-transfere-bc.                                                    **
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
**                        OBS. Nao deve conter formatacao. Ex. ttWork.cod-item no-label.         **
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
***************************************************************************************************/

/* Definicao global do nome da transacao ---                */
&global-define ProgramName bc9008
/************************************************************/

/* Definicao da temp-table de integracao ---                */
&global-define TempTable tt-embarque-bc
{bcp/bc9008.i " "}              
DEFINE TEMP-TABLE ttWork NO-UNDO LIKE {&TempTable}.
CREATE ttWork.
/************************************************************/

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Aviso Embarque 1/2'      At Row 01 Col 01          ~
                             'Embarque:'               At Row 02 Col 01          ~
                             ttWork.num-aviso-embarque At Row 03 Col 01 No-Label ~
                             'Resumo:'                 At Row 04 Col 01          ~
                             ttWork.nr-resumo          At Row 05 Col 01 No-Label 
&global-define Frame01Repeat  No
/************************************************************/

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Aviso Embarque 2/2' At Row 01 Col 01          ~
                             'Codigo do Item:'    At Row 02 Col 01          ~
                             ttWork.cod-item      At Row 03 Col 01 No-label ~
                             'Refer:'             At Row 04 Col 01          ~
                             ttWork.cod-refer     At Row 04 Col 07 No-label ~
                             'Depos:'             At Row 05 Col 01          ~
                             ttWork.cod-depos     At Row 05 Col 07 No-label ~
                             'Local:'             At Row 06 Col 01          ~
                             ttWork.cod-local     At Row 06 Col 07 No-label VIEW-AS FILL-IN SIZE 13 BY 0.88 ~
                             ' Lt:'               At Row 07 Col 01          ~
                             ttWork.cod-lote      At Row 07 Col 04 NO-LABEL FORMAT "x(40)" VIEW-AS FILL-IN SIZE 16 BY 0.88 ~
                             '  Qtd:'             At Row 08 Col 01          ~
                             ttWork.qtd-embarcada At Row 08 Col 07 No-label 
&global-define Frame02Repeat Yes
/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.num-aviso-embarque ~
                              ttWork.nr-resumo            
&global-define Update02Fields ttWork.cod-item ~
                              ttWork.cod-refer ~
                              ttWork.cod-depos ~
                              ttWork.cod-local ~
                              ttWork.cod-lote ~
                              ttWork.qtd-embarcada
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. 
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. ~
                                    Run GravaTransacao.
/************************************************************/

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers On Leave of ttWork.cod-item in Frame Frame02 ~
                            Do: ~
                                Define Variable vCodUnico       As Integer Format '9999999999999999' No-undo. ~
                                Define Variable vCodUnicoChar   As Character                         No-undo. ~
                                ~
                                Assign vCodUnico = Int(ttWork.cod-item:Screen-value in Frame Frame02) No-error. ~
                                ~
                                Assign vCodUnicoChar = String(vCodUnico,'9999999999999999'). ~
                                ~
                                Find first bc-ext-saldo-estoq no-lock ~
                                where bc-ext-saldo-estoq.cod-unico   = vCodUnicoChar No-error. ~
                                If   avail bc-ext-saldo-estoq Then Do: ~
                                     Assign ttWork.cod-item :Screen-value in Frame Frame02 = bc-ext-saldo-estoq.it-codigo ~
                                            ttWork.cod-depos:Screen-value in Frame Frame02 = bc-ext-saldo-estoq.cod-depos ~
                                            ttWork.cod-local:Screen-value in Frame Frame02 = bc-ext-saldo-estoq.cod-localiz ~
                                            ttWork.cod-lote :Screen-value in Frame Frame02 = bc-ext-saldo-estoq.lote. ~
                                End. ~
                             End ~
                             .


/************************************************************/

/*****************************************   Frames Fim ******************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Gerador de transa‡Æo do coleta de dados          */

/**************************************************************************************************/

/************************************* Codigo do Usuario Inicio ************************************
** Este local ‚ destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/

/*************************************************************************************************** 
** Esta procedure esta inicializando o campo estabelecimento da tela Frame01 com o valor 1        **
** Os outros campos nao estao sendo inicializados pois os mesmos devem apresentar valor           **
** caso seja retornado a proxima tela para esta.                                                  **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame01:
   
   ASSIGN ttWork.num-aviso-embarque = 0
          ttWork.nr-resumo          = 0.
          
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame02 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame02}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame02:
   
   ASSIGN ttWork.cod-item      = ''
          ttWork.cod-refer     = ''
          ttWork.cod-depos     = ''
          ttWork.cod-local     = ''
          ttWork.cod-lote      = ''
          ttWork.qtd-embarcada = 0.
          
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:

   ASSIGN vLogErro = NO.
    
   IF ttWork.num-aviso-embarque = 0 THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "0" "Numero do Aviso de Embarque deve ser informado"}
   END.

   IF ttWork.nr-resumo = 0 THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "0" "Numero do Resumo do Embarque deve ser informado"}
   END.

   IF vLogErro = YES THEN
      RETURN ERROR.

   ASSIGN {&TempTable}.num-aviso-embarque = INPUT FRAME Frame01 ttWork.num-aviso-embarque
          {&TempTable}.nr-resumo          = INPUT FRAME Frame01 ttWork.nr-resumo.
          
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 02.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame02:

   ASSIGN vLogErro = NO.
   
   IF ttWork.cod-item = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "0" "Codigo do Item deve ser informado"}
   END.

   IF ttWork.qtd-embarcada = 0 THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "0" "Quantidade deve ser informada"}
   END.

   IF vLogErro = YES THEN
      RETURN ERROR.

   ASSIGN {&TempTable}.cod-item      = INPUT FRAME Frame02 ttWork.cod-item
          {&TempTable}.cod-refer     = INPUT FRAME Frame02 ttWork.cod-refer
          {&TempTable}.cod-depos     = INPUT FRAME Frame02 ttWork.cod-depos
          {&TempTable}.cod-local     = INPUT FRAME Frame02 ttWork.cod-local
          {&TempTable}.cod-lote      = INPUT FRAME Frame02 ttWork.cod-lote
          {&TempTable}.qtd-embarcada = INPUT FRAME Frame02 ttWork.qtd-embarcada.
          
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure      **
** _GenerateDCTransaction.                                                                        **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
PROCEDURE GravaTransacao:
   
   DEFINE VARIABLE vNomeUsuario AS CHARACTER NO-UNDO.

   ASSIGN vTransDetail = vTransaction + 
                         " AvEmb: "   + STRING({&TempTable}.num-aviso-embarque) +
                         " Res: "     + STRING({&TempTable}.nr-resumo)          +  
                         " Item: "    + TRIM({&TempTable}.cod-item)             +
                         " Ref: "     + TRIM({&TempTable}.cod-refer)            +
                         " Depos: "   + TRIM({&TempTable}.cod-depos)            +
                         " Local: "   + TRIM({&TempTable}.cod-local)            +
                         " Lote: "    + TRIM({&TempTable}.cod-lote)             +
                         " Qt: "      + STRING({&TempTable}.qtd-embarcada).

   RUN _RetornaUsuario (OUTPUT vNomeUsuario).

   ASSIGN {&TempTable}.data-transacao = TODAY
          {&TempTable}.cod-usuario    = vNomeUsuario.

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

