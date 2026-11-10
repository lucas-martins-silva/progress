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
{include/i-prgvrs.i V01AD218 2.00.00.018}  /*** 010018 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i V01AD218 MUT}
&ENDIF

/*************************************************************************
** Vers∆o do MAGNUS utilizada: I.00.001
*************************************************************************/

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

/* Buffers Definitions */
Def buffer b-regiao for regiao.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def new global shared var gr-regiao as rowid no-undo.


/*************Multiplanta********************/

def var i-tipo-movto as integer no-undo.

{cdp/cd7300.i1}
{cdp/cdapi230.i}

/*********************************************/
/****** Integracao EMS 2 FIN x MG *******/
{cdp/cd0001i1.i} /* Definiá∆o tt-erros-mg */
{cdp/cd0707i1.i} /* Definiá∆o tt-regiao-mg */
{cdp/cdcfgfin.i} /* Definiá∆o de vari†veis */
def var i-ind-tipo-movto as integer no-undo.

/*********************************************/

/************Fim*****************************/

{bhp/bh9999.i1}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES regiao
&Scoped-define FIRST-EXTERNAL-TABLE regiao


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR regiao.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS regiao.nome-regiao regiao.localizacao ~
regiao.pais regiao.cod-estabel regiao.narrativa 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}nome-regiao ~{&FP2}nome-regiao ~{&FP3}~
 ~{&FP1}localizacao ~{&FP2}localizacao ~{&FP3}~
 ~{&FP1}pais ~{&FP2}pais ~{&FP3}~
 ~{&FP1}cod-estabel ~{&FP2}cod-estabel ~{&FP3}
&Scoped-define ENABLED-TABLES regiao
&Scoped-define FIRST-ENABLED-TABLE regiao
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS regiao.nome-ab-reg regiao.nome-regiao ~
regiao.localizacao regiao.pais regiao.cod-estabel regiao.narrativa 
&Scoped-Define DISPLAYED-OBJECTS c-desc-estabel 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS regiao.nome-ab-reg 
&Scoped-define ADM-MODIFY-FIELDS regiao.nome-regiao regiao.localizacao ~
regiao.pais regiao.cod-estabel 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS></FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = ':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 9.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     regiao.nome-ab-reg AT ROW 1.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     regiao.nome-regiao AT ROW 2.71 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.43 BY .88
     regiao.localizacao AT ROW 3.71 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .88
     regiao.pais AT ROW 4.71 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .88
     regiao.cod-estabel AT ROW 5.71 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-desc-estabel AT ROW 5.71 COL 27.57 COLON-ALIGNED NO-LABEL
     regiao.narrativa AT ROW 6.67 COL 21.86 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 60 BY 5
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.regiao
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
         HEIGHT             = 11.04
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

/* SETTINGS FOR FILL-IN c-desc-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN regiao.cod-estabel IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN regiao.localizacao IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN regiao.nome-ab-reg IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN regiao.nome-regiao IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN regiao.pais IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{utp/ut-glob.i}
{src/adm/method/viewer.i}
{include/c-viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME regiao.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL regiao.cod-estabel V-table-Win
ON F5 OF regiao.cod-estabel IN FRAME f-main /* Estab */
DO:
   assign l-implanta = yes.
   {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                      &campo=regiao.cod-estabel
                      &campozoom=cod-estabel}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL regiao.cod-estabel V-table-Win
ON LEAVE OF regiao.cod-estabel IN FRAME f-main /* Estab */
DO:
   {include/leave.i &tabela=estabelec
                    &atributo-ref=nome
                    &variavel-ref=c-desc-estabel
                    &where="estabelec.cod-estabel = input frame {&frame-name} regiao.cod-estabel"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL regiao.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF regiao.cod-estabel IN FRAME f-main /* Estab */
DO:
    apply "F5" to self. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME regiao.pais
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL regiao.pais V-table-Win
ON F5 OF regiao.pais IN FRAME f-main /* Pa°s */
DO:
     assign l-implanta = yes.
     {include/zoomvar.i &prog-zoom=adzoom/z01ad276.w
                        &campo=regiao.pais
                        &campozoom=nome-pais}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL regiao.pais V-table-Win
ON MOUSE-SELECT-DBLCLICK OF regiao.pais IN FRAME f-main /* Pa°s */
DO:
      apply "F5" to self. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

/****** Integraá∆o EMS 2 FIN x MG *******/
{btb/btb008za.i0}
{include/i-freeac.i} /* include para tirar acentuaá∆o */


  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  {src/adm/template/row-list.i "regiao"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "regiao"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Ponha aqui a validaá∆o de chave duplicada */
  if input frame {&frame-name} regiao.nome-ab-reg:sensitive = yes then do:
     find first b-regiao no-lock
          where b-regiao.nome-ab-reg = input frame {&frame-name} regiao.nome-ab-reg
          no-error.
     if  avail b-regiao then do:
         run utp/ut-msgs.p (input "show",
                            input 351,
                            input " ").
         apply 'entry' to regiao.nome-ab-reg in frame {&frame-name}.
         return 'ADM-ERROR':U.
     end.
  end.

  /* Ponha aqui as demais validaá‰es */


    if  input frame {&FRAME-NAME} regiao.nome-ab-reg = " " then do:
       {utp/ut-field.i mgadm regiao nome-ab-reg 1}
       run utp/ut-msgs.p (input "show",
                          input 164,
                          input return-value).
       apply 'entry' to regiao.nome-ab-reg in frame {&frame-name}.
       return 'ADM-ERROR':U.
   end.

     


 if  input frame {&FRAME-NAME} regiao.nome-regiao = " " then do:
       {utp/ut-field.i mgadm regiao nome-regiao 1}
       run utp/ut-msgs.p (input "show",
                          input 164,
                          input return-value).
       apply 'entry' to regiao.nome-regiao in frame {&frame-name}.
       return 'ADM-ERROR':U.
   end.

  if  not can-find (first estabelec where
      estabelec.cod-estabel = input frame {&frame-name} regiao.cod-estabel) then do:
      run utp/ut-msgs.p (input "show",
                         input 13,
                         input input frame {&frame-name} regiao.cod-estabel).
      apply 'entry' to regiao.cod-estabel in frame {&frame-name}.
      return 'ADM-ERROR':U.
   end.

   if  input frame {&FRAME-NAME} regiao.pais = " " then do:
       run utp/ut-msgs.p (input "show",
                          input 352,
                          input " ").
       apply 'entry' to regiao.pais in frame {&frame-name}.
       return 'ADM-ERROR':U.
   end.
   
   find pais no-lock
       where pais.nome-pais = input frame {&frame-name} regiao.pais no-error.
   if not avail pais then do:
       run utp/ut-msgs.p (input "show",
                          input 964,
                          input " ").
       apply "entry" to regiao.pais in frame {&frame-name}.
       return "adm-error":U.
   end.                          
   


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

   /****** Integraá∆o EMS 2 FIN x MG *******/
  {cdp/cd0002i1.i regiao}
  

 
 /********************Multiplanta***********************/
  
   assign c-transacao = "ADM027".
  {cdp/cd7300.i5 "001" c-transacao}
  
  assign i-tipo-movto = if regiao.nome-ab-reg:sensitive in frame {&frame-name} = yes
                            then 1 else 2.
                            
  run pi-cria-tt-dados (input i-tipo-movto).
  
  {cdp/cd7300.i6 "001" c-transacao}
  
  /******************Fim-Multiplanta********************/ 

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

/*****[ BANCOS HIST‡RICOS ]**********************************************************************************/
    if  not available(param-global) then
        find first param-global no-lock no-error.
    
    if  param-global.modulo-bh = yes
    then do:
        {bhp/bh9999.i 1 Regiao regiao.nome-regiao '' '' '' '' ''}
        if  return-value <> "OK"
        then return "ADM-ERROR".
    end.
/************************************************************************************************************/

    {cdp/cd0002i1.i1 regiao "no"} /****** Integraá∆o EMS 2 FIN x MG *******/
    
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

    {cdp/cd0002i1.i1 regiao "yes"} /****** Integraá∆o EMS 2 FIN x MG *******/

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
  apply "leave" to regiao.cod-estabel in frame {&frame-name}.

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
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-find-using-key V-table-Win 
PROCEDURE local-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'find-using-key':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  /* se ha integracao com o Magnus, seta o campo narrativa para o tamanho 
     maximo de 380 caracteres */
  &IF DEFINED(BF_FIN_EMS2_X_MG) &THEN
     find funcao
        where funcao.cd-funcao = "spp-ems2fin-x-mg"
          and funcao.ativo     = yes no-lock no-error.
     if  avail funcao then do:
        assign regiao.narrativa:max-chars in frame {&frame-name} = 380.
     end.
  &ENDIF.

  if regiao.cod-estabel:load-mouse-pointer   ("image/lupa.cur") in frame {&frame-name} then.
  if regiao.pais:load-mouse-pointer   ("image/lupa.cur") in frame {&frame-name} then.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  if  avail regiao then do:
      disp  regiao.nome-ab-reg
            regiao.nome-regiao
            regiao.localizacao
            regiao.pais
            regiao.cod-estabel 
            with frame {&frame-name}.
  end.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  if  avail regiao then
      assign gr-regiao = rowid(regiao).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
     
  /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-rpc-mg V-table-Win 
PROCEDURE pi-atualiza-rpc-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /****** Integraá∆o EMS 2 FIN x MG *******/
    {cdp/cd0003i1.i regiao "cdp/cd0707i1.p"}

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
    tt-replica-msg.log-replica-msg = yes then do: 
    create tt-regiao-aux.
    buffer-copy regiao to tt-regiao-aux.
    create tt-dados-env.                  
    assign tt-dados-env.num-sequencia  = i-seq 
           tt-dados-env.cod-tipo-reg   = 73
           tt-dados-env.ind-tipo-movto = i-tipo-movto
           tt-dados-env.identif-msg    = regiao.nome-ab-reg.
    raw-transfer tt-regiao-aux to tt-dados-env.conteudo-msg.                                    
    assign i-seq = i-seq + 1.                                     
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-regiao-mg V-table-Win 
PROCEDURE pi-cria-tt-regiao-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /****** Integraá∆o EMS 2 FIN x MG *******/

    def input param p-ind-tipo-movto as int  no-undo.
    def input param p-atualiza       as log  no-undo.
    
    for each tt-regiao-mg:
        delete tt-regiao-mg.
    end.

    create tt-regiao-mg.

    assign tt-regiao-mg.ind-tipo-movto = p-ind-tipo-movto
           tt-regiao-mg.l-atualiza     = p-atualiza.

    /* campos iguais */
    assign tt-regiao-mg.nome-ab-reg   = fn-free-accent(regiao.nome-ab-reg).
    assign tt-regiao-mg.nome-regiao   = fn-free-accent(regiao.nome-regiao).
    assign tt-regiao-mg.localizacao   = fn-free-accent(regiao.localizacao).
    assign tt-regiao-mg.cod-estabel   = fn-free-accent(regiao.cod-estabel).
    assign tt-regiao-mg.pais          = fn-free-accent(regiao.pais).

    /* campos diferentes */
    assign tt-regiao-mg.narrativa[1]  = fn-free-accent(substring(regiao.narrativa,  1, 76)).
    assign tt-regiao-mg.narrativa[2]  = fn-free-accent(substring(regiao.narrativa, 77,152)).
    assign tt-regiao-mg.narrativa[3]  = fn-free-accent(substring(regiao.narrativa,153,228)).
    assign tt-regiao-mg.narrativa[4]  = fn-free-accent(substring(regiao.narrativa,229,304)).
    assign tt-regiao-mg.narrativa[5]  = fn-free-accent(substring(regiao.narrativa,305,380)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-log-mg V-table-Win 
PROCEDURE pi-gera-log-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   /****** Integraá∆o EMS 2 FIN x MG *******/

    {cdp/cd0004i1.i "CD0707"
                    regiao
                    regiao.nome-ab-reg
                    tt-regiao-mg.ind-tipo-movto
                    tt-erros-mg.help-msg}
    if return-value = "NOK" then
       return.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-regiao-mg V-table-Win 
PROCEDURE pi-valida-regiao-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input-output param p-ind-tipo-movto as int no-undo.

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* There are no foreign keys supplied by this SmartObject. */

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
  {src/adm/template/snd-list.i "regiao"}

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


