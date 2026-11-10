&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i VB4IN172 2.00.01.015 } /*** "010115" 27/05/2025 16:30:41 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i vb4in172 MUT}
&ENDIF

/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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
{cdp/cdcfgman.i}
def new global shared var gr-it-periodo as rowid no-undo.
def new global shared var gr-item       as rowid no-undo.
def new global shared var gr-pl-prod    as rowid no-undo.
def new global shared var gr-pl-it-calc as rowid no-undo.

def new global shared var i-cd-plano      like pl-prod.cd-plano      no-undo.
def new global shared var c-estabel-plano like estabelec.cod-estabel no-undo.

def var de-saldo    like pl-it-calc.saldo no-undo.
def var wh-pesquisa as handle no-undo.
def var c-resp      as char.
def var c-cod-refer like it-periodo.cod-refer.

DEF VAR l-fn-cb-ref AS LOGICAL NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES pl-it-calc
&Scoped-define FIRST-EXTERNAL-TABLE pl-it-calc


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR pl-it-calc.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-4 RECT-3 RECT-2 
&Scoped-Define DISPLAYED-FIELDS item.it-codigo item.un 
&Scoped-define DISPLAYED-TABLES item
&Scoped-define FIRST-DISPLAYED-TABLE item
&Scoped-Define DISPLAYED-OBJECTS fi-cd-plano c-desc-plano c-cod-estabel ~
c-desc-estab c-estab-dest c-descr fi-obtencao fi-nmb fi-ref cb-ref fi-horiz ~
l-benef fi-saldo fi-quant-segur fi-aloc fi-ponto-repos 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */
&Scoped-define List-3 fi-ref 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE cb-ref AS CHARACTER FORMAT "X(256)":U 
     LABEL "Referància" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-estabel LIKE estabelec.cod-estabel
     LABEL "Estabelecimento":R7 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estab AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-plano AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE c-descr AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 57.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-estab-dest AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estabelec. Priori." 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-aloc AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99" INITIAL 0 
     LABEL "Saldo Aloc.":R12 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fi-cd-plano AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Plano" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-horiz AS CHARACTER FORMAT "X(256)":U 
     LABEL "Horiz. Fixo" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-nmb AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "NMB" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-obtencao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Obtená∆o" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ponto-repos AS DECIMAL FORMAT ">>>>,>>9.9999":U INITIAL 0 
     LABEL "Ponto Repos." 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-quant-segur AS DECIMAL FORMAT "->>>,>>9.99" INITIAL 0 
     LABEL "Quant. Segur.":R20 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-ref AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 17.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-saldo AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99" INITIAL 0 
     LABEL "Saldo":R12 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 112.43 BY 1.33.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 112.29 BY 4.58.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 112.43 BY 1.42.

DEFINE VARIABLE l-benef AS LOGICAL INITIAL no 
     LABEL "Possui Oper Beneficiamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83 NO-UNDO.

DEFINE VARIABLE tb-calc-alter AS LOGICAL INITIAL no 
     LABEL "C†lculo alterado" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.86 BY .67 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     fi-cd-plano AT ROW 1.42 COL 6.72 COLON-ALIGNED
     c-desc-plano AT ROW 1.42 COL 12 COLON-ALIGNED NO-LABEL
     c-cod-estabel AT ROW 1.42 COL 49 COLON-ALIGNED HELP
          ""
          LABEL "Estabelecimento":R7
     c-desc-estab AT ROW 1.42 COL 56.43 COLON-ALIGNED NO-LABEL
     c-estab-dest AT ROW 1.46 COL 105.29 COLON-ALIGNED
     item.it-codigo AT ROW 2.92 COL 6.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     c-descr AT ROW 2.92 COL 23.43 COLON-ALIGNED NO-LABEL
     item.un AT ROW 2.92 COL 81.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     fi-obtencao AT ROW 4.5 COL 50.86 COLON-ALIGNED WIDGET-ID 6
     fi-nmb AT ROW 4.5 COL 75 COLON-ALIGNED WIDGET-ID 10
     fi-ref AT ROW 4.54 COL 13.14 COLON-ALIGNED
     cb-ref AT ROW 4.54 COL 13.29 COLON-ALIGNED
     tb-calc-alter AT ROW 4.75 COL 89
     fi-horiz AT ROW 5.5 COL 75 COLON-ALIGNED WIDGET-ID 12
     l-benef AT ROW 5.5 COL 89 WIDGET-ID 2
     fi-saldo AT ROW 5.54 COL 13.29 COLON-ALIGNED
     fi-quant-segur AT ROW 5.54 COL 50.86 COLON-ALIGNED
     fi-aloc AT ROW 6.54 COL 13.29 COLON-ALIGNED WIDGET-ID 4
     fi-ponto-repos AT ROW 6.54 COL 50.86 COLON-ALIGNED
     RECT-4 AT ROW 1.13 COL 1.57
     RECT-3 AT ROW 4.17 COL 1.72
     RECT-2 AT ROW 2.67 COL 1.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgmfg.pl-it-calc
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 7.92
         WIDTH              = 113.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{utp/ut-glob.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-estabel IN FRAME F-Main
   NO-ENABLE LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE      */
/* SETTINGS FOR FILL-IN c-desc-estab IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-plano IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descr IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-estab-dest IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-ref IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-aloc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cd-plano IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-horiz IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nmb IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-obtencao IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-ponto-repos IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-quant-segur IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-ref IN FRAME F-Main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN fi-saldo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.it-codigo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-benef IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tb-calc-alter IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       tb-calc-alter:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN item.un IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME c-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel V-table-Win
ON F5 OF c-cod-estabel IN FRAME F-Main /* Estabelecimento */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                       &campo=c-cod-estabel
                       &campozoom=cod-estabel
                       &campo2=c-desc-estab
                       &campozoom2=nome}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel V-table-Win
ON LEAVE OF c-cod-estabel IN FRAME F-Main /* Estabelecimento */
DO:
  {include/leave.i &tabela=estabelec
                    &atributo-ref=nome
                    &variavel-ref=c-desc-estab
                    &where="estabelec.cod-estabel= input frame {&frame-name}
                            c-cod-estabel"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-estabel IN FRAME F-Main /* Estabelecimento */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ref
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ref V-table-Win
ON VALUE-CHANGED OF cb-ref IN FRAME F-Main /* Referància */
DO:
  assign c-cod-refer = input frame {&frame-name} cb-ref.
  run pi-calcula-saldo.
  RUN notify ('row-available, record-target':U).
  RUN new-state IN THIS-PROCEDURE ( INPUT "change-ref":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cd-plano
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-plano V-table-Win
ON F5 OF fi-cd-plano IN FRAME F-Main /* Plano */
DO:

   {include/zoomvar.i &prog-zoom="inzoom/z02in318.w"
                       &campo=fi-cd-plano
                       &campozoom=cd-plano
                       &campo2=c-desc-plano
                       &campozoom2=descricao}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-plano V-table-Win
ON LEAVE OF fi-cd-plano IN FRAME F-Main /* Plano */
DO:
  {include/leave.i &tabela=pl-prod
                    &atributo-ref=descricao
                    &variavel-ref=c-desc-plano
                    &where="pl-prod.cd-plano= input frame {&frame-name}
                            fi-cd-plano"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-plano V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cd-plano IN FRAME F-Main /* Plano */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-ref
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ref V-table-Win
ON F5 OF fi-ref IN FRAME F-Main
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=inzoom/z01in375.w
                     &campo=fi-ref
                     &campozoom = cod-refer
                     &parametros= "run pi-seta-inicial in wh-pesquisa
                     (ITEM.it-codigo:screen-value)." }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ref V-table-Win
ON LEAVE OF fi-ref IN FRAME F-Main
DO:
    FOR FIRST referencia 
        WHERE referencia.cod-refer = fi-ref:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK:
        assign c-cod-refer = referencia.cod-refer.
    END.

    run pi-calcula-saldo.
    RUN notify ('row-available, record-target':U).
    RUN new-state IN THIS-PROCEDURE ( INPUT "change-ref":U).
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ref V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-ref IN FRAME F-Main
DO:
    APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /*Funcao que habilita o fill-in de referencia ao inves do combo-box
  Em casos que o cliente possua muitas refer“ncias Ç recomendado o uso do fill-in com zoom
  */
    
  FIND FIRST funcao WHERE funcao.cd-funcao = "SPP-FI-REFER" 
                      AND funcao.ativo     = YES NO-LOCK NO-ERROR.
  IF AVAILABLE funcao THEN
    ASSIGN l-fn-cb-ref = YES.
  ELSE 
    ASSIGN l-fn-cb-ref = NO.
  
  IF l-fn-cb-ref THEN DO:
      IF fi-ref:LOAD-MOUSE-POINTER("image/lupa.cur") IN FRAME {&FRAME-NAME} THEN.
  END.
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "pl-it-calc"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "pl-it-calc"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE i-horizonte AS INTEGER     NO-UNDO.
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  ASSIGN c-cod-estabel:screen-value in frame {&FRAME-NAME} = ""
         c-desc-estab:screen-value  in frame {&FRAME-NAME} = "".

  find pl-prod NO-LOCK where 
       pl-prod.cd-plano = i-cd-plano no-error.
  if avail pl-prod then
     assign fi-cd-plano:screen-value   in frame {&FRAME-NAME} = string(i-cd-plano)
            c-desc-plano:screen-value  in frame {&FRAME-NAME} = pl-prod.descricao.

  find estabelec NO-LOCK where 
       estabelec.cod-estabel = c-estabel-plano no-error.
  if avail estabelec then
     assign c-cod-estabel:screen-value in frame {&FRAME-NAME} = c-estabel-plano
            c-desc-estab:screen-value  in frame {&FRAME-NAME} = estabelec.nome.

 assign c-estab-dest = ""
        fi-obtencao:fgcolor in frame {&frame-name} = ?.

  if avail pl-it-calc then
  find FIRST item NO-LOCK WHERE 
       item.it-codigo = pl-it-calc.it-codigo no-error.
  if avail item then do:
     if pl-it-calc.compr-fabric <> item.compr-fabric then
         assign fi-obtencao:fgcolor in frame {&frame-name} = 12.

     assign item.it-codigo:screen-value in frame {&frame-name} = pl-it-calc.it-codigo
            c-descr:screen-value        in frame {&FRAME-NAME} = item.desc-item
            item.un:screen-value        in frame {&FRAME-NAME} = item.un. 

    IF l-fn-cb-ref THEN DO:
       assign fi-ref:sensitive in frame {&frame-name} = item.tipo-con-est = 4
              fi-ref:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-cod-refer.
    END.
    ELSE DO:
       assign cb-ref:sensitive in frame {&frame-name} = item.tipo-con-est = 4.
    END.
    
    /* Code placed here will execute AFTER standard behavior.    */

     IF pl-prod.log-multi-estabel THEN DO:
        run pi-estab-producao(input  c-estabel-plano,  
                              input  pl-it-calc.it-codigo,
                              output c-estab-dest).                        

     END. 
  end.     

  assign c-estab-dest:screen-value in frame {&FRAME-NAME} = c-estab-dest.

  if c-estab-dest = " " then
       assign c-estab-dest:hidden = yes.     
  ELSE assign c-estab-dest:hidden = no. 

  if avail pl-it-calc then do: 
      ASSIGN i-horizonte = MAX(pl-prod.horiz-fixo,pl-it-calc.horiz-fixo) NO-ERROR.

     assign tb-calc-alter:checked in frame {&frame-name} = pl-it-calc.calc-alter
            fi-obtencao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = {ininc/i01in172.i 4 pl-it-calc.compr-fabric}
            fi-nmb:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(pl-it-calc.niv-mais-bai)
            fi-horiz:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(i-horizonte).
     
  end.
  ELSE DO:
    
       IF AVAILABLE ITEM THEN
           ASSIGN i-horizonte = MAX(pl-prod.horiz-fixo,ITEM.horiz-fixo).
       ELSE ASSIGN i-horizonte = pl-prod.horiz-fixo.

       assign tb-calc-alter:checked in frame {&frame-name} = no
              fi-obtencao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
              fi-nmb:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0"
             fi-horiz:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(i-horizonte).
              
  END.
  if pl-prod.log-multi-estabel then do:
    if avail item      and
       avail estabelec then

        for first item-uni-estab fields (pto-repos horiz-fixo) where
                  item-uni-estab.it-codigo   = item.it-codigo and
                  item-uni-estab.cod-estabel = estabelec.cod-estabel NO-LOCK:
            assign fi-ponto-repos:screen-value in frame {&frame-name} = string(item-uni-estab.pto-repos)
                   fi-horiz:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(MAX(pl-prod.horiz-fixo,item-uni-estab.horiz-fixo)).
        end.
  end.
  else
    if avail pl-it-calc then
        assign fi-ponto-repos:screen-value in frame  {&frame-name} = string(pl-it-calc.pto-repos).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  {utp/ut-liter.i Sim/N∆o *}
  ASSIGN l-benef:FORMAT IN FRAME {&frame-name} = return-value.

  {utp/ut-field.i mgind item cod-refer 1}
  assign cb-ref:label in frame {&frame-name} = return-value
         fi-ref:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgmfg pl-it-calc saldo 1}
  assign fi-saldo:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgmfg pl-it-calc quant-segur 1}
  assign fi-quant-segur:label in frame {&frame-name} = return-value.

  &if defined(bf_man_mrp_override) &then
  {utp/ut-field.i mgmfg pl-it-calc calc-alter 1}
  assign tb-calc-alter:hidden in frame {&frame-name} = no.
  &endif
  
  IF l-fn-cb-ref = YES THEN
      ASSIGN cb-ref:HIDDEN IN FRAME {&FRAME-NAME} = YES
             fi-ref:VISIBLE IN FRAME {&FRAME-NAME} = YES.
  ELSE 
      ASSIGN cb-ref:VISIBLE IN FRAME {&FRAME-NAME} = YES
             fi-ref:HIDDEN IN FRAME {&FRAME-NAME} = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  /*Code placed here will execute AFTER standard behavior.*/

  if avail item THEN
      assign c-descr = item.desc-item
             c-descr:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ITEM.desc-item
             gr-item = rowid(item).
  else 
      ASSIGN c-descr = "".

  assign l-benef = no.

  find first rot-item where 
             rot-item.it-codigo = item.it-codigo no-lock no-error.
  if  avail rot-item THEN
      for each rot-item where 
               rot-item.it-codigo = item.it-codigo no-lock:
          find rot-fabric where 
               rot-fabric.cod-roteiro = rot-item.cod-roteiro AND 
               NOT (rot-fabric.situacao = 2 ) no-lock no-error.
          IF AVAIL rot-fabric AND 
             CAN-FIND (FIRST operacao where 
                             operacao.it-codigo     = "" and 
                             operacao.cod-roteiro   = rot-item.cod-roteiro AND
                             operacao.tipo = 2) THEN DO:
             assign l-benef = yes.
             leave.
          end.
      end.
  else 
      FOR FIRST operacao WHERE operacao.it-codigo = item.it-codigo and   
                 operacao.cod-roteiro  = " " and   
                 operacao.tipo   = 2  no-lock:
           assign l-benef = yes.
      end.
  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
      assign cb-ref:list-item-pairs in frame {&frame-name} = ?.
  &else
      ASSIGN cb-ref:list-items in frame {&frame-name} = ? .
  &endif
  if  available(item) AND item.tipo-con-est = 4 THEN DO:
      find first ref-item where 
                 ref-item.it-codigo = item.it-codigo no-lock no-error.

      if  available(ref-item) THEN do:
          find first referencia where 
                     referencia.cod-refer = ref-item.cod-refer no-lock no-error.
          
          if l-fn-cb-ref then do:
              cb-ref:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.
              
              ASSIGN fi-ref:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ref-item.cod-refer.
              ENABLE fi-ref WITH FRAME {&FRAME-NAME}.
          end.
          else do:
              fi-ref:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.
              
              for  each ref-item where 
                        ref-item.it-codigo = item.it-codigo no-lock:
                   &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                      cb-ref:add-last(ref-item.cod-refer,ref-item.cod-refer) in frame {&frame-name} .
                   &else
                      cb-ref:add-last(ref-item.cod-refer) in frame {&frame-name} .
                   &endif
              
              end.
              find first ref-item where 
                     ref-item.it-codigo = item.it-codigo no-lock no-error.
              if  available(ref-item) THEN
                  assign cb-ref:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = referencia.cod-refer.
              
              enable cb-ref with frame {&frame-name}. 
          end.
      end.
      else do:
          if l-fn-cb-ref then do:
              
              ASSIGN fi-ref:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

              disable fi-ref cb-ref with frame {&frame-name}.
              
              ASSIGN cb-ref:HIDDEN  IN FRAME {&FRAME-NAME} = TRUE
                     fi-ref:VISIBLE IN FRAME {&FRAME-NAME} = TRUE.
          end.
          else do:
              &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                  assign cb-ref:LIST-ITEM-PAIRS in frame {&frame-name} = ?
                         cb-ref:SENSITIVE IN frame {&frame-name} = NO.          
              &else
                  assign cb-ref:list-items in frame {&frame-name} = ?
                         cb-ref:SENSITIVE IN frame {&frame-name} = NO.
              &endif
          end.
      end.
  end.
  ELSE DO:
      if l-fn-cb-ref then do:
      
          ASSIGN fi-ref:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

          disable fi-ref cb-ref with frame {&frame-name}.
          
          ASSIGN cb-ref:HIDDEN  IN FRAME {&FRAME-NAME} = TRUE
                 fi-ref:VISIBLE IN FRAME {&FRAME-NAME} = TRUE.
      end.
      else do:
          &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
              assign cb-ref:LIST-ITEM-PAIRS in frame {&frame-name} = ?
                     cb-ref:SENSITIVE IN frame {&frame-name} = NO.          
          &else
              assign cb-ref:list-items in frame {&frame-name} = ?
                     cb-ref:SENSITIVE IN frame {&frame-name} = NO.
          &endif
      end.
  END.
  
  if l-fn-cb-ref then do:
      assign c-cod-refer = fi-ref:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  end.
  else do:
      disp cb-ref with frame {&frame-name}.
      
      &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
          assign c-cod-refer = IF NOT (cb-ref:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = ?) 
                               THEN cb-ref:SCREEN-VALUE ELSE " ":U.  
      &else
          assign c-cod-refer = IF NOT (cb-ref:list-items IN FRAME {&FRAME-NAME} = ?) 
                               THEN cb-ref:SCREEN-VALUE ELSE " ":U.
      &endif
  end.
  
  if avail item then do:
     IF l-fn-cb-ref THEN DO:
         assign fi-ref:sensitive in frame {&frame-name} = item.tipo-con-est = 4.
         APPLY 'leave' to fi-ref in frame {&frame-name}.
     END.
     ELSE DO:
         APPLY 'value-changed' to cb-ref in frame {&frame-name}.
         assign cb-ref:sensitive in frame {&frame-name} = item.tipo-con-est = 4.
     END.
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-saldo V-table-Win 
PROCEDURE pi-calcula-saldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN local-display-fields.

if avail item then do:
    
     IF pl-prod.log-multi-estabel OR item.tipo-con-est = 4 THEN DO:
         FIND first pl-ext-item where 
                    pl-ext-item.it-codigo = item.it-codigo AND 
                    pl-ext-item.cod-refer = c-cod-refer AND
                    pl-ext-item.num-calc-plano = pl-prod.num-calc-plano AND
                    pl-ext-item.cod-estabel = INPUT FRAME {&FRAME-NAME} c-cod-estabel  no-lock no-error.
         if avail pl-ext-item then 
            assign fi-saldo = pl-ext-item.qt-saldo 
                   fi-aloc  = pl-ext-item.dec-1.                           
        else 
           assign fi-saldo = 0  
                  fi-aloc  = 0.

     END.
     ELSE DO:
         FIND first pl-it-calc where 
                    pl-it-calc.it-codigo = item.it-codigo and
                    pl-it-calc.cd-plano = pl-prod.cd-plano no-lock no-error.
         if avail pl-it-calc then 
            assign fi-saldo = pl-it-calc.saldo
                   fi-aloc  = pl-it-calc.saldo-aloc.
         else 
            assign fi-saldo = 0 
                   fi-aloc  = 0.
     END.  
     /*c†lculo da quantidade de seguranca*/
     FIND FIRST res-aber NO-LOCK USE-INDEX planejamento
         WHERE res-aber.num-calc-plano  = pl-prod.num-calc-plano
         AND res-aber.cod-estabel       = INPUT FRAME {&FRAME-NAME} c-cod-estabel
         AND res-aber.it-codigo         = item.it-codigo
         AND res-aber.nr-ord-produ      = 0
         AND res-aber.item-pai          = ""
         AND res-aber.cod-roteiro       = ""
         AND res-aber.op-codigo         = 0
         AND res-aber.tipo-res          = 5
         AND res-aber.cod-refer         = c-cod-refer NO-ERROR.
     IF AVAIL res-aber THEN
        ASSIGN fi-quant-segur = res-aber.quantidade.
     ELSE 
        ASSIGN fi-quant-segur = 0.
END.

DISPLAY fi-saldo fi-aloc fi-quant-segur WITH FRAME {&FRAME-NAME}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-estab-producao V-table-Win 
PROCEDURE pi-estab-producao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  parameter c-est-ori       like estabelec.cod-estabel no-undo.
    def input  parameter c-it-codigo     like item.it-codigo        no-undo. 
    def output parameter c-estab-dest    like estabelec.cod-estabel no-undo.

    def VAR l-outro-estabel as logical initial no      no-undo.
    def var i-tempo-transp  as integer initial 0       no-undo.
    def var i-prioridade                 as integer no-undo.
    def var c-prior-est                  as char    no-undo.

    assign l-outro-estabel = no
           i-tempo-transp  = 0
           c-estab-dest    = "".


    for first item-uni-estab fields (it-codigo cod-estabel int-1) 
        where item-uni-estab.it-codigo   = c-it-codigo 
          and item-uni-estab.cod-estabel = c-est-ori no-lock: end.

    if avail item-uni-estab then 
       assign i-prioridade = item-uni-estab.int-1
              c-prior-est  = c-est-ori.

    for each item-uni-estab fields (it-codigo cod-estabel int-1 demanda) where
             item-uni-estab.it-codigo = c-it-codigo no-lock:

        IF NOT CAN-FIND(FIRST pl-prod-estab NO-LOCK
                        WHERE pl-prod-estab.cd-plano = i-cd-plano
                          AND pl-prod-estab.cod-estabel = item-uni-estab.cod-estabel) THEN
            NEXT.

        if item-uni-estab.demanda = 2 then next.                    

        if i-prioridade > item-uni-estab.int-1 then 
           assign  i-prioridade   = item-uni-estab.int-1
                   c-prior-est    = item-uni-estab.cod-estabel.

    end.

    if c-prior-est = c-est-ori 
    then assign l-outro-estabel = no.
    else assign l-outro-estabel = yes.

    if l-outro-estabel = yes then do:

       /* Analisa qual o estabelecimento mais pr¢ximo do origem */
       for first matriz-estab fields (cod-estabel-ori cod-estabel-des tempo-trans) 
                 use-index id where 
                 matriz-estab.cod-estabel-ori  = c-est-ori and 
                 matriz-estab.cod-estabel-des  = c-prior-est  no-lock. end.
       if avail matriz-estab then
          assign i-tempo-transp = matriz-estab.tempo-trans.      

       for each item-uni-estab fields (it-codigo cod-estabel int-1 demanda)
                use-index codigo  where
                item-uni-estab.it-codigo = c-it-codigo and
                item-uni-estab.int-1     = i-prioridade no-lock:

          if item-uni-estab.demanda = 2 then next.      

          for first matriz-estab fields (cod-estabel-ori cod-estabel-des tempo-trans) 
                 use-index id where 
                 matriz-estab.cod-estabel-ori  = c-est-ori and 
                 matriz-estab.cod-estabel-des  = item-uni-estab.cod-estabel  no-lock. end.
          if avail matriz-estab and i-tempo-transp > matriz-estab.tempo-trans then
              assign c-prior-est    = item-uni-estab.cod-estabel
                     i-tempo-transp = matriz-estab.tempo-trans.                        
       end.                                  
    end.  

    assign c-estab-dest = c-prior-est.             

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "pl-it-calc"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

