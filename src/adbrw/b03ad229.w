&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgdis            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i B03AD229 2.00.00.004} /*** "010004" 10/06/2025 10:18:57  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i B03AD229 MUT}
&ENDIF


/*------------------------------------------------------------------------

  File:  

  Description: from BROWSER.W - Basic SmartBrowser Object Template

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
&Scop adm-attribute-dlg support/browserd.w

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var i-rep-ind as integer no-undo.
def var i-cont as integer no-undo.
def var l-editing as logical initial false no-undo.

DEF new global shared TEMP-TABLE TT-repres
   field ri-rowid          as rowid
   field nro               as integer
   FIELD i-repres          LIKE repres.cod-rep
   FIELD c-abrev           LIKE repres.nome-abrev
   FIELD de-perc           LIKE repres.comis-direta
   FIELD de-fat            LIKE repres.comis-emis.

def new global shared var v-row-lin-i-ap as rowid no-undo. 
def new global shared var v-row-parent as rowid no-undo.
def var v-row-table  as rowid no-undo.
def new global shared var de-tot-movto as dec format ">>,>>>,>>>,>>9.99" no-undo.
def var c-handle    as handle.
def var c-handle-qry as handle.
def new global shared var v-incluir-modificar as char format "x(20)" no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br-table

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES nota-fiscal
&Scoped-define FIRST-EXTERNAL-TABLE nota-fiscal


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR nota-fiscal.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-repres

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br-table                                      */
&Scoped-define FIELDS-IN-QUERY-br-table tt-repres.i-repres tt-repres.c-abrev tt-repres.de-perc tt-repres.de-fat   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-table   
&Scoped-define FIELD-PAIRS-IN-QUERY-br-table
&Scoped-define SELF-NAME br-table
&Scoped-define OPEN-QUERY-br-table OPEN QUERY {&SELF-NAME} FOR EACH tt-repres NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-table tt-repres
&Scoped-define FIRST-TABLE-IN-QUERY-br-table tt-repres


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-table bt-incluir bt-modificar bt-eliminar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS
><EXECUTING-CODE>
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS>
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE>
<FILTER-ATTRIBUTES>
************************
* Initialize Filter Attributes */
RUN set-attribute-list IN THIS-PROCEDURE ('
  Filter-Value=':U).
/************************
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-eliminar 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-incluir 
     LABEL "&Incluir" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-modificar 
     LABEL "&Modificar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-table FOR 
      tt-repres SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-table B-table-Win _FREEFORM
  QUERY br-table NO-LOCK DISPLAY
      tt-repres.i-repres
      tt-repres.c-abrev
      tt-repres.de-perc COLUMN-LABEL "% Comis"
      tt-repres.de-fat
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 66 BY 6.46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br-table AT ROW 1 COL 1
     bt-incluir AT ROW 7.5 COL 1
     bt-modificar AT ROW 7.5 COL 11
     bt-eliminar AT ROW 7.5 COL 21
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         BGCOLOR 8 FGCOLOR 0 .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: mgdis.nota-fiscal
   Allow: Basic,Browse
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
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 7.67
         WIDTH              = 66.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit L-To-R                                       */
/* BROWSE-TAB br-table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-table
/* Query rebuild information for BROWSE br-table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-repres NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK KEY-PHRASE"
     _Query            is NOT OPENED
*/  /* BROWSE br-table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}
{include/c-browse.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br-table
&Scoped-define SELF-NAME br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON MOUSE-SELECT-DBLCLICK OF br-table IN FRAME F-Main
DO:
    RUN New-State('DblClick':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON ROW-ENTRY OF br-table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON ROW-LEAVE OF br-table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table B-table-Win
ON VALUE-CHANGED OF br-table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
  run new-state('New-Line|':U + string(rowid({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}))).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-eliminar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-eliminar B-table-Win
ON CHOOSE OF bt-eliminar IN FRAME F-Main /* Eliminar */
DO:
    if  avail {&FIRST-TABLE-IN-QUERY-{&browse-name}} then do with frame {&frame-name}:
      {include/confdel.i}
      if l-resposta then 
      do:
        delete tt-repres.
        if  {&browse-name}:delete-current-row() then .
        RUN dispatch IN THIS-PROCEDURE ('open-query':U).
      end.
    end.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-incluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-incluir B-table-Win
ON CHOOSE OF bt-incluir IN FRAME F-Main /* Incluir */
DO:
    assign v-incluir-modificar = "Incluir":U.
  
    assign v-row-table   = ?.
           
    RUN ftp/ft0581b.w (input-output v-row-table,
                       input this-procedure,
                       input v-incluir-modificar).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-modificar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-modificar B-table-Win
ON CHOOSE OF bt-modificar IN FRAME F-Main /* Modificar */
DO:

  if  avail {&FIRST-TABLE-IN-QUERY-{&browse-name}} then 
  do with frame {&frame-name}:           
                   
    assign v-incluir-modificar = "Modificar":U    
           v-row-table   = rowid(tt-repres).
  
    RUN ftp/ft0581b.w (input-output v-row-table,
                       input this-procedure,
                       input v-incluir-modificar).
  end.
                       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "nota-fiscal"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "nota-fiscal"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  if not l-editing then
  do:
    FOR EACH TT-repres exclusive-lock:
      DELETE TT-repres.
    END.
    
    i-cont = 0.
    for each  fat-repre
        where fat-repre.cod-estabel = nota-fiscal.cod-estabel
          and fat-repre.serie       = nota-fiscal.serie
          and fat-repre.nr-fatura    = nota-fiscal.nr-fatura
              no-lock :
              
      find first repres 
           where repres.nome-abrev = fat-repre.nome-ab-rep
                 no-lock no-error.
      create tt-repres.
      assign tt-repres.i-repres = repres.cod-rep
             tt-repres.c-abrev  = fat-repre.nome-ab-rep
             tt-repres.de-perc  = fat-repre.perc-comis 
             tt-repres.de-fat   = fat-repre.comis-emis
             tt-repres.ri-rowid = rowid(fat-repre)         
             i-cont             = i-cont + 1
             tt-repres.nro      = i-cont.
      
    end.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-refrescar B-table-Win 
PROCEDURE local-refrescar :
/*------------------------------------------------------------------------------
  Purpose:     Enable and disable inclui/modif/eliminar buttons
  Notes:       
------------------------------------------------------------------------------*/
/*
 
  if l-editing then
  /* editing, disable buttons */
  do:
    assign bt-incluir:sensitive in frame {&frame-name} = no.    
    assign bt-modificar:sensitive in frame {&frame-name} = no.    
    assign bt-eliminar:sensitive in frame {&frame-name} = no.    
    l-editing = no.
  end.
  else
  /* viewing, enable buttons */
  do:
    assign bt-incluir:sensitive in frame {&frame-name} = yes.    
    assign bt-modificar:sensitive in frame {&frame-name} = yes.    
    assign bt-eliminar:sensitive in frame {&frame-name} = yes.    
    l-editing = yes.
    FOR EACH TT-repres exclusive-lock:
      DELETE TT-repres.
    END.
    
    find repres 
         where repres.nome-abrev = nota-fiscal.no-ab-reppri 
               no-lock no-error.
    create tt-repres.
    assign tt-repres.i-repres = repres.cod-rep
           tt-repres.c-abrev  = repres.nome-abrev
           tt-repres.de-perc  = repres.comis-direta 
           tt-repres.de-fat   = repres.comis-emis
           tt-repres.ri-rowid = rowid(repres)         
           tt-repres.nro      = 1
           i-rep-ind          = repres.rep-indireto
           i-cont             = 2. 
  
    do while repres.rep-indireto <> 0:
      find repres 
           where repres.cod-rep = i-rep-ind 
                 no-lock no-error.
  
      if not available repres then leave.
  
      find tt-repres 
           where ri-rowid = rowid(repres) 
                 no-lock no-error.
           
      if available tt-repres then leave.
      
      create tt-repres.
      assign tt-repres.i-repres = repres.cod-rep 
             tt-repres.c-abrev  = repres.nome-abrev
             tt-repres.de-perc  = repres.comis-indir
             tt-repres.de-fat   = repres.comis-emis
             tt-repres.ri-rowid = rowid(repres)
             tt-repres.nro      = i-cont
             i-cont             = i-cont + 1          
             i-rep-ind          = repres.rep-indireto.
      
    end.    
    
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).    
  end.
  

/*  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'refrescar':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */

*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-view B-table-Win 
PROCEDURE local-view :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'view':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  apply 'value-changed':U to {&browse-name} in frame {&frame-name}.

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartBrowser, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-add-browse B-table-Win 
PROCEDURE pi-add-browse :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  def input parameter rw-row-1 as rowid no-undo.
  def input parameter rw-row-2 as rowid no-undo.
    
/*

  find <tabela-1> where rowid(<tabela-1>) = rw-row-1 no-lock no-error.
  find <tabela-2> where rowid(<tabela-2>) = rw-row-2 no-lock no-error.
  find <tabela-formacao> where <tabela-formacao>.<campo-1> = <tabela-1>.<campo-1> and
                               <tabela-formacao>.<campo-2> = <tabela-2>.<campo-2> no-lock no-error.
  if not avail <tabela-formacao> then do:  
    create <tabela-formacao>.
    assign <tabela-formacao>.<campo-1> = <tabela-1>.<campo-1>
           <tabela-formacao>.<campo-2> = <tabela-2>.<campo-2>.
  end.

*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-begin-edit B-table-Win 
PROCEDURE pi-begin-edit :
/*------------------------------------------------------------------------------
  Purpose: Enable Browse item edition.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    assign bt-incluir:sensitive in frame {&frame-name} = yes.    
    assign bt-modificar:sensitive in frame {&frame-name} = yes.    
    assign bt-eliminar:sensitive in frame {&frame-name} = yes.    
    l-editing = yes.
    FOR EACH TT-repres exclusive-lock:
      DELETE TT-repres.
    END.
    
    find repres 
         where repres.nome-abrev = nota-fiscal.no-ab-reppri 
               no-lock no-error.
    create tt-repres.
    assign tt-repres.i-repres = repres.cod-rep
           tt-repres.c-abrev  = repres.nome-abrev
           tt-repres.de-perc  = repres.comis-direta 
           tt-repres.de-fat   = repres.comis-emis
           tt-repres.ri-rowid = rowid(repres)         
           tt-repres.nro      = 1
           i-rep-ind          = repres.rep-indireto
           i-cont             = 2. 
  
    do while repres.rep-indireto <> 0:
      find repres 
           where repres.cod-rep = i-rep-ind 
                 no-lock no-error.
  
      if not available repres then leave.
  
      find tt-repres 
           where ri-rowid = rowid(repres) 
                 no-lock no-error.
           
      if available tt-repres then leave.
      
      create tt-repres.
      assign tt-repres.i-repres = repres.cod-rep 
             tt-repres.c-abrev  = repres.nome-abrev
             tt-repres.de-perc  = repres.comis-indir
             tt-repres.de-fat   = repres.comis-emis
             tt-repres.ri-rowid = rowid(repres)
             tt-repres.nro      = i-cont
             i-cont             = i-cont + 1          
             i-rep-ind          = repres.rep-indireto.
      
    end.    
    
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-end-edit B-table-Win 
PROCEDURE pi-end-edit :
/*------------------------------------------------------------------------------
  Purpose: Disable browse ïs buttons.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
    assign bt-incluir:sensitive in frame {&frame-name} = no.    
    assign bt-modificar:sensitive in frame {&frame-name} = no.    
    assign bt-eliminar:sensitive in frame {&frame-name} = no.    
    l-editing = no.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate B-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   return "adm-error".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
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
      {src/adm/template/bstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



