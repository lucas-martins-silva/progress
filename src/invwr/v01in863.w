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
{include/i-prgvrs.i V01IN863 2.00.00.001} /*** "010001" 25/09/2023 10:11:47 ***/
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/* Chamada a include do gerenciador de licenªas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <mΩdulo>:  Informar qual o mΩdulo a qual o programa pertence.                  */
/*                                                                                */
/* OBS: Para os smartobjects o parametro mΩdulo deverˇ ser MUT                    */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i V01IN863 MCD}
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
def var v-row-parent as rowid  no-undo.
DEF VAR v_hdl_cenar  AS HANDLE NO-UNDO.
DEF VAR hShowMsg     AS HANDLE NO-UNDO.
DEF VAR hProgramZoom AS HANDLE NO-UNDO.
DEF VAR l-conectou-ems5 AS LOG NO-UNDO.
DEF VAR c-lb-msg   AS CHARACTER NO-UNDO.
DEF VAR l-erro     AS LOGICAL NO-UNDO.
/*Temp-table EMS5 - Retorna cen†rios cont†beis v†lidos*/
def temp-table tt_cenar_ctbl_ems5 no-undo
         field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
         field tta_des_cenar_ctbl               as character format "x(40)" label "Descriá∆o" column-label "Descriá∆o"
         field tta_log_cenar_ifrs               as logical format "Sim/N∆o" initial no label "Cen†rio IFRS" column-label "Cen†rio IFRS"
         field tta_log_cenar_fisc               as logical format "Sim/N∆o" initial no label "Cen†rio Fiscal" column-label "Cen†rio Fiscal"
         field ttv_log_permis_cenar_usuar       as logical format "Sim/N∆o" initial no
        .
def temp-table tt_erro_fgl no-undo
         field ttv_num_erro_fgl                 as integer format "9999999"
         field ttv_des_erro_fgl                 as character format "x(100)"
         field ttv_des_arq_erro                 as character format "x(100)"
         field ttv_log_ctbz                     as logical format "Sim/N∆o" initial yes label "Contabiliza Movto" column-label "Contabiliza Movto"
            .
{inbo/boin863.i tt-estab-mater-cenar}
{cdp/cd9043.i} /* Definiá∆o da tabela de erros RowErros */
{btb/btb009za.i}
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
&Scoped-define EXTERNAL-TABLES estab-mater-cenar
&Scoped-define FIRST-EXTERNAL-TABLE estab-mater-cenar


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estab-mater-cenar.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS estab-mater-cenar.cod-cenar-ctbl 
&Scoped-define ENABLED-TABLES estab-mater-cenar
&Scoped-define FIRST-ENABLED-TABLE estab-mater-cenar
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS estab-mater-cenar.cod-estab ~
estab-mater-cenar.cod-cenar-ctbl estab-mater-cenar.contab-ate 
&Scoped-define DISPLAYED-TABLES estab-mater-cenar
&Scoped-define FIRST-DISPLAYED-TABLE estab-mater-cenar
&Scoped-Define DISPLAYED-OBJECTS c-desc-estabel c-desc-cenar tg-cenar-fisc ~
tg-cenar-ifrs 

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
DEFINE VARIABLE c-desc-cenar AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 36.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estabel AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 2.67.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 4.13.

DEFINE VARIABLE tg-cenar-fisc AS LOGICAL INITIAL no 
     LABEL "Cen†rio Fiscal" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.

DEFINE VARIABLE tg-cenar-ifrs AS LOGICAL INITIAL no 
     LABEL "Cen†rio IFRS" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     estab-mater-cenar.cod-estab AT ROW 1.5 COL 22.86 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     c-desc-estabel AT ROW 1.5 COL 32.29 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     estab-mater-cenar.cod-cenar-ctbl AT ROW 2.5 COL 23 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     c-desc-cenar AT ROW 2.5 COL 35.29 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     tg-cenar-fisc AT ROW 4.46 COL 25 WIDGET-ID 16
     tg-cenar-ifrs AT ROW 5.46 COL 25 WIDGET-ID 18
     estab-mater-cenar.contab-ate AT ROW 6.46 COL 23 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     rt-key AT ROW 1.08 COL 1.57
     rt-mold AT ROW 3.88 COL 1.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.estab-mater-cenar
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
         HEIGHT             = 7.04
         WIDTH              = 78.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}
{include/i_dbtype.i}

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

/* SETTINGS FOR FILL-IN c-desc-cenar IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estab-mater-cenar.cod-estab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estab-mater-cenar.contab-ate IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-cenar-fisc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-cenar-ifrs IN FRAME f-main
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

if estab-mater-cenar.cod-cenar-ctbl:load-mouse-pointer('image\lupa.cur') in frame {&frame-name} then.
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
  {src/adm/template/row-list.i "estab-mater-cenar"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "estab-mater-cenar"}

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
    
    /*:T Ponha na pi-validate todas as validaªÑes */
    /*:T Nío gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    RUN Pi-validate.
    ASSIGN tg-cenar-fisc = tg-cenar-fisc:CHECKED IN FRAME {&FRAME-NAME}
           tg-cenar-ifrs = tg-cenar-ifrs:CHECKED IN FRAME {&FRAME-NAME}.
  /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /*:T Todos os assignãs nío feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */
     ASSIGN estab-mater-cenar.log-cenar-fisc = tg-cenar-fisc:CHECKED IN FRAME {&FRAME-NAME}
            estab-mater-cenar.log-cenar-ifrs = tg-cenar-ifrs:CHECKED IN FRAME {&FRAME-NAME}
            INPUT FRAME {&FRAME-NAME} estab-mater-cenar.contab-ate
            INPUT FRAME {&FRAME-NAME} estab-mater-cenar.cod-cenar-ctbl
            INPUT FRAME {&FRAME-NAME} estab-mater-cenar.cod-estab.
     RUN pi-replica-estab-mater-cenar.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .
 
   find estab-mat where ROWID(estab-mat) = v-row-parent no-lock no-error.
   if available estab-mat then do:
        assign estab-mater-cenar.cod-estab = estab-mat.cod-estabel.
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
    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST param-estoq NO-LOCK NO-ERROR.

    Run  pi-conecta-ems50( 1). /*Conecta bancos EMS5*/
    IF RETURN-VALUE = "NOK" THEN
        RETURN "adm-error":U.
    ELSE DO:
        run prgfin/fgl/fgl920za.py persistent set v_hdl_cenar.

        run  pi_main_retorna_cenar_ctbl_empres_1 in v_hdl_cenar(input i-ep-codigo-usuario,
                                                            input today,
                                                            output table tt_cenar_ctbl_ems5,
                                                            output table tt_erro_fgl).
        delete procedure v_hdl_cenar.
        assign v_hdl_cenar = ?.
    END.
    IF l-conectou-ems5 THEN
        Run  pi-conecta-ems50( 2). /*Desconecta bancos EMS5*/

     RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
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

   RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
   RUN pi-atualiza-campos.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   

   RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
   
   RUN pi-atualiza-campos.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-campos V-table-Win 
PROCEDURE pi-atualiza-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def buffer b-estab-mat for estab-mat.
   FIND FIRST param-estoq NO-LOCK NO-ERROR.

   find FIRST b-estab-mat where rowid(b-estab-mat) = v-row-parent no-lock no-error.
   if avail b-estab-mat THEN DO:
      assign estab-mater-cenar.cod-estab:screen-value in frame {&frame-name} = b-estab-mat.cod-estabel.
      IF AVAIL param-estoq THEN
         IF param-estoq.tp-fech = 2 THEN
            ASSIGN estab-mater-cenar.contab-ate:screen-value in frame {&frame-name} = string(b-estab-mat.contab-ate).
         ELSE
            ASSIGN estab-mater-cenar.contab-ate:screen-value in frame {&frame-name} = string(param-estoq.contab-ate).
   END.
   else
      assign estab-mater-cenar.cod-estab:screen-value in frame {&frame-name} = "".

   FIND FIRST estabelec 
        WHERE estabelec.cod-estabel = estab-mater-cenar.cod-estab:screen-value in frame {&frame-name} NO-LOCK NO-ERROR.
   IF AVAIL estabelec THEN
       ASSIGN c-desc-estabel:screen-value in frame {&frame-name} = estabelec.nome.

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
  Notes: Nío fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaªÑes, pois neste ponto do programa o registro 
  ainda nío foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /*:T Validaªío de dicionˇrio */
    
/*:T    Segue um exemplo de validaªío de programa */
/*       find tabela where tabela.campo1 = c-variavel and               */
/*                         tabela.campo2 > i-variavel no-lock no-error. */
      
      /*:T Este include deve ser colocado sempre antes do ut-msgs.p */
/*       {include/i-vldprg.i}                                             */
/*       run utp/ut-msgs.p (input "show":U, input 7, input return-value). */
/*       return 'ADM-ERROR':U.                                            */
    
    IF NOT CAN-FIND(FIRST tt_cenar_ctbl_ems5 
                    WHERE tt_cenar_ctbl_ems5.tta_cod_cenar_ctbl = estab-mater-cenar.cod-cenar-ctbl:SCREEN-VALUE IN FRAME {&FRAME-NAME}) THEN DO:
      {include/i-vldprg.i}         
      {utp/ut-liter.i Cen†rio_Cont†bil}
      run utp/ut-msgs.p (input "show":U, input 2, input return-value).
      return 'ADM-ERROR':U.

    END.

    FIND FIRST param-estoq NO-LOCK NO-ERROR.

    /* valida duplicidade de cenario apenas se a moeda funcional nao estiver implantada */
    IF  SUBSTRING(param-estoq.char-2,100,1) <> "S":U THEN DO:
        IF CAN-FIND (FIRST estab-mater-cenar 
                     WHERE estab-mater-cenar.cod-estab = estab-mater-cenar.cod-estab:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                       AND estab-mater-cenar.cod-cenar-ctbl = estab-mater-cenar.cod-cenar-ctbl:SCREEN-VALUE IN FRAME {&FRAME-NAME}) THEN DO:
          {include/i-vldprg.i}         
          {utp/ut-table.i mgind estab-mater-cenar 1}
          run utp/ut-msgs.p (input "show":U, input 1, input return-value).
          return 'ADM-ERROR':U.
        END.
    END.
    
    IF (estab-mater-cenar.cod-cenar-ctbl:SCREEN-VALUE IN FRAME f-main = param-estoq.cod-cenar-geren)
    THEN DO:
        run utp/ut-msgs.p (input "show":U, 
                              input 57731, 
                              INPUT c-lb-msg + "~~" + RETURN-VALUE).
        ASSIGN l-erro = YES.
        return "adm-error".
    END.

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
  {src/adm/template/snd-list.i "estab-mater-cenar"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-replica-estab-mater-cenar V-table-Win 
Procedure pi-replica-estab-mater-cenar:
    DEFINE VARIABLE h-boin863 AS HANDLE NO-UNDO.
    DEFINE VARIABLE c-lb-mensagem AS CHARACTER   NO-UNDO.
    if  not valid-handle (h-boin863) then
        run inbo/boin863.p persistent set h-boin863.

    IF AVAIL param-estoq AND param-estoq.tp-fech = 2 THEN DO:
        {utp/ut-liter.i "Replica cen†rio para estabelecimentos."}
            ASSIGN c-lb-mensagem = RETURN-VALUE.
        {utp/ut-liter.i "Deseja replicar o cen†rio para todos os estabelecimentos?"}
        run utp/ut-msgs.p (input "show":U, input 27100, input c-lb-mensagem + "~~" + RETURN-VALUE).
    END.
    IF RETURN-VALUE <> "NO" OR (AVAIL param-estoq AND param-estoq.tp-fech <> 2) THEN DO:
        FOR EACH estab-mat NO-LOCK:
            EMPTY TEMP-TABLE tt-estab-mater-cenar NO-ERROR.
            CREATE tt-estab-mater-cenar.
            ASSIGN tt-estab-mater-cenar.cod-estab = estab-mat.cod-estabel
                   tt-estab-mater-cenar.contab-ate = estab-mat.contab-ate.
            BUFFER-COPY estab-mater-cenar EXCEPT cod-estab contab-ate TO tt-estab-mater-cenar NO-ERROR.

            RUN openQueryStatic IN h-boin863 (INPUT "Main":U).
            RUN goToKey         IN h-boin863 (INPUT tt-estab-mater-cenar.cod-estab, 
                                              INPUT tt-estab-mater-cenar.cod-cenar-ctbl).
            IF RETURN-VALUE = "NOK" THEN DO:
                run emptyRowErrors in h-boin863.
                run setRecord in h-boin863 (input table tt-estab-mater-cenar).
                		
                run createRecord in h-boin863.
                if  return-value = "NOK" then
                	run getRowErrors in h-boin863 (output table RowErrors append).
                IF CAN-FIND(FIRST RowErrors) THEN DO:
                    {method/showmessage.i1}
                    {method/showmessage.i2 &modal="YES"}
                    {method/showmessage.i3}
                    RUN destroy IN h-boin863.
                    UNDO, RETURN "ADM-ERROR":U.
                END.
            END.
        END.
    END.
    if  valid-handle (h-boin863) then do:
        delete procedure h-boin863.
        assign h-boin863 = ?.
    end.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-conecta-ems50 V-table-Win 
Procedure Pi-conecta-ems50:
    def input param i-conect as integer no-undo.
    DEF VAR h-btb009za AS HANDLE NO-UNDO.
    FIND FIRST param-global NO-LOCK NO-ERROR.
    
    if not valid-handle (h-btb009za) or
       h-btb009za:TYPE <> "PROCEDURE":U or
       h-btb009za:FILE-NAME <> "btb/btb009za.p":U  then
       RUN btb/btb009za.p PERSISTENT SET h-btb009za.
    
    if i-conect = 1 then do:
       if not connected("emsbas") or 
          not connected("emsuni") or 
          not connected("emsfin") then do:          
         
            if  valid-handle (h-btb009za) AND
               h-btb009za:TYPE = "PROCEDURE":U AND
               h-btb009za:FILE-NAME = "btb/btb009za.p":U then do:
               ASSIGN l-conectou-ems5 = YES.
               run pi-conecta-bco IN h-btb009za (Input 1,                         /*contem a vers„o de integraå„o da Api*/
                                                 Input i-conect,                  /*contem a opå„o desejada (1-Conex„o, 2-Desconex„o)*/
                                                 Input param-global.empresa-prin, /*contem o c©digo da empresa*/
                                                 Input "all",                     /*contem o c©digo do banco externo*/ 
                                                 Output Table tt_erros_conexao).  /*retorna erros caso existam*/
            end.
        end.
    end.
    else do:
       if connected("emsbas") or 
          connected("emsfin") or 
          connected("emsuni") then do:
          
           if  valid-handle (h-btb009za) AND
              h-btb009za:TYPE = "PROCEDURE":U AND
              h-btb009za:FILE-NAME = "btb/btb009za.p":U then do:
              ASSIGN l-conectou-ems5 = NO.
              run pi-conecta-bco IN h-btb009za (Input 1,                         /*contem a vers„o de integraå„o da Api*/
                                                Input i-conect,                  /*contem a opå„o desejada (1-Conex„o, 2-Desconex„o)*/
                                                Input param-global.empresa-prin, /*contem o c©digo da empresa*/
                                                Input "all",                     /*contem o c©digo do banco externo*/ 
                                                Output Table tt_erros_conexao).  /*retorna erros caso existam*/
           end.
       end.    
    end.
    
    if valid-handle(h-btb009za) then do:
        delete procedure h-btb009za no-error.
        assign h-btb009za = ?.
    end.
    if return-value <> "OK":U then do:
        FIND FIRST tt_erros_conexao NO-ERROR.
        IF AVAIL tt_erros_conexao THEN DO:
            run utp/ut-msgs.p (input "show":U, 
                               input tt_erros_conexao.cd-erro, 
                               INPUT tt_erros_conexao.param-1).

            /*assign l-erro = yes.*/
            undo, return "NOK":U.
        END.
    end.    
    RETURN "OK":U.

End Procedure. /*Pi-conecta-ems50*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME estab-mater-cenar.cod-cenar-ctbl
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mater-cenar.cod-cenar-ctbl V-table-Win 
ON LEAVE OF estab-mater-cenar.cod-cenar-ctbl IN FRAME f-main 
DO:
    FIND FIRST tt_cenar_ctbl_ems5 
         WHERE tt_cenar_ctbl_ems5.tta_cod_cenar_ctbl = estab-mater-cenar.cod-cenar-ctbl:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-ERROR.
    IF AVAIL tt_cenar_ctbl_ems5 THEN
        ASSIGN c-desc-cenar:SCREEN-VALUE IN FRAME {&FRAME-NAME} = tt_cenar_ctbl_ems5.tta_des_cenar_ctbl
               tg-cenar-fisc:CHECKED IN FRAME {&FRAME-NAME} = tt_cenar_ctbl_ems5.tta_log_cenar_fisc
               tg-cenar-ifrs:CHECKED IN FRAME {&FRAME-NAME} = tt_cenar_ctbl_ems5.tta_log_cenar_ifrs.
    ELSE
        ASSIGN c-desc-cenar:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               tg-cenar-fisc:CHECKED IN FRAME {&FRAME-NAME} = NO
               tg-cenar-ifrs:CHECKED IN FRAME {&FRAME-NAME} = NO.
               
    IF param-estoq.cod-cenar-geren <> "" THEN DO:
      IF (estab-mater-cenar.cod-cenar-ctbl:SCREEN-VALUE IN FRAME f-main = param-estoq.cod-cenar-geren)
      THEN DO:
          run utp/ut-msgs.p (input "show":U, 
                                input 57745, 
                                INPUT c-lb-msg + "~~" + RETURN-VALUE).
          ASSIGN l-erro = YES.
          return "adm-error".
      END.
    END.   
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mater-cenar.cod-cenar-ctbl V-table-Win
ON F5 OF estab-mater-cenar.cod-cenar-ctbl IN FRAME f-main /* C¢digo Cen†rio IFRS MA1 */
DO:
      
  {method/ZoomFields.i 
          &ProgramZoom="inzoom/z01in863.w"
          &FieldZoom1="cod-cenar-ctbl"
          &FieldScreen1="estab-mater-cenar.cod-cenar-ctbl"
          &Frame1="f-main"
          &FieldZoom2="des_cenar_ctbl"
          &FieldScreen2="c-desc-cenar"
          &Frame2="f-main"
          &EnableImplant="NO"}

      APPLY "leave":U TO estab-mater-cenar.cod-cenar-ctbl IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mater-cenar.cod-cenar-ctbl V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estab-mater-cenar.cod-cenar-ctbl IN FRAME f-main /* C¢digo Cen†rio IFRS MA1 */
DO:
  APPLY "F5" TO estab-mater-cenar.cod-cenar-ctbl IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
