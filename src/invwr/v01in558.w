&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V01IN558 2.00.00.000}  /*** 010000 ***/

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

def var v-des-formato as char no-undo.
def var v-num-tamanho as int no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES ipman
&Scoped-define FIRST-EXTERNAL-TABLE ipman


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ipman.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ipman.des-ipman ipman.cod-unid-medid-gerc ~
ipman.val-meta-ipman ipman.formato ipman.val-benchm-ipman ~
ipman.log-inform-ativ ipman.des-formul-ipman 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}des-ipman ~{&FP2}des-ipman ~{&FP3}~
 ~{&FP1}cod-unid-medid-gerc ~{&FP2}cod-unid-medid-gerc ~{&FP3}~
 ~{&FP1}val-meta-ipman ~{&FP2}val-meta-ipman ~{&FP3}~
 ~{&FP1}formato ~{&FP2}formato ~{&FP3}~
 ~{&FP1}val-benchm-ipman ~{&FP2}val-benchm-ipman ~{&FP3}
&Scoped-define ENABLED-TABLES ipman
&Scoped-define FIRST-ENABLED-TABLE ipman
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold RECT-1 v-cod-ipman ~
v-cod-dbman nom-formula 
&Scoped-Define DISPLAYED-FIELDS ipman.cod-ipman ipman.des-ipman ~
ipman.cod-unid-medid-gerc ipman.val-meta-ipman ipman.formato ~
ipman.val-benchm-ipman ipman.log-inform-ativ ipman.des-formul-ipman 
&Scoped-Define DISPLAYED-OBJECTS v-cod-ipman v-cod-dbman nom-formula 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS ipman.cod-ipman 

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
DEFINE VARIABLE nom-formula AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 7 BY .71 NO-UNDO.

DEFINE VARIABLE v-cod-dbman AS CHARACTER FORMAT "x(8)" 
     LABEL "Dado B sico" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-ipman AS CHARACTER FORMAT "X(8)":U 
     LABEL "Öndice" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.14 BY 3.54.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 8.04.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ipman.cod-ipman AT ROW 1.08 COL 23.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     ipman.des-ipman AT ROW 2.71 COL 23.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 55.86 BY .88
     ipman.cod-unid-medid-gerc AT ROW 3.71 COL 23.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     ipman.val-meta-ipman AT ROW 3.71 COL 61.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     ipman.formato AT ROW 4.71 COL 23.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     ipman.val-benchm-ipman AT ROW 4.71 COL 61.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     ipman.log-inform-ativ AT ROW 5.71 COL 25.72
          VIEW-AS TOGGLE-BOX
          SIZE 19 BY .83
     v-cod-ipman AT ROW 6.83 COL 61.14 COLON-ALIGNED
     v-cod-dbman AT ROW 6.88 COL 23.72 COLON-ALIGNED HELP
          "C¢digo do Dado B sico"
     ipman.des-formul-ipman AT ROW 7.92 COL 25.72 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 2000 SCROLLBAR-VERTICAL
          SIZE 51.57 BY 2.13
     nom-formula AT ROW 7.92 COL 16.46 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
     RECT-1 AT ROW 6.71 COL 2.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: Mgind.ipman
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 9.54
         WIDTH              = 88.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN ipman.cod-ipman IN FRAME f-main
   NO-ENABLE 1                                                          */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME v-cod-dbman
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-dbman V-table-Win
ON F5 OF v-cod-dbman IN FRAME f-main /* Dado B sico */
DO:
   {include/zoomvar.i &prog-zoom="inzoom/z01in551.w"
                      &campo=v-cod-dbman
                      &campozoom=cod-dbman}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-dbman V-table-Win
ON LEAVE OF v-cod-dbman IN FRAME f-main /* Dado B sico */
DO:
  assign ipman.des-formul-ipman:screen-value = input ipman.des-formul-ipman + input v-cod-dbman.
  assign v-cod-dbman:screen-value in frame {&frame-name} = "".
  apply "entry" to v-cod-ipman.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-dbman V-table-Win
ON MOUSE-SELECT-DBLCLICK OF v-cod-dbman IN FRAME f-main /* Dado B sico */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-cod-ipman
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-ipman V-table-Win
ON F5 OF v-cod-ipman IN FRAME f-main /* Öndice */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in558.w"
                      &campo=v-cod-ipman
                      &campozoom=cod-ipman}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-ipman V-table-Win
ON LEAVE OF v-cod-ipman IN FRAME f-main /* Öndice */
DO:
  assign ipman.des-formul-ipman:screen-value = input ipman.des-formul-ipman + input v-cod-ipman.
  assign v-cod-ipman:screen-value in frame {&frame-name} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-ipman V-table-Win
ON MOUSE-SELECT-DBLCLICK OF v-cod-ipman IN FRAME f-main /* Öndice */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  {utp/ut-liter.i F¢rmula: * L}.
  assign nom-formula = return-value.
  display nom-formula with frame {&frame-name}.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

if v-cod-dbman:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
if v-cod-ipman:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "ipman"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ipman"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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
  
  {utp/ut-liter.i F¢rmula: * L}.
  assign nom-formula = return-value.
  display nom-formula with frame {&frame-name}.

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
    
    /* Ponha na pi-validate todas as valida‡äes */
    /* NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
       
    if adm-new-record then do:
       find ipman where ipman.cod-ipman = input frame {&frame-name} ipman.cod-ipman no-lock no-error.
       if avail ipman then do:
          {utp/ut-table.i mgind ipman 1 }
          run utp/ut-msgs.p (input "show",
                             input 1,
                             input return-value).
          apply "entry" to ipman.cod-ipman.
          return 'ADM-ERROR'.
       end.
    end.
    
    if input frame {&frame-name} ipman.des-ipman = "" then do:
       run utp/ut-msgs.p (input "show",
                          input 17616,
                          input "").
       apply "entry" to ipman.des-ipman.
       return 'ADM-ERROR'.
    end. 

    if input frame {&frame-name} ipman.formato = "" then do:
       run utp/ut-msgs.p (input "show",
                          input 17617,
                          input "").
       apply "entry" to ipman.formato.
       return 'ADM-ERROR'.
    end. 
       
    assign v-des-formato = ""
           v-num-tamanho = length(input ipman.formato)
           v-des-formato = string(0, input ipman.formato) no-error.

    if v-des-formato                        = ""   or
      (substr(input ipman.formato,1,1) <> "9"  and
       substr(input ipman.formato,1,1) <> ">"  and
       substr(input ipman.formato,1,1) <> ".")  or
      (substr(input ipman.formato,v-num-tamanho,1) <> "9"   and
       substr(input ipman.formato,v-num-tamanho,1) <> "<"   and
       substr(input ipman.formato,v-num-tamanho,1) <> ".") then do:
       run utp/ut-msgs.p (input "show",
                          input 2744,
                          input return-value).
       apply "entry" to ipman.cod-ipman.
       return 'ADM-ERROR'.
    end.
       
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
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
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "ipman"}

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


