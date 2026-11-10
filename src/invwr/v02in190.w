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
{include/i-prgvrs.i V02IN190 2.00.00.039 } /*** "010039" 27/08/2025 09:37:46 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v02in190 MUT}
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
{include/i-vrtab.i lote}
 
/* Parameters Definitions ---                                           */
{cdp/cdcfgmat.i}
{cdp/cdcfgman.i}
{cdp/cd0666.i} /*Defini‡Æo temp-table de erro*/

/* Local Variable Definitions ---                                       */
 DEF VAR c_Handle              AS CHAR   NO-UNDO.
 DEF VAR h_b07in403            AS HANDLE NO-UNDO.
 DEF VAR h_p-cadsi2            AS HANDLE NO-UNDO.
 DEF VAR l-sistema-externo     AS LOG    NO-UNDO.
 DEF VAR i-seq                 AS INT    NO-UNDO.
 
 def buffer b-saldo for saldo-estoq.


 /* Nota Fiscal Eletronica */
 def new global shared var v_log_eai_habilit as log no-undo.
 def var h-axsar009          as handle  no-undo.
 def temp-table tt_log_erro  no-undo
     field ttv_num_cod_erro  as integer   initial ?
     field ttv_des_msg_ajuda as character initial ?
     field ttv_des_msg_erro  as character initial ?.

&IF '{&mgscm_version}' >= '2.06B' &THEN
DEFINE VARIABLE hDBOproxy AS HANDLE NO-UNDO.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES saldo-estoq
&Scoped-define FIRST-EXTERNAL-TABLE saldo-estoq


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR saldo-estoq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS saldo-estoq.dt-fabric ~
saldo-estoq.dt-vali-lote i-per-ppm
&Scoped-define ENABLED-TABLES saldo-estoq
&Scoped-define FIRST-ENABLED-TABLE saldo-estoq
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS saldo-estoq.lote saldo-estoq.it-codigo ~
saldo-estoq.dt-fabric saldo-estoq.dt-vali-lote 
&Scoped-define DISPLAYED-TABLES saldo-estoq
&Scoped-define FIRST-DISPLAYED-TABLE saldo-estoq
&Scoped-Define DISPLAYED-OBJECTS c-des-item i-per-ppm 

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
DEFINE VARIABLE c-des-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .88 NO-UNDO.

DEFINE VARIABLE i-per-ppm AS DECIMAL FORMAT ">>>>,>>9.9999":U INITIAL 0 
     LABEL "Concentra‡Æo / Ppm" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 3.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     saldo-estoq.lote AT ROW 1.25 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 35 BY .88
     saldo-estoq.it-codigo AT ROW 2.25 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-des-item AT ROW 2.25 COL 33 COLON-ALIGNED NO-LABEL
     saldo-estoq.dt-fabric AT ROW 3.21 COL 74.14 COLON-ALIGNED WIDGET-ID 2
          LABEL "Data Fabric"
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     saldo-estoq.dt-vali-lote AT ROW 3.25 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     i-per-ppm AT ROW 3.25 COL 49 COLON-ALIGNED HELP
          "Fator Concentra‡Æo / Ppm"
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.saldo-estoq
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 3.42
         WIDTH              = 88.57.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN c-des-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN saldo-estoq.dt-fabric IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN i-per-ppm IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN saldo-estoq.it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN saldo-estoq.lote IN FRAME f-main
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
  {src/adm/template/row-list.i "saldo-estoq"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "saldo-estoq"}

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
    {include/i-valid.i}

    /* Efetua as validacoes necessarias -------------------------------------*/
    run pi-validate in this-procedure.

    if return-value = "ADM-ERROR" then
        return "ADM-ERROR".

    RUN cdp/cdapi026.p (INPUT INPUT FRAME {&frame-name} saldo-estoq.it-codigo,
                        INPUT INPUT FRAME {&frame-name} saldo-estoq.lote,
                        INPUT input frame {&frame-name} saldo-estoq.dt-vali-lot,
                        INPUT input frame {&frame-name} saldo-estoq.dt-fabric,
                        INPUT input frame {&frame-name} i-per-ppm,
                        OUTPUT TABLE tt-erro).

    IF RETURN-VALUE = "NOK":U  THEN DO:
        RUN cdp/cd0666.w (INPUT TABLE tt-erro).
        RETURN "ADM-ERROR":U.
    END.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
 
    IF RETURN-VALUE = 'ADM-ERROR':U then 
        RETURN 'ADM-ERROR':U.

 
    c_handle = "".
    RUN get-link-handle IN adm-broker-hdl
        (INPUT this-procedure,
         INPUT "RECORD-TARGET",
         OUTPUT c_handle).
 
    if c_handle <> "" THEN
    DO :
        RUN DISPATCH IN WIDGET-HANDLE(c_Handle) ("OPEN-QUERY").
    END.

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
  if avail saldo-estoq then do:
 
     for first item fields(it-codigo 
                           desc-item
                           tipo-con-est) where 
               item.it-codigo = saldo-estoq.it-codigo no-lock : end.
     assign c-des-item = if avail item then item.desc-item else "":U.
     
  end.
  
  &if defined (bf_man_per_ppm) &then    
     IF AVAIL saldo-estoq THEN DO:
       FIND FIRST ITEM WHERE ITEM.it-codigo = saldo-estoq.it-codigo NO-LOCK NO-ERROR.
       IF AVAIL ITEM THEN DO:
          IF ITEM.TIPO-FORMULA = 1 THEN ASSIGN I-PER-PPM:LABEL in frame {&frame-name} = 'NÆo Utiliza'.
          IF ITEM.tipo-formula = 2 THEN DO:
             ASSIGN i-per-ppm:FORMAT             IN FRAME {&frame-name} = ">>9.9999".
             ASSIGN i-per-ppm:LABEL              in frame {&frame-name} = 'Concentra‡Æo(%)'.
          END.
          IF ITEM.tipo-formula = 3 THEN ASSIGN i-per-ppm:LABEL in frame {&frame-name} = 'PPM'.
          IF ITEM.tipo-formula = 4 THEN ASSIGN i-per-ppm:LABEL IN FRAME {&frame-name} = 'Ve¡culo'.
       END.
       ASSIGN i-per-ppm  = saldo-estoq.per-ppm.
     END.
  &endif
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
 
  if valid-handle(h_p-cadsi2) = yes and
     avail item and (item.tipo-con-est = 3 or item.tipo-con-est = 4) then 
     RUN enable-modifica IN h_p-cadsi2(INPUT yes). 
  else
    if valid-handle(h_p-cadsi2) = yes then
       RUN enable-modifica IN h_p-cadsi2 (INPUT no).

  if valid-handle(h_b07in403) = yes then do:
    run pi-monta-browse in h_b07in403 (input input frame {&frame-name} saldo-estoq.lote,  
                                       input input frame {&frame-name} saldo-estoq.it-codigo).
  end.     

  ENABLE saldo-estoq.lote with frame {&frame-name}.
  ASSIGN saldo-estoq.lote:READ-ONLY IN FRAME {&FRAME-NAME} = YES.

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
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  &if defined (bf_man_per_ppm) &then    
    IF ITEM.TIPO-FORMULA = 1 OR ITEM.tipo-formula = 4 THEN do:
         DISABLE i-per-ppm with frame {&frame-name}.
    END.
    ELSE DO:
      FIND FIRST b-saldo USE-INDEX lote where 
                 b-saldo.it-codigo = input frame {&frame-name} saldo-estoq.it-codigo AND
                 b-saldo.lote      = INPUT FRAME {&frame-name} saldo-estoq.lote      AND
                 b-saldo.qt-aloc-prod <> 0 NO-LOCK NO-ERROR.
      IF AVAIL b-saldo THEN DO:
         DISABLE i-per-ppm with frame {&frame-name}.
      END.
    END.
  &endif
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  &if defined (bf_man_per_ppm) &then    
  &else
     ASSIGN i-per-ppm:HIDDEN IN FRAME f-main = YES.
  &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-handle-p-cadsi2 V-table-Win 
PROCEDURE pi-handle-p-cadsi2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param h-handle as handle no-undo.
 
assign h_p-cadsi2 = h-handle.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-handle V-table-Win 
PROCEDURE pi-passa-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter handle-browse as handle no-undo.
 
assign h_b07in403 = handle-browse.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */
 
/*/*    Segue um exemplo de valida‡Æo de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/
     
                         
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
  {src/adm/template/snd-list.i "saldo-estoq"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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



