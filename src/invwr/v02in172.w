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
{include/i-prgvrs.i V02IN172 2.00.00.030 } /*** "010030" ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i V02IN172 MUT}
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

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.
def var i-politica as integer no-undo.
def VAR i-tipo-requis AS INTEGER NO-UNDO.
def var c-tipo-con-est as char no-undo.
{mpp/mpapi007.i}
{mpp/mpapi007.i1}
{cdp/cdcfgman.i}

/* Local Definitions for EAI                                   */
{cdp/cd9043.i} /* Definicao da tabela de erros RowErros */
DEF VAR c-action AS CHARACTER FORMAT "X(8)" NO-UNDO.
DEFINE TEMP-TABLE tt-item-eai LIKE ITEM.
DEF VAR hShowMsg AS HANDLE NO-UNDO.
&IF DEFINED (bf_man_204) &THEN 
  DEF NEW GLOBAL SHARED VAR v_log_eai_habilit AS LOGICAL NO-UNDO. 
&ENDIF

DEFINE VARIABLE l-mudancas-sfc AS LOGICAL INIT NO NO-UNDO.

&IF '{&mgscm_version}' >= '2.06B' &THEN
DEFINE VARIABLE hDBOproxy AS HANDLE NO-UNDO.

DEF TEMP-TABLE ttItemReplica    NO-UNDO
    FIELD it-codigo             LIKE wm-item.cod-item
    FIELD desc-item             LIKE wm-item.des-item
    FIELD unid-med              LIKE wm-item.cod-unid-med
    FIELD peso-bruto            LIKE wm-item.qtd-peso
    FIELD largura               LIKE wm-item.qtd-largura
    FIELD comprimento           LIKE wm-item.qtd-comprimento
    FIELD altura                LIKE wm-item.qtd-altura
    FIELD tipo-con-est          LIKE wm-item.ind-tipo-contr-est
    FIELD fm-cod-com            LIKE wm-item.cod-familia
    FIELD fm-codigo             LIKE wm-item.cod-familia
    INDEX ch-codigo AS PRIMARY UNIQUE it-codigo.
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
&Scoped-Define ENABLED-OBJECTS c-liter-multi c-liter-sfc rt-mold RECT-1 ~
RECT-2 
&Scoped-Define DISPLAYED-FIELDS item.cod-lista-destino 
&Scoped-define DISPLAYED-TABLES item
&Scoped-define FIRST-DISPLAYED-TABLE item
&Scoped-Define DISPLAYED-OBJECTS cb-cod-obsoleto cb-tipo-contr ~
cb-tipo-con-est cb-tipo-requis c-lista-destino tg-consid-aloc-ativid ~
tg-log-programac-sfc fi-val-overlap c-liter-multi c-liter-sfc 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS cb-cod-obsoleto cb-tipo-contr ~
cb-tipo-con-est cb-tipo-requis item.cod-lista-destino 
&Scoped-define ADM-MODIFY-FIELDS cb-cod-obsoleto cb-tipo-contr ~
cb-tipo-con-est cb-tipo-requis item.cod-lista-destino 

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
DEFINE VARIABLE cb-cod-obsoleto AS CHARACTER FORMAT "X(40)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-con-est AS CHARACTER FORMAT "X(30)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-contr AS CHARACTER FORMAT "X(25)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-requis AS CHARACTER FORMAT "X(30)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE c-lista-destino AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 39 BY .88.

DEFINE VARIABLE c-liter-multi AS CHARACTER FORMAT "X(11)":U INITIAL "Multiplanta" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE c-liter-sfc AS CHARACTER FORMAT "X(50)":U INITIAL "Ch∆o de F†brica" 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE fi-val-overlap AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "% Overlap" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 1.25.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 1.96.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 4.25.

DEFINE VARIABLE tg-consid-aloc-ativid AS LOGICAL INITIAL yes 
     LABEL "Considera Alocaá∆o de Atividades" 
     VIEW-AS TOGGLE-BOX
     SIZE 33.43 BY .83 TOOLTIP "Considera Item no processo de Alocaá∆o de Atividades" NO-UNDO.

DEFINE VARIABLE tg-log-programac-sfc AS LOGICAL INITIAL yes 
     LABEL "Programa Alocaá∆o de Atividades" 
     VIEW-AS TOGGLE-BOX
     SIZE 33.43 BY .83 TOOLTIP "Indica se programa Alocaá∆o de Atividades do Item" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cb-cod-obsoleto AT ROW 1.25 COL 21 COLON-ALIGNED
     cb-tipo-contr AT ROW 2.21 COL 21 COLON-ALIGNED
     cb-tipo-con-est AT ROW 3.17 COL 21 COLON-ALIGNED
     cb-tipo-requis AT ROW 4.13 COL 21 COLON-ALIGNED
     item.cod-lista-destino AT ROW 5.71 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     c-lista-destino AT ROW 5.71 COL 35.57 COLON-ALIGNED NO-LABEL
     tg-consid-aloc-ativid AT ROW 7.38 COL 14.86 HELP
          "Considera Item no processo de Alocaá∆o de Atividades"
     tg-log-programac-sfc AT ROW 8.08 COL 14.86 HELP
          "Indica se programa Alocaá∆o de Atividades do Item"
     fi-val-overlap AT ROW 7.46 COL 62.29 COLON-ALIGNED
     c-liter-multi AT ROW 5.25 COL 5 COLON-ALIGNED NO-LABEL
     c-liter-sfc AT ROW 6.79 COL 5 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 2.29
     RECT-1 AT ROW 5.5 COL 2.14
     RECT-2 AT ROW 7.04 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


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
         HEIGHT             = 8.17
         WIDTH              = 83.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{include/i-auxtab.i}
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

/* SETTINGS FOR FILL-IN c-lista-destino IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-cod-obsoleto IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR COMBO-BOX cb-tipo-con-est IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR COMBO-BOX cb-tipo-contr IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR COMBO-BOX cb-tipo-requis IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN item.cod-lista-destino IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-val-overlap IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-consid-aloc-ativid IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-log-programac-sfc IN FRAME f-main
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

&Scoped-define SELF-NAME cb-tipo-con-est
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo-con-est V-table-Win
ON ENTRY OF cb-tipo-con-est IN FRAME f-main
DO:
    find first saldo-estoq where
                   saldo-estoq.it-codigo = item.it-codigo no-lock no-error.
    if  avail saldo-estoq then
        disable cb-tipo-con-est with frame {&frame-name}.
    else
        enable  cb-tipo-con-est with frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.cod-lista-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-lista-destino V-table-Win
ON F5 OF item.cod-lista-destino IN FRAME f-main /* Lista Destino Multiplanta */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i  &prog-zoom="mpzoom/z01mp043.w"
                        &campo=item.cod-lista-destino
                        &campozoom=cd-lista-destino
                        &campo2=c-lista-destino
                        &campozoom2=desc-lista-dest}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-lista-destino V-table-Win
ON LEAVE OF item.cod-lista-destino IN FRAME f-main /* Lista Destino Multiplanta */
DO:
    if  avail param-global
    and param-global.modulo-mp
    then do:

        for each tt-lista-destino:
            delete tt-lista-destino.
        end.
        create  tt-lista-destino.
        assign  tt-lista-destino.cod-versao-integracao  = 1
                tt-lista-destino.cd-lista-destino       = input frame {&frame-name} item.cod-lista-destino.

        run mpp/mpapi007.p (input-output table tt-lista-destino,
                            input-output table tt-maq-lista-dest).

        find first tt-lista-destino no-lock no-error.
        if  return-value = "NOK"
        then
            assign c-lista-destino:screen-value = "".
        else
            assign c-lista-destino:screen-value = tt-lista-destino.desc-lista-dest.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-lista-destino V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.cod-lista-destino IN FRAME f-main /* Lista Destino Multiplanta */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-consid-aloc-ativid
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-consid-aloc-ativid V-table-Win
ON VALUE-CHANGED OF tg-consid-aloc-ativid IN FRAME f-main /* Considera Alocaá∆o de Atividades */
DO:
    IF tg-consid-aloc-ativid:CHECKED IN FRAME f-main = NO THEN
        ASSIGN tg-log-programac-sfc:CHECKED   IN FRAME f-main = NO 
               tg-log-programac-sfc:SENSITIVE IN FRAME f-main = NO.
    ELSE
        ASSIGN tg-log-programac-sfc:SENSITIVE IN FRAME f-main = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/
  {utp/ut-field.i mgind item cod-obsoleto 1}
  assign cb-cod-obsoleto:label in frame {&frame-name} = return-value.
  {utp/ut-field.i mgind item tipo-contr 1} 
  assign cb-tipo-contr:label in frame {&frame-name} = return-value.
  {utp/ut-field.i mgind item tipo-requis 1}
  assign cb-tipo-requis:label in frame {&frame-name} = return-value.
  {utp/ut-field.i mgind item tipo-con-est 1}
  assign cb-tipo-con-est:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Multiplanta * r}
  assign c-liter-multi:screen-value in frame {&frame-name} = trim(return-value).
  {utp/ut-liter.i Ch∆o_de_F†brica *}
  assign c-liter-sfc:screen-value in frame {&frame-name} = trim(return-value).

if item.cod-lista-destino:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

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

    DEFINE VARIABLE h-ut-integration AS HANDLE      NO-UNDO.
    
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN Get-Field-Screen-Value IN adm-broker-hdl
  (INPUT this-procedure,
   INPUT "cb-politica").  
  assign i-politica = {ininc/i04in122.i 06 return-value}. 
  assign c-tipo-con-est = input frame {&frame-name} cb-tipo-con-est.
  ASSIGN i-tipo-requis = {ininc/i08in122.i 06 cb-tipo-requis:SCREEN-VALUE IN FRAME {&FRAME-NAME}} .
  
  IF i-tipo-requis = 3
     AND CAN-FIND(FIRST reservas
                   WHERE reservas.it-codigo = item.it-codigo
                     AND reservas.estado = 1) THEN DO:
 
      RUN utp/ut-msgs.p(INPUT "show",
                        INPUT 56145,
                        INPUT ITEM.it-codigo).
 
      IF RETURN-VALUE = "YES":U THEN DO:
          
           RUN cpp/cp0204.w(INPUT ROWID(ITEM),
                            INPUT 2).
      END. 
  END.

  if i-politica = 5 then do:
     
    if {ininc/i01in122.i 06 c-tipo-con-est} <> 4 then do:
         run utp/ut-msgs.p (input "show", input 16535, input "").
         apply 'entry' to cb-tipo-con-est. 
         return 'adm-error':U.
     end.
  end.           

  if ITEM.tipo-con-est = 4 and 
     {ininc/i01in122.i 06 c-tipo-con-est} <> 4 and 
     can-find(first ref-item  
   		   where ref-item.it-codigo = item.it-codigo) then do:
   DEFINE VARIABLE c-return-value AS CHARACTER   NO-UNDO.
       {utp/ut-table.i mgind item 1}
       ASSIGN c-return-value = RETURN-VALUE.
              {utp/ut-table.i mgind ref-item 1}
                  run utp/ut-msgs.p(input 'show',
                                    input 17,
                                    input c-return-value + " " + item.it-codigo + "~~" + return-value).

        apply 'entry' to cb-tipo-con-est. 
        return 'adm-error':U.
  
  end.
   
  IF ITEM.tipo-contr = 4 then do:
  
      run pi-valida-controle-estoque.
  
      if return-value = "NOK" then do:
          apply 'entry':U to cb-tipo-con-est in frame f-main.
          return "ADM-ERROR":U.
      end.
  END.
  
  /** AlteraÁ„o ticket DMANFACTORY01-2478 **/
  /*IF ITEM.tipo-con-est <> 3 AND
     CAN-FIND(first item-lista-compon where
              item-lista-compon.es-codigo         = ITEM.it-codigo and
              item-lista-compon.log-compon-altern = YES) THEN DO:
      run utp/ut-msgs.p (input "show":U, input 18233, input "").
      RETURN 'ADM-ERROR':U.
	  /* O Componente n∆o pode ser controlado por Lote para ser Alternativo da Lista */
  END.*/  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  if RETURN-VALUE = 'ADM-ERROR':U then 
     return 'ADM-ERROR':U.

  &IF DEFINED(bf_man_204) &THEN
    IF l-mudancas-sfc THEN DO:

        &IF DEFINED(bf_man_207) &THEN
            ASSIGN item.log-consid-aloc-ativid = tg-consid-aloc-ativid:CHECKED IN FRAME f-main
                   ITEM.log-programac-sfc      = tg-log-programac-sfc:CHECKED IN FRAME f-main.
                   ITEM.val-overlap            = INPUT FRAME f-main fi-val-overlap.
        &ELSE
            ASSIGN OVERLAY(ITEM.char-1,259,1) = IF tg-consid-aloc-ativid:CHECKED IN FRAME f-main THEN "S":U ELSE "N":U
                   OVERLAY(ITEM.char-1,266,1) = IF tg-log-programac-sfc:CHECKED IN FRAME f-main THEN "S":U ELSE "N":U
                   OVERLAY(item.char-1,260,5) = STRING(INPUT FRAME f-main fi-val-overlap * 100,"99999":U).
        &ENDIF
        
    END.
  &ENDIF
  
  /*Api de Integraá∆o*/
  RUN utp/ut-integration.p PERSISTENT SET h-ut-integration.
  RUN eai-integration IN h-ut-integration (INPUT "Item",            /* Nome da transaá∆o     */
                                           INPUT ROWID(ITEM),       /* Registro da transaá∆o */
                                           INPUT "UPDATE",          /* Evento da transaá∆o   */
                                           OUTPUT TABLE RowErrors). /* Erros da transaá∆o    */
  DELETE PROCEDURE h-ut-integration.

  IF CAN-FIND(FIRST RowErrors) THEN DO:
      {method/showmessage.i1}
      {method/showmessage.i2 &Modal="YES"}
  END.
  /*Fim Api de Integraá∆o*/
  
/* Integraá∆o Neogrid */
RUN utp/ut-neog.p.
IF  RETURN-VALUE = "OK" THEN
    &IF '{&BF_DIS_VERSAO_EMS}' < '2.05' &THEN
    FOR EACH estabelec FIELDS (cod-emitente cod-estabel) NO-LOCK,
        FIRST emitente FIELDS (cod-emitente)
        WHERE emitente.cod-emitente        = estabelec.cod-emitente
        AND   SUBSTR(emitente.char-1,11,1) = "1" NO-LOCK:
    &ELSE
    FOR EACH estabelec FIELDS (cod-emitente cod-estabel) NO-LOCK,
        FIRST dist-emitente FIELDS (cod-emitente)
        WHERE dist-emitente.cod-emitente = estabelec.cod-emitente
        AND   dist-emitente.parceiro-b2b = YES NO-LOCK:
    &ENDIF
        RUN adapters/neogrid/enp/aneen005.p (INPUT ROWID(item),
                                             INPUT estabelec.cod-estabel,
                                             INPUT estabelec.cod-emitente,
                                             INPUT "Update").
    END.
/* Integraá∆o CRM */
RUN utp/ut-crm.p.
IF  RETURN-VALUE = "YES" THEN
    run adapters/neogrid/enp/aneen055.p (INPUT ROWID (item),
                                         INPUT "",
                                         INPUT 0,
                                         INPUT "Update").

    /* Integracao EAI - Itens */
    &IF DEFINED (bf_man_204) &THEN 
      IF v_log_eai_habilit THEN DO:
        CREATE tt-item-eai.
        BUFFER-COPY ITEM TO tt-item-eai.
        RUN adapters/xml/ma2/axsma003.p (INPUT "upd",
                                         INPUT "cd1107.w",
                                         INPUT STRING(c-prg-vrs),
                                         INPUT TABLE tt-item-eai,
                                         OUTPUT TABLE RowErrors).  
        DELETE tt-item-eai.
        IF CAN-FIND (FIRST RowErrors WHERE 
                           RowErrors.ErrorSubType = "ERROR":U) THEN DO:
          
           {method/showmessage.i1}
           {method/showmessage.i2 &Modal="YES"}
          
           undo, return "ADM-ERROR":U.
        END.
      END.
    &ENDIF


/* Code placed here will execute AFTER standard behavior.    */


    IF CONNECTED('mgscm') THEN DO:
        IF item.cod-obsoleto = 1 THEN DO:
            IF NOT VALID-HANDLE(hDBOproxy) THEN
                RUN wmp/wmprx044.p PERSISTENT SET hDBOproxy.
            EMPTY TEMP-TABLE ttItemReplica.
            ASSIGN c-tipo-con-est = INPUT FRAME {&FRAME-NAME} cb-tipo-con-est.
            CREATE ttItemReplica.
            ASSIGN ttItemReplica.it-codigo    = ITEM.it-codigo  
                   ttItemReplica.desc-item    = ITEM.desc-item
                   ttItemReplica.unid-med     = ITEM.un
                   ttItemReplica.peso-bruto   = ITEM.peso-bruto
                   ttItemReplica.largura      = ITEM.largura
                   ttItemReplica.comprimento  = ITEM.comprim
                   ttItemReplica.altura       = ITEM.altura
                   ttItemReplica.tipo-con-est = {ininc/i01in122.i 06 c-tipo-con-est} /*ITEM.tipo-con-est*/
                   ttItemReplica.fm-cod-com   = ITEM.fm-cod-com
                   ttItemReplica.fm-codigo    = ITEM.fm-codigo.
            RUN ReplicaItem IN hDBOproxy(INPUT TABLE ttItemReplica,
                                         OUTPUT TABLE RowErrors).
            IF RETURN-VALUE = 'NOK':U THEN DO:
                FOR EACH RowErrors:
                    RUN utp/ut-msgs.p (INPUT "show":U,
                                       INPUT RowErrors.ErrorNumber,
                                       INPUT RowErrors.ErrorParameters).
                END.
                RUN destroy IN hDBOproxy.
                RETURN "ADM-ERROR":U.
            END.
            RUN destroy IN hDBOproxy.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  {include/i-valid.i}
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

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
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */
  /*&if  defined(ADM-MODIFY-FIELDS) &then
 *       disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
 *   &endif*/
 disable {&ADM-create-FIELDS} {&ADM-assign-FIELDS} with frame {&frame-name}. 

 IF l-mudancas-sfc THEN 
      ASSIGN tg-consid-aloc-ativid:SENSITIVE IN FRAME f-main = NO
             tg-log-programac-sfc:SENSITIVE IN FRAME f-main  = NO
             fi-val-overlap:SENSITIVE IN FRAME f-main        = NO.

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

/*    if available item then do:
 *      find lista-destino where lista-destino.cd-lista-destino = item.cod-lista-destino no-lock no-error.
 *      assign c-lista-destino:screen-value in frame {&frame-name} = if avail lista-destino then lista-destino.desc-lista-dest else "":U
 *             item.cod-lista-destino:screen-value in frame {&frame-name} = item.cod-lista-destino.
 *   end.    */

  if  avail param-global
  and param-global.modulo-mp then do:

      for each tt-lista-destino:
          delete tt-lista-destino.
      end.

      create  tt-lista-destino.
      assign  tt-lista-destino.cod-versao-integracao  = 1
              tt-lista-destino.cd-lista-destino       = if avail item then item.cod-lista-destino
                                                        else "".

      run mpp/mpapi007.p (input-output table tt-lista-destino,
                          input-output table tt-maq-lista-dest).

      find first tt-lista-destino no-lock no-error.

      if  return-value = "NOK"
      then
          assign c-lista-destino       :screen-value in frame {&FRAME-NAME} = ""
                 item.cod-lista-destino:screen-value in frame {&FRAME-NAME} = "".
      else
          assign c-lista-destino       :screen-value in frame {&FRAME-NAME} = tt-lista-destino.desc-lista-dest
                 item.cod-lista-destino:screen-value in frame {&FRAME-NAME} = if avail item then
                                                                              item.cod-lista-destino
                                                                              else "".
  end.


  /* Dispatch standard ADM method.                             */
 /* RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .*/


  if avail item then do with frame {&frame-name}: 
     assign cb-tipo-contr:screen-value   = {ininc/i09in122.i 04 item.tipo-contr}
            cb-cod-obsoleto:screen-value = {ininc/i17in172.i 04 item.cod-obsoleto}
            cb-tipo-requis:screen-value  = {ininc/i08in122.i 04 item.tipo-requis}
            cb-tipo-con-est:screen-value = {ininc/i01in122.i 04 item.tipo-con-est}
            cb-tipo-contr                = cb-tipo-contr:screen-value
            cb-cod-obsoleto              = cb-cod-obsoleto:screen-value
            cb-tipo-requis               = cb-tipo-requis:screen-value
            cb-tipo-con-est              = cb-tipo-con-est:screen-value.
  end. 

  else do:
     assign cb-tipo-contr:screen-value   = {ininc/i09in122.i 04 2}
            cb-cod-obsoleto:screen-value = {ininc/i17in172.i 04 1}
            cb-tipo-requis:screen-value  = {ininc/i08in122.i 04 1}
            cb-tipo-con-est:screen-value = {ininc/i01in122.i 04 1}.
  end.  
  
  &IF DEFINED(bf_man_204) &THEN
      IF l-mudancas-sfc THEN DO:
          DISPLAY c-liter-sfc WITH FRAME f-main.
          ASSIGN tg-consid-aloc-ativid:CHECKED IN FRAME f-main = IF AVAIL ITEM THEN
                                                      &IF DEFINED(bf_man_207) &THEN
                                                           (item.log-consid-aloc-ativid)
                                                      &ELSE
                                                           (IF SUBSTRING(ITEM.char-1,259,1) = "N":U THEN NO ELSE YES)
                                                      &ENDIF
                                                      ELSE NO.
          ASSIGN tg-log-programac-sfc:CHECKED IN FRAME f-main = IF AVAIL ITEM THEN
                                                      &IF DEFINED(bf_man_207) &THEN
                                                           (item.log-programac-sfc)
                                                      &ELSE
                                                           (IF SUBSTRING(ITEM.char-1,266,1) = "N":U THEN NO ELSE YES)
                                                      &ENDIF
                                                      ELSE NO.
          ASSIGN fi-val-overlap:SCREEN-VALUE IN FRAME f-main = IF AVAIL ITEM THEN
                                                      &IF DEFINED(bf_man_207) &THEN
                                                           (string(item.val-overlap))
                                                      &ELSE
                                                           string(dec(int(SUBSTRING(item.char-1,260,5)) / 100))
                                                      &ENDIF
                                                      ELSE "0":U.
      END.
      ELSE  
  &ENDIF
          ASSIGN rect-2:HIDDEN                IN FRAME f-main = YES
                 c-liter-sfc:HIDDEN           IN FRAME f-main = YES
                 tg-consid-aloc-ativid:HIDDEN IN FRAME f-main = YES
                 fi-val-overlap:HIDDEN        IN FRAME f-main = YES
                 tg-log-programac-sfc:HIDDEN  IN FRAME f-main = YES.

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
 /* RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */
 /* &if  defined(ADM-MODIFY-FIELDS) &then
 *       enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
 *   &endif*/

  enable {&adm-assign-fields} with frame {&frame-name}.

   find first saldo-estoq where
                   saldo-estoq.it-codigo = item.it-codigo no-lock no-error.
    if  avail saldo-estoq then
        disable cb-tipo-con-est with frame {&frame-name}.
    else
        enable  cb-tipo-con-est with frame {&frame-name}.

  if param-global.modulo-mp then do:
     assign item.cod-lista-destino:sensitive in frame {&frame-name} = yes.
  end.
  else do:
     assign item.cod-lista-destino:sensitive in frame {&frame-name} = no.
  end. 

  /* Ativ. 159.380 */
  ASSIGN cb-tipo-contr:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

  IF l-mudancas-sfc THEN DO:
      ASSIGN tg-consid-aloc-ativid:SENSITIVE IN FRAME f-main = YES
             fi-val-overlap:SENSITIVE        IN FRAME f-main = YES
             tg-log-programac-sfc:SENSITIVE  IN FRAME f-main = YES.
      APPLY "value-changed":U TO tg-consid-aloc-ativid IN FRAME f-main.
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

  &IF DEFINED(bf_man_204) &THEN
      RUN sfc/sf9999.p(OUTPUT l-mudancas-sfc).
  &ENDIF

  /* Code placed here will execute PRIOR to standard behavior. */
  do  with frame {&frame-name}:
      assign cb-tipo-contr:list-items   = {ininc/i09in122.i 03}
             cb-cod-obsoleto:list-items = {ininc/i17in172.i 03}
             cb-tipo-requis:list-items  = {ininc/i08in122.i 03}
             cb-tipo-con-est:list-items = {ininc/i01in122.i 03}.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
 find first param-global no-lock. 

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
  if param-global.modulo-mp then do:
   {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-controle-estoque V-table-Win 
PROCEDURE pi-valida-controle-estoque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VAR c-trad AS CHARACTER NO-UNDO.
  {utp/ut-liter.i "DÇbito_Direto" *}
   ASSIGN c-trad = RETURN-VALUE.
  {utp/ut-liter.i "Serial" *}

  IF {ininc/i01in122.i 06 c-tipo-con-est} <> 1 /*serial CE0111*/  THEN DO:
      RUN utp/ut-msgs.p (INPUT 'show',
                         INPUT 54561, 
                         INPUT  c-trad + '~~' + RETURN-VALUE).
      RETURN "NOK":U.
  END.
   
  RETURN "OK":U.
    
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

