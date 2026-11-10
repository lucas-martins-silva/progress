&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
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
{include/i-prgvrs.i V06IN661 2.00.00.004}  /*** 010004 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v06in661 MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

def var da-iniper      as date format "99/99/9999"   no-undo.
def var da-fimper      as date format "99/99/9999"   no-undo.
def var i-per-corrente as int  format "99"           no-undo.
def var i-ano-corrente as int  format "9999"         no-undo.
def var da-iniper-fech as date format "99/99/9999"   no-undo.
def var da-fimper-fech as date format "99/99/9999"   no-undo.

def var h-v01in661     as handle no-undo.
def var c-cod-estabel  as char   no-undo.

{cdp/cdcfgmat.i}

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
&Scoped-define EXTERNAL-TABLES estab-mat
&Scoped-define FIRST-EXTERNAL-TABLE estab-mat


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estab-mat.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-OBJECTS da-mensal-ate da-sumar-ate da-contab-ate ~
da-ult-fech-dia c-ult-per-fech da-ini-periodo da-fim-periodo 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS da-mensal-ate da-sumar-ate da-contab-ate ~
da-ult-fech-dia c-ult-per-fech da-ini-periodo da-fim-periodo 
&Scoped-define ADM-MODIFY-FIELDS da-mensal-ate da-sumar-ate da-contab-ate ~
da-ult-fech-dia c-ult-per-fech 

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
DEFINE VARIABLE c-ult-per-fech AS CHARACTER FORMAT "9999/99" 
     LABEL "éltimo per¡odo fechado" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE da-contab-ate AS DATE FORMAT "99/99/9999" INITIAL 03/09/00 
     LABEL "Contabilizado at‚" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88.

DEFINE VARIABLE da-fim-periodo AS DATE FORMAT "99/99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE VARIABLE da-ini-periodo AS DATE FORMAT "99/99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE VARIABLE da-mensal-ate AS DATE FORMAT "99/99/9999" INITIAL 03/09/00 
     LABEL "Data medio mensal" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88.

DEFINE VARIABLE da-sumar-ate AS DATE FORMAT "99/99/9999" INITIAL 03/09/00 
     LABEL "Sumarizado at‚" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88.

DEFINE VARIABLE da-ult-fech-dia AS DATE FORMAT "99/99/9999" INITIAL 03/09/00 
     LABEL "éltimo dia fechado" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.14 BY 7.46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     da-mensal-ate AT ROW 1.29 COL 36.43 COLON-ALIGNED
     da-sumar-ate AT ROW 2.29 COL 36.43 COLON-ALIGNED
     da-contab-ate AT ROW 3.29 COL 36.43 COLON-ALIGNED
     da-ult-fech-dia AT ROW 4.29 COL 36.43 COLON-ALIGNED
     c-ult-per-fech AT ROW 5.29 COL 36.43 COLON-ALIGNED
     da-ini-periodo AT ROW 6.29 COL 36.43 COLON-ALIGNED
     da-fim-periodo AT ROW 7.29 COL 36.43 COLON-ALIGNED
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.estab-mat
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
         HEIGHT             = 7.54
         WIDTH              = 86.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{include/i-auxtab.i}
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

/* SETTINGS FOR FILL-IN c-ult-per-fech IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN da-contab-ate IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN da-fim-periodo IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN da-ini-periodo IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN da-mensal-ate IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN da-sumar-ate IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN da-ult-fech-dia IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME c-ult-per-fech
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ult-per-fech V-table-Win
ON ENTRY OF c-ult-per-fech IN FRAME f-main /* éltimo per¡odo fechado */
DO:
    assign self:format = '9999/99'.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ult-per-fech V-table-Win
ON LEAVE OF c-ult-per-fech IN FRAME f-main /* éltimo per¡odo fechado */
DO:
  if substring(self:screen-value,1,1) = '0' or
     substring(self:screen-value,1,1) = ''  then do:
     assign self:format = 'xxxxxx'
            self:screen-value = ''.
  end.
  else do:
     {cdp/cd9998.i}

    run cdp/cdapi005.p (input  input frame {&frame-name} c-ult-per-fech,
                        output da-iniper               ,   
                        output da-fimper               ,
                        output i-per-corrente          ,
                        output i-ano-corrente          ,
                        output da-iniper-fech          ,
                        output da-fimper-fech          ).

    assign da-mensal-ate:screen-value   in frame {&frame-name} = string(da-fimper-fech)
           da-sumar-ate:screen-value    in frame {&frame-name} = string(da-fimper-fech)
           da-contab-ate:screen-value   in frame {&frame-name} = string(da-fimper-fech)
           da-ult-fech-dia:screen-value in frame {&frame-name} = string(da-fimper-fech)
           da-ini-periodo:screen-value  in frame {&frame-name} = string(da-iniper)
           da-fim-periodo:screen-value  in frame {&frame-name} = string(da-fimper).
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME da-contab-ate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-contab-ate V-table-Win
ON LEAVE OF da-contab-ate IN FRAME f-main /* Contabilizado at‚ */
DO:
    &if defined(bf_mat_fech_estab) &then
    if  adm-new-record then
        run Get-Field-Screen-Value in adm-broker-hdl 
            (input h-v01in661, input "cod-estabel").

    assign c-cod-estabel = if adm-new-record then return-value else estab-mat.cod-estabel.
    if  can-find (first movto-estoq
                  where movto-estoq.cod-estabel = c-cod-estabel
                    and movto-estoq.dt-trans <= input frame {&FRAME-NAME} da-contab-ate) then do:
        run utp/ut-msgs.p (input "show", input 28306, input da-contab-ate:label in frame {&FRAME-NAME}).
        apply 'entry' to da-contab-ate in frame {&FRAME-NAME}.
        return no-apply.
    end.
    &endif  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME da-mensal-ate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-mensal-ate V-table-Win
ON LEAVE OF da-mensal-ate IN FRAME f-main /* Data medio mensal */
DO:
    &if defined(bf_mat_fech_estab) &then
    if  adm-new-record then
        run Get-Field-Screen-Value in adm-broker-hdl 
            (input h-v01in661, input "cod-estabel").

    assign c-cod-estabel = if adm-new-record then return-value else estab-mat.cod-estabel.
    if  can-find (first movto-estoq
                  where movto-estoq.cod-estabel = c-cod-estabel
                    and movto-estoq.dt-trans   <= input frame {&FRAME-NAME} da-mensal-ate) then do:
        {utp/ut-field.i mgind estab-mat mensal-ate 02}
        run utp/ut-msgs.p (input "show", input 28306, input return-value).
        apply 'entry' to da-mensal-ate in frame {&FRAME-NAME}.
        return no-apply.
    end.
    &endif  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME da-sumar-ate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-sumar-ate V-table-Win
ON LEAVE OF da-sumar-ate IN FRAME f-main /* Sumarizado at‚ */
DO:
    &if defined(bf_mat_fech_estab) &then
    if  adm-new-record then
        run Get-Field-Screen-Value in adm-broker-hdl 
            (input h-v01in661, input "cod-estabel").

    assign c-cod-estabel = if adm-new-record then return-value else estab-mat.cod-estabel.
    if  can-find (first movto-estoq
                  where movto-estoq.cod-estabel = c-cod-estabel
                    and movto-estoq.dt-trans <= input frame {&FRAME-NAME} da-sumar-ate) then do:
        run utp/ut-msgs.p (input "show", input 28306, input da-sumar-ate:label in frame {&FRAME-NAME}).
        apply 'entry' to da-sumar-ate in frame {&FRAME-NAME}.
        return no-apply.
    end.
    &endif  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME da-ult-fech-dia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-ult-fech-dia V-table-Win
ON LEAVE OF da-ult-fech-dia IN FRAME f-main /* éltimo dia fechado */
DO:
    &if defined(bf_mat_fech_estab) &then
    if  adm-new-record then
        run Get-Field-Screen-Value in adm-broker-hdl 
            (input h-v01in661, input "cod-estabel").

    assign c-cod-estabel = if adm-new-record then return-value else estab-mat.cod-estabel.
    if  can-find (first movto-estoq
                  where movto-estoq.cod-estabel = c-cod-estabel
                    and movto-estoq.dt-trans <= input frame {&FRAME-NAME} da-ult-fech-dia) then do:
        run utp/ut-msgs.p (input "show", input 28306, input da-ult-fech-dia:label in frame {&FRAME-NAME}).
        apply 'entry' to da-ult-fech-dia in frame {&FRAME-NAME}.
        return no-apply.
    end.
    &endif  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

&if defined(bf_mat_fech_estab) &then
  {utp/ut-field.i mgind estab-mat mensal-ate 1}
  assign da-mensal-ate:label in frame {&FRAME-NAME} = return-value.
  {utp/ut-field.i mgind estab-mat sumar-ate 1}
  assign da-sumar-ate:label in frame {&FRAME-NAME} = return-value.
  {utp/ut-field.i mgind estab-mat contab-ate 1}
  assign da-contab-ate:label in frame {&FRAME-NAME} = return-value.
  {utp/ut-field.i mgind estab-mat ult-fech-dia 1}
  assign da-ult-fech-dia:label in frame {&FRAME-NAME} = return-value.
  {utp/ut-field.i mgind estab-mat ult-per-fech 1}
  assign c-ult-per-fech:label in frame {&FRAME-NAME} = return-value.
&endif

{utp/ut-field.i mgadm ano-fiscal ini-periodo 1}
assign da-ini-periodo:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgadm ano-fiscal fim-periodo 1}
assign da-fim-periodo:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "estab-mat"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "estab-mat"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */

  DO WITH FRAME {&FRAME-NAME} ON ERROR UNDO, RETURN 'ADM-ERROR':
    &if defined(bf_mat_fech_estab) &then
        if  avail estab-mat 
        and da-mensal-ate:sensitive   in frame {&frame-name} = yes
        and da-sumar-ate:sensitive    in frame {&frame-name} = yes
        and da-contab-ate:sensitive   in frame {&frame-name} = yes
        and da-ult-fech-dia:sensitive in frame {&frame-name} = yes
        and c-ult-per-fech:sensitive  in frame {&frame-name} = yes then do:

            assign estab-mat.mensal-ate   = input frame {&frame-name} da-mensal-ate
                   estab-mat.sumar-ate    = input frame {&frame-name} da-sumar-ate
                   estab-mat.contab-ate   = input frame {&frame-name} da-contab-ate
                   estab-mat.ult-fech-dia = input frame {&frame-name} da-ult-fech-dia
                   estab-mat.ult-per-fech = input frame {&frame-name} c-ult-per-fech.
        end.
    &endif
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
    /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .*/
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-CREATE-FIELDS) &then
       disable {&ADM-CREATE-FIELDS} with frame {&frame-name}.
    &endif
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

  &if defined(bf_mat_fech_estab) &then
      if avail estab-mat then do:
         assign da-mensal-ate = estab-mat.mensal-ate 
                da-sumar-ate  = estab-mat.sumar-ate  
                da-contab-ate = estab-mat.contab-ate 
                da-ult-fech-dia = estab-mat.ult-fech-dia 
                c-ult-per-fech  = estab-mat.ult-per-fech.
  
         run cdp/cdapi005.p (input  estab-mat.ult-per-fech,
                             output da-iniper             ,   
                             output da-fimper             ,
                             output i-per-corrente        ,
                             output i-ano-corrente        ,
                             output da-iniper-fech        ,
                             output da-fimper-fech        ).
         assign da-ini-periodo = da-iniper
                da-fim-periodo = da-fimper.
      end.
  &endif

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
    /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .*/
               
    /* Code placed here will execute AFTER standard behavior.    */
    
   &if defined(bf_mat_fech_estab) &then
    find first param-estoq no-lock no-error.
    if param-estoq.tp-fech = 2 
    and adm-new-record then
        enable da-mensal-ate
               da-sumar-ate
               da-contab-ate
               c-ult-per-fech
               da-ult-fech-dia
               with frame {&frame-name}.
    else do:
        if can-find(first item-estab where
                          item-estab.cod-estabel = estab-mat.cod-estabel and
                          (item-estab.val-unit-mat-m[1] <> 0 or
                           item-estab.val-unit-mob-m[1] <> 0 or
                           item-estab.val-unit-ggf-m[1] <> 0 or
                           item-estab.val-unit-mat-o[1] <> 0 or
                           item-estab.val-unit-mob-o[1] <> 0 or
                           item-estab.val-unit-ggf-o[1] <> 0 or
                           item-estab.val-unit-mat-p[1] <> 0 or
                           item-estab.val-unit-mob-p[1] <> 0 or
                           item-estab.val-unit-ggf-p[1] <> 0)) then
            disable da-mensal-ate
                    da-sumar-ate
                    da-contab-ate
                    c-ult-per-fech
                    da-ult-fech-dia
                    with frame {&frame-name}.
        else 
            enable da-mensal-ate
                   da-sumar-ate
                   da-contab-ate
                   c-ult-per-fech
                   da-ult-fech-dia
                   with frame {&frame-name}.
    end.
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
  RUN pi-grava-handle.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter v-row-parent-externo as rowid no-undo.
    
    assign v-row-parent = v-row-parent-externo.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grava-handle V-table-Win 
PROCEDURE pi-grava-handle :
/*------------------------------------------------------------------------------
  Purpose:     Guarda o handle da viewer principal (cabecalho)
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define variable ponteiro as widget-handle no-undo.

    ponteiro = session:first-procedure.
    ponteiro = ponteiro:next-sibling.
    
    do  while valid-handle(ponteiro):
        assign h-v01in661 = ponteiro:handle.
        if  ponteiro:file-name = "invwr~\v01in661.w":u then
            leave.
        else
            ponteiro = ponteiro:next-sibling.
    end.    
    
    return 'OK':u.
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

 if input frame {&FRAME-NAME} da-mensal-ate = ? then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show",
                       input 173,
                       input "").
    apply 'entry' to da-mensal-ate in frame {&FRAME-NAME}.
    return "adm-error":U.
 end.
 
 if input frame {&FRAME-NAME} da-sumar-ate = ? then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show",
                       input 173,
                       input "").
    apply 'entry' to da-sumar-ate in frame {&FRAME-NAME}.
    return "adm-error":U.
 end.

 if input frame {&FRAME-NAME} da-contab-ate = ? then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show",
                       input 173,
                       input "").
    apply 'entry' to da-contab-ate in frame {&FRAME-NAME}.
    return "adm-error":U.
 end.

 if input frame {&FRAME-NAME} da-ult-fech-dia = ? then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show",
                       input 173,
                       input "").
    apply 'entry' to da-ult-fech-dia in frame {&FRAME-NAME}.
    return "adm-error":U.
 end.

 if substring(c-ult-per-fech:screen-value,1,1) = '0' 
 or substring(c-ult-per-fech:screen-value,1,1) = '' then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show",
                       input 333,
                       input "").
    apply 'entry' to c-ult-per-fech in frame {&FRAME-NAME}.
    return "adm-error":U.
 end.


 run cdp/cdapi005.p (input frame {&frame-name} c-ult-per-fech,
                     output da-iniper,   
                     output da-fimper,
                     output i-per-corrente,
                     output i-ano-corrente,
                     output da-iniper-fech,
                     output da-fimper-fech).

  if  da-fimper-fech = ? then do:
      run utp/ut-msgs.p (input "show",
                         input 16459, /* Ano fiscal nÆo est  cadastrado */
                         input "").
      apply 'entry' to c-ult-per-fech in frame {&frame-name}.
      return "adm-error".
  end.
  
 /***************** Validacao do estab-mat.ult-fech-dia *********************/
 if  da-ult-fech-dia:sensitive in frame {&frame-name} = yes then
     if  da-fimper-fech <> input frame {&frame-name} da-ult-fech-dia then do:
         {utp/ut-field.i mgind estab-mat ult-fech-dia 1}
         run utp/ut-msgs.p (input "show",
                         input 29928, /* &1 deve ser igual a &2 */
                         input return-value + "~~" +
                               string(da-fimper-fech)).
         apply 'entry' to da-ult-fech-dia in frame {&frame-name}.
         return "ADM-ERROR".
     end.
 /*****************************************************************************/    
  
 /***************** Validacao do estab-mat.mensal-ate ************************/
 if  da-mensal-ate:sensitive in frame {&frame-name} = yes then
     if  da-fimper-fech <> input frame {&frame-name} da-mensal-ate then do:
         {utp/ut-field.i mgind estab-mat mensal-ate 1}
         run utp/ut-msgs.p (input "show",
                            input 29928, /* &1 deve ser igual a &2 */
                            input return-value + "~~" +
                                  string(da-fimper-fech)).
         apply 'entry' to da-mensal-ate in frame {&frame-name}.
         return "ADM-ERROR".
     end.
 /*****************************************************************************/    
   
 /***************** Validacao do estab-mat.contab-ate ***********************/
 if  da-contab-ate:sensitive in frame {&frame-name} = yes then
     if  da-fimper-fech <> input frame {&frame-name} da-contab-ate then do:
         {utp/ut-field.i mgind estab-mat contab-ate 1}
         run utp/ut-msgs.p (input "show",
                            input 29928, /* &1 deve ser igual a &2 */
                            input return-value + "~~" +
                                  string(da-fimper-fech)).
         apply 'entry' to da-contab-ate in frame {&frame-name}.
         return "ADM-ERROR".
     end.
 /*****************************************************************************/    

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
  {src/adm/template/snd-list.i "estab-mat"}

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

