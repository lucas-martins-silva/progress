&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
{include/i-prgvrs.i V06IN178 2.00.00.011}  /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v06in178 MUT}
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
{include/i_fnctrad.i}
{cdp/cdcfgmat.i}
/* Local Variable Definitions ---                                       */
def new global shared var gr-item-fornec as rowid no-undo.
def var c-container  as char   no-undo.
def var wh-container as handle no-undo.

def temp-table  tt-old-item-fornec like item-fornec .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold cb-tp-inspecao-novo bt-sav 
&Scoped-Define DISPLAYED-OBJECTS c-item c-des-item i-cod-emitente ~
c-des-emitente cb-tp-inspecao-original cb-tp-inspecao-novo 

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
DEFINE BUTTON bt-sav 
     IMAGE-UP FILE "image~\im-sav":U
     IMAGE-INSENSITIVE FILE "image~\ii-sav":U
     LABEL "&Sav" 
     SIZE 3.43 BY 1.04
     FONT 4.

DEFINE VARIABLE cb-tp-inspecao-novo AS CHARACTER FORMAT "X(20)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tp-inspecao-original AS CHARACTER FORMAT "X(20)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE c-des-emitente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-item AS CHARACTER FORMAT "X(37)":U 
     VIEW-AS FILL-IN 
     SIZE 59.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-item AS CHARACTER FORMAT "X(16)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-emitente AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 2.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.43 BY 1.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-item AT ROW 1.17 COL 11 COLON-ALIGNED
     c-des-item AT ROW 1.17 COL 27.43 COLON-ALIGNED NO-LABEL
     i-cod-emitente AT ROW 2.17 COL 11 COLON-ALIGNED
     c-des-emitente AT ROW 2.17 COL 23 COLON-ALIGNED NO-LABEL
     cb-tp-inspecao-original AT ROW 3.71 COL 11 COLON-ALIGNED
     cb-tp-inspecao-novo AT ROW 3.71 COL 62 COLON-ALIGNED
     bt-sav AT ROW 3.71 COL 85 HELP
          "Confirma altera‡äes"
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 3.46 COL 1
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 4.04
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-des-emitente IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-tp-inspecao-original IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-cod-emitente IN FRAME f-main
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

&Scoped-define SELF-NAME bt-sav
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sav V-table-Win
ON CHOOSE OF bt-sav IN FRAME f-main /* Sav */
DO:
   find first item-fornec
        where item-fornec.cod-emitente = integer(i-cod-emitente:screen-value in frame {&FRAME-NAME})
        and   item-fornec.it-codigo    = c-item:screen-value in frame {&frame-name} EXCLUSIVE-LOCK.

   &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
       FOR EACH tt-old-item-fornec:
           DELETE tt-old-item-fornec.
       END.
       create tt-old-item-fornec.
       buffer-copy item-fornec to tt-old-item-fornec.
   &ENDIF
    
   assign item-fornec.tp-inspecao = {ininc/i03in178.i 06 cb-tp-inspecao-novo:screen-value in frame {&FRAME-NAME}}.

   RUN Who-Is-The-Container IN adm-broker-hdl
    (INPUT this-procedure,
     OUTPUT c-container).

   assign wh-container = widget-handle(c-container).

   run pi-atualiza-browse in wh-container (input item-fornec.cod-emitente,
                                           input item-fornec.it-codigo,
                                           input item-fornec.tp-inspecao).

   &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
       if can-find(FIRST funcao
                   WHERE funcao.cd-funcao = "spp-cq-itfornest" 
                   AND   funcao.ativo     = YES NO-LOCK ) THEN DO :
           
            run cqp/cq0215b.w (input item-fornec.it-codigo,
                               input item-fornec.cod-emitente,
                               input table tt-old-item-fornec).
       END.
       &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
               run cqp/cq0215b.w (input item-fornec.it-codigo,
                                  input item-fornec.cod-emitente,
                                  input table tt-old-item-fornec).
           
       &endif
   &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-tp-inspecao-novo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tp-inspecao-novo V-table-Win
ON VALUE-CHANGED OF cb-tp-inspecao-novo IN FRAME f-main
DO:
  if cb-tp-inspecao-original:screen-value in frame {&frame-name} = cb-tp-inspecao-novo:screen-value in frame {&frame-name}
  then disable bt-sav with frame {&frame-name}.
  else enable bt-sav with frame {&frame-name}.


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
   RETURN 'ADM-ERROR':U.
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
  find item-fornec
     where rowid(item-fornec) = gr-item-fornec NO-LOCK no-error.
  if avail item-fornec then do:
     assign c-item:screen-value in frame {&frame-name} = item-fornec.it-codigo
            i-cod-emitente:screen-value in frame {&FRAME-NAME} = string(item-fornec.cod-emitente)
            cb-tp-inspecao-original:screen-value in frame {&frame-name} = {ininc/i03in178.i 04 item-fornec.tp-inspecao}.
     find item
        where item.it-codigo = item-fornec.it-codigo NO-LOCK no-error.
        assign c-des-item:screen-value in frame {&FRAME-NAME} = if avail item then item.desc-item else "":U.

     find emitente
        where emitente.cod-emitente = item-fornec.cod-emitente NO-LOCK no-error.
        assign c-des-emitente:screen-value in frame {&FRAME-NAME} = if avail emitente then emitente.nome-abrev else "":U.
  end.

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
  do with frame {&FRAME-NAME}:
     assign cb-tp-inspecao-original:list-items = {ininc/i03in178.i 03}
            cb-tp-inspecao-novo:list-items     = {ininc/i03in178.i 03}.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  {utp/ut-field.i mgind item-fornec it-codigo 1}
  assign c-item:label in frame {&FRAME-NAME} = return-value.

  {utp/ut-field.i mgind item-fornec cod-emitente 1}
  assign i-cod-emitente:label in frame {&FRAME-NAME} = return-value.

  {utp/ut-field.i mgind item-fornec tp-inspecao 1}
  assign cb-tp-inspecao-original:label in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i Tipo_Inspe‡Æo_Novo MCQ L}
  assign cb-tp-inspecao-novo:label in frame {&FRAME-NAME} = return-value.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-combo-box V-table-Win 
PROCEDURE pi-carrega-combo-box :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input parameter c-cb-tp-insp-novo as char format "X(14)" no-undo.
def var i-aux as integer no-undo.
DEF VAR c-lista AS CHAR NO-UNDO.

do with frame {&FRAME-NAME}:
   enable cb-tp-inspecao-novo.

   &if "{&fnc_multi_idioma}":U = "yes":U &then
        ASSIGN c-lista = {ininc/i03in178.i 03}.
        RUN utp/ut-lstit.p (INPUT-OUTPUT c-lista).
        cb-tp-inspecao-novo:list-item-pairs = c-lista.
   &else
        assign cb-tp-inspecao-novo:list-items = {ininc/i03in178.i 03}.    
   &ENDIF

end.

assign i-aux = {ininc/i03in178.i 06 c-cb-tp-insp-novo}.

assign cb-tp-inspecao-novo:screen-value in frame {&frame-name} = {ininc/i03in178.i 04 i-aux}.

if cb-tp-inspecao-original:screen-value in frame {&frame-name} = cb-tp-inspecao-novo:screen-value in frame {&frame-name}
  then disable bt-sav with frame {&frame-name}.
  else enable bt-sav with frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desabilita-viewer V-table-Win 
PROCEDURE pi-desabilita-viewer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
disable cb-tp-inspecao-novo bt-sav with frame {&frame-name}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
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

