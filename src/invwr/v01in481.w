&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          mgmfg            PROGRESS
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
{include/i-prgvrs.i V01IN481 2.00.00.006}  /*** 010006 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01in481 MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
{cdp/cdcfgman.i}

&Scop adm-attribute-dlg support/viewerd.w

def var v-row-parent   as rowid no-undo.
def var c-it-codigo    like item.it-codigo no-undo.
def var rw-item        as rowid no-undo.
def var c-label        as char.
def var h-boin481      as handle no-undo.

def buffer b-proces-item for proces-item.

&IF DEFINED(bf_man_206b) &THEN
    DEF VAR l-unid-negoc   AS LOG INIT NO NO-UNDO.
    DEF VAR hprogramzoom   AS HANDLE      NO-UNDO.
&ENDIF




/*** Includes para utiliza‡Æo da BOin481 ***/
{include/boini.i}
{inbo/boin481.i tt-proces-item}

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
&Scoped-define EXTERNAL-TABLES proces-item
&Scoped-define FIRST-EXTERNAL-TABLE proces-item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR proces-item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS proces-item.qtd-min-item ~
proces-item.qtd-max-item proces-item.data-inicio proces-item.data-termino ~
proces-item.cod-estabel proces-item.nr-linha proces-item.cod-refer ~
proces-item.proporcao 
&Scoped-define ENABLED-TABLES proces-item
&Scoped-define FIRST-ENABLED-TABLE proces-item
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS proces-item.it-codigo proces-item.sequencia ~
proces-item.cod-lista-compon proces-item.cod-roteiro ~
proces-item.qtd-min-item proces-item.qtd-max-item proces-item.data-inicio ~
proces-item.data-termino proces-item.cod-estabel proces-item.nr-linha ~
proces-item.cod-refer proces-item.proporcao 
&Scoped-define DISPLAYED-TABLES proces-item
&Scoped-define FIRST-DISPLAYED-TABLE proces-item
&Scoped-Define DISPLAYED-OBJECTS c-des-unid-negoc c-desc-item c-desc-lista ~
c-desc-rot c-desc-linha c-desc-estab c-desc-ref fi-cod-unid-negoc 

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
DEFINE VARIABLE c-des-unid-negoc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estab AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 26.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 41.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-linha AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 28.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-lista AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ref AS CHARACTER FORMAT "X(32)":U 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-rot AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-unid-negoc AS CHARACTER FORMAT "X(3)" 
     LABEL "Unidade Neg¢cio":R18 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 4.29.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 5.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-des-unid-negoc AT ROW 9.83 COL 60.43 COLON-ALIGNED NO-LABEL
     proces-item.it-codigo AT ROW 1.17 COL 20.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     proces-item.sequencia AT ROW 2.17 COL 20.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     proces-item.cod-lista-compon AT ROW 3.17 COL 20.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     proces-item.cod-roteiro AT ROW 4.17 COL 20.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     proces-item.qtd-min-item AT ROW 5.79 COL 20.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.86 BY .88
     proces-item.qtd-max-item AT ROW 6.79 COL 20.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.86 BY .88
     proces-item.data-inicio AT ROW 7.79 COL 20.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     proces-item.data-termino AT ROW 8.79 COL 20.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     proces-item.cod-estabel AT ROW 5.79 COL 53 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     proces-item.nr-linha AT ROW 6.79 COL 53 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     proces-item.cod-refer AT ROW 7.79 COL 53 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     proces-item.proporcao AT ROW 8.79 COL 53 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-desc-item AT ROW 1.17 COL 38 COLON-ALIGNED NO-LABEL
     c-desc-lista AT ROW 3.17 COL 37.72 COLON-ALIGNED NO-LABEL
     c-desc-rot AT ROW 4.17 COL 37.72 COLON-ALIGNED NO-LABEL
     c-desc-linha AT ROW 6.79 COL 58 COLON-ALIGNED NO-LABEL
     c-desc-estab AT ROW 5.79 COL 60.57 COLON-ALIGNED NO-LABEL
     c-desc-ref AT ROW 7.79 COL 65.57 COLON-ALIGNED NO-LABEL
     fi-cod-unid-negoc AT ROW 9.83 COL 53 COLON-ALIGNED
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 5.46 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.proces-item
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
         HEIGHT             = 10
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-des-unid-negoc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-estab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-linha IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-lista IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-ref IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-rot IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN proces-item.cod-lista-compon IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN proces-item.cod-roteiro IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cod-unid-negoc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN proces-item.it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN proces-item.sequencia IN FRAME f-main
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

&Scoped-define SELF-NAME proces-item.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL proces-item.cod-estabel V-table-Win
ON F5 OF proces-item.cod-estabel IN FRAME f-main /* Estab */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                       &campo=proces-item.cod-estabel
                       &campozoom=cod-estabel
                       &campo2=c-desc-estab
                       &campozoom2=nome}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL proces-item.cod-estabel V-table-Win
ON LEAVE OF proces-item.cod-estabel IN FRAME f-main /* Estab */
DO:
    {include/leave.i &tabela=estabelec
                     &atributo-ref=nome
                     &variavel-ref=c-desc-estab
                     &where="estabelec.cod-estabel = input frame {&frame-name} proces-item.cod-estabel"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL proces-item.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF proces-item.cod-estabel IN FRAME f-main /* Estab */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME proces-item.cod-lista-compon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL proces-item.cod-lista-compon V-table-Win
ON F5 OF proces-item.cod-lista-compon IN FRAME f-main /* Lista Componentes */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in478.w"
                       &campo=proces-item.cod-lista-compon
                       &campozoom=cod-lista-compon
                       &campo2=c-desc-lista
                       &campozoom2=des-lista-compon}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL proces-item.cod-lista-compon V-table-Win
ON LEAVE OF proces-item.cod-lista-compon IN FRAME f-main /* Lista Componentes */
DO:
    {include/leave.i &tabela=lista-compon
                     &atributo-ref=des-lista-compon
                     &variavel-ref=c-desc-lista
                     &where="lista-compon.cod-lista-compon = input frame {&frame-name} proces-item.cod-lista-compon"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL proces-item.cod-lista-compon V-table-Win
ON MOUSE-SELECT-DBLCLICK OF proces-item.cod-lista-compon IN FRAME f-main /* Lista Componentes */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME proces-item.cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL proces-item.cod-refer V-table-Win
ON F5 OF proces-item.cod-refer IN FRAME f-main /* Referˆncia */
DO:
  assign l-implanta = yes. 
  {include/zoomvar.i &prog-zoom=inzoom/z01in375.w
                     &campo=proces-item.cod-refer
                     &campozoom=cod-refer
                     &campo2=c-desc-ref
                     &campozoom2=descricao
                     &parametros="run pi-seta-inicial in wh-pesquisa (input item.it-codigo)."}  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL proces-item.cod-refer V-table-Win
ON LEAVE OF proces-item.cod-refer IN FRAME f-main /* Referˆncia */
DO:
    {include/leave.i &tabela=referencia
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-ref
                     &where="referencia.cod-refer = input frame {&frame-name} proces-item.cod-refer"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL proces-item.cod-refer V-table-Win
ON MOUSE-SELECT-DBLCLICK OF proces-item.cod-refer IN FRAME f-main /* Referˆncia */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME proces-item.cod-roteiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL proces-item.cod-roteiro V-table-Win
ON F5 OF proces-item.cod-roteiro IN FRAME f-main /* Roteiro */
DO:
  def var rw-parent as rowid no-undo.
  
  find item where rowid(item) = v-row-parent no-lock no-error. 
  assign c-it-codigo = item.it-codigo.
  assign l-implanta = yes.   
  {include/zoomvar.i &prog-zoom="inzoom/z01in400.w"
                     &campo=proces-item.cod-roteiro
                     &campozoom=cod-roteiro
                     &campo2=c-desc-rot
                     &campozoom2=descricao
                     &parametros="run pi-seta-inicial in wh-pesquisa 
                     (input c-it-codigo)."}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL proces-item.cod-roteiro V-table-Win
ON LEAVE OF proces-item.cod-roteiro IN FRAME f-main /* Roteiro */
DO:
  {include/leave.i &tabela=rot-fabric
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-rot
                   &where="rot-fabric.cod-roteiro = input frame {&frame-name} proces-item.cod-roteiro"}  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL proces-item.cod-roteiro V-table-Win
ON MOUSE-SELECT-DBLCLICK OF proces-item.cod-roteiro IN FRAME f-main /* Roteiro */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-unid-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-unid-negoc V-table-Win
ON F5 OF fi-cod-unid-negoc IN FRAME f-main /* Unidade Neg¢cio */
DO:
   &IF DEFINED (bf_man_206b) &THEN            
       {method/zoomfields.i 
               &ProgramZoom="inzoom/z01in745.w"
               &FieldZoom1=cod-unid-negoc
               &FieldScreen1="fi-cod-unid-negoc"
               &Frame1="f-main"
               &FieldZoom2=des-unid-negoc
               &FieldScreen2="c-des-unid-negoc"
               &Frame2="f-main"
               &EnableImplant="NO"}                      
   &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-unid-negoc V-table-Win
ON LEAVE OF fi-cod-unid-negoc IN FRAME f-main /* Unidade Neg¢cio */
DO:
   &IF DEFINED(bf_man_206b) &THEN
      {include/leave.i &tabela=unid-negoc
                       &atributo-ref=des-unid-negoc
                       &variavel-ref=c-des-unid-negoc
                       &where="unid-negoc.cod-unid-negoc = input frame {&frame-name} fi-cod-unid-negoc"}    
   &endif                 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-unid-negoc V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-unid-negoc IN FRAME f-main /* Unidade Neg¢cio */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME proces-item.nr-linha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL proces-item.nr-linha V-table-Win
ON F5 OF proces-item.nr-linha IN FRAME f-main /* Linha Produ‡Æo */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in186.w"
                       &campo=proces-item.nr-linha
                       &campozoom=nr-linha
                       &campo2=c-desc-linha
                       &campozoom2=descricao}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL proces-item.nr-linha V-table-Win
ON LEAVE OF proces-item.nr-linha IN FRAME f-main /* Linha Produ‡Æo */
DO: 
    &IF DEFINED (bf_man_linha_estab) &THEN
    {include/leave.i &tabela=lin-prod
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-linha
                     &where="lin-prod.cod-estabel = input frame {&frame-name} proces-item.cod-estabel and
                             lin-prod.nr-linha    = input frame {&frame-name} proces-item.nr-linha"}    
    &ELSE
    {include/leave.i &tabela=lin-prod
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-linha
                     &where="lin-prod.nr-linha = input frame {&frame-name} proces-item.nr-linha"}  
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL proces-item.nr-linha V-table-Win
ON MOUSE-SELECT-DBLCLICK OF proces-item.nr-linha IN FRAME f-main /* Linha Produ‡Æo */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  find item where rowid(item) = v-row-parent no-lock no-error. 

  do with frame {&frame-name}:
    if proces-item.cod-estabel:load-mouse-pointer      ("image/lupa.cur") then.
    if proces-item.nr-linha:load-mouse-pointer         ("image/lupa.cur") then.
    if proces-item.cod-roteiro:load-mouse-pointer      ("image/lupa.cur") then.
    if proces-item.cod-lista-compon:load-mouse-pointer ("image/lupa.cur") then.
    if proces-item.cod-refer:load-mouse-pointer        ("image/lupa.cur") then.   

    &IF DEFINED(bf_man_206b) &THEN
          IF fi-cod-unid-negoc:LOAD-MOUSE-POINTER ("image/lupa.cur") THEN.
    &ENDIF
    
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
  {src/adm/template/row-list.i "proces-item"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "proces-item"}

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

    /* Code placed here will execute PRIOR to standard behavior. */
    /*{include/i-valid.i}*/
    
    if  not frame {&frame-name}:validate() then
        return 'ADM-ERROR':U.    
    
    if proces-item.qtd-min-item:sensitive in frame {&frame-name} = yes and
       proces-item.qtd-max-item:sensitive in frame {&frame-name} = yes and
       input frame {&frame-name} proces-item.qtd-min-item >
       input frame {&frame-name} proces-item.qtd-max-item then do:
       {utp/ut-field.i mgind proces-item qtd-min-item 01}
       assign c-label = return-value.
       {utp/ut-field.i mgind proces-item qtd-max-item 01}
       run utp/ut-msgs.p (input 'show',
                          input 1208,
                          input c-label + "~~" + return-value).
        apply 'entry' to proces-item.qtd-min-item in frame {&frame-name}.
        return 'ADM-ERROR':U.           
    end.
    
    if proces-item.data-inicio:sensitive in frame {&frame-name} = yes and
       proces-item.data-termino:sensitive in frame {&frame-name} = yes and
       input frame {&frame-name} proces-item.data-inicio >
       input frame {&frame-name} proces-item.data-termino then do:
       {utp/ut-field.i mgind proces-item data-inicio 01}
       assign c-label = return-value.
       {utp/ut-field.i mgind proces-item data-termino 01}
       run utp/ut-msgs.p (input 'show',
                          input 1208,
                          input c-label + "~~" + return-value).
        apply 'entry' to proces-item.data-inicio in frame {&frame-name}.
        return 'ADM-ERROR':U.           
    end.    
    
    if proces-item.cod-estabel:sensitive in frame {&frame-name} = yes and
       input frame {&frame-name} proces-item.cod-estabel <> "" then do:
        find first estabelec
             where estabelec.cod-estabel = input frame {&frame-name} proces-item.cod-estabel
             no-lock no-error.
        if not avail estabelec then do:
            {utp/ut-table.i mgadm estabelec 01}
            run utp/ut-msgs.p (input 'show',
                               input 56,
                               input return-value).
            apply 'entry' to proces-item.cod-estabel in frame {&frame-name}.
            return 'ADM-ERROR':U.                               
        end.
    end.
    
    if proces-item.nr-linha:sensitive in frame {&frame-name} = yes and
       input frame {&frame-name} proces-item.nr-linha <> 0 then do:
        &IF DEFINED (bf_man_linha_estab) &THEN
        find first lin-prod
             where lin-prod.cod-estabel = input frame {&frame-name} proces-item.cod-estabel
               and lin-prod.nr-linha    = input frame {&frame-name} proces-item.nr-linha
             no-lock no-error.
        &ELSE
        find first lin-prod
             where lin-prod.nr-linha = input frame {&frame-name} proces-item.nr-linha
             no-lock no-error.        
        &ENDIF
        if not avail lin-prod then do:
            {utp/ut-table.i mgind lin-prod 01}
            run utp/ut-msgs.p (input 'show',
                               input 56,
                               input return-value).
            apply 'entry' to proces-item.nr-linha in frame {&frame-name}.
            return 'ADM-ERROR':U.                               
        end.
    end.    
    
    if proces-item.cod-refer:sensitive in frame {&frame-name} = yes and
       input frame {&frame-name} proces-item.cod-refer <> "" then do:
        find first ref-item
             where ref-item.cod-refer = input frame {&frame-name} proces-item.cod-refer
               and ref-item.it-codigo = input frame {&frame-name} proces-item.it-codigo
             no-lock no-error.
        if not avail ref-item then do:
            {utp/ut-table.i mgind ref-item 01}
            run utp/ut-msgs.p (input 'show',
                               input 56,
                               input return-value).
            apply 'entry' to proces-item.cod-refer in frame {&frame-name}.
            return 'ADM-ERROR':U.                               
        end.
    end.    

    &IF DEFINED(bf_man_206b) &THEN
       IF l-unid-negoc THEN DO:
          if fi-cod-unid-negoc:sensitive in frame {&frame-name} = yes and
             input frame {&frame-name} fi-cod-unid-negoc <> "" then do:
             FIND first unid-negoc
                  where unid-negoc.cod-unid-negoc = input frame {&frame-name} fi-cod-unid-negoc no-lock no-error.      
             if not avail unid-negoc then do:
                {utp/ut-table.i mgind unid-negoc 01}
                run utp/ut-msgs.p (input 'show',
                                   input 56, 
                                   input return-value).
                apply 'entry' to fi-cod-unid-negoc in frame {&frame-name}.
                return 'ADM-ERROR':U.                               
             end.
          end.
       END.
    &ENDIF
          
    /* Ponha na pi-validate todas as valida‡äes */
    /* NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
      create tt-proces-item.
             buffer-copy proces-item to tt-proces-item.
                 assign tt-proces-item.cod-estabel       = input frame {&frame-name} proces-item.cod-estabel  
                        tt-proces-item.data-inicio       = input frame {&frame-name} proces-item.data-inicio
                        tt-proces-item.data-termino      = input frame {&frame-name} proces-item.data-termino
                        tt-proces-item.nr-linha          = input frame {&frame-name} proces-item.nr-linha
                        tt-proces-item.proporcao         = input frame {&frame-name} proces-item.proporcao
                        tt-proces-item.qtd-max-item      = input frame {&frame-name} proces-item.qtd-max-item
                        tt-proces-item.qtd-min-item      = input frame {&frame-name} proces-item.qtd-min-item
                        tt-proces-item.cod-refer         = input frame {&frame-name} proces-item.cod-refer.
    
             &if DEFINED(bf_man_206b) &THEN
                IF l-unid-negoc THEN
                   ASSIGN tt-proces-item.cod-unid-negoc  = input frame {&frame-name} fi-cod-unid-negoc.                  
             &endif
     
      run AtualizarProcesItem in h-boin481 (buffer proces-item,
                                            buffer tt-proces-item).

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    IF RETURN-VALUE = 'ADM-ERROR':U then 
       RETURN 'ADM-ERROR':U.
    
    /* Foi necess rio utilizar o campo char-1 para gravar a descri‡Æo da regra processo, pois
    ** o tamanho da descricao ultrapassa a 60 caracteres definidos para o campo proces-item.des-regra-proces **/
    
    assign proces-item.des-regra-proces = tt-proces-item.des-regra-proces
           proces-item.char-1           = tt-proces-item.char-1. 

    &if DEFINED(bf_man_206b) &THEN
        IF l-unid-negoc THEN
           ASSIGN proces-item.cod-unid-negoc = input frame {&frame-name} fi-cod-unid-negoc.
    &endif
    
    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

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
    
    &IF DEFINED(bf_man_206b) &THEN
        IF l-unid-negoc THEN
           ASSIGN fi-cod-unid-negoc:SENSITIVE IN FRAME f-main = NO.
    &ENDIF
    


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

  if available proces-item then do:
      find first item 
           where item.it-codigo = proces-item.it-codigo no-lock no-error.
      assign c-desc-item = if avail item then item.desc-item else "":U.
      
      find first referencia
           where referencia.cod-refer = proces-item.cod-refer no-lock no-error.
      assign c-desc-ref = if avail referencia then referencia.descricao else "":U.
          
      find first lista-compon 
           where lista-compon.cod-lista-compon = proces-item.cod-lista-compon no-lock no-error.
      assign c-desc-lista = if avail lista-compon then lista-compon.des-lista-compon else "":U.
      
      if proces-item.cod-roteiro <> "" then do:
          find rot-fabric where rot-fabric.cod-roteiro = proces-item.cod-roteiro no-lock no-error.
          assign c-desc-rot = if avail rot-fabric then rot-fabric.descricao else "":U.            
      end.
      
      if proces-item.cod-estabel <> "" then do:
          find estabelec where estabelec.cod-estabel = proces-item.cod-estabel no-lock no-error.
          assign c-desc-estab = if avail estabelec then estabelec.nome else "":U.
      end.
      
      if proces-item.nr-linha <> 0 then do:
          &IF DEFINED (bf_man_linha_estab) &THEN
          find lin-prod 
               where lin-prod.cod-estabel = proces-item.cod-estabel
               and lin-prod.nr-linha    = proces-item.nr-linha no-lock no-error.
          &ELSE
              find lin-prod where lin-prod.nr-linha = proces-item.nr-linha no-lock no-error.          
          &ENDIF
           assign c-desc-linha = if avail lin-prod then lin-prod.descricao else "":U.            
      end.     

      &IF DEFINED(bf_man_206b) &THEN
          IF l-unid-negoc THEN DO:
             FIND unid-negoc WHERE unid-negoc.cod-unid-negoc = proces-item.cod-unid-negoc NO-LOCK NO-ERROR.
                  ASSIGN fi-cod-unid-negoc = proces-item.cod-unid-negoc
                         c-des-unid-negoc  = IF AVAIL unid-negoc THEN unid-negoc.des-unid-negoc ELSE "":U.
             APPLY 'leave':U TO fi-cod-unid-negoc  IN FRAME f-main.
          END.
          ELSE 
             ASSIGN fi-cod-unid-negoc:HIDDEN IN FRAME f-main = YES
                     c-des-unid-negoc:HIDDEN IN FRAME f-main = YES.           
      &ENDIF
           
  end.

  /* Dispatch standard ADM method.                          */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

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
    /*if adm-new-record = yes then*/
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    if avail item then do:
       if item.tipo-con-est = 4 then
            assign proces-item.cod-refer:sensitive in frame {&frame-name} = yes.
       else assign proces-item.cod-refer:sensitive in frame {&frame-name} = no.
    end.
    
    /* Pre-processador para o campo unidade de negocio */
    &IF DEFINED(bf_man_206b) &THEN 
        IF l-unid-negoc THEN            
           ASSIGN fi-cod-unid-negoc:SENSITIVE IN FRAME f-main = YES.
        ELSE 
           ASSIGN fi-cod-unid-negoc:SENSITIVE IN FRAME f-main = NO
                     fi-cod-unid-negoc:HIDDEN IN FRAME f-main = YES
                      c-des-unid-negoc:HIDDEN IN FRAME f-main = YES.
    &ELSE 
        ASSIGN fi-cod-unid-negoc:SENSITIVE IN FRAME f-main = NO
                  fi-cod-unid-negoc:HIDDEN IN FRAME f-main = YES
                   c-des-unid-negoc:HIDDEN IN FRAME f-main = YES.
    &ENDIF
            
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
  
       
  &IF DEFINED(bf_man_206b) &THEN
      if (CAN-FIND(FIRST funcao where funcao.cd-funcao = "EMS2-UNIDADE-NEGOCIO"
          and funcao.ativo = yes)) THEN
          ASSIGN l-unid-negoc = YES.
  &else
     ASSIGN fi-cod-unid-negoc:HIDDEN IN FRAME f-main= YES
             c-des-unid-negoc:HIDDEN IN FRAME f-main= YES.
  &ENDIF
  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-hbo V-table-Win 
PROCEDURE pi-atualiza-hbo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-handle as handle no-undo.

assign h-boin481 = p-handle.

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
    
  find first item where rowid(item) = v-row-parent no-lock no-error.
  if not avail item then do:
     {utp/ut-table.i mgind item 1} 
     run utp/ut-msgs.p (input "show",
                        input 56,
                        input return-value).
     return 'ADM-ERROR':U.
  end. 
  assign rw-item = v-row-parent.
      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */
    
/*/*    Segue um exemplo de valida‡Æo de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/

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
  {src/adm/template/snd-list.i "proces-item"}

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

