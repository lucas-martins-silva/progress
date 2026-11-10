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
{include/i-prgvrs.i V02IN261 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN261 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES oper-pad
&Scoped-define FIRST-EXTERNAL-TABLE oper-pad


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR oper-pad.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS oper-pad.data-inicio oper-pad.refugo-op ~
oper-pad.tipo-oper oper-pad.data-termino oper-pad.proporcao ~
oper-pad.gm-codigo oper-pad.fi-codigo oper-pad.pto-controle ~
oper-pad.cd-mob-dir oper-pad.emite-ficha oper-pad.contr-qualidade 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}data-inicio ~{&FP2}data-inicio ~{&FP3}~
 ~{&FP1}refugo-op ~{&FP2}refugo-op ~{&FP3}~
 ~{&FP1}data-termino ~{&FP2}data-termino ~{&FP3}~
 ~{&FP1}proporcao ~{&FP2}proporcao ~{&FP3}~
 ~{&FP1}gm-codigo ~{&FP2}gm-codigo ~{&FP3}~
 ~{&FP1}fi-codigo ~{&FP2}fi-codigo ~{&FP3}~
 ~{&FP1}pto-controle ~{&FP2}pto-controle ~{&FP3}~
 ~{&FP1}cd-mob-dir ~{&FP2}cd-mob-dir ~{&FP3}
&Scoped-define ENABLED-TABLES oper-pad
&Scoped-define FIRST-ENABLED-TABLE oper-pad
&Scoped-Define ENABLED-OBJECTS rt-mold1 rt-mold2 rt-mold3 rt-mold4 rt-mold5 ~
rt-mold6 
&Scoped-Define DISPLAYED-FIELDS oper-pad.data-inicio oper-pad.refugo-op ~
oper-pad.tipo-oper oper-pad.data-termino oper-pad.proporcao ~
oper-pad.gm-codigo oper-pad.fi-codigo oper-pad.pto-controle ~
oper-pad.cd-mob-dir oper-pad.emite-ficha oper-pad.contr-qualidade 
&Scoped-Define DISPLAYED-OBJECTS c-grup-maquina-descricao ~
c-ficha-metodo-descricao c-pto-controle-descricao c-descricao-mob 

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
nr-oper-pad|y|y|mgind.oper-pad.nr-oper-pad
fi-codigo||y|mgind.oper-pad.fi-codigo
gm-codigo||y|mgind.oper-pad.gm-codigo
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "nr-oper-pad",
     Keys-Supplied = "nr-oper-pad,fi-codigo,gm-codigo"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-descricao-mob AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 31.14 BY .88.

DEFINE VARIABLE c-ficha-metodo-descricao AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-grup-maquina-descricao AS CHARACTER FORMAT "X(32)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE VARIABLE c-pto-controle-descricao AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE Fi-titulo-tipo AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 11.86 BY .63 NO-UNDO.

DEFINE RECTANGLE rt-mold1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 19.14 BY 2.25.

DEFINE RECTANGLE rt-mold2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 33.14 BY 2.25.

DEFINE RECTANGLE rt-mold3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 31.57 BY 2.25.

DEFINE RECTANGLE rt-mold4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 4.25.

DEFINE RECTANGLE rt-mold5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 40.57 BY 1.25.

DEFINE RECTANGLE rt-mold6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 44.14 BY 1.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     oper-pad.data-inicio AT ROW 1.33 COL 38.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     oper-pad.refugo-op AT ROW 1.33 COL 74.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     oper-pad.tipo-oper AT ROW 1.54 COL 5.57 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Interna", 1,
"Externa", 2
          SIZE 13.29 BY 1.75
     oper-pad.data-termino AT ROW 2.33 COL 38.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     oper-pad.proporcao AT ROW 2.33 COL 74.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     oper-pad.gm-codigo AT ROW 3.83 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     c-grup-maquina-descricao AT ROW 3.83 COL 36.57 COLON-ALIGNED NO-LABEL
     oper-pad.fi-codigo AT ROW 4.83 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-ficha-metodo-descricao AT ROW 4.83 COL 29.57 COLON-ALIGNED NO-LABEL
     oper-pad.pto-controle AT ROW 5.83 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     c-pto-controle-descricao AT ROW 5.83 COL 27 COLON-ALIGNED NO-LABEL
     oper-pad.cd-mob-dir AT ROW 6.83 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     c-descricao-mob AT ROW 6.83 COL 31.86 COLON-ALIGNED NO-LABEL
     oper-pad.emite-ficha AT ROW 8.29 COL 8.29
          VIEW-AS TOGGLE-BOX
          SIZE 30.14 BY 1
     oper-pad.contr-qualidade AT ROW 8.33 COL 51.86
          VIEW-AS TOGGLE-BOX
          SIZE 23.86 BY 1
     Fi-titulo-tipo AT ROW 1 COL 2.72 NO-LABEL
     rt-mold1 AT ROW 1.15 COL 1
     rt-mold2 AT ROW 1.17 COL 21
     rt-mold3 AT ROW 1.17 COL 55.14
     rt-mold4 AT ROW 3.67 COL 1
     rt-mold5 AT ROW 8.17 COL 1
     rt-mold6 AT ROW 8.17 COL 42.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.oper-pad
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
         HEIGHT             = 8.42
         WIDTH              = 85.72.
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

/* SETTINGS FOR FILL-IN c-descricao-mob IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-ficha-metodo-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-grup-maquina-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-pto-controle-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Fi-titulo-tipo IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
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

&Scoped-define SELF-NAME oper-pad.cd-mob-dir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-pad.cd-mob-dir V-table-Win
ON F5 OF oper-pad.cd-mob-dir IN FRAME f-main /* C¢digo Mob Direta */
DO:
  {include/zoomvar.i &prog-zoom=inzoom/z01in566.w
                     &campo=oper-pad.cd-mob-dir                     
                     &campozoom=cd-mob-dir
                     &campo2=c-descricao-mob   
                     &campozoom2=descricao} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-pad.cd-mob-dir V-table-Win
ON LEAVE OF oper-pad.cd-mob-dir IN FRAME f-main /* C¢digo Mob Direta */
DO:
  {include/leave.i &tabela=tab-mob-dir
                   &atributo-ref=descricao
                   &variavel-ref=c-descricao-mob
                   &where="tab-mob-dir.cd-mob-dir = input frame {&frame-name} oper-pad.cd-mob-dir"}
                     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-pad.cd-mob-dir V-table-Win
ON MOUSE-SELECT-DBLCLICK OF oper-pad.cd-mob-dir IN FRAME f-main /* C¢digo Mob Direta */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME oper-pad.fi-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-pad.fi-codigo V-table-Win
ON F5 OF oper-pad.fi-codigo IN FRAME f-main /* Ficha M‚todo */
DO:
    {include/zoom.i &prog-zoom="inzoom/z01in125.w" 
                    &tabela=oper-pad 
                    &atributo=fi-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-pad.fi-codigo V-table-Win
ON LEAVE OF oper-pad.fi-codigo IN FRAME f-main /* Ficha M‚todo */
DO:
  {include/leave.i &tabela=ficha-metodo 
                   &atributo-ref=descricao
                   &variavel-ref=c-ficha-metodo-descricao
                   &where="ficha-metodo.fi-codigo =
                    input frame {&frame-name} oper-pad.fi-codigo"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-pad.fi-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF oper-pad.fi-codigo IN FRAME f-main /* Ficha M‚todo */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME oper-pad.gm-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-pad.gm-codigo V-table-Win
ON F5 OF oper-pad.gm-codigo IN FRAME f-main /* Grupo M quina */
DO:
  {include/zoom.i &prog-zoom="inzoom/z01in144.w" 
                  &tabela=oper-pad 
                  &atributo=gm-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-pad.gm-codigo V-table-Win
ON LEAVE OF oper-pad.gm-codigo IN FRAME f-main /* Grupo M quina */
DO:
    {include/leave.i &tabela=grup-maquina 
                     &atributo-ref=descricao
                     &variavel-ref=c-grup-maquina-descricao 
                     &where="grup-maquina.gm-codigo = input frame {&frame-name} oper-pad.gm-codigo"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-pad.gm-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF oper-pad.gm-codigo IN FRAME f-main /* Grupo M quina */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME oper-pad.pto-controle
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-pad.pto-controle V-table-Win
ON F5 OF oper-pad.pto-controle IN FRAME f-main /* Ponto Controle */
DO:
  {include/zoom.i &prog-zoom="inzoom/z01in364.w" 
                  &tabela=oper-pad 
                  &atributo=pto-controle}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-pad.pto-controle V-table-Win
ON LEAVE OF oper-pad.pto-controle IN FRAME f-main /* Ponto Controle */
DO:
    {include/leave.i &tabela=pto-controle 
                     &atributo-ref=descricao
                     &variavel-ref=c-pto-controle-descricao 
                     &where="pto-controle.codigo = input frame {&frame-name} oper-pad.pto-controle"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-pad.pto-controle V-table-Win
ON MOUSE-SELECT-DBLCLICK OF oper-pad.pto-controle IN FRAME f-main /* Ponto Controle */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  /* titulo do retangulo para o campo oper-pad.tipo-oper */
  {utp/ut-rtlbl.i mgind oper-pad tipo-oper fi-titulo-tipo}
  
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

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
    WHEN 'nr-oper-pad':U THEN
       {src/adm/template/find-tbl.i
           &TABLE = oper-pad
           &WHERE = "WHERE oper-pad.nr-oper-pad eq INTEGER(key-value)"
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
  {src/adm/template/row-list.i "oper-pad"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "oper-pad"}

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
  if avail oper-pad then do:
     find ficha-metodo where ficha-metodo.fi-codigo = oper-pad.fi-codigo no-lock no-error.
     assign c-ficha-metodo-descricao = if avail ficha-metodo then ficha-metodo.descricao else "":U.
     
     find grup-maquina where grup-maquina.gm-codigo = oper-pad.gm-codigo no-lock no-error.
     assign c-grup-maquina-descricao = if avail grup-maquina then grup-maquina.descricao else "":U.
     
     find pto-controle where pto-controle.codigo = oper-pad.pto-controle no-lock no-error.
     assign c-pto-controle-descricao = if avail pto-controle then pto-controle.descricao else "":U.
     
     find tab-mob-dir where tab-mob-dir.cd-mob-dir = oper-pad.cd-mob-dir no-lock no-error.
     assign c-descricao-mob = if avail tab-mob-dir then tab-mob-dir.descricao else "":U.
  end.
  
     

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
  {src/adm/template/sndkycas.i "nr-oper-pad" "oper-pad" "nr-oper-pad"}
  {src/adm/template/sndkycas.i "fi-codigo" "oper-pad" "fi-codigo"}
  {src/adm/template/sndkycas.i "gm-codigo" "oper-pad" "gm-codigo"}

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
  {src/adm/template/snd-list.i "oper-pad"}

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


