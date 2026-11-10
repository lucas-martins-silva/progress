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
{include/i-prgvrs.i V19IN274 2.00.00.087 } /*** 010087 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v19in274 MUT}
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

/* Multiplanta */
{cdp/cdcfgmat.i}
{cnp/cnapi020.i3} /* Integracao Contratos - declaracao temp-tables */

def var l-erro       as log    no-undo.
def var i-tipo-movto as int    no-undo.
def var c-msg        as char   no-undo.
{method/dbotterr.i}

{include/boerrtab.i} /*tt-bo-erro*/
{cdp/cd0666.i} /* tt-erro */

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var v-row-parent as rowid no-undo.

def new shared var c-cod-estabel like estabelec.cod-estabel.

def new global shared var gr-ordem-compra as rowid no-undo.

def var l-msg-tela as logical no-undo. 
def var l-erro-co  as logical no-undo.

def var h_principal as handle.
def var h_pcadpai   as handle.
def var h_v28in274  as handle.
DEF VAR h_b61in274  AS HANDLE.
DEF VAR h-bocx225na AS HANDLE  NO-UNDO.
DEF VAR i-seq-erro  AS INTEGER NO-UNDO.
DEF VAR c-return    AS CHAR    NO-UNDO.
DEFINE VARIABLE h-cdapi050 AS HANDLE      NO-UNDO.

def var de-qtd-acum as decimal no-undo.
def buffer b-ordem-compra for ordem-compra.

def var l-desvincula as logical no-undo.
DEF VAR l-integra-paradigma AS LOG NO-UNDO INITIAL NO.

def buffer b-ordem for ordem-compra.

/**  Caraiba
**/
def var l-permissao   as logical no-undo.
def var c-permissao-1 as char    no-undo.
def var c-permissao-2 as char    no-undo.
def buffer b-usuar-mater for usuar-mater.
/*****/
/* Integraá∆o CNP X INP */
{cdp/cd9730.i "new"}
{cdp/cd9731.i}
{cdp/cd9731.i2} /* l-matriz-medicao */

def temp-table tt-erro-inv no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)"
    field c-param  as char.

def var i-num-pedido  like pedido-compr.num-pedido no-undo.

&IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
    {cdp/cd9590.i}    /*Include verificaá∆o Unidade Neg¢cio*/
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
&Scoped-define EXTERNAL-TABLES ordem-compra
&Scoped-define FIRST-EXTERNAL-TABLE ordem-compra


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ordem-compra.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ordem-compra.nr-contrato ~
ordem-compra.numero-ordem ordem-compra.it-codigo 
&Scoped-define ENABLED-TABLES ordem-compra
&Scoped-define FIRST-ENABLED-TABLE ordem-compra
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS ordem-compra.nr-contrato ~
ordem-compra.numero-ordem ordem-compra.it-codigo 
&Scoped-define DISPLAYED-TABLES ordem-compra
&Scoped-define FIRST-DISPLAYED-TABLE ordem-compra
&Scoped-Define DISPLAYED-OBJECTS c-desc-contrato c-desc-item 

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
numero-ordem||y|mgind.ordem-compra.numero-ordem
cod-comprado||y|mgind.ordem-compra.cod-comprado
num-pedido||y|mgind.ordem-compra.num-pedido
nr-contrato||y|mgind.ordem-compra.nr-contrato
cod-roteiro||y|mgind.ordem-compra.cod-roteiro
it-codigo||y|mgind.ordem-compra.it-codigo
sequencia||y|mgind.ordem-compra.sequencia
cod-estabel||y|mgind.ordem-compra.cod-estabel
usuario||y|mgind.ordem-compra.usuario
nr-processo||y|mgind.ordem-compra.nr-processo
cod-refer||y|mgind.ordem-compra.cod-refer
nr-requisicao||y|mgind.ordem-compra.nr-requisicao
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "numero-ordem,cod-comprado,num-pedido,nr-contrato,cod-roteiro,it-codigo,sequencia,cod-estabel,usuario,nr-processo,cod-refer,nr-requisicao"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-desc-contrato AS CHARACTER FORMAT "x(32)" 
     VIEW-AS FILL-IN 
     SIZE 40.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 53 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 3.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ordem-compra.nr-contrato AT ROW 1.33 COL 17.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     c-desc-contrato AT ROW 1.33 COL 34 COLON-ALIGNED HELP
          "Descriá∆o do contrato modelo" NO-LABEL
     ordem-compra.numero-ordem AT ROW 2.33 COL 17.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .88
     ordem-compra.it-codigo AT ROW 3.33 COL 17.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     c-desc-item AT ROW 3.33 COL 34 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.ordem-compra
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
         HEIGHT             = 3.71
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-contrato IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

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

  /* No Foreign keys are accepted by this SmartObject. */

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
  {src/adm/template/row-list.i "ordem-compra"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ordem-compra"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

/*Alterado para que seja poss°vel executar o ponto epc de trigger j† que existia 
  um disable da trigger da tabela prazo-compra*/
ON delete OF prazo-compra OVERRIDE DO:
    {include/i-epc102.i prazo-compra}
END.

DISABLE TRIGGERS FOR LOAD OF cotacao-item.

def var c-nr-contrato like contrato-for.nr-contrato no-undo.

    /* Code placed here will execute PRIOR to standard behavior. */

    /**  Caraiba
    **/
    run cdp/cdapi181.p ( input  c-seg-usuario,
                         input  2,
                         input  3,
                         output l-permissao).
    if not l-permissao then do:
        {utp/ut-liter.i Eliminar * r}
        assign c-permissao-1 = trim(return-value).
        {utp/ut-liter.i Itens_do_Contrato * r}
        assign c-permissao-2 = trim(return-value).
        run utp/ut-msgs.p (input "show"      ,
                           input 18728       ,
                           input c-permissao-1 + "~~" + c-permissao-2).
        return "adm-error".    
    end.

    find contrato-for where
        contrato-for.nr-contrato = ordem-compra.nr-contrato
        no-lock no-error.
    find usuar-mater where
        usuar-mater.cod-usuar = c-seg-usuario
        no-lock no-error.
    find b-usuar-mater where
        b-usuar-mater.cod-usuar = contrato-for.gestor-tecnico
        no-lock no-error.           
    if usuar-mater.cont-acesso-cc and
        usuar-mater.sc-codigo <> b-usuar-mater.sc-codigo then do:
        {utp/ut-liter.i Eliminar_Parcelas_de_Contratos * r}
        assign c-permissao-1 = trim(return-value).
        {utp/ut-liter.i de_outro_Centro_de_Custo * r}
        assign c-permissao-2 = trim(return-value).
        run utp/ut-msgs.p (input "show"      ,
                           input 18728       ,
                           input c-permissao-1 + "~~" + c-permissao-2).
        return "adm-error".    
    end.

    if usuar-mater.perm-alt-cont = no and
        usuar-mater.cod-usuario <> b-usuar-mater.cod-usuario then do:
        {utp/ut-liter.i Eliminar_Parcelas_de_Contratos * r}
        assign c-permissao-1 = trim(return-value).
        {utp/ut-liter.i de_outro_Usu†rio * r}
        assign c-permissao-2 = trim(return-value).
        run utp/ut-msgs.p (input "show"      ,
                           input 18728       ,
                           input c-permissao-1 + "~~" + c-permissao-2).
        return "adm-error".    
    end.
    /*****/

    &if defined(bf_mat_contratos) &then
    run ccp/ccapi199.p("Ordem-contrato",rowid(ordem-compra),output l-erro).
    if  l-erro then do:
        /*Ordem so pode ser alterado no estabelecimento executor.*/
        {utp/ut-liter.i Ordem}
        assign c-msg = trim(return-value).
        {utp/ut-liter.i Executor}
        run utp/ut-msgs.p("show",18200,c-msg + "~~" + trim(return-value)).        
    end.
    &endif

    find item-contrat where
         item-contrat.nr-contrato  = ordem-compra.nr-contrato  and
         item-contrat.num-seq-item = ordem-compra.num-seq-item no-lock no-error.
    if  not avail item-contrat then do:
        {utp/ut-field.i mgind ordem-compra num-seq-item 1}
        /* Sequencia do Item da Ordem nao cadastrada */
        run utp/ut-msgs.p ("show",47,trim(return-value)).
        return "adm-error".
    end.

    if  item-contrat.ind-tipo-control <> 2 then do:
        /* "Item de Contrato nao Controlado por Ordem */
        run utp/ut-msgs.p ("show",8504,"").
        return "adm-error".
    end.

    if  can-find (first recebimento where recebimento.numero-ordem = ordem-compra.numero-ordem) or
        ordem-compra.situacao = 6 then do:
        /* Ordem ja possui recebimentos */
        run utp/ut-msgs.p ("show",8678,"").
        return "adm-error".
    end.

    if  can-find(first prazo-compra where prazo-compra.numero-ordem = ordem-compra.numero-ordem 
                 and prazo-compra.dec-1 > 0) then do:    
        /* Ordem possui parcela com quantidade alocada */
        run utp/ut-msgs.p ("show",18446,"").
        return "adm-error".
    end.

    if can-find(first prazo-compra where prazo-compra.numero-ordem = ordem-compra.numero-ordem 
                 and prazo-compra.qtd-rec-for > 0) then do:        
        run utp/ut-msgs.p (input "show", input 19586, input "").
        /* A parcela n∆o pode ser eliminada pois a mesma foi recebida */
        return no-apply.
    end. 

    if can-find(first prazo-compra where prazo-compra.numero-ordem = ordem-compra.numero-ordem 
                 and prazo-compra.qtd-rej-for > 0) then do:        
        run utp/ut-msgs.p (input "show", input 19586, input "").
        /* A parcela n∆o pode ser eliminada pois a mesma foi recebida */
        return no-apply.
    end. 


    for first evento-ped field (numero-ordem ind-sit-event)
        where evento-ped.numero-ordem = ordem-compra.numero-ordem
        no-lock: end.
    if  avail evento-ped and
       (evento-ped.ind-sit-event = 2 or
        evento-ped.ind-sit-event = 1) then do:
        /*Ordem possui eventos Pendentes/Realizados */
        run utp/ut-msgs.p ("show",8679,"").
        return "adm-error".
    end.

    if l-integra-cn-in and ordem-compra.num-ord-inv <> 0 then
       assign i-num-pedido = ordem-compra.num-pedido.


    assign c-nr-contrato = ordem-compra.nr-contrato.
    find b-ordem where rowid(b-ordem) = rowid(ordem-compra) exclusive-lock no-error.

    IF  l-matriz-medicao AND
        ordem-compra.situacao <> 4 THEN DO:

        FOR EACH matriz-rat-med EXCLUSIVE-LOCK
            WHERE matriz-rat-med.nr-contrato     = ordem-compra.nr-contrato
              AND matriz-rat-med.num-seq-item    = ordem-compra.num-seq-item
              AND matriz-rat-med.numero-ordem    = ordem-compra.numero-ordem
              AND matriz-rat-med.num-seq-event   = 0
              AND matriz-rat-med.num-seq-medicao = 0:
            DELETE matriz-rat-med.
        END.
    END.

    /* Integracao Contratos - limpa registros temp-table integraá∆o */
    {cnp/cnapi020.i4}

    /* Integracao Contratos - criar registro para inclus∆o */
    {cnp/cnapi020.i1 2 3 "CN0304" " " "ordem-compra" ordem-compra}

    if  ordem-compra.sit-ordem-contrat <> 2 then do:
        /* Eliminar ou Desvincular ordem de compra? */
        run utp/ut-msgs.p (input "show", input 16429, input "").
        if  return-value = "yes" then
            assign l-desvincula = no
                   b-ordem.situacao = 5
                   &if defined(bf_mat_contratos) &then
                   b-ordem.nr-contrato = 0.
                   &else
                   b-ordem.nr-contrato = "". &endif
        ELSE DO:
            if ordem-compra.ordem-emitida then do:
                run utp/ut-msgs.p (input "show",
                                   input 18893, /*Ordem de compra n∆o pode ser disvinculada porque j† foi emitida.*/
                                   input "").
                return "adm-error":U.
            end.   
            assign l-desvincula = yes
                   b-ordem.num-pedido   = 0
                   &if defined(bf_mat_contratos) &then
                   b-ordem.nr-contrato  = 0
                   &else
                   b-ordem.nr-contrato  = "" &endif
                   b-ordem.num-seq-item = 0
                   b-ordem.situacao     = 1
                   b-ordem.cod-emitente = 0
                   b-ordem.data-pedido  = ?.
        END.
    end.
    else do:
        /* Eliminar ou Desvincular ordem de compra? */
        run utp/ut-msgs.p (input "show", input 16429, input "").
        if  return-value = "yes" THEN DO:

            /*passa situaá∆o da ordem, parcela para  eliminada e passa a situacao da ordem no contrato pra cancelada.*/
            assign l-desvincula = YES
                   b-ordem.situacao = 4 /*Eliminada*/
                   ordem-compra.sit-ordem-contrat = 3. /*Cancelada*/
                   
        END.
        else do:

            /*mostra a mensagem que n∆o Ç poss°vel desvincular ordens emitidas.*/
            if ordem-compra.ordem-emitida OR
               ordem-compra.sit-ordem-contrat = 2 then do:
                run utp/ut-msgs.p (input "show",
                                   input 18893, /*Ordem de compra n∆o pode ser disvinculada porque j† foi emitida.*/
                                   input "").
                return "adm-error":U.
            end.
        end.
    end.

    assign c-cod-estabel = ordem-compra.cod-estabel.
    for each  prazo-compra
        where prazo-compra.numero-ordem = ordem-compra.numero-ordem exclusive-lock:

        /* Integracao Contratos - criar registro para inclus∆o */
        {cnp/cnapi020.i1 2 3 "CN0304" " " "prazo-compra" prazo-compra}

        if  item-contrat.log-control-event then
        run cnp/cnapi003.p (input rowid(item-contrat),
                            input (prazo-compra.qtd-do-for * (-1)),
                            input ((prazo-compra.qtd-do-for * 
                                   ordem-compra.pre-unit-for) * (-1)),
                            input 0, input 0,
                            input 0, input 0,
                            input c-cod-estabel,
                            output l-msg-tela,       
                            output l-erro-co,
                            input-output table tt-erro).        
        else
        run cnp/cnapi003.p (input rowid(item-contrat),
                            input (prazo-compra.qtd-do-for * (-1)),
                            input ((prazo-compra.qtd-do-for * 
                                   ordem-compra.pre-unit-for) * (-1)),
                            input (prazo-compra.qtd-do-for * (-1)),
                            input ((prazo-compra.qtd-do-for * 
                                   ordem-compra.pre-unit-for) * (-1)),
                            input (prazo-compra.qtd-rec-forn * (-1)),
                            input ((prazo-compra.qtd-rec-forn *
                                   ordem-compra.pre-unit-for) * (-1)),
                            input c-cod-estabel,
                            output l-msg-tela,       
                            output l-erro-co,
                            input-output table tt-erro).
        find first tt-erro no-lock no-error. 
        if avail tt-erro then 
           run cdp/cd0666.w (input table tt-erro).                                                

        if l-erro-co then next.

        if  ordem-compra.sit-ordem-contrat = 1 then do:
            if l-integra-cn-in and ordem-compra.num-ord-inv <> 0 and l-desvincula then do:          
            &if defined(bf_mat_controle_verba) &then                
                run inp/inapi358.p (input rowid(prazo-compra), no).
            &endif
            end.
            &if defined(bf_mat_contratos) &then
            if  l-desvincula then
            &else
            if not l-desvincula then
               delete prazo-compra .
            else 
            &endif            
               assign prazo-compra.situacao = 1
                      prazo-compra.quantidade  = prazo-compra.quant-saldo
                                               + prazo-compra.quant-receb
                                               - prazo-compra.quant-rejeit
                      prazo-compra.qtd-do-forn = prazo-compra.qtd-sal-forn
                                               + prazo-compra.qtd-rec-forn
                                               - prazo-compra.qtd-rej-forn.      
        end.
        ELSE 
            if l-desvincula then
                assign prazo-compra.situacao = 4. /*Eliminada*/
    end.
    /* Integracao Contratos - executa API integraá∆o e valida erros */  
    {cnp/cnapi020.i2 "NOK" "yes"}

    &if defined(bf_mat_contratos) &then
    if  not avail param-global then
        find first param-global no-lock no-error.
    if  avail param-global and
        param-global.modulo-mp then do:
        assign i-tipo-movto = if l-desvincula then 2 else 3.
        if  l-desvincula then do:
            /** Guarda numero do contrato para 
                atualizar saldos na outra planta **/
            create tt-erro.
            assign tt-erro.i-sequen = 0
                   tt-erro.cd-erro  = 0 
                   tt-erro.mensagem = string(c-nr-contrato).
        end.
        run ccp/ccapi200.p (input "Ordem-contrato":U,
                            input rowid(ordem-compra),
                            input i-tipo-movto,
                            input-output table tt-erro).
        for each tt-erro
            where tt-erro.cd-erro = 0:
            delete tt-erro.
        end.
    end.
    &endif
    
    /* retirar o relacionamento existente, quando a ordem tiver como origem uma SC, voltando ela para aberta e retornando o saldo , quando for eleiminaá∆o da ordem*/
    
    IF NOT l-desvincula THEN DO:

       
      IF ordem-compra.nr-requisicao <> 0  THEN DO:
           
        FOR EACH it-requisicao WHERE it-requisicao.nr-requisicao = ordem-compra.nr-requisicao 
                                AND  it-requisicao.numero-ordem = ordem-compra.numero-ordem EXCLUSIVE-LOCK:

          

          ASSIGN it-requisicao.situacao = 1
                 it-requisicao.qt-atendida = 0
                 it-requisicao.qt-a-devolver = 0
                 it-requisicao.qt-a-atender = it-requisicao.qt-requisitada
                 it-requisicao.numero-ordem = 0.
        END.
         /* verifica se existe pelo menos um item com a situaá∆o "Aberta" para mudar tambÇm a situaá∆o da requisicao - mesma regra do cc0300*/
        FIND FIRST it-requisicao WHERE it-requisicao.nr-requisicao = ordem-compra.nr-requisicao
                                   AND it-requisicao.situacao = 1 NO-LOCK NO-ERROR.
        IF AVAIL it-requisicao THEN DO:
         
          FIND FIRST requisicao WHERE requisicao.nr-requisicao = ordem-compra.nr-requisicao EXCLUSIVE-LOCK NO-ERROR.
          IF AVAIL requisicao THEN DO: 
            ASSIGN requisicao.situacao = 1.
          END.
    
        END.
    
      END.
    END.

    if l-integra-cn-in and ordem-compra.num-ord-inv <> 0 then do:    
       if l-desvincula then do:
          find pedido-compr where 
               pedido-compr.num-pedido = i-num-pedido
               no-lock no-error.                    
          /* Acerto situacao:  "E" para "A" */
          for each prazo-compra no-lock
               where prazo-compra.numero-ordem = ordem-compra.numero-ordem:
               run inp/in2110a.p (input rowid(prazo-compra), "M").        
          end.
          run inp/in2110.p (input rowid(ordem-compra), "M").          
          run inp/in2110b.p.

          run inp/in2104.p (rowid(ordem-compra),rowid(pedido-compr), "E",
                            input-output table tt-erro-inv, yes).
          &if defined(bf_mat_controle_verba) &then
              run inp/inapi357.p(rowid(ordem-compra),yes). 
          &endif.  
          for each cotacao-item field (numero-ordem) no-lock
               where cotacao-item.numero-ordem = ordem-compra.numero-ordem:
                RUN inp/in2103.p (ROWID(cotacao-item),"E"). /* elimina cotacao-inv */            
          end. 
       end.       
       else do:
          run inp/in2104.p (rowid(ordem-compra),rowid(pedido-compr), "E",
                            input-output table tt-erro-inv, yes).
          &if defined(bf_mat_controle_verba) &then
              run inp/inapi357.p(rowid(ordem-compra),yes). 
          &endif.            
           for each cotacao-item field (numero-ordem) no-lock
               where cotacao-item.numero-ordem = ordem-compra.numero-ordem:
                RUN inp/in2103.p (ROWID(cotacao-item),"E"). /* elimina cotacao-inv */
           end. 
           for each prazo-compra exclusive-lock
               where prazo-compra.numero-ordem = ordem-compra.numero-ordem:
               if l-integra-cn-in and ordem-compra.num-ord-inv <> 0 then
                  run inp/in2110a.p (input rowid(prazo-compra), "E").        
          end.
          run inp/in2110.p (input rowid(ordem-compra), "E").          
          run inp/in2110b.p.
       end.       
    end.   

    &if defined(bf_mat_contratos) &then
    if  not l-desvincula then
    for each prazo-compra exclusive-lock
        where prazo-compra.numero-ordem = ordem-compra.numero-ordem:
        delete prazo-compra.        
    end.
    &endif

    /*
    ** Integraá∆o M¢dulo Importaá∆o
    */

    FIND FIRST param-global NO-LOCK NO-ERROR.
    IF AVAIL param-global AND
             param-global.modulo-07 THEN DO:
        FIND emitente WHERE
             emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK NO-ERROR.
        IF AVAIL emitente AND
                 emitente.natureza = 3 OR
                 emitente.natureza = 4 THEN DO:
            RUN cxbo/bocx225na.p PERSISTENT SET h-bocx225na.
            RUN OpenQueryStatic IN h-bocx225na (INPUT "Main":U).
            RUN GoToOrdemCompra IN h-bocx225na (INPUT ordem-compra.numero-ordem).
            DELETE PROCEDURE h-bocx225na.

            IF RETURN-VALUE = "" OR
               RETURN-VALUE = "OK":U THEN DO:
                CREATE tt-bo-erro.
                ASSIGN i-seq-erro = i-seq-erro + 1.
                {utp/ut-liter.i Contrato_da_Ordem_de_Compra * L}
                ASSIGN c-return = TRIM(RETURN-VALUE).
                {utp/ut-liter.i Ordem_de_Compra_j†_est†_vinculada_a_um_Embarque * L}
                ASSIGN tt-bo-erro.parametros = c-return + "~~" + TRIM(RETURN-VALUE).
                RUN utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 26802,
                                   INPUT tt-bo-erro.parametros).
                ASSIGN tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 26802
                       tt-bo-erro.mensagem = RETURN-VALUE.
                UNDO, RETURN "NOK":U.
            END.
        END.
    END.
    /***********************************************************************************/

    for each cotacao-item field (numero-ordem)
        where cotacao-item.numero-ordem = ordem-compra.numero-ordem EXCLUSIVE-LOCK:

        for each  desp-cotacao-item 
            where desp-cotacao-item.numero-ordem = cotacao-item.numero-ordem
              and desp-cotacao-item.cod-emitente = cotacao-item.cod-emitente
              and desp-cotacao-item.it-codigo    = cotacao-item.it-codigo
              and desp-cotacao-item.seq-cotac    = cotacao-item.seq-cotac exclusive-lock:                        

            delete desp-cotacao-item.
        end.

        delete cotacao-item.
    end. 
    
    &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN 
        IF  l-desvincula THEN DO:
            RUN cnp/cn9176.p (INPUT ordem-compra.num-pedido,
                              INPUT ordem-compra.numero-ordem,
                              INPUT 1, /*Parcela*/
                              INPUT 4, /*Eliminacao Ordem COntrato*/
                              INPUT ?, /*Preco Anterior*/
                              INPUT ?, /*Preco Atual*/
                              INPUT ?, /*Qtde Anterior*/
                              INPUT ?, /*Qtde Atual*/
                              INPUT ?, /*Data Anterior*/
                              INPUT ?, /*Data Atual*/
                              INPUT STRING(ordem-compra.nr-contrato)). 
            /*
            {inp/in0000.i INT(1)
                          Ordem_de_compra_desvinculada_do_contrato
                          STRING(ordem-compra.nr-contrato)
                          ''}
            */              
        END.
        ELSE DO:
            RUN cnp/cn9176.p (INPUT ordem-compra.num-pedido,
                              INPUT ordem-compra.numero-ordem,
                              INPUT 1, /*Parcela*/
                              INPUT 3, /*Eliminacao*/
                              INPUT ?, /*Preco Anterior*/
                              INPUT ?, /*Preco Atual*/
                              INPUT ?, /*Qtde Anterior*/
                              INPUT ?, /*Qtde Atual*/
                              INPUT ?, /*Data Anterior*/
                              INPUT ?, /*Data Atual*/
                              INPUT "":U). 
            /*
            {inp/in0000.i INT(1)
                          Eliminaá∆o_da_ordem_de_compra
                          ''
                          ''}
            */              
        END.
    &ENDIF
    

    IF l-integra-paradigma THEN DO:
        RUN ccp/ccapi342.p (INPUT  "ordem-compra":U,
                            INPUT  ROWID(ordem-compra),
                            OUTPUT TABLE RowErrors).

        IF CAN-FIND(first RowErrors) then DO:
            run cdp/cd0666.w (input table RowErrors).
            return "adm-error":U.
        END.
    END.
    
    /* Dispatch standard ADM method.                             */

    /*** Siscoserv ***/
    IF NOT VALID-HANDLE(h-cdapi050) THEN 
        RUN cdp/cdapi050.p PERSISTENT SET h-cdapi050.
    RUN pi-siscoserv-ativo IN h-cdapi050.
    IF RETURN-VALUE = "OK":U THEN
        RUN pi-apaga-ord-compra-sis IN h-cdapi050 (INPUT ordem-compra.numero-ordem,
                                                   INPUT ordem-compra.num-pedido).
    IF VALID-HANDLE(h-cdapi050) THEN DO:
        DELETE PROCEDURE h-cdapi050. 
        ASSIGN h-cdapi050 = ?.
    END.
    /*** Siscoserv ***/

    if not l-desvincula then do:
        /**** Aprovaá∆o Eletrìnica ****/
        find first param-compra  no-lock no-error.
        find first param-contrat no-lock no-error.
        if  param-compra.log-1 and param-contrat.log-1
        then do:
            if avail item-contrat
            then
                if item-contrat.val-total = 0 
                then run cdp/cdapi171.p (8, 3, rowid(ordem-compra)).
        end.
        /**** fim ****/
        RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
    end.
    else 
        RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

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

  find contrato-for where contrato-for.nr-contrato = ordem-compra.nr-contrato no-lock no-error.
  assign c-desc-contrato = if avail contrato-for then contrato-for.des-contrat else "":U.

  find item where item.it-codigo = ordem-compra.it-codigo no-lock no-error.
  assign c-desc-item = if avail item then item.desc-item else "":U.

  find item-contrat 
      where item-contrat.nr-contrato  = ordem-compra.nr-contrato
        and item-contrat.num-seq-item = ordem-compra.num-seq-item
        and item-contrat.it-codigo    = ordem-compra.it-codigo        
        no-lock no-error.
  if  avail item-contrat then do:
      if  item-contrat.ind-tipo-control = 1
      or  item-contrat.ind-tipo-control = 3 then do:
          run state-changed in h_principal (input h_pcadpai,"nao-habilitar":U).
          if  valid-handle(h_v28in274) then
              run enable-bt-alterar in h_v28in274(input no).
      end.

      if  ordem-compra.situacao <> 4    /* Eliminada */   
      and item-contrat.ind-tipo-control = 2 then do:
          run state-changed in h_principal (input h_pcadpai,"habilitar":U).
          if  valid-handle(h_v28in274) then
              run enable-bt-alterar in h_v28in274(input yes).          
      end.
      ELSE DO:
          run state-changed in h_principal (input h_pcadpai,"nao-habilitar":U).
          if  valid-handle(h_v28in274) then
              run enable-bt-alterar in h_v28in274(input NO).
      END.
  end.
  else do:
      run state-changed in h_principal (input h_pcadpai,"nao-habilitar":U).
      if  valid-handle(h_v28in274) then
          run enable-bt-alterar in h_v28in274(input no).      
  end.
  IF (AVAIL contrato-for AND contrato-for.ind-control-rec = 1) OR
     (AVAIL contrato-for AND item-contrat.ind-tipo-control = 1) THEN
      RUN state-changed IN h_principal (INPUT h_pcadpai, "habilitar-modifica":U).

  &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
   IF  AVAIL ITEM AND ITEM.tipo-contr = 4  /* Item DÇbito Direto */
   AND (AVAIL item-contrat
   AND item-contrat.ind-tipo-control = 2   /*Controle por Ordem */
   AND item-contrat.log-control-event = NO
   AND (param-contrat.log-rat-ord = YES     /* Controle rateio para contratos controlados por Ordem*/
    OR l-mat-unid-negoc)) THEN
       RUN pi-habilita-bt-matriz IN h_principal(YES).
   ELSE
       RUN pi-habilita-bt-matriz IN h_principal(NO).

   /* Iteraá∆o 2 */
   IF   param-contrat.log-rat-ord = NO /* Controle rateio para contratos controlados por Ordem*/
   AND (CAN-FIND(FIRST matriz-rat-contr
                 WHERE matriz-rat-contr.nr-contrato = ordem-compra.nr-contrato)
    OR  CAN-FIND(FIRST matriz-rat-item
                 WHERE matriz-rat-item.nr-contrato = ordem-compra.nr-contrato)
    OR ((AVAIL ordem-compra AND ordem-compra.ordem-servic > 0) AND 
        CAN-FIND (FIRST unid-neg-ordem 
                  WHERE unid-neg-ordem.numero-ordem = ordem-compra.numero-ordem)) /* usado em ordem de MI */ 
       ) THEN DO:
       RUN pi-habilita-bt-matriz IN h_principal(NO).
   END.
  &ENDIF
  
  IF VALID-HANDLE(h_b61in274) THEN DO:
      RUN local-open-query     IN h_b61in274.
      RUN pi-item-contrato     IN h_b61in274.
  END.

    /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    FIND FIRST funcao NO-LOCK
         WHERE funcao.cd-funcao = "spp-portal-paradigma":U
           AND funcao.ativo NO-ERROR.
    
    IF AVAIL funcao THEN DO:
    
        IF NOT AVAIL param-compra THEN
            FIND FIRST param-compra NO-LOCK NO-ERROR.
    
        IF &if "{&bf_mat_versao_ems}" < "2.09" &then
               SUBSTRING(param-compra.char-2,103,1) = "S":U
           &ELSE
               param-compra.log-portal-paradigma
           &ENDIF
        THEN DO:
            ASSIGN l-integra-paradigma = YES.
        END.
    END.

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

  if avail ordem-compra then 
   assign gr-ordem-compra = rowid(ordem-compra).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-handle V-table-Win 
PROCEDURE pi-passa-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-handle  as handle.
def input parameter p-pcadpai as handle.
def input parameter p-viewer  as handle.
def input parameter p-browse  as handle.

assign h_principal = p-handle
       h_pcadpai   = p-pcadpai
       h_v28in274  = p-viewer
       h_b61in274  = p-browse.
                   

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
  {src/adm/template/sndkycas.i "numero-ordem" "ordem-compra" "numero-ordem"}
  {src/adm/template/sndkycas.i "cod-comprado" "ordem-compra" "cod-comprado"}
  {src/adm/template/sndkycas.i "num-pedido" "ordem-compra" "num-pedido"}
  {src/adm/template/sndkycas.i "nr-contrato" "ordem-compra" "nr-contrato"}
  {src/adm/template/sndkycas.i "cod-roteiro" "ordem-compra" "cod-roteiro"}
  {src/adm/template/sndkycas.i "it-codigo" "ordem-compra" "it-codigo"}
  {src/adm/template/sndkycas.i "sequencia" "ordem-compra" "sequencia"}
  {src/adm/template/sndkycas.i "cod-estabel" "ordem-compra" "cod-estabel"}
  {src/adm/template/sndkycas.i "usuario" "ordem-compra" "usuario"}
  {src/adm/template/sndkycas.i "nr-processo" "ordem-compra" "nr-processo"}
  {src/adm/template/sndkycas.i "cod-refer" "ordem-compra" "cod-refer"}
  {src/adm/template/sndkycas.i "nr-requisicao" "ordem-compra" "nr-requisicao"}

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
  {src/adm/template/snd-list.i "ordem-compra"}

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

