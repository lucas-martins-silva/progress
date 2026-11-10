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
{include/i-prgvrs.i V09IN223 2.00.00.005}

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V09IN223 MUT}
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

def new global shared var gr-docum as rowid no-undo.

/* Local Variable Definitions ---                                       */

def var i-ind-aux as integer initial 0.
def var de-aux-1  as decimal no-undo.
def var de-aux-2  as decimal no-undo.
def var de-preco-aux as decimal no-undo.
def var de-agreg-aca as decimal no-undo.
def var de-preco-total as decimal no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES movto-pend
&Scoped-define FIRST-EXTERNAL-TABLE movto-pend


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR movto-pend.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS movto-pend.num-pedido movto-pend.numero-ordem ~
movto-pend.parcela movto-pend.quantidade movto-pend.un ~
movto-pend.vl-mat-agreg[1] movto-pend.valor-mob-m[1] ~
movto-pend.valor-ggf-m[1] movto-pend.desconto-agreg 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}num-pedido ~{&FP2}num-pedido ~{&FP3}~
 ~{&FP1}numero-ordem ~{&FP2}numero-ordem ~{&FP3}~
 ~{&FP1}parcela ~{&FP2}parcela ~{&FP3}~
 ~{&FP1}quantidade ~{&FP2}quantidade ~{&FP3}~
 ~{&FP1}un ~{&FP2}un ~{&FP3}~
 ~{&FP1}vl-mat-agreg[1] ~{&FP2}vl-mat-agreg[1] ~{&FP3}~
 ~{&FP1}valor-mob-m[1] ~{&FP2}valor-mob-m[1] ~{&FP3}~
 ~{&FP1}valor-ggf-m[1] ~{&FP2}valor-ggf-m[1] ~{&FP3}~
 ~{&FP1}desconto-agreg ~{&FP2}desconto-agreg ~{&FP3}
&Scoped-define ENABLED-TABLES movto-pend
&Scoped-define FIRST-ENABLED-TABLE movto-pend
&Scoped-Define ENABLED-OBJECTS rt-mold rt-mold-2 
&Scoped-Define DISPLAYED-FIELDS movto-pend.num-pedido ~
movto-pend.numero-ordem movto-pend.parcela movto-pend.quantidade ~
movto-pend.un movto-pend.vl-mat-agreg[1] movto-pend.valor-mob-m[1] ~
movto-pend.valor-ggf-m[1] movto-pend.desconto-agreg 
&Scoped-Define DISPLAYED-OBJECTS c-it-codigo c-desc-it-codigo ~
c-item-do-forn c-desc-item-do-forn de-unit-mat de-perc-mat de-perc-mob ~
de-perc-ggf 

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
DEFINE VARIABLE c-desc-it-codigo AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 51.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item-do-forn AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "x(16)" 
     LABEL "Item":R5 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88.

DEFINE VARIABLE c-item-do-forn AS CHARACTER FORMAT "X(20)" 
     LABEL "Item Fornecedor":R18 
     VIEW-AS FILL-IN 
     SIZE 21.14 BY .88.

DEFINE VARIABLE de-perc-ggf AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "":R10 
     VIEW-AS FILL-IN 
     SIZE 10.29 BY .88.

DEFINE VARIABLE de-perc-mat AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "":R10 
     VIEW-AS FILL-IN 
     SIZE 10.29 BY .88.

DEFINE VARIABLE de-perc-mob AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "":R10 
     VIEW-AS FILL-IN 
     SIZE 10.29 BY .88.

DEFINE VARIABLE de-unit-mat AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "":R12 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 5.75.

DEFINE RECTANGLE rt-mold-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 8.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     movto-pend.num-pedido AT ROW 1.58 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     movto-pend.numero-ordem AT ROW 1.58 COL 58 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .88
     c-it-codigo AT ROW 2.58 COL 17 COLON-ALIGNED HELP
          "C¢digo do Item"
     c-desc-it-codigo AT ROW 2.58 COL 34.72 COLON-ALIGNED NO-LABEL
     c-item-do-forn AT ROW 3.58 COL 17 COLON-ALIGNED
     c-desc-item-do-forn AT ROW 3.58 COL 38.57 COLON-ALIGNED NO-LABEL
     movto-pend.parcela AT ROW 4.58 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     movto-pend.quantidade AT ROW 5.58 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     movto-pend.un AT ROW 5.58 COL 58 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     de-unit-mat AT ROW 7.5 COL 36 COLON-ALIGNED
     de-perc-mat AT ROW 8.5 COL 36 COLON-ALIGNED HELP
          "Percentual de Utilizaá∆o"
     de-perc-mob AT ROW 9.5 COL 36 COLON-ALIGNED HELP
          "Percentual de Utilizaá∆o"
     de-perc-ggf AT ROW 10.5 COL 36 COLON-ALIGNED HELP
          "Percentual de Utilizaá∆o"
     movto-pend.vl-mat-agreg[1] AT ROW 11.5 COL 36 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     movto-pend.valor-mob-m[1] AT ROW 12.5 COL 36 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     movto-pend.valor-ggf-m[1] AT ROW 13.5 COL 36 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     movto-pend.desconto-agreg AT ROW 14.5 COL 36 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     rt-mold AT ROW 1 COL 1
     rt-mold-2 AT ROW 7 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.movto-pend
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
         HEIGHT             = 14.79
         WIDTH              = 88.
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

/* SETTINGS FOR FILL-IN c-desc-it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item-do-forn IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-item-do-forn IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-perc-ggf IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-perc-mat IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-perc-mob IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-unit-mat IN FRAME f-main
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

&Scoped-define SELF-NAME de-perc-ggf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-perc-ggf V-table-Win
ON LEAVE OF de-perc-ggf IN FRAME f-main
DO:
  
    display ((input frame {&frame-name} de-unit-mat *
            input frame {&frame-name} movto-pend.quantidade) *
            input frame {&frame-name} de-perc-ggf / 100) @
            movto-pend.valor-ggf-m[1] with frame {&frame-name}.
  
    run pi-beneficia-I.                 
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-perc-mat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-perc-mat V-table-Win
ON LEAVE OF de-perc-mat IN FRAME f-main
DO:
  
    display ((input frame {&frame-name} de-unit-mat *
            input frame {&frame-name} movto-pend.quantidade) *
            input frame {&frame-name} de-perc-mat / 100) @
            movto-pend.vl-mat-agreg[1] with frame {&frame-name}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-perc-mob
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-perc-mob V-table-Win
ON LEAVE OF de-perc-mob IN FRAME f-main
DO:
  
    display ((input frame {&frame-name} de-unit-mat *
            input frame {&frame-name} movto-pend.quantidade) *
            input frame {&frame-name} de-perc-mob / 100) @
            movto-pend.valor-mob-m[1] with frame {&frame-name}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-pend.num-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.num-pedido V-table-Win
ON F5 OF movto-pend.num-pedido IN FRAME f-main /* Pedido */
DO:

    {include/zoomvar.i &prog-zoom="inzoom/z04in356.w"
                       &campo=movto-pend.num-pedido
                       &campozoom=num-pedido
                       &campo2=movto-pend.numero-ordem
                       &campozoom2=numero-ordem
                       &campo3=movto-pend.parcela
                       &campozoom3=parcela}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.num-pedido V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-pend.num-pedido IN FRAME f-main /* Pedido */
DO:
        apply "F5" to self.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-pend.numero-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.numero-ordem V-table-Win
ON F5 OF movto-pend.numero-ordem IN FRAME f-main /* Ordem */
DO:

    {include/zoomvar.i &prog-zoom="inzoom/z04in356.w"
                       &campo=movto-pend.num-pedido
                       &campozoom=num-pedido
                       &campo2=movto-pend.numero-ordem
                       &campozoom2=numero-ordem
                       &campo3=movto-pend.parcela
                       &campozoom3=parcela}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.numero-ordem V-table-Win
ON LEAVE OF movto-pend.numero-ordem IN FRAME f-main /* Ordem */
DO:
  
    find ordem-compra where
        ordem-compra.numero-ordem = input frame {&frame-name} movto-pend.numero-ordem
        no-lock no-error.
        
    find item where
        item.it-codigo = ordem-compra.it-codigo
        no-lock no-error.
        
    display ordem-compra.it-codigo @ c-it-codigo with frame {&frame-name}.
    display item.desc-item @ c-desc-it-codigo with frame {&frame-name}.
    
    find item-fornec where
        item-fornec.it-codigo = ordem-compra.it-codigo and
        item-fornec.cod-emitente = docum-est.cod-emitente 
        no-lock no-error.
    if available item-fornec then do:
        find item where 
            item.it-codigo = item-fornec.item-do-forn
            no-lock no-error.
        display item-fornec.item-do-forn @ c-item-do-forn with frame {&frame-name}.
        display item.desc-item @ c-desc-item-do-forn with frame {&frame-name}.
    end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.numero-ordem V-table-Win
ON MOUSE-SELECT-DBLCLICK OF movto-pend.numero-ordem IN FRAME f-main /* Ordem */
DO:
        apply "F5" to self.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-pend.parcela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.parcela V-table-Win
ON LEAVE OF movto-pend.parcela IN FRAME f-main /* Parcela */
DO:
  
    find prazo-compra use-index ordem where
        prazo-compra.numero-ordem = input frame {&frame-name} movto-pend.numero-ordem and
        prazo-compra.parcela = input frame {&frame-name} movto-pend.parcela
        no-lock no-error.

    find familia where
        familia.fm-codigo = item.fm-codigo
        no-lock no-error.

    if available prazo-compra then do:
        assign de-aux-1 = prazo-compra.quant-saldo +
                          (prazo-compra.quantidade *
                          familia.var-quantid / 100)
               de-aux-2 = prazo-compra.quant-saldo -
                          (prazo-compra.quantidade *
                          familia.var-quantid / 100).
    end.                          
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-pend.quantidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.quantidade V-table-Win
ON LEAVE OF movto-pend.quantidade IN FRAME f-main /* Qtde */
DO:
  
    if input frame {&frame-name} movto-pend.quantidade > de-aux-1 then do:        
        run utp/ut-msgs.p (input "show", input 7344, input "").
        if param-re.aceita-var = no then do:
            apply "entry" to movto-pend.quantidade in frame {&frame-name}.
            return no-apply.
        end.            
        run utp/ut-msgs.p (input "show", input 7345, input "").
        if return-value = "yes" then do:
            apply "entry" to movto-pend.quantidade in frame {&frame-name}.
            return no-apply.
        end.            
    end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-pend.un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.un V-table-Win
ON LEAVE OF movto-pend.un IN FRAME f-main /* Unid */
DO:
  
    if param-re.preco-unit then do:
        display ordem-compra.pre-unit-for @ de-unit-mat with frame {&frame-name}.
        enable de-unit-mat
               de-perc-mat
               de-perc-mob
               de-perc-ggf with frame {&frame-name}.
        apply "entry" to de-unit-mat in frame {&frame-name}.
        return no-apply.               
    end.               
    else
        run pi-beneficia-I.                 
  
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

    if movto-pend.num-pedido:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
    if movto-pend.numero-ordem:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "movto-pend"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "movto-pend"}

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

    find first param-global
        no-lock no-error.
        
    find first param-estoq
        no-lock no-error.
        
    find param-re where
        param-re.usuario = c-seg-usuario
        no-lock no-error.        
        
    find docum-est where
        rowid(docum-est) = gr-docum
        no-lock no-error.

    assign i-ind-aux = i-ind-aux + 1.

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

    assign movto-pend.serie-docto = ""
           movto-pend.nro-docto = docum-est.nro-docto
           movto-pend.cod-emitente = docum-est.cod-emitente
           movto-pend.nat-operacao = docum-est.nat-operacao
           movto-pend.tipo = 2
           movto-pend.sequencia = i-ind-aux
           movto-pend.it-codigo = input frame {&frame-name} c-it-codigo.

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

    {utp/ut-liter.i Preáo_unit†rio * R}
    assign de-unit-mat:label in frame {&frame-name} = trim(return-value).
    
    {utp/ut-liter.i %_Valor_MAT * R}
    assign de-perc-mat:label in frame {&frame-name} = trim(return-value).
    
    {utp/ut-liter.i %_Valor_MOB * R}
    assign de-perc-mob:label in frame {&frame-name} = trim(return-value).

    {utp/ut-liter.i %_Valor_GGF * R}
    assign de-perc-ggf:label in frame {&frame-name} = trim(return-value).

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-beneficia-I V-table-Win 
PROCEDURE pi-beneficia-I :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    assign de-preco-total = ordem-compra.pre-unit-for *
            (input frame {&frame-name} movto-pend.quantidade +
            integer(input frame {&frame-name} movto-pend.quantidade = 0)).
            
    if ordem-compra.mo-codigo <> 0 then 
        run cdp/cd0812.p (input ordem-compra.mo-codigo, 
                          input 0,
                          input de-preco-total,
                          input docum-est.dt-emissao,
                          output de-preco-total).
                          
    assign de-aux-1 = de-preco-total + de-preco-total * familia.var-preco / 100
           de-aux-2 = de-preco-total - de-preco-total * familia.var-preco / 100.
           
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

    find pedido-compr where
        pedido-compr.num-pedido = input frame {&frame-name} movto-pend.num-pedido
        no-lock no-error.
    if not available pedido-compr then do:
        {include/i-vldprg.i}           
        {utp/ut-table.i mgind pedido-compr 1}
        run utp/ut-msgs.p (input "show", input 47, input return-value).
        apply "entry" to movto-pend.num-pedido in frame {&frame-name}.
        return error.
    end.
    
    if pedido-compr.situacao = 3 then do:
        {include/i-vldprg.i}           
        run utp/ut-msgs.p (input "show", input 7169, input "").
        apply "entry" to movto-pend.num-pedido in frame {&frame-name}.
        return error.
    end.
    
    if pedido-compr.natureza <> 3 then do:
        {include/i-vldprg.i}           
        run utp/ut-msgs.p (input "show", input 6412, input "").
        apply "entry" to movto-pend.num-pedido in frame {&frame-name}.
        return error.
    end.

    if pedido-compr.cod-emitente <> docum-est.cod-emitente then do:     
        {include/i-vldprg.i}           
        run utp/ut-msgs.p (input "show", input 7341, input "").
        if return-value = "no" then do:
            apply "entry" to movto-pend.num-pedido in frame {&frame-name}.
            return error.
        end.            
    end.
   
    find ordem-compra where
        ordem-compra.numero-ordem = input frame {&frame-name} movto-pend.numero-ordem
        no-lock no-error.
    if not available ordem-compra then do:
        {include/i-vldprg.i}           
        {utp/ut-table.i mgind ordem-compra 1}
        run utp/ut-msgs.p (input "show", input 47, input return-value).
        apply "entry" to movto-pend.numero-ordem in frame {&frame-name}.
        return error.
    end.
        
    if ordem-compra.num-pedido <> pedido-compr.num-pedido then do:
        {include/i-vldprg.i}           
        run utp/ut-msgs.p (input "show", input 7342, input "").
        apply "entry" to movto-pend.numero-ordem in frame {&frame-name}.
        return error.
    end.

    find first prazo-compra where
        prazo-compra.numero-ordem = ordem-compra.numero-ordem and
        prazo-compra.situacao = 2 
        no-lock no-error.
    if not available prazo-compra then do:
        {include/i-vldprg.i}           
        run utp/ut-msgs.p (input "show", input 7343, input "").
        apply "entry" to movto-pend.numero-ordem in frame {&frame-name}.
        return error.
    end.

    find prazo-compra use-index ordem where
        prazo-compra.numero-ordem = input frame {&frame-name} movto-pend.numero-ordem and
        prazo-compra.parcela = input frame {&frame-name} movto-pend.parcela
        no-lock no-error.
    if not available prazo-compra then do:
        {include/i-vldprg.i}           
        {utp/ut-table.i mgind prazo-compra 1}
        run utp/ut-msgs.p (input "show", input 47, input return-value).
        apply "entry" to movto-pend.parcela in frame {&frame-name}.
        return error.
    end.
        
    if prazo-compra.situacao <> 2 then do:
        {include/i-vldprg.i}           
        run utp/ut-msgs.p (input "show", input 6898, input "").
        apply "entry" to movto-pend.parcela in frame {&frame-name}.
        return error.
    end.

    if input frame {&frame-name} movto-pend.quantidade <= 0 then do:
        {include/i-vldprg.i}           
        {utp/ut-field.i mgind movto-pend quantidade 1}
        run utp/ut-msgs.p (input "show", input 36, input return-value).
        apply "entry" to movto-pend.quantidade in frame {&frame-name}.
        return error.
    end.

    if item.it-codigo <> "" and 
        input frame {&frame-name} movto-pend.un <> item.un then do:
        {include/i-vldprg.i}           
        run utp/ut-msgs.p (input "show", input 7346, input "").
        apply "entry" to movto-pend.un in frame {&frame-name}.
        return error.
    end.

    if (input frame {&frame-name} movto-pend.vl-mat-agreg[1] -
        (input frame {&frame-name} movto-pend.vl-mat-agreg[1] * 
        input frame {&frame-name} movto-pend.desconto-agreg / 100)) <= 0 and
        input frame {&frame-name} movto-pend.valor-mob-m[1] <= 0 and
        input frame {&frame-name} movto-pend.valor-ggf-m[1] <= 0 then do:
        {include/i-vldprg.i}           
        {utp/ut-liter.i Valor_da_transaá∆o * R}
        run utp/ut-msgs.p (input "show", input 36, input return-value).
        apply "entry" to movto-pend.vl-mat-agreg[1] in frame {&frame-name}.
        return error.
    end.

    assign de-preco-aux = (input frame {&frame-name} movto-pend.vl-mat-agreg[1] +
                           input frame {&frame-name} movto-pend.valor-mob-m[1] +
                           input frame {&frame-name} movto-pend.valor-ggf-m[1]) -
                           ((input frame {&frame-name} movto-pend.vl-mat-agreg[1] +
                           input frame {&frame-name} movto-pend.valor-mob-m[1] +
                           input frame {&frame-name} movto-pend.valor-ggf-m[1]) *
                           input frame {&frame-name} movto-pend.desconto-agreg / 100).
                                                                                        
    if de-preco-aux > de-aux-1 or
        de-preco-aux < de-aux-2 then do:
        {include/i-vldprg.i}           
        run utp/ut-msgs.p (input "show", input 7347, input "").
        if param-re.aceita-var = no then do:
            apply "entry" to movto-pend.vl-mat-agreg[1] in frame {&frame-name}.
            return error.
        end.
        run utp/ut-msgs.p (input "show", input 7347, input "").
        if return-value = "yes" then do:            
            apply "entry" to movto-pend.vl-mat-agreg[1] in frame {&frame-name}.
            return error.
        end.
    end.
    
    assign de-agreg-aca = de-agreg-aca +
        (input frame {&frame-name} movto-pend.vl-mat-agreg[1] +
        input frame {&frame-name} movto-pend.valor-mob-m[1] +
        input frame {&frame-name} movto-pend.valor-ggf-m[1]).    
        
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
  {src/adm/template/snd-list.i "movto-pend"}

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


