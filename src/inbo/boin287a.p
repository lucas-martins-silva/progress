&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOFunction 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN287A 2.00.00.007 } /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin287a MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : dbofun.p
    Purpose    : O DBO Function (Datasul Business Objects) ‚ um programa 
                 PROGRESS que cont‚m a l¢gica de neg¢cio.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN287A
&GLOBAL-DEFINE DBOVersion 1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName param-estoq    
&GLOBAL-DEFINE TableLabel Parƒmetros do Estoque


/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin287.i RowObject}
{cdp/cd0666.i} /* Defini‡Æo da tt-erro */

&GLOBAL-DEFINE ROW-NUM-DEFINED YES

def temp-table tt-docto NO-UNDO
    field num-docto         as char
    field cod-estabel       as char
    field cod-item          as char 
    field cod-refer         as char
    field cod-lote          as char
    field dt-validade       as date
    field qtd-item          as dec
    field num-docto-origem  as char.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOFunction



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOFunction
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOFunction ASSIGN
         HEIGHT             = 2.01
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOFunction 
/* ************************* Included-Libraries *********************** */

{method/dbofun.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOFunction 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE connectWMS DBOFunction 
PROCEDURE connectWMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER l-conecta AS LOGICAL NO-UNDO.

  &if "{&EMSFND_VERSION}" >= "1.00" &then
  &else
    
    IF  NOT CONNECTED("mgscm":U) THEN DO:
    
        FIND FIRST bco-ext
             WHERE bco-ext.nom-logic-bco = "mgscm":U NO-LOCK NO-ERROR.
        
        IF NOT AVAIL bco-ext THEN DO:
            RETURN "NOK":U.
        END.
        
        IF NOT CONNECTED(bco-ext.nom-logic-bco) THEN DO:
            /************* Conectando o Banco do WMS ************/
            CONNECT VALUE(bco-ext.localiz-fisic-bco) -ld
                    VALUE(bco-ext.nom-logic-bco) 
                    VALUE(bco-ext.param-conex-bco) NO-ERROR.
            
            IF NOT CONNECTED(bco-ext.nom-logic-bco) THEN DO:
                RETURN "NOK":U.
            END.  
            ASSIGN l-conecta = YES.
        END.
        ELSE 
            ASSIGN l-conecta = NO.
        RETURN 'nok':u.
    
    END.
    ELSE 
        ASSIGN l-conecta = NO.
  &endif
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createDocument DBOFunction 
PROCEDURE createDocument :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param r-docto       as rowid no-undo.
def output param table for    tt-erro.

def var hDBOWm-docto        as handle no-undo.

if not valid-handle(hDBOWm-docto) then
    run scbo/bosc038.p persistent set hDBOWm-docto.
    
find docum-est where
    rowid(docum-est) = r-docto no-lock no-error.

if avail docum-est then do:
    for each item-doc-est of docum-est where
        item-doc-est.baixa-ce = yes no-lock:
        find first item where 
             item.it-codigo = item-doc-est.it-codigo no-lock no-error.
        if avail item and item.tipo-contr = 1 then
            next.
        create tt-docto.
        assign tt-docto.num-docto        = docum-est.nro-docto
               tt-docto.cod-estabel      = docum-est.cod-estabel
               tt-docto.cod-item         = item-doc-est.it-codigo
               tt-docto.qtd-item         = item-doc-est.quantidade
               tt-docto.cod-refer        = item-doc-est.cod-refer
               tt-docto.cod-lote         = item-doc-est.lote 
               tt-docto.dt-validade      = item-doc-est.dt-vali-lote
               tt-docto.num-docto-origem = string(docum-est.serie-docto,"x(5)")       +
                                           string(docum-est.nro-docto,"x(16)")        +
                                           string(docum-est.cod-emitente,">>>>>>>>9") +
                                           string(docum-est.nat-operacao).
    end.
    if can-find(first tt-docto no-lock) then do:
        run makeReceiving in hDBOWm-docto (input table tt-docto,
                                           input docum-est.cod-emitente).
        if return-value = "NOK":U then do:
            run getRowErrors in hDBOWm-docto (output table RowErrors).
            run createErrors in this-procedure.
            return "NOK":U.
        end.
    end.
end.
else do:
    return "NOK":U.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createErrors DBOFunction 
PROCEDURE createErrors :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
for each RowErrors no-lock:
    create tt-erro.
    assign tt-erro.i-sequen    = RowErrors.ErrorSequence
           tt-erro.cd-erro     = RowErrors.ErrorNumber
           tt-erro.mensagem    = RowErrors.ErrorDescription.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disconnectWMS DBOFunction 
PROCEDURE disconnectWMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&if "{&EMSFND_VERSION}" >= "1.00" &then
&else

find first bco-ext where
    bco-ext.nom-logic-bco = "wms":U no-lock no-error.
if not avail bco-ext then do:
    return "NOK":U.
end.

Run btb/btb962zz.p (input bco-ext.nom-logic-bco). 

&endif

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


