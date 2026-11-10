&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          movind           PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V08IN271 2.00.00.084} /*** "010084" 10/06/2024 09:08:01 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v08in271 MUT}
&ENDIF

/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{cdp/cd9203.i}

DEF NEW GLOBAL SHARED VAR gr-ord-prod AS rowid NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-item     AS rowid NO-UNDO.

def var c-erro    as char no-undo.
def var c-texto   as char no-undo.
def var c-retorno as char no-undo.
def var h-acomp   as handle no-undo.
def var c-handle  as char no-undo.

DEF VAR l-usa-unid-negoc    AS LOGICAL NO-UNDO.
&GLOBAL-DEFINE bf_Program

/** Unifica‡Æo de Conceito **/
{cdp/cdunif001.i}

{cdp/cdcfgman.i}   /* Vari vel preprocessador bf_man_sfc_lc */
{cdp/cdcfgmat.i}   /* Vari vel preprocessador bf_mat_conta_estab */
{cpp/cpapi301.i}
{cdp/cd0666.i}
{cpp/cpapi301.i23}
{cpp/cpapi301.i21} 

DEFINE VARIABLE h-handle-pai AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES ord-prod
&Scoped-define FIRST-EXTERNAL-TABLE ord-prod


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ord-prod.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ord-prod.nr-ord-produ ord-prod.cod-refer 
&Scoped-define ENABLED-TABLES ord-prod
&Scoped-define FIRST-ENABLED-TABLE ord-prod
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS ord-prod.nr-ord-produ ord-prod.it-codigo ~
ord-prod.qt-ordem ord-prod.un ord-prod.cod-refer 
&Scoped-define DISPLAYED-TABLES ord-prod
&Scoped-define FIRST-DISPLAYED-TABLE ord-prod
&Scoped-Define DISPLAYED-OBJECTS fi-estado fi-descricao fi-rep-prod ~
c-unid-negoc c-processo 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-processo AS CHARACTER FORMAT "X(30)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE c-unid-negoc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Unid. Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-descricao AS CHARACTER FORMAT "x(255)" 
     VIEW-AS FILL-IN 
     SIZE 49.72 BY .88.

DEFINE VARIABLE fi-estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE fi-rep-prod AS CHARACTER FORMAT "X(20)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86 BY 4.21.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ord-prod.nr-ord-produ AT ROW 1.17 COL 17.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.86 BY .88
     fi-estado AT ROW 1.17 COL 65.29 COLON-ALIGNED
     ord-prod.it-codigo AT ROW 2.17 COL 17.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     fi-descricao AT ROW 2.17 COL 34.57 COLON-ALIGNED NO-LABEL
     ord-prod.qt-ordem AT ROW 3.17 COL 17.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19 BY .88
     ord-prod.un AT ROW 3.17 COL 36.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     fi-rep-prod AT ROW 3.17 COL 65.29 COLON-ALIGNED
     ord-prod.cod-refer AT ROW 4.17 COL 17.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     c-unid-negoc AT ROW 4.17 COL 46 COLON-ALIGNED
     c-processo AT ROW 4.17 COL 65.29 COLON-ALIGNED
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.ord-prod
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 4.21
         WIDTH              = 86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-processo IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-processo:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-unid-negoc IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-unid-negoc:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN fi-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-estado IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-rep-prod IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-prod.it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-prod.qt-ordem IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-prod.un IN FRAME f-main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

  {utp/ut-field.i mgind ord-prod estado 1}.
  assign fi-estado:Label = return-value.

  {utp/ut-field.i mgind ord-prod rep-prod 1}
  assign fi-rep-prod:label = return-value.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "ord-prod"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ord-prod"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME f-main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
/*   RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) . */

  /* Code placed here will execute AFTER standard behavior.    */

  {include/i-epc015.i}  /* Ponto padrao de EPC DELETE*/
   for each tt-ord-prod:
      delete tt-ord-prod.
  end.

  create tt-ord-prod.
  assign tt-ord-prod.cod-versao-integracao = 003
         tt-ord-prod.ind-tipo-movto        = 3
         tt-ord-prod.nr-ord-produ          = ord-prod.nr-ord-produ.

  run utp/ut-msgs.p (input "show",
                     input 1550, 
                     input "").
  assign tt-ord-prod.verifica-compras = (return-value = "yes").

  /*** Valida opera‡Æo de item configurado ****/

  IF CAN-FIND(al-res-op WHERE al-res-op.nr-ord-res    = ord-prod.nr-ord-produ
                          AND al-res-op.nr-ord-produ <> 0) THEN DO:
     run utp/ut-msgs.p (input "show",
                        input 30000, 
                        input "").
     IF RETURN-VALUE = "no":U THEN
        return "adm-error".
  END.

  /********************************************/
  run pi-valida-ord-prod (input tt-ord-prod.ind-tipo-movto,
                          input yes,
                          input tt-ord-prod.nr-ord-produ,
                          output c-erro,
                          output c-texto).                      

  if return-value = "nok" and
      c-erro = "" then do:
    
      for each tt-erro:
    
          assign c-erro  = if c-erro = "" then string(tt-erro.cd-erro) else "," + string(tt-erro.cd-erro)
                 c-texto = if c-texto = "" then tt-erro.mensagem else "," + tt-erro.mensagem.
    
      end.
    
  end.

  if return-value = "nok" then do:
     run utp/ut-msgs.p (input "show",
                        input int (entry (num-entries (c-erro), c-erro)),
                        input entry (num-entries (c-texto), c-texto)).
     return "adm-error".
  end.
  else do:
      deleta:
      /** Bloco para deletar o registro da Ordem **/
      do transaction on error undo on stop undo:
           /********************* CHAMADA UPC *********************/
           /** Chamada referente …s chamadas X do Magnus do CP0301
               "Elimina" FO 817.259 - FRAS-LE **/

           RUN pi-upc (INPUT "Elim",
                       INPUT "Numero-Ordem",
                       INPUT ?,
                       INPUT ?,
                       INPUT "ord-prod",
                       INPUT ROWID(ord-prod)).

           if return-value = "NOK":U then
              undo deleta, return "adm-error":U.

           /******************************************************/
           run utp/ut-acomp.p persistent set h-acomp.
           run pi-inicializar in h-acomp (input "").
           {utp/ut-liter.i Excluindo_Relacionamentos_da_Ordem... mcp l} 
           run pi-acompanhar in h-acomp (input trim (return-value)).

           run cpp/cpapi301.p (input-output table tt-ord-prod,
                               input-output table tt-reapro,
                               input-output table tt-erro,
                               yes).
           assign c-retorno = return-value.

           run pi-finalizar in h-acomp.

           find first tt-erro no-lock no-error.
           if avail tt-erro then
              run cdp/cd0666.w (input table tt-erro).

           if c-retorno = "ok" then do:
              find first tt-ord-prod.
              find ord-prod where rowid (ord-prod) = tt-ord-prod.rw-ord-prod
                   no-lock no-error.
              assign adm-first-table = tt-ord-prod.rw-ord-prod.
           end.
           else return "adm-error".
      end.
  end.

  RUN get-link-handle IN adm-broker-hdl
     (INPUT this-procedure,
      INPUT "record-source",
      OUTPUT c-handle).

  run dispatch in widget-handle (c-handle) ('get-next':U).   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

    if  avail ord-prod then do:

        ASSIGN gr-ord-prod = ROWID(ord-prod).
	
	/* Esse FIND CURRENT atualiza o registro para que nos casos de alteracao externa via AppServer (APP mobile, TOTVS MES), 
         essas modificacoes fiquem disponiveis imediatamente nessa viewer */       
	           
        FIND CURRENT ord-prod NO-LOCK.

        find item
            where item.it-codigo = ord-prod.it-codigo no-lock no-error.
        if avail item then
            assign fi-descricao = item.desc-item.
        else
            assign fi-descricao = "".
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            
            run utp/ut-liter.p (REPLACE({ininc/i01in271.i 04 ord-prod.estado}, " ", "_"),"*","").
            assign fi-estado   = RETURN-VALUE.
            run utp/ut-liter.p ({ininc/i07in271.i 04 ord-prod.rep-prod},"*","").
            assign fi-rep-prod = return-value.
        &else
            assign fi-estado   = entry (ord-prod.estado, {ininc/i01in271.i 03})
                   fi-rep-prod = {ininc/i07in271.i 04 ord-prod.rep-prod}.
        &endif

        ASSIGN c-processo  = ord-prod.cod-lista-compon + " / " + ord-prod.cod-roteiro.

        IF l-usa-unid-negoc THEN DO:

            ASSIGN c-unid-negoc = ord-prod.cod-unid-negoc.

        END.
    end.
    ELSE
        ASSIGN gr-ord-prod = ?.

    /*Quando programa chamador = cp0301*/
    IF VALID-HANDLE(h-handle-pai) THEN
        RUN afterDisplayFields IN h-handle-pai.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  assign c-processo:hidden in frame {&frame-name} = no.

  {utp/ut-liter.i Processo * R}
  assign c-processo:label in frame {&frame-name} = trim(return-value).

  ASSIGN l-usa-unid-negoc = NO.

  IF CAN-FIND (FIRST funcao
               WHERE funcao.cd-funcao = "EMS2-UNIDADE-NEGOCIO"
               AND   funcao.ativo     = YES) THEN DO:

      ASSIGN l-usa-unid-negoc = YES.

  END.

  IF l-usa-unid-negoc THEN DO:

      ASSIGN c-unid-negoc:HIDDEN IN FRAME {&FRAME-NAME} = NO.

      {utp/ut-liter.i Unid._Negocio * R}
      ASSIGN c-unid-negoc:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

  END.
  ELSE DO:

      ASSIGN c-unid-negoc:HIDDEN IN FRAME {&FRAME-NAME} = YES.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  IF  AVAIL ord-prod THEN  
      ASSIGN gr-ord-prod = rowid (ord-prod).

  FIND item 
      WHERE item.it-codigo = ord-prod.it-codigo NO-LOCK NO-ERROR.
  IF  AVAIL item THEN
      ASSIGN gr-item = ROWID(item).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */


  /* Ponha aqui a valida‡Æo de chave duplicada */

  /* Ponha aqui as demais valida‡äes */

  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .


  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-upc V-table-Win 
PROCEDURE pi-upc :
/**********************************************************************
** UPC Especifica
** Podem ser passados parametros para ela afim de reutilizar o codigo
** se houver necessidade.
**********************************************************************/ 
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

    /* DPC */
    if  c-nom-prog-dpc-mg97 <> ""
    and c-nom-prog-dpc-mg97 <> ? then do:

        run value(c-nom-prog-dpc-mg97) (input p-ind-event,
                                        input p-ind-object,
                                        input THIS-PROCEDURE,
                                        input FRAME f-main:HANDLE,
                                        input p-cod-table,
                                        input p-row-table).

    end.

    /* APPC */
    if  c-nom-prog-appc-mg97 <> ""
    and c-nom-prog-appc-mg97 <> ? then do:

        run value(c-nom-prog-appc-mg97) (input p-ind-event,
                                         input p-ind-object,
                                         input THIS-PROCEDURE,
                                         input FRAME f-main:HANDLE,
                                         input p-cod-table,
                                         input p-row-table).

    end.

    /* UPC */
    if  c-nom-prog-upc-mg97 <> ""
    and c-nom-prog-upc-mg97 <> ? then do:
        run value(c-nom-prog-upc-mg97) (input p-ind-event,
                                        input p-ind-object,
                                        input THIS-PROCEDURE,
                                        input FRAME f-main:HANDLE,
                                        input p-cod-table,
                                        input p-row-table).
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "ord-prod"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaHandlePai V-table-Win 
PROCEDURE setaHandlePai :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-handle AS HANDLE NO-UNDO.

ASSIGN h-handle-pai = p-handle.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

