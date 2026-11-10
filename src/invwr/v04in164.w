&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
{include/i-prgvrs.i V04IN164 2.00.00.015 } /*** "010015" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V04IN164 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE BUFFER b-it-exame         FOR it-exame.
DEFINE BUFFER b-it-comp-exame    FOR it-comp-exame.
DEFINE BUFFER b-item-compon-test FOR item-compon-test.
DEFINE BUFFER b-tex-exame        FOR tex-exame.
DEFINE BUFFER b-exame-insp       FOR exame-insp.

/*************************  Multi-Planta ************************************/
def var  i-tipo-movto   as integer    no-undo.
def var  l-cria         as logical    no-undo.

{cdp/cd7300.i1}
/********************** Fim Multi-Planta ************************************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold c-item-origem i-exame-inicial ~
i-exame-final c-item-destino 
&Scoped-Define DISPLAYED-OBJECTS c-item-origem c-des-item-orig ~
i-exame-inicial c-des-exame-inicial i-exame-final c-des-exame-final ~
c-item-destino c-des-item-dest 

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
DEFINE VARIABLE c-des-exame-final AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-exame-inicial AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 28.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-item-dest AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 47.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-item-orig AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 47.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-destino AS CHARACTER FORMAT "X(16)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-origem AS CHARACTER FORMAT "X(16)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE i-exame-final AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE i-exame-inicial AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 4.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-item-origem AT ROW 1.25 COL 22 COLON-ALIGNED
     c-des-item-orig AT ROW 1.25 COL 38.57 COLON-ALIGNED NO-LABEL
     i-exame-inicial AT ROW 2.25 COL 22 COLON-ALIGNED
     c-des-exame-inicial AT ROW 2.25 COL 30.29 COLON-ALIGNED NO-LABEL
     i-exame-final AT ROW 3.25 COL 22 COLON-ALIGNED
     c-des-exame-final AT ROW 3.25 COL 30.29 COLON-ALIGNED NO-LABEL
     c-item-destino AT ROW 4.25 COL 22 COLON-ALIGNED
     c-des-item-dest AT ROW 4.25 COL 38.57 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
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
         HEIGHT             = 4.63
         WIDTH              = 88.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit L-To-R                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-des-exame-final IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-exame-inicial IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-item-dest IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-item-orig IN FRAME f-main
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

&Scoped-define SELF-NAME c-item-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item-destino V-table-Win
ON F5 OF c-item-destino IN FRAME f-main
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom\z02in172.w
                     &campo=c-item-destino
                     &campozoom=it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item-destino V-table-Win
ON LEAVE OF c-item-destino IN FRAME f-main
DO:
   find item no-lock
      where item.it-codigo = input frame {&FRAME-NAME} c-item-destino no-error.
   if avail item then do:
      assign c-des-item-dest:screen-value in frame {&FRAME-NAME} = item.desc-item.
   end.
   else do:
      assign c-des-item-dest:screen-value in frame {&FRAME-NAME} = "".
   end.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item-destino V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-item-destino IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-item-origem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item-origem V-table-Win
ON F5 OF c-item-origem IN FRAME f-main
DO:
  assign l-implanta = no.
  {include/zoomvar.i &prog-zoom=inzoom\z02in164.w
                     &campo=c-item-origem
                     &campozoom=it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item-origem V-table-Win
ON LEAVE OF c-item-origem IN FRAME f-main
DO:
   find item no-lock
      where item.it-codigo = input frame {&FRAME-NAME} c-item-origem no-error.
   if avail item then do:
      assign c-des-item-orig:screen-value in frame {&FRAME-NAME} = item.desc-item.
   end.
   else do:
      assign c-des-item-orig:screen-value in frame {&FRAME-NAME} = "".
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-item-origem V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-item-origem IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-exame-final
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-exame-final V-table-Win
ON F5 OF i-exame-final IN FRAME f-main
DO:
   assign l-implanta = no.
   {include/zoomvar.i &prog-zoom=inzoom/z03in164.w
                      &campo=i-exame-final
                      &campozoom=cod-exame
                      &parametros="run pi-seta-inicial in wh-pesquisa (input c-item-origem:screen-value in frame {&FRAME-NAME})."}
                      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-exame-final V-table-Win
ON LEAVE OF i-exame-final IN FRAME f-main
DO:
  {include/leave.i &tabela=exame
                   &atributo-ref=descricao
                   &variavel-ref=c-des-exame-final
                   &where="exame.cod-exame = input frame {&FRAME-NAME} i-exame-final and exame.cdn-sit-vers = 2"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-exame-final V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-exame-final IN FRAME f-main
DO:
  apply 'F5' to self.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-exame-inicial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-exame-inicial V-table-Win
ON F5 OF i-exame-inicial IN FRAME f-main
DO:
   assign l-implanta = no.
   {include/zoomvar.i &prog-zoom=inzoom/z03in164.w
                      &campo=i-exame-inicial
                      &campozoom=cod-exame
                      &parametros="run pi-seta-inicial in wh-pesquisa (input c-item-origem:screen-value in frame {&FRAME-NAME})."}
                      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-exame-inicial V-table-Win
ON LEAVE OF i-exame-inicial IN FRAME f-main
DO:
  {include/leave.i &tabela=exame
                   &atributo-ref=descricao
                   &variavel-ref=c-des-exame-inicial
                   &where="exame.cod-exame = input frame {&FRAME-NAME} i-exame-inicial and exame.cdn-sit-vers = 2"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-exame-inicial V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-exame-inicial IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  if c-item-origem:load-mouse-pointer      ("image\lupa.cur") in frame {&FRAME-NAME} then.
  if i-exame-inicial:load-mouse-pointer    ("image\lupa.cur") in frame {&FRAME-NAME} then.
  if i-exame-final:load-mouse-pointer      ("image\lupa.cur") in frame {&FRAME-NAME} then.
  if c-item-destino:load-mouse-pointer     ("image\lupa.cur") in frame {&FRAME-NAME} then.
      
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  {utp/ut-liter.i Item_Origem * R}
  assign c-item-origem:label in frame {&FRAME-NAME} = return-value.
  {utp/ut-liter.i Exame_Inicial * R}
  assign i-exame-inicial:label in frame {&FRAME-NAME} = return-value.
  {utp/ut-liter.i Exame_Final * R}
  assign i-exame-final:label in frame {&FRAME-NAME} = return-value.
  {utp/ut-liter.i Item_Destino * R}
  assign c-item-destino:label in frame {&FRAME-NAME} = return-value.
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
    
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-copia V-table-Win 
PROCEDURE pi-copia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

for each b-it-exame no-lock
   where b-it-exame.it-codigo  = input frame {&FRAME-NAME} c-item-origem
     and b-it-exame.cod-exame >= input frame {&FRAME-NAME} i-exame-inicial
     and b-it-exame.cod-exame <= input frame {&FRAME-NAME} i-exame-final:
   
    /* Verifica se a versao do exame está liberada */
   {invwr/v04in164.i b-it-exame.cod-exame}
   
   find first it-exame no-lock
        where it-exame.it-codigo =  input frame {&FRAME-NAME} c-item-destino
          and it-exame.cod-exame =  b-it-exame.cod-exame no-error.
   if not avail it-exame then do:
      create it-exame.
      assign it-exame.it-codigo   = input frame {&FRAME-NAME} c-item-destino
             it-exame.cod-exame   = b-it-exame.cod-exame   
             it-exame.descricao   = b-it-exame.descricao          
             it-exame.frequencia  = b-it-exame.frequencia
             it-exame.perc-nqa    = b-it-exame.perc-nqa
             it-exame.nivel       = b-it-exame.nivel
             it-exame.situacao    = b-it-exame.situacao
             it-exame.dt-inclusao = today
             it-exame.responsavel = b-it-exame.responsavel.
   end. 
end.


for each b-it-comp-exame no-lock
   where b-it-comp-exame.it-codigo  = input frame {&FRAME-NAME} c-item-origem
     and b-it-comp-exame.cod-exame >= input frame {&FRAME-NAME} i-exame-inicial
     and b-it-comp-exame.cod-exame <= input frame {&FRAME-NAME} i-exame-final:
   
    /* Verifica se a versao do exame está liberada */
   {invwr/v04in164.i b-it-comp-exame.cod-exame}
   
   find first it-comp-exame no-lock
        WHERE it-comp-exame.it-codigo =  input frame {&FRAME-NAME} c-item-destino
          and it-comp-exame.cod-exame =  b-it-comp-exame.cod-exame
          AND it-comp-exame.cod-comp  =  b-it-comp-exame.cod-comp no-error.

   if not avail it-comp-exame then do:
      create it-comp-exame.
      assign it-comp-exame.it-codigo     = input frame {&FRAME-NAME} c-item-destino
             it-comp-exame.cod-exame     = b-it-comp-exame.cod-exame
             it-comp-exame.cod-comp      = b-it-comp-exame.cod-comp
             it-comp-exame.descricao     = b-it-comp-exame.descricao        
             it-comp-exame.narrativa-apr = b-it-comp-exame.narrativa-apr
             it-comp-exame.result-min    = b-it-comp-exame.result-min
             it-comp-exame.result-max    = b-it-comp-exame.result-max
             it-comp-exame.tipo-result   = b-it-comp-exame.tipo-result
             it-comp-exame.nr-tabela     = b-it-comp-exame.nr-tabela
             it-comp-exame.unidade       = b-it-comp-exame.unidade
             it-comp-exame.local-cq      = b-it-comp-exame.local-cq
             it-comp-exame.inst-equip    = b-it-comp-exame.inst-equip
             it-comp-exame.compl-res     = b-it-comp-exame.compl-res
             it-comp-exame.refer-tec     = b-it-comp-exame.refer-tec
             it-comp-exame.metodo        = b-it-comp-exame.metodo
             it-comp-exame.nr-decimais   = b-it-comp-exame.nr-decimais
             it-comp-exame.nr-horas      = b-it-comp-exame.nr-horas
             it-comp-exame.situacao      = b-it-comp-exame.situacao.


      FIND FIRST b-item-compon-test NO-LOCK
           WHERE b-item-compon-test.cod-item          = b-it-comp-exame.it-codigo  
             AND   b-item-compon-test.cdn-exam        = b-it-comp-exame.cod-exame
             AND   b-item-compon-test.cdn-compon-exam = b-it-comp-exame.cod-comp NO-ERROR.

      IF AVAIL b-item-compon-test THEN DO:
          CREATE item-compon-test.
          ASSIGN item-compon-test.cod-item          = input frame {&FRAME-NAME} c-item-destino
                 item-compon-test.cdn-exam          = b-it-comp-exame.cod-exame
                 item-compon-test.cdn-compon-exam   = b-it-comp-exame.cod-comp
                 item-compon-test.qti-test-realzdo  = b-item-compon-test.qti-test-realzdo.
      END.
   end. 
end.


for each b-tex-exame no-lock
    where b-tex-exame.it-codigo  = input frame {&FRAME-NAME} c-item-origem 
      and b-tex-exame.cod-exame >= input frame {&FRAME-NAME} i-exame-inicial
      and b-tex-exame.cod-exame <= input frame {&FRAME-NAME} i-exame-final:
      
    /* Verifica se a versao do exame está liberada */
    {invwr/v04in164.i b-tex-exame.cod-exame}
                      
    find first tex-exame no-lock
         where tex-exame.it-codigo  = input frame {&FRAME-NAME} c-item-destino 
           and tex-exame.cod-exame  = b-tex-exame.cod-exame  no-error.
    if not avail tex-exame then do:
        create tex-exame.
        assign tex-exame.it-codigo  = input frame {&FRAME-NAME} c-item-destino
               tex-exame.cod-exame  = b-tex-exame.cod-exame
               tex-exame.linha-desc = b-tex-exame.linha-desc.
               
    end.
end.

for each b-exame-insp no-lock
   where b-exame-insp.it-codigo  = input frame {&FRAME-NAME} c-item-origem
     and b-exame-insp.cod-exame >= input frame {&FRAME-NAME} i-exame-inicial
     and b-exame-insp.cod-exame <= input frame {&FRAME-NAME} i-exame-final:
     
    /* Verifica se a versao do exame está liberada */
    {invwr/v04in164.i b-exame-insp.cod-exame }
    find first exame-insp no-lock
         where exame-insp.it-codigo   = input frame {&FRAME-NAME} c-item-destino
           and exame-insp.cod-exame   = b-exame-insp.cod-exame
           and exame-insp.tp-inspecao = b-exame-insp.tp-inspecao no-error.
                
    if not avail exame-insp then do:
         create exame-insp.
         assign exame-insp.it-codigo   = input frame {&FRAME-NAME} c-item-destino
                exame-insp.cod-exame   = b-exame-insp.cod-exame
                exame-insp.tp-inspecao = b-exame-insp.tp-inspecao.
    end.
end.                              
                    
/**************************************** In¡cio Multi-Planta ***********************************************/
    
assign c-transacao = "MAT041".
{cdp/cd7300.i5 "001" c-transacao}
assign i-tipo-movto = 1.

if param-global.modulo-mp = yes and tt-replica-msg.log-replica-msg = yes then do:

    create tt-dados-env.
    assign tt-dados-env.num-sequencia  = i-seq
           tt-dados-env.cod-tipo-reg   = 123
           tt-dados-env.ind-tipo-movto = i-tipo-movto
           tt-dados-env.identif-msg    = string(it-exame.cod-exame).
           
     raw-transfer  it-exame  to  tt-dados-env.conteudo-msg.
     assign i-seq = i-seq + 1.
     
     {cdp/cd7300.i6 "001" c-transacao}
end.     
  
/**************************************** Fim Multi-Planta **************************************************/ 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida V-table-Win 
PROCEDURE pi-valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* Ponha aqui a valida‡Æo de chave duplicada */
  
  /* Ponha aqui as demais valida‡äes */
  /* valida item origem */
  find item no-lock where 
       item.it-codigo = c-item-origem:screen-value in frame {&FRAME-NAME} no-error.
  if not avail item then do:
     run utp/ut-msgs.p (input "show",
                        input 2,
                        input c-item-origem:screen-value in frame {&FRAME-NAME}).
     apply 'entry' to c-item-origem.
     return 'adm-error':U.
  end.

  /* valida o exame inicial */
  find first b-it-exame no-lock
       where b-it-exame.it-codigo   = c-item-origem:screen-value             in frame {&FRAME-NAME}
       and   b-it-exame.cod-exame   = integer(i-exame-inicial:screen-value   in frame {&FRAME-NAME}) no-error.
  if not avail b-it-exame then do:
        run utp/ut-msgs.p (input "show",
                           input 2,
                           input i-exame-inicial:screen-value   in frame {&FRAME-NAME}).
        apply 'entry' to i-exame-inicial.
        return 'adm-error':U.
  end.
    
  /* valida o exame final */
  find first b-it-exame no-lock
     where b-it-exame.it-codigo   = c-item-origem:screen-value             in frame {&FRAME-NAME}
     and   b-it-exame.cod-exame   = integer(i-exame-final:screen-value     in frame {&FRAME-NAME}) no-error.
  if not avail b-it-exame then do:
        run utp/ut-msgs.p (input "show",
                           input 2,
                           input i-exame-final:screen-value     in frame {&FRAME-NAME}).
        apply 'entry' to i-exame-final.
        return 'adm-error':U.
  end.

  /* valida item destino */
  find item no-lock where
       item.it-codigo = c-item-destino:screen-value in frame {&FRAME-NAME} no-error.
  if not avail item then do:
     run utp/ut-msgs.p (input "show",
                        input 2,
                        input c-item-destino:screen-value in frame {&FRAME-NAME}).
     apply 'entry' to c-item-destino.
     return 'adm-error':U.
  end.

  

  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartViewer, and there are no
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


