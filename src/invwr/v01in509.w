&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          mgmfg            PROGRESS
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
{include/i-prgvrs.i V01IN509 2.00.00.008 } /*** "010008" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v01in509 MUT}
&ENDIF



/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

def new global shared var gr-motiv-refugo as rowid no-undo.

def var v-row-parent as rowid no-undo.

def temp-table tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".
    
{include/boini.i}

DEFINE VARIABLE hProgramZoom AS HANDLE     NO-UNDO.

DEFINE VARIABLE l-sfc-mudancas AS LOGICAL    NO-UNDO.

{cdp/cdcfgman.i}

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
&Scoped-define EXTERNAL-TABLES motiv-refugo
&Scoped-define FIRST-EXTERNAL-TABLE motiv-refugo


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR motiv-refugo.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS motiv-refugo.log-ativo ~
motiv-refugo.log-retrabalho 
&Scoped-define ENABLED-TABLES motiv-refugo
&Scoped-define FIRST-ENABLED-TABLE motiv-refugo
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold label-desc label-rejei 
&Scoped-Define DISPLAYED-FIELDS motiv-refugo.cod-motiv-refugo ~
motiv-refugo.des-motiv-refugo motiv-refugo.codigo-rejei ~
motiv-refugo.log-material motiv-refugo.log-ativo motiv-refugo.log-retrabalho 
&Scoped-define DISPLAYED-TABLES motiv-refugo
&Scoped-define FIRST-DISPLAYED-TABLE motiv-refugo
&Scoped-Define DISPLAYED-OBJECTS c-desc label-desc label-rejei 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS motiv-refugo.cod-motiv-refugo 
&Scoped-define ADM-ASSIGN-FIELDS motiv-refugo.des-motiv-refugo ~
motiv-refugo.codigo-rejei motiv-refugo.log-material ~
motiv-refugo.log-retrabalho 
&Scoped-define ADM-MODIFY-FIELDS motiv-refugo.des-motiv-refugo ~
motiv-refugo.codigo-rejei motiv-refugo.log-material ~
motiv-refugo.log-retrabalho 

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
DEFINE VARIABLE c-desc AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-clas-motiv AS CHARACTER FORMAT "X(8)":U 
     LABEL "Classe" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-des-clas-motiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE label-desc AS CHARACTER FORMAT "X(256)":U INITIAL "Descri‡Æo:" 
      VIEW-AS TEXT 
     SIZE 7.57 BY .67 NO-UNDO.

DEFINE VARIABLE label-rejei AS CHARACTER FORMAT "X(256)":U INITIAL "Rejei‡Æo Material:" 
      VIEW-AS TEXT 
     SIZE 12.57 BY .67 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 5.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     motiv-refugo.cod-motiv-refugo AT ROW 1.17 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     motiv-refugo.des-motiv-refugo AT ROW 2.79 COL 19 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 41.14 BY .88
     motiv-refugo.codigo-rejei AT ROW 3.79 COL 19 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-desc AT ROW 3.79 COL 24.14 COLON-ALIGNED NO-LABEL
     fi-cod-clas-motiv AT ROW 4.79 COL 19 COLON-ALIGNED
     fi-des-clas-motiv AT ROW 4.79 COL 28.29 COLON-ALIGNED NO-LABEL
     motiv-refugo.log-material AT ROW 5.88 COL 21.14
          VIEW-AS TOGGLE-BOX
          SIZE 18.29 BY .83
     motiv-refugo.log-ativo AT ROW 5.88 COL 39
          LABEL "Ativo"
          VIEW-AS TOGGLE-BOX
          SIZE 13.72 BY .83
     motiv-refugo.log-retrabalho AT ROW 6.88 COL 21.14
          VIEW-AS TOGGLE-BOX
          SIZE 13.72 BY .83
     label-desc AT ROW 2.92 COL 11 COLON-ALIGNED NO-LABEL
     label-rejei AT ROW 3.92 COL 6 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: Mgind.motiv-refugo
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
         HEIGHT             = 7.13
         WIDTH              = 88.57.
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

/* SETTINGS FOR FILL-IN c-desc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN motiv-refugo.cod-motiv-refugo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN motiv-refugo.codigo-rejei IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN motiv-refugo.des-motiv-refugo IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-cod-clas-motiv IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-des-clas-motiv IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX motiv-refugo.log-ativo IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX motiv-refugo.log-material IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR TOGGLE-BOX motiv-refugo.log-retrabalho IN FRAME f-main
   2 3                                                                  */
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

&Scoped-define SELF-NAME motiv-refugo.codigo-rejei
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL motiv-refugo.codigo-rejei V-table-Win
ON F5 OF motiv-refugo.codigo-rejei IN FRAME f-main /* Rej */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom="inzoom/z01in047.w"
                       &campo=motiv-refugo.codigo-rejei
                       &campozoom=codigo-rejei
                       &campo2=c-desc
                       &campozoom2=descricao}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL motiv-refugo.codigo-rejei V-table-Win
ON LEAVE OF motiv-refugo.codigo-rejei IN FRAME f-main /* Rej */
DO:
    
    {include/leave.i &tabela=cod-rejeicao
                     &atributo-ref=descricao
                     &variavel-ref=c-desc
                     &where="cod-rejeicao.codigo-rejei = input frame {&frame-name} motiv-refugo.codigo-rejei"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL motiv-refugo.codigo-rejei V-table-Win
ON MOUSE-SELECT-DBLCLICK OF motiv-refugo.codigo-rejei IN FRAME f-main /* Rej */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-clas-motiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-clas-motiv V-table-Win
ON F5 OF fi-cod-clas-motiv IN FRAME f-main /* Classe */
DO:
    &IF DEFINED(bf_man_204) &THEN
        {method/ZoomFields.i
               &ProgramZoom="mfzoom/z01mf639.w"
               &FieldZoom1="cod-clas-motiv"
               &FieldScreen1="fi-cod-clas-motiv"
               &Frame1="f-main"
               &FieldZoom2="des-clas-motiv"
               &FieldScreen2="fi-des-clas-motiv"
               &Frame2="f-main"           
               &EnableImplant="YES"}    
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-clas-motiv V-table-Win
ON LEAVE OF fi-cod-clas-motiv IN FRAME f-main /* Classe */
DO:
    &IF DEFINED(bf_man_204) &THEN
         {include/leave.i &tabela=clas-motiv 
                     &atributo-ref=des-clas-motiv
                     &variavel-ref=fi-des-clas-motiv
                     &where="clas-motiv.cod-clas-motiv = input frame {&frame-name} fi-cod-clas-motiv"}
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-clas-motiv V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-clas-motiv IN FRAME f-main /* Classe */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

if motiv-refugo.codigo-rejei:load-mouse-pointer ("image/lupa.cur") then.
fi-cod-clas-motiv:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name}.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

{inbo/boin509.i1}

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
  {src/adm/template/row-list.i "motiv-refugo"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "motiv-refugo"}

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

  DISPLAY label-desc label-rejei WITH FRAME f-main.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-cod-clas AS CHARACTER FORMAT "X(8)":U NO-UNDO.
    
    /*{include/i-valid.i}*/
    if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
    
    if adm-new-record = yes then do:
        if can-find(first motiv-refugo where
                    motiv-refugo.cod-motiv-refugo = input frame {&frame-name} motiv-refugo.cod-motiv-refugo) then do:
            {utp/ut-table.i mgind motiv-refugo 01}
            run utp/ut-msgs.p (input 'show',
                               input 1,
                              input return-value).
            apply 'entry' to motiv-refugo.cod-motiv-refugo in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
    end.

    ASSIGN c-cod-clas = fi-cod-clas-motiv:SCREEN-VALUE IN FRAME f-main.
           
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    for each tt-erro:
        delete tt-erro.
    end.

    IF l-sfc-mudancas THEN DO:

        &IF DEFINED(bf_man_207) &THEN
            ASSIGN motiv-refugo.cod-clas-motiv = c-cod-clas.
        &ELSE
            ASSIGN OVERLAY(motiv-refugo.char-1,1,8) = c-cod-clas.
        &ENDIF

    END.
    
    run ValidarMotivoRefugo (buffer motiv-refugo,
                             output table tt-bo-erro).
    if can-find(first tt-bo-erro) then do:
        for each tt-bo-erro:
            create tt-erro.
            assign tt-erro.i-sequen = tt-bo-erro.i-sequen
                   tt-erro.cd-erro  = tt-bo-erro.cd-erro
                   tt-erro.mensagem = tt-bo-erro.mensagem.
            delete tt-bo-erro.
        end.
        run cdp/cd0666.w (input table tt-erro).
        return error.
    end.    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
def var c-nome-tabela as char no-undo init "Motivo Refugo":U.     

 {utp/ut-table.i mgind motiv-refugo 01}
 assign c-nome-tabela = return-value.
 find first rep-refugo-oper
     where rep-refugo-oper.cod-motiv-refugo = motiv-refugo.cod-motiv-refugo 
     no-lock no-error.

 if  avail rep-refugo-oper then do: 

     {utp/ut-table.i mgind rep-refugo-oper 01}
     run utp/ut-msgs.p (input "show",
                        input 17,
                        input c-nome-tabela + "~~" + return-value).
     return error. 
 end. 

   run EliminarMotivoRefugo (input motiv-refugo.cod-motiv-refugo,
                            output table tt-bo-erro).
  if can-find(first tt-bo-erro) then do:
     for each tt-bo-erro:
         create tt-erro.
         assign tt-erro.i-sequen = tt-bo-erro.i-sequen
                tt-erro.cd-erro  = tt-bo-erro.cd-erro
                tt-erro.mensagem = tt-bo-erro.mensagem.
         delete tt-bo-erro.
     end.
     run cdp/cd0666.w (input table tt-erro).
     return error.
  end.
  else do:
      RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
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
    
    IF l-sfc-mudancas THEN
        DISABLE fi-cod-clas-motiv WITH FRAME f-main.
    
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

    if available motiv-refugo then do:
         find cod-rejeicao where cod-rejeicao.codigo-rejei = motiv-refugo.codigo-rejei no-lock no-error.
         assign c-desc = if avail cod-rejeicao then cod-rejeicao.descricao else "":U.
    end.

  IF AVAIL motiv-refugo AND l-sfc-mudancas THEN DO:

      ASSIGN fi-cod-clas-motiv = 
      &IF DEFINED(bf_man_207) &THEN
           motiv-refugo.cod-clas-motiv
      &ELSE
           SUBSTRING(motiv-refugo.char-1,1,8)
      &ENDIF .
      
      DISPLAY fi-cod-clas-motiv 
              fi-des-clas-motiv WITH FRAME f-main.

      APPLY "leave":U TO fi-cod-clas-motiv IN FRAME f-main.
      ASSIGN fi-des-clas-motiv = fi-des-clas-motiv:SCREEN-VALUE IN FRAME f-main.

  END.

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
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
/*    if adm-new-record = yes then*/
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    IF l-sfc-mudancas THEN
        ENABLE fi-cod-clas-motiv WITH FRAME f-main.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

&IF DEFINED(bf_man_204) &THEN
    RUN sfc/sf9999.p(OUTPUT l-sfc-mudancas).
&ENDIF

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  assign motiv-refugo.log-retrabalho:sensitive in frame {&frame-name} = no.

  IF l-sfc-mudancas THEN
      ASSIGN fi-cod-clas-motiv:HIDDEN IN FRAME f-main = NO
             fi-des-clas-motiv:HIDDEN IN FRAME f-main = NO.
  ELSE
      ASSIGN fi-cod-clas-motiv:HIDDEN IN FRAME f-main = YES
             fi-des-clas-motiv:HIDDEN IN FRAME f-main = YES
             motiv-refugo.log-retrabalho:ROW IN FRAME f-main   = motiv-refugo.log-retrabalho:ROW IN FRAME f-main - 0.44
             motiv-refugo.log-material:ROW IN FRAME f-main     = motiv-refugo.log-material:ROW IN FRAME f-main   - 0.44
             motiv-refugo.des-motiv-refugo:ROW IN FRAME f-main = motiv-refugo.des-motiv-refugo:ROW IN FRAME f-main + 0.44
             label-desc:ROW IN FRAME f-main                    = label-desc:ROW IN FRAME f-main + 0.44
             motiv-refugo.codigo-rejei:ROW IN FRAME f-main     = motiv-refugo.codigo-rejei:ROW IN FRAME f-main + 0.44
             c-desc:ROW IN FRAME f-main                        = c-desc:ROW IN FRAME f-main + 0.44
             label-rejei:ROW IN FRAME f-main                   = label-rejei:ROW IN FRAME f-main + 0.44.

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

  /* Code placed here will execute AFTER standard behavior.    */

  if avail motiv-refugo then
     assign gr-motiv-refugo = rowid(motiv-refugo).

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
  {src/adm/template/snd-list.i "motiv-refugo"}

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

