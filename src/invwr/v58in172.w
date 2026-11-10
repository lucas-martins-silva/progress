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
{include/i-prgvrs.i V58IN172 2.00.00.014}  /*** 010014 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V58IN172 MUT}
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item.curva-abc item.quant-segur ~
item.quant-perda item.tempo-segur item.lote-economi item.lote-minimo ~
item.lote-multipl item.fator-refugo 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}curva-abc ~{&FP2}curva-abc ~{&FP3}~
 ~{&FP1}quant-segur ~{&FP2}quant-segur ~{&FP3}~
 ~{&FP1}quant-perda ~{&FP2}quant-perda ~{&FP3}~
 ~{&FP1}tempo-segur ~{&FP2}tempo-segur ~{&FP3}~
 ~{&FP1}lote-economi ~{&FP2}lote-economi ~{&FP3}~
 ~{&FP1}lote-minimo ~{&FP2}lote-minimo ~{&FP3}~
 ~{&FP1}lote-multipl ~{&FP2}lote-multipl ~{&FP3}~
 ~{&FP1}fator-refugo ~{&FP2}fator-refugo ~{&FP3}
&Scoped-define ENABLED-TABLES item
&Scoped-define FIRST-ENABLED-TABLE item
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS item.curva-abc item.quant-segur ~
item.quant-perda item.tempo-segur item.lote-economi item.lote-minimo ~
item.lote-multipl item.fator-refugo 
&Scoped-Define DISPLAYED-OBJECTS cb-classificacao-abc cb-tp-ressup ~
da-data-ult-ressup cb-emissao-ordens cb-tipo-lote-economico cb-politica ~
cb-tipo-demanda de-lote-per-max i-cd-freq c-desc-freq 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS cb-classificacao-abc cb-emissao-ordens ~
cb-tipo-lote-economico cb-politica cb-tipo-demanda 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS></FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = ':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE cb-classificacao-abc AS CHARACTER FORMAT "X(8)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE cb-emissao-ordens AS CHARACTER FORMAT "X(15)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE cb-politica AS CHARACTER FORMAT "X(19)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 19 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-demanda AS CHARACTER FORMAT "X(17)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-lote-economico AS CHARACTER FORMAT "X(15)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tp-ressup AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS " "
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-freq AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35.57 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-ult-ressup AS DATE FORMAT "99/99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-lote-per-max AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE i-cd-freq AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 4.86 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 9.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item.curva-abc AT ROW 1.17 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     item.quant-segur AT ROW 1.17 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     cb-classificacao-abc AT ROW 2.17 COL 21 COLON-ALIGNED
     item.quant-perda AT ROW 2.17 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     cb-tp-ressup AT ROW 3.17 COL 21 COLON-ALIGNED
     da-data-ult-ressup AT ROW 3.17 COL 64 COLON-ALIGNED
     cb-emissao-ordens AT ROW 4.17 COL 21 COLON-ALIGNED
     item.tempo-segur AT ROW 4.17 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     cb-tipo-lote-economico AT ROW 5.17 COL 21 COLON-ALIGNED
     item.lote-economi AT ROW 5.17 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     cb-politica AT ROW 6.17 COL 21 COLON-ALIGNED
     item.lote-minimo AT ROW 6.17 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     cb-tipo-demanda AT ROW 7.17 COL 21 COLON-ALIGNED
     item.lote-multipl AT ROW 7.17 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     item.fator-refugo AT ROW 8.17 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     de-lote-per-max AT ROW 8.17 COL 64 COLON-ALIGNED
     i-cd-freq AT ROW 9.17 COL 21 COLON-ALIGNED
     c-desc-freq AT ROW 9.17 COL 26.29 COLON-ALIGNED NO-LABEL
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 9.25
         WIDTH              = 85.86.
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

/* SETTINGS FOR FILL-IN c-desc-freq IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-classificacao-abc IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX cb-emissao-ordens IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX cb-politica IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX cb-tipo-demanda IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX cb-tipo-lote-economico IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX cb-tp-ressup IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN da-data-ult-ressup IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-lote-per-max IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-cd-freq IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME cb-tp-ressup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tp-ressup V-table-Win
ON VALUE-CHANGED OF cb-tp-ressup IN FRAME f-main
DO:
   if input frame {&frame-name} cb-tp-ressup <> {ininc/i01in598.i 04 3} then do:
       assign i-cd-freq:screen-value in frame {&frame-name}          = "0"
              de-lote-per-max:screen-value in frame {&frame-name}    = "0"
              da-data-ult-ressup:screen-value in frame {&frame-name} = "01/01/0001".
       disable i-cd-freq 
               da-data-ult-ressup
               de-lote-per-max
               with frame {&frame-name}.
   end.
   else
       enable  i-cd-freq 
               da-data-ult-ressup
               de-lote-per-max
               with frame {&frame-name}. 
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cd-freq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-freq V-table-Win
ON F5 OF i-cd-freq IN FRAME f-main
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z01ad122.w
                     &campo=i-cd-freq
                     &campozoom=cd-freq}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-freq V-table-Win
ON LEAVE OF i-cd-freq IN FRAME f-main
DO:
  {include/leave.i &tabela=frequencia
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-freq
                   &where="frequencia.cd-freq = input frame {&frame-name}
                           i-cd-freq"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-freq V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cd-freq IN FRAME f-main
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.lote-economi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.lote-economi V-table-Win
ON LEAVE OF item.lote-economi IN FRAME f-main /* Lote Econìmico */
DO:
  
/*RUN Get-Field-Screen-Value IN adm-broker-hdl
 *    (INPUT this-procedure,
 *     INPUT "fraciona") .
 *           
 * if (return-value = "N∆o") and 
 *     input frame {&frame-name} item.lote-economi -
 *     int(input frame {&frame-name} item.lote-economi) <> 0  
 *      then do:
 *        run utp/ut-msgs.p (input "show",
 *                           input 847,  /* Quantidade fracionada */
 *                           input return-value).
 *        apply "entry" to item.lote-economi in frame {&frame-name}.
 *        return no-apply.
 *      end.*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.lote-minimo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.lote-minimo V-table-Win
ON LEAVE OF item.lote-minimo IN FRAME f-main /* Lote M°nimo */
DO:
  

/*RUN Get-Field-Screen-Value IN adm-broker-hdl
 *     (INPUT this-procedure,
 *      INPUT "fraciona") .
 *           
 * if (return-value = "N∆o") and 
 *     input frame {&frame-name} item.lote-minimo -
 *     int(input frame {&frame-name} item.lote-minimo) <> 0  
 *      then do:
 *        run utp/ut-msgs.p (input "show",
 *                           input 847,  /* Quantidade fracionada */
 *                           input return-value).
 *        apply "entry" to item.lote-minimo in frame {&frame-name}.
 *        return no-apply.
 *      end.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.lote-multipl
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.lote-multipl V-table-Win
ON LEAVE OF item.lote-multipl IN FRAME f-main /* Lote M£ltiplo */
DO:
/*    if  item.fraciona = no
 *   and item.lote-multipl <> int(item.lote-multipl) then do:
 *       {include/i-vldprg.i}
 *       run utp/ut-msgs.p (input "show":U, input 1000, input "").
 *       apply 'entry' to item.lote-multipl in frame {&frame-name}.
 *       return 'ADM-ERROR':U.
 *   end.*/


/*RUN Get-Field-Screen-Value IN adm-broker-hdl
 *     (INPUT this-procedure,
 *      INPUT "fraciona") .
 *           
 * if (return-value = "N∆o") and 
 *     input frame {&frame-name} item.lote-multipl -
 *     int(input frame {&frame-name} item.lote-multipl) <> 0  
 *      then do:
 *        run utp/ut-msgs.p (input "show",
 *                           input 847,  /* Quantidade fracionada */
 *                           input return-value).
 *        apply "entry" to item.lote-multipl in frame {&frame-name}.
 *        return no-apply.
 *      end.*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.quant-perda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.quant-perda V-table-Win
ON LEAVE OF item.quant-perda IN FRAME f-main /* Qtde Perda */
DO:
  
/*    if  item.fraciona = no
 *   and item.quant-perd <> int(item.quant-perda) then do:
 *       {include/i-vldprg.i}
 *       run utp/ut-msgs.p (input "show":U, input 1304, input "").
 *       apply 'entry' to item.quant-perd in frame {&frame-name}.
 *       return 'ADM-ERROR':U.
 *   end.*/

/*RUN Get-Field-Screen-Value IN adm-broker-hdl
 *     (INPUT this-procedure,
 *      INPUT "fraciona") .
 *           
 * if (return-value = "N∆o") and 
 *     input frame {&frame-name} item.quant-perd -
 *     int(input frame {&frame-name} item.quant-perd) <> 0  
 *      then do:
 *        run utp/ut-msgs.p (input "show",
 *                           input 847,  /* Quantidade fracionada */
 *                           input return-value).
 *        apply "entry" to item.quant-perd in frame {&frame-name}.
 *        return no-apply.
 *      end.*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.quant-segur
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.quant-segur V-table-Win
ON LEAVE OF item.quant-segur IN FRAME f-main /* Qtde Segur */
DO:
  
  /*RUN Get-Field-Screen-Value IN adm-broker-hdl
 *     (INPUT this-procedure,
 *      INPUT "fraciona") .
 *           
 * if (return-value = "N∆o") and 
 *     input frame {&frame-name} item.quant-segur -
 *     int(input frame {&frame-name} item.quant-segur) <> 0  
 *      then do:
 *        run utp/ut-msgs.p (input "show",
 *                           input 847,  /* Quantidade fracionada */
 *                           input return-value).
 *        apply "entry" to item.quant-segur in frame {&frame-name}.
 *        return no-apply.
 *      end.*/


/*    if  item.fraciona = no
 *   and item.quant-segur <> int(item.quant-segur) then do:
 *       {include/i-vldprg.i}
 *       run utp/ut-msgs.p (input "show":U, input 1304, input "").
 *       apply 'entry' to item.quant-segur in frame {&frame-name}.
 *       return 'ADM-ERROR':U.
 *   end.
 * */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  if i-cd-freq:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
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
  
  /* Code placed here will execute PRIOR to standard behavior. 
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.*/
    {include/i-valid.i} 
  /* Ponha aqui a validaá∆o de chave duplicada */
  /* Ponha aqui as demais validaá‰es */
  
  /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if  RETURN-VALUE = 'ADM-ERROR':U then 
      RETURN 'ADM-ERROR':U.
  find current item-mat exclusive-lock.
  /* Code placed here will execute AFTER standard behavior.    */
  assign input frame {&frame-name} cb-tp-ressup
         item-mat.tp-ressup = {ininc/i01in598.i 06 cb-tp-ressup}.
  assign input frame {&frame-name} cb-classificacao-abc 
         item.classif-abc = {ininc/i03in172.i 06 cb-classificacao-abc}.
  assign input frame {&frame-name} cb-emissao-ordens 
         item.emissao-ord = {ininc/i03in122.i 06 cb-emissao-ordens}.
  assign input frame {&frame-name} cb-tipo-lote-economico 
         item.tipo-lote-ec = {ininc/i04in172.i 06 cb-tipo-lote-economico}.
  assign input frame {&frame-name} cb-politica 
         item.politica = {ininc/i04in122.i 06 cb-politica}.
  assign input frame {&frame-name} cb-tipo-demanda 
         item.demanda = {ininc/i02in122.i 06 cb-tipo-demanda}.
  assign input frame {&frame-name} i-cd-freq
         item-mat.cd-freq = i-cd-freq
         input frame {&frame-name} da-data-ult-ressup
         item-mat.data-ult-ressup = da-data-ult-ressup
         input frame {&frame-name} de-lote-per-max
         item-mat.lote-per-max = de-lote-per-max.

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
  disable cb-tp-ressup 
          i-cd-freq
          da-data-ult-ressup
          de-lote-per-max
          with frame {&frame-name}.
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
  do  with frame {&frame-name}:
      if  avail item then do:
          assign cb-classificacao-abc:screen-value   = {ininc/i03in172.i 04 item.classif-abc}
                 cb-emissao-ordens:screen-value      = {ininc/i03in122.i 04 item.emissao-ord}
                 cb-tipo-lote-economico:screen-value = {ininc/i04in172.i 04 item.tipo-lote-ec}
                 cb-politica:screen-value            = {ininc/i04in122.i 04 item.politica}
                 cb-tipo-demanda:screen-value        = {ininc/i02in122.i 04 item.demanda}.
          {cep/ce0106.i item-mat item}
          assign cb-tp-ressup:screen-value        = {ininc/i01in598.i 04 item-mat.tp-ressup}
                 i-cd-freq:screen-value           = string(item-mat.cd-freq)
                 da-data-ult-ressup:screen-value  = string(item-mat.data-ult-ressup)
                 de-lote-per-max:screen-value     = string(item-mat.lote-per-max).
      end.
      else
          assign cb-classificacao-abc:screen-value   = {ininc/i03in172.i 04 1}
                 cb-emissao-ordens:screen-value      = {ininc/i03in122.i 04 1}
                 cb-tipo-lote-economico:screen-value = {ininc/i04in172.i 04 1}
                 cb-politica:screen-value            = {ininc/i04in122.i 04 1}
                 cb-tipo-demanda:screen-value        = {ininc/i02in122.i 04 1}
                 cb-tp-ressup:screen-value           = {ininc/i01in598.i 04 1}
                 da-data-ult-ressup:screen-value     = "01/01/0001"
                 de-lote-per-max:screen-value        = "1"
                 i-cd-freq:screen-value              = "0".
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
  enable cb-tp-ressup 
         with frame {&frame-name}.
  if avail item then do:
      {cep/ce0106.i item-mat item}
      if item-mat.tp-ressup <> 3 then
          disable i-cd-freq
                  da-data-ult-ressup
                  de-lote-per-max
                  with frame {&frame-name}.
      else 
          enable i-cd-freq
                 da-data-ult-ressup
                 de-lote-per-max
                 with frame {&frame-name}.
  end.
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
  do  with frame {&frame-name}:

      {utp/ut-field.i mgind item-mat cd-freq 1}
      assign i-cd-freq:label in frame {&frame-name} = return-value.
      {utp/ut-field.i mgind item-mat data-ult-ressup 1}
      assign da-data-ult-ressup:label in frame {&frame-name} = return-value.
      {utp/ut-field.i mgind item-mat lote-per-max 1}
      assign de-lote-per-max:label in frame {&frame-name} = return-value.
      {utp/ut-field.i mgind item-mat-estab tp-ressup 1}
      assign cb-tp-ressup:label in frame {&frame-name} = trim(return-value).
      {utp/ut-field.i mgind item classif-abc 1}
      assign cb-classificacao-abc:label = trim(return-value).
      {utp/ut-field.i mgind item emissao-ord 1}
      assign cb-emissao-ordens:label = trim(return-value).
      {utp/ut-field.i mgind item tipo-lote-ec 1}
      assign cb-tipo-lote-economico:label = trim(return-value).
      {utp/ut-field.i mgind item politica 1}
      assign cb-politica:label = trim(return-value).
      {utp/ut-field.i mgind item demanda 1}
      assign cb-tipo-demanda:label = trim(return-value).

      assign cb-classificacao-abc:list-items   = {ininc/i03in172.i 03}
             cb-emissao-ordens:list-items      = {ininc/i03in122.i 03}
             cb-tipo-lote-economico:list-items = {ininc/i04in172.i 03}
             cb-politica:list-items            = {ininc/i04in122.i 03}
             cb-tipo-demanda:list-items        = {ininc/i02in122.i 03}             
             cb-tp-ressup:list-items           = {ininc/i01in598.i 03}.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
   

RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "fraciona") .
     
              
if (return-value = "N∆o") and 
     input frame {&frame-name} item.lote-minimo -
     int(input frame {&frame-name} item.lote-minimo) <> 0  
      then do:
         {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",
                            input 847,  /* Quantidade fracionada */
                            input return-value).
         apply "entry" to item.lote-minimo in frame {&frame-name}.
        return 'ADM-ERROR':U.
       end.

RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "fraciona") .
          
if (return-value = "N∆o") and 
    input frame {&frame-name} item.quant-segur -
    int(input frame {&frame-name} item.quant-segur) <> 0  
     then do:
        {include/i-vldprg.i}

       run utp/ut-msgs.p (input "show",
                          input 847,  /* Quantidade fracionada */
                          input return-value).
       apply "entry" to item.quant-segur in frame {&frame-name}.
/*       return no-apply.*/
       return 'ADM-ERROR':U.
     end.

RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "fraciona") .

          
if (return-value = "N∆o") and 
    input frame {&frame-name} item.quant-perda -
    int(input frame {&frame-name} item.quant-perda) <> 0  
     then do:
        {include/i-vldprg.i}

       run utp/ut-msgs.p (input "show",
                          input 847,  /* Quantidade fracionada */
                          input return-value).
       apply "entry" to item.quant-perda in frame {&frame-name}.
       return 'ADM-ERROR':U.
     end.

RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "fraciona") .

          
if (return-value = "N∆o") and 
    input frame {&frame-name} item.lote-economi -
    int(input frame {&frame-name} item.lote-economi) <> 0  
     then do:
        {include/i-vldprg.i}

       run utp/ut-msgs.p (input "show",
                          input 847,  /* Quantidade fracionada */
                          input return-value).
       apply "entry" to item.lote-economi in frame {&frame-name}.
     return 'ADM-ERROR':U.
     end.

RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "fraciona") .
         
if (return-value = "N∆o") and 
    input frame {&frame-name} item.lote-multipl -
    int(input frame {&frame-name} item.lote-multipl) <> 0  
     then do:

        {include/i-vldprg.i}
       run utp/ut-msgs.p (input "show",
                          input 847,  /* Quantidade fracionada */
                          input return-value).
       apply "entry" to item.lote-multipl in frame {&frame-name}.
       return 'ADM-ERROR':U.
     end.

if not can-find (frequencia where
     frequencia.cd-freq = input frame {&frame-name} i-cd-freq) and
     i-cd-freq:sensitive in frame {&frame-name} then do:
      {include/i-vldprg.i}
      {utp/ut-table.i mgadm frequencia 1}
      run utp/ut-msgs.p (input "show":U, input 56, input return-value).
      apply "entry" to i-cd-freq in frame {&frame-name}.
      return 'ADM-ERROR':U.
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


