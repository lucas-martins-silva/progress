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
{include/i-prgvrs.i V05IN024 2.00.00.012 } /*** "010012" 05/02/2024 14:08:20  ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v05in024 MUT}
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
def var v-row-parent as rowid no-undo.

def var c-log-reg as char no-undo.
DEFINE VARIABLE l-valor AS LOGICAL   NO-UNDO.
DEFINE VARIABLE c-valor AS CHARACTER NO-UNDO.
DEFINE VARIABLE h-v06in024 AS HANDLE NO-UNDO.
DEFINE VARIABLE c-lb-sim AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-lb-nao AS CHARACTER NO-UNDO.

{utp/ut-liter.i Sim *}
ASSIGN c-lb-sim = RETURN-VALUE.
{utp/ut-liter.i NÆo *}
ASSIGN c-lb-nao = RETURN-VALUE.

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
&Scoped-define EXTERNAL-TABLES mla-param-aprov
&Scoped-define FIRST-EXTERNAL-TABLE mla-param-aprov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR mla-param-aprov.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS mla-param-aprov.log-email ~
mla-param-aprov.log-atachado mla-param-aprov.log-email-altern ~
mla-param-aprov.log-aprov-altern mla-param-aprov.log-exchange ~
mla-param-aprov.servidor-email mla-param-aprov.porta-email ~
mla-param-aprov.servidor-asp mla-param-aprov.compl-email ~
mla-param-aprov.destino-verba 
&Scoped-define ENABLED-TABLES mla-param-aprov
&Scoped-define FIRST-ENABLED-TABLE mla-param-aprov
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-3 RECT-5 
&Scoped-Define DISPLAYED-FIELDS mla-param-aprov.log-email ~
mla-param-aprov.log-atachado mla-param-aprov.log-email-altern ~
mla-param-aprov.log-aprov-altern mla-param-aprov.log-exchange ~
mla-param-aprov.servidor-email mla-param-aprov.porta-email ~
mla-param-aprov.servidor-asp mla-param-aprov.compl-email ~
mla-param-aprov.destino-verba 
&Scoped-define DISPLAYED-TABLES mla-param-aprov
&Scoped-define FIRST-DISPLAYED-TABLE mla-param-aprov
&Scoped-Define DISPLAYED-OBJECTS i-aprovacao-total 

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
DEFINE VARIABLE i-aprovacao-total AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Transa‡Æo", 1,
"Documento", 2
     SIZE 27.14 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.72 BY 3.13.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.72 BY 5.25.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.72 BY 2.63.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     mla-param-aprov.log-email AT ROW 1.25 COL 19
          VIEW-AS TOGGLE-BOX
          SIZE 9.43 BY .83
     mla-param-aprov.log-atachado AT ROW 1.25 COL 50.29
          VIEW-AS TOGGLE-BOX
          SIZE 18 BY .83
     mla-param-aprov.log-email-altern AT ROW 2.13 COL 19
          VIEW-AS TOGGLE-BOX
          SIZE 22.72 BY .83
     mla-param-aprov.log-aprov-altern AT ROW 2.13 COL 50.29
          VIEW-AS TOGGLE-BOX
          SIZE 31.29 BY .83
     mla-param-aprov.log-exchange AT ROW 3 COL 19
          VIEW-AS TOGGLE-BOX
          SIZE 12.72 BY .83
     mla-param-aprov.servidor-email AT ROW 4.75 COL 15.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 40 BY .88
     mla-param-aprov.porta-email AT ROW 4.75 COL 68.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     mla-param-aprov.servidor-asp AT ROW 5.75 COL 17.57 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 61.33 BY .88
     mla-param-aprov.compl-email AT ROW 7.63 COL 24.72 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 59.14 BY 2.63
     mla-param-aprov.destino-verba AT ROW 10.5 COL 25 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Principal", 1,
"Alternativo", 2
          SIZE 28.14 BY .83
     i-aprovacao-total AT ROW 11.38 COL 25 NO-LABEL
     "Debita Verba:" VIEW-AS TEXT
          SIZE 10 BY .67 AT ROW 10.5 COL 14.57
     "Considera Lota‡Æo do usu rio:" VIEW-AS TEXT
          SIZE 21.57 BY .67 AT ROW 11.5 COL 3.15
     "Servi‡o Aprova‡Æo:" VIEW-AS TEXT
          SIZE 14.14 BY .67 AT ROW 5.75 COL 3.90
     "Complemento E-mail:" VIEW-AS TEXT
          SIZE 14.14 BY .67 AT ROW 7.5 COL 9.72
     RECT-1 AT ROW 1 COL 1
     RECT-3 AT ROW 7.25 COL 1
     RECT-5 AT ROW 4.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.mla-param-aprov
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
         HEIGHT             = 11.5
         WIDTH              = 85.86.
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
       FRAME f-main:HIDDEN           = TRUE
       FRAME f-main:HEIGHT           = 11.5
       FRAME f-main:WIDTH            = 85.86.

/* SETTINGS FOR RADIO-SET i-aprovacao-total IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN mla-param-aprov.servidor-asp IN FRAME f-main
   ALIGN-L                                                              */
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

&Scoped-define SELF-NAME mla-param-aprov.log-email
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-param-aprov.log-email V-table-Win
ON VALUE-CHANGED OF mla-param-aprov.log-email IN FRAME f-main /* E-mail */
DO:

    if mla-param-aprov.log-email:checked in frame {&frame-name} then do:
        assign mla-param-aprov.servidor-email:sensitive in frame {&frame-name} = yes
               mla-param-aprov.porta-email:sensitive    in frame {&frame-name} = yes
               mla-param-aprov.log-exchange:sensitive   in frame {&frame-name} = yes.
    end.
    else do:               
        assign mla-param-aprov.servidor-email:sensitive in frame {&frame-name} = no
               mla-param-aprov.porta-email:sensitive    in frame {&frame-name} = no
               mla-param-aprov.log-exchange:sensitive   in frame {&frame-name} = no.
    end.
  
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
  {src/adm/template/row-list.i "mla-param-aprov"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "mla-param-aprov"}

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
    {include/i-valid.i}
    
    /* Ponha na pi-validate todas as valida‡äes */
    /* NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

    if not adm-new-record then
        run pi-log-reg.   
   
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    ASSIGN i-aprovacao-total    = INPUT FRAME {&FRAME-NAME} i-aprovacao-total.

    ASSIGN mla-param-aprov.int-1 = i-aprovacao-total.    

    if adm-new-record then do:
        create mla-log-reg.
        assign mla-log-reg.ep-codigo   = mla-param-aprov.ep-codigo
               mla-log-reg.cod-estabel = mla-param-aprov.cod-estabel
               mla-log-reg.cod-usuar   = c-seg-usuario
               mla-log-reg.cod-tabela  = 12
               mla-log-reg.chave-reg   = string(mla-param-aprov.ep-codigo) + " | " +
                                         string(mla-param-aprov.cod-estabel)
               mla-log-reg.data-reg    = today
               mla-log-reg.hora-reg    = string(time,"hh:mm")
               mla-log-reg.tipo-reg    = 1
        .
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao001 = {ininc/i03in030.i 03}.
            RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao001).
            ASSIGN mla-log-reg.log-reg     = entry(12, cAuxTraducao001) + chr(13) .
        &else
            ASSIGN mla-log-reg.log-reg     = entry(12,{ininc/i03in030.i 03}) + chr(13) .
        &endif
        ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg +
                     "Log E-mail         : " + string(mla-param-aprov.log-email)        + chr(13) + 
                     "Servidor E-mail    : " + string(mla-param-aprov.servidor-email)   + chr(13) + 
                     "Porta E-mail       : " + string(mla-param-aprov.porta-email)      + chr(13) + 
                     "Log Exchange       : " + string(mla-param-aprov.log-exchange)     + chr(13) + 
                     "Log Atachado       : " + string(mla-param-aprov.log-atachado)     + chr(13) +                                      
                     "Log Senha          : " + string(mla-param-aprov.log-senha)        + chr(13) +                                      
                     "Log Aprov Altern   : " + string(mla-param-aprov.log-aprov-altern) + chr(13) +                                      
                     "Log Email Altern   : " + string(mla-param-aprov.log-email-altern) + chr(13) +                                      
                     "Destino Verba      : " + string(mla-param-aprov.destino-verba)    + chr(13) +                                      
                     "Servi‡o Aprova‡Æo  : " + string(mla-param-aprov.servidor-asp)     + CHR(13) +
                     "Lota‡ao Aprov Total     : " + STRING(mla-param-aprov.int-1)            + CHR(13).
                     
        IF VALID-HANDLE(h-v06in024) THEN DO:

           RUN pi-passa-valores-log IN h-v06in024 (INPUT "l-limite-alternativo":U, OUTPUT l-valor).
           ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + "Assume Limite Prin      : " + string(l-valor)     + CHR(13).
          
           RUN pi-passa-valores-log IN h-v06in024 (INPUT "log-aprovac-altern-dat":U, OUTPUT l-valor).
           ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + "Altern Por Data         : " + string(l-valor)     + CHR(13).
                      
           RUN pi-passa-valores-log IN h-v06in024 (INPUT "l-lotacao-principal":U, OUTPUT l-valor).
           ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + "Assume Lota‡ao Prin     : " + (IF l-valor = TRUE THEN "S":U ELSE "N":U) + CHR(13).
                                
           RUN pi-passa-valores-log IN h-v06in024 (INPUT "l-perm-aprov-principal":U, OUTPUT l-valor).
           ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + "Assume Perm Aprov Prin  : " + (IF l-valor = TRUE THEN "S":U ELSE "N":U) + CHR(13).
                                                 
           RUN pi-passa-valores-log IN h-v06in024 (INPUT "l-perm-mestre-principal":U, OUTPUT l-valor).
           ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + "Assume Perm Mestre Prin : " + (IF l-valor = TRUE THEN "S":U ELSE "N":U) + CHR(13).

           RUN pi-passa-valores-log IN h-v06in024 (INPUT "log-priorid-aprova-docto":U, OUTPUT l-valor).
           ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + "Prioridade Aprov Docto  : " + string(l-valor)     + CHR(13).
                                                  
           RUN pi-passa-valores-log IN h-v06in024 (INPUT "log-cond-pagto":U, OUTPUT l-valor).
           ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + "Gera Pend Cond Pag. e Vl: " + string(l-valor)     + CHR(13).
           
           RUN pi-passa-valores-log IN h-v06in024 (INPUT "log-ord-recbda":U, OUTPUT l-valor).
           ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + "Nao Gera Pend OC Receb  : " + string(l-valor)     + CHR(13).
           
           RUN pi-passa-valores-log IN h-v06in024 (INPUT "log-ord-confda":U, OUTPUT l-valor).
           ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + "Nao Gera Pend OC Confirm: " + string(l-valor)    + CHR(13).

           RUN pi-passa-valores-log IN h-v06in024 (INPUT "log-integr-fluig":U, OUTPUT l-valor).
           {utp/ut-field.i mgind mla-param-aprov log-integr-fluig 1}
           ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + RETURN-VALUE + " : " + (IF l-valor = YES THEN c-lb-sim ELSE c-lb-nao)    + CHR(13).

           RUN pi-passa-valores-log IN h-v06in024 (INPUT "log-praz-conclus":U, OUTPUT l-valor).
           {utp/ut-field.i mgind mla-param-aprov log-praz-conclus 1}
           ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + RETURN-VALUE + " : " + (IF l-valor = YES THEN c-lb-sim ELSE c-lb-nao)    + CHR(13).

           RUN pi-passa-valores-char IN h-v06in024 (INPUT "hra-execucao":U, OUTPUT c-valor).
           {utp/ut-field.i mgind mla-param-aprov hra-execucao 1}
           ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + RETURN-VALUE + " : " + string(c-valor)    + CHR(13).

           RUN pi-passa-valores-char IN h-v06in024 (INPUT "cdn-rej":U, OUTPUT c-valor).
           {utp/ut-field.i mgind mla-param-aprov cdn-rej 1}
           ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg + RETURN-VALUE + " : " + string(c-valor)    + CHR(13).
           
       END.
    end.
    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

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

    DISABLE i-aprovacao-total WITH FRAME {&FRAME-NAME}.    

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
    
  IF AVAILABLE mla-param-aprov THEN DO:
      ASSIGN i-aprovacao-total    = mla-param-aprov.int-1.

      DISPLAY i-aprovacao-total WITH FRAME {&FRAME-NAME}.
  END.

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
    
    ENABLE i-aprovacao-total WITH FRAME {&FRAME-NAME}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-log-reg V-table-Win 
PROCEDURE pi-log-reg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    assign c-log-reg = "".

    if available mla-param-aprov then do:
        if mla-param-aprov.log-email <> mla-param-aprov.log-email:checked in frame {&frame-name} then
            assign c-log-reg = c-log-reg + 
                   "Log E-mail         : " + string(mla-param-aprov.log-email) + chr(13) +
                   "                     " + string(mla-param-aprov.log-email:checked in frame {&frame-name}) + chr(13) + chr(13).
        if mla-param-aprov.servidor-email <> input frame {&frame-name} mla-param-aprov.servidor-email then
            assign c-log-reg = c-log-reg +                    
                   "Servidor E-mail    : " + string(mla-param-aprov.servidor-email)+ chr(13) + 
                   "                     " + string(input frame {&frame-name} mla-param-aprov.servidor-email) + chr(13) + chr(13).
        if mla-param-aprov.porta-email <> input frame {&frame-name} mla-param-aprov.porta-email then
            assign c-log-reg = c-log-reg +                    
                   "Porta E-mail       : " + string(mla-param-aprov.porta-email) + chr(13) + 
                   "                     " + string(input frame {&frame-name} mla-param-aprov.porta-email) + chr(13) + chr(13). 
        if mla-param-aprov.log-exchange <> mla-param-aprov.log-exchange:checked in frame {&frame-name} then
            assign c-log-reg = c-log-reg +            
                   "Log Exchange       : " + string(mla-param-aprov.log-exchange) + chr(13) + 
                   "                     " + string(mla-param-aprov.log-exchange:checked in frame {&frame-name}) + chr(13) + chr(13). 
        if mla-param-aprov.log-atachado <> mla-param-aprov.log-atachado:checked in frame {&frame-name} then
            assign c-log-reg = c-log-reg +            
                   "Log Atachado       : " + string(mla-param-aprov.log-atachado) + chr(13) + 
                   "                     " + string(mla-param-aprov.log-atachado:checked in frame {&frame-name}) + chr(13) + chr(13). 
        if mla-param-aprov.log-aprov-altern <> mla-param-aprov.log-aprov-altern:checked in frame {&frame-name} then
            assign c-log-reg = c-log-reg +            
                   "Log Aprov Altern   : " + string(mla-param-aprov.log-aprov-altern) + chr(13) + 
                   "                     " + string(mla-param-aprov.log-aprov-altern:checked in frame {&frame-name}) + chr(13) + chr(13). 
        if mla-param-aprov.log-email-altern <> mla-param-aprov.log-email-altern:checked in frame {&frame-name} then
            assign c-log-reg = c-log-reg +            
                   "Log Email Altern   : " + string(mla-param-aprov.log-email-altern) + chr(13) + 
                   "                     " + string(mla-param-aprov.log-email-altern:checked in frame {&frame-name}) + chr(13) + chr(13). 
        if mla-param-aprov.destino-verba <> input frame {&frame-name} mla-param-aprov.destino-verba then
            assign c-log-reg = c-log-reg +                    
                   "Destino Verba      : " + string(mla-param-aprov.destino-verba) + chr(13) + 
                   "                     " + string(input frame {&frame-name} mla-param-aprov.destino-verba) + chr(13) + chr(13). 
        if mla-param-aprov.servidor-asp <> input frame {&frame-name} mla-param-aprov.servidor-asp then
            assign c-log-reg = c-log-reg +                    
                   "Servi‡o Aprova‡Æo  : " + string(mla-param-aprov.servidor-asp) + chr(13) + 
                   "                     " + string(input frame {&frame-name} mla-param-aprov.servidor-asp) + CHR(13) + CHR(13). 
        IF VALID-HANDLE(h-v06in024) THEN DO:

           RUN pi-passa-valores-log IN h-v06in024 (INPUT "l-limite-alternativo":U, OUTPUT l-valor).
            
           IF mla-param-aprov.log-1 <> l-valor THEN
              ASSIGN c-log-reg = c-log-reg +
                     "Assume Limite Prin : " + STRING(mla-param-aprov.log-1) +  CHR(13) + 
                     "                     " + STRING(l-valor) +  CHR(13) + CHR(13).
                     
           RUN pi-passa-valores-log IN h-v06in024 (INPUT "log-aprovac-altern-dat":U, OUTPUT l-valor).
           
           IF mla-param-aprov.log-aprovac-altern-dat <> l-valor THEN
               ASSIGN c-log-reg = c-log-reg + 
                      "Altern Por Data   : " + STRING(mla-param-aprov.log-aprovac-altern-dat) + CHR(13) +
                      "                    " + STRING(l-valor) + CHR(13) + CHR(13).
    
           RUN pi-passa-valores-log IN h-v06in024 (INPUT "l-lotacao-principal":U, OUTPUT l-valor).
    
           IF SUBSTRING(mla-param-aprov.char-1,2,1) <> IF l-valor = TRUE THEN "S":U ELSE "N":U THEN
               ASSIGN c-log-reg = c-log-reg + 
                      "Assume Lota‡ao Prin : " +  SUBSTRING(mla-param-aprov.char-1,2,1) + CHR(13) +
                      "                      " +  (IF l-valor = TRUE THEN "S":U ELSE "N":U) + CHR(13) + CHR(13).
                                              
           RUN pi-passa-valores-log IN h-v06in024 (INPUT "l-perm-aprov-principal":U, OUTPUT l-valor).
    
           IF SUBSTRING(mla-param-aprov.char-1,3,1) <> IF l-valor = TRUE THEN "S":U ELSE "N":U THEN
               ASSIGN c-log-reg = c-log-reg + 
                      "Assume Perm Aprov Prin : " +  SUBSTRING(mla-param-aprov.char-1,3,1) + CHR(13) + 
                      "                         " +  (IF l-valor = TRUE THEN "S":U ELSE "N":U) + CHR(13) + CHR(13).
                                                 
           RUN pi-passa-valores-log IN h-v06in024 (INPUT "l-perm-mestre-principal":U, OUTPUT l-valor).
           
           IF SUBSTRING(mla-param-aprov.char-1,4,1) <> IF l-valor = TRUE THEN "S":U ELSE "N":U THEN
               ASSIGN c-log-reg = c-log-reg + 
                      "Assume Perm Mestre Prin : " +  SUBSTRING(mla-param-aprov.char-1,4,1) + CHR(13) + 
                      "                          " +  (IF l-valor = TRUE THEN "S":U ELSE "N":U) + CHR(13) + CHR(13).

           RUN pi-passa-valores-log IN h-v06in024 (INPUT "log-priorid-aprova-docto":U, OUTPUT l-valor).
           
           IF mla-param-aprov.log-priorid-aprova-docto <> l-valor THEN
               ASSIGN c-log-reg = c-log-reg + 
                      "Prioridade Aprov Docto  : " +  STRING(mla-param-aprov.log-priorid-aprova-docto) + CHR(13) + 
                      "                          " +  STRING(l-valor) + CHR(13) + CHR(13).

           RUN pi-passa-valores-log IN h-v06in024 (INPUT "log-cond-pagto":U, OUTPUT l-valor).
           
           IF mla-param-aprov.log-cond-pagto <> l-valor THEN
               ASSIGN c-log-reg = c-log-reg + 
                      "Gera Pend Cond Pag. e Vl : " +  STRING(mla-param-aprov.log-cond-pagto) + CHR(13) + 
                      "                           " +  STRING(l-valor) + CHR(13) + CHR(13).
           
           RUN pi-passa-valores-log IN h-v06in024 (INPUT "log-ord-recbda":U, OUTPUT l-valor).
           IF mla-param-aprov.log-ord-recbda <> l-valor THEN
               ASSIGN c-log-reg = c-log-reg + 
                      "Nao Gera Pend OC Receb : " +  STRING(mla-param-aprov.log-ord-recbda) + CHR(13) + 
                      "                         " +  STRING(l-valor) + CHR(13) + CHR(13).
           
           RUN pi-passa-valores-log IN h-v06in024 (INPUT "log-ord-confda":U, OUTPUT l-valor).
           
           IF mla-param-aprov.log-ord-confda <> l-valor THEN
              ASSIGN c-log-reg = c-log-reg + 
                      "Nao Gera Pend OC Confirm : " +  STRING(mla-param-aprov.log-ord-confda) + CHR(13) + 
                      "                           " +  STRING(l-valor) + CHR(13) + CHR(13).

           RUN pi-passa-valores-log IN h-v06in024 (INPUT "log-integr-fluig":U, OUTPUT l-valor).
           
           IF mla-param-aprov.log-integr-fluig <> l-valor THEN DO:
              {utp/ut-field.i mgind mla-param-aprov log-integr-fluig 1}
              ASSIGN c-log-reg = c-log-reg + 
                      RETURN-VALUE + " : " +  (IF mla-param-aprov.log-integr-fluig THEN c-lb-sim ELSE c-lb-nao) + CHR(13) + 
                      "                           " +  (IF l-valor THEN c-lb-sim ELSE c-lb-nao) + CHR(13) + CHR(13).
           END.

           RUN pi-passa-valores-log IN h-v06in024 (INPUT "log-praz-conclus":U, OUTPUT l-valor).
           
           IF mla-param-aprov.log-praz-conclus <> l-valor THEN DO:
              {utp/ut-field.i mgind mla-param-aprov log-praz-conclus 1}
              ASSIGN c-log-reg = c-log-reg + 
                      RETURN-VALUE + " : " +  (IF mla-param-aprov.log-praz-conclus THEN c-lb-sim ELSE c-lb-nao) + CHR(13) + 
                      "                           " +  (IF l-valor THEN c-lb-sim ELSE c-lb-nao) + CHR(13) + CHR(13).
           END.

           RUN pi-passa-valores-char IN h-v06in024 (INPUT "hra-execucao":U, OUTPUT c-valor).
           
           IF mla-param-aprov.hra-execucao <> c-valor THEN DO:
              {utp/ut-field.i mgind mla-param-aprov hra-execucao 1}
              ASSIGN c-log-reg = c-log-reg + 
                     RETURN-VALUE + " : " +  STRING(mla-param-aprov.hra-execucao,"999:99") + CHR(13) + 
                      "                           " +  STRING(c-valor) + CHR(13) + CHR(13).
           END.

           RUN pi-passa-valores-char IN h-v06in024 (INPUT "cdn-rej":U, OUTPUT c-valor).
           
           IF trim(string(mla-param-aprov.cdn-rej)) <> trim(c-valor) THEN DO:
              {utp/ut-field.i mgind mla-param-aprov cdn-rej 1}
              ASSIGN c-log-reg = c-log-reg + 
                      RETURN-VALUE + " : " +  STRING(mla-param-aprov.cdn-rej) + CHR(13) + 
                      "                           " +  STRING(c-valor) + CHR(13) + CHR(13).
           END.
       END.
            
    end.

    if c-log-reg <> "" then do:
        create mla-log-reg.
        assign mla-log-reg.ep-codigo   = mla-param-aprov.ep-codigo
               mla-log-reg.cod-estabel = mla-param-aprov.cod-estabel
               mla-log-reg.cod-usuar   = c-seg-usuario
               mla-log-reg.cod-tabela  = 12
               mla-log-reg.chave-reg   = string(mla-param-aprov.ep-codigo) + " | " +
                                         string(mla-param-aprov.cod-estabel)
               mla-log-reg.data-reg    = today
               mla-log-reg.hora-reg    = string(time,"hh:mm")
               mla-log-reg.tipo-reg    = 2
        .
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao002 = {ininc/i03in030.i 03}.
            RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao002).
            ASSIGN mla-log-reg.log-reg     = entry(12, cAuxTraducao002) + chr(13) + chr(13) + c-log-reg.
        &else
            ASSIGN mla-log-reg.log-reg     = entry(12,{ininc/i03in030.i 03}) + chr(13) + chr(13) + c-log-reg.
        &endif
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-handle V-table-Win 
PROCEDURE pi-passa-handle :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para passar o handle da Viwer v06in024, e ser utilizada
                na procedure de grava‡Æo de log.
  Parameters:  p-handle - handle da viwer
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-handle AS HANDLE NO-UNDO.

    ASSIGN h-v06in024 = p-handle.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */
    
/*/*    Segue um exemplo de valida‡Æo de programa */
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
  {src/adm/template/snd-list.i "mla-param-aprov"}

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

