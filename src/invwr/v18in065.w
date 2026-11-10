&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
{include/i-prgvrs.i V18IN065 2.00.00.012}  /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V18IN065 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

def buffer b-ordem for ordem-compra.

define temp-table w-ordens
           field marca        as char format "x(1)" column-label "*"
           field cod-estabel  like ordem-compra.cod-estabel
           field nr-contrat   like contrato-for.nr-contrato
           field num-seq-item like item-contrat.num-seq-item
           field numero-ordem like ordem-compra.numero-ordem
           field it-codigo    like item.it-codigo
           field descricao    like item.desc-item
           field un           like prazo-compra.un
           field quantidade   like prazo-compra.quantidade
           field situacao     like ordem-compra.situacao.

def var c-cod-estabel like estabelec.cod-estabel.
def var l-erro-co     as logical init no no-undo.

def  var i-seq       as integer.
def  var c-it-descricao  like item.desc-item.
def  var i-num-seq       like item-contrat.num-seq-item.
def var r-primeiro as rowid no-undo.
def var r-ultimo   as rowid.
def var i-cont     as int.
def  var l-confirma as logical format "Sim/Nao" init no.

def  var r-registro       as rowid no-undo.
def  var i-natureza    as integer.
def  var c-natureza-p  as character initial "c,s,b".
def  var c-natur-f     as character format "x(14)".
def  var c-natureza    as character format "x(14)" extent 3
                         init ["Compra","Servico","Beneficiamento"].
def var de-qtd               like prazo-compra.quantidade.
def  var c-opcao       as character no-undo.
def  var da-entrega-contrato like prazo-compra.data-entrega no-undo.
def  var l-x           as logical init no no-undo.

def var de-valor-conver   as dec format "->>>>,>>>,>>9.9999".
def var i-ordem-ini   as integer   format "zzzzz9" init "0".
def var i-ordem-fim   as integer   format "zzzzz9" init "999999".
def var i-seq-ini     as integer   format "99" init "0".
def var i-seq-fim     as integer   format "99" init "99".
def var c-item-ini    as character format "x(16)" init "".
def var c-item-fim    as character format "x(16)" init "ZZZZZZZZZZZZZZZZ".
def var de-indice     as decimal.
def var l-erro-x      as logical init no no-undo.
def var r-ordem       as rowid.
def  var c-nr-contr as int format ">>>,>>>,>>9" no-undo.
def  var c-desc     as char format "x(32)" .

{cdp/cdcfgmat.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-key i-nr-contrato i-num-seq-item ~
i-numero-ordem rt-mold 
&Scoped-Define DISPLAYED-OBJECTS i-nr-contrato c-contrato i-num-seq-item ~
i-numero-ordem c-it-codigo c-item i-quantidade c-un i-situacao 

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
DEFINE VARIABLE c-contrato AS CHARACTER FORMAT "x(32)" 
     VIEW-AS FILL-IN 
     SIZE 28 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "x(16)" 
     LABEL "Item":R5 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-item AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 46.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-un AS CHARACTER FORMAT "xx" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-contrato AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 
     LABEL "Nr Contrato":R14 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-seq-item AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "SeqÅància Item":R17 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-numero-ordem AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Ordem Compra":R15 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-quantidade AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Qtde":R5 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE i-situacao AS INTEGER FORMAT ">9" INITIAL 1 
     LABEL "Situaá∆o":R10 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80 BY 3.5.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80 BY 3.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     i-nr-contrato AT ROW 1.25 COL 17 COLON-ALIGNED HELP
          "Permite informar o numero do contrato de fornecimento"
     c-contrato AT ROW 1.25 COL 31.57 COLON-ALIGNED HELP
          "Descriá∆o do contrato modelo" NO-LABEL
     i-num-seq-item AT ROW 2.25 COL 17 COLON-ALIGNED HELP
          "SeqÅància do item no contrato."
     i-numero-ordem AT ROW 3.25 COL 17 COLON-ALIGNED
     c-it-codigo AT ROW 5 COL 17 COLON-ALIGNED HELP
          "C¢digo do Item"
     c-item AT ROW 5 COL 31.57 COLON-ALIGNED NO-LABEL
     i-quantidade AT ROW 6 COL 17 COLON-ALIGNED HELP
          "Quantidade"
     c-un AT ROW 6.04 COL 31.57 COLON-ALIGNED HELP
          "Unidade de medida do item" NO-LABEL
     i-situacao AT ROW 7 COL 17 COLON-ALIGNED
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 4.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
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
         HEIGHT             = 7.29
         WIDTH              = 80.
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

/* SETTINGS FOR FILL-IN c-contrato IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-quantidade IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-situacao IN FRAME f-main
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

&Scoped-define SELF-NAME i-nr-contrato
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-contrato V-table-Win
ON F5 OF i-nr-contrato IN FRAME f-main /* Nr Contrato */
DO:

{include/zoomvar.i &prog-zoom=inzoom/z01in065.w
                   &campo=i-nr-contrato
                   &campozoom=nr-contrato }


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-contrato V-table-Win
ON LEAVE OF i-nr-contrato IN FRAME f-main /* Nr Contrato */
DO:

&if defined(bf_mat_contratos) &then
{include/leave.i &tabela=contrato-for
                 &atributo-ref=des-contrat
                 &variavel-ref=c-contrato   
                 &where="contrato-for.nr-contrato =
                        input frame {&frame-name} i-nr-contrato"}
&else
{include/leave.i &tabela=contrato-for
                 &atributo-ref=des-contrat
                 &variavel-ref=c-contrato   
                 &where="contrato-for.nr-contrato =
                        string(input frame {&frame-name} i-nr-contrato)"}
&endif



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-contrato V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-nr-contrato IN FRAME f-main /* Nr Contrato */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-num-seq-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-num-seq-item V-table-Win
ON F5 OF i-num-seq-item IN FRAME f-main /* SeqÅància Item */
DO:

{include/zoomvar.i &prog-zoom=inzoom/z01in582.w
                   &campo=i-num-seq-item
                   &campozoom=num-seq-item}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-num-seq-item V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-num-seq-item IN FRAME f-main /* SeqÅància Item */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-numero-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-numero-ordem V-table-Win
ON F5 OF i-numero-ordem IN FRAME f-main /* Ordem Compra */
DO:

{include/zoomvar.i &prog-zoom=inzoom/z01in274.w
                   &campo=i-numero-ordem
                   &campozoom=numero-ordem}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-numero-ordem V-table-Win
ON LEAVE OF i-numero-ordem IN FRAME f-main /* Ordem Compra */
DO:

find ordem-compra where ordem-compra.numero-ordem = 
    input frame {&frame-name} i-numero-ordem 
    no-lock no-error.
if not available ordem-compra then do:
    {utp/ut-table.i mgind ordem-compra 1}
    run utp/ut-msgs.p (input "show",
                       input 56    ,
                       input return-value).
    /*Ordem n∆o cadastrada*/
    return "adm-error".
end.
find first w-ordens
    where w-ordens.numero-ordem = input frame {&frame-name} 
          i-numero-ordem no-lock no-error.
if available w-ordens then do:
    {utp/ut-table.i mgind ordem-compra 1}
    run utp/ut-msgs.p (input "show",
                       input 8516  ,
                       input return-value).
    /* ordem j† foi informada */
    return "adm-error".
end.

find item-contrat where item-contrat.num-seq-item =
    input frame {&frame-name} i-num-seq-item
    &if defined(bf_mat_contratos) &then
    and item-contrat.nr-contrat = input frame {&frame-name} i-nr-contrato
    &else
    and item-contrat.nr-contrat = input frame {&frame-name} i-nr-contrato
    &endif
    no-lock no-error.
if not avail item-contrat then do:
    {utp/ut-liter.i Sequància_no_Contrato * L}
    run utp/ut-msgs.p (input "show",
                       input 56    ,
                       input return-value).
    /*cdp/cd9999.i "Sequencia no Contrato nao Cadastrada.*/
    apply "entry" to i-num-seq-item in frame {&frame-name}.
    return "adm-error".
end.

if ordem-compra.it-codigo <> item-contrat.it-codigo then do:
    run utp/ut-msgs.p (input "show",
                       input 8517  ,
                       input ""    ).
    /* {cdp/cd9999.i "Item da ordem diferente do item do contrato. */
    return "adm-error".
end.

find first recebimento where 
    recebimento.numero-ordem = ordem-compra.numero-ordem
    no-lock no-error.
if avail recebimento then do:
    run utp/ut-msgs.p (input "show",
                       input 8518  ,
                       input ""    ).
    /* cdp/cd9999.i "Ordem possui recebimentos. Inclusao nao permitida. */
    return "adm-error".
end.

if ordem-compra.situacao = 2 then do:
    find first pedido-compr where 
        pedido-compr.num-pedido = ordem-compra.num-pedido
        no-lock no-error.
    if avail pedido-compr then do:
        run utp/ut-msgs.p (input "show",
                           input 8519  ,
                           input ""    ).        
        /* cdp/cd9999.i "Ordem ja pertence ao contrato. */
        return "adm-error".
    end.
    find last b-ordem where b-ordem.num-pedido = 
        ordem-compra.num-pedido no-lock no-error.
    if avail b-ordem and b-ordem.numero-ordem =
        ordem-compra.numero-ordem then do:

        find first b-ordem where b-ordem.num-pedido =
            ordem-compra.num-pedido no-lock no-error.
        if avail b-ordem and b-ordem.numero-ordem =
            ordem-compra.numero-ordem then do:
            run utp/ut-msgs.p (input "show",
                               input 8520  ,
                               input ""    ).            
            /* cdp/cd9999.i "Ordem unica de Pedido de Compra. Selecao nao permitida. */
            return "adm-error".
        end.
    end.
    find first recebimento where 
        recebimento.numero-ordem =
        ordem-compra.numero-ordem no-lock no-error.
    if avail recebimento then next.
 end.
 /* -------------------------------------------------------*/


if ordem-compra.situacao = 6 or ordem-compra.situacao = 4 then do:
    run utp/ut-msgs.p (input "show",
                       input 8521  ,
                       input ""    ).    
    /* {cdp/cd9999.i "Situacao da ordem nao permite inclusao ao Contrato."} */
    return "adm-error".
end.
assign de-qtd = 0.
for each prazo-compra where prazo-compra.numero-ordem =
    ordem-compra.numero-ordem no-lock:

    assign de-qtd = de-qtd + prazo-compra.quantidade
        c-un = prazo-compra.un.
end.
display de-qtd @ i-quantidade
        c-un   @ c-un
        with frame {&frame-name}.

find item where item.it-codigo = ordem-compra.it-codigo 
    no-lock no-error.

disp item.it-codigo @ c-it-codigo
     item.desc-item @ c-item
     ordem-compra.situacao @ i-situacao
     with frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-numero-ordem V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-numero-ordem IN FRAME f-main /* Ordem Compra */
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


if i-nr-contrato:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.
if i-num-seq-item:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.
if i-numero-ordem:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.

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

   /*Segue um exemplo de validaá∆o de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valores V-table-Win 
PROCEDURE pi-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output parameter p-nr-contrato like contrato-for.nr-contrato.
def output parameter p-num-seq-item like item-contrat.num-seq-item.
def output parameter p-numero-ordem like ordem-compra.numero-ordem.


&if defined(bf_mat_contratos) &then
assign p-nr-contrato = input frame {&frame-name} i-nr-contrato
&else
assign p-nr-contrato = string(input frame {&frame-name} i-nr-contrato)
&endif
       p-num-seq-item = input frame {&frame-name} i-num-seq-item
       p-numero-ordem = input frame {&frame-name} i-numero-ordem.

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartViewer, and there are no
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


