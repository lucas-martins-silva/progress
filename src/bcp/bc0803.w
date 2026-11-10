&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-window 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0803 2.00.00.016}  /*** "010016" 31/08/2023 15:08:05  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BC0803 MBC}
&ENDIF


/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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
DEF INPUT PARAM h-handleParam AS HANDLE               NO-UNDO.
DEF INPUT PARAM h-handleSon   AS HANDLE               NO-UNDO.
DEF INPUT PARAM i-nr-trans    LIKE bc-trans.nr-trans  NO-UNDO.
DEF INPUT PARAM c-detalhe     LIKE bc-trans.detalhe   NO-UNDO.
DEF INPUT PARAM r-conteudo    AS RAW                  NO-UNDO.
DEF INPUT PARAM l-apaga       AS LOGICAL              NO-UNDO.
/* Local Variable Definitions ---                                       */
DEF VAR c-cd-trans  LIKE bc-trans.cd-trans NO-UNDO.
DEF VAR raw-temp    AS RAW                 NO-UNDO.
DEF VAR l-programa  AS LOGICAL INITIAL NO  NO-UNDO.
DEF VAR l-trans-atu AS LOGICAL INITIAL NO  NO-UNDO.
{bcp/bcapi002.i}

DEFINE NEW GLOBAL SHARED VAR vAcessType AS INTEGER NO-UNDO.

IF vAcessType = 2 THEN
   ASSIGN l-programa  = YES
          l-trans-atu = YES.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE JanelaDetalhe
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-ajuda bt-ok bt-cancelar RECT-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-window AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_folder   AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v18cl012 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v27cl012 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v29cl012 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v30cl012 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 88 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     bt-ajuda AT ROW 15 COL 77.57
     bt-ok AT ROW 15.04 COL 2
     bt-cancelar AT ROW 15.04 COL 13
     RECT-1 AT ROW 14.83 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 88.72 BY 15.33.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: JanelaDetalhe
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
   Design Page: 2
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-window ASSIGN
         HIDDEN             = YES
         TITLE              = "Manuten‡Æo de Etiquetas Avulsas"
         HEIGHT             = 15.46
         WIDTH              = 89
         MAX-HEIGHT         = 21.13
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.13
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-window 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-window.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-window
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
THEN w-window:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON END-ERROR OF w-window /* Manuten‡Æo de Etiquetas Avulsas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
   /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON WINDOW-CLOSE OF w-window /* Manuten‡Æo de Etiquetas Avulsas */
DO:
   /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
   IF VALID-HANDLE(h-handleParam) AND STRING(h-handleParam) <> "0" THEN
      RUN piLibWindow IN h-handleParam NO-ERROR. 
     
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-window
ON CHOOSE OF bt-ajuda IN FRAME F-Main /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO:
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar w-window
ON CHOOSE OF bt-cancelar IN FRAME F-Main /* Cancelar */
DO:
   IF VALID-HANDLE(h-handleParam) AND STRING(h-handleParam) <> "0" THEN
      RUN piLibWindow IN h-handleParam NO-ERROR. 
      
   ASSIGN l-apaga = NO.
   APPLY "CLOSE" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-window
ON CHOOSE OF bt-ok IN FRAME F-Main /* OK */
DO:
   IF l-programa THEN DO:
      APPLY "CHOOSE" TO bt-cancelar IN FRAME {&FRAME-NAME}.
      LEAVE.
   END.

   CREATE tt-etiqueta.
   RUN pi-devolve-trans IN h_v18cl012 (INPUT-OUTPUT TABLE tt-etiqueta,
                                       OUTPUT c-detalhe).

   FIND FIRST tt-etiqueta NO-ERROR.
   RAW-TRANSFER tt-etiqueta TO r-conteudo.

   IF VALID-HANDLE(h-handleParam) AND STRING(h-handleParam) <> "0" THEN
      RUN piLibWindow IN h-handleParam NO-ERROR. 
      
   IF VALID-HANDLE(h-handleSon) AND STRING(h-handleSon) <> "0" THEN
      RUN pi-atualiza-dados IN h-handleSon (INPUT i-nr-trans,
                                            INPUT c-detalhe,
                                            INPUT r-conteudo,
                                            INPUT l-apaga) NO-ERROR. 
   APPLY "CLOSE" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-window 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-window  _ADM-CREATE-OBJECTS
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
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'FOLDER-LABELS = ':U + 'Etiqueta|Etiqueta 1|Auxiliar|Auxiliar 1' + ',
                     FOLDER-TAB-TYPE = 1':U ,
             OUTPUT h_folder ).
       RUN set-position IN h_folder ( 1.33 , 1.00 ) NO-ERROR.
       RUN set-size IN h_folder ( 13.33 , 88.00 ) NO-ERROR.

       /* Links to SmartFolder h_folder. */
       RUN add-link IN adm-broker-hdl ( h_folder , 'Page':U , THIS-PROCEDURE ).

    END. /* Page 0 */

    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'clvwr/v18cl012.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v18cl012 ).
       RUN set-position IN h_v18cl012 ( 2.75 , 2.00 ) NO-ERROR.
       /* Size in UIB:  ( 11.33 , 86.29 ) */

    END. /* Page 1 */

    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'clvwr/v30cl012.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v30cl012 ).
       RUN set-position IN h_v30cl012 ( 2.75 , 2.00 ) NO-ERROR.
       /* Size in UIB:  ( 11.33 , 85.72 ) */

    END. /* Page 2 */

    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'clvwr/v27cl012.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v27cl012 ).
       RUN set-position IN h_v27cl012 ( 2.75 , 2.00 ) NO-ERROR.
       /* Size in UIB:  ( 11.50 , 85.72 ) */

       /* Initialize other pages that this page requires. */
       RUN init-pages IN THIS-PROCEDURE ('1') NO-ERROR.

       /* Links to SmartViewer h_v27cl012. */
       RUN add-link IN adm-broker-hdl ( h_v18cl012 , 'Record':U , h_v27cl012 ).

    END. /* Page 3 */

    WHEN 4 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'clvwr/v29cl012.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v29cl012 ).
       RUN set-position IN h_v29cl012 ( 2.75 , 2.00 ) NO-ERROR.
       /* Size in UIB:  ( 11.33 , 85.72 ) */

       /* Adjust the tab order of the smart objects. */
    END. /* Page 4 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-window  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-window  _DEFAULT-DISABLE
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
   IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
   THEN DELETE WIDGET w-window.
   IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-window  _DEFAULT-ENABLE
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
  ENABLE bt-ajuda bt-ok bt-cancelar RECT-1 
      WITH FRAME F-Main IN WINDOW w-window.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW w-window.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-window 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

   /* Code placed here will execute PRIOR to standard behavior. */
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
   /* Dispatch standard ADM method.                             */
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
   {include/i-logfin.i}

   /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-window 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   IF VALID-HANDLE(h-handleParam) AND STRING(h-handleParam) <> "0" THEN
      RUN piLibWindow IN h-handleParam NO-ERROR. 

   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-window 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

   /* Code placed here will execute PRIOR to standard behavior. */
   
{utp/ut9000.i "BC0803" "2.00.00.016"} /* 31/08/2023 15:08:05 */

   IF VALID-HANDLE(h-handleParam) AND STRING(h-handleParam) <> "0" THEN
      RUN piBloqWindow IN h-handleParam NO-ERROR. 

   /* Dispatch standard ADM method.                             */
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

   RUN init-pages("4,3,2,1").
   RUN pi-habilita-campos IN h_v18cl012 (INPUT YES).
   RUN pi-habilita-campos IN h_v27cl012 (INPUT YES).
   RUN pi-habilita-campos IN h_v29cl012 (INPUT YES).
   RUN pi-habilita-campos IN h_v30cl012 (INPUT YES).

   FIND FIRST bc-trans 
        WHERE bc-trans.nr-trans = i-nr-trans NO-LOCK NO-ERROR.       
   IF AVAIL bc-trans THEN
      ASSIGN c-cd-trans = bc-trans.cd-trans.

   RUN pi-recebe-handle IN h_v18cl012 (INPUT h_v27cl012,
                                       INPUT ?,
                                       INPUT h_v29cl012,
                                       INPUT h_v30cl012,
                                       INPUT c-cd-trans).

   RUN pi-recebe-trans IN h_v18cl012 (INPUT r-conteudo, INPUT c-detalhe).
  
   IF l-programa AND l-trans-atu THEN DO:
      RUN pi-desabilita-tudo IN h_v18cl012.
      RUN pi-desabilita-tudo IN h_v27cl012.
      RUN pi-desabilita-tudo IN h_v29cl012.
      RUN pi-desabilita-tudo IN h_v30cl012.
   END.

   /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RTB_xref_generator w-window 
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
   RUN clvwr/v30cl012.w.
   RUN clvwr/v18cl012.w.
   RUN adm/objects/folder.w.
   RUN clvwr/v29cl012.w.
   RUN clvwr/v27cl012.w.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-window  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this JanelaDetalhe, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-window 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
   DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
   DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

