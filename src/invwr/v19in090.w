&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
          mgmov            PROGRESS
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
{include/i-prgvrs.i V19IN090 2.00.00.009}  /*** 010009 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v19in090 MUT}
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

def var p-rw-docum-est as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.
def var h_q01di135 as handle.
def new global shared var r-nota-upc as rowid.
def new global shared var r-docum-upc as rowid.

{rep/re9999.i2 "new"}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS nota-fiscal.char-1 
&Scoped-define ENABLED-TABLES nota-fiscal
&Scoped-define FIRST-ENABLED-TABLE nota-fiscal
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-3 l-reabre fi-serie ~
fi-nr-nota-fis 
&Scoped-Define DISPLAYED-OBJECTS l-reabre fi-cod-estabel fi-nome fi-serie ~
fi-nr-nota-fis 

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
DEFINE VARIABLE fi-cod-estabel LIKE estabelec.cod-estabel
     LABEL "Estabelecimento":R15 
     VIEW-AS FILL-IN 
     SIZE 7.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-nota-fis AS CHARACTER FORMAT "x(16)" 
     LABEL "Nr Nota Fiscal":R17 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88.

DEFINE VARIABLE fi-serie AS CHARACTER FORMAT "x(5)" INITIAL "U" 
     LABEL "S‚rie":R7 
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 68 BY 1.79.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 68 BY 5.13.

DEFINE VARIABLE l-reabre AS LOGICAL INITIAL no 
     LABEL "Reabre Pedido" 
     VIEW-AS TOGGLE-BOX
     SIZE 25.72 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     nota-fiscal.char-1 AT ROW 1.54 COL 66.29 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE .14 BY .21
     l-reabre AT ROW 1.79 COL 21.29
     fi-cod-estabel AT ROW 4.58 COL 19.43 COLON-ALIGNED
          LABEL "Estabelecimento":R15
     fi-nome AT ROW 4.58 COL 27.14 COLON-ALIGNED NO-LABEL
     fi-serie AT ROW 5.58 COL 19.43 COLON-ALIGNED
     fi-nr-nota-fis AT ROW 6.58 COL 19.43 COLON-ALIGNED
     RECT-2 AT ROW 1.29 COL 2
     RECT-3 AT ROW 3.46 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 7.58
         WIDTH              = 69.
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

/* SETTINGS FOR FILL-IN nota-fiscal.char-1 IN FRAME f-main
   NO-DISPLAY ALIGN-L                                                   */
ASSIGN 
       nota-fiscal.char-1:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN fi-cod-estabel IN FRAME f-main
   NO-ENABLE LIKE = mgcad.estabelec.cod-estabel EXP-LABEL EXP-SIZE      */
/* SETTINGS FOR FILL-IN fi-nome IN FRAME f-main
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

&Scoped-define SELF-NAME fi-nr-nota-fis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-nota-fis V-table-Win
ON F5 OF fi-nr-nota-fis IN FRAME f-main /* Nr Nota Fiscal */
DO:
    {include/zoomvar.i &prog-zoom=dizoom/z01di135.w
                       &campo=fi-nr-nota-fis
                       &campozoom=nr-nota-fis}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-nota-fis V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-nr-nota-fis IN FRAME f-main /* Nr Nota Fiscal */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-serie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-serie V-table-Win
ON F5 OF fi-serie IN FRAME f-main /* S‚rie */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in407.w
                       &campo=fi-serie
                       &campozoom=serie}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-serie V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-serie IN FRAME f-main /* S‚rie */
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

if fi-nr-nota-fis:load-mouse-pointer("image/lupa.cur") in frame {&frame-name} then .
if fi-serie:load-mouse-pointer("image/lupa.cur") in frame {&frame-name} then .

/*find docum-est where rowid(docum-est) = p-rw-docum-est no-lock no-error.
 * find estabelec where 
 *      estabelec.cod-estabel = docum-est.cod-estabel no-lock no-error.
 * assign fi-cod-estabel = docum-est.cod-estabel
 *        fi-nome        = estabelec.nome.*/

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
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

   find docum-est where 
      rowid(docum-est) = p-rw-docum-est NO-LOCK NO-ERROR.
 if avail docum-est then do:
     find estabelec where
          estabelec.cod-estabel = docum-est.cod-estabel no-lock no-error.
     if avail estabelec then do:
         assign fi-cod-estabel:screen-value in frame {&frame-name} = 
                               estabelec.cod-estabel
                fi-nome:screen-value in frame {&frame-name} = 
                               estabelec.nome.
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
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if adm-new-record = yes then
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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

  {utp/ut-liter.i Reabre_Pedido}
  assign l-reabre:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-field.i mgind docum-est cod-estabel 1}
  assign fi-cod-estabel:label in frame {&FRAME-NAME} = trim(return-value).  

  {utp/ut-field.i mgind docum-est serie-docto 1}
  assign fi-serie:label in frame {&FRAME-NAME} = trim(return-value).  

  {utp/ut-liter.i Nr_Nota_Fiscal}
  assign fi-nr-nota-fis:label in frame {&FRAME-NAME} = trim(return-value).  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

 find first param-estoq no-lock no-error.
 if not avail param-estoq then do:
    run utp/ut-msgs.p (input "show",
                       input 1059,
                       input "").
    RUN dispatch IN THIS-PROCEDURE ('adm-exit':U).
 end.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-itens-devolucao V-table-Win 
PROCEDURE pi-gera-itens-devolucao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def var i-seq         as integer no-undo.
def var de-aliq-icm   as decimal no-undo.
def var de-valor      as decimal no-undo.
def var l-configurado as logical no-undo.
def var l-itens       as logical no-undo.

find first param-estoq no-lock no-error.  
if not avail param-estoq then do:
   run utp/ut-msgs.p (input "show",
                      input 1059,
                      input ""). 
   RUN dispatch IN THIS-PROCEDURE ('adm-exit':U).
end.

find param-re where param-re.usuario = c-seg-usuario no-lock no-error.
find natur-oper where 
     natur-oper.nat-operacao = docum-est.nat-operacao no-lock no-error.

find last item-doc-est
    where item-doc-est.cod-emitente = docum-est.cod-emitente
      and item-doc-est.nat-operacao = docum-est.nat-operacao
      and item-doc-est.serie-docto  = docum-est.serie-docto
      and item-doc-est.nro-docto    = docum-est.nro-docto no-lock no-error.
assign i-seq = if not avail item-doc-est then param-re.seq-item-um
               else item-doc-est.sequencia + param-re.inc-seq.

run rep/re9991.p (input rowid(docum-est), output de-aliq-icm).
for each it-nota-fisc
   where it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis
     and it-nota-fisc.serie       = nota-fiscal.serie
     and it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel no-lock:

    find item where item.it-codigo = it-nota-fisc.it-codigo no-lock no-error.
    create item-doc-est.
    assign item-doc-est.nro-docto      = docum-est.nro-docto
           item-doc-est.serie-docto    = docum-est.serie-docto
           item-doc-est.cod-emitente   = docum-est.cod-emitente
           item-doc-est.nat-operacao   = docum-est.nat-operacao
           item-doc-est.sequencia      = i-seq
           item-doc-est.it-codigo      = it-nota-fisc.it-codigo
           item-doc-est.nat-comp       = it-nota-fisc.nat-operacao
           item-doc-est.serie-comp     = it-nota-fisc.serie
           item-doc-est.nro-comp       = it-nota-fisc.nr-nota-fis
           item-doc-est.nr-pd-seq      = it-nota-fisc.nr-seq-ped
           item-doc-est.seq-comp       = it-nota-fisc.nr-seq-fat
           item-doc-est.nr-pedcli      = it-nota-fisc.nr-pedcli
           item-doc-est.reabre-pd      = l-reabre
           item-doc-est.data-comp      = it-nota-fisc.dt-emis-nota
           item-doc-est.peso-liquido   = it-nota-fisc.peso-liq-fat
           item-doc-est.quantidade     = it-nota-fisc.qt-faturada[1]
           item-doc-est.preco-unit[1]  =     /* Qtd Faturada Familia / Item */
                if it-nota-fisc.ind-fat-qtfam = no then it-nota-fisc.vl-preuni
                else ( it-nota-fisc.vl-preuni * it-nota-fisc.qt-faturada[2]
                     / it-nota-fisc.qt-faturada[1] )
           item-doc-est.class-fiscal   = it-nota-fisc.class-fiscal
           item-doc-est.cd-trib-ipi    = it-nota-fisc.cd-trib-ipi
           item-doc-est.cd-trib-icm    = it-nota-fisc.cd-trib-icm
           item-doc-est.aliquota-ipi   = it-nota-fisc.aliquota-ipi
           item-doc-est.aliquota-icm   = it-nota-fisc.aliquota-icm
           item-doc-est.baixa-ce       = it-nota-fisc.baixa-estoq
           item-doc-est.cod-refer      = it-nota-fisc.cod-refer
           item-doc-est.un             = item.un
           item-doc-est.qt-do-forn     = item-doc-est.quantidade
           item-doc-est.preco-total[1] = item-doc-est.quantidade 
                                       * item-doc-est.preco-unit[1]
           item-doc-est.cod-depos      = item.deposito-pad
           item-doc-est.cod-localiz    = item.cod-localiz
           i-seq                       = i-seq + param-re.inc-seq
           l-itens                     = yes.
    if  item.tipo-contr = 4 then do:
        find nar-it-nota where
             nar-it-nota.cod-estabel  = it-nota-fisc.cod-estabel and
             nar-it-nota.serie        = it-nota-fisc.serie       and
             nar-it-nota.nr-nota-fis  = it-nota-fisc.nr-nota-fis and
             nar-it-nota.nr-sequencia = it-nota-fisc.nr-seq-fat  and
             nar-it-nota.it-codigo    = it-nota-fisc.it-codigo no-lock no-error.
        if  avail nar-it-nota then do:
            assign item-doc-est.narrativa = nar-it-nota.narrativa.
        end.
    end.
    run rep/re9992.p (input rowid(item-doc-est)).
    assign item-doc-est.valor-ipi[1]  = de-IPI-item
           item-doc-est.base-ipi[1]   = de-IPI-base-item
           item-doc-est.ipi-ntrib[1]  = de-IPI-ntrib-item
           item-doc-est.ipi-outras[1] = de-IPI-outras-item.
    /* Calculo do ICMS */
    run rep/re9994.p ( input rowid(item-doc-est) ).  /*ICMS*/

    find emitente where
         emitente.cod-emitente = docum-est.cod-emitente no-lock no-error.
    find estabelec where
         estabelec.cod-estabel = docum-est.cod-estabel no-lock no-error.
    find natur-oper where
         natur-oper.nat-operacao = docum-est.nat-operacao no-lock no-error.     

    assign item-doc-est.valor-icm[1]   = de-ICM-item
           item-doc-est.base-icm[1]    = de-ICM-base-item
           item-doc-est.icm-ntrib[1]   = de-ICM-ntrib-item
           item-doc-est.icm-outras[1]  = de-ICM-outras-item
           item-doc-est.icm-complem[1] = de-ICM-complem-item *
                                         integer(estabelec.pais = "BRASIL" and
                                         emitente.pais = estabelec.pais and
                                         estabelec.estado <> docum-est.uf and
                                         natur-oper.consum-final).
    assign item-doc-est.base-subs[1]   = if natur-oper.subs-trib 
                                         then de-ICM-base-item else 0
           item-doc-est.vl-subs[1]     = if natur-oper.subs-trib 
                                         then de-ICM-item else 0.

    if  item.tipo-contr = 4 then do:
        if  it-nota-fisc.ct-cuscon = "" then do:
            assign item-doc-est.conta-contabil = item.conta-aplicacao.
            if  item-doc-est.conta-contabil = "" then do:
                run utp/ut-msgs.p (input "show":U, input 5170, input "1").
            end.
        end.
        else
            assign item-doc-est.conta-contabil = it-nota-fisc.ct-cuscon.
        run cdp/cd0813.p (1, 0, 1, nota-fiscal.dt-confirma, output de-valor).
        assign item-doc-est.iss-ntrib[1] = if de-valor = ? or de-valor = 0 
                                           then 1 else de-valor.
        run cdp/cd0813.p (2, 0, 1, nota-fiscal.dt-confirma, output de-valor).
        assign item-doc-est.iss-ntrib[2] = if de-valor = ? or de-valor = 0 
                                           then 1 else de-valor.
    end.
    else do:
        if  item.tipo-contr = 1 then do:
            assign item-doc-est.conta-contabil = if it-nota-fisc.ct-cuscon = ""
                                                 then docum-est.conta-transit
                                                 else it-nota-fisc.ct-cuscon.
        end.
        run cdp/cd0813.p (1, 0, 1, nota-fiscal.dt-confirma, output de-valor).
        assign item-doc-est.iss-ntrib[1] = if de-valor = ? or de-valor = 0 
                                           then 1 else de-valor.
        run cdp/cd0813.p (2, 0, 1, nota-fiscal.dt-confirma, output de-valor).
        assign item-doc-est.iss-ntrib[2] = if de-valor = ? or de-valor = 0 
                                           then 1 else de-valor.
    end.
    assign l-configurado = if item.politica = 5 and item.baixa-est = no 
                           then yes else no
           i-sequencia   = if item.politica = 5 and item.baixa-est = no 
                           then it-nota-fisc.nr-seq-fat * 100000 + 1
                           else it-nota-fisc.nr-seq-fat.
    find fat-ser-lote where
         fat-ser-lote.cod-estabel = it-nota-fisc.cod-estabel and
         fat-ser-lote.serie       = it-nota-fisc.serie       and
         fat-ser-lote.nr-nota-fis = it-nota-fisc.nr-nota-fis and
         fat-ser-lote.nr-seq-fat  = i-sequencia no-lock no-error.
    if  avail fat-ser-lote then 
        assign item-doc-est.cod-depos   = fat-ser-lote.cod-depos
               item-doc-est.cod-localiz = if item.loc-unica 
                                          then item.cod-localiz
                                          else fat-ser-lote.cod-localiz
               item-doc-est.lote        = fat-ser-lote.nr-serlote.
    if  ambiguous fat-ser-lote or l-configurado then 
        for each fat-ser-lote 
           where fat-ser-lote.cod-estabel = it-nota-fisc.cod-estabel
            and  fat-ser-lote.serie       = it-nota-fisc.serie
            and  fat-ser-lote.nr-nota-fis = it-nota-fisc.nr-nota-fis
            and (fat-ser-lote.nr-seq-fat  = i-sequencia or l-configurado)
                 no-lock break by fat-ser-lote.cod-depos:

            /* Testa Sequencia do Produto Configurado */
            if  l-configurado
            and (fat-ser-lote.nr-seq-fat < i-sequencia
            or   fat-ser-lote.nr-seq-fat >
                ( (it-nota-fisc.nr-seq-fat + 1) * 100000) ) then
                next.
            create rat-lote.
            assign rat-lote.nro-docto    = item-doc-est.nro-docto
                   rat-lote.serie-docto  = item-doc-est.serie-docto
                   rat-lote.cod-emitente = item-doc-est.cod-emitente
                   rat-lote.nat-operacao = item-doc-est.nat-operacao
                   rat-lote.it-codigo    = fat-ser-lote.it-codigo
                   rat-lote.sequencia    = item-doc-est.sequencia
                   rat-lote.quantidade   = fat-ser-lote.qt-baixada[1]
                   rat-lote.cod-depos    = fat-ser-lote.cod-depos
                   rat-lote.cod-localiz  = if item.loc-unica = yes
                                           and l-configurado = no
                                           then item.cod-localiz
                                           else fat-ser-lote.cod-localiz
                   rat-lote.lote         = fat-ser-lote.nr-serlote.
            if  first-of(fat-ser-lote.cod-depos) then 
                assign item-doc-est.cod-depos   = fat-ser-lote.cod-depos
                       item-doc-est.lote        = fat-ser-lote.nr-serlote
                       item-doc-est.cod-localiz = if item.loc-unica 
                                                  and l-configurado = no 
                                 then item.cod-localiz
                                 else fat-ser-lote.cod-localiz.
        end.
end.

if  l-itens = no then do:
    run utp/ut-msgs.p (input "show":U, input 5170, input "2").
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grava V-table-Win 
PROCEDURE pi-grava :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

assign input frame {&frame-name} fi-cod-estabel
       input frame {&frame-name} fi-serie
       input frame {&frame-name} fi-nr-nota-fis
       input frame {&frame-name} l-reabre.
    find nota-fiscal where
         nota-fiscal.cod-estabel = fi-cod-estabel and
         nota-fiscal.serie       = fi-serie       and
         nota-fiscal.nr-nota-fis = fi-nr-nota-fis no-lock no-error.
    if avail nota-fiscal then do:
       run pi-reposiciona-query in h_q01di135 (input rowid(nota-fiscal)).  
       assign r-nota-upc = rowid(nota-fiscal).

       assign r-docum-upc = rowid(docum-est).
    end.
    if  not avail nota-fiscal   /* NF inexiste ou cliente <> do documento */
    or  nota-fiscal.cod-emitente <> docum-est.cod-emitente then do:
        {utp/ut-table.i mgdis nota-fiscal 1}
        run utp/ut-msgs.p (input "show":U, input 2, input return-value).
        apply "entry" to fi-serie in frame {&frame-name}.
        return 'ERROR':U.
    end.
    if  nota-fiscal.dt-confirm = ? then do:
        run utp/ut-msgs.p (input "show":U, input 4069, input "").
        apply "entry" to fi-serie in frame {&frame-name}.
        return 'ERROR':U.
    end.
    if  nota-fiscal.dt-cancel <> ? then do:
        run utp/ut-msgs.p (input "show":U, input 3366, input "").
        apply "entry" to fi-serie in frame {&frame-name}.
        return 'ERROR':U.
    end.

    if  session:set-wait-state ("GENERAL":U) then .
    run pi-gera-itens-devolucao in this-procedure.
    if  session:set-wait-state ("":U) then .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-handle V-table-Win 
PROCEDURE pi-passa-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter h-handle as handle.

assign h_q01di135 = h-handle.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-rowid V-table-Win 
PROCEDURE pi-passa-rowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter rw-docum-est as rowid.

 assign p-rw-docum-est = rw-docum-est.

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

   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this Window, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

