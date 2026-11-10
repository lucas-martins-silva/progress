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
{include/i-prgvrs.i V12IN172 2.00.02.014 } /*** 010214 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v12in172 MUT}
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
def new global shared var gr-deposito  as rowid no-undo.
def new global shared var gr-planejad  as rowid no-undo.
def new global shared var gr-lin-prod  as rowid no-undo.
def new global shared var gr-estabelec as rowid no-undo.

/* Local Variable Definitions ---                                       */
def temp-table tt-item-2 like item use-index codigo.

def new shared var c-it-codigo like item.it-codigo.

def var r-registro   as rowid.
def var i-ind-refugo as integer init 1 no-undo.

{database/tgin/twp/twin172.i1 item tt-item-2 "not avail"}

{cdp/cdcfgman.i}

/**************************MULTIPLANTA*********************************/
{utp/ut-glob.i}
{cdp/cd7300.i1}
{cdp/cdapi244.i}
{mcinc/mcapi003.i}
def temp-table tt-dados-env-SMC     like tt-dados-env.
def temp-table tt-replica-msg-SMC   like tt-replica-msg.
def temp-table tt-control-env-SMC   like tt-control-env.
def temp-table tt-integracao-SMC    like tt-integracao.

/************************FIM MULTIPLANTA*******************************/

{cdp/cd0666.i}
{cpp/cpapi020.i}
{cpp/cpapi020.i1} /* Funá‰es Fator de Concentraá∆o */

def temp-table tt-estabel no-undo
    field cod-estabel as char
    field log-exporta as log format "*/ "
    index codigo is primary unique cod-estabel
    index exporta log-exporta.  

def temp-table tt-old-item no-undo like item
    use-index codigo.    

def var l-cancelar     as logical       no-undo. 
def var l-modific      as logical       no-undo.   
def var l-anterior     as logical       no-undo.
def var h-tipo-con-est as widget-handle no-undo.

DEF VAR cTipoFormula AS CHAR FORMAT "x(20)" NO-UNDO.

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
&Scoped-Define ENABLED-FIELDS item.cod-localiz item.ressup-fabri ~
item.cap-est-fabr item.lote-economi 
&Scoped-define ENABLED-TABLES item
&Scoped-define FIRST-ENABLED-TABLE item
&Scoped-Define ENABLED-OBJECTS RECT-1 
&Scoped-Define DISPLAYED-FIELDS item.deposito-pad item.cod-localiz ~
item.cd-planejado item.ressup-fabri item.cap-est-fabr item.lote-economi 
&Scoped-define DISPLAYED-TABLES item
&Scoped-define FIRST-DISPLAYED-TABLE item
&Scoped-Define DISPLAYED-OBJECTS c-dep-pad c-desc-local c-cd-plan de-peso ~
cb-peso cb-tipo-formula fi-per-ppm 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS item.deposito-pad item.cd-planejado ~
de-peso 
&Scoped-define ADM-MODIFY-FIELDS item.deposito-pad item.cd-planejado ~
cb-tipo-formula 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-retorna-campo V-table-Win 
FUNCTION f-retorna-campo RETURNS CHARACTER
  ( input c-campo as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE cb-peso AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-formula AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-cd-plan AS CHARACTER FORMAT "x(30)":U 
     VIEW-AS FILL-IN 
     SIZE 35.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-dep-pad AS CHARACTER FORMAT "x(40)":U 
     VIEW-AS FILL-IN 
     SIZE 44.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-local AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27.5 BY .88 NO-UNDO.

DEFINE VARIABLE de-peso AS DECIMAL FORMAT ">>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-per-ppm AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 8.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item.deposito-pad AT ROW 1.33 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-dep-pad AT ROW 1.33 COL 37.86 COLON-ALIGNED NO-LABEL
     item.cod-localiz AT ROW 2.33 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 24 BY .88
     c-desc-local AT ROW 2.33 COL 54.29 COLON-ALIGNED NO-LABEL
     item.cd-planejado AT ROW 3.33 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     c-cd-plan AT ROW 3.33 COL 46.43 COLON-ALIGNED NO-LABEL
     item.ressup-fabri AT ROW 4.33 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     item.cap-est-fabr AT ROW 5.33 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     item.lote-economi AT ROW 6.33 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     de-peso AT ROW 7.33 COL 30 COLON-ALIGNED
     cb-peso AT ROW 7.33 COL 60 COLON-ALIGNED
     cb-tipo-formula AT ROW 8.33 COL 30 COLON-ALIGNED
     fi-per-ppm AT ROW 8.33 COL 60 COLON-ALIGNED
     RECT-1 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
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
         HEIGHT             = 8.5
         WIDTH              = 84.14.
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

/* SETTINGS FOR FILL-IN c-cd-plan IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-dep-pad IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-local IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-peso IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-tipo-formula IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN item.cd-planejado IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN de-peso IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN item.deposito-pad IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-per-ppm IN FRAME f-main
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

&Scoped-define SELF-NAME cb-tipo-formula
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo-formula V-table-Win
ON ENTRY OF cb-tipo-formula IN FRAME f-main
DO:
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        ASSIGN cTipoFormula = string(lookup(cb-tipo-formula:screen-value in frame {&frame-name}, cb-tipo-formula:LIST-ITEM-PAIRS) / 2).    
    &else
        ASSIGN cTipoFormula = string(lookup(cb-tipo-formula:screen-value in frame {&frame-name}, cb-tipo-formula:list-items)).
    &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo-formula V-table-Win
ON VALUE-CHANGED OF cb-tipo-formula IN FRAME f-main
DO:

    def var de-per-ppm as dec no-undo.

    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        IF cTipoFormula <> string(lookup(cb-tipo-formula:screen-value in frame {&frame-name}, cb-tipo-formula:LIST-ITEM-PAIRS) / 2 ) THEN DO:
    
        case int(lookup(cb-tipo-formula:screen-value in frame {&frame-name}, cb-tipo-formula:LIST-ITEM-PAIRS) / 2) :
            when 2 then do:
                assign de-per-ppm = if NOT fi-per-ppm:HIDDEN in frame {&frame-name} then
                                        f-conv-per-ppm(dec(fi-per-ppm:screen-value in frame {&frame-name}),2)
                                    else
                                        100.
                run pi-formata-campo (fi-per-ppm:handle, true, true, de-per-ppm, {ininc/i25in172.i 04 02} + "(%)":u, ">>9.9999":u).
                run pi-retorna-handle (output h-tipo-con-est).
                assign h-tipo-con-est:screen-value = {ininc/i01in122.i 04 03}.
            end.
            when 3 then do:
                assign de-per-ppm = if NOT fi-per-ppm:HIDDEN in frame {&frame-name} then
                                        f-conv-per-ppm(dec(fi-per-ppm:screen-value in frame {&frame-name}),1)
                                    else
                                        1000000.            
                run pi-formata-campo (fi-per-ppm:handle, true, true, de-per-ppm, {ininc/i25in172.i 04 03}, ">>>>,>>9.9999":u).
                run pi-retorna-handle (output h-tipo-con-est).
                assign h-tipo-con-est:screen-value = {ininc/i01in122.i 04 03}.
            end.
            otherwise
                run pi-formata-campo (fi-per-ppm:handle, false, false, 0, "", "").
        end case.
    
        ASSIGN cTipoFormula = string(lookup(cb-tipo-formula:screen-value in frame {&frame-name}, cb-tipo-formula:LIST-ITEM-PAIRS) / 2).
    
        END.    
    &else
        IF cTipoFormula <> string(lookup(cb-tipo-formula:screen-value in frame {&frame-name}, cb-tipo-formula:list-items)) THEN DO:
    
        case lookup(cb-tipo-formula:screen-value in frame {&frame-name}, cb-tipo-formula:list-items):
            when 2 then do:
                assign de-per-ppm = if NOT fi-per-ppm:HIDDEN in frame {&frame-name} then
                                        f-conv-per-ppm(dec(fi-per-ppm:screen-value in frame {&frame-name}),2)
                                    else
                                        100.
                run pi-formata-campo (fi-per-ppm:handle, true, true, de-per-ppm, {ininc/i25in172.i 04 02} + "(%)":u, ">>9.9999":u).
                run pi-retorna-handle (output h-tipo-con-est).
                assign h-tipo-con-est:screen-value = {ininc/i01in122.i 04 03}.
            end.
            when 3 then do:
                assign de-per-ppm = if NOT fi-per-ppm:HIDDEN in frame {&frame-name} then
                                        f-conv-per-ppm(dec(fi-per-ppm:screen-value in frame {&frame-name}),1)
                                    else
                                        1000000.            
                run pi-formata-campo (fi-per-ppm:handle, true, true, de-per-ppm, {ininc/i25in172.i 04 03}, ">>>>,>>9.9999":u).
                run pi-retorna-handle (output h-tipo-con-est).
                assign h-tipo-con-est:screen-value = {ininc/i01in122.i 04 03}.
            end.
            otherwise
                run pi-formata-campo (fi-per-ppm:handle, false, false, 0, "", "").
        end case.
    
        ASSIGN cTipoFormula = string(lookup(cb-tipo-formula:screen-value in frame {&frame-name}, cb-tipo-formula:list-items)).
    
        END.
    &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.cd-planejado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cd-planejado V-table-Win
ON F5 OF item.cd-planejado IN FRAME f-main /* Planejador */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in321.w"
                     &campo=item.cd-planejado
                     &campozoom=cd-planejado}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cd-planejado V-table-Win
ON LEAVE OF item.cd-planejado IN FRAME f-main /* Planejador */
DO:
  {include/leave.i &tabela=planejad
                   &atributo-ref=nome
                   &variavel-ref=c-cd-plan
                   &where="planejad.cd-planejado = input frame {&frame-name} item.cd-planejado"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cd-planejado V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.cd-planejado IN FRAME f-main /* Planejador */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.cod-localiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-localiz V-table-Win
ON F5 OF item.cod-localiz IN FRAME f-main /* Localizaá∆o */
DO:
  {include/zoomvar.i &prog-zoom="inzoom\z01in189.w"
                     &campo=item.cod-localiz
                     &campozoom=cod-localiz}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-localiz V-table-Win
ON LEAVE OF item.cod-localiz IN FRAME f-main /* Localizaá∆o */
DO:

  {include/leave.i &tabela=localizacao
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-local
                   &where="localizacao.cod-localiz = input frame {&frame-name} item.cod-localiz"} 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-localiz V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.cod-localiz IN FRAME f-main /* Localizaá∆o */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.deposito-pad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.deposito-pad V-table-Win
ON F5 OF item.deposito-pad IN FRAME f-main /* Dep¢sito Padr∆o */
DO:
  {include/zoomvar.i &prog-zoom="inzoom\z01in084.w"
                     &campo=item.deposito-pad
                     &campozoom=cod-depos}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.deposito-pad V-table-Win
ON LEAVE OF item.deposito-pad IN FRAME f-main /* Dep¢sito Padr∆o */
DO:

   {include/leave.i &tabela=deposito
                   &atributo-ref=nome
                   &variavel-ref=c-dep-pad
                   &where="deposito.cod-depos = input frame {&frame-name} item.deposito-pad"} 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.deposito-pad V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.deposito-pad IN FRAME f-main /* Dep¢sito Padr∆o */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

    do  with frame {&frame-name}:
        IF item.deposito-pad:LOAD-MOUSE-POINTER ("image~\lupa.cur") THEN.
        IF item.cod-localiz:LOAD-MOUSE-POINTER  ("image~\lupa.cur") THEN.
        IF item.cd-planejado:LOAD-MOUSE-POINTER ("image~\lupa.cur") THEN.
    end. 

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    for each tt-old-item:
        delete tt-old-item.
    end.

    create tt-old-item.
    buffer-copy item to tt-old-item.


  /* Code placed here will execute PRIOR to standard behavior. */
   {include/i-valid.i}
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  def var c-aux-f as char no-undo.

      assign cb-peso = input frame {&frame-name} cb-peso.

    for each tt-item-2:
        delete tt-item-2.
    end.
    create tt-item-2.
    buffer-copy item to tt-item-2.

            assign c-aux-f = f-retorna-campo ("cb-tipo-conest")
                   tt-item-2.tipo-con-est = {ininc/i01in122.i 06 c-aux-f}
                   c-aux-f = f-retorna-campo ("cb-demanda")
                   tt-item-2.demanda      = {ininc/i02in122.i 06 c-aux-f}                   
                   c-aux-f = f-retorna-campo ("cb-tipo-requis")
                   tt-item-2.tipo-requis  = {ininc/i08in122.i 06 c-aux-f}                  
                   c-aux-f = f-retorna-campo ("cb-classe-repr")
                   tt-item-2.classe-repro  = {ininc/i06in122.i 06 c-aux-f}
                   c-aux-f = f-retorna-campo ("cb-tipo-contr")
                   tt-item-2.tipo-contr   = {ininc/i09in122.i 06 c-aux-f}                   
                   c-aux-f = f-retorna-campo ("cb-reporte-mob")
                   tt-item-2.tipo-sched   = {ininc/i06in172.i 06 c-aux-f}
                   c-aux-f = f-retorna-campo ("cb-reporte-ggf")
                   tt-item-2.tipo-sched   = {ininc/i06in172.i 06 c-aux-f}
                   c-aux-f = f-retorna-campo ("cb-tipo-alocac")
                   tt-item-2.tipo-sched   = {ininc/i18in172.i 06 c-aux-f}
                   c-aux-f = f-retorna-campo ("cb-reporte-prod")
                   tt-item-2.tipo-sched   = {ininc/i12in172.i 06 c-aux-f}.

           run pi-validate-item. 

           if return-value <> 'ok' and return-value <> '' then do:
               run pi-apresenta-erros.
               return "ADM-ERROR":U.
           end.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

  assign c-it-codigo = item.it-codigo.
  find first pend-item where pend-item.it-codigo = c-it-codigo 
                       and   pend-item.modulo    = 'mcp':U no-error.
  if  avail pend-item then
      delete pend-item.         

  if param-global.modulo-per-ppm then do:

 &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    assign item.tipo-formula = INT(lookup(cb-tipo-formula:screen-value in frame {&frame-name}, cb-tipo-formula:LIST-ITEM-PAIRS) / 2).
    case int(lookup(cb-tipo-formula:screen-value in frame {&frame-name}, cb-tipo-formula:LIST-ITEM-PAIRS) / 2):  
 &else
    assign item.tipo-formula = lookup(cb-tipo-formula:screen-value in frame {&frame-name}, cb-tipo-formula:list-items).
    case lookup(cb-tipo-formula:screen-value in frame {&frame-name}, cb-tipo-formula:list-items): 
 &endif
        WHEN 0 THEN
             ASSIGN ITEM.per-ppm = 0
                    fi-per-ppm:HIDDEN IN FRAME {&FRAME-NAME} = YES.
        when 2 or
        when 3 then
             assign item.per-ppm = dec(fi-per-ppm:screen-value in frame {&frame-name})
                    fi-per-ppm:HIDDEN IN FRAME {&FRAME-NAME} = NO.
        otherwise
             assign item.per-ppm = 0
                    fi-per-ppm:HIDDEN IN FRAME {&FRAME-NAME} = YES. 
    end case.
  END.
  ELSE
       ASSIGN cb-tipo-formula:HIDDEN IN FRAME {&FRAME-NAME} = YES
              fi-per-ppm:HIDDEN      IN FRAME {&FRAME-NAME} = YES.

  ASSIGN cb-tipo-formula:SENSITIVE IN FRAME {&FRAME-NAME} = NO
         fi-per-ppm:SENSITIVE      IN FRAME {&FRAME-NAME} = NO.

  /** Atualizaá∆o da tabela item-man **/
  {cpp/cp0105.i1} 

  ASSIGN item-man.dec-1 = DEC(de-peso:screen-value in frame {&frame-name}).
/*----------------------MULTIPLANTA-------------------------*/
assign c-transacao = "MAN003".
{cdp/cd7300.i5 "001" c-transacao}
run pi-cria-tt-dados.
{cdp/cd7300.i6 "001" c-transacao}

/*-------------------FIM MULTIPLANTA-------------------------*/

/*----------------------MULTIPLANTA-SMC-------------------------*/
for each tt-smc-item:
    delete tt-smc-item.
end.

assign c-transacao = "SMC015".
{cdp/cd7300.i5 "001" c-transacao "-SMC"}

run pi-cria-tt-dados-smc.
{cdp/cd7300.i6 "001" c-transacao "-SMC"}

/*-------------------FIM MULTIPLANTA-SMC-------------------------*/


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
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
     do on error undo, leave:
        validate item.
     end.

     if return-value <> "ok" and return-value <> "" then do:
        run pi-apresenta-erros.
        return "ADM-ERROR":U.
     end.

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

  if valid-handle (h-cpapi020) then
    run pi-finalizar in h-cpapi020.

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

  assign de-peso:sensitive in frame {&frame-name} = no
         cb-peso:sensitive in frame {&frame-name} = no.

  if param-global.modulo-per-ppm THEN DO:

     assign cb-tipo-formula:HIDDEN in frame {&frame-name} = NO
            fi-per-ppm:HIDDEN      in frame {&frame-name} = NO.
   &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
      case INT(lookup(cb-tipo-formula:screen-value in frame {&frame-name}, cb-tipo-formula:LIST-ITEM-PAIRS) / 2):    
   &else   
      case lookup(cb-tipo-formula:screen-value in frame {&frame-name}, cb-tipo-formula:list-items): 
   &endif
          WHEN 0 THEN fi-per-ppm:HIDDEN IN FRAME {&FRAME-NAME} = YES.
          when 2 or
          when 3 THEN fi-per-ppm:HIDDEN IN FRAME {&FRAME-NAME} = NO.
          OTHERWISE fi-per-ppm:HIDDEN IN FRAME {&FRAME-NAME} = YES. 
      end case.
  END.


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

    if  avail item then do:
        find deposito
            where deposito.cod-depos = item.deposito-pad no-lock no-error.

        FIND FIRST localizacao
             where localizacao.cod-estabel = ITEM.cod-estab 
               and localizacao.cod-depos   = ITEM.deposito-pad
               and localizacao.cod-localiz = item.cod-localiz
                NO-LOCK NO-ERROR.

        find planejad
            where planejad.cd-planejado = item.cd-planejado no-lock no-error.

        find first lin-prod
             where lin-prod.cod-estabel = item.cod-estabel
               and lin-prod.nr-linha    = item.nr-linha no-lock no-error.
        assign c-dep-pad    = if  avail deposito    then deposito.nome          else "":U
               c-desc-local = if  avail localizacao then localizacao.descricao  else "":U
               c-cd-plan    = if  avail planejad    then planejad.nome          else "":U.

       find item-man
           where item-man.it-codigo = item.it-codigo no-lock no-error.
       if  avail item-man then do with frame {&frame-name}:

           

           if item-man.int-1 > 0 AND item-man.int-1 < 7 then DO: 
              ASSIGN cb-peso = {ininc/i04in180.i 04 item-man.int-1}.
           END.
           ELSE DO:
              ASSIGN cb-peso = {ininc/i04in180.i 04 1}.
           END.
       end.   
       else do:
           assign /*de-peso = 0*/
                  cb-peso = {ininc/i04in180.i 04 1}.
       end.

    end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  assign de-peso:screen-value in frame {&frame-name} = string(item-man.dec-1).

    if  param-global.modulo-per-ppm THEN DO:
        IF  item.tipo-formula <> 0 then do:
            assign cb-tipo-formula:HIDDEN in frame {&frame-name} = NO
                   cb-tipo-formula:screen-value in frame {&frame-name} = {ininc/i25in172.i 04 item.tipo-formula}.
            case item.tipo-formula:
                when 2 THEN DO:
                     ASSIGN fi-per-ppm:HIDDEN IN FRAME {&FRAME-NAME} = NO.
                     run pi-formata-campo (fi-per-ppm:handle, true, false, item.per-ppm, {ininc/i25in172.i 04 02} + "(%)":u, ">>9.9999":u).
                END.
                when 3 THEN DO:
                     ASSIGN fi-per-ppm:HIDDEN IN FRAME {&FRAME-NAME} = NO.
                     run pi-formata-campo (fi-per-ppm:handle, true, false, item.per-ppm, {ininc/i25in172.i 04 03}, ">>>>,>>9.9999":u).
                END.
                otherwise
                    run pi-formata-campo (fi-per-ppm:handle, false, false, 0, "", "").
            end case.
        end.
        ELSE DO:
           ASSIGN fi-per-ppm:HIDDEN IN FRAME {&FRAME-NAME} = YES.
           run pi-formata-campo (fi-per-ppm:handle, false, false, 0, "", "").
        END.
    END.
    ELSE
       ASSIGN cb-tipo-formula:HIDDEN IN FRAME {&FRAME-NAME} = YES
              fi-per-ppm:HIDDEN      IN FRAME {&FRAME-NAME} = YES.

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

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

    find first localizacao
         where localizacao.cod-depos   = item.deposito-pad 
         and   localizacao.cod-localiz = item.cod-localiz no-lock no-error.

    if  param-global.modulo-ce
    and (available localizacao
    or   item.cod-localiz = "") then 
        assign item.deposito-pad:sensitive      = false
               mgind.item.cod-localiz:sensitive = false. 

        assign de-peso:sensitive in frame {&frame-name} = yes
               cb-peso:sensitive in frame {&frame-name} = yes.
        if  avail item-man then
            if  item-man.dec-1 = 0 then
                assign de-peso:screen-value in frame {&frame-name} = string(item-man.dec-1).

       if param-global.modulo-per-ppm THEN DO:
          ASSIGN cb-tipo-formula:SCREEN-VALUE in frame {&frame-name} = {ininc/i25in172.i 04 ITEM.tipo-formula}.

          IF can-find (first estrutura where
                             estrutura.es-codigo = item.it-codigo use-index onde-se-usa) or
             can-find (first alternativo where
                             alternativo.al-codigo = item.it-codigo use-index onde-se-usa) or
             can-find (first item-lista-compon where
                             item-lista-compon.es-codigo = item.it-codigo use-index onde-se-usa) or
             can-find (first reservas where
                             reservas.it-codigo = item.it-codigo and
                             reservas.estado    = 1 use-index planejamento) or
             can-find (first saldo-estoq where
                             saldo-estoq.it-codigo = item.it-codigo use-index item) THEN DO:

           assign cb-tipo-formula:SENSITIVE in frame {&frame-name} = FALSE
                  fi-per-ppm:SENSITIVE      in frame {&frame-name} = FALSE.              
          END.
          else DO:
             IF  item.tipo-formula = 2 or
                 item.tipo-formula = 3 then
                 assign cb-tipo-formula:HIDDEN in frame {&frame-name} = NO
                        fi-per-ppm:HIDDEN      in frame {&frame-name} = NO
                        fi-per-ppm:SENSITIVE   in frame {&frame-name} = TRUE. 
             ELSE
                assign cb-tipo-formula:HIDDEN in frame {&frame-name} = NO
                       fi-per-ppm:HIDDEN      in frame {&frame-name} = YES.
          END.
       end.
       ELSE 
          assign cb-tipo-formula:HIDDEN in frame {&frame-name} = YES
                 fi-per-ppm:HIDDEN      in frame {&frame-name} = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-end-update V-table-Win 
PROCEDURE local-end-update :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  &IF DEFINED (bf_man_per_ppm) &THEN
    def var c-aux as char no-undo.
    def var i-cnt as int  no-undo.
  &ENDIF

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    if can-find (first fam-uni-estab
                 where fam-uni-estab.fm-codigo = item.fm-codigo no-lock) then do:

       &IF DEFINED (bf_man_per_ppm) &THEN
           buffer-compare item to tt-old-item save result in c-aux.

           assign i-cnt = if can-do(c-aux,"per-ppm":u) and
                             can-do(c-aux,"tipo-formula":u) then 2
                          else if can-do(c-aux,"per-ppm":u) or
                                  can-do(c-aux,"tipo-formula":u) then 1
                          else 0.

           assign l-modific = (num-entries(c-aux) > i-cnt).

       &ELSE
            assign l-modific = yes.          
       &ENDIF

       if l-modific then do:
          run cdp/cd0204k1.w (input        item.it-codigo,
                              input-output l-modific,
                              input-output l-anterior,
                              output       l-cancelar,
                              output table tt-estabel).

          run cdp/cd0204k.p (input item.it-codigo,
                             input "M", /* Modificaá∆o */
                             input l-modific,
                             input l-anterior,
                             input (not l-cancelar),
                             input table tt-estabel,
                             input table tt-old-item).
       end.

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

      {utp/ut-liter.i Peso * R}
      assign de-peso:label in frame {&frame-name} = trim(return-value).

      &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
          DEFINE VARIABLE c-lista AS CHARACTER  NO-UNDO.
          {utp/ut-liter.i Unidade  * R}
          assign cb-peso:label      in frame {&frame-name}      = trim(return-value)
                 c-lista                                        = {ininc/i04in180.i 03}.
          run utp/ut-lstit.p (input-output c-lista).
          ASSIGN cb-peso:LIST-ITEM-PAIRS in frame {&frame-name} = c-lista.
    
          {utp/ut-liter.i Componente_para_formulaá∆o * R}
          ASSIGN cb-tipo-formula:label      in frame {&frame-name}      = trim(return-value)
                 c-lista                                                = {ininc/i25in172.i 03}.
          run utp/ut-lstit.p (input-output c-lista).
                 cb-tipo-formula:LIST-ITEM-PAIRS in frame {&frame-name} = c-lista.      
      &else
          {utp/ut-liter.i Unidade  * R}
          assign cb-peso:label      in frame {&frame-name}         = trim(return-value)
                 cb-peso:list-items in frame {&frame-name}         = {ininc/i04in180.i 03}.
    
          {utp/ut-liter.i Componente_para_formulaá∆o * R}
          ASSIGN cb-tipo-formula:label      in frame {&frame-name} = trim(return-value)
                 cb-tipo-formula:list-items in frame {&frame-name} = {ininc/i25in172.i 03}.
      &endif

    find first param-global NO-LOCK NO-ERROR.

        run cpp/cpapi020.p persistent set h-cpapi020(INPUT-OUTPUT table tt-balanceia,
                                                     input-output table tt-erro,
                                                     INPUT        yes,
                                                     INPUT-OUTPUT TABLE tt-veiculos).


    if param-global.modulo-per-ppm then do:

       assign cb-tipo-formula:HIDDEN     in frame {&frame-name} = NO
              fi-per-ppm:HIDDEN          in frame {&frame-name} = NO.
    end.
    else
        assign cb-tipo-formula:HIDDEN in frame {&frame-name} = YES
               fi-per-ppm:HIDDEN      in frame {&frame-name} = YES.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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

  /* Code placed here will execute AFTER standard behavior.    */
  FIND deposito WHERE deposito.cod-depos = item.deposito-pad NO-LOCK NO-ERROR.
  IF  AVAIL deposito THEN
      ASSIGN gr-deposito = ROWID(deposito).

  FIND planejad WHERE planejad.cd-planejado = item.cd-planejado NO-LOCK NO-ERROR.    
  IF  AVAIL planejad THEN
      ASSIGN gr-planejad = ROWID(planejad).

  find first lin-prod
       where lin-prod.cod-estabel = item.cod-estabel
         and lin-prod.nr-linha    = item.nr-linha no-lock no-error.
  IF  AVAIL lin-prod THEN
      ASSIGN gr-lin-prod = ROWID(lin-prod).

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

  ASSIGN r-registro = ROWID(item). 

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-apresenta-erros V-table-Win 
PROCEDURE pi-apresenta-erros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  {database/tgin/twp/twin172.i "show"}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza V-table-Win 
PROCEDURE pi-atualiza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT this-procedure,
         INPUT "cb-ind-refugo").

    assign i-ind-refugo = {ininc/i01in180.i 06 return-value}.

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

if param-global.modulo-mp and tt-replica-msg.log-replica-msg = yes then do:
    create tt-item-aux.
    buffer-copy item to tt-item-aux.
    create tt-dados-env.
    assign tt-dados-env.num-sequencia  = i-seq
           tt-dados-env.cod-tipo-reg   = 3 /*tabela Item*/
           tt-dados-env.ind-tipo-movto = 2 /*modifica*/
           tt-dados-env.identif-msg    = item.it-codigo.
    raw-transfer tt-item-aux to tt-dados-env.conteudo-msg.
    assign i-seq = i-seq + 1.
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados-smc V-table-Win 
PROCEDURE pi-cria-tt-dados-smc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
if param-global.modulo-mp 
and tt-replica-msg-SMC.log-replica-msg = yes 
then do:
    create tt-smc-item.
    buffer-copy item to tt-smc-item.
    create tt-dados-env-SMC.
    assign tt-dados-env-SMC.num-sequencia  = i-seq
           tt-dados-env-SMC.cod-tipo-reg   = 3 /*tabela Item*/
           tt-dados-env-SMC.ind-tipo-movto = 2 /*modifica*/
           tt-dados-env-SMC.identif-msg    = item.it-codigo.
    raw-transfer tt-smc-item to tt-dados-env-SMC.conteudo-msg.
    assign i-seq = i-seq + 1.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-formata-campo V-table-Win 
PROCEDURE pi-formata-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pHandle      as handle no-undo.
def input param pVisible     as log    no-undo.
def input param pSensitive   as log    no-undo.
def input param pScreenValue as dec    no-undo.
def input param pLabel       as char   no-undo.
def input param pFormat      as char   no-undo.
  
    if pVisible THEN DO:
        RUN utp/ut-liter.p (trim(pLabel), "*", "").
        assign pHandle:HIDDEN       = NOT pVisible
               pHandle:sensitive    = pSensitive
               pHandle:format       = pFormat
               pHandle:screen-value = string(pScreenValue)
               pHandle:label        = RETURN-VALUE no-error.
    END.
    else
        assign pHandle:HIDDEN = NOT pVisible no-error.

return 'ok':u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-handle V-table-Win 
PROCEDURE pi-retorna-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def output param p-handle as handle.

def var c-handle as char   no-undo.
def var h-handle as handle no-undo.
def var h-frame  as handle no-undo.
def var i-cont   as int    no-undo.

    run who-is-the-container in adm-broker-hdl (input this-procedure, output c-handle).
    assign h-handle = widget-handle(c-handle).

    run get-link-handle in adm-broker-hdl (input  h-handle, 
                                           input  "container-target":U,
                                           output c-handle).
    do i-cont = 1 to num-entries(c-handle):
        assign h-handle = widget-handle(entry(i-cont,c-handle)).
        if h-handle:file-name = "invwr/v11in172.w":u then do:

            run get-attribute in h-handle ("adm-object-handle":U).
            assign h-frame = widget-handle(return-value)
                   h-frame = h-frame:first-child
                   h-frame = h-frame:first-child.

            do while h-frame <> ? :

                if lookup(h-frame:type, "combo-box":U)      <> 0 and
                   lookup(h-frame:type, "combo-box":U)      <> ? and
                   lookup(h-frame:name, "cb-tipo-conest":U) <> 0 and 
                   lookup(h-frame:name, "cb-tipo-conest":U) <> ? then do:
                    assign p-handle = h-frame.
                    return 'ok':u.
                end.

                assign h-frame = h-frame:next-sibling.

            end.
        end.
    end.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-tipo-report V-table-Win 
PROCEDURE pi-tipo-report :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN Get-Field-Screen-Value IN adm-broker-hdl
       (INPUT this-procedure,
        INPUT 'cb-report-prod').     /* Busca o valor do atributo na viewer v11in172*/
{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
     case return-value:
          when 'Ordem'             then return '1'.
          when 'Operaá∆o'          then return '2'.
          when 'Ponte de Controle' then return '3'.
          when 'Item'              then return '4'.
     end .
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
     case return-value:
          when 'Orden'              then return '1'.
          when 'Operaci¢n'          then return '2'.
          when 'Punto de Control'   then return '3'.
          when 'Item'               then return '4'.
     end .
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
     case return-value:
          when 'Req'             then return '1'.
          when 'Operation'       then return '2'.
          when 'Control Point'   then return '3'.
          when 'Item'            then return '4'.
     end .
&ENDIF


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

    if input frame {&frame-name} mgind.item.deposito-pad <> "" then do:
       if not can-find(deposito where deposito.cod-depos = input frame {&frame-name} item.deposito-pad) then do:
          {include/i-vldprg.i}
          {utp/ut-table.i mgind deposito 1}                
          run utp/ut-msgs.p (input "show",
                             input 56,
                             input return-value). 
          apply "entry" to item.deposito-pad in frame {&frame-name}.
          return "adm-error".                   
       end.
    end.   

    if input frame {&frame-name} item.cd-planejad <> "" then do:
       if not can-find(planejad where planejad.cd-planejado = input frame {&frame-name} item.cd-planejad) then do:
          {include/i-vldprg.i}
          {utp/ut-table.i mgind planejad 1}                
          run utp/ut-msgs.p (input "show",
                             input 56,
                             input return-value). 
          apply "entry" to item.cd-planejad in frame {&frame-name}.
          return "adm-error".                                                
       end.                             
    end.   

    if input frame {&frame-name} item.cod-localiz  <> "" then do:
        find first localizacao where localizacao.cod-depos    = input frame {&frame-name} item.deposito-pad and 
                                     localizacao.cod-localiz  = input frame {&frame-name} item.cod-localiz  no-lock no-error.
        if not available localizacao then do:
              {include/i-vldprg.i} 
              {utp/ut-table.i mgind localizacao 1}             
              run utp/ut-msgs.p (input "show",
                                 input 4898,
                                 input return-value). 
              apply "entry" to item.cod-localiz in frame {&frame-name}.
              return "adm-error".                                                
        end.
    end.

    if param-global.modulo-per-ppm then
        if cb-tipo-formula:screen-value in frame {&frame-name} = {ininc/i25in172.i 04 02} or
           cb-tipo-formula:screen-value in frame {&frame-name} = {ininc/i25in172.i 04 03} then do:

            if dec(fi-per-ppm:screen-value in frame {&frame-name}) <= 0 then do:
                {include/i-vldprg.i} 
                run utp/ut-msgs.p (input "show",
                                   input 2333,
                                   input cb-tipo-formula:screen-value in frame {&frame-name}). 
                apply "entry" to fi-per-ppm in frame {&frame-name}.
                return "adm-error":u.
            end.

            run pi-retorna-handle (output h-tipo-con-est).
            if h-tipo-con-est:screen-value <> {ininc/i01in122.i 04 03} then do:
                {include/i-vldprg.i} 
                run utp/ut-msgs.p (input "show",
                                   input 27283,
                                   input ""). 
                apply "entry" to cb-tipo-formula in frame {&frame-name}.
                return "adm-error":u.                
            end.

        end.

   RUN pi-tipo-report.   /* verifica o tipo de reporte do item*/
   
   if  return-value = '4' then
       if avail item then do:
           find first item-uni-estab where item-uni-estab.it-codigo = item.it-codigo.
           if  avail item-uni-estab then do:
               find first lin-prod where
                          lin-prod.cod-estabel = item-uni-estab.cod-estabel
                      and lin-prod.nr-linha    = item-uni-estab.nr-linha no-lock no-error.
               if  not avail lin-prod then do:
                   {include/i-vldprg.i} 
                   {utp/ut-table.i mgind lin-prod 1}
                   run utp/ut-msgs.p (input "show",
                                      input 56,
                                      input return-value).
                   return "adm-error".
               end.
               else
                   if  lin-prod.sum-requis = 2 then do:
                       {include/i-vldprg.i} 
                       run utp/ut-msgs.p (input "show",
                                          input 34357,  /* item-uni-estab requer linha de processo*/
                                          input ''). 
                       return "adm-error".
                   end.
        end.
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-retorna-campo V-table-Win 
FUNCTION f-retorna-campo RETURNS CHARACTER
  ( input c-campo as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RUN Get-Field-Screen-Value IN adm-broker-hdl
     (INPUT this-procedure,
      INPUT c-campo).

  RETURN return-value.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

