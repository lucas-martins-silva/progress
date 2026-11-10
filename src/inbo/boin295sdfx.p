&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN295SDFX 2.00.00.003}  /*** "010003" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin295sdfx MCC}
&ENDIF

/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN295
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName pedido-compr
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin295.i RowObject}
{inbo/boin295.i RowObjectDefault}
{utp/ut-glob.i}
def var hboMngr         as handle no-undo.
def VAR c-responsavel   like pedido-compr.responsavel no-undo.

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 13.13
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */
{cdp/findparamglobal.i}
{cdp/findparamcompra.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields DBOProgram 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     Habilitar os campos de interface segundo a regra de neg¢cio.
  Parameters:  pType: Tipo de Transaá∆o ("Create", "Update" ou "Delete") 
               pFieldName: Atributo da tabela.
               pFieldEnable: Habilita ou n∆o o atributo.
  Notes:       
------------------------------------------------------------------------------*/

    def input  param pType        as char               no-undo.
    def input  param pFieldName   as char               no-undo.
    def output param pFieldEnable as log    init yes    no-undo.

    def var c-enable              as char no-undo. /* Quando houver ordem de investimento informada */

    {cdp/findparamglobal.i}
    if  not avail param-global then
        return "NOK".

    {cdp/findparammat.i}
    if  not avail param-mat then
        return "NOK".

    {cdp/findparamcompra.i}
    if  not avail param-compra then
        return "NOK".

    case pFieldName:
        when "num-pedido" then 
            assign pFieldEnable = pType = "create".

        when "nr-processo" then
            assign pFieldEnable = param-compra.usa-proc.

        when "cod-emitente" then
            assign pFieldEnable = pType = "create".

        when "cod-estab-gestor" then
            assign pFieldEnable = param-global.modulo-mp = YES.

        when "data-pedido" then
            assign pFieldEnable = pType = "create".

        WHEN "emergencial" THEN
            ASSIGN pFieldEnable = pType = "create".
    end case.

    return "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveCodEmitente DBOProgram 
PROCEDURE leaveCodEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def INPUT param pType AS CHAR.
    def output param table for RowObjectDefault.
    
    IF pType = "create" THEN DO:
        run setCondPagto        (output RowObjectDefault.cod-cond-pag).
        run setCodTransp        (output RowObjectDefault.cod-transp).
        run setViaTransp        (output RowObjectDefault.via-transp).    
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveCodTransp DBOProgram 
PROCEDURE leaveCodTransp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param table for RowObjectDefault.
    
    run setViaTransp        (output RowObjectDefault.via-transp).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setCodTransp DBOProgram 
PROCEDURE setCodTransp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param pCodTransp like pedido-compr.cod-transp no-undo.

    assign pCodTransp = emitente.cod-transp.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setCondPagto DBOProgram 
PROCEDURE setCondPagto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param p-cod-cond-pag like pedido-compr.cod-cond-pag no-undo.

    {cdp/findemitente.i RowObject.cod-emitente}
    IF AVAIL emitente THEN
        assign p-cod-cond-pag = emitente.cod-cond-pag.
    ELSE
        assign p-cod-cond-pag = param-compra.cod-cond-pag.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaults DBOProgram 
PROCEDURE setDefaults :
/*------------------------------------------------------------------------------
  Purpose:     Executar o leave dos campos para sugest∆o de valores default.
  Parameters:  pType: Tipo de Transaá∆o ("Create", "Update" ou "Delete")
               pFieldName: Atributo da tabela
               RowObject: temp-table com os dados da tela
               RowObject: temp-table com os dados default
  Notes:       O mÇtodo SetDefaults deve ser executado apenas quando tratar-se
               de uma inclus∆o ou da modificaá∆o de algum campo.
------------------------------------------------------------------------------*/
    def input  param pType        as char no-undo.
    def input  param pFieldName   as char no-undo.
    def input  param table for RowObject.
    def output param table for RowObjectDefault.

    empty temp-table RowObjectDefault.

    find first RowObject       no-error.

    /* Defaults na inicializaá∆o da tela */
    if  pType      = "create"
    and pFieldName = "" then do:

        create RowObjectDefault.
        run setNumPedido            (output RowObjectDefault.num-pedido).
        run setResponsavel          (output RowObjectDefault.responsavel).
        run setEndEntrega           (output RowObjectDefault.end-entrega).
        run setEndCobranca          (output RowObjectDefault.end-cobranca).
        run setMensagem             (output RowObjectDefault.cod-mensagem).
        run setCondPagto            (output RowObjectDefault.cod-cond-pag).
        run setNature               (output RowObjectDefault.natureza).  
        run setInitialSituation     (output RowObjectDefault.i-situacao).
        run setSituation            (output RowObjectDefault.situacao).
    end.
    /* Defaults de leave de campos (criaá∆o e modificaá∆o) */
    else do:
    
        if  avail RowObject then do:
            create RowObjectDefault.
            buffer-copy RowObject to RowObjectDefault.
        end.
    end.

    /* Regras de neg¢cio para sugest∆o de valores defaults */
    case pFieldName:

        when "cod-emitente"      then run leaveCodEmitente     (INPUT pType,
                                                                output table RowObjectDefault).
        when "cod-transp" then 
            if  pType = "create" then run leaveCodTransp       (output table RowObjectDefault).

    end case.

    return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setEndCobranca DBOProgram 
PROCEDURE setEndCobranca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param p-end-cobranca like pedido-compr.end-cobranca no-undo.

    assign p-end-cobranca = param-compra.end-cobr-pad.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setEndEntrega DBOProgram 
PROCEDURE setEndEntrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param p-end-entrega like pedido-compr.end-entrega no-undo.

    assign p-end-entrega = param-compra.end-entr-pad.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setMensagem DBOProgram 
PROCEDURE setMensagem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param p-cod-mensagem like pedido-compr.cod-mensagem no-undo.

    assign p-cod-mensagem = param-compra.cod-mensagem.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setNumPedido DBOProgram 
PROCEDURE setNumPedido :

    DEF OUTPUT PARAM i-num-pedido LIKE pedido-compr.num-pedido NO-UNDO.

    DEF VAR h-boin295                AS HANDLE NO-UNDO.
    {java/ut_bohandler.i &bofilename=inbo/boin295.p   &bovarname=h-boin295   &runningBO=false}
    
    run emptyRowErrors in h-boin295.
    RUN geraNumeroPedidoCompra IN h-boin295 (output i-num-pedido).
    run getRowErrors in h-boin295(output table RowErrors append).

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setResponsavel DBOProgram 
PROCEDURE setResponsavel :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir o usu†rio requisitante
  Parameters:  pRequisitante: retorna usu†rio respons†vel pela ordem de compra.
  Notes:       Sugere o usu†rio logado no sistema como requisitante.
------------------------------------------------------------------------------*/

    def output param pResponsavel like pedido-compr.responsavel no-undo.

    assign pResponsavel = c-seg-usuario.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setViaTransp DBOProgram 
PROCEDURE setViaTransp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param p-via-transp like pedido-compr.via-transp no-undo.
    
    {cdp/findtransporte.i RowObjectDefault.cod-transp}
    
    IF AVAIL transporte THEN
        assign p-via-transp = transporte.via-transp.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setNature DBOProgram 
PROCEDURE setNature :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir natureza.
  Parameters:  pSituacao: retorna a natureza cadastrada para o item informado
                          na ordem de compra.
  Notes:       
------------------------------------------------------------------------------*/

    def output param pNatureza like pedido-compr.natureza no-undo.

    assign pNatureza = 1. /* Compra */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setInitialSituation DBOProgram 
PROCEDURE setInitialSituation :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir i-situacao inicial.
  Parameters:  pSituacao: retorna a situacao inicial do pedido
  Notes:       
------------------------------------------------------------------------------*/
    def output param piSituacao like pedido-compr.i-situacao no-undo.

    assign piSituacao = 1. /* Aberto */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSituation DBOProgram 
PROCEDURE setSituation :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir i-situacao inicial.
  Parameters:  pSituacao: retorna a situacao inicial do pedido
  Notes:       
------------------------------------------------------------------------------*/
    def output param piSituacao like pedido-compr.situacao no-undo.

    assign piSituacao = 2. /*-- Nao Impresso --*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

