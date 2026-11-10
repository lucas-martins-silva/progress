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
{include/i-prgvrs.i V38IN271 2.00.00.035 } /*** "010035" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v38in271 MUT}
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

{cdp/cdcfgman.i} /* Include com preprocessador para release 2.02 */

/* Local Variable Definitions ---                                       */
def var r-atualiza                 as rowid          no-undo.
def var da-dt-trans                as date           no-undo.
def var h-handle                   as handle         no-undo.
def var c-handle                   as char           no-undo.
def var wh-handle-viewer-principal as handle         no-undo.
def var wh-container               as widget-handle  no-undo.
&IF DEFINED (bf_man_per_ppm) &THEN
  def var h-label                  as handle         no-undo.
  def var i-old-tipo-tela          as int            no-undo.
  def var i-old-tipo-formula       as int            no-undo.
&ENDIF

{cpp/cpapi001.i28} /* f-retorna-ult-oper */
{cdp/cd9203.i}     /* Function f-item-uni-estab        */

DEF VAR l-usa-unid-negoc           AS LOG            NO-UNDO.
DEF VAR h-cdapi024                 AS HANDLE         NO-UNDO.

DEF VAR c-dep-acab-anterior        AS CHAR           NO-UNDO.
DEF VAR i-fnc-pf AS LOGICAL NO-UNDO.

&if '{&bf_lote_avancado_liberado}' = 'yes' &then
  def new global shared var c-seg-usuario as char format "x(12)"  no-undo.

  def var h-ceapi030      as handle no-undo.
  def var l-retorno       as log    no-undo.
  def var l-lote-avancado as log    no-undo.
  def var l-sugere-lote   as log    no-undo.
  def var l-amostra       as log    no-undo.
  def var i-tp-amostra    as int    no-undo.

  {cep/ceapi030.i}
  {cdp/cd0666.i}
&endif

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
&Scoped-define EXTERNAL-TABLES ord-prod
&Scoped-define FIRST-EXTERNAL-TABLE ord-prod


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ord-prod.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-OBJECTS fi-cod-depos-acabado ~
fi-cod-localiz-acabado fi-cod-refer-acabado fi-lote-serie-acabado ~
fi-dt-validade-lote-acabado fi-estado fi-per-ppm-acabado 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS fi-cod-depos-acabado fi-cod-refer-acabado ~
fi-lote-serie-acabado fi-dt-validade-lote-acabado 
&Scoped-define List-4 fi-cod-depos-acabado fi-cod-localiz-acabado ~
fi-lote-serie-acabado 

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
DEFINE VARIABLE fi-cod-depos-acabado AS CHARACTER FORMAT "X(3)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-localiz-acabado AS CHARACTER FORMAT "X(20)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-refer-acabado AS CHARACTER FORMAT "X(8)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dep-reciclado AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dt-validade-lote-acabado AS DATE FORMAT "99/99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estado AS CHARACTER FORMAT "X(30)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE fi-lote-serie-acabado AS CHARACTER FORMAT "X(40)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE fi-per-ppm-acabado AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL ? 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 6.46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     fi-cod-depos-acabado AT ROW 1.25 COL 29 COLON-ALIGNED
     fi-dep-reciclado AT ROW 1.25 COL 69.14 COLON-ALIGNED
     fi-cod-localiz-acabado AT ROW 2.33 COL 29 COLON-ALIGNED
     fi-cod-refer-acabado AT ROW 3.42 COL 29 COLON-ALIGNED
     fi-lote-serie-acabado AT ROW 4.5 COL 29 COLON-ALIGNED
     fi-dt-validade-lote-acabado AT ROW 5.58 COL 29 COLON-ALIGNED
     fi-estado AT ROW 5.58 COL 59 COLON-ALIGNED
     fi-per-ppm-acabado AT ROW 6.25 COL 29 COLON-ALIGNED
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.ord-prod
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
         HEIGHT             = 6.54
         WIDTH              = 86.29.
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

/* SETTINGS FOR FILL-IN fi-cod-depos-acabado IN FRAME f-main
   NO-ENABLE 3 4                                                        */
/* SETTINGS FOR FILL-IN fi-cod-localiz-acabado IN FRAME f-main
   NO-ENABLE 4                                                          */
/* SETTINGS FOR FILL-IN fi-cod-refer-acabado IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN fi-dep-reciclado IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fi-dep-reciclado:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN fi-dt-validade-lote-acabado IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN fi-estado IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-lote-serie-acabado IN FRAME f-main
   NO-ENABLE 3 4                                                        */
/* SETTINGS FOR FILL-IN fi-per-ppm-acabado IN FRAME f-main
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

&Scoped-define SELF-NAME fi-cod-depos-acabado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos-acabado V-table-Win
ON F5 OF fi-cod-depos-acabado IN FRAME f-main
DO:
   {include/zoomvar.i &prog-zoom = "inzoom/z01in084.w"
                     &campo     = fi-cod-depos-acabado
                     &campozoom = cod-depos   }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos-acabado V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-depos-acabado IN FRAME f-main
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-localiz-acabado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-localiz-acabado V-table-Win
ON F5 OF fi-cod-localiz-acabado IN FRAME f-main
DO:
   {include/zoomvar.i &prog-zoom = "inzoom/z01in189.w"
                      &campo     = fi-cod-localiz-acabado
                      &campozoom = cod-localiz   }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-localiz-acabado V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-localiz-acabado IN FRAME f-main
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-refer-acabado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-refer-acabado V-table-Win
ON F5 OF fi-cod-refer-acabado IN FRAME f-main
DO:
  {include/zoomvar.i &prog-zoom=inzoom/z01in375.w
                    &campo=fi-cod-refer-acabado
                    &campozoom = cod-refer
                    &parametros= "run pi-seta-inicial in wh-pesquisa
                    (input item.it-codigo)." }.       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-refer-acabado V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-refer-acabado IN FRAME f-main
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-dep-reciclado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-dep-reciclado V-table-Win
ON F5 OF fi-dep-reciclado IN FRAME f-main
DO:
   {include/zoomvar.i &prog-zoom = "inzoom/z01in084.w"
                     &campo     = fi-dep-reciclado
                     &campozoom = cod-depos   }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-dep-reciclado V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-dep-reciclado IN FRAME f-main
DO:
     apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-dt-validade-lote-acabado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-dt-validade-lote-acabado V-table-Win
ON ENTRY OF fi-dt-validade-lote-acabado IN FRAME f-main
DO:
    /* Chamada UPC solicitada pela Fras-le */
    RUN pi-upc (INPUT "Vali-lote",
                INPUT "Vali-lote",
                INPUT ?,
                INPUT ?,
                INPUT "ord-prod",
                INPUT ROWID(ord-prod)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-lote-serie-acabado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-lote-serie-acabado V-table-Win
ON ENTRY OF fi-lote-serie-acabado IN FRAME f-main
DO:
    /* Chamada UPC solicitada pela Fras-le */
    RUN pi-upc (INPUT "Antes-lote-serie",
                INPUT "Antes-lote-serie",
                INPUT ?,
                INPUT ?,
                INPUT "ord-prod",
                INPUT ROWID(ord-prod)).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-lote-serie-acabado V-table-Win
ON LEAVE OF fi-lote-serie-acabado IN FRAME f-main
DO:
   if item.tipo-con-est = 3 or item.tipo-con-est = 4 then do:
      find first saldo-estoq use-index lote where 
                 saldo-estoq.lote      = input frame {&frame-name} fi-lote-serie-acabado and
                 saldo-estoq.it-codigo = item.it-codigo
                 no-lock no-error.         

      if not avail(saldo-estoq) then do:
         assign fi-dt-validade-lote-acabado:sensitive = yes
              &IF DEFINED (bf_man_per_ppm) &THEN
                fi-per-ppm-acabado:sensitive          = yes
              &ENDIF
                .

         &if '{&bf_lote_avancado_liberado}' = 'yes' &then
            assign fi-estado:visible = no.
         &endif

      end.
      else do:
         assign  fi-dt-validade-lote-acabado:sensitive    = no
                 fi-dt-validade-lote-acabado:screen-value = string(saldo-estoq.dt-vali-lote)
               &IF DEFINED (bf_man_per_ppm) &THEN
                 fi-per-ppm-acabado:sensitive             = no
                 fi-per-ppm-acabado:screen-value          = string(saldo-estoq.per-ppm)
               &ENDIF
                 .

       &if '{&bf_lote_avancado_liberado}' = 'yes' &then   
         if l-lote-avancado then do:
    
             run pi-identifica-saldo in h-ceapi030 (input 0,
                                                    input saldo-estoq.it-codigo,
                                                    input saldo-estoq.cod-estabel,
                                                    input input frame {&frame-name} fi-lote-serie-acabado,
                                                    input 0,
                                                    output l-retorno,
                                                    output table tt-valores2,
                                                    output table tt-erro).
             if return-value = "ok":u then do:
                 find first tt-valores2 no-lock no-error.
                 if avail tt-valores2 then do:
                     assign fi-estado:screen-value = tt-valores2.des-estado
                            fi-estado:visible      = yes.
                 end.
             end.

         end.

         if not l-lote-avancado or
            return-value <> "ok":u then
             assign fi-estado:visible = no.
       &endif
       
      end.     
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


  /************************ INTERNAL PROCEDURES ********************/
  
{utp/ut-field.i mgind deposito cod-depos 1}
assign fi-cod-depos-acabado:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind localizacao cod-localiz 1}
assign fi-cod-localiz-acabado:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind ord-prod lote-serie 1}
assign fi-lote-serie-acabado:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind ord-prod cod-refer 1}
assign fi-cod-refer-acabado:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind lote dt-validade 1}
assign fi-dt-validade-lote-acabado:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Dep_Reciclado L}
assign fi-dep-reciclado:label in frame {&frame-name} = return-value.


if fi-cod-depos-acabado:load-mouse-pointer("image/lupa.cur")   then.
if fi-cod-localiz-acabado:load-mouse-pointer("image/lupa.cur") then.
if fi-cod-refer-acabado:load-mouse-pointer("image/lupa.cur")   then.
if fi-dep-reciclado:load-mouse-pointer("image/lupa.cur")   then.




&IF DEFINED(bf_man_206b) &THEN

    ASSIGN l-usa-unid-negoc = FALSE.

    IF CAN-FIND (FIRST funcao
                 WHERE funcao.cd-funcao = "EMS2-UNIDADE-NEGOCIO"
                 AND   funcao.ativo     = TRUE) THEN DO:

        ASSIGN l-usa-unid-negoc = TRUE.

    END.

&ENDIF

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
  {src/adm/template/row-list.i "ord-prod"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ord-prod"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  &if '{&bf_lote_avancado_liberado}' = 'yes' &then
    if valid-handle(h-ceapi030) then
        delete procedure h-ceapi030.
  &endif

  /* Code placed here will execute AFTER standard behavior.    */
  &IF DEFINED(bf_man_206b) &THEN
  
      IF l-usa-unid-negoc THEN DO:

          IF VALID-HANDLE(h-cdapi024) THEN DO:
              DELETE PROCEDURE h-cdapi024.
              ASSIGN h-cdapi024 = ?.
          END.

      END.

  &ENDIF

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

  /* Dispatch standard ADM method.                             */
 /* RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .*/

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

  &if '{&bf_lote_avancado_liberado}' = 'yes' &then
    if not valid-handle(h-ceapi030) then
        run cep/ceapi030.p persistent set h-ceapi030 (input table tt-dados-fda,
                                                      output table tt-valores,
                                                      output table tt-erro).

    if can-find(funcao where funcao.cd-funcao = "lote-avancado":u and
                             funcao.ativo) then
        assign l-lote-avancado = yes.    
  &endif
  
  assign fi-estado:visible in frame {&frame-name} = no.

  /* Code placed here will execute AFTER standard behavior.    */

  find first param-global no-lock no-error.  
  if  param-global.modulo-ce then do:
     find first param-estoq no-lock no-error.
     find first param-cq    no-lock no-error.     
  end.
  find first param-cp no-lock no-error.

  assign fi-per-ppm-acabado:visible in frame {&frame-name} = false.

  &IF DEFINED(bf_man_206b) &THEN
  
      IF l-usa-unid-negoc THEN DO:

          RUN cdp/cdapi024.p PERSISTENT SET h-cdapi024.

      END.

  &ENDIF
  
    &IF DEFINED (bf_man_204) &THEN
       
     ASSIGN i-fnc-pf = can-find (first funcao 
                                    where funcao.cd-funcao = "spp-dep-refugo" 
                                      and funcao.ativo     = yes).      

   
 
   &endif

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-apply-entry V-table-Win 
PROCEDURE pi-apply-entry :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def var c-tipo       as char init "Fill-in,Radio-set,Combo-box,Editor,Selection-List,Toggle-box,Slider".
    def var wh-frame     as handle  no-undo.
    def var i-pag-viewer as integer no-undo.
    def var i-pag-atual  as integer no-undo.
    def var c-campo      as char    no-undo.

    RUN get-link-handle IN adm-broker-hdl
       (INPUT  this-procedure,
        INPUT  "record-source",
        OUTPUT c-handle).

   

    assign wh-handle-viewer-principal = widget-handle (c-handle).
    run get-attribute in wh-handle-viewer-principal (input "campo" ).    
    assign c-campo = return-value.

    RUN get-attribute ("W-Page").
    assign i-pag-viewer = int(return-value).
    RUN get-attribute ("W-Container-Source").
    assign wh-container = widget-handle (return-value).
    RUN get-attribute in wh-container ("current-page").
    assign i-pag-atual = int(return-value)
           wh-frame = frame {&frame-name}:handle
           wh-frame = wh-frame:first-child
           wh-frame = wh-frame:first-child.

    do while wh-frame <> ? :
       if lookup(wh-frame:Type, c-tipo) <> 0 and
          lookup(wh-frame:name, c-campo) <> 0 then do:
          if i-pag-atual <> i-pag-viewer then
             run select-page in wh-container (string (i-pag-viewer)).
          apply 'entry' to wh-frame.
          leave.
       end.
       assign wh-frame = wh-frame:next-sibling.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desabilita-campos V-table-Win 
PROCEDURE pi-desabilita-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  clear frame {&frame-name}.
  disable {&List-4} with frame {&frame-name}.
  disable fi-cod-refer-acabado
          fi-dep-reciclado
          fi-dt-validade-lote-acabado
        &IF DEFINED (bf_man_per_ppm) &THEN
          fi-per-ppm-acabado
        &ENDIF
          with frame {&frame-name}.

  &if '{&bf_lote_avancado_liberado}' = 'yes' &then
    assign fi-estado:visible in frame {&frame-name} = no.
  &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-formata-tela V-table-Win 
PROCEDURE pi-formata-tela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&IF DEFINED (bf_man_per_ppm) &THEN

    def input param p-tipo-tela    as int no-undo. /* 1- Normal, 2- Fator de Concentraá∆o */
    def input param p-tipo-formula as int no-undo. /* 0- quando o p-tipo-tela for 1,
                                                      2- Concentraá∆o, quando p-tipo-tela for 2,
                                                      3- PPM, quando p-tipo-tela for 2 */

    if i-old-tipo-tela <> p-tipo-tela then do:

        case p-tipo-tela:

            when 1 then
                assign fi-cod-localiz-acabado:row      in frame {&frame-name} = 2.33
                       h-label                                                = fi-cod-localiz-acabado:side-label-handle
                       h-label:row                                            = 2.33
                       fi-cod-refer-acabado:row        in frame {&frame-name} = 3.42
                       h-label                                                = fi-cod-refer-acabado:side-label-handle
                       h-label:row                                            = 3.42
                       fi-lote-serie-acabado:row       in frame {&frame-name} = 4.50
                       h-label                                                = fi-lote-serie-acabado:side-label-handle
                       h-label:row                                            = 4.50
                       fi-dt-validade-lote-acabado:row in frame {&frame-name} = 5.58
                       h-label                                                = fi-dt-validade-lote-acabado:side-label-handle
                       h-label:row                                            = 5.58
                       fi-per-ppm-acabado:hidden       in frame {&frame-name} = true no-error.

            when 2 then
                assign fi-cod-localiz-acabado:row      in frame {&frame-name} = 2.25
                       h-label                                                = fi-cod-localiz-acabado:side-label-handle
                       h-label:row                                            = 2.25
                       fi-cod-refer-acabado:row        in frame {&frame-name} = 3.25
                       h-label                                                = fi-cod-refer-acabado:side-label-handle
                       h-label:row                                            = 3.25
                       fi-lote-serie-acabado:row       in frame {&frame-name} = 4.25
                       h-label                                                = fi-lote-serie-acabado:side-label-handle
                       h-label:row                                            = 4.25
                       fi-dt-validade-lote-acabado:row in frame {&frame-name} = 5.25
                       h-label                                                = fi-dt-validade-lote-acabado:side-label-handle
                       h-label:row                                            = 5.25
                       fi-per-ppm-acabado:hidden       in frame {&frame-name} = false no-error.

        end case.

    end.

    if p-tipo-formula <> 0 then do:
        assign fi-per-ppm-acabado:label  in frame {&frame-name} = if p-tipo-formula = 2 then {ininc/i25in172.i 04 02} + "(%)":u
                                                                                        else {ininc/i25in172.i 04 03}
               fi-per-ppm-acabado:format in frame {&frame-name} = if p-tipo-formula = 2 then ">>9.9999":u
                                                                                        else ">>>>,>>9.9999":u.
    end.

    assign i-old-tipo-tela = p-tipo-tela.

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grava-arquivos V-table-Win 
PROCEDURE pi-grava-arquivos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Chamada EPC para a assign record */
     {include/i-epc003.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-campos V-table-Win 
PROCEDURE pi-habilita-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   

    DEFINE VARIABLE c-cod-estabel   AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE c-unid-negoc    AS CHARACTER    NO-UNDO.

  &if '{&bf_lote_avancado_liberado}' = 'yes' &then
    def var c-handle   as char   no-undo.
    def var i-cont     as int    no-undo.
    def var h_v44in271 as handle no-undo.
  &endif

   RUN get-link-handle IN adm-broker-hdl
      (INPUT this-procedure,
       INPUT "record-source",
       OUTPUT c-handle).

   run get-attribute in widget-handle (c-handle) (input "rw-oper").
   

   ASSIGN fi-dep-reciclado:SENSITIVE IN FRAME {&FRAME-NAME} = i-fnc-pf.      

   find oper-ord where
        rowid (oper-ord) = to-rowid (return-value) no-lock no-error.   

   if not avail oper-ord or
      rowid (oper-ord) = f-retorna-ult-oper (ord-prod.nr-ord-prod) then do:          
      RUN Get-Field-Screen-Value IN adm-broker-hdl
         (INPUT this-procedure,
          INPUT "it-codigo").

      find item where
           item.it-codigo = return-value no-lock no-error.                                            
      if ((item.it-codigo  <> "") and (item.it-codigo <> ?) and (item.tipo-contr <> 4)) then do:     
         clear frame {&frame-name}.
         enable {&List-4} with frame {&frame-name}.           

         FIND FIRST param-cp NO-LOCK NO-ERROR.

         IF i-fnc-pf THEN
            ASSIGN fi-dep-reciclado:SCREEN-VALUE IN FRAME {&FRAME-NAME} = substring(param-cp.char-2,1,3).


         assign fi-cod-depos-acabado:screen-value in frame {&frame-name} = ord-prod.cod-depos.

         if  param-global.modulo-cq and 
             param-cq.tipo-cq       > 0 and 
             STRING (f-item-uni-estab(item.it-codigo,
                                      ord-prod.cod-estabel,
                                      "contr-qualid":U)) = "yes":U then do:

             &if '{&bf_lote_avancado_liberado}' = 'yes' &then
                 if l-lote-avancado and 
                    item.tipo-con-est > 2 then do:
            
                     assign fi-cod-depos-acabado:screen-value = f-item-uni-estab(item.it-codigo,
                                                                                 if ord-prod.cod-estabel = '' then 
                                                                                     item.cod-estabel
                                                                                 else ord-prod.cod-estabel,
                                                                                 "deposito-pad":U).
            
                 end.
                 else
             &endif

             &IF DEFINED(bf_man_206b) &THEN
             
                 IF l-usa-unid-negoc THEN DO:

                     IF ITEM.contr-qualid THEN DO:

                         run get-field-screen-value in adm-broker-hdl (INPUT this-procedure, INPUT "c-unid-negoc").
                         ASSIGN c-unid-negoc = RETURN-VALUE.

                         run get-field-screen-value in adm-broker-hdl (INPUT this-procedure, INPUT "cod-estabel").
                         ASSIGN c-cod-estabel = RETURN-VALUE.

                         FIND unid-negoc-cq 
                             WHERE unid-negoc-cq.cod-estab      = c-cod-estabel
                             AND   unid-negoc-cq.cod-unid-negoc = c-unid-negoc NO-LOCK NO-ERROR.

                         IF AVAIL unid-negoc-cq THEN DO:

                             ASSIGN fi-cod-depos-acabado:SCREEN-VALUE IN FRAME {&FRAME-NAME} = unid-negoc-cq.cod-depos-cq.

                         END.
                         ELSE DO:

                             FIND estabelec WHERE estabelec.cod-estabel = c-cod-estabel NO-LOCK NO-ERROR.
                             IF AVAIL estabelec THEN DO:

                                 ASSIGN fi-cod-depos-acabado:SCREEN-VALUE IN FRAME {&FRAME-NAME} = estabelec.deposito-cq.

                             END.

                         END.
          
                     END.
          
                 END.
                 ELSE DO:

                     find first estabelec where estabelec.cod-estabel = ord-prod.cod-estabel no-lock no-error.
                     if avail(estabelec) then 
                         assign fi-cod-depos-acabado:screen-value in frame {&frame-name} = estabelec.deposito-cq.

                 END.

             &ELSE
             
                 find first estabelec where estabelec.cod-estabel = ord-prod.cod-estabel no-lock no-error.
                 if avail(estabelec) then 
                     assign fi-cod-depos-acabado:screen-value in frame {&frame-name} = estabelec.deposito-cq.
    
             &ENDIF

         end.           
         
         assign fi-cod-refer-acabado:sensitive      in frame {&frame-name} = (item.tipo-con-est = 4)      
                fi-cod-refer-acabado:screen-value   in frame {&frame-name} = if item.tipo-con-est = 4 
                                                                             then ord-prod.cod-refer
                                                                             ELSE ""
                fi-cod-localiz-acabado:sensitive                           = not(item.loc-unica).
         ASSIGN fi-cod-localiz-acabado:screen-value = f-item-uni-estab (input item.it-codigo,
                                                                        input ord-prod.cod-estabel,
                                                                        "cod-localiz").
         if item.tipo-con-est <> 1 then do:
              &if '{&bf_lote_avancado_liberado}' = 'yes' &then
                     
                   if l-lote-avancado then do:

                       empty temp-table tt-dados-fda.
                       empty temp-table tt-valores.
                       empty temp-table tt-erro.

                       if not valid-handle(h-ceapi030) then
                           run cep/ceapi030.p persistent set h-ceapi030 (input table tt-dados-fda,
                                                                         output table tt-valores,
                                                                         output table tt-erro).

                       create tt-dados-fda.
                       assign tt-dados-fda.cod-estabel     = ord-prod.cod-estabel
                              tt-dados-fda.it-codigo       = ord-prod.it-codigo
                              tt-dados-fda.cod-refer       = ord-prod.cod-refer
                              tt-dados-fda.cod-modul-dtsul = "MCP"
                              tt-dados-fda.cod-usuario     = c-seg-usuario
                              tt-dados-fda.cod-depos       = fi-cod-depos-acabado:screen-value in frame {&frame-name}
                              tt-dados-fda.cod-localiz     = fi-cod-localiz-acabado:screen-value in frame {&frame-name}
                              tt-dados-fda.fm-codigo       = item.fm-codigo
                              tt-dados-fda.nr-ord-produ    = ord-prod.nr-ord-produ.

                       run pi-executar in h-ceapi030 (input table tt-dados-fda,
                                                      output table tt-valores,
                                                      output table tt-erro).
                       if return-value = 'ok':u then do:

                           find first tt-valores no-lock no-error.
    
                           run pi-param-esp in h-ceapi030 (input ord-prod.it-codigo,
                                                           input "",
                                                           input ord-prod.cod-estabel,
                                                           output l-sugere-lote,
                                                           output l-amostra,
                                                           output i-tp-amostra).
                           if l-sugere-lote and
                              avail tt-valores and
                              tt-valores.lote <> "" then do:
                               assign fi-lote-serie-acabado:screen-value in frame {&frame-name} = tt-valores.lote.
                           end.
                       end.
                       else do:
                           run cdp/cd0666.w (input table tt-erro).
                           empty temp-table tt-erro.
                       end.
                   end.
                   else

               &endif

               if ord-prod.lote-serie = "" 
               THEN DO:                   
                   /* Facchini */
                   IF can-find (first funcao
                                where funcao.cd-funcao = "cpp-lote-unico":U
                                  and funcao.ativo) then do:
                        assign fi-lote-serie-acabado:screen-value in frame {&frame-name} = ord-prod.cod-refer.
                   END.
                   ELSE DO:
                       assign fi-lote-serie-acabado:screen-value in frame {&frame-name} = ord-prod.cod-estabel + "." + FILL("0",6 - LENGTH(ord-prod.nr-ord-prod)) + string(ord-prod.nr-ord-produ).
                   END.
               END.
                else
                  assign fi-lote-serie-acabado:screen-value in frame {&frame-name} =
                                               ord-prod.lote-serie.  

               find first saldo-estoq use-index lote where 
                    saldo-estoq.lote      = fi-lote-serie-acabado:screen-value and
                    saldo-estoq.it-codigo = item.it-codigo
                    no-lock no-error.       
              if avail(saldo-estoq) THEN DO:
                  assign fi-dt-validade-lote-acabado:screen-value = string(saldo-estoq.dt-vali-lote)
                         fi-dt-validade-lote-acabado:sensitive    = no
                       &IF DEFINED (bf_man_per_ppm) &THEN
                         fi-per-ppm-acabado:screen-value          = string(saldo-estoq.per-ppm)
                         fi-per-ppm-acabado:sensitive             = no
                       &ENDIF
                         .

                &if '{&bf_lote_avancado_liberado}' = 'yes' &then
                  if l-lote-avancado then do:
                      run pi-identifica-saldo in h-ceapi030 (input 0,
                                                             input saldo-estoq.it-codigo,
                                                             input saldo-estoq.cod-estabel,
                                                             input input frame {&frame-name} fi-lote-serie-acabado,
                                                             input 0,
                                                             output l-retorno,
                                                             output table tt-valores2,
                                                             output table tt-erro).
                      if return-value = "ok":u then do:
                          find first tt-valores2 no-lock no-error.
                          if avail tt-valores2 then
                              assign fi-estado:screen-value = tt-valores2.des-estado.
    
                          if not fi-estado:visible then do:
    
                              assign fi-estado:visible = yes.
                              run get-attribute ("W-Container-Source").
                              assign wh-container = widget-handle (return-value).
    
                              /* reposicionar no folder 1 */
                              run select-page in wh-container (2).
                              run select-page in wh-container (1).
    
                              /* entrar no campo de qtidade */
                              run who-is-the-container in adm-broker-hdl (input this-procedure, output c-handle).
                              assign h-handle = widget-handle(c-handle).
                            
                              run get-link-handle in adm-broker-hdl (input  h-handle, 
                                                                     input  "container-target":U,
                                                                     output c-handle).
                              do i-cont = 1 to num-entries(c-handle):
                                  assign h_v44in271 = widget-handle(entry(i-cont,c-handle)).
                                  if h_v44in271:file-name = "invwr/v44in271.w":u then do:
                                      run pi-entry-qtd in h_v44in271.
                                      leave.                        
                                  end.
                              end.
                          end.
                        
                      end.
                  END.
                &endif

              END.
               else DO:
                   /* Facchini */
                   IF can-find (first funcao
                                where funcao.cd-funcao = "cpp-lote-unico":U
                                  and funcao.ativo) then do:
                        assign fi-dt-validade-lote-acabado:screen-value in frame {&frame-name} = string(12/31/9999).
                   END.
                   ELSE DO:

                       &if '{&bf_lote_avancado_liberado}' = 'yes' &then
                       
                         if l-lote-avancado then do:

                             find first tt-valores no-lock no-error.
                             if avail tt-valores and 
                                tt-valores.dt-val <> ? then
                                 assign fi-dt-validade-lote-acabado:screen-value = string(tt-valores.dt-val)
                                        fi-dt-validade-lote-acabado:sensitive    = yes.

                         end.

                         if not l-lote-avancado or
                            not avail tt-valores then 
                       &endif
                       
                       assign fi-dt-validade-lote-acabado:screen-value = ""
                              fi-dt-validade-lote-acabado:sensitive    = yes
                            &IF DEFINED (bf_man_per_ppm) &THEN
                              fi-per-ppm-acabado:screen-value          = string(item.per-ppm)
                              fi-per-ppm-acabado:sensitive             = yes
                            &ENDIF
                              .
                   END.
               END.
         end.                                
         else 
            assign fi-dt-validade-lote-acabado:sensitive = no
                   fi-lote-serie-acabado:sensitive       = no
                   fi-cod-refer-acabado:sensitive        = no.                                                  
      end.                                
      else run pi-desabilita-campos.
   end.
   else run pi-desabilita-campos.

  

    ASSIGN c-dep-acab-anterior = INPUT FRAME {&FRAME-NAME} fi-cod-depos-acabado.

    /* Chamada UPC solicitada pela ACO */
    RUN pi-upc (INPUT "Fim-habilita-campos",
                INPUT "Fim-habilita-campos",
                INPUT ?,
                INPUT ?,
                INPUT "ord-prod",
                INPUT ROWID(ord-prod)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-handle V-table-Win 
PROCEDURE pi-recebe-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN Who-Is-The-Container IN adm-broker-hdl
    (INPUT  this-procedure,
     OUTPUT c-handle).

run get-attribute in widget-handle (c-handle) (input 'HANDLE').

assign h-handle = widget-handle (return-value).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-campo V-table-Win 
PROCEDURE pi-retorna-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter c-campo as char.
def output parameter c-valor-campo as char.

case c-campo:
    when "fi-dt-validade-lote-acabado":u then assign c-valor-campo = input frame {&frame-name} fi-dt-validade-lote-acabado.
    when "fi-lote-serie-acabado":u  then assign c-valor-campo = input frame {&frame-name} fi-lote-serie-acabado.
    when "fi-dep-reciclado":u  then assign c-valor-campo = input frame {&frame-name} fi-dep-reciclado.
  &IF DEFINED (bf_man_per_ppm) &THEN
    when "fi-per-ppm-acabado":u then assign c-valor-campo = fi-per-ppm-acabado:screen-value in frame {&frame-name}.
  &ENDIF
end.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-upc V-table-Win 
PROCEDURE pi-upc :
/**********************************************************************
** UPC Especifica
** Podem ser passados parametros para ela afim de reutilizar o codigo
** se houver necessidade.
**********************************************************************/ 
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

    ASSIGN THIS-PROCEDURE:PRIVATE-DATA = THIS-PROCEDURE:FILE-NAME.    

    /* DPC */
    if  c-nom-prog-dpc-mg97 <> ""
    and c-nom-prog-dpc-mg97 <> ? then do:

        run value(c-nom-prog-dpc-mg97) (input p-ind-event,
                                        input p-ind-object,
                                        input THIS-PROCEDURE,
                                        input FRAME f-main:HANDLE,
                                        input p-cod-table,
                                        input p-row-table).

    end.

    /* APPC */
    if  c-nom-prog-appc-mg97 <> ""
    and c-nom-prog-appc-mg97 <> ? then do:

        run value(c-nom-prog-appc-mg97) (input p-ind-event,
                                         input p-ind-object,
                                         input THIS-PROCEDURE,
                                         input FRAME f-main:HANDLE,
                                         input p-cod-table,
                                         input p-row-table).

    end.

    /* UPC */
    if  c-nom-prog-upc-mg97 <> ""
    and c-nom-prog-upc-mg97 <> ? then do:
        run value(c-nom-prog-upc-mg97) (input p-ind-event,
                                        input p-ind-object,
                                        input THIS-PROCEDURE,
                                        input FRAME f-main:HANDLE,
                                        input p-cod-table,
                                        input p-row-table).
    end.

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
    
    /* Chamada EPC para a pi-validate */
    {include/i-epc002.i}  


    DEFINE VARIABLE c-unid-negoc    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-it-codigo     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-cod-estabel   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-unid-achada   AS CHARACTER  NO-UNDO.

    
    &IF DEFINED(bf_man_206b) &THEN
    
        IF l-usa-unid-negoc AND
           c-dep-acab-anterior <> INPUT FRAME {&frame-name} fi-cod-depos-acabado AND 
           (ord-prod.nome-abrev   = "" AND 
            ord-prod.nr-pedido    = ""  AND 
            ord-prod.nr-sequencia = 0) THEN DO:

                
            run get-field-screen-value in adm-broker-hdl (INPUT this-procedure, INPUT "c-unid-negoc").
            ASSIGN c-unid-negoc = RETURN-VALUE.

            run get-field-screen-value in adm-broker-hdl (INPUT this-procedure, INPUT "it-codigo").
            ASSIGN c-it-codigo = RETURN-VALUE.

            run get-field-screen-value in adm-broker-hdl (INPUT this-procedure, INPUT "cod-estabel").
            ASSIGN c-cod-estabel = RETURN-VALUE.

            RUN retornaUnidadeNegocio IN h-cdapi024 (INPUT c-cod-estabel,
                                                     INPUT c-it-codigo,
                                                     INPUT INPUT FRAME {&FRAME-NAME} fi-cod-depos-acabado,
                                                     OUTPUT c-unid-achada).

            IF  c-unid-achada   <>  c-unid-negoc    THEN DO:
                IF  CAN-FIND    (   FIRST   unid-negoc-depos
                                    WHERE   unid-negoc-depos.it-codigo      =   c-it-codigo
                                    AND     unid-negoc-depos.cod-estab      =   c-cod-estabel
                                    AND     unid-negoc-depos.cod-depos      =   INPUT FRAME {&FRAME-NAME} fi-cod-depos-acabado
                                    AND     unid-negoc-depos.cod-unid-negoc =   c-unid-achada)  THEN    
                    RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 31379, INPUT '').
                ELSE
                    RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 31197, INPUT c-cod-estabel + '~~' + c-it-codigo + ' (CD0140)').

                RETURN "ADM-ERROR":U.

            END.

        END.

    &ENDIF


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
  {src/adm/template/snd-list.i "ord-prod"}

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

  ASSIGN fi-dep-reciclado:VISIBLE IN FRAME {&FRAME-NAME} = i-fnc-pf.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

