&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V06AD043 2.00.00.005 } /*** "010005" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V06AD043 MUT}
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
define new global shared var gr-emitente as rowid NO-UNDO.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

def buffer b-cont-emit for cont-emit.

def var i-seq-reg as int no-undo.

def var l-cliente   as logical initial no no-undo.
def var l-fornec    as logical initial no no-undo.
def var c-nome      as char               no-undo.
def var i-sequencia as integer            no-undo.

/*** Vari veis para integra‡Æo EMS x SISDOC ***/
def var i-integracao-sisdoc as integer init ?   no-undo.
def var c-handle            as char             no-undo.
def var c-opcao-int         as char             no-undo.
def var l-origem-int        as logical init yes no-undo.
def var i-retorno-erro      as integer init ?   no-undo.
    /* ** 5 => Quando parƒmetro "nao-integra" e o registro j  est  integrado **
       ** 6 => Erro de integra‡Æo no SISDOC                                  **
       ** 7 => Erro de integra‡Æo no EMS                                     ** */
/********* Fim vari veis para integra‡Æo ******/

/*************Multiplanta********************/
def var i-tipo-movto as integer no-undo.
def var l-cria       as logical initial no no-undo.

{cdp/cd7300.i1}
{cdp/cdapi237.i}
/************Fim*****************************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES cont-emit
&Scoped-define FIRST-EXTERNAL-TABLE cont-emit


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cont-emit.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cont-emit.nome cont-emit.area cont-emit.cargo ~
cont-emit.telefone cont-emit.ramal cont-emit.telefax cont-emit.ramal-fax ~
cont-emit.e-mail 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}nome ~{&FP2}nome ~{&FP3}~
 ~{&FP1}area ~{&FP2}area ~{&FP3}~
 ~{&FP1}cargo ~{&FP2}cargo ~{&FP3}~
 ~{&FP1}telefone ~{&FP2}telefone ~{&FP3}~
 ~{&FP1}ramal ~{&FP2}ramal ~{&FP3}~
 ~{&FP1}telefax ~{&FP2}telefax ~{&FP3}~
 ~{&FP1}ramal-fax ~{&FP2}ramal-fax ~{&FP3}~
 ~{&FP1}e-mail ~{&FP2}e-mail ~{&FP3}
&Scoped-define ENABLED-TABLES cont-emit
&Scoped-define FIRST-ENABLED-TABLE cont-emit
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS cont-emit.cod-emitente cont-emit.sequencia ~
cont-emit.nome cont-emit.area cont-emit.cargo cont-emit.telefone ~
cont-emit.ramal cont-emit.telefax cont-emit.ramal-fax cont-emit.e-mail 
&Scoped-Define DISPLAYED-OBJECTS c-nome-abrev 

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
DEFINE VARIABLE c-nome-abrev AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35.43 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 6.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cont-emit.cod-emitente AT ROW 1.17 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-nome-abrev AT ROW 1.17 COL 30.29 COLON-ALIGNED NO-LABEL
     cont-emit.sequencia AT ROW 1.17 COL 81.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     cont-emit.nome AT ROW 2.63 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.14 BY .88
     cont-emit.area AT ROW 3.63 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.14 BY .88
     cont-emit.cargo AT ROW 4.63 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     cont-emit.telefone AT ROW 5.63 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     cont-emit.ramal AT ROW 5.63 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     cont-emit.telefax AT ROW 6.63 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     cont-emit.ramal-fax AT ROW 6.63 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     cont-emit.e-mail AT ROW 7.63 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 26.14 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.cont-emit
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 7.71
         WIDTH              = 88.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-nome-abrev IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cont-emit.cod-emitente IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cont-emit.sequencia IN FRAME f-main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME cont-emit.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cont-emit.cod-emitente V-table-Win
ON LEAVE OF cont-emit.cod-emitente IN FRAME f-main /* Emitente */
DO:

    find first emitente
         where emitente.cod-emitente = input frame {&frame-name} cont-emit.cod-emitente
         no-lock no-error.
                    
    if  avail emitente then
        disp emitente.nome-abrev @ c-nome-abrev with frame {&frame-name}.
    else 
        disp ""  @ c-nome-abrev with frame {&frame-name}.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "cont-emit"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cont-emit"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-apply-entry V-table-Win 
PROCEDURE local-apply-entry :
/*------------------------------------------------------------------------------
    Purpose:     Override standard ADM method
    Notes:       
------------------------------------------------------------------------------*/
            
    find emitente where rowid(emitente) =  v-row-parent no-lock no-error.
                    
    if  avail emitente then do:
        
        assign cont-emit.cod-emitente:screen-value in frame {&FRAME-NAME} = string(emitente.cod-emitente).
        
        disp emitente.nome-abrev @ c-nome-abrev with frame {&frame-name}.
    end.
    else 
        disp ""  @ c-nome-abrev with frame {&frame-name}.
    
    if  adm-new-record = yes then do:                    
        find last b-cont-emit
             where b-cont-emit.cod-emitente = input frame {&frame-name} cont-emit.cod-emitente
             no-lock no-error.
                            
        if  avail b-cont-emit then
            assign cont-emit.sequencia:screen-value in frame {&FRAME-NAME} = string(b-cont-emit.sequencia + 10).
        else
            assign cont-emit.sequencia:screen-value in frame {&FRAME-NAME} = string(10).
    end.
    
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'apply-entry':U ) .
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  do transaction:  

    if  not frame {&frame-name}:validate() then
        return 'ADM-ERROR':U.
    
    find first b-cont-emit no-lock
         where b-cont-emit.cod-emitente = input frame {&FRAME-NAME} cont-emit.cod-emitente
         and   b-cont-emit.nome         = input frame {&FRAME-NAME} cont-emit.nome 
         and   rowid(b-cont-emit)      <> rowid(cont-emit) no-error.
    
    if  avail b-cont-emit then do:
        run utp/ut-msgs.p (input "show":U, 
                           input 16443, 
                           input string(input frame {&FRAME-NAME} cont-emit.cod-emitente) + "~~" +
                                 string(input frame {&FRAME-NAME} cont-emit.nome)).
        apply 'entry' to cont-emit.nome in frame {&FRAME-NAME}.
        return 'adm-error'.
    end.
    
    assign i-sequencia = input frame {&FRAME-NAME} mgadm.cont-emit.sequencia.
        
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    assign mgadm.cont-emit.sequencia = i-sequencia.
     
     /**** Integra‡Æo 2.00 X 5.00 ****/
     find first param-global NO-LOCK NO-ERROR.
     if param-global.log-2 = yes then do:
         if  cont-emit.identific <> 2 then do:
             find funcao where funcao.cd-funcao = "adm-cdc-ems-5.00" NO-LOCK NO-ERROR.
             if  avail funcao 
                 and funcao.ativo = yes 
                 and funcao.log-1 = yes 
             then assign l-cliente = yes.
         end.
         if  cont-emit.identific <> 1 then do:
              find funcao where funcao.cd-funcao = "adm-cdf-ems-5.00" NO-LOCK NO-ERROR.
              if  avail funcao 
                  and funcao.ativo = yes 
                  and funcao.log-1 = yes 
              then assign l-fornec = yes.
         end.
         if  l-fornec = yes 
             or l-cliente = yes and 
             emitente.natureza = 2 then do:
             run cdp/cd1608.p (input cont-emit.cod-emitente,
                               input cont-emit.cod-emitente,
                               input emitente.identific,
                               input yes,
                               input 1,
                               input cont-emit.sequencia,
                               input "",
                               input "Arquivo",
                               input c-nome).
         end.
     end.
     /**** Fim Integra‡Æo ****/

     /******* Integra‡Æo EMS x SISDOC ******/
     if  i-integracao-sisdoc = ? then do:
         RUN Who-Is-The-Container IN adm-broker-hdl (INPUT  this-procedure,
                                                     OUTPUT c-handle).
         run pi-atualiza-var in widget-handle(c-handle) (output i-integracao-sisdoc).
     end.
  
     if  i-integracao-sisdoc = 3 then do:
         if  adm-new-record then
             assign c-opcao-int = "inclui".
         else 
             assign c-opcao-int = "modifica".
     
         run cdp/cd2305.w (input rowid(cont-emit),
                           input c-opcao-int,
                           input "contato",
                           output i-retorno-erro,
                           output l-origem-int).
         if  i-retorno-erro = 6 or
             i-retorno-erro = 7 then
             undo, return "adm-error":U.
         end.  /* if i-integracao-sisdoc = 3 */     
     /***** Fim Integra‡Æo EMS x SISDOC ****/

     /********************Multiplanta***********************/
  
     assign c-transacao = "ADM037".
     {cdp/cd7300.i5 "001" c-transacao}
  
     assign i-tipo-movto = if  cont-emit.cod-emitente:sensitive in frame {&frame-name} = yes and
                               cont-emit.sequencia:sensitive in frame {&frame-name} = yes 
                               then 1 
                               else 2.
     run pi-cria-tt-dados (input i-tipo-movto).
  
     {cdp/cd7300.i6 "001" c-transacao}
  
     /******************Fim-Multiplanta********************/  

  end.    /* do transaction */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
    Purpose:     Override standard ADM method
    Notes:       
------------------------------------------------------------------------------*/

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

    find emitente where rowid(emitente) = gr-emitente NO-LOCK no-error.
    if available emitente then do:
        assign cont-emit.cod-emitente = emitente.cod-emitente.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  IF CONT-EMIT.IDENTIFIC <> 3 THEN DO:

     /**** Integra‡Æo 2.00 X 5.00 ****/
     find first param-global NO-LOCK NO-ERROR.
     if param-global.log-2 = yes then do:
         if  cont-emit.identific <> 2 then do:
             find funcao where funcao.cd-funcao = "adm-cdc-ems-5.00" NO-LOCK NO-ERROR.
             if  avail funcao 
                 and funcao.ativo = yes 
                 and funcao.log-1 = yes 
             then assign l-cliente = yes.
         end.
         if  cont-emit.identific <> 1 then do:
              find funcao where funcao.cd-funcao = "adm-cdf-ems-5.00" NO-LOCK NO-ERROR.
              if  avail funcao 
                  and funcao.ativo = yes 
                  and funcao.log-1 = yes 
              then assign l-fornec = yes.
         end.
         if  l-fornec = yes 
             or l-cliente = yes  and 
             emitente.natureza = 2 then do:
             find current cont-emit no-lock no-error.
             run cdp/cd1608.p (input cont-emit.cod-emitente,
                               input cont-emit.cod-emitente,
                               input emitente.identific,
                               input yes,
                               input 2,
                               input cont-emit.sequencia,
                               input "",
                               input "Arquivo",
                               input "").
         end.
     end.
     /**** Fim Integra‡Æo ****/

     /******* Integra‡Æo EMS x SISDOC ******/
     if  i-integracao-sisdoc = ? then do:
         RUN Who-Is-The-Container IN adm-broker-hdl (INPUT  this-procedure,
                                                     OUTPUT c-handle).
         run pi-atualiza-var in widget-handle(c-handle) (output i-integracao-sisdoc).
     end.
    
     if  i-integracao-sisdoc = 2 then
         assign c-opcao-int = "nao-integra".
     if  i-integracao-sisdoc = 3 then
         assign c-opcao-int = "elimina".
 
     if  i-integracao-sisdoc = 2 or
         i-integracao-sisdoc = 3 then do:      
         run cdp/cd2305.w (input rowid(cont-emit),
                           input c-opcao-int,
                           input "contato",
                           output i-retorno-erro,
                           output l-origem-int).
         if  i-retorno-erro = 5 or
             i-retorno-erro = 6 or
             i-retorno-erro = 7 then do:
             run notify ("pi-cancelar, tableio-source").
             return "ADM-ERROR":U.
         end.    
     end.  /* if i-integracao-sisdoc = 2 or ...*/     
     /***** Fim Integra‡Æo EMS x SISDOC ****/

     RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .


  END.   
  ELSE DO:
    CONT-EMIT.IDENTIFIC = 1.

    /**** Integra‡Æo 2.00 X 5.00 ****/
    find first param-global NO-LOCK NO-ERROR.
    if  param-global.log-2 = yes then do:
        if  cont-emit.identific <> 2 then do:
            find funcao where funcao.cd-funcao = "adm-cdc-ems-5.00" NO-LOCK NO-ERROR.
            if  avail funcao 
                and funcao.ativo = yes 
                and funcao.log-1 = yes 
            then assign l-cliente = yes.
        end.
        if  cont-emit.identific <> 1 then do:
             find funcao where funcao.cd-funcao = "adm-cdf-ems-5.00" NO-LOCK NO-ERROR.
             if  avail funcao 
                 and funcao.ativo = yes 
                 and funcao.log-1 = yes 
             then assign l-fornec = yes.
        end.
        if  l-fornec = yes 
            or l-cliente = yes and 
            emitente.natureza = 2 then do:
            run cdp/cd1608.p (input cont-emit.cod-emitente,
                              input cont-emit.cod-emitente,
                              input cont-emit.identific,
                              input yes,
                              input 2,
                              input cont-emit.sequencia,
                              input "",
                              input "Arquivo",
                              input "").
        end.
    end.
    /**** Fim Integra‡Æo ****/

    /******* Integra‡Æo EMS x SISDOC ******/
    if  i-integracao-sisdoc = ? then do:
        RUN Who-Is-The-Container IN adm-broker-hdl (INPUT  this-procedure,
                                                    OUTPUT c-handle).
        run pi-atualiza-var in widget-handle(c-handle) (output i-integracao-sisdoc).
    end.
    
    if  i-integracao-sisdoc = 2 then
        assign c-opcao-int = "nao-integra".
    if  i-integracao-sisdoc = 3 then
        assign c-opcao-int = "elimina".
 
    if  i-integracao-sisdoc = 2 or
        i-integracao-sisdoc = 3 then do:      
        run cdp/cd2305.w (input rowid(cont-emit),
                          input c-opcao-int,
                          input "contato",
                          output i-retorno-erro,
                          output l-origem-int).
        if  i-retorno-erro = 5 or
            i-retorno-erro = 6 or
            i-retorno-erro = 7 then do:
            run notify ("pi-cancelar, tableio-source").
            return "ADM-ERROR":U.
        end.    
    end.  /* if i-integracao-sisdoc = 2 or ...*/     
    /***** Fim Integra‡Æo EMS x SISDOC ****/

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    
  /* Code placed here will execute PRIOR to standard behavior. */
    
  /******* Integra‡Æo EMS x SISDOC ******/
  if  not adm-new-record then do:
      if  i-integracao-sisdoc = ? then do:
          RUN Who-Is-The-Container IN adm-broker-hdl (INPUT  this-procedure,
                                                      OUTPUT c-handle).
          run pi-atualiza-var in widget-handle(c-handle) (output i-integracao-sisdoc).
      end.
    
      if  i-integracao-sisdoc = 2 then do:
          assign c-opcao-int = "nao-integra".
          run cdp/cd2305.w (input rowid(cont-emit),
                            input c-opcao-int,
                            input "contato",
                            output i-retorno-erro,
                            output l-origem-int).
          if  i-retorno-erro = 5 or
              i-retorno-erro = 6 or
              i-retorno-erro = 7 then do:
              run notify ("pi-cancelar, tableio-source").
              return "ADM-ERROR":U.
          end.  /* if i-retorno-erro = 5 or ... */    
      end.  /* if i-integracao-sisdoc = 2 */     
  end.  /* if not adm-new-record */
  /***** Fim Integra‡Æo EMS x SISDOC ****/

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    
  /* Code placed here will execute AFTER standard behavior.    */
  if adm-new-record = yes then
  &if  defined(ADM-MODIFY-FIELDS) &then
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados V-table-Win 
PROCEDURE pi-cria-tt-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter i-tipo-movto as integer.

if  param-global.modulo-mp and
    tt-replica-msg.log-replica-msg  = yes then do: 
    create tt-cont-emit-aux.
    buffer-copy cont-emit to tt-cont-emit-aux.
    create tt-dados-env.                  
    assign tt-dados-env.num-sequencia  = i-seq 
           tt-dados-env.cod-tipo-reg   = 72
           tt-dados-env.ind-tipo-movto = i-tipo-movto
           tt-dados-env.identif-msg    = string(cont-emit.cod-emitente) + "," +
                                         string(cont-emit.sequencia).
    raw-transfer tt-cont-emit-aux to tt-dados-env.conteudo-msg.                                     
    assign i-seq = i-seq + 1.                                     
end.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "cont-emit"}

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


