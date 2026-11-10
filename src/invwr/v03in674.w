&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
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
{include/i-prgvrs.i V03IN674 2.00.00.006}  /*** 010006 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v03in674 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

def var i-classif-abc as int no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS fam-mat-estab.cd-freq ~
fam-mat-estab.cod-comprado fam-mat-estab.cod-grp-compra ~
fam-mat-estab.crit-cc fam-mat-estab.crit-ce fam-mat-estab.cod-fat-ponder ~
fam-mat-estab.altera-conta fam-mat-estab.fator-refugo 
&Scoped-define ENABLED-TABLES fam-mat-estab
&Scoped-define FIRST-ENABLED-TABLE fam-mat-estab
&Scoped-Define ENABLED-OBJECTS rt-mold c-cod-estab-gestor 
&Scoped-Define DISPLAYED-FIELDS fam-mat-estab.cd-freq ~
fam-mat-estab.cod-comprado fam-mat-estab.cod-grp-compra ~
fam-mat-estab.crit-cc fam-mat-estab.crit-ce fam-mat-estab.cod-fat-ponder ~
fam-mat-estab.altera-conta fam-mat-estab.fator-refugo 
&Scoped-define DISPLAYED-TABLES fam-mat-estab
&Scoped-define FIRST-DISPLAYED-TABLE fam-mat-estab
&Scoped-Define DISPLAYED-OBJECTS c-desc-freq c-desc-comprador ~
c-des-grp-compra c-desc-formula c-cod-estab-gestor c-desc-gestor 

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
DEFINE VARIABLE c-cod-estab-gestor LIKE estabelec.cod-estabel
     LABEL "Estabelecimento Gestor":R24 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-grp-compra AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-comprador AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-formula AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-freq AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-gestor AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 47.72 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 87.29 BY 10.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     fam-mat-estab.cd-freq AT ROW 2.04 COL 29.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-desc-freq AT ROW 2.04 COL 34 COLON-ALIGNED NO-LABEL
     fam-mat-estab.cod-comprado AT ROW 3.04 COL 29.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     c-desc-comprador AT ROW 3.04 COL 45.72 COLON-ALIGNED NO-LABEL
     fam-mat-estab.cod-grp-compra AT ROW 4.04 COL 29.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     c-des-grp-compra AT ROW 4.04 COL 45.72 COLON-ALIGNED NO-LABEL
     fam-mat-estab.crit-cc AT ROW 5.04 COL 29.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.14 BY .88
     fam-mat-estab.crit-ce AT ROW 6.04 COL 29.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.14 BY .88
     fam-mat-estab.cod-fat-ponder AT ROW 7.04 COL 29.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-desc-formula AT ROW 7.04 COL 33.86 COLON-ALIGNED NO-LABEL
     fam-mat-estab.altera-conta AT ROW 8.04 COL 31.14
          VIEW-AS TOGGLE-BOX
          SIZE 24.57 BY .83
     fam-mat-estab.fator-refugo AT ROW 9.04 COL 29.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     c-cod-estab-gestor AT ROW 10.04 COL 29.14 COLON-ALIGNED
          LABEL "Estabelecimento Gestor":R24
     c-desc-gestor AT ROW 10.04 COL 34.29 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 10.33
         WIDTH              = 87.57.
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

/* SETTINGS FOR FILL-IN c-cod-estab-gestor IN FRAME f-main
   LIKE = mgcad.estabelec.cod-estabel EXP-LABEL EXP-SIZE                */
/* SETTINGS FOR FILL-IN c-des-grp-compra IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-comprador IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-formula IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-freq IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-gestor IN FRAME f-main
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME c-cod-estab-gestor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estab-gestor V-table-Win
ON F5 OF c-cod-estab-gestor IN FRAME f-main /* Estabelecimento Gestor */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                     &campo=c-cod-estab-gestor
                     &campozoom=cod-estabel}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estab-gestor V-table-Win
ON LEAVE OF c-cod-estab-gestor IN FRAME f-main /* Estabelecimento Gestor */
DO:
{include/leave.i &tabela=estabelec
                 &atributo-ref=nome
                 &variavel-ref=c-desc-gestor
                 &where="estabelec.cod-estabel = input frame {&frame-name} 
                         c-cod-estab-gestor"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estab-gestor V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-estab-gestor IN FRAME f-main /* Estabelecimento Gestor */
DO:
{include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                   &campo=c-cod-estab-gestor
                   &campozoom=cod-estabel}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fam-mat-estab.cd-freq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-mat-estab.cd-freq V-table-Win
ON F5 OF fam-mat-estab.cd-freq IN FRAME f-main /* Freq Fornecimento */
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z01ad122.w
                     &campo=fam-mat-estab.cd-freq
                     &campozoom=cd-freq}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-mat-estab.cd-freq V-table-Win
ON LEAVE OF fam-mat-estab.cd-freq IN FRAME f-main /* Freq Fornecimento */
DO:
  {include/leave.i &tabela=frequencia
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-freq
                   &where="frequencia.cd-freq = input frame {&frame-name}
                           fam-mat-estab.cd-freq"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-mat-estab.cd-freq V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fam-mat-estab.cd-freq IN FRAME f-main /* Freq Fornecimento */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fam-mat-estab.cod-comprado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-mat-estab.cod-comprado V-table-Win
ON F5 OF fam-mat-estab.cod-comprado IN FRAME f-main /* Comprador */
DO:
  {include/zoomvar.i &prog-zoom=inzoom/z01in055.w
                       &campo=fam-mat-estab.cod-comprado
                       &campozoom=cod-comprado}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-mat-estab.cod-comprado V-table-Win
ON LEAVE OF fam-mat-estab.cod-comprado IN FRAME f-main /* Comprador */
DO:
  {include/leave.i &tabela=comprador
                     &atributo-ref=nome
                     &variavel-ref=c-desc-comprador
                     &where="comprador.cod-comprado = input frame {&frame-name}
                             fam-mat-estab.cod-comprado"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-mat-estab.cod-comprado V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fam-mat-estab.cod-comprado IN FRAME f-main /* Comprador */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fam-mat-estab.cod-fat-ponder
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-mat-estab.cod-fat-ponder V-table-Win
ON F5 OF fam-mat-estab.cod-fat-ponder IN FRAME f-main /* F¢rmulas Pondera‡äes */
DO:
  {include/zoomvar.i &prog-zoom=inzoom/z01in659.w
                     &campo=fam-mat-estab.cod-fat-ponder
                     &campozoom=cod-fat-ponder}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-mat-estab.cod-fat-ponder V-table-Win
ON LEAVE OF fam-mat-estab.cod-fat-ponder IN FRAME f-main /* F¢rmulas Pondera‡äes */
DO:
  {include/leave.i &tabela=fat-ponder
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-formula
                     &where="fat-ponder.cod-fat-ponder = input frame {&frame-name}
                             fam-mat-estab.cod-fat-ponder"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-mat-estab.cod-fat-ponder V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fam-mat-estab.cod-fat-ponder IN FRAME f-main /* F¢rmulas Pondera‡äes */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fam-mat-estab.cod-grp-compra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-mat-estab.cod-grp-compra V-table-Win
ON F5 OF fam-mat-estab.cod-grp-compra IN FRAME f-main /* Grupo Compra */
DO:
  {include/zoomvar.i &prog-zoom=inzoom/z01in455.w
                       &campo=fam-mat-estab.cod-grp-compra 
                       &campozoom=cod-grp-compra}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-mat-estab.cod-grp-compra V-table-Win
ON LEAVE OF fam-mat-estab.cod-grp-compra IN FRAME f-main /* Grupo Compra */
DO:
  {include/leave.i &tabela=grupo-compra
                     &atributo-ref=des-grp-compra
                     &variavel-ref=c-des-grp-compra
                     &where="grupo-compra.cod-grp-compra = input frame {&frame-name}
                             fam-mat-estab.cod-grp-compra"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-mat-estab.cod-grp-compra V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fam-mat-estab.cod-grp-compra IN FRAME f-main /* Grupo Compra */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fam-mat-estab.crit-cc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-mat-estab.crit-cc V-table-Win
ON LEAVE OF fam-mat-estab.crit-cc IN FRAME f-main /* Criticidade Compra */
DO:
  if adm-new-record then do:
      RUN Get-Field-Screen-Value IN adm-broker-hdl
         (INPUT THIS-PROCEDURE,
          INPUT "cb-classificacao-abc").
      assign i-classif-abc = {ininc/i01in598.i 06 return-value}.
      for first recalc-fat-ponder fields (classif-abc crit-cc crit-ce cod-fat-ponder) where
            recalc-fat-ponder.classif-abc = i-classif-abc and
            recalc-fat-ponder.crit-cc     = input frame {&frame-name} fam-mat-estab.crit-cc and
            recalc-fat-ponder.crit-ce     = input frame {&frame-name} fam-mat-estab.crit-ce no-lock: end.
      if avail recalc-fat-ponder then
           assign fam-mat-estab.cod-fat-ponder:screen-value in frame {&frame-name} = string(recalc-fat-ponder.cod-fat-ponder).
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fam-mat-estab.crit-ce
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-mat-estab.crit-ce V-table-Win
ON LEAVE OF fam-mat-estab.crit-ce IN FRAME f-main /* Criticidade Estocagem */
DO:
  if adm-new-record then do:
      RUN Get-Field-Screen-Value IN adm-broker-hdl
         (INPUT THIS-PROCEDURE,
          INPUT "cb-classificacao-abc").
      assign i-classif-abc = {ininc/i01in598.i 06 return-value}.
      for first recalc-fat-ponder fields (classif-abc crit-cc crit-ce cod-fat-ponder) where
            recalc-fat-ponder.classif-abc = i-classif-abc and
            recalc-fat-ponder.crit-cc     = input frame {&frame-name} fam-mat-estab.crit-cc and
            recalc-fat-ponder.crit-ce     = input frame {&frame-name} fam-mat-estab.crit-ce no-lock: end.
      if avail recalc-fat-ponder then
           assign fam-mat-estab.cod-fat-ponder:screen-value in frame {&frame-name} = string(recalc-fat-ponder.cod-fat-ponder).
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
  if c-cod-estab-gestor:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.       
  if fam-mat-estab.cd-freq:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.       
  if fam-mat-estab.cod-comprado:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if fam-mat-estab.cod-grp-compra:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if fam-mat-estab.cod-fat-ponder:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  disable c-cod-estab-gestor with frame {&frame-name}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}
    
    /* Ponha na pi-validate todas as valida‡äes */
    /* NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  

     &IF "{&mguni_version}" >= "2.071" &THEN
     assign substring(fam-mat-estab.char-2,97,5) = input frame {&frame-name} c-cod-estab-gestor:screen-value. 
     &ELSE
     assign substring(fam-mat-estab.char-2,97,3) = input frame {&frame-name} c-cod-estab-gestor:screen-value. 
     &ENDIF
     
    
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
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    disable c-cod-estab-gestor with frame {&frame-name}.
     
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
  if avail fam-mat-estab then do with frame {&frame-name}:
      
      &IF "{&mguni_version}" >= "2.071" &THEN
      assign c-cod-estab-gestor:screen-value = substring(fam-mat-estab.char-2,97,5). 
      &ELSE
      assign c-cod-estab-gestor:screen-value = substring(fam-mat-estab.char-2,97,3). 
      &ENDIF

      for first frequencia fields (cd-freq descricao) where
          frequencia.cd-freq = fam-mat-estab.cd-freq no-lock: end.
      if avail frequencia then 
          assign c-desc-freq:screen-value  = frequencia.descricao.
      for first comprador fields (cod-comprado nome) where
          comprador.cod-comprado = fam-mat-estab.cod-comprado no-lock: end.          
      if avail comprador then 
          assign c-desc-comprador:screen-value = comprador.nome.
      for first fat-ponder fields (cod-fat-ponder descricao) where
          fat-ponder.cod-fat-ponder = fam-mat-estab.cod-fat-ponder no-lock: end.          
      if avail fat-ponder then 
          assign c-desc-formula:screen-value = fat-ponder.descricao.
      for first estabelec fields (cod-estabel nome) where
          &IF "{&mguni_version}" >= "2.071" &THEN
          estabelec.cod-estabel = substring(fam-mat-estab.char-2,97,5)
          &ELSE
          estabelec.cod-estabel = substring(fam-mat-estab.char-2,97,3)
          &ENDIF
          no-lock: end.          
      if avail estabelec then 
         assign c-desc-gestor:screen-value in frame {&frame-name} = estabelec.nome.
  end.
  else 
      assign c-desc-freq:screen-value in frame {&frame-name} = " "
             c-desc-comprador:screen-value in frame {&frame-name} = " "      
             c-desc-formula:screen-value in frame {&frame-name} = " ".
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
    if avail param-compra then do:
        if param-compra.int-2 = 1 then
            assign fam-mat-estab.cod-grp-compra:sensitive in frame {&frame-name} = yes
                   fam-mat-estab.cod-comprado:sensitive in frame {&frame-name}   = no.
        else 
            assign fam-mat-estab.cod-grp-compra:sensitive in frame {&frame-name} = no
                   fam-mat-estab.cod-comprado:sensitive in frame {&frame-name}   = yes.
    end.

    if avail param-compra then do:
        if  substring(param-compra.char-2,97,3) = "YES" then
            assign c-cod-estab-gestor:sensitive in frame {&frame-name} = yes.
        else
            assign c-cod-estab-gestor:sensitive in frame {&frame-name} = no.
    end.

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
  find first param-compra no-lock no-error.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  {utp/ut-liter.i Classifica‡Æo_Cont bil * R}
  assign fam-mat-estab.altera-conta:label in frame {&frame-name} = return-value.
  disable c-cod-estab-gestor with frame {&frame-name}.  
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desabilita V-table-Win 
PROCEDURE pi-desabilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter cb-tp-ressup as char no-undo.

if cb-tp-ressup <> {ininc/i01in598.i 04 3} then 
    assign fam-mat-estab.cd-freq:screen-value in frame {&frame-name} = "0"
           c-desc-freq:screen-value              in frame {&frame-name} = " "
           fam-mat-estab.cd-freq:sensitive    in frame {&frame-name} = no.
else 
    assign fam-mat-estab.cd-freq:sensitive    in frame {&frame-name} = yes.
    
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
 if not can-find (comprador where
     comprador.cod-comprado = input frame {&frame-name} fam-mat-estab.cod-comprado) and
     fam-mat-estab.cod-comprado:sensitive in frame {&frame-name} then do:
      {include/i-vldprg.i}
      {utp/ut-table.i mgind comprador 1}
      run utp/ut-msgs.p (input "show":U, input 56, input return-value).
      apply "entry" to fam-mat-estab.cod-comprado in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  if not can-find (frequencia where
     frequencia.cd-freq = input frame {&frame-name} fam-mat-estab.cd-freq) and
     fam-mat-estab.cd-freq:sensitive in frame {&frame-name} then do:
      {include/i-vldprg.i}
      {utp/ut-table.i mgadm frequencia 1}
      run utp/ut-msgs.p (input "show":U, input 56, input return-value).
      apply "entry" to fam-mat-estab.cd-freq in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  if not can-find (fat-ponder where
     fat-ponder.cod-fat-ponder = input frame {&frame-name} fam-mat-estab.cod-fat-ponder) and
     input frame {&frame-name} fam-mat-estab.cod-fat-ponder <> 0 then do:
      {include/i-vldprg.i}
      {utp/ut-table.i mgind fat-ponder 1}
      run utp/ut-msgs.p (input "show":U, input 56, input return-value).
      apply "entry" to fam-mat-estab.cod-fat-ponder in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  if not can-find(grupo-compra where
                  grupo-compra.cod-grp-compra = input frame {&frame-name} fam-mat-estab.cod-grp-compra) and 
      fam-mat-estab.cod-grp-compra:sensitive in frame {&frame-name} then do:
      {include/i-vldprg.i}
      {utp/ut-liter.i Grupo_Compras * C}
      run utp/ut-msgs.p (input "show", input 47, input trim(return-value)).
      apply "entry" to fam-mat-estab.cod-grp-compra.
      return "adm-error".
  end.

  find first param-compra no-lock no-error.
  if avail param-compra then do:
    if substring(param-compra.char-2,97,3) = "YES" then do:
       if not can-find(estabelec where
                       estabelec.cod-estabel = input frame {&frame-name} c-cod-estab-gestor) and 
           c-cod-estab-gestor:sensitive in frame {&frame-name} then do:
           {include/i-vldprg.i}
           {utp/ut-liter.i Estabelecimento_Gestor * C}
           run utp/ut-msgs.p (input "show", input 56, input return-value).
           apply "entry" to c-cod-estab-gestor.
           return "adm-error".
       end.
    END.
  END.

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this Window, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

