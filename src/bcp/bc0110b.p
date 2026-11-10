/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0110B 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc0110b MBC}
&ENDIF


/********************************************************************************************
**   Programa..: bc0110b.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - jun/2000 - John Cleber Jaraceski                            **
**                                                                                         **
**   Objetivo..: Template DC Importacao para Etiqueta Bidimensional                        **
**                                                                                         **
**   Includes..: bc9109.i, bc9110.i, bc9111.i, bc9102.i, bcapi001.i, bcapi010.i, bc9001.i  **
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
&global-define ProgramBC0110B
/************************************************************/

/* Definicao da temp-table de integracao ---                */

DEF TEMP-TABLE tt-etiqueta2d NO-UNDO
    FIELD sequencia    AS INT
    FIELD nome-abrev   AS CHAR
    FIELD cgc          AS CHAR
    FIELD cod-emitente AS INT    
    FIELD conteudo     AS CHAR
    FIELD cod-usuario  AS CHAR
    FIELD data-transacao AS DATE
    FIELD tipo-etiq      AS INT
    INDEX id IS PRIMARY sequencia.

&global-define TempTable tt-etiqueta2d
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

/* ConversÆo tt-campos para XML - tt-xml para bcapi017 */
{bcp/bcapi017.i}        

/* Decodifica‡Æo da String 2d - tt-campos para bcapi019 */
{bcp/bcapi019.i}

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
{bcp/bc9110.i1} /* Gerador de transa‡Æo do coleta de dados                                       */

/**************************************************************************************************/

/************************************* Codigo do Usuario Inicio ************************************
** Este local ‚ destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/
/* Includes para DBOïs */
{clbo/bocl029.i tt-emitente-etiqueta}

/* Defini‡äes das procedures para integra‡Æo com o Magnus i.00 */
{bcp/bcproxy.i2}

/*************************************************************************************************** 
** Esta procedure transfere os dados do parametro pTransacao para os respectivos campos da        **
** temp-table {&TempTable}. Vale ressaltar que o parametro pTransacao utiliza como delimitador    **
** esta definido nos Parametrosa do M¢dulo.                                                       **
** Esta procedure eï executada automaticamente apos o gatilho {&TriggerBeforeTransfer}.           **
****************************************************************************************************/
Procedure TransfereDados:
def var i-posicao as int.


    Assign  {&TempTable}.cgc                        =  String(Entry(2,  pTransacao, cDelimitador))
            {&TempTable}.nome-abrev                 =  String(Entry(3,  pTransacao, cDelimitador))
            {&TempTable}.cod-emitente               =  int(String(Entry(4,  pTransacao, cDelimitador)))            
            
            i-posicao                               =(  length(  String(Entry(1,  pTransacao, cDelimitador))
                                                               + String(Entry(2,  pTransacao, cDelimitador))
                                                               + String(Entry(3,  pTransacao, cDelimitador))
                                                               + String(Entry(4,  pTransacao, cDelimitador)))
                                                      + (length(cDelimitador) * 4)
                                                      + 1)
            {&TempTable}.conteudo                   =  Substring(pTransacao,i-posicao)                                                                                                              
            no-error.

End Procedure.

/*************************************************************************************************** 
** Esta procedure valida os dados armazenados na temp-table {&TempTable}, ja que os dados do      **
** parametro pTransacao jaï foram transferidos para a temp-table.                                 **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterTransfer}.                      **
****************************************************************************************************/
Procedure ValidaCamposTempTable:

    /* Validacoes Inicio --- */
    Assign vLogErro = No.

    if  {&TempTable}.nome-abrev   <> "" 
    or  {&TempTable}.cgc          <> ""
    or  {&TempTable}.cod-emitente <> 0
    then do:
    
        run pi-verifica-emitente    ( input {&TempTable}.nome-abrev,
                                      input {&TempTable}.nome-abrev,
                                      input 0,    /* Codigo do Emitente               */
                                      input 0,    /* Codigo do Emitente               */
                                      input 5,    /* Tipo de Acesso 0=Currente ....   */
                                      input 2).   /* Record-Frase = 2 (cgc)*/
        
        if  NOT AVAIL ttemitente THEN DO:        
        
            IF  {&TempTable}.cod-emitente > 0 THEN DO:
        
                run pi-verifica-emitente    ( input "",
                                              input "",
                                              input {&TempTable}.cod-emitente,    /* Codigo do Emitente               */
                                              input {&TempTable}.cod-emitente,    /* Codigo do Emitente               */
                                              input 5,    /* Tipo de Acesso 0=Currente ....   */
                                              input 2).   /* Record-Frase = 2 (cgc)*/
        
        
            END.
        
        END.
        
        /* tenta ler pelo cgc - em base de teste tem emitente com nome-abrev = "" */
        IF  (   NOT AVAIL ttemitente 
             OR {&TempTable}.nome-abrev = "":U)
        AND {&TempTable}.cgc <> "":U THEN DO:
        
            run pi-verifica-emitentecgc ( input {&TempTable}.cgc,
                                          input {&TempTable}.cgc,
                                          input 0,    /* Codigo do Emitente               */
                                          input 0,    /* Codigo do Emitente               */
                                          input 5,    /* Tipo de Acesso 0=Currente ....   */
                                          input 2, "", "").   /* Record-Frase = 2 (cgc)*/
        
            IF  NOT AVAIL ttemitentecgc
            THEN DO:
                RUN utp/ut-msgs.p ("msg":U, 25947, {&TempTable}.cgc).
                {bcp/bc9111.i "25947" " " " " " + return-value"}
                ASSIGN vlogerro = YES.
    
            END.
            ELSE 
                ASSIGN {&TempTable}.nome-abrev    = ttemitentecgc.nome-abrev
                       {&TempTable}.cgc           = ttemitentecgc.cgc
                       {&TempTable}.cod-emitente  = ttemitentecgc.cod-emitente.
        
        END.
        
        IF  NOT AVAIL ttemitente 
        AND NOT AVAIL ttemitentecgc
        AND vlogerro = NO
        THEN DO:
            {utp/ut-table.i mgadm emitente 1}
            RUN utp/ut-msgs.p ("msg":U, 25947, {&TempTable}.cgc).
            {bcp/bc9111.i "25947" " " " " " + return-value"}
            ASSIGN vlogerro = YES.
        END.
    END. 
    
    If   vLogErro = Yes Then do:        
        Return Error.
    END.

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

    Assign vTransDetail = "".
    
    Raw-transfer {&TempTable} To vConteudoRaw.

    Run _GenerateDCTransaction2d (Input vTransaction,  /* Codigo da Transacao                   */
                                  Input vConteudoRaw,  /* Conteudo da temp-table {&TempTable}   */
                                  Input vTransDetail,  /* Cabecalho de detalhes da transacao    */
                                  Input vNomeUsuario). /* Usuario responsavel pela transacao    */
    
End Procedure.
/*************************************  Codigo do Usuario Fim   **********************************/
