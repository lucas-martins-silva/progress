&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN356FX 2.00.00.014 } /*** "010014" 24/11/2023 13:25:22 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin356fx MUT}
&ENDIF
/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN356
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName prazo-compra
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin356.i RowObject}
{cdp/cd9730.i "new"} /* t-invest */

def temp-table tt-erro-mp
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

def temp-table ttParametrosTela no-undo
    field parametro as char
    field valor     as char.


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName}  FOR {&TableName}.
DEFINE BUFFER b-prazo         FOR {&TableName}.
DEFINE BUFFER bf-ordem-compra FOR ordem-compra.
DEFINE BUFFER bf-ordem        FOR ordem-compra.

{utp/ut-glob.i}

def var nova-dt                 as   date                      no-undo.
def var dt-ressup               as   integer                   no-undo.
def var de-tot-parcela          as   decimal                   no-undo.
def var i-pedido                like ped-venda.nr-pedcli       no-undo.
def var i-seq-item              like prazo-compra.nr-sequencia no-undo.
def var l-ord-inv               as   logical init no           no-undo.
def var l-invest                as   logical init no           no-undo.
def var l-primeiro              as   logical                   no-undo.
def var de-indice               as   decimal                   no-undo.
def var l-ind-drop-shipment     as   logical init no           no-undo.
def var c-motivo                as   char    format "x(76)"    no-undo.
def var i-moeda-lim             as   integer                   no-undo.
def var i-tipo-moeda            as   integer                   no-undo.
def var de-valor-doc            as   decimal                   no-undo.
def var de-valor-lim            as   decimal                   no-undo.
def var c-moeda-lim             as   char                      no-undo.
def var c-tipo-moeda            as   char                      no-undo.
def var l-pendente              as   logical                   no-undo.
def var l-atualiza-quantidade   as   logical init no           no-undo.

/* Multi-Planta */
def var i-tipo-movto       as integer            no-undo.
def var l-cria             as logical            no-undo.
def var i-seq-smc          as integer            no-undo.
def var i-seq-smc1         as integer            no-undo.
def var i-cont-parc        as int     initial 0  no-undo. 

/* {cdp/cd7300.i1}                               */
/* {cdp/cd7300.i2}                               */
/* {mcinc/mcapi064.i}                            */
/* {mcinc/mcapi065.i}                            */
/* {mpp/mpapi011.i}                              */
/* {cdp/cd9730.i "new"} /*temp-table t-invest */ */
{fch/fchmat/fchmataddpurchaserequisitions.i4 ttParamConfigRules} /* ttParamConfigRules */






/* Vari†veis para o setInterfaceParameters */
def var l-ExportaPedidoCliente      as log                          no-undo.
def var l-QtdMenorLoteMinimo        as log                          no-undo.
def var l-QtdDifLoteMultiplo        as log                          no-undo.

def var de-total-parcela            as dec format ">>>>,>>9.9999"   no-undo.
def var c-diferencas                as char                         no-undo. /* vari†vel utilizada para armazenar o resultado da comparaá∆o de registros alterados */
def var c-desc-eve1                 as char                         no-undo.
def var c-desc-eve2                 as char                         no-undo.
def var i-NumeroOrdem               like ordem-compra.numero-ordem  no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 23.33
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    run afterCreateUpdateRecord.

    assign prazo-compra.it-codigo    = ordem-compra.it-codigo
           prazo-compra.situacao     = ordem-compra.situacao
           prazo-compra.data-alter   = ?
           prazo-compra.cod-alter    = no.

    /*** INVESTIMENTOS ***/
    if  connected("mginv")
    and param-global.modulo-in
    and ordem-compra.num-ord-inv <> 0 then do:
        run inp/in2110a.p (input rowid(prazo-compra),
                           input "I").
            
        if ordem-compra.num-pedido <> 0 then
            run inp/in2112.p (input rowid(ordem-compra),
                              input "M").
    end.
    /*********************/

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateUpdateRecord DBOProgram 
PROCEDURE afterCreateUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    find first ordem-compra
        where ordem-compra.numero-ordem = RowObject.numero-ordem exclusive-lock no-error.
    assign prazo-compra.natureza     = ordem-compra.natureza
           prazo-compra.quant-saldo  = prazo-compra.quantidade
           ordem-compra.usuario      = c-seg-usuario
           ordem-compra.data-atualiz = today
           ordem-compra.hora-atualiz = string(time,"hh:mm:ss").

    /*** INVESTIMENTOS ***/
    if  connected("mginv")
    and param-global.modulo-in
    and ordem-compra.num-ord-inv <> 0 then do:
        run inp/inapi358.p(input RowObject.r-rowid,
                           input yes). /* atualiza valores */
        if  return-value = "NOK" then
            return "NOK".
    end.
    /*********************/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-nivel        AS INTEGER  INITIAL 1    NO-UNDO.
    DEFINE VARIABLE l-atualiza     AS LOGICAL  INITIAL YES  NO-UNDO.

    run afterCreateUpdateRecord.

    REPEAT WHILE PROGRAM-NAME(i-nivel) <> ?:
        IF PROGRAM-NAME(i-nivel) MATCHES "*cc0605*":U THEN DO:
           ASSIGN l-atualiza = NO.
           LEAVE.
        END.
        ASSIGN i-nivel = i-nivel + 1.
    END.
    
    assign prazo-compra.data-alter   = today
           prazo-compra.cod-alter    = yes
           prazo-compra.quantid-orig = prazo-compra.quantidade.
           
    IF l-atualiza THEN
        ASSIGN prazo-compra.data-orig    = prazo-compra.data-entrega.

    /* Exportar alteraá‰es de Clientes/Pedidos para outras parcelas */
    if  l-ExportaPedidoCliente then do:

        if  lookup("nome-abrev",c-diferencas)   <> 0
        or  lookup("pedido-clien",c-diferencas) <> 0
        or  lookup("nr-sequencia",c-diferencas) <> 0 then do:
    
            for each bfprazo-compra
                where bfprazo-compra.numero-ordem = RowObject.numero-ordem
                  and rowid(bfprazo-compra)       <> RowObject.r-rowid exclusive-lock:
                
                assign bfprazo-compra.nome-abrev   = if  bfprazo-compra.nome-abrev = RowObject.nome-abrev then RowObject.nome-abrev
                                                     else bfprazo-compra.nome-abrev
    
                       bfprazo-compra.pedido-clien = if  bfprazo-compra.pedido-clien = RowObject.pedido-clien
                                                     and bfprazo-compra.nome-abrev   = RowObject.nome-abrev
                                                     and bfprazo-compra.nr-sequencia = RowObject.nr-sequencia then RowObject.pedido-clien
                                                     else bfprazo-compra.pedido-clien   
    
                       bfprazo-compra.nr-sequencia = if  bfprazo-compra.nr-sequencia = RowObject.nr-sequencia
                                                     and bfprazo-compra.nome-abrev   = RowObject.nome-abrev
                                                     and bfprazo-compra.nr-sequencia = RowObject.nr-sequencia then RowObject.nr-sequencia
                                                     else bfprazo-compra.nr-sequencia.
            end.  
        end.
    end.

    /*** INVESTIMENTOS ***/
    if  connected("mginv")
    and param-global.modulo-in
    and ordem-compra.num-ord-inv <> 0 then
        run inp/in2110a.p (input rowid(prazo-compra),
                           input "M").
    /*********************/
    
    
    
    
    
    
    
    
    
    
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    run beforeCreateUpdateRecord.

    if  item.tipo-con-est <> 4 then /* Referància */
        assign RowObject.cod-refer = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateUpdateRecord DBOProgram 
PROCEDURE beforeCreateUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    find first ordem-compra
        where ordem-compra.numero-ordem = RowObject.numero-ordem exclusive-lock no-error.
    if  avail ordem-compra then do:
        assign de-total-parcela = 0.
        for each bfprazo-compra field (numero-ordem quantidade)
            where bfprazo-compra.numero-ordem =  RowObject.numero-ordem
              and rowid(bfprazo-compra)       <> RowObject.r-rowid no-lock:
            assign de-total-parcela = de-total-parcela + bfprazo-compra.quantidade.
        end.
        assign ordem-compra.qt-solic = de-total-parcela.
    end.

    /*** INVESTIMENTO ***/
    if  connected("mginv")
    and param-global.modulo-in 
    and ordem-compra.num-ord-inv <> 0 then do:    
        run inp/in2110a.p (input RowObject.r-rowid,
                           input "E").

        if  avail ordem-compra then
            run inp/in2110.p (input rowid(ordem-compra),
                              input "M").

        run inp/in2110b.p.
    end.
    /********************/

    /*** MULTIPLANTA ***/
    if  param-global.modulo-mp then do:

        empty temp-table tt-erro-mp.

        run ccp/ccapi200.p(input "Prazo-compra",
                           input RowObject.r-rowid,
                           input 3, /* Eliminaá∆o */
                           input-output table tt-erro-mp).
    
        if  can-find(first tt-erro-mp) then do:
            for each tt-erro-mp:
                run _insertErrorManual (input tt-erro-mp.cd-erro,
                                        input "EMS",
                                        input "ERROR",
                                        input tt-erro-mp.mensagem,
                                        input "",
                                        input "").
            end.
            return "NOK".
        end.
    end.
    /*******************/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    run beforeCreateUpdateRecord.

    /*** INVESTIMENTOS ***/
    if  connected("mginv")
    and param-global.modulo-in
    and ordem-compra.num-ord-inv <> 0 then
        run inp/inapi358.p(input RowObject.r-rowid,
                           input no). /* atualiza valores */
    /*********************/

    if  lookup("data-entrega",c-diferencas) <> 0 then do:
    
        for each evento-ped
           where evento-ped.numero-ordem = RowObject.numero-ordem 
            and (   evento-ped.seq-evento = 1
                 or evento-ped.seq-evento = 2) exclusive-lock: 

            {utp/ut-liter.i Cotar_Ordem_n£mero}
            assign c-desc-eve1 = return-value.
            {utp/ut-liter.i Fechar_pedido_para_a_Ordem_n£mero}
            assign c-desc-eve2 = return-value.

            if  evento-ped.des-event = c-desc-eve1 + " " + string(RowObject.numero-ordem,"zzzzz9,99") then
                assign evento-ped.dt-evento     = RowObject.data-entrega - (item-uni-estab.res-for-comp + item-uni-estab.res-cq-comp + item-uni-estab.res-int-comp)
                       evento-ped.ind-sit-event = 1                        
                       evento-ped.cod-comprado  = ordem-compra.cod-comprado.                  
            if  evento-ped.des-event = c-desc-eve2 + " " + string(RowObject.numero-ordem,"zzzzz9,99") then
                assign evento-ped.dt-evento    = RowObject.data-entrega - (item-uni-estab.res-for-comp + item-uni-estab.res-cq-comp)
                       evento-ped.cod-comprado = ordem-compra.cod-comprado.
        end.   
    end.

    if  ordem-compra.nr-contrato <> 0
    and  avail prazo-compra 
    and (   lookup("quantidade",c-diferencas)   <> 0
         or lookup("data-entrega",c-diferencas) <> 0) then do:
    
        if   param-compra.compra-centr then do:
    
            find first emitente
                where emitente.cod-emitente = ordem-compra.cod-emitente exclusive-lock no-error.
            if  avail emitente
            and emitente.prog-emit = no then
                assign emitente.prog-emit = yes. /* reemite programaá∆o de entrega */
        end.
    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cc-codigo":U THEN ASSIGN pFieldValue = RowObject.cc-codigo.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "es-codigo":U THEN ASSIGN pFieldValue = RowObject.es-codigo.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "item-cotacao":U THEN ASSIGN pFieldValue = RowObject.item-cotacao.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "pedido-clien":U THEN ASSIGN pFieldValue = RowObject.pedido-clien.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "usuario-alt":U THEN ASSIGN pFieldValue = RowObject.usuario-alt.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-alter":U THEN ASSIGN pFieldValue = RowObject.data-alter.
        WHEN "data-entrega":U THEN ASSIGN pFieldValue = RowObject.data-entrega.
        WHEN "data-entrega-ant":U THEN ASSIGN pFieldValue = RowObject.data-entrega-ant.
        WHEN "data-orig":U THEN ASSIGN pFieldValue = RowObject.data-orig.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "concentracao":U THEN ASSIGN pFieldValue = RowObject.concentracao.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "qtd-a-ped-forn":U THEN ASSIGN pFieldValue = RowObject.qtd-a-ped-forn.
        WHEN "qtd-aloc-forn":U THEN ASSIGN pFieldValue = RowObject.qtd-aloc-forn.
        WHEN "qtd-do-forn":U THEN ASSIGN pFieldValue = RowObject.qtd-do-forn.
        WHEN "qtd-rec-forn":U THEN ASSIGN pFieldValue = RowObject.qtd-rec-forn.
        WHEN "qtd-rej-forn":U THEN ASSIGN pFieldValue = RowObject.qtd-rej-forn.
        WHEN "qtd-sal-forn":U THEN ASSIGN pFieldValue = RowObject.qtd-sal-forn.
        WHEN "quant-a-ped":U THEN ASSIGN pFieldValue = RowObject.quant-a-ped.
        WHEN "quant-alocada":U THEN ASSIGN pFieldValue = RowObject.quant-alocada.
        WHEN "quant-receb":U THEN ASSIGN pFieldValue = RowObject.quant-receb.
        WHEN "quant-rejeit":U THEN ASSIGN pFieldValue = RowObject.quant-rejeit.
        WHEN "quant-saldo":U THEN ASSIGN pFieldValue = RowObject.quant-saldo.
        WHEN "quantid-orig":U THEN ASSIGN pFieldValue = RowObject.quantid-orig.
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
        WHEN "rendimento":U THEN ASSIGN pFieldValue = RowObject.rendimento.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "hora":U THEN ASSIGN pFieldValue = RowObject.hora.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "MRP":U THEN ASSIGN pFieldValue = RowObject.MRP.
        WHEN "natureza":U THEN ASSIGN pFieldValue = RowObject.natureza.
        WHEN "nr-alt-data":U THEN ASSIGN pFieldValue = RowObject.nr-alt-data.
        WHEN "nr-alt-quant":U THEN ASSIGN pFieldValue = RowObject.nr-alt-quant.
        WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        WHEN "nr-entrega":U THEN ASSIGN pFieldValue = RowObject.nr-entrega.
        WHEN "nr-estrut":U THEN ASSIGN pFieldValue = RowObject.nr-estrut.
        WHEN "nr-estrut-filha":U THEN ASSIGN pFieldValue = RowObject.nr-estrut-filha.
        WHEN "nr-sequencia":U THEN ASSIGN pFieldValue = RowObject.nr-sequencia.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "parcela":U THEN ASSIGN pFieldValue = RowObject.parcela.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ordem
  Parameters:  
               retorna valor do campo numero-ordem
               retorna valor do campo parcela
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnumero-ordem LIKE prazo-compra.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pparcela LIKE prazo-compra.parcela NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnumero-ordem = RowObject.numero-ordem
           pparcela = RowObject.parcela.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-alter":U THEN ASSIGN pFieldValue = RowObject.cod-alter.
        WHEN "cons-mrp":U THEN ASSIGN pFieldValue = RowObject.cons-mrp.
        WHEN "cons-pmp":U THEN ASSIGN pFieldValue = RowObject.cons-pmp.
        WHEN "expectativa":U THEN ASSIGN pFieldValue = RowObject.expectativa.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "ordem-emitida":U THEN ASSIGN pFieldValue = RowObject.ordem-emitida.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice ordem
  Parameters:  
               recebe valor do campo numero-ordem
               recebe valor do campo parcela
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnumero-ordem LIKE prazo-compra.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER pparcela LIKE prazo-compra.parcela NO-UNDO.

    FIND FIRST bfprazo-compra WHERE 
        bfprazo-compra.numero-ordem = pnumero-ordem AND 
        bfprazo-compra.parcela = pparcela NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfprazo-compra THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfprazo-compra)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE identifyChanges DBOProgram 
PROCEDURE identifyChanges :
/*------------------------------------------------------------------------------
  Purpose:     Identificar os campos alterados
  Parameters:  pDiferencas: lista dos campos alterados, separados por v°rgula
  Notes:       Identifica os campos alterados para executar regras de neg¢cio
               que est∆o atreladas ao campo alterado.
------------------------------------------------------------------------------*/

    def output param pDiferencas        as char     no-undo.

    {cdp/findprazocompra.i RowObject.numero-ordem RowObject.parcela}
    if  avail prazo-compra then
        buffer-compare prazo-compra to RowObject
            save result in pDiferencas.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDeliveriesOfRequisition DBOProgram 
PROCEDURE openQueryDeliveriesOfRequisition :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query {&QueryName}
        for each {&tableName}
            where {&tableName}.numero-ordem = i-NumeroOrdem no-lock indexed-reposition.

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query {&QueryName}
        for each {&tableName} no-lock indexed-reposition.

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConfigRulesParam DBOProgram 
PROCEDURE setConfigRulesParam :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAM TABLE FOR ttParamConfigRules.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDeliveriesOfRequisition DBOProgram 
PROCEDURE setConstraintDeliveriesOfRequisition :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param pNumeroOrdem like ordem-compra.numero-ordem no-undo.

    assign i-NumeroOrdem = pNumeroOrdem.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setInterfaceParameters DBOProgram 
PROCEDURE setInterfaceParameters :
/*------------------------------------------------------------------------------
  Purpose:     Recebe atravÇs da temp-table ttParametrosTela os parÉmetros
               necess†rios a execuá∆o das regras de neg¢cio do DBO.
  Parameters:  ttParametrosTela.: temp-table genÇrica contendo os parÉmetros
                                  setados em tela pelo usu†rio.
  Notes:       A inicializaá∆o dos parÉmetros Ç de SUMA IMPORT∂NCIA para que
               a execuá∆o das regras de neg¢cio n∆o ocorra de modo indevido.
------------------------------------------------------------------------------*/

    def input param table for ttParametrosTela.

    /* Inicilizaá∆o dos parÉmetros */
    assign l-ExportaPedidoCliente = no
           l-QtdMenorLoteMinimo   = no
           l-QtdDifLoteMultiplo   = no.

    for each ttParametrosTela:

        case ttParametrosTela.parametro:
            /* Exportar alteraá‰es de Clientes/Pedidos para outras parcelas */
            when "exporta-pedido-cliente" then
                assign l-ExportaPedidoCliente   = ttParametrosTela.valor = "yes".
            /* Cadastrar parcela com quantidade menor que lote m°nimo */
            when "qtd-menor-lote-minimo" then
                assign l-QtdMenorLoteMinimo     = ttParametrosTela.valor = "yes".
            /* Cadastrar parcela com quantidade diferente do lote m£ltiplo */
            when "qtd-dif-lote-multiplo" then
                assign l-QtdDifLoteMultiplo     = ttParametrosTela.valor = "yes".
        end case.
    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateContract DBOProgram 
PROCEDURE validateContract :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es referente a Contratos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    if  ordem-compra.nr-contrato <> 0 then do:

        {cdp/findcontratofor.i ordem-compra.nr-contrato}
    
        if avail contrato-for then do:
            if  RowObject.data-entrega < contrato-for.dt-ini-validade
            or  RowObject.data-entrega > contrato-for.dt-ter-validade then do:
                {method/svc/errors/inserr.i &ErrorNumber="17538"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="''"}
                return "NOK".
            end. 
        end.
    end.

              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    def var l-erro                  as log             no-undo.
    def var c-msg-param-1           as char            no-undo.
    def var c-msg-param-2           as char            no-undo.
    DEFINE VARIABLE iContOrig       AS INTEGER         NO-UNDO.
    DEFINE VARIABLE lOrigemHtml     AS LOGICAL INIT NO NO-UNDO.
    DEFINE VARIABLE de-max-parcela  AS DECIMAL         NO-UNDO.
    DEFINE VARIABLE iCont           AS INTEGER INIT 1  NO-UNDO.
    DEFINE VARIABLE l-cc0605        AS LOGICAL INIT NO NO-UNDO.

    run identifyChanges (output c-diferencas).

    {cdp/findparamglobal.i}
    {cdp/findparamcompra.i}
    
    /*API CCAPI352 Ç utilizada pela tela HTML de inclus∆o de ordens*/
    DO  iContOrig = 1 TO 10:
        IF  PROGRAM-NAME(iContOrig) MATCHES "*ccapi352*":U THEN DO:
            ASSIGN lOrigemHtml = YES.
            LEAVE.
        END.
    END.
    

   /* {cdp/findordemcompra.i RowObject.numero-ordem}*/

	find first ordem-compra
            where ordem-compra.numero-ordem = RowObject.numero-ordem no-lock no-error.

	
    if  not avail ordem-compra then do:
        {utp/ut-table.i movind ordem-compra 1}
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="return-value"}
        return "NOK".
    end.

    {cdp/finditem.i ordem-compra.it-codigo}
    if  not avail item then do:
        {utp/ut-table.i mgind item 1}
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="return-value"} 
        return "NOK".
    end.

    {cdp/finditemuniestab.i ordem-compra.it-codigo ordem-compra.cod-estabel}
    if  not avail item-uni-estab then do:
        {method/svc/errors/inserr.i &ErrorNumber="25904"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="RowObject.it-codigo + '~~~~' + ordem-compra.cod-estabel"}
        return "NOK".
    end.

    if  pType = "Create" then do:
        if  can-find(first prazo-compra 
                     where prazo-compra.numero-ordem = RowObject.numero-ordem 
                     and   prazo-compra.parcela      = RowObject.parcela) then do:
            {utp/ut-table.i movind prazo-compra 1}
            {method/svc/errors/inserr.i &ErrorNumber="1"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
            return "NOK".
        end.
       
        /*Valida data de entrega contra data de ressuprimento apenas se a origem n∆o for HTML.
          A tela HTML realizar essa validaá∆o via Javascript para tratar a resposta do usu†rio*/
        IF NOT lOrigemHtml AND RowObject.data-entrega < (today + item-uni-estab.res-int-comp + item-uni-estab.res-for-comp) then do:
            {method/svc/errors/inserr.i &ErrorNumber="33330"
                                        &ErrorType="EMS"
                                        &ErrorSubType="WARNING"
                                        &ErrorParameters="string(today + item-uni-estab.res-int-comp + item-uni-estab.res-for-comp) + '~~~~' +
                                                          string(item-uni-estab.res-int-comp) + '~~~~' + string(item-uni-estab.res-for-comp)"}
        end.
    end.
   
    if  pType = "Create"
    or  pType = "Update" then do:

        if  avail ordem-compra then do:
            if  RowObject.data-entrega < ordem-compra.data-emissao then do:
                {method/svc/errors/inserr.i &ErrorNumber="6719"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="''"}
                return "NOK".
            end.

            if  RowObject.parcela > 1 then do:
                if  can-find(first prazo-compra
                             where prazo-compra.numero-ordem = ordem-compra.numero-ordem 
                               and prazo-compra.parcela      = RowObject.parcela - 1
                               and prazo-compra.data-entrega > RowObject.data-entrega) then do:
                    {method/svc/errors/inserr.i &ErrorNumber="5797"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="''"}
                end.
            end.
        end.

        if can-find (first prazo-compra
                     where prazo-compra.numero-ordem = ordem-compra.numero-ordem
                       and prazo-compra.parcela      < RowObject.parcela
                       and prazo-compra.data-entrega > RowObject.data-entrega) then do:
            {method/svc/errors/inserr.i &ErrorNumber="3997"
                                        &ErrorType="EMS"
                                        &ErrorSubType="WARNING"
                                        &ErrorParameters="''"}
        end.       
    
        if can-find (first prazo-compra
                     where prazo-compra.numero-ordem = ordem-compra.numero-ordem
                       and prazo-compra.parcela      > RowObject.parcela
                       and prazo-compra.data-entrega < RowObject.data-entrega) then do:
            {method/svc/errors/inserr.i &ErrorNumber="3996"
                                        &ErrorType="EMS"
                                        &ErrorSubType="WARNING"
                                        &ErrorParameters="''"}
        end.                          

        if  RowObject.data-entrega < today then do:
            {utp/ut-field.i movind prazo-compra data-entrega 1}
            {method/svc/errors/inserr.i &ErrorNumber="34109"
                                        &ErrorType="EMS"
                                        &ErrorSubType="WARNING"
                                        &ErrorParameters="return-value + '~~~~' + string(RowObject.data-entrega) + '~~~~' + string(today)"}
        end.
        
        if  item.tipo-con-est = 4 then do: /* Referància */
    
            if  RowObject.cod-refer <> ""
            and not can-find(first referencia
                             where referencia.cod-refer = RowObject.cod-refer) then do:
                {utp/ut-table.i mgind referencia 1}
                {method/svc/errors/inserr.i &ErrorNumber="56"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="return-value"}
                return "NOK".
            end.
        end.

        if  RowObject.quantidade = 0 then do:
            {method/svc/errors/inserr.i &ErrorNumber="1368"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="''"}
        end.

        /*Valida quantidade m†xima permitida na parcela */
        ASSIGN de-max-parcela = 9999999.9999.
        IF RowObject.quantidade > de-max-parcela THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="55231"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="string(de-max-parcela,'>,>>>,>>9.9999')"}
             return "NOK".
        END.

        if  item.fraciona = no
        and RowObject.quantidade <> int(RowObject.quantidade) then do:
            {method/svc/errors/inserr.i &ErrorNumber="847"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="''"}
        end.

        /* N∆o Valida Data Entrega quando usa o CC0605 */
        REPEAT WHILE PROGRAM-NAME(iCont) <> ?:
            IF PROGRAM-NAME(iCont) MATCHES "*cc0605*" THEN
                ASSIGN l-cc0605 = YES.
            ASSIGN iCont = iCont + 1.
        END.
        IF NOT l-cc0605 THEN DO:

            /* Validaá∆o Data Entrega */
            FIND FIRST prazo-compra 
                 WHERE prazo-compra.numero-ordem = RowObject.numero-ordem 
                   AND prazo-compra.parcela      = RowObject.parcela NO-LOCK NO-ERROR.
            FIND FIRST ttParamConfigRules NO-ERROR.
            IF rowObject.situacao <> 6 AND AVAIL ttParamConfigRules AND  
                    (pType = "Create":U OR 
                    (AVAIL prazo-compra AND (prazo-compra.data-entrega <> rowObject.data-entrega OR
                                             prazo-compra.qtd-sal-forn <> rowObject.qtd-sal-forn))) THEN DO:
               IF (rowObject.data-entrega < ttParamConfigRules.initialDate or 
                   rowObject.data-entrega > ttParamConfigRules.finalDate) then do:
                {method/svc/errors/inserr.i &ErrorNumber="314"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="string(ttParamConfigRules.initialDate) + '~~~~' + string(ttParamConfigRules.finalDate)"}                             
               END.
            END.
        END.

        /* Validaá‰es relacionadas a Unidade de Medida */
        {cdp/findtabunidade.i RowObject.un}
        if  not avail tab-unidade then do:
            {utp/ut-table.i mgind tab-unidade 1}
            {method/svc/errors/inserr.i &ErrorNumber="56"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
            return "NOK".
        end.

        if  can-find (first item-fornec
                      where item-fornec.it-codigo = ordem-compra.it-codigo
                      and   item-fornec.ativo)
        and ordem-compra.it-codigo <> "" 
        and ordem-compra.it-codigo <> ?  
        and RowObject.un           <> item.un then do:
            {method/svc/errors/inserr.i &ErrorNumber="3359"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="''"}
            return "NOK".
        end.
        else if item.tipo-contr = 2 /* Total */
            and RowObject.un    <> item.un then do:
            {method/svc/errors/inserr.i &ErrorNumber="3359"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="''"}
            return "NOK".
        end.

        find first bfprazo-compra
            where bfprazo-compra.numero-ordem = ordem-compra.numero-ordem
              and bfprazo-compra.parcela      <> RowObject.parcela no-lock no-error.
        if  avail bfprazo-compra then do:

            if  not can-find (first item-fornec 
                              where item-fornec.it-codigo = ordem-compra.it-codigo
                              and   item-fornec.ativo) 
            and RowObject.un           <> bfprazo-compra.un 
            and ordem-compra.it-codigo <> "" then do:
                {method/svc/errors/inserr.i &ErrorNumber="3995"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="''"}
                return "NOK".
            end.
        end.
        /* Fim validaá‰es relacionadas a Unidade de Medida */
    end.
    if  pType = "Delete" then do:

        /*** MULTIPLANTA ***/
        if  param-global.modulo-mp then do:
            run ccp/ccapi199.p (input "Ordem-compra",
                                input rowid(ordem-compra),
                                output l-erro).
            if  l-erro then do:
                {utp/ut-liter.i Ordem}
                assign c-msg-param-1 = trim(return-value).
                {utp/ut-liter.i Gestor}
                assign c-msg-param-2 = trim(return-value).
                {method/svc/errors/inserr.i &ErrorNumber="18200"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-msg-param-1 + '~~~~' + c-msg-param-2"}
                return "NOK".
            end.
        end.
        /*******************/
    end.

    /*** Validaá‰es Contratos ***/
    run validateContract (input pType).
    if  return-value = "NOK" then
        return "NOK".
    /****************************/
    /* Validaá‰es Pedido de Venda */
    run validateSalesOrder (input pType).
    if  return-value = "NOK" then
        return "NOK".
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR") THEN
        RETURN "NOK".

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateSalesOrder DBOProgram 
PROCEDURE validateSalesOrder :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es referente ao Pedido de Venda
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    FIND FIRST para-ped NO-LOCK NO-ERROR.

    if  param-global.modulo-pd then do:
        if  RowObject.nome-abrev   <> ""
        or  RowObject.pedido-clien <> ""
        or  RowObject.nr-sequencia <> 0 then do:
    
            for first emitente 
                where emitente.nome-abrev = RowObject.nome-abrev 
                  and emitente.identific  <> 2 no-lock: end.
            if  not avail emitente then do:
                {method/svc/errors/inserr.i &ErrorNumber="895"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="''"} 
                return "NOK".
            end.
    
            find first ped-venda
                where ped-venda.nome-abrev = RowObject.nome-abrev
                  and ped-venda.nr-pedcli  = RowObject.pedido-clien no-lock no-error.
            if  not avail ped-venda then do:
                {utp/ut-table.i movdis ped-venda 1}
                {method/svc/errors/inserr.i &ErrorNumber="56"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="return-value"} 
                return "NOK".
            end.
            else do:

                if  ped-venda.cod-sit-aval = 1
                or  ped-venda.cod-sit-aval = 4 then do:
                    {method/svc/errors/inserr.i &ErrorNumber="6270"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="''"} 
                    return "NOK".
                end.
                 
                /* Pedido n∆o aprovado no WF de desconto */
                IF  para-ped.log-usa-aprovac-workflow 
                AND ped-venda.log-aprov-workflow = NO THEN DO:
                
                     {method/svc/errors/inserr.i
                                &ErrorNumber="52327"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters=" ped-venda.nr-pedcli + '~~~~' + ped-venda.nome-abrev"}
                              
                    return "NOK".
                
                END. 

                if  ped-venda.cod-sit-ped = 3 then do:
                    {method/svc/errors/inserr.i &ErrorNumber="6271"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="''"} 
                    return "NOK".
                end.

                if  ped-venda.cod-sit-ped = 5 then do:
                    {method/svc/errors/inserr.i &ErrorNumber="6272"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="''"} 
                    return "NOK".
                end.

                if  ped-venda.cod-sit-ped = 6 then do:
                    {method/svc/errors/inserr.i &ErrorNumber="6273"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="''"} 
                    return "NOK".
                end.

                for first ped-item field (nome-abrev nr-pedcli nr-sequencia)
                    where ped-item.nome-abrev   = RowObject.nome-abrev
                      and ped-item.nr-pedcli    = RowObject.pedido-clien
                      and ped-item.nr-sequencia = RowObject.nr-sequencia no-lock: end.
                if  not avail ped-item then do:
                    {utp/ut-table.i movdis ped-item 1}
                    {method/svc/errors/inserr.i &ErrorNumber="56"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="return-value"} 
                    return "NOK".
                end. 
            end.
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

