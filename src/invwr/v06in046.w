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
{include/i-prgvrs.i V06IN046 2.00.00.049 } /*** "010049" 06/05/2026 14:14:40 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v06in046 MUT}
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
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{cdp/cd9990.i1}
{cdp/cd4000.i}
{cdp/cdcfgmat.i}
{include/i_dbvers.i}

define workfile w-pedido no-undo
    field nome-abrev like ped-venda.nome-abrev
    field nr-pedcli  like ped-venda.nr-pedcli.
define new global shared variable de-aliquota-ipi-old as decimal.
define VAR de-aliquota-pis-old    as decimal FORMAT ">9.9999" NO-UNDO.
define VAR de-reducao-pis-old     as decimal no-undo.
define VAR de-aliquota-cofins-old as decimal FORMAT ">9.9999" no-undo.
define VAR de-reducao-cofins-old  as decimal no-undo.
define VAR l-susp-ipi-old         as logical no-undo.
define var wh-cd0603              as handle  no-undo.
define var c-cd0603               as char    no-undo.
define var l-is-alterado          AS LOGICAL NO-UNDO.

DEFINE VAR h-cdapi995             AS HANDLE  NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE de-val-pis-externo-old    AS DECIMAL NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE de-val-cofins-externo-old AS DECIMAL NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE l-atualizou-valores-ext   AS LOGICAL NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES classif-fisc
&Scoped-define FIRST-EXTERNAL-TABLE classif-fisc


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR classif-fisc.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS classif-fisc.aliquota-ipi ~
classif-fisc.unidade classif-fisc.cod-unidade classif-fisc.log-1  tg-is
&Scoped-define ENABLED-TABLES classif-fisc
&Scoped-define FIRST-ENABLED-TABLE classif-fisc
&Scoped-Define ENABLED-OBJECTS c-unid-tribut
&Scoped-Define DISPLAYED-FIELDS classif-fisc.aliquota-ipi ~
classif-fisc.unidade classif-fisc.cod-unidade classif-fisc.log-1 
&Scoped-define DISPLAYED-TABLES classif-fisc
&Scoped-define FIRST-DISPLAYED-TABLE classif-fisc
&Scoped-Define DISPLAYED-OBJECTS c-unid-tribut tg-is c-descricao ~
c-descricao-unid 

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
DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "x(15)" 
     VIEW-AS FILL-IN 
     SIZE 24.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao-unid AS CHARACTER FORMAT "x(15)" 
     VIEW-AS FILL-IN 
     SIZE 24.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-unid-tribut AS CHARACTER FORMAT "x(2)" 
     LABEL "Unidade de Medida Tribut†vel" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE tg-is AS LOGICAL INITIAL no 
     LABEL "Incide IS" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     classif-fisc.aliquota-ipi AT ROW 1.25 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     classif-fisc.unidade AT ROW 2.25 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     classif-fisc.cod-unidade AT ROW 3.25 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.86 BY .88
     c-unid-tribut AT ROW 4.25 COL 30 COLON-ALIGNED HELP
          "Unidade de medida tribut†vel para o XML da NF-e."
     classif-fisc.log-1 AT ROW 5.25 COL 32 HELP
          ""
          LABEL "Suspens∆o IPI"
          VIEW-AS TOGGLE-BOX
          SIZE 19 BY .83
     tg-is AT ROW 6.04 COL 32 
        HELP "NCM possui incidància de IS - Imposto Seletivo"
     c-descricao AT ROW 2.25 COL 35.29 COLON-ALIGNED NO-LABEL
     c-descricao-unid AT ROW 4.25 COL 35.29 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.classif-fisc
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
         HEIGHT             = 5.96
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R,COLUMNS                    */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX classif-fisc.log-1 IN FRAME f-main
   EXP-LABEL EXP-HELP                                                   */
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

&Scoped-define SELF-NAME c-unid-tribut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-unid-tribut V-table-Win
ON F5 OF c-unid-tribut IN FRAME f-main /* Unidade de Medida Tribut†vel */
DO:
  {include/zoomvar.i &prog-zoom=inzoom/z01in417.w
                     &campo=c-unid-tribut
                     &campozoom=un
                     &frame=f-main
                     &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-unid-tribut V-table-Win
ON LEAVE OF c-unid-tribut IN FRAME f-main /* Unidade de Medida Tribut†vel */
DO:
  {include/leave.i &tabela=tab-unidade
                   &atributo-ref=descricao
                   &variavel-ref=c-descricao-unid
                   &where="tab-unidade.un = input frame {&frame-name} c-unid-tribut"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-unid-tribut V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-unid-tribut IN FRAME f-main /* Unidade de Medida Tribut†vel */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME classif-fisc.unidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL classif-fisc.unidade V-table-Win
ON F5 OF classif-fisc.unidade IN FRAME f-main /* Unid Medid */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z01in417.w
                     &campo=classif-fisc.unidade
                     &campozoom=un}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL classif-fisc.unidade V-table-Win
ON LEAVE OF classif-fisc.unidade IN FRAME f-main /* Unid Medid */
DO:
  {include/leave.i &tabela=tab-unidade
                   &atributo-ref=descricao
                   &variavel-ref=c-descricao
                   &where="tab-unidade.un = input frame {&frame-name} classif-fisc.unidade"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL classif-fisc.unidade V-table-Win
ON MOUSE-SELECT-DBLCLICK OF classif-fisc.unidade IN FRAME f-main /* Unid Medid */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  if classif-fisc.unidade:load-mouse-pointer('image/lupa.cur') in frame {&frame-name} then.   
  if c-unid-tribut       :load-mouse-pointer('image/lupa.cur') in frame {&frame-name} then. 


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
  {src/adm/template/row-list.i "classif-fisc"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "classif-fisc"}

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
  
  ASSIGN classif-fisc.aliquota-ipi:SCREEN-VALUE IN FRAME {&frame-name} = "0"
         tg-is:CHECKED                          IN FRAME {&FRAME-NAME} = FALSE.

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
  {include/i-valid.i} 

  ASSIGN c-unid-tribut = c-unid-tribut:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

  run who-is-the-container in adm-broker-hdl (input this-procedure, output c-cd0603).
  assign wh-cd0603 = widget-handle(c-cd0603).

  if avail classif-fisc then
    assign de-aliquota-ipi-old    = classif-fisc.aliquota-ipi
           de-aliquota-pis-old    = classif-fisc.dec-1
           de-aliquota-cofins-old = classif-fisc.dec-2
           de-reducao-pis-old     = classif-fisc.int-1 / 100
           de-reducao-cofins-old  = classif-fisc.int-2 / 100
           l-susp-ipi-old         = classif-fisc.log-1
           tg-is                  = IF SUBSTRING(classif-fisc.char-1,84,1) = "S" THEN TRUE ELSE FALSE.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  IF RETURN-VALUE = 'ADM-ERROR':U THEN
    RETURN 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */
  IF i-pais-impto-usuario = 1 THEN
      ASSIGN OVERLAY(classif-fisc.char-2,2,2)  = c-unid-tribut
             l-is-alterado                     = (tg-is <> (SUBSTRING(classif-fisc.char-1, 84, 1) = "S"))
             OVERLAY(classif-fisc.char-1,84,1) = IF tg-is THEN "S" ELSE "N".
             
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
  
  IF i-pais-impto-usuario = 1 THEN
      ASSIGN c-unid-tribut:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

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

  find first tab-unidade where 
             tab-unidade.un = 
             input frame {&frame-name} classif-fisc.unidade no-lock no-error.

  if  avail tab-unidade then
      assign c-descricao:screen-value in frame {&frame-name} = tab-unidade.descricao.    

  if i-pais-impto-usuario <> 1 then
      assign classif-fisc.aliquota-ipi:hidden in frame {&FRAME-NAME} = YES 
             classif-fisc.log-1       :hidden in frame {&FRAME-NAME} = YES
             tg-is                    :HIDDEN IN FRAME {&FRAME-NAME} = YES.

  IF i-pais-impto-usuario = 1 THEN DO:
      ASSIGN c-unid-tribut:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF AVAIL classif-fisc THEN SUBSTRING(classif-fisc.char-2,2,2) ELSE ""
             tg-is        :CHECKED      IN FRAME {&FRAME-NAME} = IF SUBSTRING(classif-fisc.char-1,84,1) = "S" THEN TRUE ELSE FALSE.
             
      APPLY "LEAVE" TO c-unid-tribut IN FRAME {&FRAME-NAME}.
  END.

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
  /* Dispatch standard ADM method. 

  run get-attribute ('adm-new-record').
                              */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  IF adm-new-record = YES THEN
      &if  defined(ADM-MODIFY-FIELDS) &then
          enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
      &endif
      
  if i-pais-impto-usuario <> 1 then
      assign classif-fisc.aliquota-ipi:sensitive in frame {&FRAME-NAME} = NO
             classif-fisc.log-1       :sensitive in frame {&FRAME-NAME} = NO
             tg-is                    :SENSITIVE IN FRAME {&FRAME-NAME} = NO.

  IF i-pais-impto-usuario = 1 THEN
      ASSIGN c-unid-tribut:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

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
  define buffer b-item     for item.
  define buffer b-ped-item for ped-item.
  &IF  "{&bf_mat_versao_ems}" >= "2.06" &then
       define buffer b-item-mat for item-mat.
  &endif

  define variable i-cont    as integer no-undo.
  define variable i-cont2   as integer no-undo.
  define variable i-exporta as integer no-undo.
  define variable l-aberto  as logical no-undo.
  define variable l-parcial as logical no-undo.
  define variable l-penden  as logical no-undo.

  define variable i-cont-inicio as integer no-undo.
  define variable i-cont-final  as integer no-undo.
  define variable h-acomp       as handle  no-undo.
  define variable i-time        as int no-undo.

  DEF VAR h-bo-ped-venda-cal AS HANDLE NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN get-attribute ('ADM-NEW-RECORD').

  if  return-value = "no" then do:

      /* reforma - alterou parametro de IS em tela, abre tela para replicar para os itens que usam essa class fiscal */
      IF l-is-alterado THEN
          RUN cdp/cd0603k1.w (INPUT classif-fisc.class-fiscal).

      IF  classif-fisc.aliquota-ipi <> de-aliquota-ipi-old then do:

          run cdp/cd0603a.w (output i-exporta, output l-aberto, output l-parcial).

          if  i-exporta = 1 or i-exporta = 2 then do:

              session:set-wait-state("general").

              run utp/ut-acomp.p persistent set h-acomp.

              {utp/ut-liter.i Exportaá∆o_dados_para_items *}
              run pi-inicializar in h-acomp (input  Return-value ).

              for each w-pedido exclusive-lock:
                 delete w-pedido.
              end.            

              &IF  "{&bf_mat_versao_ems}" >= "2.04" &THEN 
                   IF  NOT VALID-HANDLE(h-bo-ped-venda-cal)
                   OR  h-bo-ped-venda-cal:TYPE <> "PROCEDURE":U
                   OR  h-bo-ped-venda-cal:FILE-NAME <> "dibo/bodi159cal.p" THEN
                       RUN dibo/bodi159cal.p PERSISTENT SET h-bo-ped-venda-cal.
                   RUN setaInstanciaHandles IN h-bo-ped-venda-cal.
                   RUN inicializaHandles    IN h-bo-ped-venda-cal.
              &ENDIF

              if  i-exporta = 1 then do:             

                  for each b-item use-index class-fiscal where b-item.class-fiscal = classif-fisc.class-fiscal no-lock:

                      if  time - i-time > 0 then do:
                          {utp/ut-liter.i Item.: *}
                          run pi-acompanhar in h-acomp ( Return-value  + b-item.it-codigo). 
                          assign i-time = time.
                      end.

                      find item where rowid(item) = rowid(b-item) EXCLUSIVE-LOCK NO-ERROR.

                      assign item.aliquota-ipi = classif-fisc.aliquota-ipi.

                      if  l-aberto or l-parcial  then do:
                          /* gravar aliquota de ipi nos pedidos */
                          {cdp/cd0603.i1 " "}                               
                      end.

                  end.

                  /* recalcular o valor dos pedidos */
                  for each w-pedido exclusive-lock:

                      find ped-venda 
                           where ped-venda.nome-abrev = w-pedido.nome-abrev 
                           and   ped-venda.nr-pedcli = w-pedido.nr-pedcli EXCLUSIVE-LOCK NO-ERROR.

                      if  time - i-time > 0 then do:
                          {utp/ut-liter.i Recalculando_Pedido.: *}
                          run pi-acompanhar in h-acomp ( Return-value  + ped-venda.nome-abrev + "/":U + ped-venda.nr-pedcli). 
                          assign i-time = time.
                      end.

                      &IF  "{&bf_mat_versao_ems}" >= "2.04" &THEN 
                           RUN CalculateOrder       IN h-bo-ped-venda-cal (INPUT ROWID(ped-venda)).
                           RUN SetaInstanciaHandles IN h-bo-ped-venda-cal.
                      &ELSE
                          run cdp/cd4323a.p (input rowid(ped-venda),
                                             input yes,
                                             input i-pais-impto-usuario).
                      &ENDIF

                      delete w-pedido.
                  end.
              end.

              if  i-exporta = 2 then do:
                  for each item use-index class-fiscal 
                           where item.class-fiscal = classif-fisc.class-fiscal 
                           AND   item.aliquota-ipi = de-aliquota-ipi-old exclusive-lock:

                     if  time - i-time > 0 then do:
                         {utp/ut-liter.i Item.: *}
                         run pi-acompanhar in h-acomp ( Return-value  + item.it-codigo). 
                         assign i-time = time.
                     end.

                     assign item.aliquota-ipi = classif-fisc.aliquota-ipi.   

                     if  l-aberto or l-parcial then do:
                         {cdp/cd0603.i1 "and ped-item.aliquota-ipi = de-aliquota-ipi-old"} 
                     end.

                  end.

                  /* recalcular o valor dos pedidos */
                  for each w-pedido exclusive-lock:

                      find ped-venda 
                           where ped-venda.nome-abrev = w-pedido.nome-abrev 
                           AND   ped-venda.nr-pedcli  = w-pedido.nr-pedcli EXCLUSIVE-LOCK NO-ERROR.

                      if  time - i-time > 0 then do:
                          {utp/ut-liter.i Recalculando_Pedido.: *}
                          run pi-acompanhar in h-acomp ( Return-value  + ped-venda.nome-abrev + "/":U + ped-venda.nr-pedcli). 
                          assign i-time = time.
                      end.

                      &IF  "{&bf_mat_versao_ems}" >= "2.04" &THEN 
                           RUN CalculateOrder IN h-bo-ped-venda-cal (INPUT ROWID(ped-venda)).
                      &ELSE
                          run cdp/cd4323a.p (input rowid(ped-venda),
                                             input yes,
                                             input i-pais-impto-usuario).
                      &ENDIF

                      delete w-pedido.
                  end.
              end.

              &IF  "{&bf_mat_versao_ems}" >= "2.04" &THEN 
                   RUN FinalizaHandles IN h-bo-ped-venda-cal.
                   DELETE PROCEDURE h-bo-ped-venda-cal.
              &ENDIF

              run pi-finalizar in h-acomp.
              session:set-wait-state("").

        end.
    end.

    IF de-aliquota-pis-old    <> classif-fisc.dec-1
    OR de-aliquota-cofins-old <> classif-fisc.dec-2
    OR de-reducao-pis-old     <> classif-fisc.int-1 / 100
    OR de-reducao-cofins-old  <> classif-fisc.int-2 / 100 
    OR l-susp-ipi-old         <> classif-fisc.log-1
    OR
        &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN
            (l-atualizou-valores-ext                                         AND
            (ROUND(de-val-pis-externo-old,2)    <> classif-fisc.val-aliq-ext-pis      OR
             ROUND(de-val-cofins-externo-old,2) <> classif-fisc.val-aliq-ext-cofins   OR
             de-val-pis-externo-old             <> DEC(SUBSTR(classif-fisc.char-1,85,9)) OR
             de-val-cofins-externo-old          <> DEC(SUBSTR(classif-fisc.char-1,94,9)) ))
        &ELSE
            (l-atualizou-valores-ext                                                       AND
            (de-val-pis-externo-old    <> DECIMAL(SUBSTRING(classif-fisc.char-1,31,06))    OR
             de-val-cofins-externo-old <> DECIMAL(SUBSTRING(classif-fisc.char-1,37,06)) ))
        &ENDIF
        THEN DO:

        run cdp/cd0603c.w (output i-exporta).

        if i-exporta = 1 or i-exporta = 2 then do:
           if session:set-wait-state("general") then.

           run utp/ut-acomp.p persistent set h-acomp.
           {utp/ut-liter.i Exportaá∆o_dados_para_items *}
           run pi-inicializar in h-acomp (input  Return-value ).

           if i-exporta = 1 then do:             
              for each b-item use-index class-fiscal where b-item.class-fiscal = classif-fisc.class-fiscal no-lock:
                  if  time - i-time > 0 then do:
                     {utp/ut-liter.i Item.: *}
                     run pi-acompanhar in h-acomp ( Return-value  + b-item.it-codigo). 
                     assign i-time = time.
                 end.
                 find item where rowid(item) = rowid(b-item) EXCLUSIVE-LOCK NO-ERROR.
                 &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN
                    find item-mat where item-mat.it-codigo = b-item.it-codigo EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAIL item-mat THEN DO:
                       ASSIGN  item-mat.val-aliq-ext-pis        = classif-fisc.val-aliq-ext-pis
                               item-mat.val-aliq-ext-cofins     = classif-fisc.val-aliq-ext-cofins
                               OVERLAY(item-mat.char-1,247,9)   = SUBSTR(classif-fisc.char-1,85,9) /* PIS com 4 decimais */
                               OVERLAY(item-mat.char-1,256,9)   = SUBSTR(classif-fisc.char-1,94,9) /* COFINS com 4 decimais */
                               item-mat.val-reduc-pis-normal    = classif-fisc.int-1 / 100
                               item-mat.val-reduc-cofins-normal = classif-fisc.int-2 / 100.

                    END.
                    IF AVAIL ITEM THEN
                    ASSIGN substr(item.char-2,31,5) = string(classif-fisc.dec-1,"99.99")  
                           substr(item.char-2,36,5) = string(classif-fisc.dec-2,"99.99")
                           substr(item.char-2,51,1) = IF classif-fisc.log-1 THEN "2" ELSE "1"
                           substr(item.char-2,41,5) = string(classif-fisc.int-1 / 100,"99.99")
                           substr(item.char-2,46,5) = string(classif-fisc.int-2 / 100,"99.99").
                 &ELSE
                     assign substr(item.char-2,31,5) = string(classif-fisc.dec-1,"99.99")  
                            substr(item.char-2,36,5) = string(classif-fisc.dec-2,"99.99")
                            substr(item.char-2,41,5) = string(classif-fisc.int-1 / 100,"99.99")
                            substr(item.char-2,46,5) = string(classif-fisc.int-2 / 100,"99.99")
                            substr(item.char-2,51,1) = IF classif-fisc.log-1 THEN "2" ELSE "1"
                            OVERLAY(item.char-1,217,006) = STRING(SUBSTRING(classif-fisc.char-1,31,06))
                            OVERLAY(item.char-1,223,006) = STRING(SUBSTRING(classif-fisc.char-1,37,06)).
                  &ENDIF
                  
                  RUN grava-aliquotas IN h-cdapi995 (INPUT "item",
                                                     INPUT item.it-codigo,
                                                     INPUT classif-fisc.dec-1,
                                                     INPUT classif-fisc.dec-2).                  
              end.
           end.
           ELSE 
           if i-exporta = 2 then do:

                for each b-item use-index class-fiscal
                    where b-item.class-fiscal = classif-fisc.class-fiscal
                    no-lock:

                    &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN
                        FIND FIRST b-item-mat NO-LOCK
                             WHERE b-item-mat.it-codigo = b-item.it-codigo NO-ERROR.
                    &ENDIF

                    if  time - i-time > 0 then do:
                        {utp/ut-liter.i Item.: *}
                        run pi-acompanhar in h-acomp ( Return-value  + b-item.it-codigo). 
                        assign i-time = time.
                    end.

                    IF  DECIMAL(SUBSTRING(b-item.char-2,31,5)) = de-aliquota-pis-old              OR
                        DECIMAL(SUBSTRING(b-item.char-2,36,5)) = de-aliquota-cofins-old           OR
                        (SUBSTRING(b-item.char-2,51,1) = "2")  = l-susp-ipi-old                   OR
                        &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN
                            DECIMAL(SUBSTRING(b-item.char-2,41,5)) = de-reducao-pis-old           OR
                            DECIMAL(SUBSTRING(b-item.char-2,46,5)) = de-reducao-cofins-old        OR
                            (AVAIL b-item-mat AND b-item-mat.val-aliq-ext-pis          = ROUND(de-val-pis-externo-old,2))    OR
                            (AVAIL b-item-mat AND b-item-mat.val-aliq-ext-cofins       = ROUND(de-val-cofins-externo-old,2)) OR
                            (AVAIL b-item-mat AND DEC(SUBSTR(b-item-mat.char-1,247,9)) = de-val-pis-externo-old)             OR
                            (AVAIL b-item-mat AND DEC(SUBSTR(b-item-mat.char-1,256,9)) = de-val-cofins-externo-old)
                        &ELSE
                            DECIMAL(SUBSTRING(b-item.char-2,41,5))                   = de-reducao-pis-old           OR
                            DECIMAL(SUBSTRING(b-item.char-2,46,5))                   = de-reducao-cofins-old        OR
                            DECIMAL(SUBSTRING(b-item.char-1,217,006))                = de-val-pis-externo-old       OR
                            DECIMAL(SUBSTRING(b-item.char-1,223,006))                = de-val-cofins-externo-old
                        &ENDIF
                        THEN DO:

                        FIND FIRST item 
                            WHERE ROWID(item) = ROWID(b-item) EXCLUSIVE-LOCK NO-ERROR.
                        &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN
                            FIND FIRST item-mat
                                WHERE item-mat.it-codigo = ITEM.it-codigo EXCLUSIVE-LOCK NO-ERROR.
                        &ENDIF

                        IF  DECIMAL(SUBSTRING(b-item.char-2,31,5)) = de-aliquota-pis-old THEN DO:
                            ASSIGN SUBSTRING(item.char-2,31,5) = STRING(classif-fisc.dec-1,"99.99").
                            RUN grava-aliquotas IN h-cdapi995 (INPUT "item",
                                                           INPUT item.it-codigo,
                                                           INPUT classif-fisc.dec-1,
                                                           INPUT DECIMAL(SUBSTRING(b-item.char-2,36,5))).

                        END.

                        IF  DECIMAL(SUBSTRING(b-item.char-2,36,5)) = de-aliquota-cofins-old THEN DO:
                            ASSIGN SUBSTRING(item.char-2,36,5) = STRING(classif-fisc.dec-2,"99.99").
                            
                            RUN grava-aliquotas IN h-cdapi995 (INPUT "item",
                                                               INPUT item.it-codigo,
                                                               INPUT DECIMAL(SUBSTRING(b-item.char-2,31,5)),
                                                               INPUT classif-fisc.dec-2).
                        END.

                        IF DECIMAL(SUBSTRING(b-item.char-2,41,5)) = de-reducao-pis-old THEN
                            ASSIGN SUBSTRING(item.char-2,41,5) = STRING(classif-fisc.int-1 / 100,"99.99").

                        IF DECIMAL(SUBSTRING(b-item.char-2,46,5)) = de-reducao-cofins-old THEN
                            ASSIGN SUBSTRING(item.char-2,46,5) = STRING(classif-fisc.int-2 / 100,"99.99").

                        IF (SUBSTRING(b-item.char-2,51,1) = "2") =  l-susp-ipi-old THEN
                            ASSIGN SUBSTRING(item.char-2,51,1) = IF classif-fisc.log-1 THEN "2" ELSE "1".

                        &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN
                            IF AVAIL b-item-mat  THEN DO:
                            
                                IF  b-item-mat.val-aliq-ext-pis = ROUND(de-val-pis-externo-old,2) THEN
                                    ASSIGN item-mat.val-aliq-ext-pis = classif-fisc.val-aliq-ext-pis.
    
                                IF  DEC(SUBSTR(b-item-mat.char-1,247,9)) = de-val-pis-externo-old THEN /* PIS com 4 decimais */
                                    ASSIGN OVERLAY(item-mat.char-1,247,9) = SUBSTR(classif-fisc.char-1,85,9).
                                    
                                IF  b-item-mat.val-aliq-ext-cofins = ROUND(de-val-cofins-externo-old,2) THEN
                                    ASSIGN item-mat.val-aliq-ext-cofins = classif-fisc.val-aliq-ext-cofins.
    
                                IF  DEC(SUBSTR(b-item-mat.char-1,256,9)) = de-val-cofins-externo-old THEN /* COFINS com 4 decimais */
                                    ASSIGN OVERLAY(item-mat.char-1,256,9) = SUBSTR(classif-fisc.char-1,94,9).
                                    
                                IF  b-item-mat.val-reduc-pis-normal = de-reducao-pis-old THEN
                                    ASSIGN item-mat.val-reduc-pis-normal = classif-fisc.int-1 / 100.
    
                                IF  b-item-mat.val-reduc-cofins-normal = de-aliquota-cofins-old THEN
                                    ASSIGN item-mat.val-reduc-cofins-normal = classif-fisc.int-2 / 100.
                            END.
                        &ELSE
                            IF  DECIMAL(SUBSTRING(b-item.char-1,217,006)) = de-val-pis-externo-old THEN
                                ASSIGN OVERLAY(item.char-1,217,006) = STRING(SUBSTRING(classif-fisc.char-1,31,06)).

                            IF  DECIMAL(SUBSTRING(b-item.char-1,223,006)) = de-val-cofins-externo-old THEN
                                ASSIGN OVERLAY(item.char-1,223,006) = STRING(SUBSTRING(classif-fisc.char-1,37,06)).
                        &ENDIF
  
                    END.
                END.
           end.
           run pi-finalizar in h-acomp.
           if session:set-wait-state("") then.
        end.
    END.
  end.

  ASSIGN l-atualizou-valores-ext = NO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

  IF NOT VALID-HANDLE (h-cdapi995) THEN
      RUN cdp\cdapi995.p PERSISTENT SET h-cdapi995.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  assign classif-fisc.unidade:format in frame {&frame-name} = "x(2)".
  
  /* Integracao Modulo Importacao */
  find first param-global no-lock no-error.

  /* Code placed here will execute AFTER standard behavior.    */

  ASSIGN c-unid-tribut:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  IF i-pais-impto-usuario <> 1 THEN
      ASSIGN c-unid-tribut:HIDDEN IN FRAME {&FRAME-NAME} = TRUE
             c-descricao-unid:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.

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


  if input frame {&frame-name} classif-fisc.unidade <> "" then do:
     find first tab-unidade where tab-unidade.un = input frame {&frame-name} classif-fisc.unidade no-lock no-error.
     if not avail tab-unidade then do:
        {include/i-vldprg.i} 
        {utp/ut-table.i mgind tab-unidade 1}
        run utp/ut-msgs.p (input "show",
                           input 56,
                           input return-value).     
        apply 'entry' to classif-fisc.unidade in frame {&frame-name}.
        return 'ADM-ERROR':U.
     end.   
  end.  


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
  {src/adm/template/snd-list.i "classif-fisc"}

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

