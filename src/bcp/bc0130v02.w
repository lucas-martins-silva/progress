&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcld            PROGRESS
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
{include/i-prgvrs.i BC0130V02 2.00.00.001}  /*** 010001 ***/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* Parameters Definitions ---                                           */

/* Global Variable Definitions ---                                      */
{include/i-vrtab.i bc-eqpto}

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE hProgramZoom AS HANDLE     NO-UNDO.

DEFINE VARIABLE v-row-parent AS ROWID      NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES bc-eqpto
&Scoped-define FIRST-EXTERNAL-TABLE bc-eqpto


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR bc-eqpto.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS bc-eqpto.cod-eqpto bc-eqpto.des-eqpto ~
bc-eqpto.cod-servid bc-eqpto.cod-tip-eqpto 
&Scoped-define ENABLED-TABLES bc-eqpto
&Scoped-define FIRST-ENABLED-TABLE bc-eqpto
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS bc-eqpto.cod-eqpto bc-eqpto.des-eqpto ~
bc-eqpto.cod-servid bc-eqpto.cod-tip-eqpto 
&Scoped-define DISPLAYED-TABLES bc-eqpto
&Scoped-define FIRST-DISPLAYED-TABLE bc-eqpto
&Scoped-Define DISPLAYED-OBJECTS des-servid des-tipo-equip 

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
DEFINE VARIABLE des-servid AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33.29 BY .88 NO-UNDO.

DEFINE VARIABLE des-tipo-equip AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33.29 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 4.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     bc-eqpto.cod-eqpto AT ROW 1.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     bc-eqpto.des-eqpto AT ROW 2.25 COL 2.14
          VIEW-AS FILL-IN 
          SIZE 40 BY .88
     bc-eqpto.cod-servid AT ROW 3.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     des-servid AT ROW 3.25 COL 39.57 COLON-ALIGNED NO-LABEL
     bc-eqpto.cod-tip-eqpto AT ROW 4.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     des-tipo-equip AT ROW 4.25 COL 39.57 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgcld.bc-eqpto
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
         HEIGHT             = 4.5
         WIDTH              = 88.57.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN bc-eqpto.des-eqpto IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN des-servid IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN des-tipo-equip IN FRAME f-main
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

&Scoped-define SELF-NAME bc-eqpto.cod-servid
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bc-eqpto.cod-servid V-table-Win
ON LEAVE OF bc-eqpto.cod-servid IN FRAME f-main /* Cod Servidor */
DO:
/*    {include/leave.i &tabela=bc-servid
                     &atributo-ref=des-servid
                     &variavel-ref="bc-eqpto.cod-servid:SCREEN-VALUE IN FRAME {&FRAME-NAME}"
                     &where="bc-servid.cod-servid = INPUT FRAME {&frame-name} bc-eqpto.cod-servid"}*/

    DEFINE BUFFER bfBCServid FOR bc-servid.

    FIND bfBCServid NO-LOCK WHERE
         bfBCServid.cod-servid = (bc-eqpto.cod-servid:SCREEN-VALUE IN FRAME {&FRAME-NAME}) NO-ERROR.

    IF AVAIL bfBCServid THEN
        ASSIGN des-servid = bfBCServid.des-servid.
    ELSE
        ASSIGN des-servid = "":U.

    DISP des-servid WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bc-eqpto.cod-servid V-table-Win
ON MOUSE-SELECT-DBLCLICK OF bc-eqpto.cod-servid IN FRAME f-main /* Cod Servidor */
OR "f5":U OF bc-eqpto.cod-servid DO:

    {method/ZoomFields.i
        &ProgramZoom="clzoom/z01cl039.w"
        &FieldZoom1="cod-servid"
        &FieldScreen1="bc-eqpto.cod-servid"
        &Frame1="{&FRAME-NAME}"
        &FieldZoom2="des-servid"
        &FieldScreen2="des-servid"
        &Frame2="{&FRAME-NAME}"
        &EnableImplant="NO"}
        
/*    APPLY "LEAVE":U TO bc-eqpto.cod-servid IN FRAME {&FRAME-NAME}.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bc-eqpto.cod-tip-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bc-eqpto.cod-tip-eqpto V-table-Win
ON LEAVE OF bc-eqpto.cod-tip-eqpto IN FRAME f-main /* Tipo Equipamento */
DO:
    DEFINE BUFFER bfBCTipEqpto FOR bc-tip-eqpto.

    FIND bfBCTipEqpto NO-LOCK WHERE
         bfBCTipEqpto.cod-tip-eqpto = (bc-eqpto.cod-tip-eqpto:SCREEN-VALUE IN FRAME {&FRAME-NAME}) NO-ERROR.

    IF AVAIL bfBCTipEqpto THEN
        ASSIGN des-tipo-equip = bfBCTipEqpto.des-tip-eqpto.
    ELSE
        ASSIGN des-tipo-equip = "":U.

    DISP des-tipo-equip WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bc-eqpto.cod-tip-eqpto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF bc-eqpto.cod-tip-eqpto IN FRAME f-main /* Tipo Equipamento */
OR "f5":U OF bc-eqpto.cod-tip-eqpto DO:
    {include/zoomvar.i &prog-zoom=bcp\bc0131z01.w
                       &campo=bc-eqpto.cod-tip-eqpto
                       &campozoom=cod-tip-eqpto}

    APPLY "LEAVE":U TO bc-eqpto.cod-tip-eqpto IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
bc-eqpto.cod-servid:LOAD-MOUSE-POINTER ("image~\lupa.cur").
bc-eqpto.cod-tip-eqpto:LOAD-MOUSE-POINTER ("image~\lupa.cur").

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
  {src/adm/template/row-list.i "bc-eqpto"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "bc-eqpto"}

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
    RUN pi-validate IN THIS-PROCEDURE.

    IF RETURN-VALUE = 'ADM-ERROR':U THEN
        RETURN 'ADM-ERROR':U.

    /*:T NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ).

    IF RETURN-VALUE = 'ADM-ERROR':U THEN
        RETURN 'ADM-ERROR':U.
    
    /*:T Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
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
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

    IF NOT adm-new-record THEN
        DISABLE bc-eqpto.cod-eqpto WITH FRAME {&FRAME-NAME}.

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

    /* Code placed here will execute AFTER standard behavior.    */
    IF AVAIL bc-eqpto THEN
        ASSIGN gr-bc-eqpto = ROWID(bc-eqpto).

    APPLY "LEAVE":U TO bc-eqpto.cod-servid IN FRAME {&FRAME-NAME}.
    APPLY "LEAVE":U TO bc-eqpto.cod-tip-eqpto IN FRAME {&FRAME-NAME}.

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
    DEFINE INPUT  PARAMETER v-row-parent-externo AS ROWID      NO-UNDO.

    ASSIGN v-row-parent = v-row-parent-externo.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*:T------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
    DEFINE BUFFER bfBCEquipamento    FOR bc-eqpto.
    DEFINE BUFFER bfBCTipoTransEquip FOR bc-tip-trans-eqpto.

    DEFINE VARIABLE cLabelCodigo AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cLabelEquip  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cLabelRelac  AS CHARACTER  NO-UNDO.

    {include/i-vldfrm.i} /*:T Valida‡Æo de dicion rio */

/*:T    Segue um exemplo de valida‡Æo de programa */
/*       find tabela where tabela.campo1 = c-variavel and               */
/*                         tabela.campo2 > i-variavel no-lock no-error. */
      
      /*:T Este include deve ser colocado sempre antes do ut-msgs.p */
/*       {include/i-vldprg.i}                                             */
/*       run utp/ut-msgs.p (input "show":U, input 7, input return-value). */
/*       return 'ADM-ERROR':U.                                            */

/*    IF NOT adm-new-record THEN DO:
        IF bc-eqpto.cod-eqpto:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> bc-eqpto.cod-eqpto THEN DO:
            {include/i-vldprg.i}

            FIND FIRST bfBCTipoTransEquip NO-LOCK
                 WHERE bfBCTipoTransEquip.cod-eqpto = bc-eqpto.cod-eqpto NO-ERROR.

            IF AVAIL bfBCTipoTransEquip THEN DO:
                {utp/ut-liter.i C¢digo_do_Equipamento *}
                ASSIGN cLabelCodigo = RETURN-VALUE.

                {utp/ut-liter.i O_Equipamento *}
                ASSIGN cLabelEquip = RETURN-VALUE.

                {utp/ut-liter.i Transa‡äes *}
                ASSIGN cLabelRelac = RETURN-VALUE.

                RUN utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 31922,
                                   INPUT (cLabelCodigo + "~~":U +
                                          cLabelEquip  + "~~":U +
                                          cLabelRelac)).

                IF RETURN-VALUE = "no":U THEN
                    RETURN 'ADM-ERROR':U.
            END.
        END.
    END.*/

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
  {src/adm/template/snd-list.i "bc-eqpto"}

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

    RUN pi-trata-state (p-issuer-hdl, p-state).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

