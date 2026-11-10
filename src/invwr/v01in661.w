&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V01IN661 2.00.00.007 } /*** "010007" ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01in661 MUT}
&ENDIF

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
def var h-v05in661   as handle.
DEF VAR h-boin863    AS HANDLE NO-UNDO.
DEF VAR v_hdl_cenar  as handle no-undo.
DEF VAR hShowMsg     AS HANDLE NO-UNDO.
DEF VAR l-ifrs-contab-estoq AS LOGICAL NO-UNDO.
DEF VAR lIntegracaoEMS5     AS LOGICAL NO-UNDO.
DEF VAR l-conectou-ems5     AS LOGICAL NO-UNDO.
DEF VAR i-estab-copia AS CHAR NO-UNDO.

{cdp/cdcfgmat.i}
{inbo/boin863.i tt-estab-mater-cenar}
{inbo/boin863.i tt-estab-mater-cenar-aux}
{btb/btb009za.i}
{cdp/cd9043.i} /* Definiá∆o da tabela de erros RowErros */

/*Temp-table EMS5 - Retorna cen†rios cont†beis v†lidos*/
def temp-table tt_cenar_ctbl_ems5 no-undo
         field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
         field tta_des_cenar_ctbl               as character format "x(40)" label "Descriá∆o" column-label "Descriá∆o"
         field tta_log_cenar_ifrs               as logical format "Sim/N∆o" initial no label "Cen†rio IFRS" column-label "Cen†rio IFRS"
         field tta_log_cenar_fisc               as logical format "Sim/N∆o" initial no label "Cen†rio Fiscal" column-label "Cen†rio Fiscal"
         field ttv_log_permis_cenar_usuar       as logical format "Sim/N∆o" initial no
        .
def temp-table tt_erro_fgl no-undo
         field ttv_num_erro_fgl                 as integer format "9999999"
         field ttv_des_erro_fgl                 as character format "x(100)"
         field ttv_des_arq_erro                 as character format "x(100)"
         field ttv_log_ctbz                     as logical format "Sim/N∆o" initial yes label "Contabiliza Movto" column-label "Contabiliza Movto"
            .

def buffer b-estab-mat for estab-mat.
def buffer b-estab-mat-ger for estab-mat.
def buffer b-estab-mater-cenar for estab-mater-cenar.

/*Funá∆o IFRS*/
  assign l-ifrs-contab-estoq = yes
  
  /*Integraá∆o Contabilidade EMS5*/
         lIntegracaoEMS5 =  CAN-FIND(first funcao 
                                     WHERE funcao.cd-funcao = "adm-fgl-ems-5.00"
                                       AND funcao.ativo = YES
                                       AND funcao.log-1 = YES).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES estab-mat
&Scoped-define FIRST-EXTERNAL-TABLE estab-mat


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estab-mat.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS estab-mat.char-2 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}char-2 ~{&FP2}char-2 ~{&FP3}
&Scoped-define ENABLED-TABLES estab-mat
&Scoped-define FIRST-ENABLED-TABLE estab-mat
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS estab-mat.cod-estabel ~
estab-mat.cod-estabel-prin estab-mat.char-2 
&Scoped-Define DISPLAYED-OBJECTS c-desc-estab-pad c-desc-estab-prin 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS estab-mat.cod-estabel ~
estab-mat.cod-estabel-prin 

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
DEFINE VARIABLE c-desc-estab-pad AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estab-prin AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 94.57 BY 2.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     estab-mat.cod-estabel AT ROW 1.25 COL 25.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-desc-estab-pad AT ROW 1.25 COL 32.86 COLON-ALIGNED NO-LABEL
     estab-mat.cod-estabel-prin AT ROW 2.25 COL 25.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-desc-estab-prin AT ROW 2.25 COL 32.86 COLON-ALIGNED NO-LABEL
     estab-mat.char-2 AT ROW 3.13 COL 1 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 1 BY .25
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.estab-mat
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
         HEIGHT             = 2.38
         WIDTH              = 88.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-estab-pad IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-estab-prin IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estab-mat.char-2 IN FRAME f-main
   ALIGN-L                                                              */
ASSIGN 
       estab-mat.char-2:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN estab-mat.cod-estabel IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN estab-mat.cod-estabel-prin IN FRAME f-main
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

&Scoped-define SELF-NAME estab-mat.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-estabel V-table-Win
ON F5 OF estab-mat.cod-estabel IN FRAME f-main /* Estabelecimento Padr∆o */
DO:

    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                       &campo=estab-mat.cod-estabel
                       &campozoom=cod-estabel}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-estabel V-table-Win
ON LEAVE OF estab-mat.cod-estabel IN FRAME f-main /* Estabelecimento Padr∆o */
DO:

    {include/leave.i &tabela=estabelec
                     &atributo-ref=nome
                     &variavel-ref=c-desc-estab-pad
                     &where="estabelec.cod-estabel = input frame {&frame-name}
                             estab-mat.cod-estabel"}
  
    
    if valid-handle(h-v05in661) then
       run pi-habilita-campos in h-v05in661 (input input frame {&FRAME-NAME} 
                                                   estab-mat.cod-estabel).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estab-mat.cod-estabel IN FRAME f-main /* Estabelecimento Padr∆o */
DO:

    apply "F5" to self.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estab-mat.cod-estabel-prin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-estabel-prin V-table-Win
ON F5 OF estab-mat.cod-estabel-prin IN FRAME f-main /* Estab Principal */
DO:

    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                       &campo=estab-mat.cod-estabel-prin
                       &campozoom=cod-estabel}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-estabel-prin V-table-Win
ON LEAVE OF estab-mat.cod-estabel-prin IN FRAME f-main /* Estab Principal */
DO:

    {include/leave.i &tabela=estabelec
                     &atributo-ref=nome
                     &variavel-ref=c-desc-estab-prin
                     &where="estabelec.cod-estabel = input frame {&frame-name}
                             estab-mat.cod-estabel-prin"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.cod-estabel-prin V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estab-mat.cod-estabel-prin IN FRAME f-main /* Estab Principal */
DO:

    apply "F5" to self.
      
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

    if estab-mat.cod-estabel:load-mouse-pointer("image/lupa.cur") then .
    if estab-mat.cod-estabel-prin:load-mouse-pointer("image/lupa.cur") then .

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
  {src/adm/template/row-list.i "estab-mat"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "estab-mat"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  ASSIGN i-estab-copia = input frame {&frame-name} estab-mat.cod-estabel.


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
    
    /* Ponha na pi-validate todas as validaá‰es */
    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    IF i-estab-copia <> "" THEN DO:
        find first b-estab-mat WHERE b-estab-mat.cod-estabel = i-estab-copia NO-LOCK NO-ERROR.
        FIND FIRST b-estab-mat-ger WHERE  b-estab-mat-ger.cod-estabel = input frame {&frame-name} estab-mat.cod-estabel EXCLUSIVE-LOCK NO-ERROR.
        ASSIGN b-estab-mat-ger.dat-fechto-geren     = b-estab-mat.dat-fechto-geren    
               b-estab-mat-ger.num-ult-fechto-geren = b-estab-mat.num-ult-fechto-geren
               b-estab-mat-ger.dat-mensal-geren     = b-estab-mat.dat-mensal-geren    
               b-estab-mat-ger.dat-sumar-geren      = b-estab-mat.dat-sumar-geren     
               b-estab-mat-ger.dat-ctbl-geren       = b-estab-mat.dat-ctbl-geren
               i-estab-copia                  = "".
    END.
    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */
     IF l-ifrs-contab-estoq AND lIntegracaoEMS5 THEN DO:
         FIND FIRST param-estoq NO-LOCK NO-ERROR.
         find first b-estab-mat 
              WHERE b-estab-mat.cod-estabel = param-estoq.estabel-pad no-lock no-error.
         IF AVAIL b-estab-mat THEN DO:
            FOR EACH estab-mater-cenar 
               WHERE estab-mater-cenar.cod-estab = b-estab-mat.cod-estabel NO-LOCK:
                IF NOT CAN-FIND (FIRST b-estab-mater-cenar 
                                 WHERE b-estab-mater-cenar.cod-estab      = estab-mat.cod-estabel
                                   AND b-estab-mater-cenar.cod-cenar-ctbl = estab-mater-cenar.cod-cenar-ctbl) THEN DO:
                    CREATE b-estab-mater-cenar.
                    ASSIGN b-estab-mater-cenar.cod-estab = estab-mat.cod-estabel.
                    BUFFER-COPY estab-mater-cenar EXCEPT cod-estab TO b-estab-mater-cenar NO-ERROR.
                END.
            END.
         END.
         ELSE DO:
             Run  pi-conecta-ems50( 1). /*Conecta bancos EMS5*/
             IF RETURN-VALUE = "NOK":U THEN
                 RETURN "adm-error".
             ELSE DO:
                 run prgfin/fgl/fgl920za.py persistent set v_hdl_cenar.
            
                 run  pi_main_retorna_cenar_ctbl_empres_1 in v_hdl_cenar(input i-ep-codigo-usuario,
                                                                     input today,
                                                                     output table tt_cenar_ctbl_ems5,
                                                                     output table tt_erro_fgl).
                 delete procedure v_hdl_cenar.
                 assign v_hdl_cenar = ?.
                
                 RUN pi-cria-estab-mater-cenar.
             END.
             IF l-conectou-ems5 THEN
                 Run  pi-conecta-ems50( 2). /*Desconecta bancos EMS5*/
         END.
     END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-estab-mater-cenar V-table-Win 
PROCEDURE pi-cria-estab-mater-cenar :
/*------------------------------------------------------------------------------
  Purpose:    Cria relacionamento Estab X Cen†rio
  Notes:       
------------------------------------------------------------------------------*/
   
FIND FIRST param-estoq NO-LOCK NO-ERROR.

EMPTY TEMP-TABLE tt-estab-mater-cenar.
FOR EACH tt_cenar_ctbl_ems5 
   WHERE tt_cenar_ctbl_ems5.tta_log_cenar_ifrs 
      OR tt_cenar_ctbl_ems5.tta_log_cenar_fisc:
   
   CREATE tt-estab-mater-cenar.
   ASSIGN tt-estab-mater-cenar.cod-estab      = estab-mat.cod-estabel
          tt-estab-mater-cenar.cod-cenar-ctbl = tt_cenar_ctbl_ems5.tta_cod_cenar_ctbl
          tt-estab-mater-cenar.log-cenar-fisc = tt_cenar_ctbl_ems5.tta_log_cenar_fisc
          tt-estab-mater-cenar.log-cenar-ifrs = tt_cenar_ctbl_ems5.tta_log_cenar_ifrs.

   &if "{&bf_mat_versao_ems}" < "2.09" &THEN
       IF SUBSTRING(param-estoq.char-2,10,8) = tt_cenar_ctbl_ems5.tta_cod_cenar_ctbl and
          SUBSTRING(param-estoq.char-2,8,1) = "S":U THEN
            ASSIGN tt-estab-mater-cenar.cdn-moeda = 1.
       ELSE IF SUBSTRING(param-estoq.char-2,18,8) = tt_cenar_ctbl_ems5.tta_cod_cenar_ctbl and
          SUBSTRING(param-estoq.char-2,9,1) = "S":U THEN
            ASSIGN tt-estab-mater-cenar.cdn-moeda = 2.
   &else
       IF param-estoq.cod-cenar-ifrs-1 = tt_cenar_ctbl_ems5.tta_cod_cenar_ctbl and
          param-estoq.log-moed-ifrs-1 THEN
           ASSIGN tt-estab-mater-cenar.cdn-moeda = 1.
       ELSE IF param-estoq.cod-cenar-ifrs-2 = tt_cenar_ctbl_ems5.tta_cod_cenar_ctbl and
          param-estoq.log-moed-ifrs-2 THEN
           ASSIGN tt-estab-mater-cenar.cdn-moeda = 2.
   &endif
   ELSE
       ASSIGN tt-estab-mater-cenar.cdn-moeda = 0.

   IF param-estoq.tp-fech = 2 THEN /*Fechamento por Estabelecimento*/
       ASSIGN tt-estab-mater-cenar.contab-ate = estab-mat.contab-ate.
   ELSE
       ASSIGN tt-estab-mater-cenar.contab-ate = param-estoq.contab-ate.
END.

IF CAN-FIND (FIRST tt-estab-mater-cenar) THEN DO:
    if  not valid-handle (h-boin863) then
        run inbo/boin863.p persistent set h-boin863.

    FOR EACH tt-estab-mater-cenar:
        EMPTY TEMP-TABLE tt-estab-mater-cenar-aux.

        CREATE tt-estab-mater-cenar-aux.
        BUFFER-COPY tt-estab-mater-cenar TO tt-estab-mater-cenar-aux NO-ERROR.

        RUN openQueryStatic IN h-boin863 (INPUT "Main":U).
        RUN goToKey         IN h-boin863 (INPUT tt-estab-mater-cenar-aux.cod-estab, 
                                          INPUT tt-estab-mater-cenar-aux.cod-cenar-ctbl).
        IF RETURN-VALUE = "NOK":U THEN DO:
            run emptyRowErrors in h-boin863.
            run setRecord in h-boin863 (input table tt-estab-mater-cenar-aux).
            		
            run createRecord in h-boin863.
            if  return-value = "NOK" then
            	run getRowErrors in h-boin863 (output table RowErrors append).
            IF CAN-FIND(FIRST RowErrors) THEN DO:
                {method/showmessage.i1}
                {method/showmessage.i2 &modal="YES"}
                {method/showmessage.i3}
                RUN destroy IN h-boin863.
                UNDO, RETURN "ADM-ERROR":U.
            END.
        END.
    END.
    
    EMPTY TEMP-TABLE tt-estab-mater-cenar.

    if  valid-handle (h-boin863) then do:
        delete procedure h-boin863.
        assign h-boin863 = ?.
    end.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  def var c-table-label as char format "x(40)".
  def var c-table-relac as char format "x(40)".

  /* Code placed here will execute PRIOR to standard behavior. */
  {utp/ut-table.i mgind estab-mat 1}
  assign c-table-label = return-value.

  if can-find(first pedido-compr use-index end-entrega
              where pedido-compr.end-entrega = estab-mat.cod-estabel)
  or can-find(first pedido-compr use-index end-cobranca
              where pedido-compr.end-cobranca = estab-mat.cod-estabel) then do:
     {utp/ut-table.i mgind pedido-compr 1} 
     assign c-table-relac = return-value.
 
     run utp/ut-msgs.p (input "show":U,
                        input 5,
                        input c-table-label + "~~" + c-table-relac).
     return "adm-error".
  End.

  if can-find(first ped-venda use-index ch-estcli
              where ped-venda.cod-estabel = estab-mat.cod-estabel) then do:
     {utp/ut-table.i mgdis ped-venda 1} 
     assign c-table-relac = return-value.
 
     run utp/ut-msgs.p (input "show":U,
                        input 5,
                        input c-table-label + "~~" + c-table-relac).
     return "adm-error".
  End. 
 
  if can-find(first estab-cli use-index ch-estcli
              where estab-cli.cod-estabel = estab-mat.cod-estabel) then do:
     {utp/ut-table.i mgdis estab-cli 1} 
     assign c-table-relac = return-value.
 
     run utp/ut-msgs.p (input "show":U,
                        input 5,
                        input c-table-label + "~~" + c-table-relac).
     return "adm-error".
  End.  
 
  if can-find(first nota-fiscal where
                    nota-fiscal.cod-estabel = estab-mat.cod-estabel) then do:
     {utp/ut-table.i mgdis nota-fiscal 1} 
     assign c-table-relac = return-value.
  
     run utp/ut-msgs.p (input "show":U,
                        input 6,
                        input c-table-label + "~~" + c-table-relac).
     return "adm-error".
  End. 
  
  if can-find(first item-estab where
                    item-estab.cod-estabel = estab-mat.cod-estabel) then do:
     {utp/ut-table.i mgind item-estab 1} 
     assign c-table-relac = return-value.
  
     run utp/ut-msgs.p (input "show":U,
                        input 6,
                        input c-table-label + "~~" + c-table-relac).
     return "adm-error".
  End.

  if can-find(first item-uni-estab where
                    item-uni-estab.cod-estabel = estab-mat.cod-estabel) then do:
     {utp/ut-table.i mgind item-uni-estab 1} 
     assign c-table-relac = return-value.
  
     run utp/ut-msgs.p (input "show":U,
                        input 6,
                        input c-table-label + "~~" + c-table-relac).
     return "adm-error".
  End.
  IF l-ifrs-contab-estoq AND lIntegracaoEMS5 THEN
      FOR EACH estab-mater-cenar 
         WHERE estab-mater-cenar.cod-estab = estab-mat.cod-estabel EXCLUSIVE-LOCK:
          DELETE estab-mater-cenar.
      END.
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

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    if available estab-mat then do with frame {&frame-name}:
        find estabelec where
            estabelec.cod-estabel = estab-mat.cod-estabel 
            no-lock no-error.
        assign c-desc-estab-pad:screen-value = if available estabelec then
                                               estabelec.nome else
                                               "":U.
        find estabelec where
            estabelec.cod-estabel = estab-mat.cod-estabel-prin
            no-lock no-error.
        assign c-desc-estab-prin:screen-value = if available estabelec then
                                                estabelec.nome else
                                                "":U.                                               
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
    if adm-new-record = yes THEN DO:
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.     
    END.
    &endif
    
    if adm-new-record = yes THEN
        run new-state ('desabilita-bt-gerencial':U).
    ELSE
        run new-state ('habilita-bt-gerencial':U).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-get-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output parameter p-cod-estabel      AS CHAR FORMAT "X(5)".
    def output parameter p-cod-estabel-prin AS CHAR FORMAT "X(5)".
    
    IF AVAIL estab-mat THEN
        assign p-cod-estabel      = estab-mat.cod-estabel
               p-cod-estabel-prin = estab-mat.cod-estabel-prin.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-handle V-table-Win 
PROCEDURE pi-recebe-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-handle as handle.

assign h-v05in661 = p-handle.


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

    find estabelec where
        estabelec.cod-estabel = input frame {&frame-name} estab-mat.cod-estabel
        no-lock no-error.
    if not available estabelec then do:        
        {include/i-vldprg.i}
        {utp/ut-liter.i Padr∆o * r}
        run utp/ut-msgs.p (input "show", input 13, input return-value).
        apply "entry" to estab-mat.cod-estabel in frame {&frame-name}.
        return "adm-error".
    end.        

    find estabelec where
        estabelec.cod-estabel = input frame {&frame-name} estab-mat.cod-estabel-prin
        no-lock no-error.
    if not available estabelec then do:        
        {include/i-vldprg.i}
        {utp/ut-liter.i Principal * r}
        run utp/ut-msgs.p (input "show", input 13, input return-value).
        apply "entry" to estab-mat.cod-estabel-prin in frame {&frame-name}.
        return "adm-error".
    end.        

    if adm-new-record then do:

        find first b-estab-mat where
            b-estab-mat.cod-estabel      = input frame {&frame-name} estab-mat.cod-estabel
            no-lock no-error.
        if available b-estab-mat then do:    
            {utp/ut-table.i mgind estab-mat 1}
            run utp/ut-msgs.p (input "show", input 1, input trim(return-value)).    
            apply "entry" to estab-mat.cod-estabel in frame {&frame-name}.
            return "adm-error".    
        end.
        
        find first b-estab-mat where
            b-estab-mat.cod-estabel      = input frame {&frame-name} estab-mat.cod-estabel and
            b-estab-mat.cod-estabel-prin = input frame {&frame-name} estab-mat.cod-estabel-prin
            no-lock no-error.
        if available b-estab-mat then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show", input 17522, input "").
            apply "entry" to estab-mat.cod-estabel-prin in frame {&frame-name}.
            return "adm-error".
        end.            
        find first b-estab-mat where
            b-estab-mat.cod-estabel      = input frame {&frame-name} estab-mat.cod-estabel-prin and
            b-estab-mat.cod-estabel-prin = input frame {&frame-name} estab-mat.cod-estabel
            no-lock no-error.
        if available b-estab-mat then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show", input 17522, input "").
            apply "entry" to estab-mat.cod-estabel in frame {&frame-name}.
            return "adm-error".
        end.            


        /*find first b-estab-mat where
 *             b-estab-mat.cod-estabel = input frame {&frame-name} estab-mat.cod-estabel
 *             no-lock no-error.
 *         if available b-estab-mat then do:
 *             {include/i-vldprg.i}
 *             run utp/ut-msgs.p (input "show", input 17523, input "").
 *             apply "entry" to estab-mat.cod-estabel in frame {&frame-name}.
 *             return "adm-error".
 *         end.
 *         find first b-estab-mat where
 *             b-estab-mat.cod-estabel-prin = input frame {&frame-name} estab-mat.cod-estabel
 *             no-lock no-error.
 *         if available b-estab-mat then do:
 *             {include/i-vldprg.i}
 *             run utp/ut-msgs.p (input "show", input 17523, input "").
 *             apply "entry" to estab-mat.cod-estabel in frame {&frame-name}.
 *             return "adm-error".
 *         end.*/


        find first b-estab-mat where
            b-estab-mat.cod-estabel = input frame {&frame-name} estab-mat.cod-estabel-prin
            no-lock no-error.
        if  available b-estab-mat 
        and b-estab-mat.cod-estabel <> b-estab-mat.cod-estabel-prin then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show", input 17523, input "").
            apply "entry" to estab-mat.cod-estabel-prin in frame {&frame-name}.
            return "adm-error".
        end.
    end.

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
  {src/adm/template/snd-list.i "estab-mat"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-conecta-ems50 V-table-Win 
Procedure Pi-conecta-ems50:
    def input param i-conect as integer no-undo.
    DEF VAR h-btb009za AS HANDLE NO-UNDO.
    if not valid-handle (h-btb009za) or
       h-btb009za:TYPE <> "PROCEDURE":U or
       h-btb009za:FILE-NAME <> "btb/btb009za.p":U  then
       RUN btb/btb009za.p PERSISTENT SET h-btb009za.
    
    if i-conect = 1 then do:
       if not connected("emsbas") or 
          not connected("emsuni") or 
          not connected("emsfin") then do:          
         
            if  valid-handle (h-btb009za) AND
               h-btb009za:TYPE = "PROCEDURE":U AND
               h-btb009za:FILE-NAME = "btb/btb009za.p":U then do:
               ASSIGN l-conectou-ems5 = YES.
               run pi-conecta-bco IN h-btb009za (Input 1,                         /*contem a vers„o de integraå„o da Api*/
                                                 Input i-conect,                  /*contem a opå„o desejada (1-Conex„o, 2-Desconex„o)*/
                                                 Input param-global.empresa-prin, /*contem o c©digo da empresa*/
                                                 Input "all",                     /*contem o c©digo do banco externo*/ 
                                                 Output Table tt_erros_conexao).  /*retorna erros caso existam*/
            end.
        end.
        else
    end.
    else do:
        if connected("emsbas") or 
           connected("emsfin") or 
           connected("emsuni") then do:
           
            if  valid-handle (h-btb009za) AND
               h-btb009za:TYPE = "PROCEDURE":U AND
               h-btb009za:FILE-NAME = "btb/btb009za.p":U then do:
               ASSIGN l-conectou-ems5 = NO.
               run pi-conecta-bco IN h-btb009za (Input 1,                         /*contem a vers„o de integraå„o da Api*/
                                                 Input i-conect,                  /*contem a opå„o desejada (1-Conex„o, 2-Desconex„o)*/
                                                 Input param-global.empresa-prin, /*contem o c©digo da empresa*/
                                                 Input "all",                     /*contem o c©digo do banco externo*/ 
                                                 Output Table tt_erros_conexao).  /*retorna erros caso existam*/
            end.
        end.    
    end.
    
    if valid-handle(h-btb009za) then do:
        delete procedure h-btb009za no-error.
        assign h-btb009za = ?.
    end.
    if return-value <> "OK":U then do:
        FIND FIRST tt_erros_conexao NO-ERROR.
        IF AVAIL tt_erros_conexao THEN DO:
            run utp/ut-msgs.p (input "show":U, 
                               input tt_erros_conexao.cd-erro, 
                               INPUT tt_erros_conexao.param-1).

            undo, return "NOK":U.
        END.
    end.    
    RETURN "OK":U.

End Procedure. /*Pi-conecta-ems50*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
