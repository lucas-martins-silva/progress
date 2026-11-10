&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i VA7IN172 2.00.00.004}  /*** 010004 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i va7in172 MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */
def new global shared var g-item-mat-estab as logical initial yes no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item.res-int-comp item.res-for-comp ~
item.res-cq-comp item.ressup-fabri item.res-cq-fabri 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}res-int-comp ~{&FP2}res-int-comp ~{&FP3}~
 ~{&FP1}res-for-comp ~{&FP2}res-for-comp ~{&FP3}~
 ~{&FP1}res-cq-comp ~{&FP2}res-cq-comp ~{&FP3}~
 ~{&FP1}ressup-fabri ~{&FP2}ressup-fabri ~{&FP3}~
 ~{&FP1}res-cq-fabri ~{&FP2}res-cq-fabri ~{&FP3}
&Scoped-define ENABLED-TABLES item
&Scoped-define FIRST-ENABLED-TABLE item
&Scoped-Define ENABLED-OBJECTS rt-mold RECT-1 RECT-2 
&Scoped-Define DISPLAYED-FIELDS item.res-int-comp item.res-for-comp ~
item.res-cq-comp item.ressup-fabri item.res-cq-fabri 
&Scoped-Define DISPLAYED-OBJECTS i-cod-fat-ponder c-desc-formula de-pto-enc ~
i-crit-cc i-crit-ce de-indice i-fat-1 i-fat-2 i-fat-3 i-fat-4 i-fat-5 ~
i-fat-6 i-fat-7 i-fat-8 i-fat-9 i-fat-10 i-fat-11 i-fat-12 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS></FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = ':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-desc-formula AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .88 NO-UNDO.

DEFINE VARIABLE de-indice AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .88 NO-UNDO.

DEFINE VARIABLE de-pto-enc AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 24.29 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-fat-ponder AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-crit-cc AS INTEGER FORMAT "9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE i-crit-ce AS INTEGER FORMAT "9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE i-fat-1 AS INTEGER FORMAT "9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE i-fat-10 AS INTEGER FORMAT "9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE i-fat-11 AS INTEGER FORMAT "9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE i-fat-12 AS INTEGER FORMAT "9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE i-fat-2 AS INTEGER FORMAT "9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE i-fat-3 AS INTEGER FORMAT "9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE i-fat-4 AS INTEGER FORMAT "9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE i-fat-5 AS INTEGER FORMAT "9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE i-fat-6 AS INTEGER FORMAT "9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE i-fat-7 AS INTEGER FORMAT "9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE i-fat-8 AS INTEGER FORMAT "9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE i-fat-9 AS INTEGER FORMAT "9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 43 BY 5.46.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 43 BY 5.46.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86 BY 4.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     i-cod-fat-ponder AT ROW 1.17 COL 29.86 COLON-ALIGNED
     c-desc-formula AT ROW 1.17 COL 34.86 COLON-ALIGNED NO-LABEL
     de-pto-enc AT ROW 2.17 COL 29.86 COLON-ALIGNED
     i-crit-cc AT ROW 3.17 COL 29.86 COLON-ALIGNED
     i-crit-ce AT ROW 4.17 COL 29.86 COLON-ALIGNED
     item.res-int-comp AT ROW 5.63 COL 20.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     de-indice AT ROW 6.25 COL 58.29 COLON-ALIGNED
     item.res-for-comp AT ROW 6.63 COL 20.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     i-fat-1 AT ROW 7.25 COL 58.29 COLON-ALIGNED
     i-fat-2 AT ROW 7.25 COL 66.29 COLON-ALIGNED NO-LABEL
     i-fat-3 AT ROW 7.25 COL 74.29 COLON-ALIGNED NO-LABEL
     i-fat-4 AT ROW 7.25 COL 81.29 COLON-ALIGNED NO-LABEL
     item.res-cq-comp AT ROW 7.63 COL 20.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     i-fat-5 AT ROW 8.25 COL 58.29 COLON-ALIGNED
     i-fat-6 AT ROW 8.25 COL 66.29 COLON-ALIGNED NO-LABEL
     i-fat-7 AT ROW 8.25 COL 74.29 COLON-ALIGNED NO-LABEL
     i-fat-8 AT ROW 8.25 COL 81.29 COLON-ALIGNED NO-LABEL
     item.ressup-fabri AT ROW 8.63 COL 20.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     i-fat-9 AT ROW 9.25 COL 58.29 COLON-ALIGNED
     i-fat-10 AT ROW 9.25 COL 66.29 COLON-ALIGNED NO-LABEL
     i-fat-11 AT ROW 9.25 COL 74.29 COLON-ALIGNED NO-LABEL
     i-fat-12 AT ROW 9.25 COL 81.29 COLON-ALIGNED NO-LABEL
     item.res-cq-fabri AT ROW 9.63 COL 20.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     rt-mold AT ROW 1 COL 1
     RECT-1 AT ROW 5.38 COL 1
     RECT-2 AT ROW 5.38 COL 44
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 9.92
         WIDTH              = 86.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-formula IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-indice IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-pto-enc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-cod-fat-ponder IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-crit-cc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-crit-ce IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-fat-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-fat-10 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-fat-11 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-fat-12 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-fat-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-fat-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-fat-4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-fat-5 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-fat-6 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-fat-7 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-fat-8 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-fat-9 IN FRAME f-main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME i-cod-fat-ponder
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-fat-ponder V-table-Win
ON F5 OF i-cod-fat-ponder IN FRAME f-main
DO:
  {include/zoomvar.i &prog-zoom=inzoom/z01in659.w
                       &campo=i-cod-fat-ponder 
                       &campozoom=cod-fat-ponder}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-fat-ponder V-table-Win
ON LEAVE OF i-cod-fat-ponder IN FRAME f-main
DO:
  {include/leave.i &tabela=fat-ponder
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-formula
                   &where="fat-ponder.cod-fat-ponder = input frame {&frame-name}
                           i-cod-fat-ponder"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-fat-ponder V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cod-fat-ponder IN FRAME f-main
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  if i-cod-fat-ponder:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "item"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}
    assign input frame {&frame-name} i-cod-fat-ponder
           input frame {&frame-name} de-pto-enc
           input frame {&frame-name} i-crit-cc
           input frame {&frame-name} i-crit-ce
           input frame {&frame-name} de-indice
           input frame {&frame-name} i-fat-1
           input frame {&frame-name} i-fat-2
           input frame {&frame-name} i-fat-3
           input frame {&frame-name} i-fat-4
           input frame {&frame-name} i-fat-5
           input frame {&frame-name} i-fat-6
           input frame {&frame-name} i-fat-7
           input frame {&frame-name} i-fat-8
           input frame {&frame-name} i-fat-9
           input frame {&frame-name} i-fat-10
           input frame {&frame-name} i-fat-11
           input frame {&frame-name} i-fat-12.
    /* Ponha na pi-validate todas as valida‡äes */
    /* NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.       
    find current item-mat exclusive-lock no-error.
    assign item-mat.cod-fat-ponder   = i-cod-fat-ponder
           item-mat.ponto-encomenda  = de-pto-enc
           item-mat.crit-cc          = i-crit-cc
           item-mat.crit-ce          = i-crit-ce
           item-mat.ind-cons-prv     = de-indice
           item-mat.fator-ponder[1]  = i-fat-1
           item-mat.fator-ponder[2]  = i-fat-2
           item-mat.fator-ponder[3]  = i-fat-3
           item-mat.fator-ponder[4]  = i-fat-4
           item-mat.fator-ponder[5]  = i-fat-5
           item-mat.fator-ponder[6]  = i-fat-6
           item-mat.fator-ponder[7]  = i-fat-7
           item-mat.fator-ponder[8]  = i-fat-8
           item-mat.fator-ponder[9]  = i-fat-9
           item-mat.fator-ponder[10] = i-fat-10
           item-mat.fator-ponder[11] = i-fat-11
           item-mat.fator-ponder[12] = i-fat-12.
           
    /*--- Cria relacionamento item-mat-estab ---*/
    
    if  g-item-mat-estab = yes then do: 
                    
           for each fam-mat-estab where 
                    fam-mat-estab.fm-codigo = item.fm-codigo no-lock:
               find first item-mat-estab where 
                    item-mat-estab.it-codigo = item.it-codigo and  
                    item-mat-estab.cod-estabel = fam-mat-estab.cod-estabel
                    no-lock no-error.    
               if not avail item-mat-estab then do:
                  create item-mat-estab.
                  assign item-mat-estab.it-codigo        = item.it-codigo
                         item-mat-estab.cod-estabel      = fam-mat-estab.cod-estabel
                         item-mat-estab.fm-codigo        = fam-mat-estab.fm-codigo
                         item-mat-estab.curva-abc        = fam-mat-estab.curva-abc                
                         item-mat-estab.cod-comprado     = fam-mat-estab.cod-comprado             
                         item-mat-estab.demanda          = fam-mat-estab.demanda                  
                         item-mat-estab.emissao-ord      = fam-mat-estab.emissao-ord              
                         item-mat-estab.classif-abc      = fam-mat-estab.classif-abc              
                         item-mat-estab.politica         = fam-mat-estab.politica                 
                         item-mat-estab.periodo-fixo     = fam-mat-estab.periodo-fixo              
                         item-mat-estab.tempo-segur      = fam-mat-estab.tempo-segur             
                         item-mat-estab.quant-segur      = fam-mat-estab.quant-segur              
                         item-mat-estab.res-int-comp     = fam-mat-estab.res-int-comp            
                         item-mat-estab.res-for-comp     = fam-mat-estab.res-for-comp             
                         item-mat-estab.res-cq-comp      = fam-mat-estab.res-cq-comp              
                         item-mat-estab.res-cq-fabri     = fam-mat-estab.res-cq-fabri            
                         item-mat-estab.lote-multipl     = fam-mat-estab.lote-multipl             
                         item-mat-estab.tipo-lote-ec     = fam-mat-estab.tipo-lote-ec            
                         item-mat-estab.lote-economi     = fam-mat-estab.lote-economi             
                         item-mat-estab.fator-refugo     = fam-mat-estab.fator-refugo             
                         item-mat-estab.quant-perda      = fam-mat-estab.quant-perda             
                         item-mat-estab.lote-minimo      = fam-mat-estab.lote-minimo             
                         item-mat-estab.horiz-fixo       = fam-mat-estab.horiz-fixo             
                         item-mat-estab.tipo-est-seg     = fam-mat-estab.tipo-est-seg             
                         item-mat-estab.check-sum        = fam-mat-estab.check-sum
                         item-mat-estab.cod-depos        = fam-mat-estab.cod-depos
                         item-mat-estab.nat-despesa      = fam-mat-estab.nat-despesa  
                         item-mat-estab.ressup-min-f     = fam-mat-estab.ressup-min-f
                         item-mat-estab.fator-ponder[1]  = fam-mat-estab.fator-ponder[1]
                         item-mat-estab.fator-ponder[2]  = fam-mat-estab.fator-ponder[2]
                         item-mat-estab.fator-ponder[3]  = fam-mat-estab.fator-ponder[3]
                         item-mat-estab.fator-ponder[4]  = fam-mat-estab.fator-ponder[4]
                         item-mat-estab.fator-ponder[5]  = fam-mat-estab.fator-ponder[5]
                         item-mat-estab.fator-ponder[6]  = fam-mat-estab.fator-ponder[6]
                         item-mat-estab.fator-ponder[7]  = fam-mat-estab.fator-ponder[7]
                         item-mat-estab.fator-ponder[8]  = fam-mat-estab.fator-ponder[8]
                         item-mat-estab.fator-ponder[9]  = fam-mat-estab.fator-ponder[9]
                         item-mat-estab.fator-ponder[10] = fam-mat-estab.fator-ponder[10]
                         item-mat-estab.fator-ponder[11] = fam-mat-estab.fator-ponder[11]
                         item-mat-estab.fator-ponder[12] = fam-mat-estab.fator-ponder[12]       
                         item-mat-estab.cod-fat-ponder   = fam-mat-estab.cod-fat-ponder                 
                         item-mat-estab.cd-freq          = fam-mat-estab.cd-freq         
                         item-mat-estab.lote-per-max     = fam-mat-estab.lote-per-max         
                         item-mat-estab.tp-ressup        = fam-mat-estab.tp-ressup 
                         item-mat-estab.crit-cc          = fam-mat-estab.crit-cc                 
                         item-mat-estab.crit-ce          = fam-mat-estab.crit-ce                
                         item-mat-estab.cod-grp-compra   = fam-mat-estab.cod-grp-compra         
                         item-mat-estab.ind-cons-prv     = fam-mat-estab.ind-cons-prv           
                         item-mat-estab.int-1            = fam-mat-estab.int-1         
                         item-mat-estab.int-2            = fam-mat-estab.int-2  
                         item-mat-estab.dec-1            = fam-mat-estab.dec-1
                         item-mat-estab.dec-2            = fam-mat-estab.dec-2   
                         item-mat-estab.char-1           = fam-mat-estab.char-1
                         item-mat-estab.char-2           = fam-mat-estab.char-2
                         item-mat-estab.log-1            = fam-mat-estab.log-1
                         item-mat-estab.log-2            = fam-mat-estab.log-2
                         item-mat-estab.data-1           = fam-mat-estab.data-1
                         item-mat-estab.data-2           = fam-mat-estab.data-2
                         item-mat-estab.deposito-cq      = fam-mat-estab.deposito-cq
                         item-mat-estab.altera-conta     = fam-mat-estab.altera-conta
                         item-mat-estab.dep-rej-cq       = fam-mat-estab.dep-rej-cq. 
               end.          
           end.
    end.
    else return.                
    
    /* --------------------------------------------------------------------- */   
       
    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

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
    disable i-cod-fat-ponder
            de-pto-enc
            i-crit-cc
            i-crit-ce
            de-indice
            i-fat-1
            i-fat-2
            i-fat-3
            i-fat-4
            i-fat-5
            i-fat-6
            i-fat-7
            i-fat-8
            i-fat-9
            i-fat-10
            i-fat-11
            i-fat-12
            with frame {&frame-name}.
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
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
  if avail item then do:
      {cep/ce0106.i item-mat item}
      do with frame {&frame-name}:
          assign i-cod-fat-ponder:screen-value = string(item-mat.cod-fat-ponder) 
                 de-pto-enc:screen-value       = string(item-mat.ponto-encomenda)
                 i-crit-cc:screen-value        = string(item-mat.crit-cc)
                 i-crit-ce:screen-value        = string(item-mat.crit-ce)
                 de-indice:screen-value        = string(item-mat.ind-cons-prv)
                 i-fat-1:screen-value          = string(item-mat.fator-ponder[1])
                 i-fat-2:screen-value          = string(item-mat.fator-ponder[2])
                 i-fat-3:screen-value          = string(item-mat.fator-ponder[3])
                 i-fat-4:screen-value          = string(item-mat.fator-ponder[4])
                 i-fat-5:screen-value          = string(item-mat.fator-ponder[5])
                 i-fat-6:screen-value          = string(item-mat.fator-ponder[6])
                 i-fat-7:screen-value          = string(item-mat.fator-ponder[7])
                 i-fat-8:screen-value          = string(item-mat.fator-ponder[8])
                 i-fat-9:screen-value          = string(item-mat.fator-ponder[9])
                 i-fat-10:screen-value         = string(item-mat.fator-ponder[10])
                 i-fat-11:screen-value         = string(item-mat.fator-ponder[11])
                 i-fat-12:screen-value         = string(item-mat.fator-ponder[12]).
          for first fat-ponder fields(cod-fat-ponder descricao) where
              fat-ponder.cod-fat-ponder = item-mat.cod-fat-ponder no-lock: end.
          if avail fat-ponder then
              assign c-desc-formula:screen-value = fat-ponder.descricao.
      end. 
  end.
  else do with frame {&frame-name}:
       assign i-cod-fat-ponder:screen-value  = string(0) 
                 de-pto-enc:screen-value     = string(0)
                 i-crit-cc:screen-value      = string(0)
                 i-crit-ce:screen-value      = string(0)
                 de-indice:screen-value      = string(0)
                 i-fat-1:screen-value        = string(0)
                 i-fat-2:screen-value        = string(0)
                 i-fat-3:screen-value        = string(0)
                 i-fat-4:screen-value        = string(0)
                 i-fat-5:screen-value        = string(0)
                 i-fat-6:screen-value        = string(0)
                 i-fat-7:screen-value        = string(0)
                 i-fat-8:screen-value        = string(0)
                 i-fat-9:screen-value        = string(0)
                 i-fat-10:screen-value       = string(0)
                 i-fat-11:screen-value       = string(0)
                 i-fat-12:screen-value       = string(0)
                 c-desc-formula:screen-value = " ".
  end.
  /* Code placed here will execute AFTER standard behavior.    */

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
    enable i-cod-fat-ponder
           de-pto-enc
           i-crit-cc
           i-crit-ce
           de-indice
           i-fat-1
           i-fat-2
           i-fat-3
           i-fat-4
           i-fat-5
           i-fat-6
           i-fat-7
           i-fat-8
           i-fat-9
           i-fat-10
           i-fat-11
           i-fat-12
           with frame {&frame-name}.
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

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
  {utp/ut-field.i mgind item-mat cod-fat-ponder 1}
  assign i-cod-fat-ponder:label in frame {&frame-name} = trim(return-value).
  {utp/ut-field.i mgind item-mat-estab ponto-encomenda 1}
  assign de-pto-enc:label in frame {&frame-name} = trim(return-value).
  {utp/ut-field.i mgind item-mat-estab crit-cc 1}
  assign i-crit-cc:label in frame {&frame-name} = trim(return-value).
  {utp/ut-field.i mgind item-mat-estab crit-ce 1}
  assign i-crit-ce:label in frame {&frame-name} = trim(return-value).
  {utp/ut-field.i mgind item-mat ind-cons-prv 1}
  assign de-indice:label in frame {&frame-name} = trim(return-value).
  {utp/ut-field.i mgind item-mat-estab fator-ponder[1] 1}
  assign i-fat-1:label in frame {&frame-name} = trim(return-value).
  {utp/ut-field.i mgind item-mat-estab fator-ponder[5] 1}
  assign i-fat-5:label in frame {&frame-name} = trim(return-value).
  {utp/ut-field.i mgind item-mat-estab fator-ponder[9] 1}
  assign i-fat-9:label in frame {&frame-name} = trim(return-value).
  /* Code placed here will execute AFTER standard behavior.    */

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */
    
/*/*    Segue um exemplo de valida‡Æo de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "item"}

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


