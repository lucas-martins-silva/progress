&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i V30IN295 2.00.00.005 } /*** 010005 ***/
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */
/*                                                                                */
/* OBS: Para os smartobjects o parametro m¢dulo dever  ser MUT                    */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v30in295 MCC}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/*&Scoped-define ADM-CREATE-FIELDS c-ordem-portal*/
&Scoped-define ADM-ASSIGN-FIELDS c-ordem-portal
/*&Scoped-define ADM-MODIFY-FIELDS c-ordem-portal*/


/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.
DEF VAR l-log-portal-paradigma AS LOG INITIAL NO NO-UNDO.

{cdp/cdcfgmat.i} /* Preprocessadores fun‡äes materiais                */

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
&Scoped-define EXTERNAL-TABLES pedido-compr
&Scoped-define FIRST-EXTERNAL-TABLE pedido-compr


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR pedido-compr.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-OBJECTS tb-enviado tb-integrada tb-congelada ~
c-ordem-portal tb-com-erro tb-recusado-fornec tb-resposta-fornec 

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
DEFINE VARIABLE c-ordem-portal AS CHARACTER FORMAT "X(256)":U 
     LABEL "Pedido no Portal de Compras" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84.86 BY 7.75.

DEFINE VARIABLE tb-com-erro AS LOGICAL INITIAL no 
     LABEL "Com Erro" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tb-congelada AS LOGICAL INITIAL no 
     LABEL "Congelado" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .83 NO-UNDO.

DEFINE VARIABLE tb-enviado AS LOGICAL INITIAL no 
     LABEL "Enviado" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tb-integrada AS LOGICAL INITIAL no 
     LABEL "Integrado com o Portal de Compras" 
     VIEW-AS TOGGLE-BOX
     SIZE 36.72 BY .83 NO-UNDO.

DEFINE VARIABLE tb-recusado-fornec AS LOGICAL INITIAL no 
     LABEL "Recusado pelo Fornecedor" 
     VIEW-AS TOGGLE-BOX
     SIZE 28.72 BY .83 NO-UNDO.

DEFINE VARIABLE tb-resposta-fornec AS LOGICAL INITIAL no 
     LABEL "Pendente de Resposta do Fornecedor" 
     VIEW-AS TOGGLE-BOX
     SIZE 36.72 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     tb-enviado AT ROW 1.46 COL 33.29 WIDGET-ID 2
     tb-integrada AT ROW 2.46 COL 33.29
     tb-congelada AT ROW 3.46 COL 33.29
     c-ordem-portal AT ROW 4.46 COL 31.29 COLON-ALIGNED
     tb-com-erro AT ROW 5.46 COL 33.29 WIDGET-ID 4
     tb-recusado-fornec AT ROW 6.46 COL 33.29 WIDGET-ID 6
     tb-resposta-fornec AT ROW 7.54 COL 33.29 WIDGET-ID 8
     rt-mold AT ROW 1 COL 1.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.pedido-compr
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
         HEIGHT             = 7.75
         WIDTH              = 85.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{include/i-auxtab.i}
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

/* SETTINGS FOR FILL-IN c-ordem-portal IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tb-com-erro IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tb-congelada IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tb-enviado IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tb-integrada IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tb-recusado-fornec IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tb-resposta-fornec IN FRAME f-main
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
  
    FIND FIRST param-compra NO-LOCK NO-ERROR.
    IF CAN-FIND(FIRST funcao NO-LOCK
                WHERE funcao.cd-funcao = "SPP-PORTAL-PARADIGMA":U
                  AND funcao.ativo) THEN DO:
        IF &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
               (AVAIL param-compra AND substring(param-compra.char-2,103, 1) = "S":U)
           &ELSE
               (AVAIL param-compra AND param.compra.log-portal-paradigma)
           &ENDIF
        THEN DO:
            ASSIGN l-log-portal-paradigma = YES.
        END.
    END.
  
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
  {src/adm/template/row-list.i "pedido-compr"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "pedido-compr"}

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
    
    /*:T Ponha na pi-validate todas as valida‡äes */
    /*:T NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /*:T Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
    DEFINE BUFFER bf-pedido-compr FOR pedido-compr.
  
    FIND FIRST bf-pedido-compr 
         WHERE bf-pedido-compr.num-pedido = pedido-compr.num-pedido EXCLUSIVE-LOCK NO-ERROR.
  
    IF AVAIL bf-pedido-compr THEN DO:
        &IF  "{&bf_mat_versao_ems}"  <  "2.09"  &THEN
            ASSIGN tb-integrada:SCREEN-VALUE     IN FRAME f-main = IF SUBSTRING(bf-pedido-compr.CHAR-1,1,1)  = "s":U THEN string(YES) ELSE STRING(NO)
                   tb-congelada:SCREEN-VALUE     IN FRAME f-main = IF SUBSTRING(bf-pedido-compr.CHAR-1,2,1)  = "s":U THEN STRING(YES) ELSE string(NO)
                   c-ordem-portal:SCREEN-VALUE   IN FRAME f-main = SUBSTRING(bf-pedido-compr.char-1,3,50)
                   tb-enviado:SCREEN-VALUE       IN FRAME f-main = IF SUBSTRING(bf-pedido-compr.char-1,55,1)   = "s":U THEN string(YES) ELSE STRING(NO)
                   tb-com-erro:SCREEN-VALUE      IN FRAME f-main = IF SUBSTRING(bf-pedido-compr.char-1,54,1)   = "s":U THEN string(YES) ELSE STRING(NO)
                   tb-recusado-fornec:SCREEN-VALUE IN FRAME f-main = IF SUBSTRING(bf-pedido-compr.char-1,56,1) = "s":U THEN string(YES) ELSE STRING(NO)
                   tb-resposta-fornec:SCREEN-VALUE IN FRAME f-main = IF SUBSTRING(bf-pedido-compr.char-1,57,1) = "s":U THEN string(YES) ELSE STRING(NO).
        &ELSE
            ASSIGN tb-integrada:SCREEN-VALUE     IN FRAME f-main = bf-pedido-compr.log-integr-portal
                   tb-congelada:SCREEN-VALUE     IN FRAME f-main = bf-pedido-compr.log-congela-ped
                   c-ordem-portal:SCREEN-VALUE   IN FRAME f-main = bf-pedido-compr.cod-ped-portal
                   tb-enviado:SCREEN-VALUE       IN FRAME f-main = bf-pedido-compr.log-envdo-integr
                   tb-com-erro:SCREEN-VALUE      IN FRAME f-main = bf-pedido-compr.log-erro-integr
                   tb-recusado-fornec:SCREEN-VALUE IN FRAME f-main = bf-pedido-compr.log-reprov-fornec
                   tb-resposta-fornec:SCREEN-VALUE IN FRAME f-main = bf-pedido-compr.log-pend-aceite-fornec .
        &ENDIF
    END.

    RELEASE bf-pedido-compr.

    RETURN "OK":U.

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


    IF l-log-portal-paradigma THEN DO:
        c-ordem-portal:HIDDEN   IN FRAME {&FRAME-NAME} = YES.
        tb-congelada:HIDDEN     IN FRAME {&FRAME-NAME} = YES.
        tb-enviado:HIDDEN       IN FRAME {&FRAME-NAME} = NO.
        tb-com-erro:HIDDEN      IN FRAME {&FRAME-NAME} = NO.
        tb-recusado-fornec:HIDDEN IN FRAME {&FRAME-NAME} = NO.
        tb-resposta-fornec:HIDDEN IN FRAME {&FRAME-NAME} = NO.
        tb-com-erro:ROW           IN FRAME {&FRAME-NAME} = 3.46.
        tb-recusado-fornec:ROW    IN FRAME {&FRAME-NAME} = 4.46.
        tb-resposta-fornec:ROW    IN FRAME {&FRAME-NAME} = 5.46.
    END.
    ELSE DO:
        c-ordem-portal:HIDDEN     IN FRAME {&FRAME-NAME} = NO.
        tb-congelada:HIDDEN       IN FRAME {&FRAME-NAME} = NO.
        tb-enviado:HIDDEN         IN FRAME {&FRAME-NAME} = YES.
        tb-com-erro:HIDDEN        IN FRAME {&FRAME-NAME} = YES.
        tb-recusado-fornec:HIDDEN IN FRAME {&FRAME-NAME} = YES.
        tb-resposta-fornec:HIDDEN IN FRAME {&FRAME-NAME} = YES.
    END.

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
/*:T------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /*:T Valida‡Æo de dicion rio */
    
/*:T    Segue um exemplo de valida‡Æo de programa */
/*       find tabela where tabela.campo1 = c-variavel and               */
/*                         tabela.campo2 > i-variavel no-lock no-error. */
      
      /*:T Este include deve ser colocado sempre antes do ut-msgs.p */
/*       {include/i-vldprg.i}                                             */
/*       run utp/ut-msgs.p (input "show":U, input 7, input return-value). */
/*       return 'ADM-ERROR':U.                                            */

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
  {src/adm/template/snd-list.i "pedido-compr"}

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

