&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
{include/i-prgvrs.i V01IN261 2.00.00.023}  /*** 010023 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN261 MUT}
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

def new global shared var v-row-parent as rowid no-undo.                                
def new global shared var gr-oper-pad as rowid no-undo.

define buffer b-oper-pad for oper-pad.

def var l-mod-cq as logical.

{cdp/cdcfgman.i}

def var c-handle  as char   no-undo.
def var h-handle  as handle no-undo.
def var h-handle2 as handle no-undo.

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
&Scoped-define EXTERNAL-TABLES oper-pad
&Scoped-define FIRST-EXTERNAL-TABLE oper-pad


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR oper-pad.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS oper-pad.tipo-oper oper-pad.revisao ~
oper-pad.data-inicio oper-pad.data-termino oper-pad.refugo-op ~
oper-pad.proporcao oper-pad.fi-codigo oper-pad.pto-controle ~
oper-pad.emite-ficha oper-pad.contr-qualidade 
&Scoped-define ENABLED-TABLES oper-pad
&Scoped-define FIRST-ENABLED-TABLE oper-pad
&Scoped-define DISPLAYED-TABLES oper-pad
&Scoped-define FIRST-DISPLAYED-TABLE oper-pad
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-11 rt-mold rt-mold1 rt-mold2 ~
rt-mold3 rt-mold4 
&Scoped-Define DISPLAYED-FIELDS oper-pad.tipo-oper oper-pad.revisao ~
oper-pad.data-inicio oper-pad.data-termino oper-pad.refugo-op ~
oper-pad.proporcao oper-pad.gm-codigo oper-pad.fi-codigo ~
oper-pad.pto-controle oper-pad.cd-mob-dir oper-pad.emite-ficha ~
oper-pad.contr-qualidade 
&Scoped-Define DISPLAYED-OBJECTS c-pto-controle-descricao ~
c-ficha-metodo-descricao c-desc-mob c-grup-maquina-descricao Fi-titulo-tipo 

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
DEFINE VARIABLE c-desc-mob AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 31.14 BY .88.

DEFINE VARIABLE c-ficha-metodo-descricao AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-grup-maquina-descricao AS CHARACTER FORMAT "X(32)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE VARIABLE c-pto-controle-descricao AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE Fi-titulo-tipo AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 10.29 BY .54 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 42 BY 1.25.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 42.72 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 43.14 BY 1.25.

DEFINE RECTANGLE rt-mold1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41.72 BY 1.25.

DEFINE RECTANGLE rt-mold2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41.72 BY 2.25.

DEFINE RECTANGLE rt-mold3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 43 BY 2.25.

DEFINE RECTANGLE rt-mold4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 4.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     oper-pad.tipo-oper AT ROW 1.54 COL 7 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Interna", 1,
"Externa", 2
          SIZE 30.29 BY .88
     oper-pad.revisao AT ROW 1.54 COL 67.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     oper-pad.data-inicio AT ROW 3 COL 22.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     oper-pad.data-termino AT ROW 4 COL 22.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     oper-pad.refugo-op AT ROW 3 COL 68 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     oper-pad.proporcao AT ROW 4 COL 68 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     oper-pad.gm-codigo AT ROW 5.54 COL 22.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     oper-pad.fi-codigo AT ROW 6.54 COL 22.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     oper-pad.pto-controle AT ROW 7.54 COL 22.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     oper-pad.cd-mob-dir AT ROW 8.54 COL 22.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     oper-pad.emite-ficha AT ROW 10.25 COL 9
          VIEW-AS TOGGLE-BOX
          SIZE 30.29 BY .75
     oper-pad.contr-qualidade AT ROW 10.25 COL 54
          VIEW-AS TOGGLE-BOX
          SIZE 24.86 BY .75
     c-pto-controle-descricao AT ROW 7.54 COL 28 COLON-ALIGNED NO-LABEL
     c-ficha-metodo-descricao AT ROW 6.54 COL 30.14 COLON-ALIGNED NO-LABEL
     c-desc-mob AT ROW 8.54 COL 32.14 COLON-ALIGNED NO-LABEL
     c-grup-maquina-descricao AT ROW 5.54 COL 37 COLON-ALIGNED NO-LABEL
     Fi-titulo-tipo AT ROW 1 COL 2.72 NO-LABEL
     RECT-10 AT ROW 9.96 COL 1
     RECT-11 AT ROW 9.96 COL 44
     rt-mold AT ROW 1.33 COL 43.57
     rt-mold1 AT ROW 1.33 COL 1
     rt-mold2 AT ROW 2.83 COL 1
     rt-mold3 AT ROW 2.83 COL 43.72
     rt-mold4 AT ROW 5.33 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.oper-pad
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
         HEIGHT             = 10.42
         WIDTH              = 85.72.
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-mob IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-ficha-metodo-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-grup-maquina-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-pto-controle-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN oper-pad.cd-mob-dir IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Fi-titulo-tipo IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN oper-pad.gm-codigo IN FRAME f-main
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME oper-pad.cd-mob-dir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-pad.cd-mob-dir V-table-Win
ON F5 OF oper-pad.cd-mob-dir IN FRAME f-main /* C¢digo Mob Direta */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in566.w" 
                     &campo=oper-pad.cd-mob-dir
                     &campozoom=cd-mob-dir
                     &campo2= c-desc-mob    
                     &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-pad.cd-mob-dir V-table-Win
ON LEAVE OF oper-pad.cd-mob-dir IN FRAME f-main /* C¢digo Mob Direta */
DO:
    {include/leave.i &tabela=tab-mob-dir  
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-mob
                     &where="tab-mob-dir.cd-mob-dir = input  frame {&Frame-name} oper-pad.cd-mob-dir"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-pad.cd-mob-dir V-table-Win
ON MOUSE-SELECT-DBLCLICK OF oper-pad.cd-mob-dir IN FRAME f-main /* C¢digo Mob Direta */
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME oper-pad.fi-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-pad.fi-codigo V-table-Win
ON F5 OF oper-pad.fi-codigo IN FRAME f-main /* Ficha MÇtodo */
DO:
 assign l-implanta = yes.
 {include/zoomvar.i &prog-zoom="inzoom/z01in125.w" 
                    &campo=oper-pad.fi-codigo
                    &campozoom=fi-codigo
                    &campo2=c-ficha-metodo-descricao
                    &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-pad.fi-codigo V-table-Win
ON LEAVE OF oper-pad.fi-codigo IN FRAME f-main /* Ficha MÇtodo */
DO:
  {include/leave.i &tabela=ficha-metodo 
                   &atributo-ref=descricao 
                   &variavel-ref=c-ficha-metodo-descricao
                   &where="ficha-metodo.fi-codigo =
                   input frame {&frame-name} oper-pad.fi-codigo"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-pad.fi-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF oper-pad.fi-codigo IN FRAME f-main /* Ficha MÇtodo */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME oper-pad.gm-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-pad.gm-codigo V-table-Win
ON F5 OF oper-pad.gm-codigo IN FRAME f-main /* Grupo M†quina */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in144.w" 
                     &campo=oper-pad.gm-codigo
                     &campozoom=gm-codigo
                     &campo2=c-grup-maquina-descricao
                     &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-pad.gm-codigo V-table-Win
ON LEAVE OF oper-pad.gm-codigo IN FRAME f-main /* Grupo M†quina */
DO:
  def var c-handle  as char   no-undo.
  def var h-handle  as handle no-undo.  
  def var h-handle2 as handle no-undo.
  
  {include/leave.i &tabela=grup-maquina 
                   &atributo-ref=descricao 
                   &variavel-ref=c-grup-maquina-descricao 
                   &where="grup-maquina.gm-codigo = input frame {&frame-name} oper-pad.gm-codigo"} 
                   
      
  &if defined (bf_man_sfc_lc) &then
      if input frame {&frame-name} oper-pad.gm-codigo <> "" then do:
         RUN get-link-handle IN adm-broker-hdl (INPUT this-procedure, 
                                                INPUT 'tipo-target',
                                                OUTPUT c-handle).
         if num-entries(c-handle) = 1 then 
            assign h-handle = widget-handle(c-handle).
         else
            assign h-handle  = widget-handle(substring(c-handle,1,index(c-handle,",") - 1))
                   h-handle2 = widget-handle(substring(c-handle,index(c-handle,",") + 1)).

             
         if valid-handle(h-handle) then 
            run pi-grup-maquina in h-handle (input input frame {&frame-name} oper-pad.gm-codigo).

         if valid-handle(h-handle2) then 
            run pi-grup-maquina in h-handle2 (input input frame {&frame-name} oper-pad.gm-codigo).
   
      end.
  &endif
                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-pad.gm-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF oper-pad.gm-codigo IN FRAME f-main /* Grupo M†quina */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME oper-pad.pto-controle
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-pad.pto-controle V-table-Win
ON F5 OF oper-pad.pto-controle IN FRAME f-main /* Ponto Controle */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in364.w" 
                     &campo=oper-pad.pto-controle
                     &campozoom=codigo
                     &campo2=c-pto-controle-descricao
                     &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-pad.pto-controle V-table-Win
ON LEAVE OF oper-pad.pto-controle IN FRAME f-main /* Ponto Controle */
DO:
  {include/leave.i &tabela=pto-controle 
                   &atributo-ref=descricao
                   &variavel-ref=c-pto-controle-descricao 
                   &where="pto-controle.codigo = input frame {&frame-name} oper-pad.pto-controle"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-pad.pto-controle V-table-Win
ON MOUSE-SELECT-DBLCLICK OF oper-pad.pto-controle IN FRAME f-main /* Ponto Controle */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME oper-pad.tipo-oper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-pad.tipo-oper V-table-Win
ON VALUE-CHANGED OF oper-pad.tipo-oper IN FRAME f-main /* Tp */
DO:
    
  if input frame {&frame-name} oper-pad.tipo-oper = 2 then do:
     if adm-new-record then 
        assign oper-pad.gm-codigo:sensitive          in frame {&frame-name} = no
               oper-pad.gm-codigo:screen-value       in frame {&frame-name} = ""
               c-grup-maquina-descricao:screen-value in frame {&frame-name} = ""
               oper-pad.cd-mob-dir:sensitive         in frame {&frame-name} = no
               oper-pad.cd-mob-dir:screen-value      in frame {&frame-name} = ""
               c-desc-mob:screen-value               in frame {&frame-name} = ""
               oper-pad.contr-qualidade:SENSITIVE    IN FRAME {&FRAME-NAME} = NO. 
     else 
        assign oper-pad.gm-codigo:sensitive          in frame {&frame-name} = no
               oper-pad.gm-codigo:screen-value       in frame {&frame-name} = ""
               c-grup-maquina-descricao:screen-value in frame {&frame-name} = ""
               oper-pad.cd-mob-dir:sensitive         in frame {&frame-name} = no
               oper-pad.cd-mob-dir:screen-value      in frame {&frame-name} = ""
               c-desc-mob:screen-value               in frame {&frame-name} = ""
               oper-pad.contr-qualidade:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.                  
  
     RUN Who-Is-The-Container IN adm-broker-hdl 
        (INPUT this-procedure, OUTPUT c-handle).
            
     assign h-handle = widget-handle(c-handle).
    
     run pi-desabilita-folder in h-handle (input 3).
  end.
  else do:
     assign oper-pad.gm-codigo:sensitive  in frame {&frame-name} = yes
            oper-pad.cd-mob-dir:sensitive in frame {&frame-name} = yes
            oper-pad.contr-qualidade:SENSITIVE    IN FRAME {&FRAME-NAME} = YES.

     &if defined (bf_man_sfc_lc) &then
     RUN Who-Is-The-Container IN adm-broker-hdl 
        (INPUT this-procedure, OUTPUT c-handle).
            
     assign h-handle = widget-handle(c-handle).
   
     run pi-habilita-folder in h-handle (input 3).
     &endif
  end.
 
   /*** Caso exista no programa um link do tipo "TIPO" entre esta viewer e outra ser∆o ***/
   /*** desabilitados campos desnecess†rios de acordo com o tipo de operaá∆o (interna/externa).     ***/

   RUN get-link-handle IN adm-broker-hdl (INPUT this-procedure,
                                          INPUT 'tipo-target',
                                          OUTPUT c-handle).
                                          
   if num-entries(c-handle) = 1 then 
      assign h-handle = widget-handle(c-handle).
   else
      assign h-handle  = widget-handle(substring(c-handle,1,index(c-handle,",") - 1))
             h-handle2 = widget-handle(substring(c-handle,index(c-handle,",") + 1)).

   if valid-handle(h-handle) then
      run pi-verifica-tipo-oper in h-handle (input input frame {&frame-name} oper-pad.tipo-oper).
/*
   if valid-handle(h-handle2) then
      run pi-verifica-tipo-oper in h-handle2 (input input frame {&frame-name} oper-pad.tipo-oper).
*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  /* titulo do retangulo para o campo oper-pad.tipo-oper */
  {utp/ut-rtlbl.i mgind oper-pad tipo-oper fi-titulo-tipo}
  
  if oper-pad.fi-codigo:load-mouse-pointer    ("image/lupa.cur") then.
  if oper-pad.gm-codigo:load-mouse-pointer    ("image/lupa.cur") then.
  if oper-pad.pto-controle:load-mouse-pointer ("image/lupa.cur") then.
  if oper-pad.cd-mob-dir:load-mouse-pointer   ("image/lupa.cur") then.
  
  /* verificar se trabalha com modulo de controle de qualidade */
 
  find first param-global no-lock no-error.
  if avail param-global then
      assign l-mod-cq = param-global.modulo-cq.
       
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
  {src/adm/template/row-list.i "oper-pad"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "oper-pad"}

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
  /* Code placed here will execute PRIOR to standard behavior. */
   
  /* Dispatch standard ADM method.                             */
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  

  display today @ oper-pad.data-inicio with frame {&frame-name}.
  
  assign oper-pad.gm-codigo:sensitive  in frame {&frame-name} = yes
         oper-pad.cd-mob-dir:sensitive in frame {&frame-name} = yes.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-apply-entry V-table-Win 
PROCEDURE local-apply-entry :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'apply-entry':U ) .

  if input frame {&frame-name} oper-pad.tipo-oper = 2 then do:

     RUN Who-Is-The-Container IN adm-broker-hdl 
         (INPUT this-procedure, OUTPUT c-handle).
            
     assign h-handle = widget-handle(c-handle).
   
     run pi-desabilita-folder in h-handle (input 3).
   
  end.
  else do:
     &if defined (bf_man_sfc_lc) &then
     RUN Who-Is-The-Container IN adm-broker-hdl 
         (INPUT this-procedure, OUTPUT c-handle).
            
     assign h-handle = widget-handle(c-handle).
   
     run pi-habilita-folder in h-handle (input 3).
     &endif
  end.

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
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  
  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.
   
   assign oper-pad.gm-codigo  = input frame {&frame-name} oper-pad.gm-codigo
          oper-pad.cd-mob-dir = input frame {&frame-name} oper-pad.cd-mob-dir.
   
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

   if adm-new-record then  
      assign oper-pad.gm-codigo  = input frame {&frame-name} oper-pad.gm-codigo
             oper-pad.cd-mob-dir = input frame {&frame-name} oper-pad.cd-mob-dir.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  
  if avail oper-pad then do with frame {&frame-name}:
  
     find grup-maquina where grup-maquina.gm-codigo = oper-pad.gm-codigo    no-lock no-error.
     find ficha-metodo where ficha-metodo.fi-codigo = oper-pad.fi-codigo    no-lock no-error.
     find pto-controle where pto-controle.codigo    = oper-pad.pto-controle no-lock no-error.
     find tab-mob-dir  where tab-mob-dir.cd-mob-dir = oper-pad.cd-mob-dir   no-lock no-error.
           
     assign c-grup-maquina-descricao:screen-value = if avail grup-maquina then grup-maquina.descricao else "":U
            c-ficha-metodo-descricao:screen-value = if avail ficha-metodo then ficha-metodo.descricao else "":U
            c-pto-controle-descricao:screen-value = if avail pto-controle then pto-controle.descricao else "":U
            c-desc-mob:screen-value               = if avail tab-mob-dir  then tab-mob-dir.descricao  else "":U. 
            
      if oper-pad.tipo-oper = 1 then
         assign oper-pad.gm-codigo:sensitive  in frame {&frame-name} = yes
                oper-pad.cd-mob-dir:sensitive in frame {&frame-name} = yes.
      else   
         assign oper-pad.gm-codigo:sensitive  in frame {&frame-name} = no
                oper-pad.cd-mob-dir:sensitive in frame {&frame-name} = no.         
  end.   
   
   if adm-new-record then  
      assign oper-pad.gm-codigo  = input frame {&frame-name} oper-pad.gm-codigo
             oper-pad.cd-mob-dir = input frame {&frame-name} oper-pad.cd-mob-dir.


 
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
  run get-attribute ('adm-new-record').
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  if  l-mod-cq then 
      enable  oper-pad.contr-qualidade with frame {&frame-name}.
  else
      disable oper-pad.contr-qualidade with frame {&frame-name}. 



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
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
 {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

  /*** Se operaá∆o Ç interna o grupo de m†quina Ç obrigatorio ***/

  if input frame {&frame-name} oper-pad.tipo-oper = 1 and 
     input frame {&frame-name} oper-pad.gm-codigo = "" then do:
      {include/i-vldprg.i}
      {utp/ut-table.i mgind grup-maquina 1}
      run utp/ut-msgs.p (input "show",
                         input 265,
                         input return-value).
      apply "entry" to oper-pad.gm-codigo in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  
  /*** Verifca se existe o Grupo de M†quina informado ***/
  if input frame {&frame-name} oper-pad.gm-codigo <> "" then do:
     find first grup-maquina where grup-maquina.gm-codigo = 
          input frame {&frame-name} oper-pad.gm-codigo no-lock no-error.
     if not avail grup-maquina then do:
        {include/i-vldprg.i}
        {utp/ut-table.i mgind grup-maquina 1}
        run utp/ut-msgs.p (input "show",
                           input 56,
                           input return-value).
        apply "entry" to oper-pad.gm-codigo in frame {&frame-name}.
        return 'ADM-ERROR':U.
     end.     
  end.
  
  /*** Data de inicio de validade n∆o deve ser maior ou igual a data fim validade ***/
  if input frame {&frame-name} oper-pad.data-inicio >= 
    input frame {&frame-name} oper-pad.data-termino then do:
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show",
                         input 137,
                         input "").
      apply "entry" to oper-pad.data-inicio in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  
  /*** Data de termino n∆o deve ficar no pasado ***/
  if today > input frame {&frame-name} oper-pad.data-termino then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show",
                         input 2311,
                         input "").
      apply "entry" to oper-pad.data-termino in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.     

  if input frame {&frame-name} oper-pad.cd-mob-dir <> "" then do:
     find first  tab-mob-dir where
         tab-mob-dir.cd-mob-dir = input  frame {&Frame-name} oper-pad.cd-mob-dir no-lock no-error.
     if not avail tab-mob-dir then do:
        {include/i-vldprg.i}
        {utp/ut-table.i mgind tab-mob-dir 01}
        run utp/ut-msgs.p (input "show",
                           input 56,
                           input return-value).
        apply "entry" to oper-pad.cd-mob-dir in frame {&frame-name}.
        return 'ADM-ERROR':U.
     end.
  end.
           
  
  /* Ficha Metodo e Ponto de Controloe */
  IF int(oper-pad.fi-codigo:SCREEN-VALUE) <> 0 THEN DO:
      find first ficha-metodo 
           where ficha-metodo.fi-codigo = input  frame {&Frame-name} oper-pad.fi-codigo no-lock no-error.
    
      if not avail ficha-metodo then do:
         {include/i-vldprg.i}
         {utp/ut-table.i mgind ficha-metodo 01}
         run utp/ut-msgs.p (input "show",
                            input 56,
                            input return-value).
         apply "entry" to oper-pad.fi-codigo in frame {&frame-name}.
         return 'ADM-ERROR':U.
      end.
  END.

  IF int(oper-pad.pto-controle:SCREEN-VALUE) <> 0 THEN DO:
      find first pto-controle 
          where pto-controle.codigo = input  frame {&Frame-name} oper-pad.pto-controle no-lock no-error.
    
      if not avail pto-controle then do:
       {include/i-vldprg.i}
       {utp/ut-table.i mgind pto-controle 01}
       run utp/ut-msgs.p (input "show",
                          input 56,
                          input return-value).
       apply "entry" to oper-pad.pto-controle in frame {&frame-name}.
       return 'ADM-ERROR':U.
  END.
end.

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
  {src/adm/template/snd-list.i "oper-pad"}

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

