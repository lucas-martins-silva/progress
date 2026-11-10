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
{include/i-prgvrs.i V08IN289 2.00.00.006} /*** "010006" 01/11/2023 13:32:29 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V08IN289 MUT}
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

{include/i_fncrowid.i}

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                

&IF {&ROWID_READY} = YES &THEN
    def new global shared var v_rec_catal_img          as rowid no-undo.
    def new global shared var v_rec_catal_video        as rowid no-undo.
    def new global shared var v_rec_catal_docto_anexo  as rowid no-undo.
&ELSE
    def new global shared var v_rec_catal_img          as recid no-undo.
    def new global shared var v_rec_catal_video        as recid no-undo.
    def new global shared var v_rec_catal_docto_anexo  as recid no-undo.
&ENDIF

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */



{cdp/cdcfgmnt.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES param-mi
&Scoped-define FIRST-EXTERNAL-TABLE param-mi


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-mi.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-mi.cod-catal-img ~
param-mi.cod-catal-video 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cod-catal-img ~{&FP2}cod-catal-img ~{&FP3}~
 ~{&FP1}cod-catal-video ~{&FP2}cod-catal-video ~{&FP3}
&Scoped-define ENABLED-TABLES param-mi
&Scoped-define FIRST-ENABLED-TABLE param-mi
&Scoped-Define ENABLED-OBJECTS rt-key c-cod-catal-docto-anexo 
&Scoped-Define DISPLAYED-FIELDS param-mi.cod-catal-img ~
param-mi.cod-catal-video 
&Scoped-Define DISPLAYED-OBJECTS c-desc-img c-desc-video ~
c-cod-catal-docto-anexo c-desc-docto-anexo 

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
DEFINE VARIABLE c-cod-catal-docto-anexo AS CHARACTER FORMAT "x(8)" 
     LABEL "Cat logo Documento":R22 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .88.

DEFINE VARIABLE c-desc-docto-anexo AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-img AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-video AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 82 BY 8.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-mi.cod-catal-img AT ROW 3.75 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     c-desc-img AT ROW 3.75 COL 36 COLON-ALIGNED NO-LABEL
     param-mi.cod-catal-video AT ROW 4.75 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     c-desc-video AT ROW 4.75 COL 36 COLON-ALIGNED NO-LABEL
     c-cod-catal-docto-anexo AT ROW 5.75 COL 23 COLON-ALIGNED
     c-desc-docto-anexo AT ROW 5.75 COL 36 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-mi
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
         HEIGHT             = 8.5
         WIDTH              = 82.72.
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

ASSIGN 
       c-cod-catal-docto-anexo:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-docto-anexo IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-desc-docto-anexo:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-img IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-video IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME c-cod-catal-docto-anexo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-catal-docto-anexo V-table-Win
ON F5 OF c-cod-catal-docto-anexo IN FRAME f-main /* Cat logo Documento */
DO:
    RUN btb/btb003ka.p.
    IF  v_rec_catal_docto_anexo <> ? then do:
        &IF {&ROWID_READY} = YES &THEN
        FIND catal_docto_anexo WHERE ROWID(catal_docto_anexo) = v_rec_catal_docto_anexo.
        &ELSE
        FIND catal_docto_anexo WHERE RECID(catal_docto_anexo) = v_rec_catal_docto_anexo.
        &ENDIF

        DISP catal_docto_anexo.cod_catal_docto_anexo @ c-cod-catal-docto-anexo WITH FRAME {&frame-name}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-catal-docto-anexo V-table-Win
ON LEAVE OF c-cod-catal-docto-anexo IN FRAME f-main /* Cat logo Documento */
DO:
    {include/leave.i &tabela = catal_docto_anexo
                     &atributo-ref = des_catal_docto_anexo
                     &variavel-ref = c-desc-docto-anexo
                     &where= "catal_docto_anexo.cod_catal_docto_anexo = input frame {&frame-name} c-cod-catal-docto-anexo"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-catal-docto-anexo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-catal-docto-anexo IN FRAME f-main /* Cat logo Documento */
DO:
    APPLY "F5" TO self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-mi.cod-catal-img
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-mi.cod-catal-img V-table-Win
ON F5 OF param-mi.cod-catal-img IN FRAME f-main /* Cat logo */
DO:
    RUN btb/btb103ka.p.
    IF  v_rec_catal_img <> ? then do:
        &IF {&ROWID_READY} = YES &THEN
        FIND catal_img WHERE ROWID(catal_img) = v_rec_catal_img.
        &ELSE
        FIND catal_img WHERE RECID(catal_img) = v_rec_catal_img.
        &ENDIF
        
        DISP catal_img.cod_catal_img @ param-mi.cod-catal-img WITH FRAME {&frame-name}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-mi.cod-catal-img V-table-Win
ON LEAVE OF param-mi.cod-catal-img IN FRAME f-main /* Cat logo */
DO:
    {include/leave.i &tabela = catal_img
                     &atributo-ref = des_catal_img
                     &variavel-ref = c-desc-img
                     &where= "catal_img.cod_catal_img = input frame {&frame-name} param-mi.cod-catal-img"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-mi.cod-catal-img V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-mi.cod-catal-img IN FRAME f-main /* Cat logo */
DO:
    APPLY "F5" TO self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-mi.cod-catal-video
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-mi.cod-catal-video V-table-Win
ON F5 OF param-mi.cod-catal-video IN FRAME f-main /* Cat logo */
DO:
    RUN btb/btb019ka.p.
    IF  v_rec_catal_video <> ? then do:
        &IF {&ROWID_READY} = YES &THEN
        FIND catal_video WHERE ROWID(catal_video) = v_rec_catal_video.
        &ELSE
        FIND catal_video WHERE RECID(catal_video) = v_rec_catal_video.
        &ENDIF
        
        DISP catal_video.cod_catal_video @ param-mi.cod-catal-video WITH FRAME {&frame-name}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-mi.cod-catal-video V-table-Win
ON LEAVE OF param-mi.cod-catal-video IN FRAME f-main /* Cat logo */
DO:
    {include/leave.i &tabela = catal_video
                     &atributo-ref = des_catal_video
                     &variavel-ref = c-desc-video
                     &where= "catal_video.cod_catal_video = input frame {&frame-name} param-mi.cod-catal-video"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-mi.cod-catal-video V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-mi.cod-catal-video IN FRAME f-main /* Cat logo */
DO:
    APPLY "F5" TO self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */



  IF param-mi.cod-catal-img:LOAD-MOUSE-POINTER  ("image\lupa.cur") IN FRAME {&frame-name} THEN.
  IF param-mi.cod-catal-video:LOAD-MOUSE-POINTER("image\lupa.cur") IN FRAME {&frame-name} THEN.

  &if defined (bf_mnt_ems203)  &then  
      {utp/ut-field.i mgind param-mi cod-catal-docto-anexo 1}
      assign c-cod-catal-docto-anexo:label in frame {&FRAME-NAME} = trim(return-value).
      IF c-cod-catal-docto-anexo:LOAD-MOUSE-POINTER("image\lupa.cur") IN FRAME {&frame-name} THEN.
  &else
     {utp/ut-liter.i Cat logo_Imagem * r}
     assign param-mi.cod-catal-img:label in frame {&frame-name} = trim(return-value).
     {utp/ut-liter.i Cat logo_V¡deo * r}
     assign param-mi.cod-catal-video:label in frame {&frame-name} = trim(return-value).
  &endif     

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

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
  {src/adm/template/row-list.i "param-mi"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-mi"}

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
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */


  &if defined (bf_mnt_ems203)  &then  
      find first param-mi exclusive-lock no-error.
      assign  param-mi.cod-catal-docto-anexo = input frame {&FRAME-NAME} c-cod-catal-docto-anexo.
  &endif             

    
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
  
  if  available param-mi then do:
     if param-mi.cod-catal-img <> "" then do:
        find catal_img where 
             catal_img.cod_catal_img = param-mi.cod-catal-img 
             no-lock no-error.
        assign c-desc-img = if avail catal_img then 
                               catal_img.des_catal_img
                            else "":U.
     end.
     if  param-mi.cod-catal-video <> "" then do:
        find catal_video where 
             catal_video.cod_catal_video = param-mi.cod-catal-video
             no-lock no-error.
        assign c-desc-video = if avail param-mi then 
                                 catal_video.des_catal_video
                              else "":U.
     end.
     
     &if defined (bf_mnt_ems203)  &then  
     
        if  c-cod-catal-docto-anexo <> "" then do:
           find catal_docto_anexo where 
                catal_docto_anexo.cod_catal_docto_anexo = param-mi.cod-catal-docto-anexo
                no-lock no-error.
           assign c-desc-docto-anexo = if avail param-mi then 
                                          catal_docto_anexo.des_catal_docto_anexo
                                       else "":U.
        end.
     &endif   
  end.

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
  run get-attribute ('adm-new-record').
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
  &if defined (bf_mnt_ems203)  &then  
      assign c-cod-catal-docto-anexo:hidden in frame {&FRAME-NAME} = no
             c-desc-docto-anexo:hidden      in frame {&FRAME-NAME} = no.

      find first param-mi no-lock no-error.
      if avail param-mi then 
         assign c-cod-catal-docto-anexo = param-mi.cod-catal-docto-anexo.
  &endif       


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */

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
   
   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/
 
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
  {src/adm/template/snd-list.i "param-mi"}

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


