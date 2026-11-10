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
{include/i-prgvrs.i V03IN281 2.00.00.019}  
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

def new global shared var v-row-parent as rowid no-undo.                                

{cdp/cdcfgman.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES param-cp
&Scoped-define FIRST-EXTERNAL-TABLE param-cp


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-cp.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-cp.cd-tipo param-cp.nr-ant-imp ~
param-cp.est-unico param-cp.cod-estabel param-cp.dep-fab-unico ~
param-cp.dep-fabrica param-cp.planej-op param-cp.planej-os 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cd-tipo ~{&FP2}cd-tipo ~{&FP3}~
 ~{&FP1}nr-ant-imp ~{&FP2}nr-ant-imp ~{&FP3}~
 ~{&FP1}cod-estabel ~{&FP2}cod-estabel ~{&FP3}~
 ~{&FP1}dep-fabrica ~{&FP2}dep-fabrica ~{&FP3}
&Scoped-define ENABLED-TABLES param-cp
&Scoped-define FIRST-ENABLED-TABLE param-cp
&Scoped-Define ENABLED-OBJECTS RECT-47 RECT-49 RECT-50 RECT-46 RECT-44 RECT-51 ~
RECT-43 f-plan-os 
&Scoped-Define DISPLAYED-FIELDS param-cp.cd-tipo param-cp.nr-ant-imp ~
param-cp.est-unico param-cp.cod-estabel param-cp.dep-fab-unico ~
param-cp.dep-fabrica param-cp.planej-op param-cp.planej-os 
&Scoped-Define DISPLAYED-OBJECTS c-per-descricao c-estabel-nome ~
c-depos-nome cod-dep-rec c-desc-dep-rec f-plan-op f-plan-os 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS cod-dep-rec 

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
DEFINE VARIABLE c-depos-nome AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-dep-rec AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-estabel-nome AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-per-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43.72 BY .88 NO-UNDO.

DEFINE VARIABLE cod-dep-rec AS CHARACTER FORMAT "X(3)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 7.43 BY .88 NO-UNDO.

DEFINE VARIABLE f-plan-op AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .63 NO-UNDO.

DEFINE VARIABLE f-plan-os AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .63 NO-UNDO.

DEFINE VARIABLE c-label-pendencia-mobile AS CHARACTER FORMAT "x(45)" 
     VIEW-AS TEXT 
     SIZE 25.72 BY .67 NO-UNDO.

DEFINE VARIABLE rs-gera-pendencia-apontamento-mobile AS INTEGER
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Nunca", 1,
          "Apenas processado com erro", 2,
          "Sempre on-line", 3,
          "Sempre Batch", 4 
     SIZE 68 BY .67 TOOLTIP "Simplificada (Padr∆o); Detalhada (Melhorada)" NO-UNDO.

DEFINE RECTANGLE RECT-43
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 77 BY 1.33.

DEFINE RECTANGLE RECT-44
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 77 BY 1.33.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 77 BY 1.33.

DEFINE RECTANGLE RECT-47
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 77 BY 3.13.

DEFINE RECTANGLE RECT-49
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 38 BY 1.29.

DEFINE RECTANGLE RECT-50
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 38 BY 1.29.

DEFINE RECTANGLE RECT-51
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 77 BY 1.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-cp.cd-tipo AT ROW 1.25 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     c-per-descricao AT ROW 1.25 COL 31.29 COLON-ALIGNED NO-LABEL
     param-cp.nr-ant-imp AT ROW 2.63 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     param-cp.est-unico AT ROW 2.67 COL 37
          VIEW-AS TOGGLE-BOX
          SIZE 25 BY .75
     param-cp.cod-estabel AT ROW 3.96 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-estabel-nome AT ROW 3.96 COL 35 COLON-ALIGNED NO-LABEL
     param-cp.dep-fab-unico AT ROW 5.29 COL 29.43
          VIEW-AS TOGGLE-BOX
          SIZE 29 BY .75
     param-cp.dep-fabrica AT ROW 6.08 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-depos-nome AT ROW 6.08 COL 35 COLON-ALIGNED NO-LABEL
     cod-dep-rec AT ROW 7.08 COL 27 COLON-ALIGNED
     c-desc-dep-rec AT ROW 7.08 COL 35 COLON-ALIGNED NO-LABEL
     param-cp.planej-op AT ROW 8.79 COL 8 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
          "Item", 1,
          "Linha", 2
          SIZE 31 BY .75
     param-cp.planej-os AT ROW 8.79 COL 47 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
          "Item", 1,
          "Linha", 2
          SIZE 31 BY .75
     rs-gera-pendencia-apontamento-mobile AT ROW 10.64 COL 8 NO-LABEL
     c-label-pendencia-mobile AT ROW 10 COL 3 NO-LABEL
     f-plan-op AT ROW 8.21 COL 2.72 NO-LABEL AUTO-RETURN 
     f-plan-os AT ROW 8.21 COL 40 COLON-ALIGNED NO-LABEL
     RECT-47 AT ROW 5.08 COL 2
     RECT-49 AT ROW 8.5 COL 2
     RECT-50 AT ROW 8.5 COL 41
     RECT-46 AT ROW 3.75 COL 2
     RECT-44 AT ROW 2.38 COL 2
     RECT-43 AT ROW 1.04 COL 2
     rect-51 AT ROW 10.34   COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-cp
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
         HEIGHT             = 8.83
         WIDTH              = 78.
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

/* SETTINGS FOR FILL-IN c-depos-nome IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-dep-rec IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-desc-dep-rec:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-estabel-nome IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-per-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cod-dep-rec IN FRAME f-main
   NO-ENABLE 2                                                          */
ASSIGN 
       cod-dep-rec:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN f-plan-op IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
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

&Scoped-define SELF-NAME param-cp.cd-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.cd-tipo V-table-Win
ON F5 OF param-cp.cd-tipo IN FRAME f-main /* Tipo Per°odo */
DO:
   {include/zoom.i &prog-zoom="inzoom/z01in436.w"
                  &tabela=param-cp
                  &atributo=cd-tipo}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.cd-tipo V-table-Win
ON LEAVE OF param-cp.cd-tipo IN FRAME f-main /* Tipo Per°odo */
DO:
   {include/leave.i &tabela=tipo-per
                 &atributo-ref=descricao
                 &variavel-ref=c-per-descricao
                 &where="tipo-per.cd-tipo = input frame {&frame-name} param-cp.cd-tipo"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.cd-tipo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-cp.cd-tipo IN FRAME f-main /* Tipo Per°odo */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cod-dep-rec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-dep-rec V-table-Win
ON F5 OF cod-dep-rec IN FRAME f-main
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                     &campo=cod-dep-rec
                     &campozoom=cod-depos
                     &campo2=c-desc-dep-rec
                     &campozoom2=nome}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-dep-rec V-table-Win
ON LEAVE OF cod-dep-rec IN FRAME f-main
DO:
   {include/leave.i &tabela=deposito
                   &atributo-ref=nome
                   &variavel-ref=c-desc-dep-rec
                   &where="deposito.cod-depos = input frame {&frame-name} cod-dep-rec"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cod-dep-rec V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cod-dep-rec IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-cp.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.cod-estabel V-table-Win
ON F5 OF param-cp.cod-estabel IN FRAME f-main /* Estabel Padr∆o */
DO:
  {include/zoom.i &prog-zoom="adzoom/z01ad107.w"
                  &tabela=param-cp
                  &atributo=cod-estabel}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.cod-estabel V-table-Win
ON LEAVE OF param-cp.cod-estabel IN FRAME f-main /* Estabel Padr∆o */
DO:
  {include/leave.i &tabela=estabelec
                   &atributo-ref=nome
                   &variavel-ref=c-estabel-nome
                   &where="estabelec.cod-estabel = input frame {&frame-name} param-cp.cod-estabel"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-cp.cod-estabel IN FRAME f-main /* Estabel Padr∆o */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-cp.dep-fabrica
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.dep-fabrica V-table-Win
ON F5 OF param-cp.dep-fabrica IN FRAME f-main /* Dep¢sito F†brica */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                     &campo=mgind.param-cp.dep-fabrica
                     &campozoom=cod-depos
                     &campo2=c-depos-nome
                     &campozoom2=nome}
                                          
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.dep-fabrica V-table-Win
ON LEAVE OF param-cp.dep-fabrica IN FRAME f-main /* Dep¢sito F†brica */
DO:
   {include/leave.i &tabela=deposito
                   &atributo-ref=nome
                   &variavel-ref=c-depos-nome
                   &where="deposito.cod-depos = input frame {&frame-name} param-cp.dep-fabric"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.dep-fabrica V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-cp.dep-fabrica IN FRAME f-main /* Dep¢sito F†brica */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  IF  param-cp.cd-tipo:LOAD-MOUSE-POINTER ("image~\lupa.cur") IN FRAME {&frame-name} THEN.
  IF  param-cp.cod-estabel:LOAD-MOUSE-POINTER ("image~\lupa.cur") IN FRAME {&frame-name} THEN.
  IF  param-cp.dep-fabric:LOAD-MOUSE-POINTER ("image~\lupa.cur") IN FRAME {&frame-name} THEN.  

  &IF DEFINED (bf_man_sfc_lc) &THEN
      IF cod-dep-rec:LOAD-MOUSE-POINTER ("image~\lupa.cur") IN FRAME {&frame-name} THEN.
      
      {utp/ut-field.i mgind deposito log-reciclagem 01}
      assign cod-dep-rec:label in frame {&frame-name} = return-value.
  &ENDIF

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
  {src/adm/template/row-list.i "param-cp"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-cp"}

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

  {utp/ut-rtlbl.i mgind param-cp planej-op f-plan-op}

  {utp/ut-rtlbl.i mgind param-cp planej-os f-plan-os}

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
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  
  FIND CURRENT param-manuf EXCLUSIVE-LOCK NO-ERROR.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */
  
  ASSIGN param-cp.cd-tipo          = INPUT FRAME {&frame-name} param-cp.cd-tipo
         param-cp.nr-ant-imp       = INPUT FRAME {&frame-name} param-cp.nr-ant-imp
         param-cp.est-unico        = INPUT FRAME {&frame-name} param-cp.est-unico
         param-cp.cod-estabel      = INPUT FRAME {&frame-name} param-cp.cod-estabel
         param-cp.dep-fab-unico    = INPUT FRAME {&frame-name} param-cp.dep-fab-unico
         param-cp.dep-fabrica      = INPUT FRAME {&frame-name} param-cp.dep-fabrica
         param-cp.planej-op        = INPUT FRAME {&frame-name} planej-op
         param-cp.planej-os        = INPUT FRAME {&frame-name} planej-os
         param-manuf.param-inteiro = INPUT FRAME {&frame-name} rs-gera-pendencia-apontamento-mobile.
  
  &IF DEFINED (bf_man_sfc_lc) &THEN
      assign substr(param-cp.char-2,1,3) = string(input frame {&frame-name} cod-dep-rec,"x(03)").
  &ENDIF
  
  
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
  
   if  avail param-cp then do:
       FIND tipo-per WHERE tipo-per.cd-tipo =  integer(param-cp.cd-tipo:screen-value in frame {&frame-name}) NO-LOCK NO-ERROR.
       ASSIGN c-per-descricao = IF AVAIL tipo-per THEN tipo-per.descricao ELSE "":U.

       FIND estabelec WHERE estabelec.cod-estabel = param-cp.cod-estabel:screen-value in frame {&frame-name} NO-LOCK NO-ERROR.
       ASSIGN c-estabel-nome = IF AVAIL estabelec THEN estabelec.nome ELSE "":U.

       FIND deposito WHERE deposito.cod-depos = param-cp.dep-fabrica:screen-value in frame {&frame-name} NO-LOCK NO-ERROR.
       ASSIGN c-depos-nome = IF AVAIL deposito THEN deposito.nome ELSE "":U.
       
       &IF DEFINED (bf_man_sfc_lc) &THEN
            assign cod-dep-rec = substr(param-cp.char-2,1,3).
            FIND deposito WHERE deposito.cod-depos = cod-dep-rec NO-LOCK NO-ERROR.
            ASSIGN c-desc-dep-rec = IF AVAIL deposito THEN deposito.nome ELSE "":U.
       &ENDIF
   end.   

  {utp/ut-rtlbl.i mgind param-cp planej-op f-plan-op}
  
  {utp/ut-rtlbl.i mgind param-cp planej-os f-plan-os}  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
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

  {utp/ut-rtlbl.i mgind param-cp planej-op f-plan-op}
  
  {utp/ut-rtlbl.i mgind param-cp planej-os f-plan-os}  

  {utp/ut-liter.i Gera_pendància_Apontamento_mobile * }

  ASSIGN c-label-pendencia-mobile:SCREEN-VALUE IN FRAME {&FRAME-NAME} = RETURN-VALUE.

  ENABLE rs-gera-pendencia-apontamento-mobile WITH FRAME {&FRAME-NAME}.
         

  FOR FIRST param-manuf
      WHERE param-manuf.cod-entid = "param-cp"
        AND param-manuf.cod-param = "gera-pendencia-mobile" EXCLUSIVE-LOCK:
  END.

  IF NOT AVAIL param-manuf THEN DO:

      CREATE param-manuf.
      ASSIGN param-manuf.cod-entid = "param-cp"                      
             param-manuf.cod-param = "gera-pendencia-mobile"
             param-manuf.dsl-help-msg = "1 - Nunca gera pendància; 2 - Gera pendància apenas em caso de erro no apontamento; 3 - Sempre gera pendància; 4 - Gera pendància, mas n∆o realiza o apontamento"
             param-manuf.desc-param = "Gera pendància reporte mobile"
             param-manuf.param-inteiro = 1
             param-manuf.titulo = "Gera pendància Mobile".
  END. 

  ASSIGN rs-gera-pendencia-apontamento-mobile:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(param-manuf.param-inteiro).

  FIND CURRENT param-manuf NO-LOCK NO-ERROR.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  &IF DEFINED (bf_man_sfc_lc) &THEN
      assign cod-dep-rec:hidden    in frame {&frame-name} = no
             c-desc-dep-rec:hidden in frame {&frame-name} = no
             cod-dep-rec:sensitive in frame {&frame-name} = yes.
  &ENDIF
  
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
  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */
   
   /*Segue um exemplo de validaá∆o de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/
 
 find estabelec where
      estabelec.cod-estabel = input frame {&FRAME-NAME} param-cp.cod-estabel
                               no-lock no-error.
 if not avail estabelec then do :                              
    {include/i-vldprg.i}
           run utp/ut-msgs.p (input "show":U, 
                              input 13, 
                              input "").
           apply "entry" to param-cp.cod-estabel in frame   {&FRAME-NAME} .                 
           return 'ADM-ERROR':U.        
 end.

 
  &IF DEFINED (bf_man_sfc_lc) &THEN
      if input frame {&frame-name} cod-dep-rec <> "" then do:
        find first deposito
             where deposito.cod-depos = input frame {&frame-name} cod-dep-rec no-lock no-error.
        if not avail deposito then do:
           {include/i-vldprg.i}
           {utp/ut-field.i mgind deposito cod-depos 01}
           run utp/ut-msgs.p (input "show":U, 
                              input 47, 
                              input return-value).
           apply 'entry' to cod-dep-rec in frame {&frame-name}.
           return 'ADM-ERROR':U.        
        end.
        else if not deposito.log-reciclagem then do:
           {include/i-vldprg.i}
           run utp/ut-msgs.p (input "show":U, 
                              input 18982, 
                              input "").
           apply 'entry' to cod-dep-rec in frame {&frame-name}.
           return 'ADM-ERROR':U.      
        end.
      end.
  &ENDIF
 
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
  {src/adm/template/snd-list.i "param-cp"}

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


