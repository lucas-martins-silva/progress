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
{include/i-prgvrs.i V01IN439 2.00.01.003}  /*** 010103 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN439 MUT}
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
 
/* Local Buffer Definitions ---                                         */
 def buffer b-tp-recur for tp-recur.


/** Para Montagem da Lista Tp-Recurso **/
def var i-cont  as int  no-undo.
def var c-lista as char no-undo.
def var i-seq   as int  no-undo.

def temp-table tt-lista
    field seq as int
    field des as char.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES tp-recur
&Scoped-define FIRST-EXTERNAL-TABLE tp-recur


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR tp-recur.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tp-recur.descricao tp-recur.cod-unid-capac ~
tp-recur.observacao 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}descricao ~{&FP2}descricao ~{&FP3}~
 ~{&FP1}cod-unid-capac ~{&FP2}cod-unid-capac ~{&FP3}
&Scoped-define ENABLED-TABLES tp-recur
&Scoped-define FIRST-ENABLED-TABLE tp-recur
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS tp-recur.tp-recurso tp-recur.descricao ~
tp-recur.cod-unid-capac tp-recur.observacao 
&Scoped-Define DISPLAYED-OBJECTS c-des-unid-capac cb-cl-recurso ~
cb-ind-modo-calculo 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS tp-recur.tp-recurso cb-cl-recurso ~
cb-ind-modo-calculo 
&Scoped-define ADM-ASSIGN-FIELDS cb-cl-recurso cb-ind-modo-calculo 
&Scoped-define ADM-MODIFY-FIELDS cb-cl-recurso cb-ind-modo-calculo 

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
DEFINE VARIABLE cb-cl-recurso AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE cb-ind-modo-calculo AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS " "
     SIZE 30 BY 1 NO-UNDO.

DEFINE VARIABLE c-des-unid-capac AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29.72 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.33.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 10.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     tp-recur.tp-recurso AT ROW 1.21 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     tp-recur.descricao AT ROW 2.71 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 38 BY .88
     tp-recur.cod-unid-capac AT ROW 3.71 COL 30 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-des-unid-capac AT ROW 3.71 COL 38.29 COLON-ALIGNED NO-LABEL
     cb-cl-recurso AT ROW 4.71 COL 29.86 COLON-ALIGNED
     cb-ind-modo-calculo AT ROW 5.92 COL 29.86 COLON-ALIGNED
     tp-recur.observacao AT ROW 7.29 COL 16 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 60 BY 5
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.tp-recur
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
         HEIGHT             = 11.5
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

/* SETTINGS FOR FILL-IN c-des-unid-capac IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-cl-recurso IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-ind-modo-calculo IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN tp-recur.tp-recurso IN FRAME f-main
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

&Scoped-define SELF-NAME cb-cl-recurso
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cl-recurso V-table-Win
ON VALUE-CHANGED OF cb-cl-recurso IN FRAME f-main
DO:
  if input frame {&frame-name} cb-cl-recurso <> {ininc/i01in439.i 04 5} then 
  do:
     if input frame {&frame-name} cb-cl-recurso = {ininc/i01in439.i 04 2} then
        assign cb-ind-modo-calculo:screen-value = {ininc/i02in439.i 04 2}.
     else   
        assign cb-ind-modo-calculo:screen-value = {ininc/i02in439.i 04 1}.
     assign cb-ind-modo-calculo:sensitive in frame {&frame-name} = no.
  end.    
  else 
     assign cb-ind-modo-calculo:sensitive in frame {&frame-name} = yes.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tp-recur.cod-unid-capac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tp-recur.cod-unid-capac V-table-Win
ON F5 OF tp-recur.cod-unid-capac IN FRAME f-main /* Unidade Capacidade */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z01in460.w
                     &campo=tp-recur.cod-unid-capac
                     &campozoom=cod-unid-capac
                     &campo2=c-des-unid-capac
                     &campozoom2=des-unid-capac}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tp-recur.cod-unid-capac V-table-Win
ON LEAVE OF tp-recur.cod-unid-capac IN FRAME f-main /* Unidade Capacidade */
DO:
  {include/leave.i &tabela=unid-capac
                   &atributo-ref=des-unid-capac
                   &variavel-ref=c-des-unid-capac
                   &where="unid-capac.cod-unid-capac = input frame {&frame-name}
  tp-recur.cod-unid-capac"}                         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tp-recur.cod-unid-capac V-table-Win
ON MOUSE-SELECT-DBLCLICK OF tp-recur.cod-unid-capac IN FRAME f-main /* Unidade Capacidade */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

 if tp-recur.cod-unid-capac:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
 
 {utp/ut-field.i mgind tp-recur cl-recurso 1}
 assign cb-cl-recurso:label in frame {&frame-name} = return-value.
 
 {utp/ut-field.i mgind tp-recur ind-modo-calculo 1}
 assign cb-ind-modo-calculo:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "tp-recur"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "tp-recur"}

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
   do with frame {&frame-name}:
        assign cb-cl-recurso:screen-value       = {ininc/i01in439.i 04 1}
               cb-ind-modo-calculo:screen-value = {ininc/i02in439.i 04 1}.
   end.
   assign cb-ind-modo-calculo:sensitive in frame {&frame-name} = no.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*--------------------  ----------------------------------------------------------
    Purpose:     Override standard ADM method
    Notes:       
  ------------------------------------------------------------------------------*/
  
    /* Code placed here will execute PRIOR to standard behavior. */
      /*{include/i-valid.i}*/
      if not frame {&frame-name}:validate() then
         return 'ADM-ERROR':U.
      
     
    /*** Valida»’o de chave duplicada ***/   
     if tp-recur.tp-recurso:sensitive in frame {&frame-name} = yes
     and can-find(b-tp-recur
                  where b-tp-recur.tp-recurso = input frame {&frame-name} tp-recur.tp-recurso) then
      do:
        {utp/ut-table.i mgind tp-recur 1}
        run utp/ut-msgs.p (input "show",
                           input 1,
                           input return-value).
        apply 'entry' to tp-recur.tp-recurso in frame {&frame-name}.
        return 'adm-error'.
      end.
      
    /*** Valida»’o Descri»’o ***/
    if input frame {&frame-name} tp-recur.descricao = "" then do:
        run utp/ut-msgs.p (input "show",
                           input 190,
                           input "").
        apply "entry" to tp-recur.descricao in frame {&frame-name}.
        return 'adm-error'.
    end.
    
    /** Valida»’o unidade medida ***/
    find first unid-capac
        where unid-capac.cod-unid-capac = input frame {&frame-name} tp-recur.cod-unid-capac
    no-lock no-error.
    if not avail unid-capac then do:
        {utp/ut-table.i mgind unid-capac 01}
        run utp/ut-msgs.p (input "show",
                           input 56,
                           input return-value).
        apply "entry" to tp-recur.cod-unid-capac in frame {&frame-name}.
        return 'adm-error'.
    end.
        
      
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
    
    /* Code placed here will execute AFTER standard behavior.    */
    
    END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  do with frame {&frame-name}:
     assign tp-recur.cl-recurso       = {ininc/i01in439.i 06 cb-cl-recurso:screen-value}.
            tp-recur.ind-modo-calculo = {ininc/i02in439.i 06 cb-ind-modo-calculo:screen-value}.
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
 
  if avail tp-recur then do with frame {&frame-name}:
     find unid-capac where unid-capac.cod-unid-capac = 
                           tp-recur.cod-unid-capac no-lock no-error.
     assign c-des-unid-capac = if avail unid-capac then unid-capac.des-unid-capac else "":U.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
   
  /* Code placed here will execute AFTER standard behavior.    */
  
  if avail tp-recur then do with frame {&frame-name}:
     assign cb-cl-recurso:screen-value       = {ininc/i01in439.i 04 tp-recur.cl-recurso}
            cb-ind-modo-calculo:screen-value = {ininc/i02in439.i 04 tp-recur.ind-modo-calculo}.
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
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
 /*** Se existe recurso para tipo de recurso alterado e tipo de recurso ² tipo 1, 2 ou 3
      n’o serÿ poss­vel a modifica»’o do tipo, verificar s½ na altera»’o ***/
  if avail tp-recur then do:
     find first recurso of tp-recur no-lock no-error.
     if avail recurso then do:
        apply 'value-changed' to cb-cl-recurso in frame {&frame-name}.
        assign cb-cl-recurso:sensitive in frame {&frame-name} = no.
     end.
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
  
  do with frame {&frame-name}:
  
     assign c-lista = {ininc/i01in439.i 03}.
     /*********** Nova Sequencia
     Grupo Maquina       1  1 
     MOD Centro Custo    6  2
     Equipamento         3  3
     Material            2  4
     Capacidade          4  5
     Outros              5  6
     ***********/
     for each tt-lista: delete tt-lista. end.
     
     do i-cont = 1 to num-entries(c-lista):
        assign i-seq = {ininc/i01in439.i 06 entry(i-cont,c-lista)}.
        if i-seq = 1 then do:
           create tt-lista.
           assign tt-lista.seq = 1
                  tt-lista.des = entry(i-seq,c-lista).
        end.
        if i-seq = 6 then do:
           create tt-lista.
           assign tt-lista.seq = 2
                  tt-lista.des = entry(i-seq,c-lista).
        end.
        if i-seq = 3 then do:
           create tt-lista.
           assign tt-lista.seq = 3
                  tt-lista.des = entry(i-seq,c-lista).
        end.
        if i-seq = 2 then do:
           create tt-lista.
           assign tt-lista.seq = 4
                  tt-lista.des = entry(i-seq,c-lista).
        end.
        if i-seq = 4 then do:
           create tt-lista.
           assign tt-lista.seq = 5
                  tt-lista.des = entry(i-seq,c-lista).
        end.
        if i-seq = 5 then do:
           create tt-lista.
           assign tt-lista.seq = 6
                  tt-lista.des = entry(i-seq,c-lista).
        end.
     end.
     
     assign c-lista = "".
     for each tt-lista
        break by tt-lista.seq:
        if not last(tt-lista.seq) then
           assign c-lista = c-lista + tt-lista.des + ",".
        else
           assign c-lista = c-lista + tt-lista.des.
     end.
  
     assign cb-cl-recurso:list-items       = c-lista
            cb-ind-modo-calculo:list-items = {ininc/i02in439.i 03}.
  end.

  
  if input frame {&frame-name} cb-cl-recurso:screen-value <> {ininc/i01in439.i 04 5} then
     assign cb-ind-modo-calculo:sensitive in frame {&frame-name} = yes.
     
        
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  apply 'value-changed' to cb-ind-modo-calculo in frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N’o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida»„es, pois neste ponto do programa o registro 
  ainda n’o foi criado.       
------------------------------------------------------------------------------*/

 /* {include/i-vldfrm.i}*/ /* Valida»’o de dicionÿrio */
    
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
  {src/adm/template/snd-list.i "tp-recur"}

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


