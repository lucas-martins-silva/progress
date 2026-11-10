&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          movind           PROGRESS
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
{include/i-prgvrs.i V01IN053 2.00.00.009}  /*** 010009 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN053 MUT}
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
def new global shared var v-row-parent as rowid no-undo.                                
def new global shared var i-inclui     as i     no-undo.
/* Parameters Definitions ---                                           */
def buffer b-comp  for componente.
def buffer b-comp1 for componente.
def buffer b-componente for componente.
/* Local Variable Definitions ---                                       */
def var de-qtd like componente.quantidade.
def var de-quant-tot     like saldo-terc.quantidade.
def var de-vl-saldo      like componente.preco-total extent 0 no-undo.
def var de-qt-saldo      like saldo-terc.quantidade no-undo.
def var de-valor         as decimal extent 3 no-undo.
def var de-saldo-ini     as decimal extent 3 no-undo.
def var de-preco         as decimal format ">>>>>,>>>,>>9.9999" no-undo.
def var de-quant-aux     like saldo-terc.quantidade no-undo.
def var i-cont as i.
def var de-qt-aux        like saldo-terc.quantidade no-undo.
def var l-envio          as logical.
def var i-mo-origem      like cotacao.mo-codigo           no-undo.
def var i-mo-destino     like cotacao.mo-codigo           no-undo.
def var de-vl-origem     like pr-it-per.val-unit-mob-m[1] no-undo.
def var de-vl-convertido like pr-it-per.val-unit-mob-m[2] no-undo. 
def var de-valor-tot     like componente.preco-total[1]   no-undo.
def var de-quantidade    like componente.quantidade       no-undo.
def var de-reajuste      as decimal                       no-undo.
def var da-dt-cotacao    like saldo-terc.dt-retorno       no-undo.

{cep/ce1234.i}  /* Valida»’o Decimais */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES componente
&Scoped-define FIRST-EXTERNAL-TABLE componente


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR componente.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS componente.quantidade 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}quantidade ~{&FP2}quantidade ~{&FP3}
&Scoped-define ENABLED-TABLES componente
&Scoped-define FIRST-ENABLED-TABLE componente
&Scoped-Define ENABLED-OBJECTS RECT-3 rt-mold 
&Scoped-Define DISPLAYED-FIELDS componente.dt-retorno componente.nro-docto ~
componente.serie-docto componente.nat-operacao componente.sequencia ~
componente.quantidade componente.componente 
&Scoped-Define DISPLAYED-OBJECTS c-lb 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS componente.dt-retorno componente.nro-docto ~
componente.serie-docto componente.nat-operacao componente.sequencia 

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
DEFINE VARIABLE c-lb AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 25 BY 2.08.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 72.86 BY 6.88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     componente.dt-retorno AT ROW 1.71 COL 18.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     componente.nro-docto AT ROW 1.67 COL 49.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     componente.serie-docto AT ROW 2.71 COL 18.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     componente.nat-operacao AT ROW 2.67 COL 49.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
     componente.sequencia AT ROW 3.71 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     componente.quantidade AT ROW 3.67 COL 49.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     componente.componente AT ROW 6 COL 28.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Envio", 1,
"Retorno", 2
          SIZE 20 BY .83
     c-lb AT ROW 5 COL 25.86 COLON-ALIGNED NO-LABEL
     RECT-3 AT ROW 5.33 COL 26
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.componente
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 6.96
         WIDTH              = 72.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-lb IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET componente.componente IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN componente.dt-retorno IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN componente.nat-operacao IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN componente.nro-docto IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN componente.sequencia IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN componente.serie-docto IN FRAME f-main
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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME componente.nat-operacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL componente.nat-operacao V-table-Win
ON F5 OF componente.nat-operacao IN FRAME f-main /* Nat Opera‡Æo */
DO:
   {include/zoomvar.i &prog-zoom="inzoom/z01in245.w"
                     &campo=componente.nat-operacao
                     &campozoom=nat-operacao}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL componente.nat-operacao V-table-Win
ON LEAVE OF componente.nat-operacao IN FRAME f-main /* Nat Opera‡Æo */
DO:
  find first natur-oper where 
        natur-oper.nat-operacao = input frame {&frame-name} componente.nat-operacao
        no-lock no-error.
   if avail natur-oper then do:
      assign l-envio = (  natur-oper.tp-oper-terc = 1
                       or natur-oper.tp-oper-terc = 3).
      if l-envio then
          assign componente.componente:screen-value in frame {&frame-name} = string(1).
      else 
          assign componente.componente:screen-value in frame {&frame-name} = string(2).
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL componente.nat-operacao V-table-Win
ON MOUSE-SELECT-DBLCLICK OF componente.nat-operacao IN FRAME f-main /* Nat Opera‡Æo */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME componente.nro-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL componente.nro-docto V-table-Win
ON F5 OF componente.nro-docto IN FRAME f-main /* Documento */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z02in404.w"
                         &campo=componente.nro-docto
                         &campozoom=nro-docto}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL componente.nro-docto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF componente.nro-docto IN FRAME f-main /* Documento */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME componente.serie-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL componente.serie-docto V-table-Win
ON F5 OF componente.serie-docto IN FRAME f-main /* S‚rie */
DO:
   {include/zoomvar.i &prog-zoom="inzoom/z01in407.w"
                      &campo=componente.serie-docto
                      &campozoom=serie}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL componente.serie-docto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF componente.serie-docto IN FRAME f-main /* S‚rie */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  if componente.nat-operacao:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if componente.serie-docto:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.  
  if componente.nro-docto:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "componente"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "componente"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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
  find first param-global no-lock no-error.
  find first param-estoq  no-lock no-error.
  {utp/ut-liter.i Data_Movto * L}
  assign componente.dt-retorno:label in frame {&frame-name} = return-value.
  assign componente.dt-retorno:screen-value in frame {&frame-name} = string(today).
  {utp/ut-field.i mgind movto-estoq quantidade 1}
  assign componente.quantidade:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Tp_Movto * R}
  assign c-lb:screen-value in frame {&frame-name} = return-value.
  assign componente.componente:screen-value in frame {&frame-name} = string(2).

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
  find saldo-terc where 
           rowid(saldo-terc) = v-row-parent no-lock no-error.
  find b-comp
       where b-comp.nro-docto    = saldo-terc.nro-docto
         and b-comp.serie-docto  = saldo-terc.serie-docto
         and b-comp.cod-emitente = saldo-terc.cod-emitente
         and b-comp.nat-operacao = saldo-terc.nat-operacao
         and b-comp.it-codigo    = saldo-terc.it-codigo
         and b-comp.cod-refer    = saldo-terc.cod-refer
         and b-comp.sequencia    = saldo-terc.sequencia
         no-lock no-error.
  do i-cont = 1 to 2:
      assign de-saldo-ini[i-cont] = b-comp.preco-total[i-cont].
  end.
  assign de-saldo-ini[3] = b-comp.pr-total-cmi.

  if i-inclui = 1 then do:
      if input frame {&frame-name} componente.dt-retorno > today then do:
          run utp/ut-msgs.p (input "show":U, input 5571, input return-value).
          return 'ADM-ERROR':U.    
      end.
      if input frame {&frame-name} componente.dt-retorno < 
                                   param-estoq.ult-fech-dia then do:
          run utp/ut-msgs.p (input "show":U, input 4951, input return-value).
          return 'ADM-ERROR':U.    
      end.
      if input frame {&frame-name} componente.dt-retorno < saldo-terc.dt-retorno
          then do:

          run utp/ut-msgs.p (input "show":U, input 5575, input return-value).
          return 'ADM-ERROR':U.    
      end.   
      if input frame {&frame-name} componente.nro-docto = "" then do:

          run utp/ut-msgs.p (input "show":U, input 5579, input return-value).
          return 'ADM-ERROR':U.    
      end.   
      find first serie where
           serie.serie = input frame {&frame-name} componente.serie-docto 
           no-lock no-error.
      if not avail serie then do:

          run utp/ut-msgs.p (input "show":U, input 5580, input return-value).
          return 'ADM-ERROR':U.    
      end.   
      if input frame {&frame-name} componente.quantidade <= 0 then do:

          run utp/ut-msgs.p (input "show":U, input 2608, input return-value).
          return 'ADM-ERROR':U.    
      end. 
      find natur-oper where
           natur-oper.nat-operacao = input frame {&frame-name} componente.nat-operacao 
           no-lock no-error.  
      if not avail natur-oper then do:
           run utp/ut-msgs.p (input "show":U, input 4281, input return-value).
           return 'ADM-ERROR':U.
      end.   
      if natur-oper.terceiros = no then do:

         run utp/ut-msgs.p (input "show":U, input 5492, input return-value).
         return 'ADM-ERROR':U.
      end.
      if natur-oper.transf  then do:

          run utp/ut-msgs.p (input "show":U, input 5493, input return-value).
          return 'ADM-ERROR':U.
      end.
      find componente
           where componente.nro-docto    = input frame {&frame-name} componente.nro-docto
             and componente.serie-docto  = input frame {&frame-name} componente.serie-docto
             and componente.cod-emitente = saldo-terc.cod-emitente
             and componente.nat-operacao = input frame {&frame-name} componente.nat-operacao
             and componente.it-codigo    = saldo-terc.it-codigo
             and componente.cod-refer    = saldo-terc.cod-refer
             and componente.sequencia    = input frame {&frame-name} componente.sequencia
             no-lock no-error.

      if  avail componente then do:
          {utp/ut-table.i mgind componente 1}
          run utp/ut-msgs.p (input "show":U, input 7, input return-value).
          apply "entry" to componente.nro-docto in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end. 
      find saldo-terc where 
          rowid(saldo-terc) = v-row-parent no-lock no-error.
      find componente
         where componente.nro-docto = saldo-terc.nro-docto
           and componente.serie-docto = saldo-terc.serie-docto
           and componente.cod-emitente = saldo-terc.cod-emitente
           and componente.nat-operacao = saldo-terc.nat-operacao
           and componente.it-codigo = saldo-terc.it-codigo
           and componente.cod-refer = saldo-terc.cod-refer
           and componente.sequencia = saldo-terc.sequencia
           no-lock no-error.
      assign de-qtd  = saldo-terc.quantidade + 
                      if input frame {&frame-name} componente.componente = 1 then 
                         input frame {&frame-name} componente.quantidade
                      else (input frame {&frame-name} componente.quantidade * -1).
      if de-qtd < 0 then do:

          run utp/ut-msgs.p (input "show":U, input 5590, input return-value).
          return 'ADM-ERROR':U.
      end. 
  end.
  if i-inclui = 2 or i-inclui = 3 then do:
      if componente.dt-retorno < param-estoq.ult-fech-dia then do:

          run utp/ut-msgs.p (input "show":U, input 4951, input return-value).
          return 'ADM-ERROR':U.    
      end.
      find b-componente where
           rowid(b-componente) = rowid(componente) exclusive-lock no-error.
      find item-doc-est where
           item-doc-est.serie-docto = b-componente.serie-docto
       and item-doc-est.nro-docto   = b-componente.nro-docto
       and item-doc-est.cod-emitente = b-componente.cod-emitente
       and item-doc-est.nat-operacao = b-componente.nat-operacao
       and item-doc-est.sequencia    = b-componente.sequencia
       and item-doc-est.it-codigo    = b-componente.it-codigo
       and item-doc-est.cod-refer    = b-componente.cod-refer
       no-lock no-error.
       if avail item-doc-est then do:

           run utp/ut-msgs.p (input "show":U, input 5628, input return-value).
           return 'ADM-ERROR':U.    
      end.

      if  saldo-terc.serie-docto  = b-componente.serie-docto
      and saldo-terc.nro-docto    = b-componente.nro-docto
      and saldo-terc.nat-operacao = b-componente.nat-operacao
      and saldo-terc.sequencia    = b-componente.sequencia
      and saldo-terc.cod-emitente = b-componente.cod-emitente
      and saldo-terc.it-codigo    = b-componente.it-codigo
      and saldo-terc.cod-refer    = b-componente.cod-refer then do:

           run utp/ut-msgs.p (input "show":U, input 5629, input return-value).
           return 'ADM-ERROR':U.    
      end.
  end.
  if i-inclui = 2 then do:
      assign de-quant-aux = saldo-terc.quantidade
                          + if  componente.componente = 2 then
                                 (componente.quantidade
                                - input frame {&frame-name} componente.quantidade)
                            else
                                 (input frame {&frame-name} componente.quantidade
                                - componente.quantidade).


      if input frame {&frame-name} componente.quantidade <= 0 then do:

          run utp/ut-msgs.p (input "show":U, input 2608, input return-value).
          return 'ADM-ERROR':U.    
      end.
      if de-quant-aux < 0 then do:

          run utp/ut-msgs.p (input "show":U, input 5590, input return-value).
          return 'ADM-ERROR':U.    
      end.
  end. 
  if (saldo-terc.tipo-sal-terc = 1   or
      saldo-terc.tipo-sal-terc = 2) and
      natur-oper.tp-oper-terc <> 1   and
      natur-oper.tp-oper-terc <> 2 then do:
      run utp/ut-msgs.p (input "show":U, input 6200, input return-value).
      return 'ADM-ERROR':U.
  end.
  if (saldo-terc.tipo-sal-terc = 4   or
      saldo-terc.tipo-sal-terc = 5) and
      natur-oper.tp-oper-terc <> 3   and
      natur-oper.tp-oper-terc <> 4   and
      natur-oper.tp-oper-terc <> 5   and
      natur-oper.tp-oper-terc <> 6 then do:
      run utp/ut-msgs.p (input "show":U, input 6200, input return-value).
      return 'ADM-ERROR':U.
  end.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

  find first natur-oper where 
        natur-oper.nat-operacao = input frame {&frame-name} componente.nat-operacao
        no-lock no-error.
  if avail natur-oper then do:
      assign l-envio = (  natur-oper.tp-oper-terc = 1
                       or natur-oper.tp-oper-terc = 3).
      if l-envio then
          assign componente.componente = 1.
      else 
          assign componente.componente = 2.
   end.
  if i-inclui = 1 then do:
      if avail saldo-terc then do:
          assign componente.cod-emitente = saldo-terc.cod-emitente
                 componente.serie-docto  = input frame {&frame-name} componente.serie-docto
                 componente.nro-docto    = input frame {&frame-name} componente.nro-docto
                 componente.nat-operacao = input frame {&frame-name} componente.nat-operacao
                 componente.nr-ord-prod  = saldo-terc.nr-ord-prod
                 componente.it-codigo    = saldo-terc.it-codigo
                 componente.cod-refer    = saldo-terc.cod-refer
                 componente.sequencia    = input frame {&frame-name} componente.sequencia.
      end.
      find saldo-terc where 
           rowid(saldo-terc) = v-row-parent no-lock no-error.
      find b-comp
          where b-comp.nro-docto    = saldo-terc.nro-docto
            and b-comp.serie-docto  = saldo-terc.serie-docto
            and b-comp.cod-emitente = saldo-terc.cod-emitente
            and b-comp.nat-operacao = saldo-terc.nat-operacao
            and b-comp.it-codigo = saldo-terc.it-codigo
            and b-comp.cod-refer = saldo-terc.cod-refer
            and b-comp.sequencia = saldo-terc.sequencia
            no-lock no-error.
      assign componente.nro-comp     = saldo-terc.nro-docto
             componente.serie-comp   = saldo-terc.serie-docto
             componente.nat-comp     = saldo-terc.nat-operacao
             componente.seq-comp     = saldo-terc.sequencia
             componente.un           = b-comp.un
             componente.cod-depos    = b-comp.cod-depos
             componente.cod-localiz  = b-comp.cod-localiz
             componente.nr-ord-prod  = b-comp.nr-ord-prod
             componente.aliquota-ipi = b-comp.aliquota-ipi
             componente.aliquota-icm = b-comp.aliquota-icm
             componente.cd-trib-ipi  = b-comp.cd-trib-ipi
             componente.cd-trib-icm  = b-comp.cd-trib-icm
             componente.ct-codigo    = b-comp.ct-codigo
             componente.sc-codigo    = b-comp.sc-codigo
             componente.conta-contabil = b-comp.conta-contabil 
             saldo-terc.quantidade = saldo-terc.quantidade
                                   + if componente.componente = 1 then
                                        componente.quantidade
                                     else
                                       (componente.quantidade * -1).

               if componente.dt-retorno < param-estoq.ult-fech-dia then
                  assign saldo-terc.qtd-ini = saldo-terc.qtd-ini
                                            + if componente.componente = 1 then
                                                 componente.quantidade
                                              else
                                                 componente.quantidade * -1.
      {rep/re0408.i3 componente}
      if componente.componente = 1 then 
          assign de-vl-saldo = de-vl-saldo + componente.preco-total[1]
                 de-qt-saldo = de-qt-saldo + componente.quantidade.
      else 
          assign de-vl-saldo = de-vl-saldo - componente.preco-total[1]
                 de-qt-saldo = de-qt-saldo - componente.quantidade.

  end.      
  if i-inclui = 2 then do:
      find b-comp
          where b-comp.nro-docto = saldo-terc.nro-docto
            and b-comp.serie-docto = saldo-terc.serie-docto
            and b-comp.cod-emitente = saldo-terc.cod-emitente
            and b-comp.nat-operacao = saldo-terc.nat-operacao
            and b-comp.it-codigo = saldo-terc.it-codigo
            and b-comp.cod-refer = saldo-terc.cod-refer
            and b-comp.sequencia = saldo-terc.sequencia
            no-lock no-error.
      find b-componente where
           rowid(b-componente) = rowid(componente) exclusive-lock no-error.

      assign saldo-terc.quantidade = de-quant-aux.
      if b-componente.componente = 1 then 
          assign de-vl-saldo = de-vl-saldo - b-componente.preco-total[1]
                 de-qt-saldo = de-qt-saldo - b-componente.quantidade.
      else 
          assign de-vl-saldo = de-vl-saldo + b-componente.preco-total[1]
                 de-qt-saldo = de-qt-saldo + b-componente.quantidade.
      {rep/re0408.i3 b-componente}
      assign componente.preco-total[1] = b-componente.preco-total[1].
      if b-componente.componente = 1 then 
          assign de-vl-saldo = de-vl-saldo + b-componente.preco-total[1]
                 de-qt-saldo = de-qt-saldo + b-componente.quantidade.
      else 
          assign de-vl-saldo = de-vl-saldo - b-componente.preco-total[1]
                 de-qt-saldo = de-qt-saldo - b-componente.quantidade.
  end.      


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/


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
  {utp/ut-liter.i Tp_Movto * R}
  assign c-lb:screen-value in frame {&frame-name} = return-value.
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
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
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
  find first param-global no-lock no-error.
  find first param-estoq  no-lock no-error.
  {utp/ut-liter.i Data_Movto * L}
  assign componente.dt-retorno:label in frame {&frame-name} = return-value.
  assign componente.dt-retorno:screen-value in frame {&frame-name} = string(today).
  {utp/ut-field.i mgind movto-estoq quantidade 1}
  assign componente.quantidade:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Tp_Movto * R}
  assign c-lb:screen-value in frame {&frame-name} = return-value.



  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  if i-inclui = 1 then do:
      enable componente.dt-retorno   with frame {&frame-name}.
      enable componente.nro-docto    with frame {&frame-name}.
      enable componente.serie-docto  with frame {&frame-name}.
      enable componente.nat-operacao with frame {&frame-name}.
      enable componente.sequencia    with frame {&frame-name}.
      enable componente.quantidade   with frame {&frame-name}.
      disable componente.componente with frame {&frame-name}.
      assign componente.componente:screen-value in frame {&frame-name} = string(2).
  end.
  if i-inclui = 2 then do:
      disable componente.dt-retorno   with frame {&frame-name}.
      disable componente.nro-docto    with frame {&frame-name}.
      disable componente.serie-docto  with frame {&frame-name}.
      disable componente.nat-operacao with frame {&frame-name}.
      disable componente.sequencia    with frame {&frame-name}.
      disable componente.componente   with frame {&frame-name}.
      enable componente.quantidade   with frame {&frame-name}.
  end.


  /* Code placed here will execute AFTER standard behavior.    */

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

   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "componente"}

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


