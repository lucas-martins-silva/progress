&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
{include/i-prgvrs.i V03IN050 2.00.00.015 } /*** 010015 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v03in050 MUT}
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
def var c-aux      as char   format "x(04)" init "9999" no-undo.
def var c-decimal  as char   format "x(05)" no-undo.
def var c-formato  as char   format "x(14)" no-undo.
def var c-retorno  as char   no-undo.
def var wh-retorno as handle no-undo.

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
&Scoped-define EXTERNAL-TABLES comp-exame
&Scoped-define FIRST-EXTERNAL-TABLE comp-exame


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR comp-exame.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS comp-exame.tipo-result comp-exame.nr-decimais ~
comp-exame.result-min comp-exame.result-max comp-exame.nr-tabela ~
comp-exame.compl-res comp-exame.unidade comp-exame.log-1 
&Scoped-define ENABLED-TABLES comp-exame
&Scoped-define FIRST-ENABLED-TABLE comp-exame
&Scoped-Define ENABLED-OBJECTS c-label-tipo-result txt-sit RECT-2 RECT-3 ~
rt-key 
&Scoped-Define DISPLAYED-FIELDS comp-exame.tipo-result ~
comp-exame.nr-decimais comp-exame.result-min comp-exame.result-max ~
comp-exame.nr-tabela comp-exame.compl-res comp-exame.unidade ~
comp-exame.log-1 
&Scoped-define DISPLAYED-TABLES comp-exame
&Scoped-define FIRST-DISPLAYED-TABLE comp-exame
&Scoped-Define DISPLAYED-OBJECTS c-des-nr-tabela c-label-tipo-result ~
txt-sit 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS c-label-tipo-result txt-sit 
&Scoped-define ADM-ASSIGN-FIELDS c-label-tipo-result txt-sit 
&Scoped-define ADM-MODIFY-FIELDS c-label-tipo-result txt-sit 

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
DEFINE VARIABLE c-des-nr-tabela AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-label-tipo-result AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE txt-sit AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .58 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 51 BY 1.33.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 30 BY 1.33.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.57 BY 10.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     comp-exame.tipo-result AT ROW 2 COL 23 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "NumÇrico", 1,
"Tabela", 2,
"Texto", 3,
"Faixa", 4
          SIZE 48 BY .88
     comp-exame.nr-decimais AT ROW 3.33 COL 27.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2.57 BY .88
     comp-exame.result-min AT ROW 4.33 COL 27.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     comp-exame.result-max AT ROW 5.33 COL 27.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     comp-exame.nr-tabela AT ROW 6.33 COL 27.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     c-des-nr-tabela AT ROW 6.33 COL 33.14 COLON-ALIGNED HELP
          "Descriá∆o da Tabela de Resultado" NO-LABEL
     comp-exame.compl-res AT ROW 7.33 COL 27.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     comp-exame.unidade AT ROW 8.33 COL 27.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     comp-exame.log-1 AT ROW 10.08 COL 24
          VIEW-AS TOGGLE-BOX
          SIZE 15 BY .83
     c-label-tipo-result AT ROW 1.25 COL 22 COLON-ALIGNED NO-LABEL
     txt-sit AT ROW 9.5 COL 21 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 1.79 COL 22
     RECT-3 AT ROW 9.79 COL 22
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.comp-exame
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
         HEIGHT             = 10.5
         WIDTH              = 85.57.
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

/* SETTINGS FOR FILL-IN c-des-nr-tabela IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-label-tipo-result IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN txt-sit IN FRAME f-main
   1 2 3                                                                */
ASSIGN 
       txt-sit:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME comp-exame.nr-decimais
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL comp-exame.nr-decimais V-table-Win
ON LEAVE OF comp-exame.nr-decimais IN FRAME f-main /* Decimais */
DO:

if input frame {&FRAME-NAME} comp-exame.nr-decimais > 4
      then do:
         run utp/ut-msgs.p (input "show",
                            input 17500,
                            input 4).
        apply "entry" to comp-exame.nr-decimais in frame {&frame-name}.
        return no-apply.
     end.                                   



  /* Coloca resultado m°nimo e resultado m†ximo em seu formato */
  assign c-decimal = "." + substr(c-aux,1,int(comp-exame.nr-decimais:screen-value in frame {&FRAME-NAME})).
  if  c-decimal = "." then
      assign c-decimal = "".
  assign c-formato = "->,>>>,>>9" + c-decimal
         comp-exame.result-min:format in frame {&FRAME-NAME} = c-formato
         comp-exame.result-max:format in frame {&FRAME-NAME} = c-formato.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME comp-exame.nr-tabela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL comp-exame.nr-tabela V-table-Win
ON F5 OF comp-exame.nr-tabela IN FRAME f-main /* Tabela */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom="inzoom\z01in416.w"
                  &tabela=comp-exame
                  &atributo=nr-tabela}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL comp-exame.nr-tabela V-table-Win
ON LEAVE OF comp-exame.nr-tabela IN FRAME f-main /* Tabela */
DO:
  assign l-implanta = yes.
  {include/leave.i &tabela=tab-result
                   &atributo-ref=descricao
                   &variavel-ref=c-des-nr-tabela
                   &where="tab-result.nr-tabela = input frame {&FRAME-NAME} comp-exame.nr-tabela"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL comp-exame.nr-tabela V-table-Win
ON MOUSE-SELECT-DBLCLICK OF comp-exame.nr-tabela IN FRAME f-main /* Tabela */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME comp-exame.tipo-result
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL comp-exame.tipo-result V-table-Win
ON VALUE-CHANGED OF comp-exame.tipo-result IN FRAME f-main /* Tp Result */
DO:

  if integer(comp-exame.tipo-result:screen-value in frame {&FRAME-NAME}) <> 1 and
     integer(comp-exame.tipo-result:screen-value in frame {&FRAME-NAME}) <> 4 then do:
     assign comp-exame.nr-decimais:screen-value in frame {&FRAME-NAME} = "0"
            comp-exame.result-min:screen-value  in frame {&FRAME-NAME} = "0"
            comp-exame.result-max:screen-value  in frame {&FRAME-NAME} = "0".
     disable comp-exame.nr-decimais
             comp-exame.result-min
             comp-exame.result-max with frame {&FRAME-NAME}.
  end.
  else
     enable comp-exame.nr-decimais
            comp-exame.result-min
            comp-exame.result-max with frame {&FRAME-NAME}.  

  if integer(comp-exame.tipo-result:screen-value in frame {&FRAME-NAME}) = 2 then
     enable comp-exame.nr-tabela
            comp-exame.compl-res with frame {&FRAME-NAME}.
  else do:
     assign comp-exame.nr-tabela:screen-value  in frame {&FRAME-NAME} = "0"
            comp-exame.compl-res:screen-value  in frame {&FRAME-NAME} = ""
            c-des-nr-tabela:screen-value       in frame {&FRAME-NAME} = "".
     disable comp-exame.nr-tabela
             comp-exame.compl-res with frame {&FRAME-NAME}.
  end.

  if integer(comp-exame.tipo-result:screen-value in frame {&FRAME-NAME}) <> 3 then
     enable comp-exame.unidade with frame {&FRAME-NAME}.
  else do:
     assign comp-exame.unidade:screen-value  in frame {&FRAME-NAME} = "".
     disable comp-exame.unidade with frame {&FRAME-NAME}.
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

  {utp/ut-liter.i Ativa * r}
  assign comp-exame.log-1:label in frame {&frame-name} = trim(return-value).

  {utp/ut-rtlbl.i mgind comp-exame tipo-result c-label-tipo-result}

  {utp/ut-liter.i Situaá∆o * r}
  assign txt-sit:screen-value in frame {&frame-name} = trim(return-value).

  if comp-exame.nr-tabela:load-mouse-pointer ("image/lupa.cur") in frame {&FRAME-NAME} then.

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
  {src/adm/template/row-list.i "comp-exame"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "comp-exame"}

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

  ASSIGN comp-exame.tipo-result:screen-value in frame {&FRAME-NAME} = '1'.

  apply "value-changed" to comp-exame.tipo-result in frame {&FRAME-NAME}.

  /* Code placed here will execute AFTER standard behavior.    */

  {utp/ut-rtlbl.i mgind comp-exame tipo-result c-label-tipo-result}

  {utp/ut-liter.i Situaá∆o * r}
  assign txt-sit:screen-value in frame {&frame-name} = trim(return-value)
         comp-exame.log-1:checked in frame {&frame-name} = yes.

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
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.
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
    
    find exame where rowid(exame) = v-row-parent no-error.
    if avail exame then
        assign comp-exame.cod-exame  = exame.cod-exame
               comp-exame.cdn-versao = exame.cdn-versao.
    
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
  /* Coloca resultado m°nimo e resultado m†ximo em seu formato */
  if avail comp-exame then
      assign c-decimal = "." + substr(c-aux,1,comp-exame.nr-decimais).
      if  c-decimal = "." then
          assign c-decimal = "".

  assign c-formato = "->,>>>,>>9" + c-decimal
         comp-exame.result-min:format in frame {&FRAME-NAME} = c-formato
         comp-exame.result-max:format in frame {&FRAME-NAME} = c-formato.

  if  avail comp-exame then do:
      find tab-result
          where tab-result.nr-tabela = comp-exame.nr-tabela
          no-lock no-error.
      assign c-des-nr-tabela = if avail tab-result then tab-result.descricao else "":U.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  /* Habilitaá∆o de campos */
  disable comp-exame.nr-decimais
          comp-exame.result-min
          comp-exame.result-max
          comp-exame.compl-res
          comp-exame.nr-tabela
          comp-exame.unidade with frame {&FRAME-NAME}.


  if  int(comp-exame.tipo-result:screen-value in frame {&FRAME-NAME}) = 1
  or  int(comp-exame.tipo-result:screen-value in frame {&FRAME-NAME}) = 4 then
      enable comp-exame.nr-decimais
             comp-exame.result-min
             comp-exame.result-max with frame {&FRAME-NAME}.

  if  int(comp-exame.tipo-result:screen-value in frame {&FRAME-NAME}) = 2 then
      enable comp-exame.nr-tabela
             comp-exame.compl-res with frame {&FRAME-NAME}.

  if  int(comp-exame.tipo-result:screen-value in frame {&FRAME-NAME}) <> 3 then
      enable comp-exame.unidade with frame {&FRAME-NAME}.


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

  apply "value-changed" to comp-exame.tipo-result in frame {&FRAME-NAME}.

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
   {utp/ut-rtlbl.i mgind comp-exame tipo-result c-label-tipo-result}

  {utp/ut-liter.i Situaá∆o * r}
  assign txt-sit:screen-value in frame {&frame-name} = trim(return-value)
         comp-exame.log-1:checked in frame {&frame-name} = yes.

  ASSIGN comp-exame.tipo-result:screen-value in frame {&FRAME-NAME} = '1'.

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

  RUN Who-Is-The-Container IN adm-broker-hdl
    (INPUT this-procedure,
     OUTPUT c-retorno).
  assign wh-retorno = widget-handle(c-retorno).

  /* Ponha aqui as demais validaá‰es */
  if  int(comp-exame.result-max:screen-value in frame {&FRAME-NAME}) < 
      int(comp-exame.result-min:screen-value in frame {&FRAME-NAME}) then do:
      run utp/ut-msgs.p (input "show",
                         input 692,
                         input comp-exame.result-max:screen-value in frame {&FRAME-NAME} + "~~" +
                               comp-exame.result-min:screen-value in frame {&FRAME-NAME}).
      run select-page in wh-retorno (2).
      apply 'entry' to comp-exame.result-min.
      return 'ADM-ERROR':U.
  end.

  if  comp-exame.nr-tabela:sensitive in frame {&FRAME-NAME} = yes then do:
      find tab-result
          where tab-result.nr-tabela = integer(comp-exame.nr-tabela:screen-value in frame {&FRAME-NAME})
          no-lock no-error.
      if  not avail tab-result then do:
          {utp/ut-table.i mgind tab-result 1}
          run utp/ut-msgs.p (input "show", input 2, input return-value).
          run select-page in wh-retorno (2).
          apply 'entry' to comp-exame.nr-tabela.
          return 'ADM-ERROR':U.
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
  {src/adm/template/snd-list.i "comp-exame"}

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

