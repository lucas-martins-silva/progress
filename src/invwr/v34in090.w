&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
{include/i-prgvrs.i V34IN090 2.00.00.011} /*** "010011" 24/11/2023 09:12:26  ***/
 
&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V34IN090 MUT}
&ENDIF

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
def var v-row-parent as rowid no-undo.

def var h-window   as handle no-undo.
def var h-b05in567 as handle no-undo.

{rep/re0994c.i}
{cep/ce1234.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 rt-button rt-key fi-cod-cond-pag ~
fi-cod-esp fi-tp-despesa FILL-IN-1 fi-tot-nota fi-tot-itens fi-diferenca 
&Scoped-Define DISPLAYED-OBJECTS fi-cod-cond-pag fi-desc-cond fi-cod-esp ~
fi-desc-especie fi-tp-despesa fi-desc-despesa fi-valor-mercad-fat ~
fi-tot-desconto-fat fi-tot-taxa-fat fi-despesa-nota-fat fi-tot-valor-fat ~
fi-valor-mercad-calc fi-tot-desconto-calc fi-tot-taxa-calc ~
fi-despesa-nota-calc fi-tot-valor-calc fi-valor-mercad-dif ~
fi-tot-desconto-dif fi-tot-taxa-dif fi-despesa-nota-dif fi-tot-valor-dif ~
FILL-IN-1 fi-tot-nota fi-tot-itens fi-diferenca 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS fi-tot-valor-calc fi-tot-valor-dif 

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
DEFINE VARIABLE fi-cod-cond-pag AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Condiá∆o Pagamento":R22 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .88.

DEFINE VARIABLE fi-cod-esp AS CHARACTER FORMAT "!!" INITIAL "DP" 
     LABEL "Especie":R9 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .88.

DEFINE VARIABLE fi-desc-cond AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-despesa AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-especie AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE fi-despesa-nota-calc AS DECIMAL FORMAT ">>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-despesa-nota-dif AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-despesa-nota-fat AS DECIMAL FORMAT ">>>>>,>>>,>>9.99" INITIAL 0 
     LABEL "Despesas Nota":R16 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-diferenca AS CHARACTER FORMAT "X(50)":U 
      VIEW-AS TEXT 
     SIZE 15.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tot-desconto-calc AS DECIMAL FORMAT ">>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-tot-desconto-dif AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-tot-desconto-fat AS DECIMAL FORMAT ">>>>>,>>>,>>9.99" INITIAL 0 
     LABEL "Total Descto":R15 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-tot-itens AS CHARACTER FORMAT "X(50)":U 
      VIEW-AS TEXT 
     SIZE 23.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tot-nota AS CHARACTER FORMAT "X(50)":U 
      VIEW-AS TEXT 
     SIZE 21.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tot-taxa-calc AS DECIMAL FORMAT ">>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-tot-taxa-dif AS DECIMAL FORMAT "->>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-tot-taxa-fat AS DECIMAL FORMAT ">>>,>>>,>>9.99" INITIAL 0 
     LABEL "Total Impostos":R17 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-tot-valor-calc AS DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-tot-valor-dif AS DECIMAL FORMAT "->>>>,>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-tot-valor-fat AS DECIMAL FORMAT ">>>>,>>>,>>>,>>9.99" INITIAL 0 
     LABEL "Valor Total":R14 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-tp-despesa AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Tipo Despesa":R15 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .88.

DEFINE VARIABLE fi-valor-mercad-calc AS DECIMAL FORMAT ">>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-valor-mercad-dif AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-valor-mercad-fat AS DECIMAL FORMAT ">>>>>,>>>,>>9.99" INITIAL 0 
     LABEL "Valor Total Merc":R20 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 5.14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.14 BY 3.25.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 61.72 BY 1
     BGCOLOR 7 .

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.14 BY 6.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     fi-cod-cond-pag AT ROW 1.17 COL 26 COLON-ALIGNED
     fi-desc-cond AT ROW 1.17 COL 31.57 COLON-ALIGNED NO-LABEL
     fi-cod-esp AT ROW 2.17 COL 26 COLON-ALIGNED
     fi-desc-especie AT ROW 2.17 COL 31.57 COLON-ALIGNED NO-LABEL
     fi-tp-despesa AT ROW 3.17 COL 26 COLON-ALIGNED
     fi-desc-despesa AT ROW 3.17 COL 31.57 COLON-ALIGNED NO-LABEL
     fi-valor-mercad-fat AT ROW 6.08 COL 19.57 COLON-ALIGNED
     fi-tot-desconto-fat AT ROW 7.08 COL 19.57 COLON-ALIGNED
     fi-tot-taxa-fat AT ROW 8.08 COL 19.57 COLON-ALIGNED
     fi-despesa-nota-fat AT ROW 9.08 COL 19.57 COLON-ALIGNED
     fi-tot-valor-fat AT ROW 10.17 COL 19.57 COLON-ALIGNED
     fi-valor-mercad-calc AT ROW 6.08 COL 39.86 COLON-ALIGNED NO-LABEL
     fi-tot-desconto-calc AT ROW 7.08 COL 39.86 COLON-ALIGNED NO-LABEL
     fi-tot-taxa-calc AT ROW 8.08 COL 39.86 COLON-ALIGNED NO-LABEL
     fi-despesa-nota-calc AT ROW 9.08 COL 39.86 COLON-ALIGNED NO-LABEL
     fi-tot-valor-calc AT ROW 10.17 COL 39.86 COLON-ALIGNED NO-LABEL
     fi-valor-mercad-dif AT ROW 6.08 COL 60.57 COLON-ALIGNED NO-LABEL
     fi-tot-desconto-dif AT ROW 7.08 COL 60.57 COLON-ALIGNED NO-LABEL
     fi-tot-taxa-dif AT ROW 8.08 COL 60.57 COLON-ALIGNED NO-LABEL
     fi-despesa-nota-dif AT ROW 9.08 COL 60.57 COLON-ALIGNED NO-LABEL
     fi-tot-valor-dif AT ROW 10.17 COL 60.57 COLON-ALIGNED NO-LABEL
     FILL-IN-1 AT ROW 4.92 COL 19.29 COLON-ALIGNED NO-LABEL
     fi-tot-nota AT ROW 4.92 COL 45.72 RIGHT-ALIGNED NO-LABEL
     fi-tot-itens AT ROW 4.92 COL 42.43 COLON-ALIGNED NO-LABEL
     fi-diferenca AT ROW 4.92 COL 65.14 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 1 COL 1
     rt-button AT ROW 4.83 COL 21
     rt-key AT ROW 4.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
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
         HEIGHT             = 10.25
         WIDTH              = 85.14.
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

/* SETTINGS FOR FILL-IN fi-desc-cond IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-desc-despesa IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-desc-especie IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-despesa-nota-calc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-despesa-nota-dif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-despesa-nota-fat IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-tot-desconto-calc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-tot-desconto-dif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-tot-desconto-fat IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-tot-nota IN FRAME f-main
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fi-tot-taxa-calc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-tot-taxa-dif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-tot-taxa-fat IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-tot-valor-calc IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-tot-valor-dif IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-tot-valor-fat IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-valor-mercad-calc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-valor-mercad-dif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-valor-mercad-fat IN FRAME f-main
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

&Scoped-define SELF-NAME fi-cod-cond-pag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-cond-pag V-table-Win
ON F5 OF fi-cod-cond-pag IN FRAME f-main /* Condiá∆o Pagamento */
DO:
   assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=adzoom/z01ad039.w
                     &campo=fi-cod-cond-pag
                     &campozoom=cod-cond-pag}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-cond-pag V-table-Win
ON LEAVE OF fi-cod-cond-pag IN FRAME f-main /* Condiá∆o Pagamento */
DO:
     {include/leave.i &tabela=cond-pagto
                    &atributo-ref=descricao
                    &variavel-ref=fi-desc-cond
                    &where="cond-pagto.cod-cond-pag = input frame {&frame-name} fi-cod-cond-pag"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-cond-pag V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-cond-pag IN FRAME f-main /* Condiá∆o Pagamento */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-esp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-esp V-table-Win
ON F5 OF fi-cod-esp IN FRAME f-main /* Especie */
DO:
    l-implanta      = yes.
    {include/zoomvar.i &prog-zoom=adzoom/z01ad104.w
                       &campo=fi-cod-esp
                       &campozoom=cod-esp}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-esp V-table-Win
ON LEAVE OF fi-cod-esp IN FRAME f-main /* Especie */
DO:
 {include/leave.i &tabela=espec-ap
                 &atributo-ref=descricao
                 &variavel-ref=fi-desc-especie
                 &where="espec-ap.cod-esp = input frame {&frame-name} fi-cod-esp"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-esp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-esp IN FRAME f-main /* Especie */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-despesa-nota-fat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-despesa-nota-fat V-table-Win
ON LEAVE OF fi-despesa-nota-fat IN FRAME f-main /* Despesas Nota */
DO:
/*
    assign  fi-despesa-nota-dif:screen-value = string(input docum-est.despesa-nota  -
                                                      input fi-despesa-nota-it).
    assign fi-despesa-nota-dif:fgcolor =
        if input frame {&frame-name} fi-despesa-nota-dif <> 0 then 12 else ?.
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-tot-desconto-fat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-tot-desconto-fat V-table-Win
ON LEAVE OF fi-tot-desconto-fat IN FRAME f-main /* Total Descto */
DO:
/*
    assign  fi-tot-desconto-dif:screen-value = string(input docum-est.tot-desconto  - 
                                                      input fi-tot-desconto-it)      .
    assign fi-tot-desconto-dif:fgcolor =
        if input frame {&frame-name} fi-tot-desconto-dif <> 0 then 12 else ?.
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-tp-despesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-tp-despesa V-table-Win
ON F5 OF fi-tp-despesa IN FRAME f-main /* Tipo Despesa */
DO:
    l-implanta      = yes. 
    {include/zoomvar.i &prog-zoom=adzoom/z01ad259.w
                       &campo=fi-tp-despesa
                       &campozoom=tp-codigo}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-tp-despesa V-table-Win
ON LEAVE OF fi-tp-despesa IN FRAME f-main /* Tipo Despesa */
DO:
      {include/leave.i &tabela=tipo-rec-desp
                     &atributo-ref=descricao
                     &variavel-ref=fi-desc-despesa
                     &where="tipo-rec-desp.tp-codigo = input frame {&frame-name} fi-tp-despesa"}      


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-tp-despesa V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-tp-despesa IN FRAME f-main /* Tipo Despesa */
DO:
    apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-valor-mercad-fat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-valor-mercad-fat V-table-Win
ON LEAVE OF fi-valor-mercad-fat IN FRAME f-main /* Valor Total Merc */
DO:
/*
    assign  fi-valor-mercad-dif:screen-value = string(input docum-est.valor-mercad  -
                                                      input fi-valor-mercad-it).
    assign fi-valor-mercad-dif:fgcolor =
        if input frame {&frame-name} fi-valor-mercad-dif <> 0 then 12 else ?.
*/
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
  if  fi-cod-esp:load-mouse-pointer("image/lupa.cur") then .
  if  fi-tp-despesa:load-mouse-pointer("image/lupa.cur") then .
  if  fi-cod-cond-pag:load-mouse-pointer("image/lupa.cur") then .

    {utp/ut-liter.i Condiá∆o_Pagamento * r}
    assign fi-cod-cond-pag:label in frame {&frame-name} = trim(return-value).

    {utp/ut-liter.i EspÇcie * r}
    assign fi-cod-esp:label in frame {&frame-name} = trim(return-value).

    {utp/ut-liter.i Tipo_Despesa * r}
    assign fi-tp-despesa:label in frame {&frame-name} = trim(return-value).

    {utp/ut-liter.i Valor_Total_Merc * r}
    assign fi-valor-mercad-fat:label in frame {&frame-name} = trim(return-value).

    {utp/ut-liter.i Total_Descto * r}
    assign fi-tot-desconto-fat:label in frame {&frame-name} = trim(return-value).

    {utp/ut-liter.i Total_Impostos * r}
    assign fi-tot-taxa-fat:label in frame {&frame-name} = trim(return-value).

    {utp/ut-liter.i Valor_Despesa * r}
    assign fi-despesa-nota-fat:label in frame {&frame-name} = trim(return-value).

    {utp/ut-liter.i Valor_Total * r}
    assign fi-tot-valor-fat:label in frame {&frame-name} = trim(return-value).

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
        return 'ADM-ERROR':U.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    if adm-new-record = yes then
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

  /* Code placed here will execute AFTER standard behavior.    */
  {utp/ut-liter.i Total_Fatura MRE L}  
  assign fi-tot-nota:screen-value in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Total_Calculado MRE L}  
  assign fi-tot-itens:screen-value in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Diferenáa MRE L}  
  assign fi-diferenca:screen-value in frame {&FRAME-NAME}  = return-value.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-totais V-table-Win 
PROCEDURE pi-atualiza-totais :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
find first tt-total no-error.
do with frame {&FRAME-NAME}:
    assign fi-despesa-nota-calc:screen-value    = string(tt-total.despesa-nota-calc)
           fi-despesa-nota-dif:screen-value     = string(tt-total.despesa-nota-dif) 
           fi-despesa-nota-fat:screen-value     = string(tt-total.despesa-nota-fat) 
           fi-tot-desconto-calc:screen-value    = string(tt-total.tot-desconto-calc) 
           fi-tot-desconto-dif:screen-value     = string(tt-total.tot-desconto-dif) 
           fi-tot-desconto-fat:screen-value     = string(tt-total.tot-desconto-fat) 
           fi-tot-taxa-calc:screen-value        = string(tt-total.tot-taxa-calc) 
           fi-tot-taxa-dif:screen-value         = string(tt-total.tot-taxa-dif) 
           fi-tot-taxa-fat:screen-value         = string(tt-total.tot-taxa-fat) 
           fi-tot-valor-calc:screen-value       = string(tt-total.tot-valor-calc) 
           fi-tot-valor-dif:screen-value        = string(tt-total.tot-valor-dif) 
           fi-tot-valor-fat:screen-value        = string(tt-total.tot-valor-fat) 
           fi-valor-mercad-calc:screen-value    = string(tt-total.valor-mercad-calc) 
           fi-valor-mercad-dif:screen-value     = string(tt-total.valor-mercad-dif)    
           fi-valor-mercad-fat:screen-value     = string(tt-total.valor-mercad-fat).
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-total-impostos V-table-Win 
PROCEDURE pi-atualiza-total-impostos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param table for tt-dupli-imp.

find first tt-total no-error.
if not avail tt-total then
    create tt-total.
assign  tt-total.tot-taxa-fat  = 0   
        tt-total.taxa-inc-fat  = 0
        tt-total.tot-taxa-calc = 0   
        tt-total.taxa-inc-calc = 0.
for each tt-dupli-imp:
    find tipo-tax where tipo-tax.cod-tax = tt-dupli-imp.cod-imposto no-lock no-error.
    if avail tipo-tax and tipo-tax.ind-tip-calculo = 1 then /*Base 100% --> Imposto por fora*/
        assign tt-total.tot-taxa-fat = tt-total.tot-taxa-fat    
                                    + tt-dupli-imp.vl-imposto-me
                                    + tt-dupli-imp.vl-percepcao-me
               tt-total.tot-taxa-calc = tt-total.tot-taxa-fat. /*como o compras n∆o trata impostos, o calculado Ç o mesmo da fatura*/                                                               
    else
        assign tt-total.taxa-inc-fat = tt-total.taxa-inc-fat    
                                    + tt-dupli-imp.vl-imposto-me
                                    + tt-dupli-imp.vl-percepcao-me
               tt-total.taxa-inc-calc = tt-total.taxa-inc-fat. /*como o compras n∆o trata impostos, o calculado Ç o mesmo da fatura*/                                                               

end.
assign tt-total.tot-taxa-dif = tt-total.tot-taxa-fat - tt-total.tot-taxa-calc
       tt-total.tot-valor-fat     = tt-total.valor-mercad-fat + 
                                    tt-total.despesa-nota-fat +
                                    tt-total.tot-taxa-fat     -
                                    tt-total.tot-desconto-fat
       tt-total.tot-valor-calc    = tt-total.valor-mercad-calc + 
                                    tt-total.despesa-nota-calc +
                                    tt-total.tot-taxa-calc     -
                                    tt-total.tot-desconto-calc                                    
       tt-total.tot-valor-dif     = tt-total.tot-valor-fat     - 
                                    tt-total.tot-valor-calc.


do with frame {&FRAME-NAME}:
    assign fi-tot-taxa-calc:screen-value        = string(tt-total.tot-taxa-calc) 
           fi-tot-taxa-dif:screen-value         = string(tt-total.tot-taxa-dif) 
           fi-tot-taxa-fat:screen-value         = string(tt-total.tot-taxa-fat) 
           fi-tot-valor-calc:screen-value       = string(tt-total.tot-valor-calc)
           fi-tot-valor-fat:screen-value        = string(tt-total.tot-valor-fat)
           fi-tot-valor-dif:screen-value        = string(tt-total.tot-valor-dif).
end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-devolve-tabelas V-table-Win 
PROCEDURE pi-devolve-tabelas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output param table for tt-total.
def output param table for tt-dupli-imp.

find first tt-total no-error.
if not avail tt-total then
    create tt-total.

assign tt-total.cod-cond-pag     = input frame {&FRAME-NAME} fi-cod-cond-pag
       tt-total.cod-esp          = input frame {&FRAME-NAME} fi-cod-esp
       tt-total.tp-despesa       = input frame {&FRAME-NAME} fi-tp-despesa
       tt-total.despesa-nota-fat = input frame {&FRAME-NAME} fi-despesa-nota-fat
       tt-total.tot-desconto-fat = input frame {&FRAME-NAME} fi-tot-desconto-fat
       tt-total.tot-taxa-fat     = input frame {&FRAME-NAME} fi-tot-taxa-fat
       tt-total.tot-valor-fat    = input frame {&FRAME-NAME} fi-tot-valor-fat
       tt-total.valor-mercad-fat = input frame {&FRAME-NAME} fi-valor-mercad-fat
       tt-total.despesa-nota-dif = tt-total.despesa-nota-fat - tt-total.despesa-nota-calc
       tt-total.tot-desconto-dif = tt-total.tot-desconto-fat - tt-total.tot-desconto-calc
       tt-total.tot-taxa-dif     = tt-total.tot-taxa-fat     - tt-total.tot-taxa-calc    
       tt-total.tot-valor-dif    = tt-total.tot-valor-fat    - tt-total.tot-valor-calc    
       tt-total.valor-mercad-dif = tt-total.valor-mercad-fat - tt-total.valor-mercad-calc.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-handle V-table-Win 
PROCEDURE pi-recebe-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-h-window   as handle no-undo.
def input param p-h-b05in567 as handle no-undo.

assign h-window   = p-h-window   
       h-b05in567 = p-h-b05in567.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-rowid V-table-Win 
PROCEDURE pi-recebe-rowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param rw-docum-est as rowid no-undo.

if rw-docum-est <> ? then do:
  find docum-est where rowid(docum-est) = rw-docum-est no-lock no-error.

  if  avail docum-est 
  and docum-est.CE-atual     =  no    
  and docum-est.AP-atual     =  no      
  and docum-est.nat-operacao = " " then do:
     find param-re where param-re.usuario = c-seg-usuario        no-lock.    
     find espec-ap where espec-ap.cod-esp = param-re.esp-def-nff no-lock no-error.
     find emitente where emitente.cod-emitente = docum-est.cod-emitente no-lock no-error.
     find first item-doc-est 
          where item-doc-est.cod-emitente = docum-est.cod-emitente 
            and item-doc-est.nat-operacao = docum-est.nat-operacao
            and item-doc-est.serie-docto  = docum-est.serie-docto
            and item-doc-est.nro-docto    = docum-est.nro-docto 
            and item-doc-est.numero-ordem > 0 no-lock no-error.
     if  avail item-doc-est then do:
        find ordem-compra where
             ordem-compra.numero-ordem = item-doc-est.numero-ordem no-lock no-error.
        if avail ordem-compra then do:
            find tipo-rec-desp where
                 tipo-rec-desp.tp-codigo = ordem-compra.tp-despesa no-lock no-error.
            find cond-pagto    where 
                 cond-pagto.cod-cond-pag = ordem-compra.cod-cond-pag no-lock no-error.
        end.              
        else do:
           if item-doc-est.log-1 = yes then do:
              find first rat-ordem where
                   rat-ordem.serie-docto  = docum-est.serie-docto and
                   rat-ordem.nro-docto    = docum-est.nro-docto and
                   rat-ordem.cod-emitente = docum-est.cod-emitente and
                   rat-ordem.nat-operacao = docum-est.nat-operacao no-lock no-error. 
              if avail rat-ordem then do:
                 find ordem-compra where
                      ordem-compra.numero-ordem = rat-ordem.numero-ordem no-lock no-error.
                 if avail ordem-compra then do:
                        find tipo-rec-desp where
                             tipo-rec-desp.tp-codigo = ordem-compra.tp-despesa no-lock no-error.
                        find cond-pagto    where 
                             cond-pagto.cod-cond-pag = ordem-compra.cod-cond-pag no-lock no-error.
                 end. 
              end.
           end.
        end.
     end.              
     if avail emitente and not avail ordem-compra then do:
         find tipo-rec-desp where
             tipo-rec-desp.tp-codigo = emitente.tp-desp-padrao no-lock no-error.
        find cond-pagto    where 
             cond-pagto.cod-cond-pag = emitente.cod-cond-pag no-lock no-error.
     end.
     do with frame {&FRAME-NAME}:
        assign fi-cod-cond-pag:screen-value = if  avail ordem-compra 
                                              then string(ordem-compra.cod-cond-pag) 
                                              else if avail emitente
                                                   then string(emitente.cod-cond-pag)
                                                   else ""
               fi-desc-cond:screen-value    = if avail cond-pagto
                                              then cond-pagto.descricao else ""
               fi-cod-esp:screen-value      = string(param-re.esp-def-nff)
               fi-desc-especie:screen-value = if avail espec-ap 
                                              then espec-ap.descricao else ""
               fi-tp-despesa:screen-value   = if  avail ordem-compra 
                                              then string(ordem-compra.tp-despesa) 
                                              else if avail emitente 
                                                   then string(emitente.tp-desp-padrao)
                                                   else ""
               fi-desc-despesa:screen-value = if avail tipo-rec-desp 
                                              then tipo-rec-desp.descricao else "".                                                
     end. 
     /*Totalizaá∆o da Fatura e geraá∆o dos impostos*/
     run rep/re0994e.p (input  rowid(docum-est),
                        output table tt-total,
                        output table tt-dupli-imp).

     run pi-atualiza-totais.

     if valid-handle(h-b05in567) then
        run pi-recebe-temp-table in h-b05in567 (input table tt-dupli-imp).

  end.
end.

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

/*assign l-rejeita-dec = no.*/

/*assign fi-despesa-nota-fat:screen-value in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} fi-despesa-nota-fat, 0)).*/

/*if l-rejeita-dec then do:    
    {utp/ut-liter.i Valor_Despesa * r}
    run utp/ut-msgs.p(input "show", 
                      input 18130, 
                        input trim(return-value)).
    apply 'entry':U to fi-despesa-nota-fat in frame {&frame-name}.
    return 'adm-error':U.

end.*/

/*/*    Segue um exemplo de validaá∆o de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/

    find espec-ap where 
         espec-ap.cod-esp = input frame {&frame-name} fi-cod-esp
         no-lock no-error.
    if  not avail espec-ap then do:
        {include/i-vldprg.i} 
        {utp/ut-table.i mgadm espec-ap 1}
        run utp/ut-msgs.p (input "show":U, input 7, input return-value).
        apply "entry":U to fi-cod-esp in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.
    if  espec-ap.tipo = 2 then do:
        {include/i-vldprg.i} 
        run utp/ut-msgs.p (input "show":U, input 625, input "").
        apply "entry" to fi-cod-esp in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.

    find tipo-rec-desp where
         tipo-rec-desp.tp-codigo = input frame {&frame-name} fi-tp-despesa no-lock no-error.
    if  not avail tipo-rec-desp then do:
        {include/i-vldprg.i} 
        {utp/ut-table.i mgadm tipo-rec-desp 1}
        run utp/ut-msgs.p (input "show":U, input 7, input return-value).
        apply "entry":U to fi-tp-despesa in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.     
    if  tipo-rec-desp.tipo = 1 then do:
        {include/i-vldprg.i} 
        run utp/ut-msgs.p (input "show":U, input 4995, "").
        apply "entry":U to fi-tp-despesa in frame {&frame-name}.
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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartViewer, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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


