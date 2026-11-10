&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-decla-import NO-UNDO LIKE decla-import
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE tt-histor-decla-import NO-UNDO LIKE histor-decla-import
       FIELD r-Rowid AS ROWID.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0400B 2.00.00.021 } /*** "010021" 07/11/2025 11:15:50 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0400B MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           IM0400B
&GLOBAL-DEFINE Version        2.00.00.021

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-histor-decla-import
&GLOBAL-DEFINE hDBOTable         h-bocx384
&GLOBAL-DEFINE DBOTable          histor-di

&GLOBAL-DEFINE ttParent          tt-decla-import
&GLOBAL-DEFINE DBOParentTable    decla-import

&GLOBAL-DEFINE page0KeyFields    tt-histor-decla-import.num-seq
&GLOBAL-DEFINE page0Fields       tt-histor-decla-import.cdn-pto-control tt-histor-decla-import.num-seq tt-histor-decla-import.cod-meio-transp tt-histor-decla-import.dat-efetiva tt-histor-decla-import.dat-prev-origin tt-histor-decla-import.dsl-obs tt-histor-decla-import.nr-dias c-cod-uf
&GLOBAL-DEFINE page0ParentFields tt-decla-import.num-di-ems tt-decla-import.cod-di-siscomex tt-decla-import.cod-estab tt-decla-import.dat-di tt-decla-import.num-seq-retif 
&GLOBAL-DEFINE page1Fields       
 
/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE l-habilita-pto AS LOGICAL     NO-UNDO.
DEFINE VARIABLE cReturn        AS CHARACTER   NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx110      AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx110na    AS HANDLE      NO-UNDO.

DEFINE VARIABLE c-lbl-pto-contr    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lbl-cadastra-pto AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-pto-ant          AS INTEGER     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-decla-import.num-di-ems ~
tt-decla-import.cod-di-siscomex tt-decla-import.num-seq-retif ~
tt-decla-import.cod-estab tt-decla-import.dat-di ~
tt-histor-decla-import.num-seq tt-histor-decla-import.cdn-pto-control ~
tt-histor-decla-import.descricao tt-histor-decla-import.dat-prev-origin ~
tt-histor-decla-import.dat-efetiva tt-histor-decla-import.cod-meio-transp ~
tt-histor-decla-import.nr-dias tt-histor-decla-import.dsl-obs 
&Scoped-define ENABLED-TABLES tt-decla-import tt-histor-decla-import
&Scoped-define FIRST-ENABLED-TABLE tt-decla-import
&Scoped-define SECOND-ENABLED-TABLE tt-histor-decla-import
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar rtKeys-2 c-cod-uf btOK ~
btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-decla-import.num-di-ems ~
tt-decla-import.cod-di-siscomex tt-decla-import.num-seq-retif ~
tt-decla-import.cod-estab tt-decla-import.dat-di ~
tt-histor-decla-import.num-seq tt-histor-decla-import.cdn-pto-control ~
tt-histor-decla-import.descricao tt-histor-decla-import.dat-prev-origin ~
tt-histor-decla-import.dat-efetiva tt-histor-decla-import.cod-meio-transp ~
tt-histor-decla-import.nr-dias tt-histor-decla-import.dsl-obs 
&Scoped-define DISPLAYED-TABLES tt-decla-import tt-histor-decla-import
&Scoped-define FIRST-DISPLAYED-TABLE tt-decla-import
&Scoped-define SECOND-DISPLAYED-TABLE tt-histor-decla-import
&Scoped-Define DISPLAYED-OBJECTS c-cod-uf 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-cod-uf AS CHARACTER FORMAT "X(02)":U 
     LABEL "UF" 
     VIEW-AS FILL-IN 
     SIZE 4.14 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 12.17.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-decla-import.num-di-ems AT ROW 1.5 COL 23 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 7.57 BY .88
     tt-decla-import.cod-di-siscomex AT ROW 1.5 COL 43 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 10.43 BY .88
     tt-decla-import.num-seq-retif AT ROW 1.5 COL 53.72 COLON-ALIGNED NO-LABEL WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     tt-decla-import.cod-estab AT ROW 2.5 COL 23 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-decla-import.dat-di AT ROW 2.5 COL 43 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-histor-decla-import.num-seq AT ROW 4.5 COL 23 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-histor-decla-import.cdn-pto-control AT ROW 5.5 COL 23 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-histor-decla-import.descricao AT ROW 5.5 COL 33.14 COLON-ALIGNED NO-LABEL WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 23.57 BY .88
     c-cod-uf AT ROW 5.5 COL 61 COLON-ALIGNED WIDGET-ID 34
     tt-histor-decla-import.dat-prev-origin AT ROW 6.5 COL 23 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-histor-decla-import.dat-efetiva AT ROW 7.5 COL 23 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-histor-decla-import.cod-meio-transp AT ROW 8.46 COL 23 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 30 BY .88
     tt-histor-decla-import.nr-dias AT ROW 9.42 COL 23 COLON-ALIGNED WIDGET-ID 32
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-histor-decla-import.dsl-obs AT ROW 10.42 COL 25 NO-LABEL WIDGET-ID 24
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 60 BY 4.67
     btOK AT ROW 16.63 COL 2
     btSave AT ROW 16.63 COL 13
     btCancel AT ROW 16.63 COL 24
     btHelp AT ROW 16.63 COL 80
     "Obs.:" VIEW-AS TEXT
          SIZE 4 BY .54 AT ROW 11.29 COL 21 WIDGET-ID 26
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 16.38 COL 1
     rtKeys-2 AT ROW 4.21 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-decla-import T "?" NO-UNDO mgcex decla-import
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-histor-decla-import T "?" NO-UNDO mgcex histor-decla-import
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
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
         HEIGHT             = 17
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
    RUN pi-valida-efetivacao.
    IF RETURN-VALUE = "OK" THEN DO:
        
        IF pcAction = "ADD":U THEN DO:

                RUN emptyRowErrors IN h-bocx384.

                RUN criaHistoricoEmbarques IN h-bocx384 (input input frame fpage0 tt-decla-import.num-di-ems,
                                                         input input frame fpage0 tt-histor-decla-import.num-seq,
                                                         input input frame fpage0 tt-histor-decla-import.cdn-pto-control,
                                                         INPUT tt-decla-import.cdd-siscomex-dts,
                                                         input input frame fpage0 tt-histor-decla-import.descricao,
                                                         input input frame fpage0 tt-histor-decla-import.nr-dias,
                                                         input input frame fpage0 tt-histor-decla-import.dat-prev-origin, 
                                                         input input frame fpage0 tt-histor-decla-import.dat-efetiva,
                                                         input input frame fpage0 tt-histor-decla-import.cod-meio-transp,
                                                         input input frame fpage0 tt-histor-decla-import.dsl-obs,
                                                         INPUT "").
                    
                if return-value = "ok":U then do:
                    run saverecord in this-procedure.
                    if return-value = "OK":U then 
                        apply "close":U to this-procedure.
                end.
                else do:
                    run getRowErrors in h-bocx384(output table RowErrors).
                    if can-find(first RowErrors)  then do:
                        {method/showmessage.i1}
                        {method/showmessage.i2}
                        undo, return no-apply.
                    end.
                end.
        END.
        ELSE DO:
            RUN saveRecord IN THIS-PROCEDURE.
            IF RETURN-VALUE = "OK":U THEN
                APPLY "CLOSE":U TO THIS-PROCEDURE.
        END.
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    RUN pi-valida-efetivacao.
    IF RETURN-VALUE = "OK" THEN DO:
        IF pcAction = "ADD":U THEN DO:

            RUN emptyRowErrors IN h-bocx384.

            RUN criaHistoricoEmbarques IN h-bocx384 (input input frame fpage0 tt-decla-import.num-di-ems,
                                                     input input frame fpage0 tt-histor-decla-import.num-seq,
                                                     input input frame fpage0 tt-histor-decla-import.cdn-pto-control,
                                                     input tt-decla-import.cdd-siscomex-dts,
                                                     input input frame fpage0 tt-histor-decla-import.descricao,
                                                     input input frame fpage0 tt-histor-decla-import.nr-dias,
                                                     input input frame fpage0 tt-histor-decla-import.dat-prev-origin, 
                                                     input input frame fpage0 tt-histor-decla-import.dat-efetiva,
                                                     input input frame fpage0 tt-histor-decla-import.cod-meio-transp,
                                                     input input frame fpage0 tt-histor-decla-import.dsl-obs,
                                                     INPUT "").
            if return-value = "OK":U then 
                run saverecord in this-procedure.
            else do:
                run getRowErrors in h-bocx384(output table RowErrors).
                if can-find(first RowErrors)  then do:
                    {method/showmessage.i1}
                    {method/showmessage.i2}
                end.
            end.


        END.
        ELSE 
            RUN saveRecord IN THIS-PROCEDURE.
    END.
    /*RUN saveRecord IN THIS-PROCEDURE.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-uf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-uf wMaintenanceNoNavigation
ON LEAVE OF c-cod-uf IN FRAME fpage0 /* UF */
DO:
    ASSIGN c-cod-uf = c-cod-uf:SCREEN-VALUE IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-histor-decla-import.cdn-pto-control
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-histor-decla-import.cdn-pto-control wMaintenanceNoNavigation
ON ENTRY OF tt-histor-decla-import.cdn-pto-control IN FRAME fpage0 /* Ponto Controle */
DO:
    ASSIGN i-pto-ant = INT(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-histor-decla-import.cdn-pto-control wMaintenanceNoNavigation
ON F5 OF tt-histor-decla-import.cdn-pto-control IN FRAME fpage0 /* Ponto Controle */
DO:
  {method/zoomfields.i 
     &ProgramZoom="cxzoom/z10cx110.w"
     &FieldZoom1="cod-pto-contr"
     &FieldScreen1="tt-histor-decla-import.cdn-pto-control"
     &Frame1="fPage0"
     &FieldZoom2="descricao"
     &FieldScreen2="tt-histor-decla-import.descricao"
     &Frame2="fPage0"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-histor-decla-import.cdn-pto-control wMaintenanceNoNavigation
ON LEAVE OF tt-histor-decla-import.cdn-pto-control IN FRAME fpage0 /* Ponto Controle */
DO:
    DEFINE VARIABLE c-return AS CHARACTER   NO-UNDO.

    IF  {&ttTable}.cdn-pto-control <> int({&ttTable}.cdn-pto-control:SCREEN-VALUE IN FRAME fPage0) THEN
        ASSIGN c-cod-uf = "".

    IF pcAction <> "UPDATE":U THEN DO:
        RUN goToKey IN h-bocx110na (INPUT INTEGER({&ttTable}.cdn-pto-control:SCREEN-VALUE IN FRAME fPage0)).
        IF RETURN-VALUE = "OK" THEN DO:
            RUN getCharField IN h-bocx110na (INPUT "descricao":U,
                                             OUTPUT {&ttTable}.descricao).
        END.
        ELSE DO:    
            ASSIGN {&ttTable}.descricao = "":U.
        END.

        /* Buscar UF */
        RUN findCodigo IN h-bocx110(INPUT {&ttTable}.cdn-pto-control:SCREEN-VALUE IN FRAME fPage0,
                                    OUTPUT cReturn).
        IF  cReturn = "":U THEN DO:
            IF  TRIM(c-cod-uf) = "":U THEN
                RUN getCharField IN h-bocx110 (INPUT "cod-uf":U,
                                               OUTPUT c-cod-uf). 
        END.
        DISP c-cod-uf WITH FRAME fPage0.
    END.
    DISPLAY {&ttTable}.descricao WITH FRAME fPage0.

     ASSIGN INPUT FRAME fPage0 {&ttTable}.cdn-pto-control.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-histor-decla-import.cdn-pto-control wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-histor-decla-import.cdn-pto-control IN FRAME fpage0 /* Ponto Controle */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{utp/ut-liter.i "Ponto de controle"}
ASSIGN c-lbl-pto-contr = RETURN-VALUE.
{utp/ut-liter.i "Caso confirme, o registro ser  criado no Cadastro de Pontos de Controle com este C¢digo e esta Descri‡Æo."}
ASSIGN c-lbl-cadastra-pto = RETURN-VALUE.
{maintenancenonavigation/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenanceNoNavigation 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-bocx110) THEN DO:
        DELETE PROCEDURE h-bocx110.
        ASSIGN h-bocx110 = ?.
    END.

    IF VALID-HANDLE(h-bocx110na) THEN DO:
        DELETE PROCEDURE h-bocx110na.
        ASSIGN h-bocx110na = ?.
    END.                       

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN c-cod-uf = substr(tt-histor-decla-import.cod-livre-1,6,2).
    DISP c-cod-uf WITH FRAME fPage0.

    RETURN "OK":U.
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
    DEF VAR pSeq LIKE tt-histor-decla-import.num-seq NO-UNDO.
    
    IF pcAction = "UPDATE" THEN DO:
        ASSIGN i-pto-ant = tt-histor-decla-import.cdn-pto-control.
        DISABLE tt-histor-decla-import.num-seq 
                tt-histor-decla-import.descricao
                tt-histor-decla-import.dat-prev-origin
                tt-histor-decla-import.cdn-pto-control
           WITH FRAME fPage0.
        APPLY 'LEAVE' TO tt-histor-decla-import.cdn-pto-control IN FRAME fPage0.
        IF tt-histor-decla-import.dat-efetiva <> ? THEN
            DISABLE tt-histor-decla-import.cdn-pto-control tt-histor-decla-import.descricao WITH FRAME fPage0.
    END.
    ELSE DO:
        RUN retornaProxSeqDI IN h-bocx384 (INPUT tt-decla-import.num-di-ems,
                                           INPUT tt-decla-import.cdd-siscomex-dts,
                                           OUTPUT pSeq).
        ASSIGN tt-histor-decla-import.num-seq:SCREEN-VALUE IN FRAME fPage0 = STRING(pSeq).
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterSaveFields wMaintenanceNoNavigation 
PROCEDURE afterSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN OVERLAY(tt-histor-decla-import.cod-livre-1,6,2) = STRING(c-cod-uf:SCREEN-VALUE IN FRAME fPage0).
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenanceNoNavigation 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(h-bocx110) THEN
        RUN cxbo/bocx110.p persistent set h-bocx110.

    IF NOT VALID-HANDLE(h-bocx110na) THEN DO:
        RUN cxbo/bocx110na.p PERSISTENT SET h-bocx110na.
        RUN openQueryStatic IN h-bocx110na(INPUT "Main":U).
    END.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-assign wMaintenanceNoNavigation 
PROCEDURE pi-assign :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN tt-histor-decla-import.cdn-pto-control     = INPUT FRAME fPage0 tt-histor-decla-import.cdn-pto-control            
       tt-histor-decla-import.num-seq             = INPUT FRAME fPage0 tt-histor-decla-import.num-seq                 
       tt-histor-decla-import.cod-meio-transp     = INPUT FRAME fPage0 tt-histor-decla-import.cod-meio-transp         
       tt-histor-decla-import.dat-efetiva         = INPUT FRAME fPage0 tt-histor-decla-import.dat-efetiva             
       tt-histor-decla-import.dat-prev-origin     = INPUT FRAME fPage0 tt-histor-decla-import.dat-prev-origin            
       tt-histor-decla-import.dsl-obs             = INPUT FRAME fPage0 tt-histor-decla-import.dsl-obs                 
       tt-histor-decla-import.num-di-ems          = tt-decla-import.num-di-ems
       tt-histor-decla-import.cdd-siscomex-dts    = tt-decla-import.cdd-siscomex-dts.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-efetivacao wMaintenanceNoNavigation 
PROCEDURE pi-valida-efetivacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE l-valida-li AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-arquivo AS CHARACTER FORMAT "X(30)" NO-UNDO.

ASSIGN l-valida-li = NO.

IF INPUT FRAME fPage0 tt-histor-decla-import.dat-efetiva <> ? THEN
    RUN piValidaEfetivacaoEmbarque IN h-bocx384 (INPUT  INPUT FRAME fPage0 tt-decla-import.num-di-ems,
                                                 INPUT  INPUT FRAME fPage0 tt-histor-decla-import.cdn-pto-control,
                                                 INPUT  tt-decla-import.cdd-siscomex-dts,
                                                 OUTPUT l-valida-li,
                                                 OUTPUT c-arquivo).

IF l-valida-li THEN
    /* Inicio -- Projeto Internacional */
    DO:
    DEFINE VARIABLE c-lbl-liter-embarque AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Embarque" *}
    ASSIGN c-lbl-liter-embarque = TRIM(RETURN-VALUE).
    DEFINE VARIABLE c-lbl-liter-gentileza-consultar-arquivo AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Gentileza_consultar_arquivo" *}
    ASSIGN c-lbl-liter-gentileza-consultar-arquivo = TRIM(RETURN-VALUE).
    run utp/ut-msgs.p (input "Show":U,
                       input 30446,
                       input c-lbl-liter-embarque + "~~" + c-lbl-liter-gentileza-consultar-arquivo + " " + c-arquivo).
    END. 
    IF  RETURN-VALUE = "NO":U THEN
        RETURN "NOK":U.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*:T------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este m‚todo somente ‚ executado quando a vari vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/
    ASSIGN tt-histor-decla-import.num-di-ems = tt-decla-import.num-di-ems.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

