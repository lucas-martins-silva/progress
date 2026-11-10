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
{include/i-prgvrs.i V11IN263 2.00.01.002}  /*** 010102 ***/

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

{cdp/cdcfgman.i}

def var hProgramZoom as handle no-undo.

def var c-prepar           as char format "x(5)".
def var c-grup-maquina-aps as char format "x(9)".
def var d-lote-padrao      as dec  format "999999999999.99".
def var d-lote-multi       as dec  format "999999999999.99".
def var i-fator-ant        as int  format "999".
def var l-tempo-sig        as log.
def var d-lote-minimo      as dec  format "999999999999.99".
def var c-setup-ferram     as char format "x(5)".
def var i-num-pecas        as int  format "999".
def var l-priorid-agrup    as LOG  format "S/N" INITIAL NO.

def var h-handle           as handle no-undo.

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
&Scoped-define EXTERNAL-TABLES operacao
&Scoped-define FIRST-EXTERNAL-TABLE operacao


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR operacao.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-OBJECTS fi-prepar fi-grup-maquina-aps ~
fi-lote-padrao fi-num-pecas fi-lote-multi fi-setup-ferram fi-lote-minimo ~
tg-priorid fi-fator-ant tg-tempo-sig 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS fi-fator-ant 
&Scoped-define ADM-MODIFY-FIELDS fi-prepar fi-grup-maquina-aps ~
fi-lote-padrao fi-num-pecas fi-lote-multi fi-setup-ferram fi-lote-minimo ~
tg-priorid fi-fator-ant tg-tempo-sig 

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
DEFINE VARIABLE fi-fator-ant AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-grup-maquina-aps AS CHARACTER FORMAT "X(9)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-lote-minimo AS DECIMAL FORMAT ">>>>>>>>>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-lote-multi AS DECIMAL FORMAT ">>>>>>>>>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-lote-padrao AS DECIMAL FORMAT ">>>>>>>>>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-num-pecas AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fi-prepar AS CHARACTER FORMAT "X(5)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-setup-ferram AS CHARACTER FORMAT "X(5)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 7.5.

DEFINE VARIABLE tg-priorid AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.

DEFINE VARIABLE tg-tempo-sig AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 23.57 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     fi-prepar AT ROW 1.5 COL 23 COLON-ALIGNED
     fi-grup-maquina-aps AT ROW 2.5 COL 23 COLON-ALIGNED
     fi-lote-padrao AT ROW 3.5 COL 23 COLON-ALIGNED
     fi-num-pecas AT ROW 3.5 COL 64 COLON-ALIGNED
     fi-lote-multi AT ROW 4.5 COL 23 COLON-ALIGNED
     fi-setup-ferram AT ROW 4.5 COL 64 COLON-ALIGNED
     fi-lote-minimo AT ROW 5.5 COL 23 COLON-ALIGNED
     tg-priorid AT ROW 5.5 COL 58
     fi-fator-ant AT ROW 6.5 COL 23 COLON-ALIGNED
     tg-tempo-sig AT ROW 7.5 COL 25
     rt-key AT ROW 1.04 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.operacao
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
         HEIGHT             = 7.58
         WIDTH              = 82.29.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fi-fator-ant IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-grup-maquina-aps IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN fi-lote-minimo IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN fi-lote-multi IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN fi-lote-padrao IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN fi-num-pecas IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN fi-prepar IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN fi-setup-ferram IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR TOGGLE-BOX tg-priorid IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR TOGGLE-BOX tg-tempo-sig IN FRAME f-main
   NO-ENABLE 3                                                          */
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

&Scoped-define SELF-NAME fi-grup-maquina-aps
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-grup-maquina-aps V-table-Win
ON F5 OF fi-grup-maquina-aps IN FRAME f-main
DO:

  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in144.w" 
                     &campo=fi-grup-maquina-aps
                     &campozoom=gm-codigo}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-grup-maquina-aps V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-grup-maquina-aps IN FRAME f-main
DO:

  apply 'f5' to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-prepar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-prepar V-table-Win
ON F5 OF fi-prepar IN FRAME f-main
DO:
    l-implanta = yes.
    {method/zoomfields.i 
           &ProgramZoom="apzoom/z01ap006.w"
           &FieldZoom1="cod-prepar"
           &FieldScreen1="fi-prepar"
           &Frame1="f-main"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-prepar V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-prepar IN FRAME f-main
DO:

  apply 'f5' to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-setup-ferram
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-setup-ferram V-table-Win
ON F5 OF fi-setup-ferram IN FRAME f-main
DO:
    l-implanta = yes.
    {method/zoomfields.i 
           &ProgramZoom="apzoom/z01ap006.w"
           &FieldZoom1="cod-prepar"
           &FieldScreen1="fi-setup-ferram"
           &Frame1="f-main"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-setup-ferram V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-setup-ferram IN FRAME f-main
DO:
    apply 'f5' to self.
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

  {utp/ut-liter.i Redu‡Æo_de_Prepara‡Æo * R}
  assign fi-prepar:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Centro_de_Trabalho * R}
  assign fi-grup-maquina-aps:label in frame {&frame-name} = trim(return-value).  

  {utp/ut-liter.i Lote_PadrÆo * R}
  assign fi-lote-padrao:label in frame {&frame-name} = trim(return-value).  

  {utp/ut-liter.i Lote_Multiplicidade * R}
  assign fi-lote-multi:label in frame {&frame-name} = trim(return-value).    

  {utp/ut-liter.i Lote_M¡nimo * R}
  assign fi-lote-minimo:label in frame {&frame-name} = trim(return-value).  

  {utp/ut-liter.i Tempo_Significativo * R}
  assign tg-tempo-sig:label in frame {&frame-name} = trim(return-value).  

  {utp/ut-liter.i Fator_Antecipa‡Æo * R}
  assign fi-fator-ant:label in frame {&frame-name} = trim(return-value).  

  {utp/ut-liter.i Num_Pe‡as_por_Ferramental * R}
  assign fi-num-pecas:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Redu‡Æo_Prepar_por_Ferramental * R}
  assign fi-setup-ferram:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Prioridade_Agrupamento * R}
  assign tg-priorid:label in frame {&frame-name} = trim(return-value).  

  /* indicar os campos com opcao de zoom (F5) com alteracao do ponteiro do mouse */
  if fi-prepar:load-mouse-pointer           ("image~\lupa.cur") then.
  if fi-grup-maquina-aps:load-mouse-pointer ("image~\lupa.cur") then.
  if fi-setup-ferram:load-mouse-pointer     ("image~\lupa.cur") then.

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
  {src/adm/template/row-list.i "operacao"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "operacao"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

    assign fi-prepar:screen-value           in frame {&frame-name} = ""
           fi-grup-maquina-aps:screen-value in frame {&frame-name} = ""
           fi-lote-padrao:screen-value      in frame {&frame-name} = "0"
           fi-lote-multi:screen-value       in frame {&frame-name} = "1"
           fi-fator-ant:screen-value        in frame {&frame-name} = "0"
           tg-tempo-sig:checked             in frame {&frame-name} = yes
           fi-setup-ferram:screen-value     in frame {&frame-name} = ""
           fi-num-pecas:screen-value        in frame {&frame-name} = "0"
           fi-lote-minimo:screen-value      in frame {&frame-name} = "0"
           tg-tempo-sig:checked             in frame {&frame-name} = NO.

  /* Code placed here will execute AFTER standard behavior.    */

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

    /* Ponha na pi-validate todas as valida‡„es */
    /* NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

    &IF DEFINED (bf_man_sfc_lc) &THEN

        assign c-prepar           = input frame {&frame-name} fi-prepar
               c-grup-maquina-aps = input frame {&frame-name} fi-grup-maquina-aps
               d-lote-padrao      = input frame {&frame-name} fi-lote-padrao
               d-lote-multi       = input frame {&frame-name} fi-lote-multi
               i-fator-ant        = input frame {&frame-name} fi-fator-ant
               l-tempo-sig        = input frame {&frame-name} tg-tempo-sig
               d-lote-minimo      = input frame {&frame-name} fi-lote-minimo
               i-num-pecas        = input frame {&frame-name} fi-num-pecas
               c-setup-ferram     = input frame {&frame-name} fi-setup-ferram
               l-priorid-agrup    = INPUT FRAME {&frame-name} tg-priorid.
    &ENDIF

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    &IF DEFINED (bf_man_sfc_lc) &THEN 

        assign operacao.cod-prepar   = c-prepar
               operacao.centro-aps  = c-grup-maquina-aps
               operacao.lote-padrao = d-lote-padrao
               operacao.lote-multiplo = d-lote-multi
               operacao.fator-ant  = i-fator-ant
               operacao.nr-pc-ferram  = i-num-pecas
               operacao.red-prepar-ferram  = c-setup-ferram
               operacao.lote-min = d-lote-minimo.
        /*ksm 41756 altera‡Æo dos campos char*/
        IF l-priorid-agrup = YES THEN 
            ASSIGN SUBSTRING(operacao.char-1,99,1) = "S":U. 
        ELSE
            ASSIGN SUBSTRING(operacao.char-1,99,1) = "N":U.  

        if  param-global.modulo-sws = yes then do:
            if l-tempo-sig = yes then
                assign operacao.tempo-sig = YES.
            else
                assign operacao.tempo-sig = NO.
        end.
        /*** Removido pois estava sobrepondo o valor definido no v09in263.w 
           quando o APS estava desabilitado ** Atividade 199.261
        else do:
            &if {&bf_man_205} &then
                assign operacao.tempo-sig = if l-tempo-sig = yes then YES else NO.
            &else
                &if {&bf_man_204} &then
                &else
                    assign operacao.tempo-sig = if l-tempo-sig = yes then YES else NO.
                &endif
            &endif
        end.***/
    &ENDIF

    /* Todos os assign‹s nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  if valid-handle (h-handle) then
    delete procedure h-handle.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
    &IF DEFINED (bf_man_sfc_lc) &THEN
        if  avail operacao then do:

            assign fi-prepar           = operacao.cod-prepar
                   fi-grup-maquina-aps = operacao.centro-aps
                   fi-lote-padrao      = operacao.lote-padrao
                   fi-lote-multi       = operacao.lote-multiplo
                   fi-fator-ant        = operacao.fator-ant
                   fi-num-pecas        = operacao.nr-pc-ferram
                   fi-setup-ferram     = operacao.red-prepar-ferram
                   fi-lote-minimo      = operacao.lote-min.
            /*ksm 41756 altera‡Æo dos campos chars */
            if  substring(operacao.char-1,99,1) = "N":U then
                assign tg-priorid = no.
            else
                assign tg-priorid = yes.

            if  operacao.tempo-sig = NO then
                assign tg-tempo-sig = no.
            else
                assign tg-tempo-sig = yes.
        end.
        else
            assign fi-prepar            = ""
                   fi-grup-maquina-aps  = ""
                   fi-lote-padrao       = 0
                   fi-lote-multi        = 1
                   fi-fator-ant         = 0
                   tg-tempo-sig         = yes
                   fi-lote-minimo       = 0
                   fi-setup-ferram      = ""
                   fi-num-pecas         = 0
                   tg-priorid           = NO.
    &ENDIF

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
/*    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .*/

    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    /*if adm-new-record = yes then*/
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

  find first param-global no-lock no-error.

  &IF DEFINED (bf_man_sfc_lc) &THEN
    if param-global.modulo-sws then
      run apbo/boap006.p persistent set h-handle.
  &ENDIF

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-ctrab V-table-Win 
PROCEDURE pi-atualiza-ctrab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param p-ctrab as char no-undo.

assign fi-grup-maquina-aps:screen-value in frame {&frame-name} = p-ctrab.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡„es, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Valida‡Æo de dicionÿrio */

    &IF DEFINED (bf_man_sfc_lc) &THEN
        if  param-global.modulo-sws then do:
            if  fi-prepar:screen-value in frame {&frame-name} <> "" then do:
                run validaCodPrepar in h-handle (input fi-prepar:screen-value in frame {&frame-name}).
                if return-value = "NOK" then do:
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-liter.i "Prepara‡Æo" *}
                    run utp/ut-msgs.p (input "show",
                                       input 47,
                                       input RETURN-VALUE).
                    apply 'entry' to fi-prepar.
                    return 'adm-error':U. 
                end.
            end.
         
            if  fi-grup-maquina-aps:screen-value in frame {&frame-name} <> "" then do:
                if  not can-find (first grup-maquina where
                                        grup-maquina.gm-codigo = fi-grup-maquina-aps:screen-value in frame {&frame-name}) then do:
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-liter.i "Centro_de_Trabalho" *}
                    run utp/ut-msgs.p (input "show",
                                       input 47,
                                       input RETURN-VALUE).
                    apply 'entry' to fi-grup-maquina-aps.
                    return 'adm-error':U.
                end.
            end.

            if  fi-setup-ferram:screen-value in frame {&frame-name} <> "" then do:
                run validaCodPrepar in h-handle (input fi-setup-ferram:screen-value in frame {&frame-name}).
                if return-value = "NOK" then do:
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-liter.i "Redu‡Æo_prepara‡Æo_por_ferramental" *}
                    run utp/ut-msgs.p (input "show",
                                       input 47,
                                       input RETURN-VALUE).
                    apply 'entry' to fi-setup-ferram.
                    return 'adm-error':U. 
                end.
            end.
        end.
    &ENDIF

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
  {src/adm/template/snd-list.i "operacao"}

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


