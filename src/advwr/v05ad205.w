&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          mguni            PROGRESS
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
{include/i-prgvrs.i V05AD205 2.00.00.026 } /*** 010026 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v05ad205 MUT}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w


def var c-retorno  as character     no-undo.
def var c-handle   as char          no-undo.
def var h-handle   as handle        no-undo.
def var h_v01ad205 as handle        no-undo.
def var l-retorna  as logical.

{cdp/cdcfgdis.i} /*include para pr‚-processadores*/
{cdp/cdcfgmnt.i}

/* miniflexibiliza‡Æo */
{cdp/cdcfgfin.i}
{cdp/cdcfgman.i} /* miniflexibiliza‡Æo manufatura */

/*EMBALAGEM*/
{cdp/cd9999.i4}

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
&Scoped-define EXTERNAL-TABLES param-global
&Scoped-define FIRST-EXTERNAL-TABLE param-global


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-global.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-global.modulo-pd param-global.modulo-ft ~
param-global.modulo-of param-global.modulo-ex param-global.modulo-07 ~
param-global.modulo-pv param-global.modulo-cv param-global.modulo-09 ~
param-global.modulo-10 param-global.log-modul-cm param-global.modulo-re ~
param-global.modulo-ce param-global.modulo-cq param-global.modulo-cc ~
param-global.modulo-in param-global.modulo-cn param-global.modulo-ge ~
param-global.modulo-ca 
&Scoped-define ENABLED-TABLES param-global
&Scoped-define FIRST-ENABLED-TABLE param-global
&Scoped-Define ENABLED-OBJECTS RECT-4 RECT-5 RECT-6 tg-embarque tg-drawback ~
tg-fretes tg-frete-emb l-cotac-comp tg-aquis-produt-rurais 
&Scoped-Define DISPLAYED-FIELDS param-global.modulo-pd ~
param-global.modulo-ft param-global.modulo-of param-global.modulo-ex ~
param-global.modulo-07 param-global.modulo-pv param-global.modulo-cv ~
param-global.modulo-08 param-global.modulo-09 param-global.modulo-10 ~
param-global.log-modul-cm param-global.modulo-re param-global.modulo-ce ~
param-global.modulo-cq param-global.modulo-cc param-global.modulo-in ~
param-global.modulo-cn param-global.modulo-ge param-global.modulo-ca 
&Scoped-define DISPLAYED-TABLES param-global
&Scoped-define FIRST-DISPLAYED-TABLE param-global
&Scoped-Define DISPLAYED-OBJECTS tg-embarque tg-drawback tg-fretes ~
tg-frete-emb l-cotac-comp tg-aquis-produt-rurais 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS f-main param-global.modulo-pd ~
param-global.modulo-ex param-global.modulo-07 tg-drawback ~
param-global.modulo-pv param-global.modulo-cv param-global.modulo-re ~
param-global.modulo-ce param-global.modulo-cq param-global.modulo-cc ~
param-global.modulo-in param-global.modulo-ge param-global.modulo-ca 

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
DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 15.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43 BY 15.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43 BY 8.38.

DEFINE VARIABLE l-cotac-comp AS LOGICAL INITIAL no 
     LABEL "Cota‡äes de Compra" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.

DEFINE VARIABLE tg-aquis-produt-rurais AS LOGICAL INITIAL no 
     LABEL "Aquisi‡Æo Produtos Rurais" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .83 NO-UNDO.

DEFINE VARIABLE tg-drawback AS LOGICAL INITIAL no 
     LABEL "Drawback" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-embarque AS LOGICAL INITIAL no 
     LABEL "Embarques" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE tg-frete-emb AS LOGICAL INITIAL no 
     LABEL "Frete Embarcador Multiplataforma (TotvsGFE)" 
     VIEW-AS TOGGLE-BOX
     SIZE 35 BY .75 NO-UNDO.

DEFINE VARIABLE tg-fretes AS LOGICAL INITIAL no 
     LABEL "Controle Fretes" 
     VIEW-AS TOGGLE-BOX
     SIZE 23.43 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-global.modulo-pd AT ROW 1.5 COL 3
          VIEW-AS TOGGLE-BOX
          SIZE 11.29 BY .75
     param-global.modulo-ft AT ROW 2.17 COL 3
          VIEW-AS TOGGLE-BOX
          SIZE 15.29 BY .75
     param-global.modulo-of AT ROW 2.83 COL 3
          VIEW-AS TOGGLE-BOX
          SIZE 21.57 BY .75
     tg-embarque AT ROW 3.46 COL 3
     param-global.modulo-ex AT ROW 4.17 COL 3
          VIEW-AS TOGGLE-BOX
          SIZE 14.14 BY .75
     param-global.modulo-07 AT ROW 4.83 COL 3
          VIEW-AS TOGGLE-BOX
          SIZE 14.43 BY .83
     tg-drawback AT ROW 5.5 COL 3
     param-global.modulo-pv AT ROW 6.21 COL 3
          VIEW-AS TOGGLE-BOX
          SIZE 22.29 BY .75
     param-global.modulo-cv AT ROW 6.88 COL 3
          VIEW-AS TOGGLE-BOX
          SIZE 21.43 BY .75
     param-global.modulo-08 AT ROW 7.5 COL 3
          VIEW-AS TOGGLE-BOX
          SIZE 14.43 BY .83
     param-global.modulo-09 AT ROW 8.21 COL 3
          VIEW-AS TOGGLE-BOX
          SIZE 25 BY .83
     param-global.modulo-10 AT ROW 8.92 COL 3
          VIEW-AS TOGGLE-BOX
          SIZE 26 BY .83
     tg-fretes AT ROW 9.58 COL 3
     param-global.log-modul-cm AT ROW 10.25 COL 3
          VIEW-AS TOGGLE-BOX
          SIZE 23 BY .79
     tg-frete-emb AT ROW 10.96 COL 3 WIDGET-ID 2
     param-global.modulo-re AT ROW 1.5 COL 49
          VIEW-AS TOGGLE-BOX
          SIZE 15.86 BY .75
     param-global.modulo-ce AT ROW 2.21 COL 49
          VIEW-AS TOGGLE-BOX
          SIZE 11.29 BY .75
     param-global.modulo-cq AT ROW 3 COL 49
          VIEW-AS TOGGLE-BOX
          SIZE 24.29 BY .75
     param-global.modulo-cc AT ROW 3.71 COL 49
          VIEW-AS TOGGLE-BOX
          SIZE 12 BY .75
     param-global.modulo-in AT ROW 4.38 COL 49
          VIEW-AS TOGGLE-BOX
          SIZE 24 BY .75
     param-global.modulo-cn AT ROW 5.08 COL 49
          VIEW-AS TOGGLE-BOX
          SIZE 23 BY .83
     l-cotac-comp AT ROW 5.88 COL 49
     tg-aquis-produt-rurais AT ROW 6.63 COL 49 WIDGET-ID 6
     param-global.modulo-ge AT ROW 7.92 COL 49
          VIEW-AS TOGGLE-BOX
          SIZE 11.57 BY .75
     param-global.modulo-ca AT ROW 8.63 COL 49
          VIEW-AS TOGGLE-BOX
          SIZE 19 BY .75
     RECT-4 AT ROW 1.17 COL 44.43 RIGHT-ALIGNED
     RECT-5 AT ROW 1.17 COL 46
     RECT-6 AT ROW 7.75 COL 46 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mguni.param-global
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
         HEIGHT             = 15.33
         WIDTH              = 88.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE FRAME-NAME Size-to-Fit 3 L-To-R,COLUMNS                  */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR TOGGLE-BOX param-global.modulo-07 IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-08 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-ca IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-cc IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-ce IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-cq IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-cv IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-ex IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-ge IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-in IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-pd IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-pv IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-re IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR RECTANGLE RECT-4 IN FRAME f-main
   ALIGN-R                                                              */
ASSIGN 
       RECT-6:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX tg-drawback IN FRAME f-main
   3                                                                    */
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

&Scoped-define SELF-NAME param-global.modulo-07
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-global.modulo-07 V-table-Win
ON VALUE-CHANGED OF param-global.modulo-07 IN FRAME f-main /* Modulo 07 */
DO:
    /**
        IF  param-global.modulo-ex:CHECKED IN FRAME {&FRAME-NAME} = YES
        AND param-global.modulo-07:CHECKED IN FRAME {&FRAME-NAME} = YES THEN
            ASSIGN tg-drawback:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
        ELSE
            ASSIGN tg-drawback:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                   tg-drawback:CHECKED IN FRAME {&FRAME-NAME} = NO.
               
     */          
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-global.modulo-ex
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-global.modulo-ex V-table-Win
ON VALUE-CHANGED OF param-global.modulo-ex IN FRAME f-main /* Exporta‡Æo */
DO:
    /**
        IF  param-global.modulo-ex:CHECKED IN FRAME {&FRAME-NAME} = YES
        AND param-global.modulo-07:CHECKED IN FRAME {&FRAME-NAME} = YES THEN
            ASSIGN tg-drawback:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
        ELSE
            ASSIGN tg-drawback:SENSITIVE IN FRAME {&FRAME-NAME} = NO
                   tg-drawback:CHECKED IN FRAME {&FRAME-NAME} = NO.
     */          
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF

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
  {src/adm/template/row-list.i "param-global"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-global"}

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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

  IF CAN-FIND(FIRST funcao
              WHERE funcao.cd-funcao = "spp-rm-solum"
              AND   funcao.ativo)
  AND param-global.modulo-in:CHECKED IN FRAME {&FRAME-NAME} THEN DO:
      /* Inicio -- Projeto Internacional */
      DEFINE VARIABLE c-lbl-liter-modulo-de-investim AS CHARACTER NO-UNDO.
      {utp/ut-liter.i "M¢dulo_de_Investimentos_nÆo_pode_ser_implantado" *}
      ASSIGN c-lbl-liter-modulo-de-investim = TRIM(RETURN-VALUE).
      DEFINE VARIABLE c-lbl-liter-este-ambiente-esta AS CHARACTER NO-UNDO.
      {utp/ut-liter.i "Este_ambiente_est _parametrizado_para_integrar_com_o_produto_RM_Solum" *}
      ASSIGN c-lbl-liter-este-ambiente-esta = TRIM(RETURN-VALUE).
      RUN utp/ut-msgs.p (INPUT "show",
                         INPUT 17242,
                         INPUT c-lbl-liter-modulo-de-investim + "." + "~~" + c-lbl-liter-este-ambiente-esta + ".").
         RETURN "ADM-ERROR":U.
  END.

  /* Code placed here will execute AFTER standard behavior.    */

  &if '{&bf_dis_versao_ems}' >= '2.062' &then
       ASSIGN param-global.log-modul-eq = IF tg-embarque:CHECKED IN FRAME {&FRAME-NAME} THEN YES
                                          ELSE NO.
  &endif

  assign overlay(param-global.char-2,29,1)  = if l-cotac-comp:checked in frame {&frame-name} then "1" else "2"
         overlay(param-global.char-2,101,1) = IF tg-aquis-produt-rurais:CHECKED IN FRAME {&FRAME-NAME} THEN "S":U ELSE "N":U.

  &IF "{&mguni_version}" < "2.07"  &THEN
      
      &if '{&BF_DIS_VERSAO_EMS}' >= '2.03' &then
          if  tg-fretes:checked in frame {&frame-name} then
              assign param-global.modulo-tf = yes.
          else
              assign param-global.modulo-tf = no.
      &else
          if  tg-fretes:checked in frame {&frame-name} then
              assign param-global.int-2 = 1.
          else
              assign param-global.int-2 = 0.
      &endif
  &ENDIF
  
    &IF '{&BF_DIS_VERSAO_EMS}' > '2.05' &THEN
        IF  tg-drawback:CHECKED IN FRAME {&FRAME-NAME} THEN
            ASSIGN param-global.log-modul-draw = YES.
        ELSE
            ASSIGN param-global.log-modul-draw = NO.
    &ELSE
        IF  tg-drawback:CHECKED IN FRAME {&FRAME-NAME} THEN
            ASSIGN SUBSTRING(param-global.char-2,22,1) = "1".
        ELSE
            ASSIGN SUBSTRING(param-global.char-2,22,1) = "".
    &ENDIF


  &IF DEFINED(BF_DIS_VERSAO_EMS) &THEN
      &IF {&BF_DIS_VERSAO_EMS} >= 2.02 &THEN
         if modulo-08:checked in frame {&frame-name} then
            assign param-global.modulo-08 = yes.
         else
            assign param-global.modulo-08 = no.
      &ENDIF
  &ENDIF
  
  &if '{&bf_dis_versao_ems}' >= '2.08' &then
  
      find first funcao exclusive-lock
           where funcao.cd-funcao = "SPP_TOTVSGFE" no-error.
      if  not avail funcao then do:
          create funcao.
          assign funcao.cd-funcao = "SPP_TOTVSGFE".
      end.
      assign funcao.ativo = tg-frete-emb:checked in frame {&frame-name}.
  &endif
  

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

  DISABLE param-global.modulo-pd param-global.modulo-ex 
          param-global.modulo-07 tg-drawback
          param-global.modulo-pv param-global.modulo-cv 
          param-global.modulo-re param-global.modulo-ce 
          param-global.modulo-cq param-global.modulo-cc 
          param-global.modulo-in WITH FRAME f-main.

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

  &IF "{&mguni_version}" < "2.07"  &THEN
  
      &if '{&BF_DIS_VERSAO_EMS}' >= '2.03' &then
          assign tg-fretes = param-global.modulo-tf.
      &else
          assign tg-fretes = (param-global.int-2 = 1).
      &endif
  &ENDIF
  
    &IF '{&BF_DIS_VERSAO_EMS}' > '2.05' &THEN
        ASSIGN tg-drawback = param-global.log-modul-draw.
    &ELSE
        IF SUBSTRING(param-global.char-2,22,1) = "" THEN
            ASSIGN tg-drawback = NO.
        ELSE
            ASSIGN tg-drawback = YES.             
    &ENDIF

/* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  &IF '{&bf_dis_versao_ems}' >= '2.062' &THEN 
      ASSIGN tg-embarque:CHECKED IN FRAME {&FRAME-NAME} = param-global.log-modul-eq.
  &ENDIF
  
  &if '{&bf_dis_versao_ems}' >= '2.08' &then
      assign tg-frete-emb:checked in frame {&frame-name} = can-find(first funcao 
                                                                    where funcao.cd-funcao = "SPP_TOTVSGFE"
                                                                      and funcao.ativo).
  &endif
  
  assign l-cotac-comp:checked in frame {&frame-name} = if substring(param-global.char-2,29,1) = "1" then yes else no
         tg-aquis-produt-rurais:CHECKED IN FRAME {&FRAME-NAME} = IF SUBSTRING(param-global.char-2,101,1) = "S":U THEN YES ELSE NO.

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
  
    def var l-modulo-ap as log no-undo.
    def var l-modulo-cr as log no-undo.
    def var l-modulo-cb as log no-undo.
    def var l-modulo-ae as log no-undo.
    def var l-modulo-pt as log no-undo.
    def var l-modulo-ct as log no-undo.
    def var l-modulo-fc as log no-undo.

    def var l-modulo-ft as log no-undo.
    def var l-modulo-of as log no-undo.
    def var l-modulo-pd as log no-undo.
    def var l-modulo-09 as log no-undo.
    def var l-modulo-10 as log no-undo.

    def var l-modulo-in as log no-undo.

    def var l-modulo-ce as log no-undo.
    def var l-modulo-cp as log no-undo.
    def var l-modulo-cc as log no-undo.
    def var l-modulo-re as log no-undo.
    def var l-modulo-cs as log no-undo.
    def var l-modulo-cq as log no-undo.
    def var l-modulo-cn as log no-undo.

    def var l-modulo-mi as log no-undo.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &IF DEFINED(BF_DIS_VERSAO_EMS) &THEN
     &IF {&BF_DIS_VERSAO_EMS} >= 2.02 &THEN
          find first base-cota no-lock no-error.
          if not avail base-cota then
             assign param-global.modulo-08:sensitive in frame {&frame-name} = yes.
      &ENDIF
  &ENDIF

/*****
    IF  param-global.modulo-ex = YES
    AND param-global.modulo-07 = YES THEN
        ASSIGN tg-drawback:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    ELSE
        ASSIGN tg-drawback:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
        
*****/        

        if  connected("mgdis")
        and connected("movdis") then do:
            run cdp/cd0101d.p (buffer param-global,
                               output l-modulo-ft,
                               output l-modulo-of,
                               output l-modulo-pd,
                               output l-modulo-09,
                               output l-modulo-10).

            assign param-global.modulo-ft:sensitive in frame {&frame-name} = l-modulo-ft
                   param-global.modulo-of:sensitive in frame {&frame-name} = l-modulo-of 
                   param-global.modulo-pd:sensitive in frame {&frame-name} = l-modulo-pd
                   param-global.modulo-09:sensitive in frame {&frame-name} = l-modulo-09
                   param-global.modulo-10:sensitive in frame {&frame-name} = l-modulo-10. 

            &IF "{&mguni_version}" < "2.07"  &THEN
            
                &IF '{&BF_DIS_VERSAO_EMS}' >= '2.03' &THEN
                    assign tg-fretes           = (param-global.int-2 = 1)
                           tg-fretes:sensitive = yes.
                &ELSE
                    assign tg-fretes:sensitive = no. 
                &ENDIF
            &ENDIF
          
        end.

        if  connected("mgind")
        and connected("movind") then do:
            run cdp/cd0101e.p (buffer param-global,
                               output l-modulo-ce,
                               output l-modulo-cp,
                               output l-modulo-cc,
                               output l-modulo-re,
                               output l-modulo-cs,
                               output l-modulo-cq,
                               output l-modulo-cn).

            assign param-global.modulo-ce:sensitive in frame {&frame-name} = l-modulo-ce
                   param-global.modulo-cc:sensitive in frame {&frame-name} = l-modulo-cc 
                   param-global.modulo-re:sensitive in frame {&frame-name} = l-modulo-re
                   param-global.modulo-cq:sensitive in frame {&frame-name} = l-modulo-cq
                   param-global.modulo-cn:sensitive in frame {&frame-name} = l-modulo-cn.
        end.


       if  connected ("mginv") then do:
            run cdp/cd0101f.p (buffer param-global,
                               output l-modulo-in).
            assign param-global.modulo-in:sensitive in frame {&frame-name} = l-modulo-in.
        end.

    /*se version > 2.06, campo tg-fretes nÆo ser  listado na tela*/
    &IF "{&mguni_version}" > "2.06"  &THEN
        /*desabilita tg-fretes*/
        ASSIGN tg-fretes:SENSITIVE in frame {&frame-name} = NO
               tg-fretes:VISIBLE   in frame {&frame-name} = NO.

        /*reposiciona campo log-modul-cm, para ficar onde atualmente est  posicionado o tg-fretes na tela*/
        ASSIGN param-global.log-modul-cm:ROW in frame {&frame-name} = 9.58.
        
    &ENDIF
    
    &if '{&bf_dis_versao_ems}' >= '2.08'  &then
        assign tg-frete-emb:row in frame {&frame-name} = param-global.log-modul-cm:row + 0.67.
    &else 
        assign tg-frete-emb:sensitive in frame {&frame-name} = no
               tg-frete-emb:visible   in frame {&frame-name} = no.
    &endif
        
    &IF DEFINED (BF_FIN_FIXAR_PARAM) &THEN

        ASSIGN rect-5:HEIGHT IN FRAME {&FRAME-NAME}  = 6.50
               rect-6:VISIBLE IN FRAME {&FRAME-NAME} = YES.
               
        ENABLE param-global.modulo-ge 
               param-global.modulo-ca WITH FRAME {&FRAME-NAME}.

    &ELSE
    
        ASSIGN rect-5:HEIGHT IN FRAME {&FRAME-NAME}  = 15.00
               rect-6:VISIBLE IN FRAME {&FRAME-NAME} = NO.
               
        HIDE param-global.modulo-ge 
             param-global.modulo-ca IN FRAME {&FRAME-NAME}.

    &ENDIF
    
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
  {utp/ut-liter.i Cotas * R}
  assign param-global.modulo-08:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i Importa‡Æo}
  assign param-global.modulo-07:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Descontos_e_Bonifica‡äes * R}
  assign param-global.modulo-09:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Administra‡Æo_do_Pre‡o_de_Venda * R}
  assign param-global.modulo-10:label in frame {&frame-name} = trim(return-value). 
  
  {utp/ut-liter.i Embarques * R}
  assign tg-embarque:label in frame {&FRAME-NAME} = trim(return-value).
  {utp/ut-liter.i M¢dulo_de_Embarque}
  assign tg-embarque:help in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Cota‡äes_de_Compra * R}
  assign l-cotac-comp:label in frame {&FRAME-NAME} = trim(return-value).
  {utp/ut-liter.i M¢dulo_de_Cota‡äes_de_Compras}
  assign l-cotac-comp:help in frame {&frame-name} = trim(return-value).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-handle V-table-Win 
PROCEDURE pi-recebe-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param h-v01ad205 as handle no-undo.

assign h_v01ad205 = h-v01ad205.

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
  {src/adm/template/snd-list.i "param-global"}

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
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

