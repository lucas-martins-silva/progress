&Scoped-define WINDOW-NAME C-Win

/*------------------------------------------------------------------------
File.............: bcr003.w
Description......: Tela que apresenta os relat¢rios do Procedimento
Author...........: DATASUL S.A.
Created..........: 23/07/98 - 14:18 - bc
OBS..............: Este fonte foi gerado pelo Data Viewer
------------------------------------------------------------------------*/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */


/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var c-programa         as char                          no-undo.              
def var c-lista            as char init "" no-undo.              
def var c-cod-proced       as char                          no-undo.              
def var c-prog             as char init "" no-undo.              
def var v-cod-prog-gerado  as char                          no-undo.              

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define FRAME-NAME DEFAULT-FRAME                                   

/* ***********************  Control Definitions  ********************** */

DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.                                

DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda"
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Cancelar"
     SIZE 10 BY 1.

DEFINE BUTTON bt-ok 
     LABEL "Executar"
     SIZE 10 BY 1.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 49.72 BY 1.38
     BGCOLOR 7 .

DEFINE VARIABLE SELECT-1 AS CHARACTER 
     VIEW-AS SELECTION-LIST                               SINGLE                               SCROLLBAR-VERTICAL                               SCROLLBAR-HORIZONTAL 
     SIZE 49 BY 5.46 NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     SELECT-1 AT ROW 1.08 COL 2 NO-LABEL
     bt-ok AT ROW 7.17 COL 2.57
     bt-cancelar AT ROW 7.17 COL 13.57
     bt-ajuda AT ROW 7.17 COL 40.43
     RECT-1 AT ROW 6.96 COL 1.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 51 BY 7.54.

/* *************************  Create Window  ************************** */

IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Programa N∆o Cadastrado"
         HEIGHT             = 7.54
         WIDTH              = 51.14
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 80
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&GLOBAL-DEFINE aplica_facelift YES
{include/i_fcldef.i}
{include/i_fclfrm.i DEFAULT-FRAME}

/* ***************  Runtime Attributes and UIB Settings  ************** */

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* ************************* Included-Libraries *********************** */

/*** In°cio ut-glob.i Definiá∆o de vari†veis globais ***/ 
{include/i_fnctrad.i}
&if  defined(GLOBALS) &then 

&else
     &glob GLOBALS ok 

     def new global shared var i-ep-codigo-usuario  like empresa.ep-codigo no-undo.
     def new Global shared var l-implanta           as logical    init no.
     def new Global shared var c-seg-usuario        as char format "x(12)" no-undo.
     def new global shared var i-num-ped-exec-rpw  as integer no-undo.   
     def var rw-log-exec                            as rowid no-undo.
     def new global shared var i-pais-impto-usuario as integer format ">>9" no-undo.
     def new global shared var l-rpc as logical no-undo.
     def new global shared temp-table tt-servid-rpc-aplicat NO-UNDO
         field tta-cod-aplicat-dtsul like aplicat_dtsul.cod_aplicat_dtsul
         field tta-hdl-servid-rpc    as   handle.
     def var c-erro-rpc as character format "x(60)" initial " " no-undo.
     def var c-erro-aux as character format "x(60)" initial " " no-undo.
     def new global shared var r-registro-atual as rowid no-undo.
     def new global shared var c-arquivo-log    as char  format "x(60)"no-undo.
     
      /* Vari†veis Padr∆o DWB / Datasul HR */
     def new global shared var i-num-ped as integer no-undo.         
     def new global shared var v_cdn_empres_usuar   like empresa.ep-codigo        no-undo.
     def new global shared var v_cod_usuar_corren   like usuar_mestre.cod_usuario no-undo.
     def new global shared var h_prog_segur_estab     as handle                   no-undo.
     def new global shared var v_cod_grp_usuar_lst    as char                     no-undo.
     def new global shared var v_num_tip_aces_usuar   as int                      no-undo.     
&endif

/*** Fim ut-glob.i Definiá∆o de vari†veis globais ***/ 

/* ************************  Control Triggers  ************************ */

ON END-ERROR OF C-Win 
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

ON WINDOW-CLOSE OF C-Win
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

ON CHOOSE OF bt-ajuda IN FRAME DEFAULT-FRAME
OR HELP OF FRAME {&FRAME-NAME}
DO:
    Def Var vLtr As Char No-undo.
    Def Var vLtr1 As Char No-undo.
    {utp/ut-liter.i Selecione_uma_das_opá‰es_de_classificaá∆o *}
    Assign vLtr = Return-value.
    {utp/ut-liter.i acima_geradas_para_o_relat¢rio_e,_pressione_o *}
    Assign vLtr1 = Return-value.
    {utp/ut-liter.i bot∆o_[Executar]_para_execut†-lo. *}
    message vLtr skip
            vLtr1 skip
            Return-value view-as alert-box information.
END.

ON CHOOSE OF bt-cancelar IN FRAME DEFAULT-FRAME
DO:
  apply "close" to this-procedure.
END.

ON CHOOSE OF bt-ok IN FRAME DEFAULT-FRAME
DO:
  if select-1:screen-value in frame {&frame-name} <> ? then do:
    if select-1:num-items in frame {&frame-name} <> 0 then
      run pi-selecao.
    RUN enable_UI.
  end.
END.

ON MOUSE-SELECT-DBLCLICK OF SELECT-1 IN FRAME DEFAULT-FRAME
DO:
    apply "choose" to bt-ok in frame {&frame-name}.
END.

&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCR003 2.00.00.008} /*** "010008" 23/01/2024 14:00:35 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BCR003 MBC}
&ENDIF



/***********************  DEFINITIONS  ***********************************/

&glob SYSTEM-VARS yes

DEF VAR c-programa-mg97       AS CHAR FORMAT "x(08)" NO-UNDO.
DEF VAR c-versao-mg97         AS CHAR FORMAT "x(08)" NO-UNDO.
DEF VAR c-modulo-mg97         AS CHAR FORMAT "x(08)" NO-UNDO.
DEF VAR c-titulo-prog-mg97    AS CHAR FORMAT "x(08)" NO-UNDO.
DEF VAR i-num-topico-hlp-mg97 AS INTEGER             NO-UNDO.
DEF VAR c-nom-manual-hlp-mg97 AS CHAR FORMAT "x(06)" NO-UNDO.
DEF VAR i-ctrl-tab-page       AS INTEGER             NO-UNDO.
DEF VAR i-ctrl-tab-folder     AS INTEGER             NO-UNDO.
DEF VAR lDisableUPC           AS LOGICAL             NO-UNDO.

&IF DEFINED(PGIMP) &THEN
    &Scoped-Define FRAME-NAME 
&ENDIF

&IF DEFINED(PGLOG) &THEN
    &Scoped-Define FRAME-NAME 
&ENDIF

&IF DEFINED(adm-containr) = 0 &THEN
&GLOB adm-containr yes

&IF DEFINED(adm-attribute-dlg) = 0 &THEN
&SCOP adm-attribute-dlg adm/support/contnrd.w
&ENDIF

&IF DEFINED(adm-attribute-list) = 0 &THEN
&SCOP adm-attribute-list Layout,Hide-on-Init
&ENDIF

&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&ANALYZE-RESUME

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 

/* ************************* Included-Libraries *********************** */
&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 

/* ***************************  Definitions  ************************** */

def var c-nom-prog-upc-mg97  as char format "x(50)" no-undo.
def var c-nom-prog-appc-mg97 as char format "x(50)" no-undo.
def var c-nom-prog-dpc-mg97  as char format "x(50)" no-undo.
def var c-ctrl-tab           as char                no-undo.
def var h-ctrl-tab           as handle              no-undo.
def var wh-entry-field       as widget-handle       no-undo.

&IF DEFINED (adm-smart) = 0 &THEN
&GLOBAL adm-smart

&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&ANALYZE-RESUME

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
&ANALYZE-RESUME
 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */
&IF DEFINED (adm-attribut) = 0 &THEN
&GLOB adm-attribut yes

&GLOB      adm-version ADM1.1

&IF INT(ENTRY(1,PROVERSION,".")) >= 8 &THEN
  &GLOB    ADM-DATA      ADM-DATA
  &GLOB    UNLESS-HIDDEN UNLESS-HIDDEN
&ELSE
  &GLOB    ADM-DATA      PRIVATE-DATA
  &GLOB    UNLESS-HIDDEN 
&ENDIF

DEFINE VAR adm-object-hdl       AS HANDLE NO-UNDO.
DEFINE VAR adm-query-opened        AS LOGICAL NO-UNDO INIT NO.
DEFINE VAR adm-row-avail-state     AS LOGICAL NO-UNDO INIT ?.
DEFINE VAR adm-initial-lock        AS CHARACTER NO-UNDO INIT "NO-LOCK":U.
DEFINE VAR adm-new-record          AS LOGICAL NO-UNDO INIT no.
DEFINE VAR adm-updating-record     AS LOGICAL NO-UNDO INIT no.
DEFINE VAR adm-check-modified-all  AS LOGICAL NO-UNDO INIT no.

DEFINE NEW GLOBAL SHARED VAR adm-broker-hdl    AS HANDLE  NO-UNDO.

&ENDIF
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 

/* ***************************  Main Block  *************************** */

&IF "{&ADM-CONTAINER}":U NE "":U &THEN
  &IF "{&ADM-CONTAINER}":U = "FRAME":U OR "{&ADM-CONTAINER}":U = "DIALOG-BOX":U 
  &THEN
    ASSIGN adm-object-hdl = FRAME {&FRAME-NAME}:HANDLE. 
  &ELSEIF "{&ADM-CONTAINER}":U = "WINDOW":U &THEN
    ASSIGN adm-object-hdl    =   {&window-name}.
  &ELSE
    ASSIGN adm-object-hdl    = ?.
  &ENDIF
&ELSE
  &IF "{&FRAME-NAME}":U NE "":U &THEN
      adm-object-hdl = FRAME {&FRAME-NAME}:HANDLE.
  &ENDIF
&ENDIF

&IF  DEFINED(adm-containr) <> 0 &THEN   
    &IF DEFINED(PGIMP) = 0 AND DEFINED(PGLOG) = 0 &THEN
        run pi-trad-widgets (input frame {&frame-name}:handle).
    &ENDIF
&ENDIF

&IF DEFINED(adm-viewer) <> 0 &THEN 
    run pi-trad-widgets (input frame {&frame-name}:handle).
&ENDIF       

&IF DEFINED(adm-browser) <> 0 &THEN 
    run pi-trad-widgets (input frame {&frame-name}:handle).
&ENDIF       

&IF "{&PROCEDURE-TYPE}":U NE "ADM-Broker":U &THEN
RUN get-attribute IN adm-broker-hdl ('TYPE':U) NO-ERROR.
IF RETURN-VALUE NE "ADM-Broker":U THEN 
DO: 
    RUN adm/objects/broker.p PERSISTENT set adm-broker-hdl. 
    RUN set-broker-owner IN adm-broker-hdl (THIS-PROCEDURE).
END.
&ENDIF


THIS-PROCEDURE:{&ADM-DATA} = 
     '{&ADM-VERSION}~`':U +
     '{&PROCEDURE-TYPE}~`':U +
     '{&ADM-CONTAINER}~`':U +
   &IF DEFINED (adm-open-query) NE 0 &THEN
     'YES~`':U +
   &ELSE
     'NO ~`':U +
   &ENDIF
     '{&EXTERNAL-TABLES}~`':U +
     '{&INTERNAL-TABLES}~`':U +
   &IF DEFINED(adm-browser) NE 0 &THEN  
     '{&ENABLED-TABLES-IN-QUERY-{&BROWSE-NAME}}~`':U +
   &ELSE
     '{&ENABLED-TABLES}~`':U +
   &ENDIF
     (IF adm-object-hdl = ? THEN "":U ELSE STRING(adm-object-hdl))
        + "~`":U +
   &IF DEFINED(ADM-ATTRIBUTE-LIST) NE 0 &THEN
     '{&ADM-ATTRIBUTE-LIST}~`':U + 
   &ELSE 
     '?~`':U +
   &ENDIF
   &IF "{&User-Supported-Links}":U NE "":U &THEN
     '{&ADM-SUPPORTED-LINKS},{&User-Supported-Links}~`':U +
   &ELSE
     '{&ADM-SUPPORTED-LINKS}~`':U +
   &ENDIF
     '{&ADM-DISPATCH-QUALIFIER}~`':U +
     '~`~`~`~`~`~`~`~`~`~`~`':U +
     IF THIS-PROCEDURE:{&ADM-DATA} = "":U OR THIS-PROCEDURE:{&ADM-DATA} = ? 
         THEN "^^":U 
     ELSE "^":U + ENTRY(2, THIS-PROCEDURE:{&ADM-DATA}, "^":U) + 
          "^":U + ENTRY(3, THIS-PROCEDURE:{&ADM-DATA}, "^":U).

&IF "{&LAYOUT-VARIABLE}" eq "" &THEN
  &Scoped-define EXCLUDE-adm-apply-layout YES
&ENDIF

&ANALYZE-RESUME

/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-adm-apply-entry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-apply-entry Method-Library 
PROCEDURE adm-apply-entry :
 DEFINE VAR c_Handle AS CHAR NO-UNDO.
  ASSIGN c_Handle = "".
  RUN get-link-handle IN adm-broker-hdl (INPUT THIS-PROCEDURE, 
                                         INPUT 'TABLEIO-SOURCE':U,
                                         OUTPUT c_Handle ).
  IF c_Handle <> "" THEN                                       
  RUN broker-apply-entry IN adm-broker-hdl (THIS-PROCEDURE) NO-ERROR.
  
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-apply-layout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-apply-layout Method-Library 
PROCEDURE adm-apply-layout :
  DEFINE VARIABLE layout-name AS CHARACTER NO-UNDO.
  
  RUN get-attribute ('Layout':U).
  layout-name = IF RETURN-VALUE eq ? THEN "":U ELSE RETURN-VALUE.
  
  IF layout-name eq "":U THEN DO:
    RUN get-attribute IN THIS-PROCEDURE ('Default-Layout':U).
    layout-name = IF RETURN-VALUE eq ? THEN "":U ELSE RETURN-VALUE.
    IF layout-name eq "":U THEN layout-name = "Master Layout":U.
  END.
  
  IF {&LAYOUT-VARIABLE} ne layout-name THEN DO:
    IF {&LAYOUT-VARIABLE} ne "Master Layout":U 
    THEN RUN {&LAYOUT-VARIABLE}s ("Master Layout":U).
    IF layout-name ne "Master Layout":U 
    THEN RUN {&LAYOUT-VARIABLE}s (layout-name).
    RUN dispatch ('display-fields':U).
  END.

END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-destroy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-destroy Method-Library 
PROCEDURE adm-destroy :
 RUN broker-destroy IN adm-broker-hdl (THIS-PROCEDURE) NO-ERROR.
 
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-disable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-disable Method-Library 
PROCEDURE adm-disable :
    &IF "{&FRAME-NAME}":U NE "":U &THEN
    DISABLE {&ENABLED-OBJECTS} WITH FRAME {&FRAME-NAME}.
    RUN dispatch ('disable-fields':U).  
    &ENDIF                              

    /* EPC Disable do Container */
    &IF  DEFINED(adm-containr) <> 0 &THEN
if  c-nom-prog-dpc-mg97 <> ""
and c-nom-prog-dpc-mg97 <> ? then do:

&IF DEFINED(PGIMP) <> 0 &THEN   
    run value(c-nom-prog-dpc-mg97) (input "DISABLE", 
                                    input "CONTAINER",
                                    input this-procedure,
                                    input frame f-relat:handle,
                                    input "",
                                    input ?).    
&ELSEIF DEFINED(PGLOG) <> 0 &THEN   
    run value(c-nom-prog-dpc-mg97) (input "DISABLE", 
                                    input "CONTAINER",
                                    input this-procedure,
                                    input frame f-import:handle,
                                    input "",
                                    input ?).    
&ELSE
    run value(c-nom-prog-dpc-mg97) (input "DISABLE", 
                                    input "CONTAINER",
                                    input this-procedure,
                                    input frame {&FRAME-NAME}:handle,
                                    input "",
                                    input ?).    
&ENDIF

end.

if  c-nom-prog-appc-mg97 <> ""
and c-nom-prog-appc-mg97 <> ? then do:           
    
&IF DEFINED(PGIMP) <> 0 &THEN   
    run value(c-nom-prog-appc-mg97) (input "DISABLE", 
                                     input "CONTAINER",
                                     input this-procedure,
                                     input frame f-relat:handle,
                                     input "",
                                     input ?).    
&ELSEIF DEFINED(PGLOG) <> 0 &THEN   
    run value(c-nom-prog-appc-mg97) (input "DISABLE", 
                                     input "CONTAINER",
                                     input this-procedure,
                                     input frame f-import:handle,
                                     input "",
                                     input ?).    
&ELSE
    run value(c-nom-prog-appc-mg97) (input "DISABLE", 
                                     input "CONTAINER",
                                     input this-procedure,
                                     input frame {&FRAME-NAME}:handle,
                                     input "",
                                     input ?).    
&ENDIF

end.                                       

if  c-nom-prog-upc-mg97 <> ""
and c-nom-prog-upc-mg97 <> ? then do:

&IF DEFINED(PGIMP) <> 0 &THEN   
    run value(c-nom-prog-upc-mg97) (input "DISABLE", 
                                    input "CONTAINER",
                                    input this-procedure,
                                    input frame f-relat:handle,
                                    input "",
                                    input ?).    
&ELSEIF DEFINED(PGLOG) <> 0 &THEN   
    run value(c-nom-prog-upc-mg97) (input "DISABLE", 
                                    input "CONTAINER",
                                    input this-procedure,
                                    input frame f-import:handle,
                                    input "",
                                    input ?).    
&ELSE
    run value(c-nom-prog-upc-mg97) (input "DISABLE", 
                                    input "CONTAINER",
                                    input this-procedure,
                                    input frame {&FRAME-NAME}:handle,
                                    input "",
                                    input ?).    
&ENDIF

end.
    &ENDIF

    RUN set-attribute-list ('ENABLED=no':U).

    RETURN.
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-edit-attribute-list) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-edit-attribute-list Method-Library 
PROCEDURE adm-edit-attribute-list :
  &IF "{&adm-attribute-dlg}":U NE "":U &THEN
      RUN {&adm-attribute-dlg} (INPUT THIS-PROCEDURE).
  &ELSE MESSAGE "There is no attribute list dialog for this object.":U
          VIEW-AS ALERT-BOX WARNING.
  &ENDIF
          
      RETURN. 
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-enable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-enable Method-Library 
PROCEDURE adm-enable :
     
  &IF "{&FRAME-NAME}":U NE "":U &THEN

    ENABLE {&UNLESS-HIDDEN} {&ENABLED-OBJECTS} WITH FRAME {&FRAME-NAME}.

    RUN enable_UI IN THIS-PROCEDURE NO-ERROR.

  &ENDIF                          

   &IF  DEFINED(adm-containr) <> 0 &THEN
if  c-nom-prog-dpc-mg97 <> ""
and c-nom-prog-dpc-mg97 <> ? then do:

&IF DEFINED(PGIMP) <> 0 &THEN   
    run value(c-nom-prog-dpc-mg97) (input 'ENABLE', 
                                    input 'CONTAINER',
                                    input this-procedure,
                                    input frame f-relat:handle,
                                    input "",
                                    input ?).    
&ELSEIF DEFINED(PGLOG) <> 0 &THEN   
    run value(c-nom-prog-dpc-mg97) (input 'ENABLE', 
                                    input 'CONTAINER',
                                    input this-procedure,
                                    input frame f-import:handle,
                                    input "",
                                    input ?).    
&ELSE
    run value(c-nom-prog-dpc-mg97) (input 'ENABLE', 
                                    input 'CONTAINER',
                                    input this-procedure,
                                    input frame {&FRAME-NAME}:handle,
                                    input "",
                                    input ?).    
&ENDIF

end.

if  c-nom-prog-appc-mg97 <> ""
and c-nom-prog-appc-mg97 <> ? then do:           
    
&IF DEFINED(PGIMP) <> 0 &THEN   
    run value(c-nom-prog-appc-mg97) (input 'ENABLE', 
                                     input 'CONTAINER',
                                     input this-procedure,
                                     input frame f-relat:handle,
                                     input "",
                                     input ?).    
&ELSEIF DEFINED(PGLOG) <> 0 &THEN   
    run value(c-nom-prog-appc-mg97) (input 'ENABLE', 
                                     input 'CONTAINER',
                                     input this-procedure,
                                     input frame f-import:handle,
                                     input "",
                                     input ?).    
&ELSE
    run value(c-nom-prog-appc-mg97) (input 'ENABLE', 
                                     input 'CONTAINER',
                                     input this-procedure,
                                     input frame {&FRAME-NAME}:handle,
                                     input "",
                                     input ?).    
&ENDIF

end.                                       

if  c-nom-prog-upc-mg97 <> ""
and c-nom-prog-upc-mg97 <> ? then do:

&IF DEFINED(PGIMP) <> 0 &THEN   
    run value(c-nom-prog-upc-mg97) (input 'ENABLE', 
                                    input 'CONTAINER',
                                    input this-procedure,
                                    input frame f-relat:handle,
                                    input "",
                                    input ?).    
&ELSEIF DEFINED(PGLOG) <> 0 &THEN   
    run value(c-nom-prog-upc-mg97) (input 'ENABLE', 
                                    input 'CONTAINER',
                                    input this-procedure,
                                    input frame f-import:handle,
                                    input "",
                                    input ?).    
&ELSE
    run value(c-nom-prog-upc-mg97) (input 'ENABLE', 
                                    input 'CONTAINER',
                                    input this-procedure,
                                    input frame {&FRAME-NAME}:handle,
                                    input "",
                                    input ?).    
&ENDIF

end.
   &ENDIF
         
    RUN set-attribute-list ('ENABLED=yes':U).

    RETURN.
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-exit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-exit Method-Library 
PROCEDURE adm-exit :
     RUN notify ('exit':U).
  RETURN.  
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-hide) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-hide Method-Library 
PROCEDURE adm-hide :
  RUN broker-hide IN adm-broker-hdl (THIS-PROCEDURE) NO-ERROR.
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-initialize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-initialize Method-Library 
PROCEDURE adm-initialize :
   RUN broker-initialize IN adm-broker-hdl (THIS-PROCEDURE) NO-ERROR.
   &IF  DEFINED(PGS-QG1) = 0 &THEN 
        &IF "{&frame-name}" <> "" &THEN
             IF  frame {&frame-name}:scrollable THEN
                 ASSIGN frame {&frame-name}:virtual-width-chars  = frame {&frame-name}:width-chars
                        frame {&frame-name}:virtual-height-chars = frame {&frame-name}:height-chars.
        &ENDIF             
   &ENDIF 
   def var c_Aux-var as char no-undo.
   RUN get-link-handle IN adm-broker-hdl (INPUT  THIS-PROCEDURE,
                                          INPUT  "CONTAINER-SOURCE",
                                          OUTPUT c_Aux-var).    
   RUN set-attribute-list ('W-Container-Source = ' + string(c_Aux-var)).                                         

   RUN What-is-the-Page IN adm-broker-hdl (INPUT THIS-PROCEDURE).
   RUN set-attribute-list ('W-Page = ' + RETURN-VALUE).
   &IF  DEFINED(adm-containr) <> 0 &THEN
if  c-nom-prog-dpc-mg97 <> ""
and c-nom-prog-dpc-mg97 <> ? then do:

&IF DEFINED(PGIMP) <> 0 &THEN   
    run value(c-nom-prog-dpc-mg97) (input 'INITIALIZE', 
                                    input 'CONTAINER',
                                    input this-procedure,
                                    input frame f-relat:handle,
                                    input "",
                                    input ?).    
&ELSEIF DEFINED(PGLOG) <> 0 &THEN   
    run value(c-nom-prog-dpc-mg97) (input 'INITIALIZE', 
                                    input 'CONTAINER',
                                    input this-procedure,
                                    input frame f-import:handle,
                                    input "",
                                    input ?).    
&ELSE
    run value(c-nom-prog-dpc-mg97) (input 'INITIALIZE', 
                                    input 'CONTAINER',
                                    input this-procedure,
                                    input frame {&FRAME-NAME}:handle,
                                    input "",
                                    input ?).    
&ENDIF

end.

if  c-nom-prog-appc-mg97 <> ""
and c-nom-prog-appc-mg97 <> ? then do:           
    
&IF DEFINED(PGIMP) <> 0 &THEN   
    run value(c-nom-prog-appc-mg97) (input 'INITIALIZE', 
                                     input 'CONTAINER',
                                     input this-procedure,
                                     input frame f-relat:handle,
                                     input "",
                                     input ?).    
&ELSEIF DEFINED(PGLOG) <> 0 &THEN   
    run value(c-nom-prog-appc-mg97) (input 'INITIALIZE', 
                                     input 'CONTAINER',
                                     input this-procedure,
                                     input frame f-import:handle,
                                     input "",
                                     input ?).    
&ELSE
    run value(c-nom-prog-appc-mg97) (input 'INITIALIZE', 
                                     input 'CONTAINER',
                                     input this-procedure,
                                     input frame {&FRAME-NAME}:handle,
                                     input "",
                                     input ?).    
&ENDIF

end.                                       

if  c-nom-prog-upc-mg97 <> ""
and c-nom-prog-upc-mg97 <> ? then do:

&IF DEFINED(PGIMP) <> 0 &THEN   
    run value(c-nom-prog-upc-mg97) (input 'INITIALIZE', 
                                    input 'CONTAINER',
                                    input this-procedure,
                                    input frame f-relat:handle,
                                    input "",
                                    input ?).    
&ELSEIF DEFINED(PGLOG) <> 0 &THEN   
    run value(c-nom-prog-upc-mg97) (input 'INITIALIZE',
                                                         input 'CONTAINER',
                                    input this-procedure,
                                    input frame f-import:handle,
                                    input "",
                                    input ?).    
&ELSE
    run value(c-nom-prog-upc-mg97) (input 'INITIALIZE', 
                                    input 'CONTAINER',
                                    input this-procedure,
                                    input frame {&FRAME-NAME}:handle,
                                    input "",
                                    input ?).    
&ENDIF

end.
   &ENDIF
   &IF  DEFINED(adm-viewer) <> 0 &THEN 
def var c-container  as char    no-undo.

run Who-Is-The-Container in adm-broker-hdl
    (input this-procedure,
     output c-container).
if  valid-handle(widget-handle(c-container)) then do:
    run pi-retorna-dpc in widget-handle(c-container).
    if  return-value <> ""
    and return-value <> ? then do:                  
        assign c-nom-prog-dpc-mg97 = return-value.
        run value(c-nom-prog-dpc-mg97) (input 'INITIALIZE', 
                                        input 'VIEWER',
                                        input this-procedure,
                                        input frame {&FRAME-NAME}:handle,
                                        input '{&FIRST-EXTERNAL-TABLE}',
        &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN                                 
                                        input ?).
        &ELSE
                                        input (if  avail {&FIRST-EXTERNAL-TABLE} then rowid({&FIRST-EXTERNAL-TABLE}) else ?)).    
        &ENDIF                                 
    end.                                       
    else
        assign c-nom-prog-dpc-mg97 = "".      

    run pi-retorna-appc in widget-handle(c-container).
    if  return-value <> ""
    and return-value <> ? then do:                  
        assign c-nom-prog-appc-mg97 = return-value.
        run value(c-nom-prog-appc-mg97) (input 'INITIALIZE', 
                                         input 'VIEWER',
                                         input this-procedure,
                                         input frame {&FRAME-NAME}:handle,
                                         input '{&FIRST-EXTERNAL-TABLE}',
        &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN                                 
                                         input ?).
        &ELSE
                                         input (if  avail {&FIRST-EXTERNAL-TABLE} then rowid({&FIRST-EXTERNAL-TABLE}) else ?)).    
        &ENDIF                                 
    end.                                       
    else
        assign c-nom-prog-appc-mg97 = "".             

    run pi-retorna-upc in widget-handle(c-container).
    if  return-value <> ""
    and return-value <> ? then do:                  
        assign c-nom-prog-upc-mg97 = return-value.
        run value(c-nom-prog-upc-mg97) (input 'INITIALIZE', 
                                        input 'VIEWER',
                                        input this-procedure,
                                        input frame {&FRAME-NAME}:handle,
                                        input '{&FIRST-EXTERNAL-TABLE}',
        &IF DEFINED(FIRST-EXTERNAL-TABLE) = 0 &THEN                                 
                                        input ?).
        &ELSE
                                        input (if  avail {&FIRST-EXTERNAL-TABLE} then rowid({&FIRST-EXTERNAL-TABLE}) else ?)).    
        &ENDIF                                 
    end.                                       
    else
        assign c-nom-prog-upc-mg97 = "".             
end.
   &ENDIF

   &IF  DEFINED(adm-containr) <> 0 &THEN
        run get-link-handle in adm-broker-hdl
             (input this-procedure,
              input 'page':U,
              output c-ctrl-tab).
        assign h-ctrl-tab = if c-ctrl-tab <> "" then widget-handle(c-ctrl-tab) else ?.
   &ENDIF
    
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-show-errors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-show-errors Method-Library 
PROCEDURE adm-show-errors :

    DEFINE VARIABLE        cntr                  AS INTEGER   NO-UNDO.

    DO cntr = 1 TO ERROR-STATUS:NUM-MESSAGES:
        MESSAGE ERROR-STATUS:GET-MESSAGE(cntr).
    END.

    RETURN.

END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-UIB-mode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-UIB-mode Method-Library 
PROCEDURE adm-UIB-mode :
  RUN broker-UIB-mode IN adm-broker-hdl (THIS-PROCEDURE) NO-ERROR.
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adm-view) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-view Method-Library 
PROCEDURE adm-view :
  
  RUN broker-view IN adm-broker-hdl (THIS-PROCEDURE) NO-ERROR.
  
  ASSIGN THIS-PROCEDURE:PRIVATE-DATA = "OK". 
  
  &IF  DEFINED(adm-viewer) <> 0 &THEN
       assign wh-entry-field = frame {&frame-name}:handle
              wh-entry-field = wh-entry-field:first-child
              wh-entry-field = wh-entry-field:first-child.
       do  while(valid-handle(wh-entry-field)):
           if  wh-entry-field:sensitive = yes 
           and wh-entry-field:type <> 'rectangle' then do:
               apply 'entry' to wh-entry-field.
               leave.
           end.
           else
               assign wh-entry-field = wh-entry-field:next-sibling.    
       end.
  &ENDIF
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dispatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dispatch Method-Library 
PROCEDURE dispatch :
    DEFINE INPUT PARAMETER p-method-name    AS CHARACTER NO-UNDO.
    RUN broker-dispatch IN adm-broker-hdl 
        (THIS-PROCEDURE, p-method-name) NO-ERROR.
    IF RETURN-VALUE = "ADM-ERROR":U THEN RETURN "ADM-ERROR":U.
 
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-attribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-attribute Method-Library 
PROCEDURE get-attribute :
                
  DEFINE INPUT PARAMETER p-attr-name    AS CHARACTER NO-UNDO.
  
  RUN broker-get-attribute IN adm-broker-hdl
      (INPUT THIS-PROCEDURE, INPUT p-attr-name) NO-ERROR.
  
  RETURN RETURN-VALUE.
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-attribute-list) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-attribute-list Method-Library 
PROCEDURE get-attribute-list :
                
  DEFINE OUTPUT PARAMETER p-attr-list AS CHARACTER NO-UNDO.

  RUN broker-get-attribute-list IN adm-broker-hdl
      (INPUT THIS-PROCEDURE, 
       INPUT ?,
       OUTPUT p-attr-list) NO-ERROR.
        
  RETURN.
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-new-state) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE new-state Method-Library 
PROCEDURE new-state :

  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  RUN broker-new-state IN adm-broker-hdl (THIS-PROCEDURE, p-state) NO-ERROR.

  RETURN.
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-notify) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE notify Method-Library 
PROCEDURE notify :
  DEFINE INPUT PARAMETER p-method AS CHARACTER NO-UNDO.

  RUN broker-notify IN adm-broker-hdl (THIS-PROCEDURE, p-method) NO-ERROR.
  IF RETURN-VALUE = "ADM-ERROR":U THEN 
      RETURN "ADM-ERROR":U.  

  RETURN.
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-trad-widgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trad-widgets Method-Library 
PROCEDURE pi-trad-widgets :

  define input param p-wh-frame as widget-handle no-undo.
  
  define var wh-child     as widget-handle no-undo. 
  define var c-aux        as char          no-undo.
  define var i-aux        as integer       no-undo.  
  define var c-contexto   as char          no-undo init "".
  
  assign p-wh-frame:bgcolor = ?
         p-wh-frame:font    = 1
         p-wh-frame = p-wh-frame:first-child
         wh-child   = p-wh-frame:first-child.
  do  while valid-handle(wh-child):
      case wh-child:type:
          when "RADIO-SET" then do:
              if  wh-child:table <> ? then do:
                  assign c-aux = wh-child:radio-buttons.
                  if  wh-child:private-data <> "" 
                  and wh-child:private-data <> ? then 
                      assign c-contexto = wh-child:private-data. 
                  else
                      assign c-contexto = "*".  
                  do  i-aux = 1 to num-entries(wh-child:radio-buttons):
                      if  (i-aux mod 2) <> 0 then do:
                          assign entry(i-aux, c-aux) = replace(entry(i-aux, wh-child:radio-buttons), chr(32), "_").
                      end.
                  end.                                              
                  assign wh-child:radio-buttons = c-aux.
              end.
          end.
          when "BUTTON" then do:
              if  wh-child:label <> ?
              and wh-child:label <> "" then do:
                  assign wh-child:label = trim(replace(wh-child:label, chr(32), "_")).
              end. 
              if  wh-child:help <> "" 
              and wh-child:help <> ? then do:
                  assign wh-child:help = replace(wh-child:help, chr(32), "_")
                         wh-child:tooltip = trim(replace(wh-child:help, chr(32), "_")).
              end.         
              
          end.
      end case.
      assign wh-child = wh-child:next-sibling.
  end.

END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-set-attribute-list) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-attribute-list Method-Library 
PROCEDURE set-attribute-list :
                
  DEFINE INPUT PARAMETER p-attr-list    AS CHARACTER NO-UNDO.

  RUN broker-set-attribute-list IN adm-broker-hdl
      (INPUT THIS-PROCEDURE, INPUT p-attr-list) NO-ERROR.
  
  RETURN.
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-set-position) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-position Method-Library 
PROCEDURE set-position :
  
    DEFINE INPUT PARAMETER p-row    AS DECIMAL NO-UNDO.
    DEFINE INPUT PARAMETER p-col    AS DECIMAL NO-UNDO.

    IF VALID-HANDLE(adm-object-hdl) THEN
    DO:     
      &IF "{&ADM-CONTAINER}":U NE "":U &THEN
        DEFINE VARIABLE parent-hdl AS HANDLE NO-UNDO.
        IF adm-object-hdl:TYPE = "WINDOW":U THEN
        DO:
          IF p-row = 0 THEN p-row = 
            (SESSION:HEIGHT-CHARS - adm-object-hdl:HEIGHT-CHARS) / 2.
          IF p-col = 0 THEN p-col = 
            (SESSION:WIDTH-CHARS - adm-object-hdl:WIDTH-CHARS) / 2.
        END.
        ELSE IF adm-object-hdl:TYPE = "DIALOG-BOX":U THEN
        DO:
          parent-hdl = adm-object-hdl:PARENT.
          IF p-row = 0 THEN p-row = 
            ((SESSION:HEIGHT-CHARS - adm-object-hdl:HEIGHT-CHARS) / 2) -
              parent-hdl:ROW.
          IF p-col = 0 THEN p-col = 
            ((SESSION:WIDTH-CHARS - adm-object-hdl:WIDTH-CHARS) / 2) -
              parent-hdl:COL.
        END.
        IF p-row GE 0 AND p-row < 1 THEN p-row = 1.
        IF p-col GE 0 AND p-col < 1 THEN p-col = 1.
      &ENDIF
      ASSIGN adm-object-hdl:ROW    =   p-row 
             adm-object-hdl:COLUMN =   p-col.
    END.  
    RETURN.
    
END PROCEDURE.
&ENDIF

&ANALYZE-RESUME

&ENDIF
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 

/* ***************************  Main Block  *************************** */

RUN set-attribute-list ('CURRENT-PAGE=0,ADM-OBJECT-HANDLE=':U +
    STRING(adm-object-hdl)). 

PAUSE 0 BEFORE-HIDE.

on  CTRL-TAB anywhere do:
    if  valid-handle(h-ctrl-tab) then do:
        run get-attribute in h-ctrl-tab('folder-labels':U).
        assign i-ctrl-tab-folder = NUM-ENTRIES(return-value,'|':U).
        run get-attribute('current-page':U).
        assign i-ctrl-tab-page = int(return-value) + 1.
        if  i-ctrl-tab-page > i-ctrl-tab-folder then
            run select-page(1).
        else 
            run select-page(i-ctrl-tab-page).
    end.
end.

on  SHIFT-CTRL-TAB anywhere do:
    if  valid-handle(h-ctrl-tab) then do:
        run get-attribute in h-ctrl-tab('folder-labels':U).
        assign i-ctrl-tab-folder = NUM-ENTRIES(return-value,'|':U).
        run get-attribute('current-page':U).
        assign i-ctrl-tab-page = int(return-value) - 1.
        if  i-ctrl-tab-page < 1 then
            run select-page(i-ctrl-tab-folder).
        else
            run select-page(i-ctrl-tab-page).
    end.
end.

&ANALYZE-RESUME

/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-adm-change-page) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-change-page Method-Library 
PROCEDURE adm-change-page :

  RUN broker-change-page IN adm-broker-hdl (INPUT THIS-PROCEDURE) NO-ERROR.
  
  END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-delete-page) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE delete-page Method-Library 
PROCEDURE delete-page :
  
  DEFINE INPUT PARAMETER p-page# AS INTEGER NO-UNDO.
  
  RUN broker-delete-page IN adm-broker-hdl 
      (INPUT THIS-PROCEDURE, INPUT p-page#).
  
  END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-init-object) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-object Method-Library 
PROCEDURE init-object :
  DEFINE INPUT PARAMETER  p-proc-name   AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  p-parent-hdl  AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER  p-attr-list   AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p-proc-hdl    AS HANDLE    NO-UNDO.

  RUN broker-init-object IN adm-broker-hdl
      (INPUT THIS-PROCEDURE, INPUT p-proc-name, INPUT p-parent-hdl,
       INPUT p-attr-list, OUTPUT p-proc-hdl) NO-ERROR.
  RETURN.
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-init-pages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-pages Method-Library 
PROCEDURE init-pages :

  DEFINE INPUT PARAMETER p-page-list      AS CHARACTER NO-UNDO.  

  RUN broker-init-pages IN adm-broker-hdl (INPUT THIS-PROCEDURE,
      INPUT p-page-list) NO-ERROR.
      
  END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-retorna-appc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-appc Method-Library 
PROCEDURE pi-retorna-appc :

  return c-nom-prog-appc-mg97.

END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-retorna-dpc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-dpc Method-Library 
PROCEDURE pi-retorna-dpc :
  return c-nom-prog-dpc-mg97.
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-retorna-upc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-upc Method-Library 
PROCEDURE pi-retorna-upc :
  return c-nom-prog-upc-mg97.
END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-retorna-vars-hlp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-vars-hlp Method-Library 
PROCEDURE pi-retorna-vars-hlp :

define output parameter p-num-topico-hlp as integer no-undo.
define output parameter p-nom-manual-hlp as char format 'x(06)' no-undo.

assign p-num-topico-hlp = i-num-topico-hlp-mg97
       p-nom-manual-hlp = c-nom-manual-hlp-mg97.

END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-select-page) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE select-page Method-Library 
PROCEDURE select-page :

  DEFINE INPUT PARAMETER p-page#     AS INTEGER   NO-UNDO.

  RUN broker-select-page IN adm-broker-hdl (INPUT THIS-PROCEDURE,
      INPUT p-page#) NO-ERROR.
    
  END PROCEDURE.

&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-view-page) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE view-page Method-Library 
PROCEDURE view-page :

  DEFINE INPUT PARAMETER p-page#      AS INTEGER   NO-UNDO.

  RUN broker-view-page IN adm-broker-hdl (INPUT THIS-PROCEDURE,
      INPUT p-page#).
       
  END PROCEDURE.
&ENDIF

&ANALYZE-RESUME

&ENDIF

/* ***************************  Main Block  *************************** */

ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME}
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

PAUSE 0 BEFORE-HIDE.

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK 
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

        assign c-lista = "Por Fam°lia".

        assign c-prog = "bcr003a.w".

  &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
       Run utp/ut-lstit.p (input-output c-lista).
       If c-lista <> "" Then
            Assign select-1:List-item-pairs in frame {&frame-name} = c-lista.
       Else Assign select-1:List-item-pairs in frame {&frame-name} = ?.
  &else
       assign select-1:list-items in frame {&frame-name} = c-lista.
  &endif

  if c-lista <> "" then
    &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
        assign select-1:screen-value in frame {&frame-name} = entry(2, select-1:List-item-pairs in frame {&frame-name}).
    &else
        assign select-1:screen-value in frame {&frame-name} = entry(1, select-1:list-items in frame {&frame-name}).
    &endif

  RUN enable_UI.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* **********************  Internal Procedures  *********************** */

PROCEDURE disable_UI :
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

PROCEDURE enable_UI :
  DISPLAY SELECT-1 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE SELECT-1 /* bt-gerador */ RECT-1 bt-ok bt-cancelar bt-ajuda
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

PROCEDURE local-destroy :
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
run btb/btb918za.p (input no).

END PROCEDURE.

PROCEDURE local-initialize :
 /* run pi-before-initialize. */

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

assign v-cod-prog-gerado = "bcr003a".
Def Var v-Ltr                 As Char No-undo.
Def Var v-Ltr1                As Char No-undo.

&IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
   Run utp/ut-trfrrp.p (input Frame {&FRAME-NAME}:handle).
&endif

&IF  DEFINED(SYSTEM-VARS) = 0 &THEN 

def var c-programa-mg97       as char format "x(08)" no-undo.
def var c-versao-mg97         as char format "x(08)" no-undo.
def var c-modulo-mg97         as char format "x(08)" no-undo.
def var c-titulo-prog-mg97    as char format "x(08)" no-undo.
def var i-num-topico-hlp-mg97 as integer no-undo.
def var c-nom-manual-hlp-mg97 as char format "x(06)" no-undo.

&ENDIF
/*
&IF  'v-cod-programa' = ' ' or  'v-cod-programa' = '' 
 OR  '{2}' = ' ' or  '{2}' = '' 
 OR  '{1}' = '"' or  '{2}' = '"' &THEN 
*/

IF  v-cod-prog-gerado = ' ' or  
     v-cod-prog-gerado = ''  
THEN DO:

    {utp/ut-liter.i A_chamada_do_include_UT9000.I_est†__sem_os_parÉmetros_necess†rios, *}
    Assign v-Ltr = Return-value.
    {utp/ut-liter.i ou_em_local_incorreto._Vocà_deve_editar_o_programa_e_ *}
    Assign v-Ltr1 = Return-value.
    {utp/ut-liter.i verificar_o_nome_do_programa_chamado *}
    message v-Ltr skip
            v-Ltr1 skip
            Return-value
    view-as alert-box error.
    quit.
END.
ELSE    
DO:

    assign c-programa-mg97 = caps(v-cod-prog-gerado)
           c-versao-mg97   = '1.00.00.000'.
    assign c-versao-mg97   = c-prg-vrs.
    find prog_dtsul no-lock
        where prog_dtsul.cod_prog_dtsul = c-programa-mg97 no-error.
    if  avail prog_dtsul then do:
        assign c-titulo-prog-mg97    = prog_dtsul.des_prog_dtsul
               c-nom-prog-upc-mg97   = prog_dtsul.nom_prog_upc
               c-nom-prog-appc-mg97  = prog_dtsul.nom_prog_appc
               c-nom-prog-dpc-mg97   = prog_dtsul.nom_prog_dpc
               i-num-topico-hlp-mg97 = prog_dtsul.num_topico.
        
        IF (c-nom-prog-upc-mg97 <> "") THEN DO:
            RUN men/verifyDisableUPC.p (output lDisableUPC).
            IF lDisableUPC THEN
               ASSIGN c-nom-prog-upc-mg97 = "".
        END. 
        
        find procedimento no-lock
            where procedimento.cod_proced = prog_dtsul.cod_proced no-error.
        if  avail procedimento then do:
            find modul_dtsul no-lock
                where modul_dtsul.cod_modul_dtsul = procedimento.cod_modul_dtsul no-error. 
            if  avail modul_dtsul then do:
                assign c-modulo-mg97         = caps(modul_dtsul.nom_modul_dtsul_menu)
                       c-nom-manual-hlp-mg97 = "dochlp~/" + string(modul_dtsul.num_manual_documen, "999999") + ".hlp".
            end.
        end.
    end.                                                      
    else do:
        assign c-titulo-prog-mg97    = caps(c-programa-mg97)
               c-nom-prog-upc-mg97   = ""
               c-nom-prog-appc-mg97  = ""
               i-num-topico-hlp-mg97 = 0
               c-nom-manual-hlp-mg97 = "dochlp~/000000.hlp".
    end.                 
     
    Run utp/ut-liter.p (input replace(c-titulo-prog-mg97," ","_"),"*","").
    Assign c-titulo-prog-mg97 = Return-value.

    &IF  "{&WINDOW-NAME}" <> "" AND "{&WINDOW-NAME}" <> "CURRENT-WINDOW" &THEN 
         assign {&WINDOW-NAME}:title = c-titulo-prog-mg97  
                                     + " - " 
                                     + c-programa-mg97 
                                     + " - " 
                                     + c-versao-mg97.
    &ELSE
         assign frame {&FRAME-NAME}:title = c-titulo-prog-mg97  
                                          + " - " 
                                          + c-programa-mg97 
                                          + " - " 
                                          + c-versao-mg97.
    &ENDIF
run men/men901za.p (input c-programa-mg97).
if  return-value = "2012" then do:
    {utp/ut-liter.i Usu†rio_sem_permiss∆o_para_acessar_o_programa *}
    message Return-value view-as alert-box  error.
/*  return. */ 
end.                       

if  return-value = "2014" then do:
    {utp/ut-liter.i Programa_n∆o_cadastrado_no_menu *}
    message Return-value view-as alert-box error.
/*  return. */ 
end.

run btb/btb918za.p (input yes).
END.

  /* run pi-after-initialize. */ 

END PROCEDURE.

PROCEDURE pi-selecao :
selecao:
do on error undo selecao, retry selecao:

  if select-1:num-items in frame {&frame-name}<> 0 then do:
    assign c-programa = entry(select-1:lookup(select-1:screen-value in frame {&FRAME-NAME}) in frame {&FRAME-NAME}, c-prog)
           c-programa = "bcp" + "/" + c-programa.

    def var h-prog as handle no-undo.
    
    run value(c-programa) persistent set h-prog.
    if valid-handle(h-prog) THEN
        run dispatch in h-prog ("Initialize":U) no-error.

  end.
end.

hide frame {&FRAME-NAME}.

END PROCEDURE.
