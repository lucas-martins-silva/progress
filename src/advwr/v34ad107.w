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
{include/i-prgvrs.i V34AD107 2.00.00.029}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v34ad107 MUT}
&ENDIF

{cdp/cdcfgfin.i} /** Include de verificaá∆o de funá‰es da vers∆o **/
{cdp/cdcfgdis.i}

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
DEFINE VARIABLE v-row-parent    AS ROWID        NO-UNDO.
DEFINE VARIABLE c-lbl-msg       AS CHARACTER    NO-UNDO.

/*** PUBLICACAO XML ***/
&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE XMLTopic ESTABELLEC
&GLOBAL-DEFINE XMLTableName ESTABELEC
&GLOBAL-DEFINE XMLTableNameMult ESTABELECS
&GLOBAL-DEFINE XMLPublicFields 
&GLOBAL-DEFINE XMLKeyFields cod-estabel
&GLOBAL-DEFINE XMLSender DIS
&GLOBAL-DEFINE XMLExcludeFields

{METHOD/xmlsmrt.i}

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
&Scoped-define EXTERNAL-TABLES estabelec
&Scoped-define FIRST-EXTERNAL-TABLE estabelec


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estabelec.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 rect-deposito-fechado ~
rs-forma-gera-nf-ret-autom c-lbl-integ-finan c-lbl-depos-fechado 
&Scoped-Define DISPLAYED-OBJECTS cb-integr-ap-ncr cb-integr-cr-ncr ~
tg-depos-fechado tg-nf-ret-simbol-automatico rs-forma-gera-nf-ret-autom ~
c-lbl-integ-finan c-lbl-depos-fechado 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS cb-integr-cr-ncr 
&Scoped-define ADM-MODIFY-FIELDS cb-integr-ap-ncr cb-integr-cr-ncr ~
tg-depos-fechado tg-nf-ret-simbol-automatico 

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
DEFINE VARIABLE cb-integr-ap-ncr AS CHARACTER FORMAT "X(16)":U INITIAL "Credita/Antecipa" 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     DROP-DOWN-LIST
     SIZE 19 BY 1 NO-UNDO.

DEFINE VARIABLE cb-integr-cr-ncr AS CHARACTER FORMAT "X(16)":U INITIAL "Credita/Antecipa" 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 19 BY 1 NO-UNDO.

DEFINE VARIABLE c-lbl-depos-fechado AS CHARACTER FORMAT "X(256)":U INITIAL "Dep¢sito Fechado" 
      VIEW-AS TEXT 
     SIZE 13 BY .67 NO-UNDO.

DEFINE VARIABLE c-lbl-integ-finan AS CHARACTER FORMAT "X(256)":U INITIAL "Integraá‰es com Financeiro" 
      VIEW-AS TEXT 
     SIZE 20 BY .67 NO-UNDO.

DEFINE VARIABLE rs-forma-gera-nf-ret-autom AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Autorizaá∆o da Nota Fiscal", 1,
"Atualizaá∆o do Estoque", 2
     SIZE 34 BY 1.67 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50 BY 3.46.

DEFINE RECTANGLE rect-deposito-fechado
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50 BY 4.88.

DEFINE VARIABLE tg-depos-fechado AS LOGICAL INITIAL no 
     LABEL "Estabelecimento Dep¢sito Fechado" 
     VIEW-AS TOGGLE-BOX
     SIZE 36 BY .83 NO-UNDO.

DEFINE VARIABLE tg-nf-ret-simbol-automatico AS LOGICAL INITIAL no 
     LABEL "Realiza Emiss∆o NF de Retorno Simb¢lico Automaticamente" 
     VIEW-AS TOGGLE-BOX
     SIZE 45 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cb-integr-ap-ncr AT ROW 2.54 COL 20 COLON-ALIGNED HELP
          "?"
     cb-integr-cr-ncr AT ROW 3.71 COL 20 COLON-ALIGNED HELP
          "?"
     tg-depos-fechado AT ROW 6.29 COL 5 HELP
          "Informa que o Estabelecimento Ç um Dep¢sito Fechado"
     tg-nf-ret-simbol-automatico AT ROW 7.13 COL 5 HELP
          "Realiza Emiss∆o NF de Retorno Simb¢lico Automaticamente"
     rs-forma-gera-nf-ret-autom AT ROW 8 COL 7 HELP
          "Gera NF Ret Simb¢lico no c†lculo da NF ou Atualizaá∆o Estoque" NO-LABEL
     c-lbl-integ-finan AT ROW 1.5 COL 3 COLON-ALIGNED NO-LABEL
     c-lbl-depos-fechado AT ROW 5.33 COL 3 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 1.79 COL 3
     rect-deposito-fechado AT ROW 5.63 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.estabelec
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
         HEIGHT             = 9.83
         WIDTH              = 66.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{include/i-auxtab.i}
{src/adm/METHOD/viewer.i}
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

/* SETTINGS FOR COMBO-BOX cb-integr-ap-ncr IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX cb-integr-cr-ncr IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR TOGGLE-BOX tg-depos-fechado IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR TOGGLE-BOX tg-nf-ret-simbol-automatico IN FRAME f-main
   NO-ENABLE 3                                                          */
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

&Scoped-define SELF-NAME tg-depos-fechado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-depos-fechado V-table-Win
ON VALUE-CHANGED OF tg-depos-fechado IN FRAME f-main /* Estabelecimento Dep¢sito Fechado */
DO:
    IF tg-depos-fechado:CHECKED IN FRAME {&frame-name} THEN
        ASSIGN tg-nf-ret-simbol-automatico:SENSITIVE   IN FRAME {&frame-name} = NO 
               tg-nf-ret-simbol-automatico:CHECKED     IN FRAME {&frame-name} = NO
               rs-forma-gera-nf-ret-autom:SENSITIVE    IN FRAME {&frame-name} = NO.
    ELSE 
        ASSIGN tg-nf-ret-simbol-automatico:SENSITIVE   IN FRAME {&frame-name} = YES
               rs-forma-gera-nf-ret-autom:SENSITIVE    IN FRAME {&frame-name} = YES. 

    IF tg-nf-ret-simbol-automatico:CHECKED IN FRAME {&frame-name} = NO THEN
        ASSIGN rs-forma-gera-nf-ret-autom:SENSITIVE  IN FRAME {&frame-name} = NO.
    ELSE
        ASSIGN rs-forma-gera-nf-ret-autom:SENSITIVE  IN FRAME {&frame-name} = YES.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-nf-ret-simbol-automatico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-nf-ret-simbol-automatico V-table-Win
ON VALUE-CHANGED OF tg-nf-ret-simbol-automatico IN FRAME f-main /* Realiza Emiss∆o NF de Retorno Simb¢lico Automaticamente */
DO:
    IF tg-nf-ret-simbol-automatico:CHECKED IN FRAME {&frame-name} THEN
        ASSIGN rs-forma-gera-nf-ret-autom:SENSITIVE    IN FRAME {&frame-name} = YES.
    ELSE 
        ASSIGN rs-forma-gera-nf-ret-autom:SENSITIVE    IN FRAME {&frame-name} = NO. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  {utp/ut-liter.i Integraá∆o_AP_x_NCR}
  ASSIGN cb-integr-ap-ncr:LABEL IN FRAME {&frame-name} = TRIM(RETURN-VALUE).
  {utp/ut-liter.i Integraá∆o_CR_x_NCR}
  ASSIGN cb-integr-cr-ncr:LABEL IN FRAME {&frame-name} = TRIM(RETURN-VALUE).
  
  /************************ INTERNAL PROCEDURES ********************/

  {utp/ut-rdset.i rs-forma-gera-nf-ret-autom *}

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
  {src/adm/template/row-list.i "estabelec"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "estabelec"}

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

  {utp/ut-liter.i Integraá‰es_com_Financeiro}
  ASSIGN c-lbl-integ-finan:SCREEN-VALUE IN FRAME {&frame-name} = TRIM(RETURN-VALUE).
  
  {utp/ut-liter.i Dep¢sito_Fechado}
  ASSIGN c-lbl-depos-fechado:SCREEN-VALUE IN FRAME {&frame-name} = TRIM(RETURN-VALUE).

  ASSIGN tg-depos-fechado:CHECKED                IN FRAME {&frame-name} = NO
         tg-nf-ret-simbol-automatico:SENSITIVE   IN FRAME {&frame-name} = YES
         tg-nf-ret-simbol-automatico:CHECKED     IN FRAME {&frame-name} = NO
         rs-forma-gera-nf-ret-autom:SENSITIVE    IN FRAME {&frame-name} = NO
         rs-forma-gera-nf-ret-autom:SCREEN-VALUE IN FRAME {&frame-name} = "1".

  RETURN "OK":U.
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
       IF NOT FRAME {&frame-name}:VALIDATE() THEN
        RETURN 'ADM-ERROR':U.
        
    /* Ponha na pi-validate todas as validaá‰es */
    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

   /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    IF RETURN-VALUE = 'ADM-ERROR':U THEN 
        RETURN 'ADM-ERROR':U.
    
    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */
    
    &if defined(BF_FIN_INTEGR_APP_CRP) &then
        IF  AVAILABLE(estabelec) THEN
            ASSIGN INPUT FRAME {&frame-name} cb-integr-ap-ncr cb-integr-cr-ncr
                   estabelec.integr-ncr-app = {adinc/i01ad321.i 06 cb-integr-ap-ncr}
                   estabelec.integr-ncr-crp = {adinc/i01ad321.i 06 cb-integr-cr-ncr}
                   OVERLAY(estabelec.char-1,396,1) = IF tg-depos-fechado:CHECKED IN FRAME {&frame-name} THEN "S" ELSE "N" 
                   OVERLAY(estabelec.char-1,397,1) = IF tg-nf-ret-simbol-automatico:CHECKED IN FRAME {&frame-name}  THEN "S" ELSE "N"
                   OVERLAY(estabelec.char-1,398,1) = rs-forma-gera-nf-ret-autom:SCREEN-VALUE IN FRAME {&frame-name}.
    &endif
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* Comentado Devido a retirada do Multi-Plantas
  {method/xmldef.i}
  {method/xmlini.i ADD}
  {method/xmlprp.i}
  {method/xmlsnd.i}*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
    {METHOD/showmessage.i3}
    
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

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
    /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .*/
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-CREATE-FIELDS) &then
        DISABLE {&ADM-CREATE-FIELDS} WITH FRAME {&frame-name}.
    &endif

    &if  defined(ADM-MODIFY-FIELDS) &then
        DISABLE {&ADM-MODIFY-FIELDS} WITH FRAME {&frame-name}.
    &endif
    
    DISABLE rs-forma-gera-nf-ret-autom WITH FRAME {&FRAME-NAME}.
    
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
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */
   
   &if defined(BF_FIN_INTEGR_APP_CRP) &then  
     IF AVAIL estabelec THEN DO:
       ASSIGN cb-integr-ap-ncr:SCREEN-VALUE IN FRAME {&frame-name} =
         {adinc/i01ad321.i 04 estabelec.integr-ncr-app}
       cb-integr-cr-ncr:SCREEN-VALUE IN FRAME {&frame-name} =
         {adinc/i01ad321.i 04 estabelec.integr-ncr-crp}.
     END.
     ELSE DO:
       ASSIGN cb-integr-ap-ncr:SCREEN-VALUE IN FRAME {&frame-name} =
         {adinc/i01ad321.i 04 1}
       cb-integr-cr-ncr:SCREEN-VALUE IN FRAME {&frame-name} =
         {adinc/i01ad321.i 04 1}.
     END.
   &endif
   
   IF AVAIL estabelec THEN DO:
        ASSIGN tg-depos-fechado:CHECKED IN FRAME {&frame-name}                = IF SUBSTRING(estabelec.char-1,396,1) = "S" THEN YES ELSE NO
               tg-nf-ret-simbol-automatico:CHECKED IN FRAME {&frame-name}     = IF SUBSTRING(estabelec.char-1,397,1) = "S" THEN YES ELSE NO
               rs-forma-gera-nf-ret-autom:SCREEN-VALUE IN FRAME {&frame-name} = IF SUBSTRING(estabelec.char-1,398,1) = "2" THEN "2" ELSE "1".
   END.
   ELSE DO:
        ASSIGN tg-depos-fechado:CHECKED                IN FRAME {&frame-name} = NO
               tg-nf-ret-simbol-automatico:CHECKED     IN FRAME {&frame-name} = NO
               rs-forma-gera-nf-ret-autom:SENSITIVE    IN FRAME {&frame-name} = NO
               rs-forma-gera-nf-ret-autom:SCREEN-VALUE IN FRAME {&frame-name} = "1".
   END.

   
  {utp/ut-liter.i Integraá‰es_com_Financeiro}
  ASSIGN c-lbl-integ-finan:SCREEN-VALUE IN FRAME {&frame-name} = TRIM(RETURN-VALUE).
  
  {utp/ut-liter.i Dep¢sito_Fechado}
  ASSIGN c-lbl-depos-fechado:SCREEN-VALUE IN FRAME {&frame-name} = TRIM(RETURN-VALUE).
  
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
    /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .*/
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
        /*if adm-new-record = yes then*/
        ENABLE {&ADM-MODIFY-FIELDS} WITH FRAME {&frame-name}.
    &endif
    
    IF tg-depos-fechado:CHECKED IN FRAME {&frame-name} = NO THEN
        ASSIGN tg-nf-ret-simbol-automatico:SENSITIVE IN FRAME {&frame-name} = YES
               rs-forma-gera-nf-ret-autom:SENSITIVE  IN FRAME {&frame-name} = YES.
    ELSE
        ASSIGN tg-nf-ret-simbol-automatico:SENSITIVE IN FRAME {&frame-name} = NO
               rs-forma-gera-nf-ret-autom:SENSITIVE  IN FRAME {&frame-name} = NO.

    IF tg-nf-ret-simbol-automatico:CHECKED IN FRAME {&frame-name} = NO THEN
        ASSIGN rs-forma-gera-nf-ret-autom:SENSITIVE  IN FRAME {&frame-name} = NO.
    ELSE
        ASSIGN rs-forma-gera-nf-ret-autom:SENSITIVE  IN FRAME {&frame-name} = YES.
    
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
  
  &if defined(BF_FIN_INTEGR_APP_CRP) &then
    ASSIGN cb-integr-ap-ncr:LIST-ITEMS IN FRAME {&frame-name} =
     {adinc/i01ad321.i 03}
         cb-integr-cr-ncr:LIST-ITEMS IN FRAME {&frame-name} =
     {adinc/i01ad321.i 03}.
  &endif
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */

  DISP c-lbl-integ-finan c-lbl-depos-fechado WITH FRAME {&FRAME-NAME}.

  {utp/ut-liter.i Integraá‰es_com_Financeiro}
  ASSIGN c-lbl-integ-finan:SCREEN-VALUE IN FRAME {&frame-name} = TRIM(RETURN-VALUE).
  
  {utp/ut-liter.i Dep¢sito_Fechado}
  ASSIGN c-lbl-depos-fechado:SCREEN-VALUE IN FRAME {&frame-name} = TRIM(RETURN-VALUE).

  DISABLE rs-forma-gera-nf-ret-autom WITH FRAME {&FRAME-NAME}.

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
    DEFINE INPUT PARAMETER v-row-parent-externo AS ROWID NO-UNDO.
    
    ASSIGN v-row-parent = v-row-parent-externo.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */
    
/*/*    Segue um exemplo de validaá∆o de programa */
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
  {src/adm/template/snd-list.i "estabelec"}

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

