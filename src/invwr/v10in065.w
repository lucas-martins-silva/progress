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
{include/i-prgvrs.i V10IN065 2.00.00.012 } /*** "010012" 14/11/2023 11:37:08  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V10IN065 MUT}
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

def new global shared var gr-contrato-for as rowid no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES contrato-for
&Scoped-define FIRST-EXTERNAL-TABLE contrato-for


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR contrato-for.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS contrato-for.ind-sit-contrat ~
contrato-for.ind-control-rec contrato-for.mo-codigo ~
contrato-for.variacao-qtd contrato-for.variacao-preco ~
contrato-for.cod-cond-pag contrato-for.cod-projeto contrato-for.dat-revisao ~
contrato-for.cod-cond-fatur contrato-for.gestor-tecnico ~
contrato-for.cod-mensagem contrato-for.contato contrato-for.impr-contrat contrato-for.log-libera 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}ind-sit-contrat ~{&FP2}ind-sit-contrat ~{&FP3}~
 ~{&FP1}ind-control-rec ~{&FP2}ind-control-rec ~{&FP3}~
 ~{&FP1}mo-codigo ~{&FP2}mo-codigo ~{&FP3}~
 ~{&FP1}variacao-qtd ~{&FP2}variacao-qtd ~{&FP3}~
 ~{&FP1}variacao-preco ~{&FP2}variacao-preco ~{&FP3}~
 ~{&FP1}cod-cond-pag ~{&FP2}cod-cond-pag ~{&FP3}~
 ~{&FP1}cod-projeto ~{&FP2}cod-projeto ~{&FP3}~
 ~{&FP1}dat-revisao ~{&FP2}dat-revisao ~{&FP3}~
 ~{&FP1}cod-cond-fatur ~{&FP2}cod-cond-fatur ~{&FP3}~
 ~{&FP1}gestor-tecnico ~{&FP2}gestor-tecnico ~{&FP3}~
 ~{&FP1}cod-mensagem ~{&FP2}cod-mensagem ~{&FP3}
&Scoped-define ENABLED-TABLES contrato-for
&Scoped-define FIRST-ENABLED-TABLE contrato-for
&Scoped-Define ENABLED-OBJECTS RECT-6 
&Scoped-Define DISPLAYED-FIELDS contrato-for.ind-sit-contrat ~
contrato-for.ind-control-rec contrato-for.mo-codigo ~
contrato-for.variacao-qtd contrato-for.variacao-preco ~
contrato-for.cod-cond-pag contrato-for.cod-projeto contrato-for.dat-revisao ~
contrato-for.cod-cond-fatur contrato-for.gestor-tecnico ~
contrato-for.cod-mensagem contrato-for.contato contrato-for.impr-contrat ~
contrato-for.log-libera 
&Scoped-Define DISPLAYED-OBJECTS FI-situacao FI-controle FI-moeda ~
FI-cond-pagto fi-natureza 

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
DEFINE VARIABLE FI-cond-pagto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88 NO-UNDO.

DEFINE VARIABLE FI-controle AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE FI-moeda AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 18.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-natureza AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE FI-situacao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85 BY 9.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     contrato-for.ind-sit-contrat AT ROW 1.83 COL 23.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2.29 BY .88
     FI-situacao AT ROW 1.83 COL 26 COLON-ALIGNED NO-LABEL
     contrato-for.ind-control-rec AT ROW 1.83 COL 63 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2.29 BY .88
     FI-controle AT ROW 1.83 COL 66 COLON-ALIGNED NO-LABEL
     contrato-for.mo-codigo AT ROW 2.83 COL 23.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     FI-moeda AT ROW 2.83 COL 27.14 COLON-ALIGNED NO-LABEL
     contrato-for.variacao-qtd AT ROW 2.83 COL 63 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     contrato-for.variacao-preco AT ROW 2.83 COL 72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     contrato-for.cod-cond-pag AT ROW 3.75 COL 23.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     FI-cond-pagto AT ROW 3.83 COL 28.29 COLON-ALIGNED NO-LABEL
     contrato-for.cod-projeto AT ROW 3.83 COL 63 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     fi-natureza AT ROW 4.75 COL 23.29 COLON-ALIGNED
     contrato-for.dat-revisao AT ROW 4.83 COL 63 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     contrato-for.cod-cond-fatur AT ROW 5.75 COL 23.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     contrato-for.gestor-tecnico AT ROW 5.83 COL 63.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     contrato-for.cod-mensagem AT ROW 6.75 COL 23.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.38 BY .88
     contrato-for.contato AT ROW 7.75 COL 23.29 COLON-ALIGNED 
          VIEW-AS FILL-IN 
          SIZE 56.72 BY .88
     contrato-for.impr-contrat AT ROW 9 COL 25.25
          VIEW-AS TOGGLE-BOX
          SIZE 22.57 BY .83
     contrato-for.log-libera AT ROW 9 COL 48
          VIEW-AS TOGGLE-BOX
          SIZE 8.14 BY .83
     RECT-6 AT ROW 1.08 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.contrato-for
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
         WIDTH              = 85.
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

/* SETTINGS FOR FILL-IN FI-cond-pagto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FI-controle IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FI-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-natureza IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FI-situacao IN FRAME f-main
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



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

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
  {src/adm/template/row-list.i "contrato-for"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "contrato-for"}

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

 if avail contrato-for then do:
   
    assign fi-situacao = {ininc/i05in065.i 04 contrato-for.ind-sit-contrat}
           fi-natureza = {ininc/i01in274.i 04 contrato-for.natureza}.
    
    {utp/ut-field.i mgind contrato-for natureza 1}
    assign fi-natureza:label in frame {&frame-name} = return-value.                         
   
  
    find cond-pagto where
         cond-pagto.cod-cond-pag = contrato-for.cod-cond-pag
         no-lock no-error.
    if avail cond-pagto then      
       assign fi-cond-pagto = cond-pagto.descricao.     
  
    find moeda where  moeda.mo-codigo = contrato-for.mo-codigo 
         no-lock no-error.      
    if avail moeda then 
      assign fi-moeda = moeda.descricao.        
      display fi-moeda with frame {&frame-name}.


    if contrato-for.ind-control-rec = 1 
       then do: {utp/ut-liter.i Total_Nota * r}
           assign fi-controle = return-value.
       end.
       else do: {utp/ut-field.i mgind item it-codigo 1}
           assign fi-controle = return-value.
       end.
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
  {src/adm/template/snd-list.i "contrato-for"}

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


