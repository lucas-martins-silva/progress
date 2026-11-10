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
{include/i-prgvrs.i V02AD009 2.00.00.028 } /*** 010028 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02AD009 MUT}
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

/*def buffer b-agencia for agencia.*/

/*************Multiplanta********************/

def var i-tipo-movto    as integer no-undo.
def var l-cria          as logical initial no no-undo.
def var c-aux           as character no-undo.
def var l-control-spell as logical no-undo init no.
define var l-funcionou  as logical no-undo initial no.
def var c-formato       as char no-undo.
DEF VAR l-func-alt-car-rem AS LOG NO-UNDO.
DEF VAR c-razao-social  AS CHAR FORMAT "x(40)" NO-UNDO.
DEF VAR c-estado        AS CHAR FORMAT "x(20)" NO-UNDO.
DEF VAR c-cod-postal    AS CHAR FORMAT "x(12)" NO-UNDO.
DEF VAR c-contato       AS CHAR FORMAT "x(25)" NO-UNDO.
DEF VAR c-swift         AS CHAR FORMAT "x(20)" NO-UNDO.
DEF VAR c-cta-corren    AS CHAR FORMAT "x(20)" NO-UNDO.

def var c-cep1          as char no-undo.


/******  BANCOS HIST‡RICOS ******/
{bhp/bh9999.i1}
{cdp/cd1000.i}
/********************************/

{cdp/cd7300.i1}
{cdp/cdapi221.i}

{include/i_dbvers.i}
{cdp/cdcfgfin.i} /* Definiá∆o de Funá‰es */
{include/i-freeac.i}
/*-------------- Integraá∆o Magnus I.01 x EMS 2.04 -------------*/
def var i-ind-tipo-movto as inte no-undo.
def var c-valor-chave-mg as char no-undo.

{cdp/cd1102i1.i} /* Definiá∆o da temp-table tt-agencia-mg */
{cdp/cd0001i1.i} /* Definiá∆o da temp-table de erros tt-erro-mg */
/****************************************************************/

/************Fim*****************************/

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
&Scoped-define EXTERNAL-TABLES agencia
&Scoped-define FIRST-EXTERNAL-TABLE agencia


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR agencia.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS agencia.nome agencia.sufixo agencia.endereco ~
agencia.cidade agencia.uf agencia.tipo agencia.pais agencia.telefone ~
agencia.e-mail agencia.observacao 
&Scoped-define ENABLED-TABLES agencia
&Scoped-define FIRST-ENABLED-TABLE agencia
&Scoped-define DISPLAYED-TABLES agencia
&Scoped-define FIRST-DISPLAYED-TABLE agencia
&Scoped-Define ENABLED-OBJECTS l-canal-bancario bt-informacoes im-banco ~
RECT-9 rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS agencia.cod-banco agencia.agencia ~
agencia.nome agencia.sufixo agencia.endereco agencia.cidade agencia.uf ~
agencia.tipo agencia.pais agencia.telefone agencia.e-mail ~
agencia.observacao 
&Scoped-Define DISPLAYED-OBJECTS c-nome-banco l-canal-bancario c-cep ~
fill-in-1 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS agencia.cod-banco agencia.agencia 
&Scoped-define ADM-ASSIGN-FIELDS c-nome-banco agencia.nome 
&Scoped-define ADM-MODIFY-FIELDS c-cep bt-spell 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
cod-banco||y|mgadm.agencia.cod-banco
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "cod-banco"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnc-cep V-table-Win 
FUNCTION fnc-cep RETURNS CHARACTER
  ( i-cep as int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-informacoes 
     LABEL "Informaá‰es" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-spell 
     LABEL "" 
     SIZE 4 BY 1.25.

DEFINE VARIABLE c-cep AS CHARACTER FORMAT "X(12)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-banco AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE fill-in-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67.

DEFINE IMAGE im-banco
     SIZE 10.72 BY 3.33.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 22.72 BY 3.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 2.33.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 12.5.

DEFINE VARIABLE l-canal-bancario AS LOGICAL INITIAL no 
     LABEL "Canal Banc†rio" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     agencia.cod-banco AT ROW 1.38 COL 18.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     c-nome-banco AT ROW 1.38 COL 23.72 COLON-ALIGNED NO-LABEL
     agencia.agencia AT ROW 2.38 COL 18.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     agencia.nome AT ROW 3.71 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     l-canal-bancario AT ROW 3.75 COL 40
     bt-informacoes AT ROW 3.75 COL 58
     agencia.sufixo AT ROW 4.71 COL 18.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.43 BY .88
     agencia.endereco AT ROW 5.71 COL 18.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.43 BY .88
     agencia.cidade AT ROW 6.71 COL 18.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.43 BY .88
     agencia.uf AT ROW 7.71 COL 18.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     agencia.tipo AT ROW 8.5 COL 66.43 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Propria", 1,
"Correspondente", 2
          SIZE 18.86 BY 2
     c-cep AT ROW 8.71 COL 18.86 COLON-ALIGNED
     agencia.pais AT ROW 9.71 COL 18.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .88
     agencia.telefone AT ROW 10.71 COL 18.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     agencia.e-mail AT ROW 11.71 COL 18.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 46 BY .88
     agencia.observacao AT ROW 12.75 COL 11.72 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 67 BY 3.08
     bt-spell AT ROW 12.75 COL 79 HELP
          "Corretor Ortogr†fico"
     fill-in-1 AT ROW 7.63 COL 64 COLON-ALIGNED NO-LABEL
     im-banco AT ROW 3.83 COL 85.86 RIGHT-ALIGNED
     RECT-9 AT ROW 7.88 COL 64.29
     rt-key AT ROW 1.13 COL 1
     rt-mold AT ROW 3.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.agencia
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
         HEIGHT             = 15.08
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

/* SETTINGS FOR FILL-IN agencia.agencia IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR BUTTON bt-spell IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN c-cep IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN c-nome-banco IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN agencia.cod-banco IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fill-in-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR IMAGE im-banco IN FRAME f-main
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN agencia.nome IN FRAME f-main
   2                                                                    */
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

&Scoped-define SELF-NAME bt-informacoes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-informacoes V-table-Win
ON CHOOSE OF bt-informacoes IN FRAME f-main /* Informaá‰es */
DO:

  RUN cdp/cd1102a.w (INPUT-OUTPUT c-razao-social,
                     INPUT-OUTPUT c-estado,
                     INPUT-OUTPUT c-cod-postal,
                     INPUT-OUTPUT c-contato,
                     INPUT-OUTPUT c-swift,
                     INPUT-OUTPUT c-cta-corren).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cep V-table-Win
ON ENTRY OF c-cep IN FRAME f-main
DO:
  if c-formato <> "" then
     assign c-cep:format in frame {&frame-name} = c-formato.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cep V-table-Win
ON LEAVE OF c-cep IN FRAME f-main
DO:
  {cdp/cd9998.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME agencia.cod-banco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL agencia.cod-banco V-table-Win
ON F5 OF agencia.cod-banco IN FRAME f-main /* Banco */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom="adzoom/z01ad018.w"
                  &tabela=agencia
                  &atributo=cod-banco}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL agencia.cod-banco V-table-Win
ON LEAVE OF agencia.cod-banco IN FRAME f-main /* Banco */
DO:  
  {include/leave.i &tabela=banco
                   &atributo-ref=nome-banco
                   &variavel-ref=c-nome-banco
                   &where="banco.cod-banco = input frame {&frame-name} agencia.cod-banco"} 

  find first banco where 
      banco.cod-banco = input frame {&FRAME-NAME} agencia.cod-banco no-lock no-error.
  if avail banco then do:    
     assign im-banco:hidden in frame {&frame-name} = no.
     if  im-banco:load-image("") in frame {&frame-name} then.
         if  banco.cod-imagem <> "" then do:
             find imagem no-lock where
                  imagem.cod_imagem = banco.cod-imagem no-error.
             if  avail imagem then do:
                 find catal_img of imagem no-lock no-error.
                 if  avail catal_img then do:
                     if search(string(catal_img.cod_path_catal + "\" + imagem.img_imagem)) <> ? then
                        if im-banco:load-image(string(catal_img.cod_path_catal + "\" + imagem.img_imagem)) in frame {&frame-name} then.
                 end.
             end.
         end.
  end.       
  else assign im-banco:hidden in frame {&frame-name} = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL agencia.cod-banco V-table-Win
ON MOUSE-SELECT-DBLCLICK OF agencia.cod-banco IN FRAME f-main /* Banco */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-canal-bancario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-canal-bancario V-table-Win
ON VALUE-CHANGED OF l-canal-bancario IN FRAME f-main /* Canal Banc†rio */
DO:
  IF INPUT FRAME {&frame-name} l-canal-bancario THEN
      ASSIGN bt-informacoes:SENSITIVE IN FRAME {&frame-name} = YES.
  ELSE 
      ASSIGN bt-informacoes:SENSITIVE IN FRAME {&frame-name} = NO
             c-razao-social                                  = ""
             c-estado                                        = ""
             c-cod-postal                                    = ""
             c-contato                                       = ""
             c-swift                                         = ""
             c-cta-corren                                    = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME agencia.pais
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL agencia.pais V-table-Win
ON F5 OF agencia.pais IN FRAME f-main /* Pa°s */
DO:
   assign l-implanta = yes. 
   {include/zoomvar.i &prog-zoom="unzoom/z01un006.w"
                      &campo=agencia.pais
                      &campozoom=nome-pais}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL agencia.pais V-table-Win
ON MOUSE-SELECT-DBLCLICK OF agencia.pais IN FRAME f-main /* Pa°s */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME agencia.uf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL agencia.uf V-table-Win
ON F5 OF agencia.uf IN FRAME f-main /* UF */
DO:

   assign l-implanta = yes.
   {include/zoomvar.i &prog-zoom="unzoom/z01un007.w"
                     &campo=agencia.uf
                     &campozoom=estado}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL agencia.uf V-table-Win
ON MOUSE-SELECT-DBLCLICK OF agencia.uf IN FRAME f-main /* UF */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  {include/GetDefinedFunction.i}
  /* Verificar se funØ o especial estò habilitada */
  assign l-func-alt-car-rem = &if defined(BF_FIN_ALTERA_CARTA_REM) &then yes &else GetDefinedFunction("SPP-ALT-CAR-REM") &endif.  

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  {btb/btb008za.i0} /* Integraá∆o EMS 2.04 Financeiro x Magnus I.01 */

  /************************ INTERNAL PROCEDURES ********************/

  {utp/ut-field.i mgadm agencia cep 1}.
  assign c-cep:label in frame {&FRAME-NAME} = return-value.

  if  agencia.cod-banco:load-mouse-pointer ("image\lupa.cur") then.
  if  agencia.uf:load-mouse-pointer ("image\lupa.cur") then.
  if  agencia.pais:load-mouse-pointer ("image\lupa.cur") then.

  {include/i-spell.i "mgadm.agencia.observacao" "bt-spell"}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win  adm/support/_key-fnd.p
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
  {src/adm/template/row-list.i "agencia"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "agencia"}

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

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  if l-func-alt-car-rem then
      assign c-razao-social = ""
             c-estado       = ""
             c-cod-postal   = ""
             c-contato      = ""
             c-swift        = ""
             c-cta-corren   = ""
             l-canal-bancario:screen-value in frame {&frame-name} = "no"
             bt-informacoes:sensitive in frame {&frame-name}      = no.
  apply 'leave' to agencia.cod-banco in frame {&frame-name}.

  {utp\ut-rtlbl.i mgadm agencia tipo fill-in-1}

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

    if adm-new-record then do:
       find agencia where agencia.cod-banco = input frame {&frame-name} agencia.cod-banco
            and agencia.agencia = input frame {&frame-name} agencia.agencia 
            no-lock no-error.
       if  avail agencia then do:
           run utp/ut-msgs.p (input "show",
                              input 6099,
                              input " ").
           RETURN 'ADM-ERROR'.
       end.
    end.

    assign c-cep1 = input frame {&FRAME-NAME} c-cep.

    run pi-validate.
    if return-value = "NOK" then return "ADM-ERROR".

    IF l-func-alt-car-rem THEN
        assign INPUT FRAME {&FRAME-NAME} l-canal-bancario.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

    if c-cep1 <> "" then
       assign agencia.cep = int(replace(replace(c-cep1,"-",""),".","")).

    IF l-func-alt-car-rem THEN DO:
        &if "{&mgadm_version}":U < "2.06":U &then
            if l-canal-bancario then
                ASSIGN agencia.log-1           = l-canal-bancario
                       ENTRY(1,agencia.char-1,";") = c-razao-social + ";"
                       ENTRY(2,agencia.char-1,";") = c-estado + ";"
                       ENTRY(3,agencia.char-1,";") = c-cod-postal + ";"
                       ENTRY(4,agencia.char-1,";") = c-contato + ";"
                       ENTRY(1,agencia.char-2,";") = c-swift + ";" 
                       ENTRY(2,agencia.char-2,";") = c-cta-corren + ";".
            else
                ASSIGN agencia.log-1           = l-canal-bancario
                       ENTRY(1,agencia.char-1,";") = "" + ";"
                       ENTRY(2,agencia.char-1,";") = "" + ";"
                       ENTRY(3,agencia.char-1,";") = "" + ";"
                       ENTRY(4,agencia.char-1,";") = "" + ";"
                       ENTRY(1,agencia.char-2,";") = "" + ";" 
                       ENTRY(2,agencia.char-2,";") = "" + ";".
        &else
            if l-canal-bancario then
                ASSIGN agencia.log-estrangeiro = l-canal-bancario          
                       agencia.razao-social    = c-razao-social
                       agencia.nom-estado      = c-estado
                       agencia.codigo-postal   = c-cod-postal
                       agencia.contato         = c-contato
                       agencia.swift           = c-swift
                       agencia.cta-corrente    = c-cta-corren.
            else
                ASSIGN agencia.log-estrangeiro = l-canal-bancario          
                       agencia.razao-social    = ""
                       agencia.nom-estado      = ""
                       agencia.codigo-postal   = ""
                       agencia.contato         = ""
                       agencia.swift           = ""
                       agencia.cta-corrente    = "".
        &endif
    END.

    /* Integraá∆o EMS 2.04 Financeiro x Magnus I.01 */
    {cdp/cd0002i1.i agencia}

    /********************Multiplanta***********************/

     assign c-transacao = "ADM019".
    {cdp/cd7300.i5 "001" c-transacao}

    assign i-tipo-movto = if  agencia.cod-banco:sensitive in frame {&frame-name} = yes and
                              agencia.agencia:sensitive in frame {&frame-name} = yes
                              then 1 
                              else 2.
    run pi-cria-tt-dados (input i-tipo-movto).

    {cdp/cd7300.i6 "001" c-transacao}

    /******************Fim-Multiplanta********************/  

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

    /************ BANCOS HIST‡RICOS ************/
    if  not available(param-global) then
        find first param-global no-lock no-error.

    if  l-funcao-banc-hist-adm then do:
        {bhp/bh9999.i 1 agencia agencia.cod-banco agencia.agencia '' '' '' ''}
        if  return-value <> "OK" then
            return error.
    end.

    find first cta-corrente 
         where cta-corrente.cod-banco = agencia.cod-banco
         and   cta-corrente.agencia   = agencia.agencia 
         no-lock no-error.
    if avail cta-corrente then do:
         {utp/ut-table.i mgadm cta-corrente 1}
         assign c-aux = return-value.
         {utp/ut-table.i mgadm agencia 1} 
         run utp/ut-msgs.p (input "show",
                            input 5010,
                            input c-aux + '~~' + return-value).
         RETURN 'ADM-ERROR'.
    end.
    find first aplic-emprestimo
         where aplic-emprestimo.banco   = agencia.cod-banco
         and   aplic-emprestimo.agencia = agencia.agencia 
         no-lock no-error.
    if avail aplic-emprestimo then do:
         {utp/ut-table.i mgadm aplic-emprestimo 1}
         assign c-aux = return-value.
         {utp/ut-table.i mgadm agencia 1} 
         run utp/ut-msgs.p (input "show",
                            input 5010,
                            input c-aux + '~~' + return-value).
         RETURN 'ADM-ERROR'.
    end.

    /* Integraá∆o EMS 2.04 Financeiro x Magnus I.01 */
    {cdp/cd0002i1.i1 agencia "no"}

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
    if return-value = 'ADM-ERROR':U then
       return 'ADM-ERROR':U.

    /* Integraá∆o EMS 2.04 Financeiro x Magnus I.01 */
    {cdp/cd0002i1.i1 agencia "yes"}


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
  if l-func-alt-car-rem then
      assign l-canal-bancario:sensitive in frame {&frame-name} = no
             bt-informacoes:sensitive in frame {&frame-name}   = no.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  if c-formato <> "" then do:
     if avail agencia then 
        assign c-cep = fnc-cep(agencia.cep). 

     assign c-cep:format in frame {&frame-name} = c-formato.    
  end.      

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  IF l-func-alt-car-rem THEN DO:
      assign l-canal-bancario:sensitive in frame {&frame-name} = no
             bt-informacoes:sensitive in frame {&frame-name}   = no.
      if avail agencia then do:
          &if "{&mgadm_version}":U < "2.06" &then
              IF  agencia.char-1 <> ""
              and NUM-ENTRIES(agencia.char-1,";") > 3 THEN        
                  ASSIGN c-razao-social   = ENTRY(1,agencia.char-1,";")
                         c-estado         = ENTRY(2,agencia.char-1,";")
                         c-cod-postal     = ENTRY(3,agencia.char-1,";")
                         c-contato        = ENTRY(4,agencia.char-1,";").
              IF  agencia.char-2 <> "" 
              and NUM-ENTRIES(agencia.char-2,";") > 1 THEN
                  ASSIGN c-swift          = ENTRY(1,agencia.char-2,";")
                         c-cta-corren     = ENTRY(2,agencia.char-2,";").
              if agencia.log-1 then
                  ASSIGN l-canal-bancario:screen-value in frame {&frame-name} = "yes".
              else 
                  ASSIGN l-canal-bancario:screen-value in frame {&frame-name} = "no".
          &else
              assign c-razao-social   = agencia.razao-social
                     c-estado         = agencia.nom-estado  
                     c-cod-postal     = agencia.codigo-postal  
                     c-contato        = agencia.contato     
                     c-swift          = agencia.swift       
                     c-cta-corren     = agencia.cta-corrente.
              if agencia.log-estrangeiro then
                  ASSIGN l-canal-bancario:screen-value in frame {&frame-name} = "yes".
              else
                  ASSIGN l-canal-bancario:screen-value in frame {&frame-name} = "no".  
          &endif
      end.
      else 
          ASSIGN c-razao-social   = ""
                 c-estado         = ""
                 c-cod-postal     = ""
                 c-contato        = ""
                 c-swift          = "" 
                 c-cta-corren     = "".
  END.
  else
      ASSIGN l-canal-bancario:HIDDEN IN frame {&frame-name} = yes
             bt-informacoes:HIDDEN   IN frame {&frame-name} = yes. 

  if  avail agencia then do:
      find first banco where 
           banco.cod-banco = input frame {&FRAME-NAME} agencia.cod-banco no-lock no-error.
      if  avail banco then do:
          assign im-banco:hidden in frame {&frame-name} = no.
          assign c-nome-banco:screen-value in frame {&FRAME-NAME} = banco.nome-banco.
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
      else do:
          assign c-nome-banco:screen-value in frame {&FRAME-NAME} = "".
          assign im-banco:hidden in frame {&frame-name} = yes.
      end.    
  end.

  {utp\ut-rtlbl.i mgadm agencia tipo fill-in-1}
  {include/i-inispl.i "bt-spell"}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  if l-func-alt-car-rem then do:
      if avail agencia then do:
          assign l-canal-bancario:sensitive in frame {&frame-name} = yes.
          &if "{&mgadm_version}":U < "2.06" &then
               if agencia.log-1 then
                   assign bt-informacoes:sensitive in frame {&frame-name} = yes.
               else 
                   assign bt-informacoes:sensitive in frame {&frame-name} = no.
          &else
               if agencia.log-estrangeiro then
                   assign bt-informacoes:sensitive in frame {&frame-name} = yes.
               else 
                   assign bt-informacoes:sensitive in frame {&frame-name} = no. 
          &endif      
      end.
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    {utp/ut-rtlbl.i mgadm agencia tipo fill-in-1}

    find first param-global no-lock no-error.
    assign c-formato = if avail param-global then param-global.formato-cep
                       else "".

    &if defined(BF_FIN_EMS2_X_MG) &then
        if can-find(first funcao where funcao.cd-funcao = "spp-ems2fin-x-mg"
                                 and   funcao.ativo     = yes) then
              assign agencia.agencia:format       in frame {&frame-name} = "999999-X"
                     agencia.uf:format            in frame {&frame-name} = "!!"
                     agencia.e-mail:format        in frame {&frame-name} = "x(25)"
                     agencia.observacao:max-chars in frame {&frame-name} = 228.
    &endif

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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

   if   agencia.agencia:sensitive in frame {&frame-name} = yes then do:
        find first agencia 
             where agencia.agencia = input frame {&frame-name} agencia.agencia
               and agencia.cod-banco = input frame {&frame-name} agencia.cod-banco no-lock no-error.
        if  avail agencia then do:       
            {utp/ut-table.i mgadm agencia 1} 
            run utp/ut-msgs.p(input "show",
                              input 1,
                              input return-value).

            apply 'entry' to agencia.agencia in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
   end.

  /* Demais Validaá‰es */

  find banco where banco.cod-banco = input frame {&FRAME-NAME} agencia.cod-banco no-error.
    if not avail banco then do :
       {utp/ut-table.i mgadm banco 1}
       run utp/ut-msgs.p(input "show",
                         input 47,
                         input return-value).

        apply 'entry' to agencia.cod-banco in frame {&frame-name}.
        return 'ADM-ERROR':U. 
     end.

  if input frame {&FRAME-NAME} agencia.agencia = "" then do:
      {utp/ut-table.i mgadm agencia 1}
       run utp/ut-msgs.p(input "show",
                         input 164,
                         input return-value).

        apply 'entry' to agencia.agencia in frame {&frame-name}.
        return 'ADM-ERROR':U. 
     end.


  if input frame {&frame-name} agencia.pais:sensitive then do:
     find first unid-feder
        where unid-feder.pais   = input frame {&frame-name} agencia.pais no-lock no-error.
     if not avail unid-feder then do:
        {utp/ut-table.i mguni pais 1}
        run utp/ut-msgs.p(input "show",
                         input 47,
                         input return-value).

        apply 'entry' to agencia.pais in frame {&frame-name}.
        return 'ADM-ERROR':U. 
     end.

  end.

  find first unid-feder
       where unid-feder.pais   = input frame {&frame-name} agencia.pais
       and   unid-feder.estado = input frame {&frame-name} agencia.uf no-lock no-error.

  if  not avail unid-feder then do:
      {utp/ut-table.i mguni unid-feder 1}
      run utp/ut-msgs.p(input "show",
                        input 3887,
                        input return-value).
      apply 'entry' to agencia.uf in frame {&frame-name}.
      return 'ADM-ERROR':U. 
  end.


  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

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

    {cdp/cd0003i1.i agencia cdp/cd1102i1.p}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-agencia-mg V-table-Win 
PROCEDURE pi-cria-tt-agencia-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param p-ind-tipo-movto as int no-undo.
    def input param p-atualiza       as log no-undo.

    for each tt-agencia-mg:
        delete tt-agencia-mg.
    end.

    create tt-agencia-mg.
    assign tt-agencia-mg.ind-tipo-movto = p-ind-tipo-movto
           tt-agencia-mg.l-atualiza     = p-atualiza.

    /* campos iguais */
    assign tt-agencia-mg.cod-banco      = agencia.cod-banco
           tt-agencia-mg.cod-agencia    = agencia.agencia
           tt-agencia-mg.cep            = agencia.cep
           tt-agencia-mg.endereco       = fn-free-accent(agencia.endereco)
           tt-agencia-mg.cidade         = fn-free-accent(agencia.cidade)
           tt-agencia-mg.sufixo         = fn-free-accent(agencia.sufixo)
           tt-agencia-mg.pais           = agencia.pais
           tt-agencia-mg.telefone       = agencia.telefone
           tt-agencia-mg.telefax        = agencia.telefax
           tt-agencia-mg.telex          = agencia.telex
           tt-agencia-mg.nome           = fn-free-accent(agencia.nome).

    assign tt-agencia-mg.uf             = substring(string(agencia.uf,"x(02)"),1,2)
           tt-agencia-mg.e-mail         = substring(string(fn-free-accent(agencia.e-mail),"x(25)"),1,25)
           tt-agencia-mg.observacao[1]  = substring(fn-free-accent(agencia.observacao),1,76)
           tt-agencia-mg.observacao[2]  = substring(fn-free-accent(agencia.observacao),77,76)
           tt-agencia-mg.observacao[3]  = substring(fn-free-accent(agencia.observacao),153,76).

    if agencia.tipo = 1 then
       assign tt-agencia-mg.tipo        = 0.
    if agencia.tipo = 2 then
       assign tt-agencia-mg.tipo        = 1.

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
    create tt-agencia-aux.
    buffer-copy agencia to tt-agencia-aux.
    create tt-dados-env.                  
    assign tt-dados-env.num-sequencia  = i-seq 
           tt-dados-env.cod-tipo-reg   = 46
           tt-dados-env.ind-tipo-movto = i-tipo-movto
           tt-dados-env.identif-msg    = string(agencia.cod-banco) + "," +
                                         string(agencia.agencia).
    raw-transfer tt-agencia-aux to tt-dados-env.conteudo-msg.                                     
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

    assign c-valor-chave-mg = trim(string(agencia.cod-banco)) + ";" + trim(string(agencia.agencia)).

    {cdp/cd0004i1.i "CD1102" "AGENCIA" c-valor-chave-mg tt-agencia-mg.ind-tipo-movto tt-erros-mg.help-msg}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-agencia-mg V-table-Win 
PROCEDURE pi-valida-agencia-mg :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &if defined(BF_FIN_EMS2_X_MG) &then
        if can-find(first funcao where funcao.cd-funcao = "spp-ems2fin-x-mg"
                                 and   funcao.ativo     = yes) then do:
           if agencia.endereco:screen-value     in frame {&frame-name} = " " then do:
              run utp/ut-msgs.p (input "show",
                                 input 2821,
                                 input " ").
              apply "entry" to agencia.endereco in frame {&frame-name}.
              RETURN 'NOK'.
           end.
           if agencia.cidade:screen-value       in frame {&frame-name} = " " then do:
              run utp/ut-msgs.p (input "show",
                                 input 2822,
                                 input " ").
              apply "entry" to agencia.cidade   in frame {&frame-name}.
              RETURN 'NOK'.
           end.
        end.
    &endif

    IF  l-func-alt-car-rem 
    AND INPUT FRAME {&frame-name} l-canal-bancario = YES THEN DO:
        if agencia.endereco:screen-value in frame {&frame-name} = " " then do:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Endereáo" *}
            run utp/ut-msgs.p (input "show",
                               input 265,
                               input RETURN-VALUE).
            apply "entry" to agencia.endereco   in frame {&frame-name}.
            RETURN 'NOK'.
        END.
        if agencia.cidade:screen-value in frame {&frame-name} = " " then do:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Cidade" *}
            run utp/ut-msgs.p (input "show",
                               input 265,
                               input RETURN-VALUE).
            apply "entry" to agencia.cidade   in frame {&frame-name}.
            RETURN 'NOK'.
        END.
        if agencia.pais:screen-value in frame {&frame-name} = " " then do:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Pa°s" *}
            run utp/ut-msgs.p (input "show",
                               input 265,
                               input RETURN-VALUE).
            apply "entry" to agencia.pais   in frame {&frame-name}.
            RETURN 'NOK'.
        END.
        if c-razao-social = " " then do:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Raz∆o_Social" *}
            run utp/ut-msgs.p (input "show",
                               input 265,
                               input RETURN-VALUE).
            RETURN 'NOK'.
        END.
        if c-estado = " " then do:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Estado" *}
            run utp/ut-msgs.p (input "show",
                               input 265,
                               input RETURN-VALUE).
            RETURN 'NOK'.
        END.
    END.

    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "cod-banco" "agencia" "cod-banco"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

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
  {src/adm/template/snd-list.i "agencia"}

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnc-cep V-table-Win 
FUNCTION fnc-cep RETURNS CHARACTER
  ( i-cep as int ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
def var i-cont  as int  no-undo.
def var i-cont2 as int no-undo.
def var c-cep3  as char no-undo.

assign c-cep3 = string(i-cep).

do i-cont = 1 to length(c-formato):
   if substring(c-formato, i-cont, 1) = "9" then
      assign i-cont2 = i-cont2 + 1.
end.

if i-cont2 > length(c-cep3) then
   assign c-cep3 = fill( "0", i-cont2 - length(c-cep3)) + c-cep3.

  RETURN c-cep3.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

