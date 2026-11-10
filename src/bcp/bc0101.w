&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
**
*/
&Scoped-define WINDOW-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0101 2.00.00.026 } /*** "010026" 31/08/2023 15:08:02  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BC0101 MBC}
&ENDIF

/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters: 
      <none>

  Output Parameters: 
      <none>

  Version: 1.00.000
  
  History: 
          
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF VAR i-acum-valores AS INTEGER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-paruni
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-cad

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button bt-ok bt-cancela bt-ajuda 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadsim AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-bt-ajuda 
       MENU-ITEM mi-sobre       LABEL "Sobre..."      .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q01cl014 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q02cl014 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q01cl020 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v02cl020 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_V03CL014 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v04cl014 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v05cl014 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v06cl014 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 88.57 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     bt-ok AT ROW 11.13 COL 3
     bt-cancela AT ROW 11.13 COL 13
     bt-ajuda AT ROW 11.13 COL 77.57
     rt-button AT ROW 10.83 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 88.57 BY 11.38
         CANCEL-BUTTON bt-cancela.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-paruni
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Design Page: 4
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-cadsim ASSIGN
         HIDDEN             = YES
         TITLE              = "Parƒmetros C¢digo de Barras"
         HEIGHT             = 11.46
         WIDTH              = 88.72
         MAX-HEIGHT         = 28.67
         MAX-WIDTH          = 146.14
         VIRTUAL-HEIGHT     = 28.67
         VIRTUAL-WIDTH      = 146.14
         RESIZE             = YES
         SCROLL-BARS        = NO
         STATUS-AREA        = YES
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = YES
         MESSAGE-AREA       = NO
         SENSITIVE          = YES.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-cadsim 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-incsim.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-cadsim
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   L-To-R                                                               */
ASSIGN 
       bt-ajuda:POPUP-MENU IN FRAME f-cad       = MENU POPUP-MENU-bt-ajuda:HANDLE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = YES.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON END-ERROR OF w-cadsim /* Parƒmetros C¢digo de Barras */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
   /* This case occurs when the user presses the "Esc" key.
      In a persistently run window, just ignore this.  If we did not, the
      application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON WINDOW-CLOSE OF w-cadsim /* Parƒmetros C¢digo de Barras */
DO:
   /* This ADM code must be left here in order for the SmartWindow
      and its descendents to terminate properly on exit. */
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-cadsim
ON CHOOSE OF bt-ajuda IN FRAME f-cad /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela w-cadsim
ON CHOOSE OF bt-cancela IN FRAME f-cad /* Cancelar */
DO:
   RUN notify ('cancel-record').
   APPLY "CLOSE" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-cadsim
ON CHOOSE OF bt-ok IN FRAME f-cad /* OK */
DO:
   RUN notify ('update-record').
   IF RETURN-VALUE <> "adm-error" THEN DO:
      RUN pi-retorna-valor IN h_v02cl020 (INPUT-OUTPUT i-acum-valores).
      IF i-acum-valores = 0 THEN DO:
          ASSIGN bc-param-mat.log-1 = NO.
      END.
      ELSE DO:
          ASSIGN bc-param-mat.log-1 = YES.
      END.

      APPLY "CLOSE" TO THIS-PROCEDURE.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-cadsim
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
   {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-cadsim 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-cadsim  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
   DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.
   
   RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
   ASSIGN adm-current-page = INTEGER(RETURN-VALUE).
   
   CASE adm-current-page:   
      WHEN 0 THEN DO:
         RUN init-object IN THIS-PROCEDURE (
               INPUT  'adm/objects/folder.w':U ,
               INPUT  FRAME f-cad:HANDLE ,
               INPUT  'FOLDER-LABELS = ':U + 'Etiquetas|Materiais|RPW|Integra‡Æo' + ',
                       FOLDER-TAB-TYPE = 1':U ,
               OUTPUT h_folder ).
         RUN set-position IN h_folder ( 1.00 , 1.00 ) NO-ERROR.
         RUN set-size IN h_folder ( 9.83 , 88.57 ) NO-ERROR.
      
         RUN init-object IN THIS-PROCEDURE (
               INPUT  'clqry/q01cl014.w':U ,
               INPUT  FRAME f-cad:HANDLE ,
               INPUT  '':U ,
               OUTPUT h_q01cl014 ).
         RUN set-position IN h_q01cl014 ( 10.50 , 25.57 ) NO-ERROR.
         /* Size in UIB:  ( 1.79 , 8.29 ) */
      
    	   RUN init-object IN THIS-PROCEDURE (
                 INPUT  'clqry/q02cl014.w':U ,
                 INPUT  FRAME f-cad:HANDLE ,
                 INPUT  '':U ,
                 OUTPUT h_q02cl014 ).
    	   RUN set-position IN h_q02cl014 ( 10.50 , 25.57 ) NO-ERROR.
    	 	  /* Size in UIB:  ( 1.79 , 8.29 ) */
      
         RUN init-object IN THIS-PROCEDURE (
               INPUT  'clqry/q01cl020.w':U ,
               INPUT  FRAME f-cad:HANDLE ,
               INPUT  '':U ,
               OUTPUT h_q01cl020 ).
         RUN set-position IN h_q01cl020 ( 10.50 , 35.29 ) NO-ERROR.
         /* Size in UIB:  ( 1.79 , 8.29 ) */
      
         /* Links to SmartFolder h_folder. */
         RUN add-link IN adm-broker-hdl ( h_folder , 'Page':U , THIS-PROCEDURE ).      
      END.
      
      WHEN 1 THEN DO:
         RUN init-object IN THIS-PROCEDURE (
               INPUT  'clvwr/V03CL014.W':U ,
               INPUT  FRAME f-cad:HANDLE ,
               INPUT  'Layout = ':U ,
               OUTPUT h_V03CL014 ).
         RUN set-position IN h_V03CL014 ( 2.17 , 1.57 ) NO-ERROR.
         /* Size in UIB:  ( 8.50 , 87.57 ) */
      
         /* Links to SmartViewer h_V03CL014. */
         RUN add-link IN adm-broker-hdl ( h_q01cl014 , 'Record':U , h_V03CL014 ).
         RUN add-link IN adm-broker-hdl ( THIS-PROCEDURE , 'TableIO':U , h_V03CL014 ).
      
      END. /* Page 1 */
      
      WHEN 2 THEN DO:
         RUN init-object IN THIS-PROCEDURE (
               INPUT  'clvwr/v02cl020.w':U ,
               INPUT  FRAME f-cad:HANDLE ,
               INPUT  'Layout = ':U ,
               OUTPUT h_v02cl020 ).
         RUN set-position IN h_v02cl020 ( 2.17 , 1.57 ) NO-ERROR.
         /* Size in UIB:  ( 8.50 , 87.57 ) */
      
         /* Links to SmartViewer h_v02cl020. */
         RUN add-link IN adm-broker-hdl ( h_q01cl020 , 'Record':U , h_v02cl020 ).
      
      END. /* Page 2 */
      
      WHEN 3 THEN DO:
         RUN init-object IN THIS-PROCEDURE (
               INPUT  'clvwr/v04cl014.w':U ,
               INPUT  FRAME f-cad:HANDLE ,
               INPUT  'Layout = ':U ,
               OUTPUT h_v04cl014 ).
         RUN set-position IN h_v04cl014 ( 2.17 , 1.57 ) NO-ERROR.
         /* Size in UIB:  ( 8.50 , 87.57 ) */
      
         /* Initialize other pages that this page requires. */
         RUN init-pages IN THIS-PROCEDURE ('1') NO-ERROR.
      
         /* Links to SmartViewer h_v04cl014. */
         RUN add-link IN adm-broker-hdl ( h_q01cl014 , 'Record':U , h_v04cl014 ).
         RUN add-link IN adm-broker-hdl ( h_V03CL014 , 'group-assign':U , h_v04cl014 ).
      
      END. /* Page 3 */
      
      WHEN 4 THEN DO:
         RUN init-object IN THIS-PROCEDURE (
               INPUT  'clvwr/v05cl014.w':U ,
               INPUT  FRAME f-cad:HANDLE ,
               INPUT  'Layout = ':U ,
               OUTPUT h_v05cl014 ).
         RUN set-position IN h_v05cl014 ( 2.17 , 1.57 ) NO-ERROR.
         /* Size in UIB:  ( 8.04 , 86.72 ) */
      
         /* Initialize other pages that this page requires. */
         RUN init-pages IN THIS-PROCEDURE ('1') NO-ERROR.
      
         /* Links to SmartViewer h_v05cl014. */
         RUN add-link IN adm-broker-hdl ( h_q01cl014 , 'Record':U , h_v05cl014 ).
         RUN add-link IN adm-broker-hdl ( h_V03CL014 , 'group-assign':U , h_v05cl014 ).
      
         /* Adjust the tab order of the smart objects. */
      END.    
   
   END CASE.
   /* Select a Startup page. */
   IF adm-current-page EQ 0 THEN
      RUN select-page IN THIS-PROCEDURE ( 1 ).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-cadsim  _ADM-ROW-AVAILABLE
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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-cadsim  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
   /* Delete the WINDOW we created */
   IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim) THEN
      DELETE WIDGET w-cadsim.
   
   IF THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-cadsim  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  ENABLE rt-button bt-ok bt-cancela bt-ajuda 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-cadsim.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-cadsim 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
   IF VALID-HANDLE(gh-bofn068) THEN DO:
      DELETE PROCEDURE gh-bofn068 NO-ERROR.
      ASSIGN gh-bofn068 = ?.
   END.
   
   IF VALID-HANDLE(gh-bofn088) THEN DO:
      DELETE PROCEDURE gh-bofn088 NO-ERROR.
      ASSIGN gh-bofn088 = ?.
   END.
   
   IF VALID-HANDLE(gh-bofn116) THEN DO:
      DELETE PROCEDURE gh-bofn116 NO-ERROR.
      ASSIGN gh-bofn116 = ?.
   END.

   /* Code placed here will execute PRIOR to standard behavior. */

   /* Dispatch standard ADM method.                             */
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
   {include/i-logfin.i}

   /* Code placed here will execute AFTER standard behavior.    */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-cadsim 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
  
   RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-cadsim 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

   /* Code placed here will execute PRIOR to standard behavior. */
   {include/win-size.i}

   /* Dispatch standard ADM method.                             */
{utp/ut9000.i "BC0101" "2.00.00.026"} /* 31/08/2023 15:08:02 */

   RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
   {include/i-inifld.i}

   /* Code placed here will execute AFTER standard behavior.    */

   FIND FIRST bc-param-mat EXCLUSIVE-LOCK NO-ERROR.
   IF NOT AVAIL bc-param-mat THEN
      CREATE bc-param-mat.
   ELSE
      RUN pi-atualiza-valor IN h_v02cl020 (INPUT bc-param-mat.log-1).

   FIND FIRST param-bc NO-LOCK NO-ERROR.
   IF NOT AVAIL param-bc THEN DO:
      RUN notify IN THIS-PROCEDURE ('add-record':U).
   END.
   ELSE
      RUN new-state ('update-begin':U).

   RUN dispatch IN THIS-PROCEDURE ('enable-fields').
 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RTB_xref_generator w-cadsim 
PROCEDURE RTB_xref_generator :
/* -----------------------------------------------------------
Purpose:    Generate RTB xrefs for SMARTOBJECTS.
Parameters: <none>
Notes:      This code is generated by the UIB.  DO NOT modify it.
            It is included for Roundtable Xref generation. Without
            it, Xrefs for SMARTOBJECTS could not be maintained by
            RTB.  It will in no way affect the operation of this
            program as it never gets executed.
-------------------------------------------------------------*/
   RUN "adm/objects/folder.w *RTB-SmObj* ".
   RUN "clqry/q01cl014.w *RTB-SmObj* ".
   RUN "clqry/q02cl014.w *RTB-SmObj* ".
   RUN "clvwr/v03cl014.w *RTB-SmObj* ".
   RUN "clvwr/v04cl014.w *RTB-SmObj* ".
   RUN "clvwr/v05cl014.w *RTB-SmObj* ".
   RUN "clvwr/v06cl014.w *RTB-SmObj* ".
   RUN "clqry/q01cl020.w *RTB-SmObj* ".
   RUN "clvwr/v02cl020.w *RTB-SmObj* ".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-cadsim  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this w-paruni, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-cadsim 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
   DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
   DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBloqWindow w-cadsim 
PROCEDURE piBloqWindow :
/*------------------------------------------------------------------------------
  Notes: Bloqueia Tela
------------------------------------------------------------------------------*/
   {&WINDOW-NAME}:SENSITIVE = NO.
   
   RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLibWindow w-cadsim 
PROCEDURE piLibWindow :
/*------------------------------------------------------------------------------
  Notes: Libera Tela
------------------------------------------------------------------------------*/
   {&WINDOW-NAME}:SENSITIVE = YES.
   
   RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME   
