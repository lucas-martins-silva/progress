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
{include/i-prgvrs.i V01AD104 2.00.00.030}  /*** 010030 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01AD104 MUT}
&ENDIF


{cdp/cdcfgfin.i}
{app/ap0501.i}

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

def buffer b-espec-ap for espec-ap.

def var l-novo-reg as log no-undo.
def var i-tipo     as int no-undo.
def var c-des-tipo as char format "x(25)" no-undo.
def var i-inss-iss as int initial 0 no-undo.

{utp/ut-glob.i}

/****** Integraá∆o EMS 2 FIN x MG *******/

{cdp/cd0001i1.i} /* Definiá∆o tt-erros-mg */
{cdp/cd1502i1.i} /* Definiá∆o tt-espec-ap-mg */
{cdp/cdcfgfin.i} /* Definiá∆o de vari†veis */

def var i-ind-tipo-movto as int  no-undo.
def var i-tipo-ant       as int  no-undo.
def var c-tipo-ant       as char no-undo.

/*********************************************/

/*************Multiplanta********************/
def var i-tipo-movto as integer no-undo.
def var teste        as char    no-undo.
def var i-tipo-aux   as integer no-undo.

{cdp/cd7300.i1}
{cdp/cdapi235.i}
/************Fim*****************************/
/*--- possibilita utilizar o   Modulo Multiplanta Financeiro (MMF) ---*/
def var l-ok-mmf     as logical  initial yes   no-undo.
def var c-empr       as char                   no-undo.

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
&Scoped-define EXTERNAL-TABLES espec-ap
&Scoped-define FIRST-EXTERNAL-TABLE espec-ap


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR espec-ap.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS espec-ap.descricao espec-ap.cod-class-esp ~
espec-ap.esp-ligacao espec-ap.contabiliza espec-ap.emite-ap ~
espec-ap.atual-estat espec-ap.emite-bord espec-ap.usa-antec ~
espec-ap.calc-var-cmi espec-ap.usa-previsao espec-ap.fluxo-caixa ~
espec-ap.usa-cot-emi-fasb espec-ap.log-1 
&Scoped-define ENABLED-TABLES espec-ap
&Scoped-define FIRST-ENABLED-TABLE espec-ap
&Scoped-Define ENABLED-OBJECTS usa-provisao RECT-2 rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS espec-ap.cod-esp espec-ap.descricao ~
espec-ap.cod-class-esp espec-ap.esp-ligacao espec-ap.contabiliza ~
espec-ap.emite-ap espec-ap.atual-estat espec-ap.emite-bord ~
espec-ap.usa-antec espec-ap.calc-var-cmi espec-ap.usa-previsao ~
espec-ap.fluxo-caixa espec-ap.usa-cot-emi-fasb espec-ap.log-1 
&Scoped-define DISPLAYED-TABLES espec-ap
&Scoped-define FIRST-DISPLAYED-TABLE espec-ap
&Scoped-Define DISPLAYED-OBJECTS cb-tipo c-descricao c-descr-esp-lig ~
usa-provisao 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS espec-ap.cod-esp 
&Scoped-define ADM-ASSIGN-FIELDS espec-ap.esp-ligacao 
&Scoped-define ADM-MODIFY-FIELDS cb-tipo espec-ap.esp-ligacao 
&Scoped-define List-4 espec-ap.usa-antec espec-ap.usa-previsao 

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
DEFINE VARIABLE cb-tipo AS CHARACTER FORMAT "X(20)" INITIAL "1" 
     LABEL "":6 
     VIEW-AS COMBO-BOX INNER-LINES 8
     DROP-DOWN-LIST
     SIZE 25 BY 1
     FONT 4 NO-UNDO.

DEFINE VARIABLE c-descr-esp-lig AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 24 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 5.13.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.38.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.58.

DEFINE VARIABLE usa-provisao AS LOGICAL INITIAL no 
     LABEL "Usa Provis∆o":L20 
     VIEW-AS TOGGLE-BOX
     SIZE 18.29 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     espec-ap.cod-esp AT ROW 1.38 COL 41 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     espec-ap.descricao AT ROW 2.79 COL 13.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     cb-tipo AT ROW 3.79 COL 13.29 COLON-ALIGNED HELP
          "Tipo da espÇcie de documento"
     espec-ap.cod-class-esp AT ROW 2.75 COL 57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-descricao AT ROW 2.75 COL 62 COLON-ALIGNED NO-LABEL
     espec-ap.esp-ligacao AT ROW 3.75 COL 57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-descr-esp-lig AT ROW 3.75 COL 62 COLON-ALIGNED NO-LABEL
     espec-ap.contabiliza AT ROW 5.54 COL 15.43
          VIEW-AS TOGGLE-BOX
          SIZE 14.14 BY .75
     espec-ap.emite-ap AT ROW 5.54 COL 59.14
          VIEW-AS TOGGLE-BOX
          SIZE 12 BY .75
     espec-ap.atual-estat AT ROW 6.29 COL 15.43
          VIEW-AS TOGGLE-BOX
          SIZE 21.43 BY .75
     espec-ap.emite-bord AT ROW 6.29 COL 59.14
          VIEW-AS TOGGLE-BOX
          SIZE 17 BY .75
     espec-ap.usa-antec AT ROW 7.04 COL 15.43
          VIEW-AS TOGGLE-BOX
          SIZE 19.72 BY .75
     espec-ap.calc-var-cmi AT ROW 7.04 COL 59.14
          VIEW-AS TOGGLE-BOX
          SIZE 19 BY .75
     espec-ap.usa-previsao AT ROW 7.79 COL 15.43
          VIEW-AS TOGGLE-BOX
          SIZE 16.29 BY .75
     espec-ap.fluxo-caixa AT ROW 7.79 COL 59.14
          VIEW-AS TOGGLE-BOX
          SIZE 14.43 BY .75
     espec-ap.usa-cot-emi-fasb AT ROW 8.58 COL 15.43
          VIEW-AS TOGGLE-BOX
          SIZE 32.57 BY .75
     espec-ap.log-1 AT ROW 8.58 COL 59.14
          VIEW-AS TOGGLE-BOX
          SIZE 19.86 BY .83
     usa-provisao AT ROW 9.38 COL 15.43
     RECT-2 AT ROW 5.29 COL 1
     rt-key AT ROW 1.17 COL 1
     rt-mold AT ROW 2.63 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.espec-ap
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
         HEIGHT             = 9.63
         WIDTH              = 89.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:HIDDEN           = TRUE
       FRAME f-main:HEIGHT           = 9.63
       FRAME f-main:WIDTH            = 89.29.

/* SETTINGS FOR FILL-IN c-descr-esp-lig IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-tipo IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN espec-ap.cod-esp IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN espec-ap.esp-ligacao IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR TOGGLE-BOX espec-ap.usa-antec IN FRAME f-main
   4                                                                    */
/* SETTINGS FOR TOGGLE-BOX espec-ap.usa-previsao IN FRAME f-main
   4                                                                    */
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

&Scoped-define SELF-NAME cb-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo V-table-Win
ON ENTRY OF cb-tipo IN FRAME f-main
DO:
  ASSIGN INPUT FRAME {&frame-name} cb-tipo
         i-tipo = {adinc/i01ad104.i 06 cb-tipo}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo V-table-Win
ON LEAVE OF cb-tipo IN FRAME f-main
DO:

    apply 'value-changed' to cb-tipo in frame {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo V-table-Win
ON VALUE-CHANGED OF cb-tipo IN FRAME f-main
DO:


    do with frame {&frame-name}:

       assign i-tipo = {adinc/i01ad104.i 06 cb-tipo:screen-value}.



       if  i-tipo = 4 or i-tipo = 5 then
           assign espec-ap.esp-ligacao:sensitive      = yes
                  espec-ap.atual-estat:checked        = no
                  espec-ap.calc-var-cmi:checked       = no
                  espec-ap.contabiliza:checked        = no
                  espec-ap.emite-ap:checked           = no
                  espec-ap.emite-bord:checked         = no
                  espec-ap.fluxo-caixa:checked        = no
                  espec-ap.usa-antec:checked          = no
                  espec-ap.usa-cot-emi-fasb:checked   = no
                  espec-ap.usa-previsao:checked       = no
                  espec-ap.atual-estat:sensitive      = no
                  espec-ap.calc-var-cmi:sensitive     = no
                  espec-ap.contabiliza:sensitive      = no
                  espec-ap.emite-ap:sensitive         = no
                  espec-ap.emite-bord:sensitive       = no
                  espec-ap.fluxo-caixa:sensitive      = no
                  espec-ap.usa-antec:sensitive        = no
                  espec-ap.usa-cot-emi-fasb:sensitive = no
                  espec-ap.usa-previsao:sensitive     = no.
       else 
           assign espec-ap.esp-ligacao:sensitive      = no
                  espec-ap.esp-ligacao:screen-value   = ""
                  c-descr-esp-lig:screen-value        = ""
                  espec-ap.atual-estat:sensitive      = yes
                  espec-ap.calc-var-cmi:sensitive     = yes
                  espec-ap.contabiliza:sensitive      = yes
                  espec-ap.emite-ap:sensitive         = yes
                  espec-ap.emite-bord:sensitive       = yes
                  espec-ap.fluxo-caixa:sensitive      = yes
                  espec-ap.usa-antec:sensitive        = yes
                  espec-ap.usa-cot-emi-fasb:sensitive = yes
                  espec-ap.usa-previsao:sensitive     = yes
                  espec-ap.log-1:sensitive            = yes.

       if i-tipo = 3 then do:     /* Previs∆o */
          assign espec-ap.contabiliza:checked = no. 
          disable espec-ap.contabiliza with frame {&frame-name}.
       end.   
       else if i-tipo <> 4 and i-tipo <> 5 then do:
          enable espec-ap.contabiliza with frame {&frame-name}.
       end.   

       if i-tipo = 6 then do:     /* IR */
          assign espec-ap.usa-antec:checked = no
                 espec-ap.usa-previsao:checked = no. 
          disable espec-ap.usa-antec with frame {&frame-name}.
          disable espec-ap.usa-previsao with frame {&frame-name}.
       end.   
       else if i-tipo <> 4 and i-tipo <> 5 then do:
          enable espec-ap.usa-antec with frame {&frame-name}.
          enable espec-ap.usa-previsao with frame {&frame-name}.
       end.      

       if  i-tipo = 1 then do:
           assign espec-ap.log-1:sensitive = yes
                  usa-provisao:sensitive   = yes.
       end.
       else do:
            assign espec-ap.log-1:sensitive       = no
                     espec-ap.log-1:checked       = no
                     usa-provisao:sensitive       = no
                     usa-provisao:checked         = no.
       end.

       if  i-tipo = 10 then
           ASSIGN espec-ap.usa-antec:checked   = no
                  espec-ap.usa-antec:sensitive = no.
       else
           assign espec-ap.usa-antec:sensitive = true.

    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME espec-ap.cod-class-esp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL espec-ap.cod-class-esp V-table-Win
ON F5 OF espec-ap.cod-class-esp IN FRAME f-main /* Classificaá∆o */
DO:
   assign l-implanta = yes.
   {include/zoomvar.i &prog-zoom=adzoom\z01ad301.w
                       &campo=espec-ap.cod-class-esp
                       &campozoom=cod-class-esp}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL espec-ap.cod-class-esp V-table-Win
ON LEAVE OF espec-ap.cod-class-esp IN FRAME f-main /* Classificaá∆o */
DO:
  {include/leave.i &tabela=class-esp
                 &atributo-ref=descricao
                 &variavel-ref=c-descricao
                 &where="class-esp.cod-class-esp = input frame {&frame-name} espec-ap.cod-class-esp"}  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL espec-ap.cod-class-esp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF espec-ap.cod-class-esp IN FRAME f-main /* Classificaá∆o */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME espec-ap.cod-esp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL espec-ap.cod-esp V-table-Win
ON LEAVE OF espec-ap.cod-esp IN FRAME f-main /* EspÇcie */
DO:
  if input frame {&frame-name} espec-ap.esp-ligacao = "" then 
     assign input frame {&frame-name} espec-ap.esp-ligacao:format = "x(02)" .
  else
     assign input frame {&frame-name} espec-ap.esp-ligacao:format = "!!".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME espec-ap.esp-ligacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL espec-ap.esp-ligacao V-table-Win
ON F5 OF espec-ap.esp-ligacao IN FRAME f-main /* Esp Vincula */
DO:

   assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="adzoom/z01ad104.w"
                     &campo=espec-ap.esp-ligacao
                     &campozoom=cod-esp}    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL espec-ap.esp-ligacao V-table-Win
ON LEAVE OF espec-ap.esp-ligacao IN FRAME f-main /* Esp Vincula */
DO:
  {include/leave.i &tabela=b-espec-ap
                   &atributo-ref=descricao
                   &variavel-ref=c-descr-esp-lig
                   &where="b-espec-ap.cod-esp = 
                           input frame {&frame-name} espec-ap.esp-ligacao"}  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL espec-ap.esp-ligacao V-table-Win
ON MOUSE-SELECT-DBLCLICK OF espec-ap.esp-ligacao IN FRAME f-main /* Esp Vincula */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  {cdp/cdcfgfin.i}

  {utp/ut-field.i mgadm espec-ap  Tipo 1}
  assign cb-tipo:label in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i EspÇcie_de_Retená∆o}
  assign espec-ap.log-1:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i Usa_Provis∆o}
  assign usa-provisao:label in frame {&FRAME-NAME} = trim(return-value).

  assign usa-provisao:help in frame {&FRAME-NAME} = trim(return-value).

  if espec-ap.cod-class-esp:load-mouse-pointer ("Image/lupa.cur") in frame {&frame-name} then.
  if espec-ap.esp-ligacao:load-mouse-pointer   ("image/lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "espec-ap"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "espec-ap"}

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

  ASSIGN cb-tipo:SCREEN-VALUE IN FRAME {&frame-name} = {adinc/i01ad104.i 04 1}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
    Purpose:     Override standard ADM method
    Notes:       
------------------------------------------------------------------------------*/

    run get-attribute('adm-new-record').
    if  return-value = 'yes' then
        assign i-tipo-movto = 1.
    else
        assign i-tipo-movto = 2.

    assign input frame {&frame-name} cb-tipo
           i-tipo = {adinc/i01ad104.i 06 cb-tipo:screen-value in frame {&frame-name}~~}.

    if  espec-ap.cod-esp:sensitive in frame {&frame-name} then do:
        if  can-find (espec-ap where espec-ap.cod-esp = espec-ap.cod-esp:screen-value) then do:
            {utp/ut-table.i mgadm espec-ap 1}
            run utp/ut-msgs.p (input "show":U,
                               input 1,
                               input return-value).
            apply 'entry' to espec-ap.cod-esp in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.   
    end. 

    if  i-tipo-movto = 2 and avail espec-ap then do:
        if  espec-ap.tipo <> i-tipo then do:

            if  can-find(first tit-ap where tit-ap.cod-esp = espec-ap.cod-esp:screen-value) then do:
                {utp/ut-table.i mgadm tit-ap 1} 
                run utp/ut-msgs.p (input "show":U,
                                   input 6639,
                                   input return-value + "~~" + espec-ap.cod-esp:screen-value).
                apply 'entry' to cb-tipo in frame {&frame-name}.
                return 'ADM-ERROR':U.
            end.

            FIND first conta-ap WHERE conta-ap.ep-codigo = i-ep-codigo-usuario 
                                AND   conta-ap.cod-esp   = espec-ap.cod-esp NO-LOCK NO-ERROR.

            IF  AVAIL conta-ap THEN DO:
                RUN utp/ut-msgs.p (input "show",
                                   input 8778,
                                   input "").
                apply 'entry' to cb-tipo in frame {&frame-name}.
                return 'ADM-ERROR':U.
            END.
        end.    
    end.

    if  input frame {&frame-name} espec-ap.cod-class-esp <> 0 then do:
        find first class-esp 
             where class-esp.cod-class-esp = input frame {&frame-name} espec-ap.cod-class-esp no-lock no-error.

        if  not avail class-esp then do:
            {utp/ut-table.i mgadm class-esp 1}
            run utp/ut-msgs.p (input "show",
                               input 2,
                               input return-value).
            apply 'entry' to espec-ap.cod-class-esp in frame {&frame-name}.
            return 'adm-error'.
        end.
    end.

    if  input frame {&frame-name} espec-ap.descricao = "" then do:
        run utp/ut-msgs.p (input "show",
                           input 190,
                           input "").          
        apply 'entry' to espec-ap.descricao in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.

    if  i-tipo = 4 or i-tipo = 5 then do:
        if  input frame {&frame-name} espec-ap.esp-ligacao = "" or
            input frame {&frame-name} espec-ap.esp-ligacao = ?  then do:
            {utp/ut-field.i mgadm espec-ap esp-ligacao 01}
            run utp/ut-msgs.p (input "show",
                               input 822,
                               input return-value).
            apply 'entry' to espec-ap.esp-ligacao in frame {&frame-name}.
            return 'adm-error'.
        end.

        find b-espec-ap where b-espec-ap.cod-esp = input frame {&frame-name} espec-ap.esp-ligacao no-lock no-error.
        if  not avail b-espec-ap then do:
            {utp/ut-table.i mgadm espec-ap 01}
            run utp/ut-msgs.p (input "show",
                               input 56,
                               input return-value).
            apply 'entry' to espec-ap.esp-ligacao in frame {&frame-name}.
            return 'adm-error'.
        end.

        if  avail b-espec-ap and i-tipo = 4 and b-espec-ap.tipo <> 1 then do:
            run utp/ut-msgs.p (input "show",
                               input 15679,
                               input return-value).
            apply 'entry' to espec-ap.esp-ligacao in frame {&frame-name}.
            return 'adm-error'.
        end.

        if  avail b-espec-ap and i-tipo = 5 and b-espec-ap.tipo <> 2 then do:
            run utp/ut-msgs.p (input "show",
                               input 15680,
                               input return-value).
            apply 'entry' to espec-ap.esp-ligacao in frame {&frame-name}.
            return 'adm-error'.
        end.
    end. 

    &IF DEFINED(BF_FIN_EMS2_X_MG) &THEN
        assign i-inss-iss = 0.

        if  input frame {&frame-name} cb-tipo = {adinc/i01ad104.i 04 1}
        and input frame {&frame-name} espec-ap.log-1 = yes then do: 

            if  avail espec-ap then do:
                IF  espec-ap.int-1 = 1 THEN
                    assign i-inss-iss = 3. /*--- pis, cofins e csll ---*/
                
                IF  espec-ap.int-1 <> 1 THEN DO:
                    IF  espec-ap.inss-iss = yes THEN
                        assign i-inss-iss = 1. /*--- INSS retido ---*/
                
                    IF  espec-ap.inss-iss = no THEN
                        assign i-inss-iss = 2. /*--- ISS ---*/
                END.
            END.

            run cdp/cd1502a.w (input-output i-inss-iss).
            
            if  i-inss-iss <> 1
            and i-inss-iss <> 2 
            and i-inss-iss <> 3 then return 'adm-error'.
        end.
    &ENDIF.

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

    assign espec-ap.tipo = i-tipo.

    &IF DEFINED(BF_FIN_EMS2_X_MG) &THEN
        if  i-inss-iss = 1 then
            assign espec-ap.inss-iss = YES    /* INSS retido */
                   espec-ap.int-1 = 0. 
        ELSE IF i-inss-iss = 2 THEN
                assign espec-ap.inss-iss = NO /* ISS */
                       espec-ap.int-1 = 0. 
             ELSE IF i-inss-iss = 3 THEN
                 ASSIGN espec-ap.int-1 = 1.   /* pis, cofins e csll */
    &ENDIF.

    if  l-provisao = yes then do:
        &if defined(bf_fin_provisao) &then
            assign espec-ap.usa-provisao = usa-provisao:checked.
        &else
            &if defined(bf_fin_provisao203) &then
                if can-find(first funcao where
                                  funcao.cd-funcao = "spp-provisao" and
                                  funcao.ativo     = yes ) then
                   assign espec-ap.usa-provisao = usa-provisao:checked.
            &endif.
        &endif.
    end.




    /****** Integraá∆o EMS 2 FIN x MG *******/
    {cdp/cd0002i1.i "espec-ap"}

    if  l-ok-mmf = yes then do:
        /********************Multiplanta***********************/
        assign c-transacao = "ADM033".
        {cdp/cd7300.i5 "001" c-transacao}
        run pi-cria-tt-dados (input i-tipo-movto).
        {cdp/cd7300.i6 "001" c-transacao}
        /******************Fim-Multiplanta********************/ 
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

  /* Code placed here will execute PRIOR to standard behavior. */

  {cdp/cd0002i1.i1 "espec-ap" "no"} /****** Integraá∆o EMS 2 FIN x MG *******/

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  if return-value = 'ADM-ERROR':U then 
             return 'ADM-ERROR':U.

  {cdp/cd0002i1.i1 "espec-ap" "yes"} /****** Integraá∆o EMS 2 FIN x MG *******/

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

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  &if  defined(ADM-MODIFY-FIELDS) &then
       disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
       assign usa-provisao:sensitive = false.
  &endif

  assign l-novo-reg = no.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
    Purpose:     Override standard ADM method
    Notes:       
------------------------------------------------------------------------------*/

    if avail espec-ap then do:
       find class-esp where class-esp.cod-class-esp = espec-ap.cod-class-esp no-lock no-error.
       assign c-descricao = if avail class-esp then class-esp.descricao else "":U.
       find b-espec-ap where b-espec-ap.cod-esp = espec-ap.esp-ligacao no-lock no-error.
       assign c-descr-esp-lig = if avail b-espec-ap then b-espec-ap.descricao else "":U.
    end.       

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    IF  AVAIL espec-ap THEN DO WITH FRAME {&frame-name}:
        if  espec-ap.tipo <> 0 then
            ASSIGN cb-tipo:SCREEN-VALUE = {adinc/i01ad104.i 04 espec-ap.tipo}.
        else
            ASSIGN cb-tipo:SCREEN-VALUE = {adinc/i01ad104.i 04 1}. 

        if  l-provisao = yes then 
            &if defined(bf_fin_provisao) &then
                if  espec-ap.usa-provisao = yes then
                    assign usa-provisao:checked = yes.
                else
                    assign usa-provisao:checked = no.
            &elseif defined(bf_fin_provisao203) &then
                    if  can-find(first funcao where
                                       funcao.cd-funcao = "spp-provisao" and
                                       funcao.ativo     = yes) then
                        if  espec-ap.usa-provisao = yes then
                            assign usa-provisao:checked = yes.
                        else
                            assign usa-provisao:checked = no.
            &endif.
    END.
    ELSE DO:
        ASSIGN cb-tipo:SCREEN-VALUE = {adinc/i01ad104.i 04 1}. 
    END.

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
      assign usa-provisao:sensitive = true.
  &endif

  run get-attribute('adm-new-record').
  assign l-novo-reg = (return-value = "yes").

  assign c-tipo-ant = cb-tipo:screen-value in frame {&FRAME-NAME}.
         i-tipo-ant = {adinc/i01ad103.i 06 c-tipo-ant}.

  run pi-enable-initial.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    DO  WITH FRAME {&frame-name}:      
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao001 = {adinc/i01ad104.i 03}.
            RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
            ASSIGN  cb-tipo:LIST-ITEM-PAIRS = cAuxTraducao001.
        &else
            ASSIGN cb-tipo:list-items = {adinc/i01ad104.i 03}.
        &endif
    END.

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
    assign usa-provisao:sensitive = false.

    /*---  Modulo Multiplanta Financeiro (MMF) ---*/
    {cdp/cdapi531.i1 "ADM033" "NO"}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-view V-table-Win 
PROCEDURE local-view :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'view':U ) .

  if  i-pais-impto-usuario = 1  /** Brasil **/
  or  i-pais-impto-usuario = 7  /** Chile  **/ then
      assign espec-ap.log-1:visible in frame {&FRAME-NAME} = yes.
  else
      assign espec-ap.log-1:visible in frame {&FRAME-NAME} = no.

  if  l-provisao = yes then
      assign usa-provisao:visible in frame {&FRAME-NAME} = yes.
  else
      assign usa-provisao:visible in frame {&FRAME-NAME} = no.

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
    {cdp/cd0003i1.i "espec-ap" "cdp/cd1502i1.p"}

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
         create tt-espec-ap-aux.
         buffer-copy espec-ap to tt-espec-ap-aux.
         create tt-dados-env.                  
         assign tt-dados-env.num-sequencia  = i-seq 
                tt-dados-env.cod-tipo-reg   = 82
                tt-dados-env.ind-tipo-movto = i-tipo-movto
                tt-dados-env.identif-msg    = string(espec-ap.cod-esp).
         raw-transfer tt-espec-ap-aux to tt-dados-env.conteudo-msg.                                    
         assign i-seq = i-seq + 1.                                     
     end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-espec-ap-mg V-table-Win 
PROCEDURE pi-cria-tt-espec-ap-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /****** Integraá∆o EMS 2 FIN x MG *******/

    def input param p-ind-tipo-movto as int  no-undo.
    def input param p-atualiza       as log  no-undo.

    for each tt-espec-ap-mg:
        delete tt-espec-ap-mg.
    end.

    create tt-espec-ap-mg.
    assign tt-espec-ap-mg.ind-tipo-movto = p-ind-tipo-movto
           tt-espec-ap-mg.l-atualiza     = p-atualiza.

    /* campos iguais */
    assign tt-espec-ap-mg.cod-esp      = fn-free-accent(espec-ap.cod-esp).
    assign tt-espec-ap-mg.descricao    = fn-free-accent(espec-ap.descricao).

    assign tt-espec-ap-mg.contabiliza  = espec-ap.contabiliza
           tt-espec-ap-mg.fluxo-caixa  = espec-ap.fluxo-caixa
           tt-espec-ap-mg.usa-antec    = espec-ap.usa-antec
           tt-espec-ap-mg.emite-ap     = espec-ap.emite-ap
           tt-espec-ap-mg.emite-bord   = espec-ap.emite-bord        
           tt-espec-ap-mg.calc-var-cmi = espec-ap.calc-var-cmi
           tt-espec-ap-mg.atual-estat  = espec-ap.atual-estat
           tt-espec-ap-mg.usa-previsao = espec-ap.usa-previsao
           tt-espec-ap-mg.log-2        = no.

    case espec-ap.tipo:
        when 1 then do:
               &IF DEFINED(BF_FIN_EMS2_X_MG) &THEN
                    if espec-ap.log-1 then do:
                        if  i-inss-iss = 1 
                        and espec-ap.inss-iss then
                           assign tt-espec-ap-mg.tipo  = "NO"
                                  tt-espec-ap-mg.log-2 = yes.
                        else
                           assign tt-espec-ap-mg.tipo = "IS"
                                  tt-espec-ap-mg.log-2 = no.
                    end.
                    else do:
                        assign tt-espec-ap-mg.tipo  = "NO"
                               tt-espec-ap-mg.log-2 = no.
                    end.
               &ENDIF.
        end.
        when 2 then
               assign tt-espec-ap-mg.tipo = "AN".
        when 3 then  
               assign tt-espec-ap-mg.tipo = "PR".
        when 8 then  
               assign tt-espec-ap-mg.tipo = "IR".
    end case.

    /* campos diferentes */
    assign tt-espec-ap-mg.log-1 = espec-ap.usa-cot-emi-fasb.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-enable-initial V-table-Win 
PROCEDURE pi-enable-initial :
/*------------------------------------------------------------------------------
    Purpose:     
    Parameters:  <none>
    Notes:       
------------------------------------------------------------------------------*/

    do with frame {&frame-name}:
        assign input frame {&frame-name} cb-tipo.
        assign i-tipo = {adinc/i01ad104.i 06 cb-tipo}.


        if  i-tipo = 3 then
            disable espec-ap.contabiliza with frame {&frame-name}.

        if  i-tipo = 6 then do:
            disable {&List-4} with frame {&frame-name}. /* Desabilita usa-antecipacao e previsao */
        end.
    end.

    APPLY "value-changed" TO cb-tipo IN FRAME {&frame-name}.


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

    {cdp/cd0004i1.i "cd1502"
                    "espec-ap"
                    "espec-ap.cod-esp"
                    "tt-espec-ap-mg.ind-tipo-movto"
                    "tt-erros-mg.help-msg"}
    if return-value = "NOK" then
       return.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-espec-ap-mg V-table-Win 
PROCEDURE pi-valida-espec-ap-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /****** Integraá∆o EMS 2 FIN x MG *******/

    def input-output param p-ind-tipo-movto as int no-undo.

    /* Se tipo da EspÇcie for diferente de Normal/Antecipaá∆o/Previs∆o n∆o deve ser
       integrado com o Magnus, pois os outros tipos n∆o s∆o tratados por ele. */

    if  espec-ap.tipo <> 1
    and espec-ap.tipo <> 2
    and espec-ap.tipo <> 3
    and espec-ap.tipo <> 8 then do:
 &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
     DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
     ASSIGN cAuxTraducao002 = {adinc/i01ad104.i 4 espec-ap.tipo}.
     run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                         INPUT "",
                         INPUT "").
     ASSIGN c-des-tipo    = RETURN-VALUE.
 &else
     ASSIGN c-des-tipo    = {adinc/i01ad104.i 4 espec-ap.tipo}.
 &endif
ASSIGN 
               /*c-esp-ligacao:screen-value in frame {&FRAME-NAME} = espec-ap.esp-ligacao*/
               cb-tipo:screen-value in frame {&frame-name} = {adinc/i01ad104.i 04 espec-ap.tipo}.

        if p-ind-tipo-movto = 3 then 
           assign p-ind-tipo-movto = 0.

        if p-ind-tipo-movto = 1 then do:       
           run utp/ut-msgs.p (input "show",
                              input 19446,
                              input c-des-tipo). 
           assign p-ind-tipo-movto = 0.
        end.   

        if p-ind-tipo-movto = 2 then do:
           if espec-ap.tipo <> i-tipo-ant then do:

              &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                  DEFINE VARIABLE cAuxTraducao003 AS CHARACTER NO-UNDO.
                  ASSIGN cAuxTraducao003 = {adinc/i01ad103.i 4 i-tipo-ant}.
                  run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao003)," ","_"),
                                      INPUT "",
                                      INPUT "").
                  ASSIGN  c-tipo-ant = RETURN-VALUE.
              &else
                  ASSIGN c-tipo-ant = {adinc/i01ad103.i 4 i-tipo-ant}.
              &endif
              run utp/ut-msgs.p (input "show",
                                 input 19485,
                                 input c-des-tipo + "~~" + c-tipo-ant).
              if return-value = "yes" then
                 assign p-ind-tipo-movto = 3.
              else
                 return "NOK".
           end.
           else
              assign p-ind-tipo-movto = 0.
        end.
    end.

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
  {src/adm/template/snd-list.i "espec-ap"}

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

