&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i V06AD229 2.00.00.042 } /*** "010042" 03/06/2024 15:27:49  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V06AD229 MUT}
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

{cdp/cdcfgdis.i}
{include/i_dbvers.i}

def var v-row-parent   as rowid                no-undo.
def var c-cgc-formato  as char                 no-undo.
def var c-verifica-cgc as char format "x(20)"  no-undo.
def var i-cod-indir    as integer              no-undo.
def var i-natureza     as integer  initial 1   no-undo.
def var c-formato      as char                 no-undo.

def var v09ad229       as handle no-undo.

define buffer b-repres for repres.

/*VARIµVEIS LOCALIZAÄ«O EQUADOR*/
DEFINE VARIABLE h-boec013   AS HANDLE      NO-UNDO.
DEF VAR i-tipo-regime AS INT NO-UNDO.
DEF VAR i-cdn-doc     AS INT FORMAT ">>9" NO-UNDO.
DEF VAR c-nro-doc     AS CHAR FORMAT "x(13)" NO-UNDO.
DEFINE VARIABLE h-handle-container AS HANDLE      NO-UNDO.
/*FIM - VARIµVEIS LOCALIZAÄ«O EQUADOR*/

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
&Scoped-define EXTERNAL-TABLES repres
&Scoped-define FIRST-EXTERNAL-TABLE repres


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR repres.
/* Standard List Definitions                                            */
&SCOPED-DEFINE ENABLED-FIELDS repres.nome-ab-reg repres.natureza repres.cgc ~
repres.inscr-est repres.ins-municipal repres.nom-usuar-interm
&SCOPED-DEFINE ENABLED-TABLES repres
&SCOPED-DEFINE FIRST-ENABLED-TABLE repres
&SCOPED-DEFINE ENABLED-OBJECTS log-consid-repres-cotas RECT-1 rt-mold
&SCOPED-DEFINE DISPLAYED-FIELDS repres.nome-ab-reg repres.natureza ~
    repres.cgc repres.inscr-est repres.ins-municipal repres.nom-usuar-interm
&SCOPED-DEFINE DISPLAYED-TABLES repres
&SCOPED-DEFINE FIRST-DISPLAYED-TABLE repres
&SCOPED-DEFINE DISPLAYED-OBJECTS dt-deslig ind-situacao ~
    log-consid-repres-cotas log-intermediador

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
DEFINE VARIABLE dt-deslig AS DATE FORMAT "99/99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY 1 NO-UNDO.

DEFINE VARIABLE text-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS TEXT 
     SIZE 16.43 BY .63 NO-UNDO.

DEFINE VARIABLE ind-situacao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
        "Ativo", 1,
        "Inativo", 2
     SIZE 18 BY .83 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 25.72 BY 3.83.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75.43 BY 7.21.

DEFINE VARIABLE log-consid-repres-cotas AS LOGICAL INITIAL yes 
     LABEL "Considera Representante Base Rateio Cotas" 
     VIEW-AS TOGGLE-BOX
     SIZE 45 BY .83 NO-UNDO.

DEFINE VARIABLE log-intermediador AS LOGICAL INITIAL no 
     LABEL "Intermediador" 
     VIEW-AS TOGGLE-BOX
     SIZE 12 BY .54 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     repres.nome-ab-reg AT ROW 1.25 COL 53.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     repres.natureza AT ROW 1.71 COL 5.43 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
            "Pessoa Fisica", 1,
            "Pessoa Juridica", 2,
            "Estrangeiro", 3,
            "Trading", 4
          SIZE 20 BY 3.17
     repres.cgc AT ROW 2.25 COL 53.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.29 BY .88
     repres.inscr-est AT ROW 3.25 COL 53.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.29 BY .88
     repres.ins-municipal AT ROW 4.25 COL 53.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.29 BY .88
     dt-deslig AT ROW 5.25 COL 53.14 COLON-ALIGNED
     ind-situacao AT ROW 5.42 COL 10.14 NO-LABEL
     log-consid-repres-cotas AT ROW 6.32 COL 2.50 HELP
          "Considera representante na base de rateio de Cotas"
     log-intermediador AT ROW 7.33 COL 2.50
     repres.nom-usuar-interm AT ROW 7.19 COL 38 COLON-ALIGNED
         VIEW-AS FILL-IN 
         SIZE 35.50 BY .88
     text-1 AT ROW 1.08 COL 4.29 NO-LABEL
     RECT-1 AT ROW 1.25 COL 2.57
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.repres
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
         HEIGHT             = 6.5
         WIDTH              = 75.43.
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

/* SETTINGS FOR FILL-IN dt-deslig IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET ind-situacao IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       log-consid-repres-cotas:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN text-1 IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
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

&Scoped-define SELF-NAME repres.cgc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL repres.cgc V-table-Win
ON ENTRY OF repres.cgc IN FRAME f-main /* CGC/CPF */
DO:
   find first param-global no-lock no-error.

   do  with frame {&FRAME-NAME}:
       if  input frame {&frame-name} repres.natureza = 1 then do:
           assign repres.cgc:format in frame {&FRAME-NAME} = param-global.formato-id-pessoal.
       end.
       else do:
           if  input frame {&frame-name} repres.natureza = 2 then do:
               assign repres.cgc:format in frame {&FRAME-NAME} = param-global.formato-id-federal.
           end.
           else do:
               assign repres.cgc:format  in frame {&FRAME-NAME} = "x(19)".
               assign repres.cgc:screen-value in frame {&frame-name} = "".
           end.
       end.
   end.

   do  with frame {&FRAME-NAME}:
        if repres.cgc:screen-value = "" then do:
           assign repres.cgc:screen-value in frame {&FRAME-NAME} = "".
        end.
        if  repres.cgc:screen-value <> "" then do:      
            if  i-natureza = 1 then do:
                assign repres.cgc:format in frame {&FRAME-NAME} = param-global.formato-id-pessoal.
            end.
            else do:
                if  i-natureza = 2 then do:
                    assign repres.cgc:format in frame {&FRAME-NAME} = param-global.formato-id-federal.
                end.
                else do:
                    assign repres.cgc:format in frame {&FRAME-NAME} = "x(19)".
                end.
            end.
        end.
   end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL repres.cgc V-table-Win
ON LEAVE OF repres.cgc IN FRAME f-main /* CGC/CPF */
DO:
   {cdp/cd9998.i}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dt-deslig
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dt-deslig V-table-Win
ON LEAVE OF dt-deslig IN FRAME f-main
DO:
  &if "{&mgadm_version}" >= "2.04" &then 
     run pi-atz-dt-deslig in v09ad229 (INPUT dt-deslig:screen-value in frame {&frame-name}).
  &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ind-situacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ind-situacao V-table-Win
ON VALUE-CHANGED OF ind-situacao IN FRAME f-main
DO: 
    &if "{&mgadm_version}" >= "2.04" &then 
        if ind-situacao:screen-value in frame {&frame-name} = string(1) then do:
            assign dt-deslig:screen-value in frame {&FRAME-NAME} = "?".
            assign dt-deslig:sensitive in frame {&frame-name} = no.  
        end. 
        else do:
            if repres.dt-deslig = ? then
                assign dt-deslig:screen-value in frame {&frame-name} = string(today).
            else
                assign dt-deslig:screen-value in frame {&frame-name} = string(repres.dt-deslig).

            assign dt-deslig:sensitive in frame {&frame-name} = yes.  
        end.
    &endif

    apply "leave" to dt-deslig in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME log-intermediador
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL log-intermediador V-table-Win
ON VALUE-CHANGED OF log-intermediador IN FRAME f-main
DO:                                       
   IF log-intermediador:CHECKED IN FRAME {&FRAME-NAME} THEN DO:
      ASSIGN repres.nom-usuar-interm:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
   END.  
   ELSE DO:
      ASSIGN repres.nom-usuar-interm:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME repres.natureza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL repres.natureza V-table-Win
ON VALUE-CHANGED OF repres.natureza IN FRAME f-main /* Nat */
DO:
     assign i-natureza = 1.
     assign i-natureza = input frame {&frame-name} repres.natureza.
     apply 'entry' to repres.cgc in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME repres.nome-ab-reg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL repres.nome-ab-reg V-table-Win
ON F5 OF repres.nome-ab-reg IN FRAME f-main /* Regi∆o Abreviado */
DO:
assign l-implanta = yes.
{include/zoomvar.i &prog-zoom = "adzoom/z01ad218.w"
                   &campo=repres.nome-ab-reg
                   &campozoom=nome-ab-reg}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL repres.nome-ab-reg V-table-Win
ON MOUSE-SELECT-DBLCLICK OF repres.nome-ab-reg IN FRAME f-main /* Regi∆o Abreviado */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

{utp/ut-rtlbl.i mgadm repres natureza text-1}

{utp/ut-liter.i Regi∆o * L}
assign repres.nome-ab-reg:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Data_Desligamento}
assign dt-deslig:label in frame {&frame-name} = trim(return-value).

if repres.nome-ab-reg:load-mouse-pointer  ("image/lupa.cur") in frame {&frame-name} then.


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
  {src/adm/template/row-list.i "repres"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "repres"}

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

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  {utp/ut-rtlbl.i mgadm repres natureza text-1}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-apply-entry V-table-Win 
PROCEDURE local-apply-entry :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  apply 'value-changed' to repres.natureza in frame {&frame-name}.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'apply-entry':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /*Localizaá∆o Equador*/
  IF i-pais-impto-usuario = 21 THEN DO:
      RUN pi-retorna-valores-localiz IN h-handle-container (OUTPUT i-tipo-regime,
                                                            OUTPUT i-cdn-doc,
                                                            OUTPUT c-nro-doc,
                                                            OUTPUT h-boec013).
      IF c-nro-doc <> "" THEN
          ASSIGN repres.cgc:FORMAT IN FRAME {&FRAME-NAME} = "x(19)" /*Linha para evitar erro de formato, visto que o c-nro-doc Ç formatado corretamente no local/ecu/ecu0103.w*/
                 repres.cgc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-nro-doc.      
  END.
  
  run pi-validate.
  if  return-value = 'adm-error' then
      return 'adm-error'.

  /*--- Valida Formato Conta Var Compras -----*/
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
      &IF "{&bf_dis_versao_ems}" >= "2.06" &THEN
          IF param-global.modulo-08 = YES THEN DO WITH FRAME {&FRAME-NAME}:
              IF log-consid-repres-cotas:CHECKED = YES THEN
                  ASSIGN repres.log-consid-repres-cotas = YES.
              ELSE
                  ASSIGN repres.log-consid-repres-cotas = NO.
          END.
      &ELSE
          IF param-global.modulo-08 = YES THEN DO WITH FRAME {&FRAME-NAME}:
              IF log-consid-repres-cotas:CHECKED = YES THEN
                  ASSIGN SUBSTR(repres.char-1,1,1) = "".
              ELSE
                  ASSIGN SUBSTR(repres.char-1,1,1) = "1".
          END.
      &ENDIF
  &ENDIF
  
  IF log-intermediador:CHECKED = YES THEN
      ASSIGN repres.log-interm = YES.
  ELSE
      ASSIGN repres.log-interm = NO.

  IF log-intermediador:CHECKED IN FRAME {&FRAME-NAME} = NO THEN DO:
     ASSIGN repres.nom-usuar-interm:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
            repres.nom-usuar-interm = "".
  END.

  &IF "{&mgadm_version}" >= "2.04" &THEN
     ASSIGN repres.dt-deslig = DATE(dt-deslig:SCREEN-VALUE IN FRAME {&FRAME-NAME})
            repres.ind-situacao = INT(ind-situacao:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
  &ENDIF
  
  /*Localizaá∆o Equador*/
  IF i-pais-impto-usuario = 21 THEN DO:
      IF VALID-HANDLE (h-boec013) 
          AND c-nro-doc <> "" THEN DO:
          RUN pi-cria-dados-localiz      IN h-boec013 (INPUT repres.cod-rep,
                                                       INPUT i-tipo-regime,
                                                       INPUT i-cdn-doc,
                                                       INPUT c-nro-doc).
          IF RETURN-VALUE = "NOK":U THEN
              RETURN "adm-error":U.
          ELSE DO:
              ASSIGN repres.cgc = c-nro-doc.
          END.
      END.
  END.


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

  DISABLE log-intermediador WITH FRAME {&FRAME-NAME}.

  IF param-global.modulo-08 = YES THEN
      DISABLE log-consid-repres-cotas WITH FRAME {&FRAME-NAME}.

  /* Code placed here will execute AFTER standard behavior.    */
  &if "{&mgadm_version}" >= "2.04" &then 
      assign ind-situacao:sensitive in frame {&frame-name} = no
             dt-deslig:sensitive in frame {&frame-name} = no. 
  &endif

  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  IF i-pais-impto-usuario = 21 THEN DO: 
      run pi-habilita-localiz in h-handle-container (INPUT YES).
      RUN pi-limpa-dados-localiz IN h-handle-container.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
    Purpose:     Override standard ADM method
    Notes:       
------------------------------------------------------------------------------*/
    if  avail repres then do with frame {&frame-name}:
        if repres.cgc <> "" 
            /*O formato do cgc para o pa°s Equador Ç tratado no programa localizado local/ecu/ecu0103.w*/
            AND i-pais-impto-usuario <> 21 /*Equador*/ then do:            
            if  repres.natureza = 1 then do:
                assign repres.cgc:format in frame {&FRAME-NAME} = param-global.formato-id-pessoal.
            end.
            else do:
                if  repres.natureza = 2 then do:
                    assign repres.cgc:format       in frame {&FRAME-NAME} = param-global.formato-id-federal.
                end.
                else do:
                    assign repres.cgc:format       in frame {&FRAME-NAME} = "x(19)".
                end.
            end.
        end.    
    end.

	RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
	
    apply 'value-changed' to repres.natureza in frame {&frame-name}.    

    if  avail repres then do with frame {&frame-name}:
        &if "{&mgadm_version}" >= "2.04" &then 
            assign ind-situacao:screen-value in frame {&frame-name} = string(repres.ind-situacao) 
                   dt-deslig:screen-value in frame {&FRAME-NAME}    = string(repres.dt-deslig).
        &endif
    end.

    &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
        &IF "{&bf_dis_versao_ems}" >= "2.06" &THEN
            IF param-global.modulo-08 = YES THEN DO WITH FRAME {&FRAME-NAME}:
                IF repres.log-consid-repres-cotas THEN
                    ASSIGN log-consid-repres-cotas:CHECKED = YES.
                ELSE
                    ASSIGN log-consid-repres-cotas:CHECKED = NO.
            END.
        &ELSE
            IF param-global.modulo-08 = YES THEN DO WITH FRAME {&FRAME-NAME}:
                IF SUBSTR(repres.char-1,1,1) = "" THEN
                    ASSIGN log-consid-repres-cotas:CHECKED = YES.
                ELSE
                    ASSIGN log-consid-repres-cotas:CHECKED = NO.
            END.
        &ENDIF
    &ENDIF
    
    IF repres.log-interm THEN
        ASSIGN log-intermediador:CHECKED = YES.
    ELSE
        ASSIGN log-intermediador:CHECKED = NO.

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
  /* Dispatch standard ADM method.*/

  ENABLE log-intermediador WITH FRAME {&FRAME-NAME}.

  &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
    IF param-global.modulo-08 = YES THEN DO:
        ENABLE log-consid-repres-cotas ind-situacao WITH FRAME {&FRAME-NAME}.
        IF ind-situacao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(1) THEN DO:
            ASSIGN dt-deslig:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "?".
            ASSIGN dt-deslig:SENSITIVE IN FRAME {&FRAME-NAME} = NO.  
        END.
        ELSE DO:
            ASSIGN dt-deslig:SENSITIVE IN FRAME {&FRAME-NAME} = YES.  
        END.
    END.
  &ENDIF
  
  IF log-intermediador:CHECKED IN FRAME {&FRAME-NAME} THEN DO:
     ASSIGN repres.nom-usuar-interm:SENSITIVE IN FRAME {&FRAME-NAME} = YES.  
  END.
  ELSE DO:
     ASSIGN repres.nom-usuar-interm:SENSITIVE IN FRAME {&FRAME-NAME} = NO.  
  END.

  if NOT can-find (
      first funcao 
      where funcao.cd-funcao = "Repres 2.00" 
      or funcao.cd-funcao = "Representantes 2.00") then do:

      /* Code placed here will execute AFTER standard behavior.    */
      &if "{&mgadm_version}" >= "2.04" &then 
              assign ind-situacao:sensitive in frame {&frame-name} = yes.  
              if ind-situacao:screen-value in frame {&frame-name} = string(1) then do:
                  assign dt-deslig:screen-value in frame {&FRAME-NAME} = "?".
                  assign dt-deslig:sensitive in frame {&frame-name} = no.  
              end.
              else do:
                  assign dt-deslig:sensitive in frame {&frame-name} = yes.  
              end.
      &endif

      RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

      if adm-new-record = yes then
      &if  defined(ADM-MODIFY-FIELDS) &then
          enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
      &endif
      
      ENABLE repres.nome-ab-reg with frame {&frame-name}.
  END.

  IF i-pais-impto-usuario = 21 THEN
      run pi-habilita-localiz in h-handle-container (INPUT NO).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  find first param-global no-lock no-error.

  assign repres.cgc:label in frame {&FRAME-NAME} = param-global.label-cgc.

  &if "{&mgadm_version}" >= "2.04" &then 
     assign ind-situacao:hidden in frame {&frame-name} = no
            dt-deslig:hidden in frame {&frame-name} = no.
  &else
     assign ind-situacao:hidden in frame {&frame-name} = yes
            dt-deslig:hidden in frame {&frame-name} = yes.
  &endif


  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  {utp/ut-rtlbl.i mgadm repres natureza text-1}

  &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
      IF param-global.modulo-08 = YES THEN
          ASSIGN log-consid-repres-cotas:HIDDEN in frame {&FRAME-NAME} = FALSE.
  &ENDIF
  
  IF i-pais-impto-usuario = 21 THEN
      ASSIGN repres.cgc:HIDDEN IN FRAME {&FRAME-NAME} = YES.

  {utp/ut-liter.i "Identificaá∆o_no_Intermediador"}
  ASSIGN repres.nom-usuar-interm:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.

  {utp/ut-liter.i "Identificaá∆o_do_perfil_do_vendedor_no_site_do_intermediador"}
  ASSIGN repres.nom-usuar-interm:HELP IN FRAME {&FRAME-NAME} = RETURN-VALUE.

  {utp/ut-liter.i "Indica_que_este_representante_Ç_um_intermediador"}
  ASSIGN log-intermediador:HELP IN FRAME {&FRAME-NAME} = RETURN-VALUE.

  {utp/ut-liter.i "Indica_se_o_representante_est†_ativo_ou_inativo"}
  ASSIGN ind-situacao:HELP IN FRAME {&FRAME-NAME} = RETURN-VALUE.

  IF i-pais-impto-usuario <> 1 THEN
     ASSIGN repres.nom-usuar-interm:HIDDEN IN FRAME {&FRAME-NAME} = YES
            log-intermediador:HIDDEN   IN FRAME {&FRAME-NAME} = YES.
  ELSE 
     ASSIGN repres.nom-usuar-interm:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-view V-table-Win 
PROCEDURE local-view :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'view':U ) .

  apply 'value-changed' to repres.natureza in frame {&frame-name}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-natureza V-table-Win 
PROCEDURE pi-busca-natureza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM p-natureza-repre LIKE repres.natureza NO-UNDO.

ASSIGN p-natureza-repre = INT(repres.natureza:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-handle-v09ad229 V-table-Win 
PROCEDURE pi-handle-v09ad229 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-v09ad229 as handle no-undo.

assign v09ad229 = p-v09ad229.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-handle-container V-table-Win 
PROCEDURE pi-recebe-handle-container :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter h-container as handle no-undo.

assign h-handle-container  = h-container.

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
DEFINE VARIABLE l-valida-cgc AS LOGICAL    NO-UNDO.

  {include/i-vldfrm.i}

  /*Para o Pa°s Equador n∆o Ç necess†rio fazer validaá∆o de formato, 
  isso Ç feito no programa localizado*/
  IF i-pais-impto-usuario <> 21 THEN DO:
      if  repres.cgc:screen-value <> ""
      and i-natureza <> 3 
      and i-natureza <> 4 then do:    
          if  i-natureza = 1 then
              assign repres.cgc:format in frame {&FRAME-NAME} =  param-global.formato-id-pessoal
                     c-formato = input frame {&FRAME-NAME} repres.cgc no-error.    
            if  i-natureza = 2 then
                assign repres.cgc:format in frame {&FRAME-NAME} =  param-global.formato-id-federal
                       c-formato = input frame {&FRAME-NAME} repres.cgc no-error.
      end.               
      else
          assign repres.cgc:format in frame {&FRAME-NAME} =  "x(19)"
                 c-formato = input frame {&FRAME-NAME} repres.cgc no-error.

      if  ERROR-STATUS:get-number(1) <> 0 then do:
          {include/i-vldprg.i}
          run utp/ut-msgs.p (input "show",
                             input 2744,
                             input "").
          apply 'entry' to repres.cgc in frame {&frame-name}.
          return "adm-error":U.
      end.
  END.

  ASSIGN l-valida-cgc = YES.

  /*CHAMADA UPC*/
  IF c-nom-prog-upc-mg97 <> "" THEN DO:
      RUN VALUE(c-nom-prog-upc-mg97) (INPUT "VALIDA-CGC",
                                      INPUT "VIEWER",
                                      INPUT THIS-PROCEDURE,
                                      INPUT FRAME {&FRAME-NAME}:HANDLE,
                                      INPUT "repres",
                                      INPUT ROWID(repres)).
      IF RETURN-VALUE = "NOK":U THEN  
          ASSIGN l-valida-cgc = NO.
  END.
  /*FIM CHAMADA UPC*/

  IF l-valida-cgc THEN DO:

      RUN get-attribute('adm-new-record':U).
      if  return-value = 'yes':U then do:
         /*---- Verifica se o CGC j† existe para outro Representante ------*/
          if param-global.bloqueio-cgc = 3 then do:
              if i-natureza <> 3 
              and i-natureza <> 4 then do :
                  find first b-repres no-lock
                       where b-repres.cgc     = input frame {&FRAME-NAME} repres.cgc no-error.

                   if  avail b-repres then do:
                       {include/i-vldprg.i}
                       run utp/ut-msgs.p (input "show",
                                          input 16908,
                                          input "").
                       apply 'entry' to repres.cgc in frame {&frame-name}.
                       return "adm-error":U.
                  end.
              end.   
          end.
          if param-global.bloqueio-cgc = 2 then do:
              if i-natureza <> 3 
              and i-natureza <> 4 then do :
                  find first b-repres no-lock
                       where b-repres.cgc     = input frame {&FRAME-NAME} repres.cgc no-error.

                   if  avail b-repres then do:
                       {include/i-vldprg.i}
                       run utp/ut-msgs.p (input "show",
                                          input 16908,
                                          input "").
                  end.
              end.   
          end.
      end.
      else do:    
          /*---- Verifica se o CGC j† existe para outro Representante ------*/
          if param-global.bloqueio-cgc = 3 then do:
              if i-natureza <> 3 
              and i-natureza <> 4 then do :
                  find first b-repres no-lock
                       where b-repres.cgc     =  input frame {&FRAME-NAME} repres.cgc
                       and   rowid(b-repres)  <> rowid(repres) no-error.

                   if  avail b-repres then do:
                       {include/i-vldprg.i}
                       run utp/ut-msgs.p (input "show",
                                          input 16908,
                                          input "").
                       apply 'entry' to repres.cgc in frame {&frame-name}.
                       return "adm-error":U.
                  end.
              end.   
          end.
          if param-global.bloqueio-cgc = 2 then do:
              if i-natureza <> 3 
              and i-natureza <> 4 then do :
                  find first b-repres no-lock
                       where b-repres.cgc     =  input frame {&FRAME-NAME} repres.cgc
                       and   rowid(b-repres)  <> rowid(repres) no-error.

                   if  avail b-repres then do:
                       {include/i-vldprg.i}
                       run utp/ut-msgs.p (input "show",
                                          input 16908,
                                          input "").
                  end.
              end.   
          end.
      end.
  END.

  IF i-pais-impto-usuario = 1 THEN DO:
     IF log-intermediador:CHECKED IN FRAME {&FRAME-NAME} = YES AND repres.nom-usuar-interm:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 57254,
                           INPUT "Campo intermediador marcado." + "~~" + "Quando o representante estiver definido como intermediador, Ç obrigat¢rio preencher o campo Nome Intermediador.").
        APPLY 'ENTRY' TO repres.nom-usuar-interm IN FRAME {&FRAME-NAME}.
        RETURN 'ADM-ERROR':U.
     END.
  END.

  find regiao where regiao.nome-ab-reg = input frame {&frame-name} repres.nome-ab-reg no-lock no-error.
  if  not avail regiao then do:
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show" ,
                         input  3886,
                         input "").
      apply "entry" to repres.nome-ab-reg in frame {&frame-name}.
      Return 'adm-error':U.
  end.                    


  if  input frame {&FRAME-NAME} repres.natureza = 2 then do:
      if  param-global.id-estadual-obrigatorio = yes then do:               
          if  input frame {&FRAME-NAME} repres.inscr-est = "" or
              input frame {&FRAME-NAME} repres.inscr-est = ?  then do:
              {include/i-vldprg.i}
              run utp/ut-msgs.p (input "show",
                                 input 972   ,
                                 input "").
              apply 'entry' to repres.inscr-est in frame {&FRAME-NAME}.
              return "adm-error":U.                   
          end.
      end.
  end.

  find empresa where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.
  if  avail empresa and empresa.pais = "Brasil" then do: 
      do  on error undo, return 'adm-error':
          run cdp/cd6666.p (input input frame {&FRAME-NAME} repres.cgc, 
                            input input frame {&FRAME-NAME} repres.natureza).
          if  return-value = 'NOK' then do:
              {include/i-vldprg.i}
              apply 'entry' to repres.cgc in frame {&frame-name}.
              return "adm-error":U.
          end.
      end.          
  end.

  IF i-pais-impto-usuario = 21 THEN DO:
      RUN pi-retorna-valores-localiz IN h-handle-container (OUTPUT i-tipo-regime,
                                                            OUTPUT i-cdn-doc,
                                                            OUTPUT c-nro-doc,
                                                            OUTPUT h-boec013).
      {utp/ut-liter.i Dados_Localizaá∆o * }
      IF c-nro-doc = "" THEN DO:
          IF AVAIL repres THEN DO:
              IF NOT VALID-HANDLE(h-boec013) THEN
                  RUN local/ecu/ec2bo/boec013.p PERSISTENT SET h-boec013.
              
              RUN openQueryStatic IN h-boec013 (INPUT "Main":U).
              RUN goToKey IN h-boec013 (INPUT repres.cod-rep).
              
              IF RETURN-VALUE = "NOK" THEN DO:
                  {utp/ut-liter.i Dados_Localizaá∆o * }
                  run utp/ut-msgs.p (input "show",
                                     input 265,
                                     input RETURN-VALUE).
                  return "adm-error":U.
              END.
          END.
          ELSE DO:
              {utp/ut-liter.i Dados_Localizaá∆o * }
              run utp/ut-msgs.p (input "show",
                                 input 265,
                                 input RETURN-VALUE).
              return "adm-error":U.
          end.
      end.          
  end.

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
  {src/adm/template/snd-list.i "repres"}

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

