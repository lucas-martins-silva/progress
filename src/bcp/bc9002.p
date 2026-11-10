/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/********************************************************************************************
**   Programa..: bc9002.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - mai/2000 - Carlos Alberto Soares Pereira                    **
**               2.00.00.001 - jun/2000 - John Cleber Jaraceski                            **
**                                                                                         **
**   Objetivo..: Template DB Interface para transacao de Reporte por Contagem Ciclica      **
**                                                                                         **
**   Includes..: bc9105.i, bc9101.i, bc9100.i, bc9002.i                                    **
**                                                                                         **
********************************************************************************************/
{include/i-prgvrs.i BC9002 2.00.00.004 } /*** "010004" 14/03/2024 11:42:46 ***/
/***************************************************************************************************
** SECAO DE PRE-PROCESSADORES DA TEMPLATE                                                         **
** Nesta secao sao definidos os pre-processadores que serao usados na montagem da interface.      **
**                                                                                                **
** DESCRICAO DOS PREPROCESSADORES:                                                                **
** ProgramName          - Nome do programa e, tambem, do Codigo da transacao do Data Collection   **
**                        que sera acionada pela interface.                                       **
** TempTable            - Nome da Temp-Table da transacao de negocio para comunicacao com ERP.    **
**                        Ex: tt-contagem-bc.                                                     **
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
***************************************************************************************************/

/* Definicao global do nome da transacao ---                */
&global-define ProgramName bc9002
/************************************************************/

/* Definicao da temp-table de integracao ---                */
&global-define TempTable tt-contagem-bc
{bcp/bc9002.i " "}
Define Temp-table ttWork No-Undo Like {&TempTable}.
Create ttWork.
/************************************************************/

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Contagem 1/2'              At Row 01 Col 01          ~
                             '  Estab:'                  At Row 02 Col 01          ~
                             ttWork.cod-estabel          At Row 02 Col 09 No-Label ~
                             'N.Ficha:'                  At Row 03 Col 01          ~
                             ttWork.num-ficha-inventario At Row 03 Col 09 No-Label ~
                             'Nr.Cont:'                  At Row 04 Col 01          ~
                             ttWork.num-contagem         At Row 04 Col 09 No-Label ~
                             'Dt Cort:'                  At Row 05 Col 01          ~
                             ttWork.dat-contagem         At Row 05 Col 09 No-Label
&global-define Frame01Repeat  No
/************************************************************/

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Contagem 2/2'          At Row 01 Col 01          ~
                             'Codigo do Item:'       At Row 02 Col 01          ~
                             ttWork.cod-item         At Row 03 Col 01 No-Label ~
                             'Refer:'                At Row 04 Col 01          ~
                             ttWork.cod-refer        At Row 04 Col 07 No-Label ~
                             'Depos:'                At Row 05 Col 01          ~
                             ttWork.cod-depos        At Row 05 Col 07 No-Label ~
                             'Local:'                At Row 06 Col 01          ~
                             ttWork.cod-local        At Row 06 Col 07 No-Label VIEW-AS FILL-IN SIZE 13 BY 0.88 ~
                             ' Lote:'                At Row 07 Col 01          ~
                             ttWork.cod-lote         At Row 07 Col 07 No-Label FORMAT "x(40)" VIEW-AS FILL-IN SIZE 13 BY 0.88 ~
                             'Quant:'                At Row 08 Col 01          ~
                             ttWork.qtd-apontada     At Row 08 Col 07 No-Label
&global-define Frame02Repeat Yes
/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-estabel ~
                              ttWork.num-ficha-inventario ~
                              ttWork.num-contagem ~
                              ttWork.dat-contagem
&global-define Update02Fields ttWork.cod-item ~
                              ttWork.cod-refer ~
                              ttWork.cod-depos ~
                              ttWork.cod-local ~
                              ttWork.cod-lote ~
                              ttWork.qtd-apontada
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
                                     Assign ttWork.cod-item        :Screen-value in Frame Frame02 = bc-ext-saldo-estoq.it-codigo ~
                                            ttWork.cod-depos:Screen-value in Frame Frame02 = bc-ext-saldo-estoq.cod-depos ~
                                            ttWork.cod-local:Screen-value in Frame Frame02 = bc-ext-saldo-estoq.cod-localiz ~
                                            ttWork.cod-lote :Screen-value in Frame Frame02 = bc-ext-saldo-estoq.lote. ~
                                End. ~
                             End.

/************************************************************/

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
** Esta procedure esta inicializando o campo estabelecimento da tela Frame01 com o valor 1        **
** Os outros campos nao estao sendo inicializados pois os mesmos devem apresentar valor           **
** caso seja retornado a proxima tela para esta.                                                  **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame01:
   
   ASSIGN ttWork.cod-estabel          = '1'
          ttWork.num-ficha-inventario = 0
          ttWork.num-contagem         = 1
          ttWork.dat-contagem         = TODAY.
          
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame02 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame02}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame02:
   
   ASSIGN ttWork.cod-item     = ''
          ttWork.cod-refer    = ''
          ttWork.cod-depos    = ''
          ttWork.cod-local    = ''
          ttWork.cod-lote     = ''
          ttWork.qtd-apontada = 0.
          
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
   
   ASSIGN vLogErro = NO.
   
   IF ttWork.num-contagem <= 0 AND ttWork.num-contagem >= 4 THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "0" "Numero da Contagem informado fora do permitido (1,2,3)"}
   END.

   IF ttWork.cod-estabel = "" THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "0" "Codigo do Estabelecimento deve ser informado"}
   END.

   IF ttWork.dat-contagem = ? THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "0" "Data de Fabricacao deve ser informada"}
   END.

   IF vLogErro = YES THEN
      RETURN ERROR.

   ASSIGN {&TempTable}.num-ficha-inventario = INPUT FRAME Frame01 ttWork.num-ficha-inventario
          {&TempTable}.num-contagem         = INPUT FRAME Frame01 ttWork.num-contagem
          {&TempTable}.cod-estabel          = INPUT FRAME Frame01 ttWork.cod-estabel
          {&TempTable}.dat-contagem         = INPUT FRAME Frame01 ttWork.dat-contagem.
           
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 02.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame02:
   
   ASSIGN vLogErro = NO.
   
   IF ttWork.cod-item = "" THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "0" "Codigo do Item deve ser informado"}
   END.
   
   IF ttWork.cod-depos = "" THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "0" "Codigo do Deposito deve ser informado"}
   END.
   
   If ttWork.qtd-apontada = 0 THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "0" "Quantidade deve ser informada"}
   END.

   IF vLogErro = YES THEN
      RETURN ERROR.

   ASSIGN {&TempTable}.cod-item     = INPUT FRAME Frame02 ttWork.cod-item
          {&TempTable}.cod-refer    = INPUT FRAME Frame02 ttWork.cod-refer
          {&TempTable}.cod-depos    = INPUT FRAME Frame02 ttWork.cod-depos
          {&TempTable}.cod-local    = INPUT FRAME Frame02 ttWork.cod-local
          {&TempTable}.cod-lote     = INPUT FRAME Frame02 ttWork.cod-lote
          {&TempTable}.qtd-apontada = INPUT FRAME Frame02 ttWork.qtd-apontada.
             
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure      **
** _GenerateDCTransaction.                                                                        **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
PROCEDURE GravaTransacao:
   
   DEFINE VARIABLE vNomeUsuario AS CHARACTER NO-UNDO.

   ASSIGN vTransDetail = vTransaction + " Doc: "     + STRING({&TempTable}.num-ficha-inventario)  +
                                        " Item: "    + TRIM({&TempTable}.cod-item)                +
                                        " Ref: "     + TRIM({&TempTable}.cod-refer)               +
                                        " Depos: "   + TRIM({&TempTable}.cod-depos)               +
                                        " Local: "   + TRIM({&TempTable}.cod-local)               +
                                        " Lote: "    + TRIM({&TempTable}.cod-lote)                +
                                        " Qt:"       + STRING({&TempTable}.qtd-apontada).

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



