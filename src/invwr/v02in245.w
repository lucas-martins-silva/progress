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
{include/i-prgvrs.i V02IN245 2.00.01.014}  /*** 010114 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v02in245 MUT}
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

def new global shared var i-tipo as integer.
def var l-ped-abe as logical initial no.
def  var c-handle    as char.
def var i-cod-mensagem as integer no-undo.
def buffer b-esp-doc for esp-doc.

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
&Scoped-Define ENABLED-FIELDS natur-oper.calc-auto ~
natur-oper.ind-contabilizacao natur-oper.ind-entfut natur-oper.emite-duplic ~
natur-oper.auto-ct natur-oper.ind-est-qtd natur-oper.auto-cr ~
natur-oper.baixa-estoq natur-oper.usa-pick natur-oper.atual-estat ~
natur-oper.transf natur-oper.auto-ce natur-oper.ind-it-sub-dif ~
natur-oper.tp-rec-desp natur-oper.auto-est natur-oper.ind-it-icms ~
natur-oper.cod-mensagem natur-oper.atualiza-of natur-oper.cod-esp ~
natur-oper.ind-gera-of natur-oper.especie-doc natur-oper.cod-canal-venda 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}tp-rec-desp ~{&FP2}tp-rec-desp ~{&FP3}~
 ~{&FP1}cod-mensagem ~{&FP2}cod-mensagem ~{&FP3}~
 ~{&FP1}cod-esp ~{&FP2}cod-esp ~{&FP3}~
 ~{&FP1}especie-doc ~{&FP2}especie-doc ~{&FP3}~
 ~{&FP1}cod-canal-venda ~{&FP2}cod-canal-venda ~{&FP3}
&Scoped-define ENABLED-TABLES natur-oper
&Scoped-define FIRST-ENABLED-TABLE natur-oper
&Scoped-Define DISPLAYED-FIELDS natur-oper.calc-auto ~
natur-oper.ind-contabilizacao natur-oper.ind-entfut natur-oper.emite-duplic ~
natur-oper.auto-ct natur-oper.ind-est-qtd natur-oper.auto-cr ~
natur-oper.baixa-estoq natur-oper.usa-pick natur-oper.atual-estat ~
natur-oper.transf natur-oper.auto-ce natur-oper.ind-it-sub-dif ~
natur-oper.tp-rec-desp natur-oper.auto-est natur-oper.ind-it-icms ~
natur-oper.cod-mensagem natur-oper.atualiza-of natur-oper.cod-esp ~
natur-oper.ind-gera-of natur-oper.especie-doc natur-oper.cod-canal-venda 
&Scoped-Define DISPLAYED-OBJECTS c-descricao-cv 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS natur-oper.ind-contabilizacao 
&Scoped-define ADM-ASSIGN-FIELDS natur-oper.ind-contabilizacao 

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
DEFINE VARIABLE c-descricao-cv AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 31.14 BY .88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     natur-oper.calc-auto AT ROW 1.08 COL 1.57
          VIEW-AS TOGGLE-BOX
          SIZE 23.57 BY .75
     natur-oper.ind-contabilizacao AT ROW 1.08 COL 32
          VIEW-AS TOGGLE-BOX
          SIZE 21.43 BY .75
     natur-oper.ind-entfut AT ROW 1.08 COL 54.57
          VIEW-AS TOGGLE-BOX
          SIZE 17.29 BY .75
     natur-oper.emite-duplic AT ROW 2.08 COL 1.57
          VIEW-AS TOGGLE-BOX
          SIZE 20.29 BY .75
     natur-oper.auto-ct AT ROW 2.08 COL 32
          VIEW-AS TOGGLE-BOX
          SIZE 16.43 BY .75
     natur-oper.ind-est-qtd AT ROW 2.08 COL 54.57
          LABEL "":L30
          VIEW-AS TOGGLE-BOX
          SIZE 30.29 BY .83
     natur-oper.auto-cr AT ROW 3.08 COL 1.57
          VIEW-AS TOGGLE-BOX
          SIZE 22.29 BY .75
     natur-oper.baixa-estoq AT ROW 3.08 COL 32
          VIEW-AS TOGGLE-BOX
          SIZE 20.14 BY .75
     natur-oper.usa-pick AT ROW 3.08 COL 54.57
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .75
     natur-oper.atual-estat AT ROW 4.08 COL 32
          VIEW-AS TOGGLE-BOX
          SIZE 22.43 BY .75
     natur-oper.transf AT ROW 4.08 COL 54.57
          VIEW-AS TOGGLE-BOX
          SIZE 29.86 BY .75
     natur-oper.auto-ce AT ROW 5.08 COL 32
          VIEW-AS TOGGLE-BOX
          SIZE 18.72 BY .75
     natur-oper.ind-it-sub-dif AT ROW 5.08 COL 54.57
          VIEW-AS TOGGLE-BOX
          SIZE 32.14 BY .75
     natur-oper.tp-rec-desp AT ROW 5.13 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     natur-oper.auto-est AT ROW 6.08 COL 32
          VIEW-AS TOGGLE-BOX
          SIZE 21.43 BY .75
     natur-oper.ind-it-icms AT ROW 6.08 COL 54.57
          VIEW-AS TOGGLE-BOX
          SIZE 29.57 BY .75
     natur-oper.cod-mensagem AT ROW 6.13 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     natur-oper.atualiza-of AT ROW 7.08 COL 54.57
          VIEW-AS TOGGLE-BOX
          SIZE 29.57 BY .75
     natur-oper.cod-esp AT ROW 7.13 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     natur-oper.ind-gera-of AT ROW 8.08 COL 54.57
          VIEW-AS TOGGLE-BOX
          SIZE 28.57 BY .83
     natur-oper.especie-doc AT ROW 8.13 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     natur-oper.cod-canal-venda AT ROW 9.13 COL 23.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-descricao-cv AT ROW 9.13 COL 28.43 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


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
         HEIGHT             = 9.21
         WIDTH              = 86.
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

/* SETTINGS FOR FILL-IN c-descricao-cv IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX natur-oper.ind-contabilizacao IN FRAME f-main
   1 2                                                                  */
/* SETTINGS FOR TOGGLE-BOX natur-oper.ind-est-qtd IN FRAME f-main
   EXP-LABEL                                                            */
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
ON VALUE-CHANGED OF natur-oper.atual-estat IN FRAME f-main /* Atualiza Estat¡stica */
DO:
  
 if  natur-oper.calc-auto:checked   in frame {&frame-name} = yes
 and natur-oper.atual-estat:checked in frame {&frame-name} = yes then 
     enable natur-oper.auto-est with frame {&frame-name}.
 else do:
     assign natur-oper.auto-est:checked = no.
     disable natur-oper.auto-est with frame {&frame-name}.   
 end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.baixa-estoq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.baixa-estoq V-table-Win
ON VALUE-CHANGED OF natur-oper.baixa-estoq IN FRAME f-main /* Baixa Estoque */
DO:
  
 if  natur-oper.calc-auto:checked   in frame {&frame-name} = yes
 and natur-oper.baixa-estoq:checked in frame {&frame-name} = yes then 
     enable natur-oper.auto-ce with frame {&frame-name}.
 else do:
     assign natur-oper.auto-ce:checked = no.
     disable natur-oper.auto-ce with frame {&frame-name}.   
 end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.calc-auto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.calc-auto V-table-Win
ON VALUE-CHANGED OF natur-oper.calc-auto IN FRAME f-main /* C lculo Autom tico */
DO:
 if  natur-oper.calc-auto:checked    in frame {&frame-name} = yes
 and natur-oper.emite-duplic:checked in frame {&frame-name} = yes then 
     enable natur-oper.auto-cr  with frame {&frame-name}.
 else do:
     assign natur-oper.auto-cr:checked = no.
     disable natur-oper.auto-cr with frame {&frame-name}.   
 end.

 if  natur-oper.calc-auto:checked          in frame {&frame-name} = yes
 and natur-oper.ind-contabilizacao:checked in frame {&frame-name} = yes then 
     enable natur-oper.auto-ct  with frame {&frame-name}.
 else do:
     assign natur-oper.auto-ct:checked = no.
     disable natur-oper.auto-ct with frame {&frame-name}.   
 end.

 if  natur-oper.calc-auto:checked   in frame {&frame-name} = yes
 and natur-oper.atual-estat:checked in frame {&frame-name} = yes then 
     enable natur-oper.auto-est with frame {&frame-name}.
 else do:
     assign natur-oper.auto-est:checked = no.
     disable natur-oper.auto-est with frame {&frame-name}.   
 end.

 if  natur-oper.calc-auto:checked   in frame {&frame-name} = yes
 and natur-oper.baixa-estoq:checked in frame {&frame-name} = yes then 
     enable natur-oper.auto-ce with frame {&frame-name}.
 else do:
     assign natur-oper.auto-ce:checked = no.
     disable natur-oper.auto-ce with frame {&frame-name}.   
 end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.cod-canal-venda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.cod-canal-venda V-table-Win
ON F5 OF natur-oper.cod-canal-venda IN FRAME f-main /* Canal Venda */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom= "dizoom/z01di232.w"
                     &campo= natur-oper.cod-canal-venda
                     &campozoom= cod-canal-venda} 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.cod-canal-venda V-table-Win
ON LEAVE OF natur-oper.cod-canal-venda IN FRAME f-main /* Canal Venda */
DO:
 find first canal-venda where canal-venda.cod-canal-venda = input natur-oper.cod-canal-venda
      no-lock no-error.
  if  avail canal-venda then
      assign c-descricao-cv:screen-value = canal-venda.descricao.
  else
      assign c-descricao-cv:screen-value = ''.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.cod-canal-venda V-table-Win
ON MOUSE-SELECT-DBLCLICK OF natur-oper.cod-canal-venda IN FRAME f-main /* Canal Venda */
DO:
    apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.cod-esp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.cod-esp V-table-Win
ON F5 OF natur-oper.cod-esp IN FRAME f-main /* Esp‚cie T¡tulo */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom= "adzoom/z01ad103.w"
                     &campo= natur-oper.cod-esp
                     &campozoom= cod-esp} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.cod-esp V-table-Win
ON LEAVE OF natur-oper.cod-esp IN FRAME f-main /* Esp‚cie T¡tulo */
DO:
   RUN Get-Field-Screen-Value IN adm-broker-hdl
      (INPUT THIS-PROCEDURE,
       INPUT "TIPO").
   if return-value <> "1" then do:
      if input frame {&frame-name} natur-oper.cod-esp <> " " then do:
         find esp-doc where esp-doc.cod-esp = input frame {&frame-name} natur-oper.cod-esp
              no-lock no-error.
         if avail esp-doc and esp-doc.contabiliza = yes then do:
            enable natur-oper.ind-contabilizacao with frame {&frame-name}.
            enable natur-oper.auto-ct with frame {&frame-name}.
         end.  
         else do:
            assign natur-oper.ind-contabilizacao:checked in frame {&frame-name} = no.
            assign natur-oper.auto-ct:checked in frame {&frame-name} = no.
            disable natur-oper.ind-contabilizacao with frame {&frame-name}.
            disable natur-oper.auto-ct with frame {&frame-name}.
         end. 
      end.
   end. 
   else do:
      if input frame {&frame-name} natur-oper.cod-esp <> " " then do:
         find esp-doc where esp-doc.cod-esp = input frame {&frame-name} natur-oper.cod-esp
          no-lock no-error.
         if avail esp-doc and esp-doc.contabiliza = yes and esp-doc.tipo = 5 then do:
            enable natur-oper.ind-contabilizacao with frame {&frame-name}.
            enable natur-oper.auto-ct with frame {&frame-name}.
         end.
         else do:
            assign natur-oper.ind-contabilizacao:checked in frame {&frame-name} = no.
            assign natur-oper.auto-ct:checked in frame {&frame-name} = no.
            disable natur-oper.ind-contabilizacao with frame {&frame-name}.
            disable natur-oper.auto-ct with frame {&frame-name}.
         end.
      end.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.cod-esp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF natur-oper.cod-esp IN FRAME f-main /* Esp‚cie T¡tulo */
DO:
   apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.cod-mensagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.cod-mensagem V-table-Win
ON F5 OF natur-oper.cod-mensagem IN FRAME f-main /* Mensagem */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom= "adzoom/z01ad176.w"
                     &campo= natur-oper.cod-mensagem
                     &campozoom= cod-mensagem} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.cod-mensagem V-table-Win
ON MOUSE-SELECT-DBLCLICK OF natur-oper.cod-mensagem IN FRAME f-main /* Mensagem */
DO:
   apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.emite-duplic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.emite-duplic V-table-Win
ON VALUE-CHANGED OF natur-oper.emite-duplic IN FRAME f-main /* Gera Duplicatas */
DO:
  
 if  natur-oper.emite-duplic:checked in frame {&frame-name} = no 
 and integer(i-tipo) <> 1 then  
     enable natur-oper.ind-contabilizacao with frame {&frame-name}.

/* if  natur-oper.ind-contabilizacao:sensitive in frame {&frame-name} = yes 
 and integer(i-tipo) <> 1
 and natur-oper.emite-duplic:checked in frame {&frame-name} = yes then do:
     assign natur-oper.ind-contabilizacao:checked in frame {&frame-name} = yes.
     disable natur-oper.ind-contabilizacao with frame {&frame-name}.
     if natur-oper.calc-auto:checked in frame {&frame-name} = yes then
        enable natur-oper.auto-ct  with frame {&frame-name}.
 end. */
 
 if i-tipo = 2 or i-tipo = 3 then do:
    if natur-oper.emite-duplic:checked in frame {&frame-name} = yes then do: 
       assign natur-oper.ind-contabilizacao:checked   in frame {&frame-name} = yes
              natur-oper.ind-contabilizacao:sensitive in frame {&frame-name} = no.
    end.                      
    else do:
       assign natur-oper.ind-contabilizacao:checked   in frame {&frame-name} = no
              natur-oper.ind-contabilizacao:sensitive in frame {&frame-name} = yes.  
    end.             
 end.
 else do:
    if natur-oper.emite-duplic:checked in frame {&frame-name} = yes then do: 
       assign natur-oper.ind-contabilizacao:sensitive in frame {&frame-name} = yes.
       apply 'value-changed' to natur-oper.ind-contabilizacao in frame {&frame-name}.
    end.
    else do:
      assign natur-oper.ind-contabilizacao:sensitive in frame {&frame-name} = no
             natur-oper.ind-contabilizacao:checked   in frame {&frame-name} = no.
      apply 'value-changed' to natur-oper.ind-contabilizacao in frame {&frame-name}.

    end.
 end. 
 if  natur-oper.calc-auto:checked in frame {&frame-name} = yes
 and natur-oper.emite-duplic:checked in frame {&frame-name} = yes then 
     enable natur-oper.auto-cr  with frame {&frame-name}.
 else do:
     assign natur-oper.auto-cr:checked = no.
     disable natur-oper.auto-cr with frame {&frame-name}.   
 end.
 
 if  natur-oper.emite-duplic:checked in frame {&frame-name} = no then do:
     assign natur-oper.tp-rec-desp:screen-value = "0".
     disable natur-oper.tp-rec-desp with frame {&frame-name}. 
     assign natur-oper.cod-esp:screen-value     = "".
     disable natur-oper.cod-esp     with frame {&frame-name}. 
 end.         
 else do:
     enable natur-oper.tp-rec-desp with frame {&frame-name}.    
     enable natur-oper.cod-esp     with frame {&frame-name}.
 end.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.ind-contabilizacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.ind-contabilizacao V-table-Win
ON VALUE-CHANGED OF natur-oper.ind-contabilizacao IN FRAME f-main /* Gera Contabiliza‡Æo */
DO:
  
 if  natur-oper.calc-auto:checked          in frame {&frame-name} = yes
 and natur-oper.ind-contabilizacao:checked in frame {&frame-name} = yes then 
     enable natur-oper.auto-ct  with frame {&frame-name}.
 else do:
     assign natur-oper.auto-ct:checked = no.
     disable natur-oper.auto-ct with frame {&frame-name}.   
 end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.ind-entfut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.ind-entfut V-table-Win
ON VALUE-CHANGED OF natur-oper.ind-entfut IN FRAME f-main /* Entrega Futura */
DO:
  
  if input frame {&frame-name} natur-oper.ind-entfut = yes then do:
     assign natur-oper.baixa-estoq:checked = no.
     disable natur-oper.baixa-estoq with frame {&frame-name}.
     assign natur-oper.auto-ce:checked = no.
     disable natur-oper.auto-ce with frame {&frame-name}.
     assign natur-oper.ind-est-qtd:checked = no.
     disable natur-oper.ind-est-qtd with frame {&frame-name}.
     assign natur-oper.emite-duplic:checked = yes .
     apply 'value-changed' to natur-oper.baixa-estoq in frame {&frame-name}.
     apply 'value-changed' to natur-oper.emite-duplic in frame {&frame-name}.  
  
  
  end.
  else
     enable natur-oper.ind-est-qtd with frame {&frame-name}.



  if input frame {&frame-name} natur-oper.ind-entfut = no and
     param-global.modulo-ce = yes then 
     enable natur-oper.baixa-estoq with frame {&frame-name}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.ind-est-qtd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.ind-est-qtd V-table-Win
ON VALUE-CHANGED OF natur-oper.ind-est-qtd IN FRAME f-main
DO:

  if input frame {&frame-name} natur-oper.ind-est-qtd = yes then do:
     assign natur-oper.ind-entfut:checked   = no
            natur-oper.baixa-estoq:checked  = yes
            natur-oper.emite-duplic:checked = no.
     disable natur-oper.ind-entfut with frame {&frame-name}.
     apply 'value-changed' to natur-oper.baixa-estoq in frame {&frame-name}.
     apply 'value-changed' to natur-oper.emite-duplic in frame {&frame-name}.
     
  end.

  if input frame {&frame-name} natur-oper.ind-est-qtd = no then do:
     enable natur-oper.ind-entfut with frame {&frame-name}.
     assign natur-oper.baixa-estoq:checked  = no. 
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME natur-oper.tp-rec-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.tp-rec-desp V-table-Win
ON F5 OF natur-oper.tp-rec-desp IN FRAME f-main /* Tipo Despesa/Receita */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom= "adzoom/z01ad259.w"
                     &campo= natur-oper.tp-rec-desp
                     &campozoom= tp-codigo} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL natur-oper.tp-rec-desp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF natur-oper.tp-rec-desp IN FRAME f-main /* Tipo Despesa/Receita */
DO:
  apply "f5" to self.
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

  /* Code placed here will execute PRIOR to standard behavior. */
  
   {utp/ut-liter.i Remessa_Entrega_Futura * r}
   assign natur-oper.ind-est-qtd:label in frame {&frame-name} = RETURN-VALUE.
  
  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  
  if  i-ep-codigo-usuario = &IF "{&mguni_version}" >= "2.071" &THEN "1" &ELSE 1 &ENDIF  then do:
     assign natur-oper.usa-pick:checked in frame {&frame-name} = no.
     disable natur-oper.usa-pick with frame {&frame-name}.
 end.            

  
  assign i-tipo = 1. /* Ao incluir um reg novo o prog considerava o tipo
                        da natureza anterior. Esta foi a forma encontrada
                        p/ inicializar i campo tipo */
                         
  if  input frame {&frame-name} natur-oper.emite-duplic = yes then do:
      enable natur-oper.tp-rec-desp with frame {&frame-name}.
      enable natur-oper.cod-esp     with frame {&frame-name}.
  end.
  else do:    
      assign natur-oper.tp-rec-desp:screen-value = "0".
      disable natur-oper.tp-rec-desp with frame {&frame-name}.
      assign natur-oper.cod-esp:screen-value     = "".
      disable natur-oper.cod-esp with frame {&frame-name}.     
  end.

 if  natur-oper.calc-auto:checked in frame {&frame-name} = no then do:
     assign natur-oper.auto-cr:checked = no.
     disable natur-oper.auto-cr with frame {&frame-name}.
     assign natur-oper.auto-ct:checked = no.
     disable natur-oper.auto-ct with frame {&frame-name}.
     assign natur-oper.auto-est:checked = no.
     disable natur-oper.auto-est with frame {&frame-name}.
     assign natur-oper.auto-ce:checked = no.
     disable natur-oper.auto-ce with frame {&frame-name}.
 end.       
 else do:
     if natur-oper.emite-duplic:checked in frame {&frame-name} = yes then     
        enable natur-oper.auto-cr  with frame {&frame-name}.
     if natur-oper.ind-contabilizacao:checked in frame {&frame-name} = yes then 
        enable natur-oper.auto-ct  with frame {&frame-name}.
     if natur-oper.atual-estat:checked in frame {&frame-name} = yes then
        enable natur-oper.auto-est with frame {&frame-name}.
     if natur-oper.ind-entfut:checked in frame {&frame-name} = no then    
        if natur-oper.baixa-estoq:checked in frame {&frame-name} = yes then 
           enable natur-oper.auto-ce with frame {&frame-name}.
        else do:
           assign natur-oper.auto-ce:checked = no.
           disable natur-oper.auto-ce with frame {&frame-name}.
        end.
     else do:
        assign natur-oper.auto-ce:checked = no.
        disable natur-oper.auto-ce with frame {&frame-name}.
     end.
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
def var c-narrativa as char.

  /* Code placed here will execute PRIOR to standard behavior. */

RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT This-procedure,
     INPUT "EDITOR_Narrativa").
     
Assign c-narrativa = return-value.

  {include/i-valid.i}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
 assign natur-oper.narrativa = c-narrativa.
 
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
   define variable l-exporta as logical no-undo.
 
  assign i-cod-mensagem = input frame {&frame-name} natur-oper.cod-mensagem.
  
  RUN get-attribute ('ADM-NEW-RECORD'). /* Retorna yes se for uma inclusÆo */
  if return-value = "no" then do: 
     if natur-oper.cod-mensagem <> i-cod-mensagem then do:
        run cdp/cd0604a.w (output l-exporta).
        if l-exporta = yes then do:
           if session:set-wait-state ("general") then.
           for each ped-venda use-index ch-natoper
               where ped-venda.cod-sit-ped < 3
               and   ped-venda.nat-oper = natur-oper.nat-operacao exclusive-lock:
               assign ped-venda.cod-mensagem = i-cod-mensagem. /* natur-oper.cod-mensagem. */ 
           end.
           if session:set-wait-state ("") then.       
        end.
     end.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
  
   if natur-oper.ind-entfut then do:
     assign natur-oper.baixa-estoq = no.
     disable natur-oper.baixa-estoq with frame {&frame-name}.
     assign natur-oper.auto-ce = no.
     disable natur-oper.auto-ce with frame {&frame-name}.
  end.
   
 /* if input frame {&frame-name} natur-oper.emite-duplic = yes 
  and input frame {&frame-name} natur-oper.ind-contabilizacao:sensitive = yes then do:
     assign natur-oper.ind-contabilizacao:checked = yes.
     disable natur-oper.ind-contabilizacao with frame {&frame-name}.
  end.*/

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
  
if  avail natur-oper then do:
   find first canal-venda where canal-venda.cod-canal-venda = input frame {&frame-name} natur-oper.cod-canal-venda no-lock no-error.
   
    if  avail canal-venda then
        assign c-descricao-cv:screen-value = canal-venda.descricao.
    else
        assign c-descricao-cv:screen-value = ''.
end.

   {utp/ut-liter.i Remessa_Entrega_Futura * r}
   assign natur-oper.ind-est-qtd:label in frame {&frame-name} = RETURN-VALUE.
    

    
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
  
  if  i-ep-codigo-usuario = &IF "{&mguni_version}" >= "2.071" &THEN "1" &ELSE 1 &ENDIF  then do:
      assign natur-oper.usa-pick:checked in frame {&frame-name} = no.
      disable natur-oper.usa-pick with frame {&frame-name}.
  end.    
  
  
  find first param-global no-lock no-error.
  if param-global.modulo-ce = no then do:
     assign natur-oper.baixa-estoq:checked in frame {&frame-name} = no. 
     disable natur-oper.baixa-estoq with frame {&frame-name}.
     assign natur-oper.auto-ce = no.
     disable natur-oper.auto-ce with frame {&frame-name}.
  end.

  if  input frame {&frame-name} natur-oper.emite-duplic = yes then do:
      enable natur-oper.tp-rec-desp with frame {&frame-name}.
      enable natur-oper.cod-esp     with frame {&frame-name}.
  end.
  else do:    
      assign natur-oper.tp-rec-desp:screen-value = "0".
      disable natur-oper.tp-rec-desp with frame {&frame-name}.
      assign natur-oper.cod-esp:screen-value     = "".
      disable natur-oper.cod-esp with frame {&frame-name}.     
  end. 
  
  if natur-oper.emite-duplic:checked in frame {&frame-name} = yes then     
     enable natur-oper.auto-cr  with frame {&frame-name}.
  else do:
     assign natur-oper.ind-contabilizacao:checked = no.
     disable natur-oper.ind-contabilizacao with frame {&frame-name}.
     assign natur-oper.auto-ct:checked = no.
     disable natur-oper.auto-ct with frame {&frame-name}.
     assign natur-oper.auto-cr:checked = no.
     disable natur-oper.auto-cr with frame {&frame-name}. 
  end.     
  if natur-oper.ind-contabilizacao:checked in frame {&frame-name} = yes then
     enable natur-oper.auto-ct  with frame {&frame-name}.
  else do:
     assign natur-oper.auto-ct:checked = no.
     disable natur-oper.auto-ct with frame {&frame-name}.
  end.   
  if natur-oper.atual-estat:checked in frame {&frame-name} = yes then
     enable natur-oper.auto-est with frame {&frame-name}.
  else do:
     assign natur-oper.auto-est:checked = no.
     disable natur-oper.auto-est with frame {&frame-name}.
  end.   
  if natur-oper.ind-entfut:checked in frame {&frame-name} = no then    
     if natur-oper.baixa-estoq:checked in frame {&frame-name} = yes then 
        enable natur-oper.auto-ce with frame {&frame-name}.
     else do:
        assign natur-oper.auto-ce:checked = no.
        disable natur-oper.auto-ce with frame {&frame-name}.
     end.
  else do:
     assign natur-oper.auto-ce:checked = no.
     disable natur-oper.auto-ce with frame {&frame-name}.
  end.           

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  if natur-oper.cod-mensagem:load-mouse-pointer    ("image~\lupa.cur") in frame {&frame-name} then.
  if natur-oper.tp-rec-desp:load-mouse-pointer     ("image~\lupa.cur") in frame {&frame-name} then.
  if natur-oper.cod-esp:load-mouse-pointer         ("image~\lupa.cur") in frame {&frame-name} then.
  if natur-oper.cod-canal-venda:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
 
  run pi-habilita-ind-cont.      
        
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

   {utp/ut-liter.i Remessa_Entrega_Futura * r}
   assign natur-oper.ind-est-qtd:label in frame {&frame-name} = RETURN-VALUE.

   {utp/ut-liter.i Atualiza_Obrig_Fiscais_Automatic. * r}
   assign natur-oper.atualiza-of:label in frame {&FRAME-NAME} = RETURN-VALUE.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialized V-table-Win 
PROCEDURE local-initialized :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
 
  /* Dispatch standard ADM method.                             */
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialized':U ) .
 
   /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-duplic V-table-Win 
PROCEDURE pi-habilita-duplic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param c-tipo as char no-undo.

assign i-tipo = integer(c-tipo).

apply "value-changed" to natur-oper.emite-duplic in frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-ind-cont V-table-Win 
PROCEDURE pi-habilita-ind-cont :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT THIS-PROCEDURE,
     INPUT "TIPO").

if return-value = "1" then do:  
   disable natur-oper.ind-contabilizacao with frame {&frame-name}.
   assign natur-oper.ind-contabilizacao:checked in frame {&frame-name} = no.
   disable natur-oper.auto-ct with frame {&frame-name}.
   assign natur-oper.auto-ct:checked in frame {&frame-name} = no.
end.
else do:
    /* if  natur-oper.emite-duplic:checked in frame {&frame-name} = yes then do:
       assign natur-oper.ind-contabilizacao:checked in frame {&frame-name} = yes.
       disable natur-oper.ind-contabilizacao with frame {&frame-name}.
     end. 
     else enable natur-oper.ind-contabilizacao with frame {&frame-name}. */
     if  natur-oper.calc-auto:checked in frame {&frame-name} = yes then
         enable natur-oper.auto-ct  with frame {&frame-name}.
end. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-entfut V-table-Win 
PROCEDURE pi-trata-entfut :
/* A CHAMADA DESSA PI ( STATE CHANGED ) FOI COMENTADA */


/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* £nico lugar p/ por a l¢gica abaixo, pois em enable-fields, depois de uma modifica‡Æo,
   estava-se guardando o vlr do l-ped-abe ao incluir um novo registro.  */
 
 /* find first ped-venda   where ped-venda.nat-operacao = natur-oper.nat-operacao
 *                            and ped-venda.cod-sit-ped < 4
 *                            and ped-venda.cod-sit-ped <> 2 no-error.
 *   find first nota-fiscal where nota-fiscal.nat-operacao = natur-oper.nat-operacao
 *                            and nota-fiscal.ind-sit-nota < 6 no-error.
 *   assign l-ped-abe = if avail ped-venda or avail nota-fiscal then yes
 *                                                              else no.
 *   if  l-ped-abe = yes then 
 *       disable natur-oper.ind-entfut with frame {&frame-name}.
 *   else 
 *       enable natur-oper.ind-entfut with frame {&frame-name}.      */
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

 {include/i-vldfrm.i}

 RUN get-link-handle IN adm-broker-hdl
     (INPUT this-procedure ,
      INPUT "variavel-source" ,
      OUTPUT c-handle ).  
 run pi-apply-tipo in widget-handle (c-handle).
   
 if natur-oper.emite-duplic:checked in frame {&frame-name} = yes then do:
    find first tipo-rec-desp where
               tipo-rec-desp.tp-codigo = input frame {&frame-name} natur-oper.tp-rec-desp no-lock no-error.
    if not avail tipo-rec-desp then do: 
       {include/i-vldprg.i}   
       {utp/ut-table.i mgind natur-oper 1}
        run utp/ut-msgs.p (input "show",
                           input 3879,
                           input return-value).
        apply 'entry' to natur-oper.tp-rec-desp.                   
        return 'adm-error'.  
    end.           
    if avail tipo-rec-desp then do:    
       if integer(i-tipo) = 1 then do:
          if tipo-rec-desp.tipo = 1 then do:
             {include/i-vldprg.i}      
             {utp/ut-table.i mgind natur-oper 1}
             run utp/ut-msgs.p (input "show",
                                input 414,
                                input return-value).
             apply 'entry' to natur-oper.tp-rec-desp.                   
             return 'adm-error'. 
          end.
       end.   
       else do:
          if integer(i-tipo) <> 1 then do:
             if tipo-rec-desp.tipo <> 1 then do: 
                {include/i-vldprg.i}   
                {utp/ut-table.i mgind natur-oper 1}
                run utp/ut-msgs.p (input "show",
                                   input 415,
                                   input return-value).
                apply 'entry' to natur-oper.tp-rec-desp.                   
                return 'adm-error'.  
             end.
          end.
       end.
    end.
 end.   


if input frame {&frame-name} natur-oper.cod-esp = "" and i-pais-impto-usuario = 1 then.
else do:
    if natur-oper.emite-duplic:checked in frame {&frame-name} = yes then do:
      find esp-doc where esp-doc.cod-esp = input frame {&frame-name} natur-oper.cod-esp no-lock no-error.
      if  not avail esp-doc  then do:
          {include/i-vldprg.i}   
          {utp/ut-table.i mgind natur-oper 1}
           run utp/ut-msgs.p (input "show",
                              input 5921,
                              input return-value).
           apply 'entry' to natur-oper.cod-esp.
           return 'adm-error'.  
      end.                   
      if  avail esp-doc then do:
          if  esp-doc.tipo = 6
          or  esp-doc.tipo = 3 then do:       
              {include/i-vldprg.i}   
              {utp/ut-table.i mgind natur-oper 1}
               run utp/ut-msgs.p (input "show",
                                  input 3899,
                                  input return-value).
               apply 'entry' to natur-oper.cod-esp.                   
               return 'adm-error'.  
          end. 
          if  (esp-doc.tipo = 4 or esp-doc.tipo = 5)
          and esp-doc.esp-ligacao = "" then do: 
              {include/i-vldprg.i}   
              {utp/ut-table.i mgind natur-oper 1}
               run utp/ut-msgs.p (input "show",
                                  input 3900,
                                  input return-value).
               apply 'entry' to natur-oper.cod-esp.                   
               return 'adm-error'.  
          end. 
          if  esp-doc.tipo = 1 then do:
              find first b-esp-doc where b-esp-doc.esp-ligacao = esp-doc.cod-esp no-lock no-error.
              if avail b-esp-doc then do:
                 {include/i-vldprg.i}   
                 {utp/ut-table.i mgind natur-oper 1}
                  run utp/ut-msgs.p (input "show",
                                     input 3901,
                                     input return-value).
                  apply 'entry' to natur-oper.cod-esp.                   
                  return 'adm-error'.  
              end.   
          end. 
      end.    
    end.
end.

find first mensagem where mensagem.cod-mensagem = input frame {&frame-name} natur-oper.cod-mensagem no-lock no-error.
if not avail mensagem                                     and
   input frame {&frame-name} natur-oper.cod-mensagem <> 0 and
   input frame {&frame-name} natur-oper.cod-mensagem <> ? then do:
   {include/i-vldprg.i}   
   {utp/ut-field.i mgadm mensagem cod-mensagem 1}
    run utp/ut-msgs.p (input "show",
                       input 56,
                       input return-value).
    apply 'entry' to natur-oper.cod-mensagem.                   
    return 'adm-error'.  
end.    

find first canal-venda where canal-venda.cod-canal-venda = input frame {&frame-name} natur-oper.cod-canal-venda
     no-lock no-error.

if not avail canal-venda and input frame {&frame-name} natur-oper.cod-canal-venda <> 0 then do:
   {include/i-vldprg.i}   
   {utp/ut-table.i mgdis canal-venda 1}
    run utp/ut-msgs.p (input "show",
                       input 2,
                       input return-value).
    apply 'entry' to natur-oper.cod-canal-venda.                   
    return 'adm-error'.  
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

  if natur-oper.cod-mensagem:load-mouse-pointer    ("image~\lupa.cur") in frame {&frame-name} then.
  if natur-oper.tp-rec-desp:load-mouse-pointer     ("image~\lupa.cur") in frame {&frame-name} then.
  if natur-oper.cod-esp:load-mouse-pointer         ("image~\lupa.cur") in frame {&frame-name} then.
  if natur-oper.cod-canal-venda:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
 
/*  if p-state = "update-begin" then   /* FOI COMENTANDO ESSA LàGICA, POIS ESTµ INCORRETA */
 *      run pi-trata-entfut.*/
     
     
  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


