&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*****************************************************************************/
{include/i-prgvrs.i V03IN114 2.00.00.030 } /*** "010030" 19/09/2023 09:19:50  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V03IN114 MUT}
&ENDIF

/*---------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

----------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.                 */
/*--------------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
{cdp/cdcfgmat.i}

&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */
DEFINE NEW GLOBAL SHARED VARIABLE v-row-parent AS ROWID NO-UNDO.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE BUFFER b-exame       FOR exame.
DEFINE BUFFER bf-exame      FOR exame.
DEFINE BUFFER bf-exame-2    FOR exame.
DEFINE BUFFER bf-comp-exame FOR comp-exame.
DEFINE BUFFER bf-exame-tex  FOR exame-tex.

DEFINE VARIABLE c-texto-exame  LIKE exame-tex.linha-desc NO-UNDO.
DEFINE VARIABLE l-new-record   AS LOGICAL                NO-UNDO.
DEFINE VARIABLE i-situacao     AS INTEGER                NO-UNDO.
DEFINE VARIABLE c-responsavel  AS CHARACTER              NO-UNDO.
DEFINE VARIABLE i-exportacao   AS INTEGER                NO-UNDO.
DEFINE VARIABLE l-confirma     AS LOGICAL                NO-UNDO.
DEFINE VARIABLE i-cont         AS INTEGER                NO-UNDO.
DEFINE VARIABLE estado         AS CHARACTER              NO-UNDO.

DEF TEMP-TABLE tt-comp-exame NO-UNDO
    LIKE comp-exame.

DEFINE VARIABLE l-entrou-copia AS LOGICAL     NO-UNDO.

FIND FIRST param-cq NO-LOCK NO-ERROR.

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
&Scoped-define EXTERNAL-TABLES exame
&Scoped-define FIRST-EXTERNAL-TABLE exame


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR exame.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS exame.descricao exame.frequencia ~
exame.situacao exame.amostragem exame.tam-fixo-amost exame.homogeneo ~
exame.rejeita-lote exame.destrutivo exame.log-exter exame.cod-resp 
&Scoped-define ENABLED-TABLES exame
&Scoped-define FIRST-ENABLED-TABLE exame
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold bt-narrativa c-label-situacao 
&Scoped-Define DISPLAYED-FIELDS exame.cod-exame exame.descricao ~
exame.cdn-versao exame.frequencia exame.situacao exame.amostragem ~
exame.tam-fixo-amost exame.homogeneo exame.rejeita-lote exame.destrutivo ~
exame.log-exter exame.cod-resp 
&Scoped-define DISPLAYED-TABLES exame
&Scoped-define FIRST-DISPLAYED-TABLE exame
&Scoped-Define DISPLAYED-OBJECTS c-nome-resp c-label-situacao 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS exame.cod-exame exame.cdn-versao 

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
DEFINE BUTTON bt-narrativa 
     LABEL "Narrativa" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-label-situacao AS CHARACTER FORMAT "X(20)":U INITIAL "Situaá∆o:" 
      VIEW-AS TEXT 
     SIZE 6.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-resp AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 35.29 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87.72 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87.72 BY 11.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     bt-narrativa AT ROW 14.42 COL 1
     exame.cod-exame AT ROW 1.17 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     exame.descricao AT ROW 2.67 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 31.43 BY .88
     exame.cdn-versao AT ROW 3.75 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY 1
     exame.frequencia AT ROW 5 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     exame.situacao AT ROW 6 COL 28 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Ativo", 1,
"Inativo", 2
          SIZE 18.29 BY .75
     exame.amostragem AT ROW 6.92 COL 28
          VIEW-AS TOGGLE-BOX
          SIZE 15.29 BY .75
     exame.tam-fixo-amost AT ROW 7.92 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     exame.homogeneo AT ROW 8.92 COL 28
          VIEW-AS TOGGLE-BOX
          SIZE 16 BY .75
     exame.rejeita-lote AT ROW 9.92 COL 28
          VIEW-AS TOGGLE-BOX
          SIZE 16.57 BY .75
     exame.destrutivo AT ROW 10.92 COL 28
          VIEW-AS TOGGLE-BOX
          SIZE 14.43 BY .75
     exame.log-exter AT ROW 11.92 COL 28 WIDGET-ID 2
          VIEW-AS TOGGLE-BOX
          SIZE 11.29 BY .75
     exame.cod-resp AT ROW 12.92 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     c-nome-resp AT ROW 12.92 COL 42.72 COLON-ALIGNED HELP
          "Nome Completo do Responsavel" NO-LABEL
     c-label-situacao AT ROW 6 COL 19 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.exame
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
         HEIGHT             = 14.58
         WIDTH              = 88.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R,COLUMNS                    */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-nome-resp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN exame.cdn-versao IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN exame.cod-exame IN FRAME f-main
   NO-ENABLE 1                                                          */
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

&Scoped-define SELF-NAME exame.amostragem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL exame.amostragem V-table-Win
ON VALUE-CHANGED OF exame.amostragem IN FRAME f-main /* Amostragem */
DO:
  if exame.amostragem:checked in frame {&FRAME-NAME} = yes then do:
     assign  exame.tam-fixo-amost:screen-value in frame {&FRAME-NAME} = "0".
     disable exame.tam-fixo-amost with frame {&FRAME-NAME}.
  end.
  else
     enable exame.tam-fixo-amost with frame {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-narrativa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-narrativa V-table-Win
ON CHOOSE OF bt-narrativa IN FRAME f-main /* Narrativa */
DO:
    RUN cqp/cq9012.w (input-output c-texto-exame).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-narrativa V-table-Win
ON RETURN OF bt-narrativa IN FRAME f-main /* Narrativa */
DO:
  apply "choose":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME exame.cod-exame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL exame.cod-exame V-table-Win
ON LEAVE OF exame.cod-exame IN FRAME f-main /* Exame */
DO: 
    CASE estado:
        WHEN "Copia":U THEN
            RUN pi-leave-exame-copia.
        WHEN "gerar-nova-versao":U THEN 
            RUN pi-leave-exame-gerar-nova-versao.
        OTHERWISE 
            RUN pi-leave-exame.
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME exame.cod-resp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL exame.cod-resp V-table-Win
ON F5 OF exame.cod-resp IN FRAME f-main /* Respons†vel */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom="inzoom/z01in391.w"
                  &tabela=exame
                  &atributo=cod-resp}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL exame.cod-resp V-table-Win
ON LEAVE OF exame.cod-resp IN FRAME f-main /* Respons†vel */
DO:
  {include/leave.i &tabela=responsavel
                   &atributo-ref=nome-resp
                   &variavel-ref=c-nome-resp
                   &where="responsavel.cod-resp = input frame {&FRAME-NAME} exame.cod-resp"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL exame.cod-resp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF exame.cod-resp IN FRAME f-main /* Respons†vel */
DO:
  apply 'F5' to self.
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

    
  if exame.cod-resp:load-mouse-pointer ("image~\lupa.cur") in frame {&FRAME-NAME} then.

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
  {src/adm/template/row-list.i "exame"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "exame"}

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

  &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
      find last exame no-lock no-error.
      if  avail exame then do:
          assign i-cont = exame.cod-exame + 1
                 exame.cod-exame:screen-value in frame {&frame-name} = string(i-cont).
      end.
      else do:
          assign exame.cod-exame:screen-value in frame {&frame-name} = "1".
      end.
  &ENDIF

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
    if  not frame {&frame-name}:validate() then
        return 'ADM-ERROR':U.
    
    /* Ponha aqui a validaá∆o de chave duplicada */
    IF adm-new-record THEN DO:
        FIND FIRST bf-exame NO-LOCK
              WHERE bf-exame.cod-exame  = INT(exame.cod-exame:screen-value in frame {&FRAME-NAME}) NO-ERROR.
        
        IF  AVAIL bf-exame 
        AND AVAIL param-cq 
        AND param-cq.log-2 = NO THEN DO: 
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 1, 
                               INPUT "Exame").
            apply 'entry' to exame.cod-exame.
            return 'adm-error'.
        END. 
    END.
    
    /* Ponha aqui as demais validaá‰es */
    find responsavel no-lock
        where responsavel.cod-resp = exame.cod-resp:screen-value in frame {&FRAME-NAME} no-error.
    if not avail responsavel then do:
       {utp/ut-table.i mgind responsavel 1}
       run utp/ut-msgs.p (input "show",
                          input 2,
                          input return-value).
       apply 'entry' to exame.cod-resp.
       return 'adm-error'.
    end.
    
    /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    IF RETURN-VALUE = 'ADM-ERROR':U then 
        RETURN 'ADM-ERROR':U.
    
    /* QUANDO SE TRATAR DE INCLUSAO 
       SETAR A SITUAÄ«O DA VERS«O COMO PENDENTE */
    IF adm-new-record THEN DO:
    
        IF  AVAIL param-cq 
        AND param-cq.log-2 = YES THEN
            ASSIGN exame.cdn-sit-vers = 1 /* Pendente */.
        ELSE ASSIGN exame.cdn-sit-vers = 2 /* Liberado */.
    
        /* QUENDO INCLUSAO OU GERAR NOVA VERSAO, COPIAR OS COMPONENTES */
        FOR EACH tt-comp-exame:
            CREATE comp-exame.
            BUFFER-COPY tt-comp-exame TO comp-exame.
        END.
    
        EMPTY TEMP-TABLE tt-comp-exame NO-ERROR.
    END.
  
  
    /*Atualiza descricao do relacionamento do exame com itens quando n„o est·
      parametrizado controle de vers„o */
    IF AVAILABLE param-cq 
    AND NOT param-cq.log-2 THEN DO:
        FOR EACH it-exame EXCLUSIVE-LOCK
           WHERE it-exame.cod-exame = INPUT FRAME {&FRAME-NAME} exame.cod-exame:
            ASSIGN it-exame.descricao = INPUT FRAME {&FRAME-NAME} exame.descricao.
        END.
    END.
    
    /* Code placed here will execute AFTER standard behavior.    */     
    IF exame.cod-exame:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
       CREATE exame-tex.
       ASSIGN exame-tex.cod-exame  = exame.cod-exame
              exame-tex.cdn-versao = exame.cdn-versao
              exame-tex.linha-desc = c-texto-exame.
    END.
    ELSE DO:
       FIND FIRST exame-tex EXCLUSIVE-LOCK
            WHERE exame-tex.cod-exame  = exame.cod-exame  
              AND exame-tex.cdn-versao = exame.cdn-versao NO-ERROR.
        IF AVAILABLE exame-tex THEN
           ASSIGN exame-tex.linha-desc = c-texto-exame.
        ELSE DO:
           CREATE exame-tex.
           ASSIGN exame-tex.cod-exame  = exame.cod-exame
                  exame-tex.cdn-versao = exame.cdn-versao
                  exame-tex.linha-desc = c-texto-exame.
        END.       
    END.
   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

    IF estado = "gerar-nova-versao" THEN
        DISABLE exame.cod-exame 
           WITH FRAME {&frame-name}.

    DISABLE exame.cdn-versao 
            WITH FRAME {&frame-name}.
    
    RETURN "OK":U.
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
  if avail exame then do:
     find responsavel no-lock
        where responsavel.cod-resp = exame.cod-resp no-error.
     assign c-nome-resp = if avail responsavel then responsavel.nome-resp else "":U.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  assign i-situacao    = integer(exame.situacao:screen-value in frame {&FRAME-NAME})
         c-responsavel = exame.cod-resp:screen-value in frame {&FRAME-NAME}.
         
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
  run get-attribute ('adm-new-record').
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  run get-attribute ('adm-new-record').
  if return-value = 'yes' then do:
    assign exame.amostragem:checked in frame {&FRAME-NAME} = no.
  end.
  
  apply "value-changed" to exame.amostragem in frame {&FRAME-NAME}.
  assign c-texto-exame = "".


  /* DESABILITA CAMPO VERSAO POIS A MESMA SERµ SUGERIDA AO DIGITAR O CODIGO DO EXAME */
  ASSIGN exame.cdn-versao:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  
  IF estado = "copia":U 
  OR estado = "gerar-nova-versao":U THEN
      apply "leave" to exame.cod-exame in frame {&FRAME-NAME}.
      
    /* Buffer carregado quando copia ou gerar nova versao */
    IF AVAILABLE bf-exame-tex THEN DO:
        IF c-texto-exame = "" THEN 
            ASSIGN c-texto-exame = bf-exame-tex.linha-desc.
    END.

    CASE estado:
        WHEN "Inclui" THEN DO:
        END.
        WHEN "Copia" THEN DO:
            IF avail bf-exame-tex AND c-texto-exame = "" THEN 
                ASSIGN c-texto-exame = bf-exame-tex.linha-desc.
        END.
        OTHERWISE DO:
            FIND FIRST exame-tex no-lock
                 where exame-tex.cod-exame  = integer(exame.cod-exame:screen-value in frame {&FRAME-NAME})
                   AND exame-tex.cdn-versao = integer(exame.cdn-versao:screen-value in frame {&FRAME-NAME})no-error.
            IF AVAILABLE exame-tex THEN 
                ASSIGN c-texto-exame = exame-tex.linha-desc.
        END.
    END CASE.
      
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
  
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exporta V-table-Win 
PROCEDURE pi-exporta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
for each it-exame exclusive-lock
   where it-exame.cod-exame = exame.cod-exame.
   assign it-exame.situacao    = integer(exame.situacao:screen-value in frame {&FRAME-NAME})
          it-exame.responsavel = exame.cod-resp:screen-value         in frame {&FRAME-NAME}.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exporta-confirmando V-table-Win 
PROCEDURE pi-exporta-confirmando :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
for each it-exame exclusive-lock
   where it-exame.cod-exame = exame.cod-exame.
  run cqp/cq9005.w (input it-exame.it-codigo, input it-exame.cod-exame, input it-exame.situacao, input it-exame.responsavel, output l-confirma).
   if l-confirma = yes then
      assign it-exame.situacao    = integer(exame.situacao:screen-value in frame {&FRAME-NAME})
             it-exame.responsavel = exame.cod-resp:screen-value         in frame {&FRAME-NAME}.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exportacao-exames-item V-table-Win 
PROCEDURE pi-exportacao-exames-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  if (exame.cod-exame:sensitive in frame {&FRAME-NAME} = no) and
     (integer(exame.situacao:screen-value in frame {&FRAME-NAME}) <> i-situacao or
      exame.cod-resp:screen-value in frame {&FRAME-NAME} <> c-responsavel) then do:
     run cqp/cq9014.w (output i-exportacao).
     if i-exportacao = 3 then
        run pi-exporta-confirmando.
     if i-exportacao = 2 then
        run pi-exporta.
  end.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave-exame V-table-Win 
PROCEDURE pi-leave-exame :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cod-exame  AS INTEGER NO-UNDO.

    /* BUSCA ULTIMA VERSAO DO EXAME */
    FIND LAST bf-exame NO-LOCK
        WHERE bf-exame.cod-exame = INPUT FRAME {&FRAME-NAME} exame.cod-exame NO-ERROR.
    
    IF AVAILABLE bf-exame THEN DO:
    
        /* VERIFICA SE J¡ EXISTE VERS√O PENDENTE */
        FOR FIRST bf-exame-2 NO-LOCK
            WHERE bf-exame-2.cod-exame = INPUT FRAME {&FRAME-NAME} exame.cod-exame
              AND bf-exame-2.cdn-sit-vers = 1:
            
            run utp/ut-msgs.p (input "show",
                               input 55517, /* Exame &1 possui vers„o pendente de liberaÁ„o */
                               input STRING(bf-exame-2.cod-exame) + "~~" + STRING(bf-exame-2.cdn-versao)).
                
            /* BUSCA ULTIMO EXAME CADASTRADO */
            FIND LAST bf-exame NO-LOCK NO-ERROR.
            
            ASSIGN i-cod-exame = bf-exame.cod-exame + 1 /* INCREMEENTA CODIGO DO EXAME */
                   exame.cod-exame:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(i-cod-exame) /* SUGERE EXAME NA TELA*/
                   exame.cdn-versao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1":U.
            RETURN "NOK":U.
        END.
        
        IF AVAIL param-cq 
        AND param-cq.log-2 = YES THEN DO: 

            /* LIMPA BUFFER */
            RELEASE bf-exame-tex NO-ERROR.
        
            ASSIGN exame.cdn-versao:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = STRING(bf-exame.cdn-versao + 1).
            
            /* SUGERE INFORMAÄÂES DA VERS«O EXAME EXISTENTE */
            ASSIGN exame.descricao:SCREEN-VALUE      IN FRAME {&FRAME-NAME}  = bf-exame.descricao
                   
                   exame.frequencia:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = STRING(bf-exame.frequencia)
                   exame.tam-fixo-amost:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(bf-exame.tam-fixo-amost)
                   exame.cod-resp:SCREEN-VALUE       IN FRAME {&FRAME-NAME} = bf-exame.cod-resp
            
                   exame.amostragem:CHECKED          IN FRAME {&FRAME-NAME} = bf-exame.amostragem
                   exame.homogeneo:CHECKED           IN FRAME {&FRAME-NAME} = bf-exame.homogeneo
                   exame.rejeita-lote:CHECKED        IN FRAME {&FRAME-NAME} = bf-exame.rejeita-lote
                   exame.destrutivo:CHECKED          IN FRAME {&FRAME-NAME} = bf-exame.destrutivo
                   exame.log-exter:CHECKED           IN FRAME {&FRAME-NAME} = bf-exame.log-exter.
            
            /* BUSCA DESCRIÄ«O DO RESPONSµVEL */
            IF bf-exame.cod-resp <> "" THEN
                APPLY "LEAVE":U TO exame.cod-resp IN FRAME {&FRAME-NAME}.
            
            EMPTY TEMP-TABLE tt-comp-exame NO-ERROR.
    
            IF estado <> "Copia" THEN DO:
                /* BUSCA OS COMPONENTES DA VERS«O DO EXAME EXISTENTE*/
                FOR EACH bf-comp-exame OF bf-exame NO-LOCK:        
                    CREATE tt-comp-exame.
                    BUFFER-COPY bf-comp-exame TO tt-comp-exame.
                    ASSIGN tt-comp-exame.cod-exame  = INPUT FRAME {&FRAME-NAME} exame.cod-exame
                           tt-comp-exame.cdn-versao = INPUT FRAME {&FRAME-NAME} exame.cdn-versao.
                END.
            END.
        END.
        ELSE ASSIGN exame.cdn-versao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1":U.
    END.
    ELSE 
        ASSIGN exame.cdn-versao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave-exame-copia V-table-Win 
PROCEDURE pi-leave-exame-copia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cod-exame  AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-cdn-versao AS INTEGER NO-UNDO.
    
    IF NOT l-entrou-copia THEN DO:
        ASSIGN l-entrou-copia = YES.

       /* BUSCA CODIGO DO EXAME */
       FIND LAST bf-exame NO-LOCK NO-ERROR.        
       IF AVAILABLE bf-exame THEN
           ASSIGN i-cod-exame = bf-exame.cod-exame + 1.
        
        /* POSICIONA NO EXAME QUE SER¡ COPIADO*/
        FIND FIRST bf-exame NO-LOCK
             WHERE bf-exame.cod-exame  = INPUT FRAME {&FRAME-NAME} exame.cod-exame 
               AND bf-exame.cdn-versao = INPUT FRAME {&FRAME-NAME} exame.cdn-versao NO-ERROR.
               
        IF AVAILABLE bf-exame THEN DO:
           ASSIGN exame.cod-exame:SCREEN-VALUE      IN FRAME {&FRAME-NAME} =  string(i-cod-exame)
                  exame.cdn-versao:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = "1".
           
           /* SUGERE INFORMAÄÂES DA VERS«O EXAME EXISTENTE */
           ASSIGN exame.descricao:SCREEN-VALUE      IN FRAME {&FRAME-NAME}  = bf-exame.descricao
                  
                  exame.frequencia:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = STRING(bf-exame.frequencia)
                  exame.tam-fixo-amost:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(bf-exame.tam-fixo-amost)
                  exame.cod-resp:SCREEN-VALUE       IN FRAME {&FRAME-NAME} = bf-exame.cod-resp
           
                  exame.amostragem:CHECKED          IN FRAME {&FRAME-NAME} = bf-exame.amostragem
                  exame.homogeneo:CHECKED           IN FRAME {&FRAME-NAME} = bf-exame.homogeneo
                  exame.rejeita-lote:CHECKED        IN FRAME {&FRAME-NAME} = bf-exame.rejeita-lote
                  exame.destrutivo:CHECKED          IN FRAME {&FRAME-NAME} = bf-exame.destrutivo
                  exame.log-exter:CHECKED           IN FRAME {&FRAME-NAME} = bf-exame.log-exter.
           
           /* BUSCA DESCRIÄ«O DO RESPONSµVEL */
           IF bf-exame.cod-resp <> "" THEN
               APPLY "LEAVE":U TO exame.cod-resp IN FRAME {&FRAME-NAME}.
           
           EMPTY TEMP-TABLE tt-comp-exame NO-ERROR.
           
           /* POSICIONA NA TABELA EXAME-TEX */
           FOR FIRST bf-exame-tex OF bf-exame NO-LOCK:
           END.
       END.
       ELSE 
           ASSIGN exame.cdn-versao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1":U.
    END.
    ELSE DO:
        FIND LAST bf-exame NO-LOCK
            WHERE bf-exame.cod-exame = INPUT FRAME {&FRAME-NAME} exame.cod-exame NO-ERROR.
        IF AVAILABLE bf-exame THEN DO:
            /*N∆o Ç permitido gerar nova vers∆o pelo bot∆o "C¢pia". Utilizar bot∆o "Gerar Nova Vers∆o".*/
            run utp/ut-msgs.p (input "show",
                               input 55506,
                               input "").

            /* BUSCA CODIGO DO EXAME */
            FIND LAST bf-exame NO-LOCK NO-ERROR.        
            IF AVAILABLE bf-exame THEN
                ASSIGN i-cod-exame = bf-exame.cod-exame + 1
                       exame.cod-exame:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(i-cod-exame)
                       exame.cdn-versao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1":U.
            
        END.
        ELSE 
            ASSIGN exame.cdn-versao:SCREEN-VALUE   IN FRAME {&FRAME-NAME} = "1":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave-exame-gerar-nova-versao V-table-Win 
PROCEDURE pi-leave-exame-gerar-nova-versao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cdn-versao AS INTEGER NO-UNDO.

    /* BUSCA CODIGO DA ULTIMA VERSAO */
    FIND LAST bf-exame NO-LOCK
        WHERE bf-exame.cod-exame = INPUT FRAME {&FRAME-NAME} exame.cod-exame NO-ERROR.        
    IF AVAILABLE bf-exame THEN
        ASSIGN i-cdn-versao = bf-exame.cdn-versao + 1.
     
     /* POSICIONA NO EXAME QUE SER¡ COPIADO*/
     FIND FIRST bf-exame NO-LOCK
          WHERE bf-exame.cod-exame  = INPUT FRAME {&FRAME-NAME} exame.cod-exame 
            AND bf-exame.cdn-versao = INPUT FRAME {&FRAME-NAME} exame.cdn-versao NO-ERROR.
            
     IF AVAILABLE bf-exame THEN DO:
    
        ASSIGN exame.cdn-versao:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = STRING(i-cdn-versao).
        
        /* SUGERE INFORMAÄÂES DA VERS«O EXAME EXISTENTE */
        ASSIGN exame.descricao:SCREEN-VALUE      IN FRAME {&FRAME-NAME}  = bf-exame.descricao
               
               exame.frequencia:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = STRING(bf-exame.frequencia)
               exame.tam-fixo-amost:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(bf-exame.tam-fixo-amost)
               exame.cod-resp:SCREEN-VALUE       IN FRAME {&FRAME-NAME} = bf-exame.cod-resp
        
               exame.amostragem:CHECKED          IN FRAME {&FRAME-NAME} = bf-exame.amostragem
               exame.homogeneo:CHECKED           IN FRAME {&FRAME-NAME} = bf-exame.homogeneo
               exame.rejeita-lote:CHECKED        IN FRAME {&FRAME-NAME} = bf-exame.rejeita-lote
               exame.destrutivo:CHECKED          IN FRAME {&FRAME-NAME} = bf-exame.destrutivo
               exame.log-exter:CHECKED           IN FRAME {&FRAME-NAME} = bf-exame.log-exter.
        
        /* BUSCA DESCRIÄ«O DO RESPONSµVEL */
        IF bf-exame.cod-resp <> "" THEN
            APPLY "LEAVE":U TO exame.cod-resp IN FRAME {&FRAME-NAME}.
        
        EMPTY TEMP-TABLE tt-comp-exame NO-ERROR.
        FOR EACH bf-comp-exame OF bf-exame NO-LOCK:        
            CREATE tt-comp-exame.
            BUFFER-COPY bf-comp-exame TO tt-comp-exame.
            ASSIGN tt-comp-exame.cod-exame  = INPUT FRAME {&FRAME-NAME} exame.cod-exame
                   tt-comp-exame.cdn-versao = INPUT FRAME {&FRAME-NAME} exame.cdn-versao.
        END.
        
        /* POSICIONA NA TABELA EXAME-TEX */
        FOR FIRST bf-exame-tex OF bf-exame NO-LOCK:
        END.
    END.
    ELSE 
        ASSIGN exame.cdn-versao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1":U.
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-estado V-table-Win 
PROCEDURE pi-recebe-estado :
/*------------------------------------------------------------------------------
  Purpose: Manuseia trocas de estado dos SmartObjects    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

    ASSIGN estado = p-state.

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
  {src/adm/template/snd-list.i "exame"}

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

