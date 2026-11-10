&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movind           PROGRESS
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
{include/i-prgvrs.i V04IN372 2.00.00.011 } /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V04IN372 MUT}
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

{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

def buffer b-recebimento for recebimento.

def new shared var de-indice       as decimal.
def new shared var de-preco-conv   like ordem-compra.preco-unit.
def new shared var de-val-tot      like ordem-compra.preco-unit.
def new shared var da-movto        like recebimento.data-movto.

def var c-ordem  as char format "x(14)" no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES recebimento
&Scoped-define FIRST-EXTERNAL-TABLE recebimento


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR recebimento.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS recebimento.data-movto ~
recebimento.quant-rejeit recebimento.codigo-rejei recebimento.serie-nota ~
recebimento.numero-nota recebimento.data-nota recebimento.recebedor 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}data-movto ~{&FP2}data-movto ~{&FP3}~
 ~{&FP1}quant-rejeit ~{&FP2}quant-rejeit ~{&FP3}~
 ~{&FP1}codigo-rejei ~{&FP2}codigo-rejei ~{&FP3}~
 ~{&FP1}serie-nota ~{&FP2}serie-nota ~{&FP3}~
 ~{&FP1}numero-nota ~{&FP2}numero-nota ~{&FP3}~
 ~{&FP1}data-nota ~{&FP2}data-nota ~{&FP3}~
 ~{&FP1}recebedor ~{&FP2}recebedor ~{&FP3}
&Scoped-define ENABLED-TABLES recebimento
&Scoped-define FIRST-ENABLED-TABLE recebimento
&Scoped-Define ENABLED-OBJECTS rt-mold fi-un 
&Scoped-Define DISPLAYED-FIELDS recebimento.num-pedido ~
recebimento.numero-ordem recebimento.parcela recebimento.data-movto ~
recebimento.quant-rejeit recebimento.codigo-rejei recebimento.serie-nota ~
recebimento.numero-nota recebimento.data-nota recebimento.recebedor 
&Scoped-Define DISPLAYED-OBJECTS fi-un fi-desc-un fi-descricao 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS recebimento.numero-ordem ~
recebimento.parcela 
&Scoped-define ADM-ASSIGN-FIELDS recebimento.num-pedido ~
recebimento.numero-ordem recebimento.parcela fi-un 

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
DEFINE VARIABLE fi-desc-un AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE fi-descricao AS CHARACTER FORMAT "X(30)" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88.

DEFINE VARIABLE fi-un AS CHARACTER FORMAT "xx" 
     LABEL "UN":R21 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.86 BY 10.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     recebimento.num-pedido AT ROW 1.33 COL 35.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .88
     recebimento.numero-ordem AT ROW 2.33 COL 35.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .88
     recebimento.parcela AT ROW 2.33 COL 59.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     recebimento.data-movto AT ROW 3.33 COL 35.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     recebimento.quant-rejeit AT ROW 4.33 COL 35.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     fi-un AT ROW 5.33 COL 35.57 COLON-ALIGNED
     fi-desc-un AT ROW 5.33 COL 41.14 COLON-ALIGNED NO-LABEL
     recebimento.codigo-rejei AT ROW 6.33 COL 35.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     fi-descricao AT ROW 6.33 COL 41.14 COLON-ALIGNED NO-LABEL
     recebimento.serie-nota AT ROW 7.33 COL 35.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     recebimento.numero-nota AT ROW 8.33 COL 35.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     recebimento.data-nota AT ROW 9.33 COL 35.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     recebimento.recebedor AT ROW 10.33 COL 35.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.recebimento
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
         HEIGHT             = 10.63
         WIDTH              = 86.86.
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

/* SETTINGS FOR FILL-IN fi-desc-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-un IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN recebimento.num-pedido IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN recebimento.numero-ordem IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN recebimento.parcela IN FRAME f-main
   NO-ENABLE 1 2                                                        */
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

&Scoped-define SELF-NAME recebimento.codigo-rejei
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL recebimento.codigo-rejei V-table-Win
ON F5 OF recebimento.codigo-rejei IN FRAME f-main /* C¢digo Devoluá∆o */
DO:
  {include/zoom.i &prog-zoom="inzoom/z01in047.w"
                  &tabela=recebimento
                  &atributo=codigo-rejei}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL recebimento.codigo-rejei V-table-Win
ON LEAVE OF recebimento.codigo-rejei IN FRAME f-main /* C¢digo Devoluá∆o */
DO:
  {include/leave.i &tabela       = cod-rejeicao
                   &atributo-ref = descricao
                   &variavel-ref = fi-descricao
                   &where        = "cod-rejeicao.codigo-rejei = 
                                      input frame {&frame-name} recebimento.codigo-rejei"}.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL recebimento.codigo-rejei V-table-Win
ON MOUSE-SELECT-DBLCLICK OF recebimento.codigo-rejei IN FRAME f-main /* C¢digo Devoluá∆o */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-un V-table-Win
ON F5 OF fi-un IN FRAME f-main /* UN */
DO:
  {include/zoomvar.i &prog-zoom=inzoom/z01in417.w
                     &campo=fi-un
                     &campozoom=un} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-un V-table-Win
ON LEAVE OF fi-un IN FRAME f-main /* UN */
DO:
  {include/leave.i &tabela       = tab-unidade
                   &atributo-ref = descricao
                   &variavel-ref = fi-desc-un
                   &where        = "tab-unidade.un = 
                                      input frame {&frame-name} fi-un"}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-un V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-un IN FRAME f-main /* UN */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME recebimento.parcela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL recebimento.parcela V-table-Win
ON LEAVE OF recebimento.parcela IN FRAME f-main /* Parcela */
DO:
    &if defined(bf_dis_default_UN) &then
        find first param-mat no-lock no-error.
          if avail param-mat
               and param-mat.ind-sit-un = 2 then do:
            {include/leave.i &tabela=prazo-compra
                             &atributo-ref=un
                             &variavel-ref=fi-un
                             &where="prazo-compra.numero-ordem = input frame {&frame-name} recebimento.numero-ordem and
                                     prazo-compra.parcela      = input frame {&frame-name} recebimento.parcela"}
        end.

    &endif

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

if recebimento.codigo-rejei:load-mouse-pointer("image\lupa.cur") in frame
   {&frame-name} then.

if fi-un:load-mouse-pointer("image\lupa.cur") in frame {&frame-name} then.

{utp/ut-liter.i Un}
assign fi-un:label in frame {&frame-name} = trim(return-value).

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
  {src/adm/template/row-list.i "recebimento"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "recebimento"}

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

assign fi-un = "".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

find pedido-compr where rowid(pedido-compr) = v-row-parent
    no-lock no-error.
if  avail pedido-compr then do with frame {&frame-name}:
    assign recebimento.num-pedido:screen-value = string(pedido-compr.num-pedido).
    find first b-recebimento 
         where b-recebimento.num-pedido = pedido-compr.num-pedido
         and   b-recebimento.cod-movto = 1
         no-lock no-error.
    if  avail b-recebimento then
        assign recebimento.numero-ordem:screen-value = string(b-recebimento.numero-ordem)
               recebimento.parcela:screen-value = string(b-recebimento.parcela).
end.



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

assign de-indice = 1.

if  avail recebimento then
    assign de-val-tot = recebimento.quant-rejei. 

  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  


/*Ordem de compra n∆o cadastrada*/
find ordem-compra 
     where ordem-compra.numero-ordem =
     input frame {&frame-name} recebimento.numero-ordem no-lock no-error.

    if  not avail ordem-compra then do:
         {utp/ut-table.i mgind ordem-compra 1}
         run utp/ut-msgs.p ("show",47,trim(return-value)).
         apply "entry" to recebimento.numero-ordem.
         return "adm-error".
     end.

/*Parcela deve ser diferente de zero*/
if  input frame {&frame-name} recebimento.parcela = 0 then do:
    {utp/ut-liter.i Parcela * L}
    run utp/ut-msgs.p (input "show",input 1491,input return-value).
    apply "entry" to recebimento.parcela.
    return "adm-error".
end.

/*Data do movimento deve ser informado*/
if  input frame {&frame-name} recebimento.data-movto = ? then do:
    {utp/ut-liter.i Data_do_Movimento * L}
    run utp/ut-msgs.p ("show",47,trim(return-value)).
    apply "entry" to recebimento.data-movto.
    return "adm-error".
end.

/* Quantidade devolvida deve ser informada*/
if  input frame {&frame-name} recebimento.quant-rejeit = 0 then do:
    {utp/ut-liter.i Quantidade * L}
    run utp/ut-msgs.p ("show",47,trim(return-value)).
    apply "entry" to recebimento.quant-rejeit.
    return "adm-error".
end.

/* Devoluá∆o Inexistente*/
find cod-rejeicao 
     where cod-rejeicao.codigo-rejei = 
     input frame {&frame-name} recebimento.codigo-rejei no-lock no-error.

     if  not avail cod-rejeicao then do:     
        {utp/ut-liter.i Devoluá∆o * L}
        run utp/ut-msgs.p ("show",56,trim(return-value)).
        apply "entry" to recebimento.codigo-rejei.
        return "adm-error".
     end.

/* Numero do documento deve ser informado*/
if  input frame {&frame-name} recebimento.numero-nota = "" then do:
    {utp/ut-liter.i Numero_Documento * L}
    run utp/ut-msgs.p ("show",47,trim(return-value)).
    apply "entry" to recebimento.numero-nota.
    return "adm-error".
end.

/* Data do documento deve ser informado*/
if  input frame {&frame-name} recebimento.data-nota = ? then do:
    {utp/ut-liter.i Data_do_Documento * L}
    run utp/ut-msgs.p ("show",47,trim(return-value)).
    apply "entry" to recebimento.data-nota.
    return "adm-error".
end.

/* Respons†vel  deve ser informado*/
if  input frame {&frame-name} recebimento.recebedor = "" then do:
    {utp/ut-liter.i Respons†vel * L}
    run utp/ut-msgs.p ("show",47,trim(return-value)).
    apply "entry" to recebimento.recebedor.
    return "adm-error".
end.



  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  

find prazo-compra where
     prazo-compra.numero-ordem = recebimento.numero-ordem and
     prazo-compra.parcela      = recebimento.parcela EXCLUSIVE-LOCK no-error.

find ordem-compra where 
     ordem-compra.numero-ordem = recebimento.numero-ordem EXCLUSIVE-LOCK NO-ERROR.

find pedido-compr where rowid(pedido-compr) = v-row-parent NO-LOCK no-error.

find item where item.it-codigo = ordem-compra.it-codigo no-lock no-error.

if adm-new-record = yes then do:
    assign prazo-compra.quant-rejeit = prazo-compra.quant-rejeit
                                     + recebimento.quant-rejeit.
    &if defined(bf_mat_contratos) &then
    if ordem-compra.nr-contrato <> 0 then do:
    &else
    if ordem-compra.nr-contrato <> "" then do:
    &endif
        assign ordem-compra.qt-acum-dev = ordem-compra.qt-acum-dev
                                        + recebimento.quant-rejeit.                                
    end.
end.
else do:
    assign prazo-compra.quant-rejeit = prazo-compra.quant-rejeit
                                     + (recebimento.quant-rejeit - de-val-tot).
    &if defined(bf_mat_contratos) &then
    if  ordem-compra.nr-contrato <> 0 then do:
    &else
    if  ordem-compra.nr-contrato <> "" then do:
    &endif
        assign ordem-compra.qt-acum-dev = ordem-compra.qt-acum-dev
                                        + (recebimento.quant-rejeit - de-val-tot).
    end.  
end.                                              

if  avail item then do:
    if item.tipo-contr = 4 then do:         
       for first cotacao-item field (numero-ordem cod-emitente data-cotacao un)
           where cotacao-item.numero-ordem = ordem-compra.numero-ordem 
           and   cotacao-item.cod-emitente = ordem-compra.cod-emitente 
           and   cotacao-item.data-cotacao = ordem-compra.data-cotacao no-lock: 
           if cotacao-item.un <> prazo-compra.un then do:
                find tab-conv-un where
                     tab-conv-un.un           = prazo-compra.un and
                     tab-conv-un.unid-med-for = cotacao-item.un no-lock no-error.
                assign de-indice =
                       if  available tab-conv-un then
                           tab-conv-un.fator-conver / exp(10,tab-conv-un.num-casa-dec)
                       else 1.
           end.
       end.       
    end.
    else do:
       find item-fornec where
            item-fornec.it-codigo    = item.it-codigo and
            item-fornec.cod-emitente = recebimento.cod-emitente no-lock no-error.
       if avail item-fornec then do:
           de-indice = item-fornec.fator-conver /
                       if item-fornec.num-casa-dec = 0
                          then 1
                          else exp(10,item-fornec.num-casa-dec).   
       end.
    end.
end. 

if avail prazo-compra then do:
    assign prazo-compra.quant-saldo = prazo-compra.quantidade
                                    - prazo-compra.quant-receb
                                    + prazo-compra.quant-rejei.
    if prazo-compra.quant-saldo < 0 then
       prazo-compra.quant-saldo = 0.
    if prazo-compra.quant-saldo > 0 then
       assign prazo-compra.situacao = 2
              ordem-compra.situacao = 2.
end.

assign recebimento.qtd-rej-forn  = recebimento.quant-rejeit * de-indice
       prazo-compra.qtd-rej-forn = prazo-compra.quant-rejei * de-indice
       prazo-compra.qtd-sal-forn = prazo-compra.quant-saldo * de-indice                    
       recebimento.hora-atualiz  = string(time,"HH:MM:SS")
       recebimento.cod-emitente  = pedido-compr.cod-emitente
       recebimento.it-codigo     = ordem-compra.it-codigo
       recebimento.pre-unit-for  = ordem-compra.pre-unit-for
       recebimento.aliquota-icm  = ordem-compra.aliquota-icm
       recebimento.aliquota-ipi  = ordem-compra.aliquota-ipi 
       recebimento.aliquota-iss  = ordem-compra.aliquota-iss
       recebimento.valor-total   = recebimento.pre-unit-for
                                   * ( recebimento.qtd-rej-forn
                                   + int(recebimento.qtd-rej-forn = 0) )           
       recebimento.valor-ipi    = (ordem-compra.aliquota-ipi / 100) * recebimento.valor-total
       recebimento.valor-icm    = (ordem-compra.aliquota-icm / 100) * recebimento.valor-total
       recebimento.valor-iss    = (ordem-compra.aliquota-iss / 100) * recebimento.valor-total
       recebimento.cod-movto     = 2
       recebimento.usuario       = c-seg-usuario.

if  avail ordem-compra then do: 
    if  ordem-compra.mo-codigo > 0 then do:
        run cdp/cd0812.p (input ordem-compra.mo-codigo, input 0,
                         input ordem-compra.pre-unit-for,
                         input ordem-compra.data-pedido,
                         output de-preco-conv).
        if  de-preco-conv = ? then
            assign de-preco-conv = ordem-compra.pre-unit-for.
    end.
    else
        assign de-preco-conv = ordem-compra.pre-unit-for.
end. 

assign de-val-tot = recebimento.qtd-rej-forn * de-preco-conv.
find first b-recebimento
     where b-recebimento.numero-ordem = ordem-compra.numero-ordem 
     and   b-recebimento.parcela      = recebimento.parcela 
     and   b-recebimento.cod-movto    = 1 no-lock no-error.
if  avail b-recebimento then  
    assign recebimento.preco-unit = b-recebimento.preco-unit.                                                      

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

  if available recebimento then do:
    find cod-rejeicao where cod-rejeicao.codigo-rejei = recebimento.codigo-rejei no-lock no-error.
    assign fi-descricao = if avail cod-rejeicao then cod-rejeicao.descricao     
                         else "":U.
  end. 

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

if  avail recebimento and not adm-new-record then do:
    find prazo-compra where 
         prazo-compra.numero-ordem = recebimento.numero-ordem and
         prazo-compra.parcela      = recebimento.parcela no-lock no-error.
    assign fi-un = if avail prazo-compra then prazo-compra.un else "".
    disp fi-un with frame {&frame-name}.
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
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */


do with frame {&frame-name}:
    find pedido-compr where rowid(pedido-compr) = v-row-parent 
        no-lock no-error.

    /* Localiza recebimento */
    find first b-recebimento 
         where b-recebimento.numero-ordem = input recebimento.numero-ordem
         and   b-recebimento.parcela = input recebimento.parcela 
         and   b-recebimento.ind-movto = 1 no-lock no-error.
    assign da-movto = if avail b-recebimento then b-recebimento.data-movto
                      else ?.
    if not avail b-recebimento then do:
        {utp/ut-table.i mgind recebimento 1}
        run utp/ut-msgs.p ("show",47,trim(return-value)).
        apply "entry" to recebimento.numero-ordem.
        return "adm-error".
    end.
    {utp/ut-table.i mgind ordem-compra 1}
    assign c-ordem = trim(return-value).

    find ordem-compra where 
         ordem-compra.numero-ordem = input recebimento.numero-ordem
         no-lock no-error.
    if  not avail ordem-compra then do:
        run utp/ut-msgs.p ("show",47,c-ordem).
        apply "entry" to recebimento.numero-ordem.
        return "adm-error".
    end.

    find prazo-compra where 
         prazo-compra.numero-ordem = input recebimento.numero-ordem and
         prazo-compra.parcela      = input recebimento.parcela
         no-lock no-error.
    if  not avail prazo-compra then do:
        {utp/ut-table.i mgind prazo-compra 1}
        run utp/ut-msgs.p ("show",47,trim(return-value)).
        apply "entry" to recebimento.parcela.
        return "adm-error".
    end.

    if  avail pedido-compr and
        ordem-compra.num-pedido <> pedido-compr.num-pedido then do:
        {utp/ut-table.i mgind pedido-compr 1}
        run utp/ut-msgs.p ("show",7137,c-ordem + "~~" + trim(return-value)).
        apply "entry" to recebimento.numero-ordem.
        return "adm-error".
    end.

    if  input recebimento.data-movto <= da-movto then do:
        run utp/ut-msgs.p (input "show",3864,"").     
        return "adm-error".
    end.

    if  input recebimento.quant-rejeit + 
        prazo-compra.quant-rejei > prazo-compra.quant-receb then do:
        run utp/ut-msgs.p ("show",3872,"").
        return "adm-error".
    end. 

    if  item.tipo-contr = 4 then do:
        if  input fi-un <> prazo-compra.un then do:
            run utp/ut-msgs.p ("show",2391,"").     
            return "adm-error".
        end. 
    end.    
    else do:  
        if  input fi-un <> item.un then do:
            run utp/ut-msgs.p (input "show",3359,"").
            return "adm-error".
        end. 
    end.
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
  {src/adm/template/snd-list.i "recebimento"}

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


