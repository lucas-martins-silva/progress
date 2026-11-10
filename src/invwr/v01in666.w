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
{include/i-prgvrs.i V01IN666 2.00.00.007}  /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN666 MUT}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

{cdp/cdcfgmat.i}

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.
&if '{&bf_mat_versao_ems}' >= '2.062' &then
    def var l-habilita as log no-undo.
&endif

    def var h_v02in666 as handle no-undo.

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
&Scoped-define EXTERNAL-TABLES param-aprov
&Scoped-define FIRST-EXTERNAL-TABLE param-aprov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-aprov.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-aprov.aprova-solic ~
param-aprov.aprova-requis param-aprov.aprova-cotac ~
param-aprov.aprova-pedido param-aprov.aprova-emerg param-aprov.aprova-proc ~
param-aprov.aprova-cont param-aprov.aprova-manut 
&Scoped-define ENABLED-TABLES param-aprov
&Scoped-define FIRST-ENABLED-TABLE param-aprov
&Scoped-Define ENABLED-OBJECTS rt-mold-9 rt-mold-10 rt-mold rt-mold-2 ~
rt-mold-3 rt-mold-4 rt-mold-5 rt-mold-6 rt-mold-7 rt-mold-8 tg-aprovacao 
&Scoped-Define DISPLAYED-FIELDS param-aprov.aprova-solic ~
param-aprov.aprova-requis param-aprov.aprova-cotac ~
param-aprov.aprova-pedido param-aprov.aprova-emerg param-aprov.aprova-proc ~
param-aprov.aprova-cont param-aprov.aprova-manut 
&Scoped-define DISPLAYED-TABLES param-aprov
&Scoped-define FIRST-DISPLAYED-TABLE param-aprov
&Scoped-Define DISPLAYED-OBJECTS tg-aprovacao 

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
DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 29.14 BY 1.25.

DEFINE RECTANGLE rt-mold-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 29.14 BY 1.25.

DEFINE RECTANGLE rt-mold-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 29.14 BY 1.25.

DEFINE RECTANGLE rt-mold-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 29.14 BY 1.25.

DEFINE RECTANGLE rt-mold-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 29.14 BY 1.25.

DEFINE RECTANGLE rt-mold-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 29.14 BY 1.25.

DEFINE RECTANGLE rt-mold-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 29.14 BY 1.25.

DEFINE RECTANGLE rt-mold-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 29.14 BY 1.25.

DEFINE RECTANGLE rt-mold-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 29.14 BY 1.25.

DEFINE RECTANGLE rt-mold-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 81.86 BY 11.88.

DEFINE VARIABLE tg-aprovacao AS LOGICAL INITIAL no 
     LABEL "Aprova‡Æo Eletr“nica" 
     VIEW-AS TOGGLE-BOX
     SIZE 25.14 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     tg-aprovacao AT ROW 1.75 COL 5
     param-aprov.aprova-solic AT ROW 1.75 COL 41.14
          VIEW-AS TOGGLE-BOX
          SIZE 21.43 BY .83
     param-aprov.aprova-requis AT ROW 3.13 COL 41.14
          VIEW-AS TOGGLE-BOX
          SIZE 22.14 BY .83
     param-aprov.aprova-cotac AT ROW 4.5 COL 41.14
          VIEW-AS TOGGLE-BOX
          SIZE 15.57 BY .83
     param-aprov.aprova-pedido AT ROW 5.88 COL 41.14
          VIEW-AS TOGGLE-BOX
          SIZE 17.72 BY .83
     param-aprov.aprova-emerg AT ROW 7.25 COL 41.14
          VIEW-AS TOGGLE-BOX
          SIZE 22.14 BY .83
     param-aprov.aprova-proc AT ROW 8.63 COL 41.14
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .83
     param-aprov.aprova-cont AT ROW 10 COL 41.14
          VIEW-AS TOGGLE-BOX
          SIZE 20.72 BY .83
     param-aprov.aprova-manut AT ROW 11.38 COL 41.14
          VIEW-AS TOGGLE-BOX
          SIZE 21.29 BY .83
     rt-mold-9 AT ROW 1 COL 1
     rt-mold-10 AT ROW 1.5 COL 3.29
     rt-mold AT ROW 1.5 COL 39.86
     rt-mold-2 AT ROW 2.88 COL 39.86
     rt-mold-3 AT ROW 4.25 COL 39.86
     rt-mold-4 AT ROW 5.63 COL 39.86
     rt-mold-5 AT ROW 7 COL 39.86
     rt-mold-6 AT ROW 8.38 COL 39.86
     rt-mold-7 AT ROW 9.75 COL 39.86
     rt-mold-8 AT ROW 11.13 COL 39.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-aprov
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
         HEIGHT             = 11.88
         WIDTH              = 81.86.
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

&Scoped-define SELF-NAME param-aprov.aprova-cont
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-aprov.aprova-cont V-table-Win
ON VALUE-CHANGED OF param-aprov.aprova-cont IN FRAME f-main /* Controle Contratos */
DO:

    run pi-habilita-total.
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-aprov.aprova-emerg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-aprov.aprova-emerg V-table-Win
ON VALUE-CHANGED OF param-aprov.aprova-emerg IN FRAME f-main /* Pedido Emergencial */
DO:

    run pi-habilita-total.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-aprov.aprova-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-aprov.aprova-pedido V-table-Win
ON VALUE-CHANGED OF param-aprov.aprova-pedido IN FRAME f-main /* Pedido Compra */
DO:

    run pi-habilita-total.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-aprov.aprova-proc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-aprov.aprova-proc V-table-Win
ON VALUE-CHANGED OF param-aprov.aprova-proc IN FRAME f-main /* Processo Compra */
DO:

    run pi-habilita-total.
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-aprov.aprova-requis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-aprov.aprova-requis V-table-Win
ON VALUE-CHANGED OF param-aprov.aprova-requis IN FRAME f-main /* Requisi‡Æo Estoque */
DO:

    run pi-habilita-total.
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-aprov.aprova-solic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-aprov.aprova-solic V-table-Win
ON VALUE-CHANGED OF param-aprov.aprova-solic IN FRAME f-main /* Solicita‡Æo Compra */
DO:
  
    run pi-habilita-total.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-aprovacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-aprovacao V-table-Win
ON VALUE-CHANGED OF tg-aprovacao IN FRAME f-main /* Aprova‡Æo Eletr“nica */
DO:

do  with frame {&frame-name}:
    assign input tg-aprovacao
           param-aprov.aprova-solic:sensitive  = tg-aprovacao
           param-aprov.aprova-requis:sensitive = tg-aprovacao
           param-aprov.aprova-pedido:sensitive = tg-aprovacao
           param-aprov.aprova-emerg:sensitive  = tg-aprovacao
           param-aprov.aprova-proc:sensitive   = tg-aprovacao
           param-aprov.aprova-cont:sensitive   = tg-aprovacao
           param-aprov.aprova-manut:sensitive  = tg-aprovacao.

    &if '{&bf_mat_versao_ems}' < '2.062' &then
        assign param-aprov.aprova-cotac:sensitive  = tg-aprovacao.
    &else
        if not tg-aprovacao then
            assign param-aprov.aprova-cotac:sensitive  = tg-aprovacao.
        else
            assign param-aprov.aprova-cotac:sensitive  = l-habilita.
    &endif

    
    if  not tg-aprovacao then do:
        assign  param-aprov.aprova-solic:checked  = tg-aprovacao
                param-aprov.aprova-requis:checked = tg-aprovacao
                /*&if '{&bf_mat_versao_ems}' < '2.062' &then*/
                    param-aprov.aprova-cotac:checked  = tg-aprovacao
                /*&else
                    param-aprov.aprova-cotac:checked  = l-habilita
                &endif*/
                param-aprov.aprova-pedido:checked = tg-aprovacao
                param-aprov.aprova-emerg:checked  = tg-aprovacao
                param-aprov.aprova-proc:checked   = tg-aprovacao
                param-aprov.aprova-cont:checked   = tg-aprovacao
                param-aprov.aprova-manut:checked  = tg-aprovacao.
        if valid-handle(h_v02in666) then           
        run pi-habilita-total in h_v02in666
                (tg-aprovacao, tg-aprovacao,
                 tg-aprovacao, tg-aprovacao,
                 tg-aprovacao).
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

{utp/ut-liter.i Aprova‡Æo_Eletr“nica}
assign tg-aprovacao:label in frame {&frame-name} = trim(return-value).

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
  {src/adm/template/row-list.i "param-aprov"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-aprov"}

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
    

    find first param-compra exclusive-lock no-error.
    if  not avail param-compra then 
        create param-compra.
        
    if  available param-compra then do:
        assign param-compra.log-1 = input frame {&frame-name} tg-aprovacao.
        if param-aprov.aprova-cotac  then assign param-compra.int-1 = 1.
        if (param-aprov.aprova-emerg or param-aprov.aprova-pedido) then assign param-compra.int-1 = 2.
        if  param-aprov.aprova-cotac and
           (param-aprov.aprova-emerg or param-aprov.aprova-pedido) 
        then assign param-compra.int-1 = 3.
        
        &if defined(bf_mat_aprova_eletronica) &then            
            if param-aprov.aprova-emerg  then param-aprov.aprova-emerg = yes.
                                         else param-aprov.aprova-emerg = no.
        &else
            if param-aprov.aprova-emerg  then assign substring(param-compra.char-1,101,1) = "Y":U.
                                         else assign substring(param-compra.char-1,101,1) = "N":U.
        &endif 
        
        if param-aprov.aprova-proc   then assign substring(param-compra.char-2,21,1)  = "S":U.
                                     else assign substring(param-compra.char-2,21,1)  = "N":U.  
    end.
    release param-compra.

    find first param-estoq exclusive-lock no-error.
    if available param-estoq then do:
        if param-aprov.aprova-requis then assign substring(param-estoq.char-1,4,1) = "Y":U.
                                     else assign substring(param-estoq.char-1,4,1) = "N":U.
    end.
    release param-estoq.

    find first param-mi exclusive-lock no-error.
    if available param-mi then do:
        assign param-mi.aprov-solic = param-aprov.aprova-manut.
    end.
    release param-mi.
    
    find first param-contrat exclusive-lock no-error.
    if available param-contrat then do:
        assign param-contrat.log-1 = param-aprov.aprova-cont.
    end.
    release param-contrat.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  

  
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
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

    if available param-aprov then
        run pi-habilita-total.

    find first param-compra no-lock no-error.
    if  avail param-compra then
        assign tg-aprovacao:checked in frame {&frame-name} = param-compra.log-1.
    else
        assign tg-aprovacao:checked in frame {&frame-name} = no.
    apply 'value-changed' to tg-aprovacao in frame {&frame-name}.

    &if '{&bf_mat_versao_ems}' >= '2.062' &then
        find first param-global no-lock no-error.
        if avail param-global then
            if substring(param-global.char-2,29,1) = "1" then do:
                assign l-habilita = yes.
                if tg-aprovacao then
                    assign param-aprov.aprova-cotac:sensitive in frame {&frame-name} = yes.
                else
                    assign param-aprov.aprova-cotac:sensitive in frame {&frame-name} = no.
            end.
            else
                assign param-aprov.aprova-cotac:sensitive in frame {&frame-name} = no
                       l-habilita                                                = no.
    &endif
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-total V-table-Win 
PROCEDURE pi-habilita-total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    run pi-habilita-total in h_v02in666
        (param-aprov.aprova-solic:checked  in frame {&frame-name},
         param-aprov.aprova-requis:checked in frame {&frame-name},
         (param-aprov.aprova-pedido:checked in frame {&frame-name} or
         param-aprov.aprova-emerg:checked in frame {&frame-name}),
         param-aprov.aprova-proc:checked   in frame {&frame-name},
         param-aprov.aprova-cont:checked   in frame {&frame-name}).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-handle V-table-Win 
PROCEDURE pi-passa-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter p-handle as handle no-undo.
    assign h_v02in666 = p-handle.

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
  {src/adm/template/snd-list.i "param-aprov"}

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

