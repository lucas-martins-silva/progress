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
{include/i-prgvrs.i V07AD205 2.00.00.062 } /*** "010062" 26/02/2026 08:32:25 ***/


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


  /*definicao de variaveis*/

DEF NEW GLOBAL SHARED VAR v_hdl_license_manager AS HANDLE NO-UNDO.

/*definicao de variaveis*/
def new global shared var h-btb432za as HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE v_log_eai_ativado  AS LOGICAL NO-UNDO INITIAL NO.
DEFINE NEW GLOBAL SHARED VARIABLE v_log_eai2_ativado AS LOGICAL NO-UNDO INITIAL NO.

/* Parameters Definitions ---                                           */
{cdp/cdcfgdis.i} /* preprocessadores */
/*EAI*/
{include/i_dbeai.i}

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

DEF VAR l-totvs-colaboracao AS LOG INITIAL NO NO-UNDO.
DEF VAR c-slot-disponivel   AS CHAR           NO-UNDO.
DEF VAR c-lista AS CHAR NO-UNDO.
/* DEF VAR h-btb432za          AS HANDLE         NO-UNDO. */

/*Web Service - TAF*/
DEF VAR h-webservicetaf     AS HANDLE   NO-UNDO.
DEF VAR l-conexao           AS LOG      NO-UNDO.
DEF VAR v-senha-long        AS LONGCHAR NO-UNDO.       
DEF VAR v-senha-mem         AS MEMPTR   NO-UNDO.          
DEF VAR v-senha-encode-long AS LONGCHAR NO-UNDO.
/*Fim TAF*/

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
&Scoped-Define ENABLED-FIELDS param-global.data-2 
&Scoped-define ENABLED-TABLES param-global
&Scoped-define FIRST-ENABLED-TABLE param-global
&Scoped-Define ENABLED-OBJECTS tg-totvs-colab cb-versao-tc rs-layout tg-eai ~
tg-eai2 tg-sop tg-e-commerce fl-cod-url fl-porta bt-conect-taf fl-resource ~
fl-usuar fl-senha tg-tpf tg-wms-saas tg-tms-saas RECT-1 RECT-14 RECT-15 RECT-19 RECT-20 ~
RECT-2 
&Scoped-Define DISPLAYED-FIELDS param-global.data-2 
&Scoped-define DISPLAYED-TABLES param-global
&Scoped-define FIRST-DISPLAYED-TABLE param-global
&Scoped-Define DISPLAYED-OBJECTS tg-totvs-colab cb-versao-tc rs-layout ~
tg-eai tg-eai2 tg-sop tg-e-commerce fl-cod-url fl-porta fl-resource ~
fl-usuar fl-senha tg-tpf tg-wms-saas tg-tms-saas

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
DEFINE BUTTON bt-conect-taf 
     IMAGE-UP FILE "image/im-autom.bmp":U
     IMAGE-INSENSITIVE FILE "image/im-autom.bmp":U
     LABEL "" 
     SIZE 4 BY 1.13.

DEFINE VARIABLE cb-versao-tc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Vers∆o" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "1.0","2.0" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE fl-cod-url AS CHARACTER FORMAT "X(100)":U 
     LABEL "URL" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE fl-porta AS CHARACTER FORMAT "X(05)":U 
     LABEL "Porta" 
     VIEW-AS FILL-IN 
     SIZE 6.57 BY .88 NO-UNDO.

DEFINE VARIABLE fl-resource AS CHARACTER FORMAT "X(50)":U 
     LABEL "Resource" 
     VIEW-AS FILL-IN 
     SIZE 25.29 BY .88 NO-UNDO.

DEFINE VARIABLE fl-senha AS CHARACTER FORMAT "X(50)":U 
     LABEL "Senha" 
     VIEW-AS FILL-IN 
     SIZE 25.29 BY .88 NO-UNDO.

DEFINE VARIABLE fl-usuar AS CHARACTER FORMAT "X(50)":U 
     LABEL "Usu†rio" 
     VIEW-AS FILL-IN 
     SIZE 25.29 BY .88 NO-UNDO.

DEFINE VARIABLE rs-layout AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "SEFAZ", 1,
"NeoGridFiscalDoc", 2
     SIZE 24 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37 BY 4.5.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43.57 BY 13.5.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37 BY 5.5.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41 BY 8.54.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 37 BY 3.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 39 BY 3.25.

DEFINE VARIABLE tg-e-commerce AS LOGICAL INITIAL no 
     LABEL "E-commerce" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .83 NO-UNDO.

DEFINE VARIABLE tg-eai AS LOGICAL INITIAL no 
     LABEL "EAI 1" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE tg-eai2 AS LOGICAL INITIAL no 
     LABEL "EAI 2" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE tg-sop AS LOGICAL INITIAL no 
     LABEL "Sales and Operation Planning" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .83 NO-UNDO.

DEFINE VARIABLE tg-totvs-colab AS LOGICAL INITIAL no 
     LABEL "Totvs Colaboraá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE tg-tpf AS LOGICAL INITIAL no 
     LABEL "Totvs Processos Fiscais" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .83 NO-UNDO.

DEFINE VARIABLE tg-wms-saas AS LOGICAL INITIAL no 
     LABEL "WMS Externo" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .83 NO-UNDO.

DEFINE VARIABLE tg-tms-saas AS LOGICAL INITIAL no 
     LABEL "TMS Externo" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .83 NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     tg-totvs-colab AT ROW 1.83 COL 13
     param-global.data-2 AT ROW 13 COL 79 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 1.57 BY 1
     cb-versao-tc AT ROW 2.83 COL 11 COLON-ALIGNED
     rs-layout AT ROW 3.83 COL 13 NO-LABEL
     tg-eai AT ROW 9.83 COL 7.43
     tg-eai2 AT ROW 10.75 COL 7.43
     tg-sop AT ROW 11.67 COL 7.43
     tg-e-commerce AT ROW 12.58 COL 7.43 HELP
          "Integraá∆o com o E-commerce (TOTVS Connector)"
     fl-cod-url AT ROW 3.38 COL 48.43 COLON-ALIGNED HELP
          "Endereáo disponibilizado pelo Web Service TAF"
     fl-porta AT ROW 4.38 COL 48.43 COLON-ALIGNED HELP
          "Porta disponibilizada pelo Web Service TAF"
     bt-conect-taf AT ROW 4.29 COL 57 HELP
          "Executa o teste de conex∆o com o Web Service - TAF"
     fl-resource AT ROW 6.67 COL 48.43 COLON-ALIGNED HELP
          "Resource disponibilizado pelo Web Service TAF"
     fl-usuar AT ROW 7.67 COL 48.43 COLON-ALIGNED HELP
          "Usu†rio Web Servive TAF" WIDGET-ID 26
     fl-senha AT ROW 8.67 COL 48.43 COLON-ALIGNED HELP
          "Senha Web Service  TAF" WIDGET-ID 28 PASSWORD-FIELD 
     tg-tpf AT ROW 6.79 COL 13 WIDGET-ID 38    
     tg-tms-saas AT ROW 12.58 COL 48.43 HELP
          "Integraá∆o com TMS Externo (SaaS)"
     tg-wms-saas AT ROW 13.46 COL 48.43 HELP
          "Integraá∆o com WMS Externo (SaaS)"
     tg-wms-saas AT ROW 13.46 COL 48.43 HELP
          "Integraá∆o com WMS Externo (SaaS)" WIDGET-ID 40
     "Integraá∆o Web Service - TAF" VIEW-AS TEXT
          SIZE 21 BY .67 AT ROW 1.29 COL 43.29
     RECT-1 AT ROW 1 COL 2
     RECT-14 AT ROW 1 COL 40 WIDGET-ID 2
     RECT-15 AT ROW 9 COL 2 WIDGET-ID 4
     RECT-19 AT ROW 1.63 COL 42 WIDGET-ID 16
     RECT-20 AT ROW 2.67 COL 43 WIDGET-ID 34
     RECT-2 AT ROW 5.75 COL 2 WIDGET-ID 36
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgcad.param-global
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
         HEIGHT             = 13.5
         WIDTH              = 82.72.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

ASSIGN 
       param-global.data-2:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME bt-conect-taf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-conect-taf V-table-Win
ON CHOOSE OF bt-conect-taf IN FRAME f-main
DO: 
    IF CAN-FIND(FIRST funcao NO-LOCK WHERE funcao.cd-funcao = "spp-WS-Net-HTTP" AND funcao.ativo) THEN DO: 
        if not valid-handle(h-webservicetaf) then
            run utp/ut-webservicetafNetHTTP.p persistent set h-webservicetaf.
    END.
    ELSE DO:
        if not valid-handle(h-webservicetaf) THEN 
            run utp/ut-webservicetaf.p persistent set h-webservicetaf.
    END.
    
    if valid-handle(h-webservicetaf) THEN DO:     
        IF fl-cod-url:screen-value in frame {&frame-name} <> '' AND fl-porta:screen-value in frame {&frame-name} <> '' THEN DO:        

            RUN verificaConexaoTAF IN h-webservicetaf (INPUT fl-cod-url:screen-value in frame {&frame-name}, 
                                                       INPUT fl-porta:screen-value in frame {&frame-name}, 
                                                       OUTPUT l-conexao).
            if not l-conexao then do:
                {utp/ut-liter.i "Erro_de_Conex∆o,_favor_verificar_URL_e_a_Porta."}
                run utp/ut-msgs.p (input "show":U, input 17006, input return-value).
            end.
            else do:
                {utp/ut-liter.i "Conex∆o_OK."}
                run utp/ut-msgs.p (input "show":U, input 15825, input return-value).
            end.
        END.
        ELSE DO:
                {utp/ut-liter.i "Favor_verificar_o_Servidor_e_a_Porta."}
                run utp/ut-msgs.p (input "show":U, input 17006, input return-value).
        END.
    END.
    delete procedure h-webservicetaf.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-versao-tc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-versao-tc V-table-Win
ON VALUE-CHANGED OF cb-versao-tc IN FRAME f-main /* Vers∆o */
DO:                                       
   IF cb-versao-tc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "2.0" THEN
       ENABLE rs-layout WITH FRAME {&FRAME-NAME}.
   ELSE DO:
       DISABLE rs-layout WITH FRAME {&FRAME-NAME}.
       ASSIGN rs-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1".
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-e-commerce
&Scoped-define SELF-NAME tg-totvs-colab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-totvs-colab V-table-Win
ON VALUE-CHANGED OF tg-totvs-colab IN FRAME f-main /* Totvs Colaboraá∆o */
DO:                                       
   IF  tg-totvs-colab:CHECKED IN FRAME {&FRAME-NAME} THEN DO:
      ASSIGN c-lista = "1.0,2.0":U.
      RUN utp/ut-lstit.p (INPUT-OUTPUT c-lista).

      ASSIGN cb-versao-tc:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = c-lista NO-ERROR. 
      ASSIGN cb-versao-tc:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = "2.0".
      
      /*ENABLE cb-versao-tc WITH FRAME {&FRAME-NAME}.*/
   END.
   ELSE DO:
       ASSIGN c-lista = ",1.0,2.0":U.
       RUN utp/ut-lstit.p (INPUT-OUTPUT c-lista).

       ASSIGN cb-versao-tc:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = c-lista NO-ERROR.

       ASSIGN  cb-versao-tc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
               rs-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1".
       DISABLE cb-versao-tc rs-layout  WITH FRAME {&FRAME-NAME}.
   END.
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
  /*{include/i-valid.i}*/
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  RUN pi-validate IN THIS-PROCEDURE.
  IF  RETURN-VALUE = 'ADM-ERROR':U THEN
      RETURN 'ADM-ERROR':U.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

  IF AVAIL param-global THEN DO:
      ASSIGN OVERLAY(param-global.char-2,41,4) = INPUT FRAME {&FRAME-NAME} cb-versao-tc
             OVERLAY(param-global.char-2,46,1) = INPUT FRAME {&FRAME-NAME} rs-layout.

      &IF '{&bf_dis_versao_ems}' >= '2.09' &THEN
          IF tg-totvs-colab:CHECKED IN FRAME {&FRAME-NAME} THEN
              ASSIGN param-global.log-integr-totvs-colab = YES.
          ELSE
              ASSIGN param-global.log-integr-totvs-colab = NO.
      &ELSE
          IF tg-totvs-colab:CHECKED IN FRAME {&FRAME-NAME} THEN
              ASSIGN OVERLAY(param-global.char-2,35,1) = "S".
          ELSE
              ASSIGN OVERLAY(param-global.char-2,35,1) = "N".
      &ENDIF
      
      IF tg-tpf:CHECKED IN FRAME {&FRAME-NAME} THEN
          ASSIGN OVERLAY(param-global.char-2,48,1) = "S".
      ELSE
          ASSIGN OVERLAY(param-global.char-2,48,1) = "N".

      &IF {&EAI_inst} = YES &THEN
          if  tg-eai:checked in frame {&frame-name} THEN DO:
              assign OVERLAY(param-global.char-2,30,1)= "1".
              ASSIGN v_log_eai_ativado = YES.
          END.
          ELSE DO:
              assign OVERLAY(param-global.char-2,30,1)= "0".
              ASSIGN v_log_eai_ativado = NO.
          END.
      &ENDIF
      
      if  tg-eai2:checked in frame {&frame-name} THEN DO:
          assign OVERLAY(param-global.char-2,36,1)= "1".
          ASSIGN v_log_eai2_ativado = YES.
      END.
      ELSE DO:
          assign OVERLAY(param-global.char-2,36,1)= "0".
          ASSIGN v_log_eai2_ativado = NO.
      END.

      IF tg-sop:CHECKED IN FRAME {&FRAME-NAME} THEN 
         ASSIGN OVERLAY(param-global.char-2,40,1)= "S".
      ELSE
         ASSIGN OVERLAY(param-global.char-2,40,1)= "N".
      
      IF tg-e-commerce:CHECKED IN FRAME {&FRAME-NAME} THEN    
         ASSIGN OVERLAY(param-global.char-2,47,1)= "S".
      ELSE                                             
         ASSIGN OVERLAY(param-global.char-2,47,1)= "N".

      /*Tratamento conex∆o web service taf*/

      FIND FIRST param-extrat-taf WHERE
                 param-extrat-taf.cod-estab = "*" AND 
                 param-extrat-taf.cod-param = "Utiliz-WebService-TAF" EXCLUSIVE-LOCK NO-ERROR.

      IF NOT AVAIL param-extrat-taf THEN DO:
          CREATE param-extrat-taf.
          ASSIGN param-extrat-taf.cod-estab = "*"
                 param-extrat-taf.cod-param = "Utiliz-WebService-TAF".
      END.
      
      IF trim(fl-senha:screen-value in frame {&frame-name}) <> "" THEN DO:
          ASSIGN v-senha-long = trim(fl-senha:screen-value in frame {&frame-name}).

          COPY-LOB v-senha-long TO v-senha-mem.                      
          ASSIGN v-senha-encode-long = BASE64-ENCODE(v-senha-mem).

      END.
      ELSE
          ASSIGN v-senha-encode-long = "". 

      IF trim(SUBSTRING(param-extrat-taf.param-caracter,121,50)) <> trim(fl-senha:screen-value in frame {&frame-name}) THEN
          ASSIGN OVERLAY(param-extrat-taf.param-caracter,121,50) = v-senha-encode-long.

      ASSIGN OVERLAY(param-extrat-taf.param-caracter,186,100)   = trim(fl-cod-url:screen-value in frame {&frame-name})
             OVERLAY(param-extrat-taf.param-caracter,21,50)  = trim(fl-resource:screen-value in frame {&frame-name})
             OVERLAY(param-extrat-taf.param-caracter,71,50)  = trim(fl-usuar:screen-value in frame {&frame-name})
             OVERLAY(param-extrat-taf.param-caracter,180,05) = trim(fl-porta:screen-value in frame {&frame-name}). 

      /*fim do tratamento web service taf*/                                       

      // WMS SAAS
      FIND FIRST funcao EXCLUSIVE-LOCK
           WHERE funcao.cd-funcao = "WMS-SAAS":U NO-ERROR.
      IF  AVAILABLE funcao THEN
          ASSIGN funcao.ativo = tg-wms-saas:CHECKED.
      ELSE DO:
          CREATE funcao.
          ASSIGN funcao.cd-funcao = "WMS-SAAS":U
                 funcao.ativo     = tg-wms-saas:CHECKED.
      END.

      /* TMS SAAS */
        FIND FIRST funcao EXCLUSIVE-LOCK
            WHERE funcao.cd-funcao = "TMS-SAAS":U NO-ERROR.

        IF tg-tms-saas:CHECKED IN FRAME {&FRAME-NAME} THEN DO:
            IF AVAILABLE funcao THEN
                ASSIGN funcao.ativo = TRUE.
            ELSE DO:
                CREATE funcao.
                ASSIGN funcao.cd-funcao = "TMS-SAAS":U
                    funcao.ativo     = TRUE.
            END.
        END.
        ELSE DO:
            IF AVAILABLE funcao THEN
                ASSIGN funcao.ativo = FALSE.
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

  &IF '{&bf_dis_versao_ems}' >= '2.09' &THEN
      IF param-global.log-integr-totvs-colab THEN
          ASSIGN tg-totvs-colab:CHECKED IN FRAME {&FRAME-NAME} = YES.
      ELSE
          ASSIGN tg-totvs-colab:CHECKED IN FRAME {&FRAME-NAME} = NO.
  &ELSE
      IF SUBSTRING(param-global.char-2,35,1) = "S" THEN
          ASSIGN tg-totvs-colab:CHECKED IN FRAME {&FRAME-NAME} = YES.
      ELSE
          ASSIGN tg-totvs-colab:CHECKED  IN FRAME {&FRAME-NAME} = NO.
  &ENDIF

  IF SUBSTRING(param-global.char-2,48,1) = "S" THEN
      ASSIGN tg-tpf:CHECKED IN FRAME {&FRAME-NAME} = YES.
  ELSE
      ASSIGN tg-tpf:CHECKED  IN FRAME {&FRAME-NAME} = NO.

  IF (tg-totvs-colab:CHECKED IN FRAME {&FRAME-NAME}) THEN DO:
      IF ((SUBSTRING(param-global.char-2,41,4) = ?) OR (SUBSTRING(param-global.char-2,41,4) = "")) THEN
          ASSIGN cb-versao-tc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "2.0".
      ELSE
          ASSIGN cb-versao-tc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(param-global.char-2,41,4).

      ASSIGN rs-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(param-global.char-2,46,1).
  END.

  &IF {&EAI_inst} = YES &THEN
     IF int(SUBSTRING(param-global.char-2,30,1)) = 0 THEN
        ASSIGN tg-eai:CHECKED IN FRAME {&FRAME-NAME} = FALSE.
     ELSE IF int(SUBSTRING(param-global.char-2,30,1)) = 1 THEN
        ASSIGN tg-eai:CHECKED IN FRAME {&FRAME-NAME} = TRUE.
  &ENDIF
  
  IF int(SUBSTRING(param-global.char-2,36,1)) = 0 THEN
     ASSIGN tg-eai2:CHECKED IN FRAME {&FRAME-NAME} = FALSE.
  ELSE IF int(SUBSTRING(param-global.char-2,36,1)) = 1 THEN
     ASSIGN tg-eai2:CHECKED IN FRAME {&FRAME-NAME} = TRUE.

  IF SUBSTRING(param-global.char-2,40,1) = "S" THEN /* S&OP */
     ASSIGN tg-sop:CHECKED IN FRAME {&FRAME-NAME} = YES.
  ELSE
     ASSIGN tg-sop:CHECKED  IN FRAME {&FRAME-NAME} = NO.

  IF SUBSTRING(param-global.char-2,47,1) = "S" THEN /* E-commerce */
     ASSIGN tg-e-commerce:CHECKED IN FRAME {&FRAME-NAME} = YES.      
  ELSE                                                        
     ASSIGN tg-e-commerce:CHECKED  IN FRAME {&FRAME-NAME} = NO.     

  /*Carregar os campos web service taf*/
  FIND FIRST param-extrat-taf WHERE
             param-extrat-taf.cod-estab = "*" AND 
             param-extrat-taf.cod-param = "Utiliz-WebService-TAF" NO-LOCK NO-ERROR.

  IF AVAIL param-extrat-taf THEN
      ASSIGN fl-cod-url:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = trim(substring(param-extrat-taf.param-caracter,186,100))
             fl-resource:SCREEN-VALUE IN FRAME {&FRAME-NAME} = trim(substring(param-extrat-taf.param-caracter,21,50))
             fl-usuar:SCREEN-VALUE IN FRAME {&FRAME-NAME}    = trim(substring(param-extrat-taf.param-caracter,71,50))
             fl-senha:SCREEN-VALUE IN FRAME {&FRAME-NAME}    = trim(substring(param-extrat-taf.param-caracter,121,50))
             fl-porta:SCREEN-VALUE IN FRAME {&FRAME-NAME}    = trim(substring(param-extrat-taf.param-caracter,180,05)).

  FIND FIRST funcao EXCLUSIVE-LOCK
       WHERE funcao.cd-funcao = "WMS-SAAS":U NO-ERROR.
  IF AVAILABLE funcao THEN
      ASSIGN tg-wms-saas:CHECKED IN FRAME {&FRAME-NAME} = funcao.ativo.

 FIND FIRST funcao NO-LOCK
     WHERE funcao.cd-funcao = "TMS-SAAS":U NO-ERROR.

 IF AVAILABLE funcao THEN
     ASSIGN tg-tms-saas:CHECKED IN FRAME {&FRAME-NAME} = funcao.ativo.
 ELSE
     ASSIGN tg-tms-saas:CHECKED IN FRAME {&FRAME-NAME} = NO.
  
  /*fim*/


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
    ASSIGN cb-versao-tc:SENSITIVE IN FRAME {&FRAME-NAME} = NO
           rs-layout   :SENSITIVE IN FRAME {&FRAME-NAME} = NO.

    IF l-totvs-colaboracao THEN
        ASSIGN tg-totvs-colab:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    ELSE
        ASSIGN tg-totvs-colab:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

    &IF {&EAI_inst} = YES &THEN
        IF int(SUBSTRING(param-global.char-2,30,1)) = 0 THEN
           ASSIGN tg-eai:CHECKED IN FRAME {&FRAME-NAME} = FALSE.
        ELSE IF int(SUBSTRING(param-global.char-2,30,1)) = 1 THEN
           ASSIGN tg-eai:CHECKED IN FRAME {&FRAME-NAME} = TRUE.
    &ENDIF

    IF int(SUBSTRING(param-global.char-2,36,1)) = 0 THEN
       ASSIGN tg-eai2:CHECKED IN FRAME {&FRAME-NAME} = FALSE.
    ELSE IF int(SUBSTRING(param-global.char-2,36,1)) = 1 THEN
       ASSIGN tg-eai2:CHECKED IN FRAME {&FRAME-NAME} = TRUE.

    &IF '{&bf_dis_versao_ems}' >= '2.09' &THEN
        IF param-global.log-integr-totvs-colab THEN DO:
            ASSIGN tg-totvs-colab:CHECKED IN FRAME {&FRAME-NAME} = YES
                   /*cb-versao-tc:SENSITIVE IN FRAME {&FRAME-NAME} = YES*/ .

            IF cb-versao-tc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "2.00" THEN
                ASSIGN rs-layout:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
        END.
        ELSE
            ASSIGN tg-totvs-colab:CHECKED  IN FRAME {&FRAME-NAME} = NO
                   cb-versao-tc :SENSITIVE IN FRAME {&FRAME-NAME} = NO
                   rs-layout    :SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    &ELSE
        IF SUBSTRING(param-global.char-2,35,1) = "S" THEN DO:
            ASSIGN tg-totvs-colab:CHECKED IN FRAME {&FRAME-NAME} = YES
                   /*cb-versao-tc:SENSITIVE IN FRAME {&FRAME-NAME} = YES*/ .

            IF cb-versao-tc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "2.0" THEN
                ASSIGN rs-layout:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
        END.
        ELSE
           ASSIGN tg-totvs-colab:CHECKED  IN FRAME {&FRAME-NAME} = NO
                  cb-versao-tc :SENSITIVE IN FRAME {&FRAME-NAME} = NO
                  rs-layout    :SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    &ENDIF

  if adm-new-record = yes then
  &if defined(ADM-MODIFY-FIELDS) &then
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

  /****************** Validaá∆o de slot do TOTVS Colaboraá∆o ******************/

IF VALID-HANDLE(v_hdl_license_manager) THEN DO:
    ASSIGN h-btb432za = v_hdl_license_manager.
END.
ELSE DO:
    RUN btb/btb432za.p PERSISTENT SET h-btb432za.
END.


Run PI-SlotAvail in h-btb432za (INPUT 3100, OUTPUT c-slot-disponivel).


IF c-slot-disponivel = "OK":U THEN
      ASSIGN l-totvs-colaboracao = YES.
  ELSE
      ASSIGN l-totvs-colaboracao = NO.
/*

...


*/


/*fechando a instancia*/
IF h-btb432za <> v_hdl_license_manager THEN
    DELETE PROCEDURE h-btb432za.

/* Fim Validaá∆o de slot do TOTVS Colaboraá∆o */

  &IF {&EAI_inst} = YES &THEN 
      ASSIGN tg-eai:HIDDEN in frame {&frame-name} = NO.
  &ELSE
      ASSIGN tg-eai:HIDDEN in frame {&frame-name} = YES.
  &ENDIF  
  

  IF  i-pais-impto-usuario <> 1 /* Brasil*/ THEN DO:
      ASSIGN tg-totvs-colab:HIDDEN IN FRAME {&FRAME-NAME} = YES
             cb-versao-tc  :HIDDEN IN FRAME {&FRAME-NAME} = YES
             rs-layout     :HIDDEN IN FRAME {&FRAME-NAME} = YES
             tg-tpf        :HIDDEN IN FRAME {&FRAME-NAME} = YES.
  END.

  ASSIGN tg-wms-saas:VISIBLE in frame {&frame-name} = (i-pais-impto-usuario = 1).



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
   
   /*Segue um exemplo de validaá∆o de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/

   IF  SUBSTRING(param-global.char-2,48,1) = "S" AND (INPUT FRAME {&FRAME-NAME} tg-tpf = NO)
   AND CAN-FIND (FIRST  param-gener
                 WHERE  param-gener.cod-chave-1 = "param-comunic"
                 AND    param-gener.cod-valor   = "6" /* TOTVS PROCESSOS FISCAIS */ ) THEN DO:

       {utp/ut-liter.i "TOTVS_Processos_Fiscais" *}

       RUN utp/ut-msgs.p (INPUT "show",
                          INPUT 57396,
                          INPUT "TPF" + "~~" + TRIM(RETURN-VALUE)).

       RETURN 'ADM-ERROR':U.

   END.

   IF  SUBSTRING(param-global.char-2,35,1) = "S" AND (INPUT FRAME {&FRAME-NAME} tg-totvs-colab = NO)
   AND CAN-FIND (FIRST  param-gener
                 WHERE  param-gener.cod-chave-1 = "param-comunic"
                 AND    param-gener.cod-valor   = "4" /* TOTVS COLABORA«√O 2.0 */ ) THEN DO:

       {utp/ut-liter.i "TOTVS_ColaboraÁ„o_2.0" *}

       RUN utp/ut-msgs.p (INPUT "show",
                          INPUT 57396,
                          INPUT "TC2" + "~~" + TRIM(RETURN-VALUE)).

       RETURN 'ADM-ERROR':U.

   END.
/*
    IF  (INPUT FRAME {&FRAME-NAME} tg-totvs-colab = NO)
    AND (INPUT FRAME {&FRAME-NAME} tg-totvs-colab = NO)
    AND (TRIM(SUBSTRING(param-global.char-2,35,1)) = "S") 
    AND (INPUT FRAME {&FRAME-NAME} tg-totvs-colab = NO) THEN DO:

        DEFINE VARIABLE c-lbl-liter-erro AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Confirma_eliminaá∆o_de_parametrizaá∆o?" *}
        ASSIGN c-lbl-liter-erro = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-help AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Ao_alterar_a_vers∆o_do_TOTVS_Colaboraá∆o_para_1.0,_toda_a_parametrizaá∆o_realizada_no_programa_CD0360_ser†_eliminada._Confirmar_alteraá∆o?" *}
        ASSIGN c-lbl-liter-help = TRIM(RETURN-VALUE).
        
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 27100,
                           INPUT c-lbl-liter-erro + "~~" + c-lbl-liter-help).

        IF RETURN-VALUE = "YES" THEN DO:
            FOR EACH param-gener WHERE cod-chave-1 = "param-comunic":
                DELETE param-gener.
            END.
        END.
        ELSE DO:
            APPLY "entry" TO cb-versao-tc IN FRAME {&FRAME-NAME}.
            RETURN 'ADM-ERROR':U.
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
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

