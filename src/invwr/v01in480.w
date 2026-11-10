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
{include/i-prgvrs.i V01IN480 2.00.00.007 } /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN480 MUT}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

def new global shared var gr-rot-fabric   as rowid no-undo.
def new global shared var gr-item         as rowid no-undo.

def var c-it-codigo    like item.it-codigo.
def var c-cod-roteiro  like rot-fabric.cod-roteiro.
def var rw-item        as   rowid  no-undo.
def var v-row-parent   as   rowid  no-undo.
def var c-label        as   char   no-undo.
def var h-boin480      as   handle no-undo.

def buffer b-lista-compon-item for lista-compon-item.


{METHOD/dbotterr.i}

define variable hShowMsg            as handle     no-undo.

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
&Scoped-define EXTERNAL-TABLES lista-compon-item
&Scoped-define FIRST-EXTERNAL-TABLE lista-compon-item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR lista-compon-item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS lista-compon-item.sequencia ~
lista-compon-item.proporcao lista-compon-item.qtd-item ~
lista-compon-item.qtd-lista lista-compon-item.data-inicio ~
lista-compon-item.data-termino lista-compon-item.cod-roteiro ~
lista-compon-item.op-codigo 
&Scoped-define ENABLED-TABLES lista-compon-item
&Scoped-define FIRST-ENABLED-TABLE lista-compon-item
&Scoped-Define ENABLED-OBJECTS RECT-1 rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS lista-compon-item.it-codigo ~
lista-compon-item.sequencia lista-compon-item.cod-lista-compon ~
lista-compon-item.proporcao lista-compon-item.qtd-item ~
lista-compon-item.qtd-lista lista-compon-item.data-inicio ~
lista-compon-item.data-termino lista-compon-item.cod-roteiro ~
lista-compon-item.op-codigo 
&Scoped-define DISPLAYED-TABLES lista-compon-item
&Scoped-define FIRST-DISPLAYED-TABLE lista-compon-item
&Scoped-Define DISPLAYED-OBJECTS c-un-item c-un-lista c-desc-item ~
c-desc-lista c-desc-op c-desc-rot 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS lista-compon-item.sequencia ~
lista-compon-item.cod-lista-compon 

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
DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-lista AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-op AS CHARACTER FORMAT "X(34)":U 
     VIEW-AS FILL-IN 
     SIZE 31.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-rot AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-un-item AS CHARACTER FORMAT "X(2)":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-un-lista AS CHARACTER FORMAT "X(2)":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.42.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.38.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-un-item AT ROW 5.75 COL 35.29 COLON-ALIGNED NO-LABEL
     c-un-lista AT ROW 6.75 COL 37.57 COLON-ALIGNED NO-LABEL
     lista-compon-item.it-codigo AT ROW 1.25 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc-item AT ROW 1.25 COL 37.72 COLON-ALIGNED NO-LABEL
     lista-compon-item.sequencia AT ROW 2.25 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     lista-compon-item.cod-lista-compon AT ROW 3.25 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc-lista AT ROW 3.25 COL 37.72 COLON-ALIGNED NO-LABEL
     lista-compon-item.proporcao AT ROW 4.75 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     lista-compon-item.qtd-item AT ROW 5.75 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.86 BY .88
     lista-compon-item.qtd-lista AT ROW 6.75 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     lista-compon-item.data-inicio AT ROW 4.75 COL 55 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     lista-compon-item.data-termino AT ROW 5.75 COL 55 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     lista-compon-item.cod-roteiro AT ROW 8.29 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     lista-compon-item.op-codigo AT ROW 9.29 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     c-desc-op AT ROW 9.29 COL 27.43 COLON-ALIGNED NO-LABEL
     c-desc-rot AT ROW 8.29 COL 37.57 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 8.04 COL 1
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 4.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.lista-compon-item
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
         HEIGHT             = 9.54
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

/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-lista IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-op IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-rot IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un-lista IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN lista-compon-item.cod-lista-compon IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN lista-compon-item.it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN lista-compon-item.sequencia IN FRAME f-main
   1                                                                    */
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

&Scoped-define SELF-NAME lista-compon-item.cod-lista-compon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lista-compon-item.cod-lista-compon V-table-Win
ON F5 OF lista-compon-item.cod-lista-compon IN FRAME f-main /* Lista Componentes */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in478.w"
                       &campo=lista-compon-item.cod-lista-compon
                       &campozoom=cod-lista-compon
                       &campo2=c-desc-lista
                       &campozoom2=des-lista-compon}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lista-compon-item.cod-lista-compon V-table-Win
ON LEAVE OF lista-compon-item.cod-lista-compon IN FRAME f-main /* Lista Componentes */
DO:
    {include/leave.i &tabela=lista-compon
                     &atributo-ref=des-lista-compon
                     &variavel-ref=c-desc-lista
                     &where="lista-compon.cod-lista-compon = input frame {&frame-name} lista-compon-item.cod-lista-compon"}
    if avail lista-compon then
       assign c-un-lista:screen-value in frame {&frame-name} = lista-compon.un.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lista-compon-item.cod-lista-compon V-table-Win
ON MOUSE-SELECT-DBLCLICK OF lista-compon-item.cod-lista-compon IN FRAME f-main /* Lista Componentes */
DO:
  apply 'F5' to self. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lista-compon-item.cod-roteiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lista-compon-item.cod-roteiro V-table-Win
ON F5 OF lista-compon-item.cod-roteiro IN FRAME f-main /* Roteiro */
DO:
  def var rw-parent as rowid no-undo.

  find item where rowid(item) = v-row-parent no-lock no-error. 
  assign c-it-codigo = item.it-codigo.
  assign l-implanta = yes.   
  {include/zoomvar.i &prog-zoom="inzoom/z01in400.w"
                     &campo=lista-compon-item.cod-roteiro
                     &campozoom=cod-roteiro
                     &campo2=c-desc-rot
                     &campozoom2=descricao
                     &parametros="run pi-seta-inicial in wh-pesquisa 
                     (input c-it-codigo)."}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lista-compon-item.cod-roteiro V-table-Win
ON LEAVE OF lista-compon-item.cod-roteiro IN FRAME f-main /* Roteiro */
DO:
  {include/leave.i &tabela=rot-fabric
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-rot
                   &where="rot-fabric.cod-roteiro = input frame {&frame-name} lista-compon-item.cod-roteiro"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lista-compon-item.cod-roteiro V-table-Win
ON MOUSE-SELECT-DBLCLICK OF lista-compon-item.cod-roteiro IN FRAME f-main /* Roteiro */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lista-compon-item.op-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lista-compon-item.op-codigo V-table-Win
ON F5 OF lista-compon-item.op-codigo IN FRAME f-main /* Opera‡Æo */
DO:
  def var rw-parent as rowid no-undo.
  find item where rowid(item) = v-row-parent no-lock no-error. 
  assign c-it-codigo = item.it-codigo.

  find rot-fabric 
       where rot-fabric.cod-roteiro = input frame {&frame-name} lista-compon-item.cod-roteiro 
       no-lock no-error.
  if avail rot-fabric then 
     assign gr-rot-fabric = rowid(rot-fabric)
            gr-item       = ?
            rw-parent     = gr-rot-fabric.
  else do:          
        assign rw-parent  = v-row-parent.
  end.   

  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z04in263.w"
                     &campo=lista-compon-item.op-codigo
                     &campozoom=op-codigo
                     &campo2=c-desc-op
                     &campozoom2=descricao
                     &parametros="run pi-seta-inicial in wh-pesquisa 
                     (input rw-parent)."}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lista-compon-item.op-codigo V-table-Win
ON LEAVE OF lista-compon-item.op-codigo IN FRAME f-main /* Opera‡Æo */
DO:
 find item where rowid(item) = v-row-parent no-lock no-error. 
 assign c-it-codigo = item.it-codigo. 

 if input frame {&frame-name} lista-compon-item.cod-roteiro <> "" then
    find rot-fabric 
        where rot-fabric.cod-roteiro = input frame {&frame-name} lista-compon-item.cod-roteiro 
        no-lock no-error.
 if avail rot-fabric then 
    assign c-it-codigo   = "" 
           c-cod-roteiro = rot-fabric.cod-roteiro.
 else
     assign c-it-codigo   = item.it-codigo 
            c-cod-roteiro = "".

 find operacao where
      operacao.it-codigo   = c-it-codigo   and
      operacao.cod-roteiro = c-cod-roteiro and
      operacao.op-codigo   = input frame {&frame-name} lista-compon-item.op-codigo no-lock no-error.

 if  avail operacao then 
     assign c-desc-op:screen-value in frame {&frame-name} = operacao.descricao.
 else    
     assign c-desc-op:screen-value in frame {&frame-name} = "".  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lista-compon-item.op-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF lista-compon-item.op-codigo IN FRAME f-main /* Opera‡Æo */
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
   if lista-compon-item.op-codigo:load-mouse-pointer   ("image/lupa.cur") then.
   if lista-compon-item.cod-roteiro:load-mouse-pointer ("image/lupa.cur") then.
   if lista-compon-item.cod-lista-compon:load-mouse-pointer ("image/lupa.cur") then.
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
  {src/adm/template/row-list.i "lista-compon-item"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "lista-compon-item"}

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

  display today @ lista-compon-item.data-inicio with frame {&frame-name}.

  if available item then
      disp item.it-codigo @ lista-compon-item.it-codigo
           item.desc-item @ c-desc-item 
           item.un        @ c-un-item
           with frame {&frame-name}.

  find last param-en no-lock no-error.
  if not avail param-en then
     create param-en.
  find last b-lista-compon-item where 
       b-lista-compon-item.it-codigo = lista-compon-item.it-codigo:screen-value in frame {&frame-name} 
       no-lock no-error.
  if  avail b-lista-compon-item then 
     assign lista-compon-item.sequencia:screen-value in frame {&frame-name} = string(b-lista-compon-item.sequencia + param-en.num-var-estrutura).
  else
     assign lista-compon-item.sequencia:screen-value in frame {&frame-name} = string(param-en.num-var-estrutura).

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

    
    if not frame {&frame-name}:validate() then
       return 'ADM-ERROR':U.    

    IF CAN-FIND (FIRST item-lista-compon
             WHERE item-lista-compon.cod-lista-compon = lista-compon.cod-lista-compon
               AND item-lista-compon.es-codigo        = item.it-codigo) THEN DO:
        run utp/ut-msgs.p (INPUT 'show',
                           INPUT 2240,
                           INPUT return-value ).
        RETURN "ADM-ERROR":U.
    END.

    if not can-find(lista-compon where lista-compon.cod-lista-compon = 
                    input frame {&frame-name} lista-compon-item.cod-lista-compon) then do:
        {utp/ut-table.i mgind lista-compon 01}
        run utp/ut-msgs.p (input 'show',
                           input 56,
                           input return-value).
        apply "entry" to lista-compon-item.cod-lista-compon in frame {&frame-name}.
        return "ADM-ERROR":U.
    end.                       

    if lista-compon-item.cod-lista-compon:sensitive in frame {&frame-name} = yes 
    and can-find(first b-lista-compon-item 
                 where b-lista-compon-item.it-codigo        = item.it-codigo
                   and b-lista-compon-item.cod-lista-compon = input frame {&frame-name} lista-compon-item.cod-lista-compon) then do:
        {utp/ut-field.i mgind lista-compon-item cod-lista-compon 1}
        run utp/ut-msgs.p (input "show",
                           input 1,
                           input return-value).
        apply "entry" to lista-compon-item.cod-lista-compon in frame {&frame-name}.
        return "ADM-ERROR":U.
    end.   

    if lista-compon-item.cod-roteiro:screen-value in frame {&frame-name} <> "" and
       lista-compon-item.op-codigo:screen-value in frame {&frame-name} = "0" then do:
        {utp/ut-field.i mgind lista-compon-item op-codigo 01}
        run utp/ut-msgs.p (input "show",
                           input 822,
                           input return-value).
        apply 'entry' to lista-compon-item.op-codigo in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.
    ELSE DO:
        IF lista-compon-item.cod-roteiro:screen-value in frame {&frame-name} <> "" AND 
           lista-compon-item.op-codigo:screen-value in frame {&frame-name} <> "0"   THEN DO:
            find first operacao
           where operacao.cod-roteiro = input frame {&frame-name} lista-compon-item.cod-roteiro
             AND operacao.op-codigo   = input frame {&frame-name} lista-compon-item.op-codigo
             and operacao.it-codigo   = "" no-lock no-error.

            if not avail operacao then do:
                {utp/ut-field.i mgind lista-compon-item op-codigo 01}
                run utp/ut-msgs.p (input "show",
                                   input 7381,
                                   input return-value).
                apply 'entry' to lista-compon-item.op-codigo in frame {&frame-name}.
                return 'ADM-ERROR':U.
            END.
        END.
    END.

    if input frame {&frame-name} lista-compon-item.data-inicio >
       input frame {&frame-name} lista-compon-item.data-termino then do:
       {utp/ut-field.i mgind lista-compon-item data-inicio 01}
       assign c-label = return-value.
       {utp/ut-field.i mgind lista-compon-item data-termino 01}
       run utp/ut-msgs.p (input 'show',
                          input 1208,
                          input c-label + "~~" + return-value).
        apply 'entry' to lista-compon-item.data-inicio in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.                              

    if input frame {&frame-name} lista-compon-item.cod-roteiro <> "" then do:
        find first rot-item
             where rot-item.cod-roteiro = input frame {&frame-name} lista-compon-item.cod-roteiro
               and rot-item.it-codigo   = item.it-codigo no-lock no-error.
        if not avail rot-item then do:
            run utp/ut-msgs.p (input 'show',
                               input 2688,
                               input "").
            apply 'entry' to lista-compon-item.cod-roteiro in frame {&frame-name}.
            return 'ADM-ERROR':U.    
        end.
    end.
    IF lista-compon-item.op-codigo:screen-value in frame {&frame-name}      <> ""  AND 
       int(lista-compon-item.op-codigo:screen-value in frame {&frame-name}) <> 0   AND 
       lista-compon-item.cod-roteiro:screen-value in frame {&frame-name}    = " "  then do:
        find first operacao
             where operacao.op-codigo   = input frame {&frame-name} lista-compon-item.op-codigo
               AND operacao.cod-roteiro = input frame {&frame-name} lista-compon-item.cod-roteiro
               and operacao.it-codigo   = input frame {&frame-name} lista-compon-item.it-codigo no-lock no-error.

        if not avail operacao then do:
            {utp/ut-field.i mgind lista-compon-item op-codigo 01}
            run utp/ut-msgs.p (input "show",
                               input 7381,
                               input return-value).
            apply 'entry' to lista-compon-item.op-codigo in frame {&frame-name}.
            return 'ADM-ERROR':U.
        END.
    end.

    

    DO TRANS ON ERROR UNDO, LEAVE:
    

        RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
        if RETURN-VALUE = 'ADM-ERROR':U then 
            return 'ADM-ERROR':U.
    
        run atualizarListaComponItem in h-boin480 (buffer lista-compon-item,
                                                   OUTPUT TABLE rowErrors).


        IF RETURN-VALUE = "NOK" THEN DO:

            {method/showmessage.i1}
            {method/showmessage.i2}
    
            WAIT-FOR CLOSE OF hShowMsg.

            UNDO, RETURN "ADM-ERROR":u.

        END.

    END.



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

  if available item then 
      assign lista-compon-item.it-codigo = item.it-codigo.


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

    if available lista-compon-item then do:
         find item 
            where item.it-codigo = lista-compon-item.it-codigo no-lock no-error.
         assign c-desc-item = if avail item then item.desc-item else "":U
                c-un-item   = if avail item then item.un        else "":U.

         find first lista-compon 
            where lista-compon.cod-lista-compon = lista-compon-item.cod-lista-compon no-lock no-error.
         assign c-desc-lista = if avail lista-compon then lista-compon.des-lista-compon else "":U
                c-un-lista   = if avail lista-compon then lista-compon.un else "":U.

         if lista-compon-item.op-codigo <> 0 then do with frame {&frame-name}:
             if lista-compon-item.cod-roteiro <> "" then
                find rot-fabric 
                    where rot-fabric.cod-roteiro = input frame {&frame-name} lista-compon-item.cod-roteiro 
                    no-lock no-error.
                if avail rot-fabric then 
                    assign c-it-codigo   = "" 
                           c-cod-roteiro = rot-fabric.cod-roteiro.
                else
                    assign c-it-codigo   = item.it-codigo 
                           c-cod-roteiro = "".

             find operacao 
                  where operacao.it-codigo   = c-it-codigo   
                    and operacao.cod-roteiro = c-cod-roteiro 
                    and operacao.op-codigo   = lista-compon-item.op-codigo NO-LOCK no-error.         

              assign c-desc-op = if avail operacao then operacao.descricao else "":U.

         end.   

         if lista-compon-item.cod-roteiro <> "" then do with frame {&frame-name}:
             find rot-fabric where 
                  rot-fabric.cod-roteiro = lista-compon-item.cod-roteiro no-lock no-error.
             assign c-desc-rot = if avail rot-fabric then rot-fabric.descricao else "":U.
             find operacao where operacao.cod-roteiro = lista-compon-item.cod-roteiro and
                                 operacao.op-codigo   = lista-compon-item.op-codigo no-lock no-error.
             assign c-desc-op:screen-value = if avail operacao then operacao.descricao else "":U.
         end.         
    end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  assign c-desc-op:screen-value = if avail operacao then operacao.descricao else "":U.
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

assign h-boin480 = p-handle.

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
  {src/adm/template/snd-list.i "lista-compon-item"}

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

