&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgmov            PROGRESS
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
{include/i-prgvrs.i V14IN218 2.00.00.008 } /*** "010008" 09/01/2026 14:41:41  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v14in218 MUT}
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

def buffer b-saldo for saldo-estoq.

def var de-aux-1    as decimal decimals 2 no-undo.
def var de-aux-2    as decimal decimals 2 no-undo.
def var l-entrada   as logical.
def var l-resposta  as logical.
def var i-saldo-neg as integer.

def var c-it-codigo like saldo-estoq.it-codigo.
def var c-cod-refer like saldo-estoq.cod-refer.
def var c-cod-estabel like saldo-estoq.cod-estabel.
def var c-cod-depos   like saldo-estoq.cod-depos.
def var c-lote        like saldo-estoq.lote.
def var c-cod-localiz like saldo-estoq.cod-localiz.
def var c-data-valida as date format "99/99/9999".
def var de-qtd        like movto-estoq.quantidade no-undo.
DEF VAR i-cenario     AS INT NO-UNDO.
DEF VAR c-per-geren   AS CHAR NO-UNDO.
DEF VAR l-enable      AS LOG NO-UNDO.

def var da-iniper-fech like param-estoq.ult-fech-dia no-undo.
def var da-fimper-fech like param-estoq.ult-fech-dia no-undo.
def var da-iniper-x    like param-estoq.ult-fech-dia no-undo.
def var da-fimper-x    like param-estoq.ult-fech-dia no-undo.
def var i-per-corrente as integer  no-undo.
DEF VAR da-mensal-ate  LIKE param-estoq.mensal-ate NO-UNDO.

def var dt-trans like movto-estoq.dt-trans no-undo.

def var h_v07in218 as handle.
def var h_v10in218 as handle.
def var h_v09in218 as handle.
def var h_window   as handle.
def var c-container as c.

{cep/ce1234.i}  /* Validaá∆o Decimais */
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}
{cep/ceapi001k.i7} //pi-data-per-geren

&if '{&bf_lote_avancado_liberado}' = 'yes' &then
def var h-handle        as handle no-undo.
def var h-ceapi030      as handle no-undo.
def var l-retorno       as handle no-undo.
def var l-lote-avancado as log    no-undo.

{cep/ceapi030.i}
&endif

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES movto-estoq
&Scoped-define FIRST-EXTERNAL-TABLE movto-estoq


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR movto-estoq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS movto-estoq.quantidade movto-estoq.un ~
movto-estoq.tipo-trans 
&Scoped-define ENABLED-TABLES movto-estoq
&Scoped-define FIRST-ENABLED-TABLE movto-estoq
&Scoped-Define ENABLED-OBJECTS de-val-mat2 de-val-mat3 de-val-mob2 ~
de-val-mob3 de-val-ggf2 de-val-ggf3 RECT-4 RECT-5 rt-mold 
&Scoped-Define DISPLAYED-FIELDS movto-estoq.quantidade movto-estoq.un ~
movto-estoq.tipo-trans 
&Scoped-define DISPLAYED-TABLES movto-estoq
&Scoped-define FIRST-DISPLAYED-TABLE movto-estoq
&Scoped-Define DISPLAYED-OBJECTS c-tipo-trans de-val-mat1 c-moeda ~
de-val-mat2 de-val-mat3 de-val-mob1 de-val-mob2 c-moeda1 de-val-mob3 ~
de-val-ggf1 de-val-ggf2 c-moeda2 de-val-ggf3 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS de-val-mat1 de-val-mob1 de-val-ggf1 

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
DEFINE VARIABLE c-moeda AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 10.43 BY .63 NO-UNDO.

DEFINE VARIABLE c-moeda1 AS CHARACTER FORMAT "x(20)":U 
      VIEW-AS TEXT 
     SIZE 16.29 BY .63 NO-UNDO.

DEFINE VARIABLE c-moeda2 AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 8 BY .63 NO-UNDO.

DEFINE VARIABLE c-tipo-trans AS CHARACTER FORMAT "X(18)":U 
      VIEW-AS TEXT 
     SIZE 16 BY .63 NO-UNDO.

DEFINE VARIABLE de-val-ggf1 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-ggf2 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-ggf3 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-mat1 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-mat2 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-mat3 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-mob1 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-mob2 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-mob3 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 34 BY 1.5.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83.72 BY 4.5.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 7.08.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     movto-estoq.quantidade AT ROW 1.83 COL 17.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.72 BY .88
     movto-estoq.un AT ROW 1.83 COL 39.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     c-tipo-trans AT ROW 1.33 COL 51.29 COLON-ALIGNED NO-LABEL
     movto-estoq.tipo-trans AT ROW 2.21 COL 59.72 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Entrada", 1,
"Sa°da", 2
          SIZE 23.72 BY .83
     de-val-mat1 AT ROW 4.63 COL 17.57 COLON-ALIGNED
     c-moeda AT ROW 3.58 COL 23.14 COLON-ALIGNED NO-LABEL
     de-val-mat2 AT ROW 5.63 COL 17.57 COLON-ALIGNED
     de-val-mat3 AT ROW 6.63 COL 17.57 COLON-ALIGNED
     de-val-mob1 AT ROW 4.63 COL 39.57 COLON-ALIGNED NO-LABEL
     de-val-mob2 AT ROW 5.63 COL 39.57 COLON-ALIGNED NO-LABEL
     c-moeda1 AT ROW 3.58 COL 43.29 COLON-ALIGNED NO-LABEL
     de-val-mob3 AT ROW 6.63 COL 39.57 COLON-ALIGNED NO-LABEL
     de-val-ggf1 AT ROW 4.63 COL 61.57 COLON-ALIGNED NO-LABEL
     de-val-ggf2 AT ROW 5.63 COL 61.57 COLON-ALIGNED NO-LABEL
     c-moeda2 AT ROW 3.58 COL 68.57 COLON-ALIGNED NO-LABEL
     de-val-ggf3 AT ROW 6.63 COL 61.57 COLON-ALIGNED NO-LABEL
     RECT-4 AT ROW 1.71 COL 52
     RECT-5 AT ROW 3.33 COL 2.43
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.movto-estoq
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
         HEIGHT             = 7.17
         WIDTH              = 86.14.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tipo-trans IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-ggf1 IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN de-val-mat1 IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN de-val-mob1 IN FRAME f-main
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

&Scoped-define SELF-NAME de-val-ggf1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-val-ggf1 V-table-Win
ON LEAVE OF de-val-ggf1 IN FRAME f-main
DO:
    do  with frame {&frame-name}:
        if  input frame {&frame-name} de-val-ggf1 = 0 then do with frame {&FRAME-NAME}:
            display 0 @ de-val-ggf2
                    0 @ de-val-ggf3.

            disable de-val-ggf2
                    de-val-ggf3.
        end.
        else do:

            IF i-cenario = 2 THEN DO: //gerencial

                if  param-estoq.log-tem-moed-geren-1 then do:
                    IF valid-handle(h_v09in218) THEN
                        run pi-getDt-trans in h_v09in218 (output dt-trans).
                    else
                        assign dt-trans = today.
                    enable de-val-ggf2 with frame {&frame-name}.
                    run cdp/cd0813.p (0, 1, input frame {&frame-name} de-val-ggf1,
                                            input dt-trans, output de-aux-1).
                end.
                if  param-estoq.log-tem-moed-geren-2 then do:
                    IF valid-handle(h_v09in218) THEN
                        run pi-getDt-trans in h_v09in218 (output dt-trans).
                    else
                        assign dt-trans = today.
                    enable de-val-ggf3 with frame {&frame-name}.
                    run cdp/cd0813.p (0, 2, input frame {&frame-name} de-val-ggf1,
                                            input dt-trans, output de-aux-2).
                    if  de-aux-2 <> ? then
                        assign de-val-ggf3:screen-value in frame {&frame-name} = string(de-aux-2).
                end.
                if  de-aux-1 <> ? and param-estoq.log-tem-moed-geren-1 then do:
                    assign de-val-ggf2:screen-value in frame {&frame-name} = string(de-aux-1).
                    if lookup(last-event:label, "TAB,SHIFT-TAB") <> 0 then do:
                        apply last-event:label to self.
                        return no-apply.
                    end.
                end.

            END.
            ELSE DO:
                if  param-estoq.tem-moeda1 then do:
                    IF valid-handle(h_v09in218) THEN
                        run pi-getDt-trans in h_v09in218 (output dt-trans).
                    else
                        assign dt-trans = today.
                    enable de-val-ggf2 with frame {&frame-name}.
                    run cdp/cd0813.p (0, 1, input frame {&frame-name} de-val-ggf1,
                                            input dt-trans, output de-aux-1).
                end.
                if  param-estoq.tem-moeda2 then do:
                    IF valid-handle(h_v09in218) THEN
                        run pi-getDt-trans in h_v09in218 (output dt-trans).
                    else
                        assign dt-trans = today.
                    enable de-val-ggf3 with frame {&frame-name}.
                    run cdp/cd0813.p (0, 2, input frame {&frame-name} de-val-ggf1,
                                            input dt-trans, output de-aux-2).
                    if  de-aux-2 <> ? then
                        assign de-val-ggf3:screen-value in frame {&frame-name} = string(de-aux-2).
                end.
                if  de-aux-1 <> ? and param-estoq.tem-moeda1 then do:
                    assign de-val-ggf2:screen-value in frame {&frame-name} = string(de-aux-1).
                    if lookup(last-event:label, "TAB,SHIFT-TAB") <> 0 then do:
                        apply last-event:label to self.
                        return no-apply.
                    end.
                end.
            END.

       end.

       def var v_finalidade as char format "x(256)" no-undo.
       run pi-getFinalidadeConta in h_v09in218 (output v_finalidade).
       IF valid-handle(h_v09in218) THEN
            run pi-getDt-trans in h_v09in218 (output dt-trans).
        else
            assign dt-trans = today.
       
       if  l-entrada
      /* and (conta -contab.estoque = 2 or conta -contab.estoque = 7 or conta -contab.estoque = 8) */
       and (v_finalidade = {adinc/i05ad049.i 4 2} or
            v_finalidade = {adinc/i05ad049.i 4 7} or
            v_finalidade = {adinc/i05ad049.i 4 8})
       and input frame {&frame-name} movto-estoq.tipo-trans  = 1
       and (item.data-ult-ent = ? or item.data-ult-ent < dt-trans) then do:
           assign item.data-ult-ent = dt-trans
                  item.preco-ul-ent = input frame {&frame-name} de-val-ggf1 / input frame {&frame-name} movto-estoq.quantidade.
       end.
       
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-val-ggf2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-val-ggf2 V-table-Win
ON LEAVE OF de-val-ggf2 IN FRAME f-main
DO:
    if lookup(last-event:label, "TAB,SHIFT-TAB") <> 0 then do:
        apply last-event:label to self.
        return no-apply.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-val-mat1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-val-mat1 V-table-Win
ON LEAVE OF de-val-mat1 IN FRAME f-main
DO:
    do  with frame {&frame-name}:
        if input frame {&frame-name} de-val-mat1 = 0 then do with frame {&FRAME-NAME}: 
            display 0 @ de-val-mat2
                    0 @ de-val-mat3.

            disable de-val-mat2
                    de-val-mat3.
        end.
        else do:

            IF i-cenario = 2 THEN DO: //gerencial
            
                if  param-estoq.log-tem-moed-geren-1 then do:
                    IF valid-handle(h_v09in218) THEN
                        run pi-getDt-trans in h_v09in218 (output dt-trans).
                    else
                        assign dt-trans = today.
                    enable de-val-mat2 with frame {&frame-name}.
                    run cdp/cd0813.p (0, 1, input frame {&frame-name} de-val-mat1,
                                            input dt-trans, output de-aux-1).
                end.
                if  param-estoq.log-tem-moed-geren-2 then do:
                    IF valid-handle(h_v09in218) THEN
                        run pi-getDt-trans in h_v09in218 (output dt-trans).
                    else
                        assign dt-trans = today.
                    enable de-val-mat3 with frame {&frame-name}.
                    run cdp/cd0813.p (0, 2, input frame {&frame-name} de-val-mat1,
                                            input dt-trans, output de-aux-2).
                    if  de-aux-2 <> ? then
                        assign de-val-mat3:screen-value in frame {&frame-name} = string(de-aux-2).
                end.
                if  de-aux-1 <> ? and param-estoq.log-tem-moed-geren-1 then do:
    
                    assign de-val-mat2:screen-value in frame {&frame-name} = string(de-aux-1).
    
                    if lookup(last-event:label, "TAB,SHIFT-TAB") <> 0 then do:
                        apply last-event:label to self.
                        return no-apply.
                    end.
                end.


            END.
            ELSE DO:

                if  param-estoq.tem-moeda1 then do:
                    IF valid-handle(h_v09in218) THEN
                        run pi-getDt-trans in h_v09in218 (output dt-trans).
                    else
                        assign dt-trans = today.
                    enable de-val-mat2 with frame {&frame-name}.
                    run cdp/cd0813.p (0, 1, input frame {&frame-name} de-val-mat1,
                                            input dt-trans, output de-aux-1).
                end.
                if  param-estoq.tem-moeda2 then do:
                    IF valid-handle(h_v09in218) THEN
                        run pi-getDt-trans in h_v09in218 (output dt-trans).
                    else
                        assign dt-trans = today.
                    enable de-val-mat3 with frame {&frame-name}.
                    run cdp/cd0813.p (0, 2, input frame {&frame-name} de-val-mat1,
                                            input dt-trans, output de-aux-2).
                    if  de-aux-2 <> ? then
                        assign de-val-mat3:screen-value in frame {&frame-name} = string(de-aux-2).
                end.
                if  de-aux-1 <> ? and param-estoq.tem-moeda1 then do:
    
                    assign de-val-mat2:screen-value in frame {&frame-name} = string(de-aux-1).
    
                    if lookup(last-event:label, "TAB,SHIFT-TAB") <> 0 then do:
                        apply last-event:label to self.
                        return no-apply.
                    end.
                end.


            END.

            
        end. 
        
        def var v_finalidade as char format "x(256)" no-undo.
        run pi-getFinalidadeConta in h_v09in218 (output v_finalidade).
        IF valid-handle(h_v09in218) THEN
            run pi-getDt-trans in h_v09in218 (output dt-trans).
        else
            assign dt-trans = today.
                 
        if  l-entrada
        and (v_finalidade = {adinc/i05ad049.i 4 2} or
             v_finalidade = {adinc/i05ad049.i 4 7} or
             v_finalidade = {adinc/i05ad049.i 4 8})
      /*  and (conta -contab.estoque = 2 or conta -contab.estoque = 7 or conta -contab.estoque = 8) */       
        and input frame {&frame-name} movto-estoq.tipo-trans  = 1
        and (item.data-ult-ent = ? or item.data-ult-ent < dt-trans) then do:
            assign item.data-ult-ent = dt-trans
                   item.preco-ul-ent = input frame {&frame-name} de-val-mat1 / input frame {&frame-name} movto-estoq.quantidade.
        end.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-val-mat2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-val-mat2 V-table-Win
ON LEAVE OF de-val-mat2 IN FRAME f-main
DO:
    if lookup(last-event:label, "TAB,SHIFT-TAB") <> 0 then do:
        apply last-event:label to self.
        return no-apply.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-val-mob1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-val-mob1 V-table-Win
ON LEAVE OF de-val-mob1 IN FRAME f-main
DO:
    do  with frame {&frame-name}:
        if  input frame {&frame-name} de-val-mob1 = 0 then do with frame {&FRAME-NAME}:
              display 0 @ de-val-mob2
                      0 @ de-val-mob3.

              disable de-val-mob2
                      de-val-mob3.
        end.
        else do:

            IF i-cenario = 2 THEN DO: //gerencial

                if  param-estoq.log-tem-moed-geren-1 then do:
                    IF valid-handle(h_v09in218) THEN
                        run pi-getDt-trans in h_v09in218 (output dt-trans).
                    else
                        assign dt-trans = today.
                    enable de-val-mob2 with frame {&frame-name}.
                    run cdp/cd0813.p (0, 1, input frame {&frame-name} de-val-mob1,
                                            input dt-trans, output de-aux-1).
                end.
                if  param-estoq.log-tem-moed-geren-2 then do:
                    IF valid-handle(h_v09in218) THEN
                        run pi-getDt-trans in h_v09in218 (output dt-trans).
                    else
                        assign dt-trans = today.
                    enable de-val-mob3 with frame {&frame-name}.
                    run cdp/cd0813.p (0, 2, input frame {&frame-name} de-val-mob1,
                                            input dt-trans, output de-aux-2).
                    if  de-aux-2 <> ? then
                        assign de-val-mob3:screen-value in frame {&frame-name} = string(de-aux-2).
                end.
                if  de-aux-1 <> ? and param-estoq.log-tem-moed-geren-1 then do:
                    assign de-val-mob2:screen-value in frame {&frame-name} = string(de-aux-1).
                    if lookup(last-event:label, "TAB,SHIFT-TAB") <> 0 then do:
                        apply last-event:label to self.
                        return no-apply.
                    end.
                end.

            END.
            ELSE DO:

                if  param-estoq.tem-moeda1 then do:
                    IF valid-handle(h_v09in218) THEN
                        run pi-getDt-trans in h_v09in218 (output dt-trans).
                    else
                        assign dt-trans = today.
                    enable de-val-mob2 with frame {&frame-name}.
                    run cdp/cd0813.p (0, 1, input frame {&frame-name} de-val-mob1,
                                            input dt-trans, output de-aux-1).
                end.
                if  param-estoq.tem-moeda2 then do:
                    IF valid-handle(h_v09in218) THEN
                        run pi-getDt-trans in h_v09in218 (output dt-trans).
                    else
                        assign dt-trans = today.
                    enable de-val-mob3 with frame {&frame-name}.
                    run cdp/cd0813.p (0, 2, input frame {&frame-name} de-val-mob1,
                                            input dt-trans, output de-aux-2).
                    if  de-aux-2 <> ? then
                        assign de-val-mob3:screen-value in frame {&frame-name} = string(de-aux-2).
                end.
                if  de-aux-1 <> ? and param-estoq.tem-moeda1 then do:
                    assign de-val-mob2:screen-value in frame {&frame-name} = string(de-aux-1).
                    if lookup(last-event:label, "TAB,SHIFT-TAB") <> 0 then do:
                        apply last-event:label to self.
                        return no-apply.
                    end.
                end.
                
            END.


        end.
        
        def var v_finalidade as char format "x(256)" no-undo.
        run pi-getFinalidadeConta in h_v09in218 (output v_finalidade).        
        IF valid-handle(h_v09in218) THEN
            run pi-getDt-trans in h_v09in218 (output dt-trans).
        else
            assign dt-trans = today.
        
        if  l-entrada
        and (v_finalidade = {adinc/i05ad049.i 4 2} or
             v_finalidade = {adinc/i05ad049.i 4 7} or
             v_finalidade = {adinc/i05ad049.i 4 8})
      /*  and (conta -contab.estoque = 2 or conta -contab.estoque = 7 or conta -contab.estoque = 8) */
        and input frame {&frame-name} movto-estoq.tipo-trans  = 1
        and (item.data-ult-ent = ? or item.data-ult-ent < dt-trans) then do:
            assign item.data-ult-ent = dt-trans
                   item.preco-ul-ent = input frame {&frame-name} de-val-mob1 / input frame {&frame-name} movto-estoq.quantidade.
        end.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-val-mob2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-val-mob2 V-table-Win
ON LEAVE OF de-val-mob2 IN FRAME f-main
DO:
    if lookup(last-event:label, "TAB,SHIFT-TAB") <> 0 then do:
        apply last-event:label to self.
        return no-apply.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-estoq.un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.un V-table-Win
ON F5 OF movto-estoq.un IN FRAME f-main /* Un */
DO:
  {include/zoom.i &prog-zoom="inzoom/z01in417.w"
                   &tabela=movto-estoq
                   &atributo=un}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-estoq.un V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-estoq.un IN FRAME f-main /* Un */
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

if movto-estoq.un:load-mouse-pointer ("image/lupa.cur") then.

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
  {src/adm/template/row-list.i "movto-estoq"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "movto-estoq"}

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

  {utp/ut-field.i mgind movto-estoq quantidade 1}
  assign movto-estoq.quantidade:label in frame {&frame-name} = return-value.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  {utp/ut-liter.i Tipo_Transaá∆o * L}
  assign c-tipo-trans = return-value.
  display c-tipo-trans with frame {&frame-name}.

  {utp/ut-liter.i Material * C}
  assign c-moeda = return-value.
  {utp/ut-liter.i M∆o-de-Obra * C}
  assign c-moeda1 = return-value.
  {utp/ut-liter.i GGF * C}
  assign c-moeda2 = return-value.
  display c-moeda
          c-moeda1
          c-moeda2 with frame {&frame-name}.

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

  /* Habilitar os campos corretamente */
  RUN local-display-fields.

  ASSIGN l-enable = NO.
  
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

  disable de-val-mat2
          de-val-mat3
          de-val-mob2
          de-val-mob3
          de-val-ggf2
          de-val-ggf3 with frame {&frame-name}.    


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  {utp/ut-liter.i Tipo_Transaá∆o * L}
  assign c-tipo-trans:screen-value in frame {&frame-name} = return-value. 

  {utp/ut-liter.i Material * C}
  assign c-moeda = return-value.
  {utp/ut-liter.i M∆o-de-Obra * C}
  assign c-moeda1 = return-value.
  {utp/ut-liter.i GGF * C}
  assign c-moeda2 = return-value.

  IF i-cenario = 2 THEN DO: //gerencial

      if available movto-estoq THEN DO:

          /*busca extens∆o da movto-estoq para buscar os valores do custo gerencial*/ 
          find first ext-movto-estoq
               where ext-movto-estoq.nr-transacao    = movto-estoq.nr-trans
                 and ext-movto-estoq.seq-custeio = 0 no-lock no-error. 
          IF AVAIL ext-movto-estoq THEN
              display ext-movto-estoq.val-mater[1] @ de-val-mat1
                      ext-movto-estoq.val-mater[2] @ de-val-mat2
                      ext-movto-estoq.val-mater[3] @ de-val-mat3
                      ext-movto-estoq.val-mob[1] @ de-val-mob1
                      ext-movto-estoq.val-mob[2] @ de-val-mob2
                      ext-movto-estoq.val-mob[3] @ de-val-mob3
                      ext-movto-estoq.val-ggf[1] @ de-val-ggf1
                      ext-movto-estoq.val-ggf[2] @ de-val-ggf2
                      ext-movto-estoq.val-ggf[3] @ de-val-ggf3 with frame {&frame-name}.


      END.
      
  END.
  ELSE DO:

      if available movto-estoq then  
      display movto-estoq.valor-mat-m[1] @ de-val-mat1
              movto-estoq.valor-mat-m[2] @ de-val-mat2
              movto-estoq.valor-mat-m[3] @ de-val-mat3
              movto-estoq.valor-mob-m[1] @ de-val-mob1
              movto-estoq.valor-mob-m[2] @ de-val-mob2
              movto-estoq.valor-mob-m[3] @ de-val-mob3
              movto-estoq.valor-ggf-m[1] @ de-val-ggf1
              movto-estoq.valor-ggf-m[2] @ de-val-ggf2
              movto-estoq.valor-ggf-m[3] @ de-val-ggf3 with frame {&frame-name}.

  END.

  RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT THIS-PROCEDURE,
     INPUT "it-codigo").  
   find item where 
        item.it-codigo = return-value no-lock no-error.
  /* Code placed here will execute AFTER standard behavior.    */

  clear frame {&frame-name}.

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
  
  disable de-val-mat2
          de-val-mat3
          de-val-mob2
          de-val-mob3
          de-val-ggf2
          de-val-ggf3 with frame {&frame-name}.

  ASSIGN l-enable = YES.
  
  IF i-cenario = 2 THEN
      DISABLE movto-estoq.quantidade movto-estoq.un with frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  find first param-global no-lock no-error.
  find first param-estoq no-lock no-error.
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Habilitar os campos corretamente */
  RUN local-display-fields.

  RUN pi-troca-cenario (INPUT 1).

  /* Code placed here will execute AFTER standard behavior.    */

  {utp/ut-liter.i Tipo_Transaá∆o * L}
  assign c-tipo-trans = return-value.
  {utp/ut-liter.i Material * C}
  assign c-moeda = return-value.
  {utp/ut-liter.i M∆o-de-Obra * C}
  assign c-moeda1 = return-value.
  {utp/ut-liter.i GGF * C}
  assign c-moeda2 = return-value.
  display c-tipo-trans
          c-moeda
          c-moeda1
          c-moeda2  with frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-epc V-table-Win 
PROCEDURE pi-epc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Chamada EPC para a assign record */
  {include/i-epc003.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-focu-campo V-table-Win 
PROCEDURE pi-focu-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
apply "entry" to movto-estoq.quantidade in frame {&frame-name}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-troca-cenario V-table-Win 
PROCEDURE pi-troca-cenario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

     def input param p-cenario as INT no-undo.

     ASSIGN i-cenario = p-cenario.

     IF i-cenario = 2 THEN DO: //gerencial 

          find moeda where moeda.mo-codigo = 0 no-lock no-error.
          if avail moeda then do:
             assign de-val-mat1:label in frame {&frame-name} = moeda.descricao.
          end.
        
          if param-estoq.log-tem-moed-geren-1 then do:
             find moeda where moeda.mo-codigo = param-estoq.cdn-moed-geren-1 no-lock no-error.
             if avail moeda then do:
                assign de-val-mat2:label in frame {&frame-name} = moeda.descricao.
             end.
          end.
          else do:
              assign de-val-mat2:visible in frame {&frame-name} = no.
              assign de-val-mob2:visible in frame {&frame-name} = no.
              assign de-val-ggf2:visible in frame {&frame-name} = no.
          end.
        
          if param-estoq.log-tem-moed-geren-2 then do:
             find moeda where moeda.mo-codigo = param-estoq.cdn-moed-geren-2 no-lock no-error.
             if avail moeda then do:
                assign de-val-mat3:label in frame {&frame-name} = moeda.descricao.
             end.
          end.
          else do:
              assign de-val-mat3:visible in frame {&frame-name} = no.
              assign de-val-mob3:visible in frame {&frame-name} = no.
              assign de-val-ggf3:visible in frame {&frame-name} = no.
          end.

          IF l-enable THEN DO:
              DISABLE movto-estoq.quantidade movto-estoq.un with frame {&frame-name}.
              ASSIGN movto-estoq.quantidade:SCREEN-VALUE IN FRAME {&frame-name} = "0".
          END.                                                                        
          
     END.
     ELSE DO:
    
          find moeda where moeda.mo-codigo = 0 no-lock no-error.
          if avail moeda then do:
             assign de-val-mat1:label in frame {&frame-name} = moeda.descricao.
          end.
        
          if param-estoq.tem-moeda1 then do:
             find moeda where moeda.mo-codigo = param-estoq.moeda1 no-lock no-error.
             if avail moeda then do:
                assign de-val-mat2:label in frame {&frame-name} = moeda.descricao.
             end.
          end.
          else do:
              assign de-val-mat2:visible in frame {&frame-name} = no.
              assign de-val-mob2:visible in frame {&frame-name} = no.
              assign de-val-ggf2:visible in frame {&frame-name} = no.
          end.
        
          if param-estoq.tem-moeda2 then do:
             find moeda where moeda.mo-codigo = param-estoq.moeda2 no-lock no-error.
             if avail moeda then do:
                assign de-val-mat3:label in frame {&frame-name} = moeda.descricao.
             end.
          end.
          else do:
              assign de-val-mat3:visible in frame {&frame-name} = no.
              assign de-val-mob3:visible in frame {&frame-name} = no.
              assign de-val-ggf3:visible in frame {&frame-name} = no.
          end.
          
          IF l-enable THEN
              ENABLE movto-estoq.quantidade movto-estoq.un WITH frame {&frame-name}.

     END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-getTipo-trans V-table-Win 
PROCEDURE pi-getTipo-trans :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  def output parameter p-tipo-trans like movto-estoq.tipo-trans no-undo.
  
  assign p-tipo-trans = input frame {&frame-name} movto-estoq.tipo-trans.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita V-table-Win 
PROCEDURE pi-habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-un V-table-Win 
PROCEDURE pi-mostra-un :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input param c-item-cod as char no-undo.

  &if defined(bf_dis_default_UN) &then
      find first param-mat no-lock no-error.
        if avail param-mat
            and param-mat.ind-sit-un = 2 then do:
            {include/leave.i &tabela=item
                           &atributo-ref=un
                           &variavel-ref=movto-estoq.un
                           &where="item.it-codigo = c-item-cod"}
        end.
  &endif   


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-handle V-table-Win 
PROCEDURE pi-passa-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-handle1 as handle.
def input param p-handle2 as handle.
def input param p-handle3 as handle.
def input param p-handle4 as handle.

assign h_v07in218 = p-handle1
       h_v09in218 = p-handle2
       h_v10in218 = p-handle3
       h_window   = p-handle4.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-item V-table-Win 
PROCEDURE pi-passa-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter rw-it-codigo as rowid no-undo.

find item where
     rowid(item) = rw-it-codigo no-lock no-error.
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
  /* Chamada EPC para a pi-validate */
  {include/i-epc002.i}

   /*Segue um exemplo de validaá∆o de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/

 RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT THIS-PROCEDURE,
     INPUT "cod-estabel").
 assign c-cod-estabel   = return-value.


 /* Validaá∆o Casas Decimais */

 IF i-cenario = 2 THEN DO: //gerencial 

     assign l-rejeita-dec = no
        de-val-mat1:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-val-mat1, 0 ) )
        de-val-mat2:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-val-mat2, param-estoq.cdn-moed-geren-1 ))
        de-val-mat3:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-val-mat3, param-estoq.cdn-moed-geren-2 ))

        de-val-mob1:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-val-mob1, 0 ))
        de-val-mob2:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-val-mob2, param-estoq.cdn-moed-geren-1 ))
        de-val-mob3:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-val-mob3, param-estoq.cdn-moed-geren-2 ))

        de-val-ggf1:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-val-ggf1, 0 ))
        de-val-ggf2:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-val-ggf2, param-estoq.cdn-moed-geren-1 ))
        de-val-ggf3:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-val-ggf3, param-estoq.cdn-moed-geren-2 )).
     
     if  l-rejeita-dec then do:
         run utp/ut-msgs.p (input "show":U, 
                            input 18100, 
                            input " ").
         return 'ADM-ERROR':U.        
     end.
    
    
    
     if  input frame {&frame-name} movto-estoq.quantidade > 0 and
         input frame {&frame-name} de-val-mat2 = 0 and 
         input frame {&frame-name} de-val-mat1 > 0 and 
         param-estoq.log-tem-moed-geren-1 then do:
        {include/i-vldprg.i}
         run utp/ut-msgs.p (input "show":U, 
                            input 1802,
                            input "2").
         apply "entry" to de-val-mat2 in frame {&frame-name}.
         return 'ADM-ERROR':U.      
     end.     
     if input frame {&frame-name} movto-estoq.quantidade > 0 and
         input frame {&frame-name} de-val-mat3 = 0 and 
         input frame {&frame-name} de-val-mat1 > 0 and 
         param-estoq.log-tem-moed-geren-2 then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U, 
                           input 1802, 
                           input "3").
        apply "entry" to de-val-mat3 in frame {&frame-name}.                       
        return 'ADM-ERROR':U.                            
     end. 
    
     if input frame {&frame-name} movto-estoq.quantidade > 0 and
        input frame {&frame-name} de-val-mob2 = 0 and 
        input frame {&frame-name} de-val-mob1 > 0 and 
         param-estoq.log-tem-moed-geren-1 then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U, 
                           input 1803, 
                           input "2").
        apply "entry" to de-val-mob2 in frame {&frame-name}.                       
        return 'ADM-ERROR':U.                            
     end.
     if input frame {&frame-name} movto-estoq.quantidade > 0 and
        input frame {&frame-name} de-val-mob3 = 0 and 
        input frame {&frame-name} de-val-mob1 > 0 and 
         param-estoq.log-tem-moed-geren-2 then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U, 
                           input 1803, 
                           input "3").
        apply "entry" to de-val-mob3 in frame {&frame-name}.                   
        return 'ADM-ERROR':U.                            
     end. 
    
     if  input frame {&frame-name} movto-estoq.quantidade > 0 and
         input frame {&frame-name} de-val-ggf2 = 0 and 
         input frame {&frame-name} de-val-ggf1 > 0 and 
         param-estoq.log-tem-moed-geren-1 then do:
        {include/i-vldprg.i}
         run utp/ut-msgs.p (input "show":U, 
                            input 6431,
                            input "2").
         apply "entry" to de-val-ggf2 in frame {&frame-name}.
         return 'ADM-ERROR':U.                            
     end.     
     if  input frame {&frame-name} movto-estoq.quantidade > 0 and
         input frame {&frame-name} de-val-ggf3 = 0 and 
         input frame {&frame-name} de-val-ggf1 > 0 and 
         param-estoq.log-tem-moed-geren-2 then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U, 
                           input 6431, 
                           input "3").
        apply "entry" to de-val-ggf3 in frame {&frame-name}.                       
        return 'ADM-ERROR':U.                            
     end. 

     run pi-getDt-trans in h_v09in218 (output dt-trans).

     IF input frame {&frame-name} movto-estoq.quantidade > 0 THEN DO:

        IF PARAM-estoq.tp-fech = 1 THEN DO:
            RUN pi-data-per-geren(INPUT  param-estoq.cod-cenar-geren,
                                  INPUT  param-estoq.dat-fechto-geren,
                                  OUTPUT c-per-geren).
            
            RUN cdp/cdapi3020.p ( INPUT  param-estoq.cod-cenar-geren,
                                  INPUT  INT(SUBSTR(c-per-geren,1,4)),
                                  INPUT  param-estoq.num-ult-fechto-geren,
                                  OUTPUT i-per-corrente,   /* 1o periodo aberto */
                                  OUTPUT da-iniper-x,      /* Dt Ini - 1o periodo aberto */
                                  OUTPUT da-fimper-x,      /* Dt Fim - 1o periodo aberto */
                                  OUTPUT da-iniper-fech,   /* Dt Ini - ult per fechado   */
                                  OUTPUT da-fimper-fech ). /* Dt Fim - Ult per fechado   */

            ASSIGN da-mensal-ate = param-estoq.mensal-ate.
        END.
        ELSE DO:

            for first estab-mat FIELDS(cod-estabel ult-per-fech dat-fechto-geren num-ult-fechto-geren mensal-ate) 
		        where estab-mat.cod-estabel = c-cod-estabel no-lock: end.

            RUN pi-data-per-geren(INPUT  param-estoq.cod-cenar-geren,
                                  INPUT  estab-mat.dat-fechto-geren,
                                  OUTPUT c-per-geren).
            
            RUN cdp/cdapi3020.p ( INPUT  param-estoq.cod-cenar-geren,
                                  INPUT  INT(SUBSTR(c-per-geren,1,4)),
                                  INPUT  estab-mat.num-ult-fechto-geren,
                                  OUTPUT i-per-corrente,   /* 1o periodo aberto */
                                  OUTPUT da-iniper-x,      /* Dt Ini - 1o periodo aberto */
                                  OUTPUT da-fimper-x,      /* Dt Fim - 1o periodo aberto */
                                  OUTPUT da-iniper-fech,   /* Dt Ini - ult per fechado   */
                                  OUTPUT da-fimper-fech ). /* Dt Fim - Ult per fechado   */

            ASSIGN da-mensal-ate = estab-mat.mensal-ate.

        END.

        IF dt-trans <= da-mensal-ate OR dt-trans < da-iniper-x THEN DO:

            //N∆o Ç permitido movimento de quantidade para a data informada 
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show":U, 
                               input 57063, 
                               input dt-trans).
            return 'ADM-ERROR':U.    

        END.

     END.


 END.
 ELSE DO:
        
     assign l-rejeita-dec = no
        de-val-mat1:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-val-mat1, 0 ) )
        de-val-mat2:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-val-mat2, param-estoq.moeda1 ))
        de-val-mat3:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-val-mat3, param-estoq.moeda2 ))

        de-val-mob1:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-val-mob1, 0 ))
        de-val-mob2:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-val-mob2, param-estoq.moeda1 ))
        de-val-mob3:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-val-mob3, param-estoq.moeda2 ))

        de-val-ggf1:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-val-ggf1, 0 ))
        de-val-ggf2:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-val-ggf2, param-estoq.moeda1 ))
        de-val-ggf3:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-val-ggf3, param-estoq.moeda2 )).


     if  l-rejeita-dec then do:
         run utp/ut-msgs.p (input "show":U, 
                            input 18100, 
                            input " ").
         return 'ADM-ERROR':U.        
     end.
    
    
    
     if  input frame {&frame-name} movto-estoq.quantidade > 0 and
         input frame {&frame-name} de-val-mat2 = 0 and 
         input frame {&frame-name} de-val-mat1 > 0 and 
         param-estoq.tem-moeda1 then do:
        {include/i-vldprg.i}
         run utp/ut-msgs.p (input "show":U, 
                            input 1802,
                            input "2").
         apply "entry" to de-val-mat2 in frame {&frame-name}.
         return 'ADM-ERROR':U.      
     end.     
     if input frame {&frame-name} movto-estoq.quantidade > 0 and
         input frame {&frame-name} de-val-mat3 = 0 and 
         input frame {&frame-name} de-val-mat1 > 0 and 
         param-estoq.tem-moeda2 then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U, 
                           input 1802, 
                           input "3").
        apply "entry" to de-val-mat3 in frame {&frame-name}.                       
        return 'ADM-ERROR':U.                            
     end. 
    
     if input frame {&frame-name} movto-estoq.quantidade > 0 and
        input frame {&frame-name} de-val-mob2 = 0 and 
        input frame {&frame-name} de-val-mob1 > 0 and 
         param-estoq.tem-moeda1 then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U, 
                           input 1803, 
                           input "2").
        apply "entry" to de-val-mob2 in frame {&frame-name}.                       
        return 'ADM-ERROR':U.                            
     end.
     if input frame {&frame-name} movto-estoq.quantidade > 0 and
        input frame {&frame-name} de-val-mob3 = 0 and 
        input frame {&frame-name} de-val-mob1 > 0 and 
         param-estoq.tem-moeda2 then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U, 
                           input 1803, 
                           input "3").
        apply "entry" to de-val-mob3 in frame {&frame-name}.                   
        return 'ADM-ERROR':U.                            
     end. 
    
     if  input frame {&frame-name} movto-estoq.quantidade > 0 and
         input frame {&frame-name} de-val-ggf2 = 0 and 
         input frame {&frame-name} de-val-ggf1 > 0 and 
         param-estoq.tem-moeda1 then do:
        {include/i-vldprg.i}
         run utp/ut-msgs.p (input "show":U, 
                            input 6431,
                            input "2").
         apply "entry" to de-val-ggf2 in frame {&frame-name}.
         return 'ADM-ERROR':U.                            
     end.     
     if  input frame {&frame-name} movto-estoq.quantidade > 0 and
         input frame {&frame-name} de-val-ggf3 = 0 and 
         input frame {&frame-name} de-val-ggf1 > 0 and 
         param-estoq.tem-moeda2 then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U, 
                           input 6431, 
                           input "3").
        apply "entry" to de-val-ggf3 in frame {&frame-name}.                       
        return 'ADM-ERROR':U.                            
     end. 

 END.
 
 if input frame {&frame-name} de-val-mat1 <= 0 and
    input frame {&frame-name} de-val-mob1 <= 0 and
    input frame {&frame-name} de-val-ggf1 <= 0 and
    input frame {&frame-name} movto-estoq.quantidade   <= 0  then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show":U, 
                       input 1811, 
                       input "3").
    return 'ADM-ERROR':U.        
 end.

 if input frame {&frame-name} movto-estoq.quantidade < 0 then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show":U, 
                       input 1790, 
                       input return-value).
    apply "entry" to movto-estoq.quantidade in frame {&frame-name}.                       
    return 'ADM-ERROR':U.  
 end.      

 def var v_finalidade as char format "x(256)" no-undo.
 run pi-getFinalidadeConta in h_v09in218 (output v_finalidade).

 if l-entrada and input frame {&frame-name} movto-estoq.tipo-trans = 1 and
                  input frame {&frame-name} movto-estoq.quantidade = 0 and
                  (v_finalidade = {adinc/i05ad049.i 4 2} or
                   v_finalidade = {adinc/i05ad049.i 4 7} or
                   v_finalidade = {adinc/i05ad049.i 4 8}) then do:
                 /* (conta -contab.estoque = 2 or conta -contab.estoque = 7 or conta -contab.estoque = 8)  then do: */
    {include/i-vldprg.i}
     run utp/ut-msgs.p (input "show":U, 
                        input 1791, 
                        input return-value).
     apply "entry" to movto-estoq.quantidade in frame {&frame-name}.                        
     return 'ADM-ERROR':U.  
 end.   
 if item.tipo-con-est = 2 then  do:
    if  input frame {&frame-name} movto-estoq.quantidade <> 0 and
        input frame {&frame-name} movto-estoq.quantidade <> 1 then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U, 
                           input 1836, 
                           input return-value).
        apply "entry" to movto-estoq.quantidade in frame {&frame-name}.
        return 'ADM-ERROR':U.  
    end.
 end.    

 if  input frame {&frame-name} movto-estoq.un = " " or
     input frame {&frame-name} movto-estoq.un <> item.un then do:
     {include/i-vldprg.i}
     run utp/ut-msgs.p (input "show":U,
                        input 1225,
                        input return-value).
     apply "entry" to movto-estoq.un in frame {&frame-name}.
     return 'ADM-ERROR':U.
 end.

 assign l-resposta = no.
 if item.perm-saldo-neg = 1 then
    assign i-saldo-neg = 1.
 else if item.perm-saldo-neg = 2 then
    assign i-saldo-neg = 2.
 else
    assign i-saldo-neg = 3.

 RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT THIS-PROCEDURE,
     INPUT "it-codigo").
 assign c-it-codigo   = return-value.

 RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT THIS-PROCEDURE,
     INPUT "cod-refer").
 assign c-cod-refer   = return-value.

 RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT THIS-PROCEDURE,
     INPUT "cod-depos").
 assign c-cod-depos   = return-value.

 RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT THIS-PROCEDURE,
     INPUT "lote").
 assign c-lote   = return-value.

 RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT THIS-PROCEDURE,
     INPUT "cod-localiz").
 assign c-cod-localiz   = return-value.

 IF CAN-FIND (FIRST funcao 
               WHERE funcao.cd-funcao = "spp-integra-ems-his"
               AND   funcao.ativo     = YES) THEN DO:
     find first deposito where
                deposito.cod-depos = c-cod-depos no-lock no-error.
     &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
         IF avail deposito
             and (deposito.log-orig-ext) 
             AND input frame {&frame-name} movto-estoq.quantidade <> 0 THEN DO:
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-deposito-nao-pode-ser-moviment AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Deposito_n∆o_pode_ser_movimentado" *}
             ASSIGN c-lbl-liter-deposito-nao-pode-ser-moviment = TRIM(RETURN-VALUE).
             DEFINE VARIABLE c-lbl-liter-deposito-somente-pode-ser-movi AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Deposito_somente_pode_ser_movimentado_em_quantidade_pelo_Sistema_Hospitalar" *}
             ASSIGN c-lbl-liter-deposito-somente-pode-ser-movi = TRIM(RETURN-VALUE).
             RUN utp/ut-msgs.p (INPUT "show",
                                INPUT 17006,
                                INPUT c-lbl-liter-deposito-nao-pode-ser-moviment + "." + "~~" +
                                c-lbl-liter-deposito-somente-pode-ser-movi + "." ).
             RETURN 'adm-error'.
         END.
     &ELSE
        &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
           IF avail deposito
                and TRIM(SUBSTRING(deposito.char-1,2,1)) = "S" 
                AND input frame {&frame-name} movto-estoq.quantidade <> 0 THEN DO:
               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-deposito-nao-pode-ser-moviment-2 AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Deposito_n∆o_pode_ser_movimentado" *}
               ASSIGN c-lbl-liter-deposito-nao-pode-ser-moviment-2 = TRIM(RETURN-VALUE).
               DEFINE VARIABLE c-lbl-liter-deposito-somente-pode-ser-movi-2 AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Deposito_somente_pode_ser_movimentado_em_quantidade_pelo_Sistema_Hospitalar" *}
               ASSIGN c-lbl-liter-deposito-somente-pode-ser-movi-2 = TRIM(RETURN-VALUE).
               RUN utp/ut-msgs.p (INPUT "show",
                                  INPUT 17006,
                                  INPUT c-lbl-liter-deposito-nao-pode-ser-moviment-2 + "." + "~~" +
                                  c-lbl-liter-deposito-somente-pode-ser-movi-2 + "." ).
              RETURN 'adm-error'.
           END.
        &ENDIF
     &ENDIF.
      if  avail item then do:
          find first grup-estoque where
                     grup-estoque.ge-codigo = item.ge-codigo no-lock no-error.
          &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
             if avail grup-estoque 
                 and (grup-estoque.log-orig-ext) 
                 AND input frame {&frame-name} movto-estoq.quantidade <> 0 then do:
                     /* Inicio -- Projeto Internacional */
                     DEFINE VARIABLE c-lbl-liter-item-nao-pode-ser-movimentado AS CHARACTER NO-UNDO.
                     {utp/ut-liter.i "Item_n∆o_pode_ser_movimentado" *}
                     ASSIGN c-lbl-liter-item-nao-pode-ser-movimentado = TRIM(RETURN-VALUE).
                     DEFINE VARIABLE c-lbl-liter-item-somente-pode-ser-moviment AS CHARACTER NO-UNDO.
                     {utp/ut-liter.i "Item_somente_pode_ser_movimentado_em_quantidade_pelo_Sistema_Hospitalar" *}
                     ASSIGN c-lbl-liter-item-somente-pode-ser-moviment = TRIM(RETURN-VALUE).
                     RUN utp/ut-msgs.p (INPUT "show",
                                        INPUT 17006,
                                        INPUT c-lbl-liter-item-nao-pode-ser-movimentado + "." + "~~" +
                                        c-lbl-liter-item-somente-pode-ser-moviment + "." ).
                     RETURN 'adm-error'.
             end.
         &ELSE
            &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
               if avail grup-estoque 
                   and (grup-estoque.log-1) 
                   AND input frame {&frame-name} movto-estoq.quantidade <> 0 then do:
                     /* Inicio -- Projeto Internacional */
                     DEFINE VARIABLE c-lbl-liter-item-nao-pode-ser-movimentado-2 AS CHARACTER NO-UNDO.
                     {utp/ut-liter.i "Item_n∆o_pode_ser_movimentado" *}
                     ASSIGN c-lbl-liter-item-nao-pode-ser-movimentado-2 = TRIM(RETURN-VALUE).
                     DEFINE VARIABLE c-lbl-liter-item-somente-pode-ser-moviment-2 AS CHARACTER NO-UNDO.
                     {utp/ut-liter.i "Item_somente_pode_ser_movimentado_em_quantidade_pelo_Sistema_Hospitalar" *}
                     ASSIGN c-lbl-liter-item-somente-pode-ser-moviment-2 = TRIM(RETURN-VALUE).
                     RUN utp/ut-msgs.p (INPUT "show",
                                        INPUT 17006,
                                        INPUT c-lbl-liter-item-nao-pode-ser-movimentado-2 + "." + "~~" +
                                        c-lbl-liter-item-somente-pode-ser-moviment-2 + "." ).
                     RETURN 'adm-error'.
               end.
            &ENDIF
         &ENDIF.   
      end.
     &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
         IF AVAIL ITEM 
               AND input frame {&frame-name} movto-estoq.quantidade <> 0
               AND (ITEM.log-orig-ext) THEN DO:
                   /* Inicio -- Projeto Internacional */
                   DEFINE VARIABLE c-lbl-liter-item-nao-pode-ser-movimentado-3 AS CHARACTER NO-UNDO.
                   {utp/ut-liter.i "Item_n∆o_pode_ser_movimentado" *}
                   ASSIGN c-lbl-liter-item-nao-pode-ser-movimentado-3 = TRIM(RETURN-VALUE).
                   DEFINE VARIABLE c-lbl-liter-item-somente-pode-ser-moviment-3 AS CHARACTER NO-UNDO.
                   {utp/ut-liter.i "Item_somente_pode_ser_movimentado_em_quantidade_pelo_Sistema_Hospitalar" *}
                   ASSIGN c-lbl-liter-item-somente-pode-ser-moviment-3 = TRIM(RETURN-VALUE).
                   RUN utp/ut-msgs.p (INPUT "show",
                                      INPUT 17006,
                                      INPUT c-lbl-liter-item-nao-pode-ser-movimentado-3 + "." + "~~" +
                                      c-lbl-liter-item-somente-pode-ser-moviment-3 + "." ).
                   apply "entry" to movto-estoq.quantidade in frame {&frame-name}. 
                   RETURN "adm-error".
         END.
     &ELSE
       &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
          IF AVAIL ITEM 
               AND input frame {&frame-name} movto-estoq.quantidade <> 0
               AND   TRIM(SUBSTR(ITEM.CHAR-1,267,1)) = "S" THEN DO:
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-item-nao-pode-ser-movimentado-4 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Item_n∆o_pode_ser_movimentado" *}
             ASSIGN c-lbl-liter-item-nao-pode-ser-movimentado-4 = TRIM(RETURN-VALUE).
             DEFINE VARIABLE c-lbl-liter-item-somente-pode-ser-moviment-4 AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Item_somente_pode_ser_movimentado_em_quantidade_pelo_Sistema_Hospitalar" *}
             ASSIGN c-lbl-liter-item-somente-pode-ser-moviment-4 = TRIM(RETURN-VALUE).
             RUN utp/ut-msgs.p (INPUT "show",
                                INPUT 17006,
                                INPUT c-lbl-liter-item-nao-pode-ser-movimentado-4 + "." + "~~" +
                                c-lbl-liter-item-somente-pode-ser-moviment-4 + "." ).
             apply "entry" to movto-estoq.quantidade in frame {&frame-name}. 
             RETURN "adm-error".
         END.
       &ENDIF 
     &ENDIF
  END.
                           
 find first saldo-estoq where
      saldo-estoq.it-codigo   = c-it-codigo   and
      saldo-estoq.cod-refer   = c-cod-refer   and
      saldo-estoq.cod-estabel = c-cod-estabel and
      saldo-estoq.cod-depos   = c-cod-depos   and
      saldo-estoq.lote        = c-lote        and
      saldo-estoq.cod-localiz = c-cod-localiz 
      no-lock no-error.

&if '{&bf_lote_avancado_liberado}' = 'yes' &then
if not valid-handle(h-ceapi030) then do:
    run Who-Is-The-Container in adm-broker-hdl (input this-procedure, 
                                                output h-handle).

    run pi-retorna-lote-avancado in h-handle (output h-ceapi030).

end.
&endif

   if input frame {&frame-name} movto-estoq.quantidade <> 0 and item.tipo-contr <> 4 then do:
    if input frame {&frame-name} movto-estoq.tipo-trans = 2 then do:
     if item.tipo-con-est = 2 then do:
      if not avail saldo-estoq then do: 
       find b-saldo where b-saldo.it-codigo = c-it-codigo 
                      and b-saldo.lote      = c-lote no-lock no-error.                              
       if avail b-saldo then do:
        if (b-saldo.qtidade-atu  - b-saldo.qt-alocada - 
            b-saldo.qt-aloc-prod - b-saldo.qt-aloc-ped) = 1 then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",
                               input 8995,
                               input return-value).
            return "adm-error".                   
        end.                           
        if (b-saldo.qtidade-atu  - b-saldo.qt-alocada - 
            b-saldo.qt-aloc-prod - b-saldo.qt-aloc-ped) = -1 then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",
                               input 15372,
                               input item.un).
            return "adm-error".                   
        end.  
       end.                           
       if i-saldo-neg = 1 then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show":U, 
                               input 1793, 
                               input return-value).
            return 'ADM-ERROR':U.       
       end.
       else 
        if i-saldo-neg = 2 then do:
           {include/i-vldprg.i}
           run utp/ut-msgs.p (input "show":U, 
                              input 1794, 
                              input " ").
           if return-value = "no" then
              return 'ADM-ERROR':U.        
        end.
      end.
      else do:
        if (saldo-estoq.qtidade-atu  - saldo-estoq.qt-alocada - 
            saldo-estoq.qt-aloc-prod - saldo-estoq.qt-aloc-ped) = -1 then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",
                               input 1793,
                               input return-value).
            return "adm-error".                   
        end.  
        if (saldo-estoq.qtidade-atu  - saldo-estoq.qt-alocada - 
            saldo-estoq.qt-aloc-prod - saldo-estoq.qt-aloc-ped) = 0 then do:
         if i-saldo-neg = 1 then do:
              {include/i-vldprg.i}
              run utp/ut-msgs.p (input "show":U, 
                                 input 1793, 
                                 input return-value).
              return 'ADM-ERROR':U.       
         end.
         else 
          if i-saldo-neg = 2 then do:
             {include/i-vldprg.i}
             run utp/ut-msgs.p (input "show":U, 
                                input 1794, 
                                input " ").
             if return-value = "no" then
                return 'ADM-ERROR':U.        
          end.
        end. 
      end.
     if not avail saldo-estoq then do:
       if i-saldo-neg = 1 then do:
          {include/i-vldprg.i}
           run utp/ut-msgs.p (input "show":U, 
                              input 1793, 
                              input return-value).
           return 'ADM-ERROR':U.       
       end.
       else 
        if i-saldo-neg = 2 then do:
          {include/i-vldprg.i}
           run utp/ut-msgs.p (input "show":U, 
                              input 1794, 
                              input " ").
           if return-value = "no" then
              return 'ADM-ERROR':U.        
        end.             
      end.
      else do:
        if input frame {&frame-name} movto-estoq.quantidade >
        (saldo-estoq.qtidade-atu  - saldo-estoq.qt-alocada - 
         saldo-estoq.qt-aloc-prod - saldo-estoq.qt-aloc-ped) then do:
          if i-saldo-neg = 1 then do:
             {include/i-vldprg.i}
             run utp/ut-msgs.p (input "show":U, 
                                input 1793, 
                                input return-value).
             return 'ADM-ERROR':U.       
          end.
          else 
           if i-saldo-neg = 2 then do:
             {include/i-vldprg.i}
             run utp/ut-msgs.p (input "show":U, 
                                input 1794, 
                                input " ").
             if return-value = "no" then
                return 'ADM-ERROR':U.        
           end. 
        end.
      end.                
     end.
    end. 
  end.  

 if  item.tipo-con-est = 2  and input frame {&frame-name} movto-estoq.quantidade <> 0 and
                                input frame {&frame-name} movto-estoq.tipo-trans = 1 then do:
     find first b-saldo use-index lote where b-saldo.lote        = c-lote           and
                                             b-saldo.it-codigo   = item.it-codigo   and
                                             b-saldo.qtidade-atu > 0 no-lock no-error.
     if  avail b-saldo and b-saldo.qtidade-atu > 0 then do:
         {include/i-vldprg.i}
         run utp/ut-msgs.p (input "show":U, 
                            input 1801, 
                            input return-value).
         return 'ADM-ERROR':U.
     end.    
 end.


  /* Chamada EPC para a after validate */
  {include/i-epc019.i}

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
  {src/adm/template/snd-list.i "movto-estoq"}

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

