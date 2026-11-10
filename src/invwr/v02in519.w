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
{include/i-prgvrs.i V02IN519 2.00.00.042 } /*** "010042" 01/08/2023 16:51:05  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v02in519 MUT}
&ENDIF



CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */
{cdp/cdcfgmat.i}
{cdp/cdcfgman.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent    as rowid    no-undo.
DEF VAR l-sfc-mudancas  AS LOG      NO-UNDO.

DEFINE VARIABLE l-preparacao-padrao     AS LOGICAL  NO-UNDO.
DEFINE VARIABLE l-reduz-parada-ggf      AS LOGICAL  NO-UNDO.
DEFINE VARIABLE l-reduz-parada-mob      AS LOGICAL  NO-UNDO.
DEFINE VARIABLE l-ferrametaria-operacao AS LOGICAL  NO-UNDO.
DEFINE VARIABLE l-bloqueia-reporte-futuro AS LOGICAL  NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES param-sfc
&Scoped-define FIRST-EXTERNAL-TABLE param-sfc


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-sfc.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-sfc.cd-calen param-sfc.cod-model-turno ~
param-sfc.log-pcp-liber-op param-sfc.log-consid-rede-pert ~
param-sfc.log-op-automatica 
&Scoped-define ENABLED-TABLES param-sfc
&Scoped-define FIRST-ENABLED-TABLE param-sfc
&Scoped-Define ENABLED-OBJECTS RECT-12 RECT-13 RECT-14 cbTipoRelogio ~
tgUsaPad tgReportaQtdZero tgSumarizAutom tgCtrab tgFerramtOper tgRepGGFAuto ~
tgAtuGGF tgRepMOBAuto tgAtuMob tgGGFMODEquipe tgParadaAtuGGF ~
tgGGFMODPreparacao tgParadaAtuMob tgGGFMODPrepPadrao ~
tgBloqueiaReporteFuturo cTituloMOBGGF 
&Scoped-Define DISPLAYED-FIELDS param-sfc.cd-calen ~
param-sfc.cod-model-turno param-sfc.log-pcp-liber-op ~
param-sfc.log-consid-rede-pert param-sfc.log-op-automatica 
&Scoped-define DISPLAYED-TABLES param-sfc
&Scoped-define FIRST-DISPLAYED-TABLE param-sfc
&Scoped-Define DISPLAYED-OBJECTS c-desc1 c-desc2 cbTipoRelogio tgUsaPad ~
tgReportaQtdZero tgSumarizAutom tgCtrab tgFerramtOper tgRepGGFAuto tgAtuGGF ~
tgRepMOBAuto tgAtuMob tgGGFMODEquipe tgParadaAtuGGF tgGGFMODPreparacao ~
tgParadaAtuMob tgGGFMODPrepPadrao tgBloqueiaReporteFuturo cTituloMOBGGF 

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
DEFINE VARIABLE cbTipoRelogio AS CHARACTER FORMAT "X(256)" INITIAL "yes" 
     LABEL "Tipo Rel¢gio" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Hor†rio","Yes",
                     "Centesimal","no"
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc1 AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 28.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc2 AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 28.72 BY .88 NO-UNDO.

DEFINE VARIABLE cTituloMOBGGF AS CHARACTER FORMAT "X(256)":U INITIAL "ParÉmetros MOB/GGF" 
      VIEW-AS TEXT 
     SIZE 21 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83 BY 2.75.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83 BY 5.25.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83 BY 4.5.

DEFINE VARIABLE tgAlertaInv AS LOGICAL INITIAL no 
     LABEL "Alerta Inviabilidade de Integraá∆o de Ordens CP X SFC" 
     VIEW-AS TOGGLE-BOX
     SIZE 41 BY .83 NO-UNDO.

DEFINE VARIABLE tgAtuGGF AS LOGICAL INITIAL no 
     LABEL "Reporte de Parada Atualiza Movimentos GGF" 
     VIEW-AS TOGGLE-BOX
     SIZE 33.72 BY .83 TOOLTIP "Indica se Reporte de Parada Atualiza Movimentos de GGF" NO-UNDO.

DEFINE VARIABLE tgAtuMob AS LOGICAL INITIAL no 
     LABEL "Reporte de Parada Atualiza Movimentos MOB" 
     VIEW-AS TOGGLE-BOX
     SIZE 33.72 BY .83 TOOLTIP "Indica se Reporte de Parada Atualiza Movimentos de MOB" NO-UNDO.

DEFINE VARIABLE tgBloqueiaReporteFuturo AS LOGICAL INITIAL no 
     LABEL "Bloqueia TÇrmino Reporte em Data Futura" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .83 NO-UNDO.

DEFINE VARIABLE tgCtrab AS LOGICAL INITIAL no 
     LABEL "Reporte para mais de um Centro de Trabalho" 
     VIEW-AS TOGGLE-BOX
     SIZE 35 BY .83 TOOLTIP "Reporte para mais de um Centro de Trabalho" NO-UNDO.

DEFINE VARIABLE tgFerramtOper AS LOGICAL INITIAL no 
     LABEL "Ferramentaria por Operaá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .83 NO-UNDO.

DEFINE VARIABLE tgGGFMODEquipe AS LOGICAL INITIAL no 
     LABEL "Gera GGF/MOD proporcional por equipe" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .83 NO-UNDO.

DEFINE VARIABLE tgGGFMODPreparacao AS LOGICAL INITIAL no 
     LABEL "Gera GGF/MOD para preparaá∆o REAL" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .83 NO-UNDO.

DEFINE VARIABLE tgGGFMODPrepPadrao AS LOGICAL INITIAL no 
     LABEL "Gera GGF/MOD para preparaá∆o PADR«O" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .83 NO-UNDO.

DEFINE VARIABLE tgParadaAtuGGF AS LOGICAL INITIAL no 
     LABEL "Reduz Parada do GGF" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .83 NO-UNDO.

DEFINE VARIABLE tgParadaAtuMob AS LOGICAL INITIAL no 
     LABEL "Reduz Parada do MOB" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .83 NO-UNDO.

DEFINE VARIABLE tgRepGGFAuto AS LOGICAL INITIAL no 
     LABEL "Reporta GGF Autom†tico" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .83 NO-UNDO.

DEFINE VARIABLE tgRepMOBAuto AS LOGICAL INITIAL no 
     LABEL "Reporta MOB Autom†tico" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .83 NO-UNDO.

DEFINE VARIABLE tgReportaQtdZero AS LOGICAL INITIAL no 
     LABEL "Reporta com quantidade zero" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .83 NO-UNDO.

DEFINE VARIABLE tgSumarizAutom AS LOGICAL INITIAL no 
     LABEL "Sumarizaá∆o Autom†tica" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .83 NO-UNDO.

DEFINE VARIABLE tgUsaPad AS LOGICAL INITIAL no 
     LABEL "Usa Padr∆o em Operaá‰es N∆o Reportadas" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-sfc.cd-calen AT ROW 1.46 COL 15.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     c-desc1 AT ROW 1.46 COL 28 COLON-ALIGNED NO-LABEL
     param-sfc.cod-model-turno AT ROW 2.46 COL 15.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     c-desc2 AT ROW 2.46 COL 28 COLON-ALIGNED NO-LABEL
     cbTipoRelogio AT ROW 4 COL 12 COLON-ALIGNED
     param-sfc.log-pcp-liber-op AT ROW 5.04 COL 5
          VIEW-AS TOGGLE-BOX
          SIZE 15 BY .83
     param-sfc.log-consid-rede-pert AT ROW 5.79 COL 5
          VIEW-AS TOGGLE-BOX
          SIZE 36 BY .83
     tgUsaPad AT ROW 5.79 COL 48
     param-sfc.log-op-automatica AT ROW 6.54 COL 5
          VIEW-AS TOGGLE-BOX
          SIZE 35.14 BY .83
     tgReportaQtdZero AT ROW 6.54 COL 48
     tgSumarizAutom AT ROW 7.29 COL 5
     tgCtrab AT ROW 7.29 COL 48 HELP
          "Reporte para mais de um Centro de Trabalho"
     tgAlertaInv AT ROW 8.04 COL 5
     tgFerramtOper AT ROW 8.04 COL 48
     tgRepGGFAuto AT ROW 9.75 COL 5
     tgAtuGGF AT ROW 9.75 COL 48 HELP
          "Indica se Reporte de Parada Atualiza Movimentos de GGF"
     tgRepMOBAuto AT ROW 10.5 COL 5
     tgAtuMob AT ROW 10.5 COL 48 HELP
          "Indica se Reporte de Parada Atualiza Movimentos de GGF" WIDGET-ID 2
     tgGGFMODEquipe AT ROW 11.25 COL 5
     tgParadaAtuGGF AT ROW 11.25 COL 48
     tgGGFMODPreparacao AT ROW 12 COL 5
     tgParadaAtuMob AT ROW 12 COL 48
     tgGGFMODPrepPadrao AT ROW 12.75 COL 5
     tgBloqueiaReporteFuturo AT ROW 12.75 COL 48 WIDGET-ID 8
     cTituloMOBGGF AT ROW 9 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     RECT-12 AT ROW 1 COL 1
     RECT-13 AT ROW 3.75 COL 1
     RECT-14 AT ROW 9.25 COL 1 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-sfc
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
         HEIGHT             = 12.75
         WIDTH              = 83.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tgAlertaInv IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
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

&Scoped-define SELF-NAME param-sfc.cd-calen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-sfc.cd-calen V-table-Win
ON F5 OF param-sfc.cd-calen IN FRAME f-main /* Calend†rio */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in026.w"
                     &campo=param-sfc.cd-calen
                     &campozoom=cd-calen
                     &campo2=c-desc1
                     &campozoom2=descricao}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-sfc.cd-calen V-table-Win
ON LEAVE OF param-sfc.cd-calen IN FRAME f-main /* Calend†rio */
DO:
    {include/leave.i &tabela=calen-gener
                     &atributo-ref=descricao
                     &variavel-ref=c-desc1
                     &where="calen-gener.cd-calen = input frame {&frame-name} param-sfc.cd-calen"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-sfc.cd-calen V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-sfc.cd-calen IN FRAME f-main /* Calend†rio */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-sfc.cod-model-turno
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-sfc.cod-model-turno V-table-Win
ON F5 OF param-sfc.cod-model-turno IN FRAME f-main /* Modelo Turno */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in467.w"
                     &campo=param-sfc.cod-model-turno
                     &campozoom=cod-model-turno
                     &campo2=c-desc2
                     &campozoom2=des-model-turno}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-sfc.cod-model-turno V-table-Win
ON LEAVE OF param-sfc.cod-model-turno IN FRAME f-main /* Modelo Turno */
DO:
    {include/leave.i &tabela=model-turno-semana
                     &atributo-ref=des-model-turno
                     &variavel-ref=c-desc2
                     &where="model-turno-semana.cod-model-turno = input frame {&frame-name} param-sfc.cod-model-turno"}  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-sfc.cod-model-turno V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-sfc.cod-model-turno IN FRAME f-main /* Modelo Turno */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

FIND FIRST funcao 
    WHERE funcao.cd-funcao = "SFC-MUDANCAS":U
    AND   funcao.ativo     = TRUE NO-LOCK NO-ERROR.

IF AVAIL funcao THEN
    ASSIGN l-sfc-mudancas = TRUE.
ELSE
    ASSIGN l-sfc-mudancas = FALSE.

if param-sfc.cd-calen:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
if param-sfc.cod-model-turno:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.



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
  {src/adm/template/row-list.i "param-sfc"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-sfc"}

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
    /*{include/i-valid.i}*/

    if  not frame {&frame-name}:validate() then
        return 'ADM-ERROR':U.    

      find first calen-gener
           where calen-gener.cd-calen = input frame {&frame-name} param-sfc.cd-calen no-lock no-error.
      if not avail calen-gener then do:
         {utp/ut-table.i mgind calen-gener 01}
         run utp/ut-msgs.p (input 'show',
                            input 56,
                            input return-value).
         apply 'entry' to param-sfc.cd-calen in frame {&frame-name}.
         return 'adm-error'.
      end.

      find first model-turno-semana
           where model-turno-semana.cod-model-turno = input frame {&frame-name} param-sfc.cod-model-turno no-lock no-error.
      if not avail model-turno-semana then do:
         {utp/ut-table.i mgind model-turno-semana 01}
         run utp/ut-msgs.p (input 'show',
                            input 56,
                            input return-value).
         apply 'entry' to param-sfc.cod-model-turno in frame {&frame-name}.
         return 'adm-error'.
      end.

    /* Ponha na pi-validate todas as validaá‰es */
    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    ASSIGN param-sfc.log-tipo-relogio = cbTipoRelogio:INPUT-VALUE IN FRAME {&FRAME-NAME}.

    ASSIGN param-sfc.log-reporta-varios-ctrab = tgCtrab:checked in frame {&FRAME-NAME}.
    
    ASSIGN param-sfc.log-parada-atualiza-ggf = tgatuggf:checked in frame {&FRAME-NAME}.
    
    ASSIGN param-sfc.log-gera-ggf-autom = tgRepGGFAuto:CHECKED IN FRAME {&FRAME-NAME}
           param-sfc.log-gera-mod-autom = tgRepMOBAuto:CHECKED IN FRAME {&FRAME-NAME}.
        
    ASSIGN param-sfc.log-usa-padr = tgUsaPad:CHECKED IN FRAME {&FRAME-NAME}.
    
    ASSIGN param-sfc.log-alerta-integr = tgAlertaInv:checked IN FRAME {&FRAME-NAME}
           param-sfc.log-sumariz-autom = tgSumarizAutom:checked IN FRAME {&FRAME-NAME}.
        
    ASSIGN param-sfc.log-report-quant-zero   = tgReportaQtdZero:checked IN FRAME {&FRAME-NAME}
           param-sfc.log-gera-ggf-mod-prepar = tgGGFMODPreparacao:checked IN FRAME {&FRAME-NAME}
           param-sfc.log-gera-ggf-mod-equipe = tgGGFMODEquipe:checked IN FRAME {&FRAME-NAME}.  
    
    ASSIGN OVERLAY(param-sfc.char-1,34,1)  = IF tgatumob:checked in frame {&FRAME-NAME} THEN "S":u ELSE "N":u.

    RUN pi-assign-param-manuf.
    
    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
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
    
    DISABLE tgUsaPad WITH FRAME {&FRAME-NAME}.
    
    DISABLE tgAlertaInv 
            tgSumarizAutom
            tgReportaQtdZero
            tgGGFMODPreparacao
            tgGGFMODEquipe
            tgGGFMODPrepPadrao
            tgParadaAtuMob
            tgParadaAtuGGF
            tgFerramtOper
            WITH FRAME {&FRAME-NAME}.    

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

  {utp/ut-liter.i Reporta_GGF_Autom†tico}
  ASSIGN tgRepGGFAuto:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

  {utp/ut-liter.i Reporta_MOB_Autom†tico}
  ASSIGN tgRepMOBAuto:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

  {utp/ut-liter.i Gera_GGF/MOD_prep_com_reporte_Padr∆o}
  ASSIGN tgGGFMODPrepPadrao:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).
  {utp/ut-liter.i Reduz_Parada_do_GGF}
  ASSIGN tgParadaAtuGGF:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

  {utp/ut-liter.i Reduz_Parada_do_MOB}
  ASSIGN tgParadaAtuMOB:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).

  {utp/ut-liter.i Ferramentaria_por_Operaá∆o}
  ASSIGN tgFerramtOper:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).
  
  {utp/ut-liter.i Considera_Rede_Pert_para_Reporte_por_Ordem}
  assign param-sfc.log-consid-rede-pert:label in frame {&frame-name} = TRIM(RETURN-VALUE).

  find first calen-gener
       where calen-gener.cd-calen = param-sfc.cd-calen no-lock no-error.
  assign c-desc1:screen-value in frame {&frame-name} = if avail calen-gener then calen-gener.descricao
                                                       else "".
  find first model-turno-semana
       where model-turno-semana.cod-model-turno = param-sfc.cod-model-turno no-lock no-error.
  assign c-desc2:screen-value in frame {&frame-name} = if avail model-turno-semana then model-turno-semana.des-model-turno
                                                       else "".

  RUN pi-trata-param-manuf.

  if avail param-sfc then do:

      ASSIGN cbTipoRelogio:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(param-sfc.log-tipo-relogio).

      {utp/ut-liter.i "Reporta para mais de um Centro de Trabalho"}
      assign tgCtrab:label   in frame {&FRAME-NAME} = trim(return-value).

      ASSIGN tgCtrab:checked in frame {&FRAME-NAME} = param-sfc.log-reporta-varios-ctrab.
            
      {utp/ut-liter.i Reporte_de_Parada_Atualiza_Movimentos_GGF *}
      assign tgatuggf:label   in frame {&FRAME-NAME} = trim(return-value)
             tgatuggf:checked in frame {&FRAME-NAME} = param-sfc.log-parada-atualiza-ggf.
                                                 
      {utp/ut-liter.i Reporte_de_Parada_Atualiza_Movimentos_MOB *}
      assign tgatumob:label   in frame {&FRAME-NAME} = trim(return-value)
             tgatumob:checked in frame {&FRAME-NAME} = 
                                                 if substring(param-sfc.char-1,34,1) = "S":U
                                                       THEN YES else no.
                                                 
                                                 
      ASSIGN tgRepGGFAuto:CHECKED IN FRAME {&FRAME-NAME} = param-sfc.log-gera-ggf-autom
             tgRepMOBAuto:CHECKED IN FRAME {&FRAME-NAME} = param-sfc.log-gera-mod-autom.
            
      ASSIGN tgUsaPad:CHECKED IN FRAME {&FRAME-NAME} = param-sfc.log-usa-padr.
            
      ASSIGN tgAlertaInv:checked IN FRAME {&FRAME-NAME} = param-sfc.log-alerta-integr
             tgSumarizAutom:checked IN FRAME {&FRAME-NAME} = param-sfc.log-sumariz-autom.
      
      ASSIGN tgReportaQtdZero:checked IN FRAME {&FRAME-NAME}        = param-sfc.log-report-quant-zero  
             tgGGFMODPreparacao:checked IN FRAME {&FRAME-NAME}      = param-sfc.log-gera-ggf-mod-prepar
             tgGGFMODPrepPadrao:checked IN FRAME {&FRAME-NAME}      = l-preparacao-padrao
             tgParadaAtuGGF:checked IN FRAME {&FRAME-NAME}          = l-reduz-parada-ggf
             tgParadaAtuMOB:checked IN FRAME {&FRAME-NAME}          = l-reduz-parada-mob
             tgFerramtOper:checked IN FRAME {&FRAME-NAME}           = l-ferrametaria-operacao                 
             tgBloqueiaReporteFuturo:checked IN FRAME {&FRAME-NAME} = l-bloqueia-reporte-futuro
             tgGGFMODEquipe:checked IN FRAME {&FRAME-NAME}          = param-sfc.log-gera-ggf-mod-equipe.                      
      
  end.

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
    
    ENABLE tgUsaPad WITH FRAME {&FRAME-NAME}.
        
    ENABLE tgAlertaInv 
           tgSumarizAutom
           tgReportaQtdZero
           tgGGFMODPreparacao
           tgGGFMODPrepPadrao
           tgParadaAtuMob
           tgParadaAtuGGF
           tgGGFMODEquipe
           tgFerramtOper
        WITH FRAME {&FRAME-NAME}.

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
  ASSIGN tgUsaPad:VISIBLE IN FRAME {&FRAME-NAME} = TRUE.
    
  ASSIGN tgAlertaInv:VISIBLE IN FRAME {&FRAME-NAME}        = TRUE
         tgSumarizAutom:VISIBLE IN FRAME {&FRAME-NAME}     = TRUE
         tgReportaQtdZero:VISIBLE IN FRAME {&FRAME-NAME}   = TRUE
         tgGGFMODPreparacao:VISIBLE IN FRAME {&FRAME-NAME} = TRUE
         tgGGFMODEquipe:VISIBLE IN FRAME {&FRAME-NAME}     = TRUE
         tgGGFMODPrepPadrao:VISIBLE IN FRAME {&FRAME-NAME} = TRUE
         tgParadaAtuMob:VISIBLE IN FRAME {&FRAME-NAME}     = TRUE
         tgParadaAtuGGF:VISIBLE IN FRAME {&FRAME-NAME}     = TRUE
         tgFerramtOper:VISIBLE IN FRAME {&FRAME-NAME}      = TRUE.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE movimentos V-table-Win 
PROCEDURE movimentos :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-assign-param-manuf V-table-Win 
PROCEDURE pi-assign-param-manuf :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/

  FOR FIRST param-manuf
      WHERE param-manuf.cod-entid = "param-sfc"
        AND param-manuf.cod-param = "log-gera-ggf-mod-prepar-padrao" EXCLUSIVE-LOCK:
  END.

  ASSIGN param-manuf.param-logico = tgGGFMODPrepPadrao:checked IN FRAME {&FRAME-NAME}.

  FOR FIRST param-manuf
      WHERE param-manuf.cod-entid = "param-sfc"
        AND param-manuf.cod-param = "l-reduz-parada-ggf" EXCLUSIVE-LOCK:
  END.

  ASSIGN param-manuf.param-logico = tgParadaAtuGGF:checked IN FRAME {&FRAME-NAME}.   

  FOR FIRST param-manuf
      WHERE param-manuf.cod-entid = "param-sfc"
        AND param-manuf.cod-param = "l-reduz-parada-mob" EXCLUSIVE-LOCK:
  END.

  ASSIGN param-manuf.param-logico =  tgParadaAtuMOB:checked IN FRAME {&FRAME-NAME}.

  FOR FIRST param-manuf
      WHERE param-manuf.cod-entid = "param-sfc"
        AND param-manuf.cod-param = "l-ferramentaria-operacao" EXCLUSIVE-LOCK:
  END.

  ASSIGN param-manuf.param-logico =  tgFerramtOper:checked IN FRAME {&FRAME-NAME}.
  
  FOR FIRST param-manuf
      WHERE param-manuf.cod-entid = "param-sfc"
        AND param-manuf.cod-param = "l-bloqueia-reporte-futuro" EXCLUSIVE-LOCK:
  END.

  ASSIGN param-manuf.param-logico =  tgBloqueiaReporteFuturo:checked IN FRAME {&FRAME-NAME}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-param-manuf V-table-Win 
PROCEDURE pi-trata-param-manuf :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  FOR FIRST param-manuf
      WHERE param-manuf.cod-entid = "param-sfc"
        AND param-manuf.cod-param = "log-gera-ggf-mod-prepar-padrao" NO-LOCK:
  END.

  IF NOT AVAIL param-manuf THEN DO:

      CREATE param-manuf.
      ASSIGN param-manuf.cod-entid = "param-sfc"                      
             param-manuf.cod-param = "log-gera-ggf-mod-prepar-padrao"
             param-manuf.dsl-help-msg = "Indica se o tempo de preparaá∆o da Operaá∆o dever† ser somado ao tempo do apontamento quando o tipo de reporte de GGF/MOD no CS0302 estiver como Padr∆o"
             param-manuf.desc-param = "Gera GGF/MOD prep. com reporte Padr∆o"
             param-manuf.titulo = "Prep x Reporte Padr.".
  END.   

  ASSIGN l-preparacao-padrao = param-manuf.param-logico.

  FOR FIRST param-manuf
      WHERE param-manuf.cod-entid = "param-sfc"
        AND param-manuf.cod-param = "l-reduz-parada-ggf" NO-LOCK:
  END.

  IF NOT AVAIL param-manuf THEN DO:

      CREATE param-manuf.
      ASSIGN param-manuf.cod-entid = "param-sfc"                      
             param-manuf.cod-param = "l-reduz-parada-ggf"
             param-manuf.dsl-help-msg = "Determina se o tempo de Parada dever† ser descontado do tempo total de GGF da Operaá∆o quando j† existir uma parada lanáada no mesmo hor†rio do apontamento"
             param-manuf.desc-param = "Reduz tempo de parada do Apontamento - GGF"
             param-manuf.titulo = "Parada x Rep Padr.GGF".
  END.   

  ASSIGN l-reduz-parada-ggf = param-manuf.param-logico.

  FOR FIRST param-manuf
      WHERE param-manuf.cod-entid = "param-sfc"
        AND param-manuf.cod-param = "l-reduz-parada-mob" NO-LOCK:
  END.

  IF NOT AVAIL param-manuf THEN DO:

      CREATE param-manuf.
      ASSIGN param-manuf.cod-entid = "param-sfc"                      
             param-manuf.cod-param = "l-reduz-parada-mob"
             param-manuf.dsl-help-msg = "Determina se o tempo de Parada dever† ser descontado do tempo total de MOB da Operaá∆o quando j† existir uma parada lanáada no mesmo hor†rio do apontamento"
             param-manuf.desc-param = "Reduz tempo de parada do Apontamento - MOB"
             param-manuf.titulo = "Parada x Rep Padr.MOB".
  END.   

  ASSIGN l-reduz-parada-mob = param-manuf.param-logico.

  FOR FIRST param-manuf
      WHERE param-manuf.cod-entid = "param-sfc"
        AND param-manuf.cod-param = "l-ferramentaria-operacao" NO-LOCK:
  END.

  IF NOT AVAIL param-manuf THEN DO:

      CREATE param-manuf.
      ASSIGN param-manuf.cod-entid = "param-sfc"                      
             param-manuf.cod-param = "l-ferramentaria-operacao"
             param-manuf.dsl-help-msg = "Indica se o sistema dever† permitir a abertura de ordens com tipo Ferramentaria, Ativo Fixo ou Manutená∆o com reporte por Operaá∆o/Ponto de Controle"
             param-manuf.desc-param = "Permite OP Ferramentaria por Operac∆o"
             param-manuf.titulo = "OP Ferramt x Pto Contrl".
  END. 

  ASSIGN l-ferrametaria-operacao = param-manuf.param-logico.
  
  FOR FIRST param-manuf
      WHERE param-manuf.cod-entid = "param-sfc"
        AND param-manuf.cod-param = "l-bloqueia-reporte-futuro" NO-LOCK:
  END.

  IF NOT AVAIL param-manuf THEN DO:

      CREATE param-manuf.
      ASSIGN param-manuf.cod-entid = "param-sfc"                      
             param-manuf.cod-param = "l-bloqueia-reporte-futuro"
             param-manuf.dsl-help-msg = "Indica se o sistema deve impedir que sejam efetuados reportes cuja data de tÇrmino seja maior que o dia atual."
             param-manuf.desc-param = "Bloqueia reporte data futura"
             param-manuf.titulo = "Bloqueia Rep. Futuro".
  END. 

  ASSIGN l-bloqueia-reporte-futuro = param-manuf.param-logico.

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
  {src/adm/template/snd-list.i "param-sfc"}

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

