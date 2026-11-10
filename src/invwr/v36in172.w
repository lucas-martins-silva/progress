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
{include/i-prgvrs.i V36IN172 2.00.00.056 } /*** "010056" 23/10/2023 11:39:22 ***/

{include/i_fncrowid.i}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v36in172 MUT}
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
def var c-fm-codigo like familia.fm-codigo no-undo.
def var c-it-codigo like item.it-codigo.
DEF VAR h-boin01073 AS   HANDLE            NO-UNDO.
/*def var c-tipo-contr as char.
def var l-busca as log.
def var l-obsoleto as log.
def var c-tabela as char format "x(20)" no-undo.
def var c-nome like item.desc-item no-undo. */
&IF {&ROWID_READY} = YES &THEN
    def new global shared var v_rec_imagem as rowid  no-undo.
&ELSE
    def new global shared var v_rec_imagem as recid  no-undo.
&ENDIF

  DEFINE VARIABLE pIdiClassifItem AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cIdiClassifItem AS CHARACTER  NO-UNDO.

{METHOD/dbotterr.i}
{inbo/boin01073.i tt-item-internac}

DEF VAR hShowMsg AS HANDLE NO-UNDO.
DEF VAR tg-direito-tribut-aux AS LOG NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item.cd-folh-item item.lote-economi ~
item.codigo-refer item.inform-compl item.cod-imagem 
&Scoped-define ENABLED-TABLES item
&Scoped-define FIRST-ENABLED-TABLE item
&Scoped-Define ENABLED-OBJECTS cb-idi-classif-item rt-mold 
&Scoped-Define DISPLAYED-FIELDS item.cd-folh-item item.lote-economi ~
item.codigo-refer item.inform-compl item.cod-imagem 
&Scoped-define DISPLAYED-TABLES item
&Scoped-define FIRST-DISPLAYED-TABLE item
&Scoped-Define DISPLAYED-OBJECTS tg-direito-tribut cb-idi-classif-item ~
c-folh-desc 

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
DEFINE VARIABLE cb-idi-classif-item AS CHARACTER FORMAT "X(20)" INITIAL "1" 
     LABEL "Classificaá∆o Item" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","1"
     DROP-DOWN-LIST
     SIZE 28 BY 1 NO-UNDO.

DEFINE VARIABLE c-folh-desc AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 42.14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.14 BY 7.5.

DEFINE VARIABLE tg-direito-tribut AS LOGICAL INITIAL no 
     LABEL "Direito Tribut†rio" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     tg-direito-tribut AT ROW 7.25 COL 27.72 WIDGET-ID 4
     cb-idi-classif-item AT ROW 7.25 COL 26 COLON-ALIGNED HELP
          "Classifica o item em genÇrico, produto ou insumo" WIDGET-ID 2
     item.cd-folh-item AT ROW 2.25 COL 25.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-folh-desc AT ROW 2.25 COL 38.72 COLON-ALIGNED NO-LABEL
     item.lote-economi AT ROW 3.25 COL 25.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     item.codigo-refer AT ROW 4.25 COL 25.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 26 BY .88
     item.inform-compl AT ROW 5.25 COL 25.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     item.cod-imagem AT ROW 6.25 COL 25.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 31.14 BY .88
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item
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
         HEIGHT             = 7.54
         WIDTH              = 85.14.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-folh-desc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-direito-tribut IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       tg-direito-tribut:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME item.cd-folh-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cd-folh-item V-table-Win
ON F5 OF item.cd-folh-item IN FRAME f-main /* Folha Especificaá∆o */
DO:
  def var c-tabela as char no-undo.
  
  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure,
                                                INPUT "fm-codigo").
  assign c-fm-codigo = return-value.
   
  find first folh-fm-it where folh-fm-it.fm-codigo = c-fm-codigo  no-lock no-error.
  if available folh-fm-it then do: 
      assign l-implanta = yes.
      {include/zoomvar.i &prog-zoom="inzoom/z02in130.w"
                         &campo=item.cd-folh-item
                         &campozoom=cd-folha
                         &campo2=c-folh-desc
                         &campozoom2=descricao
                         &parametros="run pi-seta-inicial in wh-pesquisa (input c-fm-codigo)."}
  end.
  else do:       
      {utp/ut-table.i mgind familia 01}
      assign c-tabela = return-value.
      {utp/ut-table.i mgind folh-espec 01}
      run utp/ut-msgs.p (input "show",
                         input 2734  ,
                         input c-tabela + "~~" + return-value).
  end.                        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cd-folh-item V-table-Win
ON LEAVE OF item.cd-folh-item IN FRAME f-main /* Folha Especificaá∆o */
DO:
  assign c-folh-desc:screen-value in frame {&frame-name} = '':U.
  
  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure,
                                                INPUT "fm-codigo").
  assign c-fm-codigo = return-value.
 
  find first folh-fm-it where folh-fm-it.fm-codigo = c-fm-codigo no-lock no-error.
  if available folh-fm-it or input frame {&frame-name} item.cd-folh-item <> '' then do: 
      find folh-fm-it where 
           folh-fm-it.fm-codigo = c-fm-codigo and
           folh-fm-it.cd-folha  = input frame {&frame-name} item.cd-folh-item no-lock no-error.
      if avail folh-fm-it then do:
        {include/leave.i &tabela=folh-espec
                         &atributo-ref=descricao
                         &variavel-ref=c-folh-desc
                         &where="folh-espec.cd-folha = input frame {&frame-name} item.cd-folh-item"}
      end.
      else do:
         if input frame {&frame-name} item.cd-folh-item <> "" then do:      
            run utp/ut-msgs.p (input "show", 
                               input 2676, 
                               input "").
            return no-apply.
         end.   
      end.                        
  end.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cd-folh-item V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.cd-folh-item IN FRAME f-main /* Folha Especificaá∆o */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.cod-imagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-imagem V-table-Win
ON F5 OF item.cod-imagem IN FRAME f-main /* Imagem */
DO:
  run btb/btb104ka.p (param-global.cod-catal-img-it).

  &IF {&ROWID_READY} = YES &THEN
    find imagem no-lock where rowid(imagem)  = v_rec_imagem no-error.
  &ELSE
    find imagem no-lock where recid(imagem)  = v_rec_imagem no-error.
  &ENDIF
  
  if avail imagem then
     assign item.cod-imagem:screen-value = string(imagem.cod_imagem).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-imagem V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.cod-imagem IN FRAME f-main /* Imagem */
DO:
    apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  
  if item.cd-folh-item:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then. 
 
  if item.cod-imagem:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
 
  find first param-global no-lock.
  
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
  {src/adm/template/row-list.i "item"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item"}

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

    IF param-global.ind-int-agro THEN DO:
        RUN pi-seta-campo.

        ASSIGN cIdiClassifItem = cb-idi-classif-item:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
     
        ASSIGN pIdiClassifItem = {ininc/i99in172.i 6 cIdiClassifItem }.

        IF NOT CAN-FIND(FIRST funcao
                        WHERE funcao.cd-funcao = "SPP-desabilita-checkitem-agro"
                          AND funcao.ativo = YES)
        THEN DO:
            //Validaá∆o conforme documentaá∆o publicada no TDN.
            IF (    pIdiClassifItem = 2 AND LENGTH(SUBSTRING(c-it-codigo,1,9)) < 4
                 OR pIdiClassifItem = 3 AND LENGTH(SUBSTRING(c-it-codigo,1,9)) < 8)
            THEN DO: /* Valida se item ≤ 8 posicoes */
                {utp/ut-liter.i C¢digo_do_Item_com_formato_inv†lido. *}
                RUN utp\ut-msgs.p ( INPUT "show",
                                    INPUT 17006,
                                    INPUT RETURN-VALUE).
                RETURN "ADM-ERROR".
            END.
        END.
    END.

    IF i-pais-impto-usuario = 21 THEN
        ASSIGN tg-direito-tribut-aux = tg-direito-tribut:CHECKED IN FRAME {&FRAME-NAME}.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  IF param-global.ind-int-agro THEN DO:
      ASSIGN item.idi-classif-item = pIdiClassifItem.
  END.

  IF i-pais-impto-usuario = 21 AND VALID-HANDLE(h-boin01073) THEN DO: /* Equador */
      
      EMPTY TEMP-TABLE tt-item-internac.
      EMPTY TEMP-TABLE RowErrors.

      RUN goToKey IN h-boin01073 (INPUT ITEM.it-codigo).
      IF RETURN-VALUE = "OK":U THEN
          RUN getRecord IN h-boin01073 (OUTPUT TABLE tt-item-internac).

      RUN emptyRowErrors IN h-boin01073.

      FIND FIRST tt-item-internac NO-LOCK
           WHERE tt-item-internac.it-codigo = ITEM.it-codigo NO-ERROR.

      IF NOT AVAIL tt-item-internac THEN DO:
          CREATE tt-item-internac.
          ASSIGN tt-item-internac.it-codigo          = ITEM.it-codigo
                 tt-item-internac.log-direito-tribut = tg-direito-tribut-aux.

          RUN emptyRowErrors IN h-boin01073.
          RUN setRecord IN h-boin01073 (INPUT TABLE tt-item-internac).
          RUN createRecord IN h-boin01073.
      END.
      ELSE DO:
          ASSIGN tt-item-internac.log-direito-tribut = tg-direito-tribut-aux.
          RUN emptyRowErrors IN h-boin01073.
          RUN setRecord IN h-boin01073 (INPUT TABLE tt-item-internac).
          RUN updateRecord IN h-boin01073.
      END.

  END.

  if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

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
  
  IF i-pais-impto-usuario = 21 AND VALID-HANDLE(h-boin01073) THEN DO: /* Equador */
      DELETE PROCEDURE h-boin01073.
      ASSIGN h-boin01073 = ?.
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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  IF i-pais-impto-usuario = 21 THEN DO: /* Equador */
      ASSIGN tg-direito-tribut:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  END.
  
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
  /*** Quando est† no meio de uma transaá∆o, n∆o sera executada a local-display ***/

  /*if transaction then return. */
  if avail item then do:
     find folh-espec where folh-espec.cd-folha = item.cd-folh-item no-lock no-error.
     assign c-folh-desc = if avail folh-espec then folh-espec.descricao else "":U.
  end.

  ASSIGN cb-idi-classif-item:sensitive in frame {&frame-name} = NO.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  IF param-global.ind-int-agro THEN DO:

     DEFINE VARIABLE c-lista AS CHARACTER   NO-UNDO.
     DEFINE VARIABLE cAuxTraducao005 AS CHARACTER NO-UNDO.
     DEFINE VARIABLE cAuxTraducao006 AS CHARACTER NO-UNDO.
     assign c-lista = {ininc/i99in172.i 3}.
     run utp/ut-lstit.p (input-output c-lista).

     ASSIGN cb-idi-classif-item:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME}= c-lista.
     
     IF item.idi-classif-item > 0
     AND item.idi-classif-item <= {ininc/i99in172.i 5} //Retornar o total de itens da lista
     THEN DO:
         ASSIGN cAuxTraducao006 = {ininc/i99in172.i 4 item.idi-classif-item}.
         run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao006)," ","_"),
                             INPUT "",
                             INPUT "").
    
         ASSIGN cb-idi-classif-item:SCREEN-VALUE = RETURN-VALUE.
     END.
     ELSE
         ASSIGN cb-idi-classif-item:SCREEN-VALUE = "".
     
  END.
  ELSE
     ASSIGN cb-idi-classif-item:VISIBLE in frame {&frame-name} = NO.

  IF i-pais-impto-usuario = 21 AND VALID-HANDLE(h-boin01073) THEN DO: /* Equador */
      DEF VAR tg-direito-tribut-aux AS LOG NO-UNDO.
      RUN goToKey IN h-boin01073 (INPUT ITEM.it-codigo).
      IF RETURN-VALUE = "OK":U THEN DO:
          RUN getLogField IN h-boin01073 (INPUT "log-direito-tribut":U, OUTPUT tg-direito-tribut-aux).
          ASSIGN tg-direito-tribut:CHECKED IN FRAME {&FRAME-NAME} = tg-direito-tribut-aux.
      END.
      ELSE 
          ASSIGN tg-direito-tribut:CHECKED IN FRAME {&FRAME-NAME} = NO.
  END.



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
  
  if param-global.modulo-en = no then 
     assign item.cd-folh-item:sensitive in frame {&frame-name} = no.

  ASSIGN cb-idi-classif-item:sensitive in frame {&frame-name} = param-global.ind-int-agro.

  IF i-pais-impto-usuario = 21 THEN DO: /* Equador */
      ASSIGN tg-direito-tribut:SENSITIVE IN frame {&FRAME-NAME} = YES.
  END.

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
  
  IF i-pais-impto-usuario = 21 AND NOT VALID-HANDLE(h-boin01073) THEN DO: /* Equador */
      RUN inbo/boin01073.p PERSISTENT SET h-boin01073.
      RUN openQueryStatic IN h-boin01073 (INPUT "Main").
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  IF i-pais-impto-usuario = 21 THEN DO: /* Equador*/
      ASSIGN tg-direito-tribut:HIDDEN IN FRAME {&FRAME-NAME} = NO.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-video V-table-Win 
PROCEDURE pi-mostra-video :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
   if (item.cod-imagem:screen-value in frame {&frame-name} = "") then return no-apply. 
  
   find imagem where
        imagem.cod_imagem    = item.cod-imagem:screen-value in frame {&frame-name} and 
        imagem.cod_catal_img = param-global.cod-catal-img-it no-lock no-error.
   if avail imagem then do:
      find catal_img of imagem no-lock no-error.
      if avail catal_img then 
         if search(string(catal_img.cod_path_catal + "/" + imagem.img_imagem)) = ? then do:
             {utp/ut-table.i mgind item 1}.
             run utp/ut-msgs.p (input "show":U, 
                                input 3154, 
                                input return-value).
             apply 'entry' to item.cod-imagem.
             return no-apply.
         end.
         ELSE DO:
            FIND FIRST funcao NO-LOCK
                 WHERE funcao.cd-funcao = "spp-visualiz-pad-datasul":U
                   AND funcao.ativo NO-ERROR.
        
            IF AVAIL funcao THEN DO:
                run btb/btb917zy.p(input string(catal_img.cod_path_catal + "/":U + imagem.img_imagem)).
            END.
            ELSE DO:
                run btb/btb915za.p(input search(trim(catal_img.cod_path_catal) + "/":U + trim(imagem.img_imagem))).
            END.
         END.
      end.
   else do:
           {utp/ut-table.i mgind item 1}.
           run utp/ut-msgs.p (input "show":U, 
                              input 3154, 
                              input return-value).
           apply 'entry' to item.cod-imagem.
           return no-apply.
        end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-campo V-table-Win 
PROCEDURE pi-seta-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure,
                                                 INPUT 'it-codigo').
   assign c-it-codigo = return-value.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-idi-classif-item V-table-Win 
PROCEDURE pi-seta-idi-classif-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-idi-classif-item like item.idi-classif-item.

assign cb-idi-classif-item:SCREEN-VALUE in frame {&frame-name} = string({ininc/i99in172.i 4 p-idi-classif-item}).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-lote-economi V-table-Win 
PROCEDURE pi-seta-lote-economi :
/*------------------------------------------------------------------------------
  Purpose: FO 1839.176    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-lote-economi like item.lote-economi.

assign item.lote-economi:screen-value in frame {&frame-name} = string(p-lote-economi).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-tipo-cont V-table-Win 
PROCEDURE pi-seta-tipo-cont :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-tipo like item.tipo-contr.

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
   
/*** ESTA VALIDAÄ«O ABAIXO PASSOU A SER FEITA PELO TRIGGER DE WRITE DA TABELA ITEM.

******** os erros retornados pelo trigger *******************************
******** est∆o sendo tratados pela viewer principal (v34in172.w) ********

    if  adm-new-record = no 
    and item.it-codigo <> "" 
    and item.tipo-contr <> {ininc/i09in122.i 06 cb-tipo-controle:screen-value) then 
    do with frame {&frame-name}:
       if can-find (first movto-estoq
                    where movto-estoq.it-codigo = item.it-codigo
                    and   movto-estoq.dt-trans > param-estoq.ult-fech-dia) then do:
          /*** Item possui movimentaá∆o de estoque. ***/
          {include/i-vldprg.i} 
          run utp/ut-msgs.p (input "show", input 2227, input "").
          return 'ADM-ERROR':U.
       end.
       else do:
          block:
          for each saldo-estoq no-lock
              where saldo-estoq.it-codigo = item.it-codigo:
              
             if saldo-estoq.qtidade-atu <> 0
             or saldo-estoq.qtidade-ini <> 0 then do:
                assign l-busca = yes.
                leave block.
             end.
          end.    
          
       end.
               
       if not l-busca then
          block2:         
          for each item-estab
              where item-estab.it-codigo = item.it-codigo no-lock:
              
              if  item-estab.sald-ini-mat-m[1] + item-estab.sald-ini-mob-m[1] <> 0
              or (param-estoq.tem-moeda1 
              and item-estab.sald-ini-mat-m[2] + item-estab.sald-ini-mob-m[2] <> 0)
              or (param-estoq.tem-moeda2 
              and item-estab.sald-ini-mat-m[3] + item-estab.sald-ini-mob-m[3] <> 0) then do:
                 assign l-busca = yes.
                 leave block2.
              end.
          end.
       end.
    end. 
***/
    
    RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure,
                                                  INPUT "fm-codigo").
    assign c-fm-codigo = return-value.

    find first folh-fm-it where folh-fm-it.fm-codigo = c-fm-codigo no-lock no-error.
    if available folh-fm-it or input frame {&frame-name} item.cd-folh-item <> '' then do:
       find folh-fm-it where 
            folh-fm-it.fm-codigo = c-fm-codigo and
            folh-fm-it.cd-folha  = input frame {&frame-name} item.cd-folh-item no-lock no-error.
       if not avail folh-fm-it and input frame {&frame-name} item.cd-folh-item <> "" then do:
          {include/i-vldprg.i} 
          /*** folha de especificaá∆o n∆o est† cadastrada para fam°lia deste item ***/
          run utp/ut-msgs.p (input "show", 
                             input 2676, 
                             input "").
          apply 'ENTRY' to item.cd-folh-item in frame {&frame-name}.
          return 'ADM-ERROR':U.
       end.
    end.    

    /*** verifica se a imagem informada Ç valida. ***/
    if item.cod-imagem:screen-value in frame {&frame-name} <> "" then do:
       find imagem 
            where imagem.cod_imagem = item.cod-imagem:screen-value in frame {&frame-name} 
            no-lock no-error.
       if not avail imagem then do:
          {include/i-vldprg.i} 
          /*** imagem procurada n∆o encontrada ***/
          run utp/ut-msgs.p (input "show":U, 
                             input 3154, 
                             input return-value).
          apply 'entry' to item.cod-imagem in frame {&frame-name}.
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
  {src/adm/template/snd-list.i "item"}

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

