&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          movind           PROGRESS
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
{include/i-prgvrs.i V26IN090 2.00.00.018 } /*** "010018" 13/07/2026 08:23:38 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v26in090 MUT}
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
 
def new global shared var gr-emitente   as rowid no-undo.
def new global shared var gr-natur-oper as rowid no-undo.
def new global shared var gr-documento  as rowid no-undo.

DEFINE VARIABLE c-cod-cfop AS CHARACTER   NO-UNDO.
{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}
{rep/re0701.i} /* variaveis e procedure pi-recebe-handle */
{rep/re1001v.i} 


DEFINE VARIABLE i-tip-emis-nf-eletro AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-esocial            AS CHAR        NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES docum-est
&Scoped-define FIRST-EXTERNAL-TABLE docum-est


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR docum-est.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS docum-est.cod-emitente docum-est.nro-docto ~
docum-est.serie-docto docum-est.nat-operacao 
&Scoped-define ENABLED-TABLES docum-est
&Scoped-define FIRST-ENABLED-TABLE docum-est
&Scoped-Define ENABLED-OBJECTS RECT-7 
&Scoped-Define DISPLAYED-FIELDS docum-est.cod-emitente docum-est.nro-docto ~
docum-est.serie-docto docum-est.nat-operacao 
&Scoped-define DISPLAYED-TABLES docum-est
&Scoped-define FIRST-DISPLAYED-TABLE docum-est


/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS docum-est.cod-emitente ~
docum-est.serie-docto docum-est.nat-operacao 

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
DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.43 BY 1.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     docum-est.cod-emitente AT ROW 1.25 COL 10.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     docum-est.nro-docto AT ROW 1.25 COL 35.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     docum-est.serie-docto AT ROW 1.25 COL 52.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     docum-est.nat-operacao AT ROW 1.25 COL 76.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
     RECT-7 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.docum-est
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
         HEIGHT             = 1.58
         WIDTH              = 89.
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

/* SETTINGS FOR FILL-IN docum-est.cod-emitente IN FRAME f-main
   1                                                                    */
/* SETTINGS FOR FILL-IN docum-est.nat-operacao IN FRAME f-main
   1                                                                    */
/* SETTINGS FOR FILL-IN docum-est.serie-docto IN FRAME f-main
   1                                                                    */
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
  {src/adm/template/row-list.i "docum-est"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "docum-est"}

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
  /* Ponha na pi-validate todas as validaï¿½ï¿½es */
  /* Nï¿½o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignï¿½s nï¿½o feitos pelo assign-record devem ser feitos aqui */  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
  /* Code placed here will execute PRIOR to standard behavior. */
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  if  avail docum-est then do:
      assign gr-documento = rowid(docum-est).

      if  valid-handle (h_b29in090) then
          run pi-recebe-rowid in h_b29in090 ( rowid(docum-est),
                                              "docum-est" ).
      if  valid-handle (h_b33in090) then
          run pi-recebe-rowid in h_b33in090 ( rowid(docum-est),
                                              "docum-est" ).
  end.
 
  FIND FIRST emitente 
       WHERE emitente.cod-emitente = docum-est.cod-emitente NO-LOCK NO-ERROR.
  IF AVAIL emitente THEN DO:
     ASSIGN gr-emitente = ROWID(emitente).

     /*ESocial*/
     ASSIGN c-esocial = SUBSTRING(emitente.char-2,104,8).
     IF c-esocial = "Servi‡os":U OR
        c-esocial = "Prod/Ser":U OR
        c-esocial = "Ambos":U THEN
         RUN new-state ('habilita-bt-esocial':U).
     ELSE IF c-esocial = "PR Rural":U THEN
         RUN new-state ('bt-esocial-pr-rural':U).
     ELSE
         RUN new-state ('desabilita-bt-esocial':U).

  END.


   FIND FIRST estabelec  
          WHERE estabelec.cod-estabel = docum-est.cod-estabel NO-LOCK NO-ERROR.
     IF AVAIL estabelec THEN DO:

         &if "{&BF_MAT_VERSAO_EMS}" >= "2.07" &then
            ASSIGN i-tip-emis-nf-eletro = estabelec.idi-tip-emis-nf-eletro.
         &else
            ASSIGN i-tip-emis-nf-eletro = INT(TRIM(SUBSTRING(estabelec.char-1,168,1))).
         &endif
     END.
 
  FIND FIRST natur-oper 
       WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-LOCK NO-ERROR.
  IF AVAIL natur-oper THEN DO:
     ASSIGN gr-natur-oper = ROWID(natur-oper).
       
     
     IF natur-oper.imp-nota THEN 
       RUN new-state ("habilita-bt-embalagem":U).
     ELSE 
        RUN new-state ("desabilita-bt-embalagem":U).
    
    &if  defined(bf_dis_formato_CFOP) &then
        ASSIGN c-cod-cfop = natur-oper.cod-cfop.
    &else
        ASSIGN c-cod-cfop = substring(natur-oper.char-1,45,10).
    &endif

     IF  c-cod-cfop BEGINS "3" 
     AND i-tip-emis-nf-eletro <> 1       THEN
        RUN new-state ('habilita-bt-nfe-imp':U).
     ELSE
        RUN new-state ("desabilita-bt-nfe-imp":U).
  END.
  
  FIND FIRST param-global NO-LOCK NO-ERROR.
  IF AVAIL param-global AND param-global.modulo-07 /* Importa‡Æo */ THEN
      RUN new-state ('habilita-bt-docto-imp':U).
  ELSE
      RUN new-state ('desabilita-bt-docto-imp':U).

  IF  AVAIL docum-est
  AND (   docum-est.tipo-dfe-docto = rep.list.TipoDfeDoctoList:NFAg 
       OR docum-est.tipo-dfe-docto = rep.list.TipoDfeDoctoList:NFSeVia
       OR docum-est.tipo-dfe-docto = rep.list.TipoDfeDoctoList:NFGas
       OR docum-est.tipo-dfe-docto = rep.list.TipoDfeDoctoList:NFSeNacional
       OR docum-est.tipo-dfe-docto = rep.list.TipoDfeDoctoList:NFSeLocacao) THEN
      RUN new-state ('habilita-bt-Inf-DFe':U).
  ELSE 
      RUN new-state ('desabilita-bt-Inf-DFe':U).
      
  /* Code placed here will execute AFTER standard behavior.    */
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: Nï¿½o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaï¿½ï¿½es, pois neste ponto do programa o registro 
  ainda nï¿½o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Validaï¿½ï¿½o de dicionï¿½rio */
 
   /*Segue um exemplo de validaï¿½ï¿½o de programa 
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
  {src/adm/template/snd-list.i "docum-est"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-tt-inf-esocial V-table-Win 
PROCEDURE pi-recebe-tt-inf-esocial :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
    DEFINE OUTPUT PARAMETER TABLE FOR tt-inf-esocial-aquisicao.
 
    CREATE tt-inf-esocial-aquisicao.
    ASSIGN tt-inf-esocial-aquisicao.dt-trans      = docum-est.dt-trans
           tt-inf-esocial-aquisicao.tp-origem     = 1 /* Recebimento */
           tt-inf-esocial-aquisicao.cod-layout    = "1350"
           tt-inf-esocial-aquisicao.serie-docto   = docum-est.serie-docto
           tt-inf-esocial-aquisicao.nro-docto     = docum-est.nro-docto
           tt-inf-esocial-aquisicao.cod-emitente  = docum-est.cod-emitente
           tt-inf-esocial-aquisicao.nat-operacao  = docum-est.nat-operacao
           tt-inf-esocial-aquisicao.tp-aquis      = 1 /* Aquisi‡Æo da produ‡Æo de produtor rural pessoa f¡sica ou segurado especial em geral */
           tt-inf-esocial-aquisicao.vl-bruto      = docum-est.tot-valor
           tt-inf-esocial-aquisicao.l-campos-hab  = NO.

    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




