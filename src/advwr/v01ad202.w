&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i V01AD202 2.00.00.015} /*** "010015" 25/06/2025 16:21:12  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01AD202 MUT}
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

def var i-campo-act as integer initial 0.

{cdp/cdcfgfin.i} /* Definiá∆o de Funá‰es */
{include/i-freeac.i}
/*-------------- Integraá∆o Magnus I.01 x EMS 2.04 -------------*/
def var i-ind-tipo-movto as inte no-undo.

{fcp/fc0101i1.i} /* Definiá∆o da temp-table tt-param-fasb-mg */
{cdp/cd0001i1.i} /* Definiá∆o da temp-table de erros tt-erro-mg */
/****************************************************************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES param-fasb
&Scoped-define FIRST-EXTERNAL-TABLE param-fasb


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-fasb.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-fasb.moeda-cmi param-fasb.moeda-anbid ~
param-fasb.moeda-fasb param-fasb.moeda-monetaria 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}moeda-cmi ~{&FP2}moeda-cmi ~{&FP3}~
 ~{&FP1}moeda-anbid ~{&FP2}moeda-anbid ~{&FP3}~
 ~{&FP1}moeda-fasb ~{&FP2}moeda-fasb ~{&FP3}~
 ~{&FP1}moeda-monetaria ~{&FP2}moeda-monetaria ~{&FP3}
&Scoped-define ENABLED-TABLES param-fasb
&Scoped-define FIRST-ENABLED-TABLE param-fasb
&Scoped-Define ENABLED-OBJECTS rt-key RECT-2 RECT-3 RS-cmi-prim-ult ~
RS-tp-variacao 
&Scoped-Define DISPLAYED-FIELDS param-fasb.moeda-cmi param-fasb.moeda-anbid ~
param-fasb.moeda-fasb param-fasb.moeda-monetaria param-fasb.tipo-calculo 
&Scoped-Define DISPLAYED-OBJECTS c-moeda-cmi c-moeda-anbid c-moeda-fasb ~
c-moeda-monet RS-cmi-prim-ult RS-tp-variacao 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODifY-FIELDS,List-4,List-5,List-6 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<ForEIGN-KEYS></ForEIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to ForEIGN KEYS
*/
run set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = ':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-moeda-anbid AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE c-moeda-cmi AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE c-moeda-fasb AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE c-moeda-monet AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE text-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 15 BY .63 NO-UNDO.

DEFINE VARIABLE text-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 16 BY .63 NO-UNDO.

DEFINE VARIABLE RS-cmi-prim-ult AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Primeiro", 1,
"Èltimo", 2
     SIZE 13.57 BY 1.54 NO-UNDO.

DEFINE VARIABLE RS-tp-variacao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Cambial", 1,
"Previs∆o", 2
     SIZE 13.57 BY 1.54 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 18 BY 2.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 18 BY 2.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83 BY 7.83.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-fasb.moeda-cmi AT ROW 1.33 COL 28.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     c-moeda-cmi AT ROW 1.33 COL 32.72 COLON-ALIGNED NO-LABEL
     param-fasb.moeda-anbid AT ROW 2.33 COL 28.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     c-moeda-anbid AT ROW 2.33 COL 32.72 COLON-ALIGNED NO-LABEL
     param-fasb.moeda-fasb AT ROW 3.33 COL 28.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     c-moeda-fasb AT ROW 3.33 COL 32.72 COLON-ALIGNED NO-LABEL
     param-fasb.moeda-monetaria AT ROW 4.33 COL 28.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     c-moeda-monet AT ROW 4.33 COL 32.72 COLON-ALIGNED NO-LABEL
     param-fasb.tipo-calculo AT ROW 5.33 COL 28.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2.57 BY .88
     RS-cmi-prim-ult AT ROW 6.88 COL 32.14 HELP
          "Cotacao CMCAC a ser utilizada no màs" NO-LABEL
     RS-tp-variacao AT ROW 6.88 COL 58.14 HELP
          "Usa Variaá∆o Cambial ou Variacao Cambial e da Previsao" NO-LABEL
     text-1 AT ROW 6.33 COL 29.72 COLON-ALIGNED NO-LABEL
     text-2 AT ROW 6.33 COL 55.72 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     RECT-2 AT ROW 6.58 COL 30.72
     RECT-3 AT ROW 6.58 COL 56.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.param-fasb
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
         HEIGHT             = 7.96
         WIDTH              = 83.29.
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

/* SETTINGS FOR FILL-IN c-moeda-anbid IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda-cmi IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda-fasb IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda-monet IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN text-1 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN text-2 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN param-fasb.tipo-calculo IN FRAME f-main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "no-lock"
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

&Scoped-define SELF-NAME param-fasb.moeda-anbid
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-fasb.moeda-anbid V-table-Win
ON F5 OF param-fasb.moeda-anbid IN FRAME f-main /* Moeda ANBID */
do:
   assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=adzoom/z01ad272.w
                     &campo=param-fasb.moeda-anbid
                     &campozoom=mo-codigo}

   assign i-campo-act = 2.    
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-fasb.moeda-anbid V-table-Win
ON LEAVE OF param-fasb.moeda-anbid IN FRAME f-main /* Moeda ANBID */
do:
  {include/leave.i &tabela=moeda
                   &atributo-ref=descricao
                   &variavel-ref=c-moeda-anbid
                   &where="moeda.mo-codigo = input frame {&frame-name} param-fasb.moeda-anbid"}  
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-fasb.moeda-anbid V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-fasb.moeda-anbid IN FRAME f-main /* Moeda ANBID */
do:
  APPLY "F5":U TO self.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-fasb.moeda-cmi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-fasb.moeda-cmi V-table-Win
ON F5 OF param-fasb.moeda-cmi IN FRAME f-main /* Moeda CMCAC */
do:
   assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=adzoom/z01ad272.w
                     &campo=param-fasb.moeda-cmi
                     &campozoom=mo-codigo
                     &frame={&FRAME-NAME}
                     }
   assign i-campo-act = 1.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-fasb.moeda-cmi V-table-Win
ON LEAVE OF param-fasb.moeda-cmi IN FRAME f-main /* Moeda CMCAC */
do:
  {include/leave.i &tabela=moeda
                   &atributo-ref=descricao
                   &variavel-ref=c-moeda-cmi
                   &where="moeda.mo-codigo = input frame {&frame-name} param-fasb.moeda-cmi"}
                   
  if  input frame {&frame-name} param-fasb.moeda-cmi = 0 then do:
      assign param-fasb.moeda-anbid:screen-value in frame {&frame-name} = trim(string(0))
             param-fasb.moeda-anbid:sensitive in frame {&frame-name}    = no.
  end.
  else do:
      assign param-fasb.moeda-anbid:sensitive in frame {&frame-name}    = yes.
      apply "entry":U to param-fasb.moeda-anbid in frame {&frame-name}.
      return no-apply.
  end.

end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-fasb.moeda-cmi V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-fasb.moeda-cmi IN FRAME f-main /* Moeda CMCAC */
do:
  APPLY "F5":U TO self.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-fasb.moeda-fasb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-fasb.moeda-fasb V-table-Win
ON F5 OF param-fasb.moeda-fasb IN FRAME f-main /* Moeda FASB */
do:
 assign l-implanta = yes.
 {include/zoomvar.i &prog-zoom=adzoom/z01ad272.w
                     &campo=param-fasb.moeda-fasb
                     &campozoom=mo-codigo}
  
   assign i-campo-act = 3.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-fasb.moeda-fasb V-table-Win
ON LEAVE OF param-fasb.moeda-fasb IN FRAME f-main /* Moeda FASB */
do:
  {include/leave.i &tabela=moeda
                   &atributo-ref=descricao
                   &variavel-ref=c-moeda-fasb
                   &where="moeda.mo-codigo = input frame {&frame-name} param-fasb.moeda-fasb"}  
   if  input frame {&frame-name} param-fasb.moeda-fasb = 0 then do:
      assign param-fasb.moeda-monetaria:screen-value in frame {&frame-name} = string(0)
             param-fasb.moeda-monetaria:sensitive in frame {&frame-name}    = no.
  end.
  else do:
      assign param-fasb.moeda-monetaria:sensitive in frame {&frame-name}    = yes.
    
  end.

end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-fasb.moeda-fasb V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-fasb.moeda-fasb IN FRAME f-main /* Moeda FASB */
do:
  APPLY "F5":U TO self.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-fasb.moeda-monetaria
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-fasb.moeda-monetaria V-table-Win
ON F5 OF param-fasb.moeda-monetaria IN FRAME f-main /* Moeda Monet†ria */
do:
   assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=adzoom/z01ad272.w
                     &campo=param-fasb.moeda-monetaria
                     &campozoom=mo-codigo}
   assign i-campo-act = 4.

end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-fasb.moeda-monetaria V-table-Win
ON LEAVE OF param-fasb.moeda-monetaria IN FRAME f-main /* Moeda Monet†ria */
do:
  {include/leave.i &tabela=moeda
                   &atributo-ref=descricao
                   &variavel-ref=c-moeda-monet
                   &where="moeda.mo-codigo = input frame {&frame-name} param-fasb.moeda-monetaria"}  
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-fasb.moeda-monetaria V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-fasb.moeda-monetaria IN FRAME f-main /* Moeda Monet†ria */
do:
  APPLY "F5":U TO self.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RS-cmi-prim-ult
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RS-cmi-prim-ult V-table-Win
ON VALUE-CHANGED OF RS-cmi-prim-ult IN FRAME f-main
do:
 assign RS-cmi-prim-ult.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RS-tp-variacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RS-tp-variacao V-table-Win
ON VALUE-CHANGED OF RS-tp-variacao IN FRAME f-main
do:
  assign RS-tp-variacao.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
{utp/ut-rtlbl.i mguni empresa cmi-prim-ult text-1 }
{utp/ut-rtlbl.i mguni empresa tp-variacao  text-2 }
{utp/ut-rdset.i rs-cmi-prim-ult *}
{utp/ut-rdset.i rs-tp-variacao *}

  &if DEFINED(UIB_IS_runNING) <> 0 &then          
    run dispatch IN THIS-PROCEDURE ('initialize':U).        
  &endif         
  
  {btb/btb008za.i0} /* Integraá∆o EMS 2.04 Financeiro x Magnus I.01 */
  
  /************************ INTERNAL PROCEDURES ********************/


if param-fasb.moeda-cmi:load-mouse-pointer("Image\lupa.cur") in frame {&FRAME-NAME} then.
if param-fasb.moeda-anbid:load-mouse-pointer("Image\lupa.cur") in frame {&FRAME-NAME} then.
if param-fasb.moeda-fasb:load-mouse-pointer("Image\lupa.cur") in frame {&FRAME-NAME} then.
if param-fasb.moeda-monetaria:load-mouse-pointer("Image\lupa.cur") in frame {&FRAME-NAME} then.

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

  /* No Foreign keys are accepted by this SmartObject. */

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
  {src/adm/template/row-list.i "param-fasb"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-fasb"}

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
    
    {include/i-valid.i}
    
    run dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    
    if avail param-fasb then
       assign param-fasb.ep-codigo = i-ep-codigo-usuario.
    
    {cdp/cd0002i1.i param-fasb} /* Integraá∆o EMS 2.04 Financeiro x Magnus I.01 */

end PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  run dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  &if  defined(ADM-MODifY-FIELDS) &then
      disable {&ADM-MODifY-FIELDS} with frame {&frame-name}.
  &endif

end PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
    Purpose:     Override standard ADM method
    Notes:       
------------------------------------------------------------------------------*/

  if  avail moeda-empresa then do:
      do WITH FRAME {&FRAME-NAME}:
         CASE i-campo-act:
              WHEN 1 then
                     Assign param-fasb.moeda-cmi:SCREEN-VALUE = string(moeda-empresa.mo-codigo).
              WHEN 2 then
                     Assign param-fasb.moeda-anbid:SCREEN-VALUE = string(moeda-empresa.mo-codigo).
              WHEN 3 then
                     Assign param-fasb.moeda-fasb:SCREEN-VALUE = string(moeda-empresa.mo-codigo).
              WHEN 4 then
                     Assign param-fasb.moeda-monetaria:SCREEN-VALUE = string(moeda-empresa.mo-codigo).
         end CASE.
      end.
  end.
  
  assign i-campo-act = 0.
  
  run dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  {utp/ut-rtlbl.i mguni empresa cmi-prim-ult text-1}
  {utp/ut-rtlbl.i mguni empresa tp-variacao text-2}

end PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  run get-attribute ('adm-new-record').

  run dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  if  avail param-fasb then do:
      apply "leave" to param-fasb.moeda-cmi in frame {&frame-name}.
      apply "leave" to param-fasb.moeda-anbid in frame {&frame-name}.
      apply "leave" to param-fasb.moeda-fasb in frame {&frame-name}.
      apply "leave" to param-fasb.moeda-monetaria in frame {&frame-name}.
  end.
 
  &if  defined(ADM-MODifY-FIELDS) &then
      enable {&ADM-MODifY-FIELDS} with frame {&frame-name}.
  &endif  

 /* Integraá∆o da tabela Previs∆o Inflaá∆o com o EMS 5 */
    find first funcao no-lock
         where funcao.cd-funcao = "Previs∆o Inflaá∆o 2.00" no-error.
    if avail funcao then do:
        assign param-fasb.tipo-calculo:sensitive in frame {&frame-name} = no.
    end.
    else do:
        assign param-fasb.tipo-calculo:sensitive in frame {&frame-name} = yes.
    end.

end PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
    Purpose:     Override standard ADM method
    Notes:       
------------------------------------------------------------------------------*/
     
    do  transaction:
        find first param-fasb where param-fasb.ep-codigo = i-ep-codigo-usuario no-lock no-error.
        if  not avail param-fasb then do:
            create param-fasb.
        end. 
    end.
    
    run dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    do  transaction:
        find first empresa where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.
        if  available empresa then do:
            assign RS-cmi-prim-ult = empresa.cmi-prim-ult
                   RS-tp-variacao  = empresa.tp-variacao.
        end.
        else do:
            Assign RS-cmi-prim-ult = 1
                   RS-tp-variacao  = 1.
        end.
    end.

end PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
    Purpose:     Override standard ADM method
    Notes:       
------------------------------------------------------------------------------*/
            
    do  transaction:

        run PI-OK-VALIDATE.
                
        if  return-VALUE = "adm-error" then
            return "adm-error".
                    
        do WITH FRAME {&FRAME-NAME}:
            ASSIGN param-fasb.moeda-cmi.
            if param-fasb.moeda-cmi = 0 then
            do:
               ASSIGN param-fasb.moeda-anbid = 0.
               ASSIGN param-fasb.moeda-anbid:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(0).
            end.
            else
                ASSIGN param-fasb.moeda-anbid. 
            
            ASSIGN param-fasb.moeda-fasb. 
            if param-fasb.moeda-fasb = 0 then
            do:
                assign param-fasb.moeda-monetaria = 0.
                assign param-fasb.moeda-monetaria:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(0).
            end.
            Else
                ASSIGN param-fasb.moeda-monetaria.
            ASSIGN param-fasb.tipo-calculo.
            ASSIGN param-fasb.ep-codigo = i-ep-codigo-usuario.
            
            find mguni.empresa where mguni.empresa.ep-codigo = i-ep-codigo-usuario EXCLUSIVE-LOCK no-error.
            if available mguni.empresa then do:         
               if param-fasb.moeda-cmi <> 0 then
                   ASSIGN mguni.empresa.cmi-prim-ult = RS-cmi-prim-ult.
               else
                   ASSIGN mguni.empresa.cmi-prim-ult = 2.       
               ASSIGN mguni.empresa.tp-variacao = RS-tp-variacao.
            end.
        end.
    end.
    
    run dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

end PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-rpc-mg V-table-Win 
PROCEDURE pi-atualiza-rpc-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    {cdp/cd0003i1.i param-fasb fcp/fc0101i1.p}
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-param-fasb-mg V-table-Win 
PROCEDURE pi-cria-tt-param-fasb-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def input param p-ind-tipo-movto as int no-undo.
    def input param p-atualiza       as log no-undo.
    
    for each tt-param-fasb-mg:
        delete tt-param-fasb-mg.
    end.
    
    create tt-param-fasb-mg.
    assign tt-param-fasb-mg.ind-tipo-movto = p-ind-tipo-movto
           tt-param-fasb-mg.l-atualiza     = p-atualiza.
    
    /* Campos Iguais */
    assign tt-param-fasb-mg.ep-codigo        = param-fasb.ep-codigo
           tt-param-fasb-mg.moeda-cmi        = param-fasb.moeda-cmi
           tt-param-fasb-mg.moeda-fasb       = param-fasb.moeda-fasb
           tt-param-fasb-mg.moeda-anbid      = param-fasb.moeda-anbid
           tt-param-fasb-mg.moeda-monetaria  = param-fasb.moeda-monetaria
           tt-param-fasb-mg.tipo-calculo     = param-fasb.tipo-calculo.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-log-mg V-table-Win 
PROCEDURE pi-gera-log-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    {cdp/cd0004i1.i "FC0101" "PARAM-FASB" param-fasb.ep-codigo tt-param-fasb-mg.ind-tipo-movto tt-erros-mg.help-msg}
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-OK-validate V-table-Win 
PROCEDURE Pi-OK-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* --- Validaá∆o da moeda-cmi --- */

if  (input frame {&frame-name} param-fasb.moeda-cmi  <> 0 and
     input frame {&frame-name} param-fasb.moeda-anbid = 0) or
    (input frame {&frame-name} param-fasb.moeda-cmi   = 0 and
     input frame {&frame-name} param-fasb.moeda-anbid <> 0)  then do:
    run utp/ut-msgs.p (input "show",
                       input 8914,
                       input "").                       
  /*  apply "go" to param-fasb.moeda-cmi in frame {&frame-name}.    */
    apply "entry" to param-fasb.moeda-anbid in frame {&frame-name}.  
    return 'adm-error'.
end.    

if  (input frame {&frame-name} param-fasb.moeda-fasb      <> 0 and
     input frame {&frame-name} param-fasb.moeda-monetaria  = 0) or
    (input frame {&frame-name} param-fasb.moeda-fasb       = 0 and
     input frame {&frame-name} param-fasb.moeda-monetaria <> 0)  then do:
    run utp/ut-msgs.p (input "show",
                       input 8913,
                       input "").                       
   /* apply "go" to param-fasb.moeda-fasb in frame {&frame-name}.  */  
    apply "entry" to param-fasb.moeda-monetaria in frame {&frame-name}.  
    return 'adm-error'.
end.

if  input frame {&frame-name} param-fasb.moeda-cmi  <> 0 then do:
    find moeda-empresa where moeda-empresa.ep-codigo = i-ep-codigo-usuario and 
                             moeda-empresa.mo-codigo = input frame {&frame-name} param-fasb.moeda-cmi
                             no-lock no-error.
    if  not avail moeda-empresa then do:
        /* ERRO: Moeda n∆o cadastrada para empresa */
        run utp/ut-msgs.p (input "show":U,
                           input 2552,
                           input string(i-ep-codigo-usuario) + "~~" +
                                 string(input frame {&frame-name} param-fasb.moeda-cmi)).
       return "adm-error".    
    end.
end.

/* --- Validaá∆o da moeda-anbid --- */
if  input frame {&frame-name} param-fasb.moeda-anbid <> 0 then do:
    find moeda-empresa where moeda-empresa.ep-codigo = i-ep-codigo-usuario and 
                             moeda-empresa.mo-codigo = input frame {&frame-name} param-fasb.moeda-anbid
                             no-lock no-error.
    if  not avail moeda-empresa then do:
        /* ERRO: Moeda n∆o cadastrada para empresa */
        run utp/ut-msgs.p (input "show":U,
                           input 2552,
                           input string(i-ep-codigo-usuario) + "~~" +
                                 string(input frame {&frame-name} param-fasb.moeda-anbid)).
        return "adm-error".    
   end.
end.


/* --- Validaá∆o da moeda-fasb --- */ 
if  input frame {&frame-name} param-fasb.moeda-fasb <> 0 then do:
    find moeda-empresa where moeda-empresa.ep-codigo = i-ep-codigo-usuario and 
                             moeda-empresa.mo-codigo = input frame {&frame-name} param-fasb.moeda-fasb
                             no-lock no-error.
    if  not avail moeda-empresa then do:
        /* ERRO: Moeda n∆o cadastrada */
        run utp/ut-msgs.p (input "show":U,
                           input 2552,
                           input string(i-ep-codigo-usuario) + "~~" + 
                                 string(input frame {&frame-name} param-fasb.moeda-fasb)).
        return "adm-error".    
    end.
end.
 
/* --- Validaá∆o da moeda-monetaria --- */ 
if  input frame {&frame-name} param-fasb.moeda-monetaria <> 0 then do:
    find moeda-empresa where moeda-empresa.ep-codigo = i-ep-codigo-usuario and 
                             moeda-empresa.mo-codigo = input frame {&frame-name} param-fasb.moeda-monetaria
                             no-lock no-error.
    if  not avail moeda-empresa then do:
        /* ERRO: Moeda n∆o cadastrada */
        run utp/ut-msgs.p (input "show":U,
                           input 2552,
                           input string(i-ep-codigo-usuario) + "~~" + 
                                 string(input frame {&frame-name} param-fasb.moeda-monetaria)).
        return "adm-error".    
    end.
end.

if  (input frame {&frame-name} param-fasb.moeda-cmi   = input frame {&frame-name} param-fasb.moeda-anbid and
    input frame {&frame-name} param-fasb.moeda-cmi  <> 0) or
    (input frame {&frame-name} param-fasb.moeda-fasb  = input frame {&frame-name} param-fasb.moeda-monetaria and
    input frame {&frame-name} param-fasb.moeda-fasb <> 0) or
    (input frame {&frame-name} param-fasb.moeda-cmi   = input frame {&frame-name} param-fasb.moeda-fasb and
    input frame {&frame-name} param-fasb.moeda-cmi  <> 0) or
    (input frame {&frame-name} param-fasb.moeda-fasb  = input frame {&frame-name} param-fasb.moeda-anbid and 
    input frame {&frame-name} param-fasb.moeda-fasb <> 0) then do:
    run utp/ut-msgs.p (input "show":U,
                       input 7752,
                       input return-value).
    return "adm-error".
end.

/* --- Validaá∆o do tipo-calc ---- */    
if  input frame {&frame-name} param-fasb.tipo-calculo >= 2 then do:
    /* ERRO: "Tipo deve ser 0 ou 1" */
    run utp/ut-msgs.p (input "show":U,
                       input 4447,
                       input return-value).
    return "adm-error".
end.

return "".

end PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-param-fasb-mg V-table-Win 
PROCEDURE pi-valida-param-fasb-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def input-output param p-ind-tipo-movto as int no-undo.
    
    return "OK".
    
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

  {include/i-vldfrm.i}
   
end PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win adm/support/_key-snd.p
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-Send-RECorDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "param-fasb"}

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
  DEFINE INPUT PARAMETER p-issuer-hdl AS HandLE    NO-UNdo.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNdo.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  end CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
end PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


