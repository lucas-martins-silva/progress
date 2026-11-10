/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9003B 2.00.00.010 } /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i BC9003B MBC}
&ENDIF
/********************************************************************************************
**   Programa..: bc9003b.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - jun/2000 - John Cleber Jaraceski                            **
**                                                                                         **
**   Objetivo..: Template DC Importacao para Reporte por Ordem                             **
**                                                                                         **
**   Includes..: bc9109.i, bc9110.i, bc9111.i, bc9102.i, bcapi001.i, bcapi010.i, bc9003.i  **
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
**                         Ex: tt-reporte-ordem-bc                                                **
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
&global-define ProgramName bc9003
/************************************************************/

/* Definicao da temp-table de integracao ---                */
&global-define TempTable tt-reporte-ordem-bc
{bcp/bc9003.i " "}
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
    Assign  {&TempTable}.tipo                   = Integer(Entry(2, pTransacao, cDelimitador))
            {&TempTable}.nr-ord-produ           = Integer(Entry(3, pTransacao, cDelimitador))
            {&TempTable}.data                   =    ( if  Entry(4, pTransacao, cDelimitador) <> ""
                                                    then date(Entry(4, pTransacao, cDelimitador))
                                                    else ?)
            {&TempTable}.qt-reporte             = Decimal(Entry(5, pTransacao, cDelimitador))
            {&TempTable}.qt-refugo              = Decimal(Entry(6, pTransacao, cDelimitador))
            {&TempTable}.qt-apr-cond            = Decimal(Entry(7, pTransacao, cDelimitador))
            {&temptable}.it-codigo              =  String(Entry(8, pTransacao, cDelimitador))
            {&TempTable}.un                     =  String(Entry(9, pTransacao, cDelimitador))
            {&TempTable}.nro-docto              =  String(Entry(10, pTransacao, cDelimitador))
            {&TempTable}.serie-docto            =  String(Entry(11, pTransacao, cDelimitador))
            {&TempTable}.cod-depos              =  String(Entry(12, pTransacao, cDelimitador))
            {&TempTable}.cod-localiz            =  String(Entry(13, pTransacao, cDelimitador))
            {&TempTable}.dep-refugo             =  String(Entry(14, pTransacao, cDelimitador))
            {&TempTable}.loc-refugo             =  String(Entry(15, pTransacao, cDelimitador))
            {&TempTable}.lote-serie             =  String(Entry(16, pTransacao, cDelimitador))
            {&TempTable}.cod-refer              =  String(Entry(17, pTransacao, cDelimitador))
            {&TempTable}.dt-vali-lote           =    ( if  Entry(18, pTransacao, cDelimitador) <> ""
                                                    then date(Entry(18, pTransacao, cDelimitador))
                                                    else ?)
            /*Inicio Altera‡äes projeto - 107*/
            {&TempTable}.cod-cta-codigo         =  String(Entry(19, pTransacao, cDelimitador))
            {&TempTable}.cod-ccusto-codigo      =  String(Entry(20, pTransacao, cDelimitador))
            {&TempTable}.cod-cta-refugo         =  String(Entry(21, pTransacao, cDelimitador))         
            {&TempTable}.cod-ccusto-refugo      =  String(Entry(22, pTransacao, cDelimitador))
            {&TempTable}.cod-cta-aplic          =  String(Entry(23, pTransacao, cDelimitador))
            {&TempTable}.cod-ccusto-aplic       =  String(Entry(24, pTransacao, cDelimitador))
            /*Fim Altera‡äes projeto - 107*/
            {&TempTable}.cod-depos-sai          =  String(Entry(25, pTransacao, cDelimitador))
            {&TempTable}.cod-local-sai          =  String(Entry(26, pTransacao, cDelimitador))
            {&TempTable}.op-codigo              = Integer(Entry(27, pTransacao, cDelimitador))
            {&TempTable}.cod-roteiro            =  String(Entry(28, pTransacao, cDelimitador))
            {&temptable}.it-oper                =  String(Entry(29, pTransacao, cDelimitador))
            {&TempTable}.pto-controle           = Integer(Entry(30, pTransacao, cDelimitador))
            {&TempTable}.baixa-reservas         = Integer(Entry(31, pTransacao, cDelimitador))
            {&TempTable}.requis-automatica      = ( If      Entry(32, pTransacao, cDelimitador) = "Sim":U
                                                        or  Entry(32, pTransacao, cDelimitador) = "Yes":U
                                                        or  Entry(32, pTransacao, cDelimitador) = "Si":U
                                                    Then Yes Else No)
            {&TempTable}.finaliza-ordem         = ( If      Entry(33, pTransacao, cDelimitador) = "Sim":U
                                                        or  Entry(33, pTransacao, cDelimitador) = "Yes":U
                                                        or  Entry(33, pTransacao, cDelimitador) = "Si":U
                                                    Then Yes Else No)
            {&TempTable}.finaliza-oper          = ( If      Entry(34, pTransacao, cDelimitador) = "Sim":U
                                                        or  Entry(34, pTransacao, cDelimitador) = "Yes":U
                                                        or  Entry(34, pTransacao, cDelimitador) = "Si":U
                                                    Then Yes Else No)
            {&TempTable}.reserva                = ( If      Entry(35, pTransacao, cDelimitador) = "Sim":U
                                                        or  Entry(35, pTransacao, cDelimitador) = "Yes":U
                                                        or  Entry(35, pTransacao, cDelimitador) = "Si":U
                                                    Then Yes Else No)
            {&TempTable}.nro-ord-seq            = Integer(Entry(36, pTransacao, cDelimitador))
            {&TempTable}.linha                  = Integer(Entry(37, pTransacao, cDelimitador))
            {&TempTable}.ct-refugo              = Integer(Entry(38, pTransacao, cDelimitador))
            {&TempTable}.sc-refugo              = Integer(Entry(39, pTransacao, cDelimitador))
            {&TempTable}.ct-codigo              = Integer(Entry(40, pTransacao, cDelimitador))
            {&TempTable}.sc-codigo              = Integer(Entry(41, pTransacao, cDelimitador))
            {&TempTable}.estado                 =  String(Entry(42, pTransacao, cDelimitador))
            {&TempTable}.data-transacao         =    ( if  Entry(43, pTransacao, cDelimitador) <> ""
                                                    then date(Entry(43, pTransacao, cDelimitador))
                                                    else ?)
            {&TempTable}.cod-unico              =  String(Entry(44, pTransacao, cDelimitador))
            {&TempTable}.cod-usuario            =  String(Entry(45, pTransacao, cDelimitador))
            {&TempTable}.tipo-movto             = Integer(Entry(46, pTransacao, cDelimitador))
            {&TempTable}.cd-mob-dir             =  String(Entry(47, pTransacao, cDelimitador))
            {&TempTable}.gm-codigo              =  String(Entry(48, pTransacao, cDelimitador))
            {&TempTable}.tipo-relogio           = Integer(Entry(49, pTransacao, cDelimitador))
            {&TempTable}.hora-ini               = Integer(Entry(50, pTransacao, cDelimitador))
            {&TempTable}.min-ini                = Integer(Entry(51, pTransacao, cDelimitador))
            {&TempTable}.hora-fim               = Integer(Entry(52, pTransacao, cDelimitador))
            {&TempTable}.min-fim                = Integer(Entry(53, pTransacao, cDelimitador))
            {&TempTable}.tempo-ini              = Decimal(Entry(54, pTransacao, cDelimitador))
            {&TempTable}.tempo-fim              = Decimal(Entry(55, pTransacao, cDelimitador))
            {&TempTable}.tempo                  = Decimal(Entry(56, pTransacao, cDelimitador))
            {&TempTable}.minutos-report         = Integer(Entry(57, pTransacao, cDelimitador))
            {&TempTable}.referencia             =  String(Entry(58, pTransacao, cDelimitador))
            {&TempTable}.matr-func              = Integer(Entry(59, pTransacao, cDelimitador))
            {&TempTable}.op-final               = ( If      Entry(60, pTransacao, cDelimitador) = "Sim":U
                                                        or  Entry(60, pTransacao, cDelimitador) = "Yes":U
                                                        or  Entry(60, pTransacao, cDelimitador) = "Si":U
                                                    Then Yes Else No)
            {&TempTable}.cod-livre-1            =  String(Entry(61, pTransacao, cDelimitador))
            {&TempTable}.cod-livre-2            =  String(Entry(62, pTransacao, cDelimitador))
            {&TempTable}.cod-livre-3            =  String(Entry(63, pTransacao, cDelimitador))
            {&TempTable}.num-livre-1            = Integer(Entry(64, pTransacao, cDelimitador))
            {&TempTable}.num-livre-2            = Integer(Entry(65, pTransacao, cDelimitador))
            {&TempTable}.num-livre-3            = Integer(Entry(66, pTransacao, cDelimitador))
            {&TempTable}.dec-livre-1            = Decimal(Entry(67, pTransacao, cDelimitador))
            {&TempTable}.dec-livre-2            = Decimal(Entry(68, pTransacao, cDelimitador))
            {&TempTable}.dec-livre-3            = Decimal(Entry(69, pTransacao, cDelimitador))
            {&TempTable}.log-livre-1            = ( If      Entry(70, pTransacao, cDelimitador) = "Sim":U
                                                        or  Entry(70, pTransacao, cDelimitador) = "Yes":U
                                                        or  Entry(70, pTransacao, cDelimitador) = "Si":U
                                                    Then Yes Else No)
            {&TempTable}.log-livre-2            = ( If      Entry(71, pTransacao, cDelimitador) = "Sim":U
                                                        or  Entry(71, pTransacao, cDelimitador) = "Yes":U
                                                        or  Entry(71, pTransacao, cDelimitador) = "Si":U
                                                    Then Yes Else No)
            {&TempTable}.log-livre-3            = ( If      Entry(72, pTransacao, cDelimitador) = "Sim":U
                                                        or  Entry(72, pTransacao, cDelimitador) = "Yes":U
                                                        or  Entry(72, pTransacao, cDelimitador) = "Si":U
                                                    Then Yes Else No)
            {&TempTable}.dat-livre-1            =    ( if  Entry(73, pTransacao, cDelimitador) <> ""
                                                    then date(Entry(73, pTransacao, cDelimitador))
                                                    else ?)
            {&TempTable}.dat-livre-2            =    ( if  Entry(74, pTransacao, cDelimitador) <> ""
                                                    then date(Entry(74, pTransacao, cDelimitador))
                                                    else ?)
            {&TempTable}.dat-livre-3            =    ( if  Entry(75, pTransacao, cDelimitador) <> ""
                                                    then date(Entry(75, pTransacao, cDelimitador))
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
    If   {&TempTable}.tipo = 0 Then do:
         Assign vLogErro = Yes.
         {bcp/bc9111.i "0" "Tipo do Reporte deve ser 1-Por Ordem, 2-Por Opera‡Æo, 3-Ponto de Controle"}
    End.
    If   {&TempTable}.nr-ord-produ = 0 Then do:
         Assign vLogErro = Yes.
         {bcp/bc9111.i "0" "Numero do Documento deve ser informado"}
    End.
    If   {&TempTable}.data = ? Then do:
         Assign vLogErro = Yes.
         {bcp/bc9111.i "0" "Data de Fabrica‡Æo deve ser informada"}
    End.
    If   {&TempTable}.cod-depos = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9111.i "0" "Codigo do Deposito Acabado deve ser informado"}
    End.
    If   {&temptable}.it-codigo = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9111.i "0" "Codigo do Item deve ser informado"}
    End.
    If   {&TempTable}.cod-depos-sai = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9111.i "0" "Codigo do Deposito Acabado deve ser informado"}
    End.
    If   {&TempTable}.qt-reporte = 0 Then do:
         Assign vLogErro = Yes.
         {bcp/bc9111.i "0" "Quantidade Apurada deve ser informada"}
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
                          " Doc: "     + String({&TempTable}.nro-docto)     +
                          " Item: "    + Trim({&temptable}.it-codigo)       +
                          " Ref: "     + Trim({&TempTable}.cod-refer)       +
                          " Depos: "   + Trim({&TempTable}.cod-depos-sai)   +
                          " Local: "   + Trim({&TempTable}.cod-local-sai)   +
                          " Qt:"       + String({&TempTable}.qt-reporte).

    If  Avail Param-bc
    And Not Param-bc.Pto-Decimal /* YES-A qtd vem com Ponto Decimal e NO-NÆo    */
    Then
        Assign  {&TempTable}.qt-reporte     = {&TempTable}.qt-reporte   / 10000
                {&TempTable}.qt-refugo      = {&TempTable}.qt-refugo    / 10000
                {&TempTable}.qt-apr-cond    = {&TempTable}.qt-apr-cond  / 10000.

    Raw-transfer {&TempTable} To vConteudoRaw.

    Run _GenerateDCTransaction (Input vTransaction,  /* Codigo da Transacao                   */
                                Input vConteudoRaw,  /* Conteudo da temp-table {&TempTable}   */
                                Input vTransDetail,  /* Cabecalho de detalhes da transacao    */
                                Input vNomeUsuario). /* Usuario responsavel pela transacao    */
End Procedure.
/*************************************  Codigo do Usuario Fim   **********************************/
