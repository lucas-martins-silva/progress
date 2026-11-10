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
{include/i-prgvrs.i V04IN024 2.00.00.010 } /*** "010010" 18/08/2026 14:07:46  ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v04in024 MUT}
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

def buffer b-mla-param-aprov for mla-param-aprov.

def new global shared var g-empresa-aed LIKE empresa.ep-codigo no-undo.

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

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES mla-param-aprov
&Scoped-define FIRST-EXTERNAL-TABLE mla-param-aprov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR mla-param-aprov.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS mla-param-aprov.char-1 
&Scoped-define ENABLED-TABLES mla-param-aprov
&Scoped-define FIRST-ENABLED-TABLE mla-param-aprov
&Scoped-Define ENABLED-OBJECTS RECT-6 
&Scoped-Define DISPLAYED-FIELDS mla-param-aprov.cod-estabel ~
mla-param-aprov.char-1 
&Scoped-define DISPLAYED-TABLES mla-param-aprov
&Scoped-define FIRST-DISPLAYED-TABLE mla-param-aprov
&Scoped-Define DISPLAYED-OBJECTS c-desc-estabel 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS mla-param-aprov.cod-estabel 

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
DEFINE VARIABLE c-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41.14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.29 BY 1.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     mla-param-aprov.cod-estabel AT ROW 1.25 COL 23.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.29 BY .88
     c-desc-estabel AT ROW 1.25 COL 30.72 COLON-ALIGNED NO-LABEL
     mla-param-aprov.char-1 AT ROW 1.25 COL 74.29 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE .86 BY .88
     RECT-6 AT ROW 1 COL 1
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
         HEIGHT             = 1.38
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

/* SETTINGS FOR FILL-IN c-desc-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN mla-param-aprov.char-1 IN FRAME f-main
   ALIGN-L                                                              */
ASSIGN 
       mla-param-aprov.char-1:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN mla-param-aprov.cod-estabel IN FRAME f-main
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

&Scoped-define SELF-NAME mla-param-aprov.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-param-aprov.cod-estabel V-table-Win
ON F5 OF mla-param-aprov.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:

   {include/zoom.i &prog-zoom="adzoom/z01ad107.w"
                   &tabela=mla-param-aprov
                   &atributo=cod-estabel}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-param-aprov.cod-estabel V-table-Win
ON LEAVE OF mla-param-aprov.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:

  {include/leave.i &tabela=estabelec
                   &atributo-ref=nome
                   &variavel-ref=c-desc-estabel
                   &where="estabelec.cod-estabel = input frame {&frame-name} mla-param-aprov.cod-estabel"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-param-aprov.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF mla-param-aprov.cod-estabel IN FRAME f-main /* Estabelecimento */
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

   if mla-param-aprov.cod-estabel:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.

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

    assign mla-param-aprov.char-1:sensitive in frame {&frame-name} = no.

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

    if adm-new-record and
        can-find (b-mla-param-aprov where 
                  b-mla-param-aprov.ep-codigo   = g-empresa-aed and
                  b-mla-param-aprov.cod-estabel = input frame {&frame-name} mla-param-aprov.cod-estabel) then do:
        {utp/ut-table.i mgind mla-param-aprov 1}       
        run utp/ut-msgs.p (input "show",
                           input 1,
                           input return-value).
        apply "entry" to mla-param-aprov.cod-estabel in frame {&frame-name}.                           
        return 'adm-error'.
    end.        

    if adm-new-record and
        not can-find (estabelec where 
                      estabelec.cod-estabel = input frame {&frame-name} mla-param-aprov.cod-estabel) then do:
        run utp/ut-msgs.p (input "show",
                           input 13,
                           input "").
        apply 'entry' to mla-param-aprov.cod-estabel in frame {&frame-name}.
        return 'adm-error'.
    end.   
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

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

    assign mla-param-aprov.ep-codigo = g-empresa-aed.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-msg                    AS CHARACTER               NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

    if available mla-param-aprov then do:
        IF CAN-FIND(FIRST mla-tipo-doc-aprov WHERE mla-tipo-doc-aprov.ep-codigo = mla-param-aprov.ep-codigo
                                             AND   mla-tipo-doc-aprov.cod-estabel = mla-param-aprov.cod-estabel) THEN DO:
            {utp/ut-liter.i "Parƒmetro_de_Aprova‡Æo" *}
            ASSIGN c-msg = RETURN-VALUE.
            {utp/ut-liter.i "Tipo_Doc._Aprova‡Æo_(MLA0101)" *}
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 34616,
                               INPUT c-msg + "~~" + RETURN-VALUE).
            APPLY "entry" TO mla-param-aprov.cod-estabel IN FRAME {&frame-name}.                           
            RETURN 'adm-error'.
        END.
        
        IF CAN-FIND(FIRST mla-hierarquia-faixa WHERE mla-hierarquia-faixa.ep-codigo = mla-param-aprov.ep-codigo
                                               AND   mla-hierarquia-faixa.cod-estabel = mla-param-aprov.cod-estabel) THEN DO:
            {utp/ut-liter.i "Parƒmetro_de_Aprova‡Æo." *}
            ASSIGN c-msg = RETURN-VALUE.
            {utp/ut-liter.i "Aprovadores_por_faixa_(MLA0112)" *}
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 34616,
                               INPUT c-msg + "~~" + RETURN-VALUE).
            APPLY "entry" TO mla-param-aprov.cod-estabel IN FRAME {&frame-name}.                           
            RETURN 'adm-error'.
        END.
        
        create mla-log-reg.
        assign mla-log-reg.ep-codigo   = mla-param-aprov.ep-codigo
               mla-log-reg.cod-estabel = mla-param-aprov.cod-estabel
               mla-log-reg.cod-usuar   = c-seg-usuario
               mla-log-reg.cod-tabela  = 12
               mla-log-reg.chave-reg   = string(mla-param-aprov.ep-codigo) + " | " +
                                         string(mla-param-aprov.cod-estabel)
               mla-log-reg.data-reg    = today
               mla-log-reg.hora-reg    = string(time,"hh:mm")
               mla-log-reg.tipo-reg    = 3
               mla-log-reg.log-reg     = entry(12,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                         "Log E-mail               : " + string(mla-param-aprov.log-email)                + chr(13) +
                                         "Servidor E-mail          : " + string(mla-param-aprov.servidor-email)           + chr(13) +
                                         "Porta E-mail             : " + string(mla-param-aprov.porta-email)              + chr(13) +
                                         "Log Exchange             : " + string(mla-param-aprov.log-exchange)             + chr(13) +
                                         "Log Atachado             : " + string(mla-param-aprov.log-atachado)             + chr(13) +
                                         "Log Senha                : " + string(mla-param-aprov.log-senha)                + chr(13) +
                                         "Log Email Altern         : " + string(mla-param-aprov.log-email-altern)         + chr(13) +
                                         "Destino Verba            : " + string(mla-param-aprov.destino-verba)            + chr(13) +
                                         "Servi‡o Aprova‡Æo        : " + string(mla-param-aprov.servidor-asp)             + chr(13) +
                                         "Assume Limite Prin       : " + string(mla-param-aprov.log-1)                    + chr(13) +
                                         "Altern Por Data          : " + string(mla-param-aprov.log-aprovac-altern-dat)   + chr(13) +
                                         "Assume Lota‡Æo Prin      : " + substring(mla-param-aprov.char-1,2,1)            + chr(13) +
                                         "Assume Perm Aprov Prin   : " + substring(mla-param-aprov.char-1,3,1)            + chr(13) +
                                         "Assume Perm Mestre Prin  : " + substring(mla-param-aprov.char-1,4,1)            + chr(13) +
                                         "Prioridade Aprov Docto   : " + string(mla-param-aprov.log-priorid-aprova-docto) + chr(13) +
                                         "Gera Pend Cond Pag. e Vl : " + string(mla-param-aprov.log-cond-pagto)           + chr(13) +
                                         "Nao Gera Pend OC Receb   : " + string(mla-param-aprov.log-ord-recbda)           + chr(13) +
                                         "Nao Gera Pend OC Confirm : " + string(mla-param-aprov.log-ord-confda)           + chr(13).

        {utp/ut-field.i mgind mla-param-aprov log-integr-fluig 1}
        ASSIGN  mla-log-reg.log-reg =  mla-log-reg.log-reg + RETURN-VALUE + " : " + (IF mla-param-aprov.log-integr-fluig THEN c-lb-sim ELSE c-lb-nao) + CHR(13).
        
        {utp/ut-field.i mgind mla-param-aprov log-praz-conclus 1}
        ASSIGN  mla-log-reg.log-reg =  mla-log-reg.log-reg + RETURN-VALUE + " : " + (IF mla-param-aprov.log-praz-conclus THEN c-lb-sim ELSE c-lb-nao) + CHR(13).

        {utp/ut-field.i mgind mla-param-aprov hra-execucao 1}
        ASSIGN  mla-log-reg.log-reg =  mla-log-reg.log-reg + RETURN-VALUE + " : " + STRING(mla-param-aprov.hra-execucao,"999:99") + CHR(13).

        {utp/ut-field.i mgind mla-param-aprov cdn-rej 1}
        ASSIGN  mla-log-reg.log-reg =  mla-log-reg.log-reg + RETURN-VALUE + " : " + STRING(mla-param-aprov.cdn-rej) + CHR(13).
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
    
    if avail mla-param-aprov then do:
        find estabelec where 
            estabelec.cod-estabel = mla-param-aprov.cod-estabel 
            no-lock no-error.
        if avail estabelec then do:
            assign  c-desc-estabel = if avail estabelec then estabelec.nome else "":U.
            display c-desc-estabel with frame {&frame-name}.
        end.
    end.        

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

