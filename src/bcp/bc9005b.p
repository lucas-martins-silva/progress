/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9005B 2.00.00.010 } /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i BC9005B MBC}
&ENDIF
/********************************************************************************************
**   Programa..: bc9005b.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - Dez/2006 - Amarildo Gambeta                                 **
**                                                                                         **
**   Objetivo..: Template DC Importacao para Nova Transferencia de Materiais               **
**                                                                                         **
********************************************************************************************/

/***************************************************************************************************
** SECAO DE PRE-PROCESSADORES DA TEMPLATE                                                         **
** Nesta secao sao definidos os pre-processadores que serao usados na montagem da interface.      **
**                                                                                                **
** DESCRICAO DOS PREPROCESSADORES:                                                                **
** ProgramName           - Nome do programa e, tambem, do Codigo da transacao do Data Collection  **
**                         que sera acionada pela interface.                                      **
** TempTable             - Nome da Temp-Table da transacao de negocio para comunicacao com ERP.   **
**                         Ex: tt-transfere-bc.                                                   **
** TriggerBeforeTransfer - Gatilho para ser executado antes da transferencia dos dados do         **
**                         parametro pTransacao para a temp-table {&TempTable}.                   **
**                         Apos a execucao deste gatilho automaticamente sera executada a         **
**                         a procedure TranfereDados.                                             **
** TriggerAfterTransfer  - Gatilho para ser executado apos a transferencia dos dados do parametro **
**                         pTransacao para a temp-table {&TempTable}. Apos a execucao deste       **
**                         gatilho automaticamente sera executada a procedure GravaTransacao. Na  **
**                         procedure GravaTransacao deve existir uma chamada a procedure          **
**                         _GenerateDCTransaction que eï responsavel por gerar a transacao no     **
**                         Coleta de Dados.                                                       **
***************************************************************************************************/

/* Definicao global do nome da transacao ---                */
&global-define ProgramName bc9005
/************************************************************/

/* Definicao da temp-table de integracao ---                */
&global-define TempTable tt-transfere-bc
{bcp/bc9005.i " "}
/************************************************************/

/* Definicao da temp-table tt-trans ---                     */
{bcp/bcapi001.i}
/************************************************************/

/* Definicao da temp-table tt-bc-tipo-trans ---             */
{bcp/bcapi010.i}
/************************************************************/

/* Definicao da temp-table tt-erro ---                      */
{bcp/bc9102.i}
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeTransfer
&global-define TriggerAfterTransfer Run ValidaCamposTempTable. ~
                                    Run GravaTransacao.

/* Definicao de parametros ---                              */
Define  Input Parameter pColetor   As Rowid     No-undo.
Define  Input Parameter pTransacao As Character No-Undo.
Define Output Parameter Table For tt-erro{&Ext}.
/************************************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/

{bcp/bc9109.i} /* Transferencia dos dados do parametro pTransacao para a temp-table {&TempTable} */
{bcp/bc9110.i} /* Gerador de transa‡Æo do coleta de dados                                        */

/**************************************************************************************************/

/************************************* Codigo do Usuario Inicio ************************************
** Este local ‚ destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/

/*************************************************************************************************** 
** Esta procedure transfere os dados do parametro pTransacao para os respectivos campos da        **
** temp-table {&TempTable}. Vale ressaltar que o parametro pTransacao utiliza como delimitador    **
** esta definido nos Parametrosa do M¢dulo.                                                       **
** Esta procedure eï executada automaticamente apos o gatilho {&TriggerBeforeTransfer}.           **
****************************************************************************************************/
Procedure TransfereDados:

    Assign  {&TempTable}.cod-estabel                =  String(Entry(2,  pTransacao, cDelimitador))
            {&TempTable}.num-documento              =  String(Entry(3,  pTransacao, cDelimitador))
            {&TempTable}.cod-serie-documento        =  String(Entry(4,  pTransacao, cDelimitador))
            {&TempTable}.num-especie-documento      = Integer(Entry(5,  pTransacao, cDelimitador))
            {&TempTable}.data-transacao             = ( if  Entry(6, pTransacao, cDelimitador) <> ""
                                                    then date(Entry(6, pTransacao, cDelimitador))
                                                    else ?)
            {&TempTable}.cod-item                   =  String(Entry(7,  pTransacao, cDelimitador))
            {&TempTable}.cod-unico                  =  String(Entry(8,  pTransacao, cDelimitador))
            {&TempTable}.cod-refer-origem           =  String(Entry(9,  pTransacao, cDelimitador))
            {&TempTable}.cod-refer-destino          =  String(Entry(10, pTransacao, cDelimitador))
            {&TempTable}.cod-depos-origem           =  String(Entry(11, pTransacao, cDelimitador))
            {&TempTable}.cod-depos-destino          =  String(Entry(12, pTransacao, cDelimitador))
            {&TempTable}.cod-local-origem           =  String(Entry(13, pTransacao, cDelimitador))
            {&TempTable}.cod-local-destino          =  String(Entry(14, pTransacao, cDelimitador))
            {&TempTable}.cod-lote-origem            =  String(Entry(15, pTransacao, cDelimitador))
            {&TempTable}.cod-lote-destino           =  String(Entry(16, pTransacao, cDelimitador))
            {&TempTable}.dat-valid-lote-origem      = ( if  Entry(17, pTransacao, cDelimitador) <> ""
                                                    then date(Entry(17, pTransacao, cDelimitador))
                                                    else ?)
            {&TempTable}.dat-valid-lote-destino     = ( if  Entry(18, pTransacao, cDelimitador) <> ""
                                                    then date(Entry(18, pTransacao, cDelimitador))
                                                    else ?)
            {&TempTable}.cod-usuario                =  String(Entry(19, pTransacao, cDelimitador))
            {&TempTable}.qtd-movimento              = Decimal(Entry(20, pTransacao, cDelimitador))
            {&TempTable}.ct-codigo                  =  String(Entry(21, pTransacao, cDelimitador))
            {&TempTable}.sc-codigo                  =  String(Entry(22, pTransacao, cDelimitador))
            {&TempTable}.num-sequencia              = Integer(Entry(23, pTransacao, cDelimitador))
            {&TempTable}.un                         =  String(Entry(24, pTransacao, cDelimitador))
            {&TempTable}.cod-livre-1                =  String(Entry(25, pTransacao, cDelimitador))
            {&TempTable}.cod-livre-2                =  String(Entry(26, pTransacao, cDelimitador))
            {&TempTable}.cod-livre-3                =  String(Entry(27, pTransacao, cDelimitador))
            {&TempTable}.num-livre-1                = Integer(Entry(28, pTransacao, cDelimitador))
            {&TempTable}.num-livre-2                = Integer(Entry(29, pTransacao, cDelimitador))
            {&TempTable}.num-livre-3                = Integer(Entry(30, pTransacao, cDelimitador))
            {&TempTable}.dec-livre-1                = Decimal(Entry(31, pTransacao, cDelimitador))
            {&TempTable}.dec-livre-2                = Decimal(Entry(32, pTransacao, cDelimitador))
            {&TempTable}.dec-livre-3                = Decimal(Entry(33, pTransacao, cDelimitador))
            {&TempTable}.log-livre-1                = ( If  Entry(34, pTransacao, cDelimitador) = "Sim":U
                                                        or  Entry(34, pTransacao, cDelimitador) = "Yes":U
                                                        or  Entry(34, pTransacao, cDelimitador) = "Si":U
                                                        Then Yes Else No)
            {&TempTable}.log-livre-1                = ( If  Entry(35, pTransacao, cDelimitador) = "Sim":U
                                                        or  Entry(35, pTransacao, cDelimitador) = "Yes":U
                                                        or  Entry(35, pTransacao, cDelimitador) = "Si":U
                                                        Then Yes Else No)
            {&TempTable}.log-livre-1                = ( If  Entry(36, pTransacao, cDelimitador) = "Sim":U
                                                        or  Entry(36, pTransacao, cDelimitador) = "Yes":U
                                                        or  Entry(36, pTransacao, cDelimitador) = "Si":U
                                                        Then Yes Else No)
            {&TempTable}.dat-livre-1            =    ( if  Entry(37, pTransacao, cDelimitador) <> ""
                                                    then date(Entry(37, pTransacao, cDelimitador))
                                                    else ?)
            {&TempTable}.dat-livre-2            =    ( if  Entry(38, pTransacao, cDelimitador) <> ""
                                                    then date(Entry(38, pTransacao, cDelimitador))
                                                    else ?)
            {&TempTable}.dat-livre-3            =    ( if  Entry(39, pTransacao, cDelimitador) <> ""
                                                    then date(Entry(39, pTransacao, cDelimitador))
                                                    else ?)
            no-error.

    /*** Trata Erros ocorridos na Atribui‡Æo dos Valores nos Campos ***/
    {bcp/bc9111.i1}

End Procedure.

/*************************************************************************************************** 
** Esta procedure valida os dados armazenados na temp-table {&TempTable}, ja que os dados do      **
** parametro pTransacao jaï foram transferidos para a temp-table.                                 **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterTransfer}.                      **
****************************************************************************************************/
Procedure ValidaCamposTempTable:

    /* Validacoes Inicio --- */
    Assign vLogErro = No.
    If   {&TempTable}.cod-estabel = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9111.i "0" "Codigo do estabelecimento deve ser informado!"}
    End.
    If   {&TempTable}.num-documento = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9111.i "0" "Numero do eocumento deve ser informado!"}
    End.
    If   {&TempTable}.cod-depos-origem = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9111.i "0" "Codigo do deposito deve ser informado!"}
    End.
    If   {&TempTable}.cod-depos-destino = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9111.i "0" "Codigo do deposito de destino deve ser informado!"}
    End.
    If   {&TempTable}.cod-item = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9111.i "0" "Codigo do Item deve ser informado!"}
    End.
    If   {&TempTable}.qtd-movimento = 0 Then do:
         Assign vLogErro = Yes.
         {bcp/bc9111.i "0" "Quantidade deve ser informada!"}
    End.

    If   vLogErro = Yes Then Return Error.

    /* Validacoes Fim    --- */
End Procedure.

/*************************************************************************************************** 
** Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure      **
** _GenerateDCTransaction.                                                                        **
** Esta procedure eï automaticamente apos a execucao do gatilho {&TriggerAfterTransfer}.          **
****************************************************************************************************/
Procedure GravaTransacao:
    Def Var vTransDetail As Character No-undo.
    Def var vConteudoRaw As Raw       No-undo.

    Assign vTransDetail = vTransaction + 
                          " Doc: "     + String({&TempTable}.num-documento)   +
                          " Item: "    + Trim({&TempTable}.cod-item)          +
                          " Ref: "     + Trim({&TempTable}.cod-refer-origem)  +
                          " Depos: "   + Trim({&TempTable}.cod-depos-destino) +
                          " Local: "   + Trim({&TempTable}.cod-local-destino) +
                          " Lote: "    + Trim({&TempTable}.cod-lote-destino)  +
                          " Qt: "      + String({&TempTable}.qtd-movimento).

    If  Avail Param-bc
    And Not Param-bc.Pto-Decimal /* YES-A qtd vem com Ponto Decimal e NO-NÆo    */
    Then
        Assign  {&TempTable}.qtd-movimento = {&TempTable}.qtd-movimento / 10000.


    Raw-transfer {&TempTable} To vConteudoRaw.

    Run _GenerateDCTransaction (Input vTransaction,  /* Codigo da Transacao                   */
                                Input vConteudoRaw,  /* Conteudo da temp-table {&TempTable}   */
                                Input vTransDetail,  /* Cabecalho de detalhes da transacao    */
                                Input vNomeUsuario). /* Usuario responsavel pela transacao    */
End Procedure.
/*************************************  Codigo do Usuario Fim   **********************************/

