&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i V35AD098 2.00.00.019 } /*** "010019" 27/08/2025 14:43:24 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V35AD098 MUT}
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
/* PCREQ-9042 - Portador do Emitente */
define variable h-api-zoom         as handle  no-undo.
define variable i-cdn-portador     as integer no-undo.
define variable i-cdn-modalidade   as integer no-undo.

{cdp/cdapi3009.i1}

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
&Scoped-define EXTERNAL-TABLES emitente
&Scoped-define FIRST-EXTERNAL-TABLE emitente


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR emitente.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS emitente.cod-gr-cli emitente.data-implant ~
emitente.cod-rep emitente.cod-transp emitente.end-cobranca ~
emitente.portador emitente.nat-operacao emitente.nat-ope-ext emitente.atividade ~
emitente.categoria emitente.linha-produt emitente.cod-canal-venda ~
emitente.nr-peratr emitente.nr-mesina 
&Scoped-define ENABLED-TABLES emitente
&Scoped-define FIRST-ENABLED-TABLE emitente
&Scoped-define DISPLAYED-TABLES emitente
&Scoped-define FIRST-DISPLAYED-TABLE emitente
&Scoped-Define DISPLAYED-FIELDS emitente.cod-gr-cli emitente.data-implant ~
emitente.cod-rep emitente.cod-transp emitente.end-cobranca ~
emitente.portador emitente.nat-operacao emitente.nat-ope-ext emitente.atividade ~
emitente.categoria emitente.linha-produt emitente.cod-canal-venda ~
emitente.nr-peratr emitente.nr-mesina 
&Scoped-Define DISPLAYED-OBJECTS c-gr-cli c-nome-abrev c-nome-abrev-transp ~
c-modalidade c-portador c-natureza cb-tp-ente-gov 

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
DEFINE BUTTON bt-portador-fin 
     IMAGE-UP FILE "image\gr-zoo.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-zoo.bmp":U
     LABEL "Portador Financeiro" 
     SIZE 3 BY .88 TOOLTIP "Portador Financeiro".

DEFINE VARIABLE cb-tp-ente-gov AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE c-gr-cli AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 32.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-modalidade AS CHARACTER FORMAT "X(20)" 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-natureza AS CHARACTER FORMAT "X(15)" 
     LABEL "Natureza":R10 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev AS CHARACTER FORMAT "x(12)" 
     VIEW-AS FILL-IN 
     SIZE 29.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev-transp AS CHARACTER FORMAT "X(12)" 
     VIEW-AS FILL-IN 
     SIZE 31.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-portador AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 27.86 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     emitente.cod-gr-cli AT ROW 1.21 COL 19.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.57 BY .88
     c-gr-cli AT ROW 1.21 COL 25 COLON-ALIGNED NO-LABEL
     emitente.data-implant AT ROW 2.21 COL 19.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     emitente.cod-rep AT ROW 3.21 COL 19.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-nome-abrev AT ROW 3.21 COL 26.43 COLON-ALIGNED HELP
          "Informe o nome abreviado do representante" NO-LABEL
     emitente.cod-transp AT ROW 4.21 COL 19.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.43 BY .88
     c-nome-abrev-transp AT ROW 4.21 COL 27.72 COLON-ALIGNED NO-LABEL
     emitente.end-cobranca AT ROW 5.21 COL 19.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.43 BY .88
     emitente.portador AT ROW 6.21 COL 19.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-modalidade AT ROW 6.21 COL 26.43 COLON-ALIGNED HELP
          "Informe a modalidade de cobran‡a" NO-LABEL
     c-portador AT ROW 6.21 COL 45.14 COLON-ALIGNED NO-LABEL
     bt-portador-fin AT ROW 6.21 COL 75
     emitente.nat-operacao AT ROW 7.21 COL 19.14 COLON-ALIGNED
          LABEL "Natureza Estad/Export"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     c-natureza AT ROW 7.21 COL 60 COLON-ALIGNED
     emitente.nat-ope-ext AT ROW 8.21 COL 19.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     emitente.categoria AT ROW 8.21 COL 60 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     emitente.atividade AT ROW 9.21 COL 19.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.14 BY .88
     cb-tp-ente-gov AT ROW 9.21 COL 60 COLON-ALIGNED 
     emitente.linha-produt AT ROW 10.21 COL 19.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     emitente.cod-canal-venda AT ROW 10.21 COL 60 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.29 BY .88
     emitente.nr-peratr AT ROW 11.21 COL 19.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     emitente.nr-mesina AT ROW 11.21 COL 60 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.emitente
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
         HEIGHT             = 11.58
         WIDTH              = 83.86.
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

/* SETTINGS FOR FILL-IN c-gr-cli IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-modalidade IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-natureza IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-abrev IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-abrev-transp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-portador IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-tp-ente-gov IN FRAME f-main
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

&Scoped-define SELF-NAME bt-portador-fin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-portador-fin V-table-Win
ON CHOOSE OF bt-portador-fin IN FRAME f-main /* Portador Financeiro */
DO:
    /* PCREQ-9042 - Portador do Emitente */
    if avail emitente then do:

        if search("prgint/ufn/ufn008za.r")  <> ?
        or search("prgint/ufn/ufn008za.py") <> ? then
            run prgint/ufn/ufn008za.py persistent set h-api-zoom.

        if valid-handle(h-api-zoom) then do:
            empty temp-table tt_log_erro.
            run pi_zoom_port_ind_port_fin in h-api-zoom (input 1,
                                                         input emitente.cod-emitente,
                                                         input "Cliente",
                                                         input "",
                                                         output i-cdn-portador,
                                                         output i-cdn-modalidade,
                                                         output table tt_log_erro).
            delete procedure h-api-zoom.
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
  
  {utp/ut-field.i mgadm emitente natureza 1}
  assign c-natureza:label in frame {&frame-name} = return-value.
  IF i-pais-impto-usuario = 1 THEN
  DO:
   {utp/ut-liter.i "Tipo_Ente_Governamental"}
   assign cb-tp-ente-gov:label in frame {&frame-name} = return-value.
  END.
  
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
  {src/adm/template/row-list.i "emitente"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "emitente"}

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  if  avail emitente then do:
     
      for first repres fields(cod-rep nome-abrev) where 
           repres.cod-rep = emitente.cod-rep no-lock:
         assign c-nome-abrev = if avail repres then repres.nome-abrev else "":U.
      end.
      
      for first transporte where 
                transporte.cod-transp = emitente.cod-transp no-lock:
         assign c-nome-abrev-transp = if avail transporte then transporte.nome-abrev else "":U.
      end.
     
      for first gr-cli fields(cod-gr-cli descricao) where 
                gr-cli.cod-gr-cli = emitente.cod-gr-cli no-lock:
        assign c-gr-cli = if avail gr-cli then gr-cli.descricao else "":U.
      end.
      
      assign i-cdn-portador   = emitente.portador  
             i-cdn-modalidade = emitente.modalidade.

      /* PCREQ-9042 - Portador do Emitente */
      if l-fn-port-emitente then do:
      
          assign bt-portador-fin:sensitive in frame {&frame-name} = l-fn-port-emitente.
     
          if search("prgint/ufn/ufn008za.r")  <> ?
          or search("prgint/ufn/ufn008za.py") <> ? then
              run prgint/ufn/ufn008za.py persistent set h-api-zoom.
          
          if valid-handle(h-api-zoom) then do:
              empty temp-table tt_log_erro.
              run pi_busca_dados_portador_fin in h-api-zoom (input "",
                                                             input i-cdn-portador,
                                                             input i-cdn-modalidade,
                                                             input emitente.cod-emitente,
                                                             input "Cliente",
                                                             input "",
                                                             output i-cdn-portador,
                                                             output i-cdn-modalidade,
                                                             output table tt_log_erro).
              delete procedure h-api-zoom.
     
              assign emitente.portador:screen-value = string(i-cdn-portador).

          end.
      end.

      for first portador fields (ep-codigo cod-portador modalidade nome) where
                portador.ep-codigo    = i-ep-codigo-usuario and
                portador.cod-portador = i-cdn-portador      and
                portador.modalidade   = i-cdn-modalidade no-lock:
        assign c-portador = portador.nome.
      end.

      assign c-modalidade:screen-value = if i-cdn-modalidade <> 0 then {adinc/i03ad209.i 04 i-cdn-modalidade} else {adinc/i03ad209.i 04 1}.
      assign c-natureza:screen-value in frame {&frame-name} = entry(emitente.natureza, {adinc/i03ad098.i 03}).

      IF i-pais-impto-usuario = 1 THEN DO:
        IF AVAIL emitente AND INT(TRIM(SUBSTRING(emitente.char-1,165,1))) > 0 THEN 
           ASSIGN cb-tp-ente-gov:SCREEN-VALUE IN FRAME {&frame-name} = ENTRY(INT(TRIM(SUBSTRING(emitente.char-1,165,1))), {adinc/i32ad098.i 03}). 
      END.
      ELSE 
         ASSIGN cb-tp-ente-gov:VISIBLE IN FRAME {&frame-name} = NO.
      
  end.
  display c-nome-abrev c-nome-abrev-transp c-gr-cli c-portador with frame {&frame-name}.

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
  /* PCREQ-9042 - Portador do Emitente */
  {cdp/cdapi3009.i2}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-view V-table-Win 
PROCEDURE local-view :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'view':U ) .

  /* PCREQ-9042 - Portador do Emitente */
  assign bt-portador-fin:visible in frame {&frame-name} = l-fn-port-emitente.

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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "emitente"}

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

