/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9003 2.00.00.016 } /*** "010016" 14/03/2024 15:30:15  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i BC9003 MBC}
&ENDIF
/********************************************************************************************
**   Programa..: bc9003.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - mai/2000 - Carlos Alberto Soares Pereira                    **
**               2.00.00.001 - jun/2000 - John Cleber Jaraceski                            **
**                                                                                         **
**   Objetivo..: Template DB Interface para transacao de Reporte por Ordem                 **
**                                                                                         **
**   Includes..: bc9105.i, bc9101.i, bc9100.i, bc9003.i                                    **
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
&global-define ProgramName bc9003
/************************************************************/

/* Definicao da temp-table de integracao ---                */
&global-define TempTable tt-reporte-ordem-bc
{bcp/bc9003.i " "}
DEFINE TEMP-TABLE ttWork NO-UNDO LIKE {&TempTable}.
CREATE ttWork.
/************************************************************/

/* Propriedades globais para frames ---                     */
&global-define FrameSize    20 By 8
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Tipo Reporte:'          At Row 01 Col 01          ~
                             ttWork.tipo              At Row 01 Col 14 No-Label ~
                             '  1-Por Ordem'          At Row 03 Col 01          ~
                             '  2-Por Opera‡Æo'       At Row 04 Col 01          ~
                             '  3-Por PtoControle'    At Row 05 Col 01
&global-define Frame01Repeat No
/************************************************************/

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Reporte'                At Row 01 Col 01          ~
                             'NrOrd:'                 At Row 02 Col 01          ~
                             ttWork.nr-ord-produ      At Row 02 Col 07 No-Label ~
                             'Documento:'             At Row 03 Col 01          ~
                             ttWork.nro-docto         At Row 04 Col 01 No-Label ~
                             'Dep Aca:'               At Row 05 Col 01          ~
                             ttWork.cod-depos         At Row 05 Col 09 No-Label ~
                             'Loc Aca:'               At Row 06 Col 01          ~
                             ttWork.cod-localiz       At Row 06 Col 09 NO-LABEL VIEW-AS FILL-IN SIZE 11 BY 0.88 ~
                             '  Opera:'               At Row 07 Col 01          ~
                             ttWork.op-codigo         At Row 07 Col 09 No-Label ~
                             'PtoCont:'               At Row 08 Col 01          ~
                             ttWork.pto-controle      At Row 08 Col 09 No-Label
&global-define Frame02Repeat No
/************************************************************/

/* Definicao da Frame03 ---                                 */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'C¢digo do Item'        At Row 01 Col 01          ~
                             ttWork.it-codigo        At Row 02 Col 01 No-Label ~
                             'Dep Ori:'              At Row 03 Col 01          ~
                             ttWork.cod-depos-sai    At Row 03 Col 09 No-Label ~
                             'Loc Ori:'              At Row 04 Col 01          ~
                             ttWork.cod-local-sai    At Row 04 Col 09 No-Label VIEW-AS FILL-IN SIZE 11 BY 0.88~
                             'Lot Ori:'              At Row 05 Col 01          ~
                             ttWork.lote-serie       At Row 05 Col 09 No-Label VIEW-AS FILL-IN SIZE 11 BY 0.88~
                             'Dat Val:'              At Row 06 Col 01          ~
                             ttWork.dt-vali-lote     At Row 06 Col 09 No-Label ~
                             'Referen:'              At Row 07 Col 01          ~
                             ttWork.cod-refer        At Row 07 Col 09 No-Label ~
                             'Quant:'                At Row 08 Col 01          ~
                             ttWork.qt-reporte       At Row 08 Col 07 No-Label
&global-define Frame03Repeat Yes
/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.Tipo

&global-define Update02Fields ttWork.nr-ord-produ ~
                              ttWork.nro-docto ~
                              ttWork.cod-depos ~
                              ttWork.cod-localiz ~
                              ttWork.op-codigo When ttWork.Tipo = 2 ~
                              ttWork.pto-controle When ttWork.Tipo = 3

&global-define Update03Fields ttWork.it-codigo ~
                              ttWork.cod-depos-sai ~
                              ttWork.cod-local-sai ~
                              ttWork.lote-serie ~
                              ttWork.dt-vali-lote ~
                              ttWork.cod-refer ~
                              ttWork.qt-reporte

/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01.
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02.
&global-define TriggerBeforeFrame03 Run InicializaCamposFrame03.
&global-define TriggerAfterFrame01  Run GravaCamposFrame01.
&global-define TriggerAfterFrame02  Run GravaCamposFrame02.
&global-define TriggerAfterFrame03  Run GravaCamposFrame03. ~
                                    Run GravaTransacao.
/************************************************************/

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers On Leave of ttWork.nr-ord-produ in Frame Frame02 ~
                            Do: ~
                                Assign  ttWork.nro-docto:screen-value    in frame Frame02 = ~
                                        ttWork.nr-ord-produ:screen-value in frame Frame02. ~
                            End. ~
                            On Leave of ttWork.it-codigo in Frame Frame03 ~
                            Do: ~
                                Define Variable vCodUnico       As Integer Format '9999999999999999' No-undo. ~
                                Define Variable vCodUnicoChar   As Character                         No-undo. ~
                                ~
                                Assign vCodUnico = Int(ttWork.it-codigo:Screen-value in Frame Frame03) No-error. ~
                                ~
                                Assign vCodUnicoChar = String(vCodUnico,'9999999999999999'). ~
                                ~
                                Find first bc-ext-saldo-estoq no-lock ~
                                where bc-ext-saldo-estoq.cod-unico   = vCodUnicoChar No-error. ~
                                If   avail bc-ext-saldo-estoq Then Do: ~
                                     Assign ttWork.it-codigo    :Screen-value in Frame Frame03 = bc-ext-saldo-estoq.it-codigo ~
                                            ttWork.cod-depos-sai:Screen-value in Frame Frame03 = bc-ext-saldo-estoq.cod-depos ~
                                            ttWork.cod-local-sai:Screen-value in Frame Frame03 = bc-ext-saldo-estoq.cod-localiz. ~
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
** Esta procedure esta inicializando os campos da tela Frame01 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame01:
   
   ASSIGN ttWork.Tipo = 1.
   
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame02 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame02}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame02:
   
   ASSIGN ttWork.nro-docto    = ''
          ttWork.nr-ord-produ = 0
          ttWork.cod-depos    = ''
          ttWork.cod-localiz  = ''
          ttWork.op-codigo    = 0
          ttWork.pto-controle = 0.
          
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame03 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame03}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame03:
   
   ASSIGN ttWork.it-codigo     = ''
          ttWork.cod-depos-sai = ''
          ttWork.cod-local-sai = ''
          ttWork.lote-serie    = ''
          ttWork.dt-vali-lote  = TODAY
          ttWork.cod-refer     = ''
          ttWork.qt-reporte    = 0.
          
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
   
   ASSIGN vLogErro = NO.
   
   IF (ttWork.tipo <= 0 OR ttWork.tipo >= 4) THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "0" "Tipo de Reporte fora do Limite. Selecione: 1-Por Ordem, 2-Por Opera‡Æo, 3-Ponto Controle"}
   END.
   
   IF vLogErro = YES THEN
      RETURN ERROR.

   ASSIGN {&TempTable}.tipo = INPUT FRAME Frame01 ttWork.tipo.
   
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 02.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame02:

   ASSIGN vLogErro = NO.
   
   IF ttWork.nr-ord-produ = 0 THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "0" "Numero da Ordem deve ser informado"}
   END.
   
   IF ttWork.cod-depos = "" THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "0" "Codigo do Deposito deve ser informado"}
   END.
   
   IF vLogErro = YES THEN
      RETURN ERROR.

   ASSIGN {&TempTable}.nro-docto    = INPUT FRAME Frame02 ttWork.nro-docto
          {&TempTable}.nr-ord-produ = INPUT FRAME Frame02 ttWork.nr-ord-produ
          {&TempTable}.cod-depos    = INPUT FRAME Frame02 ttWork.cod-depos
          {&TempTable}.cod-localiz  = INPUT FRAME Frame02 ttWork.cod-localiz
          {&TempTable}.op-codigo    = INPUT FRAME Frame02 ttWork.op-codigo
          {&TempTable}.pto-controle = INPUT FRAME Frame02 ttWork.pto-controle.
          
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame03}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame03:
    /* Validacoes Frame 03 Inicio --- */
    Assign vLogErro = No.
    If   ttWork.it-codigo = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "0" "Codigo do Item deve ser informado"}
    End.
    If   ttWork.cod-depos-sai = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "0" "Codigo do Deposito Acabado deve ser informado"}
    End.
    If   ttWork.qt-reporte = 0 Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "0" "Quantidade Reportada deve ser informada"}
    End.
    If   vLogErro = Yes Then Return Error.
    /* Validacoes Frame 03 Fim    --- */

    Assign  {&temptable}.it-codigo      = INPUT FRAME Frame03 ttWork.it-codigo
            {&TempTable}.cod-depos-sai  = INPUT FRAME Frame03 ttWork.cod-depos-sai
            {&TempTable}.cod-local-sai  = INPUT FRAME Frame03 ttWork.cod-local-sai
            {&TempTable}.lote-serie     = INPUT FRAME Frame03 ttWork.lote-serie
            {&TempTable}.dt-vali-lote   = INPUT FRAME Frame03 ttWork.dt-vali-lote
            {&TempTable}.cod-refer      = INPUT FRAME Frame03 ttWork.cod-refer
            {&TempTable}.qt-reporte     = INPUT FRAME Frame03 ttWork.qt-reporte.
             
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure      **
** _GenerateDCTransaction.                                                                        **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
PROCEDURE GravaTransacao:
   
   DEFINE VARIABLE vNomeUsuario AS CHARACTER NO-UNDO.

   ASSIGN vTransDetail = vTransaction + 
                         " Doc: "     + TRIM({&TempTable}.nro-docto)   +
                         " Item: "    + TRIM({&temptable}.it-codigo)   +
                         " Depos: "   + TRIM({&TempTable}.cod-depos)   +
                         " Local: "   + TRIM({&TempTable}.cod-localiz) +
                         " Tipo: "    + STRING({&TempTable}.tipo)      +
                         " Qtd:"      + STRING({&TempTable}.qt-reporte).

   RUN _RetornaUsuario (OUTPUT vNomeUsuario).

   ASSIGN {&TempTable}.data           = TODAY
          {&TempTable}.data-transacao = TODAY
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

