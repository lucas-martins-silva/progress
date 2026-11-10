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
{include/i-prgvrs.i V01AD131 2.00.00.022 } /*** "010022" 28/10/2026 11:09:13  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01AD131 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{utp/ut-glob.i}

{include/i-vrtab.i grupo-fornec}

def new global shared var rw-grupo-fornec as rowid no-undo.

/*  Integracao do EMS X Magnus                          */
{cdp/cdcfgfin.i}
{cdp/cd0001i1.i}
{btb/btb008za.i0}
{include/i-freeac.i} /* include para tirar acentua‡Æo */
def var i-ind-tipo-movto as integer no-undo.


def temp-table tt-grupo-fornec-mg NO-UNDO
    field cod-gr-forn    as int      format "99"
    field descricao      as char     format "x(30)"
    field tp-rec-desp    as int      format ">>9"
    field char-1         as char     format "x(255)"
    field dec-1          as decimal  format "->>>>>>>>>>>9.9"
    field int-1          as int      format "->>>>>>>>>9"
    field log-1          as logical  format "Sim/Nao" initial "Nao"
    field data-1         as date     format "99/99/9999"
    field u-log-1        as logical  format "Sim/Nao" initial "Nao"
    field u-int-1        as int      format "->>>>>>>>>9"
    field u-char-1       as char     format "x(255)"
    field dec-2          as decimal  format "-999999999999.9"
    field u-dec-1        as decimal  format "-999999999999.9"
    field u-dec-2        as decimal  format "-999999999999.9"
    field char-2         as char     format "x(255)"
    field u-char-2       as char     format "x(255)"
    field int-2          as int      format "-9999999999"
    field u-int-2        as int      format "-9999999999"
    field ind-tipo-movto as int      format "9"
    field l-atualiza     as logical  format "Sim/Nao" initial "Sim".


/*************Multiplanta********************/

def var i-tipo-movto    as integer no-undo.
def var l-cria          as logical initial no no-undo.
def var teste           as char no-undo.

def var h-api        as handle no-undo.
def var l-integr-tms as log    no-undo.
def var l-integr-wms as log    no-undo.

DEF var wh-pesquisa  AS HANDLE NO-UNDO.

/* Verificando função de integração */
assign l-integr-tms = no
       l-integr-wms = no.

run hbbo/boParamFuncaoProdut.p persistent set h-api.
run pi_existe_funcao in h-api (input  "TMS Transportador",
                               output l-integr-tms).                               
        
run pi_existe_funcao in h-api (input  "WMS Operador Logistico",
                               output l-integr-wms).                               

delete procedure h-api.
/* Fim da Verificação */

{cdp/cd7300.i1}
{cdp/cdapi233.i}
/************Fim*****************************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES grupo-fornec
&Scoped-define FIRST-EXTERNAL-TABLE grupo-fornec


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR grupo-fornec.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS grupo-fornec.descricao 
&Scoped-define ENABLED-TABLES grupo-fornec
&Scoped-define FIRST-ENABLED-TABLE grupo-fornec
&Scoped-Define ENABLED-OBJECTS RECT-3 RECT-6 
&Scoped-Define DISPLAYED-FIELDS grupo-fornec.cod-gr-forn ~
grupo-fornec.descricao 
&Scoped-define DISPLAYED-TABLES grupo-fornec
&Scoped-define FIRST-DISPLAYED-TABLE grupo-fornec
&Scoped-Define DISPLAYED-OBJECTS i-tp-rec-desp c-receita 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */
&Scoped-define ADM-CREATE-FIELDS grupo-fornec.cod-gr-forn 
&Scoped-define ADM-ASSIGN-FIELDS grupo-fornec.descricao 

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
DEFINE VARIABLE c-receita AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35.72 BY .88 NO-UNDO.

DEFINE VARIABLE i-tp-rec-desp AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Receita/Despesa" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 1.54.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 2.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     grupo-fornec.cod-gr-forn AT ROW 1.54 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     grupo-fornec.descricao AT ROW 3.17 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 40 BY .88
     i-tp-rec-desp AT ROW 4.17 COL 35 COLON-ALIGNED
     c-receita AT ROW 4.17 COL 39.29 COLON-ALIGNED NO-LABEL
     RECT-3 AT ROW 1.25 COL 1
     RECT-6 AT ROW 2.88 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.grupo-fornec
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
         HEIGHT             = 4.5
         WIDTH              = 89.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-receita IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN grupo-fornec.cod-gr-forn IN FRAME F-Main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN grupo-fornec.descricao IN FRAME F-Main
   2                                                                    */
/* SETTINGS FOR FILL-IN i-tp-rec-desp IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME i-tp-rec-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-tp-rec-desp V-table-Win
ON F5 OF i-tp-rec-desp IN FRAME F-Main /* Receita/Despesa */
DO:

     assign l-implanta = yes.
     {include/zoomvar.i &prog-zoom=adzoom/z01ad259.w
                        &campo=i-tp-rec-desp
                        &campozoom=tp-codigo}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-tp-rec-desp V-table-Win
ON LEAVE OF i-tp-rec-desp IN FRAME F-Main /* Receita/Despesa */
DO:
  find tipo-rec-desp where tipo-rec-desp.tp-codigo = input frame {&frame-name} i-tp-rec-desp no-lock no-error.
  if  avail tipo-rec-desp then
      assign c-receita:screen-value in frame {&frame-name} = tipo-rec-desp.descricao.
  else 
      assign c-receita:screen-value in frame {&frame-name} = "".   
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-tp-rec-desp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-tp-rec-desp IN FRAME F-Main /* Receita/Despesa */
DO:
  
  apply 'f5' to self.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN        
   RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  /************************ INTERNAL PROCEDURES ********************/

  /* Se nenhuma das duas fun‡äes de integra‡Æo estiver ativada, dever  desabilitar o campo i-tp-rec-desp*/
    if  l-integr-tms = no
    and l-integr-wms = no then do:
        assign i-tp-rec-desp:VISIBLE = no
               c-receita:VISIBLE = NO               .
    end.  
    /*ELSE DO:
        assign i-tp-rec-desp:SENSITIVE IN FRAME f-main = no
               c-receita:SENSITIVE IN FRAME f-main = NO.               .
    END. */
    
  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/row-list.i "grupo-fornec"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "grupo-fornec"}

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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    if  l-integr-tms 
    or  l-integr-wms then do:       
        
        assign i-tp-rec-desp:SENSITIVE IN FRAME {&FRAME-NAME} = YES.               
        
    end.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* projeto ELLECE - atualizar a tabale conforme parametros abaixo: */
  &IF DEFINED(BF_FIN_PLAT_OPERAD_LOGIST) &THEN
      assign grupo-fornec.tp-rec-desp = INPUT FRAME {&frame-name} i-tp-rec-desp.
  &ELSE
      assign grupo-fornec.int-1       = INPUT FRAME {&frame-name} i-tp-rec-desp.
  &ENDIF

  /* Code placed here will execute AFTER standard behavior.    */

  /* Integra‡Æo do EMS  X  Magnus                              */
  {cdp/cd0002i1.i grupo-fornec}

/********************Multiplanta***********************/
  
   assign c-transacao = "ADM031".
  {cdp/cd7300.i5 "001" c-transacao}
  
  assign i-tipo-movto = if grupo-fornec.cod-gr-forn:sensitive in frame {&frame-name} = yes 
                           then 1 else 2.
  
  run pi-cria-tt-dados (input i-tipo-movto).
  
  {cdp/cd7300.i6 "001" c-transacao}
  
  /******************Fim-Multiplanta********************/ 
    if  l-integr-tms = YES
    and l-integr-wms = YES then do:              
        assign i-tp-rec-desp:SENSITIVE IN FRAME {&frame-name} = no
               c-receita:SENSITIVE IN FRAME {&frame-name} = NO.
    end.  

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
    if  l-integr-tms 
    or  l-integr-wms then do:       
        
        assign i-tp-rec-desp:SENSITIVE IN FRAME {&FRAME-NAME} = YES.               
        
    end.
   /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .
   
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

  /* Code placed here will execute PRIOR to standard behavior. */
  
  /*  Integra‡Æo  EMS  X  Magnus                               */
  {cdp/cd0002i1.i1 grupo-fornec "no"}
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  /*  Integra‡Æo  EMS  X  Magnus                               */
  {cdp/cd0002i1.i1 grupo-fornec "yes"}
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .
     if  l-integr-tms = YES
    and l-integr-wms = YES then do:              
        assign i-tp-rec-desp:SENSITIVE IN FRAME {&frame-name} = no
               c-receita:SENSITIVE IN FRAME {&frame-name} = NO.
    end.  

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

    if  avail grupo-fornec then do:

        /* projeto ELLECE */
        &IF DEFINED(BF_FIN_PLAT_OPERAD_LOGIST) &THEN
            assign i-tp-rec-desp:screen-value in frame {&FRAME-NAME} = string(grupo-fornec.tp-rec-desp).
        &ELSE
            assign i-tp-rec-desp:screen-value in frame {&FRAME-NAME} = string(grupo-fornec.int-1).
        &ENDIF
        
        find first tipo-rec-desp no-lock
             where  tipo-rec-desp.tp-codigo = input frame {&frame-name} i-tp-rec-desp no-error.
        
        if  avail tipo-rec-desp then do:
            assign c-receita:screen-value in frame {&FRAME-NAME} = tipo-rec-desp.descricao.
        end.
        else do:
            assign c-receita:screen-value in frame {&FRAME-NAME} = "".
        end.
        
        DISABLE i-tp-rec-desp
                c-receita WITH FRAME {&FRAME-NAME}.

    end.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    if  l-integr-tms 
    or  l-integr-wms then do:       
        
        assign i-tp-rec-desp:SENSITIVE IN FRAME {&FRAME-NAME} = YES.               
        
    end .
  
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
  
  DO WITH FRAME F-Main:
      i-tp-rec-desp:LOAD-MOUSE-POINTER('image/lupa.cur':U).
  END.
  


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
  
  if avail grupo-fornec then
     assign gr-grupo-fornec = rowid(grupo-fornec).

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
  
  /* Ponha aqui a valida‡Æo de chave duplicada */
     DO WITH FRAME {&FRAME-NAME}:
        IF  grupo-fornec.cod-gr-forn:SENSITIVE IN FRAME {&FRAME-NAME} = yes AND 
           CAN-FIND (grupo-fornec  WHERE grupo-fornec.cod-gr-forn = INTEGER(grupo-fornec.cod-gr-forn:SCREEN-VALUE)) THEN DO:
          {utp/ut-table.i mgadm grupo-fornec 1}
          run utp/ut-msgs.p (input "show", 
                             input 1,
                             input return-value).
          APPLY "ENTRY" TO grupo-fornec.cod-gr-forn IN FRAME {&FRAME-NAME}.
          RETURN "ADM-ERROR":U.
        END.   
     END. 

  /* Ponha aqui as demais valida‡äes */
    
    if  l-integr-tms 
    or  l-integr-wms then do:       
        
        find first tipo-rec-desp
            where tipo-rec-desp.tp-codigo = input frame {&frame-name} i-tp-rec-desp 
            no-lock no-error.
        if  not avail tipo-rec-desp then do:  
             /*{include/i-vldprg.i}*/
            run utp/ut-msgs.p (input "show",
                           input 3299,
                           input "").
            apply 'entry' to i-tp-rec-desp in frame {&FRAME-NAME}.
            return 'adm-error'.
        end.
        else do:
        if  tipo-rec-desp.tipo <> 2 then do:  
            /*{include/i-vldprg.i}*/
            run utp/ut-msgs.p (input "show",
                               input 414,
                               input "").
            apply 'entry' to i-tp-rec-desp in frame {&FRAME-NAME}.
            return 'adm-error'.
        end.
        end.
        
    end.

  /* Dispatch standard ADM method.                             */
  
  
     RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

     if  l-integr-tms 
    or  l-integr-wms then do:       
        
        assign i-tp-rec-desp:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               c-receita:SENSITIVE IN FRAME {&FRAME-NAME} = NO.               
        
    end.    
     
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

{cdp/cd0003i1.i grupo-fornec "cdp/cd0407i1.p"}


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
         create tt-grupo-fornec-aux.
         buffer-copy grupo-fornec to tt-grupo-fornec-aux.
         create tt-dados-env.                  
         assign tt-dados-env.num-sequencia  = i-seq 
                tt-dados-env.cod-tipo-reg   = 80
                tt-dados-env.ind-tipo-movto = i-tipo-movto
                tt-dados-env.identif-msg    = string(grupo-fornec.cod-gr-forn).
         raw-transfer tt-grupo-fornec-aux to tt-dados-env.conteudo-msg.                                    
         assign i-seq = i-seq + 1.                                     
     end.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-grupo-fornec-mg V-table-Win 
PROCEDURE pi-cria-tt-grupo-fornec-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param p-ind-tipo-movto as int no-undo.
def input param p-atualiza       as log  no-undo.

for each tt-grupo-fornec-mg:
    delete tt-grupo-fornec-mg.
end.   

create tt-grupo-fornec-mg.
assign tt-grupo-fornec-mg.cod-gr-forn    = grupo-fornec.cod-gr-forn.
assign tt-grupo-fornec-mg.descricao      = fn-free-accent(grupo-fornec.descricao).
assign tt-grupo-fornec-mg.ind-tipo-movto = p-ind-tipo-movto
       tt-grupo-fornec-mg.l-atualiza     = p-atualiza.

/* projeto ELLECE */
&IF DEFINED(BF_FIN_PLAT_OPERAD_LOGIST) &THEN
    assign tt-grupo-fornec-mg.tp-rec-desp = i-tp-rec-desp.
&ELSE
    assign tt-grupo-fornec-mg.int-1       = i-tp-rec-desp.
&ENDIF



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

{cdp/cd0004i1.i "cd0407" grupo-fornec grupo-fornec.cod-gr-forn tt-grupo-fornec-mg.ind-tipo-movto tt-erros-mg.help-msg}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-grupo-fornec-mg V-table-Win 
PROCEDURE pi-valida-grupo-fornec-mg :
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
  {src/adm/template/snd-list.i "grupo-fornec"}

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
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

