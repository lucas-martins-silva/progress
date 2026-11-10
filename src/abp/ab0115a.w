&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-mab-usuar-frota NO-UNDO LIKE mab-usuar-frota
       field r-rowid as rowid.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0115A 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0115a MAB}
&ENDIF


/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           AB0115A
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE Folder            NO

&GLOBAL-DEFINE ttTable           tt-mab-usuar-frota
&GLOBAL-DEFINE hDBOTable         hDBOmab-usuar-frota
&GLOBAL-DEFINE DBOTable          mab-usuar-frota

&GLOBAL-DEFINE page0KeyFields    tt-mab-usuar-frota.cod-usuar
&GLOBAL-DEFINE page0Fields       tt-mab-usuar-frota.idi-tip-usuar ~
                                 tt-mab-usuar-frota.des-email

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.

/* Local Variable Definitions ---                                       */
DEF VAR c-usuario-origem  LIKE tt-mab-usuar-frota.cod-usuar NO-UNDO.
DEF VAR c-usuario-destino LIKE tt-mab-usuar-frota.cod-usuar NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.

/** Zoom Smart **/
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-mab-usuar-frota.cod-usuar ~
tt-mab-usuar-frota.idi-tip-usuar tt-mab-usuar-frota.des-email 
&Scoped-define ENABLED-TABLES tt-mab-usuar-frota
&Scoped-define FIRST-ENABLED-TABLE tt-mab-usuar-frota
&Scoped-Define ENABLED-OBJECTS btOK btSave btCancel btHelp RECT-30 RECT-31 ~
rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS tt-mab-usuar-frota.cod-usuar ~
tt-mab-usuar-frota.idi-tip-usuar tt-mab-usuar-frota.des-email 
&Scoped-define DISPLAYED-TABLES tt-mab-usuar-frota
&Scoped-define FIRST-DISPLAYED-TABLE tt-mab-usuar-frota
&Scoped-Define DISPLAYED-OBJECTS fi-nom-usuar fi-nivel-aprovacao 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "&Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-nivel-aprovacao AS CHARACTER FORMAT "X(256)":U INITIAL "N¡vel Aprova‡Æo" 
      VIEW-AS TEXT 
     SIZE 13 BY .67 NO-UNDO.

DEFINE VARIABLE fi-nom-usuar AS CHARACTER FORMAT "X(32)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 48.57 BY 1.58.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 3.75.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 1.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-mab-usuar-frota.cod-usuar AT ROW 1.33 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     fi-nom-usuar AT ROW 1.33 COL 33.43 COLON-ALIGNED NO-LABEL
     tt-mab-usuar-frota.idi-tip-usuar AT ROW 3.42 COL 30 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "N¡vel 1", 1,
"N¡vel 2", 2
          SIZE 41 BY .71
     tt-mab-usuar-frota.des-email AT ROW 4.88 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 48.57 BY .88
     btOK AT ROW 6.67 COL 2
     btSave AT ROW 6.67 COL 13
     btCancel AT ROW 6.67 COL 24
     btHelp AT ROW 6.67 COL 80
     fi-nivel-aprovacao AT ROW 2.67 COL 24 COLON-ALIGNED NO-LABEL
     RECT-30 AT ROW 2.92 COL 23
     RECT-31 AT ROW 2.5 COL 1
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 6.42 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 7.13
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-mab-usuar-frota T "?" NO-UNDO mgfro mab-usuar-frota
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenanceNoNavigation ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 7.08
         WIDTH              = 90
         MAX-HEIGHT         = 17.42
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17.42
         VIRTUAL-WIDTH      = 90
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenanceNoNavigation 
/* ************************* Included-Libraries *********************** */

{maintenancenonavigation/maintenancenonavigation.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenanceNoNavigation
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN fi-nivel-aprovacao IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nom-usuar IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenanceNoNavigation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON END-ERROR OF wMaintenanceNoNavigation
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenanceNoNavigation
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenanceNoNavigation
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wMaintenanceNoNavigation
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
       if pcAction = "COPY":U then do:
           assign c-usuario-destino = input frame fPage0 tt-mab-usuar-frota.cod-usuar.
       end.

       RUN saveRecord IN THIS-PROCEDURE.

/*        IF RETURN-VALUE = "OK":U THEN do:                                                             */
/*            /** Faz a c¢pia das tabelas filhas para o plano criado **/                                */
/*            if pcAction = "COPY":U then do:                                                           */
/*                run copiaFilhos in {&hDBOTable} (input  c-usuario-destino,                            */
/*                                                 input  c-usuario-origem,                             */
/*                                                 INPUT-OUTPUT TABLE RowErrors).                       */
/*                /** Mostra Erros **/                                                                  */
/*                if return-value = "NOK":U THEN DO:                                                    */
/*                     /*--- Inicializa tela de mensagens de erros ---*/                                */
/*                     {method/showmessage.i1}                                                          */
/*                     /*--- Seta cursor do mouse para normal ---*/                                     */
/*                     SESSION:SET-WAIT-STATE("":U).                                                    */
/*                         /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/ */
/*                     {method/showmessage.i2}                                                          */
/*                     WAIT-FOR CLOSE OF hShowMsg.                                                      */
/*                     /*--- Destr½i tela de mensagens de erros ---*/                                   */
/*                     {method/showmessage.i3}                                                          */
/*                END.                                                                                  */
/*                                                                                                      */
/*            END.                                                                                      */
                   
           /** Fecha Programa **/
           APPLY "CLOSE":U TO THIS-PROCEDURE.
/*        end.                */
/*        ELSE                */
/*            RETURN "NOK":U. */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-mab-usuar-frota.cod-usuar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mab-usuar-frota.cod-usuar wMaintenanceNoNavigation
ON F5 OF tt-mab-usuar-frota.cod-usuar IN FRAME fpage0 /* Usu rio */
DO:
    {include/zoomvar.i &prog-zoom="unzoom/z01un178.w"
                   &campo=tt-mab-usuar-frota.cod-usuar
                   &campozoom=cod_usuario
                   &campo2=fi-nom-usuar
                   &campozoom2=nom_usuario
                   &campo3=tt-mab-usuar-frota.des-email
                   &campozoom3=cod_e_mail_local}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mab-usuar-frota.cod-usuar wMaintenanceNoNavigation
ON LEAVE OF tt-mab-usuar-frota.cod-usuar IN FRAME fpage0 /* Usu rio */
DO:
    {include/leave.i 
               &tabela=usuar_mestre
               &atributo-ref=nom_usuario
               &variavel-ref=fi-nom-usuar
               &where="usuar_mestre.cod_usuario = input frame fPage0 tt-mab-usuar-frota.cod-usuar"}
               
    IF pcAction = "ADD":U OR pcAction = "COPY":U THEN DO:
        /*Se a‡Æo for ADD, traz email do usu rio da tabela usuar_mestre. Caso contr rio, traz o email cadastrado.*/
        {include/leave.i 
                   &tabela=usuar_mestre
                   &atributo-ref=cod_e_mail_local
                   &variavel-ref=tt-mab-usuar-frota.des-email
                   &where="usuar_mestre.cod_usuario = input frame fPage0 tt-mab-usuar-frota.cod-usuar"}
    END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-mab-usuar-frota.cod-usuar wMaintenanceNoNavigation
ON LEFT-MOUSE-DBLCLICK OF tt-mab-usuar-frota.cod-usuar IN FRAME fpage0 /* Usu rio */
DO:
    APPLY "f5":U TO tt-mab-usuar-frota.cod-usuar IN FRAME fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

tt-mab-usuar-frota.cod-usuar:LOAD-MOUSE-POINTER("image/lupa.cur":U)  in frame fPage0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DISP tt-mab-usuar-frota.cod-usuar WITH FRAME fPage0.
   APPLY "leave":U TO tt-mab-usuar-frota.cod-usuar IN FRAME fPage0.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*    IF pcAction = "copy":U THEN DO:                                                         */
/*        ASSIGN c-usuario-origem = tt-mab-usuar-frota.cod-usuar:SCREEN-VALUE IN FRAME fPage0 */
/*               btSave:SENSITIVE IN FRAME fPage0 = NO.                                       */
/*    END.                                                                                    */

RUN setaAcaoOrigem IN {&hDBOTable} (INPUT pcAction,
                                    INPUT tt-mab-usuar-frota.cod-usuar:SCREEN-VALUE IN FRAME fPage0).

if pcAction = "UPDATE":U  THEN
  ASSIGN tt-mab-usuar-frota.cod-usuar:SENSITIVE IN FRAME fPage0 = NO.

{utp/ut-liter.i N¡vel_Aprova‡Æo *}
ASSIGN fi-nivel-aprovacao:SCREEN-VALUE IN FRAME fPage0 = RETURN-VALUE.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "frbo/bofr114.p":U THEN DO:
        {btb/btb008za.i1 frbo/bofr114.p YES}
        {btb/btb008za.i2 frbo/bofr114.p '' {&hDBOTable}} 
    END.
    
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

