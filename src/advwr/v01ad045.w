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
{include/i-prgvrs.i V01AD045 2.00.00.009}  /*** 010009 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01AD045 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{utp/ut-glob.i}

/*************Multiplanta********************/

def var i-tipo-movto     as integer         no-undo.
def var l-cria           as logical initial no no-undo.
def var teste            as char            no-undo.

{cdp/cd7300.i1}
{cdp/cdapi238.i}

/************Fim*****************************/

{cdp/cdcfgfin.i} /* Definiá∆o de Funá‰es */
{include/i-freeac.i}
/*-------------- Integraá∆o Magnus I.01 x EMS 2.04 -------------*/
def var i-ind-tipo-movto as inte no-undo.
def var c-valor-chave-mg as char no-undo.

{cdp/cd0708i2.i} /* Definiá∆o da temp-table tt-cont-repres-mg   */
{cdp/cd0001i1.i} /* Definiá∆o da temp-table de erros tt-erro-mg */
/****************************************************************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES cont-repres
&Scoped-define FIRST-EXTERNAL-TABLE cont-repres


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cont-repres.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cont-repres.nome cont-repres.area ~
cont-repres.cargo cont-repres.telefone cont-repres.ramal cont-repres.fax ~
cont-repres.ramal-fax cont-repres.observacao 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}nome ~{&FP2}nome ~{&FP3}~
 ~{&FP1}area ~{&FP2}area ~{&FP3}~
 ~{&FP1}cargo ~{&FP2}cargo ~{&FP3}~
 ~{&FP1}telefone ~{&FP2}telefone ~{&FP3}~
 ~{&FP1}ramal ~{&FP2}ramal ~{&FP3}~
 ~{&FP1}fax ~{&FP2}fax ~{&FP3}~
 ~{&FP1}ramal-fax ~{&FP2}ramal-fax ~{&FP3}~
 ~{&FP1}observacao ~{&FP2}observacao ~{&FP3}
&Scoped-define ENABLED-TABLES cont-repres
&Scoped-define FIRST-ENABLED-TABLE cont-repres
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS cont-repres.cod-repres ~
cont-repres.sequencia cont-repres.nome cont-repres.area cont-repres.cargo ~
cont-repres.telefone cont-repres.ramal cont-repres.fax ~
cont-repres.ramal-fax cont-repres.observacao 
&Scoped-Define DISPLAYED-OBJECTS fi-nome-abrev 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS cont-repres.cod-repres ~
cont-repres.sequencia 

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
DEFINE VARIABLE fi-nome-abrev AS CHARACTER FORMAT "x(12)" 
     VIEW-AS FILL-IN 
     SIZE 25.57 BY .88.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.29.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 6.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cont-repres.cod-repres AT ROW 1.17 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     fi-nome-abrev AT ROW 1.17 COL 24.14 COLON-ALIGNED NO-LABEL
     cont-repres.sequencia AT ROW 2.17 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.72 BY .88
     cont-repres.nome AT ROW 3.58 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.29 BY .88
     cont-repres.area AT ROW 4.58 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.29 BY .88
     cont-repres.cargo AT ROW 5.58 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.29 BY .88
     cont-repres.telefone AT ROW 6.58 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     cont-repres.ramal AT ROW 6.58 COL 49 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     cont-repres.fax AT ROW 7.58 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     cont-repres.ramal-fax AT ROW 7.58 COL 49 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     cont-repres.observacao AT ROW 8.58 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 27.29 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 3.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.cont-repres
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
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
         HEIGHT             = 8.96
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

/* SETTINGS FOR FILL-IN cont-repres.cod-repres IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fi-nome-abrev IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cont-repres.sequencia IN FRAME f-main
   NO-ENABLE 1                                                          */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK KEEP-EMPTY"
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

&Scoped-define SELF-NAME cont-repres.cod-repres
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cont-repres.cod-repres V-table-Win
ON F5 OF cont-repres.cod-repres IN FRAME f-main /* Representante */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom = "adzoom/z01ad229.w"
                       &campo=cont-repres.cod-repres
                       &campozoom=cod-rep}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cont-repres.cod-repres V-table-Win
ON LEAVE OF cont-repres.cod-repres IN FRAME f-main /* Representante */
DO:
 {include/leave.i &tabela=repres
                  &atributo-ref=nome-abrev
                  &variavel-ref=fi-nome-abrev
                  &where="repres.cod-rep = input frame {&frame-name} cont-repres.cod-repres"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cont-repres.cod-repres V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cont-repres.cod-repres IN FRAME f-main /* Representante */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
if cont-repres.cod-repres:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  {btb/btb008za.i0} /* Include utilizada na integraá∆o EMS 2.04 com Magnus I. */
  
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
  {src/adm/template/row-list.i "cont-repres"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cont-repres"}

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

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  {cdp/cd0002i1.i cont-repres} /* Integraá∆o EMS 2.04 x Magnus I.01 */

 /********************Multiplanta***********************/
  
   assign c-transacao = "ADM036".
  {cdp/cd7300.i5 "001" c-transacao}
  
  assign i-tipo-movto = if l-cria = yes then 1 else 2.
  run pi-cria-tt-dados (input i-tipo-movto).
  
  {cdp/cd7300.i6 "001" c-transacao}
  
  /******************Fim-Multiplanta********************/ END PROCEDURE.

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
  assign l-cria = yes.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    {cdp/cd0002i1.i1 cont-repres "no"} /* Integraá∆o EMS 2.04 x Magnus I.01 */

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
    if return-value = 'ADM-ERROR':U then 
       return 'ADM-ERROR':U.

    {cdp/cd0002i1.i1 cont-repres "yes"} /* Integraá∆o EMS 2.04 x Magnus I.01 */

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
  if avail cont-repres then do:
     find repres where repres.cod-rep = cont-repres.cod-repres no-lock no-error.
     assign fi-nome-abrev = if avail repres then repres.nome-abrev else "".
  end.   
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
 /*  find first repres
 *        where repres.cod-rep = input frame {&FRAME-NAME} cont-repres.cod-repres
 *        no-lock no-error.
 *   if not avail repres then display "N∆o encontrado" @ fi-nome-abrev with frame {&FRAME-NAME}.
 *   else display repres.nome-abrev @ fi-nome-abrev with frame {&FRAME-NAME}.
 * */
 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
   
   assign l-implanta = no.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  
  /* Ponha aqui a validaá∆o de chave duplicada */
  if cont-repres.cod-repres:sensitive then do:
     if can-find(cont-repres no-lock where cont-repres.cod-repres = input frame {&frame-name} cont-repres.cod-repres and 
        cont-repres.sequencia = input frame {&frame-name} cont-repres.sequencia) then do:
        {utp/ut-table.i mgadm cont-repres 1}.      
        run utp/ut-msgs.p (input "show",
                           input 7,
                           input return-value).
        apply "entry" to cont-repres.cod-repres in frame {&frame-name}.                   
        Return 'adm-error':U.
     end.      
  end.
  
  /* Ponha aqui as demais validaá‰es */
  find first repres
       where repres.cod-rep = input frame {&FRAME-NAME} cont-repres.cod-repres
       no-lock no-error.
  if not avail repres then do:
     run utp/ut-msgs.p (input "show",
                        input 372,
                        input string(input frame {&FRAME-NAME} cont-repres.cod-repres)).
     
     apply "entry" to cont-repres.cod-repres in frame {&frame-name}.
     Return 'adm-error':U.
  end.
  display repres.nome-abrev @ fi-nome-abrev with frame {&FRAME-NAME}.
  
  if input frame {&frame-name} cont-repres.nome = "" then do:
      run utp/ut-msgs.p (input "show",
                         input  5142,
                         input "").
      apply "entry" to cont-repres.nome in frame {&frame-name}.                   
      return 'adm-error':U.
   end.   
  
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
  Parameters:  "Tabela" , "Programa Magnus".
  Notes:       Integraá∆o EMS 2.04 x Magnus I.01
  ------------------------------------------------------------------------------*/

    {cdp/cd0003i1.i cont-repres cdp/cd0708i2.p}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-cont-repres-mg V-table-Win 
PROCEDURE pi-cria-tt-cont-repres-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  p-ind-tipo-movto (1-Inclus∆o 2-Alteraá∆o 3-Exclus∆o)
  Notes:       Integraá∆o EMS 2.04 x Magnus I.01
------------------------------------------------------------------------------*/
    
    def input param p-ind-tipo-movto as int no-undo.
    def input param p-atualiza       as log no-undo.

    for each tt-cont-repres-mg:
        delete tt-cont-repres-mg.
    end.

    create tt-cont-repres-mg.
    assign tt-cont-repres-mg.ind-tipo-movto = p-ind-tipo-movto
           tt-cont-repres-mg.l-atualiza     = p-atualiza.
    
    /* Campos Iguais */
    assign tt-cont-repres-mg.cod-repres     = cont-repres.cod-repres
           tt-cont-repres-mg.sequencia      = cont-repres.sequencia
           tt-cont-repres-mg.nome           = fn-free-accent(cont-repres.nome)
           tt-cont-repres-mg.area           = fn-free-accent(cont-repres.area)
           tt-cont-repres-mg.cargo          = fn-free-accent(cont-repres.cargo)
           tt-cont-repres-mg.telefone       = cont-repres.telefone
           tt-cont-repres-mg.ramal          = cont-repres.ramal
           tt-cont-repres-mg.fax            = cont-repres.fax
           tt-cont-repres-mg.ramal-fax      = cont-repres.ramal-fax
           tt-cont-repres-mg.observacao     = fn-free-accent(cont-repres.observacao)
           tt-cont-repres-mg.dec-2          = cont-repres.dec-2
           tt-cont-repres-mg.log-1          = cont-repres.log-1
           tt-cont-repres-mg.log-2          = cont-repres.log-2
           tt-cont-repres-mg.char-1         = fn-free-accent(cont-repres.char-1)
           tt-cont-repres-mg.dec-1          = cont-repres.dec-1
           tt-cont-repres-mg.int-1          = cont-repres.int-1
           tt-cont-repres-mg.char-2         = cont-repres.char-2
           tt-cont-repres-mg.int-2          = cont-repres.int-2.

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
    create tt-cont-repres-aux.
    buffer-copy cont-repres to tt-cont-repres-aux.
    create tt-dados-env.                  
    assign tt-dados-env.num-sequencia  = i-seq 
           tt-dados-env.cod-tipo-reg   = 87
           tt-dados-env.ind-tipo-movto = i-tipo-movto
           tt-dados-env.identif-msg    = string(cont-repres.cod-repres) + " , " +
                                         string(cont-repres.sequencia).
    raw-transfer tt-cont-repres-aux to tt-dados-env.conteudo-msg.                                    
    assign i-seq = i-seq + 1.                                     
end.

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

    assign c-valor-chave-mg = string(cont-repres.cod-repres) + ";" + string(cont-repres.sequencia).
  
    {cdp/cd0004i1.i "CD0708B" "CONT-REPRES" c-valor-chave-mg tt-cont-repres-mg.ind-tipo-movto tt-erros-mg.help-msg}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-cont-repres-mg V-table-Win 
PROCEDURE pi-valida-cont-repres-mg :
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
  {src/adm/template/snd-list.i "cont-repres"}

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


