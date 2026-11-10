&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i V21IN270 2.00.00.030}  /*** 010030 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v21in270 MUT}
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
def new global shared var v-row-parent as rowid  no-undo.                                
def new global shared var gr-ord-manut as rowid  no-undo.   
def new global shared var h-acomp      as handle no-undo.   
def new global shared var gr-ord-prod  as rowid  no-undo.                          
def new global shared var i-tipo-movto as integer no-undo.   /* 1- Aloca, 2 - Estorno */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var c-handle-browse  as char   initial "".
def var wh-handle-browse as handle.

def var c-handle  as char    no-undo.
def var h-handle  as handle  no-undo.
def var i-cont    as integer no-undo.
def var c-erro    as char    no-undo.
def var c-texto   as char    no-undo.
def var c-retorno as char    no-undo.
def var l-erro    as logical no-undo.

def var i-prioridade   as integer init 3   no-undo.
def var l-reaproveita  as logical          no-undo.
def var l-deposito     as logical          no-undo.
def var l-erro-valid   as logical          no-undo.
def var l-prim-exec    as logical init yes no-undo.
def var l-aloca-altern as logical          no-undo.

{cdp/cdcfgmnt.i}
{cdp/cdcfgman.i}
{utp/ut-glob.i}
{btb/btb008za.i0}

&if defined(bf_ems203) &then
    {mip/miapi005.i}
    {mip/miapi005.i1}
&else
    {cpp/cpapi013.i}
    {cpp/cpapi013.i1}
&endif

{cdp/cd0666.i}

def var l-primeira     as logical initial yes.
def var h-p-cadsi2     as handle  no-undo. 
def var h_campo        as widget-handle no-undo.
def var h_frame        as widget-handle no-undo.
def var i-estado       as integer       no-undo.
def var hdboaloc-ord-esp as handle      no-undo.
def var hdboordprod      as handle      no-undo.
def var h-ord-prod       as handle      no-undo.
def var c-servidor       as char        no-undo.

{cdp/cd9911.i}

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
&Scoped-define EXTERNAL-TABLES ord-manut
&Scoped-define FIRST-EXTERNAL-TABLE ord-manut


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ord-manut.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ord-manut.sit-aloc 
&Scoped-define ENABLED-TABLES ord-manut
&Scoped-define FIRST-ENABLED-TABLE ord-manut
&Scoped-define DISPLAYED-TABLES ord-manut
&Scoped-define FIRST-DISPLAYED-TABLE ord-manut
&Scoped-Define ENABLED-OBJECTS RECT-11 RECT-12 rt-mold 
&Scoped-Define DISPLAYED-FIELDS ord-manut.nr-ord-produ ~
ord-manut.des-man-corr ord-manut.dt-manut ord-manut.dt-fecham ~
ord-manut.dt-prev ord-manut.cd-equipto ord-manut.cd-tag ord-manut.sit-aloc 
&Scoped-Define DISPLAYED-OBJECTS c-estado c-descr-equipto c-descr-tag ~
RS-TIPO-MOVIMENTO rs-sit-aloc fi-label-retangulo-2 fi-label-retangulo 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS RS-TIPO-MOVIMENTO rs-sit-aloc 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS></FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = ':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-cod-unid-negoc AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unidade Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE c-des-unid-negoc AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 67.72 BY .88.

DEFINE VARIABLE c-descr-equipto AS CHARACTER FORMAT "X(45)" 
     VIEW-AS FILL-IN 
     SIZE 55.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-descr-tag AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 55.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-estado AS CHARACTER FORMAT "X(40)" INITIAL "NÆo Iniciada" 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-label-retangulo AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 19 BY .63 NO-UNDO.

DEFINE VARIABLE fi-label-retangulo-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Tipo Movimento" 
      VIEW-AS TEXT 
     SIZE 13.57 BY .63 NO-UNDO.

DEFINE VARIABLE fi-perc AS DECIMAL FORMAT ">>9.99":U INITIAL 100 
     LABEL "%" 
     VIEW-AS FILL-IN 
     SIZE 2.43 BY .88 NO-UNDO.

DEFINE VARIABLE rs-sit-aloc AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Total", 1,
"Parcial", 2
     SIZE 55 BY .58.

DEFINE VARIABLE RS-TIPO-MOVIMENTO AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Estornar Aloca‡äes Anteriores", 2,
"Alocar", 1
     SIZE 49.72 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 62 BY 1.33.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 62 BY 1.33.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 8.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ord-manut.nr-ord-produ AT ROW 1.25 COL 12.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     ord-manut.des-man-corr AT ROW 1.25 COL 25.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 41.86 BY .88
     c-estado AT ROW 1.25 COL 74.14 COLON-ALIGNED
     ord-manut.dt-manut AT ROW 2.25 COL 12.86 COLON-ALIGNED
          LABEL "Dt. Manut.":R18
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     ord-manut.dt-fecham AT ROW 2.25 COL 42.43 COLON-ALIGNED
          LABEL "Dt. T‚rmino":R15
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     ord-manut.dt-prev AT ROW 2.25 COL 74.14 COLON-ALIGNED
          LABEL "Prev. T‚rmino":R20
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     ord-manut.cd-equipto AT ROW 3.25 COL 12.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-descr-equipto AT ROW 3.25 COL 30.86 COLON-ALIGNED NO-LABEL
     ord-manut.cd-tag AT ROW 4.25 COL 12.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-descr-tag AT ROW 4.25 COL 30.86 COLON-ALIGNED NO-LABEL
     c-cod-unid-negoc AT ROW 5.25 COL 12.86 COLON-ALIGNED
     c-des-unid-negoc AT ROW 5.25 COL 18.29 COLON-ALIGNED NO-LABEL
     ord-manut.sit-aloc AT ROW 6.67 COL 83.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2.29 BY 1
     RS-TIPO-MOVIMENTO AT ROW 7 COL 20.72 NO-LABEL
     fi-perc AT ROW 8.5 COL 71.43 COLON-ALIGNED
     rs-sit-aloc AT ROW 8.71 COL 20.86 NO-LABEL
     fi-label-retangulo-2 AT ROW 6.25 COL 17.86 COLON-ALIGNED NO-LABEL
     fi-label-retangulo AT ROW 8 COL 19.14 COLON-ALIGNED NO-LABEL
     RECT-11 AT ROW 8.25 COL 14.86
     RECT-12 AT ROW 6.5 COL 14.86
     rt-mold AT ROW 1 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.ord-manut
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
         HEIGHT             = 8.75
         WIDTH              = 88.29.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-unid-negoc IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN c-des-unid-negoc IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN c-descr-equipto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descr-tag IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-estado IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.cd-equipto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.cd-tag IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.des-man-corr IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.dt-fecham IN FRAME f-main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN ord-manut.dt-manut IN FRAME f-main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN ord-manut.dt-prev IN FRAME f-main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN fi-label-retangulo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-label-retangulo-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-perc IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fi-perc:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN ord-manut.nr-ord-produ IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET rs-sit-aloc IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR RADIO-SET RS-TIPO-MOVIMENTO IN FRAME f-main
   NO-ENABLE 3                                                          */
ASSIGN 
       ord-manut.sit-aloc:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME rs-sit-aloc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-sit-aloc V-table-Win
ON VALUE-CHANGED OF rs-sit-aloc IN FRAME f-main
DO:
   assign l-erro = no.
   if input frame {&frame-name} rs-tipo-movimento = 1 then do:  
      RUN set-cursor IN adm-broker-hdl (INPUT "WAIT").
      run pi-carrega-tt-reservas in h-handle (input integer(input frame {&frame-name} rs-sit-aloc), 
                                              input  ord-manut.nr-ord-prod,
                                              input  i-prioridade,
                                              input  no,
                                              input  l-aloca-altern,
                                              output fi-perc,
                                              output c-erro,
                                              output c-texto).                                  
      if return-value = "nok" then do:
         assign l-erro = yes.
         for each tt-reservas:
             delete tt-reservas.
         end.
         run pi-recebe-tt-reservas in h-handle (input table tt-reservas).
         do i-cont = 1 to num-entries (c-erro):
            run utp/ut-msgs.p (input "show",
                               input int (entry (i-cont, c-erro)),
                               input entry (i-cont, c-texto)).
         end.
      end.  

      run notify ('pi-recebe-tt-res-aloc,record-target').                     
      RUN set-cursor IN adm-broker-hdl (INPUT "").   
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RS-TIPO-MOVIMENTO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RS-TIPO-MOVIMENTO V-table-Win
ON VALUE-CHANGED OF RS-TIPO-MOVIMENTO IN FRAME f-main
DO:
   assign l-erro  = no.
   assign i-tipo-movto = input frame {&frame-name} rs-tipo-movimento. 
   if input frame {&frame-name} rs-tipo-movimento = 1  then do:
      assign rs-sit-aloc:sensitive in frame {&frame-name} = true
             rs-sit-aloc:screen-value in frame {&frame-name} = string(ord-manut.sit-aloc).
      apply "value-changed" to rs-sit-aloc in frame {&frame-name}.
   end.   
   else do:
      assign rs-sit-aloc:sensitive in frame {&frame-name} = false.  
      &if defined(bf_mnt_ems203) &then
          run notify ('pi-est-tt-reserva,record-target').
      &else
        for each tt-reservas:
            delete tt-reservas.
        end.
        run pi-recebe-tt-reservas in h-handle (input table tt-reservas).
        run notify ('pi-recebe-tt-res-aloc,record-target').           
      &endif  
   end. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  {utp/ut-liter.i Alocada mmi r}
  assign fi-label-retangulo = trim(return-value).

  {utp/ut-liter.i Tipo_de_Movimento MCP R}
  assign fi-label-retangulo-2:screen-value in frame {&frame-name} = " " + return-value
         fi-label-retangulo-2                                     = " " + return-value.

  {utp/ut-rdset.i rs-tipo-movimento MCP}

  &if defined(bf_mnt_ems203) &then
      find first param-mnt no-lock no-error.
  &endif

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  /************************ INTERNAL PROCEDURES ********************/

find first param-global no-lock no-error.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win  adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
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
  {src/adm/template/row-list.i "ord-manut"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ord-manut"}

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

  /* Code placed here will execute PRIOR to standard behavior. */

  {include/i-valid.i} 

  if l-erro then do:
     do i-cont = 1 to num-entries (c-erro):
        run utp/ut-msgs.p (input "show",
                           input int (entry (i-cont, c-erro)),
                           input entry (i-cont, c-texto)).
     end.
     return "adm-error".
  end.

  if input frame {&frame-name} rs-tipo-movimento = 2 then do:
     /* Confirma estorno da ordem ? */
     run utp/ut-msgs.p (input "show",
                        input  1695 ,
                        input  "").                     
     if return-value = "no" then return "adm-error".    
  end.

  for each tt-alocacao:
      delete tt-alocacao.
  end.
    
      /* UPC */
  if  c-nom-prog-upc-mg97 <> ""
  and c-nom-prog-upc-mg97 <> ? then do:
      run value(c-nom-prog-upc-mg97) (input "BEFORE-ALOCA-RESERVAS",
                                      input "VIEWER",
                                      input THIS-PROCEDURE,
                                      input FRAME f-main:HANDLE,
                                      input "",
                                      input ?).
      IF RETURN-VALUE = "NOK":U THEN RETURN "adm-error":U.
  end.

  create tt-alocacao.
  assign tt-alocacao.cod-versao-integracao = 001
         tt-alocacao.tipo-trans   = input frame {&frame-name} rs-tipo-movimento
         tt-alocacao.nr-ord-produ = ord-manut.nr-ord-produ
         tt-alocacao.prioridade   = i-prioridade
         tt-alocacao.sit-aloc     = input frame {&frame-name} rs-sit-aloc
         tt-alocacao.informa-dep  = yes
         tt-alocacao.reaproveita  = l-reaproveita
         tt-alocacao.aloca-altern = l-aloca-altern
         tt-alocacao.prog-seg     = "mi0316".
  run pi-recebe-tt-alocacao in h-handle (input table tt-alocacao).
  run pi-retorna-tt-deposito in h-handle (output table tt-deposito).
  run pi-valida-alocacao in h-handle (input  yes,
                                      input  ord-manut.nr-ord-prod,
                                      input  tt-alocacao.tipo-trans,
                                      input  "mi",
                                      output c-erro,
                                      output c-texto). 
  assign c-retorno = return-value.       
  do i-cont = 1 to num-entries (c-erro):
     run utp/ut-msgs.p (input "show",
                        input int (entry (i-cont, c-erro)),
                        input entry (i-cont, c-texto)).
  end.
  if c-retorno = "nok" then return "adm-error". 
  run notify ('pi-validate,record-target').
  if return-value = "adm-error" then
     return "adm-error".
  run utp/ut-acomp.p persistent set h-acomp.
  if tt-alocacao.tipo-trans = 1 then Do:
     {utp/ut-liter.i Processando_Aloca‡Æo *}
     run pi-inicializar in h-acomp ( Return-value ).
End.
  else Do:
      {utp/ut-liter.i Processando_Desaloca‡Æo *}
      run pi-inicializar in h-acomp ( Return-value ).
End.


  run pi-desabilita-cancela in h-acomp.                          
  run pi-processa-alocacoes in h-handle (input        table tt-alocacao,
                                         input        table tt-deposito,
                                         input-output table tt-erro,
                                         input        yes).

  run pi-finalizar in h-acomp.                                         

  assign c-retorno = return-value.

  find first tt-erro no-error.
  if avail tt-erro then
     run cdp/cd0666.p (input table tt-erro).

  if c-retorno = "nok" then
     return "adm-error".  


  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */


  if tt-alocacao.tipo-trans = 2 then
     run utp/ut-msgs.p (input "show",
                         input 1932  ,
                         input ""    ).                                         
  else
      run utp/ut-msgs.p (input "show" ,
                         input 1948   ,
                         input ""     ).

  run dispatch in this-procedure ("display-fields").

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
  run notify ('pi-desabilita-campos,record-target').

  RUN Who-Is-The-Container IN adm-broker-hdl
      (INPUT  this-procedure,
       OUTPUT c-handle).
  run pi-habilita-botoes in widget-handle (c-handle)(input yes).

  assign l-erro = no.

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

  if  avail ord-manut then do:
      find equipto where equipto.cd-equipto = ord-manut.cd-equipto no-lock no-error.
      find tag where tag.cd-tag = ord-manut.cd-tag no-lock no-error.
      assign c-descr-tag = if  avail tag then tag.descricao else "":U
             rs-sit-aloc = ord-manut.sit-aloc
             rs-sit-aloc:screen-value in frame {&frame-name} = string(ord-manut.sit-aloc)
             c-descr-equipto = if avail equipto then equipto.descricao else "":U.
      &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
             RUN utp/ut-liter.p (trim({varinc/var00014.i 04 ord-manut.estado}), "*", "").
             assign c-estado = return-value.
      &else       
             assign c-estado = {varinc/var00014.i 04 ord-manut.estado}.
      &endif
  end.
  else
      assign c-estado = "".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  find first param-mi no-lock no-error.
  if avail param-mi then do:
     if param-mi.formato-cd-tag <> "" then 
        assign ord-manut.cd-tag:format in frame {&frame-name} = param-mi.formato-cd-tag.
     if param-mi.formato-cd-equipto <> "" then 
        assign ord-manut.cd-equipto:format in frame {&frame-name} = param-mi.formato-cd-equipto.
  end.

  IF AVAIL ord-manut THEN DO WITH FRAME {&FRAME-NAME}:
      IF l-usa-unid-negoc THEN DO:
          &IF DEFINED(bf_mnt_ems207) &THEN
              ASSIGN c-cod-unid-negoc:SCREEN-VALUE = ord-manut.cod-unid-negoc.
          &ELSEIF DEFINED(bf_mnt_ems206b) &then
              ASSIGN c-cod-unid-negoc:SCREEN-VALUE = SUBSTRING(ord-manut.char-1,19,3).
          &ENDIF
          &IF DEFINED(bf_mnt_ems206b) &THEN
              FOR FIRST unid-negoc NO-LOCK
                  WHERE unid-negoc.cod-unid-negoc = c-cod-unid-negoc:SCREEN-VALUE:
              END.
              ASSIGN c-des-unid-negoc:SCREEN-VALUE = IF AVAIL unid-negoc THEN unid-negoc.des-unid-negoc ELSE "":U.
          &ENDIF
      END.
  END.

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
  if rs-tipo-movimento:sensitive in frame {&frame-name} then do:
     if input frame {&frame-name} rs-tipo-movimento eq 2 then do:
        assign rs-sit-aloc:sensitive in frame {&frame-name} = false.
        apply "value-changed" to rs-tipo-movimento in frame {&frame-name}.
     end.   
     else
         apply "value-changed" to rs-sit-aloc in frame {&frame-name}.  

     RUN Who-Is-The-Container IN adm-broker-hdl
         (INPUT  this-procedure,
          OUTPUT c-handle).
     run pi-habilita-botoes in widget-handle (c-handle)(input no).

     run notify ('pi-habilita-campos,record-target').    
  end.
  else do:  
      /* Dispatch standard ADM method.                             */
      RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

      /* Code placed here will execute AFTER standard behavior.    */
      &if  defined(ADM-MODIFY-FIELDS) &then
          enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
      &endif
  end.

  assign l-erro = no.

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
  assign i-tipo-movto = 1.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
   RUN get-link-handle IN adm-broker-hdl
      (INPUT  this-procedure:handle,
       INPUT  "record-target",
       OUTPUT c-handle-browse).
   assign wh-handle-browse = (widget-handle(c-handle-browse)).         

   IF l-usa-unid-negoc THEN DO WITH FRAME {&FRAME-NAME}:
       ASSIGN c-cod-unid-negoc:VISIBLE = YES
              c-des-unid-negoc:VISIBLE = YES.
   END.
   ELSE DO WITH FRAME {&FRAME-NAME}:
       ASSIGN c-cod-unid-negoc:VISIBLE = NO
              c-des-unid-negoc:VISIBLE = NO
              fi-label-retangulo-2:ROW = fi-label-retangulo-2:ROW - 0.5
              RECT-12:ROW              = RECT-12:ROW - 0.5
              RS-TIPO-MOVIMENTO:ROW    = RS-TIPO-MOVIMENTO:ROW - 0.5
              fi-label-retangulo:ROW   = fi-label-retangulo:ROW - 0.5
              RECT-11:ROW              = RECT-11:ROW - 0.5
              rs-sit-aloc:ROW          = rs-sit-aloc:ROW - 0.5.
   END.
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

  if  avail ord-manut then do:
      assign gr-ord-manut = rowid(ord-manut).      
      &if defined(bf_mnt_ems203) &then
      &else
          find ord-prod where ord-prod.nr-ord-prod = ord-manut.nr-ord-prod no-lock no-error.
          if avail ord-prod then
             assign gr-ord-prod = rowid (ord-prod).
      &endif
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parametros V-table-Win 
PROCEDURE pi-atualiza-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-prioridade   as integer no-undo.
def input parameter p-reaproveita  as logical no-undo.
def input parameter p-deposito     as logical no-undo.
def input parameter p-aloca-altern as logical no-undo.

assign i-prioridade   = p-prioridade
       l-reaproveita  = p-reaproveita
       l-deposito     = p-deposito
       l-aloca-altern = p-aloca-altern.

if rs-sit-aloc:sensitive in frame {&frame-name} and
   input frame {&frame-name} rs-tipo-movimento = 1 then       
   apply "value-changed" to rs-sit-aloc in frame {&frame-name}.       

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-h-cadsi V-table-Win 
PROCEDURE pi-recebe-h-cadsi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-handle as handle no-undo.

assign h-p-cadsi2 = p-handle.

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
define input parameter pHandle as handle no-undo.

       assign h-handle = pHandle.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-ordem V-table-Win 
PROCEDURE pi-valida-ordem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var l-pi-implantado as logical no-undo.

find first param-global no-lock no-error.
&if defined (bf_mnt_calib) &then
    IF &IF DEFINED (bf_mnt_ems205) &THEN
            param-global.log-modul-calib 
        &else
            substr(param-global.char-2,100,1) = "2" 
        &endif
        &IF DEFINED (bf_mnt_ems208) &THEN
              		AND ord-manut.tp-manut = 3
        &else
              		AND ord-manut.dec-1 =  3
        &endif
    AND ord-manut.estado = 1 THEN DO:
        {utp/ut-table.i mgind ord-prod 1}
        run utp/ut-msgs.p("show", 28075, return-value).    /* ordem de calibracao nao liberada*/
        return 'ADM-ERROR':U.
    END.
&endif

if  avail param-global and 
          param-global.modulo-pi and
          ord-manut.estado = 1 then do:
    run utp/ut-msgs.p (input "show",
                      input 5935,
                      input "").
    return "adm-error":U.
end.        

run pi-valida-ordem in h-handle (input yes,
                                 input ord-manut.nr-ord-prod,  
                                 input "mi",                                           
                                 output c-erro,
                                 output c-texto).           
assign c-retorno = return-value.
do i-cont = 1 to num-entries (c-erro):
   run utp/ut-msgs.p (input "show",
                      input int (entry (i-cont, c-erro)),
                      input entry (i-cont, c-texto)).
end.

return c-retorno.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* There are no foreign keys supplied by this SmartObject. */

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
  {src/adm/template/snd-list.i "ord-manut"}

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

  /* Include com os tratamentos necess rios … valida‡Æo antes que se 
     habilite os campos                                           */ 

 if p-state = "update-begin" and l-prim-exec then do:
     assign l-prim-exec = no
            c-retorno   = "".
     if not l-erro-valid then do:
        run pi-valida-ordem.                    
        if return-value = "adm-error" or
           return-value = "nok" then do :
           assign l-erro-valid = yes.
           RUN Who-Is-The-Container IN adm-broker-hdl
              (INPUT this-procedure,
               OUTPUT c-handle).
           run pi-cancela in widget-handle(c-handle).
           assign l-erro-valid = yes.
           return "adm-error".
        end.
        else do:
             CASE p-state:
             /* Object instance CASEs can go here to replace standard behavior
                or add new cases. */
               {src/adm/template/vstates.i}
             END CASE.
             run pi-trata-state (p-issuer-hdl, p-state).
             assign l-erro-valid = no.
        end.
     end.
  end.
  else do: 
       if (p-state <> "Disable-button" or not l-erro-valid) then
           run new-state (p-state + ', state-target').           
       CASE p-state:
          /* Object instance CASEs can go here to replace standard behavior
             or add new cases. */
             {src/adm/template/vstates.i}
       END CASE.
       run pi-trata-state (p-issuer-hdl, p-state).
       assign l-erro-valid = no
              l-prim-exec  = yes.
  end.      


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

