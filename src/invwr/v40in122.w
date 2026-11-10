&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i V40IN122 2.00.02.008 } /*** 010208 ***/

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

DEF NEW GLOBAL SHARED VAR gr-familia  AS rowid NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-deposito AS rowid NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-planejad AS rowid NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-lin-prod AS rowid NO-UNDO.

def var i-ind-refugo   as integer init 1 no-undo.
def var h-tipo-con-est as handle         no-undo.

DEF VAR cTipoFormula AS CHAR FORMAT "x(20)" NO-UNDO.

{cdp/cd7300.i1}
{cdp/cdapi211.i}
{cdp/cdcfgman.i}
{cdp/cd0666.i}
{cpp/cpapi020.i}
{cpp/cpapi020.i1} /* Funções Fator de Concentração */

/* Local Definitions for EAI                                   */
{cdp/cd9043.i} /* Defini‡Æo da tabela de erros RowErros */
DEF VAR c-action AS CHARACTER FORMAT "X(8)" NO-UNDO.
DEFINE TEMP-TABLE tt-fam LIKE familia.
DEF VAR hShowMsg AS HANDLE NO-UNDO.
&IF DEFINED (bf_man_204) &THEN 
DEF SHARED VAR v_log_eai_habilit AS LOGICAL NO-UNDO. 
&ENDIF

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
&Scoped-define EXTERNAL-TABLES familia
&Scoped-define FIRST-EXTERNAL-TABLE familia


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR familia.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS familia.cd-planejado familia.ressup-fabri ~
familia.cap-est-fabr familia.lote-economi 
&Scoped-define ENABLED-TABLES familia
&Scoped-define FIRST-ENABLED-TABLE familia
&Scoped-Define DISPLAYED-FIELDS familia.deposito-pad familia.cod-localiz ~
familia.cd-planejado familia.ressup-fabri familia.cap-est-fabr ~
familia.lote-economi 
&Scoped-define DISPLAYED-TABLES familia
&Scoped-define FIRST-DISPLAYED-TABLE familia
&Scoped-Define DISPLAYED-OBJECTS c-deposito c-desc-local c-cd-plan ~
cb-tipo-formula fi-per-ppm 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS cb-tipo-formula 

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
DEFINE VARIABLE cb-tipo-formula AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-cd-plan AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 38.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-deposito AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-local AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 29.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-per-ppm AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.57 BY 7.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     familia.deposito-pad AT ROW 1.17 COL 29.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-deposito AT ROW 1.17 COL 37.57 COLON-ALIGNED NO-LABEL
     familia.cod-localiz AT ROW 2.17 COL 29.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     c-desc-local AT ROW 2.17 COL 55 COLON-ALIGNED NO-LABEL
     familia.cd-planejado AT ROW 3.17 COL 29.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     c-cd-plan AT ROW 3.17 COL 46.57 COLON-ALIGNED HELP
          "Nome do Planejador" NO-LABEL
     familia.ressup-fabri AT ROW 4.17 COL 29.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     familia.cap-est-fabr AT ROW 5.17 COL 29.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     familia.lote-economi AT ROW 6.17 COL 29.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     cb-tipo-formula AT ROW 7.17 COL 29.72 COLON-ALIGNED
     fi-per-ppm AT ROW 7.17 COL 60 COLON-ALIGNED
     RECT-8 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.familia
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
         HEIGHT             = 7.75
         WIDTH              = 86.57.
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

/* SETTINGS FOR FILL-IN c-cd-plan IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-deposito IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-local IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-tipo-formula IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN familia.cod-localiz IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN familia.deposito-pad IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-per-ppm IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-8 IN FRAME f-main
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

&Scoped-define SELF-NAME cb-tipo-formula
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo-formula V-table-Win
ON ENTRY OF cb-tipo-formula IN FRAME f-main
DO:
  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
      ASSIGN cTipoFormula = string(lookup(cb-tipo-formula:screen-value in frame {&frame-name}, cb-tipo-formula:LIST-ITEM-PAIRS) / 2 ).  
  &else
      ASSIGN cTipoFormula = string(lookup(cb-tipo-formula:screen-value in frame {&frame-name}, cb-tipo-formula:list-items)).
  &endif

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo-formula V-table-Win
ON VALUE-CHANGED OF cb-tipo-formula IN FRAME f-main
DO:

    def var de-per-ppm as dec no-undo.
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        IF cTipoFormula <> string(lookup(cb-tipo-formula:screen-value in frame {&frame-name}, cb-tipo-formula:LIST-ITEM-PAIRS) / 2 ) THEN DO:
        case INT(lookup(cb-tipo-formula:screen-value in frame {&frame-name}, cb-tipo-formula:LIST-ITEM-PAIRS) / 2):
            when 2 then do:
                assign de-per-ppm = if  NOT fi-per-ppm:HIDDEN in frame {&frame-name} then
                                f-conv-per-ppm(dec(fi-per-ppm:screen-value in frame {&frame-name}),2)
                            else
                                100.
                run pi-formata-campo (fi-per-ppm:handle, true, true, de-per-ppm, {ininc/i25in172.i 04 02} + "(%)":u, ">>9.9999":u).
                run pi-retorna-handle (output h-tipo-con-est).
                assign h-tipo-con-est:screen-value = {ininc/i01in122.i 04 03}.
            end.
            when 3 then do:
                assign de-per-ppm = if NOT fi-per-ppm:HIDDEN in frame {&frame-name} then
                                        f-conv-per-ppm(dec(fi-per-ppm:screen-value in frame {&frame-name}),1)
                                    else
                                        1000000.        
                run pi-formata-campo (fi-per-ppm:handle, true, true, de-per-ppm, {ininc/i25in172.i 04 03}, ">>>>,>>9.9999":u).
                run pi-retorna-handle (output h-tipo-con-est).
                assign h-tipo-con-est:screen-value = {ininc/i01in122.i 04 03}.
            end.
            otherwise
                run pi-formata-campo (fi-per-ppm:handle, false, false, 0, "", "").
        end case.
        ASSIGN cTipoFormula = string(lookup(cb-tipo-formula:screen-value in frame {&frame-name}, cb-tipo-formula:LIST-ITEM-PAIRS) / 2).
        END.
    &else
        IF cTipoFormula <> string(lookup(cb-tipo-formula:screen-value in frame {&frame-name}, cb-tipo-formula:list-items)) THEN DO:
        case lookup(cb-tipo-formula:screen-value in frame {&frame-name}, cb-tipo-formula:list-items):
            when 2 then do:
                assign de-per-ppm = if  NOT fi-per-ppm:HIDDEN in frame {&frame-name} then
                                f-conv-per-ppm(dec(fi-per-ppm:screen-value in frame {&frame-name}),2)
                            else
                                100.
                run pi-formata-campo (fi-per-ppm:handle, true, true, de-per-ppm, {ininc/i25in172.i 04 02} + "(%)":u, ">>9.9999":u).
                run pi-retorna-handle (output h-tipo-con-est).
                assign h-tipo-con-est:screen-value = {ininc/i01in122.i 04 03}.
            end.
            when 3 then do:
                assign de-per-ppm = if NOT fi-per-ppm:HIDDEN in frame {&frame-name} then
                                        f-conv-per-ppm(dec(fi-per-ppm:screen-value in frame {&frame-name}),1)
                                    else
                                        1000000.        
                run pi-formata-campo (fi-per-ppm:handle, true, true, de-per-ppm, {ininc/i25in172.i 04 03}, ">>>>,>>9.9999":u).
                run pi-retorna-handle (output h-tipo-con-est).
                assign h-tipo-con-est:screen-value = {ininc/i01in122.i 04 03}.
            end.
            otherwise
                run pi-formata-campo (fi-per-ppm:handle, false, false, 0, "", "").
        end case.
        ASSIGN cTipoFormula = string(lookup(cb-tipo-formula:screen-value in frame {&frame-name}, cb-tipo-formula:list-items)).
        END.
    &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME familia.cd-planejado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.cd-planejado V-table-Win
ON F5 OF familia.cd-planejado IN FRAME f-main /* Planejador */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom = "inzoom\z01in321.w"
                  &tabela = familia
                  &atributo = cd-planejado}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.cd-planejado V-table-Win
ON LEAVE OF familia.cd-planejado IN FRAME f-main /* Planejador */
DO:

  find first planejad where planejad.cd-planejado = input frame {&frame-name} familia.cd-planejado no-error.
    assign c-cd-plan:screen-value = if avail planejad then planejad.nome else "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.cd-planejado V-table-Win
ON MOUSE-SELECT-DBLCLICK OF familia.cd-planejado IN FRAME f-main /* Planejador */
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

  if  familia.cd-planejado:load-mouse-pointer ("image~\lupa.cur")  then.

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
  {src/adm/template/row-list.i "familia"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "familia"}

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

  run pi-validate.

  if return-value = "adm-error":U then
      return "adm-error":U.

  /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
       RETURN 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

    find first familia-man
         where familia-man.fm-codigo = familia.fm-codigo exclusive-lock no-error.
    if not avail familia-man then do:
         create familia-man.
         buffer-copy familia to familia-man
                assign familia-man.ind-refugo = i-ind-refugo.
    end.
    else do:
         assign familia-man.ind-refugo    = i-ind-refugo
                familia-man.tipo-requis   = familia.tipo-requis
                familia-man.reporte-mob   = familia.reporte-mob
                familia-man.reporte-ggf   = familia.reporte-ggf
                familia-man.classe-repr   = familia.classe-repr
                familia-man.tipo-con-est  = familia.tipo-con-est
                familia-man.rep-prod      = familia.rep-prod
                familia-man.demanda       = familia.demanda
                familia-man.deposito-pad  = familia.deposito-pad
                familia-man.cod-localiz   = familia.cod-localiz
                familia-man.cd-planejado  = familia.cd-planejado
                familia-man.nr-linha      = familia.nr-linha
                familia-man.ressup-fabri  = familia.ressup-fabri
                familia-man.cap-est-fabr  = familia.cap-est-fabr
                familia-man.lote-economi  = familia.lote-economi
                familia-man.sit-aloc      = familia.sit-aloc.
    end.

    if param-global.modulo-per-ppm then do:
      &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        assign familia.tipo-formula = (lookup(cb-tipo-formula:screen-value in frame {&frame-name}, cb-tipo-formula:LIST-ITEM-PAIRS) / 2) .
        case INT(lookup(cb-tipo-formula:screen-value in frame {&frame-name}, cb-tipo-formula:LIST-ITEM-PAIRS) / 2) :      
      &else
        assign familia.tipo-formula = lookup(cb-tipo-formula:screen-value in frame {&frame-name}, cb-tipo-formula:list-items).
        case lookup(cb-tipo-formula:screen-value in frame {&frame-name}, cb-tipo-formula:list-items):
      &endif
            WHEN 0 THEN
            ASSIGN familia.per-ppm = 0
                   fi-per-ppm:HIDDEN      in frame {&frame-name} = YES.
            when 2 or
           when 3 then
                assign familia.per-ppm = dec(fi-per-ppm:screen-value in frame {&frame-name})
                       fi-per-ppm:HIDDEN      in frame {&frame-name} = NO.
            otherwise
                assign familia.per-ppm = 0.
        end case.

     end.
     ELSE
        assign cb-tipo-formula:HIDDEN in frame {&frame-name} = YES
               fi-per-ppm:HIDDEN      in frame {&frame-name} = YES.

     ASSIGN cb-tipo-formula:sensitive      in frame {&frame-name} = NO
            fi-per-ppm:sensitive      in frame {&frame-name} = NO.


   /****************************MULTIPLANTA****************************/
     assign c-transacao = "MAN013".
    {cdp/cd7300.i5 "001" c-transacao}

    if param-global.modulo-mp and tt-replica-msg.log-replica-msg = yes then do:
    if avail familia then do:
         create tt-familia-aux.
         buffer-copy familia to tt-familia-aux.
         create tt-dados-env.
         assign tt-dados-env.num-sequencia  = i-seq
                tt-dados-env.cod-tipo-reg   = 30 /*fam¡lia*/
                tt-dados-env.ind-tipo-movto = 2 /*modifica*/
                tt-dados-env.identif-msg    = familia.fm-codigo.
         raw-transfer tt-familia-aux to tt-dados-env.conteudo-msg.
         assign i-seq = i-seq + 1.
      end.  
    end.

    {cdp/cd7300.i6 "001" c-transacao}

   /****************************MULTIPLANTA****************************/
    /****************************************************************/    
    /* Para execu‡Æo de Adapter da Mensagem Unidade de Medida - EAI */
    /****************************************************************/
    &IF DEFINED (bf_man_204) &THEN 
      /* Execucao caso usuario possua integracao EAI */
      IF v_log_eai_habilit THEN DO:
        IF adm-new-record THEN ASSIGN c-action = "add". 
        ELSE ASSIGN c-action = "upd".
        CREATE tt-fam.
        BUFFER-COPY familia TO tt-fam.
        RUN adapters/xml/ma2/axsma004.p (INPUT c-action,
                                         INPUT "CP0104.W",
                                         INPUT STRING(c-prg-vrs),
                                         INPUT "CPP",
                                         INPUT TABLE tt-fam,
                                         OUTPUT TABLE RowErrors).  
        DELETE tt-fam.
        IF CAN-FIND (FIRST RowErrors WHERE 
                           RowErrors.ErrorSubType = "ERROR":U) THEN DO:

           {method/showmessage.i1}
           {method/showmessage.i2 &Modal="YES"}

           undo, return "ADM-ERROR":U.
        END.
      END.
    &ENDIF

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

    if valid-handle (h-cpapi020) then
        run pi-finalizar in h-cpapi020.

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
    find deposito where deposito.cod-depos = familia.deposito-pad no-lock no-error.
    assign c-deposito = if avail deposito then deposito.nome else "".

    find first localizacao where 
               localizacao.cod-localiz  = familia.cod-localiz and 
               localizacao.cod-depos    = familia.deposito-pad no-lock no-error.
    assign c-desc-local = if avail localizacao then localizacao.descricao else "".

    find planejad where planejad.cd-planejado = familia.cd-planejado no-lock no-error.
    assign c-cd-plan = if avail planejad then planejad.nome else "".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  if param-global.modulo-per-ppm THEN DO:
     if familia.tipo-formula <> 0 then do:
        assign cb-tipo-formula:HIDDEN in frame {&frame-name} = NO 
               cb-tipo-formula:screen-value in frame {&frame-name} = {ininc/i25in172.i 04 familia.tipo-formula}.
        case familia.tipo-formula:
             when 2 THEN DO:
                  ASSIGN fi-per-ppm:HIDDEN      in frame {&frame-name} = NO.
                  run pi-formata-campo (fi-per-ppm:handle, true, false, familia.per-ppm, {ininc/i25in172.i 04 02} + "(%)":u, ">>9.9999":u).
             END.
             when 3 THEN DO:
                  ASSIGN fi-per-ppm:HIDDEN      in frame {&frame-name} = NO.
                  run pi-formata-campo (fi-per-ppm:handle, true, false, familia.per-ppm, {ininc/i25in172.i 04 03}, ">>>>,>>9.9999":u).
             END.
             otherwise
                  run pi-formata-campo (fi-per-ppm:handle, false, false, 0, "", "").
        end case.
     end.
     ELSE DO:
         ASSIGN fi-per-ppm:HIDDEN      in frame {&frame-name} = YES.
         run pi-formata-campo (fi-per-ppm:handle, false, false, 0, "", "").
     END.
  END.
  ELSE
     assign cb-tipo-formula:HIDDEN in frame {&frame-name} = YES
            fi-per-ppm:HIDDEN      in frame {&frame-name} = YES.

/* Code placed here will execute AFTER standard behavior.    */

end.

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
  RUN dispatch IN THIS-PROCEDURE (INPUT 'enable-fields':U).

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  find first localizacao where localizacao.cod-depos    = familia.deposito-pad and 
                               localizacao.cod-localiz  = familia.cod-localiz no-lock no-error.

  if param-global.modulo-ce and 
    (available localizacao or familia.cod-localiz = "") then 
     assign familia.deposito-pad:sensitive in frame {&frame-name} = false
            familia.cod-localiz:sensitive  = false.

  if param-global.modulo-per-ppm THEN DO:

     ASSIGN cb-tipo-formula:screen-value in frame {&frame-name} = {ininc/i25in172.i 04 familia.tipo-formula}.

     if familia.tipo-formula = 2 or
         familia.tipo-formula = 3 THEN 

         assign cb-tipo-formula:HIDDEN IN FRAME {&FRAME-NAME} = NO
                fi-per-ppm:HIDDEN      IN FRAME {&FRAME-NAME} = NO.
     ELSE
        assign cb-tipo-formula:HIDDEN in frame {&frame-name} = NO
               fi-per-ppm:HIDDEN      in frame {&frame-name} = YES.
  END.
  ELSE 
     assign cb-tipo-formula:HIDDEN in frame {&frame-name} = YES
            fi-per-ppm:HIDDEN      in frame {&frame-name} = YES.

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

    find first param-global no-lock.

    {utp/ut-liter.i Componente_para_formula‡Æo * R}
    ASSIGN cb-tipo-formula:LABEL in frame {&frame-name} = trim(return-value).
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE c-lista AS CHARACTER  NO-UNDO.
        ASSIGN c-lista = {ininc/i25in172.i 03}.
        run utp/ut-lstit.p (input-output c-lista).
        ASSIGN cb-tipo-formula:LIST-ITEM-PAIRS in frame {&frame-name} = c-lista.
    &else
        ASSIGN cb-tipo-formula:list-items in frame {&frame-name} = {ininc/i25in172.i 03}.
    &endif

        run cpp/cpapi020.p persistent set h-cpapi020(INPUT-OUTPUT table tt-balanceia,
                                                     input-output table tt-erro,
                                                     INPUT        yes,
                                                     INPUT-OUTPUT TABLE tt-veiculos).

    if  param-global.modulo-per-ppm then do:
        assign cb-tipo-formula:HIDDEN     in frame {&frame-name} = NO
               fi-per-ppm:HIDDEN          in frame {&frame-name} = NO.
    end.
    else
        assign cb-tipo-formula:HIDDEN in frame {&frame-name} = YES
               fi-per-ppm:HIDDEN      in frame {&frame-name} = YES.

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

  IF  AVAIL familia THEN
      ASSIGN gr-familia = ROWID(familia).

  FIND deposito WHERE deposito.cod-depos = familia.deposito NO-LOCK NO-ERROR.
  IF  AVAIL deposito THEN
      ASSIGN gr-deposito = ROWID(deposito).

  FIND planejad WHERE planejad.cd-planejado = familia.cd-planejado NO-LOCK NO-ERROR.
  IF  AVAIL planejad THEN
      ASSIGN gr-planejad = ROWID(planejad).            

  FIND FIRST lin-prod WHERE lin-prod.nr-linha = familia.nr-linha NO-LOCK NO-ERROR.
  IF  AVAIL lin-prod THEN
      ASSIGN gr-lin-prod = ROWID(lin-prod). 

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza V-table-Win 
PROCEDURE pi-atualiza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&if defined (bf_man_sfc_lc) &then
    RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT this-procedure,
         INPUT "cb-ind-refugo").

    assign i-ind-refugo = {ininc/i01in180.i 06 return-value}.
&endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-formata-campo V-table-Win 
PROCEDURE pi-formata-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pHandle      as handle no-undo.
def input param pVisible     as log    no-undo.
def input param pSensitive   as log    no-undo.
def input param pScreenValue as dec    no-undo.
def input param pLabel       as char   no-undo.
def input param pFormat      as char   no-undo.

    RUN utp/ut-liter.p (trim(pLabel), "*", "").

    if pVisible then
        assign pHandle:HIDDEN       = NOT pVisible
               pHandle:sensitive    = pSensitive
               pHandle:format       = pFormat
               pHandle:screen-value = string(pScreenValue)
               pHandle:label        = RETURN-VALUE no-error.
    else
        assign pHandle:HIDDEN = NOT pVisible no-error.

return 'ok':u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-handle V-table-Win 
PROCEDURE pi-retorna-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def output param p-handle as handle.

def var c-handle as char   no-undo.
def var h-handle as handle no-undo.
def var h-frame  as handle no-undo.
def var i-cont   as int    no-undo.

    run who-is-the-container in adm-broker-hdl (input this-procedure, output c-handle).
    assign h-handle = widget-handle(c-handle).

    run get-link-handle in adm-broker-hdl (input  h-handle, 
                                           input  "container-target":U,
                                           output c-handle).
    do i-cont = 1 to num-entries(c-handle):
        assign h-handle = widget-handle(entry(i-cont,c-handle)).
        if h-handle:file-name = "invwr/v41in122.w":u then do:

            run get-attribute in h-handle ("adm-object-handle":U).
            assign h-frame = widget-handle(return-value)
                   h-frame = h-frame:first-child
                   h-frame = h-frame:first-child.

            do while h-frame <> ? :

                if lookup(h-frame:type, "combo-box":U)      <> 0 and
                   lookup(h-frame:type, "combo-box":U)      <> ? and
                   lookup(h-frame:name, "cb-tipo-con-est":U) <> 0 and 
                   lookup(h-frame:name, "cb-tipo-con-est":U) <> ? then do:
                    assign p-handle = h-frame.
                    return 'ok':u.
                end.

                assign h-frame = h-frame:next-sibling.

            end.
        end.
    end.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */   

   if familia.deposito-pad:sensitive in frame {&frame-name} and
       input frame {&frame-name} mgind.familia.deposito-pad <> "" then do:
       if not can-find(deposito where deposito.cod-depos = input frame {&frame-name} familia.deposito-pad) then do:
          {utp/ut-table.i mgind deposito 1}                
          run utp/ut-msgs.p (input "show":U,
                             input 56,
                             input return-value). 
          apply "entry":U to familia.deposito-pad in frame {&frame-name}.
          return "adm-error":U.                   
       end.
    end.   

    if input frame {&frame-name} familia.cd-planejado <> "" then do:
       if not can-find(planejad where planejad.cd-planejado = input frame {&frame-name} familia.cd-planejado) then do:
          {utp/ut-table.i mgind planejad 1}                
          run utp/ut-msgs.p (input "show":U,
                             input 56,
                             input return-value). 
          apply "entry":U to familia.cd-planejado in frame {&frame-name}.
          return "adm-error":U.                                                
       end.                             
    end.   

    if familia.cod-localiz:sensitive in frame {&frame-name} and
       input frame {&frame-name} familia.cod-localiz  <> "" then do:
       find first localizacao where localizacao.cod-depos    = input frame {&frame-name} familia.deposito-pad and 
                                    localizacao.cod-localiz  = input frame {&frame-name} familia.cod-localiz  no-lock no-error.
       if not available localizacao then do:
             {utp/ut-table.i mgind localizacao 1}             
             run utp/ut-msgs.p (input "show":U,
                                input 8535,
                                input return-value). 
             apply "entry":U to familia.cod-localiz in frame {&frame-name}.
             return "adm-error":U.                                                
       end.
    end.    

    if param-global.modulo-per-ppm then
        if cb-tipo-formula:screen-value in frame {&frame-name} = {ininc/i25in172.i 04 02} or
           cb-tipo-formula:screen-value in frame {&frame-name} = {ininc/i25in172.i 04 03} then do:

            run pi-retorna-handle (output h-tipo-con-est).
            if h-tipo-con-est:screen-value <> {ininc/i01in122.i 04 03} then do:
                {include/i-vldprg.i} 
                run utp/ut-msgs.p (input "show",
                                   input 27283,
                                   input ""). 
                apply "entry" to cb-tipo-formula in frame {&frame-name}.
                return "adm-error":u.                
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
  {src/adm/template/snd-list.i "familia"}

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

