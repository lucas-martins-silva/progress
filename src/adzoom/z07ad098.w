&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME z02ad098
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS z02ad098 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i Z07AD098 2.00.00.020}  /*** 010020 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i z07ad098 MUT}
&ENDIF




/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
  Version: 1.00.000
  
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
&glob version 1.00.000

/* Parameters Definitions ---                                           */

/* Vari veis do filtro                                                  */
{cdp/cd9098.i}

/* Local Variable Definitions ---                                       */

def var v-row-table     as rowid no-undo.
def new global shared var i-identific  as integer no-undo.
/* {cdp/cdcfgmat.i} /* Definicao de pre-processadores - Magnus ou EMS */              */
/*                                                                                    */
/* /* Alfa 2.06 */                                                                    */
/* &IF "{&bf_mat_versao_ems}":U >= "2.05":U &THEN                                     */
/*     define variable l-fornecedor-filtro            as logical initial yes no-undo. */
/*     define variable l-cliente-filtro               as logical initial yes no-undo. */
/*     define variable l-ambos-filtro                 as logical initial yes no-undo. */
/*                                                                                    */
/*     define variable l-ativos-filtro                as logical initial yes no-undo. */
/*     define variable l-restricao-compras-filtro     as logical initial yes no-undo. */
/*     define variable l-restricao-compras-rec-filtro as logical initial yes no-undo. */
/*     define variable l-inativos-filtro              as logical initial yes no-undo. */
/*     define variable c-data-emit-restricao-filtro   as CHAR no-undo.                */
/* &ENDIF                                                                             */
/*                                                                                    */
/* define variable l-ok                           as logical             no-undo.     */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-zoom

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-filtro rt-button bt-ajuda bt-ok ~
bt-cancela /*bt-parametros*/

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR z02ad098 AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-bt-ajuda 
       MENU-ITEM mi-sobre       LABEL "Sobre..."      .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b24ad098 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b34ad098 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b35ad098 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b36ad098 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON bt-filtro 
     LABEL "Filtro" 
     SIZE 15.43 BY 1.08
     BGCOLOR 8 .

/* DEFINE BUTTON bt-parametros */
/*      LABEL "&Parametros"    */
/*      SIZE 15.43 BY 1.08     */
/*      BGCOLOR 8 .            */

DEFINE BUTTON bt-implantar 
     LABEL "Implantar" 
     SIZE 15.43 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 86 BY 1.67
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-zoom
     bt-implantar AT ROW 14.25 COL 1
     bt-filtro AT ROW 14.25 COL 16.29
     /*bt-parametros AT ROW 14.25 COL 31.60*/
     bt-ajuda AT ROW 15.75 COL 72
     bt-ok AT ROW 15.83 COL 2.14
     bt-cancela AT ROW 15.83 COL 14.72
     rt-button AT ROW 15.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1.13
         SIZE 86.14 BY 16.88
         DEFAULT-BUTTON bt-ok.


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
  CREATE WINDOW z02ad098 ASSIGN
         HIDDEN             = YES
         TITLE              = "Pesquisa Cliente"
         HEIGHT             = 16.42
         WIDTH              = 86
         MAX-HEIGHT         = 18.38
         MAX-WIDTH          = 104
         VIRTUAL-HEIGHT     = 18.38
         VIRTUAL-WIDTH      = 104
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW z02ad098
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-zoom
                                                                        */
ASSIGN 
       bt-ajuda:POPUP-MENU IN FRAME f-zoom       = MENU POPUP-MENU-bt-ajuda:HANDLE.

/* SETTINGS FOR BUTTON bt-implantar IN FRAME f-zoom
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(z02ad098)
THEN z02ad098:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB z02ad098 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-pesqui.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME z02ad098
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL z02ad098 z02ad098
ON END-ERROR OF z02ad098 /* Pesquisa Cliente */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL z02ad098 z02ad098
ON WINDOW-CLOSE OF z02ad098 /* Pesquisa Cliente */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-zoom
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-zoom z02ad098
ON GO OF FRAME f-zoom
DO:
  run pi-go.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda z02ad098
ON CHOOSE OF bt-ajuda IN FRAME f-zoom /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela z02ad098
ON CHOOSE OF bt-cancela IN FRAME f-zoom /* Cancelar */
DO:
    RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-filtro z02ad098
ON CHOOSE OF bt-filtro IN FRAME f-zoom /* Filtro */
DO:
    run cdp/cd9098.w.
    RUN notify IN  this-procedure ('open-query,container-target':U).
END. 

/* /* _UIB-CODE-BLOCK-END */                                              */
/* &ANALYZE-RESUME                                                        */
/*                                                                        */
/*                                                                        */
/* &Scoped-define SELF-NAME bt-filtro                                     */
/* &ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-parametros z02ad098       */
/* ON CHOOSE OF bt-parametros IN FRAME f-zoom /* Filtro */                */
/* DO:                                                                    */
/*     /* Alfa 2.06 */                                                    */
/*     &IF "{&bf_mat_versao_ems}":U >= "2.05":U &THEN                     */
/*         run cdp/cd9099.w (input NO,                                    */
/*                           input-output l-fornecedor-filtro,            */
/*                           input-output l-cliente-filtro,               */
/*                           input-output l-ambos-filtro,                 */
/*                           input-output l-ativos-filtro,                */
/*                           input-output l-restricao-compras-filtro,     */
/*                           input-output l-restricao-compras-rec-filtro, */
/*                           input-output l-inativos-filtro,              */
/*                           input-output c-data-emit-restricao-filtro,   */
/*                           output       l-ok).                          */
/*         if  l-ok then                                                  */
/*             run pi-passa-identific in this-procedure.                  */
/*     &ENDIF                                                             */
/* END.                                                                   */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME bt-implantar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-implantar z02ad098
ON CHOOSE OF bt-implantar IN FRAME f-zoom /* Implantar */
DO:
  if  i-filtro = 1 THEN DO:
      {include/i-implan.i cdp/cd0704.w h_b24ad098 h_b34ad098 h_b35ad098 h_b36ad098}
  END.
  ELSE
      if  i-filtro = 2 THEN DO:
          {include/i-implan.i cdp/cd0401.w h_b24ad098 h_b34ad098 h_b35ad098 h_b36ad098}
      END.
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok z02ad098
ON CHOOSE OF bt-ok IN FRAME f-zoom /* OK */
DO:
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre z02ad098
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK z02ad098 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}


/* Altera o label do terceiro folder (CGC) */

find first param-global no-lock no-error.

if  avail param-global then do:
    RUN delete-folder-page IN h_folder (INPUT 3 ).
    
    RUN create-folder-page IN h_folder (INPUT 3, INPUT param-global.label-cgc).
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects z02ad098 _ADM-CREATE-OBJECTS
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
             INPUT  FRAME f-zoom:HANDLE ,
             INPUT  'FOLDER-LABELS = ':U + 'C¢digo|Nome|CGC|Grupo' + ',
                     FOLDER-TAB-TYPE = 1':U ,
             OUTPUT h_folder ).
       RUN set-position IN h_folder ( 1.00 , 1.00 ) NO-ERROR.
       RUN set-size IN h_folder ( 13.25 , 85.00 ) NO-ERROR.

       /* Links to SmartFolder h_folder. */
       RUN add-link IN adm-broker-hdl ( h_folder , 'Page':U , THIS-PROCEDURE ).

    END. /* Page 0 */

    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adbrw/b36ad098.w':U ,
             INPUT  FRAME f-zoom:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b36ad098 ).
       RUN set-position IN h_b36ad098 ( 2.75 , 5.00 ) NO-ERROR.
       /* Size in UIB:  ( 10.50 , 78.00 ) */

       /* Links to SmartBrowser h_b36ad098. */
       RUN add-link IN adm-broker-hdl ( h_b36ad098 , 'State':U , THIS-PROCEDURE ).

    END. /* Page 1 */

    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adbrw/b35ad098.w':U ,
             INPUT  FRAME f-zoom:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b35ad098 ).
       RUN set-position IN h_b35ad098 ( 2.71 , 4.86 ) NO-ERROR.
       /* Size in UIB:  ( 10.67 , 78.00 ) */

       /* Links to SmartBrowser h_b35ad098. */
       RUN add-link IN adm-broker-hdl ( h_b35ad098 , 'State':U , THIS-PROCEDURE ).

    END. /* Page 2 */

    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adbrw/b34ad098.w':U ,
             INPUT  FRAME f-zoom:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b34ad098 ).
       RUN set-position IN h_b34ad098 ( 2.75 , 6.00 ) NO-ERROR.
       /* Size in UIB:  ( 10.54 , 76.00 ) */

       /* Links to SmartBrowser h_b34ad098. */
       RUN add-link IN adm-broker-hdl ( h_b34ad098 , 'State':U , THIS-PROCEDURE ).

    END. /* Page 3 */

    WHEN 4 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adbrw/b24ad098.w':U ,
             INPUT  FRAME f-zoom:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b24ad098 ).
       RUN set-position IN h_b24ad098 ( 2.75 , 4.00 ) NO-ERROR.
       /* Size in UIB:  ( 10.67 , 77.72 ) */

       /* Links to SmartBrowser h_b24ad098. */
       RUN add-link IN adm-broker-hdl ( h_b24ad098 , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
    END. /* Page 4 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available z02ad098 _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI z02ad098 _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(z02ad098)
  THEN DELETE WIDGET z02ad098.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI z02ad098 _DEFAULT-ENABLE
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
  ENABLE rt-button bt-filtro bt-ajuda bt-ok bt-cancela 
      /*  bt-parametros*/
         WITH FRAME f-zoom IN WINDOW z02ad098.
  {&OPEN-BROWSERS-IN-QUERY-f-zoom}
  VIEW z02ad098.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy z02ad098 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit z02ad098 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize z02ad098 
PROCEDURE local-initialize :
{utp/ut9000.i "Z07AD098" "2.00.00.020"}

/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  {include/win-size.i}
    
  if i-filtro <> 1 and i-filtro <> 2 then do:
     assign i-filtro    = 1
            i-identific = 1.
  end.
  else do:
     assign i-identific = i-filtro.
  end.          
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  assign bt-implantar:sensitive in frame {&frame-name} = l-implanta
         l-implanta = no.
  
/* /* Alfa 2.06 */                                                    */
/* &IF "{&bf_mat_versao_ems}":U >= "2.05":U &THEN                     */
/*     FIND FIRST param-global NO-LOCK NO-ERROR.                      */
/*     IF  param-global.modulo-re = FALSE AND                         */
/*         param-global.modulo-cc = FALSE AND                         */
/*         param-global.modulo-cn = FALSE THEN DO:                    */
/*         ASSIGN bt-parametros:HIDDEN IN FRAME {&FRAME-NAME} = TRUE. */
/*     END.                                                           */
/* &ENDIF                                                             */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* /* Alfa 2.06 */                                                                   */
/* &IF "{&bf_mat_versao_ems}":U >= "2.05":U &THEN                                    */
/*                                                                                   */
/* &ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-filtro w-pesquisa                  */
/* PROCEDURE pi-filtro :                                                             */
/* /*------------------------------------------------------------------------------  */
/*   Purpose:                                                                        */
/*   Parameters:  <none>                                                             */
/*   Notes:                                                                          */
/* ------------------------------------------------------------------------------*/  */
/*     define output parameter p-l-fornecedor as logical no-undo.                    */
/*     define output parameter p-l-cliente    as logical no-undo.                    */
/*     define output parameter p-l-ambos      as logical no-undo.                    */
/*                                                                                   */
/*     define output parameter p-l-ativos-filtro                 as logical no-undo. */
/*     define output parameter p-l-restricao-compras-filtro      as logical no-undo. */
/*     define output parameter p-l-restricao-compras-rec-filtro  as logical no-undo. */
/*     define output parameter p-l-inativos-filtro               as logical no-undo. */
/*     define output parameter p-c-data-emit-restricao-filtro    as CHAR no-undo.    */
/*                                                                                   */
/*     assign p-l-fornecedor = l-fornecedor-filtro                                   */
/*            p-l-cliente    = l-cliente-filtro                                      */
/*            p-l-ambos      = l-ambos-filtro.                                       */
/*                                                                                   */
/*     ASSIGN p-l-ativos-filtro                = l-ativos-filtro                     */
/*            p-l-restricao-compras-filtro     = l-restricao-compras-filtro          */
/*            p-l-restricao-compras-rec-filtro = l-restricao-compras-rec-filtro      */
/*            p-l-inativos-filtro              = l-inativos-filtro                   */
/*            p-c-data-emit-restricao-filtro   = c-data-emit-restricao-filtro.       */
/* END PROCEDURE.                                                                    */
/*                                                                                   */
/* /* _UIB-CODE-BLOCK-END */                                                         */
/* &ANALYZE-RESUME                                                                   */
/*                                                                                   */
/* &ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-identific w-pesquisa         */
/* PROCEDURE pi-passa-identific :                                                    */
/* /*------------------------------------------------------------------------------  */
/*   Purpose: Passar parametros do filtro para os browses e atualizar as queries     */
/*   Parameters:  <none>                                                             */
/*   Notes:                                                                          */
/* ------------------------------------------------------------------------------*/  */
/*                                                                                   */
/*     if  valid-handle (h_b36ad098) then                                            */
/*             run pi-filtro in h_b36ad098 (input l-fornecedor-filtro,               */
/*                                          input l-cliente-filtro,                  */
/*                                          input l-ambos-filtro,                    */
/*                                          input l-ativos-filtro,                   */
/*                                          input l-restricao-compras-filtro,        */
/*                                          input l-restricao-compras-rec-filtro,    */
/*                                          input l-inativos-filtro,                 */
/*                                          input c-data-emit-restricao-filtro).     */
/*                                                                                   */
/*     if  valid-handle (h_b35ad098) then                                            */
/*             run pi-filtro in h_b35ad098 (input l-fornecedor-filtro,               */
/*                                          input l-cliente-filtro,                  */
/*                                          input l-ambos-filtro,                    */
/*                                          input l-ativos-filtro,                   */
/*                                          input l-restricao-compras-filtro,        */
/*                                          input l-restricao-compras-rec-filtro,    */
/*                                          input l-inativos-filtro,                 */
/*                                          input c-data-emit-restricao-filtro).     */
/*                                                                                   */
/*     if  valid-handle (h_b34ad098) then                                            */
/*             run pi-filtro in h_b34ad098 (input l-fornecedor-filtro,               */
/*                                          input l-cliente-filtro,                  */
/*                                          input l-ambos-filtro,                    */
/*                                          input l-ativos-filtro,                   */
/*                                          input l-restricao-compras-filtro,        */
/*                                          input l-restricao-compras-rec-filtro,    */
/*                                          input l-inativos-filtro,                 */
/*                                          input c-data-emit-restricao-filtro).     */
/*                                                                                   */
/*     if  valid-handle (h_b24ad098) then                                            */
/*             run pi-filtro in h_b24ad098 (input l-fornecedor-filtro,               */
/*                                          input l-cliente-filtro,                  */
/*                                          input l-ambos-filtro,                    */
/*                                          input l-ativos-filtro,                   */
/*                                          input l-restricao-compras-filtro,        */
/*                                          input l-restricao-compras-rec-filtro,    */
/*                                          input l-inativos-filtro,                 */
/*                                          input c-data-emit-restricao-filtro).     */
/*                                                                                   */
/*                                                                                   */
/*     run notify in this-procedure ('open-query,container-target':U).               */
/*                                                                                   */
/* END PROCEDURE.                                                                    */
/*                                                                                   */
/* /* _UIB-CODE-BLOCK-END */                                                         */
/* &ANALYZE-RESUME                                                                   */
/*                                                                                   */
/* &ENDIF                                                                            */


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RTB_xref_generator z02ad098 
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
  RUN adbrw/b34ad098.w.
  RUN adbrw/b24ad098.w.
  RUN adbrw/b35ad098.w.
  RUN adbrw/b36ad098.w.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records z02ad098 _ADM-SEND-RECORDS
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed z02ad098 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
  case entry(1, p-state, "|"):
      when 'New-Line':U then do:
          if  num-entries(p-state, "|":U) > 1 then
              assign v-row-table = to-rowid(entry(2, p-state, "|":U)).
          else
              assign v-row-table = ?.
      end.
  end.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


