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
{include/i-prgvrs.i V01IN144 2.00.00.022}  /*** 010022 ***/
&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN144 MUT}
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

define new global shared var gr-grup-maquina     as rowid no-undo.
define new global shared var c-programa-chamador as char  no-undo.

define buffer b-grup-maquina for grup-maquina.

define var l-cc-codigo as logical.
define var c-cc-codigo as char format "x(8)".
define var c-param     as char format "x(40)".
define var h_handle    as handle.

{cdp/cd0666.i} /* utilizado na trigger de delete */

{cdp/cdcfgman.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES grup-maquina
&Scoped-define FIRST-EXTERNAL-TABLE grup-maquina


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR grup-maquina.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS grup-maquina.descricao ~
grup-maquina.nr-up-hora grup-maquina.cc-codigo grup-maquina.cd-calen ~
grup-maquina.ind-utiliz 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}descricao ~{&FP2}descricao ~{&FP3}~
 ~{&FP1}nr-up-hora ~{&FP2}nr-up-hora ~{&FP3}~
 ~{&FP1}cc-codigo ~{&FP2}cc-codigo ~{&FP3}~
 ~{&FP1}cd-calen ~{&FP2}cd-calen ~{&FP3}
&Scoped-define ENABLED-TABLES grup-maquina
&Scoped-define FIRST-ENABLED-TABLE grup-maquina
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold RECT-1 fi-text 
&Scoped-Define DISPLAYED-FIELDS grup-maquina.gm-codigo ~
grup-maquina.descricao grup-maquina.nr-up-hora grup-maquina.cc-codigo ~
grup-maquina.cd-calen grup-maquina.ind-utiliz 
&Scoped-Define DISPLAYED-OBJECTS c-centro-custo-descricao ~
c-calen-gener-descricao rs-tipo fi-text 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS grup-maquina.gm-codigo 
&Scoped-define ADM-ASSIGN-FIELDS rs-tipo 
&Scoped-define ADM-MODIFY-FIELDS rs-tipo 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
gm-codigo|y|y|mgind.grup-maquina.gm-codigo
cd-calen||y|mgind.grup-maquina.cd-calen
cc-codigo||y|mgind.grup-maquina.cc-codigo
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "gm-codigo",
     Keys-Supplied = "gm-codigo,cd-calen,cc-codigo"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-calen-gener-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 53 BY .88 NO-UNDO.

DEFINE VARIABLE c-centro-custo-descricao AS CHARACTER FORMAT "X(32)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE fi-text AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 5 BY .67.

DEFINE VARIABLE rs-tipo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Item 1", 1,
"Item 2", 2
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 32.43 BY 1.71.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 7.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     grup-maquina.gm-codigo AT ROW 1.17 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.43 BY .88
     grup-maquina.descricao AT ROW 2.67 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 33.43 BY .88
     grup-maquina.nr-up-hora AT ROW 3.67 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     grup-maquina.cc-codigo AT ROW 4.67 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-centro-custo-descricao AT ROW 4.67 COL 32 COLON-ALIGNED NO-LABEL
     grup-maquina.cd-calen AT ROW 5.67 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.43 BY .88
     c-calen-gener-descricao AT ROW 5.67 COL 32 COLON-ALIGNED NO-LABEL
     grup-maquina.ind-utiliz AT ROW 6.67 COL 20
          VIEW-AS TOGGLE-BOX
          SIZE 21.72 BY 1
     rs-tipo AT ROW 8.37 COL 16.57 NO-LABEL
     fi-text AT ROW 7.7 COL 11.86 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
     RECT-1 AT ROW 8 COL 11.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.grup-maquina
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
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
         HEIGHT             = 9.08
         WIDTH              = 88.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit L-To-R, COLUMNS                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-calen-gener-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-centro-custo-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN grup-maquina.gm-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR RADIO-SET rs-tipo IN FRAME f-main
   NO-ENABLE 2 3                                                        */
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

{utp/ut-glob.i}
{src/adm/method/viewer.i}
{include/c-viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME grup-maquina.cc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL grup-maquina.cc-codigo V-table-Win
ON F5 OF grup-maquina.cc-codigo IN FRAME f-main /* Centro Custo */
DO:
  l-implanta = yes.
  {include/zoom.i &prog-zoom="inzoom/z01in042.w"
                  &tabela=grup-maquina
                  &atributo=cc-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL grup-maquina.cc-codigo V-table-Win
ON LEAVE OF grup-maquina.cc-codigo IN FRAME f-main /* Centro Custo */
DO:
  {include/leave.i &tabela=centro-custo
                   &atributo-ref=descricao
                   &variavel-ref=c-centro-custo-descricao
                   &where="centro-custo.cc-codigo = input frame {&frame-name} grup-maquina.cc-codigo"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL grup-maquina.cc-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF grup-maquina.cc-codigo IN FRAME f-main /* Centro Custo */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME grup-maquina.cd-calen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL grup-maquina.cd-calen V-table-Win
ON F5 OF grup-maquina.cd-calen IN FRAME f-main /* Calend rio */
DO:
   l-implanta = yes.
   {include/zoom.i &prog-zoom="inzoom/z01in026.w"
                  &tabela=grup-maquina
                  &atributo=cd-calen}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL grup-maquina.cd-calen V-table-Win
ON LEAVE OF grup-maquina.cd-calen IN FRAME f-main /* Calend rio */
DO:
   {include/leave.i &tabela=calen-gener
                   &atributo-ref=descricao
                   &variavel-ref=c-calen-gener-descricao
                   &where="calen-gener.cd-calen = input frame {&frame-name} grup-maquina.cd-calen"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL grup-maquina.cd-calen V-table-Win
ON MOUSE-SELECT-DBLCLICK OF grup-maquina.cd-calen IN FRAME f-main /* Calend rio */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  if grup-maquina.cc-codigo:load-mouse-pointer ("image~\lupa.cur") then.
  if grup-maquina.cd-calen:load-mouse-pointer ("image~\lupa.cur") then.

  {utp/ut-liter.i Tipo}
  assign fi-text = trim(return-value).
  
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

{database/tgin/tdp/tdin144.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEF VAR key-value AS CHAR NO-UNDO.
  DEF VAR row-avail-enabled AS LOGICAL NO-UNDO.

  /* LOCK status on the find depends on FIELDS-ENABLED. */
  RUN get-attribute ('FIELDS-ENABLED':U).
  row-avail-enabled = (RETURN-VALUE eq 'yes':U).
  /* Look up the current key-value. */
  RUN get-attribute ('Key-Value':U).
  key-value = RETURN-VALUE.

  /* Find the current record using the current Key-Name. */
  RUN get-attribute ('Key-Name':U).
  CASE RETURN-VALUE:
    WHEN 'gm-codigo':U THEN
       {src/adm/template/find-tbl.i
           &TABLE = grup-maquina
           &WHERE = "WHERE grup-maquina.gm-codigo eq key-value"
       }
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  {src/adm/template/row-list.i "grup-maquina"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "grup-maquina"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
   
  /* Ponha aqui a valida‡Æo de chave duplicada */
  if grup-maquina.gm-codigo:sensitive in frame {&frame-name} = yes
  and can-find (b-grup-maquina where b-grup-maquina.gm-codigo = input frame {&frame-name} grup-maquina.gm-codigo) then do:
      {utp/ut-table.i mgind grup-maquina 1}
      run utp/ut-msgs.p (input "show",
                         input 7,
                         input return-value). 
      apply "entry" to grup-maquina.gm-codigo in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.   
  
  /* Ponha aqui as demais valida‡äes */
  
  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
  
  /*** Verifica se mudar  o centro de custo para executar exporta‡Æo do cc-codigo ***/
  assign l-cc-codigo = no. 

  if  frame {&frame-name} grup-maquina.cc-codigo entered 
  and avail grup-maquina then
     assign l-cc-codigo = yes
            c-cc-codigo = grup-maquina.cc-codigo. 
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  
  if RETURN-VALUE = 'ADM-ERROR':U then do:
     return 'ADM-ERROR':U.
  end.

  if return-value <> "adm-error" then do:
  
    /* Code placed here will execute AFTER standard behavior.    */
    /*** Mudan‡a de cc-codigo ‚ exportada para os equipamentos e opcionalmente para
         os movimentos de mob ***/
    if l-cc-codigo then do:
 
      find first movto-ggf
      where movto-ggf.gm-codigo = grup-maquina.gm-codigo and 
            movto-ggf.cc-codigo = c-cc-codigo no-lock no-error.
      if  available movto-ggf then do:
          {utp/ut-table.i mgind grup-maquina 1}
          assign c-param = return-value. 
          {utp/ut-table.i mgind movto-ggf 1}     
          assign c-param = return-value + '~~' + c-param.
          {utp/ut-field.i mgind grup-maquina cc-codigo 1}
          assign c-param = return-value + '~~' + c-param.
          
          run utp/ut-msgs.p (input "show",
                             input 74,
                             input c-param).
          if return-value = "yes" then 
             for each movto-ggf 
                where movto-ggf.gm-codigo = grup-maquina.gm-codigo
                and   movto-ggf.cc-codigo = c-cc-codigo EXCLUSIVE-LOCK:
                assign movto-ggf.cc-codigo = grup-maquina.cc-codigo.
             end.
       end.    
    end.        
  end.

  &IF DEFINED (bf_man_sfc_lc) &THEN
      assign substring(grup-maquina.char-1,1,1) = rs-tipo:screen-value in frame {&frame-name}.
  &ENDIF
  
  if c-programa-chamador = "cd0111" then do:
        RUN Who-Is-The-Container IN adm-broker-hdl
            (INPUT this-procedure,
             OUTPUT h_handle).    
        run pi-habilita-bt in h_handle(input yes).    
  end.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  run pi-valida-eliminacao-grup-maquina.
  if  return-value <> "ok" then do:
      run pi-mostra-erros.
      return "ADM-ERROR".
  end.

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
  
  if c-programa-chamador = "cd0111" then do:
      RUN Who-Is-The-Container IN adm-broker-hdl
          (INPUT this-procedure,
           OUTPUT h_handle).     
      run pi-habilita-bt in h_handle(input yes).
  end.
  
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
  If avail grup-maquina then do:
     find centro-custo where centro-custo.cc-codigo eq grup-maquina.cc-codigo no-lock no-error.
     assign c-centro-custo-descricao = if avail centro-custo then centro-custo.descricao else "":U.
     find calen-gener  where calen-gener.cd-calen   eq grup-maquina.cd-calen no-lock no-error.
     assign c-calen-gener-descricao = if avail calen-gener then calen-gener.descricao else "":U.
     
  End.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  &IF DEFINED (bf_man_sfc_lc) &THEN
    if avail grup-maquina then 
      assign rs-tipo:screen-value in frame {&frame-name} = if substring(grup-maquina.char-1,1,1) <> " " then
                                                               substring(grup-maquina.char-1,1,1)
                                                           else
                                                               "1".
  &ENDIF
    
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

  if c-programa-chamador = "cd0111" then do:
      RUN Who-Is-The-Container IN adm-broker-hdl
          (INPUT this-procedure,
           OUTPUT h_handle).     
      run pi-habilita-bt in h_handle(input no).
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

  &IF DEFINED (bf_man_sfc_lc) &THEN
    find first param-global no-lock no-error.
    if avail param-global then
      if param-global.modulo-sws = no then do:
  &ENDIF
          assign fi-text:visible          in frame {&frame-name} = no
                 rs-tipo:visible          in frame {&frame-name} = no
                 rect-1:visible           in frame {&frame-name} = no
                 rt-mold:height           in frame {&frame-name} = 5.25
                 {&window-name}:height                           = 8.75.

  &IF DEFINED (bf_man_sfc_lc) &THEN 
      end.
  &ENDIF

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  &IF DEFINED (bf_man_sfc_lc) &THEN
      assign rs-tipo:radio-buttons in frame {&frame-name} = {ininc/i01in084.i 07}.
  &ENDIF

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
  if available grup-maquina then
      assign gr-grup-maquina = rowid(grup-maquina).
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-erros V-table-Win 
PROCEDURE pi-mostra-erros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

for each tt-erro:
    delete tt-erro.
end.

{database/tgin/tdp/tdin144.i1}

run cdp/cd0666.w (input table tt-erro).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "gm-codigo" "grup-maquina" "gm-codigo"}
  {src/adm/template/sndkycas.i "cd-calen" "grup-maquina" "cd-calen"}
  {src/adm/template/sndkycas.i "cc-codigo" "grup-maquina" "cc-codigo"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

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
  {src/adm/template/snd-list.i "grup-maquina"}

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


