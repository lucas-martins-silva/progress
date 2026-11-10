&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            ORACLE
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
{include/i-prgvrs.i V05IN280 2.00.00.008 } /*** "010008" 29/08/2024 17:48:18 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V05IN280 MUT}
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

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-boin00885 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boin00886 AS HANDLE      NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES param-compra
&Scoped-define FIRST-EXTERNAL-TABLE param-compra


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-compra.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-compra.log-livre-1 
&Scoped-define ENABLED-TABLES param-compra
&Scoped-define FIRST-ENABLED-TABLE param-compra
&Scoped-Define ENABLED-OBJECTS rt-key-4 rt-mold tg-clicbusiness ~
tg-experiencia-uso tg-cotacao-visivel tg-homologacao tg-producao c-ambiente tg-dt-prev-pgto fi-tp-codigo tg-integr-me rt-integr-me c-integr-me
&Scoped-Define DISPLAYED-FIELDS param-compra.log-livre-1 
&Scoped-define DISPLAYED-TABLES param-compra
&Scoped-define FIRST-DISPLAYED-TABLE param-compra
&Scoped-Define DISPLAYED-OBJECTS fi-desc-tp-desp tg-clicbusiness tg-experiencia-uso ~
tg-cotacao-visivel tg-homologacao tg-producao c-ambiente tg-dt-prev-pgto tg-integr-me c-integr-me 

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
DEFINE VARIABLE c-ambiente AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 8.43 BY .67 NO-UNDO.
     
DEFINE VARIABLE c-integr-me AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 23 BY .67 NO-UNDO.

DEFINE RECTANGLE rt-key-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42 BY 7.75.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 35 BY 3.08.

DEFINE VARIABLE tg-clicbusiness AS LOGICAL INITIAL yes 
     LABEL "Clicbusiness" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE tg-cotacao-visivel AS LOGICAL INITIAL yes 
     LABEL "Cotaá‰es vis°veis no Clicbusiness" 
     VIEW-AS TOGGLE-BOX
     SIZE 36 BY .83 NO-UNDO.

DEFINE VARIABLE tg-experiencia-uso AS LOGICAL INITIAL no 
     LABEL "Experiància de uso aceita" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .83 NO-UNDO.

DEFINE VARIABLE tg-homologacao AS LOGICAL INITIAL no 
     LABEL "Homologaá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.

DEFINE VARIABLE fi-tp-codigo AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Tp.Receita" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE tg-dt-prev-pgto AS LOGICAL INITIAL no 
     LABEL "Considera Data Prev. Pagamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .83 NO-UNDO.
     
DEFINE VARIABLE tg-integr-me    AS LOGICAL INITIAL NO
     LABEL "Utiliza Integraá∆o ME":U
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE fi-desc-tp-desp AS CHARACTER FORMAT "X(55)":U 
     VIEW-AS FILL-IN 
     SIZE 19.5 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-fluxo-cx
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 35 BY 3.75.
     
DEFINE RECTANGLE rt-integr-me
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 35 BY 3.20.

DEFINE VARIABLE tg-producao AS LOGICAL INITIAL no 
     LABEL "Produá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     tg-clicbusiness AT ROW 1.88 COL 3
     param-compra.log-livre-1 AT ROW 2.5 COL 42
          VIEW-AS TOGGLE-BOX
          SIZE 1 BY .25
     tg-experiencia-uso AT ROW 3.08 COL 5
     tg-cotacao-visivel AT ROW 4.33 COL 5
     tg-homologacao AT ROW 7 COL 5.57
     tg-producao AT ROW 7 COL 21.86
     c-ambiente AT ROW 5.63 COL 4.57 NO-LABEL
     rt-key-4 AT ROW 2.25 COL 2
     rt-mold AT ROW 5.92 COL 3

     fi-tp-codigo AT ROW 3.04 COL 53 COLON-ALIGNED WIDGET-ID 6
     tg-dt-prev-pgto AT ROW 4.33 COL 53 COLON-ALIGNED
     tg-integr-me    AT ROW 8  COL 53 COLON-ALIGNED
     fi-desc-tp-desp AT ROW 3.04 COL 58.35 COLON-ALIGNED NO-LABEL
     "Fluxo Caixa - Antecipaá∆o Ordem Compra" VIEW-AS TEXT
          SIZE 29 BY .67 AT ROW 1.9 COL 48.9 WIDGET-ID 4
     rt-fluxo-cx AT ROW 2.25 COL 46.14 WIDGET-ID 2
     rt-integr-me AT ROW 6.8 COL 46.14
     c-integr-me AT ROW 6.45 COL 48.9 NO-LABEL

    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-compra
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
         HEIGHT             = 11.75
         WIDTH              = 84.14.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-ambiente IN FRAME f-main
   ALIGN-L                                                              */
ASSIGN 
       param-compra.log-livre-1:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME tg-clicbusiness
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-clicbusiness V-table-Win
ON VALUE-CHANGED OF tg-clicbusiness IN FRAME f-main /* Clicbusiness */
DO:
  IF tg-clicbusiness:CHECKED THEN DO:
      RUN pi-habilita-clicbusiness (INPUT TRUE).      
  END.      
  ELSE
      RUN pi-habilita-clicbusiness (INPUT FALSE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-experiencia-uso
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-experiencia-uso V-table-Win
ON VALUE-CHANGED OF tg-experiencia-uso IN FRAME f-main /* Experiància de uso aceita */
DO:
    DEFINE VARIABLE hProgram          AS HANDLE NO-UNDO.
    /*--- Seta cursor do mouse para espera ---*/
    SESSION:SET-WAIT-STATE("GENERAL":U).
    {&WINDOW-NAME}:SENSITIVE = NO.
    
    RUN ccp/cc0104a.w PERSISTENT SET hProgram.
    
    /** Validaá∆o do Handle **/
    IF  VALID-HANDLE(hProgram) AND
        hProgram:TYPE = "PROCEDURE":U AND
        hProgram:FILE-NAME = "ccp/cc0104a.w":U THEN DO:
        /*--- Inicializa programa de alteraá∆o dos par≥metros ---*/
        RUN initializeInterface IN hProgram. 
    END.
    /** Espera pelo fechamento do programa **/
    WAIT-FOR "CLOSE":U of hProgram.        
    
    SESSION:IMMEDIATE-DISPLAY = TRUE.
    {&WINDOW-NAME}:SENSITIVE = YES.

    IF  VALID-HANDLE(hProgram) THEN DO:
        DELETE PROCEDURE hProgram.            
    END.

    FIND FIRST param-compra NO-LOCK NO-ERROR.
    IF AVAIL param-compra THEN DO:
        /*Verifica se o termo de aceite est† aceito*/
        IF SUBSTRING(param-compra.char-2,105,1) = "S":U THEN DO:
            ASSIGN tg-experiencia-uso:SENSITIVE = FALSE
                   tg-experiencia-uso:CHECKED = TRUE.
        END.
        ELSE
            ASSIGN tg-experiencia-uso:CHECKED = FALSE.

        ASSIGN tg-homologacao:CHECKED = IF SUBSTRING(param-compra.char-2,107,1) = "H":U THEN TRUE ELSE FALSE /*Verifica se o ambiente do clicbusiness Ç o de homologaá∆o*/
               tg-producao:CHECKED = IF SUBSTRING(param-compra.char-2,107,1) = "P":U THEN TRUE ELSE FALSE /*Verifica se o ambiente do clicbusiness Ç o de Produá∆o*/.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-homologacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-homologacao V-table-Win
ON VALUE-CHANGED OF tg-homologacao IN FRAME f-main /* Homologaá∆o */
DO:
    IF tg-homologacao:CHECKED THEN
        ASSIGN tg-producao:CHECKED = FALSE.
    ELSE
        ASSIGN tg-producao:CHECKED = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-producao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-producao V-table-Win
ON VALUE-CHANGED OF tg-producao IN FRAME f-main /* Produá∆o */
DO:
    IF tg-producao:CHECKED THEN
        ASSIGN tg-homologacao:CHECKED = FALSE.
    ELSE
        ASSIGN tg-homologacao:CHECKED = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-integr-me
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-integr-me V-table-Win
ON VALUE-CHANGED OF tg-integr-me IN FRAME f-main /* Integra Me */
DO:
    IF NOT tg-integr-me:CHECKED THEN DO:
        FOR EACH ordem-compra-integr-me NO-LOCK WHERE ordem-compra-integr-me.idi-tipo-acao <> 3: // s¢ verifica ordens que n∆o est∆o eliminadas no datasul
            FIND FIRST ordem-compra 
                 WHERE ordem-compra.numero-ordem = ordem-compra-integr-me.numero-ordem
                   AND ordem-compra.situacao <> 6 NO-LOCK NO-ERROR. // verifica se existem ordens que ainda nao est∆o recebidas
            IF AVAIL ordem-compra THEN DO:
                ASSIGN tg-integr-me:CHECKED = TRUE.
                RUN utp/ut-msgs.p (INPUT "show":U, INPUT 57838, INPUT "Integraá∆o com ME":U).
                APPLY "entry":U TO tg-integr-me IN FRAME {&FRAME-NAME}.
                RETURN "adm-error":U.
            END.
        END. 
    END.
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-tp-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-tp-codigo V-table-Win
ON F5 OF fi-tp-codigo IN FRAME f-main /* Tipo Despesa */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad259.w
                       &campo=fi-tp-codigo
                       &campozoom=tp-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-tp-codigo V-table-Win
ON LEAVE OF fi-tp-codigo IN FRAME f-main /* Tipo Despesa */
DO:
    {include/leave.i &tabela=tipo-rec-desp
                     &atributo-ref=descricao tipo
                     &variavel-ref=fi-desc-tp-desp
                     &where="tipo-rec-desp.tp-codigo = input frame {&frame-name} fi-tp-codigo"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-tp-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-tp-codigo IN FRAME f-main /* Tipo Despesa */
DO:
    apply "F5" to self.
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

  if fi-tp-codigo:load-mouse-pointer("image/lupa.cur")   then.

  FIND FIRST tipo-rec-desp WHERE tipo-rec-desp.tp-codigo = INPUT FRAME {&FRAME-NAME} fi-tp-codigo
                           NO-LOCK NO-ERROR.
  IF AVAIL tipo-rec-desp THEN
      ASSIGN fi-desc-tp-desp = tipo-rec-desp.descricao.

/*{utp/ut-rtlbl.i mgind param-compra limite    fi-limite}
{utp/ut-rtlbl.i mgind param-compra nome-ass  fi-nome-ass}
{utp/ut-rtlbl.i mgind param-compra cargo-ass fi-cargo-ass}*/

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
  {src/adm/template/row-list.i "param-compra"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-compra"}

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
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if  RETURN-VALUE = 'ADM-ERROR':U then 
      RETURN 'ADM-ERROR':U.

  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

  DEFINE VARIABLE c-homologacao AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c-producao    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c-ambiente    AS CHARACTER  NO-UNDO.

  ASSIGN c-homologacao = IF tg-homologacao:CHECKED IN FRAME {&frame-name} THEN "H":U ELSE "" /*Seta a var°avel do ambeinte do clicbusiness como homologaá∆o*/
         c-producao    = IF tg-producao:CHECKED IN FRAME {&frame-name} THEN "P":U ELSE "". /*Seta a var°avel do ambeinte do clicbusiness como produá∆o*/

  IF AVAIL param-compra THEN DO:

      ASSIGN OVERLAY(param-compra.char-1,104,3) = STRING(INPUT FRAME {&FRAME-NAME} fi-tp-codigo, ">>9")
             param-compra.consid-dt-prev-pagto =  IF tg-dt-prev-pgto:CHECKED IN FRAME {&frame-name} THEN YES ELSE NO
             c-ambiente                         = SUBSTRING(param-compra.char-2,107,1)                                    /*Pega o ambiente atual do clicbusiness*/
             OVERLAY(param-compra.char-2,104,1) = IF tg-clicbusiness:CHECKED IN FRAME {&frame-name} THEN "S":U ELSE "N":U /*Grava se o clicbusiness est† ativo*/
             OVERLAY(param-compra.char-2,105,1) = IF tg-experiencia-uso:CHECKED IN FRAME {&frame-name} THEN "S":U ELSE "N":U /*Grava se o termo de aceite foi aceito*/
             OVERLAY(param-compra.char-2,106,1) = IF tg-cotacao-visivel:CHECKED IN FRAME {&frame-name} THEN "S":U ELSE "N":U /*Grava se a cotaá∆o est† visivel no portal*/
             OVERLAY(param-compra.char-2,107,1) = IF c-homologacao = "H":U THEN "H":U ELSE IF c-producao = "P":U THEN "P":U ELSE "". /*Grava qual ambiente foi escolhido homologaá∆o, Produá∆o ou nenhum.*/
             
      // busca/cria funcao Mercado Eletronico
      FIND FIRST funcao EXCLUSIVE-LOCK
           WHERE funcao.cd-funcao = "SPP-INTEGRA-PORTAL-ME":U NO-ERROR.
      IF AVAIL funcao THEN DO:
          ASSIGN funcao.ativo = IF tg-integr-me:CHECKED IN FRAME {&FRAME-NAME} THEN TRUE ELSE FALSE.
      END.
      ELSE DO:
          CREATE funcao.
          ASSIGN funcao.cd-funcao = "SPP-INTEGRA-PORTAL-ME":U
                 funcao.descricao = "Utiliza Integracao ME":U
                 funcao.ativo     = IF tg-integr-me:CHECKED IN FRAME {&FRAME-NAME} THEN TRUE ELSE FALSE.
      END.
             

      IF NOT VALID-HANDLE(h-boin00885) THEN DO:
          RUN inbo/boin00885.p PERSISTENT SET h-boin00885.
          RUN openQueryStatic IN h-boin00885 (INPUT "Main":U) NO-ERROR.
      END.
          
      IF NOT VALID-HANDLE(h-boin00886) THEN DO:
          RUN inbo/boin00886.p PERSISTENT SET h-boin00886.
          RUN openQueryStatic IN h-boin00886 (INPUT "Main":U) NO-ERROR.
      END.

      IF c-ambiente = "H":U THEN DO: /*Ambiente do clicbusiness como homologaá∆o*/
          IF c-homologacao = "" AND c-producao = "P":U THEN DO:
              RUN pi-clearTable IN h-boin00886.
              RUN pi-clearTable IN h-boin00885.
          END.          
      END.
      ELSE IF c-ambiente = "P":U THEN DO: /*Ambiente do clicbusiness como produá∆o*/
          IF c-producao = "" AND c-homologacao = "H":U THEN DO:
              RUN pi-clearTable IN h-boin00886.
              RUN pi-clearTable IN h-boin00885.
          END.          
      END.

      IF VALID-HANDLE(h-boin00885) THEN DO:
          DELETE PROCEDURE h-boin00885.
          ASSIGN h-boin00885 = ?.
      END.
      IF VALID-HANDLE(h-boin00886) THEN DO:
          DELETE PROCEDURE h-boin00886.
          ASSIGN h-boin00886 = ?.
      END.
  END.

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
  &endif.


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

  IF AVAIL param-compra THEN DO:
      IF SUBSTRING(param-compra.char-1,104,3) <> "" THEN
          FIND FIRST tipo-rec-desp WHERE tipo-rec-desp.tp-codigo = INT(SUBSTRING(param-compra.char-1,104,3))
                                   NO-LOCK NO-ERROR.
      IF AVAIL tipo-rec-desp THEN
          ASSIGN fi-desc-tp-desp = tipo-rec-desp.descricao.
  END.
    
         

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /*if avail param-compra then do with frame {&frame-name}:
   assign c-diretorio2:screen-value = substring(param-compra.char-1, 51, 50).
   end. 
  else do:
   assign c-diretorio2:screen-value = "".
  end.*/

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

  /*if adm-new-record = yes then*/
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  /*if  avail param-compra 
  and param-compra.log-2 then do:       
     assign c-diretorio2:sensitive in frame {&frame-name} = yes
            bt-arq2:sensitive      in frame {&frame-name} = yes.
  end.
  else do:
     assign c-diretorio2:sensitive in frame {&frame-name} = no
            bt-arq2:sensitive      in frame {&frame-name} = no.
  end.*/

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

  {utp/ut-liter.i Ambiente * l}
  assign c-ambiente:screen-value in frame {&frame-name} = trim(return-value).
  
  {utp/ut-liter.i Integraá∆o_Mercado_Eletrìnico * l}
  assign c-integr-me:screen-value in frame {&frame-name} = trim(return-value).

  IF NOT AVAIL param-compra THEN
      FIND FIRST param-compra NO-LOCK NO-ERROR.

  IF SUBSTRING(param-compra.char-1,104,3) <> "":U THEN
      ASSIGN fi-tp-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(param-compra.char-1,104,3).

  IF SUBSTRING(param-compra.char-2,104,1) = "N":U THEN DO: /*Verifica se a integraá∆o com o clicbusiness est† ativa*/
      ASSIGN tg-clicbusiness:CHECKED IN FRAME {&FRAME-NAME} = FALSE.
      RUN pi-habilita-clicbusiness (INPUT FALSE).
  END.
  ELSE
      ASSIGN tg-clicbusiness:CHECKED IN FRAME {&FRAME-NAME} = TRUE.

    IF SUBSTRING(param-compra.char-2,105,1) = "S":U THEN /*Verifica se o termo de aceite foi aceito*/
        ASSIGN tg-experiencia-uso:CHECKED IN FRAME {&FRAME-NAME} = TRUE
               tg-experiencia-uso:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
               
    IF SUBSTRING(param-compra.char-2,106,1) = "N":U THEN /*Verifica se a cotaá∆o est† vis°vel no portal*/
        ASSIGN tg-cotacao-visivel:CHECKED IN FRAME {&FRAME-NAME} = FALSE.
    ELSE
        ASSIGN tg-cotacao-visivel:CHECKED IN FRAME {&FRAME-NAME} = TRUE.

    IF SUBSTRING(param-compra.char-2,107,1) = "H":U THEN /*Verifica se o ambiente Ç o de homologaá∆o*/
        ASSIGN tg-homologacao:CHECKED IN FRAME {&FRAME-NAME} = TRUE.

    IF SUBSTRING(param-compra.char-2,107,1) = "P":U THEN /*Verifica se o ambiente Ç o de Produá∆o*/
        ASSIGN tg-producao:CHECKED IN FRAME {&FRAME-NAME} = TRUE.  

    ASSIGN tg-dt-prev-pgto:CHECKED IN FRAME {&FRAME-NAME} = param-compra.consid-dt-prev-pagto.
    
    FIND FIRST funcao NO-LOCK
         WHERE funcao.cd-funcao = "SPP-INTEGRA-PORTAL-ME":U NO-ERROR.
    IF AVAIL funcao THEN DO:
        ASSIGN tg-integr-me:CHECKED IN FRAME {&FRAME-NAME} = funcao.ativo.
    END.
    ELSE DO:
        ASSIGN tg-integr-me:CHECKED IN FRAME {&FRAME-NAME} = FALSE.
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
     /*define input parameter v-row-parent-externo as rowid no-undo.

     assign v-row-parent = v-row-parent-externo.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-clicbusiness V-table-Win 
PROCEDURE pi-habilita-clicbusiness :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-habilita AS LOGICAL NO-UNDO.

    ASSIGN tg-experiencia-uso:SENSITIVE IN FRAME {&FRAME-NAME} = IF tg-experiencia-uso:CHECKED IN FRAME {&FRAME-NAME} THEN FALSE ELSE p-habilita
           tg-cotacao-visivel:SENSITIVE IN FRAME {&FRAME-NAME} = p-habilita
           tg-homologacao:SENSITIVE IN FRAME {&FRAME-NAME} = p-habilita
           tg-producao:SENSITIVE IN FRAME {&FRAME-NAME} = p-habilita.

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
    /*Se marcar o parÉmetro clicbusiness e experiància de uso 
        aceita ent∆o valida os campos de ambiente.*/
  IF tg-clicbusiness:CHECKED IN FRAME {&FRAME-NAME} AND
     tg-experiencia-uso:CHECKED IN FRAME {&FRAME-NAME} THEN DO:    
     IF NOT tg-homologacao:CHECKED IN FRAME {&FRAME-NAME} 
         AND NOT tg-producao:CHECKED IN FRAME {&FRAME-NAME} THEN DO:
    
        /*Se n∆o selecionou nenhum tipo de ambiente n∆o deixa gravar*/ 
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 53701, 
                           INPUT "" ).
        RETURN 'ADM-ERROR':U.
     END.
  END.


  IF INPUT FRAME {&FRAME-NAME} fi-tp-codigo <> 0 THEN DO:
      FIND FIRST tipo-rec-desp WHERE tipo-rec-desp.tp-codigo = INPUT FRAME {&FRAME-NAME} fi-tp-codigo
                               NO-LOCK NO-ERROR.
      IF NOT AVAIL tipo-rec-desp THEN DO:
          RUN utp/ut-msgs.p (INPUT "show":U, INPUT 2, INPUT "Tipo de Despesa").
          APPLY "entry":U TO fi-tp-codigo IN FRAME {&FRAME-NAME}.
          RETURN "adm-error":U.
      END.
        
      IF tipo-rec-desp.tipo = 2 THEN DO:
          RUN utp/ut-msgs.p (INPUT "show":U, INPUT 57551, INPUT "").
          APPLY "entry":U TO fi-tp-codigo IN FRAME {&FRAME-NAME}.
          RETURN "adm-error":U.
      END.
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
  {src/adm/template/snd-list.i "param-compra"}

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

  /*CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

