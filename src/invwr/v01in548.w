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
{include/i-prgvrs.i V01IN548 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN548 MUT}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

def var v-row-parent as rowid no-undo.
def var c-lista      as char format "x(40)" no-undo.
def var c-lista-aux  as char format "x(40)" no-undo.
def var c-tela       as char format "x(20)" no-undo.
def var c-cod-aux    as char format "x(08)" no-undo.

def buffer b-regra-vis-man for regra-vis-man.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES regra-vis-man
&Scoped-define FIRST-EXTERNAL-TABLE regra-vis-man


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR regra-vis-man.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS regra-vis-man.seq-regra 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}seq-regra ~{&FP2}seq-regra ~{&FP3}
&Scoped-define ENABLED-TABLES regra-vis-man
&Scoped-define FIRST-ENABLED-TABLE regra-vis-man
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold c-it-fm 
&Scoped-Define DISPLAYED-FIELDS regra-vis-man.cod-visao ~
regra-vis-man.seq-regra 
&Scoped-Define DISPLAYED-OBJECTS c-desc cb-dim1 i-ge c-it-fm 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS cb-dim1 

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
DEFINE VARIABLE cb-dim1 AS CHARACTER FORMAT "X(50)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS " "
     SIZE 25.14 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 41.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-fm AS CHARACTER FORMAT "X(16)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-ge AS INTEGER FORMAT "99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 79.86 BY 2.33.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 79.86 BY 1.67.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     regra-vis-man.cod-visao AT ROW 1.17 COL 19.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     c-desc AT ROW 1.17 COL 35.72 COLON-ALIGNED NO-LABEL
     regra-vis-man.seq-regra AT ROW 2.17 COL 19.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     cb-dim1 AT ROW 3.79 COL 19.14 COLON-ALIGNED
     i-ge AT ROW 3.8 COL 45 COLON-ALIGNED NO-LABEL
     c-it-fm AT ROW 3.8 COL 45 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 3.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: Mgind.regra-vis-man
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
         HEIGHT             = 4.21
         WIDTH              = 80.29.
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

/* SETTINGS FOR FILL-IN c-desc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-dim1 IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN regra-vis-man.cod-visao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-ge IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       i-ge:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME c-it-fm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-fm V-table-Win
ON F5 OF c-it-fm IN FRAME f-main
DO:
    assign c-tela    = input frame {&frame-name} cb-dim1
           c-cod-aux = substr(c-tela,1,6).
    if c-cod-aux = "MAN011" then do:  
        {include/zoomvar.i &prog-zoom="inzoom/z01in172.w"
                           &campo=c-it-fm
                           &campozoom=it-codigo}  
    end.
    else do:
        run pi-chama-zoom.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-it-fm V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-it-fm IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-dim1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-dim1 V-table-Win
ON VALUE-CHANGED OF cb-dim1 IN FRAME f-main
DO:
    assign c-tela    = input frame {&frame-name} cb-dim1
           c-cod-aux = substr(c-tela,1,6).

    if c-cod-aux = "MAN011" or
       c-cod-aux = "MAT002" then
       assign c-it-fm:sensitive    in frame {&frame-name} = yes
              c-it-fm:hidden       in frame {&frame-name} = no
              c-it-fm:screen-value in frame {&frame-name} = ""
              i-ge:sensitive       in frame {&frame-name} = no
              i-ge:hidden          in frame {&frame-name} = yes
              i-ge:screen-value    in frame {&frame-name} = "0".
    else
       assign c-it-fm:sensitive    in frame {&frame-name} = no
              c-it-fm:hidden       in frame {&frame-name} = yes
              c-it-fm:screen-value in frame {&frame-name} = ""              
              i-ge:sensitive       in frame {&frame-name} = yes
              i-ge:hidden          in frame {&frame-name} = no
              i-ge:screen-value    in frame {&frame-name} = "0".                  
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-ge
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ge V-table-Win
ON F5 OF i-ge IN FRAME f-main
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in142.w"
                       &campo=i-ge
                       &campozoom=ge-codigo}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ge V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-ge IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

if c-it-fm:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
if i-ge:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "regra-vis-man"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "regra-vis-man"}

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

  if avail visao-man then do:
     disp visao-man.cod-visao @ regra-vis-man.cod-visao
          visao-man.des-visao @ c-desc
          with frame {&frame-name}.

    find last  b-regra-vis-man
         where b-regra-vis-man.cod-visao = visao-man.cod-visao no-lock no-error.
    assign regra-vis-man.seq-regra:screen-value in frame {&frame-name} = if avail b-regra-vis-man 
                                                                         then string(b-regra-vis-man.seq-regra + 10)
                                                                         else "10".
  end.
  
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
    /*{include/i-valid.i}*/
    if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
      
    assign c-it-fm   = input frame {&frame-name} c-it-fm
           i-ge      = input frame {&frame-name} i-ge
           c-tela    = input frame {&frame-name} cb-dim1
           c-cod-aux = substr(c-tela,1,6).
    
    if c-cod-aux = "MAN011" then do:
        find first item where
             item.it-codigo = c-it-fm no-lock no-error.
        if not avail item then do:
            {utp/ut-field.i mgind item it-codigo 01}
            run utp/ut-msgs.p (input 'show', input 56, input return-value).
            apply "entry" to c-it-fm in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
    end.
    else if c-cod-aux = "MAT002" then do:
        find first familia where
             familia.fm-codigo = c-it-fm no-lock no-error.
        if not avail familia then do:
            {utp/ut-field.i mgind familia fm-codigo 01}
            run utp/ut-msgs.p (input 'show', input 56, input return-value).
            apply "entry" to c-it-fm in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.          
    end.
    else if c-cod-aux = "MAT003" then do:
        find first grup-estoque where
             grup-estoque.ge-codigo = i-ge no-lock no-error.
        if not avail grup-estoque then do:
            {utp/ut-field.i mgind grup-estoque ge-codigo 01}
            run utp/ut-msgs.p (input 'show', input 56, input return-value).
            apply "entry" to i-ge in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.     
    end.
          
    /* Ponha na pi-validate todas as valida‡äes */
    /* NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

    if c-cod-aux = "MAN011" or
       c-cod-aux = "MAT002" then do:
        find first dim-man
             where dim-man.cod-dim-man = c-cod-aux no-lock no-error.
        assign regra-vis-man.des-regra = dim-man.des-dimensao + " = " + c-it-fm
               regra-vis.cod-dim1      = dim-man.cod-dim-man
               regra-vis.res-dim1      = c-it-fm.
    end.
    else do:
        find first dim-man
             where dim-man.cod-dim-man = c-cod-aux no-lock no-error.
        assign regra-vis-man.des-regra = dim-man.des-dimensao + " = " + string(i-ge)
               regra-vis.cod-dim1      = dim-man.cod-dim-man
               regra-vis.res-dim1      = string(i-ge).
    end.
       
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

    find visao-man  where rowid(visao-man) = v-row-parent no-error.
    if available visao-man  then do:
        assign regra-vis-man.cod-visao = visao-man.cod-visao.
    end.
    
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

  /* Code placed here will execute AFTER standard behavior.    */

  if avail regra-vis-man and not adm-new-record then do:
      find first visao-man
           where visao-man.cod-visao = regra-vis-man.cod-visao no-lock no-error.
      assign c-desc:screen-value in frame {&frame-name} = visao-man.des-visao.
      
      if regra-vis-man.cod-dim1 = "MAT003" then do:
           disp int(regra-vis-man.res-dim1) @ i-ge with frame {&frame-name}.
           assign c-it-fm:sensitive in frame {&frame-name} = no
                  c-it-fm:hidden    in frame {&frame-name} = yes
                  i-ge:sensitive    in frame {&frame-name} = yes
                  i-ge:hidden       in frame {&frame-name} = no.
      end.
      else disp regra-vis-man.res-dim1 @ c-it-fm with frame {&frame-name}.
     
      find first dim-man
           where dim-man.cod-dim-man = regra-vis-man.cod-dim1
           no-lock no-error.
      if avail dim-man then do:
        assign c-lista-aux = dim-man.cod-dim-man + " - " + dim-man.des-dimensao
               cb-dim1     = c-lista-aux.
  
        disp cb-dim1
             with frame {&frame-name}.     
      end.
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
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    assign regra-vis-man.seq-regra:sensitive in frame {&frame-name} = no.    

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

   for each dim-man
         where dim-man.cod-dim-man = "MAN011" or
               dim-man.cod-dim-man = "MAT002" or
               dim-man.cod-dim-man = "MAT003":
        if c-lista = "" then
            assign c-lista     = dim-man.cod-dim-man + ' - ' + dim-man.des-dimensao
                   c-lista-aux = c-lista.
        else
            assign c-lista = c-lista + ',' + dim-man.cod-dim-man + ' - ' + dim-man.des-dimensao.
   end.
   
   assign cb-dim1:list-items in frame {&frame-name} = c-lista
          cb-dim1 = c-lista-aux.

  {utp/ut-field.i mgind regra-vis-man cod-dim1 01}
  assign cb-dim1:label in frame {&frame-name} = return-value.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  disp cb-dim1
       with frame {&frame-name}.
       
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
    
    find visao-man  where rowid(visao-man) = v-row-parent no-error.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-chama-zoom V-table-Win 
PROCEDURE pi-chama-zoom :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{include/zoomvar.i &prog-zoom="inzoom/z01in122.w"
                   &campo=c-it-fm
                   &campozoom=fm-codigo}  
                           
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
    
/*/*    Segue um exemplo de valida‡Æo de programa */
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
  {src/adm/template/snd-list.i "regra-vis-man"}

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


