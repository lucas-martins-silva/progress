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
{include/i-prgvrs.i V70IN172 2.00.00.015}  /*** 010015 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v70in172 MUT}
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

{include/i-vrtab.i item}
{include/i-vrtab.i tab-unidade}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var de-total-consumo as decimal format "->>>>,>>>,>>9.9999" init 0 no-undo.
def var de-giro-estoq    as decimal format "->>>>,>>>,>>9.9999" init 0 no-undo.
def var i-cont           as integer format "99"                 init 0 no-undo.
def var i-mes-per        as integer format "99"                 init 1 no-undo.
def var i-dia            as integer format "99"      no-undo.
def var i-mes            as integer format "99"      no-undo.
def var i-ano            as integer format "9999"    no-undo.
def var c-item           like item.it-codigo         no-undo.
def var c-desc-item      as char    format "x(36)"   no-undo.
def var c-per-pesq       as char    format "9999/99" no-undo.
def var c-jan            as char    format "x(03)"   no-undo.
def var c-fev            as char    format "x(03)"   no-undo.
def var c-mar            as char    format "x(03)"   no-undo.
def var c-abr            as char    format "x(03)"   no-undo.
def var c-mai            as char    format "x(03)"   no-undo.
def var c-jun            as char    format "x(03)"   no-undo.
def var c-jul            as char    format "x(03)"   no-undo.
def var c-ago            as char    format "x(03)"   no-undo.
def var c-set            as char    format "x(03)"   no-undo.
def var c-out            as char    format "x(03)"   no-undo.
def var c-nov            as char    format "x(03)"   no-undo.
def var c-dez            as char    format "x(03)"   no-undo.
def var c-tab-meses      as char    no-undo.
def var c-tabela         as char    no-undo.
def var c-tit-graf       as char    no-undo.
def var c-tit-x          as char    no-undo.
def var c-tit-y          as char    no-undo.
def var r-registro       as rowid   no-undo.
def var da-data          as date    no-undo.

{utp/utapi001.i}

def var i-empresa like param-global.empresa-prin no-undo.

{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}

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
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS item.it-codigo item.baixa-estoq item.un ~
item.consumo-prev item.consumo-aad item.fator-refugo 
&Scoped-Define DISPLAYED-OBJECTS c-descricao c-desc-un c-compr-fabric ~
c-tipo-con-est c-tipo-contr c-cod-obsoleto c-politica c-tipo-requis ~
c-perm-saldo-neg 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS item.it-codigo 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
it-codigo|y|y|mgind.item.it-codigo
cd-planejado|y|y|mgind.item.cd-planejado
class-fiscal||y|mgind.item.class-fiscal
cod-comprado||y|mgind.item.cod-comprado
fm-codigo||y|mgind.item.fm-codigo
ge-codigo||y|mgind.item.ge-codigo
nr-linha||y|mgind.item.nr-linha
nat-despesa||y|mgind.item.nat-despesa
cod-refer||y|mgind.item.cod-refer
un||y|mgind.item.un
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "it-codigo,cd-planejado",
     Keys-Supplied = "it-codigo,cd-planejado,class-fiscal,cod-comprado,fm-codigo,ge-codigo,nr-linha,nat-despesa,cod-refer,un"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-cod-obsoleto AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-compr-fabric AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-un AS CHARACTER FORMAT "x(15)" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY .88 NO-UNDO.

DEFINE VARIABLE c-perm-saldo-neg AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-politica AS CHARACTER FORMAT "X(22)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-tipo-con-est AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-tipo-contr AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-tipo-requis AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88 BY 12.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item.it-codigo AT ROW 1.17 COL 7 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-descricao AT ROW 1.17 COL 24.86 COLON-ALIGNED NO-LABEL
     item.baixa-estoq AT ROW 2.75 COL 38
          VIEW-AS TOGGLE-BOX
          SIZE 20.14 BY .88
     item.un AT ROW 3.75 COL 36 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     c-desc-un AT ROW 3.75 COL 41.86 COLON-ALIGNED NO-LABEL
     c-compr-fabric AT ROW 4.75 COL 36 COLON-ALIGNED
     item.consumo-prev AT ROW 5.75 COL 36 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     item.consumo-aad AT ROW 6.75 COL 36 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     item.fator-refugo AT ROW 7.75 COL 36 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-tipo-con-est AT ROW 8.75 COL 36 COLON-ALIGNED
     c-tipo-contr AT ROW 9.75 COL 36 COLON-ALIGNED
     c-cod-obsoleto AT ROW 10.75 COL 36 COLON-ALIGNED
     c-politica AT ROW 11.75 COL 36 COLON-ALIGNED
     c-tipo-requis AT ROW 12.75 COL 36 COLON-ALIGNED
     c-perm-saldo-neg AT ROW 13.75 COL 36 COLON-ALIGNED
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
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
         HEIGHT             = 14
         WIDTH              = 88.
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

/* SETTINGS FOR TOGGLE-BOX item.baixa-estoq IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-obsoleto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-compr-fabric IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-perm-saldo-neg IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-politica IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tipo-con-est IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tipo-contr IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tipo-requis IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.consumo-aad IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.consumo-prev IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.fator-refugo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.it-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN item.un IN FRAME f-main
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



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

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
    WHEN 'it-codigo':U THEN
       {src/adm/template/find-tbl.i
           &TABLE = item
           &WHERE = "WHERE item.it-codigo eq key-value"
       }
    WHEN 'cd-planejado':U THEN
       {src/adm/template/find-tbl.i
           &TABLE = item
           &WHERE = "WHERE item.cd-planejado eq key-value"
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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if  avail item then do with frame {&frame-name}:
      {utp/ut-field.i mgind item politica 1}
      assign c-politica:label = trim(return-value).
      {utp/ut-field.i mgind item cod-obsoleto 1}
      assign c-cod-obsoleto:label = trim(return-value).
      {utp/ut-field.i mgind item tipo-con-est 1}
      assign c-tipo-con-est:label = trim(return-value).
      {utp/ut-field.i mgind item tipo-contr 1}
      assign c-tipo-contr:label = trim(return-value).
      {utp/ut-field.i mgind item compr-fabric 1}
      assign c-compr-fabric:label = trim(return-value).
      {utp/ut-field.i mgind item tipo-requis 1}
      assign c-tipo-requis:label = trim(return-value).
      {utp/ut-field.i mgind item perm-saldo-neg 1}
      assign c-perm-saldo-neg:label = trim(return-value).

      assign c-politica:screen-value       = {ininc/i04in122.i 04 item.politica}
             c-cod-obsoleto:screen-value   = {ininc/i17in172.i 04 item.cod-obsoleto}
             c-tipo-con-est:screen-value   = {ininc/i01in122.i 04 item.tipo-con-est}
             c-tipo-contr:screen-value     = {ininc/i09in122.i 04 item.tipo-contr}
             c-compr-fabric:screen-value   = {ininc/i01in172.i 04 item.compr-fabric}
             c-tipo-requis:screen-value    = {ininc/i08in122.i 04 item.tipo-requis}
             c-perm-saldo-neg:screen-value = {ininc/i11in122.i 04 item.perm-saldo-neg}
             c-descricao                   = item.desc-item.
      disp c-descricao with frame {&frame-name}.
  end.
  else
      assign c-politica:screen-value       = {ininc/i04in122.i 04 1}
             c-cod-obsoleto:screen-value   = {ininc/i17in172.i 04 1}
             c-tipo-con-est:screen-value   = {ininc/i01in122.i 04 1}
             c-tipo-contr:screen-value     = {ininc/i09in122.i 04 1}
             c-compr-fabric:screen-value   = {ininc/i01in172.i 04 1}
             c-tipo-requis:screen-value    = {ininc/i08in122.i 04 1}
             c-perm-saldo-neg:screen-value = {ininc/i11in122.i 04 1}.

  find tab-unidade where tab-unidade.un = item.un no-lock no-error.
  if  avail tab-unidade then do:
      assign c-desc-un = tab-unidade.descricao.
      disp c-desc-un with frame {&frame-name}.
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
  find first param-global no-lock no-error.
  find first param-estoq no-lock no-error.
  
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

  if avail item then assign gr-item = rowid(item).

  find tab-unidade where tab-unidade.un = item.un no-lock no-error.
  if avail tab-unidade then
     assign gr-tab-unidade = rowid(tab-unidade).

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
  
  /* Ponha aqui a valida‡Æo de chave duplicada */
  
  /* Ponha aqui as demais valida‡äes */
  
  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-grafico V-table-Win 
PROCEDURE pi-gera-grafico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter c-per-ini as char format "9999/99".

    {utp/ut-liter.i Giro_de_Estoque_do_Item}
    assign c-tit-graf = trim(return-value).
    {utp/ut-liter.i Porcentagem}
    assign c-tit-y = trim(return-value).
    {utp/ut-liter.i Meses}
    assign c-tit-x = trim(return-value).

    find first tt-atributos no-lock no-error.

    create tt-atributos.
    assign tt-atributos.cod-versao-integracao = 003
           tt-atributos.numgraph              = 1
           tt-atributos.graphtype             = 4
           tt-atributos.graphtitle            = c-tit-graf + " " + item.it-codigo
           tt-atributos.lefttitle             = c-tit-y
           tt-atributos.lefttitlestyle        = 0
           tt-atributos.bottomtitle           = c-tit-x
           tt-atributos.legendpos             = 0
           tt-atributos.gridstyle             = 0
           tt-atributos.gridlinestyle         = 0.

    create tt-sets.
    assign tt-sets.numgraph = 1
           tt-sets.numset   = 1
           c-tabela         = {ininc/i01in061.i 03}
           i-ano            = int(substr(c-per-ini,1,4)) - 1
           i-mes            = int(substr(c-per-ini,5,2)) + 1
           da-data          = (if i-mes > 12
                                  then date(1,1,i-ano + 1)
                                  else date(i-mes,1,i-ano)).

    do  i-cont = 1 to 12:
        assign c-per-pesq       = string(year(da-data),"9999")+ string(month(da-data),"99")
               de-total-consumo = 0
               de-giro-estoq    = 0
               i-mes            = month(da-data).


        &if defined (bf_mat_consumo_estab) &then
        
            for each consumo-estab no-lock
                where consumo-estab.periodo   = c-per-pesq
                and   consumo-estab.it-codigo = input frame {&frame-name} item.it-codigo:
    
                assign i-empresa = param-global.empresa-prin.
    
                &if defined (bf_dis_consiste_conta) &then
    
                    find estabelec where
                         estabelec.cod-estabel = item.cod-estabel no-lock no-error.
    
                    run cdp/cd9970.p (input rowid(estabelec),
                                      output i-empresa).
                &endif
    
                find conta-contab use-index codigo where 
                     conta-contab.ep-codigo = i-empresa         and
                     conta-contab.ct-codigo = consumo-estab.ct-codigo and
                     conta-contab.sc-codigo = consumo-estab.sc-codigo no-lock no-error.
                if   avail conta-contab
                and (conta-contab.tipo = 1
                or   conta-contab.tipo = 3
                or   conta-contab.tipo = 6 ) then
                    assign de-total-consumo = de-total-consumo + consumo-estab.qt-saida.
            end.

        &ELSE 

            for each consumo no-lock
                where consumo.periodo   = c-per-pesq
                and   consumo.it-codigo = input frame {&frame-name} item.it-codigo:
    
                assign i-empresa = param-global.empresa-prin.
    
                &if defined (bf_dis_consiste_conta) &then
    
                    find estabelec where
                         estabelec.cod-estabel = item.cod-estabel no-lock no-error.
    
                    run cdp/cd9970.p (input rowid(estabelec),
                                      output i-empresa).
                &endif
    
                find conta-contab use-index codigo where 
                     conta-contab.ep-codigo = i-empresa         and
                     conta-contab.ct-codigo = consumo.ct-codigo and
                     conta-contab.sc-codigo = consumo.sc-codigo no-lock no-error.
                if   avail conta-contab
                and (conta-contab.tipo = 1
                or   conta-contab.tipo = 3
                or   conta-contab.tipo = 6 ) then
                    assign de-total-consumo = de-total-consumo + consumo.qt-saida.
            end.

        &ENDIF
        
        find first sl-it-per
            where sl-it-per.it-codigo      = item.it-codigo
            and   year(sl-it-per.periodo) = year(da-data)
            and  month(sl-it-per.periodo) = month(da-data)
            no-lock no-error.
        assign de-giro-estoq = if avail sl-it-per
                                  then (de-total-consumo * 100) / sl-it-per.saldo-medio else 0
               da-data       = da-data + 31.
        if  de-giro-estoq = ? then
            assign de-giro-estoq = 0.
        assign c-tab-meses  = entry(i-mes,c-tabela).

        create tt-points.
        assign tt-points.numgraph  = 1
               tt-points.numpoint  = i-cont
               tt-points.labeltext = c-tab-meses.

        create tt-dados.
        assign tt-dados.numgraph  = 1
               tt-dados.numpoint  = i-cont
               tt-dados.numset    = 1
               tt-dados.graphdata = de-giro-estoq.
    end.
    run utp/utapi001.p(input  table tt-atributos,
                       input  table tt-points,
                       input  table tt-sets,
                       input  table tt-dados,
                       input  table tt-ylabels,
                       output table tt-erros).
    if  return-value = "NOK" then
        for each tt-erros:
            run utp/ut-msgs.p (input "show", input tt-erros.cod-erro, input "").
        end.

    /* Elimina os registros das temp-tables */
    for each tt-dados:
        delete tt-dados.
    end.
    for each tt-atributos:
        delete tt-atributos.
    end.
    for each tt-points:
        delete tt-points.
    end.
    for each tt-sets:
        delete tt-sets.
    end.
    for each tt-erros:
        delete tt-erros.
    end.

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
  {src/adm/template/sndkycas.i "it-codigo" "item" "it-codigo"}
  {src/adm/template/sndkycas.i "cd-planejado" "item" "cd-planejado"}
  {src/adm/template/sndkycas.i "class-fiscal" "item" "class-fiscal"}
  {src/adm/template/sndkycas.i "cod-comprado" "item" "cod-comprado"}
  {src/adm/template/sndkycas.i "fm-codigo" "item" "fm-codigo"}
  {src/adm/template/sndkycas.i "ge-codigo" "item" "ge-codigo"}
  {src/adm/template/sndkycas.i "nr-linha" "item" "nr-linha"}
  {src/adm/template/sndkycas.i "nat-despesa" "item" "nat-despesa"}
  {src/adm/template/sndkycas.i "cod-refer" "item" "cod-refer"}
  {src/adm/template/sndkycas.i "un" "item" "un"}

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


