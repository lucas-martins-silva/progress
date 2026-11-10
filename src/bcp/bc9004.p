/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9004 2.00.00.013 } /*** "010013" 09/10/2025 11:26:30 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BC9004 MBC}
&ENDIF

{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */

/********************************************************************************************
**   Programa..: bc9004.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - mai/2000 - Carlos Alberto Soares Pereira                    **
**               2.00.00.001 - jun/2000 - John Cleber Jaraceski                            **
**                                                                                         **
**   Objetivo..: Templates DB Interface para transacao de Requisicao de Materiais          **
**                                                                                         **
**   Includes..: bc9109.p, bc9110.p, bc9111.p, bc9102.p, bcapi001.p, bcapi010.p, bc9004.p  **
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
**                        Ex: tt-requis-mat-bc.                                                   **
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
**                                  When 'Pro' Then Assign ttWork.cod-localiz = 'Pro01'.            **
**                                  When 'Alm' Then Assign ttWork.cod-localiz = 'Alm01'.            **
**                                  When 'Exp' Then Assign ttWork.cod-localiz = 'Exp01'.            **
**                            End.                                                                **
***************************************************************************************************/

/* Definicao global do nome da transacao ---                */
&global-define ProgramName bc9004
/************************************************************/

/* Definicao da temp-table de integracao ---                */
&global-define TempTable tt-requis-mat-bc
{bcp/bc9004.i " "}
{bcp/bc9048.i1} /* definicao variaveis menu padrao */

Define Temp-table ttWork No-Undo like {&TempTable}.
Create ttWork.
/************************************************************/

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    22 By 8
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Req. Materiais 1/3'     At Row 01 Col 01          ~
                             'Req Reser Ord - 1'      At Row 02 Col 01          ~
                             'Dev Reser Ord - 2'      At Row 03 Col 01          ~
                             'Req Ordem     - 3'      At Row 04 Col 01          ~
                             'Dev Req Ordem - 4'      At Row 05 Col 01          ~
                             'Tipo Trans:'            At Row 06 Col 01          ~
                              ttWork.tipo-trans       At Row 06 Col 12 No-Label

&global-define Frame01Repeat No
/************************************************************/

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Req. Materiais 2/3'   At Row 01 Col 01          ~
                             'Estabel.:'            At Row 02 Col 01          ~
                             ttWork.cod-estabel     At Row 02 Col 10 No-Label ~
                             'Ord.Prod:'            At Row 03 Col 01          ~
                             ttWork.nr-ord-produ    At Row 03 Col 10 No-Label ~
                             'Doc:'                 At Row 04 Col 01          ~
                             ttWork.nro-docto       At Row 04 Col 05 No-Label ~
                             'Conta:'               At Row 05 Col 01          ~
                             ttWork.ct-codigo       At Row 06 Col 01 NO-LABEL ~
                             'Centro de Custo:'     At Row 07 Col 01          ~
                             ttWork.sc-codigo       At Row 08 Col 01 NO-LABEL

&global-define Frame02Repeat No
/************************************************************/

/* Definicao da Frame03 ---                                 */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Codigo do Item:'     At Row 01 Col 01          ~
                             ttWork.it-codigo      At Row 02 Col 01 No-Label ~
                             ' Refer:'             At Row 03 Col 01          ~
                             ttWork.cod-refer      At Row 03 Col 08 No-Label ~
                             ' Depos:'             At Row 04 Col 01          ~
                             ttWork.cod-depos      At Row 04 Col 08 No-Label ~
                             ' Local:'             At Row 05 Col 01          ~
                             ttWork.cod-localiz      At Row 05 Col 08 No-Label VIEW-AS FILL-IN SIZE 12 BY 0.88 ~
                             '  Lote:'             At Row 06 Col 01          ~
                             ttWork.lote           At Row 06 Col 08 No-Label FORMAT "x(40)" VIEW-AS FILL-IN SIZE 13 BY 0.88 ~
                             'Dt Vld:'             At Row 07 Col 01          ~
                             ttWork.dt-vali-lote   At Row 07 Col 08 No-Label ~
                             'Quant:'              At Row 08 Col 01          ~
                             ttWork.quantidade     At Row 08 Col 07 No-Label
&global-define Frame03Repeat Yes
/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.tipo-trans

&global-define Update02Fields ttWork.cod-estabel ~
                              ttWork.nr-ord-produ ~
                              ttWork.nro-docto ~
                              ttWork.ct-codigo ~
                              ttWork.sc-codigo
                              
&global-define Update03Fields ttWork.it-codigo      ~
                              ttWork.cod-refer      ~
                              ttWork.cod-depos      ~
                              ttWork.cod-localiz      ~
                              ttWork.lote           ~
                              ttWork.dt-vali-lote   ~
                              ttWork.quantidade 
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
&global-define UserTriggers On Leave of ttWork.it-codigo in Frame Frame03 ~
                            Do: ~
                                Define Variable vCodUnico       As Integer Format '9999999999999999' No-undo. ~
                                Define Variable vCodUnicoChar   As Character                         No-undo. ~
                                ~
                                Assign vCodUnico = Int(ttWork.it-codigo:Screen-value in Frame Frame03) No-error. ~
                                ~
                                Find First Param-Bc No-Lock No-Error. ~
                                If Avail param-bc And param-bc.int-1 <> 1 then ~
                                   Assign vCodUnicoChar = String(vCodUnico). ~
                                   Find first bc-ext-saldo-estoq no-lock ~
                                        where bc-ext-saldo-estoq.it-codigo = vCodUnicoChar No-error. ~
                                ~
                                If Not Avail bc-ext-saldo-estoq And param-bc.int-1 <> 2 Then do: ~
                                   Assign vCodUnicoChar = String(vCodUnico,'9999999999999999'). ~
                                   Find first bc-ext-saldo-estoq no-lock ~
                                        where bc-ext-saldo-estoq.cod-unico = vCodUnicoChar No-error. ~
                                End. ~
                                ~
                                If avail bc-ext-saldo-estoq Then Do: ~
                                   Assign ttWork.it-codigo:Screen-value in Frame Frame03 = bc-ext-saldo-estoq.it-codigo ~
                                          ttWork.cod-depos:Screen-value in Frame Frame03 = bc-ext-saldo-estoq.cod-depos ~
                                          ttWork.cod-localiz:Screen-value in Frame Frame03 = bc-ext-saldo-estoq.cod-localiz ~
                                          ttWork.lote     :Screen-value in Frame Frame03 = bc-ext-saldo-estoq.lote. ~
                                End. ~
                            End. ~
                            On Leave of ttWork.nr-ord-produ in Frame Frame02 ~
                            Do: ~
                                If  Inte(ttWork.nr-ord-produ:Screen-Value in Frame Frame02) = 0 ~
                                Then ~
                                    Assign  ttWork.ct-codigo:Sensitive  in Frame Frame02 = yes  ~
                                            ttWork.sc-codigo:Sensitive  in Frame Frame02 = yes. ~
                                Else ~
                                    Assign  ttWork.ct-codigo:Sensitive  in Frame Frame02 = no  ~
                                            ttWork.sc-codigo:Sensitive  in Frame Frame02 = no. ~
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
** Esta procedure esta inicializando o campo tipo-trans da tela Frame01 com o valor 1             **
** Os outros campos nao estao sendo inicializados pois os mesmos devem apresentar valor           **
** caso seja retornado a proxima tela para esta.                                                  **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame01:

    Assign  ttWork.tipo-trans = 1.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta inicializando o campo estabelecimento da tela Frame02 com o valor 1        **
** Os outros campos nao estao sendo inicializados pois os mesmos devem apresentar valor           **
** caso seja retornado a proxima tela para esta.                                                  **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame02}.                      **
****************************************************************************************************/

Procedure InicializaCamposFrame02:

    Assign  ttWork.nro-docto        = ''
            ttWork.nr-ord-produ     = 0
            ttWork.cod-estabel      = '1'
            ttWork.ct-codigo        = ''
            ttWork.sc-codigo        = ''
            .
End Procedure.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame02 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame02}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame03:
    Assign  ttWork.it-codigo    = ''
            ttWork.cod-refer    = ''
            ttWork.cod-depos    = ''
            ttWork.cod-localiz    = ''
            ttWork.lote         = ''
            ttWork.dt-vali-lote = Today
            ttWork.quantidade   = 0
            .
End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame01:
    /* Validacoes Frame 01 Inicio --- */
    Assign vLogErro = No.
    If   ttWork.tipo-trans < 1 
    or   ttWork.tipo-trans > 4
    Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "0" "As opcoes dispon¡veis sao 1,2,3 e 4"}
    End.

    If   vLogErro = Yes Then Return Error.
    /* Validacoes Frame 01 Fim    --- */

    Assign  {&TempTable}.tipo-trans     = input Frame Frame01 ttWork.tipo-trans.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 02.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame02:
    /* Validacoes Frame 02 Inicio --- */
    Assign vLogErro = No.
    If   ttWork.cod-estabel = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "0" "Codigo do Estabelecimento deve ser informado"}
    End.
    If   vLogErro = Yes Then Return Error.
    /* Validacoes Frame 02 Fim    --- */

    Assign  {&TempTable}.nro-docto      = input Frame Frame02 ttWork.nro-docto
            {&TempTable}.nr-ord-produ   = input Frame Frame02 ttWork.nr-ord-produ
            {&TempTable}.cod-estabel    = input Frame Frame02 ttWork.cod-estabel
            {&TempTable}.ct-codigo      = input Frame Frame02 ttWork.ct-codigo
            {&TempTable}.sc-codigo      = input Frame Frame02 ttWork.sc-codigo
    . 
End Procedure.

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
    If   ttWork.cod-depos = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "0" "Codigo do Deposito deve ser informado"}
    End.
    If   ttWork.quantidade = 0 Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "0" "Quantidade deve ser informada"}
    End.
    If   vLogErro = Yes Then Return Error.
    /* Validacoes Frame 03 Fim    --- */

    Assign  {&temptable}.it-codigo      = input Frame Frame03 ttWork.it-codigo
            {&TempTable}.cod-refer      = input Frame Frame03 ttWork.cod-refer
            {&TempTable}.cod-depos      = input Frame Frame03 ttWork.cod-depos
            {&TempTable}.cod-localiz      = input Frame Frame03 ttWork.cod-localiz
            {&TempTable}.lote           = input Frame Frame03 ttWork.lote
            {&TempTable}.dt-vali-lote   = input Frame Frame03 ttWork.dt-vali-lote
            {&TempTable}.quantidade     = input Frame Frame03 ttWork.quantidade
            . 
End Procedure.

/*************************************************************************************************** 
** Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure      **
** _GenerateDCTransaction.                                                                        **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame03}.                       **
****************************************************************************************************/
Procedure GravaTransacao:
    Def Var vNomeUsuario            As Character                No-undo.

    Assign vTransDetail = vTransaction  + 
                          " Doc: "      + String({&TempTable}.nro-docto)    +
                          " Item: "     + Trim({&temptable}.it-codigo)      +
                          " Ref: "      + Trim({&TempTable}.cod-refer)      +
                          " Depos: "    + Trim({&TempTable}.cod-depos)      +
                          " Local: "    + Trim({&TempTable}.cod-localiz)      +
                          " Lote: "     + Trim({&TempTable}.lote)           +
                          " Qt: "       + String({&TempTable}.quantidade).

    Run _RetornaUsuario (Output vNomeUsuario).

    Assign {&TempTable}.data-transacao  = Today
           {&TempTable}.dt-nf-saida     = Today
           {&TempTable}.cod-usuario     = vNomeUsuario.

    Raw-transfer {&TempTable} To vConteudoRaw.

    Run _GenerateDCTransaction (Input vTransaction,            /* Codigo da Transacao                   */
                                Input vConteudoRaw,            /* Conteudo da temp-table {&TempTable}   */
                                Input vTransDetail,            /* Cabecalho de detalhes da transacao    */
                                Input vNomeUsuario).           /* Usuario responsavel pela transacao    */
End Procedure.

FINALLY:    
   IF NOT lMenu AND THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
  
   RETURN 'OK':U.
END FINALLY.
/*************************************  Codigo do Usuario Fim   **********************************/
