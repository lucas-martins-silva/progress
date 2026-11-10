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
{include/i-prgvrs.i V09IN263 2.00.01.013} /*** "010113" 26/10/2023 17:31:45 ***/

{include/i_fncrowid.i}

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V09IN263 MUT}
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

{cdp/cdcfgman.i}

/* global variable definitions */
def new global shared var v-row-parent   as rowid no-undo.  
def new global shared var gr-operacao    as rowid no-undo. 

&IF {&ROWID_READY} = YES &THEN
    def new global shared var v_rec_video    as rowid no-undo.
&ELSE
    def new global shared var v_rec_video    as recid no-undo.
&ENDIF

def new global shared var c-tipo-sistema as character no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var c-item        like item.it-codigo.
def var c-rot-fabric  like rot-fabric.cod-roteiro.
def var l-mod-CQ      as logical no-undo.
def var l-CF          as logical initial no.

def var c-label-operacao  as char format "X(30)" no-undo. 
def var c-label-oper-exam as char format "X(30)" no-undo.

def var p-unidades             like oper-pad.nr-unidades      no-undo.
def var p-val-operac-item      as   decimal format ">,>>9.9999" no-undo.
def var p-cod-un-operac        as   char    format "x(2)"       no-undo.
def var p-qtd-tempo-pos-proces as   decimal format ">,>>9.99"   no-undo.
def var p-tempo-homem          like operacao.tempo-homem      no-undo.
def var p-tempo-maquin         like operacao.tempo-maquin     no-undo.
def var p-tempo-prepar         like operacao.tempo-prepar     no-undo.
def var p-qtd-capac-operac     as   decimal format ">,>>>,>>9.9999" no-undo.
def var p-tempo-sig            as   log                       no-undo.

def var h_v12in263       as handle no-undo.

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
&Scoped-define EXTERNAL-TABLES operacao
&Scoped-define FIRST-EXTERNAL-TABLE operacao


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR operacao.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS operacao.emite-ficha operacao.contr-qualidade ~
operacao.cod-video operacao.tempo-prepar operacao.tempo-maquin ~
operacao.tempo-homem operacao.nr-op-simult operacao.numero-homem 
&Scoped-define ENABLED-TABLES operacao
&Scoped-define FIRST-ENABLED-TABLE operacao
&Scoped-define DISPLAYED-TABLES operacao
&Scoped-define FIRST-DISPLAYED-TABLE operacao
&Scoped-Define ENABLED-OBJECTS v-unidades cb-un-med-tempo tg-tempo-sig ~
rt-mold1 rt-mold2 rt-mold3 rt-mold4 
&Scoped-Define DISPLAYED-FIELDS operacao.emite-ficha ~
operacao.contr-qualidade operacao.cod-video operacao.tempo-prepar ~
operacao.tempo-maquin operacao.tempo-homem operacao.nr-op-simult ~
operacao.numero-homem 
&Scoped-Define DISPLAYED-OBJECTS v-unidades c-ind-tempo-operac ~
cb-un-med-tempo tg-tempo-sig 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS cb-un-med-tempo 

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
DEFINE VARIABLE cb-un-med-tempo AS CHARACTER FORMAT "X(20)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-ind-tempo-operac AS CHARACTER FORMAT "X(14)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE v-unidades AS INTEGER FORMAT ">>>>9":U INITIAL 100 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 5.29 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41.72 BY 1.25.

DEFINE RECTANGLE rt-mold2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 43 BY 1.25.

DEFINE RECTANGLE rt-mold3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 8.63.

DEFINE RECTANGLE rt-mold4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 1.25.

DEFINE VARIABLE tg-tempo-sig AS LOGICAL INITIAL no 
     LABEL "Tempo Significativo" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     operacao.emite-ficha AT ROW 1.25 COL 7.72
          VIEW-AS TOGGLE-BOX
          SIZE 27.43 BY .75
     operacao.contr-qualidade AT ROW 1.25 COL 52
          VIEW-AS TOGGLE-BOX
          SIZE 24.86 BY .75
     operacao.cod-video AT ROW 2.54 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 31.14 BY .88
     v-unidades AT ROW 4.21 COL 22 COLON-ALIGNED
     operacao.tempo-prepar AT ROW 5.71 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     operacao.tempo-maquin AT ROW 6.71 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     c-ind-tempo-operac AT ROW 6.71 COL 60 COLON-ALIGNED
     operacao.tempo-homem AT ROW 7.71 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     cb-un-med-tempo AT ROW 7.71 COL 60 COLON-ALIGNED
     operacao.nr-op-simult AT ROW 9.21 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     tg-tempo-sig AT ROW 9.25 COL 62
     operacao.numero-homem AT ROW 10.21 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     rt-mold1 AT ROW 1 COL 1
     rt-mold2 AT ROW 1 COL 43.57
     rt-mold3 AT ROW 3.75 COL 1
     rt-mold4 AT ROW 2.33 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.operacao
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
         HEIGHT             = 11.38
         WIDTH              = 85.72.
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-ind-tempo-operac IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-un-med-tempo IN FRAME f-main
   3                                                                    */
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

&Scoped-define SELF-NAME cb-un-med-tempo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-un-med-tempo V-table-Win
ON VALUE-CHANGED OF cb-un-med-tempo IN FRAME f-main
DO:
  &if defined (bf_man_sfc_lc) &then 

  run pi-atualiza-dados in h_v12in263 (input v-unidades:screen-value,
                                       input cb-un-med-tempo:screen-value).

  &endif 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME operacao.cod-video
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.cod-video V-table-Win
ON F5 OF operacao.cod-video IN FRAME f-main /* V°deo */
DO:
  run btb/btb020ka.p (param-global.cod-catal-video-op).
  
  &IF {&ROWID_READY} = YES &THEN
    find video where rowid(video)  = v_rec_video no-lock no-error.
  &ELSE
    find video where recid(video)  = v_rec_video no-lock no-error.
  &ENDIF
  assign operacao.cod-video:screen-value = 
             if avail video then string(video.cod_video) else "":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.cod-video V-table-Win
ON MOUSE-SELECT-DBLCLICK OF operacao.cod-video IN FRAME f-main /* V°deo */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-unidades
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-unidades V-table-Win
ON LEAVE OF v-unidades IN FRAME f-main
DO:
  &if defined (bf_man_sfc_lc) &then 

  run pi-atualiza-dados in h_v12in263 (input v-unidades:screen-value,
                                       input cb-un-med-tempo:screen-value).

  &endif 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

if operacao.cod-video:load-mouse-pointer ('image/lupa.cur') in frame {&frame-name} then.

{utp/ut-field.i mgind operacao un-med-tempo 01}
assign cb-un-med-tempo:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind operacao nr-unidades 01}
assign v-unidades:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind grup-maquina ind-tempo-operac 01}
assign c-ind-tempo-operac:label in frame {&frame-name} = return-value.

  /* verificar se trabalha com modulo de controle de qualidade */
  find first param-global no-lock no-error.
  if avail param-global then
      assign l-mod-cq = param-global.modulo-cq.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

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
  {src/adm/template/row-list.i "operacao"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "operacao"}

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

  /* Code placed here will execute AFTER standard behavior.    */

  do with frame {&frame-name}:
     {utp/ut-field.i mgind operacao tempo-maquin 1}. 

     assign operacao.tempo-maquin:label      = return-value
            v-unidades:hidden                = false
            operacao.tempo-prepar:hidden     = false
            operacao.numero-homem:hidden     = false
            operacao.tempo-homem:hidden      = false
            v-unidades:screen-value          = string(100).

     assign cb-un-med-tempo:screen-value = {ininc/i02in261.i 04 1}.
  end.

  run pi-verifica-tipo-oper (input 1).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /*Alterado devido a Fo. 1309.439*/
  ASSIGN v-unidades:screen-value          = string(v-unidades).


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
   {include/i-valid.i} /*** Validaá∆o do dicion†rio ***/

    assign p-tempo-homem          = input frame {&frame-name} operacao.tempo-homem
           p-tempo-maquin         = input frame {&frame-name} operacao.tempo-maquin
           p-tempo-prepar         = input frame {&frame-name} operacao.tempo-prepar
           p-unidades             = input frame {&frame-name} v-unidades
           p-tempo-sig            = input frame {&frame-name} tg-tempo-sig.

   /* Dispatch standard ADM method.                             */
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
   if RETURN-VALUE = 'ADM-ERROR':U then 
      RETURN 'ADM-ERROR':U.

   &if {&bf_man_205} &then
       assign operacao.tempo-sig = p-tempo-sig.
   &else
       assign substr(operacao.char-1,41,1) = if p-tempo-sig = true then "S":U else "N":U.
   &endif

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
     assign operacao.un-med-tempo = {ininc/i02in261.i 06 cb-un-med-tempo:screen-value}.
  end.

  if  operacao.tipo-oper = 2 then 
        assign operacao.numero-homem = 0.

  assign operacao.nr-unidades          = p-unidades 
         operacao.tempo-homem          = p-tempo-homem
         operacao.tempo-maquin         = p-tempo-maquin
         operacao.tempo-prepar         = p-tempo-prepar.

    if  l-CF = yes then do:
        assign operacao.tempo-homem-config      = p-tempo-homem
               operacao.tempo-maquin-config     = p-tempo-maquin
               operacao.tempo-prepar-config     = p-tempo-prepar.
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

    if  avail operacao and adm-new-record = no then do:
        assign v-unidades:screen-value      in frame {&frame-name} = string(operacao.nr-unidades)
               cb-un-med-tempo:screen-value in frame {&frame-name} = {ininc/i02in261.i 04 operacao.un-med-tempo}. 

        if  operacao.tipo-oper = 2 then do with frame {&frame-name}:
            {utp/ut-liter.i Tempo_Ressuprimento *}. 

            assign operacao.tempo-maquin:label  = return-value
                   operacao.numero-homem:hidden = yes
                   operacao.tempo-homem:hidden  = yes.
        end.

         &if {&bf_man_205} &then
             assign tg-tempo-sig = operacao.tempo-sig.
         &else
             assign tg-tempo-sig = if substr(operacao.char-1,41,1) = "S":U then true else false.
         &endif
         disp tg-tempo-sig with frame {&frame-name}.
    end.

    if  c-tipo-sistema = "CF" then do:
        assign l-CF = yes.
    end.

    assign c-ind-tempo-operac:hidden      in frame {&frame-name} = no.

    if  avail operacao then do:
        if  operacao.tipo-oper = 2 then 
            assign c-ind-tempo-operac:hidden      in frame {&frame-name} = yes.
        else do with frame {&frame-name}:
           &if defined (bf_man_sfc_lc) &then 
               run pi-atualiza-dados in h_v12in263 (input v-unidades:screen-value,
                                                    input cb-un-med-tempo:screen-value).
           &endif 

           find first grup-maquina
                where grup-maquina.gm-codigo = operacao.gm-codigo no-lock no-error.

           run utp/ut-liter.p (REPLACE({ininc/i06in144.i 04 grup-maquina.ind-tempo-operac}, " ", "_"),"*","").
           assign c-ind-tempo-operac:screen-value in frame {&frame-name} = RETURN-VALUE
                  v-unidades                           = operacao.nr-unidades
                  v-unidades:screen-value              = string(v-unidades).

            if  l-CF = yes then do:
                assign operacao.tempo-maquin:screen-value   = string(operacao.tempo-maquin-config)
                       operacao.tempo-homem:screen-value    = string(operacao.tempo-homem-config)
                       operacao.tempo-prepar:screen-value   = string(operacao.tempo-prepar-config).
            end.
        end.
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
  assign cb-un-med-tempo:list-items in frame {&frame-name} = {ininc/i02in261.i 03}.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-handle V-table-Win 
PROCEDURE pi-atualiza-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param p-viewer as handle.

assign h_v12in263 = p-viewer.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-default-oper-pad V-table-Win 
PROCEDURE pi-default-oper-pad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input parameter rw-oper-pad as rowid no-undo.

    find oper-pad where rowid(oper-pad) = rw-oper-pad no-lock no-error.

    if  avail oper-pad then do with frame {&frame-name}:

        assign operacao.emite-ficha:checked          = oper-pad.emite-ficha
               operacao.contr-qualidade:checked      = oper-pad.contr-qualidade
               v-unidades                            = oper-pad.nr-unidades               
               operacao.tempo-maquin:screen-value    = string(oper-pad.tempo-maquin)
               operacao.tempo-prepar:screen-value    = string(oper-pad.tempo-prepar)
               operacao.tempo-homem:screen-value     = string(oper-pad.tempo-homem)
               v-unidades:screen-value               = string(oper-pad.nr-unidades)
               operacao.numero-homem:screen-value    = string(oper-pad.numero-homem)
               operacao.nr-op-simult:screen-value    = string(oper-pad.nr-op-simult)
               operacao.cod-video:screen-value       = string(oper-pad.cod-video)
               cb-un-med-tempo:screen-value          = {ininc/i02in261.i 04 oper-pad.un-med-tempo}.
               &if {&bf_man_204} &then
                  if  avail oper-pad then do:
                      &if {&bf_man_206} &then
                          assign tg-tempo-sig = oper-pad.tempo-sig.
                       &else
                          assign tg-tempo-sig = if substr(oper-pad.char-1,41,1) = "S":U then true else false.
                       &endif
                  end.

                  IF  tg-tempo-sig THEN
                      ASSIGN tg-tempo-sig:CHECKED in frame {&frame-name} = YES.
                  ELSE
                      ASSIGN tg-tempo-sig:CHECKED in frame {&frame-name} = NO.

                &endif
             

        if  oper-pad.tipo-oper = 1 then do:
            {utp/ut-field.i mgind operacao tempo-maquin 1}. 
            assign operacao.tempo-maquin:label      = return-value
                   v-unidades:hidden                = false
                   operacao.tempo-prepar:hidden     = false
                   operacao.numero-homem:hidden     = false
                   operacao.tempo-homem:hidden      = false.
        end. 
        else do:
            {utp/ut-liter.i Tempo_Ressuprimento *}. 
            assign operacao.tempo-maquin:label  = return-value
                   operacao.numero-homem:hidden = true
                   operacao.tempo-homem:hidden  = true.

            assign c-ind-tempo-operac:hidden      in frame {&frame-name} = yes.

        end.   
    end. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grup-maquina V-table-Win 
PROCEDURE pi-grup-maquina :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-grup-maquina like grup-maquina.gm-codigo.

&if defined (bf_man_sfc_lc) &then

    find first grup-maquina
         where grup-maquina.gm-codigo = p-grup-maquina no-lock no-error.
    assign c-ind-tempo-operac:screen-value in frame {&frame-name} = {ininc/i06in144.i 04 grup-maquina.ind-tempo-operac}.

&endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-oper-pad V-table-Win 
PROCEDURE pi-oper-pad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-nr-oper-pad like oper-pad.nr-oper-pad.

&if defined (bf_man_sfc_lc) &then

    find first oper-pad
         where oper-pad.nr-oper-pad = p-nr-oper-pad no-lock no-error.
    find first grup-maquina
         where grup-maquina.gm-codigo = oper-pad.gm-codigo no-lock no-error.

    assign c-ind-tempo-operac:screen-value      in frame {&frame-name} = if  avail grup-maquina then {ininc/i06in144.i 04 grup-maquina.ind-tempo-operac}
                                                                                                else {ininc/i06in144.i 04 1}
           v-unidades:screen-value              in frame {&frame-name} = string(oper-pad.nr-unidades)
           v-unidades                                                  = oper-pad.nr-unidades.

    run pi-verifica-tipo-oper (input oper-pad.tipo-oper).

&endif

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

    if  l-CF = no then do with frame {&frame-name}:
        if  input operacao.tempo-homem = ? then do:
            {utp/ut-field.i mgind operacao tempo-homem 1}
            run utp/ut-msgs.p (input 'show',
                               input 17944,
                               input trim(return-value)).
            apply 'entry' to operacao.tempo-homem.
            return 'adm-error'.
        end.

        if  input operacao.tempo-maquin = ? then do:
            {utp/ut-field.i mgind operacao tempo-maquin 1}
            run utp/ut-msgs.p (input 'show',
                               input 17944,
                               input trim(return-value)).
            apply 'entry' to operacao.tempo-maquin.
            return 'adm-error'.
        end.

        if  input operacao.tempo-prepar = ? then do:
            {utp/ut-field.i mgind operacao tempo-prepar 1}
            run utp/ut-msgs.p (input 'show',
                               input 17944,
                               input trim(return-value)).
            apply 'entry' to operacao.tempo-prepar.
            return 'adm-error'.
        end.
    end.

    if  adm-new-record = no 
    and operacao.contr-qualidade:checked in frame {&frame-name} = yes then do:

        find first oper-exam 
             where oper-exam.it-codigo   = c-item
             and   oper-exam.cod-roteiro = c-rot-fabric
             and   oper-exam.op-codigo   = operacao.op-codigo no-lock no-error.
        if  not avail oper-exam then do:
            if  not l-mod-CQ then
                assign operacao.contr-qualidade:checked in frame {&frame-name}= no.
        end.
        else do: 
            {utp/ut-table.i mgind operacao  1} assign c-label-operacao = return-value.
            {utp/ut-table.i mgind oper-exam 1} assign c-label-oper-exam = return-value.

            {utp/ut-field.i mgind operacao contr-qualidade 1}
            {include/i-vldprg.i}

            /*** Operaá∆o possui oper-exam cadastrado. Controle de qualidade n∆o pode ser alterado. ***/
            run utp/ut-msgs.p (input "show",
                               input 1170,
                               input c-label-operacao  + "~~" +
                                     c-label-oper-exam + "~~" +
                                     return-value).
            apply "entry" to operacao.contr-qualidade in frame {&frame-name}.      
            return "ADM-ERROR":U.
        end.  
    end.

    if input frame {&frame-name} operacao.cod-video <> "" then do:
        find first param-global no-lock no-error.
        if  not avail param-global then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input 'show',
                               input 16,
                               input '').
            return 'ADM-ERROR':U.
        end.

        find video 
            where video.cod_video = input frame {&frame-name} operacao.cod-video no-lock no-error.
        if  avail video then do:
            if  video.cod_catal_video <> param-global.cod-catal-video-op then do:
                {include/i-vldprg.i}
                /*** V°deo n∆o consta no cat†logo dos parÉmetros globais. ***/
                run utp/ut-msgs.p (input 'show',
                                   input 7596,
                                   input string(param-global.cod-catal-video-op)).
                apply 'entry' to operacao.cod-video in frame {&frame-name}.
                return 'ADM-ERROR':U.
            end.
        end.
        else do:
            {include/i-vldprg.i}
            /*** V°deo n∆o encontrado ***/
            run utp/ut-msgs.p (input 'show',
                               input 7174,
                               input '').
            apply 'entry' to operacao.cod-video in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
    end.

    do  with frame {&frame-name}:
        if  not (input operacao.nr-op-simult > 0) then do:
            {utp/ut-field.i mgind operacao nr-op-simult 1}
            run utp/ut-msgs.p (input 'show',
                               input 6179,
                               input trim(return-value)).
            apply 'entry' to operacao.nr-op-simult.
            return 'ADM-ERROR'.
        end.
        if  operacao.numero-homem:hidden = no
        and not input v-unidades > 0 then do:
            {utp/ut-field.i mgind operacao nr-unidades 1}
            run utp/ut-msgs.p (input 'show',
                               input 6179,
                               input trim(return-value)).
            apply 'entry' to v-unidades.
            return 'adm-error'.
        end.
        if  operacao.numero-homem:hidden = no
        and not input operacao.numero-homem >= 0 then do:
            {utp/ut-field.i mgind operacao numero-homem 1}
            run utp/ut-msgs.p (input 'show',
                               input 6179,
                               input trim(return-value)).
            apply 'entry' to operacao.numero-homem.
            return 'adm-error'.
        end.

        /* Verifica se Ç operac∆o interna pelo operacao.tempo-homem:hidden = false e
           se a unidade de tempo Ç Dias */
        if operacao.tempo-homem:hidden = false and 
           {ininc/i02in261.i 06 cb-un-med-tempo:screen-value} = 4 then do:
           {include/i-vldprg.i}
            run utp/ut-msgs.p (input 'show',
                               input 17641,
                               input "" ).
            apply 'entry' to cb-un-med-tempo.
            return 'adm-error'. 
        end.
    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-tipo-oper V-table-Win 
PROCEDURE pi-verifica-tipo-oper :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input parameter i-tipo-oper like operacao.tipo-oper no-undo.

  if i-tipo-oper = 1 then do with frame {&frame-name}:
     {utp/ut-field.i mgind operacao tempo-maquin 1}. 

     assign operacao.tempo-maquin:label        = return-value
            v-unidades:hidden                  = false
            operacao.tempo-prepar:hidden       = false
            operacao.numero-homem:hidden       = false
            operacao.numero-homem:screen-value = IF operacao.numero-homem:SCREEN-VALUE = "0" THEN "1":U ELSE operacao.numero-homem:SCREEN-VALUE.
            operacao.tempo-homem:hidden        = false.

     enable operacao.tempo-maquin
            v-unidades
            operacao.tempo-prepar
            operacao.numero-homem
            operacao.tempo-homem
            operacao.nr-op-simult.

     &if defined (bf_man_sfc_lc) &then
         assign c-ind-tempo-operac:hidden in frame {&frame-name}      = no.

         run pi-atualiza-dados in h_v12in263 (input v-unidades:screen-value      in frame {&frame-name},
                                              input cb-un-med-tempo:screen-value in frame {&frame-name}).
     &endif           
  end.
  else do with frame {&frame-name}:
     {utp/ut-liter.i Tempo_Ressuprimento}. 
     assign operacao.tempo-maquin:label     = return-value
            operacao.numero-homem:hidden    = true
            operacao.tempo-homem:hidden     = true.

     &if defined (bf_man_sfc_lc) &then
         assign c-ind-tempo-operac:hidden      in frame {&frame-name} = yes.       
     &endif                
  end.   

  /**********
  if  adm-new-record = no then 
      assign cb-un-med-tempo:screen-value = {ininc/i02in261.i 04 operacao.un-med-tempo}.
  else 
      assign cb-un-med-tempo:screen-value = {ininc/i02in261.i 04 1}.
  ***********/
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
  {src/adm/template/snd-list.i "operacao"}

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

