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
{include/i-prgvrs.i V02IN479 2.00.00.012}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v02in479 MUT}
&ENDIF



/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

{cdp/cdcfgman.i}

def new global shared var gr-lista-compon as rowid no-undo.

def var v-row-parent as rowid  no-undo.
def var c-texto      as char   no-undo.
def var h-boin479    as handle no-undo.
def var rw-lista     as rowid  no-undo.

def buffer b-item-lista-compon for item-lista-compon.

define variable c-lista as character no-undo.
define variable i-cont as integer no-undo.

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
&Scoped-define EXTERNAL-TABLES item-lista-compon
&Scoped-define FIRST-EXTERNAL-TABLE item-lista-compon


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item-lista-compon.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item-lista-compon.qtd-lista ~
item-lista-compon.proporcao item-lista-compon.qtd-compon ~
item-lista-compon.data-inicio item-lista-compon.data-termino 
&Scoped-define ENABLED-TABLES item-lista-compon
&Scoped-define FIRST-ENABLED-TABLE item-lista-compon
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS item-lista-compon.cod-lista-compon ~
item-lista-compon.sequencia item-lista-compon.es-codigo ~
item-lista-compon.cod-ref-es item-lista-compon.qtd-lista ~
item-lista-compon.int-1 item-lista-compon.proporcao ~
item-lista-compon.qtd-compon item-lista-compon.data-inicio ~
item-lista-compon.data-termino 
&Scoped-define DISPLAYED-TABLES item-lista-compon
&Scoped-define FIRST-DISPLAYED-TABLE item-lista-compon
&Scoped-Define DISPLAYED-OBJECTS c-desc-lista c-desc1 c-desc-ref c-un-lista ~
c-un 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS item-lista-compon.sequencia ~
item-lista-compon.es-codigo item-lista-compon.int-1 
&Scoped-define ADM-ASSIGN-FIELDS item-lista-compon.cod-ref-es ~
item-lista-compon.int-1 
&Scoped-define ADM-MODIFY-FIELDS item-lista-compon.int-1 

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
DEFINE VARIABLE c-desc-lista AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 47.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ref AS CHARACTER FORMAT "X(32)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc1 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 47.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-un AS CHARACTER FORMAT "X(2)":U 
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-un-lista AS CHARACTER FORMAT "X(2)":U 
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 4.29.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 4.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item-lista-compon.cod-lista-compon AT ROW 1.17 COL 21.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc-lista AT ROW 1.17 COL 39.29 COLON-ALIGNED NO-LABEL
     item-lista-compon.sequencia AT ROW 2.17 COL 21.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     item-lista-compon.es-codigo AT ROW 3.17 COL 21.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc1 AT ROW 3.17 COL 39.29 COLON-ALIGNED NO-LABEL
     item-lista-compon.cod-ref-es AT ROW 4.17 COL 21.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     c-desc-ref AT ROW 4.17 COL 34.57 COLON-ALIGNED NO-LABEL
     item-lista-compon.qtd-lista AT ROW 5.67 COL 21.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.86 BY .88
     c-un-lista AT ROW 5.67 COL 37 COLON-ALIGNED NO-LABEL
     item-lista-compon.int-1 AT ROW 6.67 COL 23.72 HELP
          "" NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "OPT1", 1,
"OPT2", 2,
"OPT3", 3
          SIZE 49.43 BY 1
     item-lista-compon.proporcao AT ROW 7.71 COL 21.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
    item-lista-compon.qtd-compon AT ROW 8.71 COL 21.72 COLON-ALIGNED FORMAT "->>>,>>9.9999999999"
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-un AT ROW 8.71 COL 39.29 COLON-ALIGNED NO-LABEL
     item-lista-compon.data-inicio AT ROW 7.71 COL 61.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     item-lista-compon.data-termino AT ROW 8.71 COL 61.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 5.29 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item-lista-compon
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
         HEIGHT             = 9.17
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

/* SETTINGS FOR FILL-IN c-desc-lista IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-ref IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un-lista IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item-lista-compon.cod-lista-compon IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item-lista-compon.cod-ref-es IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN item-lista-compon.es-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR RADIO-SET item-lista-compon.int-1 IN FRAME f-main
   NO-ENABLE 1 2 3 EXP-HELP                                             */
/* SETTINGS FOR FILL-IN item-lista-compon.qtd-compon IN FRAME f-main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN item-lista-compon.sequencia IN FRAME f-main
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

&Scoped-define SELF-NAME item-lista-compon.cod-ref-es
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-lista-compon.cod-ref-es V-table-Win
ON F5 OF item-lista-compon.cod-ref-es IN FRAME f-main /* Ref Componente */
DO:
  assign l-implanta = yes. 
  {include/zoomvar.i &prog-zoom=inzoom/z01in375.w
                     &campo=item-lista-compon.cod-ref-es
                     &campozoom=cod-refer
                     &campo2=c-desc-ref
                     &campozoom2=descricao
                     &parametros="run pi-seta-inicial in wh-pesquisa (input item-lista-compon.es-codigo:screen-value in frame {&frame-name})."}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-lista-compon.cod-ref-es V-table-Win
ON LEAVE OF item-lista-compon.cod-ref-es IN FRAME f-main /* Ref Componente */
DO:
    /* se encontrar referància para o item, busca descriá∆o */
     if CAN-FIND (FIRST ref-item WHERE
                    ref-item.cod-refer = input frame {&frame-name} item-lista-compon.cod-ref-es and
                    ref-item.it-cod = input frame {&frame-name} item-lista-compon.es-codigo) then do: 

                {include/leave.i &tabela=referencia
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-ref
                     &where="referencia.cod-refer = input frame {&frame-name} item-lista-compon.cod-ref-es"}    
     end.
     else
         c-desc-ref:screen-value in frame {&frame-name} = " ".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-lista-compon.cod-ref-es V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-lista-compon.cod-ref-es IN FRAME f-main /* Ref Componente */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-lista-compon.es-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-lista-compon.es-codigo V-table-Win
ON F5 OF item-lista-compon.es-codigo IN FRAME f-main /* Componente */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom="inzoom/z01in172.w"
                       &campo=item-lista-compon.es-codigo
                       &campozoom=it-codigo
                       &campo2=c-desc1
                       &campozoom2=desc-item}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-lista-compon.es-codigo V-table-Win
ON LEAVE OF item-lista-compon.es-codigo IN FRAME f-main /* Componente */
DO:
  {include/leave.i &tabela=item
                   &atributo-ref=desc-item
                   &variavel-ref=c-desc1
                   &atributo-ref2=un
                   &variavel-ref2=c-un
                   &where="item.it-codigo = input frame {&frame-name} item-lista-compon.es-codigo"}
  if avail item then do:
     /* se tipo controle estoque = 4 (referància) */
     if item.tipo-con-est = 4 then do:
          assign item-lista-compon.cod-ref-es:sensitive in frame {&frame-name} = yes.
          apply "entry" to item-lista-compon.cod-ref-es in frame {&frame-name}.
          return no-apply.
     end.
     else do:
          assign item-lista-compon.cod-ref-es:screen-value in frame {&frame-name} = " "
                 c-desc-ref:screen-value in frame {&frame-name} = " "
                 item-lista-compon.cod-ref-es:sensitive in frame {&frame-name} = no.
     end.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-lista-compon.es-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-lista-compon.es-codigo IN FRAME f-main /* Componente */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
 {utp/ut-liter.i SeqÅància *R}
 assign item-lista-compon.sequencia:label in frame {&frame-name} = trim(return-value).

 {utp/ut-liter.i In°cio_Validade *R}
 assign item-lista-compon.data-inicio:label in frame {&frame-name} = trim(return-value).

 {utp/ut-liter.i Co-produto * R}
 assign item-lista-compon.es-codigo:label in frame {&frame-name} = trim(return-value).

 {utp/ut-liter.i Ref._Co-produto * R}
 assign item-lista-compon.cod-ref-es:label in frame {&frame-name} = trim(return-value).

 if item-lista-compon.es-codigo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
 if item-lista-compon.cod-ref-es:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "item-lista-compon"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item-lista-compon"}

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

  display today @ item-lista-compon.data-inicio with frame {&frame-name}.

  if available lista-compon then
      disp lista-compon.cod-lista-compon @ item-lista-compon.cod-lista-compon 
           lista-compon.des-lista-compon @ c-desc-lista
           lista-compon.un               @ c-un-lista
           lista-compon.qtd-lista        @ item-lista-compon.qtd-lista  with frame {&frame-name}.

  find last param-en no-lock no-error.
  if not avail param-en then
     create param-en.
  find last b-item-lista-compon where 
       b-item-lista-compon.cod-lista-compon = item-lista-compon.cod-lista-compon:screen-value in frame {&frame-name} 
       no-lock no-error.
  if  avail b-item-lista-compon then 
     assign item-lista-compon.sequencia:screen-value in frame {&frame-name} = string(b-item-lista-compon.sequencia + param-en.num-var-estrutura).
  else
     assign item-lista-compon.sequencia:screen-value in frame {&frame-name} = string(param-en.num-var-estrutura).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    def var da-1 as date no-undo.
    def var da-2 as date no-undo.

      find first item where 
         item.it-codigo = item-lista-compon.es-codigo:screen-value in frame {&frame-name} no-lock no-error.
      if not avail item then do:   

          {utp/ut-table.i mgind item 01}       
          run utp/ut-msgs.p (input "show":U, 
                             input 56, 
                             input return-value).
          apply 'entry' to item-lista-compon.es-codigo in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.                                
      else do:

            if item.un <> c-un:screen-value in frame {&frame-name} then do:
                run utp/ut-msgs.p (input "show":U, input 848, input "").
                apply 'entry' to c-un.
                return 'ADM-ERROR':U.
            end.

            if item.it-codigo = "" then do:
                run utp/ut-msgs.p (input "show",
                                   input 17485,
                                   input return-value).
                apply 'entry' to item-lista-compon.es-codigo in frame {&frame-name}.                            
                return 'ADM-ERROR':U.
            end.   

            /*** Verifica se componente da estrutura Ç obsoleto ***/
            if item.cod-obsoleto >= 3 then do:

                run utp/ut-msgs.p (input "show",
                                   input 563,
                                   input item.it-codigo).
                apply 'entry' to item-lista-compon.es-codigo in frame {&frame-name}.                            
                return 'ADM-ERROR':U.
            end.         
      end.

      /*** Item n∆o pode ter nenhuma lista associada ***/

      IF CAN-FIND(FIRST lista-compon-item WHERE
                  lista-compon-item.cod-lista-compon = lista-compon.cod-lista-compon AND
                  lista-compon-item.it-codigo        = item-lista-compon.es-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}) then do:
          run utp/ut-msgs.p (input "show",
                             input 17758,
                             input return-value).
          apply 'entry' to item-lista-compon.es-codigo in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.

      assign da-1 = date(item-lista-compon.data-inicio:screen-value in frame {&frame-name})
             da-2 = date(item-lista-compon.data-termino:screen-value in frame {&frame-name}).

      /*** Verifica coerància de datas ***/
      if  da-1 > da-2 then do:
          {utp/ut-field.i mgind item-lista-compon data-termino 01}
          assign c-texto = return-value. 
          {utp/ut-field.i mgind item-lista-compon data-inicio 01}
          run utp/ut-msgs.p (input "show",
                             input 7017,
                             input c-texto + "~~" + return-value).
          apply 'entry' to item-lista-compon.data-inicio in frame {&frame-name}.                            
          return 'ADM-ERROR':U.
      end.         

      if item-lista-compon.cod-ref-es:sensitive in frame {&frame-name} = yes and
         input frame {&frame-name} item-lista-compon.cod-ref-es <> "" then do:

          find first ref-item
               where ref-item.cod-refer = input frame {&frame-name} item-lista-compon.cod-ref-es
                 and ref-item.it-codigo = input frame {&frame-name} item-lista-compon.es-codigo
               no-lock no-error.
          if not avail ref-item then do:
              {utp/ut-table.i mgind ref-item 01}
              run utp/ut-msgs.p (input 'show',
                                 input 56,
                                 input return-value).
              apply 'entry' to item-lista-compon.cod-ref-es in frame {&frame-name}.
              return 'ADM-ERROR':U.                               
          end.
      end.
      else do:

          if item-lista-compon.cod-ref-es:sensitive in frame {&frame-name} = yes and
             input frame {&frame-name} item-lista-compon.cod-ref-es = "" then do:
            {utp/ut-table.i mgind ref-item 01}
            run utp/ut-msgs.p (input 'show',
                               input 56,
                               input return-value).
            apply 'entry' to item-lista-compon.cod-ref-es in frame {&frame-name}.
            return 'ADM-ERROR':U.                               
         end.
      end.

      IF  adm-new-record AND 
          CAN-FIND(FIRST b-item-lista-compon NO-LOCK
                  WHERE b-item-lista-compon.cod-lista-compon = input frame {&frame-name} item-lista-compon.cod-lista-compon
                    AND b-item-lista-compon.es-codigo        = input frame {&frame-name} item-lista-compon.es-codigo
                    AND b-item-lista-compon.sequencia        = input frame {&frame-name} item-lista-compon.sequencia)
      THEN DO:
          {utp/ut-table.i mgmfg item-lista-compon 01}
          run utp/ut-msgs.p (INPUT 'show',
                             INPUT 1,
                             INPUT RETURN-VALUE).
          APPLY 'entry' to item-lista-compon.sequencia IN FRAME {&FRAME-NAME}.
          RETURN 'ADM-ERROR':U.                               
      END.


/*       if item-lista-compon.cod-ref-es:sensitive in frame {&frame-name} = yes then do:                                                   */
/*                                                                                                                                         */
/*          find first b-item-lista-compon                                                                                           */ 
/*               where b-item-lista-compon.cod-lista-compon = item-lista-compon.cod-lista-compon:screen-value in frame {&frame-name} */
/*                 and b-item-lista-compon.es-codigo        = item-lista-compon.es-codigo:screen-value in frame {&frame-name}        */
/*                 and b-item-lista-compon.cod-ref-es         = input frame {&frame-name} item-lista-compon.cod-ref-es               */
/*                 and rowid(b-item-lista-compon)          <> rowid(item-lista-compon) no-lock no-error.                             */
/*          if avail b-item-lista-compon then do:                                                                                    */
/*             {utp/ut-table.i mgind item-lista-compon 01}                                                                           */
/*             run utp/ut-msgs.p (input "show",                                                                                      */
/*                                input 1,                                                                                           */
/*                                input return-value).                                                                               */
/*             apply 'entry' to item-lista-compon.es-codigo in frame {&frame-name}.                                                  */
/*             return 'ADM-ERROR':U.                                                                                                 */
/*          end.                                                                                                                     */
/*       end.                                                                                                                        */
/*       else do:                                                                                                                    */
/*                                                                                                                                   */
/*          find first b-item-lista-compon                                                                                           */
/*               where b-item-lista-compon.cod-lista-compon = item-lista-compon.cod-lista-compon:screen-value in frame {&frame-name} */
/*                 and b-item-lista-compon.es-codigo        = item-lista-compon.es-codigo:screen-value in frame {&frame-name}        */
/*                 and rowid(b-item-lista-compon)          <> rowid(item-lista-compon) no-lock no-error.                             */
/*          if avail b-item-lista-compon then do:                                                                                    */
/*             {utp/ut-table.i mgind item-lista-compon 01}                                                                           */
/*             run utp/ut-msgs.p (input "show",                                                                                      */
/*                                input 1,                                                                                           */
/*                                input return-value).                                                                               */
/*             apply 'entry' to item-lista-compon.es-codigo in frame {&frame-name}.                                                  */
/*             return 'ADM-ERROR':U.                                                                                                 */
/*          end.                                                                                                                     */
/*       end. */

      &IF DEFINED (bf_man_per_ppm) &THEN
        if param-global.modulo-per-ppm and
           item.tipo-formula <> 1 then do: /* Concentraá∆o, PPM, Ve°culo */
            run utp/ut-msgs.p (input "show",
                               input 27340,
                               input return-value + "~~" + 
                                     {ininc/i25in172.i 04 item.tipo-formula}).
            apply 'entry' to item-lista-compon.es-codigo in frame {&frame-name}.
            return 'ADM-ERROR':U.                    

        end.
      &ENDIF    


    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    if input frame {&frame-name} item-lista-compon.qtd-compon > 0 then 
       assign item-lista-compon.qtd-compon = - input frame {&frame-name} item-lista-compon.qtd-compon.

       run AtualizarItemListaCompon in h-boin479 (input rowid(item-lista-compon)). 


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

    find lista-compon
         where rowid(lista-compon) = v-row-parent no-error.
    if available lista-compon then
        assign item-lista-compon.cod-lista-compon = lista-compon.cod-lista-compon.

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

    if avail item-lista-compon then do:
        if item-lista-compon.int-1 = 0 then do transaction:
            find current item-lista-compon exclusive-lock.
            assign item-lista-compon.int-1 = 3.
            find current item-lista-compon no-lock.
        end.
    end.

  /* Dispatch standard ADM method.                             */

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    if available lista-compon then do:
        assign item-lista-compon.cod-lista-compon:screen-value in frame {&frame-name} = lista-compon.cod-lista-compon
               c-desc-lista:screen-value in frame {&frame-name}                       = lista-compon.des-lista-compon
               c-un-lista:screen-value in frame {&frame-name}                         = lista-compon.un.
        if adm-new-record then
            assign item-lista-compon.qtd-lista:screen-value in frame {&frame-name} = string(lista-compon.qtd-lista).
    end.

    if avail item-lista-compon then do:
        find item where item.it-codigo = item-lista-compon.es-codigo no-lock no-error.
        if  avail item then 
            assign c-un:screen-value in frame {&frame-name}    = item.un
                   c-desc1:screen-value in frame {&frame-name} = item.desc-item.
    end.

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
/*    if adm-new-record = yes then*/
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

  if not adm-new-record then  do:
     find item where item.it-codigo = item-lista-compon.es-codigo no-lock no-error.
     if  avail item then do:
         assign c-un:screen-value in frame {&frame-name}    = item.un
                c-desc1:screen-value in frame {&frame-name} = item.desc-item.
         if item.tipo-con-est = 4 then
            assign item-lista-compon.cod-ref-es:sensitive in frame {&frame-name} = yes.
     end.
     assign item-lista-compon.qtd-compon:screen-value in frame {&frame-name} = string(item-lista-compon.qtd-compon).         
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

  assign rw-lista = gr-lista-compon.

    do i-cont = 1 to 3:
        assign c-lista = c-lista + entry(i-cont,{ininc/i01in068.i 03}) + "," + string(i-cont) + ",".
    end.

    assign c-lista   = substring(c-lista, 1, length(c-lista) - 1).
    assign item-lista-compon.int-1:radio-buttons in frame {&frame-name} = c-lista.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  find first param-global no-lock.

  if rw-lista <> ? then
     find first lista-compon
          where rowid(lista-compon) = rw-lista no-lock no-error.

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

assign h-boin479 = p-handle.

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

    find lista-compon where rowid(lista-compon) = v-row-parent no-error.

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

/*/*    Segue um exemplo de validaá∆o de programa */
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
  {src/adm/template/snd-list.i "item-lista-compon"}

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

