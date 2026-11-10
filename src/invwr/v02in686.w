&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            ORACLE
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
{include/i-prgvrs.i V02IN686 2.00.00.006 } /*** 010006 ***/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

DEF NEW GLOBAL SHARED VAR gr-fam-uni-estab AS rowid NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-deposito      AS rowid NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-planejad      AS rowid NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-lin-prod      AS rowid NO-UNDO.

def var i-ind-refugo as integer init 1 no-undo.
def var v-row-parent as rowid no-undo.

{cdp/cd7300.i1}
{cdp/cdapi211.i}
{cdp/cdcfgman.i}

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
&Scoped-define EXTERNAL-TABLES fam-uni-estab
&Scoped-define FIRST-EXTERNAL-TABLE fam-uni-estab


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR fam-uni-estab.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS fam-uni-estab.deposito-pad ~
fam-uni-estab.cod-localiz fam-uni-estab.cd-planejado fam-uni-estab.nr-linha ~
fam-uni-estab.cap-est-fabr 
&Scoped-define ENABLED-TABLES fam-uni-estab
&Scoped-define FIRST-ENABLED-TABLE fam-uni-estab
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS fam-uni-estab.deposito-pad ~
fam-uni-estab.cod-localiz fam-uni-estab.cd-planejado fam-uni-estab.nr-linha ~
fam-uni-estab.cap-est-fabr 
&Scoped-define DISPLAYED-TABLES fam-uni-estab
&Scoped-define FIRST-DISPLAYED-TABLE fam-uni-estab
&Scoped-Define DISPLAYED-OBJECTS c-deposito c-desc-local c-cd-plan ~
c-nr-linha 

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
DEFINE VARIABLE c-cd-plan AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 41.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-deposito AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-local AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 37 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-linha AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 53.29 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.14 BY 7.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     fam-uni-estab.deposito-pad AT ROW 1.17 COL 25.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-deposito AT ROW 1.17 COL 33.29 COLON-ALIGNED NO-LABEL
     fam-uni-estab.cod-localiz AT ROW 2.17 COL 25.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21 BY .88
     c-desc-local AT ROW 2.17 COL 47 COLON-ALIGNED NO-LABEL
     fam-uni-estab.cd-planejado AT ROW 3.17 COL 25.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     c-cd-plan AT ROW 3.17 COL 42.29 COLON-ALIGNED HELP
          "Nome do Planejador" NO-LABEL
     fam-uni-estab.nr-linha AT ROW 4.17 COL 25.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-nr-linha AT ROW 4.17 COL 30.72 COLON-ALIGNED NO-LABEL
     fam-uni-estab.cap-est-fabr AT ROW 5.17 COL 30.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.fam-uni-estab
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
         HEIGHT             = 7.25
         WIDTH              = 86.14.
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

/* SETTINGS FOR FILL-IN c-cd-plan IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-deposito IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-local IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nr-linha IN FRAME f-main
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

&Scoped-define SELF-NAME fam-uni-estab.cd-planejado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-uni-estab.cd-planejado V-table-Win
ON F5 OF fam-uni-estab.cd-planejado IN FRAME f-main /* Planejador */
DO:
    assign l-implanta = yes.
    {include/zoom.i &prog-zoom = "inzoom\z01in321.w"
                    &tabela = fam-uni-estab
                    &atributo = cd-planejado}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-uni-estab.cd-planejado V-table-Win
ON LEAVE OF fam-uni-estab.cd-planejado IN FRAME f-main /* Planejador */
DO:
    find first planejad 
        where planejad.cd-planejado = input frame {&frame-name} fam-uni-estab.cd-planejado no-lock no-error.
    assign c-cd-plan:screen-value = if  avail planejad 
                                    then planejad.nome 
                                    else "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-uni-estab.cd-planejado V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fam-uni-estab.cd-planejado IN FRAME f-main /* Planejador */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fam-uni-estab.nr-linha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-uni-estab.nr-linha V-table-Win
ON F5 OF fam-uni-estab.nr-linha IN FRAME f-main /* Linha Produá∆o */
DO:
    assign l-implanta = yes.
    {include/zoom.i &prog-zoom = "inzoom\z01in186.w"
                    &tabela    = fam-uni-estab
                    &atributo  = nr-linha}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-uni-estab.nr-linha V-table-Win
ON LEAVE OF fam-uni-estab.nr-linha IN FRAME f-main /* Linha Produá∆o */
DO:
    RUN Get-Field-Screen-Value IN adm-broker-hdl
       (INPUT this-procedure,
        INPUT "cod-estabel").
    find first lin-prod 
         where lin-prod.nr-linha    = input frame {&frame-name} fam-uni-estab.nr-linha 
           and lin-prod.cod-estabel = return-value no-lock no-error.
    assign c-nr-linha:screen-value = if  avail lin-prod 
                                     then lin-prod.descricao 
                                     else "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-uni-estab.nr-linha V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fam-uni-estab.nr-linha IN FRAME f-main /* Linha Produá∆o */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  if  fam-uni-estab.cd-planejado:load-mouse-pointer ("image~\lupa.cur") then.
  if  fam-uni-estab.nr-linha:load-mouse-pointer     ("image~\lupa.cur") then.

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
  {src/adm/template/row-list.i "fam-uni-estab"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "fam-uni-estab"}

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
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
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
  
    find deposito 
        where deposito.cod-depos = fam-uni-estab.deposito-pad no-lock no-error.

    find first localizacao 
         where localizacao.cod-localiz = fam-uni-estab.cod-localiz 
           and localizacao.cod-depos   = fam-uni-estab.deposito-pad no-lock no-error.

    find planejad 
        where planejad.cd-planejado = fam-uni-estab.cd-planejado no-lock no-error.

    assign c-deposito   = if avail deposito    then deposito.nome         else ""
           c-desc-local = if avail localizacao then localizacao.descricao else ""
           c-cd-plan    = if avail planejad    then planejad.nome         else "".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  apply "leave":U to fam-uni-estab.nr-linha in frame {&FRAME-NAME}.
      

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

    find first param-global no-lock no-error.
    
    find first localizacao 
        where localizacao.cod-depos    = fam-uni-estab.deposito-pad 
          and localizacao.cod-localiz  = fam-uni-estab.cod-localiz no-lock no-error.
    
    if  param-global.modulo-ce 
    and (avail localizacao 
    or   fam-uni-estab.cod-localiz = "") then 
        assign fam-uni-estab.deposito-pad:sensitive in frame {&frame-name} = false
               fam-uni-estab.cod-localiz:sensitive  = false.

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

  IF  AVAIL fam-uni-estab THEN
      ASSIGN gr-fam-uni-estab = ROWID(fam-uni-estab).
      
  FIND deposito WHERE deposito.cod-depos = fam-uni-estab.deposito-pad NO-LOCK NO-ERROR.
  IF  AVAIL deposito THEN
      ASSIGN gr-deposito = ROWID(deposito).
              
  FIND planejad WHERE planejad.cd-planejado = fam-uni-estab.cd-planejado NO-LOCK NO-ERROR.
  IF  AVAIL planejad THEN
      ASSIGN gr-planejad = ROWID(planejad).            
      
  FIND FIRST lin-prod WHERE lin-prod.nr-linha = fam-uni-estab.nr-linha NO-LOCK NO-ERROR.
  IF  AVAIL lin-prod THEN
      ASSIGN gr-lin-prod = ROWID(lin-prod).

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
    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */
    
   if  fam-uni-estab.deposito-pad:sensitive in frame {&frame-name} 
   and input frame {&frame-name} fam-uni-estab.deposito-pad <> "" then do:
       if  not can-find(deposito 
                  where deposito.cod-depos = input frame {&frame-name} fam-uni-estab.deposito-pad) then do:
            {utp/ut-table.i mgind deposito 1}
            run utp/ut-msgs.p (input "show",
                               input 56,
                               input return-value). 
            apply "entry" to fam-uni-estab.deposito-pad in frame {&frame-name}.
            return "adm-error".
        end.
    end.   
    
    if input frame {&frame-name} fam-uni-estab.cd-planejado <> "" then do:
        if  not can-find(planejad 
                   where planejad.cd-planejado = input frame {&frame-name} fam-uni-estab.cd-planejado) then do:
            {utp/ut-table.i mgind planejad 1}
            run utp/ut-msgs.p (input "show",
                               input 56,
                               input return-value). 
            apply "entry" to fam-uni-estab.cd-planejado in frame {&frame-name}.
            return "adm-error". 
        end.
    end.

    if avail param-global and param-global.modulo-cp then do:
        RUN Get-Field-Screen-Value IN adm-broker-hdl
            (INPUT this-procedure,
             INPUT "cod-estabel").
        find first lin-prod 
             where lin-prod.nr-linha = input frame {&frame-name} fam-uni-estab.nr-linha and
                   lin-prod.cod-estabel = return-value no-lock no-error.
        if  not avail lin-prod then do:
            {utp/ut-table.i mgind lin-prod 1}
            run utp/ut-msgs.p (input "show",
                               input 56,
                               input return-value). 
            apply "entry" to fam-uni-estab.nr-linha in frame {&frame-name}.
            return "adm-error".
        end.
    end. 
    
    if  fam-uni-estab.cod-localiz:sensitive in frame {&frame-name} 
    and input frame {&frame-name} fam-uni-estab.cod-localiz  <> "" then do:
        find first localizacao 
             where localizacao.cod-depos    = input frame {&frame-name} fam-uni-estab.deposito-pad 
               and localizacao.cod-localiz  = input frame {&frame-name} fam-uni-estab.cod-localiz  
             no-lock no-error.
        if  not available localizacao then do:
            {utp/ut-table.i mgind localizacao 1}
            run utp/ut-msgs.p (input "show",
                               input 8535,
                               input return-value). 
            apply "entry" to fam-uni-estab.cod-localiz in frame {&frame-name}.
            return "adm-error".
        end.
    end.    

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
  {src/adm/template/snd-list.i "fam-uni-estab"}

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

