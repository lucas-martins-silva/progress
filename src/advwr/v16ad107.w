&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
{include/i-prgvrs.i V16AD107 2.00.01.021 } /*** 010121 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v16ad107 MUT}
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
def var c-cep-unformat as char  no-undo.
DEF VAR c-cep-aux      as char  no-undo.
def var c-formato      as char  no-undo.

DEF VAR c-endereco-aux LIKE emitente.endereco NO-UNDO.
DEF VAR c-rua          AS CHAR                NO-UNDO.
DEF VAR c-nro          AS CHAR                NO-UNDO.
DEF VAR c-comp         AS CHAR                NO-UNDO.
DEF VAR c-help         AS CHAR                NO-UNDO.
DEF VAR h-cdapi704     AS HANDLE              NO-UNDO.


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
&Scoped-define EXTERNAL-TABLES estabelec
&Scoped-define FIRST-EXTERNAL-TABLE estabelec


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estabelec.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS estabelec.int-2 estabelec.endereco ~
estabelec.bairro estabelec.cidade estabelec.pais 
&Scoped-define ENABLED-TABLES estabelec
&Scoped-define FIRST-ENABLED-TABLE estabelec
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS estabelec.deposito-cq estabelec.dep-rej-cq ~
estabelec.int-2 estabelec.endereco estabelec.bairro estabelec.cidade ~
estabelec.estado estabelec.pais 
&Scoped-define DISPLAYED-TABLES estabelec
&Scoped-define FIRST-DISPLAYED-TABLE estabelec
&Scoped-Define DISPLAYED-OBJECTS c-deposito1 c-deposito2 c-per-descricao ~
c-cep l-integra-estab-his 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS estabelec.deposito-cq estabelec.dep-rej-cq 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
cod-estabel|y|y|mgadm.estabelec.cod-estabel
cod-emitente||y|mgadm.estabelec.cod-emitente
ep-codigo||y|mgadm.estabelec.ep-codigo
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "cod-estabel",
     Keys-Supplied = "cod-estabel,cod-emitente,ep-codigo"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-cep AS CHARACTER
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-deposito1 AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 33.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-deposito2 AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 33.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-per-descricao AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 33.29 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 9.5.

DEFINE VARIABLE l-integra-estab-his AS LOGICAL INITIAL no 
     LABEL "Integra HIS" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     estabelec.deposito-cq AT ROW 1.25 COL 34.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-deposito1 AT ROW 1.25 COL 41.57 COLON-ALIGNED HELP
          "Descriá∆o do Dep¢sito" NO-LABEL
     estabelec.dep-rej-cq AT ROW 2.25 COL 34.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-deposito2 AT ROW 2.25 COL 41.43 COLON-ALIGNED HELP
          "Descriá∆o do Dep¢sito" NO-LABEL
     estabelec.int-2 AT ROW 3.25 COL 34 COLON-ALIGNED
          LABEL "Tipo Per°odo Produá∆o" FORMAT ">9"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-per-descricao AT ROW 3.25 COL 41.43 COLON-ALIGNED HELP
          "Descriá∆o do Dep¢sito" NO-LABEL
     estabelec.endereco AT ROW 4.25 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 36.14 BY .88
     estabelec.bairro AT ROW 5.25 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     estabelec.cidade AT ROW 6.25 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 26.14 BY .88
     estabelec.estado AT ROW 7.25 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-cep AT ROW 8.25 COL 34 COLON-ALIGNED
     estabelec.pais AT ROW 9.25 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     l-integra-estab-his AT ROW 9.25 COL 70 WIDGET-ID 12
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.estabelec
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
         HEIGHT             = 9.58
         WIDTH              = 88.
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

/* SETTINGS FOR FILL-IN c-cep IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-deposito1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-deposito2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-per-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estabelec.dep-rej-cq IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN estabelec.deposito-cq IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN estabelec.estado IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estabelec.int-2 IN FRAME f-main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR TOGGLE-BOX l-integra-estab-his IN FRAME f-main
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

&Scoped-define SELF-NAME c-cep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cep V-table-Win
ON ENTRY OF c-cep IN FRAME f-main
DO:
    if avail param-global then  
        assign c-cep:format in frame {&FRAME-NAME} = param-global.formato-cep.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cep V-table-Win
on leave of c-cep in frame f-main
do:

  if length(c-cep:format in frame {&frame-name}) <> 
     length(c-cep:screen-value in frame {&frame-name}) then do:
       run utp/ut-msgs.p(input "show",
                         input 4334,
                         input trim(return-value)).
       return no-apply.
  end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.dep-rej-cq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.dep-rej-cq V-table-Win
ON F5 OF estabelec.dep-rej-cq IN FRAME f-main /* Dep¢sito Rejeiá∆o CQ */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z01in084.w
                     &campo=estabelec.dep-rej-cq
                     &campozoom=cod-depos}  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.dep-rej-cq V-table-Win
ON LEAVE OF estabelec.dep-rej-cq IN FRAME f-main /* Dep¢sito Rejeiá∆o CQ */
DO:
    {include/leave.i &tabela=deposito
                     &atributo-ref=nome
                     &variavel-ref=c-deposito2
                     &where="deposito.cod-depos = input frame {&frame-name} 
                       estabelec.dep-rej-cq"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.dep-rej-cq V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.dep-rej-cq IN FRAME f-main /* Dep¢sito Rejeiá∆o CQ */
DO:

apply 'F5' to self. 
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.deposito-cq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.deposito-cq V-table-Win
ON F5 OF estabelec.deposito-cq IN FRAME f-main /* Dep¢sito CQ */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z01in084.w
                     &campo=estabelec.deposito-cq
                     &campozoom=cod-depos}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.deposito-cq V-table-Win
ON LEAVE OF estabelec.deposito-cq IN FRAME f-main /* Dep¢sito CQ */
DO:
  {include/leave.i &tabela=deposito
                   &atributo-ref=nome
                   &variavel-ref=c-deposito1
                    &where="deposito.cod-depos = input frame {&frame-name} 
                    estabelec.deposito-cq"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.deposito-cq V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.deposito-cq IN FRAME f-main /* Dep¢sito CQ */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.estado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.estado V-table-Win
ON F5 OF estabelec.estado IN FRAME f-main /* UF */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=unzoom/z01un007.w
                       &campo=estabelec.estado
                       &campozoom=estado
                       &campo2=estabelec.pais
                       &campozoom2=pais}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.estado V-table-Win
ON LEAVE OF estabelec.estado IN FRAME f-main /* UF */
DO:
  assign estabelec.estado:screen-value in frame {&frame-name} = caps(estabelec.estado:screen-value in frame {&frame-name}).
  if adm-new-record then do:
      find first unid-feder where
           unid-feder.estado = input frame {&frame-name} estabelec.estado
           no-lock no-error.
      if avail unid-feder then
          assign estabelec.pais:screen-value in frame {&frame-name} = unid-feder.pais.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.estado V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.estado IN FRAME f-main /* UF */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.int-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.int-2 V-table-Win
ON F5 OF estabelec.int-2 IN FRAME f-main /* Tipo Per°odo Produá∆o */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in299.w
                       &campo=estabelec.int-2
                       &campozoom=nr-periodo}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.int-2 V-table-Win
ON LEAVE OF estabelec.int-2 IN FRAME f-main /* Tipo Per°odo Produá∆o */
DO:
    {include/leave.i &tabela=tipo-per
                 &atributo-ref=descricao
                 &variavel-ref=c-per-descricao
                 &where="tipo-per.cd-tipo = input frame {&frame-name} estabelec.int-2"}

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.int-2 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.int-2 IN FRAME f-main /* Tipo Per°odo Produá∆o */
DO:
  apply 'F5' to self. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-integra-estab-his
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-integra-estab-his V-table-Win
ON VALUE-CHANGED OF l-integra-estab-his IN FRAME f-main /* Integra HIS */
DO:
   IF l-integra-estab-his:CHECKED IN FRAME {&frame-name} = NO THEN
       IF AVAILABLE estabelec AND SUBSTRING(estabelec.char-2, 214, 1) = "S" THEN
           RUN utp/ut-msgs.p (INPUT 'show', 
                              INPUT 54543, 
                              INPUT '').

             
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.pais
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.pais V-table-Win
ON F5 OF estabelec.pais IN FRAME f-main /* Pa°s */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=unzoom/z01un007.w
                       &campo=estabelec.pais
                       &campozoom=pais}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.pais V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.pais IN FRAME f-main /* Pa°s */
DO:
  apply 'F5' to self.

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

if estabelec.deposito-cq:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
if estabelec.dep-rej-cq:load-mouse-pointer  ("image~\lupa.cur") in frame {&frame-name} then.
IF  estabelec.int-2:LOAD-MOUSE-POINTER      ("image\lupa.cur") IN FRAME {&frame-name} THEN.
if estabelec.pais:load-mouse-pointer        ("image~\lupa.cur") in frame {&frame-name} then.
if estabelec.estado:load-mouse-pointer      ("image~\lupa.cur") in frame {&frame-name} then.

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
    WHEN 'cod-estabel':U THEN
       {src/adm/template/find-tbl.i
           &TABLE = estabelec
           &WHERE = "WHERE estabelec.cod-estabel eq key-value"
       }
  END CASE.

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
  {src/adm/template/row-list.i "estabelec"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "estabelec"}

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

/* Code placed here will execute AFTER standard behavior.    */
  
/* sugerir QC no campo dep¢sito CQ se idioma ING */  

if  adm-new-record then do:
{include/i-lgcode.i}
if "{&language-code}" = "ING"
     then  do:
       assign estabelec.deposito-cq:screen-value in frame {&frame-name} = "QC". 
     end.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
procedure local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
  {include/i-valid.i}
  assign c-cep-unformat = replace(input frame {&frame-name} c-cep,".","")
         c-cep-unformat = replace(c-cep-unformat,",","") 
         c-cep-unformat = replace(c-cep-unformat,"-","")
         c-cep-unformat = replace(c-cep-unformat,";","").

  run dispatch in this-procedure ( input 'assign-record':u ) .

  assign estabelec.cep = integer(c-cep-unformat).

end procedure.

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

   assign estabelec.estado = estabelec.estado:screen-value in frame {&frame-name}.
  /* Code placed here will execute AFTER standard behavior.    */

  ASSIGN OVERLAY(estabelec.char-2, 214, 1) = IF l-integra-estab-his:CHECKED IN FRAME {&frame-name} THEN "S"
                                             ELSE "N".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  IF SUBSTRING(estabelec.char-2, 214, 1) = "S" THEN
     ASSIGN l-integra-estab-his:CHECKED IN FRAME {&frame-name} = YES.
  ELSE ASSIGN l-integra-estab-his:CHECKED IN FRAME {&frame-name} = NO.
                                             
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
     IF VALID-HANDLE(h-cdapi704) THEN DO:
          DELETE PROCEDURE h-cdapi704.
          ASSIGN h-cdapi704 = ?.
     END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

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
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .
  
    &if  defined(ADM-MODIFY-FIELDS) &then
        disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    DISABLE estabelec.deposito-cq
            estabelec.dep-rej-cq
            c-cep
            estabelec.estado
            l-integra-estab-his
            WITH FRAME {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

def var c-cep-aux  as char format "x(12)" no-undo.

    if available estabelec then do:
    
    if avail estabelec and avail param-global then
        assign c-cep-aux = param-global.formato-cep
               c-cep-aux = replace(c-cep-aux,".","")
               c-cep-aux = replace(c-cep-aux,"-","")
               c-cep-aux = replace(c-cep-aux,";","").

        find deposito where deposito.cod-depos = estabelec.deposito-cq no-lock no-error.
        assign c-deposito1 = if avail deposito then deposito.nome else "":U.
       
        find deposito where deposito.cod-depos = estabelec.dep-rej-cq no-lock no-error.
        assign c-deposito2 = if avail deposito then deposito.nome else "":U.           
       
        find first tipo-per no-lock
             where tipo-per.cd-tipo = estabelec.int-2 no-error.
        if avail tipo-per then
            assign c-per-descricao = tipo-per.descricao.
        else
           assign c-per-descricao = "".      
    end. 

    if avail estabelec then 
        assign c-cep = string(estabelec.cep).    
    if avail param-global then    
        assign c-cep:format in frame {&frame-name} = param-global.formato-cep.    
    
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
    
    if avail param-global then    
        assign c-cep:format in frame {&frame-name} = param-global.formato-cep.
    
    if avail estabelec 
    and length(string(estabelec.cep)) < length(c-cep-aux) then
        assign c-cep:screen-value in frame {&frame-name} = fill("0",length(c-cep-aux) - length(string(estabelec.cep))) + string(estabelec.cep).

    IF AVAIL estabelec THEN DO:
       IF CAN-FIND (FIRST funcao 
                    WHERE funcao.cd-funcao = "spp-integra-ems-his"
                      AND funcao.ativo     = YES) THEN 
          ASSIGN l-integra-estab-his:CHECKED IN FRAME {&FRAME-NAME} = SUBSTRING(estabelec.char-2, 214, 1) = "S".
       ELSE 
           ASSIGN l-integra-estab-his:HIDDEN    IN FRAME {&FRAME-NAME} = YES  
                  l-integra-estab-his:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    END.

    /* sugerir QC no campo dep¢sito CQ se idioma ING */
    if adm-new-record then do:
    {include/i-lgcode.i}
    if "{&language-code}" = "ING" 
       then  do:
         assign estabelec.deposito-cq:screen-value in frame {&frame-name} = "QC". 
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
  run get-attribute ('adm-new-record').

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
  enable estabelec.estado c-cep with frame {&frame-name}.

  IF AVAIL estabelec THEN DO:
      IF CAN-FIND (FIRST funcao 
                   WHERE funcao.cd-funcao = "spp-integra-ems-his"
                     AND funcao.ativo     = YES) THEN DO:
          IF adm-new-record THEN 
              ASSIGN l-integra-estab-his:CHECKED IN FRAME {&FRAME-NAME} = NO.
          ENABLE l-integra-estab-his WITH FRAME {&frame-name}.
      END.          
  END.
    
  IF  AVAIL param-global THEN DO:
      IF  param-global.modulo-cq = no THEN
          DISABLE estabelec.deposito-cq
                  estabelec.dep-rej-cq
                  WITH FRAME {&frame-name}.
      ELSE
          ENABLE estabelec.deposito-cq 
                 estabelec.dep-rej-cq
                 WITH FRAME {&frame-name}.            
  END.

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

  /* Code placed here will execute AFTER standard behavior.    */
 
  FIND FIRST param-global NO-LOCK no-error.

  {utp/ut-liter.i "CEP" * R}
  assign c-cep:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgadm estabelec estado 1}
  assign estabelec.estado:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Integra_HIS *}
  assign l-integra-estab-his:label in frame {&frame-name} = trim(return-value).

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
   /* sugerir QC como campo init do dep¢sito CQ qd ING */

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
   
 IF  AVAIL param-global THEN DO:
  
     IF  param-global.modulo-cq = yes THEN DO:
         find first deposito where deposito.cod-depos = input frame {&frame-name} estabelec.deposito-cq and
                    deposito.ind-dep-cq = yes no-lock no-error.
         if not avail deposito then do:
           {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show", 
                               input 1014, 
                               input "").
            apply 'entry' to estabelec.deposito-cq in frame {&frame-name}.
            return 'adm-error'.       
         end.
         find first deposito where deposito.cod-depos = input frame {&frame-name} estabelec.dep-rej-cq and
                    deposito.ind-dep-rej = yes no-lock no-error.
         if not avail deposito then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show", 
                               input 1015, 
                               input "").
            apply 'entry' to estabelec.dep-rej-cq in frame {&frame-name}.
            return 'adm-error'.
         end.                
     END.  /* if param-global ... */  
  END. /* if avail param-global ... */   
  
 find first unid-feder where 
            unid-feder.pais = input frame {&frame-name} estabelec.pais and           
            unid-feder.estado = input frame {&frame-name} estabelec.estado 
            no-lock no-error.
 if not avail unid-feder then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p (input "show", 
                       input 4259, 
                       input "").
    apply 'entry' to estabelec.estado in frame {&frame-name}.
    return 'adm-error'.
 end.

 IF input frame {&frame-name} estabelec.pais = "Brasil" THEN DO:

     assign c-cep-aux = string(int(input frame {&frame-name} c-cep)) no-error.

    if c-cep-aux = "" or c-cep-aux = "0" then do:
        {include/i-vldprg.i}        
        run utp/ut-msgs.p (input "show", input 192, input "").
        apply 'entry' to c-cep.
        return "adm-error".
    end.

 END.

 IF CAN-FIND(FIRST pais WHERE 
                     pais.nome-pais = INPUT FRAME {&FRAME-NAME} estabelec.pais AND
                     pais.int-2     <> 1) THEN DO:

      IF NOT VALID-HANDLE(h-cdapi704) THEN
         RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.

      RUN pi-trata-endereco IN h-cdapi704 (INPUT INPUT FRAME {&FRAME-NAME} estabelec.endereco, OUTPUT c-rua, OUTPUT c-nro, OUTPUT c-comp).

      ASSIGN c-endereco-aux = c-rua +
                              IF c-nro <> "" AND c-comp <> "" THEN " " + c-nro + " " + c-comp
                                                              ELSE ""
             c-endereco-aux = c-endereco-aux +
                               IF c-nro <> "" AND c-comp = "" THEN " " + c-nro ELSE ""
             c-endereco-aux = c-endereco-aux +
                               IF c-nro = "" AND c-comp <> "" THEN " " + c-comp ELSE "".

       IF c-nro = "" THEN DO:

          ASSIGN c-help = "N∆o foi poss°vel identificar no endereáo informado os componentes Logradouro e N£mero do Endereáo. Veja abaixo exemplo de formatos v†lidos:" + CHR(13) + 
                           "AV. PRESIDENTE COSTA E SILVA, 1178 - SALA 5" + CHR(13) + 
                           "AV. GETÈLIO VARGAS 1178 TêRREO"              + CHR(13) + 
                           "MARGINAL DA VIA ANCHIETA, KM 23"             + CHR(13) + 
                           "RUA MARECHAL DEODORO NR. 251"                + CHR(13) + 
                           "RUA VISCONDE DE MAUA N.1890 ED. SENTRA"      + CHR(13) + 
                           "AV ANTONIO DE CARVALHO 2600/3108"            + CHR(13) + 
                           "AV. TEODOMIRO DA FONSECA, 2173 BL1"          + CHR(13) + 
                           "RODOVIA BR 101 - KM29 - IGARASSU"            + CHR(13) + 
                           "RUA XV DE NOVEMBRO AP. 121 Nr 415"           + CHR(13) + 
                           "AV. BANDEIRA GOMES S/N - ED.MEDSERV"         + CHR(13) + 
                           "RUA 1650, NR 900, BLOCO 2".

          IF CAN-FIND(FIRST pais WHERE 
                            pais.nome-pais = INPUT FRAME {&FRAME-NAME} estabelec.pais AND
                            pais.int-2     = 2) THEN DO: /* Advertencia */
              /* Inicio -- Projeto Internacional */
              {utp/ut-liter.i "Formato_do_endereáo_do_estabelecimento_desconhecido._Deseja_continuar?" *}
              RUN utp/ut-msgs.p (INPUT "show":U,
                                INPUT  27100,
                                INPUT RETURN-VALUE + "~~" + c-help).

               IF RETURN-VALUE = "NO":U THEN DO:
                 APPLY "ENTRY" TO estabelec.endereco IN FRAME f-main.
                 RETURN 'adm-error':U.
              END.
          END.
    
          IF CAN-FIND(FIRST pais WHERE 
                            pais.nome-pais = INPUT FRAME {&FRAME-NAME} estabelec.pais AND
                            pais.int-2     = 3) THEN DO: /* Com Bloqueio */
              /* Inicio -- Projeto Internacional */
              {utp/ut-liter.i "Formato_do_endereáo_do_estabelecimento_inv†lido" *}
              RUN utp/ut-msgs.p (INPUT "show":U,
                                INPUT  17006,
                                INPUT RETURN-VALUE + "." + "~~" + c-help).
              APPLY "ENTRY" TO estabelec.endereco IN FRAME f-main.
              RETURN 'adm-error':U.
          END.
       END.

 END.
 
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
  {src/adm/template/sndkycas.i "cod-estabel" "estabelec" "cod-estabel"}
  {src/adm/template/sndkycas.i "cod-emitente" "estabelec" "cod-emitente"}
  {src/adm/template/sndkycas.i "ep-codigo" "estabelec" "ep-codigo"}

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
  {src/adm/template/snd-list.i "estabelec"}

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

