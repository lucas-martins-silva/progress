&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
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
{include/i-prgvrs.i V27IN245 2.00.00.028}  /*** 010028 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V27IN245 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def new global shared var l-gera-dup as logical init no. 
def var v-row-parent    as rowid   no-undo.
def var l-entfut        as logical no-undo.
def var l-novo-reg      as logical initial no.
def var l-setou-campo   as logical no-undo.
def var l-emite-duplic  as logical no-undo.
def var l-ind-contabil  as logical no-undo.
def var c-destino-icm   as char    no-undo.
def var i-destino-icm   as integer no-undo.    
def var c-tipo          as char    no-undo.
def var l-terceiros     as logical no-undo.
def var l-transf        as logical no-undo.
def var c-trib-ipi      as char    no-undo.
def var l-atu-ce        as logical no-undo.
def var l-remito        as logical no-undo.
def var l-prevcr        as logical no-undo.
def var h_v25in245      as handle  no-undo.

{cdp/cd4300.i3}              /* Definicao var para o cd4300.i4  */
{cdp/cd0604.i50}             /* Definicao var para o cd0604.i51 */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES natur-oper
&Scoped-define FIRST-EXTERNAL-TABLE natur-oper


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR natur-oper.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS natur-oper.calc-auto natur-oper.atual-estat ~
natur-oper.auto-est natur-oper.baixa-estoq natur-oper.auto-ce ~
natur-oper.ind-gera-of natur-oper.emite-duplic natur-oper.auto-cr ~
natur-oper.ind-contabilizacao natur-oper.auto-ct natur-oper.ind-entfut ~
natur-oper.ind-est-qtd 
&Scoped-define FIELD-PAIRS
&Scoped-define ENABLED-TABLES natur-oper
&Scoped-define FIRST-ENABLED-TABLE natur-oper
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 rs-ent-fut 
&Scoped-Define DISPLAYED-FIELDS natur-oper.calc-auto natur-oper.atual-estat ~
natur-oper.auto-est natur-oper.baixa-estoq natur-oper.auto-ce ~
natur-oper.ind-gera-of natur-oper.emite-duplic natur-oper.auto-cr ~
natur-oper.ind-contabilizacao natur-oper.auto-ct natur-oper.ind-entfut ~
natur-oper.ind-est-qtd 
&Scoped-Define DISPLAYED-OBJECTS tb-sc-transven tg-atu-cota rs-ent-fut 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS tb-sc-transven 
&Scoped-define ADM-ASSIGN-FIELDS tb-sc-transven 
&Scoped-define ADM-MODIFY-FIELDS tb-sc-transven 

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
DEFINE VARIABLE rs-ent-fut AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Entrega Futura", 0,
"Faturamento Antecipado", 1
     SIZE 24.86 BY 1.71 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 29.86 BY 6.71.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 36.43 BY 6.71.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 66.72 BY 2.33.

DEFINE VARIABLE tb-sc-transven AS LOGICAL INITIAL no 
     LABEL "Imprime NF Auto" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83 NO-UNDO.

DEFINE VARIABLE tg-atu-cota AS LOGICAL INITIAL no 
     LABEL "Atualiza Cotas" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     natur-oper.calc-auto AT ROW 1.38 COL 2.43
          VIEW-AS TOGGLE-BOX
          SIZE 23.43 BY .83
     natur-oper.atual-estat AT ROW 1.38 COL 33.14
          VIEW-AS TOGGLE-BOX
          SIZE 23.57 BY .83
     tb-sc-transven AT ROW 2.13 COL 2.43
     natur-oper.auto-est AT ROW 2.13 COL 33.14
          VIEW-AS TOGGLE-BOX
          SIZE 21.29 BY .83
     natur-oper.baixa-estoq AT ROW 2.88 COL 2.43
          VIEW-AS TOGGLE-BOX
          SIZE 27 BY .83
     tg-atu-cota AT ROW 2.88 COL 33.14
     natur-oper.auto-ce AT ROW 3.63 COL 2.43
          VIEW-AS TOGGLE-BOX
          SIZE 18.57 BY .83
     natur-oper.ind-gera-of AT ROW 3.63 COL 33.14
          VIEW-AS TOGGLE-BOX
          SIZE 25.14 BY .83
     natur-oper.emite-duplic AT ROW 4.38 COL 2.43
          VIEW-AS TOGGLE-BOX
          SIZE 20.14 BY .83
     natur-oper.auto-cr AT ROW 5.13 COL 2.43
          VIEW-AS TOGGLE-BOX
          SIZE 18.72 BY .83
     natur-oper.ind-contabilizacao AT ROW 5.88 COL 2.43
          VIEW-AS TOGGLE-BOX
          SIZE 24.57 BY .83
     natur-oper.auto-ct AT ROW 6.63 COL 2.43
          VIEW-AS TOGGLE-BOX
          SIZE 18.43 BY .83
     rs-ent-fut AT ROW 8.13 COL 2.43 NO-LABEL
     natur-oper.ind-entfut AT ROW 8.21 COL 33.14
          VIEW-AS TOGGLE-BOX
          SIZE 25.14 BY .83
     natur-oper.ind-est-qtd AT ROW 8.96 COL 33.14
          VIEW-AS TOGGLE-BOX
          SIZE 30.43 BY .83
     RECT-1 AT ROW 1 COL 1
     RECT-2 AT ROW 1 COL 31.14
     RECT-3 AT ROW 7.83 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.natur-oper
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
         HEIGHT             = 9.17
         WIDTH              = 66.86.
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

/* SETTINGS FOR TOGGLE-BOX tb-sc-transven IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR TOGGLE-BOX tg-atu-cota IN FRAME f-main
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

&Scoped-define SELF-NAME natur-oper.atual-estat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.atual-estat V-table-Win
ON VALUE-CHANGED OF natur-oper.atual-estat IN FRAME f-main /* Atualiza Estat°stica */
DO:
    /*
    if natur-oper.atual-estat:checked in frame {&frame-name} then 
        assign natur-oper.auto-est:sensitive in frame {&frame-name} = yes.
    else do:
        assign natur-oper.auto-est:sensitive in frame {&frame-name} = no.
        assign natur-oper.auto-est:checked in frame {&frame-name} = no.          
    end. 
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.baixa-estoq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.baixa-estoq V-table-Win
ON VALUE-CHANGED OF natur-oper.baixa-estoq IN FRAME f-main /* Baixa Estoque */
DO:

    if  valid-handle(h_v25in245) 
    and rs-ent-fut:screen-value in frame {&frame-name} = "0"   /* Entrega Futura */
    and natur-oper.ind-entfut:checked in frame {&frame-name}   /* Nota Remessa */    
    then
        run pi-habilita-campos in h_v25in245 
                                ( "nat-comp",                                               /* Natureza Comp. */
                                  if  natur-oper.baixa-estoq:checked in frame {&frame-name} /* Baixa Estoque */
                                  then yes                                                  /* Habilita */
                                  else no ).                                                /* N∆o Habilita */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.emite-duplic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.emite-duplic V-table-Win
ON VALUE-CHANGED OF natur-oper.emite-duplic IN FRAME f-main /* Gera Duplicatas */
DO:
    /*
    if natur-oper.emite-duplic:checked in frame {&frame-name} then
        assign natur-oper.auto-cr:sensitive in frame {&frame-name} = yes.
    else do:
        assign natur-oper.auto-cr:sensitive in frame {&frame-name} = no.
        assign natur-oper.auto-cr:checked in frame {&frame-name} = no.
    end.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.ind-contabilizacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.ind-contabilizacao V-table-Win
ON VALUE-CHANGED OF natur-oper.ind-contabilizacao IN FRAME f-main /* Gera Contabilizaá∆o */
DO:
    /*
    if natur-oper.ind-contabilizacao:checked in frame {&frame-name} then
        assign natur-oper.auto-ct:sensitive in frame {&frame-name} = yes.
    else do:
        assign natur-oper.auto-ct:sensitive in frame {&frame-name} = no.
        assign natur-oper.auto-ct:checked in frame {&frame-name} = no.
    end.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.ind-entfut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.ind-entfut V-table-Win
ON VALUE-CHANGED OF natur-oper.ind-entfut IN FRAME f-main /* Entrega Futura */
DO:

    assign natur-oper.ind-est-qtd:sensitive in frame {&frame-name} =
           if natur-oper.ind-entfut:checked in frame {&frame-name} 
           then no
           else yes.
  
    if  valid-handle(h_v25in245) then
        run pi-habilita-campos in h_v25in245 
                               ( "nat-comp",                                               /* Natureza Comp. */
                                 if  rs-ent-fut:screen-value in frame {&frame-name} = "0"  /* Entrega Futura */
                                 and natur-oper.ind-entfut:checked in frame {&frame-name}  /* Nota Remessa */
                                 and natur-oper.baixa-estoq:checked in frame {&frame-name} /* Baixa Estoque */
                                 then yes                                                  /* Habilita */
                                 else no ).                                                /* N∆o Habilita */
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.ind-est-qtd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.ind-est-qtd V-table-Win
ON VALUE-CHANGED OF natur-oper.ind-est-qtd IN FRAME f-main /* Atualiza Estat Quantidade */
DO:
    assign natur-oper.ind-entfut:sensitive in frame {&frame-name} =
           if natur-oper.ind-est-qtd:checked in frame {&frame-name} 
           then no
           else yes.                    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-ent-fut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-ent-fut V-table-Win
ON VALUE-CHANGED OF rs-ent-fut IN FRAME f-main
DO:
  
    if  valid-handle(h_v25in245) then
        run pi-habilita-campos in h_v25in245 
                               ( "nat-comp",                                               /* Natureza Comp. */
                                 if  rs-ent-fut:screen-value in frame {&frame-name} = "0"  /* Entrega Futura */
                                 and natur-oper.ind-entfut:checked in frame {&frame-name}  /* Nota Remessa */
                                 and natur-oper.baixa-estoq:checked in frame {&frame-name} /* Baixa Estoque */
                                 then yes                                                  /* Habilita */
                                 else no ).                                                /* N∆o Habilita */  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/****************************  Main Block  ***************************/

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  {utp/ut-liter.i Imprime_NF_Auto * L}
  assign tb-sc-transven:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Atualiza_Cotas * L}
  assign tg-atu-cota:label in frame {&frame-name} = trim(return-value).
 
  {utp/ut-liter.i Nota_de_Faturamento * L}
  assign natur-oper.ind-entfut:label in frame {&frame-name} = trim(return-value).
 
  {utp/ut-liter.i Indica * R}
  assign natur-oper.ind-entfut:help in frame {&frame-name} = trim(return-value) + " " + 
                                                             natur-oper.ind-entfut:label in frame {&frame-name}.

  {utp/ut-liter.i Nota_de_Remessa * L}
  assign natur-oper.ind-est-qtd:label in frame {&frame-name} = trim(return-value).
 
  {utp/ut-liter.i Indica * R}
  assign natur-oper.ind-est-qtd:help in frame {&frame-name} = trim(return-value) + " " + 
                                                              natur-oper.ind-est-qtd:label in frame {&frame-name}.

  {utp/ut-liter.i Atualiza_Estoque * R}
  assign natur-oper.baixa-estoq:label in frame {&frame-name} = trim(return-value).

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
  {src/adm/template/row-list.i "natur-oper"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "natur-oper"}

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  assign tg-atu-cota:sensitive in frame {&frame-name} = if param-global.modulo-08 then yes else no.
  if not param-global.modulo-ce
     or l-entfut 
     or {ininc/i06in245.i 06 c-tipo} = 2 then
      assign natur-oper.baixa-estoq:checked in frame {&frame-name} = no.
  if {ininc/i06in245.i 06 c-tipo} = 1 then                    
      assign natur-oper.baixa-estoq:checked in frame {&frame-name} = yes.

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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if return-value = 'ADM-ERROR':U then
     return 'ADM-ERROR':U.
  
  if param-global.modulo-08 then do:
  
    assign l-atu-cota = tg-atu-cota:checked in frame {&frame-name}
           substr(natur-oper.char-2,31,5) = 
                  if l-atu-cota then "1    " else "2    ".
  end.

if avail natur-oper then  
    assign substr(natur-oper.char-1,1,5) =
    if rs-ent-fut:screen-value in frame {&FRAME-NAME} = "1"
    then "1    "
    else "0    ".

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .


  /*  Imprime nota fiscal auto  */
  if input frame {&frame-name} tb-sc-transven = yes then do:
     assign natur-oper.sc-transven = '1'. /* imprime auto */
  end.
  if input frame {&frame-name} tb-sc-transven = no then do:
     assign natur-oper.sc-transven = '0'. /* n∆o imprime auto */
  end.
  /*  Fim Imprime nota fiscal auto  */

  assign substr(natur-oper.char-1,1,5) =
  if rs-ent-fut:screen-value in frame {&FRAME-NAME} = "1"
  then "1    "
  else "0    ".

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

    assign l-novo-reg = no
           l-setou-campo = no.
           
    assign natur-oper.auto-ce:sensitive  in frame {&frame-name} = no.       

    assign rs-ent-fut:sensitive in frame {&frame-name} = no.


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
  
  if  avail natur-oper then do:
      if  natur-oper.ind-gera-of = yes then
          assign natur-oper.ind-gera-of:checked in frame {&frame-name} = yes.
      if  natur-oper.ind-entfut = yes then
          assign natur-oper.ind-entfut:checked in frame {&frame-name} = yes.
      if  natur-oper.ind-est-qtd = yes then
          assign natur-oper.ind-est-qtd:checked in frame {&frame-name} = yes.        

      find first param-global no-lock no-error.
      if  avail param-global and param-global.modulo-08 then do:
          assign l-atu-cota = if substr(natur-oper.char-2,31,5) <> ""
                 then int(substr(natur-oper.char-2,31,5)) = 1
                 else no.
          assign tg-atu-cota:checked in frame {&frame-name}   = l-atu-cota
                 tg-atu-cota:sensitive in frame {&FRAME-NAME} = no.               
      end.
    
      assign natur-oper.auto-ce:sensitive in frame {&frame-name} = no.
      if  adm-new-record then
          assign natur-oper.auto-ce:checked in frame {&frame-name} = no.

      assign rs-ent-fut:sensitive    in frame {&frame-name} = no
             rs-ent-fut:screen-value in frame {&frame-name} = substr(natur-oper.char-1,1,5).
   
      /* Imprime nota fiscal auto */
      if  natur-oper.sc-transven = '1' then 
          assign  tb-sc-transven:checked in frame {&frame-name} = yes
                  tb-sc-transven.
      if  natur-oper.sc-transven = '0' or
          natur-oper.sc-transven = ''  then
          assign  tb-sc-transven:checked in frame {&frame-name}  = no
                  tb-sc-transven.
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

  /* Code placed here will execute PRIOR to standard behavior. */
  /* Dispatch standard ADM method.                             */
   run get-attribute('adm-new-record').

  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  
  /*if adm-new-record = yes then*/
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  assign tg-atu-cota:sensitive in frame {&frame-name} = if param-global.modulo-08 
                                                        then yes 
                                                        else no.
  run get-attribute('adm-new-record').

/*  if not adm-new-record then do:
     if natur-oper.baixa-estoq:checked in frame {&frame-name} = yes
        then assign natur-oper.auto-ce:sensitive    in frame {&frame-name} = yes.
        else assign natur-oper.auto-ce:sensitive    in frame {&frame-name} = no.

     if natur-oper.emite-duplic:checked in frame {&frame-name} = yes
        then assign natur-oper.auto-cr:sensitive in frame {&frame-name} = yes.
        else assign natur-oper.auto-cr:sensitive in frame {&frame-name} = no.
        
     if natur-oper.ind-contabilizacao:checked in frame {&frame-name} = yes
        then assign natur-oper.auto-ct:sensitive in frame {&frame-name} = yes.
        else assign natur-oper.auto-ct:sensitive in frame {&frame-name} = no.        

     assign tg-atu-cota:sensitive in frame {&frame-name} = if param-global.modulo-08 then yes else no.
  end.
  else assign natur-oper.auto-ce:sensitive     in frame {&frame-name} = no
              natur-oper.auto-cr:sensitive     in frame {&frame-name} = no
              natur-oper.auto-ct:sensitive     in frame {&frame-name} = no
              natur-oper.auto-ce:checked       in frame {&frame-name} = no.*/

  assign l-novo-reg = yes.
  run pi-inicializa-campo (yes).

  assign rs-ent-fut:sensitive in frame {&frame-name} = yes.
  
  if  valid-handle(h_v25in245) then
      run pi-habilita-campos in h_v25in245 
                            ( "nat-comp",                                               /* Natureza Comp. */
                              if  not adm-new-record                                    /* N∆o Ç Inclus∆o */
                              and rs-ent-fut:screen-value in frame {&frame-name} = "0"  /* Entrega Futura */
                              and natur-oper.ind-entfut:checked in frame {&frame-name}  /* Nota Remessa */
                              and natur-oper.baixa-estoq:checked in frame {&frame-name} /* Baixa Estoque */
                              then yes                                                  /* Habilita */
                              else no ).                                                /* N∆o Habilita */
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
  
  find first param-global no-lock no-error.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-handle V-table-Win 
PROCEDURE pi-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter h-handle as handle no-undo.

    assign h_v25in245 = h-handle.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-campo V-table-Win 
PROCEDURE pi-inicializa-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter p-seta-campo as logical no-undo.

    if  l-novo-reg then do:
        RUN Get-Field-Screen-Value IN adm-broker-hdl
            (INPUT THIS-PROCEDURE, INPUT "tipo":U).
        assign c-tipo = return-value.

        assign natur-oper.atual-estat:sensitive in frame {&frame-name} = if param-global.modulo-ft 
                                                                            then yes
                                                                            else no.

        RUN Get-Field-Screen-Value IN adm-broker-hdl
            (INPUT THIS-PROCEDURE, INPUT "tipo":U).
            assign c-tipo         = return-value.

        RUN Get-Field-Screen-Value IN adm-broker-hdl
            (INPUT THIS-PROCEDURE, INPUT "terceiros":U).
            assign l-terceiros    = return-value = "yes".

        RUN Get-Field-Screen-Value IN adm-broker-hdl
            (INPUT THIS-PROCEDURE, INPUT "transf":U).
            assign l-transf       = return-value = "yes".

        if  avail natur-oper then
            if natur-oper.ind-est-qtd and
               natur-oper.ind-entfut then do with frame {&frame-name}:
               assign natur-oper.ind-est-qtd:checked = no
                      natur-oper.ind-entfut:checked  = no.
            end.
        
        assign natur-oper.ind-est-qtd:sensitive in frame {&frame-name} =
               not natur-oper.ind-entfut:checked in frame {&frame-name}.
        assign natur-oper.ind-entfut:sensitive in frame {&frame-name} =
               not natur-oper.ind-est-qtd:checked in frame {&frame-name}.
        
        /*       
        assign natur-oper.auto-ce:sensitive in frame {&frame-name} = 
               if  natur-oper.baixa-estoq:checked in frame {&frame-name}
                   then yes
                   else no.       

        if  natur-oper.baixa-estoq:checked in frame {&frame-name} = no then
            assign natur-oper.auto-ce:checked in frame {&frame-name} = no.
       
        assign natur-oper.auto-cr:sensitive in frame {&frame-name} =
               if  natur-oper.emite-duplic:checked in frame {&frame-name}
                   then yes
                   else no.

        if  natur-oper.emite-duplic:checked in frame {&frame-name} = no then
            assign natur-oper.auto-cr:checked in frame {&frame-name} = no.

        assign natur-oper.auto-ct:sensitive in frame {&frame-name} =
               if  natur-oper.ind-contabilizacao:checked in frame {&frame-name}
                   then yes
                   else no.

        if  natur-oper.ind-contabilizacao:checked in frame {&frame-name} = no then
            assign natur-oper.auto-cr:checked in frame {&frame-name} = no.        

        assign natur-oper.auto-est:sensitive in frame {&frame-name} =
               if  natur-oper.atual-estat:checked in frame {&frame-name} 
                   then yes
                   else no.

        if  natur-oper.atual-estat:checked in frame {&frame-name} = no then
            assign natur-oper.auto-est:checked in frame {&frame-name} = no.      
        */      

    end.

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
  {src/adm/template/snd-list.i "natur-oper"}

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


