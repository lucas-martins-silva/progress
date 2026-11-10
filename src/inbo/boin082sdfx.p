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
{include/i-prgvrs.i BOIN082SDFX 2.00.00.020 } /*** "010020" 17/06/2025 16:40:45 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin082sdfx MUT}
&ENDIF

/*                                                                */
/* &IF "{&EMSFND_VERSION}" >= "1.00" &THEN                        */
/*     {include/i-license-manager.i boin082sdfx MUT}              */
/* &ENDIF                                                         */

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
&GLOBAL-DEFINE DBOName BOIN082
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName cotacao-item
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin082.i RowObject}
{inbo/boin082.i RowObjectDefault}
{include/i-epc200.i boin082sdfx}

{fch/fchmat/fchmataddpurchaserequisitions.i} /* ttPurchaseRequisition */
                                
/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
{utp/ut-glob.i}

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var hboMngr                         as handle   no-undo.
def var h-boin082sd                     as handle   no-undo.
def var h-bocx155                       as handle   no-undo.
DEF VAR h-boin274na                     AS HANDLE   NO-UNDO.
DEF VAR h-bocx250na                     AS HANDLE   NO-UNDO.
DEF VAR h-boin082i                      AS HANDLE   NO-UNDO.
DEF VAR h-bocx319                       AS HANDLE   NO-UNDO.

def var c-cod-estabel                   LIKE ordem-compra.cod-estabel NO-UNDO.
DEF VAR c-cod-estabel-aux               LIKE ordem-compra.cod-estabel NO-UNDO.
DEF VAR c-return-emit-cex               AS CHARACTER   NO-UNDO.
def var i-informa                       as integer no-undo.
DEF VAR iCodigoMoedaInc LIKE moeda.mo-codigo NO-UNDO.
def var i-mo-codig      LIKE moeda.mo-codigo NO-UNDO.
def var l-existe-moeda  as logical init no no-undo.
DEFINE VARIABLE iCodBusca  AS INTEGER NO-UNDO.
def var cCampoLeave     as character no-undo.
DEF VAR l-emergencial AS LOGICAL INITIAL NO NO-UNDO.

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
         HEIGHT             = 1
         WIDTH              = 40.57.
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

    {cdp/findparamcompra.i}
    if  not avail param-compra then
        return "NOK".

    {cdp/findordemcompra.i rowObject.numero-ordem}

    case pFieldName:
        when "cod-emitente" then
            assign pFieldEnable = pType = "create".

        when "taxa-financ" then 
            assign pFieldEnable = param-compra.utiliza-taxa.

        when "nr-dias-taxa" then
            assign pFieldEnable =     param-compra.utiliza-taxa
                                  and RowObject.taxa-financ.

        when "valor-taxa" then 
            assign pFieldEnable =     param-compra.utiliza-taxa
                                  and RowObject.taxa-financ.

        when "codigo-icm" then do:
        
            if  avail ttPurchaseRequisition then
                assign pFieldEnable = param-compra.utiliza-icm 
                                      and ttPurchaseRequisition.natureza <> 2 /* nao servico */.
            ELSE IF AVAIL ordem-compra THEN
                assign pFieldEnable = param-compra.utiliza-icm 
                                      and avail ordem-compra
                                      and ordem-compra.natureza <> 2 /* nao servico */.
            ELSE 
                assign pFieldEnable = param-compra.utiliza-icm. 
        end.
        when "aliquota-icm" then do:
        
            if  avail ttPurchaseRequisition then
                assign pFieldEnable = param-compra.utiliza-icm 
                                      and ttPurchaseRequisition.natureza <> 2 /* nao servico */.
            ELSE IF AVAIL ordem-compra THEN
                assign pFieldEnable = param-compra.utiliza-icm
                                      and avail ordem-compra
                                      and ordem-compra.natureza <> 2 /* nao servico */.
            ELSE
                assign pFieldEnable = param-compra.utiliza-icm.
        end.
        when "aliquota-iss" then 
            assign pFieldEnable = param-compra.utiliza-iss.

        when "codigo-ipi" THEN
            RUN verificaImportacao IN THIS-PROCEDURE (OUTPUT pFieldEnable).
                              
        when "valor-frete"  THEN
            RUN verificaImportacao IN THIS-PROCEDURE (OUTPUT pFieldEnable).
                         
        when "frete" THEN
            RUN verificaImportacao IN THIS-PROCEDURE (OUTPUT pFieldEnable).
        
    end case.

    return "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFieldsImport DBOProgram 
PROCEDURE enableFieldsImport :
/*------------------------------------------------------------------------------
  Purpose:     Habilitar os campos de interface segundo a regra de neg¢cio (Importaá∆o).
  Parameters:  pType: Tipo de Transaá∆o ("Create", "Update" ou "Delete") 
               pFieldName: Atributo da tabela.
               pFieldEnable: Habilita ou n∆o o atributo.
  Notes:       
------------------------------------------------------------------------------*/

    def input  param pType        as char               no-undo.
    def input  param pFieldName   as char               no-undo.
    def output param pFieldEnable as log    init yes    no-undo.

    {cdp/finditem.i rowObject.it-codigo}

    case pFieldName:
        when "class-fiscal" then
            assign pFieldEnable = (ITEM.tipo-contr = 4).
        WHEN "itinerario" THEN
            ASSIGN pFieldEnable = (i-informa = 2 OR i-informa = 3).
        WHEN "mapa-cotacao" THEN
            ASSIGN pFieldEnable = (pType = "update").

    end case.

    return "ok":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDefaultsEmergency DBOProgram 
PROCEDURE getDefaultsEmergency :
{inbo/boin082sdfx.i}
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDiasValidade DBOProgram 
PROCEDURE getDiasValidade :
/*------------------------------------------------------------------------------
  Purpose:     Retornar dias de validade
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    def output param p-dias-validade like RowObject.dias-validade no-undo.

    IF NOT AVAIL param-compra THEN
        FIND FIRST param-compra NO-LOCK NO-ERROR.

    ASSIGN p-dias-validade = param-compra.num-dias-valid-cotac.
    IF p-dias-validade = 0 THEN
        ASSIGN p-dias-validade = 1.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNextVendorItem DBOProgram 
PROCEDURE getNextVendorItem :
/*------------------------------------------------------------------------------
  Purpose:     Retorna pr¢ximo Fornecedor do item
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    

    def input  param p-it-codigo LIKE RowObjectDefault.it-codigo NO-UNDO.
    def output param table for RowObjectDefault.
    
    /* Fornecedores relacionados ao Item X Fonecedor x Estabelecimento */
    for each item-fornec-estab NO-LOCK
        where item-fornec-estab.it-codigo   = p-it-codigo
          and item-fornec-estab.cod-estabel = c-cod-estabel:

            for first cotacao-item 
                 fields(cod-emitente it-codigo data-cotacao numero-ordem) no-lock 
            where 
                  cotacao-item.cod-emitente  = item-fornec-estab.cod-emitente and
                  cotacao-item.it-codigo     = RowObject.it-codigo    and
                  cotacao-item.data-cotacao <> &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF  and
                  cotacao-item.numero-ordem  = RowObject.numero-ordem:  
            END.
            IF AVAIL cotacao-item THEN 
                NEXT.
            ELSE
            DO: 
                ASSIGN RowObjectDefault.cod-emitente = item-fornec-estab.cod-emitente.
                run leaveCodEmitente   (output table RowObjectDefault).
                LEAVE.
            END.
    end.

    IF NOT AVAIL item-fornec-estab THEN  /* qdo sai pelo leave o item-fornec-estab fica available */
    for each item-fornec
        where item-fornec.it-codigo = RowObject.it-codigo no-lock:

            for first cotacao-item 
                 fields(cod-emitente it-codigo data-cotacao numero-ordem) no-lock
            where 
                  cotacao-item.cod-emitente  = item-fornec.cod-emitente and
                  cotacao-item.it-codigo     = RowObject.it-codigo    and
                  cotacao-item.data-cotacao <> &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF  and
                  cotacao-item.numero-ordem  = RowObject.numero-ordem:  
            END.
            IF AVAIL cotacao-item THEN 
                NEXT.
            ELSE
            DO: 
                ASSIGN RowObjectDefault.cod-emitente = item-fornec.cod-emitente.
                run leaveCodEmitente   (output table RowObjectDefault).
                LEAVE.
            END.
    end.

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice cotacao
  Parameters:  
               recebe valor do campo numero-ordem
               recebe valor do campo cod-emitente
               recebe valor do campo it-codigo
               recebe valor do campo seq-cotac
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnumero-ordem LIKE cotacao-item.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE cotacao-item.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE cotacao-item.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pseq-cotac LIKE cotacao-item.seq-cotac NO-UNDO.

    FIND FIRST bfcotacao-item WHERE 
        bfcotacao-item.numero-ordem = pnumero-ordem AND 
        bfcotacao-item.cod-emitente = pcod-emitente AND 
        bfcotacao-item.it-codigo = pit-codigo AND 
        bfcotacao-item.seq-cotac = pseq-cotac NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcotacao-item THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcotacao-item)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveAliquotaIpi DBOProgram 
PROCEDURE leaveAliquotaIpi :
def output param table for RowObjectDefault.

    RUN returnVendorUnitPrice ("aliquota-ipi", output table RowObjectDefault).

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveCdnPaisOrig DBOProgram 
PROCEDURE leaveCdnPaisOrig :
/*------------------------------------------------------------------------------
  Purpose: Leave do campo pa°s de origem (importaá∆o)
  Parameters:  RowObjectDefault: temp-table contendo os dados sugeridos
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pAliquotaAntiga LIKE cotacao-item.aliquota-ipi NO-UNDO.
    def output param table for RowObjectDefault.

    /* Busca o regime de importacao padrao */
    run buscaRegimePadrao in h-bocx319 (input  RowObjectDefault.cdn-pais-orig,
                                        input  RowObjectDefault.class-fiscal, 
                                        output RowObjectDefault.regime-impot).

    /* Busca aliquotas II e IPI */
    run calculateII_IPI in h-boin082i (input  RowObjectDefault.it-codigo,      
                                       input  RowObjectDefault.numero-ordem,   
                                       input  pAliquotaAntiga,   
                                       input  RowObjectDefault.class-fiscal,               
                                       input  RowObjectDefault.cdn-pais-orig,              
                                       input  RowObjectDefault.regime-impot,               
                                       output RowObjectDefault.aliquota-ii,    
                                       output RowObjectDefault.aliquota-ipi).  
   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveClassFiscal DBOProgram 
PROCEDURE leaveClassFiscal :
/*------------------------------------------------------------------------------
  Purpose: Leave do campo classificaá∆o fiscal (importaá∆o)
  Parameters:  RowObjectDefault: temp-table contendo os dados sugeridos
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pAliquotaAntiga LIKE cotacao-item.aliquota-ipi NO-UNDO.
    def output param table for RowObjectDefault.

    {java/ut_bohandler.i &bofilename=cxbo/bocx319.p     &bovarname=h-bocx319    &runningBO=false}
    {java/ut_bohandler.i &bofilename=inbo/boin082i.p    &bovarname=h-boin082i   &runningBO=false}

    /* Busca o regime de importacao padrao */
    run buscaRegimePadrao in h-bocx319 (input  RowObjectDefault.cdn-pais-orig,
                                        input  RowObjectDefault.class-fiscal, 
                                        output RowObjectDefault.regime-impot).
    /* Busca aliquotas II e IPI */
    run calculateII_IPI in h-boin082i (input  RowObjectDefault.it-codigo,   
                                       input  RowObjectDefault.numero-ordem,
                                       input  pAliquotaAntiga,
                                       input  RowObjectDefault.class-fiscal,              
                                       input  RowObjectDefault.cdn-pais-orig,             
                                       input  RowObjectDefault.regime-impot,             
                                       output RowObjectDefault.aliquota-ii, 
                                       output RowObjectDefault.aliquota-ipi).

    RETURN "OK":U.

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

    def output param table for RowObjectDefault.

    run setBuyer            (output RowObjectDefault.cod-comprado).
    run setQuotationDate    (output RowObjectDefault.data-cotacao).
    run setCodTransp        (output RowObjectDefault.cod-transp).

    run setFinancialFields  (OUTPUT TABLE RowObjectDefault).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveCodigoIpi DBOProgram 
PROCEDURE leaveCodigoIpi :
def output param table for RowObjectDefault.

    RUN returnVendorUnitPrice ("codigo-ipi", output table RowObjectDefault).
    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveItCodigo DBOProgram 
PROCEDURE leaveItCodigo :
/*------------------------------------------------------------------------------
  Purpose:     Retornar comprador da ordem
  Parameters:  
  Notes:       ocorre apenas na tela de pedido emergencial
------------------------------------------------------------------------------*/
    def output param table for RowObjectDefault.

    run setBuyer            (output RowObjectDefault.cod-comprado).
    run setQuotationDate    (output RowObjectDefault.data-cotacao).

    run setFinancialFields  (OUTPUT TABLE RowObjectDefault).
    run setFieldsByParamCompra       (OUTPUT TABLE RowObjectDefault).

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveNrDiasTaxa DBOProgram 
PROCEDURE leaveNrDiasTaxa :
def output param table for RowObjectDefault.

    RUN returnVendorUnitPrice ("nr-dias-taxa", output table RowObjectDefault).
    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leavePercDescto DBOProgram 
PROCEDURE leavePercDescto :
def output param table for RowObjectDefault.

    RUN returnVendorUnitPrice ("perc-descto", output table RowObjectDefault).

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leavePrecoFornec DBOProgram 
PROCEDURE leavePrecoFornec :
def output param table for RowObjectDefault.

    RUN returnVendorUnitPrice ("preco-fornec", output table RowObjectDefault).
    
    return "OK".                                                                                                            
                                                                                                                            
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveRegimeImport DBOProgram 
PROCEDURE leaveRegimeImport :
/*------------------------------------------------------------------------------
  Purpose: Leave do campo regime de importaá∆o (importaá∆o)
  Parameters:  RowObjectDefault: temp-table contendo os dados sugeridos
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pAliquotaAntiga LIKE cotacao-item.aliquota-ipi NO-UNDO.
    def output param table for RowObjectDefault.

    {java/ut_bohandler.i &bofilename=inbo/boin082i.p    &bovarname=h-boin082i   &runningBO=false}

    /* Busca aliquotas II e IPI */
    run calculateII_IPI in h-boin082i (input  RowObjectDefault.it-codigo,     
                                       input  RowObjectDefault.numero-ordem,  
                                       input  pAliquotaAntiga,  
                                       input  RowObjectDefault.class-fiscal,            
                                       input  RowObjectDefault.cdn-pais-orig,           
                                       input  RowObjectDefault.regime-impot,            
                                       output RowObjectDefault.aliquota-ii,   
                                       output RowObjectDefault.aliquota-ipi). 

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveTaxaFinanc DBOProgram 
PROCEDURE leaveTaxaFinanc :
def output param table for RowObjectDefault.

    RUN returnVendorUnitPrice ("taxa-financ", output table RowObjectDefault).

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveValorDescto DBOProgram 
PROCEDURE leaveValorDescto :
def output param table for RowObjectDefault.

    RUN returnVendorUnitPrice ("valor-descto", output table RowObjectDefault).

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveValorTaxa DBOProgram 
PROCEDURE leaveValorTaxa :
def output param table for RowObjectDefault.

    RUN returnVendorUnitPrice ("valor-taxa", output table RowObjectDefault).

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnVendorUnitPrice DBOProgram 
PROCEDURE returnVendorUnitPrice :
/*------------------------------------------------------------------------------
  Purpose:   Calcula o pre-unit-for
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/
    DEFINE input  param pFieldName as char no-undo.
    DEFINE output param table for RowObjectDefault.

    DEFINE VARIABLE h-boin082ca AS HANDLE      NO-UNDO.

    {java/ut_bohandler.i &bofilename=inbo/boin082ca.p   &bovarname=h-boin082ca  &runningBO=false}
    run emptyRowErrors in h-boin082ca.

    
    FIND FIRST RowObject NO-ERROR.
    /*--- Calcula o pre-unit-for ---*/
    run calculaPrecoUnitFornecedorCotacao in h-boin082ca (input (pFieldName <> "valor-descto"),
                                                          input RowObject.numero-ordem,
                                                          input-output table RowObjectDefault).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setBuyer DBOProgram 
PROCEDURE setBuyer :
/*------------------------------------------------------------------------------
  Purpose:     Retornar comprador da ordem
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    def output param pCodComprado like ordem-compra.cod-comprado no-undo.

    {cdp/findordemcompra.i RowObjectDefault.numero-ordem}

    IF AVAIL ordem-compra THEN
        assign pCodComprado = ordem-compra.cod-comprado.
    ELSE
        ASSIGN pCodComprado = c-seg-usuario.

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

    {cdp/findemitente.i RowObjectDefault.cod-emitente}
    if  avail emitente then
        assign pCodTransp = emitente.cod-transp.

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
               RowObjectDefault: temp-table com os dados default
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
    if  pType matches ("*emergency*") then do:

        ASSIGN l-emergencial = YES.
        find first ttPurchaseRequisition no-error.
        if  not avail ttPurchaseRequisition then
            return "NOK":U.

        if  pType = "createEmergency" 
        and pFieldName = "" then do:

            run getDefaultsEmergency (input pFieldName,
                                      output table RowObjectDefault).
            run getDiasValidade      (output RowObjectDefault.dias-validade).
        end.
        /* Defaults de leave de campos (criaá∆o e modificaá∆o) */
        else do:
            
            if  avail RowObject then do:
                
                create RowObjectDefault.
                buffer-copy RowObject to RowObjectDefault.
            end.
        end.
    end.
    else do:
        ASSIGN l-emergencial = NO.
        if  pType      = "create"
        and pFieldName = "" then do:
    
            /* Item da Requisiá∆o */
            create RowObjectDefault.
            /* Grava chave do registro pai para, posteriormente, habilitar/desabilitar os campos (enableFields) */
            assign RowObjectDefault.numero-ordem = RowObject.numero-ordem  
                   RowObjectDefault.it-codigo    = RowObject.it-codigo     
                   RowObjectDefault.cod-emitente = RowObject.cod-emitente. 

            run setPurchRequisitionSite (input "").
    
            if  RowObjectDefault.cod-emitente = 0 then
                run getNextVendorItem (input RowObject.it-codigo, 
                                       output table RowObjectDefault).
    
            run getDiasValidade (output RowObjectDefault.dias-validade).
            run leaveCodEmitente (output table RowObjectDefault).

            RUN returnVendorUnitPrice ("preco-fornec", output table RowObjectDefault).
        end.
        /* Defaults de leave de campos (criaá∆o e modificaá∆o) */
        else do:
            if  avail RowObject then do:
                create RowObjectDefault.
                buffer-copy RowObject to RowObjectDefault.

                if  rowObjectDefault.data-cotacao = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF then
                    assign rowObjectDefault.data-cotacao = today.
            end.
        end.
    end.

    /* Regras de neg¢cio para sugest∆o de valores defaults */
    case pFieldName:
        when "cod-emitente" then do:

            if  pType matches ("*emergency*") then
                run getDefaultsEmergency (input pFieldName,
                                          output table RowObjectDefault).
            else
                run leaveCodEmitente (output table RowObjectDefault).
        end.
        when "it-codigo" then do:

            if  pType matches ("*emergency*") then
                run getDefaultsEmergency (input pFieldName,
                                          output table RowObjectDefault).
            else
                run leaveCodEmitente (output table RowObjectDefault).
        end.
        when "qt-solic" then do:

            if  avail ttPurchaseRequisition
            and ttPurchaseRequisition.qt-solic = 0 then
                run getDefaultsEmergency (input pFieldName,
                                          output table RowObjectDefault).
        end.
        when "cod-estabel"     then run getDefaultsEmergency (input pFieldName,
                                                              output table RowObjectDefault). /*-- estab do pedido --*/
        when "preco-fornec"    then run leavePrecoFornec     (output table RowObjectDefault).
        when "perc-descto"     then run leavePercDescto      (output table RowObjectDefault).
        when "valor-descto"    then run leaveValorDescto     (output table RowObjectDefault).
        when "aliquota-ipi"    then run leaveAliquotaIpi     (output table RowObjectDefault).
        when "codigo-ipi"      then run leaveCodigoIpi       (output table RowObjectDefault).
        when "taxa-financ"     then run leaveTaxaFinanc      (output table RowObjectDefault).
        when "valor-taxa"      then run leaveValorTaxa       (output table RowObjectDefault).
        when "nr-dias-taxa"    then run leaveNrDiasTaxa      (output table RowObjectDefault).
        when "currency":U OR 
        when "mo-codigo" then do:
            if pType matches ("emergency") then
                run getDefaultsEmergency (input pFieldName,
                                         output table RowObjectDefault).
            ELSE do:
                ASSIGN cCampoLeave = "mo-codigo":U.
                run leaveCodEmitente (output table RowObjectDefault).
                IF pType = "update" THEN
                    assign rowObjectDefault.seq-cotac = RowObject.seq-cotac.
                ASSIGN cCampoLeave = "".
            end.
        end.
    end case.

	IF c-nom-prog-dpc-mg97  <> "" OR 
        c-nom-prog-appc-mg97 <> "" OR
        c-nom-prog-upc-mg97  <> "" THEN DO:
        
        FOR EACH tt-epc:
            DELETE tt-epc.
        END.
               
        create tt-epc.
        assign tt-epc.cod-event      = "AfterSetDefaults"
                tt-epc.cod-parameter = "RowObjectDefault"
                tt-epc.val-parameter = String(TEMP-TABLE RowObjectDefault:HANDLE).
        
        {include/i-epc201.i "AfterSetDefaults"}
                                    
        FIND FIRST tt-epc
            where tt-epc.cod-event     = "AfterSetDefaults"
                and tt-epc.cod-parameter = "cod-transp" NO-ERROR.
                          
        IF AVAIL tt-epc THEN DO:
			FIND FIRST RowObjectDefault NO-ERROR.
			IF AVAIL RowObjectDefault THEN DO:
				assign RowObjectDefault.cod-transp = int(tt-epc.val-parameter).
			END.  
        END.
        FIND FIRST tt-epc
            where tt-epc.cod-event     = "AfterSetDefaults"
                and tt-epc.cod-parameter = "un" NO-ERROR.
                          
        IF AVAIL tt-epc THEN DO:
            FIND FIRST RowObjectDefault NO-ERROR.
            IF AVAIL RowObjectDefault THEN DO:
                assign RowObjectDefault.un = tt-epc.val-parameter.
            END.  
        END.
               
    end.

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaultsImport DBOProgram 
PROCEDURE setDefaultsImport :
/*------------------------------------------------------------------------------
  Purpose:     Executar o leave dos campos para sugest∆o de valores default para importaá∆o.
  Parameters:  pType: Tipo de Transaá∆o ("Create", "Update" ou "Delete")
               pFieldName: Atributo da tabela
               RowObject: temp-table com os dados da tela
               RowObjectDefault: temp-table com os dados default
               pAliquotaAntiga: Al°quota IPI de veio da cotaá∆o
  Notes:       O mÇtodo SetDefaults deve ser executado apenas quando tratar-se
               de uma inclus∆o ou da modificaá∆o de algum campo.
------------------------------------------------------------------------------*/
    def input  param pType        as char no-undo.
    def input  param pFieldName   as char no-undo.
    def input  param table for RowObject.
    DEF INPUT  PARAM pAliquotaAntiga LIKE cotacao-item.aliquota-ipi NO-UNDO.
    DEF INPUT  PARAM cCodEstabel     LIKE pedido-compr.cod-estabel  NO-UNDO.
    def output param table for RowObjectDefault.
    
    empty temp-table RowObjectDefault.

    find first RowObject       no-error.

    create RowObjectDefault.
    buffer-copy RowObject to RowObjectDefault.

    assign i-informa = 0.

    {java/ut_bohandler.i &bofilename=inbo/boin274na.p   &bovarname=h-boin274na  &runningBO=false}
    {java/ut_bohandler.i &bofilename=cxbo/bocx319.p     &bovarname=h-bocx319    &runningBO=false}
    {java/ut_bohandler.i &bofilename=inbo/boin082i.p    &bovarname=h-boin082i   &runningBO=false}
    {java/ut_bohandler.i &bofilename=cxbo/bocx250na.p   &bovarname=h-bocx250na  &runningBO=false}
    {java/ut_bohandler.i &bofilename=cxbo/bocx155.p     &bovarname=h-bocx155    &runningBO=false}

    IF (cCodEstabel = "") THEN DO:
        run openQueryStatic in h-boin274na (input "Main":U) no-error.
        run gotoKey in h-boin274na (input RowObject.numero-ordem).

        if  return-value = "OK":U then
            run getCharfield in h-boin274na (input "cod-estabel":U, output c-cod-estabel).
    END.
    ELSE DO:
        ASSIGN c-cod-estabel = cCodEstabel.
    END.

    run openQueryStatic in h-bocx250na (input "Main":U) no-error.
    run gotoKey in h-bocx250na (input c-cod-estabel).

    if  return-value = "OK":U THEN DO:
        run getIntfield in h-bocx250na (input "int-1":U, output i-informa).
    END.

    RUN setConstraintCodEstabel IN h-boin082i (INPUT cCodEstabel).

    IF pType = "create" AND
       pFieldName = "" THEN DO:

        run openQueryStatic in h-bocx155 (input "Main":U) no-error.
        run findPk-emitente in h-bocx155(input RowObject.cod-emitente, output c-return-emit-cex).

        IF c-return-emit-cex = "" THEN DO:
            run getCharfield in h-bocx155(input "cod-incoterm-imp",
                                          output RowObjectDefault.cod-incoterm).

            run getIntfield in h-bocx155 (input "cod-pto-contr",
                                          output RowObjectDefault.cod-pto-contr-base).

            IF i-informa = 2 OR 
               i-informa = 3 THEN DO:
                run getintfield in h-bocx155 (input "cod-itiner-imp",
                                              output RowObjectDefault.itinerario).
            END.

            /* Busca o valor padrao do fabricante, do pais de origem e do regime de importacao padrao */
            run setDefaultsIm0060 in h-boin082i (input  RowObject.it-codigo,
                                                 input  RowObject.cod-emitente,
                                                 input  RowObject.class-fiscal, 
                                                 output RowObjectDefault.cdn-fabrican,
                                                 output RowObjectDefault.cdn-pais-orig,
                                                 output RowObjectDefault.regime-impot).
   
            /* Busca aliquotas II e IPI */
            run calculateII_IPI in h-boin082i (input  RowObject.it-codigo,   
                                               input  RowObject.cod-emitente,
                                               input  pAliquotaAntiga,
                                               input  RowObject.class-fiscal,              
                                               input  RowObject.cdn-pais-orig,             
                                               input  RowObject.regime-impot,             
                                               output RowObjectDefault.aliquota-ii, 
                                               output RowObjectDefault.aliquota-ipi).

        END.

        RUN leaveClassFiscal  (INPUT pAliquotaAntiga, OUTPUT TABLE RowObjectDefault).
        RUN leaveRegimeImport (INPUT pAliquotaAntiga, OUTPUT TABLE RowObjectDefault).
        RUN leaveCdnPaisOrig  (INPUT pAliquotaAntiga, OUTPUT TABLE RowObjectDefault).
        
    END.
    ELSE DO:
        case pFieldName:
            when "class-fiscal" then    RUN leaveClassFiscal  (INPUT pAliquotaAntiga, output table RowObjectDefault).
            when "regime-impot" then    RUN leaveRegimeImport (INPUT pAliquotaAntiga, output table RowObjectDefault).
            when "cdn-pais-orig" then   RUN leaveCdnPaisOrig  (INPUT pAliquotaAntiga, output table RowObjectDefault).   
        end case.

        RUN returnVendorUnitPrice ("preco-fornec", output table RowObjectDefault).
    END.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setFieldsByParamCompra DBOProgram 
PROCEDURE setFieldsByParamCompra :
/*------------------------------------------------------------------------------
  Purpose:     Retornar comprador da ordem
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    def output param table for RowObjectDefault.

    {cdp/findparamcompra.i}
    if  not avail param-compra then
        return "NOK".
    {cdp/findordemcompra.i RowObject.numero-ordem}

    if  param-compra.utiliza-icm = no then
        assign RowObjectDefault.codigo-icm = 1
               RowObjectDefault.aliquota-icm = param-compra.aliq-icm-pad
                                               WHEN (avail ordem-compra and ordem-compra.natureza <> 2) /* nao servico */.
    if  param-compra.utiliza-iss = no then
        assign RowObjectDefault.aliquota-iss = param-compra.aliq-iss-pad.

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setFinancialFields DBOProgram 
PROCEDURE setFinancialFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def OUTPUT param table for RowObjectDefault.

    DEFINE BUFFER   b-cot-item FOR cotacao-item.

    DEFINE VARIABLE deQtParcela   LIKE prazo-compra.quantidade NO-UNDO.
    DEFINE VARIABLE rbCotacaoItem AS ROWID       NO-UNDO.
    DEFINE VARIABLE rwTbPrCc      AS ROWID       NO-UNDO.
    DEFINE VARIABLE rwTabItem     AS ROWID       NO-UNDO.
    DEFINE VARIABLE deConver      as dec   no-undo.

    FIND FIRST RowObject NO-ERROR.
    IF NOT AVAIL RowObject THEN
        return "NOK".

    {cdp/findparamcompra.i}
    if  not avail param-compra then
        return "NOK".

    {cdp/findemitente.i RowObjectDefault.cod-emitente}

    IF NOT AVAIL emitente THEN
        return "NOK".
    
    for first cont-emit fields(cod-emitente nome sequencia)
         where cont-emit.cod-emitente = emitente.cod-emitente no-lock: end.
    if  avail cont-emit then
        assign rowObjectDefault.contato = substring(cont-emit.nome, 1, 12).

    {cdp/finditem.i RowObjectDefault.it-codigo}
    IF NOT AVAIL ITEM THEN
        return "NOK".
    
    IF RowObjectDefault.numero-ordem <> 0 AND RowObjectDefault.numero-ordem <> ? THEN DO:
        {cdp/findordemcompra.i RowObjectDefault.numero-ordem}
    
        for each prazo-compra fields(numero-ordem quantidade) where
            prazo-compra.numero-ordem = RowObject.numero-ordem no-lock:
            assign deQtParcela = deQtParcela + prazo-compra.quantidade.
        end.
    
        for last b-cot-item 
            where b-cot-item.numero-ordem = RowObject.numero-ordem 
              and b-cot-item.cod-emitente = RowObjectDefault.cod-emitente 
              and b-cot-item.it-codigo    = RowObject.it-codigo 
              no-lock: end.
    END.
    
    for first item-fornec fields(it-codigo 
                                 cod-emitente 
                                 ativo 
                                 unid-med-for 
                                 cod-cond-pag 
                                 num-casa-dec 
                                 fator-conver) 
        where item-fornec.it-codigo    = RowObject.it-codigo    and
              item-fornec.cod-emitente = RowObjectDefault.cod-emitente and
              item-fornec.ativo          no-lock: end.

    if  avail b-cot-item then  
        assign  rowObjectDefault.seq-cotac  = b-cot-item.seq-cotac + 1
                rowObjectDefault.un         = b-cot-item.un.
    ELSE 
        assign rowObjectDefault.seq-cotac = 1
               rowObjectDefault.un        = (   IF AVAIL item-fornec
                                                THEN item-fornec.unid-med-for
                                                ELSE IF AVAIL ITEM
                                                     THEN item.un
                                                     ELSE ""
                                                ).


    if avail item-fornec THEN DO: 
        IF AVAIL param-compra 
             AND param-compra.log-multi-unid-medid 
             AND item-fornec.unid-med-for <> RowObject.un THEN DO:
            /*Utiliza M£ltiplas Unidades de Medida
              Se unidade da item-fornec <> unidade da cotaá∆o, busca fator de convers∆o conforme a unidade da cotaá∆o*/
            FOR FIRST item-fornec-umd FIELDS(fator-conver num-casa-dec)
                WHERE item-fornec-umd.it-codigo = item-fornec.it-codigo
                  AND item-fornec-umd.cod-emitente = item-fornec.cod-emitente
                  AND item-fornec-umd.unid-med-for = RowObject.un
                  AND item-fornec-umd.log-ativo NO-LOCK: END.
            assign deConver = if avail item-fornec-umd
                               then (1 / (exp(10, item-fornec-umd.num-casa-dec)) * item-fornec-umd.fator-conver)
                               else 1.
        END.
        ELSE
            assign deConver = ( 1 / (exp(10, item-fornec.num-casa-dec))) * item-fornec.fator-conver.
    END.
    else assign deConver = 1.

    for first b-cot-item fields(numero-ordem cod-emitente it-codigo seq-cotac data-cotacao dias-validade) 
        where b-cot-item.cod-emitente  = RowObjectDefault.cod-emitente 
        and   b-cot-item.it-codigo     = RowObjectDefault.it-codigo    
        and   b-cot-item.data-cotacao <> &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF     
        and   (   b-cot-item.numero-ordem = 0              
               or b-cot-item.numero-ordem = ?)   
        and   b-cot-item.dias-validade + b-cot-item.data-cotacao > today no-lock: end.

    if  avail b-cot-item then DO:
        assign rbCotacaoItem = rowid(b-cot-item)
               rwTbPrCc  = ?
               rwTabItem = ?.
          /*Se for leave da moeda e encontrar cotaá∆o desvinculada n∆o prossegue*/
        IF cCampoLeave = "mo-codigo":U THEN RETURN.
    END.
    else do:
        IF NOT l-emergencial THEN
            assign rowObjectDefault.cod-cond-pag = if avail item-fornec then item-fornec.cod-cond-pag
                                                   else if avail emitente then emitente.cod-cond-pag
                                                   else 0.

        /** Desenvolvimento release 2.04 - item-fornec-estab **/
        ASSIGN l-existe-moeda = NO.

        IF AVAIL ordem-compra THEN DO:
            ASSIGN c-cod-estabel-aux = ordem-compra.cod-estabel.
        END.
        ELSE IF AVAIL ttPurchaseRequisition THEN DO:
            ASSIGN c-cod-estabel-aux = ttPurchaseRequisition.cod-estabel.
        END.

        IF cCampoLeave <> "mo-codigo":U THEN DO:
            FIND FIRST item-fornec-estab WHERE item-fornec-estab.it-codigo    = RowObjectDefault.it-codigo
                                           AND item-fornec-estab.cod-estabel  = c-cod-estabel-aux
                                           AND item-fornec-estab.cod-emitente = RowObjectDefault.cod-emitente NO-LOCK NO-ERROR.
            IF AVAIL item-fornec-estab THEN DO:
                ASSIGN rowObject.cod-cond-pag = item-fornec-estab.cod-cond-pag WHEN NOT l-emergencial.
    
                IF TRIM(SUBSTRING(item-fornec-estab.char-1, 1, 2)) <> "" THEN
                    ASSIGN i-mo-codig = integer(SUBSTRING(item-fornec-estab.char-1, 1, 2))
                           l-existe-moeda = YES.
            END.
            ELSE DO:
                /* Verifica se existe relacionamento item x fornec e seta a moeda */
                FIND FIRST item-fornec WHERE item-fornec.it-codigo    = RowObjectDefault.it-codigo    
                                         AND item-fornec.cod-emitente = RowObjectDefault.cod-emitente NO-LOCK NO-ERROR.
                IF AVAIL item-fornec THEN DO:
                    IF TRIM(SUBSTRING(item-fornec.char-2, 3, 2)) <> "" THEN
                       ASSIGN i-mo-codig = integer(SUBSTRING(item-fornec.char-2, 3, 2))
                              l-existe-moeda = YES.
                END.
            END.
        END.
        ELSE
            ASSIGN l-existe-moeda = YES
                   i-mo-codig = rowObject.mo-codigo.

        IF l-existe-moeda THEN DO:
            for first tb-pr-cc fields(cod-emitente cod-cond-pag dt-inicio  dt-termino  situacao
                                      nr-tab       mo-codigo    frete      taxa-financ nr-dias-taxa
                               valor-frete  codigo-ipi   valor-taxa perc-descto cod-estabel) 
                where tb-pr-cc.cod-emitente = emitente.cod-emitente   
                and   tb-pr-cc.cod-cond-pag = rowObjectDefault.cod-cond-pag 
                and   tb-pr-cc.dt-inicio   <= rowObjectDefault.data-cotacao  
                and   tb-pr-cc.dt-termino  >= rowObjectDefault.data-cotacao  
                AND   tb-pr-cc.cod-estabel  = c-cod-estabel-aux
                AND   tb-pr-cc.mo-codigo    = i-mo-codig
                and   tb-pr-cc.situacao     = 1 no-lock: end.
            IF AVAIL tb-pr-cc THEN DO:
                ASSIGN iCodBusca = 1.
            END.
            ELSE DO:
                for first tb-pr-cc fields(cod-emitente cod-cond-pag dt-inicio  dt-termino  situacao
                                          nr-tab       mo-codigo    frete      taxa-financ nr-dias-taxa
                                          valor-frete  codigo-ipi   valor-taxa perc-descto cod-estabel) 
                    where tb-pr-cc.cod-emitente = emitente.cod-emitente     
                    and   tb-pr-cc.cod-cond-pag = rowObjectDefault.cod-cond-pag 
                    and   tb-pr-cc.dt-inicio   <= rowObjectDefault.data-cotacao  
                    and   tb-pr-cc.dt-termino  >= rowObjectDefault.data-cotacao  
                    AND   tb-pr-cc.cod-estabel  = ""
                    AND   tb-pr-cc.mo-codigo    = i-mo-codig
                    and   tb-pr-cc.situacao     = 1 no-lock: end.
                 
                    IF AVAIL tb-pr-cc THEN
                        ASSIGN iCodBusca = 2.
            END.
        END.
        ELSE DO:
            for first tb-pr-cc fields(cod-emitente cod-cond-pag dt-inicio  dt-termino  situacao
                                      nr-tab       mo-codigo    frete      taxa-financ nr-dias-taxa
                                      valor-frete  codigo-ipi   valor-taxa perc-descto cod-estabel) 
                where tb-pr-cc.cod-emitente = emitente.cod-emitente     
                and   tb-pr-cc.cod-cond-pag = rowObjectDefault.cod-cond-pag 
                and   tb-pr-cc.dt-inicio   <= rowObjectDefault.data-cotacao  
                and   tb-pr-cc.dt-termino  >= rowObjectDefault.data-cotacao  
                AND   tb-pr-cc.cod-estabel  = c-cod-estabel-aux
                and   tb-pr-cc.situacao     = 1 no-lock: end.
                
            IF AVAIL tb-pr-cc THEN
                ASSIGN iCodBusca = 3.
            ELSE DO:
                for first tb-pr-cc fields(cod-emitente cod-cond-pag dt-inicio  dt-termino  situacao
                                      nr-tab       mo-codigo    frete      taxa-financ nr-dias-taxa
                                      valor-frete  codigo-ipi   valor-taxa perc-descto cod-estabel) 
                where tb-pr-cc.cod-emitente = emitente.cod-emitente     
                and   tb-pr-cc.cod-cond-pag = rowObjectDefault.cod-cond-pag 
                and   tb-pr-cc.dt-inicio   <= rowObjectDefault.data-cotacao  
                and   tb-pr-cc.dt-termino  >= rowObjectDefault.data-cotacao  
                AND   tb-pr-cc.cod-estabel  = ""
                and   tb-pr-cc.situacao     = 1 no-lock: end.
        
                IF AVAIL tb-pr-cc THEN
                    ASSIGN iCodBusca = 4.
            END.
        END.

        assign deQtParcela = deQtParcela * deConver.
        
        /*procurar item-tab*/
        IF AVAIL tb-pr-cc THEN DO:
            REPEAT:
                for last item-tab fields(it-codigo cod-emitente cod-cond-pag nr-tab quant-min 
                                         pr-item   aliquota-ipi desco-quant aliquota-icm cod-estabel mo-codigo)
                    where item-tab.it-codigo    = RowObjectDefault.it-codigo 
                    and   item-tab.cod-emitente = emitente.cod-emitente 
                    and   item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag 
                    and   item-tab.nr-tab       = tb-pr-cc.nr-tab
                    AND   item-tab.cod-estabel  = tb-pr-cc.cod-estabel
                    AND   item-tab.mo-codigo    = tb-pr-cc.mo-codigo
                    and   item-tab.quant-min   <= deQtParcela no-lock: end.
                if  not available item-tab then
                    for first item-tab fields(it-codigo cod-emitente cod-cond-pag nr-tab quant-min 
                                              pr-item   aliquota-ipi desco-quant aliquota-icm mo-codigo cod-estabel mo-codigo) 
                        where item-tab.cod-emitente = emitente.cod-emitente 
                        and   item-tab.nr-tab       = tb-pr-cc.nr-tab       
                        and   item-tab.cod-cond-pag = tb-pr-cc.cod-cond-pag 
                        AND   item-tab.cod-estabel  = tb-pr-cc.cod-estabel
                        AND   item-tab.mo-codigo    = tb-pr-cc.mo-codigo
                        and   item-tab.it-codigo    = RowObjectDefault.it-codigo no-lock: end.
        
                /* achou item-tab, encerrar busca */
                IF  AVAILABLE item-tab THEN
                    LEAVE.
        
                CASE iCodBusca:
                    WHEN 1 THEN DO:
                        FIND NEXT tb-pr-cc                                                      
                        WHERE tb-pr-cc.cod-emitente = emitente.cod-emitente                 
                          AND tb-pr-cc.cod-cond-pag = rowObjectDefault.cod-cond-pag    
                          AND tb-pr-cc.dt-inicio   <= rowObjectDefault.data-cotacao     
                          AND tb-pr-cc.dt-termino  >= rowObjectDefault.data-cotacao     
                          AND tb-pr-cc.cod-estabel  = c-cod-estabel-aux
                          AND tb-pr-cc.mo-codigo    = i-mo-codig
                          AND tb-pr-cc.situacao     = 1 NO-LOCK NO-ERROR.
                    END.
        
                    WHEN 2 THEN DO:
                        FIND NEXT tb-pr-cc                                                  
                            WHERE tb-pr-cc.cod-emitente = emitente.cod-emitente             
                              AND tb-pr-cc.cod-cond-pag = rowObjectDefault.cod-cond-pag
                              AND tb-pr-cc.dt-inicio   <= rowObjectDefault.data-cotacao 
                              AND tb-pr-cc.dt-termino  >= rowObjectDefault.data-cotacao 
                              AND tb-pr-cc.cod-estabel  = ""                                
                              AND tb-pr-cc.mo-codigo    = i-mo-codig
                              AND tb-pr-cc.situacao     = 1 NO-LOCK NO-ERROR.
                    END.
        
                    WHEN 3 THEN DO:
                        FIND NEXT tb-pr-cc                                                  
                            WHERE tb-pr-cc.cod-emitente = emitente.cod-emitente             
                              AND tb-pr-cc.cod-cond-pag = rowObjectDefault.cod-cond-pag
                              AND tb-pr-cc.dt-inicio   <= rowObjectDefault.data-cotacao 
                              AND tb-pr-cc.dt-termino  >= rowObjectDefault.data-cotacao 
                              AND tb-pr-cc.cod-estabel  = c-cod-estabel-aux
                              AND tb-pr-cc.situacao     = 1 NO-LOCK NO-ERROR.
                    END.
        
                    WHEN 4 THEN DO:
                        FIND NEXT tb-pr-cc                                                  
                            WHERE tb-pr-cc.cod-emitente = emitente.cod-emitente             
                              AND tb-pr-cc.cod-cond-pag = rowObjectDefault.cod-cond-pag
                              AND tb-pr-cc.dt-inicio   <= rowObjectDefault.data-cotacao 
                              AND tb-pr-cc.dt-termino  >= rowObjectDefault.data-cotacao 
                              AND tb-pr-cc.cod-estabel  = ""                                
                              AND tb-pr-cc.situacao     = 1 NO-LOCK NO-ERROR.
                    END.
                END CASE.
                    
                /* se n∆o tiver mais tabela de preáo, encerrar busca */
                IF NOT AVAIL tb-pr-cc THEN
                    LEAVE.
            END.
        END.
    
        IF AVAIL item-tab THEN DO:
            ASSIGN rowObjectDefault.preco-fornec = item-tab.pr-Item
                   rowObjectDefault.mo-codigo = tb-pr-cc.mo-codigo. 
        END.
    END.

    if  avail item-tab 
    and avail tb-pr-cc then 
        assign rwTbPrCc  = if avail tb-pr-cc then rowid(tb-pr-cc) else ?
               rwTabItem = if avail item-tab then rowid(item-tab) else ?.

    find bfcotacao-item where rowid(bfcotacao-item) = rbCotacaoItem no-lock no-error.
    find item-tab       where rowid(item-tab)       = rwTabItem     no-lock no-error.
    find tb-pr-cc       where rowid(tb-pr-cc)       = rwTbPrCc     no-lock no-error.

    if  rowid(b-cot-item) <> ? 
    and avail bfcotacao-item then
        assign  rowObjectDefault.preco-fornec = bfcotacao-item.preco-fornec
                rowObjectDefault.mo-codigo    = bfcotacao-item.mo-codigo
                rowObjectDefault.valor-taxa   = bfcotacao-item.valor-taxa
                rowObjectDefault.nr-dias-taxa = bfcotacao-item.nr-dias-taxa
                rowObjectDefault.taxa-financ  = bfcotacao-item.taxa-financ
                rowObjectDefault.un           = bfcotacao-item.un.

    if  rwTbPrCc <> ? then do :
        assign rowObjectDefault.taxa-financ  = tb-pr-cc.taxa-financ.
        if tb-pr-cc.taxa-financ then do:
            assign rowObjectDefault.valor-taxa   = tb-pr-cc.valor-taxa   
                   rowObjectDefault.nr-dias-taxa = tb-pr-cc.nr-dias-taxa .
        end.
    end.
    else do:
        if  avail emitente then 
            if  (emitente.nr-dias-taxa = 0 or 
                 emitente.nr-dias-taxa = ? )
            and (emitente.taxa-financ = 0  or
                 emitente.taxa-financ = ? )
        then do: 
            assign rowObjectDefault.taxa-financ  = param-compra.utiliza-taxa.
                if  param-compra.utiliza-taxa then
                    assign rowObjectDefault.valor-taxa   = param-compra.taxa-financ
                           rowObjectDefault.nr-dias-taxa = param-compra.nr-dias-taxa.
        end.
        else do:
             assign rowObjectDefault.valor-taxa   = emitente.taxa-financ
                    rowObjectDefault.nr-dias-taxa = emitente.nr-dias-taxa.
        end.
    end.

    if rwTabItem <> ? then
       assign rowObjectDefault.aliquota-ipi = item-tab.aliquota-ipi
              rowObjectDefault.aliquota-icm = item-tab.aliquota-icm.

    if rwTbPrCc <> ? then 
       assign rowObjectDefault.codigo-ipi  = tb-pr-cc.codigo-ipi
              rowObjectDefault.frete       = tb-pr-cc.frete
              rowObjectDefault.valor-frete = tb-pr-cc.valor-frete.

    if rbCotacaoItem = ? and rwTbPrCc = ? then do :
       assign rowObjectDefault.aliquota-iss = param-compra.aliq-iss-pad
              rowObjectDefault.aliquota-icm = param-compra.aliq-icm-pad.

       if available item then
          assign rowObjectDefault.aliquota-ipi = item.aliquota-ipi . 
       if avail ordem-compra then
          assign rowObjectDefault.codigo-icm = IF AVAIL ordem-compra THEN 
                                                   ordem-compra.codigo-icm 
                                               ELSE 1.
       if available item 
       and item.aliquota-ipi = 0 then do:
           
          for first classif-fisc fields(class-fiscal aliquota-ipi) where 
              classif-fisc.class-fiscal = item.class-fiscal no-lock: end.
          if avail classif-fisc then 
             assign rowObjectDefault.codigo-ipi    = yes
                    rowObjectDefault.aliquota-ipi  = classif-fisc.aliquota-ipi.
       end.
    end.

    if  rbCotacaoItem <> ? then 
        assign  rowObjectDefault.perc-descto  = bfcotacao-item.perc-descto
                rowObjectDefault.valor-descto = bfcotacao-item.valor-descto.
    
    if  rwTabItem <> ? then 
        assign rowObjectDefault.perc-descto = item-tab.desco-quant.
    
    if  rwTbPrCc <> ? then do:
        if rowObjectDefault.perc-descto = 0 then
            assign rowObjectDefault.perc-descto  = tb-pr-cc.perc-descto 
                   rowObjectDefault.cod-cond-pag = tb-pr-cc.cod-cond-pag.
    end.
    
    if  rbCotacaoItem <> ? and rwTbPrCc <> ? then do:
        if avail ordem-compra then do:
                for first emitente fields(cod-emitente cod-cond-pag) where
                          emitente.cod-emitente = ordem-compra.cod-emitente no-lock: end.
            if avail emitente then 
                assign rowObjectDefault.cod-cond-pag = emitente.cod-cond-pag.
            
            for first cont-emit fields(cod-emitente nome sequencia)
               where cont-emit.cod-emitente = emitente.cod-emitente
                and cont-emit.sequencia = 1 no-lock: end.
            if  avail cont-emit then
               assign rowObjectDefault.contato = substring(cont-emit.nome, 1, 12).
        end.
    end.
    
    IF AVAIL ordem-compra 
    AND ordem-compra.natureza = 2 then /* servico */
      ASSIGN rowObjectDefault.aliquota-ipi = 0
             rowObjectDefault.aliquota-icm = 0.

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setPurchaseRequisition DBOProgram 
PROCEDURE setPurchaseRequisition :
/*------------------------------------------------------------------------------
  Purpose: Seta valores da ordem de compra para setar defaults da cotaá∆o 
           (usado no pedido emergencial)
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter table for ttPurchaseRequisition.

    find first ttPurchaseRequisition no-error.

    return "OK".
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setPurchRequisitionSite DBOProgram 
PROCEDURE setPurchRequisitionSite :
/*------------------------------------------------------------------------------
  Purpose:     Setar o cod-estabel da ordem
  Parameters:  p-estabel LIKE ordem-compra.cod-estabel
  Notes:       Necessario para tornar o metodo setFinancialFields utilizavel para Ped Emerg
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-estabel LIKE ordem-compra.cod-estabel NO-UNDO.

    IF p-estabel = "" THEN DO:
        {cdp/findordemcompra.i RowObject.numero-ordem}
        IF AVAIL ordem-compra THEN
            ASSIGN c-cod-estabel = ordem-compra.cod-estabel.
    END.
    ELSE
        ASSIGN c-cod-estabel = p-estabel.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setQuotationDate DBOProgram 
PROCEDURE setQuotationDate :
/*------------------------------------------------------------------------------
  Purpose:     Retornar comprador da ordem
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    def output param p-data-cotacao like RowObject.data-cotacao no-undo.

    ASSIGN p-data-cotacao = today.

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaImportacao DBOProgram 
PROCEDURE verificaImportacao :
/*------------------------------------------------------------------------------
  Purpose:     Verifica se o m¢dulo de importaá∆o est† habilitado e se emitente Ç estrangeiro
  Parameters:  retorna se campo deve ser habilitado ou desabilitado
  Notes:       
------------------------------------------------------------------------------*/
    def output param p-habilita AS LOG no-undo.

    {cdp/findparamglobal.i}
    ASSIGN p-habilita = YES.
    IF AVAIL param-global AND param-global.modulo-07 = YES THEN DO:

        FOR FIRST emitente FIELDS (natureza cod-emitente) 
            WHERE emitente.cod-emitente = rowObject.cod-emitente NO-LOCK:         
        END.

        IF AVAIL emitente AND 
                (emitente.natureza = 3  OR       /* Estrangeiro */
                 emitente.natureza = 4) AND 
                 CONNECTED("mgcex":U) THEN
            ASSIGN p-habilita = NO.
    END.

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

