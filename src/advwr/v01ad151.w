&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
{include/i-prgvrs.i V01AD151 2.00.00.009}  /*** 010009 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01AD151 MUT}
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
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def buffer b-instr-banco for instr-banco.
def var i-modulo        as integer format "99"    no-undo.
DEF VAR i-Tipo-Conta    AS INTEGER INITIAL 1      NO-UNDO.
DEF VAR cAuxTraducao001 AS CHARACTER NO-UNDO.
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
&Scoped-define EXTERNAL-TABLES instr-banco
&Scoped-define FIRST-EXTERNAL-TABLE instr-banco


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR instr-banco.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS instr-banco.instr-do-banc 
&Scoped-define ENABLED-TABLES instr-banco
&Scoped-define FIRST-ENABLED-TABLE instr-banco
&Scoped-define DISPLAYED-TABLES instr-banco
&Scoped-define FIRST-DISPLAYED-TABLE instr-banco
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS instr-banco.cod-banco instr-banco.cod-instr ~
instr-banco.instr-do-banc 
&Scoped-Define DISPLAYED-OBJECTS cb-modulo c-desc-banco c-desc-instr 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS cb-modulo instr-banco.cod-banco ~
instr-banco.cod-instr 

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
DEFINE VARIABLE cb-modulo AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     LABEL "M¢dulo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE-PIXELS 147 BY 24 NO-UNDO.

DEFINE VARIABLE c-desc-banco AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-instr AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.14 BY 3.83.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.14 BY 1.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cb-modulo AT Y 9 X 144 COLON-ALIGNED
     instr-banco.cod-banco AT ROW 2.5 COL 21.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-desc-banco AT ROW 2.5 COL 26.57 COLON-ALIGNED NO-LABEL
     instr-banco.cod-instr AT ROW 3.5 COL 21.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-desc-instr AT ROW 3.5 COL 26.57 COLON-ALIGNED NO-LABEL
     instr-banco.instr-do-banc AT ROW 5.21 COL 21.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 4.96 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.instr-banco
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
         HEIGHT             = 5.38
         WIDTH              = 88.14.
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

/* SETTINGS FOR FILL-IN c-desc-banco IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-instr IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-modulo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN instr-banco.cod-banco IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN instr-banco.cod-instr IN FRAME f-main
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

&Scoped-define SELF-NAME cb-modulo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-modulo V-table-Win
ON VALUE-CHANGED OF cb-modulo IN FRAME f-main /* M¢dulo */
DO:
    assign input frame {&frame-name} cb-modulo.

    IF INPUT FRAME {&frame-name} cb-modulo = {adinc/i04ad296.i 04 1} THEN 
        /* Contas a Receber */
        ASSIGN i-Tipo-Conta = 1.   
    ELSE    
        /* Contas a Pagar */
        ASSIGN i-Tipo-Conta = 2.    

    APPLY 'leave' TO instr-banco.cod-instr IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME instr-banco.cod-banco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL instr-banco.cod-banco V-table-Win
ON F5 OF instr-banco.cod-banco IN FRAME f-main /* Banco */
DO:
  
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=adzoom/z01ad018.w
                     &campo=instr-banco.cod-banco
                     &campozoom=cod-banco}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL instr-banco.cod-banco V-table-Win
ON LEAVE OF instr-banco.cod-banco IN FRAME f-main /* Banco */
DO:

    find first banco no-lock
         where banco.cod-banco = input frame {&FRAME-NAME} instr-banco.cod-banco no-error.
    
    if  avail banco then 
        assign c-desc-banco:screen-value in frame {&FRAME-NAME} = banco.nome-banco.
    else 
        assign c-desc-banco:screen-value in frame {&FRAME-NAME} = "".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL instr-banco.cod-banco V-table-Win
ON MOUSE-SELECT-DBLCLICK OF instr-banco.cod-banco IN FRAME f-main /* Banco */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME instr-banco.cod-instr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL instr-banco.cod-instr V-table-Win
ON F5 OF instr-banco.cod-instr IN FRAME f-main /* Instr Banc†ria */
DO:
    
    assign l-implanta = yes. 
    {include/zoomvar.i &prog-zoom=adzoom/z01ad152.w
                       &campo=instr-banco.cod-instr
                       &campozoom=cod-instr}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL instr-banco.cod-instr V-table-Win
ON LEAVE OF instr-banco.cod-instr IN FRAME f-main /* Instr Banc†ria */
DO:
    FIND FIRST instrucao WHERE 
         instrucao.cod-instr       = INPUT FRAME {&FRAME-NAME} instr-banco.cod-instr 
     AND instrucao.ind-modul-dtsul = i-Tipo-Conta NO-LOCK NO-ERROR.
         
    if  avail instrucao then 
        assign c-desc-instr:screen-value in frame {&FRAME-NAME} = instrucao.descricao.
    else 
        assign c-desc-instr:screen-value in frame {&FRAME-NAME} = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL instr-banco.cod-instr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF instr-banco.cod-instr IN FRAME f-main /* Instr Banc†ria */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
{utp/ut-liter.i Modulo * R}
assign cb-modulo:label in frame  {&frame-name} = return-value.
IF instr-banco.cod-instr:LOAD-MOUSE-POINTER ("image~\lupa.cur") IN FRAME {&FRAME-NAME} THEN.
IF instr-banco.cod-banco:LOAD-MOUSE-POINTER ("image~\lupa.cur") IN FRAME {&FRAME-NAME} THEN.


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
  {src/adm/template/row-list.i "instr-banco"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "instr-banco"}

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

  {include/i-valid.i}

  RUN get-attribute ('adm-new-record':U).
  if  return-value = "yes":U then do:
      
      assign input frame {&frame-name} cb-modulo i-modulo = {adinc/i04ad296.i 06 cb-modulo}.
            
      find first b-instr-banco 
           where b-instr-banco.ind-modul-dtsul =  i-modulo
           and   b-instr-banco.cod-banco       = input frame {&FRAME-NAME} instr-banco.cod-banco
           and   b-instr-banco.cod-instr       = input frame {&FRAME-NAME} instr-banco.cod-instr
           no-lock no-error.
            
      if  avail b-instr-banco then do:       
          run utp/ut-msgs.p (input "show",
                             input 5293,    
                             input "").
          apply 'entry' to cb-modulo in frame {&FRAME-NAME}.
          return ("adm-error":U).                 
      end.     
                
      find first banco no-lock
           where banco.cod-banco = input frame {&FRAME-NAME} instr-banco.cod-banco no-error.
               
      if  not available banco then do: 
          run utp/ut-msgs.p (input "show",
                             input 7276,    
                             input "").
          apply 'entry' to instr-banco.cod-banco in frame {&FRAME-NAME}.
          return ("adm-error":U).                 
      end. 
                
      if  input frame {&FRAME-NAME} instr-banco.cod-instr = 0 then do:  
          {utp/ut-liter.i Campo * C}
          run utp/ut-msgs.p (input "show",
                             input 1491,    
                             input trim(return-value)).
          apply 'entry' to instr-banco.cod-instr in frame {&FRAME-NAME}.
          return ("adm-error":U).                 
      end. 
      
      find first instrucao no-lock
           where instrucao.cod-instr = input frame {&FRAME-NAME} instr-banco.cod-instr 
           and   instrucao.ind-modul-dtsul =  i-modulo
           no-error.
       
      if  not avail instrucao then do: 
          run utp/ut-msgs.p (input "show",
                             input 7277,    
                             input "").
          apply 'entry' to instr-banco.cod-instr in frame {&FRAME-NAME}.
          return ("adm-error":U).                 
      end.     
  end.        
                
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .                                 

  ASSIGN instr-banco.ind-modul-dtsul =  i-modulo.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

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

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
 
  find first banco no-lock
       where banco.cod-banco = input frame {&FRAME-NAME} instr-banco.cod-banco no-error.
  
  if  avail banco then do:
      assign c-desc-banco:screen-value in frame {&FRAME-NAME} = banco.nome-banco.
  end.
  else do:
      assign c-desc-banco:screen-value in frame {&FRAME-NAME} = "".
  end.
 
  assign input frame {&frame-name} cb-modulo 
         i-modulo = {adinc/i04ad296.i 06 cb-modulo}.

  if  avail instr-banco then do:      
      &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
          ASSIGN cAuxTraducao001 = {adinc/i04ad296.i 03}.
          RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
          ASSIGN cb-modulo:LIST-ITEM-PAIRS in frame {&frame-name} = cAuxTraducao001.
      &else
          ASSIGN cb-modulo:LIST-ITEMS in frame {&frame-name} = {adinc/i04ad296.i 03}.
      &endif

      assign cb-modulo:screen-value = {adinc/i04ad296.i 04 instr-banco.ind-modul-dtsul}. 
      APPLY 'value-changed' TO cb-modulo IN FRAME {&FRAME-NAME}.
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

  run get-attribute ('adm-new-record').

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

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

  assign input frame {&frame-name} cb-modulo:list-items   = {adinc/i04ad296.i 03}
         input frame {&frame-name} cb-modulo:screen-value = {adinc/i04ad296.i 04 1}.
 

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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

  {include/i-vldfrm.i}
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE salvar_chave V-table-Win 
PROCEDURE salvar_chave :
/*
    Salva a chave da tabela instr-banco.
    Esta funªío ≤ executada sempre que a procedura local-assign-record ≤ executada.
*/

    ASSIGN instr-banco.ind-modul-dtsul = i-Tipo-Conta.
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
  {src/adm/template/snd-list.i "instr-banco"}

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

