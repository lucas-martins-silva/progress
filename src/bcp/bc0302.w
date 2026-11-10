&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-livre 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0302 2.00.00.016}  /*** "010016" 31/08/2023 15:08:04  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BC0302 MBC}
&ENDIF



/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF VAR c-cdtrans-ini   AS CHAR     INIT ""             NO-UNDO.
DEF VAR c-cdtrans-fim   AS CHAR     INIT "ZZZZZZZZZZZZ" NO-UNDO.
DEF VAR de-nr-trans     AS DECIMAL  INIT 0000000000     NO-UNDO.
DEF VAR de-trans-ini    AS DECIMAL  INIT 0000000000     NO-UNDO.
DEF VAR de-trans-fim    AS DECIMAL  INIT 9999999999     NO-UNDO.
DEF VAR da-trans-ini    AS DATE     INIT 01/01/1800     NO-UNDO.
DEF VAR da-trans-fim    AS DATE     INIT 12/31/9999     NO-UNDO.
DEF VAR hr-trans-ini    AS CHAR     INIT "00:00:00"     NO-UNDO.
DEF VAR hr-trans-fim    AS CHAR     INIT "23:59:59"     NO-UNDO.
DEF VAR c-usu-ini       AS CHAR     INIT ""             NO-UNDO.
DEF VAR c-usu-fim       AS CHAR     INIT "ZZZZZZZZZZZZ" NO-UNDO.
DEF VAR da-atu-ini      AS DATE     INIT 01/01/1800     NO-UNDO.
DEF VAR da-atu-fim      AS DATE     INIT 12/31/9999     NO-UNDO.
DEF VAR hr-atu-ini      AS CHAR     INIT "00:00:00"     NO-UNDO.
DEF VAR hr-atu-fim      AS CHAR     INIT "23:59:59"     NO-UNDO.
DEF VAR l-nova          AS LOGICAL  INIT YES            NO-UNDO.
DEF VAR l-atualizada    AS LOGICAL  INIT NO             NO-UNDO.
DEF VAR l-erro          AS LOGICAL  INIT NO             NO-UNDO.
DEF VAR l-erro-vp       AS LOGICAL  INIT NO             NO-UNDO.
DEF VAR l-em-proces     AS LOGICAL  INIT NO             NO-UNDO.
DEF VAR l-cancelado     AS LOGICAL  INIT NO             NO-UNDO.
DEF VAR l-movimento     AS LOGICAL  INIT YES            NO-UNDO.
DEF VAR l-etiqueta      AS LOGICAL  INIT YES            NO-UNDO.
DEF VAR c-filtro        AS CHAR                         NO-UNDO.
DEF VAR lVaParaNrTrans  AS LOGICAL  INITIAL NO          NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-livre
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-cad

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-query bt-filtro bt-param bt-vapara ~
rt-button 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-livre AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU mi-programa 
       MENU-ITEM mi-consultas   LABEL "Co&nsultas"     ACCELERATOR "CTRL-L"
       MENU-ITEM mi-imprimir    LABEL "&Relat¢rios"    ACCELERATOR "CTRL-P"
       RULE
       MENU-ITEM mi-sair        LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU m_Ajuda 
       MENU-ITEM mi-conteudo    LABEL "&Conteudo"     
       MENU-ITEM mi-sobre       LABEL "&Sobre..."     .

DEFINE MENU m-livre MENUBAR
       SUB-MENU  mi-programa    LABEL "&Arquivo"      
       SUB-MENU  m_Ajuda        LABEL "&Ajuda"        .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b15cl012 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-exihel AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-filtro 
     IMAGE-UP FILE "image\im-fil":U
     IMAGE-INSENSITIVE FILE "image\ii-fil":U
     LABEL "" 
     SIZE 4 BY 1.25.

DEFINE BUTTON bt-param 
     IMAGE-UP FILE "image\im-param":U
     IMAGE-INSENSITIVE FILE "image\im-param":U
     LABEL "" 
     SIZE 4 BY 1.25.

DEFINE BUTTON bt-query 
     IMAGE-UP FILE "image\im-sav":U
     LABEL "" 
     SIZE 4 BY 1.25.

DEFINE BUTTON bt-vapara 
     IMAGE-UP FILE "image/im-crit.bmp":U
     LABEL "<VP>" 
     SIZE 4 BY 1.25 TOOLTIP "V  Para Numero da Transa‡Æo.".

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 89.72 BY 1.46
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     bt-query AT ROW 1.13 COL 2 HELP
          "Atualiza Informa‡äes"
     bt-filtro AT ROW 1.13 COL 6 HELP
          "Filtro"
     bt-param AT ROW 1.13 COL 10 HELP
          "Parƒmetros"
     bt-vapara AT ROW 1.13 COL 14 HELP
          "V  Para Numero da Transa‡Æo."
     rt-button AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 11.33.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-livre
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-livre ASSIGN
         HIDDEN             = YES
         TITLE              = "Consulta Transa‡äes"
         HEIGHT             = 11.29
         WIDTH              = 90
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU m-livre:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-livre 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-livre.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-livre
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
THEN w-livre:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON END-ERROR OF w-livre /* Consulta Transa‡äes */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
   /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON WINDOW-CLOSE OF w-livre /* Consulta Transa‡äes */
DO:
   /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-filtro w-livre
ON CHOOSE OF bt-filtro IN FRAME f-cad
DO:
   ASSIGN lVaParaNrTrans = NO.
   RUN dispatch IN h_b15cl012 ('open-query':U).
   RUN bcp/bc0203a.w (INPUT-OUTPUT c-filtro).
   RUN pi-recebe-param IN h_b15cl012 (INPUT c-cdtrans-ini,
                                      INPUT c-cdtrans-fim,
                                      INPUT de-trans-ini,
                                      INPUT de-trans-fim,
                                      INPUT da-trans-ini,
                                      INPUT da-trans-fim,
                                      INPUT hr-trans-ini,
                                      INPUT hr-trans-fim,
                                      INPUT c-usu-ini,
                                      INPUT c-usu-fim,
                                      INPUT da-atu-ini,
                                      INPUT da-atu-fim,
                                      INPUT hr-atu-ini,
                                      INPUT hr-atu-fim,
                                      INPUT l-nova,
                                      INPUT l-atualizada,
                                      INPUT l-erro,
                                      INPUT l-em-proces,
                                      INPUT l-cancelado,
                                      INPUT l-movimento,
                                      INPUT l-etiqueta,
                                      INPUT c-filtro).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-param
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-param w-livre
ON CHOOSE OF bt-param IN FRAME f-cad
DO:
   ASSIGN lVaParaNrTrans = NO.
   RUN dispatch IN h_b15cl012 ('open-query':U).
   RUN bcp/bc0203b.w (INPUT "bc0302",
                      INPUT-OUTPUT c-cdtrans-ini,
                      INPUT-OUTPUT c-cdtrans-fim,
                      INPUT-OUTPUT de-trans-ini,
                      INPUT-OUTPUT de-trans-fim,
                      INPUT-OUTPUT da-trans-ini,
                      INPUT-OUTPUT da-trans-fim,
                      INPUT-OUTPUT hr-trans-ini,
                      INPUT-OUTPUT hr-trans-fim,
                      INPUT-OUTPUT c-usu-ini,
                      INPUT-OUTPUT c-usu-fim,
                      INPUT-OUTPUT da-atu-ini,
                      INPUT-OUTPUT da-atu-fim,
                      INPUT-OUTPUT hr-atu-ini,
                      INPUT-OUTPUT hr-atu-fim,
                      INPUT-OUTPUT l-nova,
                      INPUT-OUTPUT l-atualizada,
                      INPUT-OUTPUT l-erro,
                      INPUT-OUTPUT l-em-proces,
                      INPUT-OUTPUT l-cancelado,
                      INPUT-OUTPUT l-movimento,
                      INPUT-OUTPUT l-etiqueta).

   RUN pi-recebe-param in h_b15cl012 (INPUT c-cdtrans-ini,
                                      INPUT c-cdtrans-fim,
                                      INPUT de-trans-ini,
                                      INPUT de-trans-fim,
                                      INPUT da-trans-ini,
                                      INPUT da-trans-fim,
                                      INPUT hr-trans-ini,
                                      INPUT hr-trans-fim,
                                      INPUT c-usu-ini,
                                      INPUT c-usu-fim,
                                      INPUT da-atu-ini,
                                      INPUT da-atu-fim,
                                      INPUT hr-atu-ini,
                                      INPUT hr-atu-fim,
                                      INPUT l-nova,
                                      INPUT l-atualizada,
                                      INPUT l-erro,
                                      INPUT l-em-proces,
                                      INPUT l-cancelado,
                                      INPUT l-movimento,
                                      INPUT l-etiqueta,
                                      INPUT c-filtro).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-query
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-query w-livre
ON CHOOSE OF bt-query IN FRAME f-cad
DO:
   IF lVaParaNrTrans = YES THEN DO:
      RUN utp/ut-msgs (INPUT "SHOW",
                       INPUT 29746,
                       INPUT STRING(de-nr-trans)).
      IF RETURN-VALUE = "NO" THEN DO:
         ASSIGN lVaParaNrTrans = NO.
         RUN dispatch IN h_b15cl012 ('open-query':U).

         RUN pi-recebe-param in h_b15cl012 (INPUT c-cdtrans-ini,
                                            INPUT c-cdtrans-fim,
                                            INPUT de-trans-ini,
                                            INPUT de-trans-fim,
                                            INPUT da-trans-ini,
                                            INPUT da-trans-fim,
                                            INPUT hr-trans-ini,
                                            INPUT hr-trans-fim,
                                            INPUT c-usu-ini,
                                            INPUT c-usu-fim,
                                            INPUT da-atu-ini,
                                            INPUT da-atu-fim,
                                            INPUT hr-atu-ini,
                                            INPUT hr-atu-fim,
                                            INPUT l-nova,
                                            INPUT l-atualizada,
                                            INPUT l-erro,
                                            INPUT l-em-proces,
                                            INPUT l-cancelado,
                                            INPUT l-movimento,
                                            INPUT l-etiqueta,
                                            INPUT c-filtro).
      END.
   END.

   RUN pi-atualiza-query IN h_b15cl012 (INPUT YES).
   RUN dispatch IN h_b15cl012 ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-vapara
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-vapara w-livre
ON CHOOSE OF bt-vapara IN FRAME f-cad /* <VP> */
DO:
   ASSIGN  de-nr-trans = 0.
   RUN dispatch IN h_b15cl012 ('open-query':U).
   RUN bcp/bc0203d.w (INPUT-OUTPUT de-nr-trans).
   IF de-nr-trans <> 0 THEN DO:
      ASSIGN lVaParaNrTrans = YES.
      RUN pi-vapara-nrtrans IN h_b15cl012 (INPUT de-nr-trans, OUTPUT l-erro-vp).
      IF l-erro-vp THEN DO:
         ASSIGN lVaParaNrTrans = NO.
         {utp/ut-liter.i "Numero da transa‡Æo nÆo encontrado."}
         RUN utp/ut-msgs.p (INPUT "SHOW",
                            INPUT 17567,
                            INPUT RETURN-VALUE + "(" + STRING(de-nr-trans) + ")" ).
      END.
   END.
   ELSE
      ASSIGN lVaParaNrTrans = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-consultas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-consultas w-livre
ON CHOOSE OF MENU-ITEM mi-consultas /* Consultas */
DO:
   RUN pi-consulta IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-conteudo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-conteudo w-livre
ON CHOOSE OF MENU-ITEM mi-conteudo /* Conteudo */
OR HELP OF FRAME {&FRAME-NAME}
DO:
   RUN pi-ajuda IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-imprimir w-livre
ON CHOOSE OF MENU-ITEM mi-imprimir /* Relat¢rios */
DO:
   RUN pi-imprimir IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-programa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-programa w-livre
ON MENU-DROP OF MENU mi-programa /* Arquivo */
DO:
   RUN pi-disable-menu.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sair w-livre
ON CHOOSE OF MENU-ITEM mi-sair /* Sair */
DO:
   RUN pi-sair IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-livre
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
   {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-livre 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-livre  _ADM-CREATE-OBJECTS
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
             INPUT  'panel/p-exihel.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-exihel ).
       RUN set-position IN h_p-exihel ( 1.13 , 74.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.25 , 16.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'clbrw/b15cl012.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b15cl012 ).
       RUN set-position IN h_b15cl012 ( 2.79 , 1.43 ) NO-ERROR.
       /* Size in UIB:  ( 9.42 , 89.00 ) */

       /* Links to SmartPanel h_p-exihel. */
       RUN add-link IN adm-broker-hdl ( h_p-exihel , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-exihel ,
             bt-vapara:HANDLE IN FRAME f-cad , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b15cl012 ,
             h_p-exihel , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-livre  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-livre  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
  THEN DELETE WIDGET w-livre.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-livre  _DEFAULT-ENABLE
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
  ENABLE bt-query bt-filtro bt-param bt-vapara rt-button 
      WITH FRAME f-cad IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-livre.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-livre 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-livre 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-livre 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

   /* Code placed here will execute PRIOR to standard behavior. */
   RUN pi-before-initialize.

   {include/win-size.i}

{utp/ut9000.i "BC0302" "2.00.00.016"} /* 31/08/2023 15:08:04 */

   /* Dispatch standard ADM method.                             */

   RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

   /* Code placed here will execute AFTER standard behavior.    */

   RUN pi-after-initialize.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RTB_xref_generator w-livre 
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
   RUN "panel\p-exihel.w *RTB-SmObj* ".
   RUN "clbrw\b15cl012.w *RTB-SmObj* ".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-livre  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this w-livre, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-livre 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
   DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
   DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

   RUN pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBloqWindow wMaintenance 
PROCEDURE piBloqWindow :
/*------------------------------------------------------------------------------
  Notes: Bloquei Tela
------------------------------------------------------------------------------*/
   ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLibWindow wMaintenance 
PROCEDURE piLibWindow  :
/*------------------------------------------------------------------------------
  Notes: Libera Tela
------------------------------------------------------------------------------*/
   ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

