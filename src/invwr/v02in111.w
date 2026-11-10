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
{include/i-prgvrs.i V02IN111 2.00.00.056 } /*** "010056" ***/
      

/*------------------------------------------------------------------------

  File:

  Description: Viewer da tabela mgind.estrutura

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

def new global shared var v-row-parent      as rowid no-undo.                                
def new global shared var gr-item           as rowid no-undo.
def new global shared var gr-rot-fabric     as rowid no-undo.
def new global shared var c-hidden          as logical no-undo.
def new global shared var de-quant          as decimal no-undo.

{cdp/cdcfgman.i}
{cdp/cdcfgren.i} /*Include com PrÇ-Processador da Grendene*/

def var rw-item        as rowid                  no-undo.
def var c-it-codigo    like item.it-codigo       no-undo.
def var c-es-codigo    like estrutura.es-codigo  no-undo.
def var c-cod-roteiro  like operacao.cod-roteiro no-undo.
def var h-item         as handle                 no-undo.
def var h-es-codigo    as handle                 no-undo.
define variable c-erro as character              no-undo.
DEF VAR fi-per-drb-aux AS DEC FORMAT ">>9.99":U  NO-UNDO.

define buffer b-item       for item.

def new global shared var gr-operacao as rowid no-undo.

DEF TEMP-TABLE tt-datas NO-UNDO
    FIELD dt-trans     AS DATE
    FIELD de-soma-perc AS DEC DECIMALS 4
    INDEX id-trans dt-trans
    INDEX id-soma  de-soma-perc.

DEF TEMP-TABLE tt-estruts NO-UNDO
    FIELD sequencia AS INT
    FIELD es-codigo AS CHAR
    FIELD dt-trans  AS DATE
    FIELD perc       AS DEC DECIMALS 4
    INDEX id-a  sequencia es-codigo dt-trans
    INDEX id-dt dt-trans.

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
&Scoped-define EXTERNAL-TABLES estrutura
&Scoped-define FIRST-EXTERNAL-TABLE estrutura


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estrutura.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS estrutura.fator-perda estrutura.proporcao ~
estrutura.qtd-item estrutura.log-quant-fix estrutura.fantasma ~
estrutura.tempo-reserv estrutura.data-inicio estrutura.data-termino ~
estrutura.cod-roteiro estrutura.op-codigo 
&Scoped-define ENABLED-TABLES estrutura
&Scoped-define FIRST-ENABLED-TABLE estrutura
&Scoped-Define ENABLED-OBJECTS fi-per-drb de-qtd-compon de-quant-liquid ~
fi-per-ppm RECT-3 RECT-5 
&Scoped-Define DISPLAYED-FIELDS estrutura.fator-perda estrutura.proporcao ~
estrutura.qtd-item estrutura.log-quant-fix estrutura.fantasma ~
estrutura.tempo-reserv estrutura.data-inicio estrutura.data-termino ~
estrutura.cod-roteiro estrutura.op-codigo 
&Scoped-define DISPLAYED-TABLES estrutura
&Scoped-define FIRST-DISPLAYED-TABLE estrutura
&Scoped-Define DISPLAYED-OBJECTS fi-per-drb c-un-it de-qtd-compon c-un ~
de-quant-liquid tg-veiculo fi-per-ppm c-desc-rot c-desc-oper 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS de-qtd-compon de-quant-liquid tg-veiculo 

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
DEFINE VARIABLE c-desc-oper AS CHARACTER FORMAT "x(34)" 
     VIEW-AS FILL-IN 
     SIZE 35.14 BY .88.

DEFINE VARIABLE c-desc-rot AS CHARACTER FORMAT "X(30)" 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE c-un AS CHARACTER FORMAT "xx" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-un-it AS CHARACTER FORMAT "X(2)":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE de-qtd-compon AS DECIMAL FORMAT "->>,>>9.9999999999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE de-quant-liquid AS DECIMAL FORMAT "->>,>>9.9999999999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE fi-per-drb AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "% DRB" 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-per-ppm AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL ? 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.72 BY 5.29.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.72 BY 2.42.

DEFINE VARIABLE tg-veiculo AS LOGICAL INITIAL no 
     LABEL "Ve°culo / Excipiente" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .75 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     estrutura.fator-perda AT ROW 1.17 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     estrutura.proporcao AT ROW 2.17 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     fi-per-drb AT ROW 2.17 COL 38 COLON-ALIGNED
     estrutura.qtd-item AT ROW 3.17 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21 BY .88
     c-un-it AT ROW 3.17 COL 42.29 COLON-ALIGNED NO-LABEL
     de-qtd-compon AT ROW 4.17 COL 21 COLON-ALIGNED HELP
          "Quantidade do Componente"
     c-un AT ROW 4.17 COL 42.29 COLON-ALIGNED HELP
          "Unidade de medida do item" NO-LABEL
     de-quant-liquid AT ROW 5.17 COL 21 COLON-ALIGNED HELP
          "Quantidade L°quida"
     estrutura.log-quant-fix AT ROW 1.25 COL 47
          LABEL "Quantidade Fixa"
          VIEW-AS TOGGLE-BOX
          SIZE 18.14 BY .75
     estrutura.fantasma AT ROW 1.25 COL 67
          VIEW-AS TOGGLE-BOX
          SIZE 12.86 BY .75
     estrutura.tempo-reserv AT ROW 2.17 COL 65 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     estrutura.data-inicio AT ROW 3.17 COL 65 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     estrutura.data-termino AT ROW 4.17 COL 65 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     tg-veiculo AT ROW 5.17 COL 47
     fi-per-ppm AT ROW 5.17 COL 65 COLON-ALIGNED
     estrutura.cod-roteiro AT ROW 6.71 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-desc-rot AT ROW 6.71 COL 39 COLON-ALIGNED HELP
          "Descriá∆o do roteiro" NO-LABEL
     estrutura.op-codigo AT ROW 7.71 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-desc-oper AT ROW 7.71 COL 28.86 COLON-ALIGNED NO-LABEL
     RECT-3 AT ROW 1 COL 1
     RECT-5 AT ROW 6.46 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.estrutura
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
         HEIGHT             = 8.21
         WIDTH              = 85.72.
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

/* SETTINGS FOR FILL-IN c-desc-oper IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-rot IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un-it IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-qtd-compon IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN de-quant-liquid IN FRAME f-main
   2                                                                    */
ASSIGN 
       fi-per-drb:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX estrutura.log-quant-fix IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-veiculo IN FRAME f-main
   NO-ENABLE 2                                                          */
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

&Scoped-define SELF-NAME estrutura.cod-roteiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estrutura.cod-roteiro V-table-Win
ON F5 OF estrutura.cod-roteiro IN FRAME f-main /* Roteiro */
DO: 
  def var rw-parent as rowid no-undo.
  find item where rowid(item) = v-row-parent no-lock no-error. 
  assign c-it-codigo = item.it-codigo.
  assign l-implanta = yes.   
  {include/zoomvar.i &prog-zoom="inzoom/z01in400.w"
                     &campo=estrutura.cod-roteiro
                     &campozoom=cod-roteiro
                     &campo2=c-desc-rot
                     &campozoom2=descricao
                     &parametros="run pi-seta-inicial in wh-pesquisa 
                     (input c-it-codigo)."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estrutura.cod-roteiro V-table-Win
ON LEAVE OF estrutura.cod-roteiro IN FRAME f-main /* Roteiro */
DO:
  {include/leave.i &tabela=rot-fabric
                  &atributo-ref=descricao
                  &variavel-ref=c-desc-rot
                  &where="rot-fabric.cod-roteiro = input frame {&frame-name} estrutura.cod-roteiro"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estrutura.cod-roteiro V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estrutura.cod-roteiro IN FRAME f-main /* Roteiro */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-qtd-compon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-qtd-compon V-table-Win
ON LEAVE OF de-qtd-compon IN FRAME f-main
DO:
   IF estrutura.log-quant-fix:CHECKED IN FRAME {&frame-name} = NO THEN
           ASSIGN de-quant-liquid:SCREEN-VALUE = STRING((INPUT FRAME {&frame-name} de-qtd-compon) - 
                                                       ((INPUT FRAME {&frame-name} de-qtd-compon) * 
                                                       ((INPUT FRAME {&frame-name} estrutura.fator-perda) / 100))).     
   ELSE
           ASSIGN de-quant-liquid:SCREEN-VALUE = INPUT FRAME {&frame-name} de-qtd-compon.

  /* Rotina utilizada especificamente para o programa de cadastro de itens 
     Passa a Quantidade Utilizada Estrutura */

  assign de-quant = input frame {&frame-name} de-qtd-compon.

  IF RETURN-VALUE = "" OR
     RETURN-VALUE = "ok" THEN
     run notify ('pi-seta-qt-utilizada,state-target').

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-quant-liquid
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-quant-liquid V-table-Win
ON LEAVE OF de-quant-liquid IN FRAME f-main
DO:
  ASSIGN de-qtd-compon:SCREEN-VALUE = STRING((INPUT FRAME {&frame-name} de-quant-liquid) / 
                                             (1 - ((INPUT FRAME {&frame-name} estrutura.fator-perda) / 100))). 


  /* Rotina utilizada especificamente para o programa de cadastro de itens 
     Passa a Quantidade Utilizada Estrutura */

  assign de-quant = input frame {&frame-name} de-qtd-compon.

  IF RETURN-VALUE = "" OR
     RETURN-VALUE = "ok" THEN
     run notify ('pi-seta-qt-utilizada,state-target').



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estrutura.fator-perda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estrutura.fator-perda V-table-Win
ON LEAVE OF estrutura.fator-perda IN FRAME f-main /* Fator Perda */
DO:
  ASSIGN de-quant-liquid:SCREEN-VALUE = STRING((INPUT FRAME {&frame-name} de-qtd-compon) - 
                                              ((INPUT FRAME {&frame-name} de-qtd-compon) * 
                                              ((INPUT FRAME {&frame-name} estrutura.fator-perda) / 100))).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estrutura.log-quant-fix
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estrutura.log-quant-fix V-table-Win
ON VALUE-CHANGED OF estrutura.log-quant-fix IN FRAME f-main /* Quantidade Fixa */
DO:
    if  estrutura.log-quant-fix:checked in frame {&frame-name} = YES THEN DO:
        assign estrutura.proporcao:SCREEN-VALUE in frame {&frame-name} = "100"
               estrutura.proporcao:SENSITIVE = FALSE
               estrutura.fator-perda:SCREEN-VALUE in frame {&frame-name} = "0"
               estrutura.fator-perda:SENSITIVE = FALSE
               estrutura.qtd-item:SCREEN-VALUE in frame {&frame-name} = "1"
               estrutura.qtd-item:SENSITIVE = FALSE
               de-quant-liquid:SCREEN-VALUE in frame {&frame-name} = STRING(INPUT FRAME {&frame-name} de-qtd-compon)
               de-quant-liquid:SENSITIVE = FALSE.
    END.
    ELSE DO:
        assign  estrutura.proporcao:SENSITIVE = TRUE
                estrutura.fator-perda:SENSITIVE = TRUE
                estrutura.qtd-item:SENSITIVE = TRUE
                de-quant-liquid:SENSITIVE = TRUE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estrutura.op-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estrutura.op-codigo V-table-Win
ON F5 OF estrutura.op-codigo IN FRAME f-main /* Operaá∆o */
DO:
  def var rw-parent as rowid no-undo.

  find item where rowid(item) = v-row-parent no-lock no-error. 

  assign c-it-codigo = item.it-codigo.

  find rot-fabric 
       where rot-fabric.cod-roteiro = input frame {&frame-name} estrutura.cod-roteiro 
       no-lock no-error.
  if avail rot-fabric then 
     assign gr-rot-fabric = rowid(rot-fabric)
            gr-item       = ?
            rw-parent     = gr-rot-fabric.
  else do:          
        assign rw-parent  = v-row-parent.
  end.   

  find item where rowid(item) = rw-parent no-lock no-error. 

  ASSIGN GR-OPERACAO = ?.

  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z04in263.w"
                     &campo=estrutura.op-codigo
                     &campozoom=op-codigo
                     &campo2=c-desc-oper
                     &campozoom2=descricao
                     &parametros="run pi-seta-inicial in wh-pesquisa 
                     (input rw-parent)."}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estrutura.op-codigo V-table-Win
ON LEAVE OF estrutura.op-codigo IN FRAME f-main /* Operaá∆o */
DO:

 find item where rowid(item) = v-row-parent no-lock no-error. 
 assign c-it-codigo = item.it-codigo. 

 if input frame {&frame-name} estrutura.cod-roteiro <> "" then
    find rot-fabric 
        where rot-fabric.cod-roteiro = input frame {&frame-name} estrutura.cod-roteiro 
        no-lock no-error.
 if avail rot-fabric then 
    assign c-it-codigo   = "" 
           c-cod-roteiro = rot-fabric.cod-roteiro.
 else
     assign c-it-codigo   = item.it-codigo 
            c-cod-roteiro = "".

 find operacao where
      operacao.it-codigo = c-it-codigo and
      operacao.cod-roteiro = c-cod-roteiro and
      operacao.op-codigo   = input frame {&frame-name} estrutura.op-codigo no-lock no-error.

 if  avail operacao then 
     assign c-desc-oper:screen-value in frame {&frame-name} = operacao.descricao.
 else    
     assign c-desc-oper:screen-value in frame {&frame-name} = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estrutura.op-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estrutura.op-codigo IN FRAME f-main /* Operaá∆o */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-veiculo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-veiculo V-table-Win
ON VALUE-CHANGED OF tg-veiculo IN FRAME f-main /* Ve°culo / Excipiente */
DO:
    IF tg-veiculo:CHECKED IN FRAME f-main THEN DO:
        ASSIGN fi-per-ppm:SENSITIVE    IN FRAME f-main = YES
               fi-per-ppm:SCREEN-VALUE IN FRAME f-main = IF NOT AVAIL estrutura OR (estrutura.val-perc-distrib-veic = 0)
                                                         THEN "100"
                                                         ELSE STRING(estrutura.val-perc-distrib-veic).
    END.
    ELSE
        ASSIGN fi-per-ppm:SENSITIVE    IN FRAME f-main = NO
               fi-per-ppm:SCREEN-VALUE IN FRAME f-main = "0":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

 find item where rowid(item) = v-row-parent no-lock no-error. 
 do with frame {&frame-name}:
   if estrutura.op-codigo:load-mouse-pointer   ("image/lupa.cur") then.
   if estrutura.cod-roteiro:load-mouse-pointer ("image/lupa.cur") then.
 end.

 {utp/ut-liter.i Quantidade_Componente * R}
 assign de-qtd-compon:label in frame {&frame-name} = trim(return-value).

 {utp/ut-field.i mgind estrutura quant-liquid 01}
 assign de-quant-liquid:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "estrutura"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "estrutura"}

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

    /* C¢digo Espec°fico GRENDENE - Favor n∆o alterar */
    /* No caso de n∆o ser a GRENDENE o programa funcionar† normalmente */
    &if defined (CUSTOM_GRENDENE) &then

        /* Dispatch standard ADM method.                             */
        RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

        display c-un-it with frame {&frame-name}.

    &else

        /* Dispatch standard ADM method.                             */
        RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

        display today @ estrutura.data-inicio 
            c-un-it                       
            with frame {&frame-name}.

    &endif

  /* Code placed here will execute AFTER standard behavior.    */
    if param-global.modulo-per-ppm then do:
        run pi-retorna-handle (input "it-codigo":U,output h-item).
        assign /*estrutura.fantasma:column in frame {&frame-name} = 67.00*/
               tg-veiculo:visible        in frame {&frame-name} = false
               tg-veiculo:checked        in frame {&frame-name} = false.
    end.

  assign de-qtd-compon:screen-value in frame {&frame-name} = "0".

  IF  adm-new-record THEN
      ASSIGN estrutura.tempo-reserv:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "?".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-apply-entry V-table-Win 
PROCEDURE local-apply-entry :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'apply-entry':U ) .

  assign de-quant = input frame {&frame-name} de-qtd-compon.
  /* Code placed here will execute AFTER standard behavior.    */

  IF NOT ADM-NEW-RECORD THEN  
   APPLY 'entry' TO estrutura.fator-perda IN FRAME f-main.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-componentes AS CHARACTER  NO-UNDO.
DEFINE BUFFER b-estrutura FOR estrutura.        
DEFINE BUFFER bf-tt-estruts FOR tt-estruts.

  /* Code placed here will execute PRIOR to standard behavior. */
  /*{include/i-valid.i}*/
  if not frame {&frame-name}:validate() then 
     return 'ADM-ERROR':U.

  if avail estrutura then do:
      find b-item where b-item.it-codigo = c-es-codigo no-lock no-error.
      if  avail b-item then do:
          if  b-item.un <> c-un:screen-value in frame {&frame-name} then do:
              run utp/ut-msgs.p (input "show":U, input 848, input "").
              apply 'entry' to c-un.
              return 'ADM-ERROR':U.
          end.              
      end.
  end.            

  if input frame {&frame-name} de-qtd-compon = 0 then do:
     run utp/ut-msgs.p (input "show",
                        input 1368,
                        input "").
     apply 'entry' to de-qtd-compon.
     return 'ADM-ERROR':U.
  end.
  if estrutura.cod-roteiro:screen-value in frame {&frame-name} <> "" and
     estrutura.op-codigo:screen-value in frame {&frame-name} = "0" then do:
         {utp/ut-field.i mgind estrutura op-codigo 01}
         run utp/ut-msgs.p (input "show",
                            input 822,
                            input return-value).
         apply 'entry' to estrutura.op-codigo in frame {&frame-name}.
         return 'ADM-ERROR':U.
  end.

  /* Observaá∆o: A grendene n∆o efetua esta validaá∆o de data de implantaá∆o. */
  &if defined (CUSTOM_GRENDENE) &then

  &ELSE
  /* Validacao data-inicio deve ser maior ou igual a data de implantacao do item */
  IF date(estrutura.data-inicio:SCREEN-VALUE IN FRAME {&FRAME-NAME}) < b-item.data-implant  THEN DO:

      RUN utp/ut-msgs.p (INPUT "show",
                         INPUT 32537,
                         INPUT "").
      APPLY 'entry' TO estrutura.data-inicio.
      RETURN 'adm-error':U.

  END.
  &ENDIF

      /*** A relaá∆o da estrutura n∆o pode ser fantasma se o componente tiver
           uma lista de componentes associada ***/

      if  estrutura.fantasma:checked in frame {&frame-name} = yes
      and can-find (first lista-compon-item
                    where lista-compon-item.it-codigo = c-es-codigo) then do:
          run utp/ut-msgs.p (input "show",
                             input 17755,
                             input return-value).
          apply 'entry' to estrutura.fantasma in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
          
          if estrutura.log-quant-fix:checked in frame {&frame-name} = no then do:
                  if input frame {&frame-name} estrutura.qtd-item <= 0 then do:
                          {utp/ut-field.i mgind estrutura qtd-item 01}
                          run utp/ut-msgs.p (input "show",
                                                                 input 2333,
                                                                 input return-value).
                          apply 'entry' to estrutura.qtd-item in frame {&frame-name}.
                          return 'ADM-ERROR':U.
                  end.
          end.

  /* Dispatch standard ADM method.                             */

      if param-global.modulo-per-ppm then do:

          run pi-retorna-handle (input "it-codigo":U,output h-item).
          run pi-retorna-handle (input "es-codigo":U,output h-es-codigo).

          if input frame {&frame-name} de-qtd-compon < 0 then do:
              find b-item where 
                   b-item.it-codigo = h-es-codigo:screen-value no-lock no-error.
              if avail b-item and
                 b-item.tipo-formula >= 2 and
                 b-item.tipo-formula <= 4 then do:
                  run utp/ut-msgs.p (input "show",
                                     input 27296,
                                     input b-item.it-codigo + "~~" + 
                                           {ininc/i25in172.i 04 b-item.tipo-formula}).
                  apply 'entry' to de-qtd-compon in frame {&frame-name}.
                  return 'ADM-ERROR':U.
              end.
          end.

          IF b-item.tipo-formula = 4 THEN DO:
              /*Percentual deve ser diferente de zero.*/
              if tg-veiculo:CHECKED IN FRAME f-main AND
                 INPUT FRAME f-main fi-per-ppm <= 0 OR INPUT FRAME f-main fi-per-ppm = ? then do:
                  {utp/ut-liter.i %_Distrib._Ve°culo *}
                  run utp/ut-msgs.p (input "show",
                                     input 2333,
                                     input RETURN-VALUE). 
                  apply "entry" to fi-per-ppm in frame {&frame-name}.
                  return "adm-error":U.
              end.

          END.

          if tg-veiculo:checked in frame {&frame-name} and
             can-find (first alternativo where
                             alternativo.it-codigo = h-item:screen-value and
                             alternativo.es-codigo = h-es-codigo:screen-value) then do:

              for first alternativo no-lock where
                        alternativo.it-codigo = h-item:screen-value and
                        alternativo.es-codigo = h-es-codigo:screen-value,
                  first b-item no-lock where
                        b-item.it-codigo    = alternativo.al-codigo and
                        b-item.tipo-formula <> 4:
                  run utp/ut-msgs.p (input "show",
                                     input 27304,
                                     input h-es-codigo:screen-value + "~~" + 
                                           h-item:screen-value).
                  return 'ADM-ERROR':U.
              end.
          end.

          assign tg-veiculo = tg-veiculo:checked in frame {&frame-name}
                 fi-per-ppm = dec(fi-per-ppm:SCREEN-VALUE IN FRAME f-main).
      end.

  IF i-pais-impto-usuario <> 1 THEN 
      ASSIGN fi-per-drb-aux = INPUT FRAME {&FRAME-NAME} fi-per-drb.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

      assign estrutura.qtd-compon   = input frame {&frame-name} de-qtd-compon
             /* D_MAN002 - Quantidade fixa para componentes de engenharia */
             estrutura.quant-usada  = if estrutura.log-quant-fix then estrutura.qtd-compon
                                      else estrutura.qtd-compon / input frame {&frame-name} estrutura.qtd-item.
                        if estrutura.quant-usada = ? then assign estrutura.quant-usada = 0.

  IF i-pais-impto-usuario <> 1 THEN    
      ASSIGN estrutura.dec-2 = fi-per-drb-aux.

      if param-global.modulo-per-ppm THEN DO:

          FOR EACH tt-datas:  DELETE tt-datas. END.
          FOR EACH tt-estruts: DELETE tt-estruts. END.

          assign estrutura.veiculo = tg-veiculo:checked in frame {&frame-name}.
          IF estrutura.veiculo THEN DO:
              /*Tratamento de Gravaá∆o do Percentual de Distribuiá∆o do Ve°culo*/
              ASSIGN estrutura.val-perc-distrib-veic = fi-per-ppm.                  
                     
              IF can-find (first b-estrutura NO-LOCK
                           WHERE b-estrutura.it-codigo =  estrutura.it-codigo 
                             and b-estrutura.veiculo   =  true                
                             and rowid(b-estrutura)    <> rowid(estrutura)) then DO:
                  /*caso exista mais de um componente na estrutura usando este ve°culo,
                    emite warning avisando que o usu†rio dever† ajustar os percentuais em quest∆o.*/
                  FOR EACH b-estrutura NO-LOCK
                     WHERE b-estrutura.it-codigo    = estrutura.it-codigo 
                       and b-estrutura.veiculo      = TRUE
                       AND b-estrutura.data-termino > TODAY:
                      CREATE tt-datas.
                      ASSIGN tt-datas.dt-trans = b-estrutura.data-inicio.
                      CREATE tt-datas.
                      ASSIGN tt-datas.dt-trans = b-estrutura.data-termino - 1.
                  END.

                  FOR EACH tt-datas:
                      FOR EACH b-estrutura NO-LOCK
                         WHERE b-estrutura.it-codigo    =  estrutura.it-codigo 
                           and b-estrutura.veiculo      =  TRUE
                           AND b-estrutura.data-inicio  <= tt-datas.dt-trans
                           AND b-estrutura.data-termino >  tt-datas.dt-trans:

                          FIND FIRST tt-estruts 
                               WHERE tt-estruts.sequencia = b-estrutura.sequencia
                                 AND tt-estruts.es-codigo = b-estrutura.es-codigo
                                 AND tt-estruts.dt-trans  = tt-datas.dt-trans NO-ERROR.
                          IF NOT AVAIL tt-estruts THEN DO:
                              CREATE tt-estruts.
                              ASSIGN tt-estruts.perc      = b-estrutura.val-perc-distrib-veic               
                                     tt-estruts.dt-trans  = tt-datas.dt-trans       
                                     tt-estruts.sequencia = b-estrutura.sequencia 
                                     tt-estruts.es-codigo = b-estrutura.es-codigo.
                          END.
                          ASSIGN tt-datas.de-soma-perc = tt-datas.de-soma-perc + tt-estruts.perc.
                      END.
                  END.

                  FOR EACH tt-datas WHERE tt-datas.de-soma-perc = 100:
                      FOR EACH tt-estruts 
                         WHERE tt-estruts.dt-trans = tt-datas.dt-trans:
                          DELETE tt-estruts.
                      END.
                  END.

                  IF CAN-FIND(FIRST tt-datas
                              WHERE tt-datas.dt-trans >= estrutura.data-inicio
                                AND tt-datas.dt-trans <= estrutura.data-termino) THEN DO:

                      FOR EACH tt-estruts:
                          FOR EACH  bf-tt-estruts
                              WHERE bf-tt-estruts.sequencia =  tt-estruts.sequencia
                                AND bf-tt-estruts.es-codigo =  tt-estruts.es-codigo
                                AND ROWID(bf-tt-estruts)    <> ROWID(tt-estruts):
                              DELETE bf-tt-estruts.
                          END.
                      END.
    
                      FOR EACH tt-estruts:
                          ASSIGN c-componentes = c-componentes +                                                                                     
                                 STRING(tt-estruts.sequencia) + " / ":U + STRING(tt-estruts.es-codigo) + ": ":U + STRING(tt-estruts.perc) + "%" + CHR(13). 
                      END.
    
                      IF c-componentes <> "":U THEN DO:
                          {utp/ut-liter.i Estrutura *}
                          run utp/ut-msgs.p (input "show":U, input 33942, input c-componentes + "~~":U + RETURN-VALUE).
                      END.

                  END.


              END. /*IF can-find (first b-estrutura*/
          END.
          ELSE
              ASSIGN estrutura.val-perc-distrib-veic = 0.                      
      END.

  &if defined (CUSTOM_GRENDENE) &then

      run enp/gen0105b.p (input 1, input estrutura.es-codigo, input (input frame {&frame-name} de-qtd-compon), input-output c-erro).

      return "ok":U.
  &endif

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
  
  IF i-pais-impto-usuario <> 1 THEN
      ASSIGN fi-per-drb:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
   /* Dispatch standard ADM method.                             */
 RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .  

  /* Code placed here will execute AFTER standard behavior.    */
 if available estrutura then do:   
    if estrutura.op-codigo <> 0 then do with frame {&frame-name}:
       find operacao where operacao.it-codigo = estrutura.it-codigo and
                           operacao.op-codigo = estrutura.op-codigo no-lock no-error.
       if avail operacao then 
          assign c-desc-oper:screen-value in frame {&frame-name} = operacao.descricao.
       else assign c-desc-oper:screen-value in frame {&frame-name} = "":U.   
     end.   

     if input estrutura.cod-roteiro <> "" then do with frame {&frame-name}:
        find rot-fabric where 
             rot-fabric.cod-roteiro = estrutura.cod-roteiro no-lock no-error.
        assign c-desc-rot:screen-value  = if avail rot-fabric then rot-fabric.descricao else "":U.
        find operacao where operacao.cod-roteiro = estrutura.cod-roteiro and
                            operacao.op-codigo   = estrutura.op-codigo no-lock no-error.
        assign c-desc-oper:screen-value = if avail operacao then operacao.descricao else "":U.
     end.  

     if not adm-new-record then do:
        
            /* D_MAN002 - Quantidade fixa para componentes de engenharia */
            if estrutura.qtd-compon = 0 or estrutura.qtd-item = 1 then
                 assign de-qtd-compon = if estrutura.log-quant-fix then estrutura.qtd-compon
                                        else estrutura.qtd-compon * estrutura.qtd-item
                        de-qtd-compon:screen-value in frame {&frame-name} = string(estrutura.qtd-compon * estrutura.qtd-item).
            else 
                 assign de-qtd-compon = if estrutura.log-quant-fix then estrutura.qtd-compon
                                        else estrutura.qtd-compon
                        de-qtd-compon:screen-value in frame {&frame-name} = string(estrutura.qtd-compon).

        ASSIGN de-quant-liquid:SCREEN-VALUE = STRING(de-qtd-compon - (de-qtd-compon * (estrutura.fator-perda / 100))).

     end.

     IF i-pais-impto-usuario <> 1 THEN DO:
         ASSIGN fi-per-drb:HIDDEN       IN FRAME {&FRAME-NAME} = NO
                fi-per-drb:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(estrutura.dec-2).

     END.

  end.

 display c-un-it with frame {&frame-name}.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  def buffer b-estrutura for estrutura.

  /* Code placed here will execute PRIOR to standard behavior. */
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  IF i-pais-impto-usuario <> 1 THEN
      ASSIGN fi-per-drb:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

  if not adm-new-record then  do:
     find item where item.it-codigo = estrutura.es-codigo no-lock no-error.
     if  avail item then do:
         assign c-un:screen-value in frame {&frame-name} = item.un.

            if param-global.modulo-per-ppm then do:
                case item.tipo-formula:
                    when 2 THEN /*Concentraá∆o*/
                        run pi-formata-campo (fi-per-ppm:handle, true, false, item.per-ppm, {ininc/i25in172.i 04 02} + "(%)":U, ">>9.9999":u).
                    when 3 THEN /*PPM*/
                        run pi-formata-campo (fi-per-ppm:handle, true, false, item.per-ppm, {ininc/i25in172.i 04 03}, ">>>>,>>9.9999":u).
                    WHEN 4 THEN DO: /*Ve°culo*/
                        run pi-formata-campo (fi-per-ppm:handle, true, TRUE, estrutura.val-perc-distrib-veic, "%":U, ">>9.9999":U).

                        assign /*estrutura.fantasma:column in frame {&frame-name} = 57.00*/
                               tg-veiculo:visible        in frame {&frame-name} = true
                               tg-veiculo:sensitive      in frame {&frame-name} = true
                               tg-veiculo:checked        in frame {&frame-name} = estrutura.veiculo.

                        APPLY "value-changed":U TO tg-veiculo IN FRAME f-main.
                    END.
                    OTHERWISE DO:  /*Nao Utiliza*/
                        run pi-formata-campo (fi-per-ppm:handle, false, false, 0, "", "").
                        assign /*estrutura.fantasma:column in frame {&frame-name} = 67.00*/
                               tg-veiculo:visible        in frame {&frame-name} = false.
                    END.
                end case.
            end.
     end.
  end.

      assign estrutura.qtd-item:sensitive in frame {&frame-name} = yes.
    
  if  estrutura.log-quant-fix:checked in frame {&frame-name} = yes then do:
        assign  estrutura.proporcao:sensitive = false
                estrutura.fator-perda:sensitive = false
                estrutura.qtd-item:sensitive = false
                de-quant-liquid:sensitive = false.
  END.

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

  find first item
       where rowid(item) = v-row-parent no-lock no-error.
  assign c-un-it = item.un.

  find first param-global no-lock.
  assign estrutura.fantasma:column in frame {&frame-name} = 67.00
         tg-veiculo:visible        in frame {&frame-name} = false
         fi-per-ppm:visible        in frame {&frame-name} = false.

  IF i-pais-impto-usuario <> 1 THEN
      ASSIGN fi-per-drb:HIDDEN IN FRAME {&FRAME-NAME} = NO.

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
        assign pHandle:visible      = pVisible
               pHandle:sensitive    = pSensitive
               pHandle:format       = pFormat
               pHandle:screen-value = string(pScreenValue)
               pHandle:label        = RETURN-VALUE no-error.
    END.
    else
        assign pHandle:visible = pVisible no-error.

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

def input  param p-campo  as char   no-undo.
def output param p-handle as handle no-undo.

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
        if h-handle:file-name = "invwr/v07in111.w":u then do:

            run get-attribute in h-handle ("adm-object-handle":U).
            assign h-frame = widget-handle(return-value)
                   h-frame = h-frame:first-child
                   h-frame = h-frame:first-child.

            do while h-frame <> ? :

                if lookup(h-frame:type, "fill-in":U) <> 0 and
                   lookup(h-frame:type, "fill-in":U) <> ? and
                   lookup(h-frame:name, p-campo)     <> 0 and 
                   lookup(h-frame:name, p-campo)     <> ? then do:
                    assign p-handle = h-frame.
                    return 'ok':u.
                end.

                assign h-frame = h-frame:next-sibling.

            end.
        end.
    end.    

return 'nok':u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-estrutura V-table-Win 
PROCEDURE pi-seta-estrutura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input parameter p-es-codigo as char no-undo.
  def input parameter c-un-item     as char no-undo.

  ASSIGN c-un-it:screen-value in frame {&frame-name} = c-un-item.

  find b-item where b-item.it-codigo = p-es-codigo no-lock no-error.
  if  available b-item then do:
      assign c-es-codigo = p-es-codigo
             c-un:screen-value in frame {&frame-name} = b-item.un.

        if param-global.modulo-per-ppm then do:

            case b-item.tipo-formula:
                when 2 THEN /*Concentraá∆o*/
                    run pi-formata-campo (fi-per-ppm:handle, true, false, b-item.per-ppm, {ininc/i25in172.i 04 02} + "(%)":U, ">>9.9999":u).
                when 3 THEN /*PPM*/
                    run pi-formata-campo (fi-per-ppm:handle, true, false, b-item.per-ppm, {ininc/i25in172.i 04 03}, ">>>>,>>9.9999":u).
                WHEN 4 THEN DO: /*Ve°culo*/
                    run pi-formata-campo (fi-per-ppm:handle, true, TRUE, 100, "%":U, ">>9.9999":U).

                /*Projeto Controle de Potància - Permite incluir o item como ve°culo em mais de uma estrutura.*/
                run pi-retorna-handle (input "it-codigo":U,output h-item).
/*                     if can-find (first b-estrutura where                                 */
/*                                        b-estrutura.it-codigo =  h-item:screen-value and  */
/*                                        b-estrutura.veiculo   =  true                and  */
/*                                        rowid(b-estrutura)    <> rowid(estrutura)) then   */
/*                         assign estrutura.fantasma:column in frame {&frame-name} = 57.00  */
/*                                tg-veiculo:visible        in frame {&frame-name} = true   */
/*                                tg-veiculo:sensitive      in frame {&frame-name} = false  */
/*                                tg-veiculo:checked        in frame {&frame-name} = false. */
/*                     else                                                                 */
                    assign /*estrutura.fantasma:column in frame {&frame-name} = 57.00*/
                           tg-veiculo:visible        in frame {&frame-name} = true
                           tg-veiculo:sensitive      in frame {&frame-name} = true
                           tg-veiculo:checked        in frame {&frame-name} = YES.

                    APPLY "value-changed":U TO tg-veiculo IN FRAME f-main.
                END.
                OTHERWISE DO:  /*Nao Utiliza*/
                    run pi-formata-campo (fi-per-ppm:handle, false, false, 0, "", "").
                    assign /*estrutura.fantasma:column in frame {&frame-name} = 67.00*/
                           tg-veiculo:visible        in frame {&frame-name} = false.
                END.
            end case.
        end.
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
  {src/adm/template/snd-list.i "estrutura"}

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

