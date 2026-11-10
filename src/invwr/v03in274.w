&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V03IN274 2.00.00.023 } /*** 010023 ***/
 

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v03in274 MUT}
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
 
{include/i-vrtab.i item}
{include/i-vrtab.i estabelec}
{include/i-vrtab.i deposito}
{include/i-vrtab.i cond-pagto}
{include/i-vrtab.i comprador}
{include/i-vrtab.i requisitante}
{include/i-vrtab.i pedido-compr}
{include/i-vrtab.i operacao}
 
/* Parameters Definitions ---                                           */
 
/* Local Variable Definitions ---                                       */
 
 
define new global shared var gr-ordem-compra as rowid no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES ordem-compra
&Scoped-define FIRST-EXTERNAL-TABLE ordem-compra


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ordem-compra.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ordem-compra.it-codigo ~
ordem-compra.cod-estabel ordem-compra.dep-almoxar ordem-compra.num-pedido ~
ordem-compra.num-ord-inv ordem-compra.cod-comprado ~
ordem-compra.ordem-servic ordem-compra.requisitante ordem-compra.op-codigo ~
ordem-compra.data-pedido ordem-compra.nr-alt-preco ~
ordem-compra.data-emissao 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}it-codigo ~{&FP2}it-codigo ~{&FP3}~
 ~{&FP1}cod-estabel ~{&FP2}cod-estabel ~{&FP3}~
 ~{&FP1}dep-almoxar ~{&FP2}dep-almoxar ~{&FP3}~
 ~{&FP1}num-pedido ~{&FP2}num-pedido ~{&FP3}~
 ~{&FP1}num-ord-inv ~{&FP2}num-ord-inv ~{&FP3}~
 ~{&FP1}cod-comprado ~{&FP2}cod-comprado ~{&FP3}~
 ~{&FP1}ordem-servic ~{&FP2}ordem-servic ~{&FP3}~
 ~{&FP1}requisitante ~{&FP2}requisitante ~{&FP3}~
 ~{&FP1}op-codigo ~{&FP2}op-codigo ~{&FP3}~
 ~{&FP1}data-pedido ~{&FP2}data-pedido ~{&FP3}~
 ~{&FP1}nr-alt-preco ~{&FP2}nr-alt-preco ~{&FP3}~
 ~{&FP1}data-emissao ~{&FP2}data-emissao ~{&FP3}
&Scoped-define ENABLED-TABLES ordem-compra
&Scoped-define FIRST-ENABLED-TABLE ordem-compra
&Scoped-Define ENABLED-OBJECTS RECT-8 
&Scoped-Define DISPLAYED-FIELDS ordem-compra.it-codigo ~
ordem-compra.cod-estabel ordem-compra.dep-almoxar ordem-compra.num-pedido ~
ordem-compra.cod-cond-pag ordem-compra.num-ord-inv ~
ordem-compra.cod-comprado ordem-compra.ordem-servic ~
ordem-compra.requisitante ordem-compra.op-codigo ordem-compra.data-pedido ~
ordem-compra.nr-alt-preco ordem-compra.data-emissao 
&Scoped-Define DISPLAYED-OBJECTS c-descr-item c-desc-estabelec ~
c-desc-deposito c-desc-cond-pagto c-desc-comprador c-desc-requisitante ~
cb-local-entrega 

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
DEFINE VARIABLE cb-local-entrega AS CHARACTER FORMAT "X(256)":U 
     LABEL "Local Entrega" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "Item 1" 
     SIZE 16.29 BY 1 NO-UNDO.
DEFINE VARIABLE c-desc-comprador AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-cond-pagto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 19.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-deposito AS CHARACTER FORMAT "X(33)":U 
     VIEW-AS FILL-IN 
     SIZE 29.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estabelec AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 50.75 BY .88 NO-UNDO.
DEFINE VARIABLE c-desc-requisitante AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-descr-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 40.75 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.29 BY 10.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ordem-compra.it-codigo AT ROW 1.46 COL 19.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.86 BY .88
     c-descr-item AT ROW 1.46 COL 37.61 COLON-ALIGNED NO-LABEL
     ordem-compra.cod-estabel AT ROW 2.46 COL 19.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.86 BY .88
     c-desc-estabelec AT ROW 2.46 COL 27.72 COLON-ALIGNED NO-LABEL
     ordem-compra.dep-almoxar AT ROW 3.46 COL 19.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.86 BY .88
     c-desc-deposito AT ROW 3.46 COL 27.72 COLON-ALIGNED NO-LABEL
     ordem-compra.num-pedido AT ROW 3.46 COL 67.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     ordem-compra.cod-cond-pag AT ROW 4.46 COL 19.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     c-desc-cond-pagto AT ROW 4.46 COL 26.72 NO-LABEL
     ordem-compra.num-ord-inv AT ROW 4.46 COL 67.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     ordem-compra.ordem-servic AT ROW 5.46 COL 19.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     ordem-compra.op-codigo AT ROW 5.46 COL 67.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     ordem-compra.cod-comprado AT ROW 6.46 COL 19.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     c-desc-comprador AT ROW 6.46 COL 36.43 COLON-ALIGNED NO-LABEL
     ordem-compra.requisitante AT ROW 7.46 COL 19.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     c-desc-requisitante AT ROW 7.46 COL 36.43 COLON-ALIGNED NO-LABEL
     ordem-compra.data-pedido AT ROW 8.46 COL 19.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     ordem-compra.nr-alt-preco AT ROW 8.46 COL 67.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     ordem-compra.data-emissao AT ROW 9.46 COL 19.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     cb-local-entrega AT ROW 9.46 COL 67.43 COLON-ALIGNED
     RECT-8 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 85.29 BY 10.5.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.ordem-compra
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 10.5
         WIDTH              = 85.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-comprador IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-cond-pagto IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-desc-deposito IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-estabelec IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-requisitante IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descr-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-local-entrega IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ordem-compra.cod-cond-pag IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */
 
{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
 
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
 
  /************************ INTERNAL PROCEDURES ********************/

  assign cb-local-entrega:list-items in frame {&frame-name} = {ininc/i08in295.i 03}.

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
  {src/adm/template/row-list.i "ordem-compra"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ordem-compra"}

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
 
if  avail ordem-compra then do:
    find item where item.it-codigo = ordem-compra.it-codigo no-lock no-error.
    
    find cond-pagto where cond-pagto.cod-cond-pag = ordem-compra.cod-cond-pag no-lock no-error.
    
    find deposito where deposito.cod-depos = ordem-compra.dep-almoxar no-lock no-error.
    
    find estabelec where estabelec.cod-estabel = ordem-compra.cod-estabel no-lock no-error.
    
    FOR FIRST comprador FIELDS (nome) NO-LOCK
        WHERE comprador.cod-comprado = ordem-compra.cod-comprado:        
    END.

    FOR FIRST requisitante FIELDS (nome) NO-LOCK
        WHERE requisitante.nome-abrev = ordem-compra.requisitante:
    END.
    assign c-descr-item         = if avail item then item.desc-item else ""
           c-desc-cond-pagto    = if available cond-pagto then cond-pagto.descricao else " "
           c-desc-deposito      = if available deposito then deposito.nome else ""
           c-desc-estabelec     = if avail estabelec then estabelec.nome else " "
           c-desc-comprador     = if avail comprador then comprador.nome else " "
           c-desc-requisitante  = if avail requisitante then requisitante.nome else " ".
end.
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
 
  assign cb-local-entrega = {ininc/i08in295.i 04 ordem-compra.local-entrega} no-error.
  disp cb-local-entrega with frame {&frame-name}.
   
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

    if avail ordem-compra then do:
        find first item no-lock 
             where item.it-codigo = ordem-compra.it-codigo no-error.
        if avail item then 
            assign gr-item = rowid(item).
        
        find first estabelec no-lock 
             where estabelec.cod-estabel = ordem-compra.cod-estabel no-error.
        if  avail estabelec then
            assign gr-estabelec = rowid(estabelec).
       
        find first deposito no-lock 
             where deposito.cod-depos = ordem-compra.dep-almoxar no-error.
        if avail deposito then
            assign gr-deposito = rowid(deposito).                     
        
        if ordem-compra.cod-cond-pag <> 0 then
        find first cond-pagto no-lock 
             where cond-pagto.cod-cond-pag = ordem-compra.cod-cond-pag no-error.
        if avail cond-pagto then
            assign gr-cond-pagto = rowid(cond-pagto).
        
        if ordem-compra.num-pedido <> 0 then
        find first pedido-compr no-lock 
             where pedido-compr.num-pedido = ordem-compra.num-pedido no-error.
        if avail pedido-compr then
            assign gr-pedido-compr = rowid(pedido-compr).
    end.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
  /* Code placed here will execute PRIOR to standard behavior. */
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
 
  /* Ponha aqui a valida‡Æo de chave duplicada */
 
  /* Ponha aqui as demais valida‡äes */
 
  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.
 
  /* Code placed here will execute AFTER standard behavior.    */
 
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
  {src/adm/template/snd-list.i "ordem-compra"}

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
