&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME z01ad098
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS z01ad098 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i Z01AD098 2.00.00.040 } /*** "010040" 10/09/2026 14:47:50 ***/

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


/* Local Variable Definitions ---                                       */

/******************************ATENCAO*************************************
 Pre-processador abaixo responsavel por distinguir o produto que
 esta executando o componente ( Magnus ou EMS ). 
 Se estiver definida a variavel bf-mat-comex 
 ( &if defined(bf-mat-comex) &then ), significa que o produto
 chamador e o Magnus se n∆o, EMS. Utilizado pelo produto Comercio Exterior
**************************************************************************/ 
{cdp/cdcfgmat.i} /* Definicao de pre-processadores - Magnus ou EMS */

define variable v-row-table            as rowid               no-undo.
define variable l-fornecedor-filtro    as logical initial yes no-undo.
define variable l-cliente-filtro       as logical             no-undo.
define variable l-ambos-filtro         as logical initial yes no-undo.
define variable l-ok                   as logical             no-undo.

def new global shared var i-identific     as integer         no-undo.
def new global shared var l-mostra-fornec as logical init no no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-zoom

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button bt-implantar bt-filtro bt-ok ~
bt-cancela bt-ajuda 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR z01ad098 AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-bt-ajuda 
       MENU-ITEM mi-sobre       LABEL "Sobre..."      .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b09ad098 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b30ad098 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b31ad098 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b32ad098 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b33ad098 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b37ad098 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b52ad098 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON bt-filtro 
     LABEL "&Filtro" 
     SIZE 16.57 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON bt-implantar 
     LABEL "&Implantar" 
     SIZE 16.57 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1.08
     BGCOLOR 8 .

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 88.57 BY 1.67
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-zoom
     bt-implantar AT ROW 15.08 COL 1.43
     bt-filtro AT ROW 15.08 COL 18
     bt-ok AT ROW 16.5 COL 3
     bt-cancela AT ROW 16.5 COL 14
     bt-ajuda AT ROW 16.5 COL 79
     rt-button AT ROW 16.17 COL 1.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         DEFAULT-BUTTON bt-ok.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 7
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW z01ad098 ASSIGN
         HIDDEN             = YES
         TITLE              = "Pesquisa Emitente"
         HEIGHT             = 16.88
         WIDTH              = 90
         MAX-HEIGHT         = 23.17
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 23.17
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB z01ad098 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-pesqui.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW z01ad098
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-zoom
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       bt-ajuda:POPUP-MENU IN FRAME f-zoom       = MENU POPUP-MENU-bt-ajuda:HANDLE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(z01ad098)
THEN z01ad098:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME z01ad098
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL z01ad098 z01ad098
ON END-ERROR OF z01ad098 /* Pesquisa Emitente */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL z01ad098 z01ad098
ON WINDOW-CLOSE OF z01ad098 /* Pesquisa Emitente */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
   assign l-mostra-fornec = no.

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-zoom
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-zoom z01ad098
ON GO OF FRAME f-zoom
DO:
  run pi-go.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda z01ad098
ON CHOOSE OF bt-ajuda IN FRAME f-zoom /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela z01ad098
ON CHOOSE OF bt-cancela IN FRAME f-zoom /* Cancelar */
DO:
    RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-filtro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-filtro z01ad098
ON CHOOSE OF bt-filtro IN FRAME f-zoom /* Filtro */
DO:

    run cdp/cd9099.w (input-output l-fornecedor-filtro,
                      input-output l-cliente-filtro,  
                      input-output l-ambos-filtro,    
                      output       l-ok).
    if  l-ok then 
        run pi-passa-identific in this-procedure.
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-implantar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-implantar z01ad098
ON CHOOSE OF bt-implantar IN FRAME f-zoom /* Implantar */
DO:
  {include/i-implan.i cdp/cd0401.w h_b30ad098 h_b31ad098 h_b32ad098 h_b33ad098 h_b09ad098}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre z01ad098
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK z01ad098 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* Altera o label do terceiro folder (CGC) */

&if defined(bf-mat-comex) &then            
&else
    find first param-global no-lock no-error.

    if  avail param-global then do:
        RUN delete-folder-page IN h_folder (INPUT 3 ).

        RUN create-folder-page IN h_folder (INPUT 3, INPUT param-global.label-cgc).
    end.
&endif

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects z01ad098  _ADM-CREATE-OBJECTS
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
             INPUT  'FOLDER-LABELS = ':U + 'C¢digo|Nome Abrev|CGC|Grupo|Matriz|Nome|Inicia com' + ',
                     FOLDER-TAB-TYPE = 2':U ,
             OUTPUT h_folder ).
       RUN set-position IN h_folder ( 1.00 , 1.00 ) NO-ERROR.
       RUN set-size IN h_folder ( 13.67 , 88.00 ) NO-ERROR.

       /* Links to SmartFolder h_folder. */
       RUN add-link IN adm-broker-hdl ( h_folder , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_folder ,
             bt-implantar:HANDLE IN FRAME f-zoom , 'BEFORE':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adbrw/b30ad098.w':U ,
             INPUT  FRAME f-zoom:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b30ad098 ).
       RUN set-position IN h_b30ad098 ( 3.25 , 7.00 ) NO-ERROR.
       /* Size in UIB:  ( 10.50 , 78.14 ) */

       /* Links to SmartBrowser h_b30ad098. */
       RUN add-link IN adm-broker-hdl ( h_b30ad098 , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b30ad098 ,
             h_folder , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adbrw/b31ad098.w':U ,
             INPUT  FRAME f-zoom:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b31ad098 ).
       RUN set-position IN h_b31ad098 ( 3.50 , 7.00 ) NO-ERROR.
       /* Size in UIB:  ( 10.25 , 78.14 ) */

       /* Links to SmartBrowser h_b31ad098. */
       RUN add-link IN adm-broker-hdl ( h_b31ad098 , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b31ad098 ,
             h_folder , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adbrw/b32ad098.w':U ,
             INPUT  FRAME f-zoom:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b32ad098 ).
       RUN set-position IN h_b32ad098 ( 3.25 , 9.00 ) NO-ERROR.
       /* Size in UIB:  ( 10.38 , 76.14 ) */

       /* Links to SmartBrowser h_b32ad098. */
       RUN add-link IN adm-broker-hdl ( h_b32ad098 , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b32ad098 ,
             h_folder , 'AFTER':U ).
    END. /* Page 3 */
    WHEN 4 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adbrw/b33ad098.w':U ,
             INPUT  FRAME f-zoom:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b33ad098 ).
       RUN set-position IN h_b33ad098 ( 3.00 , 6.00 ) NO-ERROR.
       /* Size in UIB:  ( 10.67 , 77.72 ) */

       /* Links to SmartBrowser h_b33ad098. */
       RUN add-link IN adm-broker-hdl ( h_b33ad098 , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b33ad098 ,
             h_folder , 'AFTER':U ).
    END. /* Page 4 */
    WHEN 5 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adbrw/b09ad098.w':U ,
             INPUT  FRAME f-zoom:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b09ad098 ).
       RUN set-position IN h_b09ad098 ( 3.50 , 7.00 ) NO-ERROR.
       /* Size in UIB:  ( 10.17 , 79.14 ) */

       /* Links to SmartBrowser h_b09ad098. */
       RUN add-link IN adm-broker-hdl ( h_b09ad098 , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b09ad098 ,
             h_folder , 'AFTER':U ).
    END. /* Page 5 */
    WHEN 6 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adbrw/b37ad098.W':U ,
             INPUT  FRAME f-zoom:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b37ad098 ).
       RUN set-position IN h_b37ad098 ( 3.50 , 6.00 ) NO-ERROR.
       /* Size in UIB:  ( 10.25 , 78.14 ) */

       /* Links to SmartBrowser h_b37ad098. */
       RUN add-link IN adm-broker-hdl ( h_b37ad098 , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b37ad098 ,
             h_folder , 'AFTER':U ).
    END. /* Page 6 */
    WHEN 7 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adbrw/b52ad098.w':U ,
             INPUT  FRAME f-zoom:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b52ad098 ).
       RUN set-position IN h_b52ad098 ( 3.21 , 5.57 ) NO-ERROR.
       /* Size in UIB:  ( 10.25 , 78.14 ) */

       /* Links to SmartBrowser h_b52ad098. */
       RUN add-link IN adm-broker-hdl ( h_b52ad098 , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b52ad098 ,
             h_folder , 'AFTER':U ).
    END. /* Page 7 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available z01ad098  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI z01ad098  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(z01ad098)
  THEN DELETE WIDGET z01ad098.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI z01ad098  _DEFAULT-ENABLE
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
  ENABLE rt-button bt-implantar bt-filtro bt-ok bt-cancela bt-ajuda 
      WITH FRAME f-zoom IN WINDOW z01ad098.
  {&OPEN-BROWSERS-IN-QUERY-f-zoom}
  VIEW z01ad098.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy z01ad098 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit z01ad098 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/

   assign l-mostra-fornec = no.

   APPLY "CLOSE":U TO THIS-PROCEDURE.

   RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize z01ad098 
PROCEDURE local-initialize :
{utp/ut9000.i "Z01AD098" "2.00.00.040"} /* 10/09/2026 14:47:50 */

/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  {include/win-size.i}

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
 
  assign bt-implantar:sensitive in frame {&frame-name} = l-implanta
         l-implanta = no.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-filtro z01ad098 
PROCEDURE pi-filtro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define output parameter p-l-fornecedor as logical no-undo.
    define output parameter p-l-cliente    as logical no-undo.
    define output parameter p-l-ambos      as logical no-undo.

    assign p-l-fornecedor = l-fornecedor-filtro  
           p-l-cliente    = l-cliente-filtro     
           p-l-ambos      = l-ambos-filtro.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-identific z01ad098 
PROCEDURE pi-passa-identific :
/*------------------------------------------------------------------------------
  Purpose: Passar parametros do filtro para os browses e atualizar as queries    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if  valid-handle (h_b30ad098) then
        run pi-filtro in h_b30ad098 (input l-fornecedor-filtro,
                                     input l-cliente-filtro,
                                     input l-ambos-filtro).
     
    if  valid-handle (h_b31ad098) then
        run pi-filtro in h_b31ad098 (input l-fornecedor-filtro,
                                     input l-cliente-filtro,
                                     input l-ambos-filtro).

    if  valid-handle (h_b32ad098) then
        run pi-filtro in h_b32ad098 (input l-fornecedor-filtro,
                                     input l-cliente-filtro,
                                     input l-ambos-filtro).

    if  valid-handle (h_b33ad098) then
        run pi-filtro in h_b33ad098 (input l-fornecedor-filtro,
                                     input l-cliente-filtro,
                                     input l-ambos-filtro).
                                    
    if  valid-handle (h_b09ad098) then
        run pi-filtro in h_b09ad098 (input l-fornecedor-filtro,
                                     input l-cliente-filtro,
                                     input l-ambos-filtro).

    if  valid-handle (h_b37ad098) then
        run pi-filtro in h_b37ad098 (input l-fornecedor-filtro,
                                     input l-cliente-filtro,
                                     input l-ambos-filtro).
                                   
    if  valid-handle (h_b52ad098) then
        run pi-filtro in h_b52ad098 (input l-fornecedor-filtro,
                                     input l-cliente-filtro,
                                     input l-ambos-filtro).

    run notify in this-procedure ('open-query,container-target':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-valor z01ad098 
PROCEDURE pi-retorna-valor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER P-CAMPO AS CHARACTER NO-UNDO.

    DEFINE VARIABLE P-VALOR AS CHAR INIT "" NO-UNDO.

    if  avail mgadm.emitente then do:
        case p-campo:
            WHEN "nome-emit" THEN 
                ASSIGN p-valor = STRING(emitente.nome-emit).
            when "cod-emitente" then
                assign p-valor = string(emitente.cod-emitente).
            when "nome-abrev" then
                assign p-valor = string(emitente.nome-abrev).
            when "cod-gr-forn" then
                assign p-valor = string(emitente.cod-gr-forn).
            when "nome-matriz" then
                assign p-valor = string(emitente.nome-matriz).
            when "cgc" then
                assign p-valor = string(emitente.cgc).
        end.
    end.
    return p-valor.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-inicial z01ad098 
PROCEDURE pi-seta-inicial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pl-fornec-seta-ini AS LOGICAL NO-UNDO.
DEFINE INPUT PARAMETER pl-cli-seta-ini    AS LOGICAL NO-UNDO.
DEFINE INPUT PARAMETER pl-ambos-seta-ini  AS LOGICAL NO-UNDO.

ASSIGN l-fornecedor-filtro = pl-fornec-seta-ini
       l-cliente-filtro    = pl-cli-seta-ini
       l-ambos-filtro      = pl-ambos-seta-ini.
       
RUN pi-passa-identific.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RTB_xref_generator z01ad098 
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
  RUN adbrw/b31ad098.w.
  RUN adm/objects/folder.w.
  RUN adbrw/b32ad098.w.
  RUN adbrw/b30ad098.w.
  RUN adbrw/b33ad098.w.
  RUN adbrw/b09ad098.w.
  RUN adbrw/b37ad098.w.
  RUN adbrw/b52ad098.w.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records z01ad098  _ADM-SEND-RECORDS
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed z01ad098 
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

