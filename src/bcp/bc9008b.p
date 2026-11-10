/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9008B 2.00.00.011 } /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i BC9008B MBC}
&ENDIF
/********************************************************************************************
**   Programa..: bc9008b.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - jun/2000 - John Cleber Jaraceski                            **
**                                                                                         **
**   Objetivo..: Template DC Importacao para Aviso de Embarque                             **
**                                                                                         **
**   Includes..: bc9109.i, bc9110.i, bc9111.i, bc9102.i, bcapi001.i, bcapi010.i, bc9008.i  **
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
&global-define ProgramName bc9008
/************************************************************/

/* Definicao da temp-table de integracao ---                */
&global-define TempTable tt-embarque-bc
{bcp/bc9008.i " "}
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
    Assign  {&TempTable}.num-aviso-embarque = DEC(Entry(2,  pTransacao, cDelimitador))
            {&TempTable}.nr-resumo          = Integer(Entry(3,  pTransacao, cDelimitador))    
            {&TempTable}.data-transacao     =    ( if  Entry(4, pTransacao, cDelimitador) <> ""
                                                    then date(Entry(4, pTransacao, cDelimitador))
                                                    else ?)
            {&TempTable}.cod-item           =  String(Entry(5,  pTransacao, cDelimitador))
            {&TempTable}.cod-unico          =  String(Entry(6,  pTransacao, cDelimitador))
            {&TempTable}.cod-refer          =  String(Entry(7,  pTransacao, cDelimitador))
            {&TempTable}.cod-depos          =  String(Entry(8,  pTransacao, cDelimitador))
            {&TempTable}.cod-local          =  String(Entry(9,  pTransacao, cDelimitador))
            {&TempTable}.cod-lote           =  String(Entry(10,  pTransacao, cDelimitador))
            {&TempTable}.dat-valid-lote     =    ( if  Entry(11, pTransacao, cDelimitador) <> ""
                                                    then date(Entry(11, pTransacao, cDelimitador))
                                                    else ?)
            {&TempTable}.cod-usuario        =  String(Entry(12, pTransacao, cDelimitador))
            {&TempTable}.qtd-embarcada      = Decimal(Entry(13, pTransacao, cDelimitador))
            {&TempTable}.chave-unica        =  String(Entry(14, pTransacao, cDelimitador))            
            {&TempTable}.cod-livre-1        =  String(Entry(15, pTransacao, cDelimitador))
            {&TempTable}.cod-livre-2        =  String(Entry(16, pTransacao, cDelimitador))
            {&TempTable}.cod-livre-3        =  String(Entry(17, pTransacao, cDelimitador))
            {&TempTable}.num-livre-1        = Integer(Entry(18, pTransacao, cDelimitador))
            {&TempTable}.num-livre-2        = Integer(Entry(19, pTransacao, cDelimitador))
            {&TempTable}.num-livre-3        = Integer(Entry(20, pTransacao, cDelimitador))
            {&TempTable}.dec-livre-1        = Decimal(Entry(21, pTransacao, cDelimitador))
            {&TempTable}.dec-livre-2        = Decimal(Entry(22, pTransacao, cDelimitador))
            {&TempTable}.dec-livre-3        = Decimal(Entry(23, pTransacao, cDelimitador))
            {&TempTable}.log-livre-1        = ( If  Entry(24, pTransacao, cDelimitador) = "Sim":U
                                                or  Entry(24, pTransacao, cDelimitador) = "Yes":U
                                                or  Entry(24, pTransacao, cDelimitador) = "Si":U
                                                Then Yes Else No)
            {&TempTable}.log-livre-2        = ( If  Entry(25, pTransacao, cDelimitador) = "Sim":U
                                                or  Entry(25, pTransacao, cDelimitador) = "Yes":U
                                                or  Entry(25, pTransacao, cDelimitador) = "Si":U
                                                Then Yes Else No)
            {&TempTable}.log-livre-3        = ( If  Entry(26, pTransacao, cDelimitador) = "Sim":U
                                                or  Entry(26, pTransacao, cDelimitador) = "Yes":U
                                                or  Entry(26, pTransacao, cDelimitador) = "Si":U
                                                Then Yes Else No)
            {&TempTable}.dat-livre-1        =    ( if  Entry(27, pTransacao, cDelimitador) <> ""
                                                    then date(Entry(27, pTransacao, cDelimitador))
                                                    else ?)
            {&TempTable}.dat-livre-2        =    ( if  Entry(28, pTransacao, cDelimitador) <> ""
                                                    then date(Entry(28, pTransacao, cDelimitador))
                                                    else ?)
            {&TempTable}.dat-livre-3        =    ( if  Entry(29, pTransacao, cDelimitador) <> ""
                                                    then date(Entry(29, pTransacao, cDelimitador))
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
    If   {&TempTable}.num-aviso-embarque = 0 Then do:
         Assign vLogErro = Yes.
         {bcp/bc9111.i "0" "Numero do Aviso de Embarque deve ser informado"}
    End.
    If   {&TempTable}.cod-item = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9111.i "0" "Codigo do Item deve ser informado"}
    End.

    If   {&TempTable}.qtd-embarcada = 0 Then do:
         Assign vLogErro = Yes.
         {bcp/bc9111.i "0" "Quantidade deve ser informada"}
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
                          " AvEmb: "   + String({&TempTable}.num-aviso-embarque) +
                          " Res: "     + string({&TempTable}.nr-resumo)          +
                          " Item: "    + Trim({&TempTable}.cod-item)             +
                          " Ref: "     + Trim({&TempTable}.cod-refer)            +
                          " Depos: "   + Trim({&TempTable}.cod-depos)            +
                          " Local: "   + Trim({&TempTable}.cod-local)            +
                          " Lote: "    + Trim({&TempTable}.cod-lote)             +
                          " Qt: "      + String({&TempTable}.qtd-embarcada).
    
    Raw-transfer {&TempTable} To vConteudoRaw.
    
    Run _GenerateDCTransaction (Input vTransaction,  /* Codigo da Transacao                   */
                                Input vConteudoRaw,  /* Conteudo da temp-table {&TempTable}   */
                                Input vTransDetail,  /* Cabecalho de detalhes da transacao    */
                                Input vNomeUsuario). /* Usuario responsavel pela transacao    */
End Procedure.
/*************************************  Codigo do Usuario Fim   **********************************/

