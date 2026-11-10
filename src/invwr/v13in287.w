&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME

&Scoped-define WINDOW-NAME CURRENT-WINDOW

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 

CREATE WIDGET-POOL.

&Scop adm-attribute-dlg support/viewerd.w

/* Definiá‰es de Vari†veis Globais e Handles */
def new global shared var l-inclui as logical no-undo.
def new global shared var l-erro   as logical no-undo.
def buffer b-param-estoq for param-estoq.
DEFINE NEW GLOBAL SHARED VARIABLE wh-pesquisa as widget-handle no-undo.

def var p-nome-estabel like estabelec.nome        no-undo.

{cdp/cdcfgdis.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ******************** Preprocessor Definitions ******************** */
&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no
&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target
&Scoped-define FRAME-NAME f-main
&Scoped-define EXTERNAL-TABLES param-estoq
&Scoped-define FIRST-EXTERNAL-TABLE param-estoq

/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-estoq.
DEF SHARED VAR h-window AS HANDLE NO-UNDO.

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS c-estab-tms i-ge-tms c-fm-tms c-un-tms 
&Scoped-define ENABLED-TABLES param-estoq
&Scoped-define FIRST-ENABLED-TABLE param-estoq 
&Scoped-Define DISPLAYED-FIELDS c-desc-estab-tms c-desi-ge-tms ~
c-desc-fm-tms c-desc-un-tms c-estab-tms ~
i-ge-tms c-fm-tms c-un-tms  
&Scoped-define DISPLAYED-TABLES param-estoq
&Scoped-define FIRST-DISPLAYED-TABLE param-estoq
/* Objetos que permitem ediá∆o */
&Scoped-Define ENABLED-OBJECTS RECT-6 c-estab-tms ~
i-ge-tms c-fm-tms c-un-tms 

/* Objetos apenas de exibiá∆o */
&Scoped-Define DISPLAYED-OBJECTS c-desc-estab-tms c-desi-ge-tms ~
c-desc-fm-tms c-desc-un-tms c-estab-tms ~
i-ge-tms c-fm-tms c-un-tms 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME

/* *********************** Definiá∆o dos Widgets ********************** */
DEFINE VARIABLE c-estab-tms AS CHARACTER FORMAT "x(5)"
    LABEL "Estabelecimento Padr∆o TMS"
    VIEW-AS FILL-IN
    SIZE 18.14 BY .88 NO-UNDO.

DEFINE VARIABLE i-ge-tms AS INT FORMAT ">9"
    LABEL "Grupo Estoque Padr∆o TMS Saas"
    VIEW-AS FILL-IN
    SIZE 18.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-fm-tms AS CHARACTER FORMAT "x(8)"
    LABEL "Fam°lia Padr∆o TMS Saas"
    VIEW-AS FILL-IN
    SIZE 18.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-un-tms AS CHARACTER FORMAT "x(2)"
    LABEL "Unid Medid Padr∆o TMS Saas"
    VIEW-AS FILL-IN
    SIZE 18.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estab-tms AS CHARACTER FORMAT "x(40)"
    VIEW-AS FILL-IN
    SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desi-ge-tms AS CHARACTER FORMAT "x(30)"
    VIEW-AS FILL-IN
    SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-fm-tms AS CHARACTER FORMAT "x(30)"
    VIEW-AS FILL-IN
    SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-un-tms AS CHARACTER FORMAT "x(15)"
    VIEW-AS FILL-IN
    SIZE 40 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
      SIZE 86.86 BY 13.

/* *********************** Definiá∆o do Frame *********************** */

DEFINE FRAME f-main
    c-estab-tms AT ROW 2.5 COL 18 COLON-ALIGNED LABEL "Estab" 
    c-desc-estab-tms AT ROW 2.5 COL 30.40  NO-LABEL

    i-ge-tms AT ROW 3.5 COL 18 COLON-ALIGNED LABEL "Grupo Estoque"
    c-desi-ge-tms AT ROW 3.5 COL 30.40 NO-LABEL

    c-fm-tms AT ROW 4.5 COL 18  COLON-ALIGNED LABEL "Fam°lia"
    c-desc-fm-tms AT ROW 4.5 COL 30.40  NO-LABEL

    c-un-tms AT ROW 5.5 COL 18 COLON-ALIGNED LABEL "Unid Med"
    c-desc-un-tms AT ROW 5.5 COL 30.40 NO-LABEL

    RECT-6 AT ROW 1 COL 1

    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1 SCROLLABLE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* Inclui as bibliotecas ADM ap¢s a definiá∆o do Frame e dos Widgets */
{src/adm/method/viewer.i}
{utp/ut-glob.i}
&ANALYZE-RESUME

/* *********************** Control Triggers ************************ */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estab-tms V-table-Win
ON LEAVE OF c-estab-tms IN FRAME f-main
DO:

    FIND FIRST estabelec
        WHERE estabelec.cod-estabel = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.

    IF AVAILABLE estabelec THEN DO:
        c-desc-estab-tms:SCREEN-VALUE = estabelec.nome.
        ASSIGN l-erro = NO.
    END.
    ELSE DO:
        {utp/ut-field.i mgind param-estoq cod-estabel-tms 1}
        RUN utp/ut-msgs.p ("show", 47, "Estabelecimento Padr∆o TMS " + SELF:SCREEN-VALUE ).
        ASSIGN l-erro = YES.
        APPLY "ENTRY" TO SELF.
        RUN pi-atualiza-bt-ok.
        RETURN NO-APPLY.
    END.

    RUN pi-atualiza-bt-ok.
END.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estab-tms V-table-Win
ON F5 OF c-estab-tms IN FRAME f-main
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                    &campo= "c-estab-tms"
                    &campozoom="cod-estabel"
                    &frame="f-main"
                    &campo2="c-desc-estab-tms"
                    &campozoom2="nome"
                    &frame2="f-main"}
END.
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estab-tms V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-estab-tms IN FRAME f-main /* CFOP */
DO:
      APPLY 'F5' TO SELF.
END.
/* _UIB-CODE-BLOCK-END */

&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ge-tms V-table-Win
ON LEAVE OF i-ge-tms IN FRAME f-main
DO:
    DEFINE VARIABLE i-ge-aux AS INTEGER NO-UNDO.
    
    IF TRIM(SELF:SCREEN-VALUE) = "" OR TRIM(SELF:SCREEN-VALUE) = ? THEN 
        i-ge-aux = 0.
    ELSE 
        i-ge-aux = INTEGER(SELF:SCREEN-VALUE) NO-ERROR.

    FIND FIRST grup-estoque
        WHERE grup-estoque.ge-codigo = i-ge-aux
        NO-LOCK NO-ERROR.

    IF AVAILABLE grup-estoque THEN DO:
        c-desi-ge-tms:SCREEN-VALUE = grup-estoque.descricao.
        ASSIGN l-erro = NO.
    END.
    ELSE DO:
        {utp/ut-field.i mgind param-estoq ge-tms 1}
        RUN utp/ut-msgs.p ("show", 47, "Grupo de Estoque Padr∆o TMS " + STRING(i-ge-aux) ).
        ASSIGN l-erro = YES.
        APPLY "ENTRY" TO SELF.
        RUN pi-atualiza-bt-ok.
        RETURN NO-APPLY.
    END.
    RUN pi-atualiza-bt-ok.
END.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ge-tms V-table-Win
ON F5 OF i-ge-tms IN FRAME f-main
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in142.w"
                        &campo="i-ge-tms"
                        &campozoom="ge-codigo"
                        &frame="f-main"
                        &campo2="c-desi-ge-tms"
                        &campozoom2="descricao"
                        &frame2="f-main"}                        
END.

&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ge-tms V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-ge-tms IN FRAME f-main /* CFOP */
DO:
      APPLY 'F5' TO SELF.
END.
/* _UIB-CODE-BLOCK-END */

&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-fm-tms V-table-Win
ON LEAVE OF c-fm-tms IN FRAME f-main
DO:

    FIND FIRST familia
        WHERE familia.fm-codigo = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.

    IF AVAILABLE familia THEN DO:
        c-desc-fm-tms:SCREEN-VALUE = familia.descricao.
        ASSIGN l-erro = NO.
    END.
    
    ELSE DO:
        {utp/ut-field.i mgind param-estoq fm-tms 1}
        RUN utp/ut-msgs.p ("show", 47, "Fam°lia Padr∆o TMS " + SELF:SCREEN-VALUE ).
        ASSIGN l-erro = YES.
        APPLY "ENTRY" TO SELF.
        RUN pi-atualiza-bt-ok.
        RETURN NO-APPLY.
    END.

    RUN pi-atualiza-bt-ok.
END.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-fm-tms V-table-Win
ON F5 OF c-fm-tms IN FRAME f-main
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z02in122.w"
                       &campo="c-fm-tms"
                       &campozoom="fm-codigo"
                       &frame="f-main"
                       &campo2="c-desc-fm-tms"
                       &campozoom2="descricao"
                       &frame2="f-main"}.    
END.

&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-fm-tms V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-fm-tms IN FRAME f-main /* CFOP */
DO:
      APPLY 'F5' TO SELF.
END.
/* _UIB-CODE-BLOCK-END */

&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-un-tms V-table-Win
ON LEAVE OF c-un-tms IN FRAME f-main
DO:

    FIND FIRST tab-unidade
        WHERE tab-unidade.un = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.

    IF AVAILABLE tab-unidade THEN DO:
        c-desc-un-tms:SCREEN-VALUE = tab-unidade.descricao.
        ASSIGN l-erro = NO.
    END.
    ELSE DO:
        {utp/ut-field.i mgind param-estoq un-tms 1}
        RUN utp/ut-msgs.p ("show", 47, "Unidade de Medida Padr∆o TMS " + SELF:SCREEN-VALUE ).
        ASSIGN l-erro = YES.
        APPLY "ENTRY" TO SELF.
        RUN pi-atualiza-bt-ok.
        RETURN NO-APPLY.
    END.

    RUN pi-atualiza-bt-ok.
END.
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-un-tms V-table-Win
ON F5 OF c-un-tms IN FRAME f-main
DO:
    {include/zoomvar.i &prog-zoom="inzoom\z01in417.w"
                       &campo="c-un-tms"
                       &campozoom=un
                       &frame="f-main"
                       &campo2="c-desc-un-tms"
                       &campozoom2="descricao"
                       &frame2="f-main"}.
END.

&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-un-tms V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-un-tms IN FRAME f-main /* CFOP */
DO:
      APPLY 'F5' TO SELF.
END.
&ANALYZE-RESUME

/* ********************** Internal Procedures *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win
PROCEDURE local-initialize :

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ).

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            c-estab-tms:WIDTH-CHARS       = 10
            i-ge-tms:WIDTH-CHARS          = 10
            c-fm-tms:WIDTH-CHARS          = 10
            c-un-tms:WIDTH-CHARS          = 10

            c-desc-estab-tms:WIDTH-CHARS            = 45
            c-desi-ge-tms:WIDTH-CHARS               = 45
            c-desc-fm-tms:WIDTH-CHARS               = 45
            c-desc-un-tms:WIDTH-CHARS               = 45.

        /* cursor de lupa */
        c-estab-tms:LOAD-MOUSE-POINTER("image~\lupa.cur").
        i-ge-tms:LOAD-MOUSE-POINTER("image~\lupa.cur").
        c-fm-tms:LOAD-MOUSE-POINTER("image~\lupa.cur").
        c-un-tms:LOAD-MOUSE-POINTER("image~\lupa.cur").
    END.
    RUN pi-atualiza-bt-ok.

END PROCEDURE.

&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win
PROCEDURE local-display-fields :

    RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
    FIND FIRST param-estoq NO-LOCK NO-ERROR. 

    IF AVAIL param-estoq THEN DO WITH FRAME {&FRAME-NAME}:
        FIND FIRST estabelec WHERE estabelec.cod-estabel = param-estoq.cod-estabel-tms NO-LOCK NO-ERROR.

        IF AVAIL estabelec THEN 
            ASSIGN c-desc-estab-tms = estabelec.nome
                   c-estab-tms      = param-estoq.cod-estabel-tms. 
            
        FIND FIRST grup-estoque WHERE grup-estoque.ge-codigo = param-estoq.ge-tms NO-LOCK NO-ERROR.

        IF AVAIL grup-estoque THEN 
            ASSIGN c-desi-ge-tms = grup-estoque.descricao
                   i-ge-tms      = param-estoq.ge-tms.

        FIND FIRST familia WHERE familia.fm-codigo = param-estoq.fm-tms NO-LOCK NO-ERROR.

        IF AVAIL familia THEN 
            ASSIGN c-desc-fm-tms = familia.descricao
                   c-fm-tms = param-estoq.fm-tms.

        FIND FIRST tab-unidade WHERE tab-unidade.un = param-estoq.un-tms NO-LOCK NO-ERROR.

        IF AVAIL tab-unidade THEN 
            ASSIGN c-desc-un-tms = tab-unidade.descricao
                   c-un-tms      = param-estoq.un-tms.

        DISP c-estab-tms 
             i-ge-tms 
             c-fm-tms 
             c-un-tms 
             c-desc-estab-tms 
             c-desi-ge-tms
             c-desc-fm-tms
             c-desc-un-tms
        WITH FRAME {&FRAME-NAME}.

        RUN pi-atualiza-bt-ok.
    END.
END PROCEDURE.
&ANALYZE-RESUME

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
  {src/adm/template/row-list.i "param-estoq"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-estoq"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win
PROCEDURE local-assign-record :

DEFINE VARIABLE c-estab-aux AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i-ge-aux    AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-fm-aux    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-un-aux    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-aux   AS CHARACTER NO-UNDO.

    /* Captura valores da tela */
    c-estab-aux = c-estab-tms:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
    IF c-estab-aux = ? THEN c-estab-aux = "".
    ELSE c-estab-aux = TRIM(c-estab-aux).

    c-fm-aux = c-fm-tms:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
    IF c-fm-aux = ? THEN c-fm-aux = "".
    ELSE c-fm-aux = TRIM(c-fm-aux).

    c-un-aux = c-un-tms:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
    IF c-un-aux = ? THEN c-un-aux = "".
    ELSE c-un-aux = TRIM(c-un-aux).

    c-aux = i-ge-tms:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
    IF c-aux = ? OR TRIM(c-aux) = "" THEN
        i-ge-aux = 0.
    ELSE
        i-ge-aux = INTEGER(c-aux) NO-ERROR.


    FIND FIRST estabelec 
         WHERE estabelec.cod-estabel = c-estab-aux
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE estabelec THEN DO:
        RUN utp/ut-msgs.p ("show", 47,
            "Estabelecimento inv†lido ou campo obrigat¢rio").
        APPLY "ENTRY" TO c-estab-tms IN FRAME {&FRAME-NAME}.
        RETURN 'ADM-ERROR'.
    END.

    FIND FIRST grup-estoque 
         WHERE grup-estoque.ge-codigo = i-ge-aux
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE grup-estoque THEN DO:
        RUN utp/ut-msgs.p ("show", 47,
            "Grupo de estoque inv†lido ou campo obrigat¢rio").
        APPLY "ENTRY" TO i-ge-tms IN FRAME {&FRAME-NAME}.
        RETURN 'ADM-ERROR'.
    END.

    FIND FIRST familia 
         WHERE familia.fm-codigo = c-fm-aux
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE familia THEN DO:
        RUN utp/ut-msgs.p ("show", 47,
            "Fam°lia inv†lida ou campo obrigat¢rio").
        APPLY "ENTRY" TO c-fm-tms IN FRAME {&FRAME-NAME}.
        RETURN 'ADM-ERROR'.
    END.

    FIND FIRST tab-unidade 
         WHERE tab-unidade.un = c-un-aux
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE tab-unidade THEN DO:
        RUN utp/ut-msgs.p ("show", 47,
            "Unidade de medida inv†lida ou campo obrigat¢rio").
        APPLY "ENTRY" TO c-un-tms IN FRAME {&FRAME-NAME}.
        RETURN 'ADM-ERROR'.
    END.

    FIND FIRST param-estoq EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL param-estoq THEN DO:
        ASSIGN
            param-estoq.cod-estabel-tms = INPUT FRAME {&FRAME-NAME} c-estab-tms
            param-estoq.ge-tms          = INPUT FRAME {&FRAME-NAME} i-ge-tms
            param-estoq.fm-tms          = INPUT FRAME {&FRAME-NAME} c-fm-tms
            param-estoq.un-tms          = INPUT FRAME {&FRAME-NAME} c-un-tms.
    END.

    RUN dispatch IN THIS-PROCEDURE ('assign-record').

    IF RETURN-VALUE = 'ADM-ERROR' THEN
        RETURN 'ADM-ERROR'.

END PROCEDURE.
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :

    DEFINE VARIABLE c-estab-aux AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i-ge-aux    AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-fm-aux    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-un-aux    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-aux   AS CHARACTER NO-UNDO.

    ASSIGN l-erro = NO.
    
    c-estab-aux = c-estab-tms:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
    IF c-estab-aux = ? THEN c-estab-aux = "".
    ELSE c-estab-aux = TRIM(c-estab-aux).

    c-aux = i-ge-tms:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
    IF c-aux = ? OR TRIM(c-aux) = "" THEN i-ge-aux = 0.
    ELSE i-ge-aux = INTEGER(c-aux) NO-ERROR.

    c-fm-aux = c-fm-tms:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
    IF c-fm-aux = ? THEN c-fm-aux = "".
    ELSE c-fm-aux = TRIM(c-fm-aux).

    c-un-aux = c-un-tms:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
    IF c-un-aux = ? THEN c-un-aux = "".
    ELSE c-un-aux = TRIM(c-un-aux).

    FIND FIRST estabelec 
         WHERE estabelec.cod-estabel = c-estab-aux 
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE estabelec THEN DO:
        RUN utp/ut-msgs.p ("show", 47, "Estabelecimento Padr∆o TMS " + c-estab-aux  ).
        ASSIGN l-erro = YES. 
        APPLY "ENTRY" TO c-estab-tms IN FRAME {&FRAME-NAME}.
        RETURN 'ADM-ERROR'.
    END.

    FIND FIRST grup-estoque 
         WHERE grup-estoque.ge-codigo = i-ge-aux 
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE grup-estoque THEN DO:
        RUN utp/ut-msgs.p ("show", 47, "Grupo de Estoque Padr∆o TMS" + STRING(i-ge-aux) ).
        ASSIGN l-erro = YES. 
        APPLY "ENTRY" TO i-ge-tms IN FRAME {&FRAME-NAME}.
        RETURN 'ADM-ERROR'.
    END.

    FIND FIRST familia 
         WHERE familia.fm-codigo = c-fm-aux 
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE familia THEN DO:
        RUN utp/ut-msgs.p ("show", 47, "Fam°lia Padr∆o TMS " + c-fm-aux ).
        ASSIGN l-erro = YES. 
        APPLY "ENTRY" TO c-fm-tms IN FRAME {&FRAME-NAME}.
        RETURN 'ADM-ERROR'.
    END.

    FIND FIRST tab-unidade 
         WHERE tab-unidade.un = c-un-aux 
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE tab-unidade THEN DO:
        RUN utp/ut-msgs.p ("show", 47, "Unidade de Medida Padr∆o TMS " + c-un-aux ).
        ASSIGN l-erro = YES. 
        APPLY "ENTRY" TO c-un-tms IN FRAME {&FRAME-NAME}.
        RETURN 'ADM-ERROR'.
    END.

    RUN dispatch IN THIS-PROCEDURE ('update-record').
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        ASSIGN l-erro = YES. 
        RETURN 'ADM-ERROR'.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-view V-table-Win
PROCEDURE local-view :
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'view':U ).
    RUN local-display-fields.
END PROCEDURE.
&ANALYZE-RESUME

PROCEDURE disable_UI:
    IF VALID-HANDLE(THIS-PROCEDURE) THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
END PROCEDURE.

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
  {src/adm/template/snd-list.i "param-estoq"}

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
  //run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

PROCEDURE pi-valida-campos:

    DEFINE VARIABLE l-ok AS LOGICAL NO-UNDO INITIAL TRUE.

    IF INPUT FRAME {&frame-name} c-estab-tms = "" THEN l-ok = FALSE.
    IF INPUT FRAME {&frame-name} i-ge-tms = 0 THEN l-ok = FALSE.
    IF INPUT FRAME {&frame-name} c-fm-tms = "" THEN l-ok = FALSE.
    IF INPUT FRAME {&frame-name} c-un-tms = "" THEN l-ok = FALSE.

    IF NOT l-ok THEN DO:
        RUN utp/ut-msgs.p ("show", 47, "Existem campos obrigat¢rios n∆o preenchidos").
        RETURN ERROR.
    END.

END PROCEDURE.

PROCEDURE pi-atualiza-bt-ok:

    DEFINE VARIABLE l-enabled AS LOGICAL NO-UNDO.
    DEFINE VARIABLE h-parent  AS HANDLE  NO-UNDO.



    l-enabled =
        NOT l-erro AND
        TRIM(c-estab-tms:SCREEN-VALUE IN FRAME {&FRAME-NAME}) <> "" AND
        TRIM(c-fm-tms:SCREEN-VALUE IN FRAME {&FRAME-NAME}) <> "" AND
        TRIM(c-un-tms:SCREEN-VALUE IN FRAME {&FRAME-NAME}) <> "".
        
    h-parent = THIS-PROCEDURE:PARENT NO-ERROR.

    IF VALID-HANDLE(h-parent) THEN
        RUN pi-set-ok-enabled IN h-parent (l-enabled) NO-ERROR.

END PROCEDURE.
