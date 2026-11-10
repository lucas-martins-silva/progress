&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          mgmfg            PROGRESS
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
{include/i-prgvrs.i V01IN482 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN482 MUT}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

&Scop adm-attribute-dlg support/viewerd.w

{include/i-vrtab.i item-controle}

def var v-row-parent as rowid no-undo.

def buffer b-item-controle for item-controle.

{cdp/cdcfgman.i}

DEFINE VARIABLE l-modificando AS LOGICAL INIT NO NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES item-controle
&Scoped-define FIRST-EXTERNAL-TABLE item-controle


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item-controle.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item-controle.des-ic ~
item-controle.abreviatura item-controle.formato item-controle.nr-tabela 
&Scoped-define ENABLED-TABLES item-controle
&Scoped-define FIRST-ENABLED-TABLE item-controle
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS item-controle.cod-ic item-controle.des-ic ~
item-controle.abreviatura item-controle.formato item-controle.nr-tabela 
&Scoped-define DISPLAYED-TABLES item-controle
&Scoped-define FIRST-DISPLAYED-TABLE item-controle
&Scoped-Define DISPLAYED-OBJECTS cb-tip-result c-des-tabela 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS item-controle.cod-ic cb-tip-result 
&Scoped-define ADM-ASSIGN-FIELDS cb-tip-result 
&Scoped-define ADM-MODIFY-FIELDS cb-tip-result 

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
DEFINE VARIABLE cb-tip-result AS CHARACTER FORMAT "X(15)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-des-tabela AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 35.29 BY .88 NO-UNDO.

DEFINE VARIABLE i-teste AS DECIMAL FORMAT "->>>>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 4.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item-controle.cod-ic AT ROW 1.17 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     item-controle.des-ic AT ROW 2.17 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.14 BY .88
     item-controle.abreviatura AT ROW 3.67 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     cb-tip-result AT ROW 4.67 COL 25 COLON-ALIGNED
     item-controle.formato AT ROW 5.79 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 31.14 BY .88
     i-teste AT ROW 5.79 COL 56.57 COLON-ALIGNED NO-LABEL
     item-controle.nr-tabela AT ROW 6.75 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     c-des-tabela AT ROW 6.75 COL 32.29 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 3.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: Mgind.item-controle
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
         HEIGHT             = 6.92
         WIDTH              = 88.57.
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

/* SETTINGS FOR FILL-IN c-des-tabela IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-tip-result IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN item-controle.cod-ic IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN i-teste IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       i-teste:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME cb-tip-result
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tip-result V-table-Win
ON VALUE-CHANGED OF cb-tip-result IN FRAME f-main
DO:

    /*Num‚rico*/
    if  input frame {&frame-name} cb-tip-result = {ininc/i01in482.i 04 1} then do:
        enable item-controle.formato with frame {&frame-name}.
        disable item-controle.nr-tabela with frame {&frame-name}.
        if  adm-new-record OR l-modificando then
            assign item-controle.formato:screen-value in frame {&frame-name} = "->>>>>>,>>9.9999":U.
    end.
    
    /*Tabela*/
    if  input frame {&frame-name} cb-tip-result = {ininc/i01in482.i 04 2} then do:
        disable item-controle.formato with frame {&frame-name}.
        enable item-controle.nr-tabela with frame {&frame-name}.
        if  adm-new-record OR l-modificando then
            assign item-controle.formato:screen-value in frame {&frame-name} = "":U.
    end.
    ELSE
        IF adm-new-record OR l-modificando THEN
            ASSIGN item-controle.nr-tabela:SCREEN-VALUE IN FRAME f-main = "":U
                   c-des-tabela:SCREEN-VALUE            IN FRAME f-main = "":U.

    /*Observa‡Æo*/
    if  input frame {&frame-name} cb-tip-result = {ininc/i01in482.i 04 3} then do:
        enable item-controle.formato with frame {&frame-name}.
        disable item-controle.nr-tabela with frame {&frame-name}.
        if  adm-new-record OR l-modificando then
            assign item-controle.formato:screen-value in frame {&frame-name} = "x(40)":U.
    end.
    
    /*Data*/
    if  input frame {&frame-name} cb-tip-result = {ininc/i01in482.i 04 4} then do:
        disable item-controle.formato 
                item-controle.nr-tabela
                with frame {&frame-name}.
        if  adm-new-record OR l-modificando then
            assign item-controle.formato:screen-value in frame {&frame-name} = "99/99/9999":U.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-controle.nr-tabela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-controle.nr-tabela V-table-Win
ON F5 OF item-controle.nr-tabela IN FRAME f-main /* Tabela */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in418.w"
                     &campo=item-controle.nr-tabela
                     &campozoom=nr-tabela
                     &campo2=c-des-tabela  
                     &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-controle.nr-tabela V-table-Win
ON LEAVE OF item-controle.nr-tabela IN FRAME f-main /* Tabela */
DO:
  {include/leave.i &tabela=tabela-res 
                   &atributo-ref=descricao
                   &variavel-ref=c-des-tabela
                   &where="tabela-res.nr-tabela = input frame {&frame-name} item-controle.nr-tabela"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-controle.nr-tabela V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-controle.nr-tabela IN FRAME f-main /* Tabela */
DO:
  apply 'F5' to self. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

item-controle.nr-tabela:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name}.

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
  {src/adm/template/row-list.i "item-controle"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item-controle"}

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

  apply 'value-changed' to cb-tip-result in frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE i-tamanho AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-inicio  AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-cont    AS INTEGER    NO-UNDO.
DEFINE VARIABLE c-aux     AS CHARACTER  NO-UNDO.

    /* Code placed here will execute PRIOR to standard behavior. */
    if  not frame {&frame-name}:validate() then
        return 'ADM-ERROR':U.

    if can-find(first b-item-controle where b-item-controle.cod-ic = input frame {&frame-name} item-controle.cod-ic)
       and adm-new-record = yes  then do:
        {utp/ut-table.i mgind item-controle 01}        
        run utp/ut-msgs.p (input 'show',
                           input 8,
                           input return-value).
        apply 'entry' to item-controle.cod-ic in frame {&frame-name}.
        return 'ADM-ERROR'.
    end.        

    
    if  input frame {&frame-name} cb-tip-result = {ininc/i01in482.i 04 2} then do:
        find first tabela-res
            where tabela-res.nr-tabela = input frame {&frame-name} item-controle.nr-tabela
            no-lock no-error.
        if  not avail tabela-res then do:
            {utp/ut-liter.i Tabela_de_Resultados *}
            run utp/ut-msgs.p (input "show":U, 
                               input 47, 
                               input return-value).
            apply 'entry' to item-controle.nr-tabela in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
    end.
    
    if  input frame {&frame-name} cb-tip-result = {ininc/i01in482.i 04 1} then do:

        assign i-teste:format in frame {&frame-name} = input frame {&frame-name} item-controle.formato no-error.

        if  i-teste:format in frame {&frame-name} <> input frame {&frame-name} item-controle.formato then do:
            run utp/ut-msgs.p (input "show":U, 
                               input 30822, 
                               input return-value).
            apply 'entry' to item-controle.formato in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
    end.

    /** Quado for observa‡Æo, deve-se verificar o valor limite para cadastrar o formato da observa‡Æo **/
    if  input frame {&frame-name} cb-tip-result = {ininc/i01in482.i 04 3} then do:
        
        if substring(input frame {&frame-name} item-controle.formato,1,2) = "x(":U    then do:
            assign i-tamanho = length(input frame {&frame-name} item-controle.formato)
                   i-inicio  = i-tamanho
                   i-inicio  = i-inicio - 3.
            do i-cont = 3 to (i-tamanho - 1):
                if substring(input frame {&frame-name} item-controle.formato,i-cont,i-inicio) > "9":U then do:
                    run utp/ut-msgs.p (input "show":U, 
                                       input &if defined(bf_man_205) &then 28353 
                                             &else 28354 &endif, 
                                       input input frame {&frame-name} item-controle.formato).
                    apply 'entry' to item-controle.formato in frame {&frame-name}.
                    return 'ADM-ERROR':U.     
                end.
            end.
            if (int(substring(input frame {&frame-name} item-controle.formato,3,i-inicio)) > &if defined(bf_man_205) 
                                                                                              &then 300 
                                                                                              &else 60 &endif or 
                input frame {&frame-name} item-controle.formato                < "x(1)":U)                    or
                substring(input frame {&frame-name} item-controle.formato,i-tamanho,1) <> ")":U               then do:
                run utp/ut-msgs.p (input "show":U, 
                                   input &if defined(bf_man_205) &then 28353 
                                         &else 28354 &endif, 
                                   input input frame {&frame-name} item-controle.formato).
                apply 'entry' to item-controle.formato in frame {&frame-name}.
                return 'ADM-ERROR':U.
            end.
        end.
        ELSE DO:
            if input frame {&frame-name} item-controle.formato = "":U then do:
                run utp/ut-msgs.p (input "show":U, 
                                   input &if defined(bf_man_205) &then 28353 
                                         &else 28354 &endif, 
                                   input input frame {&frame-name} item-controle.formato).
                apply 'entry' to item-controle.formato in frame {&frame-name}.
                return 'ADM-ERROR':U.            
            end.
            ELSE
                DO i-cont = 1 TO LENGTH(input frame {&frame-name} item-controle.formato):
    
                    ASSIGN c-aux = SUBSTRING(input frame {&frame-name} item-controle.formato,i-cont,1).
    
                    IF c-aux <> "":U  AND
                       c-aux <> "X":U AND
                       c-aux <> "A":U AND
                       c-aux <> "-":U AND
                       c-aux <> "(":U AND
                       c-aux <> ")":U AND
                       c-aux <> "!":U AND
                       c-aux <> "0":U AND 
                       c-aux <> "1":U AND 
                       c-aux <> "2":U AND 
                       c-aux <> "3":U AND 
                       c-aux <> "4":U AND 
                       c-aux <> "5":U AND 
                       c-aux <> "6":U AND 
                       c-aux <> "7":U AND 
                       c-aux <> "8":U AND 
                       c-aux <> "9":U THEN DO:
                        run utp/ut-msgs.p (input "show":U, 
                                           input &if defined(bf_man_205) &then 28353 
                                                 &else 28354 &endif, 
                                           input input frame {&frame-name} item-controle.formato).
                        apply 'entry' to item-controle.formato in frame {&frame-name}.
                        return 'ADM-ERROR':U.     
                    END.
                END.
        END.
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

    assign item-controle.tip-result = {ininc/i01in482.i 06 cb-tip-result}.

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
    
    ASSIGN l-modificando = NO.
    
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

  assign cb-tip-result:screen-value in frame {&frame-name} = if  avail item-controle
                                                             then {ininc/i01in482.i 04 item-controle.tip-result}
                                                             else {ininc/i01in482.i 04 1}.

  APPLY "leave":U TO item-controle.nr-tabela IN FRAME f-main.  

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
 /*   if adm-new-record = yes then */
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    apply 'value-changed' to cb-tip-result in frame {&frame-name}.

    ASSIGN l-modificando = YES.

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

  {utp/ut-field.i mgind item-controle tip-result 1}

  assign cb-tip-result:list-items in frame {&frame-name} = {ininc/i01in482.i 03}
         cb-tip-result:label in frame {&frame-name} = return-value.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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

  if avail item-controle then
        assign gr-item-controle = rowid(item-controle).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "item-controle"}

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

