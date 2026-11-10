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
{include/i-prgvrs.i V04IN090 2.00.00.012}  /*** 010012 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v04in090 MUT}
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

def var h-handle-aux1 as handle no-undo.
def var l-inclui as l no-undo init no.
def var c-natureza like docum-est.nat-operacao.
def var i-especie like docum-est.esp-docto.
def var i-observa  like docum-est.cod-observ.

{rep/re9999.i1}
{rep/re9999.i2 "new"}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES docum-est
&Scoped-define FIRST-EXTERNAL-TABLE docum-est


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR docum-est.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS docum-est.base-iss docum-est.iss-deb-cre ~
docum-est.base-ipi docum-est.ipi-deb-cre docum-est.icm-fonte ~
docum-est.base-subs docum-est.vl-subs docum-est.base-icm ~
docum-est.icm-deb-cre 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}base-iss ~{&FP2}base-iss ~{&FP3}~
 ~{&FP1}iss-deb-cre ~{&FP2}iss-deb-cre ~{&FP3}~
 ~{&FP1}base-ipi ~{&FP2}base-ipi ~{&FP3}~
 ~{&FP1}ipi-deb-cre ~{&FP2}ipi-deb-cre ~{&FP3}~
 ~{&FP1}icm-fonte ~{&FP2}icm-fonte ~{&FP3}~
 ~{&FP1}base-subs ~{&FP2}base-subs ~{&FP3}~
 ~{&FP1}vl-subs ~{&FP2}vl-subs ~{&FP3}~
 ~{&FP1}base-icm ~{&FP2}base-icm ~{&FP3}~
 ~{&FP1}icm-deb-cre ~{&FP2}icm-deb-cre ~{&FP3}
&Scoped-define ENABLED-TABLES docum-est
&Scoped-define FIRST-ENABLED-TABLE docum-est
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS docum-est.base-iss docum-est.iss-deb-cre ~
docum-est.dt-venc-iss docum-est.base-ipi docum-est.ipi-deb-cre ~
docum-est.dt-venc-ipi docum-est.icm-fonte docum-est.base-subs ~
docum-est.vl-subs docum-est.base-icm docum-est.icm-deb-cre ~
docum-est.dt-venc-icm 
&Scoped-Define DISPLAYED-OBJECTS i-aliq-icm-com 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS docum-est.base-iss docum-est.iss-deb-cre ~
docum-est.dt-venc-iss docum-est.base-ipi docum-est.ipi-deb-cre ~
docum-est.dt-venc-ipi docum-est.icm-fonte docum-est.base-subs ~
docum-est.vl-subs docum-est.base-icm docum-est.icm-deb-cre ~
docum-est.dt-venc-icm i-aliq-icm-com 

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
DEFINE VARIABLE i-aliq-icm-com AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Al°quota ICMS Complementar":R31 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84.86 BY 11.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     docum-est.base-iss AT ROW 1.83 COL 30.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     docum-est.iss-deb-cre AT ROW 2.83 COL 30.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     docum-est.dt-venc-iss AT ROW 2.83 COL 68.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     docum-est.base-ipi AT ROW 3.83 COL 30.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     docum-est.ipi-deb-cre AT ROW 4.83 COL 30.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     docum-est.dt-venc-ipi AT ROW 4.83 COL 68.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     docum-est.icm-fonte AT ROW 5.83 COL 30.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     docum-est.base-subs AT ROW 6.83 COL 30.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     docum-est.vl-subs AT ROW 7.83 COL 30.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.57 BY .88
     docum-est.base-icm AT ROW 8.83 COL 30.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     docum-est.icm-deb-cre AT ROW 9.83 COL 30.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     docum-est.dt-venc-icm AT ROW 9.83 COL 68.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     i-aliq-icm-com AT ROW 10.83 COL 30.29 COLON-ALIGNED
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.docum-est
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
         HEIGHT             = 12.04
         WIDTH              = 87.43.
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

/* SETTINGS FOR FILL-IN docum-est.base-icm IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN docum-est.base-ipi IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN docum-est.base-iss IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN docum-est.base-subs IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN docum-est.dt-venc-icm IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN docum-est.dt-venc-ipi IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN docum-est.dt-venc-iss IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN i-aliq-icm-com IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN docum-est.icm-deb-cre IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN docum-est.icm-fonte IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN docum-est.ipi-deb-cre IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN docum-est.iss-deb-cre IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN docum-est.vl-subs IN FRAME f-main
   2                                                                    */
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

&Scoped-define SELF-NAME docum-est.icm-deb-cre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.icm-deb-cre V-table-Win
ON LEAVE OF docum-est.icm-deb-cre IN FRAME f-main /* Valor ICMS */
DO:
    find first param-global no-lock no-error.
    find empresa where
         empresa.ep-codigo = param-global.empresa-prin no-lock no-error.
    find first param-fasb where
         param-fasb.ep-codigo = empresa.ep-codigo no-lock no-error.

    assign docum-est.dt-venc-icm:sensitive in frame {&frame-name} =
        (avail param-fasb and (input frame {&frame-name} docum-est.icm-deb-cre > 0 or l-retorno)).
    if docum-est.dt-venc-icm:sensitive in frame {&frame-name} = yes then do:
        if l-inclui then do:
            RUN Get-Field-Screen-Value IN adm-broker-hdl
               (INPUT this-procedure, INPUT "dt-trans").
            assign docum-est.dt-venc-icm:screen-value in frame {&frame-name} = return-value.
        end.
        apply "entry" to docum-est.dt-venc-icm in frame {&frame-name}.
        return no-apply.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.ipi-deb-cre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.ipi-deb-cre V-table-Win
ON LEAVE OF docum-est.ipi-deb-cre IN FRAME f-main /* Valor IPI */
DO:
    find first param-global no-lock no-error.
    find empresa where
         empresa.ep-codigo = param-global.empresa-prin no-lock no-error.
    find first param-fasb where
         param-fasb.ep-codigo = empresa.ep-codigo no-lock no-error.

    assign docum-est.dt-venc-ipi:sensitive in frame {&frame-name} =
        (avail param-fasb and (input frame {&frame-name} docum-est.ipi-deb-cre > 0 or l-retorno)).
    if docum-est.dt-venc-ipi:sensitive in frame {&frame-name} = yes then do:
        if l-inclui then do:
            RUN Get-Field-Screen-Value IN adm-broker-hdl
               (INPUT this-procedure, INPUT "dt-trans").
            assign docum-est.dt-venc-ipi:screen-value in frame {&frame-name} = return-value.
        end.
        apply "entry" to docum-est.dt-venc-ipi in frame {&frame-name}.
        return no-apply.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.iss-deb-cre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.iss-deb-cre V-table-Win
ON LEAVE OF docum-est.iss-deb-cre IN FRAME f-main /* Valor ISS */
DO:
    find first param-global no-lock no-error.
    find empresa where
         empresa.ep-codigo = param-global.empresa-prin no-lock no-error.
    find first param-fasb where
         param-fasb.ep-codigo = empresa.ep-codigo no-lock no-error.

    assign docum-est.dt-venc-iss:sensitive in frame {&FRAME-NAME} =
                (avail param-fasb and(input frame {&frame-name} docum-est.iss-deb-cre > 0)).
    if docum-est.dt-venc-iss:sensitive in frame {&frame-name} = yes then do:
        if l-inclui then do:
            RUN Get-Field-Screen-Value IN adm-broker-hdl
               (INPUT this-procedure, INPUT "dt-trans").
            assign docum-est.dt-venc-iss:screen-value in frame {&frame-name} = return-value.
        end.
        apply "entry" to docum-est.dt-venc-iss in frame {&frame-name}.
        return no-apply.
    end.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  find first param-global no-lock no-error.
  find param-re where param-re.usuario = c-seg-usuario no-lock no-error.
  
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
  {src/adm/template/row-list.i "docum-est"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "docum-est"}

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
  do  with frame {&FRAME-NAME}:
      assign docum-est.dt-venc-iss:sensitive in frame {&frame-name} = no
             docum-est.dt-venc-ipi:sensitive in frame {&frame-name} = no
             docum-est.dt-venc-icm:sensitive in frame {&frame-name} = no.
  end.
  assign l-inclui = yes.

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
  /* Dispatch standard ADM method.   */   
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */
  
/*  assign docum-est.iss-deb-cre = input frame {&frame-name} docum-est.iss-deb-cre
         docum-est.icm-deb-cre = input frame {&frame-name} docum-est.icm-deb-cre
         docum-est.ipi-deb-cre = input frame {&frame-name} docum-est.ipi-deb-cre.
*/         
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

  find natur-oper where 
       natur-oper.nat-operacao = docum-est.nat-operacao
       no-lock no-error.
  if avail natur-oper then
     assign i-aliq-icm-com = natur-oper.aliq-icm-com.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-campo V-table-Win 
PROCEDURE pi-inicializa-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param p-natureza as character no-undo.
def input param p-especie  as integer   no-undo.
def input param p-observa  as integer   no-undo.

assign c-natureza = p-natureza 
       i-especie  = p-especie
       i-observa  = p-observa.

find first param-global no-lock no-error.
find param-re where param-re.usuario = c-seg-usuario no-lock no-error.
find natur-oper where natur-oper.nat-operacao = p-natureza no-lock no-error.
find empresa where
     empresa.ep-codigo = param-global.empresa-prin no-lock no-error.
find first param-fasb where
     param-fasb.ep-codigo = empresa.ep-codigo no-lock no-error.

if avail natur-oper then
   assign i-aliq-icm-com:screen-value in frame {&FRAME-NAME} = string(natur-oper.aliq-icm-com).

if   l-inclui = no 
 and avail param-fasb 
 and avail docum-est then do with frame {&frame-name}:
    run pi-seta-flags-observacao in this-procedure
        (input i-observa, input docum-est.nat-operacao).
         assign docum-est.dt-venc-iss:sensitive in frame {&frame-name} =
                        (input frame {&frame-name} docum-est.iss-deb-cre <> 0)
               docum-est.dt-venc-ipi:sensitive in frame {&frame-name} =
                        (input frame {&frame-name} docum-est.ipi-deb-cre <> 0
                         or l-retorno)
               docum-est.dt-venc-icm:sensitive in frame {&frame-name} =
                        (input frame {&frame-name} docum-est.icm-deb-cre <> 0 
                         or l-retorno).

end.

assign docum-est.base-icm:sensitive in frame {&frame-name} = no
       docum-est.base-ipi:sensitive in frame {&frame-name} = no
       docum-est.base-iss:sensitive in frame {&frame-name} = no
       docum-est.iss-deb-cre:sensitive in frame {&frame-name} = no
       docum-est.base-subs:sensitive in frame {&frame-name} = no
       docum-est.icm-deb-cre:sensitive in frame {&frame-name} = no
/*       docum-est.icm-fonte:sensitive in frame {&frame-name} = no*/
       docum-est.ipi-deb-cre:sensitive in frame {&frame-name} = no
       docum-est.vl-subs:sensitive in frame {&frame-name} = no.

if l-inclui = no and avail natur-oper then do  with frame {&frame-name}: 
    assign i-aliq-icm-com = natur-oper.aliq-icm-com.

    run pi-seta-flags-observacao in this-procedure
        (input p-observa, input p-natureza).
    if  l-servicos 
    or  (input frame {&frame-name} docum-est.base-iss <> 0
    and  input frame {&frame-name} docum-est.iss-deb-cre <> 0)
    then do with frame {&frame-name}:
       if avail param-re and param-re.ped-imp-nota then
            assign docum-est.base-iss:sensitive in frame {&frame-name} = yes
                   docum-est.iss-deb-cre:sensitive in frame {&frame-name} = yes.
       if  l-servicos then do:
            assign docum-est.base-icm:screen-value in frame {&frame-name}    = "0"
                   docum-est.base-ipi:screen-value in frame {&frame-name}    = "0"
                   docum-est.icm-deb-cre:screen-value in frame {&frame-name} = "0"
                   docum-est.icm-fonte:screen-value in frame {&frame-name}   = "0"
                   docum-est.ipi-deb-cre:screen-value in frame {&frame-name} = "0"
                   docum-est.base-subs:screen-value in frame {&frame-name}   = "0"
                   docum-est.vl-subs:screen-value in frame {&frame-name}     = "0".
       end.

       
    end.
    if l-servicos = no then do:
       if avail param-re and param-re.ped-imp-nota then
            assign docum-est.base-icm:sensitive in frame {&frame-name}    = yes
                   docum-est.base-ipi:sensitive in frame {&frame-name}    = yes
                   docum-est.icm-deb-cre:sensitive in frame {&frame-name} = yes
                   docum-est.icm-fonte:sensitive in frame {&frame-name}   = yes
                   docum-est.ipi-deb-cre:sensitive in frame {&frame-name} = yes                   
                   docum-est.base-subs:sensitive in frame {&frame-name}   = natur-oper.subs-trib
                   docum-est.vl-subs:sensitive in frame {&frame-name}     = natur-oper.subs-trib.
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
def var l-sem-valor as logical no-undo.
  
{include/i-vldfrm.i} /* Validaá∆o de dicion†rio */
   
if l-inclui = no and avail docum-est then do:

    run rep/re9990.p (input rowid(docum-est), input no). 
    /* o segundo parÉmetro indica que o programa somente ir† calcular os valores 
       totais do documento e n∆o ir† atualiz†-lo. */
    
    assign de-valor-total = de-valor-total + input frame {&frame-name} docum-est.icm-fonte.

    run pi-seta-flags-observacao in this-procedure
        (input i-observa, input docum-est.nat-operacao).

    run rep/re9997.p (input rowid(docum-est), 
                      input de-iss-base, input input frame {&FRAME-NAME} docum-est.base-iss, 
                      input 5504, 
                      input yes).

    if  l-servicos 
    or  (input frame {&frame-name} docum-est.base-iss <> 0
    and  input frame {&frame-name} docum-est.iss-deb-cre <> 0)
    then do with frame {&frame-name}:
        if input frame {&frame-name} docum-est.base-iss <> de-iss-base and
           not l-sem-valor then do:
            {include/i-vldprg.i} 
            {utp/ut-liter.i Base_ISS  MRE R}
            run utp/ut-msgs.p (input "show":U, input 6164, input return-value).
            if  return-value = "yes" then do:
                apply "entry" to docum-est.base-iss in frame {&frame-name}.
                return 'ADM-ERROR':U.
            end.
            run rep/re9997.p (input rowid(docum-est), 
                              input de-iss-base, input input frame {&FRAME-NAME} docum-est.base-iss, 
                              input 5504, 
                              input no).
        end.
        /* Verifica se o valor do ISS e maior que a base. */
        if input frame {&frame-name} docum-est.iss-deb-cre > input frame {&frame-name} docum-est.base-iss and
           input frame {&FRAME-NAME} docum-est.base-iss > 0 then do:
            {include/i-vldprg.i} 
            run utp/ut-msgs.p (input "show":U, input 5505, input "").
            apply "entry" to docum-est.iss-deb-cre in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
        if input frame {&frame-name} docum-est.iss-deb-cre <> de-ISS-deb-cre and
           not l-sem-valor then do:
            {include/i-vldprg.i} 
            {utp/ut-liter.i Valor_ISS  MRE R}
            run utp/ut-msgs.p (input "show":U, input 6164, input return-value).
            if  return-value = "yes" then do:
                apply "entry" to docum-est.iss-deb-cre in frame {&frame-name}.
                return 'ADM-ERROR':U.
            end.
            run rep/re9997.p (input rowid(docum-est), 
                              input de-iss-deb-cre, input input frame {&frame-name} docum-est.iss-deb-cre, 
                              input 5505, 
                              input  no).
        end.
        else do:
            run rep/re9997.p (input rowid(docum-est), 
                              input de-iss-deb-cre, input input frame {&frame-name} docum-est.iss-deb-cre, 
                              input 5505, 
                              input yes).
        end.
    end.
    if l-servicos = no then do:
        if input frame {&FRAME-NAME} docum-est.base-ipi <> de-IPI-base and
           not l-sem-valor then do:
            {include/i-vldprg.i} 
            {utp/ut-liter.i Base_IPI  MRE R}
            run utp/ut-msgs.p (input "show":U, input 6164, input return-value).
            if  return-value = "yes" then do:
                apply "entry" to docum-est.base-ipi in frame {&frame-name}.
                return 'ADM-ERROR':U.
            end.
            run rep/re9997.p (input rowid(docum-est), 
                              input de-ipi-base, input input frame {&FRAME-NAME} docum-est.base-ipi, 
                              input 5506, 
                              input no).
        end.
        else do:
            run rep/re9997.p (input rowid(docum-est), 
                              input de-ipi-base, input input frame {&FRAME-NAME} docum-est.base-ipi, 
                              input 5506, 
                              input yes).
        end.
        if input frame {&frame-name} docum-est.ipi-deb-cre <> de-IPI-deb-cre and
           not l-sem-valor then do:
            {include/i-vldprg.i} 
            {utp/ut-liter.i Valor_IPI  MRE R}
            run utp/ut-msgs.p (input "show":U, input 6164, input return-value).
            if  return-value = "yes" then do:
                apply "entry" to docum-est.ipi-deb-cre in frame {&frame-name}.
                return 'ADM-ERROR':U.
            end.
            run rep/re9997.p (input rowid(docum-est), 
                              input de-ipi-deb-cre, input input frame {&frame-name} docum-est.ipi-deb-cre, 
                              input 5507, 
                              input no).
        end.
        else do:
            run rep/re9997.p (input rowid(docum-est), 
                              input de-ipi-deb-cre, input input frame {&frame-name} docum-est.ipi-deb-cre, 
                              input 5507, 
                              input yes).
        end.
        if  input frame {&FRAME-NAME} docum-est.base-subs <> de-ICM-base
        and natur-oper.subs-trib
        and not(l-entrada and l-devolucao and param-global.modulo-ft)
        then do:
            {include/i-vldprg.i} 
            {utp/ut-liter.i Base_Subst MRE R}
            run utp/ut-msgs.p (input "show":U, input 6164, input return-value).
            if  return-value = "yes" then do:
                apply "entry" to docum-est.base-subs in frame {&frame-name}.
                return 'ADM-ERROR':U.
            end.
            run rep/re9997.p (input rowid(docum-est), 
                              input de-icm-base, input input frame {&FRAME-NAME} docum-est.base-subs, 
                              input 5515, 
                              input no).
        end.
        else do:
            run rep/re9997.p (input rowid(docum-est), 
                              input de-icm-base, input input frame {&FRAME-NAME} docum-est.base-subs, 
                              input 5515, 
                              input yes).
        end.
        /* Verifica se o valor do ICMS Sub. e maior que a base. */
        if input frame {&FRAME-NAME} docum-est.vl-subs > input frame {&FRAME-NAME} docum-est.base-subs and
           input frame {&FRAME-NAME} docum-est.base-subs > 0 then do:
            {include/i-vldprg.i} 
            run utp/ut-msgs.p (input "show":U, input 5516, input "").
            apply "entry" to docum-est.vl-subs in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
        if input frame {&FRAME-NAME} docum-est.base-icm <> de-ICM-base and
           not l-sem-valor then do:
            {include/i-vldprg.i} 
            {utp/ut-liter.i Base_ICMS  MRE R}
            run utp/ut-msgs.p (input "show":U, input 6164, input return-value).
            if  return-value = "yes" then do:
                apply "entry" to docum-est.base-icm  in frame {&frame-name}.
                return 'ADM-ERROR':U.
            end.
            run rep/re9997.p (input rowid(docum-est), 
                              input de-icm-base, input input frame {&FRAME-NAME} docum-est.base-icm, 
                              input 5508, 
                              input no).
        end.
        else do:
            run rep/re9997.p (input rowid(docum-est), 
                              input de-icm-base, input input frame {&FRAME-NAME} docum-est.base-icm, 
                              input 5508, 
                              input yes).
        end.
        /* Verifica se o valor do ICM e maior que a base. */
        if input frame {&frame-name} docum-est.icm-deb-cre > input frame {&frame-name} docum-est.base-icm and
           input frame {&FRAME-NAME} docum-est.base-icm > 0 then do:
            {include/i-vldprg.i} 
            run utp/ut-msgs.p (input "show":U, input 5509, input "").
            apply "entry" to docum-est.icm-deb-cre in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
        if input frame {&frame-name} docum-est.icm-deb-cre <> de-ICM-deb-cre and
           not l-sem-valor then do:
            {include/i-vldprg.i} 
            {utp/ut-liter.i Valor_ICM  MRE R}
            run utp/ut-msgs.p (input "show":U, input 6164, input return-value).
            if  return-value = "yes" then do:
                apply "entry" to docum-est.icm-deb-cre  in frame {&frame-name}.
                return 'ADM-ERROR':U.
            end.
            run rep/re9997.p (input rowid(docum-est), 
                              input de-icm-deb-cre, input input frame {&frame-name} docum-est.icm-deb-cre, 
                              input 5509, 
                              input no).
        end.
        else do:
            run rep/re9997.p (input rowid(docum-est), 
                              input de-icm-deb-cre, input input frame {&frame-name} docum-est.icm-deb-cre, 
                              input 5509, 
                              input yes).
        end.
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
  {src/adm/template/snd-list.i "docum-est"}

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


