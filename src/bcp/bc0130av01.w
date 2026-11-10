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
{include/i-prgvrs.i BC0130AV01 2.00.00.002}  /*** 010002 ***/

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
&Scoped-define EXTERNAL-TABLES bc-param-eqpto
&Scoped-define FIRST-EXTERNAL-TABLE bc-param-eqpto


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR bc-param-eqpto.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS bc-param-eqpto.cod-param ~
bc-param-eqpto.des-param bc-param-eqpto.dsl-val-param 
&Scoped-define ENABLED-TABLES bc-param-eqpto
&Scoped-define FIRST-ENABLED-TABLE bc-param-eqpto
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold cb-idi-tip-dado dt-val-param ~
de-val-param i-val-param tg-val-param 
&Scoped-Define DISPLAYED-FIELDS bc-param-eqpto.cod-eqpto ~
bc-param-eqpto.cod-param bc-param-eqpto.des-param ~
bc-param-eqpto.dsl-val-param 
&Scoped-define DISPLAYED-TABLES bc-param-eqpto
&Scoped-define FIRST-DISPLAYED-TABLE bc-param-eqpto
&Scoped-Define DISPLAYED-OBJECTS des-eqpto cb-idi-tip-dado dt-val-param ~
de-val-param i-val-param tg-val-param 

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
DEFINE VARIABLE cb-idi-tip-dado AS INTEGER FORMAT ">9":U INITIAL 1 
     LABEL "Tipo de Parƒmetro" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Caracter",1,
                     "Data",2,
                     "Decimal",3,
                     "Inteiro",4,
                     "L¢gico",5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE de-val-param AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>>,>>9.99999":U INITIAL 1 
     LABEL "Valor do Parƒmetro" 
     VIEW-AS FILL-IN 
     SIZE 56 BY .88 NO-UNDO.

DEFINE VARIABLE des-eqpto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38.43 BY .88 NO-UNDO.

DEFINE VARIABLE dt-val-param AS DATE FORMAT "99/99/9999":U INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "Valor do Parƒmetro" 
     VIEW-AS FILL-IN 
     SIZE 56 BY .88 NO-UNDO.

DEFINE VARIABLE i-val-param AS INTEGER FORMAT "->>>,>>>,>>9":U INITIAL 1 
     LABEL "Valor do Parƒmetro" 
     VIEW-AS FILL-IN 
     SIZE 56 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89 BY 2.46.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89 BY 3.5.

DEFINE VARIABLE tg-val-param AS LOGICAL INITIAL no 
     LABEL "Valor do Parƒmetro" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     bc-param-eqpto.cod-eqpto AT ROW 1.25 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     des-eqpto AT ROW 1.25 COL 48.57 COLON-ALIGNED NO-LABEL
     bc-param-eqpto.cod-param AT ROW 2.25 COL 31 COLON-ALIGNED
          LABEL "C¢digo do Parƒmetro":R19
          VIEW-AS FILL-IN 
          SIZE 41.14 BY .88
     bc-param-eqpto.des-param AT ROW 4 COL 9.57
          LABEL "Descri‡Æo do Parƒmetro":R22
          VIEW-AS FILL-IN 
          SIZE 56 BY .88
     cb-idi-tip-dado AT ROW 5 COL 31 COLON-ALIGNED
     dt-val-param AT ROW 6 COL 31 COLON-ALIGNED
     de-val-param AT ROW 6 COL 31 COLON-ALIGNED
     i-val-param AT ROW 6 COL 31 COLON-ALIGNED
     bc-param-eqpto.dsl-val-param AT ROW 6 COL 31 COLON-ALIGNED
          LABEL "Valor do Parƒmetro":R18
          VIEW-AS FILL-IN 
          SIZE 56 BY .88
     tg-val-param AT ROW 6 COL 33
     rt-key AT ROW 1.04 COL 1
     rt-mold AT ROW 3.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgcld.bc-param-eqpto
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
         HEIGHT             = 6.25
         WIDTH              = 89.
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

/* SETTINGS FOR FILL-IN bc-param-eqpto.cod-eqpto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN bc-param-eqpto.cod-param IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN des-eqpto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN bc-param-eqpto.des-param IN FRAME f-main
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN bc-param-eqpto.dsl-val-param IN FRAME f-main
   EXP-LABEL                                                            */
ASSIGN 
       tg-val-param:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME cb-idi-tip-dado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-idi-tip-dado V-table-Win
ON VALUE-CHANGED OF cb-idi-tip-dado IN FRAME f-main /* Tipo de Parƒmetro */
DO:
    ASSIGN bc-param-eqpto.dsl-val-param:HIDDEN IN FRAME {&FRAME-NAME} = (cb-idi-tip-dado:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "1":U)
           dt-val-param:HIDDEN IN FRAME {&FRAME-NAME} = (cb-idi-tip-dado:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "2":U)
           de-val-param:HIDDEN IN FRAME {&FRAME-NAME} = (cb-idi-tip-dado:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "3":U)
           i-val-param:HIDDEN IN FRAME {&FRAME-NAME} = (cb-idi-tip-dado:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "4":U)
           tg-val-param:HIDDEN IN FRAME {&FRAME-NAME} = (cb-idi-tip-dado:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "5":U).

    CASE (cb-idi-tip-dado:SCREEN-VALUE IN FRAME {&FRAME-NAME}):
        WHEN "1":U THEN DO:
            ENABLE bc-param-eqpto.dsl-val-param WITH FRAME {&FRAME-NAME}.

            DISABLE
                dt-val-param
                de-val-param
                i-val-param
                tg-val-param
                WITH FRAME {&FRAME-NAME}.
        END.

        WHEN "2":U THEN DO:
            ENABLE dt-val-param WITH FRAME {&FRAME-NAME}.

            DISABLE
                bc-param-eqpto.dsl-val-param
                de-val-param
                i-val-param
                tg-val-param
                WITH FRAME {&FRAME-NAME}.
        END.

        WHEN "3":U THEN DO:
            ENABLE de-val-param WITH FRAME {&FRAME-NAME}.

            DISABLE
                bc-param-eqpto.dsl-val-param
                dt-val-param
                i-val-param
                tg-val-param
                WITH FRAME {&FRAME-NAME}.
        END.

        WHEN "4":U THEN DO:
            ENABLE i-val-param WITH FRAME {&FRAME-NAME}.

            DISABLE
                bc-param-eqpto.dsl-val-param
                dt-val-param
                de-val-param
                tg-val-param
                WITH FRAME {&FRAME-NAME}.
        END.

        WHEN "5":U THEN DO:
            ENABLE tg-val-param WITH FRAME {&FRAME-NAME}.

            DISABLE
                bc-param-eqpto.dsl-val-param
                dt-val-param
                de-val-param
                i-val-param
                WITH FRAME {&FRAME-NAME}.
        END.

    END CASE.
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
  {src/adm/template/row-list.i "bc-param-eqpto"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "bc-param-eqpto"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    RUN local-display-fields IN THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cValParam AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE iDataType AS INTEGER    NO-UNDO.

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}

    /*:T Ponha na pi-validate todas as valida‡äes */
    RUN pi-validate IN THIS-PROCEDURE.

    IF RETURN-VALUE = 'ADM-ERROR':U THEN
        RETURN 'ADM-ERROR':U.

    /*:T NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

    ASSIGN iDataType = INTEGER(cb-idi-tip-dado:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

    CASE iDataType:
        WHEN 1 THEN
            ASSIGN cValParam = bc-param-eqpto.dsl-val-param:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

        WHEN 2 THEN
            ASSIGN cValParam = dt-val-param:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

        WHEN 3 THEN
            ASSIGN cValParam = de-val-param:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

        WHEN 4 THEN
            ASSIGN cValParam = i-val-param:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

        WHEN 5 THEN
            ASSIGN cValParam = tg-val-param:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    END CASE.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    IF RETURN-VALUE = 'ADM-ERROR':U THEN
        RETURN 'ADM-ERROR':U.

    /*:T Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */
    ASSIGN bc-param-eqpto.cod-eqpto = bc-param-eqpto.cod-eqpto:SCREEN-VALUE IN FRAME {&FRAME-NAME}
           bc-param-eqpto.dsl-val-param = cValParam
           bc-param-eqpto.idi-tip-dado = iDataType.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE BUFFER bfBCEqpto FOR bc-eqpto.

    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    FIND bfBCEqpto NO-LOCK WHERE ROWID(bfBCEqpto) = v-row-parent NO-ERROR.

    IF AVAIL bfBCEqpto THEN
        ASSIGN bc-param-eqpto.cod-eqpto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = bfBCEqpto.cod-eqpto
               des-eqpto = bfBCEqpto.des-eqpto.
    ELSE
        ASSIGN bc-param-eqpto.cod-eqpto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U
               des-eqpto = "":U.

    IF AVAIL bc-param-eqpto AND
       bc-param-eqpto.idi-tip-dado <> 0 AND
       bc-param-eqpto.idi-tip-dado <> ? THEN DO:

        ASSIGN cb-idi-tip-dado = bc-param-eqpto.idi-tip-dado.

        CASE cb-idi-tip-dado:
            WHEN 2 THEN
                ASSIGN dt-val-param = DATE(bc-param-eqpto.dsl-val-param).

            WHEN 3 THEN
                ASSIGN de-val-param = DECIMAL(bc-param-eqpto.dsl-val-param).

            WHEN 4 THEN
                ASSIGN i-val-param = INTEGER(bc-param-eqpto.dsl-val-param).

            WHEN 5 THEN
                ASSIGN tg-val-param = (bc-param-eqpto.dsl-val-param = "yes":U).

        END CASE.
    END.

    DISP
        cb-idi-tip-dado
        de-val-param
        des-eqpto
        dt-val-param
        i-val-param
        tg-val-param
        WITH FRAME {&FRAME-NAME}.

    APPLY "VALUE-CHANGED":U TO cb-idi-tip-dado IN FRAME {&FRAME-NAME}.

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

    DEFINE BUFFER bfBCParamEqpto FOR bc-param-eqpto.

    DEFINE VARIABLE lErrorFound AS LOGICAL    NO-UNDO
        INITIAL NO.

    {include/i-vldfrm.i} /*:T Valida‡Æo de dicion rio */

/*:T    Segue um exemplo de valida‡Æo de programa */
/*       find tabela where tabela.campo1 = c-variavel and               */
/*                         tabela.campo2 > i-variavel no-lock no-error. */

      /*:T Este include deve ser colocado sempre antes do ut-msgs.p */
/*       {include/i-vldprg.i}                                             */
/*       run utp/ut-msgs.p (input "show":U, input 7, input return-value). */
/*       return 'ADM-ERROR':U.                                            */

    IF bc-param-eqpto.cod-param:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U OR
       bc-param-eqpto.cod-param:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ? THEN DO:

        {include/i-vldprg.i}

        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "C¢digo_do_Parƒmetro" *}
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 265,
                           INPUT RETURN-VALUE).

        RETURN "ADM-ERROR":U.
    END.

    FIND bfBCParamEqpto NO-LOCK WHERE
         bfBCParamEqpto.cod-eqpto = bc-param-eqpto.cod-eqpto:SCREEN-VALUE IN FRAME {&FRAME-NAME} AND
         bfBCParamEqpto.cod-param = bc-param-eqpto.cod-param:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-ERROR.

    IF adm-new-record AND AVAIL bfBCParamEqpto THEN DO:
        {include/i-vldprg.i}

        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Parƒmetro_do_Equipamento" *}
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 1,
                           INPUT RETURN-VALUE).

        RETURN "ADM-ERROR":U.
    END.

    CASE cb-idi-tip-dado:SCREEN-VALUE IN FRAME {&FRAME-NAME}:
        WHEN "1":U THEN
            IF bc-param-eqpto.dsl-val-param:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U OR
               bc-param-eqpto.dsl-val-param:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ? THEN
                ASSIGN lErrorFound = YES.

        WHEN "2":U THEN
            IF DATE(dt-val-param:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = ? THEN
                ASSIGN lErrorFound = YES.

        WHEN "3":U THEN
            IF de-val-param:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U OR
               de-val-param:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ? THEN
                ASSIGN lErrorFound = YES.

        WHEN "4":U THEN
            IF i-val-param:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U OR
               i-val-param:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ? THEN
                ASSIGN lErrorFound = YES.
    END CASE.

    IF lErrorFound THEN DO:
        {include/i-vldprg.i}

        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Valor_do_Parƒmetro" *}
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 265,
                           INPUT RETURN-VALUE).

        RETURN "ADM-ERROR":U.
    END.

    RETURN "OK":U.

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
  {src/adm/template/snd-list.i "bc-param-eqpto"}

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

