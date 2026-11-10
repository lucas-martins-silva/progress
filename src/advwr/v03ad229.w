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
{include/i-prgvrs.i V03AD229 2.00.00.010 } /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V03AD229 MUT}
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
{cdp/cdcfgfin.i}
{include/i_dbvers.i}
{cdp/cdcfgdis.i} 

def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

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
&Scoped-define EXTERNAL-TABLES repres
&Scoped-define FIRST-EXTERNAL-TABLE repres


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR repres.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS repres.endereco repres.Complemento ~
repres.bairro repres.cidade repres.caixa-postal repres.nome-ab-reg ~
repres.cep repres.pais repres.estado repres.telefone[1] repres.telefax ~
repres.cgc repres.inscr-est repres.e-mail 
&Scoped-define ENABLED-TABLES repres
&Scoped-define FIRST-ENABLED-TABLE repres
&Scoped-Define ENABLED-OBJECTS t-end-compl 
&Scoped-Define DISPLAYED-FIELDS repres.endereco repres.Complemento ~
repres.bairro repres.cidade repres.caixa-postal repres.nome-ab-reg ~
repres.cep repres.pais repres.estado repres.telefone[2] repres.telefone[1] ~
repres.telefax repres.cgc repres.inscr-est repres.e-mail 
&Scoped-define DISPLAYED-TABLES repres
&Scoped-define FIRST-DISPLAYED-TABLE repres
&Scoped-Define DISPLAYED-OBJECTS c-natureza c-end-compl c-rep-rat-cotas ~
t-end-compl 

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
DEFINE VARIABLE c-end-compl AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 2000 SCROLLBAR-VERTICAL
     SIZE 71.29 BY 1.71 TOOLTIP "Endere‡o Completo" NO-UNDO.

DEFINE VARIABLE c-natureza AS CHARACTER FORMAT "X(256)":U 
     LABEL "c-natureza" 
     VIEW-AS FILL-IN 
     SIZE 28.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-rep-rat-cotas AS CHARACTER FORMAT "x(10)":U 
     LABEL "Rep Rat Cotas" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE t-end-compl AS CHARACTER FORMAT "X(15)":U INITIAL "End. Completo:" 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-natureza AT ROW 1 COL 14.86 COLON-ALIGNED
     repres.endereco AT ROW 2 COL 14.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 47.14 BY .88
     c-end-compl AT ROW 2.96 COL 16.86 NO-LABEL
     repres.Complemento AT ROW 4.75 COL 14.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 47.14 BY .88
     repres.bairro AT ROW 5.75 COL 14.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     repres.cidade AT ROW 5.75 COL 51 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 26.43 BY .88
     repres.caixa-postal AT ROW 6.75 COL 14.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .88
     repres.nome-ab-reg AT ROW 6.75 COL 51 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19 BY .88
     repres.cep AT ROW 7.75 COL 14.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     repres.pais AT ROW 7.75 COL 51 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .88
     repres.estado AT ROW 7.75 COL 77.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.43 BY .88
     repres.telefone[2] AT ROW 8.75 COL 14.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.86 BY .88
     repres.telefone[1] AT ROW 8.75 COL 43.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.86 BY .88
     repres.telefax AT ROW 8.75 COL 70 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     repres.cgc AT ROW 9.75 COL 14.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 23 BY .88
     repres.inscr-est AT ROW 9.75 COL 63.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 23 BY .88
     repres.e-mail AT ROW 10.75 COL 14.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 39.29 BY .88
     c-rep-rat-cotas AT ROW 11.75 COL 14.86 COLON-ALIGNED
     t-end-compl AT ROW 3.13 COL 2.29 NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.repres
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
         HEIGHT             = 11.67
         WIDTH              = 87.86.
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

/* SETTINGS FOR EDITOR c-end-compl IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-natureza IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-rep-rat-cotas IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN t-end-compl IN FRAME f-main
   ALIGN-L                                                              */
ASSIGN 
       t-end-compl:PRIVATE-DATA IN FRAME f-main     = 
                "End. Completo:".

/* SETTINGS FOR FILL-IN repres.telefone[2] IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/
  {utp/ut-field.i mgadm repres natureza 1}
  assign c-natureza:label in frame {&frame-name} = return-value.

  /*Find First param-global No-Lock No-Error.*/

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
  {src/adm/template/row-list.i "repres"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "repres"}

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

  &if defined(bf_fin_4linhas_end) &then
      assign c-end-compl:sensitive in frame {&frame-name} = no
             t-end-compl:sensitive in frame {&frame-name} = no.
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

  case repres.natureza:
    when 1 then /* F¡sica */
        assign repres.cgc:format in frame {&FRAME-NAME} = param-global.formato-id-pessoal no-error.
    when 2 then /* Jur¡dica */
        assign repres.cgc:format in frame {&FRAME-NAME} = param-global.formato-id-federal no-error.
    otherwise /* Inclui: estrangeiro, trading */
        assign repres.cgc:format in frame {&frame-name} = "x(19)" no-error.
  end case.

  if repres.cgc = "" then
    assign repres.cgc:format in frame {&frame-name} = "x(19)" no-error.

  if ERROR-STATUS:ERROR then 
    assign repres.cgc:format in frame {&frame-name} = "x(19)" no-error.
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
  if avail repres then do with frame {&frame-name}:
     assign c-natureza:screen-value = {adinc/i03ad098.i 04 repres.natureza}.
     RUN utp/ut-liter.p (INPUT REPLACE(c-natureza:SCREEN-VALUE," ","_"),"*","").
     ASSIGN c-natureza:screen-value = RETURN-VALUE.
  end.
    
  assign repres.cgc:label = param-global.label-cgc.             

  &if defined(bf_fin_4linhas_end) &then 
     assign c-end-compl:screen-value in frame {&frame-name} = repres.endereco_text.
  &endif

  &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
      &IF "{&bf_dis_versao_ems}" < "2.06" &THEN
          IF  SUBSTR(repres.char-1,1,1) = "" THEN DO:
              {utp/ut-liter.i Sim}
              ASSIGN c-rep-rat-cotas:screen-value = RETURN-VALUE.
          END.
          ELSE DO:
              IF  SUBSTR(repres.char-1,1,1) = "1" THEN DO:
                  {utp/ut-liter.i NÆo}
                  ASSIGN c-rep-rat-cotas:screen-value = RETURN-VALUE.
              END.
          END.
      &ELSE
          IF  repres.log-consid-repres-cotas THEN DO:
              {utp/ut-liter.i Sim}
              ASSIGN c-rep-rat-cotas:screen-value = RETURN-VALUE.
          END.
          ELSE DO:
              {utp/ut-liter.i NÆo}
              ASSIGN c-rep-rat-cotas:screen-value = RETURN-VALUE.
          END. 
      &ENDIF
  &ENDIF

  {utp/ut-liter.i END._Completo: * R}
  ASSIGN t-end-compl:SCREEN-VALUE IN FRAME {&FRAME-NAME} = trim(RETURN-VALUE).
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

  &if defined(bf_fin_4linhas_end) &then
      assign c-end-compl:sensitive in frame {&frame-name} = yes
             t-end-compl:sensitive in frame {&frame-name} = yes.
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
  
  Find First param-global No-Lock No-Error.
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
  &IF "{&bf_dis_versao_ems}" <= "2.02" &THEN
    assign c-rep-rat-cotas:visible in frame {&frame-name} = no.
  &ELSE  
      if param-global.modulo-08 = yes then 
            assign c-rep-rat-cotas:visible in frame {&frame-name} = yes.
      else 
            assign c-rep-rat-cotas:visible in frame {&frame-name} = no.
  &ENDIF
  
  assign c-end-compl:visible in frame {&frame-name} = no
         t-end-compl:visible in frame {&frame-name} = no.

  &if defined(bf_fin_4linhas_end) &then
      assign c-end-compl:visible in frame {&frame-name} = yes
             t-end-compl:visible in frame {&frame-name} = yes.
  &endif    
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
  {src/adm/template/snd-list.i "repres"}

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

