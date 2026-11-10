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
{include/i-prgvrs.i V02IN176 2.00.00.020}  /*** 010020 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v02in176 MUT}
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

{cdp/cdcfgmat.i}

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.
def new global shared var gr-docum-est    as rowid no-undo.


/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{rep/re9999.i1}
def var l-pedido      as logical   no-undo initial no.
def var c-buttons-rs  as character no-undo.
def var h-handle-aux1 as handle.
def var l-inclui      as logical   no-undo initial no.
def buffer b-it-doc for item-doc-est.
def var c-label       as char      no-undo format "x(20)".
def var c-it-codigo   as char      no-undo.
def var l-prog        as log       no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES item-doc-est
&Scoped-define FIRST-EXTERNAL-TABLE item-doc-est


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item-doc-est.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item-doc-est.encerra-pa ~
item-doc-est.iss-ntrib[1] item-doc-est.iss-ntrib[2] 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}iss-ntrib[1] ~{&FP2}iss-ntrib[1] ~{&FP3}~
 ~{&FP1}iss-ntrib[2] ~{&FP2}iss-ntrib[2] ~{&FP3}
&Scoped-define ENABLED-TABLES item-doc-est
&Scoped-define FIRST-ENABLED-TABLE item-doc-est
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-4 RECT-5 rt-key 
&Scoped-Define DISPLAYED-FIELDS item-doc-est.serie-comp ~
item-doc-est.nro-comp item-doc-est.nat-comp item-doc-est.seq-comp ~
item-doc-est.baixa-ce item-doc-est.atualiza-pa item-doc-est.encerra-pa ~
item-doc-est.data-comp item-doc-est.nr-pedcli item-doc-est.nr-pd-seq ~
item-doc-est.codigo-rejei item-doc-est.iss-ntrib[1] ~
item-doc-est.iss-ntrib[2] 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS item-doc-est.serie-comp ~
item-doc-est.nro-comp item-doc-est.nat-comp item-doc-est.seq-comp ~
item-doc-est.baixa-ce item-doc-est.atualiza-pa item-doc-est.encerra-pa ~
item-doc-est.data-comp item-doc-est.nr-pedcli item-doc-est.nr-pd-seq ~
item-doc-est.codigo-rejei item-doc-est.iss-ntrib[1] ~
item-doc-est.iss-ntrib[2] 

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
DEFINE VARIABLE fi-devolucao AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 19.29 BY .67 NO-UNDO.

DEFINE VARIABLE fi-docto-comp AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 27.72 BY .67 NO-UNDO.

DEFINE VARIABLE fi-moeda-alt AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 18.14 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 40.72 BY 4.79.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 44.72 BY 2.92.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 40.72 BY 2.92.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 44.72 BY 4.79.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item-doc-est.serie-comp AT ROW 1.83 COL 26.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     item-doc-est.nro-comp AT ROW 2.83 COL 26.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     item-doc-est.nat-comp AT ROW 3.83 COL 26.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
     item-doc-est.seq-comp AT ROW 4.83 COL 26.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     item-doc-est.baixa-ce AT ROW 6.71 COL 15.72
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .79
     item-doc-est.atualiza-pa AT ROW 7.5 COL 15.72
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .79
     item-doc-est.encerra-pa AT ROW 8.29 COL 15.72
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .79
     item-doc-est.data-comp AT ROW 1.83 COL 68 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     item-doc-est.nr-pedcli AT ROW 2.83 COL 68 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     item-doc-est.nr-pd-seq AT ROW 3.83 COL 68 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     item-doc-est.codigo-rejei AT ROW 4.83 COL 68 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     item-doc-est.iss-ntrib[1] AT ROW 7.08 COL 66.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     item-doc-est.iss-ntrib[2] AT ROW 8.08 COL 66.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     fi-docto-comp AT ROW 1.04 COL 2.72 COLON-ALIGNED NO-LABEL
     fi-devolucao AT ROW 1.08 COL 48 COLON-ALIGNED NO-LABEL
     fi-moeda-alt AT ROW 6.17 COL 48 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 1.25 COL 47
     RECT-4 AT ROW 6.33 COL 1.72
     RECT-5 AT ROW 6.33 COL 47
     rt-key AT ROW 1.25 COL 1.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: item-doc-est
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
         HEIGHT             = 8.33
         WIDTH              = 87.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR TOGGLE-BOX item-doc-est.atualiza-pa IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR TOGGLE-BOX item-doc-est.baixa-ce IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN item-doc-est.codigo-rejei IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN item-doc-est.data-comp IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR TOGGLE-BOX item-doc-est.encerra-pa IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN fi-devolucao IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-docto-comp IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-moeda-alt IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN item-doc-est.iss-ntrib[1] IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN item-doc-est.iss-ntrib[2] IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN item-doc-est.nat-comp IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN item-doc-est.nr-pd-seq IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN item-doc-est.nr-pedcli IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN item-doc-est.nro-comp IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN item-doc-est.seq-comp IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN item-doc-est.serie-comp IN FRAME f-main
   NO-ENABLE 2                                                          */
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

&Scoped-define SELF-NAME item-doc-est.nat-comp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.nat-comp V-table-Win
ON LEAVE OF item-doc-est.nat-comp IN FRAME f-main /* Natureza Complementar */
DO:

  if item-doc-est.serie-comp:modified in frame {&frame-name} 
  or item-doc-est.nro-comp:modified in frame {&frame-name} 
  or item-doc-est.nat-comp:modified in frame {&frame-name} then do:
    RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT this-procedure, INPUT "it-codigo").
    assign c-it-codigo = return-value.
    find docum-est where rowid(docum-est) = v-row-parent no-lock no-error.
    find emitente where emitente.cod-emitente = docum-est.cod-emitente
         no-lock no-error.

    run pi-seta-flags-observacao in this-procedure    /* criada no re9999.i1 */
       (input docum-est.cod-observa, input docum-est.nat-operacao).
    if l-retorno or l-sai-cons then do:
        find first saldo-terc no-lock
           where saldo-terc.serie-docto  = input frame {&frame-name} item-doc-est.serie-comp
             and saldo-terc.nro-docto    = input frame {&frame-name} item-doc-est.nro-comp 
             and saldo-terc.cod-emitente = docum-est.cod-emitente
             and saldo-terc.nat-operacao = input frame {&frame-name} item-doc-est.nat-comp 
             and saldo-terc.it-codigo    = c-it-codigo
             and saldo-terc.quantidade   <> 0 no-error.
        if available saldo-terc then do:
           disp saldo-terc.sequencia @ item-doc-est.seq-comp with frame {&frame-name}.
           assign item-doc-est.seq-comp:sensitive in frame {&FRAME-NAME} = yes.
        end.
        else do:
           assign item-doc-est.seq-comp:sensitive in frame {&FRAME-NAME} = no.
        end.
        find b-it-doc where
             b-it-doc.cod-emitente = docum-est.cod-emitente and 
             b-it-doc.serie-docto  = input frame {&frame-name} item-doc-est.serie-comp and
             b-it-doc.nro-docto    = input frame {&frame-name} item-doc-est.nro-comp   and
             b-it-doc.nat-operacao = input frame {&frame-name} item-doc-est.nat-comp   and
             b-it-doc.sequencia    = input frame {&frame-name} item-doc-est.seq-comp   and
             b-it-doc.it-codigo    = c-it-codigo
             no-lock no-error.
        if avail b-it-doc then 
           assign item-doc-est.baixa-ce:checked in frame {&FRAME-NAME} = b-it-doc.baixa-ce.
    end.
    else do:
       if l-entrada then do:
            find first it-nota-fisc no-lock
                 where it-nota-fisc.cod-estabel  = docum-est.cod-estabel
                   and it-nota-fisc.serie        = input frame {&frame-name} item-doc-est.serie-comp
                   and it-nota-fisc.nr-nota-fis  = input frame {&frame-name} item-doc-est.nro-comp
                   and it-nota-fisc.it-codigo    = c-it-codigo
                   and it-nota-fisc.nat-operacao = input frame {&frame-name} item-doc-est.nat-comp
                   and it-nota-fisc.nome-ab-cli  = emitente.nome-abrev no-error.
            find first movto-estoq     
                 where movto-estoq.cod-emitente = docum-est.cod-emitente
                   and movto-estoq.serie-docto  = input frame {&frame-name} item-doc-est.serie-comp
                   and movto-estoq.nro-docto    = input frame {&frame-name} item-doc-est.nro-comp
                   and movto-estoq.cod-estabel  = docum-est.cod-estabel
                   and movto-estoq.nat-operacao = input frame {&frame-name} item-doc-est.nat-comp
                   and movto-estoq.it-codigo    = c-it-codigo no-lock no-error.
            if available it-nota-fisc then do:
                disp it-nota-fisc.nr-seq-fat    @ item-doc-est.seq-comp with frame {&frame-name}.
                assign item-doc-est.seq-comp:sensitive in frame {&FRAME-NAME} = yes.

            end.                                                
            else assign item-doc-est.seq-comp:sensitive in frame {&FRAME-NAME} = no.
       end.
       else assign item-doc-est.seq-comp:sensitive in frame {&FRAME-NAME} = no.
       assign item-doc-est.data-comp:screen-value in frame {&FRAME-NAME}  = ?
              item-doc-est.nr-pedcli:screen-value in frame {&FRAME-NAME}  = ""
              item-doc-est.nr-pd-seq:screen-value in frame {&FRAME-NAME}  = "0".
       if l-entrada and docum-est.esp-docto = 20 /*"NFD"*/ then do:
         RUN pi-inicializa-devol-cliente  in this-procedure (input yes).
         if not avail it-nota-fisc and item-doc-est.data-comp:sensitive in frame {&FRAME-NAME} then do:
            apply "entry" to item-doc-est.data-comp in frame {&frame-name}.
            return no-apply.
         end.
       end.
    end.
    if item-doc-est.seq-comp:sensitive in frame {&FRAME-NAME} then do:
           apply "entry" to item-doc-est.seq-comp in frame {&frame-name}.
           return no-apply.
    end.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.nro-comp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.nro-comp V-table-Win
ON LEAVE OF item-doc-est.nro-comp IN FRAME f-main /* Numero Comp */
DO:

  if item-doc-est.serie-comp:modified in frame {&frame-name} 
  or item-doc-est.nro-comp:modified in frame {&frame-name} then do:
    RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT this-procedure, INPUT "it-codigo").
    assign c-it-codigo = return-value.
    find docum-est where rowid(docum-est) = v-row-parent no-lock no-error.
    find emitente where emitente.cod-emitente = docum-est.cod-emitente
         no-lock no-error.

    run pi-seta-flags-observacao in this-procedure    /* criada no re9999.i1 */
       (input docum-est.cod-observa, input docum-est.nat-operacao).

    if l-retorno or l-sai-cons then do:
        find first saldo-terc no-lock
           where saldo-terc.serie-docto  = input frame {&frame-name} item-doc-est.serie-comp
             and saldo-terc.nro-docto    = input frame {&frame-name} item-doc-est.nro-comp 
             and saldo-terc.cod-emitente = docum-est.cod-emitente
             and saldo-terc.it-codigo    = c-it-codigo
             and saldo-terc.quantidade   <> 0 no-error.
        if available saldo-terc then do:
           disp saldo-terc.sequencia    @ item-doc-est.seq-comp 
                saldo-terc.nat-operacao @ item-doc-est.nat-comp with frame {&frame-name}.
           assign item-doc-est.seq-comp:sensitive in frame {&FRAME-NAME} = yes
                  item-doc-est.nat-comp:sensitive in frame {&FRAME-NAME} = yes.
        end.
        else do:
           assign item-doc-est.seq-comp:sensitive in frame {&FRAME-NAME} = no
                  item-doc-est.nat-comp:sensitive in frame {&FRAME-NAME} = no.
        end.

        find b-it-doc where
             b-it-doc.cod-emitente = docum-est.cod-emitente and 
             b-it-doc.serie-docto  = input frame {&frame-name} item-doc-est.serie-comp and
             b-it-doc.nro-docto    = input frame {&frame-name} item-doc-est.nro-comp   and
             b-it-doc.nat-operacao = input frame {&frame-name} item-doc-est.nat-comp   and
             b-it-doc.sequencia    = input frame {&frame-name} item-doc-est.seq-comp   and
             b-it-doc.it-codigo    = c-it-codigo
             no-lock no-error.
        if avail b-it-doc then 
           assign item-doc-est.baixa-ce:checked in frame {&FRAME-NAME} = b-it-doc.baixa-ce.
    end.
    else do:
       if l-entrada then do:
            find first it-nota-fisc no-lock
                 where it-nota-fisc.cod-estabel  = docum-est.cod-estabel
                   and it-nota-fisc.serie        = input frame {&frame-name} item-doc-est.serie-comp
                   and it-nota-fisc.nr-nota-fis  = input frame {&frame-name} item-doc-est.nro-comp
                   and it-nota-fisc.it-codigo    = c-it-codigo
                   and it-nota-fisc.nome-ab-cli  = emitente.nome-abrev no-error.
            find first movto-estoq     
                 where movto-estoq.cod-emitente = docum-est.cod-emitente
                   and movto-estoq.serie-docto  = input frame {&frame-name} item-doc-est.serie-comp
                   and movto-estoq.nro-docto    = input frame {&frame-name} item-doc-est.nro-comp
                   and movto-estoq.cod-estabel  = docum-est.cod-estabel
                   and movto-estoq.it-codigo    = c-it-codigo no-lock no-error.
            if available it-nota-fisc then do:
                disp it-nota-fisc.nr-seq-fat    @ item-doc-est.seq-comp 
                     it-nota-fisc.nat-operacao  @ item-doc-est.nat-comp with frame {&frame-name}.
                assign item-doc-est.seq-comp:sensitive in frame {&FRAME-NAME} = yes
                       item-doc-est.nat-comp:sensitive in frame {&FRAME-NAME} = yes.
            end.                                                
            else do:
                assign item-doc-est.seq-comp:sensitive in frame {&FRAME-NAME} = no
                       item-doc-est.nat-comp:sensitive in frame {&FRAME-NAME} = no.
            end.
       end.
       else do:
            assign item-doc-est.seq-comp:sensitive in frame {&FRAME-NAME} = no.
            find first b-it-doc where
                       b-it-doc.cod-emitente = docum-est.cod-emitente and 
                       b-it-doc.serie-docto  = input frame {&frame-name} item-doc-est.serie-comp and
                       b-it-doc.nro-docto    = input frame {&frame-name} item-doc-est.nro-comp   and
                       b-it-doc.it-codigo    = c-it-codigo
                       no-lock no-error.
            find first movto-estoq     
                 where movto-estoq.cod-emitente = docum-est.cod-emitente
                   and movto-estoq.serie-docto  = input frame {&frame-name} item-doc-est.serie-comp
                   and movto-estoq.nro-docto    = input frame {&frame-name} item-doc-est.nro-comp
                   and movto-estoq.cod-estabel  = docum-est.cod-estabel
                   and movto-estoq.it-codigo    = c-it-codigo no-lock no-error.
            if available b-it-doc then do:
                disp b-it-doc.nat-operacao  @ item-doc-est.nat-comp with frame {&frame-name}.
                assign item-doc-est.nat-comp:sensitive in frame {&FRAME-NAME} = yes.
            end.                                                
            else do:
                if available movto-estoq then do:
                    disp movto-estoq.nat-operacao @ item-doc-est.nat-comp with frame {&frame-name}.
                    assign item-doc-est.nat-comp:sensitive in frame {&FRAME-NAME} = yes.
                end.
                else do:
                    assign item-doc-est.nat-comp:sensitive in frame {&FRAME-NAME} = no.
                end.
            end.
       end.
       assign item-doc-est.data-comp:screen-value in frame {&FRAME-NAME}  = ?
              item-doc-est.nr-pedcli:screen-value in frame {&FRAME-NAME}  = ""
              item-doc-est.nr-pd-seq:screen-value in frame {&FRAME-NAME}  = "0".
       if l-entrada and docum-est.esp-docto = 20 /*"NFD"*/ then do:
         RUN pi-inicializa-devol-cliente in this-procedure (input yes).
         if not avail it-nota-fisc and item-doc-est.data-comp:sensitive in frame {&FRAME-NAME} then do:
            apply "entry" to item-doc-est.data-comp in frame {&frame-name}.
            return no-apply.
         end.
       end.
    end.
    if item-doc-est.nat-comp:sensitive in frame {&FRAME-NAME} then do:
           apply "entry" to item-doc-est.nat-comp in frame {&frame-name}.
           return no-apply.
    end.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-doc-est.seq-comp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-doc-est.seq-comp V-table-Win
ON LEAVE OF item-doc-est.seq-comp IN FRAME f-main /* Seq Complem */
DO:

  if item-doc-est.serie-comp:modified in frame {&frame-name} 
  or item-doc-est.nro-comp:modified in frame {&frame-name} 
  or item-doc-est.nat-comp:modified in frame {&frame-name}
  or item-doc-est.seq-comp:modified in frame {&frame-name} then do:
    RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT this-procedure, INPUT "it-codigo").
    assign c-it-codigo = return-value.
    find docum-est where rowid(docum-est) = v-row-parent no-lock no-error.
    find emitente where emitente.cod-emitente = docum-est.cod-emitente
         no-lock no-error.

    run pi-seta-flags-observacao in this-procedure    /* criada no re9999.i1 */
       (input docum-est.cod-observa, input docum-est.nat-operacao).
    if l-retorno or l-sai-cons then do:
        find first saldo-terc no-lock
           where saldo-terc.serie-docto  = input frame {&frame-name} item-doc-est.serie-comp
             and saldo-terc.nro-docto    = input frame {&frame-name} item-doc-est.nro-comp 
             and saldo-terc.cod-emitente = docum-est.cod-emitente
             and saldo-terc.nat-operacao = input frame {&frame-name} item-doc-est.nat-comp 
             and saldo-terc.it-codigo    = c-it-codigo
             and saldo-terc.sequencia    = input frame {&frame-name} item-doc-est.seq-comp
             and saldo-terc.quantidade   <> 0 no-error.
        find b-it-doc where
             b-it-doc.cod-emitente = docum-est.cod-emitente and 
             b-it-doc.serie-docto  = input frame {&frame-name} item-doc-est.serie-comp and
             b-it-doc.nro-docto    = input frame {&frame-name} item-doc-est.nro-comp   and
             b-it-doc.nat-operacao = input frame {&frame-name} item-doc-est.nat-comp   and
             b-it-doc.sequencia    = input frame {&frame-name} item-doc-est.seq-comp   and
             b-it-doc.it-codigo    = c-it-codigo
             no-lock no-error.
        if avail b-it-doc then 
           assign item-doc-est.baixa-ce:checked in frame {&FRAME-NAME} = b-it-doc.baixa-ce.
    end.
    else do:
       if l-entrada then do:
            find first it-nota-fisc no-lock
                 where it-nota-fisc.cod-estabel  = docum-est.cod-estabel
                   and it-nota-fisc.serie        = input frame {&frame-name} item-doc-est.serie-comp
                   and it-nota-fisc.nr-nota-fis  = input frame {&frame-name} item-doc-est.nro-comp
                   and it-nota-fisc.it-codigo    = c-it-codigo
                   and it-nota-fisc.nat-operacao = input frame {&frame-name} item-doc-est.nat-comp
                   and it-nota-fisc.nr-seq-fat   = input frame {&frame-name} item-doc-est.seq-comp
                   and it-nota-fisc.nome-ab-cli  = emitente.nome-abrev no-error.
            find first movto-estoq     
                 where movto-estoq.cod-emitente = docum-est.cod-emitente
                   and movto-estoq.serie-docto  = input frame {&frame-name} item-doc-est.serie-comp
                   and movto-estoq.nro-docto    = input frame {&frame-name} item-doc-est.nro-comp
                   and movto-estoq.cod-estabel  = docum-est.cod-estabel
                   and movto-estoq.nat-operacao = input frame {&frame-name} item-doc-est.nat-comp
                   and movto-estoq.it-codigo    = c-it-codigo no-lock no-error.
       end.
       assign item-doc-est.data-comp:screen-value in frame {&FRAME-NAME}  = ?
              item-doc-est.nr-pedcli:screen-value in frame {&FRAME-NAME}  = ""
              item-doc-est.nr-pd-seq:screen-value in frame {&FRAME-NAME}  = "0".
       if l-entrada and docum-est.esp-docto = 20 /*"NFD"*/ then 
         RUN pi-inicializa-devol-cliente  in this-procedure (input yes).
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


  find param-re where param-re.usuario = c-seg-usuario no-lock no-error.
  find first param-global no-lock no-error.

if l-prog <> no then   /* ver pi-nome-programa */

  RUN pi-inicializa-label.

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
  {src/adm/template/row-list.i "item-doc-est"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item-doc-est"}

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

  /* Code placed here will execute AFTER standard behavior.    */
  assign l-inclui = yes.

  RUN pi-inicializa-label.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

if l-prog <> no then  /* ver pi-nome-programa */

  RUN pi-inicializa-label.

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

  find first param-estoq no-lock no-error.

  disable item-doc-est.iss-ntrib[1]
          item-doc-est.iss-ntrib[2]
          item-doc-est.encerra-pa when not avail item-doc-est 
                                    or item-doc-est.numero-ordem = 0
          with frame {&frame-name}.

  if  avail docum-est then do:
      run pi-seta-flags-observacao in this-procedure 
          (input docum-est.cod-observa, input docum-est.nat-operacao).
  end.        
/************************************************************************************************************
 *** NA TRANSFER“NCIA N«O DEVE SER PEDIDO O VALOR DO PREÄO UNITµRIO PARA A MOEDA ALTERNATIVA.             ***
 *** if  avail docum-est and docum-est.esp-docto = 23 then do:   /* NFT */                                ***
 ***     assign item-doc-est.iss-ntrib[1]:sensitive = avail param-estoq and param-estoq.tem-moeda1        ***
 ***            item-doc-est.iss-ntrib[2]:sensitive = avail param-estoq and param-estoq.tem-moeda2.       ***
 ***                                                                                                      ***
 *** end.                                                                                                 ***
 ************************************************************************************************************/
  if  l-devolucao or (not l-entrada and not l-transf and not l-remessa) or l-retorno or l-sai-cons then do with frame {&frame-name}:
      assign item-doc-est.serie-comp:sensitive = yes
             item-doc-est.nro-comp:sensitive   = yes.

  end.
  if  l-devolucao then do with frame {&frame-name}:
      assign item-doc-est.baixa-ce:sensitive     = yes
             item-doc-est.codigo-rejei:sensitive = yes.
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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa V-table-Win 
PROCEDURE pi-inicializa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input param rw-item         as rowid   no-undo.
  def input param l-alterou-item  as logical no-undo. 
  def input param l-inclusao      as logical no-undo.

  find docum-est where rowid(docum-est) = v-row-parent no-lock no-error.

  run pi-seta-flags-observacao in this-procedure    /* criada no re9999.i1 */
     (input docum-est.cod-observa, input docum-est.nat-operacao).

  find item where rowid(item) = rw-item no-lock no-error.
  find first param-estoq no-lock no-error.
  if  avail item then do with frame {&frame-name}:
      if  l-devolucao or (not l-entrada and not l-transf and not l-remessa) or l-retorno or l-sai-cons then do with frame {&frame-name}:
            if (param-estoq.tem-moeda1 or param-estoq.tem-moeda2) and
               not l-retorno and not l-sai-cons and
               l-entrada and item.tipo-contr <> 2 /*"T"*/ then do:
                assign item-doc-est.iss-ntrib[1]:sensitive = avail param-estoq and param-estoq.tem-moeda1
                       item-doc-est.iss-ntrib[2]:sensitive = avail param-estoq and param-estoq.tem-moeda2.
            end.
      end. 
      if  param-re.baixa-estoq = no and item.tipo-contr <> 4
      and (l-sai-cons or l-remessa) then do:
          assign item-doc-est.baixa-ce:sensitive = yes.
      end.    
      else do:
          assign item-doc-est.baixa-ce:sensitive = no.
      end.

      if  param-re.baixa-estoq = no and (l-ent-cons or l-retorno)
      and (item.tipo-contr = 1 or item.tipo-contr = 3) then do:
          assign item-doc-est.atualiza-pa:sensitive = yes.
      end.    
      else do:
          assign item-doc-est.atualiza-pa:sensitive = no.
      end.

      RUN Get-Field-Screen-Value IN adm-broker-hdl
          (INPUT this-procedure, INPUT "numero-ordem").
      if  integer(return-value) > 0 then do with frame {&frame-name}:
          find ordem-compra where
               ordem-compra.numero-ordem = integer(return-value) no-lock no-error.

          &if defined(bf_mat_contratos) &then     
          if  avail ordem-compra and ordem-compra.nr-contrato <> 0 then do:
          &else
          if  avail ordem-compra and ordem-compra.nr-contrato <> "" then do:
          &endif
              if  l-transf = no and (l-devolucao = no and l-remessa = no)
              and param-re.encerra-cc and l-entrada
              and l-sai-cons = no and l-ent-cons = no then 
                  assign item-doc-est.encerra-pa:sensitive = yes.
          end. 
          else do:
              assign item-doc-est.encerra-pa:sensitive    = yes.
              if l-inclusao then   /* somente inicializa quando for inclusao */
                 assign item-doc-est.encerra-pa:checked      = no.
          end.
      end.
      if not l-inclusao then do:
        find emitente where emitente.cod-emitente = docum-est.cod-emitente
             no-lock no-error.
        if l-retorno or l-sai-cons then do:
            find first saldo-terc no-lock
               where saldo-terc.serie-docto  = input frame {&frame-name} item-doc-est.serie-comp
                 and saldo-terc.nro-docto    = input frame {&frame-name} item-doc-est.nro-comp 
                 and saldo-terc.cod-emitente = docum-est.cod-emitente
                 and saldo-terc.nat-operacao = input frame {&frame-name} item-doc-est.nat-comp 
                 and saldo-terc.it-codigo    = item.it-codigo
                 and saldo-terc.sequencia    = input frame {&frame-name} item-doc-est.seq-comp
                 and saldo-terc.quantidade   <> 0 no-error.
            find b-it-doc where
                 b-it-doc.cod-emitente = docum-est.cod-emitente and 
                 b-it-doc.serie-docto  = input frame {&frame-name} item-doc-est.serie-comp and
                 b-it-doc.nro-docto    = input frame {&frame-name} item-doc-est.nro-comp   and
                 b-it-doc.nat-operacao = input frame {&frame-name} item-doc-est.nat-comp   and
                 b-it-doc.sequencia    = input frame {&frame-name} item-doc-est.seq-comp   and
                 b-it-doc.it-codigo    = item.it-codigo
                 no-lock no-error.
        end.
        else do:
           if l-entrada then do:
                find first it-nota-fisc no-lock
                     where it-nota-fisc.cod-estabel  = docum-est.cod-estabel
                       and it-nota-fisc.serie        = input frame {&frame-name} item-doc-est.serie-comp
                       and it-nota-fisc.nr-nota-fis  = input frame {&frame-name} item-doc-est.nro-comp
                       and it-nota-fisc.it-codigo    = item.it-codigo
                       and it-nota-fisc.nat-operacao = input frame {&frame-name} item-doc-est.nat-comp
                       and it-nota-fisc.nr-seq-fat   = input frame {&frame-name} item-doc-est.seq-comp
                       and it-nota-fisc.nome-ab-cli  = emitente.nome-abrev no-error.
                find first movto-estoq     
                     where movto-estoq.cod-emitente = docum-est.cod-emitente
                       and movto-estoq.serie-docto  = input frame {&frame-name} item-doc-est.serie-comp
                       and movto-estoq.nro-docto    = input frame {&frame-name} item-doc-est.nro-comp
                       and movto-estoq.cod-estabel  = docum-est.cod-estabel
                       and movto-estoq.nat-operacao = input frame {&frame-name} item-doc-est.nat-comp
                       and movto-estoq.it-codigo    = item.it-codigo no-lock no-error.
           end.
           if l-entrada and docum-est.esp-docto = 20 /*"NFD"*/ then 
             RUN pi-inicializa-devol-cliente  in this-procedure (input no).
        end.
      end.
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-devol-cliente V-table-Win 
PROCEDURE pi-inicializa-devol-cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter l-inicializa as logical.

def var de-qtd-devol as decimal no-undo.
def var de-fator     as decimal no-undo.
    RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT this-procedure, INPUT "it-codigo").
    assign c-it-codigo = return-value.

    assign  de-qtd-devol = ?
            item-doc-est.data-comp:sensitive in frame {&FRAME-NAME} = (not avail it-nota-fisc and
                                                                       not avail movto-estoq)
            item-doc-est.nr-pedcli:sensitive in frame {&FRAME-NAME} = (not avail it-nota-fisc and
                                                                       param-re.reabre-pd and 
                                                                       param-global.modulo-pd)
            item-doc-est.nr-pd-seq:sensitive in frame {&FRAME-NAME} = (not avail it-nota-fisc and
                                                                       param-re.reabre-pd and
                                                                       param-global.modulo-pd)
            item-doc-est.baixa-ce:sensitive in frame {&FRAME-NAME} = (not avail it-nota-fisc and
                                                                      not avail movto-estoq and
                                                                      param-re.baixa-estoq = no).
    if l-inicializa then do:
        if avail it-nota-fisc then do:
            assign item-doc-est.data-comp:screen-value in frame {&FRAME-NAME}  = string(it-nota-fisc.dt-emis-nota)
                   item-doc-est.nr-pedcli:screen-value in frame {&FRAME-NAME}  = string(it-nota-fisc.nr-pedcli)
                   item-doc-est.nr-pd-seq:screen-value in frame {&FRAME-NAME}  = string(it-nota-fisc.nr-seq-fat)
                   item-doc-est.baixa-ce:checked in frame {&FRAME-NAME}        = it-nota-fisc.baixa-estoq.
        end.
        else if avail movto-estoq then do:
            assign item-doc-est.data-comp:screen-value in frame {&FRAME-NAME} = string(movto-estoq.dt-trans).  
        end.
        if not avail it-nota-fisc then do:
            if param-re.baixa-estoq then 
               assign item-doc-est.baixa-ce:checked in frame {&FRAME-NAME} = param-re.baixa-estoq.
        end.
    end.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-label V-table-Win 
PROCEDURE pi-inicializa-label :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
if l-prog <> no then do:  /* ver pi-nome-programa */

  find docum-est where rowid(docum-est) = v-row-parent no-lock no-error.
  find first param-estoq no-lock no-error.
  run pi-seta-flags-observacao in this-procedure 
       (input docum-est.cod-observa, input docum-est.nat-operacao).

  {utp/ut-field.i mgind docum-est nro-docto 1}
  assign c-buttons-rs = return-value.
  {utp/ut-field.i mgind calen-data data 1}
  assign c-buttons-rs = c-buttons-rs + ",1, " + return-value + ",2"
         fi-devolucao = " " + {ininc/i03in090.i 04 3}
         fi-devolucao:screen-value in frame {&frame-name} = fi-devolucao
         fi-devolucao:width in frame {&frame-name} = length(fi-devolucao) + 3
         l-pedido = (param-global.modulo-pd = yes and param-re.reabre-pd).
  {utp/ut-liter.i Documento_Complementar * R}
  assign fi-docto-comp:screen-value in frame {&frame-name} = return-value.

  {utp/ut-liter.i Moeda_Alternativa * R}
  assign fi-moeda-alt:screen-value in frame {&frame-name} = return-value.

    if l-devolucao or (not l-entrada and not l-transf and not l-remessa)
       or l-sai-cons or l-retorno then do:
       {utp/ut-field.i mgind item-doc-est cotacao-alt 2}
       /* moeda alternativa 1 */
       assign c-label = return-value.   
       if avail param-estoq and param-estoq.tem-moeda1 then do:
          find moeda where moeda.mo-codigo = param-estoq.moeda1 no-lock no-error.
          if avail moeda then 
            assign c-label = c-label + " " + moeda.descricao.
       end.
       assign item-doc-est.iss-ntrib[1]:label = c-label.
       /* moeda alternativa 2 */
       assign c-label = return-value.   
       if avail param-estoq and param-estoq.tem-moeda2 then do:
          find moeda where moeda.mo-codigo = param-estoq.moeda2 no-lock no-error.
          if avail moeda then 
            assign c-label = c-label + " " + moeda.descricao.
       end.
       assign item-doc-est.iss-ntrib[2]:label = c-label.
    end.
    else do:
       {utp/ut-field.i mgind item-doc-est preco-total-alt 2}
       /* moeda alternativa 1 */
       assign c-label = return-value.   
       if avail param-estoq and param-estoq.tem-moeda1 then do:
          find moeda where moeda.mo-codigo = param-estoq.moeda1 no-lock no-error.
          if avail moeda then 
            assign c-label = c-label + " " + string(moeda.descricao,"x(8)").
       end.
       assign item-doc-est.iss-ntrib[1]:label = c-label.
       /* moeda alternativa 2 */
       assign c-label = return-value.   
       if avail param-estoq and param-estoq.tem-moeda2 then do:
          find moeda where moeda.mo-codigo = param-estoq.moeda2 no-lock no-error.
          if avail moeda then 
            assign c-label = c-label + " " + string(moeda.descricao,"x(8)").
       end.
       assign item-doc-est.iss-ntrib[2]:label = c-label.
    end.   
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-nome-programa V-table-Win 
PROCEDURE pi-nome-programa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter c-nome-programa as char no-undo.
if c-nome-programa = "re0701b" then
   assign l-prog   = no.



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
  def var c-item       as character no-undo.
  def var c-referencia as character no-undo.
  def var c-serie-comp as character no-undo.
  def var c-docto-comp as character no-undo.
  def var c-nat-comp   as character no-undo.
  def var c-pedcli     as character no-undo.
  def var i-seq-comp   as integer   no-undo.
  def var i-seq-ped    as integer   no-undo.
  def var l-tem-nota   as logical   no-undo.
  def var de-mo-cot1   as decimal   no-undo.
  def var de-mo-cot2   as decimal   no-undo.
  def var da-data-comp as date      no-undo.

  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

  if  (input frame {&frame-name} item-doc-est.serie-comp <> ""   or
       input frame {&frame-name} item-doc-est.nro-comp    <> "") and
      (l-devolucao                                            or 
      (not l-entrada and not l-transf and not l-remessa)      or 
      l-retorno or l-sai-cons) then do:
      RUN Get-Field-Screen-Value IN adm-broker-hdl
          (INPUT this-procedure, INPUT "it-codigo").
      assign c-item       = return-value.
      RUN Get-Field-Screen-Value IN adm-broker-hdl
          (INPUT this-procedure, INPUT "cod-refer").
      assign c-referencia = return-value
             c-serie-comp = input frame {&frame-name} item-doc-est.serie-comp
             c-docto-comp = input frame {&frame-name} item-doc-est.nro-comp
             c-nat-comp   = input frame {&frame-name} item-doc-est.nat-comp
             i-seq-comp   = input frame {&frame-name} item-doc-est.seq-comp
             i-seq-ped    = input frame {&frame-name} item-doc-est.nr-pd-seq
             c-pedcli     = input frame {&frame-name} item-doc-est.nr-pedcli
             da-data-comp = input frame {&frame-name} item-doc-est.data-comp
             l-tem-nota   = no.
    if  l-retorno or l-sai-cons then do with frame {&frame-name}: 
      find       saldo-terc NO-LOCK
           where saldo-terc.serie-docto  = c-serie-comp
             and saldo-terc.nro-docto    = c-docto-comp
             and saldo-terc.cod-emitente = docum-est.cod-emitente
             and saldo-terc.nat-operacao = c-nat-comp
             and saldo-terc.it-codigo    = c-item 
             and saldo-terc.cod-refer    = c-referencia
             and saldo-terc.sequencia    = i-seq-comp no-error.
      if  not available saldo-terc  then do:
          {include/i-vldprg.i}
          {utp/ut-table.i mgind saldo-terc 1}
          run utp/ut-msgs.p (input "show":U, input 2, input return-value).
          apply "entry" to item-doc-est.serie-comp in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
    end. /* Fim do Retorno de Beneficiamento ou Sa°da de Consignaá∆o */
    else do:
        if l-entrada then do:
            find emitente where emitente.cod-emitente = docum-est.cod-emitente
                 no-lock no-error.
            find first it-nota-fisc no-lock
                 where it-nota-fisc.cod-estabel  = docum-est.cod-estabel
                   and it-nota-fisc.serie        = c-serie-comp
                   and it-nota-fisc.nr-nota-fis  = c-docto-comp
                   and it-nota-fisc.nat-operacao = c-nat-comp
                   and it-nota-fisc.nr-seq-fat   = i-seq-comp
                   and it-nota-fisc.it-codigo    = c-item
                   and it-nota-fisc.nome-ab-cli  = emitente.nome-abrev no-error.
            find first movto-estoq     
                 where movto-estoq.cod-emitente = docum-est.cod-emitente
                   and movto-estoq.serie-docto  = c-serie-comp
                   and movto-estoq.nro-docto    = c-docto-comp
                   and movto-estoq.cod-estabel  = docum-est.cod-estabel
                   and movto-estoq.nat-operacao = c-nat-comp
                   and movto-estoq.it-codigo    = c-item no-lock no-error.

            if not avail it-nota-fisc and not avail movto-estoq then do:       
                {include/i-vldprg.i}
                {utp/ut-liter.i Docto_Complem * R}
                run utp/ut-msgs.p (input "show":U, input 2, input return-value).
                apply "entry" to item-doc-est.serie-comp in frame {&frame-name}.
                return 'ADM-ERROR':U.
            end.
            if avail it-nota-fisc then do:
                find nota-fiscal no-lock where 
                     nota-fiscal.cod-estabel = it-nota-fisc.cod-estabel and
                     nota-fiscal.serie       = it-nota-fisc.serie       and
                     nota-fiscal.nr-nota-fis = it-nota-fisc.nr-nota-fis no-error.
                if  nota-fiscal.ind-sit-nota = 1 then do:
                    {include/i-vldprg.i}
                    run utp/ut-msgs.p (input "show":U, input 7150, input "").
                    apply "entry" to item-doc-est.nat-comp in frame {&frame-name}.
                    return 'ADM-ERROR':U.
                end.
                if  nota-fiscal.dt-confirm = ? then do:
                    {include/i-vldprg.i}
                    run utp/ut-msgs.p (input "show":U, input 6328, input "").
                    apply "entry" to item-doc-est.nat-comp in frame {&frame-name}.
                    return 'ADM-ERROR':U.
                end.
                if  nota-fiscal.dt-cancela <> ? then do:
                    {include/i-vldprg.i}
                    run utp/ut-msgs.p (input "show":U, input 3366, input "").
                    apply "entry" to item-doc-est.nat-comp in frame {&frame-name}.
                    return 'ADM-ERROR':U.
                end.
                find ped-venda where
                     ped-venda.nome-abrev = emitente.nome-abrev and
                     ped-venda.nr-pedcli  = it-nota-fisc.nr-pedcli no-lock no-error.
                if  avail ped-venda and param-re.reabre-pd then do:
                    if  ped-venda.cod-sit-ped = 5 then do:
                        {include/i-vldprg.i}
                        run utp/ut-msgs.p (input "show":U, input 7152, input "").
                        apply "entry" to item-doc-est.nat-comp in frame {&frame-name}.
                        return 'ADM-ERROR':U.
                    end.
                    if  ped-venda.cod-sit-ped = 6 then do:
                        {include/i-vldprg.i}
                        run utp/ut-msgs.p (input "show":U, input 7153, input "").
                        apply "entry" to item-doc-est.nat-comp in frame {&frame-name}.
                        return 'ADM-ERROR':U.
                    end.
                end.
            end.
        end.
        else do:
            find b-it-doc where
                 b-it-doc.cod-emitente = docum-est.cod-emitente and 
                 b-it-doc.serie-docto  = input frame {&frame-name} item-doc-est.serie-comp and
                 b-it-doc.nro-docto    = input frame {&frame-name} item-doc-est.nro-comp   and
                 b-it-doc.nat-operacao = input frame {&frame-name} item-doc-est.nat-comp   and
                 b-it-doc.sequencia    = input frame {&frame-name} item-doc-est.seq-comp   and
                 b-it-doc.it-codigo    = c-item
                 no-lock no-error.
            find first movto-estoq     
                 where movto-estoq.cod-emitente = docum-est.cod-emitente
                   and movto-estoq.serie-docto  = c-serie-comp
                   and movto-estoq.nro-docto    = c-docto-comp
                   and movto-estoq.cod-estabel  = docum-est.cod-estabel
                   and movto-estoq.nat-operacao = c-nat-comp
                   and movto-estoq.it-codigo    = c-item no-lock no-error.
            if not avail b-it-doc and not avail movto-estoq then do:       
                {include/i-vldprg.i}
                {utp/ut-liter.i Docto_Complem * R}
                run utp/ut-msgs.p (input "show":U, input 2, input return-value).
                apply "entry" to item-doc-est.serie-comp in frame {&frame-name}.
                return 'ADM-ERROR':U.
            end.
        end.
        if l-entrada and docum-est.esp-docto = 20 /*"NFD"*/ then do:
            if  c-pedcli <> "" or i-seq-ped <> 0 then do:
                find first ped-item
                     where ped-item.nome-abrev   = emitente.nome-abrev 
                       and ped-item.nr-pedcli    = c-pedcli
                       and ped-item.nr-sequencia = i-seq-ped
                       and ped-item.it-codigo    = c-item no-lock no-error.
                if  not avail ped-item then do:
                    {include/i-vldprg.i}
                    {utp/ut-table.i mgdis ped-item 1}
                    run utp/ut-msgs.p (input "show":U, input 2, input return-value).
                    apply "entry" to item-doc-est.nr-pd-seq in frame {&frame-name}.
                    return 'ADM-ERROR':U.
                end.
                find ped-venda where
                     ped-venda.nome-abrev = ped-item.nome-abrev and
                     ped-venda.nr-pedcli  = ped-item.nr-pedcli no-lock no-error.
                if  ped-venda.cod-sit-ped = 5 then do:
                    {include/i-vldprg.i}
                    run utp/ut-msgs.p (input "show":U, input 7152, input "").
                    apply "entry" to item-doc-est.nr-pedcli in frame {&frame-name}.
                    return 'ADM-ERROR':U.
                end.
                if  ped-venda.cod-sit-ped = 6 then do:
                    {include/i-vldprg.i}
                    run utp/ut-msgs.p (input "show":U, input 7153, input "").
                    apply "entry" to item-doc-est.nr-pedcli in frame {&frame-name}.
                    return 'ADM-ERROR':U.
                end.
                if  ped-venda.mo-codigo <> 0 then do:
                    find cotacao no-lock where
                         cotacao.mo-codigo   = ped-venda.mo-codigo and
                         cotacao.ano-periodo = string(year(da-data-comp),"9999") 
                                             + string(month(da-data-comp),"99")
                                               no-error.
                    if  not avail cotacao 
                    or  cotacao.cotacao[day(da-data-comp)] = ? then do:
                        {include/i-vldprg.i}
                        run utp/ut-msgs.p (input "show":U, input 3279, 
                                           input string(da-data-comp)).
                        apply "entry" to item-doc-est.data-comp in frame {&frame-name}.
                        return 'ADM-ERROR':U.
                    end.
                end.
            end.
        end.
    end.
  end.

  if  param-global.modulo-cq 
  and item-doc-est.codigo-rejei:sensitive in frame {&frame-name} then do:
      find cod-rejeicao no-lock where
           cod-rejeicao.codigo-rejei = input frame {&frame-name} item-doc-est.codigo-rejei no-error.
       if  not avail cod-rejeicao then do:
          {utp/ut-table.i mgind cod-rejeicao 1}
          {include/i-vldprg.i}
          run utp/ut-msgs.p (input "show":U, input 2, input return-value).
          apply "entry" to item-doc-est.codigo-rejei in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.     
  end.

if item-doc-est.data-comp:sensitive in frame {&frame-name} 
 and input frame {&FRAME-NAME} item-doc-est.data-comp = ? then do:
    {utp/ut-field.i mgind item-doc-est data-comp 2}
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show":U, input 1385, input return-value).
    apply "entry" to item-doc-est.data-comp in frame {&frame-name}.
    return 'ADM-ERROR':U.
end.

if  item-doc-est.iss-ntrib[1]:sensitive in frame {&frame-name} 
  and input frame {&frame-name} item-doc-est.iss-ntrib[1] = 0 then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show":U, input 3588, input "").
    apply "entry" to item-doc-est.iss-ntrib[1] in frame {&frame-name}.
    return 'ADM-ERROR':U.
end.

if  item-doc-est.iss-ntrib[2]:sensitive in frame {&frame-name} 
  and input frame {&frame-name} item-doc-est.iss-ntrib[2] = 0 then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show":U, input 3588, input "").
    apply "entry" to item-doc-est.iss-ntrib[2] in frame {&frame-name}.
    return 'ADM-ERROR':U.
end.

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
  {src/adm/template/snd-list.i "item-doc-est"}

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


