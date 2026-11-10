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
{include/i-prgvrs.i BOAD229A 2.00.00.012}  /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOAD229A MUT}
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
&GLOBAL-DEFINE DBOName 
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName 
&GLOBAL-DEFINE TableLabel 


/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{adbo/boad229a.i RowObject}
/* miniflexibiliza‡Æo */
{include/i_dbvers.i}

{cdp/cdcfgfin.i}

/* Defini‡äes para SetConstraintS */
define variable i-repres-ini as integer no-undo.
define variable i-repres-fim as integer no-undo.
define variable c-tipo as char format "x(10)" no-undo.

DEF VAR v_log_filtro AS LOG INIT NO NO-UNDO.

DEF VAR l-funcao-portador-ap AS LOG NO-UNDO.

/* Verifica fun‡Æo */
{include/getdefinedfunction.i}
assign l-funcao-portador-ap = &if defined(BF_FIN_PORTADOR_AP) &then yes &else GetDefinedFunction("SPP-PORTADOR-AP") &endif.

DEF TEMP-TABLE RowObject_2 LIKE RowObject
    INDEX tt_id  IS PRIMARY UNIQUE
          cod-rep.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOFunction
&Scoped-define DB-AWARE no



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
         HEIGHT             = 9.83
         WIDTH              = 42.14.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AtualizDTREs DBOFunction 
PROCEDURE AtualizDTREs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    define input parameter i-cod-rep as integer no-undo.
    define input parameter p-dt-res as date format "99/99/9999" no-undo.
    
    find repres where repres.cod-rep = i-cod-rep exclusive-lock no-error.
    if avail repres then 
       assign repres.dt-deslig = p-dt-res.

    return "OK":U.           
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IntegracaoRacAP DBOFunction 
PROCEDURE IntegracaoRacAP :
/*------------------------------------------------------------------------------
  Purpose:     Preparar temp-table de representantes com todas as informa‡äes
               necess rias para a Integra‡ao do Rac com Contas a Pagar
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    define output parameter table for RowObject.
   
    for each repres where
             repres.cod-rep >= i-repres-ini and
             repres.cod-rep <= i-repres-fim 
             no-lock:

        create RowObject.
        assign RowObject.cod-rep          = repres.cod-rep
               RowObject.nome             = repres.nome
               RowObject.nome-abrev       = repres.nome-abrev
               RowObject.tipo-repres      = repres.tipo-repres
               RowObject.calendario-pagto = repres.calendario-pagto
               RowObject.cod-emitente     = repres.cod-emitente
               RowObject.cod-imposto      = if c-tipo = "IR" then repres.cod-tax else repres.cod-tax-indeniz
               RowObject.cod-retencao     = if c-tipo = "IR" then repres.cod-retencao else repres.cod-retenc-indeniz
               RowObject.bloqueado-pagto  = repres.bloqueado-pagto
               RowObject.r-Rowid          = rowid(repres)
               RowObject.vl-minimo-comis  = repres.vl-minimo-comis
               RowObject.mo-codigo        = repres.mo-codigo.
        
        find emitente use-index codigo where
             emitente.cod-emitente = RowObject.cod-emitente
             no-lock no-error.
        if  avail emitente then DO:
            IF l-funcao-portador-ap = NO THEN DO:
              assign RowObject.cod-portador = emitente.portador
                     RowObject.modalidade   = emitente.modalidade.
            END.
            ELSE DO:
                &if "{&mgadm_version}" >= "2.06b" &then
                    ASSIGN RowObject.cod-portador = emitente.portador-ap
                           RowObject.modalidade   = emitente.modalidade-ap.
                &else
                    ASSIGN RowObject.cod-portador = int(SUBSTR(emitente.char-1,31,5))
                           RowObject.modalidade   = int(SUBSTR(emitente.char-1,36,2)).
                &endif
            END.
            ASSIGN RowObject.tp-pagto     = emitente.tp-pagto.
        END.

        find tipo-tax use-index ch-tipo-tax where
             tipo-tax.cod-tax = RowObject.cod-imposto
             no-lock no-error.
        if  avail tipo-tax then 
            assign RowObject.perc-imposto   = tipo-tax.tax-perc
                   RowObject.conta-imposto  = tipo-tax.conta-tax
                   RowObject.ct-imposto     = tipo-tax.ct-tax
                   RowObject.sc-imposto     = tipo-tax.sc-tax
                   RowObject.cod-esp-ir     = tipo-tax.cod-esp
                   RowObject.serie-ir       = tipo-tax.serie
                   RowOBject.vl-minimo-ret  = tipo-tax.vl-minimo-retencao.        
    end.

    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IntegracaoRacAP_2 DBOFunction 
PROCEDURE IntegracaoRacAP_2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER TABLE FOR RowObject_2.

    for each repres FIELDS(cod-rep
                           nome
                           nome-abrev
                           tipo-repres
                           calendario-pagto
                           cod-emitente
                           repres.cod-tax
                           repres.cod-tax-indeniz
                           repres.cod-retencao
                           repres.cod-retenc-indeniz
                           bloqueado-pagto
                           dt-deslig
                           vl-minimo-comis
                           mo-codigo)
         WHERE repres.cod-rep >= i-repres-ini and
               repres.cod-rep <= i-repres-fim no-lock:

        IF  v_log_filtro AND 
            repres.tipo-repres <> 2 THEN
            NEXT.

        create RowObject_2.
        assign RowObject_2.cod-rep          = repres.cod-rep
               RowObject_2.nome             = repres.nome
               RowObject_2.nome-abrev       = repres.nome-abrev
               RowObject_2.tipo-repres      = repres.tipo-repres
               RowObject_2.calendario-pagto = repres.calendario-pagto
               RowObject_2.cod-emitente     = repres.cod-emitente
               RowObject_2.cod-imposto      = if c-tipo = "IR" then repres.cod-tax else repres.cod-tax-indeniz
               RowObject_2.cod-retencao     = if c-tipo = "IR" then repres.cod-retencao else repres.cod-retenc-indeniz
               RowObject_2.bloqueado-pagto  = repres.bloqueado-pagto
               RowObject_2.r-Rowid          = rowid(repres)
               RowObject_2.vl-minimo-comis  = repres.vl-minimo-comis
               RowObject_2.mo-codigo        = repres.mo-codigo
               RowObject_2.log-desligado    = (repres.dt-deslig <> ?)
               RowObject_2.log-bloqueado    = repres.bloqueado-pagto.

        FOR FIRST emitente FIELDS(portador
                                  modalidade
                                  tp-pagto
                                  &if "{&mgadm_version}" >= "2.06b" &then
                                     emitente.portador-ap
                                     emitente.modalidade-ap
                                  &else
                                     emitente.char-1
                                  &endif) use-index codigo
            WHERE emitente.cod-emitente = RowObject_2.cod-emitente no-lock:
            ASSIGN RowObject_2.tp-pagto     = emitente.tp-pagto.
            IF l-funcao-portador-ap = NO THEN DO:
              assign RowObject_2.cod-portador = emitente.portador
                     RowObject_2.modalidade   = emitente.modalidade.
            END.
            ELSE DO:
                &if "{&mgadm_version}" >= "2.06b" &then
                    ASSIGN RowObject_2.cod-portador = emitente.portador-ap
                           RowObject_2.modalidade   = emitente.modalidade-ap.
                &else
                    ASSIGN RowObject_2.cod-portador = int(SUBSTR(emitente.char-1,31,5))
                           RowObject_2.modalidade   = int(SUBSTR(emitente.char-1,36,2)).
                &endif
            END.
            ASSIGN RowObject_2.tp-pagto     = emitente.tp-pagto.
        END.

        FOR FIRST tipo-tax FIELDS(tax-perc
                                  conta-tax
                                  ct-tax
                                  sc-tax
                                  cod-esp
                                  serie
                                  vl-minimo-retencao) use-index ch-tipo-tax
            WHERE tipo-tax.cod-tax = RowObject_2.cod-imposto no-lock:
            assign RowObject_2.perc-imposto   = tipo-tax.tax-perc
                   RowObject_2.conta-imposto  = tipo-tax.conta-tax
                   RowObject_2.ct-imposto     = tipo-tax.ct-tax
                   RowObject_2.sc-imposto     = tipo-tax.sc-tax
                   RowObject_2.cod-esp-ir     = tipo-tax.cod-esp
                   RowObject_2.serie-ir       = tipo-tax.serie
                   RowObject_2.vl-minimo-ret  = tipo-tax.vl-minimo-retencao.
        END.
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintIntegracaoIndenizacao DBOFunction 
PROCEDURE SetConstraintIntegracaoIndenizacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    define input parameter p-repres-ini as integer no-undo.
    define input parameter p-repres-fim as integer no-undo.
    
    assign i-repres-ini = p-repres-ini
           i-repres-fim = p-repres-fim
           c-tipo       = "IR Indeniza‡Æo".
           

    return "OK":U.     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintIntegracaoRacAP DBOFunction 
PROCEDURE SetConstraintIntegracaoRacAP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    define input parameter p-repres-ini as integer no-undo.
    define input parameter p-repres-fim as integer no-undo.
    
    assign i-repres-ini = p-repres-ini
           i-repres-fim = p-repres-fim
           c-tipo       = "IR".

    return "OK":U.           
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintIntegracaoRacAP_filtro DBOFunction 
PROCEDURE SetConstraintIntegracaoRacAP_filtro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-repres-ini AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-repres-fim AS INTEGER NO-UNDO.
    
    ASSIGN i-repres-ini = p-repres-ini
           i-repres-fim = p-repres-fim
           c-tipo       = "IR"
           v_log_filtro = YES.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

