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
{include/i-prgvrs.i V05IN042 2.00.00.005 } /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v05in042 MUT}
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

define new global shared var rw-centro-custo as rowid no-undo.
define var c-handle   as char.

def var da-iniper          as date format "99/99/9999"   no-undo.
def var da-fimper          as date format "99/99/9999"   no-undo.
def var i-per-corrente     as int  format "99"           no-undo.
def var i-ano-corrente     as int  format "9999"         no-undo.
def var da-iniper-fech     as date format "99/99/9999"   no-undo.
def var da-fimper-fech     as date format "99/99/9999"   no-undo.
def var i-cont             as int                        no-undo.
def var c-lista-periodos   as char format "x(80)"        no-undo.
def var wh-handle-browse-1 as handle                     no-undo.
def var wh-handle-browse-2 as handle                     no-undo.
def var wh-handle-browse-3 as handle                     no-undo.
def var c-periodo          as char                       no-undo.
def var c-parametro        as char                       no-undo.
def var c-min-conta        as char                       no-undo.

def var c-ult-per-fech-aux like param-estoq.ult-per-fech no-undo.
def var i-ano-anterior     as int  format "9999"         no-undo.
def var i-ano-posterior    as int  format "9999"         no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
def var i-empresa-prin     LIKE empresa.ep-codigo                    no-undo.
&ELSE
def var i-empresa-prin     as integer                    no-undo.
&ENDIF

{cdp/cdcfgman.i}
/* Local Definitions for EAI                                   */
&IF DEFINED (bf_man_204) &THEN 
  {cdp/cd9043.i} /* Definiá∆o da tabela de erros RowErros */
  DEFINE TEMP-TABLE tt-eai-centro-custo LIKE centro-custo.
  DEF VAR hShowMsg AS HANDLE NO-UNDO.
  DEF SHARED VAR v_log_eai_habilit AS LOGICAL NO-UNDO. 
  DEFINE TEMP-TABLE tt-eai-periodo NO-UNDO
       FIELD periodo LIKE ext-per-custo.periodo. 
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
&Scoped-define EXTERNAL-TABLES centro-custo
&Scoped-define FIRST-EXTERNAL-TABLE centro-custo


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR centro-custo.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS centro-custo.conta-mob ~
centro-custo.data-cust-pr 
&Scoped-define ENABLED-TABLES centro-custo
&Scoped-define FIRST-ENABLED-TABLE centro-custo
&Scoped-Define ENABLED-OBJECTS rt-key cb-periodo cb-estabel 
&Scoped-Define DISPLAYED-FIELDS centro-custo.cod-estabel ~
centro-custo.conta-mob centro-custo.data-cust-pr 
&Scoped-define DISPLAYED-TABLES centro-custo
&Scoped-define FIRST-DISPLAYED-TABLE centro-custo
&Scoped-Define DISPLAYED-OBJECTS c-desc-estab cb-periodo c-titulo ~
de-horas-report cb-estabel 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS de-horas-report 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
cc-codigo|y|y|mgind.centro-custo.cc-codigo
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "cc-codigo",
     Keys-Supplied = "cc-codigo"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE cb-estabel AS CHARACTER FORMAT "X(3)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 9.29 BY 1 NO-UNDO.

DEFINE VARIABLE cb-periodo AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-estab AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY .88 NO-UNDO.

DEFINE VARIABLE c-titulo AS CHARACTER FORMAT "X(32)":U 
     VIEW-AS FILL-IN 
     SIZE 46.72 BY .88.

DEFINE VARIABLE de-horas-report AS DECIMAL FORMAT ">>>,>>9.9999" INITIAL 0 
     LABEL "Horas Reportadas":R20 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 3.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     centro-custo.cod-estabel AT ROW 1.17 COL 21 COLON-ALIGNED
          LABEL "Estabel Padr∆o":R15
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-desc-estab AT ROW 1.17 COL 28.29 COLON-ALIGNED NO-LABEL
     cb-periodo AT ROW 1.17 COL 68.29 COLON-ALIGNED
     centro-custo.conta-mob AT ROW 2.17 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     c-titulo AT ROW 2.17 COL 39.43 COLON-ALIGNED NO-LABEL
     de-horas-report AT ROW 3.17 COL 21 COLON-ALIGNED
     centro-custo.data-cust-pr AT ROW 3.17 COL 55.14 COLON-ALIGNED
          LABEL "Data Custo Previsto":R19 FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     cb-estabel AT ROW 3.17 COL 77 COLON-ALIGNED
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.centro-custo
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
         HEIGHT             = 3.5
         WIDTH              = 88.72.
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

/* SETTINGS FOR FILL-IN c-desc-estab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-titulo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN centro-custo.cod-estabel IN FRAME f-main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN centro-custo.data-cust-pr IN FRAME f-main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN de-horas-report IN FRAME f-main
   NO-ENABLE 3                                                          */
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

&Scoped-define SELF-NAME cb-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-estabel V-table-Win
ON VALUE-CHANGED OF cb-estabel IN FRAME f-main
DO : 

   RUN pi-atualiza-valores-moedas.
   RUN pi-atualiza-horas-report.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-periodo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-periodo V-table-Win
ON VALUE-CHANGED OF cb-periodo IN FRAME f-main
DO : 

   RUN pi-atualiza-valores-moedas.
   RUN pi-atualiza-horas-report.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME centro-custo.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.cod-estabel V-table-Win
ON F5 OF centro-custo.cod-estabel IN FRAME f-main /* Estabel Padr∆o */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                     &campo=centro-custo.cod-estabel
                     &campozoom=cod-estabel
                     &campo2=c-desc-estab
                     &campozoom2=nome}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.cod-estabel V-table-Win
ON LEAVE OF centro-custo.cod-estabel IN FRAME f-main /* Estabel Padr∆o */
DO:
  if  input frame {&frame-name} centro-custo.cod-estabel <> "*" then do :
     {include/leave.i &tabela=estabelec
                      &atributo-ref=nome
                      &variavel-ref=c-desc-estab
                      &where="estabelec.cod-estabel = input frame {&frame-name} centro-custo.cod-estabel"}  

  end.
  else 
      assign c-desc-estab = "Comum a todos estabelecimentos" .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF centro-custo.cod-estabel IN FRAME f-main /* Estabel Padr∆o */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME centro-custo.conta-mob
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.conta-mob V-table-Win
ON F5 OF centro-custo.conta-mob IN FRAME f-main /* Conta MOB */
DO:


  assign i-ep-codigo-usuario = i-empresa-prin
         l-implanta          = yes.

    {include/zoomvar.i &prog-zoom="adzoom/z01ad049.w"
                       &campo=centro-custo.conta-mob
                       &campozoom=conta-contabil}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.conta-mob V-table-Win
ON LEAVE OF centro-custo.conta-mob IN FRAME f-main /* Conta MOB */
DO:


    find first conta-contab
      where conta-contab.ep-codigo      = i-empresa-prin and
            conta-contab.conta-contabil = input frame {&frame-name} centro-custo.conta-mob no-lock no-error.
   if  not available(conta-contab) then do:
       assign c-titulo:screen-value = "".
   end.
   else do:
       assign c-titulo:screen-value = conta-contab.titulo.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.conta-mob V-table-Win
ON MOUSE-SELECT-DBLCLICK OF centro-custo.conta-mob IN FRAME f-main /* Conta MOB */
DO:
    apply "F5" to self.
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

find first param-global no-lock no-error.

do with frame {&frame-name}:
   if centro-custo.conta-mob:load-mouse-pointer ("Image~\lupa.cur") then.

   assign centro-custo.conta-mob:format = param-global.formato-conta-contabil.

   {utp/ut-field.i mgind ext-per-custo periodo 1}
   assign cb-periodo:label  = return-value.

   {utp/ut-liter.i Estabel 1}
   assign cb-estabel:label  = return-value.
end.

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
    WHEN 'cc-codigo':U THEN
       {src/adm/template/find-tbl.i
           &TABLE = centro-custo
           &WHERE = "WHERE centro-custo.cc-codigo eq key-value"
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
  {src/adm/template/row-list.i "centro-custo"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "centro-custo"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 {include/i-valid.i}

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.


  find first conta-contab
       where conta-contab.ep-codigo      = i-empresa-prin and
             conta-contab.conta-contabil = centro-custo.conta-mob no-lock no-error.
  if avail(conta-contab) then        
     assign centro-custo.ct-mob = conta-contab.ct-codigo
            centro-custo.sc-mob = conta-contab.sc-codigo.

  assign cb-periodo:sensitive in frame {&frame-name} = yes
         cb-estabel:sensitive in frame {&frame-name} = yes.                   

    /* Para execuá∆o de Adapter da Mensagem Centro Custo - EAI */
    &IF DEFINED (bf_man_204) &THEN 
      IF v_log_eai_habilit THEN DO:
        CREATE tt-eai-centro-custo.
        IF AVAIL centro-custo THEN BUFFER-COPY centro-custo TO tt-eai-centro-custo.
        /* Aliementa temp-table de per°odos*/
        CREATE tt-eai-periodo.
        ASSIGN tt-eai-periodo.periodo = c-parametro.

        RUN adapters/xml/ma2/axsma001.p (INPUT "upd",
                                         INPUT "cs0101.w",
                                         INPUT STRING(c-prg-vrs),
                                         INPUT "", /* Evento */
                                         INPUT TABLE tt-eai-periodo,
                                         INPUT TABLE tt-eai-centro-custo,
                                         OUTPUT TABLE RowErrors).  
        DELETE tt-eai-centro-custo.
        DELETE tt-eai-periodo.
        
        IF CAN-FIND (FIRST RowErrors WHERE 
                           RowErrors.ErrorSubType = "ERROR":U) THEN DO:
          
           {method/showmessage.i1}
           {method/showmessage.i2 &Modal="YES"}
           EMPTY TEMP-TABLE RowErrors NO-ERROR.
           undo, return "ADM-ERROR":U.
        END.
      END.
    &ENDIF
    
    FIND FIRST ext-per-custo-estab 
         WHERE ext-per-custo-estab.cc-codigo   = centro-custo.cc-codigo
           AND ext-per-custo-estab.cod-estabel = cb-estabel:SCREEN-VALUE IN frame {&frame-name}
           AND ext-per-custo-estab.mo-codigo   = 0
           AND ext-per-custo-estab.periodo     = substring(cb-periodo:screen-value,1,4) 
                                                + substring(cb-periodo:screen-value,6,2) EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL ext-per-custo-estab THEN
       ASSIGN ext-per-custo-estab.horas-report = INPUT FRAME {&FRAME-NAME} de-horas-report.

    RELEASE ext-per-custo-estab.

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

  assign cb-periodo:sensitive in frame {&frame-name} = yes
         cb-estabel:sensitive in frame {&frame-name} = IF AVAIL centro-custo AND centro-custo.cod-estabel = "*" THEN YES
                                                       ELSE NO.                   

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
  find first param-estoq no-lock no-error.
  if avail(param-estoq) then do:
      if param-estoq.tp-fech = 1 then do:
          if param-estoq.ult-per-fech <> ? and param-estoq.ult-per-fech <> ""  then do :
             /**********************buscando periodo atual*************/
             run cdp/cdapi005.p (input  param-estoq.ult-per-fech,   
                                 output da-iniper               ,
                                 output da-fimper               ,
                                 output i-per-corrente          ,
                                 output i-ano-corrente          ,    
                                 output da-iniper-fech          ,
                                 output da-fimper-fech          ).
             assign i-ano-anterior  = i-ano-corrente - 1
                    i-ano-posterior = i-ano-corrente + 1.                    
          end.                         
          else do:
             assign c-ult-per-fech-aux = string(year(today),"9999") + 
                                         string(month(today),"99").
             run cdp/cdapi005.p (input  c-ult-per-fech-aux      ,
                                 output da-iniper               ,
                                 output da-fimper               ,
                                 output i-per-corrente          ,
                                 output i-ano-corrente          ,    
                                 output da-iniper-fech          ,
                                 output da-fimper-fech          ).
             assign i-ano-anterior  = i-ano-corrente - 1
                    i-ano-posterior = i-ano-corrente + 1.
          end.   
      end.    
      if param-estoq.tp-fech = 2 then do:
          find first estab-mat 
               where estab-mat.cod-estabel = centro-custo.cod-estabel no-lock no-error.
          if avail estab-mat then do:
              if estab-mat.ult-per-fech <> ? and estab-mat.ult-per-fech <> ""  then do :
                 /**********************buscando periodo atual*************/
                 run cdp/cdapi005.p (input  estab-mat.ult-per-fech,   
                                     output da-iniper               ,
                                     output da-fimper               ,
                                     output i-per-corrente          ,
                                     output i-ano-corrente          ,    
                                     output da-iniper-fech          ,
                                     output da-fimper-fech          ).
                 assign i-ano-anterior  = i-ano-corrente - 1
                        i-ano-posterior = i-ano-corrente + 1.                    
              end.                         
              else do:
                 assign c-ult-per-fech-aux = string(year(today),"9999") + 
                                             string(month(today),"99").
                 run cdp/cdapi005.p (input  c-ult-per-fech-aux      ,
                                     output da-iniper               ,
                                     output da-fimper               ,
                                     output i-per-corrente          ,
                                     output i-ano-corrente          ,    
                                     output da-iniper-fech          ,
                                     output da-fimper-fech          ).
                 assign i-ano-anterior = i-ano-corrente - 1
                        i-ano-posterior = i-ano-corrente + 1.
              end.   
          end.    
      end.
  end.   
      &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        assign cb-periodo:LIST-ITEM-PAIRS in frame {&frame-name} = "," .
    &else
        assign cb-periodo:list-items in frame {&frame-name} = '' .
    &endif




  for each ano-fiscal where 
       ano-fiscal.ep-codigo  = i-empresa-prin and
       ano-fiscal.ano-fiscal >= i-ano-anterior and 
       ano-fiscal.ano-fiscal <= i-ano-posterior no-lock :

        do i-cont = 1 to ano-fiscal.num-periodos :  
            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
               cb-periodo:add-last((string(ano-fiscal) + "/" + string(i-cont,"99")),( string(ano-fiscal) + "/" + string(i-cont,"99")))
                          in frame {&FRAME-NAME}.
            &else
               cb-periodo:add-last(string(ano-fiscal) + "/" + string(i-cont,"99"))
                          in frame {&frame-name}.  
            &endif

        end. 
  end.

    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        if cb-periodo:LIST-ITEM-PAIRS in frame {&frame-name} <> '' and 
    &else
        if cb-periodo:list-items in frame {&frame-name} <> '' and 
    &endif
     i-ano-corrente <> 0 then 
     cb-periodo:screen-value in frame {&frame-name} = string(i-ano-corrente,"9999") + '/' + string(i-per-corrente,"99").

  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        assign cb-estabel:LIST-ITEM-PAIRS in frame {&frame-name} = ',' .
  &ELSE
  assign cb-estabel:list-items in frame {&frame-name} = '' .
  &ENDIF
        
  for each estabelec 
      WHERE estabelec.cod-estabel <> "*" no-lock :
       &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
       cb-estabel:ADD-LAST (estabelec.cod-estabel,estabelec.cod-estabel) in frame {&frame-name}.                  
       &ELSE
        cb-estabel:ADD-LAST (estabelec.cod-estabel) in frame {&frame-name}.                  
       &ENDIF
  end.

  if &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
      cb-estabel:LIST-ITEM-PAIRS in frame {&frame-name} <> ''
      &ELSE 
      cb-estabel:list-items in frame {&frame-name} <> '' 
      &endif THEN DO:
     IF AVAIL centro-custo AND LOOKUP(centro-custo.cod-estabel, &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then cb-estabel:LIST-ITEM-PAIRS 
                                                                      &ELSE cb-estabel:LIST-ITEMS &ENDIF ) > 0 THEN
        ASSIGN  cb-estabel:screen-value in frame {&frame-name} = centro-custo.cod-estabel .                       
                
  END.
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  /* Code placed here will execute AFTER standard behavior.    */


  find first conta-contab
      where conta-contab.ep-codigo = i-empresa-prin and
            conta-contab.conta-contabil = input frame {&frame-name} centro-custo.conta-mob no-lock no-error.
  if  not available(conta-contab) then do:
      assign c-titulo:screen-value = ""
             centro-custo.conta-mob:screen-value = c-min-conta.
  end.
  else do:
      assign c-titulo:screen-value = conta-contab.titulo.
  end.

  if avail(param-estoq) THEN DO:
     apply "value-changed" to cb-periodo in frame {&frame-name}.
     apply "value-changed" to cb-estabel in frame {&frame-name}.
  END.
     

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

  assign cb-periodo:sensitive in frame {&frame-name} = no
         cb-estabel:sensitive in frame {&frame-name} = NO.

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
  find first param-estoq no-lock no-error.
  find first param-global no-lock no-error.

  assign i-empresa-prin = param-global.empresa-prin.

  find first estabelec
       where estabelec.cod-estabel = centro-custo.cod-estabel no-lock no-error.
  if avail estabelec then 
     run cdp/cd9970.p (input rowid(estabelec),
                       output i-empresa-prin).  

  run utp/ut-limit.p ("MIN", param-global.formato-conta-contabil).
  assign c-min-conta = return-value.  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  find first conta-contab
       where conta-contab.ep-codigo = i-empresa-prin and
             conta-contab.conta-contabil = input frame {&frame-name} 
             centro-custo.conta-mob no-lock no-error.
  if not available(conta-contab) then do:
     assign c-titulo:screen-value = "". 
  end.
  else do:
     assign c-titulo:screen-value = conta-contab.titulo.
  end.  

  RUN get-link-handle IN adm-broker-hdl
     (INPUT this-procedure   ,
      INPUT "handle-1-target",
      OUTPUT c-handle        ).
  assign wh-handle-browse-1 = widget-handle(c-handle).     

  RUN get-link-handle IN adm-broker-hdl
     (INPUT this-procedure   ,
      INPUT "handle-2-target",
      OUTPUT c-handle        ).
  assign wh-handle-browse-2 = widget-handle(c-handle).          

  RUN get-link-handle IN adm-broker-hdl
     (INPUT this-procedure   ,
      INPUT "handle-3-target",
      OUTPUT c-handle        ).
  assign wh-handle-browse-3 = widget-handle(c-handle).          

  if avail(param-estoq) then
     apply "value-changed" to cb-periodo in frame {&frame-name}.

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
  
  assign rw-centro-custo = rowid(centro-custo).

  /* Code placed here will execute AFTER standard behavior.    */
   assign i-empresa-prin = param-global.empresa-prin.
   find first estabelec
        where estabelec.cod-estabel = centro-custo.cod-estabel no-lock no-error.
   if avail estabelec then
         run cdp/cd9970.p (input rowid(estabelec),
                           output i-empresa-prin).

   ASSIGN cb-estabel:sensitive in frame {&frame-name} = IF AVAIL centro-custo AND centro-custo.cod-estabel = "*" THEN YES
                                                        ELSE NO.

   RUN pi-atualiza-horas-report.

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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* Ponha aqui a validaá∆o de chave duplicada */

  /* Ponha aqui as demais validaá‰es */

  /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-horas-report V-table-Win 
PROCEDURE pi-atualiza-horas-report :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   FIND FIRST ext-per-custo-estab 
        WHERE ext-per-custo-estab.cc-codigo   = centro-custo.cc-codigo
          AND ext-per-custo-estab.cod-estabel = cb-estabel:SCREEN-VALUE IN frame {&frame-name}
          AND ext-per-custo-estab.mo-codigo   = 0
          AND ext-per-custo-estab.periodo     = substring(cb-periodo:screen-value,1,4) 
                                                + substring(cb-periodo:screen-value,6,2) NO-LOCK NO-ERROR.
   IF AVAIL ext-per-custo-estab THEN
      ASSIGN de-horas-report = ext-per-custo-estab.horas-report.
   ELSE
      ASSIGN de-horas-report = 0.
   
   DISPLAY de-horas-report WITH FRAME {&FRAME-NAME}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-valores-moedas V-table-Win 
PROCEDURE pi-atualiza-valores-moedas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   do with frame {&frame-name} :
      assign c-parametro = substring(cb-periodo:screen-value,1,4) 
                         + substring(cb-periodo:screen-value,6,2).
   end.                         

   if valid-handle (wh-handle-browse-1) then
     run pi-atualiza-valores in wh-handle-browse-1 (input c-parametro,
                                                    INPUT cb-estabel:SCREEN-VALUE IN frame {&frame-name}).

   if valid-handle (wh-handle-browse-2) and param-estoq.tem-moeda1 then    
      run pi-atualiza-valores in wh-handle-browse-2 (input c-parametro,
                                                     INPUT cb-estabel:SCREEN-VALUE IN frame {&frame-name}).

   if valid-handle (wh-handle-browse-3) and param-estoq.tem-moeda2 then       
      run pi-atualiza-valores in wh-handle-browse-3 (input c-parametro,
                                                     INPUT cb-estabel:SCREEN-VALUE IN frame {&frame-name}).                  


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PI-Retorna-estab V-table-Win 
PROCEDURE PI-Retorna-estab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER p-estabel LIKE ext-per-custo-estab.cod-estabel NO-UNDO.
ASSIGN p-estabel = cb-estabel:SCREEN-VALUE IN frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

if input frame {&frame-name} centro-custo.conta-mob <> "" then do :
  find first conta-contab
       where conta-contab.ep-codigo = i-empresa-prin and
             conta-contab.conta-contabil = input frame {&frame-name} centro-custo.conta-mob no-lock no-error.
  if not available(conta-contab) then do:
     {utp/ut-field.i mgind centro-custo conta-contabil 1}
     run utp/ut-msgs.p (input "show",
                        input 2,
                        input trim(return-value)).
     apply "entry" to centro-custo.conta-mob in frame {&frame-name}.
     return "ADM-ERROR":U.
  end.
  if conta-contab.estoq <> 5 then do:             
     {utp/ut-liter.i M∆o-de-Obra * r}
      run utp/ut-msgs.p (input "show",
                         input 2851,
                         input input frame {&frame-name} centro-custo.conta-mob
                                + "~~" + trim(return-value)).
      apply "entry" to centro-custo.conta-mob in frame {&frame-name}.
      return "ADM-ERROR":U.
   end.
end.

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
  {src/adm/template/sndkycas.i "cc-codigo" "centro-custo" "cc-codigo"}

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
  {src/adm/template/snd-list.i "centro-custo"}

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

