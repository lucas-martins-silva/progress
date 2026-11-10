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
{include/i-prgvrs.i V35IN122 2.00.00.011}  /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v35in122 MUT}
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
def new global shared var gr-familia as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def workfile     w-pedido
                 field nome-abrev     like ped-venda.nome-abrev
                 field nr-pedcli      like ped-venda.nr-pedcli.



def var aux-class-fiscal  like familia.class-fiscal.
def var aux-baixa-estoq   like familia.baixa-estoq.
def var aux-codigo-orig   like familia.codigo-orig.
def var aux-fator-conver  like familia.fator-conver.
def var aux-cd-trib-icm   like familia.cd-trib-icm.
def var aux-cd-trib-ipi   like familia.cd-trib-ipi.
def var aux-fraciona      like familia.fraciona.
def var aux-ind-imp-desc  like familia.ind-imp-desc.

def new shared    var  l-fiscal       as logical initial no no-undo.
def new shared    var  r-it-pre       as rowid no-undo.
def new shared    var  de-vl-bipi     like it-nota-fisc.vl-bipi-it.
def new shared    var  de-vl-preuni   like ped-item.vl-preuni.
def new shared    var  de-vl-preori   like ped-item.vl-preori.
def new shared    var  de-totipi      like ped-venda.vl-tot-ped.
def new shared    var  de-vl-mercori  like it-nota-fisc.vl-merc-ori.
          
def new shared        var  de-abevl       like ped-venda.vl-liq-abe.
def new shared        var  de-totvl       like ped-venda.vl-liq-ped.
def new shared        var  de-vl-tot-it   like ped-ent.vl-tot-it.
def new shared        var  de-vl-liq-it   like ped-ent.vl-liq-it.
def new shared        var  de-vl-merc-abe like ped-ent.vl-merc-abe.
def new shared        var  de-vl-liq-abe  like ped-ent.vl-liq-abe.
def new shared        var  de-vl-mercliq  like it-nota-fisc.vl-merc-liq.
def new shared        var  de-vlipi       like it-nota-fisc.vl-ipi-it.
def new shared        var  de-total       like ped-venda.vl-tot-ped.
def new shared        var  de-ipi-ant     like classif-fisc.aliquota-ipi. 

def new shared        var  r-item         as rowid no-undo.
def new shared        var  r-ped-it       as rowid no-undo.
def new shared        var  r-ped-en       as rowid no-undo.
def new shared        var  r-pedido       as rowid no-undo.

def                   var  i-cont         as int. 

def new shared        var  l-tot-ab       as logical                    init no  no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES familia
&Scoped-define FIRST-EXTERNAL-TABLE familia


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR familia.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS familia.codigo-orig familia.cod-taxa ~
familia.descricao familia.un familia.cod-localiz familia.deposito-pad ~
familia.cod-servico familia.fator-conver familia.loc-unica ~
familia.baixa-estoq familia.fraciona 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}codigo-orig ~{&FP2}codigo-orig ~{&FP3}~
 ~{&FP1}cod-taxa ~{&FP2}cod-taxa ~{&FP3}~
 ~{&FP1}descricao ~{&FP2}descricao ~{&FP3}~
 ~{&FP1}un ~{&FP2}un ~{&FP3}~
 ~{&FP1}cod-localiz ~{&FP2}cod-localiz ~{&FP3}~
 ~{&FP1}deposito-pad ~{&FP2}deposito-pad ~{&FP3}~
 ~{&FP1}cod-servico ~{&FP2}cod-servico ~{&FP3}~
 ~{&FP1}fator-conver ~{&FP2}fator-conver ~{&FP3}
&Scoped-define ENABLED-TABLES familia
&Scoped-define FIRST-ENABLED-TABLE familia
&Scoped-Define ENABLED-OBJECTS RECT-20 rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS familia.codigo-orig familia.cod-taxa ~
familia.fm-codigo familia.descricao familia.un familia.cod-localiz ~
familia.deposito-pad familia.cod-servico familia.fator-conver ~
familia.loc-unica familia.baixa-estoq familia.fraciona 
&Scoped-Define DISPLAYED-OBJECTS c-tax-descricao c-un-descricao ~
cb-tipo-con-est cb-ind-imp-desc 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS familia.fm-codigo cb-tipo-con-est ~
cb-ind-imp-desc 
&Scoped-define ADM-ASSIGN-FIELDS cb-tipo-con-est cb-ind-imp-desc 
&Scoped-define ADM-MODIFY-FIELDS cb-tipo-con-est cb-ind-imp-desc 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
fm-codigo|y|y|mgind.familia.fm-codigo
class-fiscal||y|mgind.familia.class-fiscal
cod-comprado||y|mgind.familia.cod-comprado
nr-linha||y|mgind.familia.nr-linha
cd-planejado||y|mgind.familia.cd-planejado
un||y|mgind.familia.un
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "fm-codigo",
     Keys-Supplied = "fm-codigo,class-fiscal,cod-comprado,nr-linha,cd-planejado,un"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE cb-ind-imp-desc AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 19.43 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-con-est AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 17.14 BY 1 NO-UNDO.

DEFINE VARIABLE c-tax-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-un-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 32.57 BY 3.25.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 55.43 BY 11.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     familia.codigo-orig AT ROW 8.88 COL 21.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3 BY .88
     c-tax-descricao AT ROW 4.71 COL 31 COLON-ALIGNED NO-LABEL
     familia.cod-taxa AT ROW 4.71 COL 21.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     familia.fm-codigo AT ROW 1.17 COL 21.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     familia.descricao AT ROW 2.71 COL 21.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 31.43 BY .88
     familia.un AT ROW 3.71 COL 21.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     c-un-descricao AT ROW 3.71 COL 27.57 COLON-ALIGNED NO-LABEL
     familia.cod-localiz AT ROW 5.71 COL 21.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .88
     cb-tipo-con-est AT ROW 6.71 COL 21.29 COLON-ALIGNED
     familia.deposito-pad AT ROW 7.83 COL 21.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     familia.cod-servico AT ROW 9.92 COL 21.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     familia.fator-conver AT ROW 10.96 COL 21.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     cb-ind-imp-desc AT ROW 12.04 COL 21.29 COLON-ALIGNED
     familia.loc-unica AT ROW 2.83 COL 61
          VIEW-AS TOGGLE-BOX
          SIZE 23 BY .75
     familia.baixa-estoq AT ROW 3.63 COL 61
          VIEW-AS TOGGLE-BOX
          SIZE 20.86 BY .75
     familia.fraciona AT ROW 4.54 COL 61
          VIEW-AS TOGGLE-BOX
          SIZE 27.43 BY .75
     RECT-20 AT ROW 2.38 COL 57
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.familia
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
         HEIGHT             = 13.08
         WIDTH              = 88.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-tax-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-ind-imp-desc IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-tipo-con-est IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN familia.fm-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
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

&Scoped-define SELF-NAME familia.cod-servico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.cod-servico V-table-Win
ON F5 OF familia.cod-servico IN FRAME f-main /* Serviáo */
DO:
  assign l-implanta = yes.  
  {include/zoom.i &prog-zoom="dizoom/z01di185.w"
                  &tabela=familia
                  &atributo=cod-servico}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.cod-servico V-table-Win
ON MOUSE-SELECT-DBLCLICK OF familia.cod-servico IN FRAME f-main /* Serviáo */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME familia.cod-taxa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.cod-taxa V-table-Win
ON F5 OF familia.cod-taxa IN FRAME f-main /* C¢digo Taxa */
DO:
  assign l-implanta = yes.

  {include/zoomvar.i &prog-zoom=dizoom/z01di217.w
                     &campo=familia.cod-taxa
                     &campozoom=cod-tax}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.cod-taxa V-table-Win
ON LEAVE OF familia.cod-taxa IN FRAME f-main /* C¢digo Taxa */
DO:
   {include/leave.i &tabela=tipo-tax
                    &atributo-ref=descricao
                    &variavel-ref=c-tax-descricao
                    &where="tipo-tax.cod-tax = input frame {&FRAME-NAME} familia.cod-taxa"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.cod-taxa V-table-Win
ON MOUSE-SELECT-DBLCLICK OF familia.cod-taxa IN FRAME f-main /* C¢digo Taxa */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME familia.un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.un V-table-Win
ON F5 OF familia.un IN FRAME f-main /* Unid Padr∆o */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom="inzoom/z01in417.w"
                  &tabela=familia
                  &atributo=un}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.un V-table-Win
ON LEAVE OF familia.un IN FRAME f-main /* Unid Padr∆o */
DO:
  {include/leave.i &tabela=tab-unidade
                   &atributo-ref=descricao
                   &variavel-ref=c-un-descricao
                   &where="tab-unidade.un = input frame {&FRAME-NAME} familia.un"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.un V-table-Win
ON MOUSE-SELECT-DBLCLICK OF familia.un IN FRAME f-main /* Unid Padr∆o */
DO:
  apply  'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  {utp/ut-field.i mgind familia tipo-con-est 1}
  assign cb-tipo-con-est:label in frame {&FRAME-NAME} = return-value.
  {utp/ut-field.i mgind familia ind-imp-desc 1}
  assign cb-ind-imp-desc:label in frame {&FRAME-NAME} = return-value.



 if  familia.un:load-mouse-pointer           ("image/lupa.cur") in frame {&FRAME-NAME} then.
 if  familia.cod-taxa:load-mouse-pointer     ("image/lupa.cur") in frame {&FRAME-NAME} then.
 if  familia.cod-servico:load-mouse-pointer  ("image/lupa.cur") in frame {&FRAME-NAME} then.

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
    WHEN 'fm-codigo':U THEN
       {src/adm/template/find-tbl.i
           &TABLE = familia
           &WHERE = "WHERE familia.fm-codigo eq key-value"
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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
  
  /* Ponha aqui a validaá∆o de chave duplicada */
  
  /* Ponha aqui as demais validaá‰es */
  
  /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
  
  /* Dispatch standard ADM method.                             */


  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

  assign familia.tipo-con-est = {ininc/i01in122.i 06 cb-tipo-con-est}.
  assign familia.ind-imp-desc = {ininc/i10in122.i 06 cb-ind-imp-desc}.

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
  if  avail familia then do with frame {&FRAME-NAME}:
      assign cb-tipo-con-est:screen-value = {ininc/i01in122.i 04 familia.tipo-con-est}.
      assign cb-ind-imp-desc:screen-value = {ininc/i10in122.i 04 familia.ind-imp-desc}.
      find tab-unidade where tab-unidade.un = familia.un no-lock no-error.
      assign c-un-descricao = if avail tab-unidade then tab-unidade.descricao else  "":U.
      find tipo-tax where tipo-tax.cod-tax = familia.cod-taxa no-lock no-error.
      assign c-tax-descricao = if avail tipo-tax then tipo-tax.descricao else  "":U.      

  end.
  else do:
      assign cb-tipo-con-est:screen-value = {ininc/i01in122.i 04 1}
             cb-ind-imp-desc:screen-value = {ininc/i10in122.i 04 1}.
  end.  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */

   
  assign aux-baixa-estoq  = input frame {&frame-name} familia.baixa-estoq
         aux-codigo-orig  = input frame {&frame-name} familia.codigo-orig
         aux-fator-conver = input frame {&frame-name} familia.fator-conver
         aux-fraciona     = input frame {&frame-name} familia.fraciona
         aux-ind-imp-desc = cb-ind-imp-desc:lookup(cb-ind-imp-desc:screen-value).
    



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
  
  find first param-global no-lock no-error. 
  if avail param-global then do:
     find first empresa where empresa.ep-codigo = param-global.empresa-prin 
          no-lock no-error.             
     find first pais where pais.nome-pais = empresa.pais no-lock no-error.
     if pais.tem-vat = yes
     or pais.tem-sales-tax = yes then do:     
/*        disable familia.cd-trib-icm with frame {&frame-name}. */
/*        disable familia.cd-trib-ipi with frame {&frame-name}. */
     end.      
  end.        
 
  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-end-update V-table-Win 
PROCEDURE local-end-update :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

 
  define buffer b-item       for item.
  define buffer b-item-2     for item.  
  define buffer b-ped-item   for ped-item.
  define var rs-exporta-item as integer no-undo.
  define var rs-exporta-ped  as integer no-undo.
  define var l-aberto        as logical no-undo.
  define var l-parcial       as logical no-undo.
  
  /*****/  
  
       
  RUN get-attribute ('ADM-ADD-RECORD').
  

 
     if familia.baixa-estoq  <> aux-baixa-estoq  or
        familia.codigo-orig  <> aux-codigo-orig  or
        familia.fator-conver <> aux-fator-conver or 
        familia.fraciona     <> aux-fraciona     or
        familia.ind-imp-desc <> aux-ind-imp-desc then
        do: 
           run ftp/ft0306a.w (output rs-exporta-item).

           if  rs-exporta-item = 3 then do:

               if  familia.baixa-estoq  <> aux-baixa-estoq  then do:
                   for each item where item.fm-codigo   = familia.fm-codigo 
                        and item.baixa-estoq = familia.baixa-estoq no-lock:
                        find b-item where rowid(b-item) =  rowid(item) exclusive-lock no-error.
                             assign b-item.baixa-estoq = aux-baixa-estoq.
                   end.
               end.
               
               assign familia.baixa-estoq = aux-baixa-estoq.             
                         
               if  familia.codigo-orig <> aux-codigo-orig then do:
                   for each item where item.fm-codigo   = familia.fm-codigo 
                        and item.codigo-orig = familia.codigo-orig no-lock:
                        find b-item where rowid(b-item) =  rowid(item) exclusive-lock no-error.
                        assign b-item.codigo-orig = aux-codigo-orig.
                   end.
               end.
               assign familia.codigo-orig = aux-codigo-orig.             
                      
               if  familia.fator-conver <> aux-fator-conver then do:
                   for each item where item.fm-codigo   = familia.fm-codigo 
                        and item.fator-conver = familia.fator-conver no-lock:
                        find b-item where rowid(b-item) =  rowid(item) exclusive-lock no-error.
                        assign b-item.fator-conver = aux-fator-conver.
                   end.
               end.
               assign familia.fator-conver = aux-fator-conver.             

              if  familia.fraciona  <> aux-fraciona  then do:
                  for each item where item.fm-codigo   = familia.fm-codigo 
                       and item.fraciona = familia.fraciona no-lock:
                       find b-item where rowid(b-item) =  rowid(item) exclusive-lock no-error.
                       assign b-item.fraciona = aux-fraciona.
                   end.
              end.
              assign familia.fraciona = aux-fraciona.             
                         
              if  familia.ind-imp-desc <> aux-ind-imp-desc then do:
                  for each item where item.fm-codigo   = familia.fm-codigo 
                       and item.ind-imp-desc = familia.ind-imp-desc no-lock:
                       find b-item where rowid(b-item) =  rowid(item) exclusive-lock no-error.
                       assign b-item.ind-imp-desc = aux-ind-imp-desc.
                  end.
              end.
              assign familia.ind-imp-desc = aux-ind-imp-desc.             
              
           end.
             
          assign aux-baixa-estoq  = input frame {&frame-name} familia.baixa-estoq
                 aux-codigo-orig  = input frame {&frame-name} familia.codigo-orig
                 aux-fator-conver = input frame {&frame-name} familia.fator-conver
                 aux-fraciona     = input frame {&frame-name} familia.fraciona
                 aux-ind-imp-desc = cb-ind-imp-desc:lookup(cb-ind-imp-desc:screen-value).     
     end.

  
  
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

  /* Dispatch standard ADM method.   
                            */
  do with frame {&FRAME-NAME}:
     assign cb-tipo-con-est:list-items = {ininc/i01in122.i 03}.
     assign familia.codigo-orig:screen-value in frame {&frame-name} = string(0).
     assign cb-ind-imp-desc:list-items = {ininc/i10in122.i 03}.
  end.
  
  
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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ).

  if  avail familia then assign gr-familia = rowid(familia).

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
  {src/adm/template/sndkycas.i "fm-codigo" "familia" "fm-codigo"}
  {src/adm/template/sndkycas.i "class-fiscal" "familia" "class-fiscal"}
  {src/adm/template/sndkycas.i "cod-comprado" "familia" "cod-comprado"}
  {src/adm/template/sndkycas.i "nr-linha" "familia" "nr-linha"}
  {src/adm/template/sndkycas.i "cd-planejado" "familia" "cd-planejado"}
  {src/adm/template/sndkycas.i "un" "familia" "un"}

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


