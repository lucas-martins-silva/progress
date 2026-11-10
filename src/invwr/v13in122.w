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
{include/i-prgvrs.i V13IN122 2.00.00.019}  /*** 010019 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V13IN122 MUT}
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
{include/i_fnctrad.i} 
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def new global shared var gr-familia  as rowid no-undo.

/*********************** Multi-Planta ***********************************/
def var  i-tipo-movto   as integer   no-undo.
def var  l-cria         as logical   no-undo.

{cdp/cd7300.i1}
{cdp/cd0669.i}
/*******************  Fim  Multi-Planta  ********************************/

    /**  Melhorias
    **/
    {cdp/cdcfgmat.i}
    def var c-lista-prioridade   as char no-undo.
    def var c-replica-prioridade as char no-undo.
    def var c-replica-variacao   as char no-undo.
    def var i-prioridade         as inte no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES familia
&Scoped-define FIRST-EXTERNAL-TABLE familia


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR familia.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS familia.perc-nqa familia.curva-abc ~
familia.demanda familia.contr-qualid familia.emissao-ord ~
familia.perm-saldo-neg familia.tipo-contr familia.criticidade 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}perc-nqa ~{&FP2}perc-nqa ~{&FP3}
&Scoped-define ENABLED-TABLES familia
&Scoped-define FIRST-ENABLED-TABLE familia
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-4 RECT-5 RECT-8 RECT-6 RECT-3 ~
RECT-7 
&Scoped-Define DISPLAYED-FIELDS familia.perc-nqa familia.curva-abc ~
familia.demanda familia.contr-qualid familia.emissao-ord ~
familia.perm-saldo-neg familia.tipo-contr familia.criticidade 
&Scoped-Define DISPLAYED-OBJECTS cb-nivel de-var-aprov cb-prioridade 

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
DEFINE VARIABLE cb-nivel AS CHARACTER FORMAT "X(1)":U 
     LABEL "N°vel" 
     VIEW-AS COMBO-BOX INNER-LINES 8
/*      LIST-ITEMS "Item 1" */
     SIZE 7.14 BY 1 NO-UNDO.

DEFINE VARIABLE cb-prioridade AS CHARACTER FORMAT "X(256)":U 
     LABEL "Prior. Aprov." 
     VIEW-AS COMBO-BOX INNER-LINES 5
/*      LIST-ITEMS "Item 1" */
     SIZE 13.72 BY 1 NO-UNDO.

DEFINE VARIABLE de-var-aprov AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "Variaá∆o Perm." 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE FILL-IN-4 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE FILL-IN-5 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41.29 BY 2.42.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41.29 BY 3.42.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 40 BY 1.67.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 40 BY 1.67.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 40 BY 1.67.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 40 BY 1.67.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41.29 BY 2.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     familia.perc-nqa AT ROW 1.63 COL 31.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     familia.curva-abc AT ROW 1.88 COL 5.43
          LABEL "Emiss∆o Curva ABC":L21
          VIEW-AS TOGGLE-BOX
          SIZE 21.72 BY .75
     familia.demanda AT ROW 1.92 COL 49 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Dependente", 1,
"Independente", 2
          SIZE 31.57 BY .75
     cb-nivel AT ROW 2.58 COL 31.43 COLON-ALIGNED
     familia.contr-qualid AT ROW 2.71 COL 5.43
          VIEW-AS TOGGLE-BOX
          SIZE 21.14 BY .75
     de-var-aprov AT ROW 4.25 COL 20.14 COLON-ALIGNED
     familia.emissao-ord AT ROW 4.29 COL 49 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Autom†tica", 1,
"Manual", 2
          SIZE 27.72 BY .75
     cb-prioridade AT ROW 5.21 COL 20.14 COLON-ALIGNED
     familia.perm-saldo-neg AT ROW 6.71 COL 49 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "N∆o", 1,
"Sim Confirmado", 2,
"Sim", 3
          SIZE 32.72 BY .75
     familia.tipo-contr AT ROW 7.17 COL 11.29 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "F°sico", 1,
"Total", 2,
"Consignado", 3,
"DÇbito Direto", 4
          SIZE 16.29 BY 2.92
     familia.criticidade AT ROW 9.08 COL 49 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "X", 1,
"Y", 2,
"Z", 3
          SIZE 26.43 BY .75
     FILL-IN-2 AT ROW 1 COL 46.86 COLON-ALIGNED NO-LABEL
     FILL-IN-3 AT ROW 3.42 COL 46.72 COLON-ALIGNED NO-LABEL
     FILL-IN-4 AT ROW 5.83 COL 46.29 COLON-ALIGNED NO-LABEL
     FILL-IN-1 AT ROW 6.54 COL 2.43 COLON-ALIGNED NO-LABEL
     FILL-IN-5 AT ROW 8.25 COL 46.57 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 1.38 COL 2
     RECT-4 AT ROW 1.38 COL 45
     RECT-5 AT ROW 3.75 COL 45
     RECT-8 AT ROW 4.04 COL 2
     RECT-6 AT ROW 6.13 COL 45
     RECT-3 AT ROW 6.75 COL 2
     RECT-7 AT ROW 8.5 COL 45
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.familia
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
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
         HEIGHT             = 9.67
         WIDTH              = 85.14.
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

/* SETTINGS FOR COMBO-BOX cb-nivel IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       cb-nivel:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR COMBO-BOX cb-prioridade IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       cb-prioridade:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX familia.curva-abc IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN de-var-aprov IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       de-var-aprov:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-4 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-5 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       familia.perc-nqa:HIDDEN IN FRAME f-main           = TRUE.

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



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

  /**  Melhorias
  **/
  &if defined(bf_mat_aprova_eletronica) &then
      {utp/ut-liter.i Variaá∆o_Perm. * r}
      assign de-var-aprov:label in frame {&frame-name} = trim(return-value).
      {utp/ut-liter.i Prior._Aprov. * r}
      assign cb-prioridade:label in frame {&frame-name} = trim(return-value).
      {utp/ut-liter.i Muito_Alta * r}
      assign c-lista-prioridade = trim(return-value).
      {utp/ut-liter.i Alta * r}
      assign c-lista-prioridade = c-lista-prioridade + " ," + trim(return-value).    
      {utp/ut-liter.i MÇdia * r}
      assign c-lista-prioridade = c-lista-prioridade + " ," + trim(return-value).    
      {utp/ut-liter.i Baixa * r}
      assign c-lista-prioridade = c-lista-prioridade + " ," + trim(return-value).    
  &endif

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
  {src/adm/template/row-list.i "familia"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "familia"}

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

    /**  Melhorias
    **/
    &if defined(bf_mat_aprova_eletronica) &then
        assign cb-prioridade = entry(4,c-lista-prioridade).
        display cb-prioridade with frame {&frame-name}.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  &if  "{&bf_mat_versao_ems}" >= "2.04" &then
       if  familia.contr-qualid:checked in frame {&frame-name} then do:
            /* valida nqa */
            find first nqa-simp 
                 where nqa-simp.perc-nqa = input frame {&FRAME-NAME} familia.perc-nqa no-lock no-error.
            if not avail nqa-simp then do:
               {utp/ut-liter.i "NQA" * r }
               run utp/ut-msgs.p (input "show",
                                  input 2,
                                  input return-value).
               apply 'entry' to familia.perc-nqa in frame {&FRAME-NAME}.
               return 'adm-error'.
            end.

           /* valida nivel */
           find first nivel-insp 
                where nivel-insp.nivel = integer(input frame {&frame-name} cb-nivel) 
                no-lock no-error.
           if not avail nivel-insp then do:
              {utp/ut-liter.i N°vel * r }
              run utp/ut-msgs.p (input "show",
                                 input 2,
                                 input return-value).
              apply 'entry' to cb-nivel in frame {&FRAME-NAME}.
              return 'adm-error'.
           end.
       end.
  &endif


  /* Code placed here will execute PRIOR to standard behavior. */

    /**  Melhorias
    **/
    &if defined(bf_mat_aprova_eletronica) &then
        assign input frame {&frame-name} cb-prioridade
               input frame {&frame-name} de-var-aprov.
    &endif

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

  &if  "{&bf_mat_versao_ems}" >= "2.04" &then
        assign familia.nivel = int(cb-nivel:screen-value in frame {&frame-name}).
  &endif  



    /**  Melhorias
    **/
    &if defined(bf_mat_aprova_eletronica) &then
        find familia-mat where
            familia-mat.fm-codigo = familia.fm-codigo
            exclusive-lock no-error.
        if available familia-mat then do:
            assign familia-mat.variacao-perm = de-var-aprov.
            case lookup(cb-prioridade,replace(c-lista-prioridade," ,",",")):
                when 1 then assign familia-mat.prioridade-aprov = 999.
                when 2 then assign familia-mat.prioridade-aprov = 750.
                when 3 then assign familia-mat.prioridade-aprov = 450.
                when 4 then assign familia-mat.prioridade-aprov = 150.
            end case.
        end.
        assign i-prioridade = familia-mat.prioridade-aprov.
        release familia-mat.

    &endif

  /*********************** Multi-Planta ***********************************/ 

  assign c-transacao = "MAT031".

  assign i-tipo-movto = 2.  
  run pi-cria-tt-dados (input i-tipo-movto).


  /*******************  Fim  Multi-Planta  ********************************/

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

  /**  Melhorias
  **/
  &if defined(bf_mat_aprova_eletronica) &then
      assign cb-prioridade:sensitive in frame {&frame-name} = no
             de-var-aprov:sensitive  in frame {&frame-name} = no.
  &endif

  &if "{&bf_mat_versao_ems}" >= "2.04" &then
       assign cb-nivel:sensitive in frame {&frame-name} = no.
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

  {utp/ut-rtlbl.i mgind familia tipo-contr fill-in-1}
  {utp/ut-rtlbl.i mgind familia demanda fill-in-2}
  {utp/ut-rtlbl.i mgind familia emissao-ord fill-in-3}
  {utp/ut-rtlbl.i mgind familia perm-saldo-neg fill-in-4}
  {utp/ut-rtlbl.i mgind familia criticidade fill-in-5}

    /**  Melhorias
    **/
    &if defined(bf_mat_aprova_eletronica) &then
        find familia-mat where
            familia-mat.fm-codigo = familia.fm-codigo
            no-lock no-error.
        if available familia-mat then do:
            display familia-mat.variacao-perm @ de-var-aprov with frame {&frame-name}.
            if  familia-mat.prioridade-aprov >= 0 and
                familia-mat.prioridade-aprov <= 300 then
                assign cb-prioridade = entry(4,c-lista-prioridade).
            if  familia-mat.prioridade-aprov >  300 and
                familia-mat.prioridade-aprov <= 600 then
                assign cb-prioridade = entry(3,c-lista-prioridade).
            if  familia-mat.prioridade-aprov >  600 and
                familia-mat.prioridade-aprov <  999 then
                assign cb-prioridade = entry(2,c-lista-prioridade).
            if  familia-mat.prioridade-aprov =  999 then
                assign cb-prioridade = entry(1,c-lista-prioridade).
            display cb-prioridade with frame {&frame-name}.
        end.
    &endif

    &if "{&bf_mat_versao_ems}" >= "2.04" &then
       &IF "{&fnc_multi_idioma}":U = "yes":U &THEN
            Def var c-lista as char no-undo.
            Assign c-lista = "0,1,2,3,4,5,6,7".
            run utp/ut-lstit.p (input-output c-lista).
            assign cb-nivel:list-item-pairs   in frame {&frame-name} = c-lista
                   cb-nivel:screen-value in frame {&frame-name} = string(familia.nivel).
       &else 
            assign cb-nivel:list-items   in frame {&frame-name} = "0,1,2,3,4,5,6,7"
                   cb-nivel:screen-value in frame {&frame-name} = string(familia.nivel).
            disp familia.perc-nqa with frame {&FRAME-NAME}.
       &endif
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
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  /**  Melhorias
  **/
  &if defined(bf_mat_aprova_eletronica) &then
      if adm-new-record then do:
            assign cb-prioridade = entry(4,c-lista-prioridade).
            display cb-prioridade with frame {&frame-name}.
      end.
      assign cb-prioridade:sensitive in frame {&frame-name} = yes
             de-var-aprov:sensitive  in frame {&frame-name} = yes.
  &endif

  &if "{&bf_mat_versao_ems}" >= "2.04" &then
       assign cb-nivel:sensitive in frame {&frame-name} = yes.
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
  &if defined(bf_mat_aprova_eletronica) &then
      assign cb-prioridade:list-items in frame {&frame-name} = c-lista-prioridade.
  &endif
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  {utp/ut-rtlbl.i mgind familia tipo-contr fill-in-1}
  {utp/ut-rtlbl.i mgind familia demanda fill-in-2}
  {utp/ut-rtlbl.i mgind familia emissao-ord fill-in-3}
  {utp/ut-rtlbl.i mgind familia perm-saldo-neg fill-in-4}
  {utp/ut-rtlbl.i mgind familia criticidade fill-in-5}
  {utp/ut-liter.i Controle_Qualidade * R}
  assign familia.contr-qualid:label in frame {&frame-name} = return-value.

  /**  Melhorias
  **/
  &if defined(bf_mat_aprova_eletronica) &then
      assign cb-prioridade:hidden in frame {&frame-name} = no
             de-var-aprov:hidden  in frame {&frame-name} = no.
  &endif

  &if "{&bf_mat_versao_ems}" >= "2.04" &then
      {utp/ut-field.i mgind item nivel 1}
      assign cb-nivel:label           in frame {&FRAME-NAME} = return-value
             cb-nivel:hidden          in frame {&FRAME-NAME} = no
             familia.perc-nqa:hidden  in frame {&FRAME-NAME} = no.
  &endif


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

   if  avail familia then
      assign gr-familia = rowid(familia).  


  /* Code placed here will execute AFTER standard behavior.    */

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

  /* Ponha aqui as demais validaá‰es */

  /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

def var h-cdapi150 as handle no-undo.

find first param-global no-lock no-error.
if param-global.modulo-mp then do:

    run cdp/cdapi150.p persistent set h-cdapi150
        (input ?, ?, ?, ?, input-output table tt-erro).    

    run pi-gera-log in h-cdapi150 
                      (input  "familia" ,
                       input rowid(familia),
                       input i-tipo-movto,
                       input c-transacao,
                       input-output table tt-erro).

    &if defined(bf_mat_tipo_ressup) &then
        find familia-mat where
             familia-mat.fm-codigo = familia.fm-codigo no-lock no-error.        
        run pi-gera-log in h-cdapi150 
                          (input "familia-mat",
                           input rowid(familia-mat),
                           input i-tipo-movto,
                           input c-transacao,
                           input-output table tt-erro).
    &endif

    run pi-finaliza in h-cdapi150 (input c-transacao).

    delete procedure h-cdapi150.
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
  {src/adm/template/snd-list.i "familia"}

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


