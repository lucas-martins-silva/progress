&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-historico-embarque NO-UNDO LIKE historico-embarque
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-historico-embarque2 NO-UNDO LIKE historico-embarque
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
{include/i-prgvrs.i IM0055A 2.00.00.043 } /*** "010043" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0055a MIM}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           IM0055A
&GLOBAL-DEFINE Version        2.00.00.041
&GLOBAL-DEFINE DBOVersion        1.1

&GLOBAL-DEFINE InitialPage       0

&GLOBAL-DEFINE ttTable           tt-historico-embarque2
&GLOBAL-DEFINE hDBOTable         h-bocx230a2
&GLOBAL-DEFINE DBOTable          historico-embarque

&GLOBAL-DEFINE ttParent          tt-historico-embarque
&GLOBAL-DEFINE DBOParentTable    historico-embarque

&GLOBAL-DEFINE page0KeyFields    tt-historico-embarque2.sequencia ~
                                 tt-historico-embarque2.cod-pto-contr ~
                                 tt-historico-embarque2.dt-previsao
&GLOBAL-DEFINE page0Fields       tt-historico-embarque2.dt-efetiva ~
                                 tt-historico-embarque2.id-meio-transp ~
                                 tt-historico-embarque2.observacao ~
                                 c-cod-uf ~
                                 tt-historico-embarque2.descricao
&GLOBAL-DEFINE page0ParentFields tt-historico-embarque.cod-estabel ~
                                 tt-historico-embarque.embarque ~
                                 tt-historico-embarque.cod-itiner

{cdp/cdcfgmat.i}

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-meio-transp          LIKE historico-embarque.id-meio-transp NO-UNDO.
DEFINE VARIABLE l-desabilita-btdespesa AS   LOGICAL     NO-UNDO.
DEFINE VARIABLE cReturn                AS   CHARACTER   NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx115     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx110     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx220     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad107     AS HANDLE NO-UNDO.
define variable h-bocx140     as handle no-undo.
DEFINE VARIABLE h-boar0138    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx230     AS HANDLE      NO-UNDO.

def var l-desab   as logical no-undo.


&if '{&bf_mat_versao_ems}' >= '2.062':U  &then

{cxbo/bocx351.i tt-licenciam-import-oc}

define variable iPtoEmbarque     like itinerario.pto-embarque    no-undo.
define variable iPtoDesembarque  like itinerario.pto-desembarque no-undo.
define variable h-bocx351        as handle                       no-undo.
define variable cOrdensSemLI     as character                    no-undo.

&endif

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-historico-embarque.cod-estabel ~
tt-historico-embarque.embarque tt-historico-embarque.cod-itiner ~
tt-historico-embarque2.sequencia tt-historico-embarque2.cod-pto-contr ~
tt-historico-embarque2.descricao tt-historico-embarque2.dt-previsao ~
tt-historico-embarque2.dt-efetiva tt-historico-embarque2.id-meio-transp ~
tt-historico-embarque2.observacao 
&Scoped-define ENABLED-TABLES tt-historico-embarque tt-historico-embarque2
&Scoped-define FIRST-ENABLED-TABLE tt-historico-embarque
&Scoped-define SECOND-ENABLED-TABLE tt-historico-embarque2
&Scoped-Define ENABLED-OBJECTS rtToolBar desc-est FILL-IN-3 c-cod-uf btOK ~
btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-historico-embarque.cod-estabel ~
tt-historico-embarque.embarque tt-historico-embarque.cod-itiner ~
tt-historico-embarque2.sequencia tt-historico-embarque2.cod-pto-contr ~
tt-historico-embarque2.descricao tt-historico-embarque2.dt-previsao ~
tt-historico-embarque2.dt-efetiva tt-historico-embarque2.id-meio-transp ~
tt-historico-embarque2.observacao 
&Scoped-define DISPLAYED-TABLES tt-historico-embarque ~
tt-historico-embarque2
&Scoped-define FIRST-DISPLAYED-TABLE tt-historico-embarque
&Scoped-define SECOND-DISPLAYED-TABLE tt-historico-embarque2
&Scoped-Define DISPLAYED-OBJECTS desc-est FILL-IN-3 c-cod-uf 

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

DEFINE VARIABLE desc-est AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35.43 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-historico-embarque.cod-estabel AT ROW 1.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     desc-est AT ROW 1.17 COL 40 COLON-ALIGNED NO-LABEL
     tt-historico-embarque.embarque AT ROW 2.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     tt-historico-embarque.cod-itiner AT ROW 3.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     FILL-IN-3 AT ROW 3.17 COL 40.14 COLON-ALIGNED NO-LABEL
     tt-historico-embarque2.sequencia AT ROW 4.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-historico-embarque2.cod-pto-contr AT ROW 5.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.72 BY .88
     tt-historico-embarque2.descricao AT ROW 5.17 COL 41.86 COLON-ALIGNED NO-LABEL WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 25.14 BY .88
     c-cod-uf AT ROW 5.17 COL 71 COLON-ALIGNED WIDGET-ID 4
     tt-historico-embarque2.dt-previsao AT ROW 6.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-historico-embarque2.dt-efetiva AT ROW 7.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-historico-embarque2.id-meio-transp AT ROW 8.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     tt-historico-embarque2.observacao AT ROW 9.17 COL 37.14 NO-LABEL
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 30 BY 4
     btOK AT ROW 13.71 COL 2
     btSave AT ROW 13.71 COL 13
     btCancel AT ROW 13.71 COL 23.86
     btHelp AT ROW 13.71 COL 80
     "Obs:" VIEW-AS TEXT
          SIZE 3.72 BY .54 AT ROW 9.17 COL 33.14
     rtToolBar AT ROW 13.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 14.13
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-historico-embarque T "?" NO-UNDO mgcex historico-embarque
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-historico-embarque2 T "?" NO-UNDO mgcex historico-embarque
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
         HEIGHT             = 14.04
         WIDTH              = 90
         MAX-HEIGHT         = 16.33
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 16.33
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
/* SETTINGS FOR BUTTON btSave IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       btSave:HIDDEN IN FRAME fpage0           = TRUE.

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
    IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
        IF  VALID-HANDLE(h-boar0138) THEN DO:
            RUN validaIm0055a IN h-boar0138(INPUT tt-historico-embarque2.cod-pto-contr:screen-value in frame fpage0,
                                            INPUT tt-historico-embarque.cod-itiner:screen-value in frame fpage0,
                                            INPUT tt-historico-embarque.cod-estabel:screen-value in frame fpage0,
                                            INPUT tt-historico-embarque.embarque:screen-value in frame fpage0,
                                            INPUT tt-historico-embarque2.sequencia:screen-value in frame fpage0,
                                            INPUT ROWID(tt-historico-embarque)).
        END.
    END.
    /* Licenciamento Importacao */
    &if '{&bf_mat_versao_ems}' >= '2.062':U  &then
    
    run piValidaEfetivacaoEmbarque in this-procedure.
    if  return-value = "NOK":U then
        return no-apply.

    &endif
    
    /* Recalcular as datas de previsÆo */

    IF pcaction = "ADD" THEN DO:
            FIND FIRST pto-contr 
                WHERE pto-contr.cod-pto-contr =  INT(tt-historico-embarque2.cod-pto-contr:screen-value in frame fpage0) NO-LOCK NO-ERROR.
            IF AVAIL pto-contr AND pto-contr.LOG-1 = NO THEN 
                ASSIGN tt-historico-embarque2.log-1 = YES.
    END.

    
    RUN setRecalcula IN h-bocx230a2 (INPUT tt-historico-embarque2.log-1).

    RUN saveRecord IN THIS-PROCEDURE.
    
    IF RETURN-VALUE = "OK":U THEN DO:
        if pcaction = "ADD" and
            DATE(tt-historico-embarque2.dt-efetiva:SCREEN-VALUE IN FRAME fpage0) = ? then do: /*embarque encerrado*/
        
            RUN alterasitembar IN h-bocx220 (input tt-historico-embarque.cod-estabel:screen-value in frame fpage0,
                                             input tt-historico-embarque.embarque:screen-value in frame fpage0). 
        end.
        
        RUN OpenQueriesSon in phCaller.
        RUN openQuery in h-bocx230a2 (input 3).
        assign prtable = tt-historico-embarque.r-rowid.
        RUN repositionRecord in phcaller (input prtable).
        APPLY "CLOSE":U TO THIS-PROCEDURE.
    END. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
        IF  VALID-HANDLE(h-boar0138) THEN DO:
            RUN validaIm0055a IN h-boar0138(INPUT tt-historico-embarque2.cod-pto-contr:screen-value in frame fpage0,
                                            INPUT tt-historico-embarque.cod-itiner:screen-value in frame fpage0,
                                            INPUT tt-historico-embarque.cod-estabel:screen-value in frame fpage0,
                                            INPUT tt-historico-embarque.embarque:screen-value in frame fpage0,
                                            INPUT tt-historico-embarque2.sequencia:screen-value in frame fpage0,
                                            INPUT ROWID(tt-historico-embarque)).
        END.
    END.

    /* Licenciamento Importacao */
    &if '{&bf_mat_versao_ems}' >= '2.062':U  &then
    
    run piValidaEfetivacaoEmbarque in this-procedure.
    if  return-value = "NOK":U then
        return no-apply.

    &endif
    
    /* Recalcular as datas de previsÆo */
    IF pcaction = "ADD" THEN DO:
            FIND FIRST pto-contr 
                WHERE pto-contr.cod-pto-contr =  INT(tt-historico-embarque2.cod-pto-contr:screen-value in frame fpage0) NO-LOCK NO-ERROR.
            IF AVAIL pto-contr AND pto-contr.LOG-1 = NO THEN
                ASSIGN tt-historico-embarque2.log-1 = YES.
    END.


    RUN setRecalcula IN h-bocx230a2 (INPUT tt-historico-embarque2.log-1).

    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN DO:
        if pcaction = "ADD" and
            date(tt-historico-embarque2.dt-efetiva:SCREEN-VALUE IN FRAME fpage0) = ? then do: /*embarque encerrado*/
            RUN alterasitembar IN h-bocx220 (input tt-historico-embarque.cod-estabel:screen-value in frame fpage0,
                                             input tt-historico-embarque.embarque:screen-value in frame fpage0). 
        end.    
        RUN OpenQueriesSon in phCaller.
        run openQuery in h-bocx230a2 (input 3).
        assign prtable = tt-historico-embarque.r-rowid.
        run repositionRecord in phcaller (input prtable).
    end.
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


&Scoped-define SELF-NAME tt-historico-embarque.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-historico-embarque.cod-estabel wMaintenanceNoNavigation
ON LEAVE OF tt-historico-embarque.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    {method/referencefields.i 
            &HandleDBOLeave="h-boad107"
            &FindMethod="findCodigo"
            &KeyValue1="tt-historico-embarque.cod-estabel:SCREEN-VALUE IN FRAME fPage0"
            &FieldName1="nome"
            &FieldScreen1="desc-est"
            &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-historico-embarque.cod-itiner
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-historico-embarque.cod-itiner wMaintenanceNoNavigation
ON LEAVE OF tt-historico-embarque.cod-itiner IN FRAME fpage0 /* C¢digo Itiner rio */
DO:
  {method/referencefields.i 
   &HandleDBOLeave="h-bocx115"
   &FindMethod="findCodigo"
   &KeyValue1="integer(tt-historico-embarque.cod-itiner:SCREEN-VALUE IN FRAME fPage0)"
   &FieldName1="descricao"
   &FieldScreen1="fill-in-3"
   &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-historico-embarque2.cod-pto-contr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-historico-embarque2.cod-pto-contr wMaintenanceNoNavigation
ON ENTER OF tt-historico-embarque2.cod-pto-contr IN FRAME fpage0 /* Ponto Controle */
ANYWHERE
DO:
  apply 'tab' to self.
  apply 'choose' to btOK IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-historico-embarque2.cod-pto-contr wMaintenanceNoNavigation
ON F5 OF tt-historico-embarque2.cod-pto-contr IN FRAME fpage0 /* Ponto Controle */
DO:
  {method/zoomfields.i 
     &ProgramZoom="cxzoom/z10cx110.w"
     &FieldZoom1="cod-pto-contr"
     &FieldScreen1="tt-historico-embarque2.cod-pto-contr"
     &Frame1="fPage0"
     &FieldZoom2="descricao"
     &FieldScreen2="tt-historico-embarque2.descricao"
     &Frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-historico-embarque2.cod-pto-contr wMaintenanceNoNavigation
ON LEAVE OF tt-historico-embarque2.cod-pto-contr IN FRAME fpage0 /* Ponto Controle */
DO: 
    IF  tt-historico-embarque2.cod-pto-contr <> int(tt-historico-embarque2.cod-pto-contr:SCREEN-VALUE IN FRAME fPage0) THEN
        ASSIGN c-cod-uf = "".

    /* Descri‡Æo do ponto de controle */
    RUN findCh-itiner IN h-bocx230 (INPUT tt-historico-embarque.cod-estabel:SCREEN-VALUE IN FRAME fPage0,
                                    INPUT tt-historico-embarque.embarque:SCREEN-VALUE IN FRAME fPage0,
                                    INPUT INT(tt-historico-embarque.cod-itiner:SCREEN-VALUE IN FRAME fPage0),
                                    INPUT INT(tt-historico-embarque2.cod-pto-contr:SCREEN-VALUE IN FRAME fPage0),
                                    OUTPUT cReturn).

    IF cReturn = "":U THEN DO:
        RUN getCharField IN h-bocx230 (INPUT "descricao":U, 
                                       OUTPUT tt-historico-embarque2.descricao).
        DISPLAY tt-historico-embarque2.descricao WITH FRAME fPage0.
    END.

    IF TRIM(tt-historico-embarque2.descricao) = "":U OR cReturn <> "":U THEN DO:
        {method/referencefields.i &HandleDBOLeave="h-bocx110"
                                  &FindMethod="findCodigo"
                                  &KeyValue1="tt-historico-embarque2.cod-pto-contr:SCREEN-VALUE IN FRAME fPage0"
                                  &FieldName1="descricao"
                                  &FieldScreen1="tt-historico-embarque2.descricao"
                                  &Frame1="fPage0"}
    END.

    /* Buscar UF */
    RUN findCodigo IN h-bocx110(INPUT tt-historico-embarque2.cod-pto-contr:SCREEN-VALUE IN FRAME fPage0,
                                OUTPUT cReturn).
    IF  cReturn = "":U THEN DO:
        IF  TRIM(c-cod-uf) = "":U THEN
            RUN getCharField IN h-bocx110 (INPUT "cod-uf":U,
                                           OUTPUT c-cod-uf). 
    END.
    DISP c-cod-uf WITH FRAME fPage0.

    ASSIGN INPUT FRAME fPage0 tt-historico-embarque2.cod-pto-contr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-historico-embarque2.cod-pto-contr wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-historico-embarque2.cod-pto-contr IN FRAME fpage0 /* Ponto Controle */
DO:
  apply "F5":U to self.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-historico-embarque2.sequencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-historico-embarque2.sequencia wMaintenanceNoNavigation
ON LEAVE OF tt-historico-embarque2.sequencia IN FRAME fpage0 /* Seq */
DO:
  run retornaTransportePontoAnterior in h-bocx230a2(input tt-historico-embarque.cod-estabel:screen-value in frame fpage0,
                                                    input tt-historico-embarque.embarque:screen-value in frame fpage0,
                                                    input tt-historico-embarque.cod-itiner:screen-value in frame fpage0,
                                                    input tt-historico-embarque2.sequencia:screen-value in frame fpage0, 
                                                    output c-meio-transp).
  if (tt-historico-embarque2.id-meio-transp:screen-value in frame fpage0 = " ") or 
     (tt-historico-embarque2.sequencia:sensitive in frame fpage0 = yes) then
     assign tt-historico-embarque2.id-meio-transp:screen-value in frame fpage0 = c-meio-transp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/* ***************************  Main Block  *************************** */

/*--- L¢gica para inicializa‡Æo do programam ---*/
tt-historico-embarque2.cod-pto-contr:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage0.

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

IF VALID-HANDLE(h-bocx115) THEN DO:
   delete procedure h-bocx115.
END.

IF VALID-HANDLE(h-bocx110) THEN DO:
   delete procedure h-bocx110.
END.

IF VALID-HANDLE(h-boad107) THEN DO:
   delete procedure h-boad107.
END.

IF VALID-HANDLE(h-bocx220) THEN DO:
   delete procedure h-bocx220.
END.

IF VALID-HANDLE(h-bocx140) THEN DO:
   delete procedure h-bocx140.
END.

IF VALID-HANDLE(h-bocx230) THEN DO:
    DELETE PROCEDURE h-bocx230.
    ASSIGN h-bocx230 = ?.
END.

/* Licenciamento Importacao */
&if '{&bf_mat_versao_ems}' >= '2.062':U  &then
if  valid-handle (h-bocx351) then do:
    delete procedure h-bocx351.
    assign h-bocx351 = ?.
end.
&endif

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
  
  APPLY "LEAVE":U TO tt-historico-embarque.cod-estabel    IN FRAME fPage0.
  APPLY "LEAVE":U TO tt-historico-embarque.cod-itiner     IN FRAME fPage0.
  APPLY "LEAVE":U TO tt-historico-embarque2.cod-pto-contr IN FRAME fPage0.
  APPLY "LEAVE":U TO tt-historico-embarque2.sequencia     IN FRAME fPage0.

  ASSIGN c-cod-uf = substr(tt-historico-embarque2.char-1,1,2).
  DISP c-cod-uf WITH FRAME fPage0.

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenanceNoNavigation 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DISABLE tt-historico-embarque2.descricao WITH FRAME fPage0.
                  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterSaveFields wMaintenanceNoNavigation 
PROCEDURE afterSaveFields :
/*------------------------------------------------------------------------------
  Purpose: Salva os valores das variaveis na tabela.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    ASSIGN OVERLAY(tt-historico-embarque2.char-1,1,2) = STRING(c-cod-uf:SCREEN-VALUE IN FRAME fPage0).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDBOSonHandle wMaintenanceNoNavigation 
PROCEDURE getDBOSonHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input   parameter i-pag    as integer no-undo.
def output  parameter h-handle as handle  no-undo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getParentRecord wMaintenanceNoNavigation 
PROCEDURE getParentRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def output parameter table for tt-historico-embarque.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) THEN DO:
       RUN cxbo/bocx230a.p persistent set h-bocx230a2.
    END.    

    IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
        IF  NOT VALID-HANDLE(h-boar0138) THEN
            RUN local/arg/boar0138.p PERSISTENT SET h-boar0138.
    END.

    if  pcAction = "UPDATE":u then do:
        disable btSave      with frame fPage0.
        /* 
        run validaDespEmbarque in h-bocx230a2 (input  prParent,
                                               output l-desab).

        if   l-desab = yes then
             disable btDespesas with frame fPage0.
        else enable btDespesas  with frame fPage0.
        */ 
    end.
          
    RUN cxbo/bocx115.p persistent set h-bocx115.
    run openQuery in h-bocx115 (input 1).

    RUN cxbo/bocx110.p persistent set h-bocx110.
    RUN cxbo/bocx220.p persistent set h-bocx220.
    RUN adbo/boad107.p persistent set h-boad107.

    IF NOT VALID-HANDLE(h-bocx230) THEN
        RUN cxbo/bocx230.p PERSISTENT SET h-bocx230.

    /* Licenciamento Importacao */
    &if '{&bf_mat_versao_ems}' >= '2.062':U  &then
    
    if  not valid-handle (h-bocx351) then 
        run cxbo/bocx351.p persistent set h-bocx351.

    run openQueryStatic in h-bocx351 (input "Main":U).

    &endif

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaEfetivacaoEmbarque wMaintenanceNoNavigation 
PROCEDURE piValidaEfetivacaoEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   /* Licenciamento Importacao */
    &if '{&bf_mat_versao_ems}' >= '2.062':U  &then
    
    DEFINE VARIABLE c-arquivo AS CHARACTER FORMAT "X(30)" NO-UNDO.
    if  valid-handle (h-bocx115) then do:

        assign iPtoEmbarque = 0.

        run findCodigo in h-bocx115 (input tt-historico-embarque2.cod-itiner,
                                     output cReturn).
        if  cReturn = "":U then do:
            run getIntField in h-bocx115 (input "pto-embarque":U,
                                          output iPtoEmbarque).
            run getIntField in h-bocx115 (input "pto-desembarque":U,
                                          output iPtoDesembarque).
        end.
    end.

    if  (    iPtoEmbarque = input frame fPage0 tt-historico-embarque2.cod-pto-contr
         and input frame fPage0 tt-historico-embarque2.dt-efetiva <> ?)
    or  (    iPtoDesembarque = input frame fPage0 tt-historico-embarque2.cod-pto-contr
         and input frame fPage0 tt-historico-embarque2.dt-efetiva <> ?) then do:
    
        if  valid-handle (h-bocx351) then do:
    
            assign cOrdensSemLI = "":U.
            
            run piRetornaLI in h-bocx351 (input 2,
                                          input yes,
                                          input ?,
                                          input tt-historico-embarque2.cod-estabel,
                                          input tt-historico-embarque2.embarque,
                                          input ?,
                                          input no,
                                          input yes,
                                          input 0,
                                          input 99999999,
                                          input " ":U,
                                          input "ZZZZZZZZZZZZZZZZ":U,
                                          input " ":U,
                                          input "ZZZZZZZZ":U,
                                          input " ":U,
                                          input "ZZZZZZZZZZZZZZZZZZZZ":U,
                                          output table tt-licenciam-import-oc). 
        end.
    
        bloco_LI:
        for each  tt-licenciam-import-oc
            where tt-licenciam-import-oc.licenca-import = "":U
            break by tt-licenciam-import-oc.numero-ordem
                  by tt-licenciam-import-oc.parcela:
    
            if  first-of (tt-licenciam-import-oc.numero-ordem) then do:
                if  cOrdensSemLI = "":U then
                    assign cOrdensSemLI = string(tt-licenciam-import-oc.numero-ordem).
                else
                    assign cOrdensSemLI = cOrdensSemLI + ", ":U + string(tt-licenciam-import-oc.numero-ordem).
                IF cOrdensSemLI <> "" THEN
                    LEAVE bloco_LI.
            end.
        end.
    
        if  cOrdensSemLi <> "":U then do:
            ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "IM9056RP":U + ".tmp":U.

            RUN imp/im9056rp.p (INPUT tt-historico-embarque.cod-estabel,
                                INPUT tt-historico-embarque.embarque,
                                INPUT TABLE tt-licenciam-import-oc).
        
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-embarque AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Embarque" *}
            ASSIGN c-lbl-liter-embarque = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-gentileza-consultar-arquivo AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Gentileza_consultar_arquivo" *}
            ASSIGN c-lbl-liter-gentileza-consultar-arquivo = TRIM(RETURN-VALUE).
            run utp/ut-msgs.p (input "Show":U,
                               input 30446,
                               input c-lbl-liter-embarque + "~~" + c-lbl-liter-gentileza-consultar-arquivo + " " + c-arquivo).
            if  return-value = "no":U then
                return "NOK":U.
        end.
        
    end.

    return "OK":U.

    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionParent wMaintenanceNoNavigation 
PROCEDURE repositionParent :
/*------------------------------------------------------------------------------
  Purpose   : Atualiza os registros no browser do programa pai (im0055.w)
  Parameters: 1) rowid ( historico-embarque) 
              2) numero da pagina (1)
  Notes:      
------------------------------------------------------------------------------*/

DEF INPUT PARAM r-rowid AS ROWID.
DEF INPUT PARAM inrpag  AS INT.
    
   RUN repositionRecordSon IN phCaller (INPUT r-rowid, INPUT inrpag).

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este m‚todo somente ‚ executado quando a vari vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/
    assign  tt-historico-embarque2.cod-estabel = tt-historico-embarque.cod-estabel
            tt-historico-embarque2.cod-itiner  = tt-historico-embarque.cod-itiner
            tt-historico-embarque2.embarque    = tt-historico-embarque.embarque.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

