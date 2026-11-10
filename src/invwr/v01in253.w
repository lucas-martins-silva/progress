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
{include/i-prgvrs.i V01IN253 2.00.00.022}  /*** 010022 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN253 MUT}
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

{cdp/cdcfgman.i}

def new global shared var v-row-parent as rowid no-undo.                                
def new global shared var gr-op-altern as rowid no-undo. 
def new global shared var gr-operacao  as rowid no-undo.


def buffer b-op-altern for op-altern.
def var i-un-med-tempo as integer no-undo.

def var c-handle  as char   no-undo.
def var h-handle  as handle no-undo.
def var h-handle2 as handle no-undo.


def var i-nr-operacao  like oper-pad.nr-oper-pad no-undo.
DEF VAR nr-oper-pad-antes LIKE oper-pad.nr-oper-pad NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES op-altern
&Scoped-define FIRST-EXTERNAL-TABLE op-altern


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR op-altern.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS op-altern.nr-oper-pad op-altern.descricao ~
op-altern.tipo-oper op-altern.refugo-op op-altern.fi-codigo 
&Scoped-define ENABLED-TABLES op-altern
&Scoped-define FIRST-ENABLED-TABLE op-altern
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-3 rt-mold rt-mold-2 
&Scoped-Define DISPLAYED-FIELDS op-altern.nr-oper-pad op-altern.descricao ~
op-altern.tipo-oper op-altern.refugo-op op-altern.gm-codigo ~
op-altern.fi-codigo op-altern.cd-mob-dir 
&Scoped-define DISPLAYED-TABLES op-altern
&Scoped-define FIRST-DISPLAYED-TABLE op-altern
&Scoped-Define DISPLAYED-OBJECTS c-oper-pad-descricao Fi-titulo-tipo ~
c-grup-maquina-descricao c-ficha-metodo-descricao c-desc-mob-dir 

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
DEFINE VARIABLE c-desc-mob-dir AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 31.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-ficha-metodo-descricao AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-grup-maquina-descricao AS CHARACTER FORMAT "X(32)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE VARIABLE c-oper-pad-descricao AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE Fi-titulo-tipo AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 12.72 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41.29 BY 1.25.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 43.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 2.25.

DEFINE RECTANGLE rt-mold-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 3.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     op-altern.nr-oper-pad AT ROW 1.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     c-oper-pad-descricao AT ROW 1.17 COL 28.72 COLON-ALIGNED NO-LABEL
     op-altern.descricao AT ROW 2.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 35.43 BY .88
     op-altern.tipo-oper AT ROW 3.71 COL 10.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Interna", 1,
"Externa", 2
          SIZE 25.72 BY .88
     op-altern.refugo-op AT ROW 3.67 COL 62 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     op-altern.gm-codigo AT ROW 5.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .88
     Fi-titulo-tipo AT ROW 3.33 COL 2.14 NO-LABEL
     c-grup-maquina-descricao AT ROW 5.17 COL 34 COLON-ALIGNED NO-LABEL
     op-altern.fi-codigo AT ROW 6.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-ficha-metodo-descricao AT ROW 6.17 COL 27.57 COLON-ALIGNED NO-LABEL
     op-altern.cd-mob-dir AT ROW 7.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     c-desc-mob-dir AT ROW 7.17 COL 30 COLON-ALIGNED HELP
          "Descriá∆o da m∆o-de-obra direta" NO-LABEL
     RECT-2 AT ROW 3.5 COL 1
     RECT-3 AT ROW 3.5 COL 43.14
     rt-mold AT ROW 1 COL 1
     rt-mold-2 AT ROW 5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.op-altern
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
         HEIGHT             = 7.25
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

/* SETTINGS FOR FILL-IN c-desc-mob-dir IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-ficha-metodo-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-grup-maquina-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-oper-pad-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN op-altern.cd-mob-dir IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Fi-titulo-tipo IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN op-altern.gm-codigo IN FRAME f-main
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

&Scoped-define SELF-NAME op-altern.cd-mob-dir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-altern.cd-mob-dir V-table-Win
ON F5 OF op-altern.cd-mob-dir IN FRAME f-main /* C¢digo Mob Direta */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in566.w" 
                     &campo=op-altern.cd-mob-dir
                     &campozoom=cd-mob-dir
                     &campo2=c-desc-mob-dir
                     &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-altern.cd-mob-dir V-table-Win
ON LEAVE OF op-altern.cd-mob-dir IN FRAME f-main /* C¢digo Mob Direta */
DO:
  {include/leave.i &tabela=tab-mob-dir 
                   &atributo-ref=descricao 
                   &variavel-ref=c-desc-mob-dir
                   &where="tab-mob-dir.cd-mob-dir = input frame {&frame-name} op-altern.cd-mob-dir"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-altern.cd-mob-dir V-table-Win
ON MOUSE-SELECT-DBLCLICK OF op-altern.cd-mob-dir IN FRAME f-main /* C¢digo Mob Direta */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME op-altern.fi-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-altern.fi-codigo V-table-Win
ON F5 OF op-altern.fi-codigo IN FRAME f-main /* Ficha MÇtodo */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in125.w" 
                     &campo=op-altern.fi-codigo
                     &campozoom=fi-codigo
                     &campo2=c-ficha-metodo-descricao
                     &campozoom2=descricao}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-altern.fi-codigo V-table-Win
ON LEAVE OF op-altern.fi-codigo IN FRAME f-main /* Ficha MÇtodo */
DO:
  {include/leave.i &tabela=ficha-metodo 
                   &atributo-ref=descricao 
                   &variavel-ref=c-ficha-metodo-descricao
                   &where="ficha-metodo.fi-codigo = input frame {&frame-name} op-altern.fi-codigo"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-altern.fi-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF op-altern.fi-codigo IN FRAME f-main /* Ficha MÇtodo */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME op-altern.gm-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-altern.gm-codigo V-table-Win
ON F5 OF op-altern.gm-codigo IN FRAME f-main /* Grupo M†quina */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in144.w" 
                     &campo=op-altern.gm-codigo
                     &campozoom=gm-codigo
                     &campo2=c-grup-maquina-descricao
                     &campozoom2=descricao}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-altern.gm-codigo V-table-Win
ON LEAVE OF op-altern.gm-codigo IN FRAME f-main /* Grupo M†quina */
DO:
   def var c-handle  as char   no-undo.
   def var h-handle  as handle no-undo.
   def var h-handle2 as handle no-undo.

   {include/leave.i &tabela=grup-maquina 
                    &atributo-ref=descricao 
                    &variavel-ref=c-grup-maquina-descricao 
                    &where="grup-maquina.gm-codigo = input frame {&frame-name} op-altern.gm-codigo"}   

  &if defined (bf_man_sfc_lc) &then
      if avail grup-maquina then do:
         run get-link-handle in adm-broker-hdl(input  this-procedure,
                                               input  "tipo-target",  
                                               output c-handle). 

         if num-entries (c-handle) = 1 then 
            assign h-handle = widget-handle (c-handle).
         else
             assign h-handle  = widget-handle(substring(c-handle,1,index(c-handle,",") - 1))
                    h-handle2 = widget-handle(substring(c-handle,index(c-handle,",") + 1)).

         if valid-handle(h-handle) then 
            run pi-grup-maquina in h-handle (input input frame {&frame-name} op-altern.gm-codigo).

         if valid-handle(h-handle2) then 
            run pi-grup-maquina in h-handle2 (input input frame {&frame-name} op-altern.gm-codigo).
      end.  

      RUN get-field-screen-value in adm-broker-hdl (this-procedure, "fi-grup-maquina-aps").
      if return-value = "" and
         op-altern.gm-codigo:screen-value in frame {&frame-name} <> "" then do:
         run get-link-handle in adm-broker-hdl (input  this-procedure,
                                                input  'ctrab-target',
                                                output c-handle).

         if num-entries(c-handle) = 1 then do:
            assign h-handle = widget-handle(c-handle).
            if  valid-handle(h-handle) then
               run pi-atualiza-ctrab in h-handle (input input frame {&frame-name} op-altern.gm-codigo).
         end.
      end.   

  &endif

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-altern.gm-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF op-altern.gm-codigo IN FRAME f-main /* Grupo M†quina */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME op-altern.nr-oper-pad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-altern.nr-oper-pad V-table-Win
ON F5 OF op-altern.nr-oper-pad IN FRAME f-main /* Operaá∆o Padr∆o */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in261.w"
                     &campo=op-altern.nr-oper-pad
                     &campozoom=nr-oper-pad
                     &campo2=c-oper-pad-descricao
                     &campozoom2=descricao}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-altern.nr-oper-pad V-table-Win
ON LEAVE OF op-altern.nr-oper-pad IN FRAME f-main /* Operaá∆o Padr∆o */
DO:
   {include/leave.i &tabela=oper-pad
                    &atributo-ref=descricao
                    &variavel-ref=c-oper-pad-descricao 
                    &where="oper-pad.nr-oper-pad = input frame {&frame-name} op-altern.nr-oper-pad"} 

   /* Caso seja informada uma operaá∆o padr∆o cadastrada ser∆o apresentados os */
   /* valores "defaults" para a operaá∆o corrente.                             */

   if i-nr-operacao <> int(op-altern.nr-oper-pad:screen-value in frame {&frame-name}) then do:

      if avail oper-pad then do with frame {&frame-name}:

         if oper-pad.tipo-oper = 2 then do:
            assign op-altern.gm-codigo:screen-value  in frame {&frame-name} = ""
                   op-altern.gm-codigo:sensitive     in frame {&frame-name} = no
                   op-altern.cd-mob-dir:screen-value in frame {&frame-name} = ""
                   op-altern.cd-mob-dir:sensitive    in frame {&frame-name} = no
                   op-altern.tipo-oper:screen-value  in frame {&frame-name} = "2".

             RUN Who-Is-The-Container IN adm-broker-hdl 
                (INPUT this-procedure, OUTPUT c-handle).

             assign h-handle = widget-handle(c-handle).

             run pi-desabilita-folder in h-handle (input 3).
         end.
         else do:
             assign op-altern.gm-codigo:screen-value  in frame {&frame-name} = string(oper-pad.gm-codigo)
                    op-altern.gm-codigo:sensitive     in frame {&frame-name} = yes
                    op-altern.cd-mob-dir:screen-value in frame {&frame-name} = string(oper-pad.cd-mob-dir)
                    op-altern.cd-mob-dir:sensitive    in frame {&frame-name} = yes
                    op-altern.tipo-oper:screen-value  in frame {&frame-name} = "1".

             if adm-new-record = yes then do:
                assign op-altern.cd-mob-dir:screen-value in frame {&frame-name} = ""
                       op-altern.cd-mob-dir:sensitive    in frame {&frame-name} = yes.
             end.

             &if defined (bf_man_sfc_lc) &then

             RUN Who-Is-The-Container IN adm-broker-hdl 
                (INPUT this-procedure, OUTPUT c-handle).

             assign h-handle = widget-handle(c-handle).

             run pi-habilita-folder in h-handle (input 3).
             &endif
         end.

         if op-altern.nr-oper-pad:modified then do:
            assign op-altern.tipo-oper:screen-value       = string(oper-pad.tipo-oper)
                   op-altern.descricao:screen-value       = string(oper-pad.descricao)
                   op-altern.refugo-op:screen-value       = string(oper-pad.refugo-op)
                   op-altern.fi-codigo:screen-value       = string(oper-pad.fi-codigo)
                   op-altern.cd-mob-dir:screen-value      = string(oper-pad.cd-mob-dir).


            find grup-maquina where grup-maquina.gm-codigo = oper-pad.gm-codigo    no-lock no-error.
            find ficha-metodo where ficha-metodo.fi-codigo = oper-pad.fi-codigo    no-lock no-error.
            find pto-controle where pto-controle.codigo    = oper-pad.pto-controle no-lock no-error.
            find tab-mob-dir  where tab-mob-dir.cd-mob-dir = oper-pad.cd-mob-dir   no-lock no-error.

            assign c-ficha-metodo-descricao:screen-value = if avail ficha-metodo then string(ficha-metodo.descricao) else "":U
                   c-desc-mob-dir:screen-value           = if avail tab-mob-dir  then string(tab-mob-dir.descricao)  else "":U.

            if oper-pad.tipo-oper = 2 then
               assign c-grup-maquina-descricao:screen-value = "".
            else 
               assign c-grup-maquina-descricao:screen-value = if avail grup-maquina then string(grup-maquina.descricao) else "":U.


             run get-link-handle in adm-broker-hdl (input this-procedure,
                                                    input 'oper-pad-target',
                                                    output c-handle).
             if num-entries(c-handle) = 1 then 
                assign h-handle = widget-handle(c-handle).
             else
                assign h-handle  = widget-handle(substring(c-handle,1,index(c-handle,",") - 1))
                       h-handle2 = widget-handle(substring(c-handle,index(c-handle,",") + 1)).

             if valid-handle(h-handle) then 
                 run pi-default-oper-pad in h-handle (input rowid(oper-pad)).

             /****         
             if valid-handle(h-handle2) then 
                 run pi-default-oper-pad in h-handle2 (input rowid(oper-pad)).
             *****/

             &if defined (bf_man_sfc_lc) &then
                 if avail grup-maquina then do:
                    run get-link-handle in adm-broker-hdl(input  this-procedure,
                                                          input  "tipo-target",  
                                                          output c-handle). 

                    if num-entries (c-handle) = 1 then 
                       assign h-handle = widget-handle (c-handle).
                    else
                       assign h-handle  = widget-handle(substring(c-handle,1,index(c-handle,",") - 1))
                              h-handle2 = widget-handle(substring(c-handle,index(c-handle,",") + 1)).

                       if valid-handle(h-handle) then 
                          run pi-oper-pad in h-handle (input input frame {&frame-name} op-altern.nr-oper-pad).

                       if valid-handle(h-handle2) then 
                          run pi-oper-pad in h-handle2 (input input frame {&frame-name} op-altern.nr-oper-pad).
                 end.
             &endif         
         end.

      end.
      else do:
          assign op-altern.tipo-oper:screen-value = "1".

          &if defined (bf_man_sfc_lc) &then
          RUN Who-Is-The-Container IN adm-broker-hdl 
              (INPUT this-procedure, OUTPUT c-handle).

               assign h-handle = widget-handle(c-handle).

               run pi-habilita-folder in h-handle (input 3).
          &endif

      end.
   end.

   assign i-nr-operacao = int(op-altern.nr-oper-pad:screen-value in frame {&frame-name}).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-altern.nr-oper-pad V-table-Win
ON MOUSE-SELECT-DBLCLICK OF op-altern.nr-oper-pad IN FRAME f-main /* Operaá∆o Padr∆o */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME op-altern.tipo-oper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL op-altern.tipo-oper V-table-Win
ON VALUE-CHANGED OF op-altern.tipo-oper IN FRAME f-main /* Tp */
DO:

   if input frame {&frame-name} op-altern.tipo-oper = 2 then do:
      assign op-altern.gm-codigo:sensitive         in frame {&frame-name} = no
             op-altern.gm-codigo:screen-value      in frame {&frame-name} = " "
             c-grup-maquina-descricao:screen-value in frame {&frame-name} = " "
             op-altern.cd-mob-dir:sensitive        in frame {&frame-name} = no
             op-altern.cd-mob-dir:screen-value     in frame {&frame-name} = " "
             c-desc-mob-dir:screen-value           in frame {&frame-name} = " ".

      RUN Who-Is-The-Container IN adm-broker-hdl 
          (INPUT this-procedure, OUTPUT c-handle).

      assign h-handle = widget-handle(c-handle).

      run pi-desabilita-folder in h-handle (input 3).
   end.
   else do:
      if int(op-altern.nr-oper-pad:screen-value   in frame {&frame-name}) <> 0 then do:
         assign op-altern.gm-codigo:screen-value  in frame {&frame-name} = if avail grup-maquina then string(oper-pad.gm-codigo) else "":U
                op-altern.gm-codigo:sensitive     in frame {&frame-name} = yes
                op-altern.cd-mob-dir:sensitive    in frame {&frame-name} = yes
                op-altern.cd-mob-dir:screen-value in frame {&frame-name} = if avail grup-maquina then string(oper-pad.cd-mob-dir) else "":U.


         {include/leave.i &tabela=grup-maquina 
                          &atributo-ref=descricao 
                          &variavel-ref=c-grup-maquina-descricao 
                          &where="grup-maquina.gm-codigo = input frame {&frame-name} op-altern.gm-codigo"} 

         {include/leave.i &tabela=tab-mob-dir 
                          &atributo-ref=descricao 
                          &variavel-ref=c-desc-mob-dir
                          &where="tab-mob-dir.cd-mob-dir = input frame {&frame-name} op-altern.cd-mob-dir"}  
      end.
      else  
         assign op-altern.gm-codigo:sensitive  in frame {&frame-name} = yes
                op-altern.cd-mob-dir:sensitive in frame {&frame-name} = yes.


      &if defined (bf_man_sfc_lc) &then
      RUN Who-Is-The-Container IN adm-broker-hdl 
         (INPUT this-procedure, OUTPUT c-handle).

      assign h-handle = widget-handle(c-handle).

      run pi-habilita-folder in h-handle (input 3).
      &endif

   end.                   

   run get-link-handle in adm-broker-hdl(input this-procedure,
                                         input "tipo-target",  
                                         output c-handle). 

   if num-entries (c-handle) = 1 then 
      assign h-handle = widget-handle (c-handle).
   else
      assign h-handle  = widget-handle(substring(c-handle,1,index(c-handle,",") - 1))
             h-handle2 = widget-handle(substring(c-handle,index(c-handle,",") + 1)).

   if valid-handle(h-handle) then 
       run pi-seta-tipo-operacao in h-handle (input op-altern.tipo-oper:screen-value).

   /****
   if valid-handle(h-handle2) then 
       run pi-seta-tipo-operacao in h-handle2 (input op-altern.tipo-oper:screen-value).
   ***/                                  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  {utp/ut-rtlbl.i mgind op-altern tipo-oper fi-titulo-tipo}

  /* indicar os campos com opcao de zoom (F5) com alteracao do ponteiro do mouse */
  if op-altern.fi-codigo:load-mouse-pointer    ("image~\lupa.cur") then.
  if op-altern.gm-codigo:load-mouse-pointer    ("image~\lupa.cur") then.
  if op-altern.nr-oper-pad:load-mouse-pointer  ("image~\lupa.cur") then.
  if op-altern.cd-mob-dir:load-mouse-pointer   ("image~\lupa.cur") then.

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
  {src/adm/template/row-list.i "op-altern"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "op-altern"}

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
  {utp/ut-rtlbl.i mgind op-altern tipo-oper fi-titulo-tipo}

  if adm-new-record = yes THEN
     assign i-nr-operacao = 0
            nr-oper-pad-antes = 0.


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

  if input frame {&frame-name} op-altern.tipo-oper = 2 then do:

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
  if op-altern.nr-oper-pad:sensitive in frame {&frame-name} = yes 
  and adm-new-record = no then
     apply 'entry' to op-altern.nr-oper-pad in frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  {include/i-valid.i} /*** Validaá∆o do dicion†rio ***/

    DEFINE VARIABLE l-recur-sec AS LOGICAL INIT NO NO-UNDO.

    IF AVAIL op-altern AND (op-altern.gm-codigo <> input frame {&frame-name} op-altern.gm-codigo) THEN DO:
        /*Se o gm estiver sendo alterado, verifica se h† recur-sec-oper vinculado a esta operaá∆o.
          Se houver, e o mesmo tiver centro de trabalho vinculado, n∆o permite a alteraá∆o */
        FOR EACH recur-sec-operac NO-LOCK
           WHERE recur-sec-operac.num-id-operacao = op-altern.num-id-operacao
             AND recur-sec-operac.op-altern       = op-altern.op-altern:
    
            IF recur-sec-operac.cod-ctrab <> "" THEN DO:
                ASSIGN l-recur-sec = YES.
                LEAVE.
            END.
        END.
    
        IF l-recur-sec THEN DO:
            run utp/ut-msgs.p (input "show",
                               input 33921,
                               input "":U).
            return "ADM-ERROR":U.
        END.
    END.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

   if op-altern.tipo-oper = 1 then                   
      assign op-altern.gm-codigo  = input frame {&frame-name} op-altern.gm-codigo
             op-altern.cd-mob-dir = input frame {&frame-name} op-altern.cd-mob-dir.
   else
      assign op-altern.gm-codigo  = " "
             op-altern.cd-mob-dir = " ".

   if adm-new-record = YES then run pi-atualiza-narrativa.

  FIND FIRST oper-pad WHERE oper-pad.nr-oper-pad = op-altern.nr-oper-pad NO-LOCK NO-ERROR.
  FIND FIRST operacao where rowid(operacao) = v-row-parent NO-LOCK NO-ERROR.

  IF AVAIL oper-pad THEN DO:
      
      IF op-altern.nr-oper-pad <> nr-oper-pad-antes THEN DO:

          for each op-ferram where 
              op-ferram.num-id-operacao = op-altern.num-id-operacao and
              op-ferram.op-altern       = op-altern.op-altern EXCLUSIVE-LOCK:
              
              delete op-ferram.

          end.

          FOR EACH op-ferr-pad WHERE op-ferr-pad.nr-oper-pad = oper-pad.nr-oper-pad NO-LOCK,
              EACH ferr-prod WHERE ferr-prod.cod-ferr-prod = op-ferr-pad.ferramenta NO-LOCK:

              FIND FIRST op-ferram WHERE op-ferram.ferramenta = op-ferr-pad.ferramenta
                  AND op-ferram.op-altern = op-altern.op-altern
                  AND op-ferram.num-id-operacao = operacao.num-id-operacao EXCLUSIVE-LOCK NO-ERROR.

              IF NOT AVAIL op-ferram THEN DO:

                  CREATE op-ferram.
                  ASSIGN op-ferram.op-altern = op-altern.op-altern
                         op-ferram.num-id-operacao = op-altern.num-id-operacao
                         op-ferram.ferramenta = op-ferr-pad.ferramenta
                         op-ferram.un-ciclo = op-ferr-pad.un-ciclo
                         op-ferram.proporcao = op-ferr-pad.proporcao NO-ERROR.

              END.

          END.

          FIND ficha-oper-pad OF oper-pad NO-LOCK NO-ERROR.
          IF AVAIL ficha-oper-pad THEN DO:
              FIND ficha-oper OF op-altern EXCLUSIVE-LOCK NO-ERROR.
              IF AVAIL ficha-oper THEN
                  ASSIGN ficha-oper.desc-linha = ficha-oper-pad.desc-linha.
          END.


      END.

  END.
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

  /* Code placed here will execute AFTER standard behavior.    */

  if avail oper-pad then 
     assign op-altern.rev-ferramentas  = oper-pad.rev-ferramentas  * 10000
            op-altern.rev-ficha-oper   = oper-pad.rev-ficha-oper   * 10000
            op-altern.rev-item-consumo = oper-pad.rev-item-consumo * 10000.      

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

  if avail op-altern then do with frame {&frame-name}:
     find oper-pad     where oper-pad.nr-oper-pad   = op-altern.nr-oper-pad no-lock no-error.
     find grup-maquina where grup-maquina.gm-codigo = op-altern.gm-codigo   no-lock no-error.
     find ficha-metodo where ficha-metodo.fi-codigo = op-altern.fi-codigo   no-lock no-error.
     find tab-mob-dir  where tab-mob-dir.cd-mob-dir = op-altern.cd-mob-dir  no-lock no-error.

     assign c-oper-pad-descricao     = if avail oper-pad     then oper-pad.descricao     else "":U
            c-grup-maquina-descricao = if avail grup-maquina then grup-maquina.descricao else "":U
            c-ficha-metodo-descricao = if avail ficha-metodo then ficha-metodo.descricao else "":U
            c-desc-mob-dir           = if avail tab-mob-dir  then tab-mob-dir.descricao  else "":U.   

     if op-altern.tipo-oper = 1 then
         assign op-altern.gm-codigo:sensitive  in frame {&frame-name} = yes
                op-altern.cd-mob-dir:sensitive in frame {&frame-name} = yes.
     else   
         assign op-altern.gm-codigo:sensitive  in frame {&frame-name} = no
                op-altern.cd-mob-dir:sensitive in frame {&frame-name} = no.
  end.

  if adm-new-record then  
     assign op-altern.gm-codigo  = input frame {&frame-name} op-altern.gm-codigo
            op-altern.cd-mob-dir = input frame {&frame-name} op-altern.cd-mob-dir.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if adm-new-record then  
     assign op-altern.gm-codigo  = input frame {&frame-name} op-altern.gm-codigo
            op-altern.cd-mob-dir = input frame {&frame-name} op-altern.cd-mob-dir.

  assign i-nr-operacao = int(op-altern.nr-oper-pad:screen-value in frame {&frame-name})
         nr-oper-pad-antes = int(op-altern.nr-oper-pad:screen-value in frame {&frame-name}).


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

  if adm-new-record = yes or 
     (avail op-altern and op-altern.tipo-oper = 1) then 
     assign op-altern.gm-codigo:sensitive  in frame {&frame-name} = yes
            op-altern.cd-mob-dir:sensitive in frame {&frame-name} = yes.
  else
  if avail op-altern and op-altern.tipo-oper = 2 then 
     assign op-altern.gm-codigo:sensitive  in frame {&frame-name} = no
            op-altern.cd-mob-dir:sensitive in frame {&frame-name} = no.

  if avail op-altern then 
       assign i-nr-operacao = op-altern.nr-oper-pad.
    else
       assign i-nr-operacao = 0.



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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-narrativa V-table-Win 
PROCEDURE pi-atualiza-narrativa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    find ficha-oper-pad where 
         ficha-oper-pad.nr-oper-pad = input frame {&frame-name} op-altern.nr-oper-pad
         no-lock no-error.

    find ficha-oper 
         where ficha-oper.num-id-operacao = op-altern.num-id-operacao 
         and   ficha-oper.op-altern       = op-altern.op-altern
         exclusive-lock no-error.

    if avail ficha-oper-pad then do:    
       if avail ficha-oper then
          assign ficha-oper.desc-linha = ficha-oper-pad.desc-linha.
       else do:          
           create ficha-oper.
           assign ficha-oper.num-id-operacao = op-altern.num-id-operacao    
                  ficha-oper.op-altern       = op-altern.op-altern
                  ficha-oper.desc-linha      = ficha-oper-pad.desc-linha.

          if  not error-status:error then
              validate ficha-oper. 
       end.
    end.       
    else
       if avail ficha-oper and ficha-oper.desc-linha <> " " then 
          assign ficha-oper.desc-linha = " ".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-campo V-table-Win 
PROCEDURE pi-retorna-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def output parameter i-nr-oper-pad like oper-pad.nr-oper-pad.

assign i-nr-oper-pad = input frame {&frame-name} op-altern.nr-oper-pad.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-vldfrm.i}

  /*** Se operaá∆o Ç interna o grupo de m†quina Ç obrigatorio ***/

  if input frame {&frame-name} op-altern.tipo-oper = 1 then do:
     find grup-maquina 
          where grup-maquina.gm-codigo = input frame {&frame-name} op-altern.gm-codigo 
          no-lock no-error.
     if not avail grup-maquina then do:
        {utp/ut-field.i mgind operacao gm-codigo 1}
        run utp/ut-msgs.p (input "show",
                           input 265,
                           input return-value).
        apply "entry" to op-altern.gm-codigo in frame {&frame-name}.
        return 'ADM-ERROR':U.
     end.
  end.   

  if input frame {&frame-name} op-altern.cd-mob-dir <> "" then do:
     find first  tab-mob-dir where
         tab-mob-dir.cd-mob-dir = input  frame {&Frame-name} op-altern.cd-mob-dir no-lock no-error.
     if not avail tab-mob-dir then do:
        {utp/ut-table.i mgind tab-mob-dir 01}
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",
                           input 56,
                           input return-value).
        apply "entry" to op-altern.cd-mob-dir in frame {&frame-name}.
        return 'ADM-ERROR':U.
     end.
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
  {src/adm/template/snd-list.i "op-altern"}

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

