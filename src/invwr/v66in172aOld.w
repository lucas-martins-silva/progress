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
{include/i-prgvrs.i V66IN172A 2.00.00.007 } /*** "010007" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v66in172a MUT}
&ENDIF

{cdp/cdcfgman.i}
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
def new global shared var gr-item as rowid no-undo.


def var c-handle as handle no-undo.
define buffer b-item for item.

def var l-usa-unid-negoc as log init no no-undo.
def var i-processo         as int no-undo.
def var c-lista            as char no-undo.
def var c-lista-aux        as char no-undo.
&IF DEFINED(bf_man_206b) &THEN        
    DEF VAR h-cdapi024    AS HANDLE NO-UNDO.
&endif


DEF VAR l-fn-cb-ref AS LOGICAL NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS item.it-codigo item.un 
&Scoped-define DISPLAYED-TABLES item
&Scoped-define FIRST-DISPLAYED-TABLE item
&Scoped-Define DISPLAYED-OBJECTS c-descricao-item fi-ref c-descricao-refer ~
c-situacao 

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
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-unid-negoc AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unid Negoc" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 55.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao-refer AS CHARACTER FORMAT "x(32)" 
     VIEW-AS FILL-IN 
     SIZE 33.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-situacao AS CHARACTER FORMAT "X(40)" 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 35.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ref AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 17.43 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 3.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item.it-codigo AT ROW 1.17 COL 8.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-descricao-item AT ROW 1.17 COL 26.43 COLON-ALIGNED NO-LABEL
     item.un AT ROW 1.17 COL 81.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     cb-ref AT ROW 2.25 COL 8.86 COLON-ALIGNED
     c-cod-unid-negoc AT ROW 2.25 COL 78.43 COLON-ALIGNED
     fi-ref AT ROW 2.29 COL 8.86 COLON-ALIGNED WIDGET-ID 2
     c-descricao-refer AT ROW 2.29 COL 26.57 COLON-ALIGNED NO-LABEL
     c-situacao AT ROW 3.33 COL 8.86 COLON-ALIGNED HELP
          "C¢digo da situaá∆o do item"
     rt-key AT ROW 1 COL 1
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
         HEIGHT             = 3.42
         WIDTH              = 87.
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

/* SETTINGS FOR FILL-IN c-cod-unid-negoc IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       c-cod-unid-negoc:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-descricao-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao-refer IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-situacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-ref IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-ref IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN item.it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.un IN FRAME f-main
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

&Scoped-define SELF-NAME c-cod-unid-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-unid-negoc V-table-Win
ON LEAVE OF c-cod-unid-negoc IN FRAME f-main /* Unid Negoc */
DO:
  run pi-gera-processo(input item.it-codigo:screen-value in frame {&frame-name}, 
                       input cb-ref
                       &if DEFINED(bf_man_206b) &then
                       , INPUT INPUT FRAME {&frame-name} c-cod-unid-negoc
                       &endif).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

    run pi-gera-processo (input item.it-codigo:screen-value in frame {&frame-name}, 
                          input cb-ref
                          &if DEFINED(bf_man_206b) &then
                            , INPUT c-cod-unid-negoc
                          &endif
                          ).
    RUN notify ('local-open-query, record-target':U).
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

        run pi-gera-processo (input item.it-codigo:screen-value in frame {&frame-name}, 
                              input fi-ref:SCREEN-VALUE IN FRAME {&FRAME-NAME} 
                              &if DEFINED(bf_man_206b) &then
                                , INPUT c-cod-unid-negoc
                              &endif
                              ).
        RUN notify ('local-open-query, record-target':U).
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

  {utp/ut-field.i mgind item cod-obsoleto 1}
  assign c-situacao:label in frame {&frame-name} = return-value.
  {utp/ut-field.i mgind item cod-refer 1}
  assign cb-ref:label in frame {&frame-name} = return-value
         fi-ref:label in frame {&frame-name} = return-value.
  
 /* &IF DEFINED (bf_man_sfc_lc) &THEN
        {utp/ut-liter.i Processo * R}

        assign cb-processos:label  in frame {&frame-name} = trim(return-value)
               cb-processos:hidden in frame {&frame-name} = no.
    &ELSE
        assign cb-processos:hidden in frame {&frame-name} = yes.
    &ENDIF*/
    
  /*Funcao que habilita o fill-in de referencia ao inves do combo-box
  Em casos que o cliente possua muitas refer“ncias Ç recomendado o uso do fill-in com zoom
  */
    
FIND FIRST funcao
       WHERE funcao.cd-funcao = "SPP-FI-REFER" 
         AND funcao.ativo     = YES NO-LOCK NO-ERROR.
  IF AVAILABLE funcao THEN
       ASSIGN l-fn-cb-ref = YES.
  ELSE ASSIGN l-fn-cb-ref = NO.

  IF l-fn-cb-ref THEN DO:
      IF fi-ref:LOAD-MOUSE-POINTER("image/lupa.cur") IN FRAME {&FRAME-NAME} THEN.
  END.


&IF defined (bf_man_206b) &THEN
    {utp/ut-field.i mgind unid-negoc cod-unid-negoc 1}
    assign c-cod-unid-negoc:label in frame {&frame-name} = return-value.
&ENDIF

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

&IF DEFINED(bf_man_206b) &THEN

   IF CAN-FIND (FIRST funcao
                 WHERE funcao.cd-funcao = "EMS2-UNIDADE-NEGOCIO":U 
                 AND   funcao.ativo     = TRUE) THEN DO:
 
        RUN cdp/cdapi024.p PERSISTENT SET h-cdapi024.
        
        assign c-cod-unid-negoc:hidden in frame {&frame-name} = false.
            
    END.

&ENDIF

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
      &IF DEFINED(bf_man_206b) &THEN
     
    IF VALID-HANDLE(h-cdapi024) THEN DO:
                RUN pi-finalizar IN h-cdapi024.
                ASSIGN h-cdapi024 = ?.
            END.
     &endif

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

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
DEFINE VARIABLE c-refer AS CHARACTER   NO-UNDO.
  /* Code placed here will execute PRIOR to standard behavior. */
  if avail item then 
     assign c-descricao-item = item.desc-item 
            c-situacao   = {ininc/i17in172.i 04 item.cod-obsoleto}.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if  available(item) then do:
      assign c-descricao-item = item.desc-item
             c-situacao  = {ininc/i17in172.i 04 item.cod-obsoleto}.

      
     &IF DEFINED(bf_man_204) &THEN
      IF ITEM.politica = 5 THEN DO:
          /*ksm42618 fo:1783.369*/
          IF l-fn-cb-ref = NO THEN DO:
              fi-ref:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.
    
              DISABLE cb-ref with frame {&frame-name}.
              ASSIGN c-descricao-refer = ""
                     cb-ref = "".
              /*ksm42618 fo:1783.369 quando a polica for 5 ele limpa os campos do combo-box.*/
              &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
                  ASSIGN cb-ref:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = ?.
              &ELSE
              ASSIGN cb-ref:LIST-ITEMS IN FRAME {&FRAME-NAME} = "".
              &ENDIF
          END.
          ELSE DO:
              ASSIGN cb-ref:HIDDEN IN FRAME {&FRAME-NAME} = TRUE
                     fi-ref:VISIBLE IN FRAME {&FRAME-NAME} = TRUE.
          END.
      END.
      ELSE DO:
    &ENDIF
          find first ref-item
           where ref-item.it-codigo = item.it-codigo no-lock no-error.
          if  available(ref-item) and item.tipo-con-est = 4 then do:
              find first referencia
                   where referencia.cod-refer = ref-item.cod-refer no-lock no-error.
              if  available(referencia) then
                  assign c-descricao-refer = referencia.descricao
                         c-refer           = referencia.cod-refer.
              ELSE 
	            assign c-descricao-refer = "".
              
              IF l-fn-cb-ref = NO THEN DO:
                  fi-ref:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.
              
                &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then

                      assign cb-ref:list-item-pairs in frame {&frame-name} = "" NO-ERROR.
                      for  each ref-item
                           where ref-item.it-codigo = item.it-codigo no-lock:
                           if  cb-ref:add-last(ref-item.cod-refer,ref-item.cod-refer) in frame {&frame-name} then . 
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
              IF l-fn-cb-ref = NO THEN DO:
                  fi-ref:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.

                  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                  assign c-descricao-refer = ""
                         cb-ref:list-item-pairs in frame {&frame-name} = ?
                         cb-ref = "".
                  &else
                  assign c-descricao-refer = ""
                         cb-ref:list-items in frame {&frame-name} = ""
                         cb-ref = "".
                  &endif
                  
                  disable cb-ref with frame {&frame-name}.

              END.
              ELSE DO:

                  ASSIGN fi-ref:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

                  disable fi-ref cb-ref with frame {&frame-name}.
                  
                  ASSIGN cb-ref:HIDDEN  IN FRAME {&FRAME-NAME} = TRUE
                         c-descricao-refer = ""
                         fi-ref:VISIBLE IN FRAME {&FRAME-NAME} = TRUE.


                  

              END.
              
          end.
      &IF DEFINED (bf_man_204) &THEN
       END.
      &ENDIF
          run pi-gera-processo (input item.it-codigo:screen-value in frame {&frame-name}, 
                                input c-refer
                                &if DEFINED(bf_man_206b) &then
                                    , INPUT INPUT FRAME {&frame-name} c-cod-unid-negoc
                                &endif
                                ).
  end.

    &IF defined(bf_man_206b) &THEN 
        If (can-find(funcao where funcao.cd-funcao = "ems2-unidade-negocio" and
                                  funcao.ativo     = yes)) and 
            avail item then
        RUN retornaUnidadeNegocio IN h-cdapi024 (INPUT item.cod-estabel,
                                                 INPUT item.it-codigo,
                                                 INPUT "",
                                                 OUTPUT c-cod-unid-negoc).

        assign c-cod-unid-negoc:screen-value = c-cod-unid-negoc.

    &ENDIF

  
  disp c-descricao-refer c-descricao-item  c-situacao with frame {&frame-name}.

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

&IF defined(bf_man_206b) &THEN 
        If (can-find(funcao where funcao.cd-funcao = "ems2-unidade-negocio" and
                                  funcao.ativo     = yes)) then 
        ASSIGN c-cod-unid-negoc:HIDDEN IN FRAME {&FRAME-NAME} = FALSE.
&endif
      
      ASSIGN c-descricao-refer = "".
   IF l-fn-cb-ref = YES THEN
       ASSIGN cb-ref:HIDDEN IN FRAME {&FRAME-NAME} = YES
              fi-ref:VISIBLE IN FRAME {&FRAME-NAME} = YES.
   ELSE ASSIGN cb-ref:VISIBLE IN FRAME {&FRAME-NAME} = YES
              fi-ref:HIDDEN IN FRAME {&FRAME-NAME} = YES. 
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
  /* Limpeza de vari†veis relativas a referància               */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  if avail item then 
     assign gr-item = rowid(item).




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-processo V-table-Win 
PROCEDURE pi-gera-processo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-item     as char no-undo.
def input param p-refer    as char no-undo.
    
    &IF DEFINED(bf_man_206b) &THEN
        DEF INPUT PARAM p-cod-unid-negoc AS CHAR NO-UNDO.
    &ENDIF

    &IF DEFINED (bf_man_sfc_lc) &THEN
       /* &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                assign cb-processos:LIST-ITEM-PAIRS in frame {&frame-name} = ?
        &else
                assign cb-processos:LIST-ITEM-PAIRS in frame {&frame-name} = ?
        &endif*/
                       c-lista = ",".
        if  can-find (first proces-item
                      where proces-item.it-codigo = p-item
                        and proces-item.cod-refer = entry(1,p-refer,",")) then do:      

            for each proces-item
                where proces-item.it-codigo = p-item
                  and proces-item.cod-refer = entry(1,p-refer,",") no-lock:
                     
                &IF DEFINED(bf_man_206b) &THEN
                    IF l-usa-unid-negoc THEN
                        IF (proces-item.cod-unid-negoc = "" OR
                            proces-item.cod-unid-negoc = ? OR
                            proces-item.cod-unid-negoc = p-cod-unid-negoc) THEN DO:

                            if  c-lista = "," then
                                assign c-lista     = string(proces-item.sequencia,">>>>9") + ' - ' +
                                                            proces-item.cod-lista-compon   + " / " +
                                                            proces-item.cod-roteiro + "," +
                                                            proces-item.cod-lista-compon
                                       i-processo  = proces-item.sequencia
                                       c-lista-aux = proces-item.cod-lista-compon.
                            else
                                assign c-lista = c-lista + ',' +
                                                 string(proces-item.sequencia,">>>>9") + ' - ' +
                                                        proces-item.cod-lista-compon   + " / " +
                                                        proces-item.cod-roteiro + "," + 
                                                        proces-item.cod-lista-compon.
                        END.
                    IF NOT l-usa-unid-negoc THEN
                &ENDIF
                        if  c-lista = "," then
                            assign c-lista     = string(proces-item.sequencia,">>>>9") + ' - ' +
                                                        proces-item.cod-lista-compon   + " / " +
                                                        proces-item.cod-roteiro + "," +
                                                        proces-item.cod-lista-compon
                                   i-processo  = proces-item.sequencia
                                   c-lista-aux = proces-item.cod-lista-compon.
                        else
                            assign c-lista = c-lista + ',' + 
                                             string(proces-item.sequencia,">>>>9") + ' - ' +
                                                    proces-item.cod-lista-compon   + " / " +
                                                    proces-item.cod-roteiro + "," + 
                                                    proces-item.cod-lista-compon.
            end. 

/* &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                    assign cb-processos:LIST-ITEM-PAIRS in frame {&frame-name} = c-lista
            &else
                   assign cb-processos:LIST-ITEM-PAIRS in frame {&frame-name} = c-lista
            &endif
                          cb-processos = c-lista-aux
                          cb-processos:sensitive in frame {&frame-name} = yes.
            disp cb-processos
                 with frame {&frame-name}.*/
        end. 
                   else if can-find (first proces-item
                      where proces-item.it-codigo = p-item) then do:
                                        for each proces-item
                where proces-item.it-codigo = p-item no-lock:
                     
                &IF DEFINED(bf_man_206b) &THEN
                    IF l-usa-unid-negoc THEN
                        IF (proces-item.cod-unid-negoc = "" OR
                            proces-item.cod-unid-negoc = ? OR
                            proces-item.cod-unid-negoc = p-cod-unid-negoc) THEN DO:

                            if  c-lista = "," then
                                assign c-lista     = string(proces-item.sequencia,">>>>9") + ' - ' +
                                                            proces-item.cod-lista-compon   + " / " +
                                                            proces-item.cod-roteiro + "," +
                                                            proces-item.cod-lista-compon
                                       i-processo  = proces-item.sequencia
                                       c-lista-aux = proces-item.cod-lista-compon.
                            else
                                assign c-lista = c-lista + ',' +
                                                 string(proces-item.sequencia,">>>>9") + ' - ' +
                                                        proces-item.cod-lista-compon   + " / " +
                                                        proces-item.cod-roteiro + "," + 
                                                        proces-item.cod-lista-compon.
                        END.
                    IF NOT l-usa-unid-negoc THEN
                &ENDIF
                        if  c-lista = "," then
                            assign c-lista     = string(proces-item.sequencia,">>>>9") + ' - ' +
                                                        proces-item.cod-lista-compon   + " / " +
                                                        proces-item.cod-roteiro + "," +
                                                        proces-item.cod-lista-compon
                                   i-processo  = proces-item.sequencia
                                   c-lista-aux = proces-item.cod-lista-compon.
                        else
                            assign c-lista = c-lista + ',' + 
                                             string(proces-item.sequencia,">>>>9") + ' - ' +
                                                    proces-item.cod-lista-compon   + " / " +
                                                    proces-item.cod-roteiro + "," + 
                                                    proces-item.cod-lista-compon.
            end. 

/* &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                    assign cb-processos:LIST-ITEM-PAIRS in frame {&frame-name} = c-lista
            &else
                   assign cb-processos:LIST-ITEM-PAIRS in frame {&frame-name} = c-lista
            &endif
                          cb-processos = c-lista-aux
                          cb-processos:sensitive in frame {&frame-name} = yes.
            disp cb-processos
                 with frame {&frame-name}.*/
        end. 
     /*   else
            assign cb-processos:sensitive in frame {&frame-name} = no.*/
    &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-label-item V-table-Win 
PROCEDURE pi-seta-label-item :
/*------------------------------------------------------------------------------
  Purpose:     Setar label para utilizaá∆o da mesma viewer nas consultas onde se
               usa.  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input parameter p-onde-se-usa as logical.

 if p-onde-se-usa then do:
     {utp/ut-field.i mgind estrutura es-codigo 1}
     assign item.it-codigo:label in frame {&frame-name} = return-value.
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

