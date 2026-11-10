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
{include/i-prgvrs.i V02IN371 2.00.00.008}  /*** 010008 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN371 MUT}
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
def var c-lista-classe as char no-undo.
def var rw-produto as rowid no-undo.
def buffer b-rec-prod for rec-prod.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES rec-prod
&Scoped-define FIRST-EXTERNAL-TABLE rec-prod


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR rec-prod.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS rec-prod.qt-utilizada rec-prod.qt-produto ~
rec-prod.dias-utiliz rec-prod.defasagem rec-prod.observacao 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}qt-utilizada ~{&FP2}qt-utilizada ~{&FP3}~
 ~{&FP1}qt-produto ~{&FP2}qt-produto ~{&FP3}~
 ~{&FP1}dias-utiliz ~{&FP2}dias-utiliz ~{&FP3}~
 ~{&FP1}defasagem ~{&FP2}defasagem ~{&FP3}~
 ~{&FP1}observacao ~{&FP2}observacao ~{&FP3}
&Scoped-define ENABLED-TABLES rec-prod
&Scoped-define FIRST-ENABLED-TABLE rec-prod
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold rt-mold-2 
&Scoped-Define DISPLAYED-FIELDS rec-prod.sequencia produto.cd-produto ~
rec-prod.tp-recurso produto.descricao rec-prod.cd-recurso ~
rec-prod.qt-utilizada rec-prod.qt-produto rec-prod.dias-utiliz ~
rec-prod.defasagem rec-prod.observacao tp-recur.cod-unid-capac 
&Scoped-Define DISPLAYED-OBJECTS c-cl-recurso c-tp-recur-descricao c-un ~
c-descricao 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS rec-prod.sequencia rec-prod.tp-recurso ~
rec-prod.cd-recurso 

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
DEFINE VARIABLE c-cl-recurso AS CHARACTER FORMAT "X(30)":U 
     LABEL "Classe" 
     VIEW-AS FILL-IN 
     SIZE 22.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "x(35)" 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-tp-recur-descricao AS CHARACTER FORMAT "x(35)" 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-un AS CHARACTER FORMAT "xx" 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 5.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.33.

DEFINE RECTANGLE rt-mold-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     rec-prod.sequencia AT ROW 2.17 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     produto.cd-produto AT ROW 1.17 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     rec-prod.tp-recurso AT ROW 3.17 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     produto.descricao AT ROW 1.17 COL 39.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 36.14 BY .88
     c-cl-recurso AT ROW 4.17 COL 22 COLON-ALIGNED
     rec-prod.cd-recurso AT ROW 5.17 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     rec-prod.qt-utilizada AT ROW 7.67 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     rec-prod.qt-produto AT ROW 6.67 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY 1
     rec-prod.dias-utiliz AT ROW 6.67 COL 69 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     rec-prod.defasagem AT ROW 7.67 COL 69 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     rec-prod.observacao AT ROW 9.04 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 40.72 BY .88
     c-tp-recur-descricao AT ROW 3.17 COL 32 COLON-ALIGNED NO-LABEL
     c-un AT ROW 6.67 COL 30.86 COLON-ALIGNED HELP
          "Unidade de medida do produto" NO-LABEL
     tp-recur.cod-unid-capac AT ROW 7.67 COL 48.44 RIGHT-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .88
     c-descricao AT ROW 5.17 COL 40.29 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 6.42 COL 1
     rt-mold-2 AT ROW 8.88 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.rec-prod
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
         HEIGHT             = 9.13
         WIDTH              = 88.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cl-recurso IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tp-recur-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN produto.cd-produto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN rec-prod.cd-recurso IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN tp-recur.cod-unid-capac IN FRAME f-main
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN produto.descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN rec-prod.sequencia IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN rec-prod.tp-recurso IN FRAME f-main
   NO-ENABLE 1                                                          */
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

&Scoped-define SELF-NAME rec-prod.cd-recurso
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rec-prod.cd-recurso V-table-Win
ON F5 OF rec-prod.cd-recurso IN FRAME f-main /* Recurso */
DO:
  {utp/ut-field.i mgind tp-recur tp-recurso 1}
  find tp-recur where tp-recur.tp-recurso = 
       input frame {&frame-name} rec-prod.tp-recurso no-lock no-error.
  if avail tp-recur then do:
     assign l-implanta = yes.
     {include/zoomvar.i &prog-zoom=inzoom/z01in373.w
                        &campo=rec-prod.cd-recurso
                        &campozoom=cd-recurso
                        &parametros="run pi-seta-inicial in wh-pesquisa 
                                    (input rec-prod.tp-recurso:screen-value)."}
  end.
  else run utp/ut-msgs.p (input "show",
                          input 47,
                          input return-value).


  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rec-prod.cd-recurso V-table-Win
ON LEAVE OF rec-prod.cd-recurso IN FRAME f-main /* Recurso */
DO:
  if {ininc/i01in439.i 06 c-cl-recurso:screen-value in frame {&frame-name}} = 1 then do:
     find first mgind.recurso
          WHERE mgind.recurso.tp-recurso = input frame {&frame-name} rec-prod.tp-recurso 
          and   mgind.recurso.cd-recurso = input frame {&frame-name} rec-prod.cd-recurso  no-lock no-error.
     find grup-maquina where grup-maquina.gm-codigo = recurso.gm-codigo no-lock no-error.
     assign c-descricao:screen-value in frame {&frame-name} = if avail grup-maquina then grup-maquina.descricao else "":U.
  end.
  else 
  if {ininc/i01in439.i 06 c-cl-recurso:screen-value in frame {&frame-name}} = 2 then do:
     find first mgind.recurso
          WHERE mgind.recurso.tp-recurso = input frame {&frame-name} rec-prod.tp-recurso
          and   mgind.recurso.cd-recurso = input frame {&frame-name} rec-prod.cd-recurso no-lock no-error.
     find item  where item.it-codigo = recurso.it-codigo no-lock no-error.
     assign c-descricao:screen-value in frame {&frame-name} = if avail item then item.desc-item else "":U.
  end.
  else 
  if {ininc/i01in439.i 06 c-cl-recurso:screen-value in frame {&frame-name}} = 3 then do:
     find first mgind.recurso
          WHERE mgind.recurso.tp-recurso = input frame {&frame-name} rec-prod.tp-recurso
          and   mgind.recurso.cd-recurso = input frame {&frame-name} rec-prod.cd-recurso no-lock no-error.
     find equipto where equipto.cd-equipto = recurso.cod-altern no-lock no-error.
     assign c-descricao:screen-value in frame {&frame-name} = if avail equipto then equipto.descricao else "":U.
  end. 
  else assign c-descricao:screen-value in frame {&frame-name} = "":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rec-prod.cd-recurso V-table-Win
ON MOUSE-SELECT-DBLCLICK OF rec-prod.cd-recurso IN FRAME f-main /* Recurso */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rec-prod.tp-recurso
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rec-prod.tp-recurso V-table-Win
ON F5 OF rec-prod.tp-recurso IN FRAME f-main /* Tipo Recurso */
DO:
   assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z01in439.w
                     &campo=rec-prod.tp-recurso
                     &campozoom=tp-recurso
                     &campo2=c-tp-recur-descricao
                     &campozoom2=descricao
                     &campo3=tp-recur.cod-unid-capac
                     &campozoom3=cod-unid-capac}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rec-prod.tp-recurso V-table-Win
ON LEAVE OF rec-prod.tp-recurso IN FRAME f-main /* Tipo Recurso */
DO:
  {include/leave.i &tabela=tp-recur
                   &atributo-ref=descricao
                   &variavel-ref=c-tp-recur-descricao
                   &atributo-ref2=cod-unid-capac
                   &variavel=tp-recur.cod-unid-capac
                   &where="tp-recur.tp-recurso = input frame {&frame-name} rec-prod.tp-recurso"}
   if avail tp-recur then do with frame {&frame-name}:
      assign c-cl-recurso:screen-value = {ininc/i01in439.i 04 tp-recur.cl-recurso}.
   end.
   assign c-un:screen-value in frame {&frame-name} = if avail produto then produto.un else "":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rec-prod.tp-recurso V-table-Win
ON MOUSE-SELECT-DBLCLICK OF rec-prod.tp-recurso IN FRAME f-main /* Tipo Recurso */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
 {utp/ut-field.i mgind tp-recur cl-recurso 1}
 assign c-cl-recurso:label in frame {&frame-name} = return-value.

 if rec-prod.tp-recurso:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.       
 if rec-prod.cd-recurso:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.


  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

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
  {src/adm/template/row-list.i "rec-prod"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "rec-prod"}

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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  find last param-pm no-lock no-error.
  find produto where rowid(produto) = v-row-parent no-lock.
  find last b-rec-prod where b-rec-prod.cd-produto = produto.cd-produto no-lock no-error.
  if avail b-rec-prod then
     display (b-rec-prod.sequencia + param-pm.num-var-recurso) @ rec-prod.sequencia with frame {&frame-name}.
  else 
     display param-pm.num-var-recurso @ rec-prod.sequencia with frame {&frame-name}.


     display c-un with frame {&frame-name}.  

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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  find produto where rowid(produto) = v-row-parent no-lock.

  If rec-prod.sequencia:sensitive in frame {&frame-name} = yes then do:
     /*** valida‡Æo recurso ***/
     find recurso 
          where recurso.tp-recurso = input frame {&frame-name} rec-prod.tp-recurso
          and   recurso.cd-recurso = input frame {&frame-name} rec-prod.cd-recurso
          no-lock no-error.
     if not avail recurso then do:
        {utp/ut-table.i mgind recurso 1}
        run utp/ut-msgs.p (input 'show',
                           input 47,
                           input return-value).
        apply 'entry' to rec-prod.cd-recurso in frame {&frame-name}.
        return 'adm-error':U.
     end.

     /*** Valida‡Æo chave duplicada ***/
     if can-find(b-rec-prod 
                 where b-rec-prod.cd-produto = produto.cd-produto
                 and   b-rec-prod.sequencia  = input frame {&frame-name} rec-prod.sequencia
                 and   b-rec-prod.tp-recurso = input frame {&frame-name} rec-prod.tp-recurso
                 and   b-rec-prod.cd-recurso = input frame {&frame-name} rec-prod.cd-recurso) then do:
        {utp/ut-table.i mgind rec-prod 1}
        run utp/ut-msgs.p (input 'show',
                           input 1,
                           input return-value).
        apply 'entry' to rec-prod.sequencia in frame {&frame-name}.
        return 'adm-error':U.
     end.
  end.
  if rec-prod.dias-utiliz:sensitive = yes and
     integer(rec-prod.dias-utiliz:screen-value) = 0 then do: 
     run utp/ut-msgs.p (input 'show',
                        input 6576,
                        input return-value).
     apply 'entry' to rec-prod.dias-utiliz in frame {&frame-name}.
     return 'adm-error':U.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */
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

  find produto  where rowid(produto) = v-row-parent no-error.
  if available produto  then do:
    assign rec-prod.cd-produto = produto.cd-produto.
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
   if avail rec-prod then do:
      find tp-recur where tp-recur.tp-recurso = rec-prod.tp-recurso no-lock no-error.
      find produto of rec-prod no-lock no-error. 
      assign c-tp-recur-descricao = if avail tp-recur then tp-recur.descricao else ""
             c-cl-recurso         = {ininc/i01in439.i 04 tp-recur.cl-recurso}
             c-un                 = if avail produto then produto.un else "".

   end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  find recurso of rec-prod no-lock no-error.
  if avail tp-recur then do:
     display tp-recur.cod-unid-capac with frame {&frame-name}.
     if tp-recur.cl-recurso = 1 then do:
        find grup-maquina where grup-maquina.gm-codigo = recurso.gm-codigo no-lock.
        assign c-descricao:screen-value in frame {&frame-name} = grup-maquina.descricao.
     end.
     else if tp-recur.cl-recurso = 2 then do:
          find item where item.it-codigo = recurso.it-codigo no-lock no-error.
          assign c-descricao:screen-value  in frame {&frame-name} = item.desc-item.
       end.
       else if tp-recur.cl-recurso = 3 then do:
          find equipto where equipto.cd-equipto = recurso.cod-alternat no-lock no-error.
          assign c-descricao:screen-value in frame {&frame-name}  = equipto.descricao.
       end.
       else assign c-descricao:screen-value in frame {&frame-name}  = "". 
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

  find produto where rowid(produto) = v-row-parent no-lock no-error.

  assign rw-produto = v-row-parent.

  assign c-un           = produto.un
         c-lista-classe = {ininc/i01in439.i 03}.

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
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */

   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/

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
  {src/adm/template/snd-list.i "rec-prod"}

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


