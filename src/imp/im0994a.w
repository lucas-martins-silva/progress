&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-incmdp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-incmdp 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0994A 2.00.00.003 } /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im0994a MIM}
&ENDIF



CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

&global-define botao yes

/* Parameters Definitions ---                                           */

def input-output parameter v-row-table  as rowid.
def input        parameter estado       as char.
def input        parameter wh-query     as widget-handle.


/* usado como global no im0994a-b01 */
def new global shared var v-row-parent as rowid   no-undo.
def new global shared var gr-docum-est as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{cdp/cd4305.i1}                         /* Definicao TT-DOCTO, TT-IT-DOCTO */
{cdp/cd4401.i3}                         /* Definicao da temp-table TT-SALDO-ESTOQ */
{rep/re1001o.i01}                       /* Definicao da temp-table TT-CONSIST */
{rep/re9800.i}                          /* Pi-seta-flag-observacao*/
{rep/re1907.i03}                        /* pi-determina-ipi*/

/*def var v-row-parent as rowid no-undo.*/

Def var h-programa as handle no-undo.
def var c-handle as char no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button bt-ok bt-save bt-cancela bt-ajuda 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-incmdp AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-bt-ajuda 
       MENU-ITEM mi-sobre       LABEL "Sobre..."      .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.
DEFINE VARIABLE h_im0994av01 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_im0994av02 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_im0994av03 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q08in090 AS HANDLE NO-UNDO.

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

DEFINE BUTTON bt-save AUTO-GO 
     LABEL "&Salvar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 87 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     bt-ok AT ROW 16.75 COL 3.29 HELP
          "Salva e sai"
     bt-save AT ROW 16.75 COL 14.57 HELP
          "Salva e cria novo registro"
     bt-cancela AT ROW 16.75 COL 25.72 HELP
          "Cancela"
     bt-ajuda AT ROW 16.75 COL 78.29
     rt-button AT ROW 16.5 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-incmdp ASSIGN
         HIDDEN             = YES
         TITLE              = "Inclus∆o/Modificaá∆o de Documentos"
         HEIGHT             = 17.08
         WIDTH              = 90
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = yes
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-incmdp 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-incmdp.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-incmdp
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME                                                           */
ASSIGN 
       bt-ajuda:POPUP-MENU IN FRAME f-cad       = MENU POPUP-MENU-bt-ajuda:HANDLE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-incmdp)
THEN w-incmdp:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-incmdp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-incmdp w-incmdp
ON END-ERROR OF w-incmdp /* Inclus∆o/Modificaá∆o de Documentos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-incmdp w-incmdp
ON WINDOW-CLOSE OF w-incmdp /* Inclus∆o/Modificaá∆o de Documentos */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-incmdp
ON CHOOSE OF bt-ajuda IN FRAME f-cad /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela w-incmdp
ON CHOOSE OF bt-cancela IN FRAME f-cad /* Cancelar */
DO:
    run notify ('cancel-record').
    APPLY "close" to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-incmdp
ON CHOOSE OF bt-ok IN FRAME f-cad /* OK */
DO:
    DO ON ERROR UNDO, RETURN NO-APPLY:
       RUN dispatch IN h_im0994av01 ('update-record':U).
       IF  RETURN-VALUE = "ADM-ERROR":U THEN
           RETURN NO-APPLY.

       RUN pi-cria-tt-docum-est IN wh-query.
       RUN dispatch IN wh-query ('open-query':U).
       RUN get-rowid IN h_im0994av01 (OUTPUT v-row-table).
       RUN pi-reposiciona-docum-est IN wh-query (INPUT v-row-table).
       
       APPLY "close":U to this-procedure.
    END. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-save
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-save w-incmdp
ON CHOOSE OF bt-save IN FRAME f-cad /* Salvar */
DO:
   DO ON ERROR UNDO, RETURN NO-APPLY:
      RUN dispatch IN h_im0994av01 ('update-record':U).
      IF RETURN-VALUE = "ADM-ERROR":U THEN
         RETURN NO-APPLY.

      RUN select-page (INPUT 1).
     
      RUN pi-cria-tt-docum-est IN wh-query.

      IF estado = 'copia':U THEN DO:
         RUN pi-desabilita-chave IN h_im0994av01.
      END.  
      IF estado = 'inclui':U THEN DO:
         RUN dispatch IN wh-query('open-query':U).
         RUN dispatch IN h_im0994av01 ('add-record':U).
      END.
    END. 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-incmdp
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-incmdp 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-incmdp  _ADM-CREATE-OBJECTS
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
             INPUT  'FOLDER-LABELS = ':U + 'Documentos|Observaá∆o|Argentina' + ',
                     FOLDER-TAB-TYPE = 1':U ,
             OUTPUT h_folder ).
       RUN set-position IN h_folder ( 1.25 , 3.00 ) NO-ERROR.
       RUN set-size IN h_folder ( 14.50 , 87.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'inqry/q08in090.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q08in090 ).
       RUN set-position IN h_q08in090 ( 1.00 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.63 , 7.72 ) */

       /* Links to SmartFolder h_folder. */
       RUN add-link IN adm-broker-hdl ( h_folder , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_folder ,
             bt-ok:HANDLE IN FRAME f-cad , 'BEFORE':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'imp/im0994a-v01.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_im0994av01 ).
       RUN set-position IN h_im0994av01 ( 2.50 , 3.00 ) NO-ERROR.
       /* Size in UIB:  ( 13.25 , 86.57 ) */

       /* Links to SmartViewer h_im0994av01. */
       RUN add-link IN adm-broker-hdl ( h_q08in090 , 'Record':U , h_im0994av01 ).
       RUN add-link IN adm-broker-hdl ( THIS-PROCEDURE , 'TableIO':U , h_im0994av01 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_im0994av01 ,
             h_folder , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'imp/im0994a-v02.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_im0994av02 ).
       RUN set-position IN h_im0994av02 ( 3.63 , 10.72 ) NO-ERROR.
       /* Size in UIB:  ( 8.17 , 72.00 ) */

       /* Initialize other pages that this page requires. */
       RUN init-pages IN THIS-PROCEDURE ('1':U) NO-ERROR.

       /* Links to SmartViewer h_im0994av02. */
       RUN add-link IN adm-broker-hdl ( h_im0994av01 , 'Group-assign':U , h_im0994av02 ).
       RUN add-link IN adm-broker-hdl ( h_q08in090 , 'Record':U , h_im0994av02 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_im0994av02 ,
             h_folder , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'imp/im0994a-v03.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_im0994av03 ).
       RUN set-position IN h_im0994av03 ( 2.92 , 4.57 ) NO-ERROR.
       /* Size in UIB:  ( 11.00 , 82.00 ) */

       /* Initialize other pages that this page requires. */
       RUN init-pages IN THIS-PROCEDURE ('1':U) NO-ERROR.

       /* Links to SmartViewer h_im0994av03. */
       RUN add-link IN adm-broker-hdl ( h_im0994av01 , 'Group-assign':U , h_im0994av03 ).
       RUN add-link IN adm-broker-hdl ( h_q08in090 , 'Record':U , h_im0994av03 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_im0994av03 ,
             h_folder , 'AFTER':U ).
    END. /* Page 3 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-incmdp  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-incmdp  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-incmdp)
  THEN DELETE WIDGET w-incmdp.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-incmdp  _DEFAULT-ENABLE
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
  ENABLE rt-button bt-ok bt-save bt-cancela bt-ajuda 
      WITH FRAME f-cad IN WINDOW w-incmdp.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-incmdp.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-incmdp 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-incmdp 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-incmdp 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /**********************************************************************
  Esta l¢gica foi implementada a fim de impedir que o usu†rio modifique o
  documento (IM0994A) enquanto os itens estiverem sendo implantados    */
  ASSIGN i-template = 9.

  {utp/ut9000.i "IM0994A" "2.00.00.000"}

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  {include/i-inifld.i}

  /*assign bt-save:sensitive in frame {&FRAME-NAME} = no.*/

  IF  i-pais-impto-usuario = 2 /* Argentina */ THEN
      RUN init-pages IN THIS-PROCEDURE ('1,2,3').
  ELSE DO:
      RUN init-pages IN THIS-PROCEDURE ('1,2').

      RUN delete-folder-page IN h_folder (INPUT 3).
  END.

  RUN pi-recebe-handle IN h_im0994av01 (INPUT h_im0994av02,
                                        INPUT h_im0994av03,
                                        INPUT THIS-PROCEDURE).

  assign bt-save:sensitive in frame {&frame-name} = (estado = "inclui":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-reposiciona w-incmdp 
PROCEDURE pi-reposiciona :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR rw-posicao-query AS ROWID NO-UNDO.
  RUN pi-posicao-docum-est IN wh-query   (OUTPUT rw-posicao-query).
  RUN pi-reposiciona-query IN h_q08in090 (INPUT rw-posicao-query). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RTB_xref_generator w-incmdp 
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
  RUN adm/objects/folder.w.
  RUN inqry/q08in090.w.
  RUN imp/im0994a-v02.w.
  RUN imp/im0994a-v01.w.
  RUN imp/im0994a-v03.w.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-incmdp  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-incmdp 
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

