&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
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
{include/i-prgvrs.i V04IN627 2.00.00.017 } /*** 010017 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V04IN627 MUT}
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

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

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
&Scoped-define EXTERNAL-TABLES usuar-mater
&Scoped-define FIRST-EXTERNAL-TABLE usuar-mater


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR usuar-mater.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS usuar-mater.envia-e-mail ~
usuar-mater.recebe-e-mail usuar-mater.e-mail usuar-mater.home-page ~
usuar-mater.telefone[1] usuar-mater.ramal[1] usuar-mater.telefone[2] ~
usuar-mater.ramal[2] usuar-mater.telefax 
&Scoped-define ENABLED-TABLES usuar-mater
&Scoped-define FIRST-ENABLED-TABLE usuar-mater
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-8 RECT-11 
&Scoped-Define DISPLAYED-FIELDS usuar-mater.envia-e-mail ~
usuar-mater.recebe-e-mail usuar-mater.e-mail usuar-mater.home-page ~
usuar-mater.telefone[1] usuar-mater.ramal[1] usuar-mater.telefone[2] ~
usuar-mater.ramal[2] usuar-mater.telefax 
&Scoped-define DISPLAYED-TABLES usuar-mater
&Scoped-define FIRST-DISPLAYED-TABLE usuar-mater
&Scoped-Define DISPLAYED-OBJECTS c-cod-estab c-desc-estab ~
tg-atend-devol-req 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS c-cod-estab tg-atend-devol-req 

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
DEFINE VARIABLE c-cod-estab AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estab. Padr∆o" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88.

DEFINE VARIABLE c-desc-estab AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54.72 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42.43 BY 1.5.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.72 BY 8.13.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42.43 BY 1.5.

DEFINE VARIABLE tg-atend-devol-req AS LOGICAL INITIAL no 
     LABEL "Atendimento Simplificado Requisiá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 54.29 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     usuar-mater.envia-e-mail AT ROW 1.38 COL 16.43
          VIEW-AS TOGGLE-BOX
          SIZE 15.29 BY .83
     usuar-mater.recebe-e-mail AT ROW 1.38 COL 58.43
          VIEW-AS TOGGLE-BOX
          SIZE 17 BY .83
     c-cod-estab AT ROW 3.46 COL 13.72 COLON-ALIGNED WIDGET-ID 2
     c-desc-estab AT ROW 3.46 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     usuar-mater.e-mail AT ROW 4.5 COL 13.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 66 BY .88
     usuar-mater.home-page AT ROW 5.5 COL 13.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 66 BY .88
     usuar-mater.telefone[1] AT ROW 6.5 COL 13.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     usuar-mater.ramal[1] AT ROW 6.5 COL 45.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     usuar-mater.telefone[2] AT ROW 7.5 COL 13.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     usuar-mater.ramal[2] AT ROW 7.5 COL 45.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     usuar-mater.telefax AT ROW 8.5 COL 13.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     tg-atend-devol-req AT ROW 9.5 COL 15.72 WIDGET-ID 6
     RECT-10 AT ROW 1 COL 1
     RECT-8 AT ROW 1 COL 44.29
     RECT-11 AT ROW 2.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.usuar-mater
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
         HEIGHT             = 9.88
         WIDTH              = 85.72.
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
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-estab IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN c-desc-estab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-atend-devol-req IN FRAME f-main
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

&Scoped-define SELF-NAME c-cod-estab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estab V-table-Win
ON F5 OF c-cod-estab IN FRAME f-main /* Estab. Padr∆o */
DO:
  {include/zoomvar.i &prog-zoom  = adzoom/z01ad107.w
                     &campo      = c-cod-estab
                     &campozoom  = cod-estabel
                     &campo2     = c-desc-estab
                     &campozoom2 = nome}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estab V-table-Win
ON LEAVE OF c-cod-estab IN FRAME f-main /* Estab. Padr∆o */
DO:
  {include/leave.i &tabela=estabelec
                   &atributo-ref=nome
                   &variavel-ref=c-desc-estab
                   &where="estabelec.cod-estabel = input frame f-main 
                   c-cod-estab"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estab V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-estab IN FRAME f-main /* Estab. Padr∆o */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME usuar-mater.envia-e-mail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL usuar-mater.envia-e-mail V-table-Win
ON VALUE-CHANGED OF usuar-mater.envia-e-mail IN FRAME f-main /* Envia E-mail */
DO:
  if usuar-mater.envia-e-mail:checked in frame {&frame-name} = yes then 
   assign usuar-mater.e-mail:sensitive in frame {&frame-name} = yes.
  else do:
       if usuar-mater.recebe-e-mail:checked in frame {&frame-name} = no then 
        assign usuar-mater.e-mail:sensitive in frame {&frame-name} = no.
       else 
        assign usuar-mater.e-mail:sensitive in frame {&frame-name} = yes.
  end.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME usuar-mater.recebe-e-mail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL usuar-mater.recebe-e-mail V-table-Win
ON VALUE-CHANGED OF usuar-mater.recebe-e-mail IN FRAME f-main /* Recebe E-Mail */
DO:
  if usuar-mater.recebe-e-mail:checked in frame {&frame-name} = yes then 
   assign usuar-mater.e-mail:sensitive in frame {&frame-name} = yes.
  else do:
       if usuar-mater.envia-e-mail:checked in frame {&frame-name} = no then 
        assign usuar-mater.e-mail:sensitive in frame {&frame-name} = no.
       else 
        assign usuar-mater.e-mail:sensitive in frame {&frame-name} = yes.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  if c-cod-estab:load-mouse-pointer("image/lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "usuar-mater"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "usuar-mater"}

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
    
    /* Ponha na pi-validate todas as validaá‰es */
    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  

    /*grava o Estabelecimento Padr∆o - M¢dulo de Aquisiá∆o de Produtos Rurais */  
    IF AVAIL usuar-mater THEN
        ASSIGN OVERLAY(usuar-mater.char-1,16,5) = INPUT FRAME {&FRAME-NAME} c-cod-estab
               OVERLAY(usuar-mater.char-1,23,1) = IF INPUT FRAME {&FRAME-NAME} tg-atend-devol-req THEN "S":U ELSE "N":U.

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
    
    disable c-cod-estab tg-atend-devol-req with frame {&frame-name}.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /*carrega o Estabelecimento Padr∆o - M¢dulo de Aquisiá∆o de Produtos Rurais */ 
  IF AVAIL usuar-mater AND NOT adm-new-record THEN
       ASSIGN c-cod-estab:SCREEN-VALUE             IN FRAME {&FRAME-NAME} = SUBSTR(usuar-mater.char-1,16,5)
              usuar-mater.e-mail:SCREEN-VALUE      IN FRAME {&FRAME-NAME} = usuar-mater.e-mail
              usuar-mater.home-page:SCREEN-VALUE   IN FRAME {&FRAME-NAME} = usuar-mater.home-page 
              usuar-mater.telefone[1]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = usuar-mater.telefone[1]
              usuar-mater.ramal[1]:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = usuar-mater.ramal[1]
              usuar-mater.telefone[2]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = usuar-mater.telefone[2]
              usuar-mater.ramal[2]:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = usuar-mater.ramal[2]                
              usuar-mater.telefax:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = usuar-mater.telefax
              tg-atend-devol-req:CHECKED           IN FRAME {&FRAME-NAME} = IF SUBSTR(usuar-mater.char-1,23,1) = "S" THEN YES ELSE NO
              usuar-mater.envia-e-mail:CHECKED     IN FRAME {&FRAME-NAME} = IF usuar-mater.envia-e-mail  THEN YES ELSE NO
              usuar-mater.recebe-e-mail:CHECKED    IN FRAME {&FRAME-NAME} = IF usuar-mater.recebe-e-mail THEN YES ELSE NO.

  /* foi preciso incluir todos os campos da tela, pois se n„o ao abrir o CD1700, o programa n„o mostrava os dados */


  APPLY "LEAVE" TO c-cod-estab IN FRAME {&FRAME-NAME}.
  
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
    if adm-new-record = yes then
    &if  defined(ADM-MODIFY-FIELDS) &then
    enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    enable c-cod-estab tg-atend-devol-req with frame {&frame-name}.
    
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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ).
  
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
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */
    
/*/*    Segue um exemplo de validaá∆o de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/

 
 find first estabelec
      where estabelec.cod-estabel = input frame {&frame-name} c-cod-estab no-lock no-error.
 if  not avail estabelec then do:
      {utp/ut-table.i mgadm estabelec 01}
      run utp/ut-msgs.p (input 'show',
                         input 56,
                         input return-value).
      apply 'entry' to c-cod-estab in frame {&frame-name}.
      return 'ADM-ERROR':U.
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
  {src/adm/template/snd-list.i "usuar-mater"}

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

