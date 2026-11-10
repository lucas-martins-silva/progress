&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          movind           PROGRESS
          movmnt           PROGRESS
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
{include/i-prgvrs.i V18IN270 2.00.00.036 } /*** 010036 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v18in270 MUT}
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

{cdp/cdcfgmnt.i}
{utp/ut-glob.i}
{btb/btb008za.i0}

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo. 
DEF BUFFER b-ord-manut FOR ord-manut.
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var c-handle  as char.
def var h-handle  as handle.

def var c-param-aloc as char format "x(20)" no-undo.

def var c-servidor    as char.
def var h-ord-prod    as handle.
def var h-reserva     as handle.
def var h-param-estoq as handle.

def var hDBOParamEstoq    as handle    no-undo.
def var hDBOOrdProd       as handle    no-undo.

def var da-aux            as date format "99/99/9999"   no-undo.
def var c-erro            as char .
DEF VAR h-q16in270        AS HANDLE NO-UNDO.
find first param-global no-lock no-error.

{cdp/cdunif001.i} /** 105 - Unifica‡Æo de Conceito **/
DEFINE VARIABLE i-v_cod_finalid AS INTEGER     NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES ord-manut
&Scoped-define FIRST-EXTERNAL-TABLE ord-manut


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ord-manut.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ord-manut.dt-reabre 
&Scoped-define ENABLED-TABLES ord-manut
&Scoped-define FIRST-ENABLED-TABLE ord-manut
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS ord-manut.cd-equipto ord-manut.cd-manut ~
ord-manut.cd-tipo ord-manut.cd-tag ord-manut.cd-parada ord-manut.dt-manut ~
ord-manut.dt-fecham ord-manut.dt-reabre ord-manut.cd-causa-padr ~
ord-manut.vl-contador 
&Scoped-define DISPLAYED-TABLES ord-manut
&Scoped-define FIRST-DISPLAYED-TABLE ord-manut
&Scoped-Define DISPLAYED-OBJECTS c-descr-equipto c-descr-manut ~
c-descr-tipo-man c-descr-tag c-descr-causa 

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
al-codigo||y|movind.ord-manut.al-codigo
cd-causa-padr||y|movind.ord-manut.cd-causa-padr
cd-equipto||y|movind.ord-manut.cd-equipto
nr-ord-produ||y|movind.ord-manut.nr-ord-produ
cd-inspecao||y|movind.ord-manut.cd-inspecao
cd-interv-padr||y|movind.ord-manut.cd-interv-padr
cd-manut||y|movind.ord-manut.cd-manut
sequencia||y|movind.ord-manut.sequencia
cd-parada||y|movind.ord-manut.cd-parada
cd-tag||y|movind.ord-manut.cd-tag
cd-pend-padr||y|movind.ord-manut.cd-pend-padr
cd-planejado||y|movind.ord-manut.cd-planejado
cd-projeto||y|movind.ord-manut.cd-projeto
nr-rot-insp||y|movind.ord-manut.nr-rot-insp
nr-rot-lubr||y|movind.ord-manut.nr-rot-lubr
cd-sint-padr||y|movind.ord-manut.cd-sint-padr
cd-tipo||y|movind.ord-manut.cd-tipo
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "al-codigo,cd-causa-padr,cd-equipto,nr-ord-produ,cd-inspecao,cd-interv-padr,cd-manut,sequencia,cd-parada,cd-tag,cd-pend-padr,cd-planejado,cd-projeto,nr-rot-insp,nr-rot-lubr,cd-sint-padr,cd-tipo"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-descr-causa AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE c-descr-equipto AS CHARACTER FORMAT "x(45)" 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88.

DEFINE VARIABLE c-descr-manut AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE c-descr-tag AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE c-descr-tipo-man AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84.29 BY 9.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ord-manut.cd-equipto AT ROW 1.17 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 23 BY .88
     c-descr-equipto AT ROW 1.17 COL 42 COLON-ALIGNED NO-LABEL
     ord-manut.cd-manut AT ROW 2.17 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-descr-manut AT ROW 2.17 COL 31.57 COLON-ALIGNED NO-LABEL
     ord-manut.cd-tipo AT ROW 3.17 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-descr-tipo-man AT ROW 3.17 COL 27.14 COLON-ALIGNED NO-LABEL
     ord-manut.cd-tag AT ROW 4.17 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 23 BY .88
     c-descr-tag AT ROW 4.17 COL 42.14 COLON-ALIGNED NO-LABEL
     ord-manut.cd-parada AT ROW 5.17 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     ord-manut.dt-manut AT ROW 6.17 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     ord-manut.dt-fecham AT ROW 6.17 COL 48.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     ord-manut.dt-reabre AT ROW 7.17 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     ord-manut.cd-causa-padr AT ROW 8.17 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-descr-causa AT ROW 8.17 COL 31.43 COLON-ALIGNED NO-LABEL
     ord-manut.vl-contador AT ROW 9.17 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 24.29 BY .88
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


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
         HEIGHT             = 9.38
         WIDTH              = 84.57.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-descr-causa IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descr-equipto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descr-manut IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descr-tag IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descr-tipo-man IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.cd-causa-padr IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.cd-equipto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.cd-manut IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.cd-parada IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.cd-tag IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.cd-tipo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.dt-fecham IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.dt-manut IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.vl-contador IN FRAME f-main
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

&Scoped-define SELF-NAME ord-manut.dt-reabre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-manut.dt-reabre V-table-Win
ON LEAVE OF ord-manut.dt-reabre IN FRAME f-main /* Data Reabertura */
DO:
    if  date(ord-manut.dt-reabre:screen-value in frame {&frame-name}) <
        date(ord-manut.dt-fecham:screen-value in frame {&frame-name}) then do :
        run utp/ut-msgs.p (input "show",
                           input 3091,
                           input input frame f-main ord-manut.dt-reabre + "~~" +
                                 input frame f-main ord-manut.dt-fecham ).
        apply 'entry' to ord-manut.dt-reabre in frame f-main.
        return no-apply.
    end.

 &if defined (bf_mnt_ems203) &then

    find first param-mnt no-lock no-error.
    if  avail param-mnt and param-mnt.modulo-ce then do:
        {btb/btb008za.i1 inbo/boin287.p YES}
        {btb/btb008za.i2 inbo/boin287.p '' hDBOParamEstoq}
        run openQueryStatic  in hDBOParamEstoq (input "Main":U).
        run getFirst         in hDBOParamEstoq.
        run getDateField     in hDBOParamEstoq (input "mensal-ate":U, output da-aux).
        run destroy          in hDBOParamEstoq.  
    end.

    if date(ord-manut.dt-reabre:screen-value in frame {&frame-name}) <= da-aux then do :
        run utp/ut-msgs.p (input "show",
                           input 3068,
                           input "").
        apply 'entry' to ord-manut.dt-reabre in frame f-main.
        return no-apply.
    end.

 &else   
    find first param-estoq
        no-lock no-error. 
    if  avail param-estoq
    and date(ord-manut.dt-reabre:screen-value in frame {&frame-name}) <= param-estoq.mensal-ate then do :
        run utp/ut-msgs.p (input "show",
                           input 3068,
                           input "").
        apply 'entry' to ord-manut.dt-reabre in frame f-main.
        return no-apply.
    end.
 &endif   
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

    find first param-global no-lock no-error.
    IF AVAIL param-global AND param-global.modulo-cs THEN DO:
       IF ord-manut.estado = 8 THEN DO:
          run utp/ut-msgs.p ("show":U, 28373, STRING(ord-manut.nr-ord-produ)).
          return 'ADM-ERROR':U.
       END.
    END.


    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
       RETURN 'ADM-ERROR':U.


    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  

    find first param-global no-lock no-error.

    /* Reativando as Reservas */

    &if defined(bf_mnt_ems203) &then
    find first param-mnt no-lock no-error.
    if avail param-mnt and param-mnt.modulo-ce then do:
        for each reservas
            where reservas.nr-ord-produ = ord-manut.nr-ord-produ exclusive-lock:
            assign reservas.estado = 1.
        end.
    end.
    &else
    for each reservas
        where reservas.nr-ord-produ = ord-manut.nr-ord-produ exclusive-lock:
        assign reservas.estado = 1.
    end.
    &endif

    ASSIGN ord-manut.vl-contador = 0
           &if defined (bf_mnt_ems203) &then
           ord-manut.vl-cont-acum = 0
           &else
           ord-manut.dec-1 = 0
           &endif
           .

 &if defined (bf_mnt_ems203) &then
  find first param-mnt no-lock no-error.
  if (not avail param-mnt) or (avail param-mnt and not param-mnt.modulo-ce)
     or (avail param-mnt and param-mnt.modulo-ce and param-mnt.produto-ce = 2) then do:
     if not valid-handle (hDBOOrdProd) then do:
        {btb/btb008za.i1 inbo/boin271o.p YES}
        {btb/btb008za.i2 inbo/boin271o.p '' hDBOOrdProd}
     end.   
     if valid-handle(hDBOOrdProd) then do:
        run openQueryStatic in hDBOOrdProd ("Default":U).
        run setaEstadoOrdem in hDBOOrdProd (input ord-manut.nr-ord-produ, 
                                            input 6).
        run setaQuantidadesOrdem in hDBOOrdProd (input ord-manut.nr-ord-produ,
                                                 input 0, 
                                                 input 0, 
                                                 input 2).
     end.
  end. 
  assign ord-manut.estado-om    = 2
         ord-manut.om-encerrada = no
         ord-manut.dt-fecham    = ?
         ord-manut.estado       = 6
         ord-manut.calc-cs-mat  = 2.
  {mip/mi0314.i "yes" "100"}  /* realoca especialidades das tarefas */
 &else
 FOR FIRST ord-prod
     where ord-prod.nr-ord-produ = ord-manut.nr-ord-produ EXCLUSIVE-LOCK:
 END.
 if avail ord-prod then do:
     assign ord-prod.qt-reportada  = 0
            ord-prod.estado        = if not can-find(first ord-mob
                                                     where ord-mob.nr-ord-produ = ord-prod.nr-ord-produ) AND
                                        not can-find(first movto-ggf 
                                                     where movto-ggf.nr-ord-produ = ord-prod.nr-ord-produ) then 1 else 6
            ord-prod.qt-produzida  = 0
            ord-prod.calc-cs-mat   = 2
            ord-manut.estado-om    = if not can-find(first ord-mob 
                                                     where ord-mob.nr-ord-produ = ord-prod.nr-ord-produ) AND
                                        not can-find(first movto-ggf
                                                     where movto-ggf.nr-ord-produ = ord-prod.nr-ord-produ) then 1 else 2
            ord-manut.om-encerrada = no
            ord-manut.dt-fecham    = ?
            ord-manut.estado       = ord-prod.estado.
      {mip/mi0314.i "yes" "100"}  /* realoca especialidades das tarefas */
  end.
 &endif

  for each ordem-solic 
      where ordem-solic.nr-ord-prod = ord-manut.nr-ord-prod no-lock:
      find solic-serv
           where solic-serv.nr-soli-serv = ordem-solic.nr-soli-serv exclusive-lock no-error.
      if  avail solic-serv then
          assign solic-serv.estado = 3.
  end.

  /* Realoca os tempos das especialidades das tarefas */
  if  param-global.modulo-pi = yes then do:
      {mip/mi9000.i3 "ord-manut" "nr-ord-produ" ? ''}  
  end.

  /* Code placed here will execute AFTER standard behavior.    */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if valid-handle(hDBOParamEstoq) then
     run destroy in hDBOParamEstoq.

  if valid-handle(hDBOOrdProd) then
     run destroy in hDBOOrdProd.

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

  if  available ord-manut then do:
      find equipto
          where equipto.cd-equipto = ord-manut.cd-equipto
          no-lock no-error.
      assign c-descr-equipto = if  avail equipto then equipto.descricao else "":U.
      find manut
          where manut.cd-manut = ord-manut.cd-manut
          no-lock no-error.
      assign c-descr-manut = if  avail manut then manut.descricao else "":U.
      find tipo-manut
          where tipo-manut.cd-tipo = ord-manut.cd-tipo
          no-lock no-error.
      assign c-descr-tipo-man = if  avail tipo-manut then tipo-manut.descricao else "":U.
      find tag
          where tag.cd-tag = ord-manut.cd-tag
          no-lock no-error.
      assign c-descr-tag = if  avail tag then tag.descricao else "":U.
      find causa-padrao
          where causa-padrao.cd-causa-padr = ord-manut.cd-causa-padr
          no-lock no-error.
      assign c-descr-causa = if  avail causa-padrao then causa-padrao.descricao else "":U.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  find first param-mi
      no-lock no-error.
  if  avail param-mi and param-mi.formato-cd-equipto <> " " then do:
      assign ord-manut.cd-equipto:format in frame {&frame-name} = param-mi.formato-cd-equipto.
  end.
  if  avail param-mi and param-mi.formato-cd-tag <> " " then do:
      assign ord-manut.cd-tag:format in frame {&frame-name} = param-mi.formato-cd-tag.
  end.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-handle V-table-Win 
PROCEDURE pi-recebe-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-h-q16in270 AS HANDLE NO-UNDO.

ASSIGN h-q16in270 = p-h-q16in270.


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
    DEFINE VARIABLE cInputErro  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cErroAux    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-conta-ordem LIKE ord-manut.ct-codigo.
    DEFINE VARIABLE c-conta-desp LIKE ord-manut.ct-desp.

    /*Valida Equipe Ativa*/
    FOR FIRST equipe FIELDS (situacao)
        WHERE equipe.cd-equipe = ord-manut.cd-equip-res
          AND equipe.situacao = 2 EXCLUSIVE-LOCK:
        {utp/ut-liter.i equipe.cd-equipe}
        RUN utp/ut-msgs.p("show", 54659, equipe.cd-equipe).
        IF RETURN-VALUE = 'yes' THEN 
           ASSIGN equipe.situacao = 1. 
        ELSE
           RETURN 'ADM-ERROR':U.
    END.

    assign c-conta-ordem = ord-manut.ct-codigo
           c-conta-desp  = ord-manut.ct-desp.

    if input frame {&frame-name} ord-manut.dt-reabre = ? then do:
     {include/i-vldprg.i}                   
      run utp/ut-msgs.p ("show":U, 173, '').
      return 'ADM-ERROR':U.
    end.

  
    /** Carrega o Handle **/
    IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN
        RUN prgint\utb\utb743za.py PERSISTENT SET h_api_cta_ctbl.
           
   /** Limpa temp-table **/
   EMPTY TEMP-TABLE tt_log_erro.
   RUN pi_valida_conta_contabil IN h_api_cta_ctbl (INPUT  ord-manut.ep-codigo   , /** C¢digo da Empresa do EMS2.                      **/
                                                   INPUT  ord-manut.cod-estabel , /** C¢digo do Estabelecimento do EMS2.              **/
                                                   INPUT  ""                    , /** C¢digo da Unidade de Neg½cio                    **/
                                                   INPUT  ""                    , /** C¢digo do Plano de Contas                       **/ 
                                                   INPUT  ord-manut.ct-desp     , /** C¢digo da Conta                                 **/
                                                   INPUT  ""                    , /** C¢digo do Plano de Centro de Custo              **/
                                                   INPUT  ord-manut.sc-desp     , /** C¢digo do Centro de Custo                       **/
                                                   INPUT  date(ord-manut.dt-reabre:SCREEN-VALUE IN FRAME {&frame-name}), /** Data da Transa»’o                               **/
                                                   OUTPUT TABLE tt_log_erro)    . /** Erros ocorridos durante a execu‡Æo do m‚todo    **/

    FOR EACH tt_log_erro NO-LOCK:
       {utp/ut-liter.i "C¢digo Erro Financeiro: "}
       ASSIGN cErroAux = RETURN-VALUE + CHR(01) + STRING(tt_log_erro.ttv_num_cod_erro).
       ASSIGN cInputErro = tt_log_erro.ttv_des_msg_erro + '~~~~' + tt_log_erro.ttv_des_msg_ajuda + '~~~~' + cErroAux.
       RUN utp/ut-msgs.p("show", 52046, cInputErro).
       RETURN 'ADM-ERROR':U.
	   
	   
    END.

    IF NOT CAN-FIND(tt_log_erro) THEN DO:
        RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT  "",                         /* EMPRESA EMS2 */
                                                      INPUT  "",                          /* PLANO CONTAS */ 
                                                      INPUT-OUTPUT c-conta-desp,          /* CONTA */
                                                      INPUT  date(ord-manut.dt-reabre:SCREEN-VALUE IN FRAME {&frame-name}),          /* DATA TRANSACAO */
                                                      OUTPUT v_des_cta_ctbl,              /* Descri¯Êo da Contas. */
                                                      OUTPUT v_num_tip_cta_ctbl,          /* Tipo da Conta. 0 = Nenhum, 1 = Despesa, 2 = Receita, 3 = Vendas, 4 = Passivo, 5 = Ativo, 6 = Tðtulo. */
                                                      OUTPUT v_num_sit_cta_ctbl,          /* Situa¯Êo da Conta. 1 = Ativada, 2 = Desativada, 3 = Sistema. */
                                                      OUTPUT v_ind_finalid_cta,           /* Finalidade da Conta. */
                                                      OUTPUT TABLE tt_log_erro).          /* ERROS */
        
        /** Busca finalidade conforme m¢dulo CEP **/
        RUN pi_busca_dados_cta_ctbl_integr IN h_api_cta_ctbl (INPUT        ""                     ,  /* EMPRESA EMS2          */  
                                                              INPUT        "CEP"                  ,  /* MàDULO                */  
                                                              INPUT        ""                     ,  /* PLANO DE CONTAS       */  
                                                              INPUT        ord-manut.ct-desp      ,  /* CONTA                 */  
                                                              INPUT        date(ord-manut.dt-reabre:SCREEN-VALUE IN FRAME {&frame-name})     ,  /* DATA TRANSACAO        */  
                                                              OUTPUT       v_ind_finalid_cta      ,  /* FINALIDADES DA CONTA  */  
                                                              OUTPUT TABLE tt_log_erro            ). /* ERROS                 */  
        
        /** Conta NÆo gera lan‡amento **/
        /* 1 Consumo                    
          2 NÆo Consumo                
          3 Ordem servi‡o              
          4 Transferˆncia              
          5 MÆo-de-obra                
          6 Custo mercadoria vendida   
          7 Transit¢ria de compras     
          8 Transit¢ria de devolu‡Æo   
          9 Saldo por grupo de estoque 
          10 NÆo gera lan‡amentos         */
        /** A vari vel pode retornar Array, por isso faz lookup com a include **/
        ASSIGN i-v_cod_finalid = 0.
        IF LOOKUP({adinc/i05ad049.i 4 10}, v_ind_finalid_cta) > 0 THEN
            ASSIGN i-v_cod_finalid = 10.
        
        IF i-v_cod_finalid = 10 THEN DO:
            {utp/ut-liter.i "Conta Despesa nÆo gera lan‡amentos"}  
            RUN utp/ut-msgs.p("show", 52046, RETURN-VALUE).
            RETURN 'ADM-ERROR':U.
        END.

        /** Varias finalidades **/       
        /* Valores                       
        1 Consumo                        
        2 N’o Consumo                    
        3 Ordem servi¯o                  
        4 Transfer¼ncia                  
        5 M’o-de-obra                    
        6 Custo mercadoria vendida       
        7 Transit«ria de compras         
        8 Transit«ria de devolu»’o       
        9 Saldo por grupo de estoque     
        10 N’o gera lan»amentos       */ 
        ASSIGN i-v_cod_finalid = 0.
        IF LOOKUP({adinc/i05ad049.i 4 1}, v_ind_finalid_cta) > 0 THEN
            ASSIGN i-v_cod_finalid = 1.                
        
        
        if  i-v_cod_finalid <> 1 THEN DO: /* <> Ordem servi»o */
                {utp/ut-liter.i "Conta Despesa deve ser finalidade Consumo"}                             
                RUN utp/ut-msgs.p("show", 52046, RETURN-VALUE).
                RETURN 'ADM-ERROR':U.
        end.
   END.
        
    /** Carrega o Handle **/
    IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN
        RUN prgint\utb\utb743za.py PERSISTENT SET h_api_cta_ctbl.
       
    /** Limpa temp-table **/
    EMPTY TEMP-TABLE tt_log_erro.
    RUN pi_valida_conta_contabil IN h_api_cta_ctbl (INPUT  ord-manut.ep-codigo   , /** C¢digo da Empresa do EMS2.                      **/
                                                    INPUT  ord-manut.cod-estabel , /** C¢digo do Estabelecimento do EMS2.              **/
                                                    INPUT  ""                    , /** C¢digo da Unidade de Neg½cio                    **/
                                                    INPUT  ""                    , /** C¢digo do Plano de Contas                       **/ 
                                                    INPUT  ord-manut.ct-codigo   , /** C¢digo da Conta                                 **/
                                                    INPUT  ""                    , /** C¢digo do Plano de Centro de Custo              **/
                                                    INPUT  ord-manut.sc-desp     , /** C¢digo do Centro de Custo                       **/
                                                    INPUT  date(ord-manut.dt-reabre:SCREEN-VALUE IN FRAME {&frame-name}), /** Data da Transa»’o                               **/
                                                    OUTPUT TABLE tt_log_erro)    . /** Erros ocorridos durante a execu‡Æo do m‚todo    **/
    
    FOR EACH tt_log_erro NO-LOCK:
       {utp/ut-liter.i "C¢digo Erro Financeiro: "}
       ASSIGN cErroAux = RETURN-VALUE + CHR(01) + STRING(tt_log_erro.ttv_num_cod_erro).
       ASSIGN cInputErro = tt_log_erro.ttv_des_msg_erro + '~~~~' + tt_log_erro.ttv_des_msg_ajuda + '~~~~' + cErroAux.
       RUN utp/ut-msgs.p("show", 52046, cInputErro).
       RETURN 'ADM-ERROR':U.
    END.
    
    IF NOT CAN-FIND(tt_log_erro) THEN DO:
       RUN pi_busca_dados_cta_ctbl IN h_api_cta_ctbl (INPUT  "",                          /* EMPRESA EMS2 */
                                                      INPUT  "",                          /* PLANO CONTAS */ 
                                                      INPUT-OUTPUT c-conta-ordem,         /* CONTA */
                                                      INPUT  date(ord-manut.dt-reabre:SCREEN-VALUE IN FRAME {&frame-name}),         /* DATA TRANSACAO */
                                                      OUTPUT v_des_cta_ctbl,              /* Descri¯Êo da Contas. */
                                                      OUTPUT v_num_tip_cta_ctbl,          /* Tipo da Conta. 0 = Nenhum, 1 = Despesa, 2 = Receita, 3 = Vendas, 4 = Passivo, 5 = Ativo, 6 = Tðtulo. */
                                                      OUTPUT v_num_sit_cta_ctbl,          /* Situa¯Êo da Conta. 1 = Ativada, 2 = Desativada, 3 = Sistema. */
                                                      OUTPUT v_ind_finalid_cta,           /* Finalidade da Conta. */
                                                      OUTPUT TABLE tt_log_erro).          /* ERROS */
       /** Busca finalidade conforme m¢dulo CEP **/
       RUN pi_busca_dados_cta_ctbl_integr IN h_api_cta_ctbl (INPUT        ""                     ,  /* EMPRESA EMS2          */  
                                                             INPUT        "CEP"                  ,  /* MàDULO                */  
                                                             INPUT        ""                     ,  /* PLANO DE CONTAS       */  
                                                             INPUT        ord-manut.ct-codigo    ,  /* CONTA                 */  
                                                             INPUT        date(ord-manut.dt-reabre:SCREEN-VALUE IN FRAME {&frame-name}),  /* DATA TRANSACAO        */  
                                                             OUTPUT       v_ind_finalid_cta      ,  /* FINALIDADES DA CONTA  */  
                                                             OUTPUT TABLE tt_log_erro            ). /* ERROS                 */  
       
       /** Conta NÆo gera lan‡amento **/
       /* 1 Consumo                    
          2 NÆo Consumo                
          3 Ordem servi‡o              
          4 Transferˆncia              
          5 MÆo-de-obra                
          6 Custo mercadoria vendida   
          7 Transit¢ria de compras     
          8 Transit¢ria de devolu‡Æo   
          9 Saldo por grupo de estoque 
          10 NÆo gera lan‡amentos         */
        /** A vari vel pode retornar Array, por isso faz lookup com a include **/
        ASSIGN i-v_cod_finalid = 0.
        IF LOOKUP({adinc/i05ad049.i 4 10}, v_ind_finalid_cta) > 0 THEN
            ASSIGN i-v_cod_finalid = 10.
    
        /* 1 = Ativada, 2 = Desativada, 3 = Sistema. */
        if  i-v_cod_finalid = 10 then do: /* <> Sistema */
                {utp/ut-liter.i "Conta Ordem nÆo gera lan‡amentos"}
                RUN utp/ut-msgs.p("show", 52046, RETURN-VALUE).
                RETURN 'ADM-ERROR':U.
        end.
    
        /** Varias finalidades **/       
        /* Valores                       
        1 Consumo                        
        2 N’o Consumo                    
        3 Ordem servi¯o                  
        4 Transfer¼ncia                  
        5 M’o-de-obra                    
        6 Custo mercadoria vendida       
        7 Transit«ria de compras         
        8 Transit«ria de devolu»’o       
        9 Saldo por grupo de estoque     
        10 N’o gera lan»amentos       */ 
        ASSIGN i-v_cod_finalid = 0.
        IF LOOKUP({adinc/i05ad049.i 4 3}, v_ind_finalid_cta) > 0 THEN
            ASSIGN i-v_cod_finalid = 3.                
    
    
        IF  i-v_cod_finalid <> 3 THEN DO: /* <> Ordem servi»o */
                {utp/ut-liter.i "Conta Ordem deve ser finalidade Ordem Servi‡o"}                             
                RUN utp/ut-msgs.p("show", 52046, RETURN-VALUE).
                RETURN 'ADM-ERROR':U.
        END.
    END.
    /** Elimina o handle **/
    IF VALID-HANDLE(h_api_cta_ctbl) THEN
        DELETE OBJECT h_api_cta_ctbl.


&if defined (bf_mnt_calib) &then
  IF param-global.log-modul-calib AND ord-manut.tp-manut = 3 THEN DO:
      {utp/ut-table.i mgind ord-prod 1}
      run utp/ut-msgs.p("show", 28082, return-value). /* ordem nao pode ser reaberta */
      return 'ADM-ERROR':U.
  END.
&endif
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

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "al-codigo" "ord-manut" "al-codigo"}
  {src/adm/template/sndkycas.i "cd-causa-padr" "ord-manut" "cd-causa-padr"}
  {src/adm/template/sndkycas.i "cd-equipto" "ord-manut" "cd-equipto"}
  {src/adm/template/sndkycas.i "nr-ord-produ" "ord-manut" "nr-ord-produ"}
  {src/adm/template/sndkycas.i "cd-inspecao" "ord-manut" "cd-inspecao"}
  {src/adm/template/sndkycas.i "cd-interv-padr" "ord-manut" "cd-interv-padr"}
  {src/adm/template/sndkycas.i "cd-manut" "ord-manut" "cd-manut"}
  {src/adm/template/sndkycas.i "sequencia" "ord-manut" "sequencia"}
  {src/adm/template/sndkycas.i "cd-parada" "ord-manut" "cd-parada"}
  {src/adm/template/sndkycas.i "cd-tag" "ord-manut" "cd-tag"}
  {src/adm/template/sndkycas.i "cd-pend-padr" "ord-manut" "cd-pend-padr"}
  {src/adm/template/sndkycas.i "cd-planejado" "ord-manut" "cd-planejado"}
  {src/adm/template/sndkycas.i "cd-projeto" "ord-manut" "cd-projeto"}
  {src/adm/template/sndkycas.i "nr-rot-insp" "ord-manut" "nr-rot-insp"}
  {src/adm/template/sndkycas.i "nr-rot-lubr" "ord-manut" "nr-rot-lubr"}
  {src/adm/template/sndkycas.i "cd-sint-padr" "ord-manut" "cd-sint-padr"}
  {src/adm/template/sndkycas.i "cd-tipo" "ord-manut" "cd-tipo"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

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

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

