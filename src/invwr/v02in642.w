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
{include/i-prgvrs.i V02IN642 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN642 MUT}
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

{cdp/cdcfgmat.i}

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
&Scoped-define EXTERNAL-TABLES estat-cc-compr
&Scoped-define FIRST-EXTERNAL-TABLE estat-cc-compr


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estat-cc-compr.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS estat-cc-compr.qtd-req-inicial ~
estat-cc-compr.qtd-pec-emit estat-cc-compr.qtd-req-receb ~
estat-cc-compr.qtd-req-aprov estat-cc-compr.qtd-req-mesa ~
estat-cc-compr.qtd-it-cn-rec estat-cc-compr.qtd-cn-fech ~
estat-cc-compr.qtd-cn-abertos estat-cc-compr.vlr-tot-cn ~
estat-cc-compr.med-pec-dia estat-cc-compr.med-req-dia ~
estat-cc-compr.vlr-tot-pec estat-cc-compr.qtd-cmp-norm ~
estat-cc-compr.qtd-cmp-urg 
&Scoped-define DISPLAYED-TABLES estat-cc-compr
&Scoped-define FIRST-DISPLAYED-TABLE estat-cc-compr
&Scoped-Define DISPLAYED-OBJECTS qtd-oc-fechada-periodo qtd-oc-periodo ~
D-VLR-MED C-LABEL-2 C-LABEL 

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
DEFINE VARIABLE C-LABEL AS CHARACTER FORMAT "X(25)":U 
      VIEW-AS TEXT 
     SIZE 15 BY .67 NO-UNDO.

DEFINE VARIABLE C-LABEL-2 AS CHARACTER FORMAT "X(25)":U 
      VIEW-AS TEXT 
     SIZE 12.86 BY .67 NO-UNDO.

DEFINE VARIABLE D-VLR-MED AS DECIMAL FORMAT ">>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE qtd-oc-fechada-periodo AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "Qtd Compr Fech Periodo" 
     VIEW-AS FILL-IN 
     SIZE 15.43 BY .88 NO-UNDO.

DEFINE VARIABLE qtd-oc-periodo AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "Qtd Compras Periodo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 11.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     estat-cc-compr.qtd-req-inicial AT ROW 1.25 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     estat-cc-compr.qtd-pec-emit AT ROW 2.17 COL 67 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     estat-cc-compr.qtd-req-receb AT ROW 2.25 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     estat-cc-compr.qtd-req-aprov AT ROW 3.5 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     estat-cc-compr.qtd-req-mesa AT ROW 3.5 COL 67 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     estat-cc-compr.qtd-it-cn-rec AT ROW 4.75 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     estat-cc-compr.qtd-cn-fech AT ROW 5.75 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     estat-cc-compr.qtd-cn-abertos AT ROW 5.75 COL 67 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     estat-cc-compr.vlr-tot-cn AT ROW 6.75 COL 26 COLON-ALIGNED FORMAT ">>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     estat-cc-compr.med-pec-dia AT ROW 8 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     estat-cc-compr.med-req-dia AT ROW 8 COL 67 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     qtd-oc-fechada-periodo AT ROW 9.13 COL 67 COLON-ALIGNED
     estat-cc-compr.vlr-tot-pec AT ROW 9.17 COL 26 COLON-ALIGNED FORMAT ">>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     qtd-oc-periodo AT ROW 10.13 COL 67 COLON-ALIGNED
     D-VLR-MED AT ROW 10.17 COL 26 COLON-ALIGNED NO-LABEL
     estat-cc-compr.qtd-cmp-norm AT ROW 11.17 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     estat-cc-compr.qtd-cmp-urg AT ROW 11.17 COL 67 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     C-LABEL-2 AT ROW 3.67 COL 55.72 NO-LABEL
     C-LABEL AT ROW 10.29 COL 11.14 NO-LABEL
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.estat-cc-compr
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
         HEIGHT             = 11.25
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN C-LABEL IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN C-LABEL-2 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN D-VLR-MED IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estat-cc-compr.med-pec-dia IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estat-cc-compr.med-req-dia IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estat-cc-compr.qtd-cmp-norm IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estat-cc-compr.qtd-cmp-urg IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estat-cc-compr.qtd-cn-abertos IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estat-cc-compr.qtd-cn-fech IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estat-cc-compr.qtd-it-cn-rec IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN qtd-oc-fechada-periodo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN qtd-oc-periodo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estat-cc-compr.qtd-pec-emit IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estat-cc-compr.qtd-req-aprov IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estat-cc-compr.qtd-req-inicial IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estat-cc-compr.qtd-req-mesa IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estat-cc-compr.qtd-req-receb IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estat-cc-compr.vlr-tot-cn IN FRAME f-main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN estat-cc-compr.vlr-tot-pec IN FRAME f-main
   NO-ENABLE EXP-FORMAT                                                 */
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

  {utp/ut-liter.i Valor_M‚dio_PEC_R$_: * R}
   assign c-label:screen-value in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i Qtd_Req_na_Mesa_: * R}
   assign c-label-2:screen-value in frame {&FRAME-NAME} = return-value.

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
  {src/adm/template/row-list.i "estat-cc-compr"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "estat-cc-compr"}

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

  {utp/ut-liter.i Valor_M‚dio_PEC_R$ * R}
  assign c-label:screen-value in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i Qtd_Req_na_Mesa_: * R}
   assign c-label-2:screen-value in frame {&FRAME-NAME} = return-value.

  if avail estat-cc-compr
  then do:
      assign d-vlr-med = trunc(estat-cc-compr.vlr-tot-pec / estat-cc-compr.qtd-pec-emit,2).
      if  d-vlr-med = ? then
          assign d-vlr-med = 0.

      disp d-vlr-med
           with frame {&FRAME-NAME}.
  end.


  &if defined (bf_mat_versao_ems) &then
       if avail estat-cc-compr then 
       assign qtd-oc-periodo = estat-cc-compr.qtd-oc-periodo
              qtd-oc-fechada-periodo = estat-cc-compr.qt-oc-fechada-periodo.          

       disp qtd-oc-fechada-periodo 
            qtd-oc-periodo  with frame {&FRAME-NAME}.           
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
    if adm-new-record = yes then
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

  &if defined (bf_mat_versao_ems) &then
         qtd-oc-fechada-periodo:hidden    in frame {&frame-name} = no.
         qtd-oc-periodo:hidden  in frame {&frame-name} = no.
     &else
        qtd-oc-fechada-periodo:hidden      in frame {&frame-name} = yes.
        qtd-oc-periodo:hidden  in frame {&frame-name} = yes.
  &endif



  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "estat-cc-compr"}

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

