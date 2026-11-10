&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          movind           PROGRESS
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
{include/i-prgvrs.i V01IN026 2.00.00.005 } /*** 010005 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v01in026 MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

DEFINE NEW GLOBAL SHARED TEMP-TABLE tt-mla-tipo-doc-aprov NO-UNDO LIKE mla-tipo-doc-aprov
    FIELD r-rowid as ROWID.

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

def var h_v06in026 as handle no-undo.
def var h_v07in026 as handle no-undo.
def var h_v08in026 as handle no-undo.
def var h_v05in026 as handle no-undo.

def buffer b-mla-emails for mla-emails.

def new global shared var g-empresa-aed LIKE empresa.ep-codigo     no-undo.
def new global shared var gc-estabel-aed LIKE estabelec.cod-estabel no-undo.

def var c-log-reg as char no-undo.

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
&Scoped-define EXTERNAL-TABLES mla-emails
&Scoped-define FIRST-EXTERNAL-TABLE mla-emails


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR mla-emails.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS mla-emails.log-geracao ~
mla-emails.log-aprovacao mla-emails.log-rejeicao mla-emails.log-documento 
&Scoped-define ENABLED-TABLES mla-emails
&Scoped-define FIRST-ENABLED-TABLE mla-emails
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 
&Scoped-Define DISPLAYED-FIELDS mla-emails.e-mail mla-emails.log-geracao ~
mla-emails.log-aprovacao mla-emails.log-rejeicao mla-emails.log-documento 
&Scoped-define DISPLAYED-TABLES mla-emails
&Scoped-define FIRST-DISPLAYED-TABLE mla-emails


/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS mla-emails.e-mail 

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
DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.29 BY 1.38.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.29 BY 5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     mla-emails.e-mail AT ROW 1.25 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 61.14 BY .88
     mla-emails.log-geracao AT ROW 3.5 COL 16
          VIEW-AS TOGGLE-BOX
          SIZE 24.43 BY .83
     mla-emails.log-aprovacao AT ROW 4.33 COL 16
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .83
     mla-emails.log-rejeicao AT ROW 5.17 COL 16
          VIEW-AS TOGGLE-BOX
          SIZE 18.43 BY .83
     mla-emails.log-documento AT ROW 6 COL 16
          VIEW-AS TOGGLE-BOX
          SIZE 30.29 BY .83
     "$02 - Cod Estabelec" VIEW-AS TEXT
          SIZE 15 BY .67 AT ROW 3.63 COL 52.86
     "$11 - Motivo Rejei‡Æo" VIEW-AS TEXT
          SIZE 15 BY .67 AT ROW 5.88 COL 71.29
     "$10 - Desc Rejei‡Æo" VIEW-AS TEXT
          SIZE 15 BY .67 AT ROW 5.13 COL 71.29
     "$07 - Desc Documento" VIEW-AS TEXT
          SIZE 15.86 BY .67 AT ROW 2.88 COL 71.29
     "$04 - Usu rio Trans" VIEW-AS TEXT
          SIZE 15 BY .67 AT ROW 5.13 COL 52.86
     "$05 - Aprovador" VIEW-AS TEXT
          SIZE 15 BY .67 AT ROW 5.88 COL 52.86
     "Enviar E-mail:" VIEW-AS TEXT
          SIZE 9.43 BY .67 AT ROW 3.5 COL 6.14
     "Vari veis:" VIEW-AS TEXT
          SIZE 8 BY .67 AT ROW 2.88 COL 43
     "$08 - Valor Documento" VIEW-AS TEXT
          SIZE 15.86 BY .67 AT ROW 3.63 COL 71.29
     "$01 - Cod Empresa" VIEW-AS TEXT
          SIZE 15 BY .67 AT ROW 2.88 COL 52.86
     "$12 - Motivo Aprova‡Æo" VIEW-AS TEXT
          SIZE 16.72 BY .67 AT ROW 6.63 COL 71.29
     "$06 - Cod Documento" VIEW-AS TEXT
          SIZE 15 BY .67 AT ROW 6.63 COL 52.86
     "$03 - Usu rio Doc" VIEW-AS TEXT
          SIZE 15 BY .67 AT ROW 4.38 COL 52.86
     "$09 - Cod Rejei‡Æo" VIEW-AS TEXT
          SIZE 15 BY .67 AT ROW 4.38 COL 71.29
     RECT-1 AT ROW 1 COL 1
     RECT-2 AT ROW 2.63 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.mla-emails
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
         HEIGHT             = 6.75
         WIDTH              = 88.29.
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

/* SETTINGS FOR FILL-IN mla-emails.e-mail IN FRAME f-main
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

&Scoped-define SELF-NAME mla-emails.log-aprovacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-emails.log-aprovacao V-table-Win
ON VALUE-CHANGED OF mla-emails.log-aprovacao IN FRAME f-main /* A Cada Aprova‡Æo */
DO:

    run pi-habilita-campos in h_v07in026 (mla-emails.log-aprovacao:checked in frame {&frame-name}).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mla-emails.log-documento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-emails.log-documento V-table-Win
ON VALUE-CHANGED OF mla-emails.log-documento IN FRAME f-main /* Aprova‡Æo Documento */
DO:

    run pi-habilita-campos in h_v05in026 (mla-emails.log-documento:checked in frame {&frame-name}).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mla-emails.log-geracao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-emails.log-geracao V-table-Win
ON VALUE-CHANGED OF mla-emails.log-geracao IN FRAME f-main /* Gera‡Æo Pendˆncia */
DO:

    run pi-habilita-campos in h_v06in026 (mla-emails.log-geracao:checked in frame {&frame-name}).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mla-emails.log-rejeicao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-emails.log-rejeicao V-table-Win
ON VALUE-CHANGED OF mla-emails.log-rejeicao IN FRAME f-main /* A Cada Rejei‡Æo */
DO:

    run pi-habilita-campos in h_v08in026 (mla-emails.log-rejeicao:checked in frame {&frame-name}).
  
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
  {src/adm/template/row-list.i "mla-emails"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "mla-emails"}

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
    
    /* Ponha na pi-validate todas as valida‡äes */
    /* NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    find first tt-mla-tipo-doc-aprov where
        rowid(tt-mla-tipo-doc-aprov) = v-row-parent
        no-lock no-error.
    if adm-new-record then do:    
        find first b-mla-emails where
            b-mla-emails.ep-codigo   = g-empresa-aed and
            b-mla-emails.cod-estabel = gc-estabel-aed and
            b-mla-emails.cod-tip-doc = tt-mla-tipo-doc-aprov.cod-tip-doc and
            b-mla-emails.e-mail      = input frame {&frame-name} 
                                       mla-emails.e-mail
            no-lock no-error.                                           
        if available b-mla-emails then do:
            {utp/ut-table.i mgind mla-emails 1}
            run utp/ut-msgs.p ("show",1,trim(return-value)).
            apply "entry" to mla-emails.e-mail in frame {&frame-name}.
            return "adm-error".                    
        end.
    end.        

    if not adm-new-record then
        run pi-log-reg.
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    if adm-new-record then do:
        create mla-log-reg.
        assign mla-log-reg.ep-codigo   = mla-emails.ep-codigo
               mla-log-reg.cod-estabel = mla-emails.cod-estabel
               mla-log-reg.cod-usuar   = c-seg-usuario
               mla-log-reg.cod-tabela  = 2
               mla-log-reg.chave-reg   = substring(string(mla-emails.cod-tip-doc) + " | " +
                                         string(mla-emails.e-mail),1,32)
               mla-log-reg.data-reg    = today
               mla-log-reg.hora-reg    = string(time,"hh:mm")
               mla-log-reg.tipo-reg    = 1
               mla-log-reg.log-reg     = entry(2,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                         "Documento          : " + string(mla-emails.cod-tip-doc)    + chr(13) + 
                                         "E-mail             : " + string(mla-emails.e-mail)         + chr(13) +
                                         "Log Aprova‡Æo      : " + string(mla-emails.log-aprovacao)  + chr(13) +                                   
                                         "Log Documento      : " + string(mla-emails.log-documento)  + chr(13) +                                   
                                         "Log Gera‡Æo        : " + string(mla-emails.log-geracao)    + chr(13) +                                   
                                         "Log Rejei‡Æo       : " + string(mla-emails.log-rejei‡Æo)   + chr(13) +                                   
                                         "T¡tulo Aprova‡Æo   : " + string(mla-emails.titulo-email-aprova) + chr(13) +                                   
                                         "T¡tulo Documento   : " + string(mla-emails.titulo-email-doc)    + chr(13) +                                   
                                         "T¡tulo Gera‡Æo     : " + string(mla-emails.titulo-email-gera)   + chr(13) +                                   
                                         "T¡tulo Rejei‡Æo    : " + string(mla-emails.titulo-email-rej)    + chr(13) +                                   
                                         "Html Aprova‡Æo     : " + string(mla-emails.html-aprovacao)  + chr(13) +                                   
                                         "Html Documento     : " + string(mla-emails.html-documento)  + chr(13) +                                   
                                         "Html Gera‡Æo       : " + string(mla-emails.html-geracao)    + chr(13) +                                   
                                         "Html Rejei‡Æo      : " + string(mla-emails.html-rejei‡Æo).
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

    find tt-mla-tipo-doc-aprov where 
        rowid(tt-mla-tipo-doc-aprov) = v-row-parent no-lock no-error.
    if available tt-mla-tipo-doc-aprov  then do:
        assign mla-emails.cod-tip-doc = tt-mla-tipo-doc-aprov.cod-tip-doc.
    end.

    assign mla-emails.ep-codigo = g-empresa-aed
           mla-emails.cod-estabel = gc-estabel-aed.
    
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
    
    if available mla-emails then do:
        if mla-emails.log-aprovacao <> mla-emails.log-aprovacao:checked in frame {&frame-name} then
            assign c-log-reg = c-log-reg + 
                   "Log Aprova‡Æo      : " + string(mla-emails.log-aprovacao)  + chr(13) +
                   "                   : " + string(mla-emails.log-aprovacao:checked in frame {&frame-name})  + chr(13) + chr(13).                  
        if mla-emails.log-documento <> mla-emails.log-documento:checked in frame {&frame-name} then
            assign c-log-reg = c-log-reg + 
                   "Log Documento      : " + string(mla-emails.log-documento)  + chr(13) +
                   "                   : " + string(mla-emails.log-documento:checked in frame {&frame-name})  + chr(13) + chr(13).                  
        if mla-emails.log-geracao <> mla-emails.log-geracao:checked in frame {&frame-name} then
            assign c-log-reg = c-log-reg + 
                   "Log Gera‡Æo        : " + string(mla-emails.log-geracao)  + chr(13) +
                   "                   : " + string(mla-emails.log-geracao:checked in frame {&frame-name})  + chr(13) + chr(13).                  
        if mla-emails.log-rejeicao <> mla-emails.log-rejeicao:checked in frame {&frame-name} then
            assign c-log-reg = c-log-reg + 
                   "Log Rejei‡Æo       : " + string(mla-emails.log-rejeicao)  + chr(13) +
                   "                   : " + string(mla-emails.log-rejeicao:checked in frame {&frame-name}).
    end.

    if c-log-reg <> "" then do:    
        create mla-log-reg.
        assign mla-log-reg.ep-codigo   = mla-emails.ep-codigo
               mla-log-reg.cod-estabel = mla-emails.cod-estabel
               mla-log-reg.cod-usuar   = c-seg-usuario
               mla-log-reg.cod-tabela  = 2
               mla-log-reg.chave-reg   = substring(string(mla-emails.cod-tip-doc) + " | " +
                                         string(mla-emails.e-mail),1,32)
               mla-log-reg.data-reg    = today
               mla-log-reg.hora-reg    = string(time,"hh:mm")
               mla-log-reg.tipo-reg    = 2
               mla-log-reg.log-reg     = entry(2,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                         c-log-reg.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-handle V-table-Win 
PROCEDURE pi-passa-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter p-handle1 as handle no-undo.
    def input parameter p-handle2 as handle no-undo.
    def input parameter p-handle3 as handle no-undo.
    def input parameter p-handle4 as handle no-undo.

    assign h_v06in026 = p-handle1
           h_v07in026 = p-handle2
           h_v08in026 = p-handle3
           h_v05in026 = p-handle4.

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
  {src/adm/template/snd-list.i "mla-emails"}

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

