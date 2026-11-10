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
{include/i-prgvrs.i V01IN567 2.00.00.019}  /*** 010019 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01in567 MUT}
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
def /*new global shared*/  var v-row-parent    as rowid no-undo.
def new global shared var gr-dupli-apagar as rowid no-undo.
def new global shared var gr-dupli-imp    as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var c-retencao as character no-undo.
def var c-cod-rend as character no-undo.
def var da-dt-venc-imp as date no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES dupli-imp
&Scoped-define FIRST-EXTERNAL-TABLE dupli-imp


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR dupli-imp.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS dupli-imp.cod-esp dupli-imp.nro-docto-imp ~
dupli-imp.parcela-imp dupli-imp.dt-venc-imp dupli-imp.rend-trib ~
dupli-imp.aliquota dupli-imp.vl-imposto dupli-imp.tp-codigo ~
dupli-imp.cod-retencao 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cod-esp ~{&FP2}cod-esp ~{&FP3}~
 ~{&FP1}nro-docto-imp ~{&FP2}nro-docto-imp ~{&FP3}~
 ~{&FP1}parcela-imp ~{&FP2}parcela-imp ~{&FP3}~
 ~{&FP1}dt-venc-imp ~{&FP2}dt-venc-imp ~{&FP3}~
 ~{&FP1}rend-trib ~{&FP2}rend-trib ~{&FP3}~
 ~{&FP1}aliquota ~{&FP2}aliquota ~{&FP3}~
 ~{&FP1}vl-imposto ~{&FP2}vl-imposto ~{&FP3}~
 ~{&FP1}tp-codigo ~{&FP2}tp-codigo ~{&FP3}~
 ~{&FP1}cod-retencao ~{&FP2}cod-retencao ~{&FP3}
&Scoped-define ENABLED-TABLES dupli-imp
&Scoped-define FIRST-ENABLED-TABLE dupli-imp
&Scoped-Define ENABLED-OBJECTS RECT-65 RECT-66 
&Scoped-Define DISPLAYED-FIELDS dupli-imp.int-1 dupli-imp.cod-esp ~
dupli-imp.nro-docto-imp dupli-imp.parcela-imp dupli-imp.dt-venc-imp ~
dupli-imp.rend-trib dupli-imp.aliquota dupli-imp.vl-imposto ~
dupli-imp.tp-codigo dupli-imp.cod-retencao 
&Scoped-Define DISPLAYED-OBJECTS fi-imposto fi-especie c-serie fi-despesa 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS dupli-imp.int-1 
&Scoped-define ADM-ASSIGN-FIELDS dupli-imp.cod-esp 

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
DEFINE VARIABLE c-serie AS CHARACTER FORMAT "X(5)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 6.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-despesa AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-especie AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-imposto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.72 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-65
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 4.46.

DEFINE RECTANGLE RECT-66
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.43 BY 6.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     dupli-imp.int-1 AT ROW 1.33 COL 33.86 COLON-ALIGNED FORMAT ">>>9"
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     fi-imposto AT ROW 1.33 COL 40 COLON-ALIGNED NO-LABEL
     dupli-imp.cod-esp AT ROW 2.33 COL 33.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     fi-especie AT ROW 2.33 COL 40 COLON-ALIGNED NO-LABEL
     c-serie AT ROW 3.33 COL 33.86 COLON-ALIGNED
     dupli-imp.nro-docto-imp AT ROW 4.29 COL 33.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .88
     dupli-imp.parcela-imp AT ROW 4.29 COL 48.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     dupli-imp.dt-venc-imp AT ROW 5.88 COL 34.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     dupli-imp.rend-trib AT ROW 6.88 COL 34.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     dupli-imp.aliquota AT ROW 7.88 COL 34.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     dupli-imp.vl-imposto AT ROW 8.88 COL 34.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.72 BY .88
     dupli-imp.tp-codigo AT ROW 9.88 COL 34.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     fi-despesa AT ROW 9.88 COL 39.57 COLON-ALIGNED NO-LABEL
     dupli-imp.cod-retencao AT ROW 10.88 COL 34.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     RECT-65 AT ROW 1 COL 1
     RECT-66 AT ROW 5.67 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.dupli-imp
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
         HEIGHT             = 11.13
         WIDTH              = 88.57.
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

/* SETTINGS FOR FILL-IN c-serie IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dupli-imp.cod-esp IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN fi-despesa IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-especie IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-imposto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dupli-imp.int-1 IN FRAME f-main
   NO-ENABLE 1 EXP-FORMAT                                               */
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

&Scoped-define SELF-NAME dupli-imp.aliquota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dupli-imp.aliquota V-table-Win
ON LEAVE OF dupli-imp.aliquota IN FRAME f-main /* Al¡quota */
DO:
    assign dupli-imp.vl-imposto:screen-value in frame {&frame-name} =
        string(input frame {&frame-name} dupli-imp.rend-trib *
               input frame {&frame-name} dupli-imp.aliquota / 100).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-serie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-serie V-table-Win
ON F5 OF c-serie IN FRAME f-main
DO:
    l-implanta      = yes.
    {include/zoomvar.i &prog-zoom=inzoom/z01in407.w
                       &campo=c-serie
                       &campozoom=serie}

             
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-serie V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-serie IN FRAME f-main
DO:
   apply 'F5' to self.  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dupli-imp.cod-esp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dupli-imp.cod-esp V-table-Win
ON F5 OF dupli-imp.cod-esp IN FRAME f-main /* Esp‚cie */
OR  MOUSE-SELECT-DBLCLICK OF dupli-imp.cod-esp IN FRAME {&FRAME-NAME} DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad104.w
                       &campo=dupli-imp.cod-esp
                       &campozoom=cod-esp}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dupli-imp.cod-esp V-table-Win
ON LEAVE OF dupli-imp.cod-esp IN FRAME f-main /* Esp‚cie */
DO:
    {include/leave.i &tabela=espec-ap
                     &atributo-ref=descricao
                     &variavel-ref=fi-especie
                     &where="espec-ap.cod-esp = input frame {&frame-name}
                             dupli-imp.cod-esp"}

        assign da-dt-venc-imp = if avail dupli-apagar then dupli-apagar.dt-vencim
                                else ?.            
        if avail espec-ap 
        and i-pais-impto-usuario = 1 then do:
            if  espec-ap.tipo = 8 /*retencao*/ then do:           
                run pi-calcula-dt-vencto-ir(output da-dt-venc-imp).
                run pi-habilita-desabilita-retencao.
            end.
            else 
               run pi-calcula-dt-vencto-inss(output da-dt-venc-imp).
        end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dupli-imp.cod-retencao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dupli-imp.cod-retencao V-table-Win
ON F5 OF dupli-imp.cod-retencao IN FRAME f-main /* Cod Ret */
OR  MOUSE-SELECT-DBLCLICK OF dupli-imp.cod-retencao IN FRAME {&FRAME-NAME} DO:

    assign l-implanta = no.
    {include/zoomvar.i &prog-zoom = adzoom/z01ad999.w
                       &campo     = dupli-imp.cod-retencao    
                       &campozoom = tt-cod-ir.c-cod}

    if  c-retencao > "" then
        assign dupli-imp.cod-retencao:screen-value in frame {&frame-name} = 
            c-retencao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dupli-imp.int-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dupli-imp.int-1 V-table-Win
ON F5 OF dupli-imp.int-1 IN FRAME f-main /* int-1 */
DO:
    
    if  search("dizoom/z01di217.r") = ? and 
        search("dizoom/z01di217.w") = ? then do:
        run utp/ut-msgs.p (input "show",
                           input 4,
                           input "dizoom/z01di217.w").
    end.
    else do:
        assign l-implanta = yes.
        {include/zoomvar.i &prog-zoom="dizoom/z01di217.w"
                           &campo=dupli-imp.int-1
                           &campozoom=cod-tax}
    end. 
  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dupli-imp.int-1 V-table-Win
ON LEAVE OF dupli-imp.int-1 IN FRAME f-main /* int-1 */
DO:
    {include/leave.i &tabela=tipo-tax
                   &atributo-ref=descricao
                   &variavel-ref=fi-imposto
                   &where="tipo-tax.cod-tax = input frame {&frame-name}
                           dupli-imp.int-1"}
  
    assign dupli-imp.cod-retencao:sensitive in frame {&FRAME-NAME} = no.   
    
    if  avail tipo-tax then do:
    
        assign da-dt-venc-imp = if avail dupli-apagar then dupli-apagar.dt-vencim
                                else ?.            
        find espec-ap 
            where espec-ap.cod-esp = tipo-tax.cod-esp  no-lock no-error.
        if avail espec-ap 
        and i-pais-impto-usuario = 1 then do:
            if  espec-ap.tipo = 8 /*retencao*/ then do:           
                run pi-calcula-dt-vencto-ir(output da-dt-venc-imp).
                run pi-habilita-desabilita-retencao.
            end.
            else 
               run pi-calcula-dt-vencto-inss(output da-dt-venc-imp).
        end.
        
        assign dupli-imp.cod-esp:screen-value in frame {&FRAME-NAME} = tipo-tax.cod-esp
               fi-especie:screen-value in frame {&FRAME-NAME} = if avail espec-ap then espec-ap.descricao 
                                                                                  else ""
               dupli-imp.aliquota:screen-value in frame {&FRAME-NAME} = string(tipo-tax.tax-perc)
               dupli-imp.dt-venc-imp:screen-value in frame {&FRAME-NAME} = string(da-dt-venc-imp)
               c-serie:screen-value in frame {&frame-name}  = string(tipo-tax.serie).

    end.
    else
        assign dupli-imp.cod-esp:screen-value in frame {&FRAME-NAME} = ""
               fi-especie:screen-value in frame {&FRAME-NAME}        = ""
               c-serie:screen-value in frame {&frame-name}           = "".

    if  available dupli-apagar then do with frame {&frame-name}:
        assign dupli-imp.rend-trib:screen-value     = string(dupli-apagar.vl-a-pagar)
               dupli-imp.vl-imposto:screen-value    = string(dupli-apagar.vl-a-pagar * 
                                                          (input dupli-imp.aliquota / 100))
               dupli-imp.nro-docto-imp:screen-value = string(dupli-apagar.nro-docto)
               dupli-imp.parcela-imp:screen-value   = string(dupli-apagar.parcela)
                                                          .
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dupli-imp.int-1 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF dupli-imp.int-1 IN FRAME f-main /* int-1 */
DO:
  apply "F5" to self.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dupli-imp.tp-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dupli-imp.tp-codigo V-table-Win
ON F5 OF dupli-imp.tp-codigo IN FRAME f-main /* Tp Recta/Desp */
OR  MOUSE-SELECT-DBLCLICK OF dupli-imp.tp-codigo IN FRAME {&FRAME-NAME} DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad259.w
                       &campo=dupli-imp.tp-codigo
                       &campozoom=tp-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dupli-imp.tp-codigo V-table-Win
ON LEAVE OF dupli-imp.tp-codigo IN FRAME f-main /* Tp Recta/Desp */
DO:
    {include/leave.i &tabela=tipo-rec-desp
                     &atributo-ref=descricao
                     &variavel-ref=fi-despesa
                     &where="tipo-rec-desp.tp-codigo = input frame {&frame-name}
                             dupli-imp.tp-codigo"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dupli-imp.vl-imposto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dupli-imp.vl-imposto V-table-Win
ON LEAVE OF dupli-imp.vl-imposto IN FRAME f-main /* Valor Imposto */
DO:
    assign dupli-imp.aliquota:screen-value in frame {&frame-name} =
        string(input frame {&frame-name} dupli-imp.vl-imposto * 100 /
               input frame {&frame-name} dupli-imp.rend-trib ).

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

  find dupli-apagar where rowid(dupli-apagar) = gr-dupli-apagar no-lock no-error.

  if dupli-imp.int-1:load-mouse-pointer("image/lupa.cur")
     in frame {&frame-name} then .
  if dupli-imp.cod-esp:load-mouse-pointer("image/lupa.cur")
     in frame {&frame-name} then .
  if dupli-imp.tp-codigo:load-mouse-pointer("image/lupa.cur")
     in frame {&frame-name} then .
  if dupli-imp.cod-retencao:load-mouse-pointer("image/lupa.cur")
     in frame {&frame-name} then .
  if c-serie:load-mouse-pointer("image/lupa.cur")
     in frame {&frame-name} then .

  {utp/ut-field.i mgdis tipo-tax cod-tax 1}
  assign dupli-imp.int-1:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i S‚rie_Imposto * r}
  assign c-serie:label in frame {&frame-name} = trim(return-value).

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
  {src/adm/template/row-list.i "dupli-imp"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "dupli-imp"}

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
  if  available dupli-apagar then do with frame {&frame-name}:
      assign dupli-imp.rend-trib:screen-value = string(dupli-apagar.vl-a-pagar).
  end.
  
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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
  
  assign c-serie = input frame {&frame-name} c-serie.
                  
  if  dupli-imp.int-1:sensitive in frame {&frame-name} 
  and can-find(dupli-imp 
         where dupli-imp.cod-emitente       = dupli-apagar.cod-emitente
           and dupli-imp.nat-operacao       = dupli-apagar.nat-operacao
           and dupli-imp.serie-docto        = dupli-apagar.serie-docto
           and dupli-imp.nro-docto          = dupli-apagar.nro-docto
           and dupli-imp.parcela            = dupli-apagar.parcela
           and dupli-imp.cod-esp            = input frame {&frame-name} dupli-imp.cod-esp) then do:
      {utp/ut-table.i mgind dupli-imp 1}
      run utp/ut-msgs.p ( input "show":U, input 7, input return-value ).
      apply "entry":U to dupli-imp.int-1 in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.

  
  
  if  dupli-imp.int-1:sensitive in frame {&frame-name} then do:
      find tipo-tax no-lock
           where tipo-tax.cod-tax = input frame {&frame-name} dupli-imp.int-1 no-error.

      if  not avail tipo-tax then do:
          run utp/ut-msgs.p ( input "show",
                              input 3459,
                              input "" ).
          apply "entry":U to dupli-imp.int-1 in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.         


      find espec-ap 
          where espec-ap.cod-esp = input frame {&frame-name} dupli-imp.cod-esp no-lock no-error.
      if  not avail espec-ap then do:
          run utp/ut-msgs.p ( input "show",
                              input 901,
                              input "" ).
          apply "entry" to dupli-imp.int-1 in frame {&frame-name}.                           
          return 'ADM-ERROR':U.
      end.
      
      /*--- Tipo de Imposto deve ser Reten‡Æo ---*/
      if  tipo-tax.tipo <> 1 then do:
          run utp/ut-msgs.p (input "show",
                             input 7267,
                             input " ").
          apply 'entry' to dupli-imp.int-1 in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.    

      /*--- Se a especie for normal a mesma dever  ser de reten‡Æo (INSS) ---*/
      if  espec-ap.tipo = 1 and espec-ap.log-1 = no then do:
          run utp/ut-msgs.p (input "show",
                             input 17369,
                             input input frame {&FRAME-NAME} dupli-imp.cod-esp).
          apply 'entry' to dupli-imp.cod-esp in frame {&FRAME-NAME}.
          return 'ADM-ERROR':U.
      end.
    
      if  tipo-tax.tipo = 1 then do:    /* Imposto do Tipo Reten‡Æo */
       
          if  ( espec-ap.log-1 and espec-ap.tipo <> 1 )          /* Esp‚cie INSS com tipo diferenre de Normal */
          or  ( not espec-ap.log-1 and espec-ap.tipo <> 8 ) then /* NÆo ‚ INSS com tipo diferente de Reten‡Æo */ 
          do:
              run utp/ut-msgs.p ( input "show",
                                  input 1002,
                                  input "" ).
              apply "entry" to dupli-imp.cod-esp in frame {&frame-name}.                                                          
              return 'ADM-ERROR':U.     
          end.
      end.
    
      if  tipo-tax.tipo = 3 then do:   /* Imposto do Tipo Taxado */

          if  espec-ap.tipo <> 1                  /* Esp‚cie com tipo diferente de Normal */ 
          or  espec-ap.log-1     then do:         /* Esp‚cie INSS com tipo Normal */           
              run utp/ut-msgs.p ( input "show",
                                  input 1002,
                                  input "" ).
              apply "entry" to dupli-imp.cod-esp in frame {&frame-name}.                                                          
              return 'ADM-ERROR':U.                                                            
          end.    
      end.

      find lin-i-ap 
            where lin-i-ap.ep-codigo   = param-global.empresa-prin
              and lin-i-ap.cod-estabel = dupli-apagar.cod-estabel
              and lin-i-ap.cod-esp     = input frame {&frame-name} dupli-imp.cod-esp
              and lin-i-ap.serie       = c-serie
              and lin-i-ap.nr-docto    = input frame {&frame-name} dupli-imp.nro-docto-imp
              and lin-i-ap.parcela     = input frame {&frame-name} dupli-imp.parcela-imp
              and lin-i-ap.cod-fornec  = dupli-apagar.cod-emitente
              no-lock no-error.
      if  avail lin-i-ap then do:
          run utp/ut-msgs.p (input "show":U, input 5402, "").
          apply "entry":U to dupli-imp.int-1 in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
      find tit-ap 
           where tit-ap.ep-codigo   = param-global.empresa-prin
             and tit-ap.cod-estabel = dupli-apagar.cod-estabel
             and tit-ap.cod-esp     = input frame {&frame-name} dupli-imp.cod-esp
             and tit-ap.serie       = c-serie
             and tit-ap.nr-docto    = input frame {&frame-name} dupli-imp.nro-docto-imp
             and tit-ap.parcela     = input frame {&frame-name} dupli-imp.parcela-imp
             and tit-ap.cod-fornec  = dupli-apagar.cod-emitente
                 no-lock no-error.
      if  avail tit-ap then do:
          run utp/ut-msgs.p (input "show":U, input 17507, "").
          apply "entry" to dupli-imp.int-1 in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
      
     
  end.

  /*--- Valida S‚rie do Documento ---*/
  if  input frame {&FRAME-NAME} c-serie <> "" then do:
      find first serie where serie.serie = input frame {&FRAME-NAME} c-serie no-lock no-error.
        if  not avail serie then do:
            run utp/ut-msgs.p (input "show",
                               input 1116,
                               input input frame {&FRAME-NAME} c-serie).
            apply 'entry' to c-serie in frame {&FRAME-NAME}.
            return 'ADM-ERROR':U.
        end.
  end.
    
  find tipo-rec-desp 
      where tipo-rec-desp.tp-codigo = input dupli-imp.tp-codigo no-lock no-error.
      
  if  not avail tipo-rec-desp then do:
      {utp/ut-table.i mgadm tipo-rec-desp 1}
      run utp/ut-msgs.p ( input "show":U, input 2, input return-value ).
      apply "entry":U to dupli-imp.tp-codigo in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.     
  if  tipo-rec-desp.tipo = 1 then do:
      run utp/ut-msgs.p ( input "show":U, input 4995, "" ).
      apply "entry":U to dupli-imp.tp-codigo in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.

  find param-ap 
      where param-ap.ep-codigo = param-global.empresa-prin no-lock no-error.    

  if  available param-ap and
      input frame {&frame-name} dupli-imp.dt-venc-imp < param-ap.dt-ult-fec then do:
      run utp/ut-msgs.p ( input "show":U, input 6259, "" ).
      apply "entry":U to dupli-imp.dt-venc-imp in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  
  if  input frame {&frame-name} dupli-imp.dt-venc-imp < dupli-apagar.dt-trans then do:
      run utp/ut-msgs.p ( input "show":U, input 634, 
                          input string(input frame {&frame-name} dupli-imp.dt-venc-imp)
                          + "~~" + string(dupli-apagar.dt-trans)  ).
      apply "entry":U to dupli-imp.dt-venc-imp in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.  
  if  input frame {&frame-name} dupli-imp.vl-imposto = 0 then do:
      run utp/ut-msgs.p ( input "show":U, input 4199, "" ).
      apply "entry":U to dupli-imp.vl-imposto in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end. 
  if  input frame {&frame-name} dupli-imp.aliquota = 0 then do:
      run utp/ut-msgs.p ( input "show":U, input 1074, "" ).
      apply "entry":U to dupli-imp.aliquota in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end. 
  find emitente 
     where emitente.cod-emitente = dupli-apagar.cod-emitente no-lock no-error.
  
  assign c-cod-rend  = "0561,0588,2063,2281,1283,0730,8053,3426,2103,3674,0924,"
                     + "3208,0764,3277,0297,3251,3223,3264,3249,0916,8045,1708,"
                     + "3280,0422,0481,0430,0490,0473,0190,0246,6015,4600,3317,"
                     + "4424,9991".
                     
  if  dupli-imp.cod-retencao:sensitive in frame {&FRAME-NAME}
  then do with frame {&frame-name}:
      if lookup(string(input dupli-imp.cod-retencao,"9999"), c-cod-rend) = 0
      then do:
          run utp/ut-msgs.p ( input "show":U, input 843, 
                              input (input frame {&frame-name} dupli-imp.cod-retencao) ).
          if  return-value = "no" then do:
              apply "entry":U to dupli-imp.cod-retencao in frame {&frame-name}.
              return 'ADM-ERROR':U.
          end.   
      end.
  end.
  
  if  input frame {&frame-name} dupli-imp.vl-imposto > input frame {&frame-name} dupli-imp.rend-trib 
  or  input frame {&frame-name} dupli-imp.vl-imposto > dupli-apagar.vl-a-pagar then 
  do:
      run utp/ut-msgs.p ( input "show",
                          input "15972",
                          input "" ).
      apply "entry":U to dupli-imp.vl-imposto in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.      
        
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.
  
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */
  
  
  
  if  avail dupli-apagar then do:
      assign dupli-imp.cod-emitente       = dupli-apagar.cod-emitente
             dupli-imp.nat-operacao       = dupli-apagar.nat-operacao
             dupli-imp.serie-docto        = dupli-apagar.serie-docto
             dupli-imp.nro-docto          = dupli-apagar.nro-docto
             dupli-imp.parcela            = dupli-apagar.parcela
             substr(dupli-imp.char-1,1,5) = c-serie.
  end.           
 
 
 
  
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
  if  avail dupli-imp then do:
        
      find tipo-tax where tipo-tax.cod-tax = dupli-imp.int-1 
            no-lock no-error.
      find tipo-rec-desp where tipo-rec-desp.tp-codigo = dupli-imp.tp-codigo
           no-lock no-error.     
      find espec-ap where espec-ap.cod-esp = dupli-imp.cod-esp no-lock no-error.
      assign fi-despesa = if avail tipo-rec-desp then tipo-rec-desp.descricao else ""
             fi-especie = if avail espec-ap  then espec-ap.descricao else ""
             fi-imposto = if avail tipo-tax then tipo-tax.descricao else "".
      
  end.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

   if avail dupli-imp then
      assign c-serie:screen-value in frame {&frame-name} = substr(dupli-imp.char-1,1,5).
      

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

  assign dupli-imp.cod-retencao:sensitive in frame {&FRAME-NAME} = no.   
 
  if  avail dupli-imp 
  and i-pais-impto-usuario = 1 then 
      run pi-habilita-desabilita-retencao.

  if not adm-new-record then do with frame {&FRAME-NAME}:
     assign dupli-imp.int-1:sensitive         = no
            dupli-imp.cod-esp:sensitive       = no
            c-serie:sensitive                 = no
            fi-especie:sensitive              = no
            dupli-imp.nro-docto-imp:sensitive = no
            dupli-imp.parcela-imp:sensitive   = no. 
  end.          
/*  else do with frame {&FRAME-NAME}:
 *      assign c-serie:sensitive = yes.
 *   end.    */



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

  find dupli-apagar where rowid(dupli-apagar) = gr-dupli-apagar no-lock no-error.
  
  find first param-global no-lock no-error.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  if avail dupli-imp then
     assign gr-dupli-imp = rowid(dupli-imp).

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-dt-vencto-inss V-table-Win 
PROCEDURE pi-calcula-dt-vencto-inss :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output parameter da-data as date no-undo.
def var da-inss as date no-undo.

     assign da-data = dupli-apagar.dt-emiss.
     if  month(da-data) < 12 then 
         assign da-data = date( month(da-data) + 1, 2,
                                  year(da-data)).
     else 
         assign da-data = date( 1, 2, year(da-data) + 1).

     find first calen-coml
        where calen-coml.ep-codigo   = lin-i-ap.ep-codigo
          and calen-coml.cod-estabel = lin-i-ap.cod-estabel
          and calen-coml.data        = da-data
         no-lock no-error.
     if  avail calen-coml then do: 
         if  calen-com.tipo-dia <> 1 then do: 
             assign da-inss = da-data + 1.
             repeat:
                 find next calen-coml
                    where calen-coml.ep-codigo   = lin-i-ap.ep-codigo
                      and calen-coml.cod-estabel = lin-i-ap.cod-estabel
                      and calen-coml.data        = da-inss
                     no-lock no-error.
                 if  avail calen-coml then do:
                     if  calen-coml.tipo-dia = 1 then do:
                         assign da-data = da-inss.        
                         leave.
                     end.
                     assign da-inss = da-inss + 1.
                 end.
                 else
                     leave.
             end.
         end.
    end.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-dt-vencto-ir V-table-Win 
PROCEDURE pi-calcula-dt-vencto-ir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output parameter da-data as date no-undo.
def var i-dia-ir as integer no-undo.
def var i-dias   as integer no-undo.
def var i-cont1  as integer no-undo.
def var i-dia    as integer no-undo.

    find empresa-ir
       where empresa-ir.ep-codigo = i-ep-codigo-usuario no-lock no-error.
    if  not avail empresa-ir then do:
        assign i-dia-ir = 3.                                          
    end.
    else do:
        assign i-dia-ir = empresa-ir.prazo-pagto.
    end.
    find first emitente where emitente.cod-emitente = dupli-apagar.cod-emitente no-lock no-error.
    if avail emitente then do:                                
       
       if  emitente.natureza >= 2 then do:
           assign da-data = dupli-apagar.dt-trans.
       end.

       if  emitente.natureza = 1 then do:
           assign da-data = dupli-apagar.dt-vencim.
       end.
       
       do  i-cont1 = 1 to 7:
           assign i-dia = weekday(da-data).
           if  i-dia = 1 then
               leave.
           assign da-data = da-data + 1.
       end.
       
       repeat:
           assign da-data = da-data + 1.
           find calen-coml
              where calen-coml.ep-codigo   = dupli-apagar.ep-codigo
                and calen-coml.cod-estabel = dupli-apagar.cod-estabel
                and calen-coml.data        = da-data
              no-lock no-error.
              
           if  not avail calen-coml then 
               leave.
           if  calen-coml.tipo = 1 then
               assign i-dias  = i-dias + 1.
           if  i-dias = i-dia-ir then
               leave.
       end.
/*       assign impto-tit-pend-ap.dt-vencimen:screen-value in frame {&frame-name}  = string(da-data).*/
   end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-desabilita-retencao V-table-Win 
PROCEDURE pi-habilita-desabilita-retencao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*find empresa-ir
 *    where empresa-ir.ep-codigo = i-ep-codigo-usuario no-lock no-error.
 * if avail empresa-ir then 
 *      assign dupli-imp.cod-retencao:sensitive in frame {&FRAME-NAME} = 
 *             if ((input frame {&frame-name} dupli-imp.int-1 = empresa-ir.cod-impto-ir-pf) or
 *                 (input frame {&frame-name} dupli-imp.int-1 = empresa-ir.cod-impto-ir-pj)) then yes
 *             else no.*/

find tipo-tax no-lock
    where tipo-tax.cod-tax = input frame {&frame-name} dupli-imp.int-1 no-error.

if  avail tipo-tax 
and tipo-tax.tipo = 1 then
    assign dupli-imp.cod-retencao:sensitive in frame {&frame-name} = yes.
else
    assign dupli-imp.cod-retencao:sensitive in frame {&frame-name}    = no
           dupli-imp.cod-retencao:screen-value in frame {&frame-name} = "".

                     
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
  {src/adm/template/snd-list.i "dupli-imp"}

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


