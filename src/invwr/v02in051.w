&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V02IN051 2.00.00.024}  /*** "010024" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN051 MUT}
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
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def buffer b-comp-folh  for comp-folh.
def buffer b1-comp-folh for comp-folh.

def var i-opcao         as integer.
def var ce-teste        as char no-undo.
def var i-escolha       as integer.
def var i-esc-aux       as integer.
def var i-max-escolha   as integer.
def var rw-folh-espec   as rowid no-undo.
def var i-tp-resul      as integer no-undo.
def var c-opcao         as char initial "1" no-undo.
def var c-formato       as char.
def var c-aux           as char.

def var de-maximo       as decimal          no-undo.
def var i-cont          as int.

def var v-vl-min        as decimal no-undo.
def var v-vl-max        as decimal no-undo.

def var c-list-num      as char initial "-;+;>;9;z;*;,;.;$;#" no-undo.
def var c-list-date     as char initial "/,-,9" no-undo.
def var c-list-char     as char initial "X,N,A,!,9,(,),0,1,2,3,4,5,6,7,8,9" no-undo.
def var da-aux          as date no-undo.
def var l-primeira      as logical initial yes.
def var i-virgula       as integer.
def var c-tabela        as char.

def var c-vl-min-aux    as char.
def var c-vl-max-aux    as char.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES comp-folh
&Scoped-define FIRST-EXTERNAL-TABLE comp-folh


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR comp-folh.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS comp-folh.descricao comp-folh.gera-texto ~
comp-folh.abreviatura comp-folh.gera-narrativa comp-folh.un-medida ~
comp-folh.seq-de-impres comp-folh.ajuda comp-folh.nr-tabela ~
comp-folh.nr-max-esc comp-folh.vl-minimo comp-folh.dt-minima ~
comp-folh.vl-maximo comp-folh.dt-maxima comp-folh.formato 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}descricao ~{&FP2}descricao ~{&FP3}~
 ~{&FP1}abreviatura ~{&FP2}abreviatura ~{&FP3}~
 ~{&FP1}un-medida ~{&FP2}un-medida ~{&FP3}~
 ~{&FP1}seq-de-impres ~{&FP2}seq-de-impres ~{&FP3}~
 ~{&FP1}ajuda ~{&FP2}ajuda ~{&FP3}~
 ~{&FP1}nr-tabela ~{&FP2}nr-tabela ~{&FP3}~
 ~{&FP1}nr-max-esc ~{&FP2}nr-max-esc ~{&FP3}~
 ~{&FP1}vl-minimo ~{&FP2}vl-minimo ~{&FP3}~
 ~{&FP1}dt-minima ~{&FP2}dt-minima ~{&FP3}~
 ~{&FP1}vl-maximo ~{&FP2}vl-maximo ~{&FP3}~
 ~{&FP1}dt-maxima ~{&FP2}dt-maxima ~{&FP3}~
 ~{&FP1}formato ~{&FP2}formato ~{&FP3}
&Scoped-define ENABLED-TABLES comp-folh
&Scoped-define FIRST-ENABLED-TABLE comp-folh
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold cb-tipo-result RECT-1 ~
cb-forma-verif RECT-2 RECT-3 
&Scoped-Define DISPLAYED-FIELDS folh-espec.cd-folha folh-espec.descricao ~
comp-folh.cd-comp comp-folh.descricao comp-folh.gera-texto ~
comp-folh.abreviatura comp-folh.gera-narrativa comp-folh.un-medida ~
comp-folh.seq-de-impres comp-folh.ajuda comp-folh.nr-tabela ~
comp-folh.nr-max-esc comp-folh.vl-minimo comp-folh.dt-minima ~
comp-folh.vl-maximo comp-folh.dt-maxima comp-folh.formato 
&Scoped-Define DISPLAYED-OBJECTS cb-tipo-result c-descricao cb-forma-verif 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS comp-folh.cd-comp cb-tipo-result ~
cb-forma-verif 
&Scoped-define ADM-ASSIGN-FIELDS cb-tipo-result cb-forma-verif 
&Scoped-define ADM-MODIFY-FIELDS cb-tipo-result cb-forma-verif 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
cod-exame||y|comp-folh.cod-exame
cd-folha||y|comp-folh.cd-folha
nr-tabela||y|comp-folh.nr-tabela
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "cod-exame,cd-folha,nr-tabela"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE cb-forma-verif AS CHARACTER FORMAT "X(20)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-result AS CHARACTER FORMAT "X(20)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-aux-2 AS DECIMAL FORMAT "->>>>>>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 1.72 BY .88.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 55 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.42.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 52.57 BY 3.33.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 35 BY 3.33.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 5.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     folh-espec.cd-folha AT ROW 1.17 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     folh-espec.descricao AT ROW 1.17 COL 34.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 41 BY .88
     comp-folh.cd-comp AT ROW 2.17 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     comp-folh.descricao AT ROW 3.75 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.43 BY .88
     comp-folh.gera-texto AT ROW 3.75 COL 72
          VIEW-AS TOGGLE-BOX
          SIZE 15 BY .88
     comp-folh.abreviatura AT ROW 4.75 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     comp-folh.gera-narrativa AT ROW 4.75 COL 72
          VIEW-AS TOGGLE-BOX
          SIZE 17 BY .75
     cb-tipo-result AT ROW 5.75 COL 22 COLON-ALIGNED
     comp-folh.un-medida AT ROW 6.92 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     comp-folh.seq-de-impres AT ROW 6.92 COL 70.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.29 BY .88
     comp-folh.ajuda AT ROW 7.92 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 61.43 BY .88
     comp-folh.nr-tabela AT ROW 9.5 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.29 BY .88
     c-descricao AT ROW 9.5 COL 30 COLON-ALIGNED NO-LABEL
     cb-forma-verif AT ROW 10.5 COL 22 COLON-ALIGNED
     comp-folh.nr-max-esc AT ROW 10.54 COL 72.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     comp-folh.vl-minimo AT ROW 12 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.72 BY .88
     c-aux-2 AT ROW 12.13 COL 44.29 COLON-ALIGNED NO-LABEL
     comp-folh.dt-minima AT ROW 12.58 COL 69 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     comp-folh.vl-maximo AT ROW 13 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.72 BY .88
     comp-folh.dt-maxima AT ROW 13.58 COL 69 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     comp-folh.formato AT ROW 14 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 28 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 3.5 COL 1
     RECT-1 AT ROW 9.21 COL 1
     RECT-2 AT ROW 11.79 COL 1
     RECT-3 AT ROW 11.79 COL 54.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: comp-folh
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
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
         HEIGHT             = 14.17
         WIDTH              = 88.57.
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

/* SETTINGS FOR FILL-IN c-aux-2 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       c-aux-2:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-forma-verif IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR COMBO-BOX cb-tipo-result IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN comp-folh.cd-comp IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN folh-espec.cd-folha IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN folh-espec.descricao IN FRAME f-main
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

&Scoped-define SELF-NAME cb-tipo-result
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo-result V-table-Win
ON VALUE-CHANGED OF cb-tipo-result IN FRAME f-main
DO:
   
   assign c-opcao = string({ininc/i01in158.i 06 cb-tipo-result:screen-value}).   
   do with frame {&frame-name}:  
       assign comp-folh.nr-tabela:sensitive   = (lookup(c-opcao,'2')   > 0)
              cb-forma-verif:sensitive        = (lookup(c-opcao,'2')   > 0)
              comp-folh.nr-max-esc:sensitive  = (lookup(c-opcao,'2')   > 0)
              comp-folh.un-medida:sensitive   = (lookup(c-opcao,'1,2') > 0)
              comp-folh.vl-minimo:sensitive   = (lookup(c-opcao,'1')   > 0)
              comp-folh.vl-maximo:sensitive   = (lookup(c-opcao,'1')   > 0)
              comp-folh.formato:sensitive     = (lookup(c-opcao,'1,4,6')   > 0)
              comp-folh.dt-minima:sensitive   = (lookup(c-opcao,'6')   > 0)
              comp-folh.dt-maxima:sensitive   = (lookup(c-opcao,'6')   > 0).
    end.
    assign comp-folh.nr-tabela:screen-value  = "0"
           comp-folh.nr-max-esc:screen-value = "0"
           comp-folh.un-medida:screen-value  = ""
           comp-folh.vl-maximo:screen-value  = "0"
           comp-folh.vl-minimo:screen-value  = "0"
           comp-folh.formato:screen-value    = ""      
           comp-folh.dt-maxima:screen-value  = ?     
           comp-folh.dt-minima:screen-value  = ?      
               cb-forma-verif :screen-value  = "".      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME comp-folh.nr-tabela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL comp-folh.nr-tabela V-table-Win
ON F5 OF comp-folh.nr-tabela IN FRAME f-main /* Tabela */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z02in418.w"
                     &campo=comp-folh.nr-tabela
                     &campozoom=nr-tabela
                     &campo2=c-descricao
                     &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL comp-folh.nr-tabela V-table-Win
ON LEAVE OF comp-folh.nr-tabela IN FRAME f-main /* Tabela */
DO:
   {include/leave.i &tabela=tabela-res
                    &atributo-ref=descricao
                    &variavel-ref=c-descricao
                    &where="tabela-res.nr-tabela = 
                    input frame {&frame-name} comp-folh.nr-tabela"}
                    
   assign i-escolha = 0.
   for each c-tab-res where 
            c-tab-res.nr-tabela = input frame {&frame-name} comp-folh.nr-tabela no-lock:
      assign  i-escolha = i-escolha + 1.
   end.
   IF i-escolha > 99 THEN 
      assign comp-folh.nr-max-esc:screen-value in frame {&frame-name} = '99'.
   ELSE
      assign comp-folh.nr-max-esc:screen-value in frame {&frame-name} = string(i-escolha).                                                                             

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL comp-folh.nr-tabela V-table-Win
ON MOUSE-SELECT-DBLCLICK OF comp-folh.nr-tabela IN FRAME f-main /* Tabela */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
{utp/ut-field.i mgind comp-folh tipo-result 1}
assign cb-tipo-result:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind comp-folh forma-verif 1}
assign cb-forma-verif:label in frame {&frame-name} = return-value.

if comp-folh.nr-tabela:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  {src/adm/template/row-list.i "comp-folh"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "comp-folh"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  def var i-initial as integer no-undo.

  /* Code placed here will execute PRIOR to standard behavior. */
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  {utp/ut-field.i mgind comp-folh forma-verif 05}
  assign i-initial = integer(return-value).
  
  assign cb-tipo-result:screen-value in frame {&frame-name} = {ininc/i01in158.i 04 1}
         cb-forma-verif:screen-value in frame {&frame-name} = {ininc/i01in051.i 04 i-initial}.

  apply 'value-changed' to  cb-tipo-result in frame {&FRAME-NAME}.               
         
  display "" @ c-descricao with frame f-main. 
  
  find folh-espec where rowid(folh-espec) = rw-folh-espec no-lock no-error.  
  find last comp-folh use-index seq-impr
       where comp-folh.cd-folha = folh-espec.cd-folha 
       no-lock no-error.
  assign comp-folh.seq-de-impres:screen-value in frame {&frame-name} = 
     if avail comp-folh then string(comp-folh.seq-de-impres + 10) else '10':U.

  assign comp-folh.nr-tabela:screen-value  = "0"
         comp-folh.nr-max-esc:screen-value = "0"
         comp-folh.un-medida:screen-value  = ""    
         comp-folh.vl-maximo:screen-value  = "0"  
         comp-folh.vl-minimo:screen-value  = "0"    
         comp-folh.formato:screen-value    = ""     
         comp-folh.dt-maxima:screen-value  = ?     
         comp-folh.dt-minima:screen-value  = ?     
             cb-forma-verif :screen-value  = "".      
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
  /*{include/i-valid.i}*/

  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /*  find folh-espec where rowid(folh-espec) = rw-folh-espec no-lock no-error.*/
  

 /*** Validaá∆o do Campo Formato ***/


/************************ Validaá∆o Troca de Tipo de Dado **********************/ 
  
  if adm-new-record = no
  and comp-folh.tipo-result <> {ininc/i01in158.i 06 cb-tipo-result:screen-value} then do:
     if can-find (first it-carac-tec  where
                        it-carac-tec.cd-folha     = comp-folh.cd-folha and
                        it-carac-tec.cd-comp      = comp-folh.cd-comp  and 
                        it-carac-tec.observacao  <> "") then 
     do:                   
       {utp/ut-table.i mgind comp-folh 1}
       run utp/ut-msgs.p (input "show",
                          input 5737,
                          input return-value).
       apply 'entry' to cb-tipo-result in frame {&frame-name}.
       return 'adm-error':U.
     end.
     if can-find (first cond-oper where
                        cond-oper.cd-folha     = comp-folh.cd-folha and
                        cond-oper.cd-comp      = comp-folh.cd-comp  and 
                        cond-oper.observacao   <> "") then                    
     do:
       {utp/ut-table.i mgind comp-folh 1}
       run utp/ut-msgs.p (input "show",
                          input 5737,
                          input return-value).
       apply 'entry' to cb-tipo-result in frame {&frame-name}.
       return 'adm-error':U.
     end.
     if can-find (first carac-tec where 
                        carac-tec.cd-folha     = comp-folh.cd-folha and
                        carac-tec.cd-comp      = comp-folh.cd-comp  and
                        carac-tec.observacao  <> "") then
     do:       
       {utp/ut-table.i mgind comp-folh 1}
       run utp/ut-msgs.p (input "show",
                          input 5737,
                          input return-value).
       apply 'entry' to cb-tipo-result in frame {&frame-name}.
       return 'adm-error':U.
     end.                                 
  end. 
  if adm-new-record = yes then do:
     find first b1-comp-folh 
          where b1-comp-folh.cd-folha = input frame {&frame-name} folh-espec.cd-folha
            and b1-comp-folh.cd-comp  = input frame {&frame-name} comp-folh.cd-comp 
            no-lock no-error.
     if  avail b1-comp-folh then do:
          {utp/ut-liter.i Componente mcd c}
          run utp/ut-msgs.p (input "show",
                            input 8,
                            input return-value).
         apply 'entry' to comp-folh.cd-comp in frame {&frame-name}.
         return 'adm-error':U.   
     end.
  end.
    
  /************************ Validaá∆o Troca de Limites **********************/ 

  assign i-tp-resul = {ininc/i01in158.i 06 cb-tipo-result:screen-value}.
  
  if i-tp-resul = 1 then do:
  
        if  trim(c-vl-max-aux) <> trim(comp-folh.vl-maximo:screen-value in frame {&frame-name}) then do:
        
            find first it-carac-tec where
                       it-carac-tec.cd-folha     = comp-folh.cd-folha and
                       it-carac-tec.cd-comp      = input frame {&frame-name} comp-folh.cd-comp  and 
                       it-carac-tec.vl-result > input frame {&Frame-name} comp-folh.vl-maximo no-lock no-error.
            if available it-carac-tec then 
                assign v-vl-max = it-carac-tec.vl-result. 
                
            find first cond-oper where
                       cond-oper.cd-folha     = comp-folh.cd-folha and
                       cond-oper.cd-comp      = input frame {&frame-name} comp-folh.cd-comp  and 
                       cond-oper.vl-maximo > input frame {&Frame-name} comp-folh.vl-maximo no-lock no-error.
                                             
            if available cond-oper then
                if avail it-carac-tec then  
                   assign v-vl-max = max(cond-oper.vl-maximo, v-vl-max).
                else 
                   assign v-vl-max = cond-oper.vl-maximo.
            
            find first carac-tec where
                       carac-tec.cd-folha     = comp-folh.cd-folha and
                       carac-tec.cd-comp      = input frame {&frame-name} comp-folh.cd-comp  and 
                       carac-tec.vl-result > input frame {&Frame-name} comp-folh.vl-maximo no-lock no-error.
          
            if available carac-tec then 
                if (avail it-carac-tec) or (avail cond-oper) then
                   assign v-vl-max = max(carac-tec.vl-result, v-vl-max).
                else   
                   assign v-vl-max = carac-tec.vl-result .
                   
            if available it-carac-tec 
            or available carac-tec 
            or available cond-oper then do:
                 run utp/ut-msgs.p (input "show",
                                    input 5740,
                                    input string(v-vl-max)).
                 apply 'entry' to comp-folh.vl-maximo in frame {&frame-name}.
                 return 'adm-error':U.
            end.

        end.

        if  trim(c-vl-min-aux) <> trim(comp-folh.vl-minimo:screen-value in frame {&frame-name}) then do:
        
            find first it-carac-tec where
                       it-carac-tec.cd-folha   = comp-folh.cd-folha and
                       it-carac-tec.cd-comp    = input frame {&frame-name} comp-folh.cd-comp  and 
                       it-carac-tec.vl-result  < input frame {&Frame-name} comp-folh.vl-minimo 
                       no-lock no-error.
          
            if available it-carac-tec then 
                assign v-vl-min = it-carac-tec.vl-result. 
                
            find first cond-oper where
                       cond-oper.cd-folha    = comp-folh.cd-folha and
                       cond-oper.cd-comp     = input frame {&frame-name} comp-folh.cd-comp  and 
                       cond-oper.vl-minimo   < input frame {&Frame-name} comp-folh.vl-minimo 
                       no-lock no-error.
          
            if available cond-oper then
                if avail it-carac-tec then  
                   assign v-vl-min = min(cond-oper.vl-minimo, v-vl-min).
                else   
                   assign v-vl-min = cond-oper.vl-minimo.
                     
            find first carac-tec where
                       carac-tec.cd-folha  = comp-folh.cd-folha and
                       carac-tec.cd-comp   = input frame {&frame-name} comp-folh.cd-comp  and 
                       carac-tec.vl-result < input frame {&Frame-name} comp-folh.vl-minimo 
                       no-lock no-error.
          
            if available carac-tec then  
                if (avail it-carac-tec) or (avail cond-oper) then
                   assign v-vl-min = min(carac-tec.vl-result, v-vl-min).
                else  
                   assign v-vl-min = carac-tec.vl-result.
    
            if available it-carac-tec 
            or available carac-tec 
            or available cond-oper then do:
               run utp/ut-msgs.p (input "show",
                                  input 5742,
                                  input string(v-vl-min)).
               apply 'entry' to comp-folh.vl-minimo in frame {&frame-name}.
               return 'adm-error':U.
            end.
                  
            if input frame {&frame-name} comp-folh.formato = "" then do:
               {utp/ut-field.i mgind comp-folh formato 1}
               run utp/ut-msgs.p (input "show",
                                  input 164,
                                  input return-value).
               apply 'entry' to comp-folh.formato in frame {&frame-name}.
               return 'adm-error':U.
            end.
        end.    
  end.
  
  if i-tp-resul = 2 then do:
      
     assign i-escolha = 0.
     for each c-tab-res where 
              c-tab-res.nr-tabela = input frame {&frame-name} comp-folh.nr-tabela no-lock:
        assign  i-escolha = i-escolha + 1.
     end.
      if i-escolha = 0 then do:
         {utp/ut-table.i mgind tab-result 1} 
          assign c-tabela = return-value.
         {utp/ut-field.i mgind c-tab-res sequencia 1}
          run utp/ut-msgs.p (input "show",
                             input 5823,
                             input trim(return-value) + "~~" + c-tabela).
          apply 'entry' to comp-folh.nr-tabela in frame {&frame-name}.
          return 'adm-error':U.      
      end.
      
      assign i-esc-aux = 0
             i-max-escolha = 1.
      for each res-carac 
          where res-carac.cd-folha  = folh-espec.cd-folha:screen-value in frame {&FRAME-NAME}
          and   res-carac.cd-comp   = comp-folh.cd-comp:screen-value in frame {&FRAME-NAME}
          and   res-carac.nr-tabela = input frame {&frame-name} comp-folh.nr-tabela no-lock
          break by res-carac.cd-equipto:

          if last-of (res-carac.cd-equipto) then do:
             assign i-esc-aux = i-esc-aux + 1.
             if i-esc-aux > i-max-escolha then 
                assign i-max-escolha = i-esc-aux.
             assign i-esc-aux = 0.
          end.   
          else 
             assign i-esc-aux = i-esc-aux + 1.
      end.
      
      assign i-esc-aux = 0.
      for each result-cond 
          where result-cond.cd-folha  = folh-espec.cd-folha:screen-value in frame {&FRAME-NAME}
          and   result-cond.cd-comp   = comp-folh.cd-comp:screen-value in frame {&FRAME-NAME}
          and   result-cond.nr-tabela = input frame {&frame-name} comp-folh.nr-tabela no-lock
          break by result-cond.cd-tag:

          if last-of (result-cond.cd-tag) then do:
             assign i-esc-aux = i-esc-aux + 1.
             if i-esc-aux > i-max-escolha then 
                assign i-max-escolha = i-esc-aux.
             assign i-esc-aux = 0.
          end.   
          else 
             assign i-esc-aux = i-esc-aux + 1.
      end.
    
      assign i-esc-aux = 0.
      for each it-res-carac
          where it-res-carac.cd-folha  = folh-espec.cd-folha:screen-value in frame {&FRAME-NAME}
          and   it-res-carac.cd-comp   = comp-folh.cd-comp:screen-value in frame {&FRAME-NAME}
          and   it-res-carac.nr-tabela = input frame {&frame-name} comp-folh.nr-tabela no-lock
          break by it-res-carac.it-codigo:

          if last-of (it-res-carac.it-codigo) then do:
             assign i-esc-aux = i-esc-aux + 1.
             if i-esc-aux > i-max-escolha then 
                assign i-max-escolha = i-esc-aux.
             assign i-esc-aux = 0.
          end.   
          else 
             assign i-esc-aux = i-esc-aux + 1.
      end.
   
      if input frame {&frame-name} comp-folh.nr-max-esc > i-escolha or 
         input frame {&frame-name} comp-folh.nr-max-esc < i-max-escolha then do:
         {utp/ut-field.i mgind comp-folh nr-max-esc 1}
          run utp/ut-msgs.p (input "show",
                             input 3662,
                             input trim(return-value) + "~~" + string(i-max-escolha) + "~~" + string(i-escolha)).
          apply 'entry' to comp-folh.nr-max-esc in frame {&frame-name}.
          return 'adm-error':U.      
      end.     
   
  end.   
   
  assign c-formato = comp-folh.formato:screen-value in frame {&frame-name}.
  
  do with frame {&frame-name}:

        if  c-opcao = "1" then do:
             do  i-cont = 1 to length(trim(c-formato)):
                if  lookup(substring(c-formato,i-cont,1),c-list-num,";") = 0 then do:
                    run utp/ut-msgs.p (input "show", input 17065, input c-formato).
                    apply 'entry' to comp-folh.formato in frame {&frame-name}.
                    return 'adm-error':U.
                end.   
             end.
            
             /* Testa o formato para o vl-maximo*/
             
             assign error-status:error = no
                    c-aux = string(input frame {&frame-name} comp-folh.vl-maximo, c-formato) no-error.

             if  error-status:error or c-aux = "?" then do:
                 {utp/ut-field.i mgind comp-folh vl-maximo 1}
                 run utp/ut-msgs.p (input "show", 
                                    input 19071, 
                                    input string(c-formato + "~~" + trim(return-value))).

                 apply 'entry' to comp-folh.formato in frame {&frame-name}.
                 return 'adm-error':U.
             end.

             /*Teste o formato para o vl-minimo*/
             
             assign error-status:error = no
                    c-aux = string(input frame {&frame-name} comp-folh.vl-minimo, c-formato) no-error.
                    
             if  error-status:error or c-aux = "?" then do:
                 {utp/ut-field.i mgind comp-folh vl-minimo 1}
                 run utp/ut-msgs.p (input "show", 
                                    input 19071, 
                                    input c-formato + "~~" + trim(return-value))).
                                    
                 apply 'entry' to comp-folh.formato in frame {&frame-name}.
                 return 'adm-error':U.
             end.
             
             do  i-cont = 1 to length(c-formato):
                 if substring(c-formato,i-cont,1) = "," then do:
                    if  l-primeira then
                        assign i-virgula = i-cont
                               l-primeira = no.
                    else do:
                         if  (i-cont - i-virgula) <> 4 then do:
                             assign i-virgula  = 0
                                    l-primeira = yes.
                             run utp/ut-msgs.p (input "show", input 17065, input c-formato).
                             apply 'entry' to comp-folh.formato in frame {&frame-name}.
                             return 'adm-error':U.                      
                         end.         
                         else
                             assign i-virgula = i-cont.
                    end.         
                 end.
             end.
               
        end.
      
        if  c-opcao = "4" then do /* OBS */ :
            do  i-cont = 1 to length(trim(c-formato)):
                if  lookup(substring(c-formato,i-cont,1),c-list-char) = 0 then do:
                    run utp/ut-msgs.p (input "show", input 17065, input c-formato).
                    apply 'entry' to comp-folh.formato in frame {&frame-name}.
                    return 'adm-error':U.
                end.   
             end.
             
             assign error-status:error = no
                    c-aux = string("a", c-formato) no-error.
             if error-status:error then do:
                    run utp/ut-msgs.p (input "show", input 17065, input c-formato).
                    apply 'entry' to comp-folh.formato in frame {&frame-name}.
                    return 'adm-error':U.
             end.
        end.
        
        if  c-opcao = "6" then do /* DATA */ :
            if  c-formato <> "99/99/9999" and
                c-formato <> "99-99-9999" and
                c-formato <> "99999999"   then do:
               
                    run utp/ut-msgs.p (input "show", input 17065, input c-formato).
                    apply 'entry' to comp-folh.formato in frame {&frame-name}.
                    return 'adm-error':U.
            end.
        end.
  end.

  
  /*Se houve troca da folha de componentes*/
   IF  adm-new-record = NO AND 
       AVAILABLE comp-folh AND
       comp-folh.nr-tabela <> INPUT FRAME {&FRAME-NAME} comp-folh.nr-tabel THEN DO:
       IF CAN-FIND(FIRST it-res-carac
                   where it-res-carac.cd-folha  = comp-folh.cd-folha
                     AND it-res-carac.cd-comp   = comp-folh.cd-comp 
                     AND it-res-carac.nr-tabela = comp-folh.nr-tabela no-lock) THEN DO:
          {utp/ut-table.i mgind comp-folh 1}
          RUN utp/ut-msgs.p (INPUT "show",
                   INPUT 57455,
                   INPUT string(comp-folh.nr-tabela)).
          IF RETURN-VALUE = "NO" THEN
              return 'adm-error':U.
       end. 
   END.


  
  /* Dispatch standard ADM method. */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  
  /* Code placed here will execute AFTER standard behavior.    */

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
  do with frame {&frame-name}:
     assign comp-folh.tipo-result = {ininc/i01in158.i 06 cb-tipo-result:screen-value}
            comp-folh.forma-verif = {ininc/i01in051.i 06 cb-forma-verif:screen-value}. 
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
if avail folh-espec then do:
      assign comp-folh.cd-folha = folh-espec.cd-folha.
  end.   
  
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

  /* Code placed here will execute AFTER standard behavior.    */

  if avail comp-folh then do with frame {&frame-name}:
     find tabela-res where tabela-res.nr-tabela = comp-folh.nr-tabela no-lock no-error.
     if avail tabela-res then 
        display tabela-res.descricao @ c-descricao with frame f-main.
     else
        display "" @ c-descricao with frame f-main. 
     assign cb-tipo-result:screen-value = {ininc/i01in158.i 04 comp-folh.tipo-result}
            cb-forma-verif:screen-value = {ininc/i01in051.i 04 comp-folh.forma-verif}
            c-opcao = string({ininc/i01in158.i 06 cb-tipo-result:screen-value}).
            
     find tabela-res where tabela-res.nr-tabela = comp-folh.nr-tabela no-lock no-error.
     assign c-descricao = if avail tabela-res then tabela-res.descricao else "":U.
     
     assign c-vl-min-aux = comp-folh.vl-minimo:screen-value in frame {&frame-name}
            c-vl-max-aux = comp-folh.vl-maximo:screen-value in frame {&frame-name}.
  end.
  
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
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  assign i-opcao = if avail comp-folh then comp-folh.tipo-result else 1. 
  do with frame {&frame-name}:   
       assign comp-folh.nr-tabela:sensitive   = (i-opcao = 2)
              cb-forma-verif:sensitive        = (i-opcao = 2)
              comp-folh.nr-max-esc:sensitive  = (i-opcao = 2)
              comp-folh.un-medida:sensitive   = (i-opcao = 1 or i-opcao = 2)
              comp-folh.vl-minimo:sensitive   = (i-opcao = 1)  
              comp-folh.vl-maximo:sensitive   = (i-opcao = 1)  
              comp-folh.formato:sensitive     = (i-opcao = 1 or i-opcao = 4 or i-opcao = 6)  
              comp-folh.dt-minima:sensitive   = (i-opcao = 6)   
              comp-folh.dt-maxima:sensitive   = (i-opcao = 6).
      end.      
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

  do with frame {&frame-name}:
     assign cb-tipo-result:list-items = {ininc/i01in158.i 03}.
     assign cb-forma-verif:list-items = {ininc/i01in051.i 03}.
  end.
  
  find folh-espec where rowid(folh-espec) = v-row-parent no-lock no-error.
  assign rw-folh-espec = v-row-parent.
  
   /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  
         
  /* Code placed here will execute AFTER standard behavior.    */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
/*/*  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */*/
 *   
 * def var c-tabela as char format "x(20)".  
 *    
 * /**************************** Validaá∆o de Chave Duplicada **************************/
 *   
 *   
 *   if comp-folh.cd-comp:sensitive in frame {&frame-name} = yes
 *   and can-find(b-comp-folh where 
 *                b-comp-folh.cd-folha = folh-espec.cd-folha and
 *                b-comp-folh.cd-comp = input frame {&frame-name} comp-folh.cd-comp) then 
 *   do:
 *      {utp/ut-table.i mgind comp-folh 1}
 *      run utp/ut-msgs.p (input "show",
 *                         input 1,
 *                         input return-value).
 *      apply 'entry' to comp-folh.cd-comp in frame {&frame-name}.
 *      return 'adm-error':U.
 *   end.
 *  
 *   /******************************* Validaá∆o da Data *****************************/
 *   
 *   
 *   if input frame {&frame-name} comp-folh.dt-maxima < 
 *      input frame {&frame-name} comp-folh.dt-minima then
 *   do:
 *      {utp/ut-table.i mgind comp-folh 1}
 *      run utp/ut-msgs.p (input "show",
 *                         input 5069,
 *                         input return-value).
 *     apply 'entry' to comp-folh.dt-maxima in frame {&frame-name}.
 *     return 'adm-error':U.
 *   end.
 *    
 *   if comp-folh.dt-minima:sensitive in frame {&frame-name} = yes
 *   and string(input frame {&frame-name} comp-folh.dt-minima) = ? then 
 *   do:
 *      {utp/ut-table.i mgind comp-folh 1}
 *      run utp/ut-msgs.p (input "show",
 *                         input 5693,
 *                         input return-value).
 *      apply 'entry' to comp-folh.dt-minima in frame {&frame-name}.
 *      return 'adm-error':U.
 *   end.
 *   
 *   if comp-folh.dt-maxima:sensitive in frame {&frame-name} = yes
 *   and string(input frame {&frame-name} comp-folh.dt-maxima) = ? then 
 *   do:
 *      {utp/ut-table.i mgind comp-folh 1}
 *      run utp/ut-msgs.p (input "show",
 *                         input 5611,
 *                         input return-value).
 *      apply 'entry' to comp-folh.dt-maxima in frame {&frame-name}.
 *      return 'adm-error':U.
 *   end.
 *   
 *   
 *   /*******************************Validaá∆o do Valor**********************************/
 * 
 *  assign i-tp-resul = {ininc/i01in158.i 06 cb-tipo-result:screen-value}.
 * 
 *  if i-tp-resul = 1 then do:
 *       
 *        if input frame {&frame-name} comp-folh.vl-maximo = 0  then do:
 *           {utp/ut-field.i mgind comp-folh vl-maximo 1}
 *            run utp/ut-msgs.p (input "show",
 *                               input 7966,
 *                               input return-value).
 *            apply 'entry' to comp-folh.vl-maximo in frame {&frame-name}.
 *            return 'adm-error':U.
 *        end.
 * 
 *  end.
 *      
 *   if input frame {&frame-name} comp-folh.vl-maximo < 
 *      input frame {&frame-name} comp-folh.vl-minimo then
 *   do:
 *     {utp/ut-table.i mgind comp-folh 1}
 *      run utp/ut-msgs.p (input "show",
 *                         input 2831,
 *                         input return-value).
 *     apply 'entry' to comp-folh.vl-maximo in frame {&frame-name}.
 *     return 'adm-error':U.
 *   end.
 *   
 * /**************************** Validaá∆o do n£mero de escolhas de tabela **************************/
 *  if comp-folh.nr-tabela:sensitive in frame {&frame-name} = yes then do:
 *     
 *    assign i-escolha = 0.
 *    for each c-tab-res where 
 *             c-tab-res.nr-tabela = input frame {&frame-name} comp-folh.nr-tabela no-lock:
 *       assign  i-escolha = i-escolha + 1.
 *    end.
 *     if i-escolha = 0 then do:
 *        {utp/ut-table.i mgind tab-result 1} 
 *         assign c-tabela = return-value.
 *        {utp/ut-field.i mgind c-tab-res sequencia 1}
 *         run utp/ut-msgs.p (input "show",
 *                            input 5823,
 *                            input trim(return-value) + "~~" + c-tabela).
 *         apply 'entry' to comp-folh.nr-tabela in frame {&frame-name}.
 *         return 'adm-error':U.      
 *     end.
 *  
 *   
 *     if input frame {&frame-name} comp-folh.nr-max-esc > i-escolha or 
 *        input frame {&frame-name} comp-folh.nr-max-esc < 1 then do:
 *        {utp/ut-field.i mgind comp-folh nr-max-esc 1}
 *         run utp/ut-msgs.p (input "show",
 *                            input 3662,
 *                            input trim(return-value) + "~~" + '1' + "~~" + string(i-escolha)).
 *         apply 'entry' to comp-folh.nr-max-esc in frame {&frame-name}.
 *         return 'adm-error':U.      
 *     end.     
 *  
 *  end.   
 * 
 * /**************************** Validaá∆o do Formato **************************/
 *   
 *   if  comp-folh.formato:sensitive    in frame {&frame-name} = yes 
 *   and comp-folh.formato:screen-value in frame {&frame-name} = "" then 
 *   do:
 *      {utp/ut-table.i mgind comp-folh 1}
 *      run utp/ut-msgs.p (input "show",
 *                         input 5143,
 *                         input return-value).
 *      apply 'entry' to comp-folh.formato in frame {&frame-name}.
 *      return 'adm-error':U.
 *   end.  
 *   
 *   if input frame {&frame-name} cb-tipo-result = {ininc/i01in158.i 04 1} then
 *   do:
 *      assign ce-teste = string (input frame {&frame-name} comp-folh.vl-minimo,
 *                               input frame {&frame-name} comp-folh.formato) no-error.   
 *      if (index (ce-teste,'?')) <> 0 or error-status:error then                                      
 *         do: 
 *            run utp/ut-msgs.p (input "show",
 *                               input 2744,
 *                               input return-value).
 *            apply 'entry' to comp-folh.formato in frame {&frame-name}.
 *            return 'adm-error':U.
 *         end.
 *      assign ce-teste = string (input frame {&frame-name} comp-folh.vl-maximo,
 *                               input frame {&frame-name} comp-folh.formato) no-error.   
 *      if (index(ce-teste,'?')) <> 0 or error-status:error then 
 *         do:                                       
 *            run utp/ut-msgs.p (input "show",
 *                               input 2744,
 *                               input return-value).
 *            apply 'entry' to comp-folh.formato in frame {&frame-name}.
 *            return 'adm-error':U.
 *         end.  
 *   end.
 *   return 'ok'. ***/
 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "cod-exame" "comp-folh" "cod-exame"}
  {src/adm/template/sndkycas.i "cd-folha" "comp-folh" "cd-folha"}
  {src/adm/template/sndkycas.i "nr-tabela" "comp-folh" "nr-tabela"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

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
  {src/adm/template/snd-list.i "comp-folh"}

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


