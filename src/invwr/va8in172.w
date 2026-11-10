&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 

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
{include/i-prgvrs.i VA8IN172 2.00.00.008 } /*** "010008" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i va8in172 MUT}
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

def new global shared var gr-item as rowid no-undo.

{cdp/cdcfgman.i}

def var c-handle as handle no-undo.
define buffer b-item for item.

&IF DEFINED (bf_man_sfc_lc) &THEN
def var i-processo         as int no-undo.
def var c-lista            as char no-undo.
def var c-lista-aux        as char no-undo.
&ENDIF

DEF VAR l-usa-unid-negoc AS LOG INIT NO NO-UNDO.
DEF VAR hProgramZoom AS HANDLE NO-UNDO.
def var c-estabel as char no-undo.
DEF VAR i-lista-processo       AS INTEGER INIT 1 NO-UNDO.
DEF VAR i-nr-linha       AS INTEGER NO-UNDO.
DEF VAR c-unid-negoc AS CHARACTER NO-UNDO.

&IF DEFINED(bf_man_206b) &THEN
    IF CAN-FIND(funcao WHERE funcao.cd-funcao = "ems2-unidade-negocio"
                         AND funcao.ativo = YES) THEN
        ASSIGN l-usa-unid-negoc = YES.
&ENDIF

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
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS item.it-codigo item.un 
&Scoped-define DISPLAYED-TABLES item
&Scoped-define FIRST-DISPLAYED-TABLE item
&Scoped-Define DISPLAYED-OBJECTS c-descricao-item cb-ref c-descricao-refer ~
c-cod-unid-negoc cb-processos 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS cb-processos 

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
DEFINE VARIABLE cb-processos AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 31.86 BY 1 NO-UNDO.

DEFINE VARIABLE cb-ref AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 17.43 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-unid-negoc AS CHARACTER FORMAT "X(03)":U 
     LABEL "Unid.Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE c-descricao-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 55.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao-refer AS CHARACTER FORMAT "x(32)" 
     VIEW-AS FILL-IN 
     SIZE 33.14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 3.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item.it-codigo AT ROW 1.17 COL 8.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-descricao-item AT ROW 1.17 COL 26.43 COLON-ALIGNED NO-LABEL
     item.un AT ROW 1.17 COL 81.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     cb-ref AT ROW 2.17 COL 8.86 COLON-ALIGNED
     c-descricao-refer AT ROW 2.17 COL 26.43 COLON-ALIGNED NO-LABEL
     c-cod-unid-negoc AT ROW 2.17 COL 79.43 COLON-ALIGNED
     cb-processos AT ROW 3.17 COL 8.86 COLON-ALIGNED
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
         HEIGHT             = 3.33
         WIDTH              = 88.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-unid-negoc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao-refer IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-processos IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX cb-ref IN FRAME f-main
   NO-ENABLE                                                            */
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
ON F5 OF c-cod-unid-negoc IN FRAME f-main /* Unid.Neg¢cio */
DO:
  
    &IF DEFINED (bf_man_206b) &THEN  
        IF l-usa-unid-negoc THEN
            {method/zoomfields.i &ProgramZoom="inzoom/z01in745.w"
                                 &FieldZoom1=cod-unid-negoc
                                 &FieldScreen1="c-cod-unid-negoc"
                                 &Frame1="{&frame-name}"
                                 &EnableImplant="NO"}
    &endif
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-unid-negoc V-table-Win
ON LEAVE OF c-cod-unid-negoc IN FRAME f-main /* Unid.Neg¢cio */
DO:
  
    run pi-gera-processo(input item.it-codigo, 
                         input cb-ref
                         &if DEFINED(bf_man_206b) &then
                            , INPUT INPUT FRAME {&frame-name} c-cod-unid-negoc
                         &endif
                         ).


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-unid-negoc V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-unid-negoc IN FRAME f-main /* Unid.Neg¢cio */
DO:
    
    &IF DEFINED(bf_man_206b) &THEN
        IF l-usa-unid-negoc THEN
            apply 'F5':U to self.
    &ENDIF
    
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

    run pi-gera-processo (input item.it-codigo, 
                          input cb-ref
                          &if DEFINED(bf_man_206b) &then
                            , INPUT c-cod-unid-negoc
                          &endif
                          ).

    RUN notify ('local-open-query, record-target':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

    &IF DEFINED (bf_man_sfc_lc) &THEN
        {utp/ut-liter.i Processo * R}

        assign cb-processos:label  in frame {&frame-name} = trim(return-value)
               cb-processos:hidden in frame {&frame-name} = no.
    &ELSE
        assign cb-processos:hidden in frame {&frame-name} = yes.
    &ENDIF
    
    &IF DEFINED(bf_man_206b) &THEN
        IF l-usa-unid-negoc THEN
            ASSIGN c-cod-unid-negoc:HIDDEN IN FRAME {&FRAME-NAME} = NO.
        ELSE
    &ENDIF
            ASSIGN c-cod-unid-negoc:HIDDEN IN FRAME {&FRAME-NAME} = YES.

  {utp/ut-field.i mgind item cod-refer 1}
  assign cb-ref:label in frame {&frame-name} = return-value.

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
  if avail item then 
     assign c-descricao-item = item.desc-item.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if  available(item) then do:
      assign c-descricao-item = item.desc-item.

      &IF DEFINED(bf_man_206b) &THEN
          IF l-usa-unid-negoc then do:
              run pi-atualiza-unid (input c-estabel).    
          end.
      &ENDIF

      find first ref-item
           where ref-item.it-codigo = item.it-codigo no-lock no-error.
      if  available(ref-item) and item.tipo-con-est = 4 then do:

          find first referencia
               where referencia.cod-refer = ref-item.cod-refer no-lock no-error.
          if  available(referencia) then
              assign c-descricao-refer = referencia.descricao
                &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                        cb-ref     = referencia.cod-refer + ',' + referencia.cod-refer
                &else
                       cb-ref     = referencia.cod-refer
                &endif 
                .
          else
              assign c-descricao-refer = "".

        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                assign cb-ref:LIST-ITEM-PAIRS in frame {&frame-name} = ?.
        &else
                assign cb-ref:list-items in frame {&frame-name} = "".
        &endif                                                     


          for  each ref-item
              where ref-item.it-codigo = item.it-codigo no-lock:
            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                    if  cb-ref:add-last(ref-item.cod-refer,ref-item.cod-refer) in frame {&frame-name} then .
            &else
                    if  cb-ref:add-last(ref-item.cod-refer) in frame {&frame-name} then .
            &endif

          end.
          enable cb-ref with frame {&frame-name}. 
          run pi-gera-processo (input item.it-codigo, 
                                input cb-ref
                                &if DEFINED(bf_man_206b) &then
                                    , INPUT INPUT FRAME {&frame-name} c-cod-unid-negoc
                                &endif
                                ).
      end.
      else do:
          assign c-descricao-refer = ""
                &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                        cb-ref:LIST-ITEM-PAIRS in frame {&frame-name} = ?
                &else
                        cb-ref:list-items in frame {&frame-name} = ""
                &endif   
                 cb-ref = "".
          disable cb-ref with frame {&frame-name}.
          run pi-gera-processo (input item.it-codigo, 
                                input ""
                                &IF DEFINED(bf_man_206b) &THEN
                                    , INPUT INPUT FRAME {&frame-name} c-cod-unid-negoc
                                &ENDIF
                                ).
      end.
  end.

  ASSIGN cb-ref:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(1,cb-ref,",").

  disp c-descricao-refer c-descricao-item 
       with frame {&frame-name}.

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
  /* Limpeza de vari veis relativas a referˆncia               */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  if avail item then 
     assign gr-item = rowid(item).




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-param V-table-Win 
PROCEDURE pi-atualiza-param :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER i-lista-processo AS INTEGER.
DEFINE INPUT PARAMETER i-nr-linha       AS INTEGER.
DEFINE INPUT PARAMETER c-unid-negoc     AS CHARACTER.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-unid V-table-Win 
PROCEDURE pi-atualiza-unid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param c-cod-estabel as char no-undo.

    &if defined(bf_man_206b) &then
        if l-usa-unid-negoc then do:
    
            if c-cod-estabel = "" or
               c-cod-estabel = ? then do:
    
                find item where item.it-codigo = input frame {&frame-name} item.it-codigo no-error.
                if avail item then do:
                    assign c-cod-unid-negoc:screen-value in frame {&frame-name} = item.cod-unid-negoc.
                end.            
            end.
            else do:
                find item-uni-estab where item-uni-estab.it-codigo = input frame {&frame-name} ITEM.it-codigo
                                      and item-uni-estab.cod-estabel = c-cod-estabel no-lock no-error.
    
                if avail item-uni-estab then
                    assign c-cod-unid-negoc:screen-value in frame {&frame-name} = item-uni-estab.cod-unid-negoc.
                else
                    assign c-cod-unid-negoc:screen-value in frame {&frame-name} = item.cod-unid-negoc.
            end.
    
            assign c-estabel = c-cod-estabel.

            run pi-gera-processo(input item.it-codigo, 
                                 input cb-ref
                                 &if DEFINED(bf_man_206b) &then
                                    , INPUT INPUT FRAME {&frame-name} c-cod-unid-negoc
                                 &endif
                                 ).
        end.
    &endif

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

    def input param p-item  as char no-undo.
    def input param p-refer as char no-undo.
    
    &IF DEFINED(bf_man_206b) &THEN
        DEF INPUT PARAM p-cod-unid-negoc AS CHAR NO-UNDO.
    &ENDIF

    &IF DEFINED (bf_man_sfc_lc) &THEN
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                assign cb-processos:LIST-ITEM-PAIRS in frame {&frame-name} = ?
        &else
                assign cb-processos:list-items in frame {&frame-name} = ""
        &endif
                       c-lista = "".
        if  can-find (first proces-item
                      where proces-item.it-codigo = p-item
                        and proces-item.cod-refer = entry(1,p-refer,",")) then do:      

            for each proces-item
                where proces-item.it-codigo = p-item
                  and proces-item.cod-refer = entry(1,p-refer,",") no-lock:
                     
                IF i-nr-linha <> 0 AND 
                   i-nr-linha <> ? THEN 
                    IF proces-item.nr-linha <> i-nr-linha THEN NEXT.

                &IF DEFINED(bf_man_206b) &THEN
                    IF l-usa-unid-negoc THEN
                        IF (proces-item.cod-unid-negoc = "" OR
                            proces-item.cod-unid-negoc = ? OR
                            proces-item.cod-unid-negoc = p-cod-unid-negoc) THEN DO:

                            if  c-lista = "" then
                                assign c-lista     = string(proces-item.sequencia,">>>>9") + ' - ' +
                                                            proces-item.cod-lista-compon   + " / " +
                                                            proces-item.cod-roteiro
                                       i-processo  = proces-item.sequencia
                                       c-lista-aux = c-lista.
                            else
                                assign c-lista = c-lista + ',' + 
                                                 string(proces-item.sequencia,">>>>9") + ' - ' +
                                                        proces-item.cod-lista-compon   + " / " +
                                                        proces-item.cod-roteiro.
                        END.
                    IF NOT l-usa-unid-negoc THEN
                &ENDIF
                        if  c-lista = "" then
                            assign c-lista     = string(proces-item.sequencia,">>>>9") + ' - ' +
                                                        proces-item.cod-lista-compon   + " / " +
                                                        proces-item.cod-roteiro
                                   i-processo  = proces-item.sequencia
                                   c-lista-aux = c-lista.
                        else
                            assign c-lista = c-lista + ',' + 
                                             string(proces-item.sequencia,">>>>9") + ' - ' +
                                                    proces-item.cod-lista-compon   + " / " +
                                                    proces-item.cod-roteiro.
            end.

            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                    run utp/ut-lstit.p (input-output c-lista).
                    assign cb-processos:LIST-ITEM-PAIRS in frame {&frame-name} = c-lista
            &else
                   assign cb-processos:list-items in frame {&frame-name} = c-lista
            &endif
                          cb-processos = c-lista-aux
                          cb-processos:sensitive in frame {&frame-name} = yes.
            
            IF c-lista <> "" THEN
               disp cb-processos
                    with frame {&frame-name}.
        end.
        else
            assign cb-processos:sensitive in frame {&frame-name} = no.
    &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-unid V-table-Win 
PROCEDURE pi-habilita-unid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-unid-negoc AS LOG.

&IF DEFINED(bf_man_206b) &THEN
    IF l-usa-unid-negoc THEN DO:

        

        IF p-unid-negoc THEN DO:
            ENABLE c-cod-unid-negoc with FRAME {&FRAME-NAME}.
            IF c-cod-unid-negoc:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME {&FRAME-NAME} THEN.
        END.
        ELSE DO:
            DISABLE c-cod-unid-negoc WITH FRAME {&FRAME-NAME}.
        END.        

    END.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-label-item V-table-Win 
PROCEDURE pi-seta-label-item :
/*------------------------------------------------------------------------------
  Purpose:     Setar label para utiliza‡Æo da mesma viewer nas consultas onde se
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

