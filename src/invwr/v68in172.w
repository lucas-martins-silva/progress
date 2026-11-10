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
{include/i-prgvrs.i V68IN172 2.00.00.021}  /*** 010021 ***/

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

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
DEF NEW GLOBAL SHARED VAR gr-item AS rowid NO-UNDO.
def new global shared var c-estab-ini as character initial ""    no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
def new global shared var c-estab-fim as character initial "ZZZZZ" no-undo.
&ELSE
def new global shared var c-estab-fim as character initial "ZZZ" no-undo.
&ENDIF

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var h-handle as handle no-undo.
def var c-handle as char no-undo.
DEF VAR l-fn-fi-ref AS LOGICAL NO-UNDO.
  

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
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item.it-codigo item.un 
&Scoped-define ENABLED-TABLES item
&Scoped-define FIRST-ENABLED-TABLE item
&Scoped-Define ENABLED-OBJECTS RECT-21 rt-key rt-mold fi-lb-fis fi-lb-teor 
&Scoped-Define DISPLAYED-FIELDS item.it-codigo item.un 
&Scoped-define DISPLAYED-TABLES item
&Scoped-define FIRST-DISPLAYED-TABLE item
&Scoped-Define DISPLAYED-OBJECTS fi-descricao fi-ref cb-ref c-descricao-refer ~
fi-quant-segur fi-saldo-inic fi-saldo-inic-teor de-saldo-fat fi-saldo-terc ~
fi-saldo-terc-teor fi-lb-fis fi-lb-teor 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS fi-ref 

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
DEFINE VARIABLE cb-ref AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 17.43 BY 1 NO-UNDO.

DEFINE VARIABLE c-descricao-refer AS CHARACTER FORMAT "x(32)" 
     VIEW-AS FILL-IN 
     SIZE 31.29 BY .88 NO-UNDO.

DEFINE VARIABLE de-saldo-fat AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Faturamento Pendente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-descricao AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 58.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-lb-fis AS CHARACTER FORMAT "X(256)":U INITIAL "F°sico:" 
      VIEW-AS TEXT 
     SIZE 8 BY .67 NO-UNDO.

DEFINE VARIABLE fi-lb-teor AS CHARACTER FORMAT "X(256)":U INITIAL "Te¢rico:" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE fi-ref AS CHARACTER FORMAT "X(10)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 17.43 BY .88 NO-UNDO.     

DEFINE VARIABLE fi-quant-segur AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-saldo-inic AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-saldo-inic-teor AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-saldo-terc AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-saldo-terc-teor AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46 BY 2.25.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.5.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item.it-codigo AT ROW 1.25 COL 10 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     fi-descricao AT ROW 1.25 COL 28 COLON-ALIGNED NO-LABEL
     cb-ref AT ROW 2.25 COL 10 COLON-ALIGNED
     fi-ref AT ROW 2.25 COL 10 COLON-ALIGNED WIDGET-ID 2
     c-descricao-refer AT ROW 2.25 COL 28 COLON-ALIGNED NO-LABEL
     item.un AT ROW 3.75 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     fi-quant-segur AT ROW 4.75 COL 22 COLON-ALIGNED
     fi-saldo-inic AT ROW 4.75 COL 57 COLON-ALIGNED
     fi-saldo-inic-teor AT ROW 4.75 COL 72 COLON-ALIGNED NO-LABEL
     de-saldo-fat AT ROW 5.75 COL 22 COLON-ALIGNED
     fi-saldo-terc AT ROW 5.75 COL 57 COLON-ALIGNED
     fi-saldo-terc-teor AT ROW 5.75 COL 72 COLON-ALIGNED NO-LABEL
     fi-lb-fis AT ROW 3.75 COL 57 COLON-ALIGNED NO-LABEL
     fi-lb-teor AT ROW 3.75 COL 72 COLON-ALIGNED NO-LABEL
     RECT-21 AT ROW 4.5 COL 43
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 3.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item
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
         HEIGHT             = 6
         WIDTH              = 88.57.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-descricao-refer IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-ref IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-saldo-fat IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-quant-segur IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-saldo-inic IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-saldo-inic-teor IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-saldo-terc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-saldo-terc-teor IN FRAME f-main
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

&Scoped-define SELF-NAME cb-ref
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ref V-table-Win
ON VALUE-CHANGED OF cb-ref IN FRAME f-main
DO:
    assign input frame {&frame-name} cb-ref.
    find first referencia
         where referencia.cod-refer = cb-ref no-lock no-error.
    if  available(referencia) then
        assign c-descricao-refer = referencia.descricao.
    else
        assign c-descricao-refer = "".
    disp c-descricao-refer with frame {&frame-name}.

    RUN get-link-handle IN adm-broker-hdl
       (INPUT this-procedure,
        INPUT "record-target",
        OUTPUT c-handle).

    assign h-handle = widget-handle (c-handle).     

    run pi-calc-sim-estoque in h-handle (input rowid (item),                          
                                         input (input frame {&frame-name} cb-ref),
                                         output fi-saldo-inic,
                                         &if defined(bf_man_205) &then
                                         output fi-saldo-inic-teor,
                                         &ENDIF
                                         output fi-quant-segur,
                                         output fi-saldo-terc
                                         &if defined(bf_man_205) &then
                                        ,output fi-saldo-terc-teor
                                         &ENDIF
                                         ).
    run pi-calcula-fat-pendente.

    disp fi-saldo-inic 
         fi-quant-segur
         fi-saldo-terc 
         de-saldo-fat 
        with frame {&frame-name}.
    &if defined(bf_man_205) &then
    IF param-global.modulo-per-ppm THEN DO:
        disp fi-saldo-inic-teor 
             fi-saldo-terc-teor 
            with frame {&frame-name}.
    END.
    &ENDIF
    assign de-saldo-fat = 0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME fi-ref
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ref V-table-Win
ON F5 OF fi-ref IN FRAME f-main
DO:
  
   assign l-implanta = yes.   
   {include/zoomvar.i &prog-zoom=inzoom/z01in375.w
                    &campo=fi-ref
                    &campozoom = cod-refer
                    &parametros= "run pi-seta-inicial in wh-pesquisa
                    (ITEM.it-codigo:screen-value)." }
                    
   WAIT-FOR CLOSE OF wh-pesquisa.
   APPLY "leave" TO fi-ref IN FRAME f-main.
END.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ref V-table-Win
ON LEAVE OF fi-ref IN FRAME f-main
DO:

    FIND FIRST referencia NO-LOCK
            WHERE referencia.cod-refer = fi-ref:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-ERROR.
    IF NOT AVAILABLE referencia THEN
         ASSIGN c-descricao-refer:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
    ELSE DO:

        ASSIGN c-descricao-refer:SCREEN-VALUE IN FRAME {&FRAME-NAME} = referencia.descricao.
        
     
        RUN get-link-handle IN adm-broker-hdl
            (INPUT this-procedure,
             INPUT "record-target",
             OUTPUT c-handle).

        assign h-handle = widget-handle (c-handle). 

        run pi-calc-sim-estoque in h-handle (input rowid (item),                          
                                         input (input frame {&frame-name} fi-ref),
                                         output fi-saldo-inic,                                  
                                         output fi-saldo-inic-teor,                                
                                         output fi-quant-segur,
                                         output fi-saldo-terc                    
                                        ,output fi-saldo-terc-teor                                 
                                         ).
        run pi-calcula-fat-pendente.

        disp fi-saldo-inic 
             fi-quant-segur
             fi-saldo-terc 
             de-saldo-fat 
             with frame {&frame-name}.
     
        IF param-global.modulo-per-ppm THEN DO:
            disp fi-saldo-inic-teor 
                fi-saldo-terc-teor 
                with frame {&frame-name}.
        END.
       
        assign de-saldo-fat = 0.

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ref V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-ref IN FRAME f-main
DO:
  APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  FIND FIRST param-global NO-LOCK NO-ERROR.

  {utp/ut-field.i mgind item cod-refer 1}
  assign cb-ref:label in frame {&frame-name} = RETURN-VALUE
         fi-ref:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Saldo_Inicial * l}
  assign fi-saldo-inic:label in frame {&frame-name} = "Saldo Atual". /*foi modificado
   o label para saldo atual, pois quando se fazia consulta por faixa de datas havia confus∆o.*/

  {utp/ut-liter.i Saldo_com_Terceiros * l}
  assign fi-saldo-terc:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Quantidade_de_Seguranáa * l}
  assign fi-quant-segur:label in frame {&frame-name} = return-value.
  
  &if defined(bf_man_205) &then
  IF param-global.modulo-per-ppm THEN DO:
      {utp/ut-liter.i F°sico: * l}
      assign fi-lb-fis = return-value.
      
      {utp/ut-liter.i Te¢rico: * l}
      assign fi-lb-teor = return-value.
  END.
  &ENDIF

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF  

/*Funcao que habilita o fill-in de referencia ao inves do combo-box
 Em casos que o cliente possua muitas refer“ncias Ç recomendado o uso do fill-in com zoom
  */
    
  FIND FIRST funcao
       WHERE funcao.cd-funcao = "SPP-FI-REFER" 
         AND funcao.ativo     = YES NO-LOCK NO-ERROR.
  IF AVAILABLE funcao THEN
       ASSIGN l-fn-fi-ref = YES.
  ELSE ASSIGN l-fn-fi-ref = NO.

  
  IF l-fn-fi-ref THEN DO:
      IF fi-ref:LOAD-MOUSE-POINTER("image/lupa.cur") IN FRAME {&FRAME-NAME} THEN.
  END.  
  
   ASSIGN cb-ref:DELIMITER = "".
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
  {src/adm/template/row-list.i "item"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item"}

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
  
  DEFINE VARIABLE c-refer AS CHARACTER   NO-UNDO.

  if avail item then
      assign fi-descricao = item.desc-item.
  else
      assign fi-descricao = "".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if defined(bf_man_205) &then
      IF param-global.modulo-per-ppm = NO OR 
         NOT AVAIL ITEM OR (ITEM.tipo-formula <> 2 AND ITEM.tipo-formula <> 3) THEN 
  &ENDIF
          ASSIGN fi-lb-fis:HIDDEN IN FRAME {&FRAME-NAME}          = YES
                 fi-lb-teor:HIDDEN IN FRAME {&FRAME-NAME}         = YES
                 fi-saldo-inic-teor:HIDDEN IN FRAME {&FRAME-NAME} = YES
                 fi-saldo-terc-teor:HIDDEN IN FRAME {&FRAME-NAME} = YES.
  &if defined(bf_man_205) &then
      ELSE
          DISPLAY fi-lb-fis
                  fi-lb-teor
                  fi-saldo-inic-teor
                  fi-saldo-terc-teor
              WITH FRAME f-main.
  &ENDIF
  
  if  available(item) then do:
      find first ref-item
           where ref-item.it-codigo = item.it-codigo no-lock no-error.         
      if  available(ref-item) and item.tipo-con-est = 4 then do:
          find first referencia
               where referencia.cod-refer = ref-item.cod-refer no-lock no-error.
          if  available(referencia) then
              assign c-descricao-refer = referencia.descricao
                     cb-ref     = referencia.cod-refer.
          ELSE assign c-descricao-refer = "".
          
          IF l-fn-fi-ref = NO THEN DO:
              fi-ref:HIDDEN IN FRAME {&FRAME-NAME} = TRUE. 
              
              ASSIGN cb-ref = c-refer.
              &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                  assign cb-ref:list-item-pairs in frame {&frame-name} = "  ".
                  for  each ref-item
                      where ref-item.it-codigo = item.it-codigo no-lock:
                      if cb-ref:add-last(ref-item.cod-refer,ref-item.cod-refer) in frame {&frame-name} then .
                  end.
              &else
                  assign cb-ref:list-items in frame {&frame-name} = "".
                  for  each ref-item
                      where ref-item.it-codigo = item.it-codigo no-lock:
                      if  cb-ref:add-last(ref-item.cod-refer) in frame {&frame-name} then .
                  end.
              &endif
              enable cb-ref with frame {&frame-name}.
              ASSIGN cb-ref:SCREEN-VALUE = c-refer.
              END.
              ELSE DO:
                  cb-ref:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.
                  ASSIGN fi-ref:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-refer.
                  ENABLE fi-ref WITH FRAME {&FRAME-NAME}.
          END.           
      end.
      else do:
          IF l-fn-fi-ref = NO THEN DO:
              fi-ref:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.
                  
              &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                  assign c-descricao-refer = ""
                         cb-ref:list-item-pairs in frame {&frame-name} = "  "
                         cb-ref = "".          
              &else
                  assign c-descricao-refer = ""
                         cb-ref:list-items in frame {&frame-name} = ""
                         cb-ref = "".
              &ENDIF
              
              disable cb-ref with frame {&frame-name}.
          end.
          ELSE DO:
                ASSIGN fi-ref:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
                disable fi-ref cb-ref with frame {&frame-name}.            
                ASSIGN
                    cb-ref:HIDDEN  IN FRAME {&FRAME-NAME} = TRUE
                    c-descricao-refer = ""
                    fi-ref:VISIBLE IN FRAME {&FRAME-NAME} = TRUE.
          END.
      end.
  end.
 disp c-descricao-refer with frame {&frame-name}.

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

        ASSIGN c-descricao-refer = "".
            IF l-fn-fi-ref = YES THEN
                ASSIGN cb-ref:HIDDEN IN FRAME {&FRAME-NAME} = YES
                       fi-ref:VISIBLE IN FRAME {&FRAME-NAME} = YES.
            ELSE 
                ASSIGN cb-ref:VISIBLE IN FRAME {&FRAME-NAME} = YES
                       fi-ref:HIDDEN IN FRAME {&FRAME-NAME} = YES. 
          
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.   
                            */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

/*   IF gr-item <> ? THEN FIND ITEM WHERE ROWID(ITEM) = gr-item NO-LOCK NO-ERROR. */

  /* Code placed here will execute AFTER standard behavior.    */

  IF  AVAIL item THEN 
      ASSIGN gr-item = ROWID(item).

  RUN get-link-handle IN adm-broker-hdl
     (INPUT this-procedure,
      INPUT "record-target",
      OUTPUT c-handle).

  assign h-handle = widget-handle (c-handle).     

  if  avail item and valid-handle (h-handle) THEN
      run pi-calc-sim-estoque in h-handle (input rowid (item),
                                           input (input frame {&frame-name} cb-ref),
                                           output fi-saldo-inic,
                                           &if defined(bf_man_205) &then
                                           output fi-saldo-inic-teor,
                                           &ENDIF
                                           output fi-quant-segur,
                                           output fi-saldo-terc
                                           &if defined(bf_man_205) &then
                                          ,output fi-saldo-terc-teor
                                           &ENDIF
                                           ).
  run pi-calcula-fat-pendente.
  
  disp fi-saldo-inic
       fi-quant-segur
       fi-saldo-terc
       de-saldo-fat 
      with frame {&frame-name}.
  &if defined(bf_man_205) &then
      IF param-global.modulo-per-ppm AND AVAIL ITEM AND (ITEM.tipo-formula = 2 OR ITEM.tipo-formula = 3) THEN DO:
          disp fi-saldo-inic-teor 
               fi-saldo-terc-teor 
              with frame {&frame-name}.
  END.
  &ENDIF
  assign de-saldo-fat = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-fat-pendente V-table-Win 
PROCEDURE pi-calcula-fat-pendente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
for each res-item no-lock
   where res-item.it-codigo   = item.it-codigo
     and res-item.cod-refer   = input frame {&frame-name} cb-ref
     and res-item.cod-estabel >= c-estab-ini 
     and res-item.cod-estabel <= c-estab-fim:

    assign de-saldo-fat = de-saldo-fat + res-item.dec-1.

end.
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

   /*Segue um exemplo de validaá∆o de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/

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
  {src/adm/template/snd-list.i "item"}

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

