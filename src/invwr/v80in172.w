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

{include/i-prgvrs.i V80IN172 2.00.00.088 } /*** "010088" 31/03/2026 15:24:30 ***/

 

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v80in172 MUT}
&ENDIF

{include/i_fncrowid.i}

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

on write of item override do: end.



/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/***** No ems 202 foi incluido o campo cod-refer na it-dep-fat *****/
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}
{cdp/cdcfgman.i}
{method/dbotterr.i}
&IF DEFINED(BF_DIS_VERSAO_EMS) &THEN
    &IF "{&BF_DIS_VERSAO_EMS}" >= "2.02" &THEN
&GLOBAL-DEFINE COD-REFER cod-refer
    &ENDIF
&ELSE /* VersÆo 2.00 ou 2.01 */
&GLOBAL-DEFINE COD-REFER char-1
&ENDIF

/* Campos livres - RMA */
&IF DEFINED(bf_mat_versao_ems) &THEN 
  &IF {&bf_mat_versao_ems} >= 2.05 &THEN
    /* rma-it-dep */
    &GLOBAL-DEFINE dat-valid-lote dat-valid-lote
  &ELSE
    /* rma-it-dep */
    &GLOBAL-DEFINE dat-valid-lote dat-livre-1
  &ENDIF
&ENDIF
 
find first param-global no-lock no-error.

def temp-table tt-item-2 NO-UNDO like item use-index codigo .
{cdp/cd0666.i}

DEF BUFFER b-reservas       FOR reservas.
DEF BUFFER breq-ord         FOR req-ord.
def buffer b-saldo-est      for saldo-estoq.
def buffer b2-saldo-est     for saldo-estoq.
def buffer b-invent         for inventario.
def buffer b2-invent        for inventario.
def buffer b-item-doc-est   for item-doc-est.
def buffer b-rat-lote       for rat-lote.
def buffer b-it-dep-fat     for it-dep-fat.
def buffer b2-it-dep-fat    for it-dep-fat.
def buffer b-fat-ser-lote   for fat-ser-lote.
def buffer b2-fat-ser-lote  for fat-ser-lote.
def buffer b-componente     for componente.
def buffer b-preco-item     for preco-item.

DEF BUFFER b-rat-lote-internac          FOR rat-lote-internac.
DEF BUFFER b2-rat-lote-internac         FOR rat-lote-internac.
DEF BUFFER b-sdo-estoq-internac         FOR sdo-estoq-internac.
DEF BUFFER b2-sdo-estoq-internac        FOR sdo-estoq-internac.
DEF BUFFER b-fatur-ser-lote-internac    FOR fatur-ser-lote-internac.
DEF BUFFER b2-fatur-ser-lote-internac   FOR fatur-ser-lote-internac.
DEF BUFFER b-item-depos-fatur-internac  FOR item-depos-fatur-internac.
DEF BUFFER b2-item-depos-fatur-internac FOR item-depos-fatur-internac.
DEF BUFFER b-saldo-estoq-log            FOR saldo-estoq-log.

def var h-acomp            as handle  no-undo.
def var v-row-parent       as rowid   no-undo.
def var i-cont             as integer no-undo.
def var r-registro         as &IF {&ROWID_READY} = YES &THEN ROWID &ELSE RECID &ENDIF no-undo.
def var i-tipo-con-est-old as integer no-undo.
def var c-aux-refer        as char    no-undo.
def var c-aux-lote         as char    no-undo.
def var l-alt-refer        as logical no-undo.
def var da-aux-dt-lote     as date    no-undo.
DEF VAR lDevSimbConsig     AS LOGICAL NO-UNDO.

/*** Variÿveis para integra‡Æo EMS x SISDOC ***/
def var i-integracao-sisdoc as integer init ?   no-undo.
def var c-handle            as char             no-undo.
def var c-opcao-int         as char             no-undo.
def var i-retorno-erro      as integer init ?   no-undo.
    /* 
    ** 5 => Quando par³metro "nao-integra" e o registro jÿ estÿ integrado **
    ** 6 => Erro de integra‡Æo no SISDOC                                  **
    ** 7 => Erro de integra‡Æo no EMS                                     ** */

/********* Fim variÿveis para integra‡Æo ******/

&if '{&bf_lote_avancado_liberado}' = 'yes' &then
    def var l-lote-avancado   as log    no-undo.
    def var h-ceapi028        as handle no-undo.
    def var i-new-tip-con-est as int    no-undo.

    {cep/ceapi028.i}
&endif

DEF VAR hShowMsg       AS HANDLE NO-UNDO.
DEF VAR iErrorSequence AS INT    NO-UNDO.
DEF VAR cErrorDesc     AS CHAR   NO-UNDO.
DEF VAR cErrorHelp     AS CHAR   NO-UNDO.

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
&Scoped-Define ENABLED-FIELDS item.tipo-con-est item.alt-refer 
&Scoped-define ENABLED-TABLES item
&Scoped-define FIRST-ENABLED-TABLE item
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS item.it-codigo item.desc-item ~
item.tipo-con-est item.alt-refer 
&Scoped-define DISPLAYED-TABLES item
&Scoped-define FIRST-DISPLAYED-TABLE item
&Scoped-Define DISPLAYED-OBJECTS c-lote c-cod-refer c-desc-ref ~
da-dt-vali-lote c-label 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS c-lote c-cod-refer da-dt-vali-lote 

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
DEFINE VARIABLE c-cod-refer AS CHARACTER FORMAT "X(8)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ref AS CHARACTER FORMAT "X(32)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE c-label AS CHARACTER FORMAT "X(30)":U 
     LABEL "" 
      VIEW-AS TEXT 
     SIZE .57 BY .63 NO-UNDO.

DEFINE VARIABLE c-lote AS CHARACTER FORMAT "X(40)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE da-dt-vali-lote AS DATE FORMAT "99/99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80.72 BY 1.33.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80.72 BY 6.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item.it-codigo AT ROW 1.21 COL 5.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     item.desc-item AT ROW 1.21 COL 23.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 55.72 BY .88
     item.tipo-con-est AT ROW 3.04 COL 30 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Serial", 1,
"N£mero S‚rie", 2,
"Lote", 3,
"Referˆncia", 4
          SIZE 48 BY .75
     item.alt-refer AT ROW 4.38 COL 29.43
          VIEW-AS TOGGLE-BOX
          SIZE 31 BY .75
     c-lote AT ROW 5.33 COL 27.57 COLON-ALIGNED
     c-cod-refer AT ROW 6.33 COL 27.57 COLON-ALIGNED
     c-desc-ref AT ROW 6.33 COL 42 COLON-ALIGNED NO-LABEL
     da-dt-vali-lote AT ROW 7.33 COL 27.57 COLON-ALIGNED
     c-label AT ROW 3 COL 28.43
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81 BY 7.92.


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
         HEIGHT             = 7.92
         WIDTH              = 81.
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
   NOT-VISIBLE FRAME-NAME                                               */
ASSIGN 
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-refer IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN c-desc-ref IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-label IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-lote IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN da-dt-vali-lote IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN item.desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.it-codigo IN FRAME f-main
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

&Scoped-define SELF-NAME c-cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-refer V-table-Win
ON F5 OF c-cod-refer IN FRAME f-main
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in377.w"
                   &campo=c-cod-refer
                   &campo2=c-desc-ref
                   &campozoom=cod-refer
                   &campozoom2=c-desc-ref}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-refer V-table-Win
ON LEAVE OF c-cod-refer IN FRAME f-main
DO:
  {include/leave.i &tabela=referencia
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-ref
                   &where="referencia.cod-refer = input frame {&frame-name}
                                                  c-cod-refer"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-refer V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-refer IN FRAME f-main
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.tipo-con-est
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.tipo-con-est V-table-Win
ON VALUE-CHANGED OF item.tipo-con-est IN FRAME f-main /* Ctr Est */
DO:

    if  avail item then do:  
        assign c-lote:screen-value          in frame {&frame-name} = ""
               c-cod-refer:screen-value     in frame {&frame-name} = ""
               da-dt-vali-lote:screen-value in frame {&frame-name} = ?
               c-desc-ref:screen-value      in frame {&frame-name} = "".

        if item.tipo-con-est = 1 then do:                    
           if input frame {&frame-name} item.tipo-con-est > 1 then do:
              enable c-lote with frame {&frame-name}.

              if input frame {&frame-name} item.tipo-con-est > 2 then
                 enable da-dt-vali-lote with frame {&frame-name}.
              else
                 disable da-dt-vali-lote with frame {&frame-name}.
           end.
           else  
              disable c-cod-refer da-dt-vali-lote c-lote with frame {&frame-name}.              
        end.

        if item.tipo-con-est = 2 then do:
           if (input frame {&frame-name} item.tipo-con-est = 3 or
              input frame {&frame-name} item.tipo-con-est = 4) then do:   
              enable da-dt-vali-lote with frame {&frame-name}.
           end.
           else do:
              if input frame {&frame-name} item.tipo-con-est = 1 then
              disable c-cod-refer da-dt-vali-lote c-lote with frame {&frame-name}. 
           end.              
        end.   

        if item.tipo-con-est = 3 then do:
           disable c-cod-refer da-dt-vali-lote c-lote with frame {&frame-name}.                     
        end.   

        if item.tipo-con-est = 4 then do:         
           disable c-cod-refer da-dt-vali-lote c-lote with frame {&frame-name}. 
        end.                       

        if input frame {&frame-name} item.tipo-con-est = 4 then
           enable item.alt-refer c-cod-refer /*da-dt-vali-lote*/ with frame {&frame-name}.
        else
           disable item.alt-refer c-cod-refer with frame {&frame-name}.

        if item.tipo-con-est = input frame {&frame-name} item.tipo-con-est then 
           disable c-cod-refer da-dt-vali-lote c-lote with frame {&frame-name}. 

    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/****************************  Main Block  *************************** */

  if  item.it-codigo:load-mouse-pointer ("image\lupa.cur") in frame {&frame-name} then.
  if  c-cod-refer:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

        DEF BUFFER b-item FOR ITEM.
        DEF VARIABLE c-lote-histor AS CHARACTER NO-UNDO.

        for each tt-item-2:
            delete tt-item-2.
        end.

        create tt-item-2.
        buffer-copy item to tt-item-2.
        /* Code placed here will execute PRIOR to standard behavior. */
        {include/i-valid.i} 
        assign tt-item-2.tipo-con-est = input frame {&frame-name} item.tipo-con-est
               tt-item-2.alt-refer    = input frame {&frame-name} item.alt-refer
			   l-alt-refer            = tt-item-2.alt-refer.
        find first param-global no-lock no-error.

		/** Alteração ticket DMANFACTORY01-2478 **/
        /*IF tt-item-2.tipo-con-est = 3 AND
           ITEM.tipo-con-est     <> 3 AND
           CAN-FIND(first item-lista-compon where
                    item-lista-compon.es-codigo         = ITEM.it-codigo and
                    item-lista-compon.log-compon-altern = YES) THEN DO:
            run utp/ut-msgs.p (input "show":U, input 18233, input "").
            RETURN 'ADM-ERROR':U.
            /* O Componente nÆo pode ser controlado por Lote para ser Alternativo da Lista */
        END.*/

        if input frame {&frame-name} item.tipo-con-est = item.tipo-con-est then do:
          run utp/ut-msgs.p (input "show":U, input 3163, input "").
          /* Tipo de controle de estoque informado igual ao do item. */
          return 'ADM-ERROR':U.
        end.
        if item.tipo-con-est = 1 and
           input frame {&frame-name} item.tipo-con-est > 1 then do:
           if input frame {&frame-name} c-lote = "" then do:
              run utp/ut-msgs.p (input "show":U, input 2158, input "").
              /* Lote deve ser diferente de branco */
              return 'ADM-ERROR':U.
           end.
           if input frame {&frame-name} item.tipo-con-est = 4 then do: 
              find referencia where 
                   referencia.cod-refer = input frame {&frame-name} c-cod-refer
                   no-lock no-error.
              if not avail referencia then do:     
                 run utp/ut-msgs.p (input "show":U, input 529, input "").
                 /* Referencia nÆo cadastrada */
                 return 'ADM-ERROR':U.
              end.
           end.
           if input frame {&frame-name} item.tipo-con-est > 2 then do:
              if input frame {&frame-name} da-dt-vali-lote = ? then do:
                 run utp/ut-msgs.p (input "show":U, input 15021, input "").
                 /* Data de validade do lote deve ser diferente de branco */
                 return 'ADM-ERROR':U.
              end.
           end.             
        end.   

/*         if (item.tipo-con-est = 4 or item.tipo-con-est = 3) and                    */
/*            (input frame {&frame-name} item.tipo-con-est = 3 or                     */
/*            input frame {&frame-name} item.tipo-con-est = 2) then do:               */
/*            if input frame {&frame-name} item.tipo-con-est = 2 then do:             */
/*               find first movto-estoq where                                         */
/*                  movto-estoq.it-codigo = item.it-codigo no-lock no-error.          */
/*               if avail movto-estoq then do:                                        */
/*                  run utp/ut-msgs.p (input "show":U, input 15022, input "").        */
/*                 /* O item possui movimenta‡„es, nÆo pode trocar o tipo de controle */
/*                    do item para Nr. de S‚rie. */                                   */
/*                 return 'ADM-ERROR':U.                                              */
/*               end.                                                                 */
/*            end.                                                                    */
/*          end.                                                                      */


        if (item.tipo-con-est = 4 or item.tipo-con-est = 3) and
           (input frame {&frame-name} item.tipo-con-est = 3 or
            input frame {&frame-name} item.tipo-con-est = 2) then do:
            if input frame {&frame-name} item.tipo-con-est = 2 then do:
               if input frame {&frame-name} item.tipo-con-est = 2 then do: 
                  run utp/ut-msgs.p (input "show":U, 
                                     input 15038, 
                                     input "").
               end. 
            end.   
        end.
        if (item.tipo-con-est = 3 or item.tipo-con-est = 2) and
           (input frame {&frame-name} item.tipo-con-est >= 3) then do:
           if input frame {&frame-name} item.tipo-con-est = 4 then do: 
              find referencia where 
                   referencia.cod-refer = input frame {&frame-name} c-cod-refer
                   no-lock no-error.
              if not avail referencia then do:     
                 run utp/ut-msgs.p (input "show":U, input 529, input "").
                 /* Referencia nÆo cadastrada */
                 return 'ADM-ERROR':U.
              end.
           end.
           if input frame {&frame-name} item.tipo-con-est = 2 then do:
              if input frame {&frame-name} da-dt-vali-lote = ? then do:
                 run utp/ut-msgs.p (input "show":U, input 15021, input "").
                 /* Data de validade do lote deve ser diferente de branco */
                 return 'ADM-ERROR':U.
              end.
           end.             
        end.   
        if input frame {&frame-name} item.tipo-con-est = 4
           and item.niv-mais-bai <> 0 then do:
           run utp/ut-msgs.p (input "show":U, input 3164, input return-value).
          /* Item com componente na estrutura controlada por referencia. */
           if  return-value = "no" then 
               return 'ADM-ERROR':U.
        end.

        if item.politica = 5 then do: /* configurado */ 
           run utp/ut-msgs.p (input "show":U, input 5685, input "").
           return 'ADM-ERROR':U.
        end.

     if input frame {&frame-name} da-dt-vali-lote < today then do:
              run utp/ut-msgs.p (input "show":U, input 26638, input "").
              /* Data de validade menor que a data atual */
              return 'ADM-ERROR':U.          
     end.

     if (ITEM.tipo-con-est < 4 and input frame {&frame-name} item.tipo-con-est = 4)
     or (ITEM.tipo-con-est = 4 and input frame {&frame-name} item.tipo-con-est < 4)  then do:

         IF CAN-FIND(FIRST alternativo
                       WHERE alternativo.es-codigo = ITEM.it-codigo) 
         OR CAN-FIND(FIRST alternativo
                       WHERE alternativo.al-codigo = ITEM.it-codigo) THEN DO:

             run utp/ut-msgs.p("show":U,2361,""). /* Tipo de controle de estoque invÿlido para item alternativo */
             return 'ADM-ERROR':U. 
         END.
     END.

     if  input frame {&frame-name} item.tipo-con-est = 1
     and avail item then do:
         for each item-uni-estab fields(cod-estabel)
             where item-uni-estab.it-codigo      = item.it-codigo 
               and item-uni-estab.metodo-custeio = 6 /* espec¡dico */ no-lock:
             if  can-find(estab-mat where
                          estab-mat.cod-estabel = item-uni-estab.cod-estabel and
                          estab-mat.usa-on-line) then do:
                 run utp/ut-msgs.p("show":U,26162,""). /* Tipo de controle de estoque invÿlido para custo espec¡fico */
                 return 'ADM-ERROR':U.         
             end. 
         end.
     end.  

     &IF DEFINED (bf_man_sfc_ref_oper) &THEN

     if  input frame {&frame-name} item.tipo-con-est <> 1
     and avail item then do:
     /*Valida‡äes referentes ao refugo por opera‡Æo . EMS 2.05 */
               IF CAN-FIND(FIRST item-uni-estab USE-INDEX item-uni-estab-refugo
                           WHERE ITEM-uni-estab.cod-item-refugo = ITEM.it-codigo)
                  THEN DO:
                  run utp/ut-msgs.p (input "show":U, input 28064, input ITEM.it-codigo).
                  return 'ADM-ERROR':U.
               END.
               IF CAN-FIND(FIRST b-ITEM USE-INDEX item-refugo
                           WHERE b-ITEM.cod-item-refugo = ITEM.it-codigo)
                  THEN DO:
                  run utp/ut-msgs.p (input "show":U, input 28064, input ITEM.it-codigo).
                  return 'ADM-ERROR':U.
               END.
               IF CAN-FIND(FIRST fam-uni-estab USE-INDEX fam-uni-estab-refugo
                           WHERE fam-uni-estab.cod-item-refugo = input frame {&frame-name} ITEM.it-codigo)
                  THEN DO:
                  run utp/ut-msgs.p (input "show":U, input 28064, input input frame {&frame-name} ITEM.it-codigo).
                  return 'ADM-ERROR':U.
               END.              
               IF CAN-FIND(FIRST familia USE-INDEX familia-refugo
                           WHERE familia.cod-item-refugo = input frame {&frame-name} ITEM.it-codigo)
                  THEN DO:
                  run utp/ut-msgs.p (input "show":U, input 28064, input input frame {&frame-name} ITEM.it-codigo).
                  return 'ADM-ERROR':U.
               END.
               IF CAN-FIND(FIRST operacao USE-INDEX operacao-refugo
                           WHERE operacao.cod-item-refugo = input frame {&frame-name} ITEM.it-codigo)
                  THEN DO:
                  run utp/ut-msgs.p (input "show":U, input 28064, input input frame {&frame-name} ITEM.it-codigo).
                  return 'ADM-ERROR':U.
               END.
               IF CAN-FIND(FIRST ord-prod USE-INDEX ord-produc-refugo
                           WHERE ord-prod.cod-item-refugo = input frame {&frame-name} ITEM.it-codigo
                             and ord-prod.estado < 8)
                  THEN DO:
                  run utp/ut-msgs.p (input "show":U, input 28064, input input frame {&frame-name} ITEM.it-codigo).
                  return 'ADM-ERROR':U.
               END.               
               IF CAN-FIND(FIRST oper-ord USE-INDEX oper-ord-refugo
                           WHERE oper-ord.cod-item-refugo = input frame {&frame-name} ITEM.it-codigo)
                  THEN DO:
                      for each oper-ord USE-INDEX oper-ord-refugo
                           WHERE oper-ord.cod-item-refugo = input frame {&frame-name} ITEM.it-codigo
                           no-lock:
                           if can-find(first ord-prod 
                                       where ord-prod.nr-ord-produ = oper-ord.nr-ord-produ
                                         and ord-prod.estado < 8) then do:
                              run utp/ut-msgs.p (input "show":U, input 28064, input input frame {&frame-name} ITEM.it-codigo).
                              return 'ADM-ERROR':U.
                           end.
                      end.
               END.
     end.
     &endif     
           
     &IF '{&mgscm_version}' >= '2.06B' &THEN
           IF CONNECTED('mgscm') THEN DO: 
               RUN wmp/wm9705.p (INPUT INPUT FRAME {&frame-name} ITEM.it-codigo,    /*item*/
                                 INPUT item.tipo-con-est,                           /*controle estoque*/
                                 INPUT INPUT FRAME {&frame-name} item.tipo-con-est, /*controle estoque novo*/
                                 INPUT INPUT FRAME {&frame-name} c-lote,            /*lote*/
                                 INPUT INPUT FRAME {&frame-name} c-cod-refer,       /*cod. referencia*/
                                 INPUT INPUT FRAME {&frame-name} da-dt-vali-lote,
                                 OUTPUT TABLE tt-erro).  /*data validade lote*/

                find first tt-erro no-lock no-error.
                if avail tt-erro then do: 
                   run cdp/cd0666.w (input table tt-erro).
                    return "ADM-ERROR":U.
                end.
           END.
     &ENDIF
     
     assign i-tipo-con-est-old = item.tipo-con-est
            c-lote             = input frame {&frame-name} c-lote
            c-cod-refer        = input frame {&frame-name} c-cod-refer
            da-dt-vali-lote    = input frame {&frame-name} da-dt-vali-lote.
     
     &if '{&bf_lote_avancado_liberado}' = 'yes' &then
     
         if l-lote-avancado then do:
     
            for each saldo-estoq use-index item
                where saldo-estoq.it-codigo = item.it-codigo exclusive-lock:

                empty temp-table tt-fda-lote-avancad.
                empty temp-table tt-fda-lote-histor.

                create tt-fda-lote-avancad.
                assign tt-fda-lote-avancad.it-codigo             = saldo-estoq.it-codigo
                       tt-fda-lote-avancad.cod-estabel           = saldo-estoq.cod-estabel
                       tt-fda-lote-avancad.nr-lote               = saldo-estoq.lote
                       tt-fda-lote-avancad.dt-validade           = saldo-estoq.dt-vali-lote
                       tt-fda-lote-avancad.i-tipo-estado-inicial = 1
                       i-new-tip-con-est                         = input frame {&frame-name} item.tipo-con-est.
        
                create tt-fda-lote-histor.
                assign tt-fda-lote-histor.dat-alter    = today
                       /*tt-fda-lote-histor.des-alter[1]*/
                       c-lote-histor = "Altera‡Æo de tipo de controle de estoque de " + {ininc/i01in122.i 04 i-tipo-con-est-old} + 
                                                         " para ":u + {ininc/i01in122.i 04 i-new-tip-con-est} + ". Item: " + saldo-estoq.it-codigo
                       tt-fda-lote-histor.hra-alter    = string(time, "hh:mm:ss").
                
                if i-tipo-con-est-old < 3 and
                   input frame {&frame-name} item.tipo-con-est > 2 then do:
        
                    assign tt-fda-lote-avancad.nr-lote     = c-lote
                           tt-fda-lote-avancad.dt-validade = da-dt-vali-lote.
        
                    run pi-executar in h-ceapi028 (input table tt-fda-lote-avancad,
                                                   input table tt-fda-lote-histor,
                                                   input 1,/*movto estoque*/
                                                   input c-lote-histor,
                                                   output table tt-erro).
        
                    if can-find(first tt-erro) then do:
                        run cdp/cd0666.w (input table tt-erro).
                        return "ADM-ERROR":U.       
                    end.
                end.
        
                if i-tipo-con-est-old > 2 and
                   input frame {&frame-name} item.tipo-con-est < 3 then do:
        
                    assign tt-fda-lote-avancad.nr-lote = saldo-estoq.lote.
        
                    run pi-desativa-lote in h-ceapi028 (input table tt-fda-lote-avancad,
                                                        input table tt-fda-lote-histor,
                                                        input 1,/*movto estoque*/
                                                        input c-lote-histor).
        
                end.
            end.
        end.
     &endif
     
     /* Dispatch standard ADM method.*/                             
     RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
     if  return-value = 'ADM-ERROR':U THEN
         return 'ADM-ERROR':U.
     
     RUN pi-assign.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /******* Integra‡Æo EMS x SISDOC ******/

  if  i-integracao-sisdoc = ? then do:
      RUN Who-Is-The-Container IN adm-broker-hdl (INPUT  this-procedure,
                                                  OUTPUT c-handle).
      run pi-atualiza-var in widget-handle(c-handle) (output i-integracao-sisdoc).
  end.

  if  i-integracao-sisdoc = 2 then
      assign c-opcao-int = "nao-integra".
  if  i-integracao-sisdoc = 3 then
      assign c-opcao-int = "elimina".

  /***** Fim Integra‡Æo EMS x SISDOC ****/
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

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

   ON WRITE OF item REVERT.
   
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-end-update V-table-Win 
PROCEDURE local-end-update :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .

   /* Code placed here will execute AFTER standard behavior.    */

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
  run get-attribute ('adm-new-record').

IF CAN-FIND(funcao WHERE funcao.cd-funcao = "spp-integra-ems-his" AND funcao.ativo = YES) THEN DO:
&if "{&bf_mat_versao_ems}":U >= "2.08":U &then
    IF item.log-orig-ext THEN DO:
             RUN utp/ut-msgs.p (INPUT "show",
                                INPUT 35068,
                               INPUT "" ).
                  run notify ("pi-cancelar, tableio-source").
                  return "ADM-ERROR":U.
    END.
&else
  &if "{&bf_mat_versao_ems}":U >= "2.062":U &then  
  IF trim(substring(item.char-1,267,1)) = "S" THEN DO:
             RUN utp/ut-msgs.p (INPUT "show",
                                INPUT 35068,
                               INPUT "").
                  run notify ("pi-cancelar, tableio-source").
                  return "ADM-ERROR":U.
  END.
  &ENDIF
&endif
END.
  /******* Integra‡Æo EMS x SISDOC ******/

  run get-attribute ('adm-new-record').
  if  not adm-new-record then do:
      if  i-integracao-sisdoc = ? then do:
          RUN Who-Is-The-Container IN adm-broker-hdl 
                            (INPUT  this-procedure,
                             OUTPUT c-handle).
          run pi-atualiza-var in widget-handle(c-handle) (output i-integracao-sisdoc).
      end.     
  end.  /* if not adm-new-record */

  /***** Fim Integra‡Æo EMS x SISDOC ****/

  /* Dispatch standard ADM method.        */
    
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  &if  defined(ADM-MODIFY-FIELDS) &then do:
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  end.

  apply "value-changed" to item.tipo-con-est in frame {&frame-name}. 

   if input frame {&frame-name} item.it-codigo = " " or
      item.tipo-contr = 4 then do:
      assign item.tipo-con-est:sensitive in frame {&frame-name} = no.
   end.
   else do:     
      assign item.tipo-con-est:sensitive in frame {&frame-name} = yes.
      disable item.alt-refer c-cod-refer da-dt-vali-lote c-lote 
              with frame {&frame-name}.
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

  {utp/ut-liter.i Tipo_Controle_de_Estoque mce L}
  assign c-label:label in frame {&frame-name} = return-value.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  {utp/ut-liter.i Lote/Serie/Nro_Serie mce L}
  assign c-lote:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Referencia mce L}
  assign c-cod-refer:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Data_de_Validade_do_Lote mce L}
  assign da-dt-vali-lote:label in frame {&frame-name} = return-value.

  find first param-global no-lock no-error.

  &if '{&bf_lote_avancado_liberado}' = 'yes' &then
    if can-find(funcao where funcao.cd-funcao = "lote-avancado":u and
                             funcao.ativo) then do:
        assign l-lote-avancado = yes.

        run cep/ceapi028.p persistent set h-ceapi028 (input table tt-fda-lote-avancad,
                                                      input table tt-fda-lote-histor,
                                                      input 1,/*movto estoque*/
                                                      input "Altera‡Æo tipo controle estoque",
                                                      output table tt-erro).
    end.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  /* Code placed here will execute AFTER standard behavior.    */


  if  avail item and
      (input frame {&frame-name} item.tipo-con-est = 3 or 
       input frame {&frame-name} item.tipo-con-est = 4) then do:  
       assign c-lote = ""
              c-cod-refer = ""
              da-dt-vali-lote = ?
              c-desc-ref = "".
  end.

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

    {database/tgin/twp/twin172.i 'show':U}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-assign V-table-Win 
PROCEDURE pi-assign :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    find first param-global no-lock no-error.

    EMPTY TEMP-TABLE RowErrors.
	
	ASSIGN iErrorSequence = 0.

    run utp/ut-acomp.p persistent set h-acomp.
    run pi-inicializar in h-acomp (input "").

    if  i-tipo-con-est-old > 1
    and input frame {&frame-name} item.tipo-con-est = 1 then do:
        {cep/ce0111.i c-lote c-cod-refer da-dt-vali-lote}
        {cep/ce0111.i3}
        {cep/ce0111.i4 c-cod-refer}
    end.
    if  i-tipo-con-est-old = 1
    and input frame {&frame-name} item.tipo-con-est > 1 then do:
        {cep/ce0111.i c-lote c-cod-refer da-dt-vali-lote}
        {cep/ce0111.i3}
        {cep/ce0111.i4 c-cod-refer} 
    end.        

   RUN pi-assign1.
   RUN pi-assign2.
   
   IF CAN-FIND (FIRST RowErrors) THEN DO:

	   {method/showmessage.i1}
	   {method/showmessage.i2 &Modal="YES"}

   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-assign1 V-table-Win 
PROCEDURE pi-assign1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if  i-tipo-con-est-old = 4
    and (input frame {&frame-name} item.tipo-con-est = 3
    or   input frame {&frame-name} item.tipo-con-est = 2) then do:
        {cep/ce0111.i2 c-cod-refer c-lote da-dt-vali-lote}
        {cep/ce0111.i3}
        {cep/ce0111.i4 c-cod-refer}
    end.

   if  i-tipo-con-est-old = 2 AND
       input frame {&frame-name} item.tipo-con-est = 3 then do:
        {cep/ce0111.i2 c-cod-refer c-lote da-dt-vali-lote}
        {cep/ce0111.i3}
        {cep/ce0111.i4 c-cod-refer}
    end.

   if  i-tipo-con-est-old = 3 AND
       input frame {&frame-name} item.tipo-con-est = 4 then do:
        {cep/ce0111.i5 c-cod-refer c-lote l-alt-refer}
        {cep/ce0111.i3}
        {cep/ce0111.i4 c-cod-refer}
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-assign2 V-table-Win 
PROCEDURE pi-assign2 :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    if (i-tipo-con-est-old = 3 or i-tipo-con-est-old = 2)
    and input frame {&frame-name} item.tipo-con-est = 4 then do:
       {cep/ce0111.i5 c-cod-refer c-lote l-alt-refer /*da-dt-vali-lote*/}
       {cep/ce0111.i3}
       {cep/ce0111.i4 c-cod-refer}          
    end. 

    if  i-tipo-con-est-old = 3 AND
        input frame {&frame-name} item.tipo-con-est = 2 then do:
        {cep/ce0111.i2 c-cod-refer c-lote da-dt-vali-lote}
        {cep/ce0111.i3}
        {cep/ce0111.i4 c-cod-refer}          
    end.

    if  i-tipo-con-est-old = 2 and 
        input frame {&frame-name} item.tipo-con-est = 4 then do:
       {cep/ce0111.i2 c-cod-refer c-lote da-dt-vali-lote}
       {cep/ce0111.i3}
       {cep/ce0111.i4 c-cod-refer}          
    end. 

    run pi-finalizar in h-acomp.
    /******* Integra‡Æo EMS x SISDOC ******/

    if i-integracao-sisdoc = ? then do:
       RUN Who-Is-The-Container IN adm-broker-hdl (INPUT  this-procedure,
                                                   OUTPUT c-handle).
       run pi-atualiza-var in widget-handle(c-handle) (output i-integracao-sisdoc).
    end.  
   /***************** Fim Integra‡Æo EMS x SISDOC **************/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-envia-item V-table-Win 
PROCEDURE pi-envia-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define OUTPUT parameter p-it-codigo LIKE ITEM.it-codigo no-undo.

    assign p-it-codigo = ITEM.it-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-roda-include V-table-Win 
PROCEDURE pi-roda-include :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE RowErrors.

    ASSIGN iErrorSequence = 0.
    {cep/ce0111.i2 c-cod-refer c-lote da-dt-vali-lote}
    {cep/ce0111.i3}
    {cep/ce0111.i4 c-cod-refer} 
	
	IF CAN-FIND (FIRST RowErrors) THEN DO:

	   {method/showmessage.i1}
	   {method/showmessage.i2 &Modal="YES"}

	END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡„es, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Valida‡Æo de dicionÿrio */

   /*Segue um exemplo de valida‡Æo de programa 
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
     if  p-state = "Update-Begin":U then do:
         &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
             IF CAN-FIND(FIRST funcao
                         WHERE funcao.cd-funcao = "spp-sgt"
                         AND   funcao.ativo = YES)  THEN DO:
          
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-alteracao AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Altera‡Æo" *}
                ASSIGN c-lbl-liter-alteracao = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-tipo-de-controle-de-estoque AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Tipo_de_Controle_de_Estoque" *}
                ASSIGN c-lbl-liter-tipo-de-controle-de-estoque = TRIM(RETURN-VALUE).
                RUN utp/ut-msgs.p (input "show",
                                input 33548,
                                input c-lbl-liter-alteracao + "~~" + c-lbl-liter-tipo-de-controle-de-estoque ).

                RUN pi-disable-cancel in widget-handle(c-handle).
                return "adm-error".
                
                
             END.
         &endif.

        if  item.tipo-contr = 4 then do:
           run utp/ut-msgs.p (input "show":U, input 1673, input "").         
           RUN dispatch IN THIS-PROCEDURE ('cancel-record':U). 
           return "adm-error".
      end.
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

