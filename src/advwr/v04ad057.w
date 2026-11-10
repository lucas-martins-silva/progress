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
{include/i-prgvrs.i V04AD057 2.00.00.029} /*** "010029" 25/06/2025 16:21:13  ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v04ad057 MUT}
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

{utp/ut-glob.i}

/* global variable definitions */

def new global shared var v-row-parent as rowid no-undo.


/******  BANCOS HIST‡RICOS ******/
{bhp/bh9999.i1}

{cdp/cd1000.i}
/********************************/


/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def new global shared var gr-cta-corrente as rowid no-undo.
define var l-funcionou as logical no-undo initial no.

/*************Multiplanta********************/

def var i-tipo-movto as integer no-undo.
def var l-cria       as logical initial no no-undo.
def var c-conta      as char no-undo.
def var c-conta1     as char no-undo.
def var wh-cd1103 as widget-handle no-undo.
def var c-cd1103 as char no-undo.
def var c-nome       as char no-undo.

{cdp/cd7300.i1}
{cdp/cdapi223.i}

/************Fim*****************************/


/*  Integracao do EMS X Magnus                          */
{cdp/cdcfgfin.i}
{cdp/cd0001i1.i}
{btb/btb008za.i0}
{cdp/cd1103.i}

def var i-ind-tipo-movto    as integer  no-undo.
def var c-formato           as char     no-undo.
def var l-integracao        as log      no-undo.
/*--- possibilita utilizar o   Modulo Multiplanta Financeiro (MMF) ---*/
def var l-ok-mmf     as logical  initial yes   no-undo.
def var c-empr       as char                   no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES cta-corrente
&Scoped-define FIRST-EXTERNAL-TABLE cta-corrente


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cta-corrente.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cta-corrente.conta-saldo 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}conta-saldo ~{&FP2}conta-saldo ~{&FP3}
&Scoped-define ENABLED-TABLES cta-corrente
&Scoped-define FIRST-ENABLED-TABLE cta-corrente
&Scoped-Define ENABLED-OBJECTS rt-key im-banco 
&Scoped-Define DISPLAYED-FIELDS cta-corrente.cod-banco cta-corrente.agencia ~
cta-corrente.conta-corren cta-corrente.conta-saldo 
&Scoped-Define DISPLAYED-OBJECTS c-banco 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS cta-corrente.cod-banco ~
cta-corrente.agencia cta-corrente.conta-corren 

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
DEFINE VARIABLE c-banco AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 31.43 BY .88.

DEFINE IMAGE im-banco
     SIZE 11.43 BY 3.33.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cta-corrente.cod-banco AT ROW 1.5 COL 24.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     c-banco AT ROW 1.5 COL 29.29 COLON-ALIGNED NO-LABEL
     cta-corrente.agencia AT ROW 2.5 COL 24.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     cta-corrente.conta-corren AT ROW 3.5 COL 24.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .88
     cta-corrente.conta-saldo AT ROW 2.58 COL 37.43 COLON-ALIGNED NO-LABEL
           VIEW-AS TEXT 
          SIZE 18.14 BY .67
     rt-key AT ROW 1 COL 1
     im-banco AT ROW 1.5 COL 86.57 RIGHT-ALIGNED
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.cta-corrente
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
         HEIGHT             = 4.04
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

/* SETTINGS FOR FILL-IN cta-corrente.agencia IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN c-banco IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cta-corrente.cod-banco IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN cta-corrente.conta-corren IN FRAME f-main
   NO-ENABLE 1                                                          */
ASSIGN 
       cta-corrente.conta-saldo:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR IMAGE im-banco IN FRAME f-main
   ALIGN-R                                                              */
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

&Scoped-define SELF-NAME cta-corrente.agencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.agencia V-table-Win
ON ENTRY OF cta-corrente.agencia IN FRAME f-main /* Agància */
DO:
    if  l-integracao then do:
        assign cta-corrente.agencia:format in frame {&frame-name} = "999999-X".
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.agencia V-table-Win
ON F5 OF cta-corrente.agencia IN FRAME f-main /* Agància */
DO:
Assign l-implanta = yes.
{include/zoomvar.i &prog-zoom=adzoom/z01ad009.w
                   &campo=cta-corrente.agencia
                   &campozoom=agencia
                   &parametros= "run pi-seta-inicial in wh-pesquisa (input input frame {&frame-name} cta-corrente.cod-banco)."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.agencia V-table-Win
ON LEAVE OF cta-corrente.agencia IN FRAME f-main /* Agància */
DO:
    if  l-integracao then do:
        assign c-formato = input frame {&FRAME-NAME} cta-corrente.agencia no-error.
        if  error-status:get-number(1) <> 0 then do:
            assign cta-corrente.agencia:format in frame {&frame-name} = "X(8)".
        end.
        else do:
             assign cta-corrente.agencia:format in frame {&frame-name} = "999999-X".
        end.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.agencia V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cta-corrente.agencia IN FRAME f-main /* Agància */
DO:
    Apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cta-corrente.cod-banco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.cod-banco V-table-Win
ON F5 OF cta-corrente.cod-banco IN FRAME f-main /* Banco */
DO:
Assign l-implanta = yes.
{include/zoomvar.i &prog-zoom=adzoom/z01ad018.w
                   &campo={&self-name}
                   &campozoom=cod-banco}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.cod-banco V-table-Win
ON LEAVE OF cta-corrente.cod-banco IN FRAME f-main /* Banco */
DO:
  {include/leave.i &tabela = banco
                   &atributo-ref = nome-banco
                   &variavel-ref = c-banco
                   &where = "banco.cod-banco = input frame {&frame-name} cta-corrente.cod-banco"}
                   
  find first banco where 
      banco.cod-banco = input frame {&FRAME-NAME} cta-corrente.cod-banco no-lock no-error.
  
  if  avail banco then do:  
      assign im-banco:hidden in frame {&frame-name} = no.  
      
      if  im-banco:load-image("") in frame {&frame-name} then.
          if  banco.cod-imagem <> "" then do:
              find imagem no-lock where
                   imagem.cod_imagem = banco.cod-imagem 
                   no-error.
              if  avail imagem then do:
                    
                  find catal_img of imagem no-lock no-error.
                  if  avail catal_img then do:
                      if imagem.img_imagem matches("*.bmp") 
                      or imagem.img_imagem matches("*.gif") 
                      or imagem.img_imagem matches("*.ico")
                      or imagem.img_imagem matches("*.jpg") then do:
                         assign c-nome = string(catal_img.cod_path_catal + "/" + imagem.img_imagem).
                         assign l-funcionou = im-banco:load-image(c-nome) in frame {&frame-name} no-error.
                      end.
                 end.
              end.
          end.
  end.                 
  else assign im-banco:hidden in frame {&frame-name} = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.cod-banco V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cta-corrente.cod-banco IN FRAME f-main /* Banco */
DO:
    Apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cta-corrente.conta-corren
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.conta-corren V-table-Win
ON ENTRY OF cta-corrente.conta-corren IN FRAME f-main /* Conta Corrente */
DO:
    if  l-integracao then do:
        assign cta-corrente.conta-corren:format in frame {&frame-name} = "999999999-XX".
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cta-corrente.conta-corren V-table-Win
ON LEAVE OF cta-corrente.conta-corren IN FRAME f-main /* Conta Corrente */
DO:
    if  l-integracao then do:
        assign c-formato = input frame {&FRAME-NAME} cta-corrente.conta-corren no-error.
        if  error-status:get-number(1) <> 0 then do:
            assign cta-corrente.conta-corren:format in frame {&frame-name} = "x(20)".
        end.
        else do:
            assign cta-corrente.conta-corren:format in frame {&frame-name} = "999999999-XX".
        end.
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

if cta-corrente.cod-banco:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
if cta-corrente.agencia:load-mouse-pointer   ("image/lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "cta-corrente"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cta-corrente"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  
  apply 'leave' to cta-corrente.cod-banco in frame {&frame-name}.

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
    /* Ponha na pi-validate todas as validaá‰es */
    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
    nem na PI-validate. */  
   
    run pi-validate.
  
    if return-value = "adm-error":U then
      return " adm-error":u.   
  
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  
    /* Code placed here will execute AFTER standard behavior.    */
    
    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */ 
    assign cta-corrente.ep-codigo = i-ep-codigo-usuario. 
    
    /* Integraá∆o do EMS  X  Magnus                              */
    {cdp/cd0002i1.i cta-corrente}
    
    if  l-ok-mmf = yes then do:
  
        /********************Multiplanta***********************/
     
        assign c-transacao = "ADM020".
        {cdp/cd7300.i5 "001" c-transacao}
        
        assign i-tipo-movto = if  cta-corrente.cod-banco:sensitive in frame {&frame-name} = yes and
                                  cta-corrente.agencia:sensitive in frame {&frame-name} = yes and
                                  cta-corrente.conta-corren:sensitive in frame {&frame-name} = yes
                                  then 1 
                                  else 2.
      
        run pi-cria-tt-dados (input i-tipo-movto).
        
        {cdp/cd7300.i6 "001" c-transacao}
        
        /******************Fim-Multiplanta********************/  
    end.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  assign im-banco:hidden in frame {&frame-name} = no.

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

  /************ BANCOS HISTORICOS ************/
  if  not available(param-global) then
      find first param-global no-lock no-error.

  if  l-funcao-banc-hist-adm then do:
      {bhp/bh9999.i 1 cta-corrente cta-corrente.cod-banco cta-corrente.agencia cta-corrente.conta-corren '' '' ''}
      if  return-value <> "OK" then
          return error.
  end.

  /* Code placed here will execute PRIOR to standard behavior. */

  find first movto-banco
       where movto-banco.banco     = cta-corrente.cod-banco
       and   movto-banco.agencia   = cta-corrente.agencia
       and   movto-banco.cta-corrente = cta-corrente.conta-corren
       no-lock no-error.
   if avail movto-banco then do:
      run utp/ut-msgs.p (input "show",
                         input 5981,
                         input "").
      apply 'entry' to cta-corrente.cod-banco in frame {&frame-name}.
      Return 'ADM-ERROR':U.
   end.
  find first extrato-banco
       where extrato-banco.banco        = cta-corrente.cod-banco
       and   extrato-banco.agencia      = cta-corrente.agencia
       and   extrato-banco.cta-corrente = cta-corrente.conta-corren
       no-lock no-error.
   if avail extrato-banco then do:
      run utp/ut-msgs.p (input "show",
                         input 6967,
                         input "").
      apply 'entry' to cta-corrente.cod-banco in frame {&frame-name}.
      Return 'ADM-ERROR':U.
   end.
  find first portador
       where portador.ep-codigo    = i-ep-codigo-usuario
       and   portador.cod-banco    = cta-corrente.cod-banco
       and   portador.agencia      = cta-corrente.agencia
       and   portador.conta-corren = cta-corrente.conta-corren
       no-lock no-error.
   if avail portador then do:
      run utp/ut-msgs.p (input "show",
                         input 6968,
                         input "").
      apply 'entry' to cta-corrente.cod-banco in frame {&frame-name}.
      Return 'ADM-ERROR':U.
   end.
   
   /*  Integraá∆o  EMS  X  Magnus                               */
   {cdp/cd0002i1.i1 cta-corrente "no"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  /*  Integraá∆o  EMS  X  Magnus                               */
  {cdp/cd0002i1.i1 cta-corrente "yes"}

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
  
  RUN Who-Is-The-Container IN adm-broker-hdl
     (INPUT this-procedure,
      OUTPUT c-cd1103).
     
  assign wh-cd1103 = widget-handle (c-cd1103).
  
  RUN select-page IN  wh-cd1103 (1).
    
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

  if  available cta-corrente then do:
      find banco where banco.cod-banco = cta-corrente.cod-banco no-lock no-error.
      assign c-banco = if avail banco then banco.nome-banco else "":U.
      if  avail banco then do:
          assign im-banco:hidden in frame {&frame-name} = no.
          if  im-banco:load-image("") in frame {&frame-name} then.
              if  banco.cod-imagem <> "" then do:
                  find imagem no-lock where
                  imagem.cod_imagem = banco.cod-imagem no-error.
                  if  avail imagem then do:
                      find catal_img of imagem no-lock no-error.
                      if  avail catal_img then do:
                          assign l-funcionou = im-banco:load-image(string(catal_img.cod_path_catal + "/" + imagem.img_imagem))
                                               in frame {&frame-name} no-error.
                      end.
                  end.
              end.  
      end.        
      else assign im-banco:hidden in frame {&frame-name} = yes.        
  end.
 
  /* Dispatch standard ADM method.                             */
    
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
    
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
  
    assign l-integracao = no.
    &IF DEFINED(BF_FIN_EMS2_X_MG) &THEN
        find funcao
            where funcao.cd-funcao = "spp-ems2fin-x-mg"
              and funcao.ativo     = yes no-lock no-error.
        if  avail funcao then do:
            assign l-integracao = yes.
            assign cta-corrente.agencia:format      in frame {&frame-name} = "999999-X"
                   cta-corrente.conta-corren:format in frame {&frame-name} = "999999999-XX".
        end.
    &ENDIF.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
    /* Code placed here will execute AFTER standard behavior.    */
    /*---  Modulo Multiplanta Financeiro (MMF) ---*/
    {cdp/cdapi531.i1 "ADM020" "NO"}

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
  
  If avail cta-corrente then 
        Assign gr-cta-corrente = rowid(cta-corrente).
  
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

{cdp/cd0003i1.i cta-corrente "cdp/cd1103i1.p"}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-cta-corrente-mg V-table-Win 
PROCEDURE pi-cria-tt-cta-corrente-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param p-ind-tipo-movto as int no-undo.
def input param p-atualiza       as log  no-undo.

for each tt-cta-corrente-mg:
    delete tt-cta-corrente-mg.
end.   

create  tt-cta-corrente-mg.
assign  tt-cta-corrente-mg.cod-mod           = ""
        tt-cta-corrente-mg.ep-codigo         = cta-corrente.ep-codigo
        tt-cta-corrente-mg.banco             = cta-corrente.cod-banco
        tt-cta-corrente-mg.agencia           = cta-corrente.agencia
        tt-cta-corrente-mg.cta-corrente      = cta-corrente.conta-corren
        tt-cta-corrente-mg.saldo-ini         = cta-corrente.saldo-ini
        tt-cta-corrente-mg.data-saldo        = cta-corrente.data-saldo
        tt-cta-corrente-mg.saldo-atual       = cta-corrente.saldo-atual
        tt-cta-corrente-mg.cod-estabel       = cta-corrente.cod-estabel
        tt-cta-corrente-mg.cod-mod-garantido = cta-corrente.cod-mod-garantido
        tt-cta-corrente-mg.lancamento        = cta-corrente.lancamento
        tt-cta-corrente-mg.dt-ult-corr       = cta-corrente.dt-ult-corr
        tt-cta-corrente-mg.ct-deb-princ      = int(cta-corrente.ct-deb-princ)
        tt-cta-corrente-mg.sc-deb-princ      = int(cta-corrente.sc-deb-princ)
        tt-cta-corrente-mg.ct-juros-rec      = int(cta-corrente.ct-juros-rec)
        tt-cta-corrente-mg.sc-juros-rec      = int(cta-corrente.sc-juros-rec)
        tt-cta-corrente-mg.ct-despesas       = int(cta-corrente.ct-despes-financ)
        tt-cta-corrente-mg.sc-despesas       = int(cta-corrente.sc-despes-financ)
        tt-cta-corrente-mg.ct-tit-desc       = int(cta-corrente.ct-tit-desc)
        tt-cta-corrente-mg.sc-tit-desc       = int(cta-corrente.sc-tit-desc)
        tt-cta-corrente-mg.ct-juros-pg       = int(cta-corrente.ct-juros-pg)
        tt-cta-corrente-mg.sc-juros-pg       = int(cta-corrente.sc-juros-pg)
        tt-cta-corrente-mg.ct-desconto-pg    = int(cta-corrente.ct-desconto-pg)
        tt-cta-corrente-mg.sc-desconto-pg    = int(cta-corrente.sc-desconto-pg)
        tt-cta-corrente-mg.ct-ipmf           = int(cta-corrente.ct-ipmf)
        tt-cta-corrente-mg.sc-ipmf           = int(cta-corrente.sc-ipmf)
        tt-cta-corrente-mg.ct-equaliz-rec    = int(cta-corrente.ct-equaliz-rec)
        tt-cta-corrente-mg.sc-equaliz-rec    = int(cta-corrente.sc-equaliz-rec)
        tt-cta-corrente-mg.ct-equaliz-desp   = int(cta-corrente.ct-equaliz-desp)
        tt-cta-corrente-mg.sc-equaliz-desp   = int(cta-corrente.sc-equaliz-desp)
        tt-cta-corrente-mg.ct-vendor         = int(cta-corrente.ct-vendor)
        tt-cta-corrente-mg.sc-vendor         = int(cta-corrente.sc-vendor)
        tt-cta-corrente-mg.ind-tipo-movto    = p-ind-tipo-movto
        tt-cta-corrente-mg.l-atualiza        = p-atualiza.

/*  Determinar se o valor do saldo inicial e atual Ç positico ou negativo */
if cta-corrente.saldo-ini > 0 then 
   assign tt-cta-corrente-mg.lc-inicial = no.
else
   assign tt-cta-corrente-mg.lc-inicial = yes.
   
if cta-corrente.saldo-atual > 0 then 
   assign tt-cta-corrente-mg.lc-atual = no.
else
   assign tt-cta-corrente-mg.lc-atual = yes.



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
    create tt-cta-corrente-aux.
    buffer-copy cta-corrente to tt-cta-corrente-aux.
    create tt-dados-env.                  
    assign tt-dados-env.num-sequencia  = i-seq 
           tt-dados-env.cod-tipo-reg   = 50
           tt-dados-env.ind-tipo-movto = i-tipo-movto
           tt-dados-env.identif-msg    = string(cta-corrente.cod-banco)  + " , " + 
                                         string(cta-corrente.agencia)    + " , " + 
                                         string(cta-corrente.conta-corren).
    raw-transfer tt-cta-corrente-aux to tt-dados-env.conteudo-msg.                                     
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

{cdp/cd0004i1.i "cd1103" cta-corrente cta-corrente.cod-banco,cta-corrente.agencia,cta-corrente.conta-corren tt-cta-corrente-mg.ind-tipo-movto tt-erros-mg.help-msg}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-cta-corrente-mg V-table-Win 
PROCEDURE pi-valida-cta-corrente-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input-output param i-ind-tipo-movto as int no-undo.

Return "OK":U.

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

If cta-corrente.cod-banco:sensitive = yes then do:
  find banco no-lock 
      where banco.cod-banco = input frame {&frame-name} cta-corrente.cod-banco
      no-error.
  If not avail banco then do:
      {utp/ut-table.i mgadm banco 1}.
      run utp/ut-msgs.p (input "show",
                         input 2,
                         input return-value).
      apply 'entry' to cta-corrente.cod-banco in frame {&frame-name}.
      Return 'ADM-ERROR':U.
  End.
  find agencia no-lock 
      where agencia.cod-banco = input frame {&frame-name} cta-corrente.cod-banco
      and   agencia.agencia   = input frame {&frame-name} cta-corrente.agencia
      no-error.
  If not avail agencia then do:
      {utp/ut-table.i mgadm agencia 1}.
      run utp/ut-msgs.p (input "show",
                         input 2,
                         input return-value).
      apply 'entry' to cta-corrente.agencia in frame {&frame-name}.
      Return 'ADM-ERROR':U.
  End.
  find cta-corrente no-lock 
      where cta-corrente.cod-banco    = input frame {&frame-name} cta-corrente.cod-banco
      and   cta-corrente.agencia      = input frame {&frame-name} cta-corrente.agencia
      and   cta-corrente.conta-corren = input frame {&frame-name} cta-corrente.conta-corren
      no-error.
  If avail cta-corrente then do:
      {utp/ut-table.i mgadm cta-corrente 1}.
      run utp/ut-msgs.p (input "show",
                         input 1,
                         input return-value).
      apply 'entry' to cta-corrente.conta-corren in frame {&frame-name}.
      Return 'ADM-ERROR':U.
  End.
End.

/* O Oracle diferencia quanto a acentos */
{utp/ut-liter.i NAO_BANCARIO mcb L}
assign c-conta = trim(return-value).
{utp/ut-liter.i N∆o_Banc†rio mcb L}
assign c-conta1 = trim(return-value).

if input frame {&FRAME-NAME} cta-corrente.conta-corren = c-conta
or input frame {&FRAME-NAME} cta-corrente.conta-corren = c-conta1 then do:
   run utp/ut-msgs.p (input "show",
                      input 7441,
                      input "").
   apply 'entry' to cta-corrente.conta-corren in frame {&frame-name}.
   Return 'ADM-ERROR':U.
end.

/*find cta-corrente
 *     where cta-corrente.conta-corren = input frame {&FRAME-NAME} cta-corrente.conta-corren 
 *     no-lock no-error.
 * if  not avail cta-corrente then do:
 *     run utp/ut-msgs.p (input "show",
 *                        input 42,
 *                        input "").
 *     apply 'entry' to cta-corrente.conta-corren in frame {&frame-name}.
 *     Return 'ADM-ERROR':U.
 * end.*/

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
  {src/adm/template/snd-list.i "cta-corrente"}

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


