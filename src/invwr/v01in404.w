&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          movind           PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/***************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
****************************************************************************/
{include/i-prgvrs.i V01IN404 2.00.00.026 } /*** "010026" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN404 MUT}
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


{cdp/cd4300.i3}  /*Variÿveis para o cd4300.i4 */
{cdp/cd0101.i50} /*Variÿveis para o re1001b.i51*/
def var c-label      as handle  no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES saldo-terc
&Scoped-define FIRST-EXTERNAL-TABLE saldo-terc


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR saldo-terc.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS saldo-terc.cod-emitente ~
saldo-terc.serie-docto saldo-terc.cod-refer saldo-terc.nro-docto ~
saldo-terc.nat-operacao saldo-terc.sequencia saldo-terc.it-codigo 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cod-emitente ~{&FP2}cod-emitente ~{&FP3}~
 ~{&FP1}serie-docto ~{&FP2}serie-docto ~{&FP3}~
 ~{&FP1}cod-refer ~{&FP2}cod-refer ~{&FP3}~
 ~{&FP1}nro-docto ~{&FP2}nro-docto ~{&FP3}~
 ~{&FP1}nat-operacao ~{&FP2}nat-operacao ~{&FP3}~
 ~{&FP1}sequencia ~{&FP2}sequencia ~{&FP3}~
 ~{&FP1}it-codigo ~{&FP2}it-codigo ~{&FP3}
&Scoped-define ENABLED-TABLES saldo-terc
&Scoped-define FIRST-ENABLED-TABLE saldo-terc
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS saldo-terc.cod-emitente ~
saldo-terc.serie-docto saldo-terc.cod-refer saldo-terc.nro-docto ~
saldo-terc.nr-ord-prod saldo-terc.nat-operacao saldo-terc.sequencia ~
saldo-terc.it-codigo 
&Scoped-Define DISPLAYED-OBJECTS c-desc-emitente c-cgc c-desc-natureza ~
c-desc-item 

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
DEFINE VARIABLE c-cgc AS CHARACTER FORMAT "x(19)" INITIAL ? 
     LABEL "CGC/CPF":R9 
     VIEW-AS FILL-IN 
     SIZE 20.14 BY .88.

DEFINE VARIABLE c-desc-emitente AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 51.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-natureza AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 24.57 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 5.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     saldo-terc.cod-emitente AT ROW 1.25 COL 16.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     c-desc-emitente AT ROW 1.25 COL 28.86 COLON-ALIGNED NO-LABEL
     c-cgc AT ROW 1.25 COL 65.29 COLON-ALIGNED HELP
          "CGC ou CIC do cliente/fornecedor"
     saldo-terc.serie-docto AT ROW 2.25 COL 16.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     saldo-terc.cod-refer AT ROW 2.25 COL 65.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     saldo-terc.nro-docto AT ROW 3.25 COL 16.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     saldo-terc.nr-ord-prod AT ROW 3.25 COL 65.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.72 BY .88
     saldo-terc.nat-operacao AT ROW 4.25 COL 16.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
     c-desc-natureza AT ROW 4.25 COL 27.14 COLON-ALIGNED NO-LABEL
     saldo-terc.sequencia AT ROW 4.25 COL 65.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     saldo-terc.it-codigo AT ROW 5.25 COL 16.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc-item AT ROW 5.25 COL 33.86 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.saldo-terc
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
         HEIGHT             = 5.5
         WIDTH              = 88.14.
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

/* SETTINGS FOR FILL-IN c-cgc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-emitente IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-natureza IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN saldo-terc.nr-ord-prod IN FRAME f-main
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
  {src/adm/template/row-list.i "saldo-terc"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "saldo-terc"}

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    find emitente where
        emitente.cod-emitente = saldo-terc.cod-emitente
        no-lock no-error.
    if available emitente then 
        display emitente.nome-abrev @ c-desc-emitente 
                emitente.cgc        @ c-cgc with frame {&frame-name}.
    
    find natur-oper where
        natur-oper.nat-operacao = saldo-terc.nat-operacao
        no-lock no-error.
    if available natur-oper then
        display natur-oper.denominacao @ c-desc-natureza with frame {&frame-name}.
        
    find item where
        item.it-codigo = saldo-terc.it-codigo
        no-lock no-error.
    if available item then 
        display item.desc-item @ c-desc-item with frame {&frame-name}.
                        

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

  find first param-global no-lock no-error.
   assign c-cgc:format in frame {&frame-name} = param-global.formato-id-federal. 
  
  find first param-estoq no-lock no-error.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */

  /*Quando tem valor na param-estoq deve ser considerado o que est  nesse campo e nÆo na param-global*/
  IF SUBSTRING(param-estoq.char-2,68,1) <> "":U THEN
      ASSIGN l-ut-ser = (SUBSTRING(param-estoq.char-2,68,1) = "S":U).
  ELSE DO:
      {cdp/cd4300.i4  "yes" param-global.char-2}             
      {cdp/cd0101.i51 "yes"}
  END.

  do with frame {&FRAME-NAME}:
    if not l-ut-ser  /*nÆo utiliza serie*/
    and i-pais-impto-usuario <> 1 /*brasil*/ then 
        assign saldo-terc.nat-operacao:row = saldo-terc.nro-docto:row 
               c-desc-natureza:row         = saldo-terc.nro-docto:row 
               c-label          = saldo-terc.nat-operacao:SIDE-LABEL-HANDLE  /*pega o handle do label*/
               c-label:row      = saldo-terc.nro-docto:row  /*move o label para a mesma linha do fill-in*/
               saldo-terc.nro-docto:row = saldo-terc.serie-docto:row 
               c-label          = saldo-terc.nro-docto:SIDE-LABEL-HANDLE  /*pega o handle do label*/
               c-label:row      = saldo-terc.serie-docto:row  /*move o label para a mesma linha do fill-in*/  
               saldo-terc.serie-docto:visible  = no. /*esconde a s‚rie*/
  end.

  {utp/ut-liter.i CGC/CPF MRE}
  assign c-cgc:label in frame {&FRAME-NAME} = trim(return-value).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera-valores V-table-Win 
PROCEDURE pi-altera-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param r-registro as rowid.

    def var i-ordem like ord-prod.nr-ord-produ.
    assign  i-ordem = input frame {&frame-name} saldo-terc.nr-ord-prod.
       
    run rep/re0408a.w (input-output i-ordem,
                       input r-registro).
                   
    assign saldo-terc.nr-ord-prod:screen-value in frame {&frame-name} = string(i-ordem).

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
  {src/adm/template/snd-list.i "saldo-terc"}

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


