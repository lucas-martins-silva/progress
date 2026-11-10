&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
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
{include/i-prgvrs.i V28IN245 2.00.00.016}  /*** 010016 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V28IN245 MUT}
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
{cdp/cdcfgmat.i}

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
    def buffer b-natur-oper  for natur-oper.
    def buffer b2-natur-oper for natur-oper.

    def var l-terceiros    as logical no-undo.

    def var v-row-parent   as rowid   no-undo.
    def var l-novo-reg     as logical initial no.
    def var c-tipo         as char    no-undo.
    def var l-setou-campo  as logical no-undo.

    def var c-lista-itens  as char format "x(150)" no-undo.
    def var i-tp-oper-terc as i no-undo.

    def var c-item1        as char.
    def var c-item2        as char.
    def var c-item3        as char.
    def var c-item4        as char.
    def var c-item5        as char.
    def var c-item6        as char.

    def var c-lista-trib    as char format "x(150)" no-undo.
    def var i-tp-tributacao as INT no-undo.
    def var c-trib1         as char.
    def var c-trib2         as char.

    def var c-char-2       as char    no-undo.
    def var c-char-2-aux   as char    no-undo.

    def var l-primeiro  as logical init yes.
    DEF VAR l-copia     AS LOGICAL INIT YES NO-UNDO.
    DEF VAR l-alterado  AS LOGICAL INIT YES NO-UNDO.
    def var c-formato   as CHARACTER .
    
     DEF VAR c-tp-oper-terc  AS HANDLE NO-UNDO. 
     DEF VAR c-dec-1         AS HANDLE NO-UNDO. 
     DEF VAR c-nat-comp      AS HANDLE NO-UNDO. 
     DEF VAR c-desc-nat      AS HANDLE NO-UNDO. 
     DEF VAR c-tp-tributacao AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES natur-oper
&Scoped-define FIRST-EXTERNAL-TABLE natur-oper


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR natur-oper.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS natur-oper.terceiros natur-oper.dec-1 ~
natur-oper.auto-ce natur-oper.nat-comp natur-oper.transf ~
natur-oper.imp-nota natur-oper.emite-duplic natur-oper.log-oper-triang 
&Scoped-define ENABLED-TABLES natur-oper
&Scoped-define FIRST-ENABLED-TABLE natur-oper
&Scoped-Define ENABLED-OBJECTS rt-mold-2 rt-mold-3 RECT-1 RECT-2 
&Scoped-Define DISPLAYED-FIELDS natur-oper.nat-ativa natur-oper.terceiros ~
natur-oper.dec-1 natur-oper.auto-ce natur-oper.nat-comp natur-oper.transf ~
natur-oper.imp-nota natur-oper.emite-duplic natur-oper.log-oper-triang 
&Scoped-define DISPLAYED-TABLES natur-oper
&Scoped-define FIRST-DISPLAYED-TABLE natur-oper
&Scoped-Define DISPLAYED-OBJECTS cb-tp-oper-terc c-desc-nat-comp ~
cb-tp-tributacao rs-op-ent-fut fill-texto 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS cb-tp-oper-terc cb-tp-tributacao 
&Scoped-define ADM-ASSIGN-FIELDS cb-tp-oper-terc natur-oper.transf ~
cb-tp-tributacao 
&Scoped-define ADM-MODIFY-FIELDS cb-tp-oper-terc cb-tp-tributacao 

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
DEFINE VARIABLE cb-tp-oper-terc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Combo 1" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 21.14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tp-tributacao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Combo 2" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-nat-comp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24.57 BY .88 NO-UNDO.

DEFINE VARIABLE fill-texto AS CHARACTER FORMAT "X(256)":U INITIAL "Opera‡äes de Entrega Futura" 
      VIEW-AS TEXT 
     SIZE 21 BY .67 NO-UNDO.

DEFINE VARIABLE rs-op-ent-fut AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "1", 1
     SIZE 36 BY 3 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 58 BY 5.42.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 43 BY 3.75.

DEFINE RECTANGLE rt-mold-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 58 BY 5.25.

DEFINE RECTANGLE rt-mold-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 27.43 BY 10.67.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cb-tp-oper-terc AT ROW 1.38 COL 49 COLON-ALIGNED
     natur-oper.nat-ativa AT ROW 1.42 COL 3
          VIEW-AS TOGGLE-BOX
          SIZE 11.57 BY .83
     natur-oper.terceiros AT ROW 2.25 COL 3
          VIEW-AS TOGGLE-BOX
          SIZE 24.57 BY .83
     natur-oper.dec-1 AT ROW 2.38 COL 49 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     natur-oper.auto-ce AT ROW 3.08 COL 3
          VIEW-AS TOGGLE-BOX
          SIZE 18.57 BY .83
     natur-oper.nat-comp AT ROW 3.38 COL 49 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
     c-desc-nat-comp AT ROW 3.38 COL 59.57 COLON-ALIGNED NO-LABEL
     natur-oper.transf AT ROW 3.92 COL 3
          VIEW-AS TOGGLE-BOX
          SIZE 24 BY .83
     cb-tp-tributacao AT ROW 4.38 COL 49 COLON-ALIGNED
     natur-oper.imp-nota AT ROW 4.75 COL 3
          VIEW-AS TOGGLE-BOX
          SIZE 19.86 BY .83
     natur-oper.emite-duplic AT ROW 5.58 COL 3
          VIEW-AS TOGGLE-BOX
          SIZE 20.14 BY .83
     natur-oper.log-oper-triang AT ROW 6.42 COL 3
          VIEW-AS TOGGLE-BOX
          SIZE 22.43 BY .83
     rs-op-ent-fut AT ROW 7.71 COL 43 NO-LABEL
     fill-texto AT ROW 6.75 COL 37 COLON-ALIGNED NO-LABEL
     rt-mold-2 AT ROW 1 COL 29
     rt-mold-3 AT ROW 1 COL 1
     RECT-1 AT ROW 6.25 COL 29
     RECT-2 AT ROW 7.25 COL 37
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.natur-oper
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 10.67
         WIDTH              = 86.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-nat-comp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-tp-oper-terc IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-tp-tributacao IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN fill-texto IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fill-texto:HIDDEN IN FRAME f-main           = TRUE
       fill-texto:READ-ONLY IN FRAME f-main        = TRUE.

/* SETTINGS FOR TOGGLE-BOX natur-oper.nat-ativa IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       RECT-1:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       RECT-2:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR RADIO-SET rs-op-ent-fut IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       rs-op-ent-fut:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX natur-oper.transf IN FRAME f-main
   2                                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME natur-oper.auto-ce
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.auto-ce V-table-Win
ON VALUE-CHANGED OF natur-oper.auto-ce IN FRAME f-main /* CE Autom tico */
DO:
  if   natur-oper.auto-ce:checked in frame {&frame-name} = yes and
      (cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item2 
    or cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item4  
    or cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item5 
    or cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item6) then do:
       enable natur-oper.dec-1 with frame {&frame-name}.
  end.     
  else disable natur-oper.dec-1 with frame {&frame-name}.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-tp-oper-terc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tp-oper-terc V-table-Win
ON VALUE-CHANGED OF cb-tp-oper-terc IN FRAME f-main /* Combo 1 */
DO:
  APPLY "VALUE-CHANGED" to natur-oper.terceiros in frame {&frame-name}. 
  if   natur-oper.auto-ce:checked in frame {&frame-name} = yes and
      (cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item2 
    or cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item4  
    or cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item5 
    or cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item6) then do:
       enable natur-oper.dec-1 with frame {&frame-name}.
  end.     
  else disable natur-oper.dec-1 with frame {&frame-name}.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.log-oper-triang
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.log-oper-triang V-table-Win
ON VALUE-CHANGED OF natur-oper.log-oper-triang IN FRAME f-main /* Opera‡Æo Triangular */
DO:
    assign natur-oper.nat-comp:sensitive in frame {&frame-name} = self:checked.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.nat-comp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.nat-comp V-table-Win
ON F5 OF natur-oper.nat-comp IN FRAME f-main /* Natureza Complementar */
DO:

    {include/zoomvar.i &prog-zoom=inzoom/z01in245.w
                       &campo=natur-oper.nat-comp
                       &campozoom=nat-operacao}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.nat-comp V-table-Win
ON LEAVE OF natur-oper.nat-comp IN FRAME f-main /* Natureza Complementar */
DO:    
    {include/leave.i &tabela=b-natur-oper
                     &atributo-ref=denominacao
                     &variavel-ref=c-desc-nat-comp
                     &where="b-natur-oper.nat-operacao = input frame {&frame-name} natur-oper.nat-comp"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.nat-comp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF natur-oper.nat-comp IN FRAME f-main /* Natureza Complementar */
DO:

    apply "F5" to self.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-op-ent-fut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-op-ent-fut V-table-Win
ON VALUE-CHANGED OF rs-op-ent-fut IN FRAME f-main
DO:
  
   &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN DO: 
       
       APPLY "VALUE-CHANGED" to natur-oper.terceiros in frame {&frame-name}.
       ASSIGN INPUT FRAME {&FRAME-NAME} rs-op-ent-fut.
        CASE rs-op-ent-fut:
              WHEN  1  THEN DO:
                    ASSIGN natur-oper.dec-1:SENSITIVE    = YES
                           natur-oper.auto-ce:SENSITIVE  = YES
                           natur-oper.terceiro:SENSITIVE = YES.
                    IF l-alterado = NO THEN
                        ASSIGN  natur-oper.terceiro:CHECKED IN FRAME {&frame-name}  = NO.
                             
              END.
        
              WHEN 2 THEN DO:
                  ASSIGN natur-oper.terceiro:SENSITIVE = NO
                         natur-oper.dec-1:SENSITIVE    = NO
                         natur-oper.auto-ce:SENSITIVE  = NO
                         natur-oper.terceiro:CHECKED IN FRAME {&frame-name}  = YES
                         cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item1
                         cb-tp-oper-terc:SENSITIVE   = NO
                         natur-oper.transf:SENSITIVE = NO.

               END.
        
              WHEN  3  THEN DO:
                  ASSIGN natur-oper.terceiro:SENSITIVE = NO
                         natur-oper.dec-1:SENSITIVE    = NO
                         natur-oper.auto-ce:SENSITIVE  = NO
                         natur-oper.terceiro:CHECKED IN FRAME {&frame-name}  = YES
                         cb-tp-oper-terc:screen-value IN frame {&frame-name} = c-item2
                         cb-tp-oper-terc:SENSITIVE   = NO
                         natur-oper.transf:SENSITIVE = NO.
               END.
             
          END CASE.
        END.
   ASSIGN l-alterado = NO.     
   &endif
   
 END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.terceiros
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.terceiros V-table-Win
ON VALUE-CHANGED OF natur-oper.terceiros IN FRAME f-main /* Opera‡Æo com Terceiros */
DO:
   
  if input frame {&frame-name} natur-oper.terceiros = no then do with frame {&frame-name}:
      enable  natur-oper.transf.
      ASSIGN natur-oper.auto-ce:CHECKED IN FRAME {&FRAME-NAME} = FALSE.
      disable natur-oper.auto-ce.
      disable cb-tp-oper-terc.
      disable natur-oper.dec-1.
       
      {utp/ut-liter.i Remessa_Beneficiamento mce R}
      assign cb-tp-oper-terc:screen-value = trim(return-value).
   
  end.    
  else do:
      disable natur-oper.transf with frame {&frame-name}.
      enable natur-oper.auto-ce with frame {&frame-name}.
      enable cb-tp-oper-terc with frame {&frame-name}.
      if   natur-oper.auto-ce:checked in frame {&frame-name} = yes and
          (cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item2 
        or cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item4  
        or cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item5 
        or cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item6) then 
           enable natur-oper.dec-1 with frame {&frame-name}.
      else disable natur-oper.dec-1 with frame {&frame-name}.      
  end.    
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.transf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.transf V-table-Win
ON VALUE-CHANGED OF natur-oper.transf IN FRAME f-main /* Opera‡äes Transferˆncia */
DO:
  APPLY "VALUE-CHANGED" to natur-oper.terceiros in frame {&frame-name}.
  if input frame {&frame-name} natur-oper.transf = no then do with frame {&frame-name}:
      enable  natur-oper.terceiros.
  end.
  else do with frame {&FRAME-NAME}:
      disable natur-oper.terceiros.
              
  end.    

  if input frame {&frame-name} natur-oper.transf = yes and
     param-global.modulo-mp then do with frame {&frame-name}:
     enable  natur-oper.nat-comp.
     assign natur-oper.nat-comp:format in frame {&FRAME-NAME} = "x.xx-xxx". 
     
     /*{cdp/cd9998.i}*/
  end.
  else do with frame {&FRAME-NAME}:
      if  not input frame {&frame-name} natur-oper.log-oper-triang then do:
          disable natur-oper.nat-comp.
          display "" @ natur-oper.nat-comp.
      end.
  end.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

    {utp/ut-field.i mgind natur-oper tp-oper-terc 1}
    assign cb-tp-oper-terc:label in frame {&frame-name} = trim(return-value).
    
    {utp/ut-liter.i Varia‡Æo_Valor_Itens_Terceiros * L}
    assign natur-oper.dec-1:label in frame {&frame-name} = trim(return-value).

    assign natur-oper.dec-1:format in frame {&frame-name} = ">>9.99":U.

    if natur-oper.nat-comp:load-mouse-pointer("image/lupa.cur")
        in frame {&frame-name} then .

    {utp/ut-field.i mgind natur-oper tipo-trib 1}
    assign cb-tp-tributacao:label in frame {&frame-name} = trim(return-value).

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
  {src/adm/template/row-list.i "natur-oper"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "natur-oper"}

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
  HIDE FRAME f-main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  
  if {ininc/i06in245.i 06 c-tipo} = 2 then
      assign natur-oper.imp-nota:checked in frame {&frame-name} = no.
  
  if l-terceiros then                    
      assign natur-oper.transf:checked in frame {&frame-name} = no.
      
  assign natur-oper.terceiros:sensitive in frame {&frame-name} = yes
         natur-oper.transf:sensitive in frame {&frame-name} = yes
         natur-oper.auto-ce:checked in frame {&frame-name} = false.
  
  disable cb-tp-oper-terc with frame {&frame-name}.
  disable natur-oper.auto-ce with frame {&frame-name}.
  
  /* Code placed here will execute AFTER standard behavior.    */

  {utp/ut-liter.i Altera_Valor_Itens_Terc * R}
  assign natur-oper.auto-ce:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i Remessa_Beneficiamento mce R}
  assign cb-tp-oper-terc:screen-value = return-value.

  {utp/ut-liter.i Isento mce R}
  assign cb-tp-tributacao:screen-value = return-value.

  
   &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN  
      {utp/ut-liter.i Opera‡äes_de_Entrega_Futura * R}
      assign fill-texto:SCREEN-VALUE = RETURN-VALUE.
   &endif
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  
  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}

  if input frame {&frame-name} cb-tp-oper-terc = c-item1 then 
      assign i-tp-oper-terc = 1.
  if input frame {&frame-name} cb-tp-oper-terc = c-item2 then
      assign i-tp-oper-terc = 2.
  if input frame {&frame-name} cb-tp-oper-terc = c-item3 then
      assign i-tp-oper-terc = 3.
  if input frame {&frame-name} cb-tp-oper-terc = c-item4 then
      assign i-tp-oper-terc = 4.
  if input frame {&frame-name} cb-tp-oper-terc = c-item5 then
      assign i-tp-oper-terc = 5.
  if input frame {&frame-name} cb-tp-oper-terc = c-item6 then
      assign i-tp-oper-terc = 6.
  if input frame {&frame-name} cb-tp-tributacao = c-trib1 then
      assign i-tp-tributacao = 1.
  if input frame {&frame-name} cb-tp-tributacao = c-trib2 then
      assign i-tp-tributacao = 2.
  
  &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN 
       ASSIGN INPUT FRAME {&FRAME-NAME} rs-op-ent-fut.
       ASSIGN l-copia = NO
              l-alterado = YES.
  
  &endif
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  
&IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
 
       CASE rs-op-ent-fut:
       WHEN  1  THEN DO:
           ASSIGN natur-oper.ind-entfut  = NO
                  natur-oper.ind-est-qtd = NO.
       END.
       WHEN 2 THEN DO:
           ASSIGN natur-oper.ind-entfut  = YES
                  natur-oper.ind-est-qtd = NO.
       END.
       WHEN  3  THEN DO:
           ASSIGN natur-oper.ind-entfut  = NO
                  natur-oper.ind-est-qtd = YES.
       END.
   
   END CASE.
   
  &endif  
  if RETURN-VALUE = 'ADM-ERROR':U then 
      RETURN 'ADM-ERROR':U.

  assign c-char-2-aux = if trim(natur-oper.char-2) <> ""
        then natur-oper.char-2
        else "                    ":U.
           
  assign natur-oper.tp-oper-terc = i-tp-oper-terc         
         natur-oper.tipo-trib    = i-tp-tributacao.
  
 /*Inicializa natureza como utilizada pelo recebimento*/
  if adm-new-record then 
    assign natur-oper.uso       = 2 
           natur-oper.calc-auto = no 
           natur-oper.atual-est = no  
           natur-oper.auto-est  = no.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF '{&bf_mat_versao_ems}' >= '2.062' &THEN  
    ASSIGN l-copia    = YES
           l-alterado = YES.
           
&endif
/* Dispatch standard ADM method.    */         
RUN dispatch IN THIS-PROCEDURE ('copy-record':U).

 &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN   
  APPLY "VALUE-CHANGED" to rs-op-ent-fut in frame {&frame-name}.                                                 
        IF adm-new-record = NO AND l-copia = YES  THEN DO:                                     
          IF natur-oper.ind-entfut = NO AND natur-oper.ind-est-qtd = NO THEN                   
                ASSIGN rs-op-ent-fut:SCREEN-VALUE in frame {&frame-name} = STRING(1).          
            ELSE IF natur-oper.ind-entfut = YES AND natur-oper.ind-est-qtd = NO THEN           
                    ASSIGN rs-op-ent-fut:SCREEN-VALUE in frame {&frame-name} = STRING(2).      
                 ELSE IF natur-oper.ind-entfut = NO AND natur-oper.ind-est-qtd = YES THEN      
                        ASSIGN rs-op-ent-fut:SCREEN-VALUE in frame {&frame-name} = STRING(3).  
                      ELSE                                                                     
                        ASSIGN rs-op-ent-fut:SCREEN-VALUE in frame {&frame-name} = STRING(1).  
        END.                                                                                   
                                                                                               
        ASSIGN l-copia = NO
               l-alterado = YES.                                                                   
                                                                                               
 &endif                                                                                        
                                                                                               

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

    assign l-novo-reg = no
           l-setou-campo = no.

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
 
  &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN  
      
      DISABLE natur-oper.dec-1
              rs-op-ent-fut with frame {&frame-name}.
     
  &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/


  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  

    if available natur-oper then do with frame {&frame-name}:
        if natur-oper.tp-oper-terc = 1 then do:
            {utp/ut-liter.i Remessa_Beneficiamento mce R}
            assign cb-tp-oper-terc:screen-value = return-value.
        end.
        if natur-oper.tp-oper-terc = 2 then do:
            {utp/ut-liter.i Retorno_Beneficiamento mce R}
            assign cb-tp-oper-terc:screen-value = return-value.
        end.
        if natur-oper.tp-oper-terc = 3 then do:
            {utp/ut-liter.i Remessa_Consigna‡Æo mce R}
            assign cb-tp-oper-terc:screen-value = return-value.
        end.
        if natur-oper.tp-oper-terc = 4 then do:
            {utp/ut-liter.i Faturamento_Consigna‡Æo mce R}
            assign cb-tp-oper-terc:screen-value = return-value.
        end.
        if natur-oper.tp-oper-terc = 5 then do:
            {utp/ut-liter.i Devolu‡Æo_Consigna‡Æo mce R}
            assign cb-tp-oper-terc:screen-value = return-value.
        end.
        if natur-oper.tp-oper-terc = 6 then do:
            {utp/ut-liter.i Reajuste_Pre‡o mce R}
            assign cb-tp-oper-terc:screen-value = return-value.
        end.
        if natur-oper.tipo-trib = 1 then do:
            {utp/ut-liter.i Isento mce R}
            assign cb-tp-tributacao:screen-value = return-value.
        end.
        if natur-oper.tipo-trib = 2 then do:
            {utp/ut-liter.i Normal mce R}
            assign cb-tp-tributacao:screen-value = return-value.
        end.
    end.
    else do with frame {&frame-name}:
        {utp/ut-liter.i Remessa_Beneficiamento mce R}
        assign cb-tp-oper-terc:screen-value = return-value.
        {utp/ut-liter.i Isento mce R}
        assign cb-tp-tributacao:screen-value = return-value.        
    end.
    {utp/ut-liter.i Altera_Valor_Itens_Terc * R}
    assign natur-oper.auto-ce:label in frame {&frame-name} = return-value.
    find b-natur-oper where
         b-natur-oper.nat-operacao = input frame {&frame-name} natur-oper.nat-comp
         no-lock no-error.
    if avail b-natur-oper then do:    
       assign c-desc-nat-comp:screen-value in frame {&frame-name} =
       if available b-natur-oper then
            b-natur-oper.denominacao
       else "":U.
    end.

  &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN  
       ASSIGN l-copia = YES.
       IF adm-new-record = NO AND l-copia = YES  THEN DO:
           IF natur-oper.ind-entfut = NO AND natur-oper.ind-est-qtd = NO THEN       
               ASSIGN rs-op-ent-fut:SCREEN-VALUE in frame {&frame-name} = STRING(1).                       
           ELSE IF natur-oper.ind-entfut = YES AND natur-oper.ind-est-qtd = NO THEN
                   ASSIGN rs-op-ent-fut:SCREEN-VALUE in frame {&frame-name} = STRING(2)
                          natur-oper.auto-ce:SENSITIVE IN FRAME {&frame-name} = NO.                       
                ELSE IF natur-oper.ind-entfut = NO AND natur-oper.ind-est-qtd = YES THEN 
                       ASSIGN rs-op-ent-fut:SCREEN-VALUE in frame {&frame-name} = STRING(3)
                              natur-oper.auto-ce:SENSITIVE IN FRAME {&frame-name} = NO.  
                     ELSE
                       ASSIGN rs-op-ent-fut:SCREEN-VALUE in frame {&frame-name} = STRING(1).
         END.
       ASSIGN l-copia = NO
              l-alterado = YES. 
  &endif
  
  IF i-pais-impto-usuario <> 1 THEN DO:
       ASSIGN rs-op-ent-fut:HIDDEN IN FRAME {&FRAME-NAME} = YES
              fill-texto:HIDDEN IN FRAME {&FRAME-NAME}    = YES
              rect-1:HIDDEN IN FRAME {&FRAME-NAME}        = YES
              rect-2:HIDDEN IN FRAME {&FRAME-NAME}        = YES.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  /*if adm-new-record = yes then*/
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
 
  if avail natur-oper and natur-oper.terceiros then do:
      enable natur-oper.auto-ce with frame {&frame-name}.
      enable cb-tp-oper-terc with frame {&frame-name}.
      disable natur-oper.transf with frame {&frame-name}.
  end.    
  else do:
      enable  natur-oper.transf with frame {&frame-name}.
      disable natur-oper.auto-ce with frame {&frame-name}.
      disable cb-tp-oper-terc with frame {&frame-name}.
  end.    

  if avail natur-oper and natur-oper.transf = no then do with frame {&frame-name}:
      enable  natur-oper.terceiros.
  end.
  else do with frame {&FRAME-NAME}:
      disable natur-oper.terceiros.
  end.  
  
&IF '{&bf_mat_versao_ems}' >= '2.062' &THEN  
    APPLY "VALUE-CHANGED" to natur-oper.terceiros in frame {&frame-name}.
    ENABLE rs-op-ent-fut with frame {&FRAME-NAME}.
     IF adm-new-record = YES AND l-copia = NO THEN  DO:
         ASSIGN rs-op-ent-fut:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING (1).
     END.
     ASSIGN l-alterado = YES.
 &endif
     assign l-novo-reg = yes.
 run pi-inicializa-campo (yes).

 IF i-pais-impto-usuario <> 1 THEN DO:
     ASSIGN rs-op-ent-fut:HIDDEN IN FRAME {&FRAME-NAME} = YES
            fill-texto:HIDDEN IN FRAME {&FRAME-NAME}    = YES
            rect-1:HIDDEN IN FRAME {&FRAME-NAME}        = YES
            rect-2:HIDDEN IN FRAME {&FRAME-NAME}        = YES.
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
{utp/ut-liter.i Remessa_Beneficiamento mce R}
  assign c-lista-itens = trim(return-value) + ","
         c-item1 = trim(return-value).

  {utp/ut-liter.i Retorno_Beneficiamento mce R}
  assign c-lista-itens = c-lista-itens + trim(return-value) + ","
         c-item2 = trim(return-value).

  {utp/ut-liter.i Remessa_Consigna‡Æo mce R}
  assign c-lista-itens = c-lista-itens + trim(return-value) + ","
         c-item3 = trim(return-value).

  {utp/ut-liter.i Faturamento_Consigna‡Æo mce R}
  assign c-lista-itens = c-lista-itens + trim(return-value) + ","
         c-item4 = trim(return-value).

  {utp/ut-liter.i Devolu‡Æo_Consigna‡Æo mce R}
  assign c-lista-itens = c-lista-itens + trim(return-value) + ","
         c-item5 = trim(return-value).

  {utp/ut-liter.i Reajuste_Pre‡o mce R}
  assign c-lista-itens = c-lista-itens + trim(return-value)
         c-item6 = trim(return-value).

  do with frame {&frame-name}:
      assign cb-tp-oper-terc:list-items = c-lista-itens.
  end.        

  {utp/ut-liter.i Isento mce R}
  assign c-lista-trib = c-lista-trib + return-value + ","
         c-trib1 = return-value.
  {utp/ut-liter.i Normal mce R}
  assign c-lista-trib = c-lista-trib + return-value
         c-trib2 = return-value.
  do with frame {&frame-name}:
      assign cb-tp-tributacao:list-items = c-lista-trib.
  end.        
  
  assign natur-oper.auto-ce:checked in frame {&frame-name} = false.
  disable natur-oper.auto-ce with frame {&frame-name}.

  &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN  
   
   {utp/ut-liter.i Opera‡äes_de_Entrega_Futura * R}
   assign fill-texto = RETURN-VALUE.
          
   ASSIGN fill-texto:VISIBLE IN FRAME {&FRAME-NAME} = YES
          RECT-1:HIDDEN IN FRAME {&FRAME-NAME} = NO
          RECT-2:HIDDEN IN FRAME {&FRAME-NAME} = NO
          rs-op-ent-fut:HIDDEN IN FRAME {&FRAME-NAME} = NO. 
          rs-op-ent-fut:DELETE("1") IN FRAME {&frame-name}.
          {utp/ut-liter.i Nenhum mce L}
          rs-op-ent-fut:ADD-LAST(RETURN-VALUE,1) IN FRAME {&frame-name}.
          {utp/ut-liter.i Faturamento_com_Entrega_Futura mce L}
          rs-op-ent-fut:ADD-LAST(RETURN-VALUE,2) IN FRAME {&frame-name}.
          {utp/ut-liter.i Remessa_de_Entrega_Futura mce L}
          rs-op-ent-fut:ADD-LAST(RETURN-VALUE,3) IN FRAME {&frame-name}.
          
      &ELSE
      ASSIGN rt-mold-2:COLUMN = 29.00
             rt-mold-2:ROW = 1.00 
             rt-mold-2:WIDTH = 58.00
             rt-mold-2:HEIGHT = 10.67
             cb-tp-oper-terc:ROW = 3.5
             natur-oper.dec-1:ROW  = 4.5
             natur-oper.nat-comp:ROW = 5.5
             c-desc-nat-comp:ROW  = 5.5
             cb-tp-tributacao:ROW  = 6.5
             c-tp-oper-terc  = cb-tp-oper-terc:SIDE-LABEL-HANDLE
             c-dec-1         = natur-oper.dec-1:SIDE-LABEL-HANDLE
             c-nat-comp      = natur-oper.nat-comp:SIDE-LABEL-HANDLE
             c-desc-nat      = c-desc-nat-comp:SIDE-LABEL-HANDLE
             c-tp-tributacao = cb-tp-tributacao:SIDE-LABEL-HANDLE
             c-tp-oper-terc:ROW = 3.5
             c-dec-1:ROW  = 4.5       
             c-nat-comp:ROW = 5.5     
             c-tp-tributacao:ROW = 6.5.
   
   &endif  
   /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  find first param-global
        no-lock no-error.
  {utp/ut-liter.i Altera_Valor_Itens_Terc * R}
  assign natur-oper.auto-ce:label in frame {&frame-name} = return-value.
  
  if not adm-new-record then 
     disable natur-oper.nat-comp with frame {&frame-name}.
  else do:
     if input frame {&frame-name} natur-oper.transf = yes and
        param-global.modulo-mp then do with frame {&frame-name}:
        enable  natur-oper.nat-comp.
     end.
     else do with frame {&FRAME-NAME}:
      disable natur-oper.nat-comp.
     end.
  end.
       
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     define input parameter v-row-parent-externo as rowid no-undo.
     
     assign v-row-parent = v-row-parent-externo.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-campo V-table-Win 
PROCEDURE pi-inicializa-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter p-seta-campo as logical no-undo.

    if l-novo-reg then do:

        RUN Get-Field-Screen-Value IN adm-broker-hdl
            (INPUT THIS-PROCEDURE, INPUT "tipo":U).
        assign c-tipo = return-value.

        assign input frame {&frame-name} cb-tp-oper-terc.
        
            assign natur-oper.auto-ce:sensitive in frame {&frame-name} =
                if  natur-oper.terceiros:checked in frame {&frame-name} = yes 
                    then yes
                else no.
        &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN  
           IF adm-new-record = NO THEN
              APPLY "VALUE-CHANGED" to rs-op-ent-fut in frame {&frame-name}.
              
        &endif.
           assign natur-oper.dec-1:sensitive in frame {&frame-name} =
           if natur-oper.auto-ce:checked in frame {&frame-name} = true and
                 cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item2 
              or cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item4  
              or cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item5 
              or cb-tp-oper-terc:screen-value in frame {&frame-name} = c-item6 
              then yes
           else no.

        assign natur-oper.nat-comp:sensitive in frame {&frame-name} = 
                                             (    param-global.modulo-mp 
                                              and natur-oper.transf:checked in frame {&frame-name})
                                             or  natur-oper.log-oper-triang:checked in frame {&frame-name}.
         
        if p-seta-campo 
            and adm-new-record 
            and not l-setou-campo then do:
            
            if {ininc/i06in245.i 06 c-tipo} = 2 then
                assign natur-oper.imp-nota:checked in frame {&frame-name} = no.
              
            if l-terceiros then                    
                assign natur-oper.transf:checked in frame {&frame-name} = no.

            assign natur-oper.transf:sensitive in frame {&frame-name} =
               if not l-terceiros 
                 then yes
                 else no.

            assign l-setou-campo = yes.
        end.                            
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Valida‡Æo de dicionÿrio */


    RUN Get-Field-Screen-Value IN adm-broker-hdl 
        (INPUT THIS-PROCEDURE, INPUT "cb-tipo-nat-oper":U).
    assign c-tipo         = return-value.
 
   if natur-oper.transf:checked in frame {&frame-name} = yes and
        param-global.modulo-mp then do:
        
        if input frame {&frame-name} natur-oper.nat-comp = "" then do:
            {include/i-vldprg.i} 
            /* mensagem: Natureza de Opera‡Æo complementar invalida */
            run utp/ut-msgs.p (input "show":U, input 5260, input return-value).
            apply "entry" to natur-oper.nat-comp in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
        find first b-natur-oper where
             b-natur-oper.nat-operacao = input frame {&frame-name} natur-oper.nat-comp
             no-lock no-error.
            
        if not available b-natur-oper then do:    
            {include/i-vldprg.i} 
            /* mensagem: Natureza de Opera‡Æo complementar invalida */
            run utp/ut-msgs.p (input "show":U, input 5260, input return-value).
            apply "entry" to natur-oper.nat-comp in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
        
        if available b-natur-oper and
            b-natur-oper.tipo = {ininc/i06in245.i 06 c-tipo} then do:
            {include/i-vldprg.i} 
            /* mensagem: Natureza de Opera‡Æo complementar deve ser de tipo inverso */
            run utp/ut-msgs.p (input "show":U, input 15408, input return-value).
            apply "entry" to natur-oper.nat-comp in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
    end.          

    /*------------------ Validacoes do campo Operacao Triangular ------------------*/
    if  input frame {&frame-name} natur-oper.log-oper-triang
        and (    input frame {&frame-name} natur-oper.transf
             or (   input frame {&frame-name} natur-oper.terceiros
                 or lookup(input frame {&frame-name} cb-tp-oper-terc,c-lista-itens) <> 1)) then do:
         {utp/ut-liter.i Natureza_de_Opera‡Æo * c }
         run utp/ut-msgs.p("show",19489,return-value).
         return "adm-error":U.        
    end.
     
    if  input frame {&frame-name} natur-oper.log-oper-triang 
    and not input frame {&frame-name} natur-oper.terceiros then do:

        find b2-natur-oper where
             b2-natur-oper.nat-operacao = input frame {&frame-name} natur-oper.nat-comp no-lock no-error.
        
        if  not avail b2-natur-oper then do:
            {utp/ut-liter.i Natureza_de_Opera‡Æo_Complementar * c }
            run utp/ut-msgs.p("show":U,56,return-value).
            return "adm-error":U.
        end.
        
        def var i-tipo as int no-undo.
        
        assign i-tipo = {ininc/i06in245.i 06 c-tipo}.
        
        if  {ininc/i06in245.i 06 c-tipo} = 1 /* Entrada */ 
        and (avail b2-natur-oper
             and not b2-natur-oper.terceiros 
             or  (avail b2-natur-oper and b2-natur-oper.tipo = 1)
             or  (    avail b2-natur-oper
                  and b2-natur-oper.tp-oper-terc <> 1
                  and b2-natur-oper.tp-oper-terc <> 3)) then do:

            {utp/ut-liter.i Natureza_de_Opera‡Æo_de_Entrega * c}
            run utp/ut-msgs.p("show",19079,return-value).
            return "adm-error":U.
        end.

        if  {ininc/i06in245.i 06 c-tipo} = 2 /* Sa­da */ and
            avail b2-natur-oper and
            (b2-natur-oper.terceiros
             or b2-natur-oper.tipo = 1) then do:
            {utp/ut-liter.i Natureza_de_Opera‡Æo_de_Entrega * c}
            run utp/ut-msgs.p("show",19491,return-value).
            return "adm-error":U.
        end.
    end.
    
    if  (   not input frame {&frame-name} natur-oper.transf 
         or not param-global.modulo-mp)
    and not input frame {&frame-name} natur-oper.log-oper-triang
    and input frame {&frame-name} natur-oper.nat-comp <> " "
    and input frame {&frame-name} natur-oper.nat-comp <> ? then do:
        run utp/ut-msgs.p("show",25530,"").
        return "adm-error":U.
    end.
    /*-----------------------------------------------------------------------------*/
        
    &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN  
    
       IF input frame {&frame-name} rs-op-ent-fut = 2
           AND {ininc/i06in245.i 06 c-tipo} <> 2 /* codigo 1 = saida */  then do:
                         {utp/ut-liter.i Natureza_de_Opera‡Æo_de_Entrega * c}
                         run utp/ut-msgs.p("show",31966,return-value).
                         apply "entry" TO rs-op-ent-fut in frame {&frame-name}.
                         return 'ADM-ERROR':U.
                     
       END.

       IF input frame {&frame-name} rs-op-ent-fut = 3
           AND {ininc/i06in245.i 06 c-tipo} <> 1 /*codigo 1 = entrada*/ then do:
                {utp/ut-liter.i Natureza_de_Opera‡Æo_de_Sa¡da * c}
                run utp/ut-msgs.p("show",31967,return-value).
                apply "entry" TO rs-op-ent-fut in frame {&frame-name}.
                return 'ADM-ERROR':U.
       END.
    &endif  
    
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
  {src/adm/template/snd-list.i "natur-oper"}

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
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

