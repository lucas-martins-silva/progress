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
{include/i-prgvrs.i V01IN098 2.00.00.022}  /*** 010022 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN098 MUT}
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
{include/i_fnctrad.i}

/* Local Variable Definitions ---                                       */
def var c-un-item    as char no-undo.
def var c-un-produto as char no-undo.
def var c-item       as char no-undo.
def var c-produto    as char no-undo.
def var c-un-p       as char no-undo.
def var c-un-f       as char no-undo.
def var c1-un-p       as char no-undo.
def var c1-un-f       as char no-undo.
define buffer b-est-prod for est-prod.
def var rw-produto as rowid no-undo.
def var rw-est-prod as rowid no-undo.
def var c-it-cod    as char format "x(16)" no-undo.
def var c-liter-produto-item as char no-undo.
def var c-liter-item-produto as char no-undo.
def var l-ok        as logical       no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES est-prod
&Scoped-define FIRST-EXTERNAL-TABLE est-prod


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR est-prod.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS est-prod.qt-aplicada 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}qt-aplicada ~{&FP2}qt-aplicada ~{&FP3}
&Scoped-define ENABLED-TABLES est-prod
&Scoped-define FIRST-ENABLED-TABLE est-prod
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold cb-conversao-un 
&Scoped-Define DISPLAYED-FIELDS produto.cd-produto produto.descricao ~
produto.un est-prod.sequencia est-prod.it-codigo est-prod.modulo-basico ~
est-prod.qt-aplicada est-prod.proporcao 
&Scoped-Define DISPLAYED-OBJECTS c-item-descricao c-item-un cb-conversao-un 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS est-prod.sequencia est-prod.it-codigo 
&Scoped-define ADM-ASSIGN-FIELDS est-prod.proporcao 

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
DEFINE VARIABLE cb-conversao-un AS CHARACTER FORMAT "X(256)":U 
     LABEL "Un Convers∆o" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS " "
     SIZE 12.57 BY 1 NO-UNDO.

DEFINE VARIABLE c-item-descricao AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-un AS CHARACTER FORMAT "X(2)":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 4.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     produto.cd-produto AT ROW 1.25 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     produto.descricao AT ROW 1.25 COL 40 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 36.14 BY .88
     produto.un AT ROW 1.25 COL 77 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     est-prod.sequencia AT ROW 2.17 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     est-prod.it-codigo AT ROW 3.17 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-item-descricao AT ROW 3.17 COL 40 COLON-ALIGNED NO-LABEL
     c-item-un AT ROW 3.17 COL 78.57 COLON-ALIGNED NO-LABEL
     est-prod.modulo-basico AT ROW 4.5 COL 24.14
          VIEW-AS TOGGLE-BOX
          SIZE 19.29 BY .75
     est-prod.qt-aplicada AT ROW 5.25 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     cb-conversao-un AT ROW 6.25 COL 22 COLON-ALIGNED
     est-prod.proporcao AT ROW 7.38 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 4.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.est-prod
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
         HEIGHT             = 7.88
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

/* SETTINGS FOR FILL-IN c-item-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-item-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN produto.cd-produto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN produto.descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN est-prod.it-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR TOGGLE-BOX est-prod.modulo-basico IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN est-prod.proporcao IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN est-prod.sequencia IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN produto.un IN FRAME f-main
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

&Scoped-define SELF-NAME est-prod.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL est-prod.it-codigo V-table-Win
ON ENTRY OF est-prod.it-codigo IN FRAME f-main /* Item */
DO:
  if input frame {&frame-name} est-prod.it-codigo <> "" then do:
     find item where item.it-codigo = input frame {&frame-name} est-prod.it-codigo no-lock no-error.
     assign c-item-descricao:screen-value in frame {&frame-name} = 
            if avail item then item.desc-item else "":U.
  end.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL est-prod.it-codigo V-table-Win
ON F5 OF est-prod.it-codigo IN FRAME f-main /* Item */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z02in172.w
                     &campo=est-prod.it-codigo
                     &campozoom=it-codigo
                     &campo2=c-item-un
                     &campozoom2=un}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL est-prod.it-codigo V-table-Win
ON LEAVE OF est-prod.it-codigo IN FRAME f-main /* Item */
DO:
  {include/leave.i &tabela=item
                   &atributo-ref=desc-item
                   &variavel-ref=c-item-descricao
                   &atributo-ref2=un
                   &variavel-ref2=c-item-un
                   &where="item.it-codigo = input frame {&frame-name} est-prod.it-codigo"}

  if avail item then do:
     find first param-global no-lock no-error.
     if  param-global.modulo-08 then do: 
         find first est-prod use-index onde-se-usa 
              where est-prod.it-codigo = 
                    input frame {&frame-name} est-prod.it-codigo no-lock no-error.
         if avail est-prod then do:
            run utp/ut-msgs.p (input "show",
                               input 15965,
                               input "").
            apply "entry" to est-prod.it-codigo in frame {&frame-name}.
            return no-apply.
         end.
     end.       


     assign c-item-descricao = item.desc-item
            c-item-un        = item.un
            c-un-p           = produto.un + "/" + item.un
            c-un-f           = item.un + "/" + produto.un
            c1-un-p          = produto.un + "/" + item.un
            c1-un-f          = item.un + "/" + produto.un.

     &IF "{&fnc_multi_idioma}":U = "yes":U &THEN do:
         run utp/ut-lstit.p(input-output c1-un-p).
         run utp/ut-lstit.p(input-output c1-un-f).
         assign cb-conversao-un:list-item-pairs = c1-un-p + ',' + c1-un-f.
     end.
     &else
         assign cb-conversao-un:list-items = c-un-p + ',' + c-un-f.
     &endif

     if c-un-p = c-un-f then do:
         assign c-un-p           = c-liter-produto-item
                c-un-f           = c-liter-item-produto
                c1-un-p          = c-liter-produto-item
                c1-un-f          = c-liter-item-produto.
         &IF "{&fnc_multi_idioma}":U = "yes":U &THEN
             run utp/ut-lstit.p(input-output c1-un-p).
             run utp/ut-lstit.p(input-output c1-un-f).
             assign cb-conversao-un:list-item-pairs = c1-un-p + ',' + c1-un-f.
         &else
             assign cb-conversao-un:list-items = c-un-p + ',' + c-un-f.
         &endif
     end.
     else
         &IF "{&fnc_multi_idioma}":U = "yes":U &THEN
             assign cb-conversao-un:list-item-pairs = c1-un-p + ',' + c1-un-f.
         &else
             assign cb-conversao-un:list-items = c-un-p + ',' + c-un-f.
         &endif


     assign cb-conversao-un:screen-value in frame {&frame-name} = c-un-p.   
  end.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL est-prod.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF est-prod.it-codigo IN FRAME f-main /* Item */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME est-prod.modulo-basico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL est-prod.modulo-basico V-table-Win
ON VALUE-CHANGED OF est-prod.modulo-basico IN FRAME f-main /* M¢dulo B†sico */
DO:
  if produto.tipo-produto = 1 then
     if est-prod.modulo-basico:checked in frame {&frame-name} = yes then do:
         assign est-prod.proporcao:screen-value in frame {&frame-name} = "100".
         disable est-prod.proporcao with frame {&frame-name}. 
     end.
     else
         enable est-prod.proporcao with frame {&frame-name}. 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME est-prod.proporcao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL est-prod.proporcao V-table-Win
ON LEAVE OF est-prod.proporcao IN FRAME f-main /* Proporá∆o */
DO:
   find b-est-prod where 
        b-est-prod.cd-produto = est-prod.cd-produto and
        b-est-prod.sequencia  = est-prod.sequencia  and
        b-est-prod.it-codigo  = est-prod.it-codigo no-error.
   if  avail b-est-prod then
       assign est-prod.proporcao = input frame {&frame-name} est-prod.proporcao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME est-prod.qt-aplicada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL est-prod.qt-aplicada V-table-Win
ON LEAVE OF est-prod.qt-aplicada IN FRAME f-main /* Quantidade */
DO:
  /**  
  if  input frame {&frame-name} est-prod.qt-aplicada = 1 then
      assign est-prod.proporcao:screen-value in frame {&frame-name} = string(100)
             est-prod.proporcao:sensitive    in frame {&frame-name} = no.
  else
      assign est-prod.proporcao:sensitive in frame {&frame-name} = yes.
  DEIXADO EM COMENTµRIOS A PEDIDOS DE JOSE CARLOS NUNEZ EM 23/03/99 **/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  if est-prod.it-codigo:load-mouse-pointer ("Image\lupa.cur") in frame {&frame-name} then.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/
  {utp/ut-liter.i Fator * R }
  assign est-prod.qt-aplicada:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Convers∆o}
  assign cb-conversao-un:label = return-value.
  {utp/ut-liter.i Produto/Item}
  assign c-liter-produto-item = return-value.
  {utp/ut-liter.i Item/Produto}
  assign c-liter-item-produto = return-value.

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
  {src/adm/template/row-list.i "est-prod"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "est-prod"}

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

  /*** Atualiza sequencia do componente ***/

  find last param-pm no-lock no-error.
  find last b-est-prod
      where b-est-prod.cd-produto = produto.cd-produto no-lock no-error.
  if  avail b-est-prod then
      disp (b-est-prod.sequencia + param-pm.num-var-recurso) @ est-prod.sequencia 
            with frame {&frame-name}.
  else 
     disp param-pm.num-var-recurso @ est-prod.sequencia
          with frame {&frame-name}.

 /*** Desabilita modulo b†sico quando ja tem um cadastrado ***/

  find first b-est-prod where 
             b-est-prod.cd-produto = produto.cd-produto and 
             b-est-prod.modulo-basico no-lock no-error.
  if available b-est-prod then
      disable est-prod.modulo-basico with frame {&frame-name}.

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
  if not frame {&frame-name}:validate () then
     return 'ADM-ERROR':U.    


  find item where
       item.it-codigo = input frame {&frame-name} est-prod.it-codigo  no-lock no-error.

  /*** Verifica se o item Ç de DD ***/
  if avail item then do:
     if item.tipo-contr = 4 then do:
        run utp/ut-msgs.p (input "show",
                           input 1673,
                           input "").
        apply "entry" to est-prod.it-codigo in frame {&frame-name}.
        return 'ADM-ERROR':U.
     end.
     if item.cod-obsoleto <> 1 then do:
        run utp/ut-msgs.p (input "show",
                           input 1568,
                           input "").
        apply "entry" to est-prod.it-codigo in frame {&frame-name}.
        return 'ADM-ERROR':U.
     end.
  end.

  /*** Se tipo produto for "item" ou "grupo do produto" ent∆o a unidade de me- ***/
  /*** dida do item informado dever† ser igual a unidade de medida do produto  ***/
  /***-------------------------------------------------------------------------***/

  find produto
      where rowid(produto) = rw-produto no-lock no-error.     

  /*if produto.tipo-produto <> 1 then do:
 *      if input frame {&frame-name} c-item-un <> produto.un then do:
 *         {utp/ut-field.i mgind item un 1}
 *         assign c-un-item = trim(return-value).
 *         {utp/ut-table.i mgind item 1}
 *         assign c-un-item = c-un-item + " " + trim(return-value).
 *         {utp/ut-field.i mgind produto un 1}
 *         assign c-un-produto = trim(return-value).
 *         {utp/ut-table.i mgind produto 1}
 *         assign c-un-produto = c-un-produto + " " + trim(return-value).
 *         run utp/ut-msgs.p (input "show",
 *                            input 5955,
 *                            input c-un-item + "~~" + c-un-produto).
 *         apply "entry" to est-prod.it-codigo in frame {&frame-name}.
 *         return 'ADM-ERROR':U.
 *      end.
 *   end.
 *    */      

  /*** Se tipo de produto for "item" ent∆o a estrutura do produto s¢ ***/
  /*** poder† ter um item                                            ***/

  if produto.tipo-produto = 3 and adm-new-record = yes then do:
     find first b-est-prod
          where b-est-prod.cd-produto = produto.cd-produto 
          no-lock no-error.
     if avail b-est-prod then do:
        run utp/ut-msgs.p (input "show",
                           input 5957,
                           input return-value).      
        return 'ADM-ERROR':U.
     end.                            
  end.                        

  /*** Quando m¢dulo b†sico igual a "sim", o item s¢ pode pertencer a ***/
  /*** estrutura de um £nico produto                                  ***/

  find first b-est-prod 
       where b-est-prod.it-codigo  =  item.it-codigo 
       and   b-est-prod.cd-produto <> produto.cd-produto
       no-lock no-error.
  if avail b-est-prod then do:
     if b-est-prod.modulo-basico = yes then do:
        run utp/ut-msgs.p (input "show",
                           input 6034,
                           input item.it-codigo + "~~" + produto.cd-produto).
        apply "entry" to est-prod.it-codigo in frame {&frame-name}.
        return 'ADM-ERROR':U.
     end.
     else do:
        if est-prod.modulo-basico:checked in frame {&frame-name} = yes then do:
           run utp/ut-msgs.p  (input "show",
                               input 6037,
                               input item.it-codigo + "~~" + produto.cd-produto).
           apply "entry" to est-prod.it-codigo in frame {&frame-name}.
           return 'ADM-ERROR':U.
        end.
     end.
  end.

  /*** um item n∆o pode estar cadastrado duas vezes  ***/
  /*** se ele for tipo de produto "grupo de produto ou item" ***/

  find first b-est-prod 
       where b-est-prod.it-codigo  = item.it-codigo 
       no-lock no-error.
  if avail b-est-prod and 
     est-prod.it-codigo:sensitive in frame {&frame-name} = yes then do:
     if input frame {&frame-name} est-prod.it-codigo = b-est-prod.it-codigo and
        produto.tipo-produto = 2 or produto.tipo-produto = 3 then do:
        {utp/ut-table.i mgind produto 01}
        assign c-produto = trim(return-value).
        {utp/ut-table.i mgind item 01}
        assign c-item = trim(return-value).
        run utp/ut-msgs.p (input "show",
                           input 6541,
                           input c-item    + ' ' + item.it-codigo      + '~~' +
                                 c-produto + ' ' + b-est-prod.cd-produto + '~~' +
                                 c-produto).
        apply 'entry' to est-prod.it-codigo in frame {&frame-name}.                   
        return 'adm-error':U.
     end.
  end. 
  if input frame {&frame-name} est-prod.qt-aplicada = 0 then do:
      run utp/ut-msgs.p (input "show",
                         input 6722,
                         input "").
      apply "entry" to est-prod.qt-aplicada in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  if RETURN-VALUE = 'ADM-ERROR':U then do:
     return 'ADM-ERROR':U.
  end.

  if cb-conversao-un:screen-value = c-un-f then
      assign est-prod.log-1 = yes. 
  else
      assign est-prod.log-1 = no
             est-prod.qt-aplicada = 1 / est-prod.qt-aplicada.

  do on error undo, leave:
     validate est-prod.
  end.  
  if return-value = 'refe' then do:
     {utp/ut-table.i mgind ref-item 1}
     run utp/ut-msgs.p (input "show",
                        input 5823,
                        input return-value + '~~' + est-prod.it-codigo).
     apply 'entry' to est-prod.it-codigo in frame {&frame-name}.                   
     return 'adm-error':U.
  end.

  assign est-prod.modulo-basico = input frame {&frame-name} est-prod.modulo-basico.

  find item-cota 
    where item-cota.it-codigo = est-prod.it-codigo exclusive-lock no-error.
  if avail item-cota then
      assign item-cota.log-produto = yes.

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
  find produto where rowid(produto) = rw-produto no-lock no-error.
  if avail produto then do:
     assign est-prod.cd-produto = produto.cd-produto.
  end.   

  /*Alterado devido a Fo. 1490.700*/
  if est-prod.modulo-basico:checked in frame {&frame-name} = yes then 
      ASSIGN est-prod.modulo-basico = YES.
  ELSE ASSIGN est-prod.modulo-basico = NO.

  IF cb-conversao-un:screen-value = c-un-p THEN
      ASSIGN est-prod.log-1 = no.
  ELSE IF cb-conversao-un:screen-value = c-un-f THEN
      ASSIGN est-prod.log-1 = YES.
  
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
     if  available est-prod then do:
         find item where item.it-codigo = est-prod.it-codigo no-lock no-error.
         assign c-item-descricao = if avail item then item.desc-item else "":U
                c-item-un        = if avail item then item.un        else "":U.
     end.

  /* Dispatch standard ADM method.                             */

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ).
  /* Code placed here will execute AFTER standard behavior.    */
  find produto where rowid(produto) = rw-produto no-lock no-error.

  if  produto.tipo-produto <> 1 then
      assign est-prod.modulo-basico:sensitive in frame {&frame-name} = no. 

  /**
  if  avail est-prod and est-prod.qt-aplicada = 1 then
      assign est-prod.proporcao:screen-value in frame {&frame-name} = "100"
             est-prod.proporcao:sensitive    in frame {&frame-name} = no.
  else
      assign est-prod.proporcao:sensitive in frame {&frame-name} = yes.
  DEIXADO EM COMENTµRIO A PEDIDO DE JOSE CARLOS NUNEZ EM 23/03/99 **/


  /*** Desabilita dados para o caso de produto tipo item ***/ 
  do with frame {&frame-name}:
      if produto.tipo-produto = 3 then
         assign est-prod.qt-aplicada:sensitive = NO
                est-prod.proporcao:sensitive   = no.
      else assign est-prod.proporcao:sensitive = yes
                  est-prod.qt-aplicada:sensitive = YES .

      /*** Desabilita dados para o caso de produto tipo grupo de produtos ***/ 
      /*if produto.tipo-produto = 2 then 
         assign est-prod.qt-aplicada:sensitive = no .
      ELSE
         est-prod.qt-aplicada:sensitive = YES.*/

      /*** Desabilita modulo b†sico quando ja tem um cadastrado ***/
      find first b-est-prod where 
                 b-est-prod.cd-produto = produto.cd-produto and 
                 b-est-prod.modulo-basico no-lock no-error.
      if available b-est-prod then
          assign est-prod.modulo-basico:sensitive = no.

      if available est-prod and rowid(b-est-prod) = rowid(est-prod) then
          assign est-prod.modulo-basico:sensitive = yes.
  end.

  /*Alterado devido a Fo. 1490.700*/
  IF AVAIL est-prod AND est-prod.modulo-basico THEN
      ASSIGN  est-prod.proporcao:SENSITIVE = NO.

  if available est-prod then do:
     find item where item.it-codigo = est-prod.it-codigo no-lock no-error.
     if avail item then do with frame {&frame-name}:

        if  produto.un = item.un then
            assign c-un-p = c-liter-produto-item
                   c-un-f = c-liter-item-produto
                   c1-un-p = c-liter-produto-item
                   c1-un-f = c-liter-item-produto.
        else  
            assign c-un-p = produto.un + "/" + item.un
                   c-un-f = item.un + "/" + produto.un
                   c1-un-p = produto.un + "/" + item.un
                   c1-un-f = item.un + "/" + produto.un.

        &IF "{&fnc_multi_idioma}":U = "yes":U &THEN do:
            run utp/ut-lstit.p(input-output c1-un-p).
            run utp/ut-lstit.p(input-output c1-un-f).
            assign cb-conversao-un:list-item-pairs = c1-un-p + ',' + c1-un-f.
        end.
        &else
            assign cb-conversao-un:list-items = c-un-p + ',' + c-un-f.
        &endif

        if est-prod.log-1 = no then 
            assign cb-conversao-un:screen-value      = c-un-p
                   est-prod.qt-aplicada:screen-value = 
                                        string(1 / est-prod.qt-aplicada).
        else
            assign cb-conversao-un:screen-value = c-un-f.        
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
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

/*  find produto where rowid(produto) = v-row-parent no-lock no-error.
 * 
 *   assign est-prod.modulo-basico:sensitive in frame {&frame-name} = (produto.tipo-produto = 1).
 * 
 *    /*** Desabilita dados para o caso de produto tipo item ***/ 
 *   do with frame {&frame-name}:
 *       if produto.tipo-produto = 3 then
 *          assign est-prod.qt-aplicada:sensitive = no 
 *                 est-prod.proporcao:sensitive   = no.
 *                  
 *       /*** Desabilita dados para o caso de produto tipo grupo de produtos ***/ 
 *       if produto.tipo-produto = 2 then 
 *          assign est-prod.qt-aplicada:sensitive = no .
 *     
 *       /*** Desabilita modulo b†sico quando ja tem um cadastrado ***/
 *       find first b-est-prod where 
 *                  b-est-prod.cd-produto = produto.cd-produto and 
 *                  b-est-prod.modulo-basico no-lock no-error.
 *       if available b-est-prod then
 *           assign est-prod.modulo-basico:sensitive = no.
 *     
 *       if available est-prod and rowid(b-est-prod) = rowid(est-prod) then
 *           assign est-prod.modulo-basico:sensitive = yes.
 *  end.*/

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

  find produto where rowid(produto) = v-row-parent no-lock no-error.
  assign rw-produto = v-row-parent.

  if  avail produto and produto.tipo-produto = 1 then
      assign est-prod.modulo-basico:sensitive in frame {&frame-name} = yes.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ).


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

   /*Segue um exemplo de validaá∆o de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/

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
  {src/adm/template/snd-list.i "est-prod"}

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


