&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
{include/i-prgvrs.i V02IN008 2.00.00.001}  /*** 010001 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v02in008 MUT}
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

def buffer b-mla-tipo-aprov-item for mla-tipo-aprov-item.

def new global shared var g-empresa-aed LIKE empresa.ep-codigo no-undo.

def var c-log-reg as char no-undo.

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
&Scoped-define EXTERNAL-TABLES mla-tipo-aprov-item
&Scoped-define FIRST-EXTERNAL-TABLE mla-tipo-aprov-item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR mla-tipo-aprov-item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS mla-tipo-aprov-item.nr-min-aprov ~
mla-tipo-aprov-item.log-limite 
&Scoped-define ENABLED-TABLES mla-tipo-aprov-item
&Scoped-define FIRST-ENABLED-TABLE mla-tipo-aprov-item
&Scoped-Define ENABLED-OBJECTS RECT-8 
&Scoped-Define DISPLAYED-FIELDS mla-tipo-aprov-item.cod-tip-aprov ~
mla-tipo-aprov-item.nr-min-aprov mla-tipo-aprov-item.log-limite 
&Scoped-define DISPLAYED-TABLES mla-tipo-aprov-item
&Scoped-define FIRST-DISPLAYED-TABLE mla-tipo-aprov-item
&Scoped-Define DISPLAYED-OBJECTS c-desc-tipo i-ind-tip-aprov 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS mla-tipo-aprov-item.cod-tip-aprov 

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
DEFINE VARIABLE c-desc-tipo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.72 BY .88 NO-UNDO.

DEFINE VARIABLE i-ind-tip-aprov AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Hierarquia", 1,
"Lista", 2,
"Padr∆o", 3,
"TÇcnica", 4,
"Faixa", 5
     SIZE 16.72 BY 4.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 79.29 BY 7.88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     mla-tipo-aprov-item.cod-tip-aprov AT ROW 1.38 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.86 BY .88
     c-desc-tipo AT ROW 1.38 COL 23.86 COLON-ALIGNED NO-LABEL
     i-ind-tip-aprov AT ROW 2.5 COL 22 HELP
          "Tipo de aprovaá∆o" NO-LABEL
     mla-tipo-aprov-item.nr-min-aprov AT ROW 6.63 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     mla-tipo-aprov-item.log-limite AT ROW 7.75 COL 22
          VIEW-AS TOGGLE-BOX
          SIZE 39.43 BY .83
     RECT-8 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.mla-tipo-aprov-item
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
         HEIGHT             = 7.88
         WIDTH              = 79.43.
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

/* SETTINGS FOR FILL-IN c-desc-tipo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN mla-tipo-aprov-item.cod-tip-aprov IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR RADIO-SET i-ind-tip-aprov IN FRAME f-main
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

&Scoped-define SELF-NAME mla-tipo-aprov-item.cod-tip-aprov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-tipo-aprov-item.cod-tip-aprov V-table-Win
ON F5 OF mla-tipo-aprov-item.cod-tip-aprov IN FRAME f-main /* C¢digo */
DO:

    {include/zoomvar.i &prog-zoom=inzoom/z01in779.w
                       &campo=mla-tipo-aprov-item.cod-tip-aprov
                       &campozoom=cod-tip-aprov}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-tipo-aprov-item.cod-tip-aprov V-table-Win
ON LEAVE OF mla-tipo-aprov-item.cod-tip-aprov IN FRAME f-main /* C¢digo */
DO:

   {include/leave.i &tabela=mla-tipo-aprov
                    &atributo-ref=des-tip-aprov
                    &variavel-ref=c-desc-tipo
                    &where="mla-tipo-aprov.cod-tip-aprov = input frame {&frame-name} mla-tipo-aprov-item.cod-tip-aprov"}

    if available mla-tipo-aprov then do:
        assign  i-ind-tip-aprov = mla-tipo-aprov.ind-tip-aprov.
        display i-ind-tip-aprov with frame {&frame-name}.
        if adm-new-record then
            assign mla-tipo-aprov-item.nr-min-aprov:screen-value in frame {&frame-name} =
                   string(mla-tipo-aprov.nr-min-aprov).
        if mla-tipo-aprov.ind-tip-aprov = 2 then
            assign mla-tipo-aprov-item.nr-min-aprov:sensitive in frame {&frame-name} = yes.
        else 
            assign mla-tipo-aprov-item.nr-min-aprov:screen-value in frame {&frame-name} = "0"
                   mla-tipo-aprov-item.nr-min-aprov:sensitive    in frame {&frame-name} = no.
                   
        if input frame {&frame-name} i-ind-tip-aprov = 2 then
            assign mla-tipo-aprov-item.log-limite:sensitive in frame {&frame-name} = yes.
        else
            assign mla-tipo-aprov-item.log-limite:sensitive in frame {&frame-name} = no
                   mla-tipo-aprov-item.log-limite:checked in frame {&frame-name} = no.
                   
    end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-tipo-aprov-item.cod-tip-aprov V-table-Win
ON MOUSE-SELECT-DBLCLICK OF mla-tipo-aprov-item.cod-tip-aprov IN FRAME f-main /* C¢digo */
DO:

    apply 'f5' to self.  
  
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

  if mla-tipo-aprov-item.cod-tip-aprov:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.

    {utp/ut-liter.i Somente_para_Aprovador_com_Limite * r}
    assign mla-tipo-aprov-item.log-limite:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "mla-tipo-aprov-item"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "mla-tipo-aprov-item"}

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

    assign mla-tipo-aprov-item.log-limite:sensitive in frame {&frame-name} = no
           mla-tipo-aprov-item.log-limite:checked in frame {&frame-name} = no.

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

    find first item where
        rowid(item) = v-row-parent
        no-lock no-error.
    if adm-new-record then do:
        find first b-mla-tipo-aprov-item where
            b-mla-tipo-aprov-item.ep-codigo     = g-empresa-aed and
            b-mla-tipo-aprov-item.it-codigo     = item.it-codigo and
            b-mla-tipo-aprov-item.cod-tip-aprov = input frame {&frame-name} 
                                                  mla-tipo-aprov-item.cod-tip-aprov
            no-lock no-error.
        if available b-mla-tipo-aprov-item then do:                                                  
            {utp/ut-table.i mgind mla-tipo-aprov-item 1}
            run utp/ut-msgs.p ("show",1,trim(return-value)).
            apply "entry" to mla-tipo-aprov-item.cod-tip-aprov in frame {&frame-name}.
            return "adm-error".                    
        end.
        
        find first mla-tipo-aprov where
            mla-tipo-aprov.cod-tip-aprov = input frame {&frame-name} mla-tipo-aprov-item.cod-tip-aprov
            no-lock no-error.
        if not available mla-tipo-aprov then do:
            {utp/ut-table.i mgind mla-tipo-aprov 1}
            run utp/ut-msgs.p ("show",2,trim(return-value)).
            apply "entry" to mla-tipo-aprov-item.cod-tip-aprov in frame {&frame-name}.
            return "adm-error".                    
        end.
    end.

    if not adm-new-record then
        run pi-log-reg.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    if adm-new-record then do:
        create mla-log-reg.
        assign mla-log-reg.ep-codigo   = mla-tipo-aprov-item.ep-codigo
               mla-log-reg.cod-estabel = ""
               mla-log-reg.cod-usuar   = c-seg-usuario
               mla-log-reg.cod-tabela  = 20
               mla-log-reg.chave-reg   = string(mla-tipo-aprov-item.it-codigo) + " | " +
                                         string(mla-tipo-aprov-item.cod-tip-aprov)
               mla-log-reg.data-reg    = today
               mla-log-reg.hora-reg    = string(time,"hh:mm")
               mla-log-reg.tipo-reg    = 1
               mla-log-reg.log-reg     = entry(20,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                         "Item               : " + string(mla-tipo-aprov-item.it-codigo)        + chr(13) + 
                                         "Tipo Aprovaá∆o     : " + string(mla-tipo-aprov-item.cod-tip-aprov)    + chr(13) + 
                                         "Prioridade Aprov   : " + string(mla-tipo-aprov-item.prioridade-aprov) + chr(13) +                                      
                                         "Nr M°nimo Aprov    : " + string(mla-tipo-aprov-item.nr-min-aprov)     + chr(13) +                                      
                                         "Log Limite         : " + string(mla-tipo-aprov-item.log-limite).              
    end.
    
    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

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

    find first item where
        rowid(item) = v-row-parent
        no-lock no-error.
    if available item then
        assign mla-tipo-aprov-item.it-codigo = item.it-codigo.

    assign mla-tipo-aprov-item.ep-codigo = g-empresa-aed.

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

    if available mla-tipo-aprov-item then do:
        find first mla-tipo-aprov where
            mla-tipo-aprov.cod-tip-aprov = mla-tipo-aprov-item.cod-tip-aprov
            no-lock no-error.
        if available mla-tipo-aprov then do:
            assign  i-ind-tip-aprov = mla-tipo-aprov.ind-tip-aprov
                    c-desc-tipo     = mla-tipo-aprov.des-tip-aprov.
            display i-ind-tip-aprov 
                    c-desc-tipo 
                    with frame {&frame-name}.
        end.
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
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

    if available mla-tipo-aprov-item then do:
        if input frame {&frame-name} i-ind-tip-aprov = 2 then
            assign mla-tipo-aprov-item.log-limite:sensitive in frame {&frame-name} = yes.
        else
            assign mla-tipo-aprov-item.log-limite:sensitive in frame {&frame-name} = no
                   mla-tipo-aprov-item.log-limite:checked in frame {&frame-name} = no.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-log-reg V-table-Win 
PROCEDURE pi-log-reg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    assign c-log-reg = "".
    
    if available mla-tipo-aprov-item then do:
        if mla-tipo-aprov-item.nr-min-aprov <> input frame {&frame-name} mla-tipo-aprov-item.nr-min-aprov then
            assign c-log-reg = c-log-reg + 
                   "Nr M°nimo Aprov    : " + string(mla-tipo-aprov-item.nr-min-aprov) + chr(13) +             
                   "                   : " + string(input frame {&frame-name} mla-tipo-aprov-item.nr-min-aprov) + chr(13) + chr(13).
        if mla-tipo-aprov-item.log-limite <> mla-tipo-aprov-item.log-limite:checked in frame {&frame-name} then
            assign c-log-reg = c-log-reg + 
                   "Log Limite         : " + string(mla-tipo-aprov-item.log-limite) + chr(13) +             
                   "                   : " + string(mla-tipo-aprov-item.log-limite:checked in frame {&frame-name}) + chr(13) + chr(13).
    end.
    
    if c-log-reg <> "" then do:
        create mla-log-reg.
        assign mla-log-reg.ep-codigo   = mla-tipo-aprov-item.ep-codigo
               mla-log-reg.cod-estabel = ""
               mla-log-reg.cod-usuar   = c-seg-usuario
               mla-log-reg.cod-tabela  = 20
               mla-log-reg.chave-reg   = string(mla-tipo-aprov-item.it-codigo) + " | " +
                                         string(mla-tipo-aprov-item.cod-tip-aprov)
               mla-log-reg.data-reg    = today
               mla-log-reg.hora-reg    = string(time,"hh:mm")
               mla-log-reg.tipo-reg    = 2
               mla-log-reg.log-reg     = entry(20,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                         c-log-reg.
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
    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */
    
/*/*    Segue um exemplo de validaá∆o de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/

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
  {src/adm/template/snd-list.i "mla-tipo-aprov-item"}

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

