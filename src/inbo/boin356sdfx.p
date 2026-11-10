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
{include/i-prgvrs.i BOIN356SDFX 2.00.00.006 } /*** "010006" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin356sdfx MUT}
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
&GLOBAL-DEFINE DBOName BOIN356SD
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName prazo-compra
&GLOBAL-DEFINE TableLabel Entregas da Ordem de Compra
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin356.i RowObject}
{inbo/boin356.i RowObjectDefault}

def temp-table ttParametros no-undo
    field campo as char
    field valor as char.


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var c-CodEstabel    like ordem-compra.cod-estabel   no-undo.
def var iCodEmitente    like ordem-compra.cod-emitente  no-undo.
def var iNumeroOrdem    like ordem-compra.numero-ordem  no-undo.
def var iNumPedido      like ordem-compra.num-pedido    no-undo.
def var h-boin356vl     as handle                       no-undo.
def var i-cont          as int                          no-undo.
def var l-erro-calend   as logical                      no-undo.
def var dias-ressup     as int                          no-undo.


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
         HEIGHT             = 9.08
         WIDTH              = 33.43.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields DBOProgram 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     Habilitar os campos de interface segundo a regra de neg¢cio.
  Parameters:  pType: Tipo de Transaá∆o ("Create", "Update" ou "Delete") 
               pFieldName: Atributo da tabela.
               pFieldEnable: Habilita ou n∆o o atributo.
  Notes:       
------------------------------------------------------------------------------*/

    def input  param pType        as char               no-undo.
    def input  param pFieldName   as char               no-undo.
    def output param pFieldEnable as log    init yes    no-undo.

    {cdp/findparammat.i}
    if  not avail param-mat then
        return "NOK".

    {cdp/finditem.i RowObject.it-codigo}
    if  not avail item then
        return "NOK".

    case pFieldName:

        when "un" then
            assign pFieldEnable =    param-mat.ind-sit-un = 1 /* Unidade de Medida: Informa */
                                  or (    param-mat.ind-sit-un = 2 /* Unidade de Medida: Default Item */
                                      and (   RowObject.it-codigo = ?
                                           or RowObject.it-codigo = ""
                                           or item.tipo-contr     = 4)). /* DÇbito Direto */

        when "cod-refer" then
            assign pFieldEnable = item.tipo-con-est = 4. /* Referància */

    end case.

    return "ok".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveCodEstabel DBOProgram 
PROCEDURE leaveCodEstabel :
/*------------------------------------------------------------------------------
  Purpose:     Executar a sugest∆o de valores default a partir do c¢digo do 
               estabelecimento.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param table for RowObjectDefault.

    run setDeliveryDate  (output RowObjectDefault.data-entrega).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveItCodigo DBOProgram 
PROCEDURE leaveItCodigo :
/*------------------------------------------------------------------------------
  Purpose:     Executar a sugest∆o de valores default a partir da parcela da 
               ordem de compra.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param table for RowObjectDefault.

    run setUnitOfMeasure (output RowObjectDefault.un).

    run setDeliveryDate  (output RowObjectDefault.data-entrega).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveQuantidades DBOProgram 
PROCEDURE leaveQuantidades :
/*------------------------------------------------------------------------------
  Purpose:     Executar a sugest∆o de valores default a partir da parcela da 
               ordem de compra.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    defin  input  parameter pType as character no-undo.
    define output parameter table for RowObjectDefault.

    def var de-indice as decimal no-undo.

    if  not valid-handle (h-boin356vl) then
        run inbo/boin356vl.p persistent set h-boin356vl.

    if  not avail RowObjectDefault then
        return "NOK".

    /* C†lculo das demais quantidades */
    RUN passaUnFornec IN h-boin356vl (input rowObject.un).
    run pi-indice in h-boin356vl (input  rowObjectDefault.it-codigo, 
                                  input  iCodEmitente,             
                                  input  iNumeroOrdem,             
                                  output de-indice).         

    if  valid-handle (h-boin356vl) then do:
        delete procedure h-boin356vl.
        assign h-boin356vl = ?.
    end.

    {cdp/finditem.i rowObjectDefault.it-codigo}

    /*-- Inclus∆o da ordem --*/
    if  (pType = "CREATE" AND RowObjectDefault.quantidade > 0 AND RowObjectDefault.qtd-do-forn = 0)
    OR  NOT CAN-FIND(FIRST ordem-compra 
                     WHERE ordem-compra.numero-ordem = iNumeroOrdem) then DO:
        /*** O usu†rio informou Quantidade ***/
        assign RowObjectDefault.qtd-do-forn  = RowObjectDefault.quantidade * de-indice
               RowObjectDefault.qtd-sal-forn = RowObjectDefault.qtd-do-forn
                                             - RowObjectDefault.qtd-rec-forn
                                             + RowObjectDefault.qtd-rej-forn
               RowObjectDefault.quant-saldo  = if  avail item    
                                               and item.fraciona then
                                                   (RowObjectDefault.qtd-sal-forn / de-indice)
                                               else
                                                   truncate((RowObjectDefault.qtd-sal-forn / de-indice),0)
               RowObjectDefault.qtd-rec-forn = RowObjectDefault.quant-receb  * de-indice
               RowObjectDefault.qtd-rej-forn = RowObjectDefault.quant-rejeit * de-indice.
    /*-- Modificaá∆o da ordem --*/
    END.
    ELSE DO:
        /*** O usu†rio informou Qtd-sal-forn ***/
        assign RowObjectDefault.qtd-do-forn  = RowObjectDefault.qtd-sal-forn
                                             + RowObjectDefault.qtd-rec-forn
                                             - RowObjectDefault.qtd-rej-forn
               RowObjectDefault.quantidade   = if  avail item    
                                               and item.fraciona then
                                                   (RowObjectDefault.qtd-do-forn / de-indice)
                                               else
                                                   truncate(RowObjectDefault.qtd-do-forn / de-indice,0)
               RowObjectDefault.quant-saldo  = if  avail item    
                                               and item.fraciona then
                                                   (RowObjectDefault.qtd-sal-forn / de-indice)
                                               else
                                                   truncate((RowObjectDefault.qtd-sal-forn / de-indice),0)
               RowObjectDefault.quant-receb  = RowObjectDefault.qtd-rec-forn / de-indice
               RowObjectDefault.quant-rejeit = RowObjectDefault.qtd-rej-forn / de-indice.
    END.

    if  RowObjectDefault.quant-saldo < 0 then
        assign RowObjectDefault.quant-saldo = 0.
  
    if  RowObjectDefault.qtd-sal-forn < 0 then
        assign RowObjectDefault.qtd-sal-forn = 0.

    return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDefaults DBOProgram 
PROCEDURE setDefaults :
/*------------------------------------------------------------------------------
  Purpose:     Executar o leave dos campos para sugest∆o de valores default.
  Parameters:  pType: Tipo de Transaá∆o ("Create", "Update" ou "Delete")
               pFieldName: Atributo da tabela
               RowObject: temp-table com os dados da tela
               RowObjectDefault: temp-table com os dados default
  Notes:       O mÇtodo SetDefaults deve ser executado apenas quando tratar-se
               de uma inclus∆o ou da modificaá∆o de algum campo.
------------------------------------------------------------------------------*/

    def input  param pType        as char no-undo.
    def input  param pFieldName   as char no-undo.
    def input  param table for RowObject.
    def output param table for RowObjectDefault.

    empty temp-table RowObjectDefault.

    find first RowObject no-error.

    /* Defaults na inicializaá∆o da tela */
    if  pType      = "create"
    and pFieldName = "" 
    and avail RowObject    then do:

        /* Parcela da Ordem de Compra */
        create RowObjectDefault.
        /* Grava chave do registro pai para, posteriormente, habilitar/desabilitar os campos (enableFields) */
        assign RowObjectDefault.numero-ordem = RowObject.numero-ordem
               RowObjectDefault.it-codigo = RowObject.it-codigo
               RowObjectDefault.natureza = RowObject.natureza
               RowObjectDefault.nome-abrev   = ""
               RowObjectDefault.pedido-clien = "".
               
        run setScheduleSeq   (output RowObjectDefault.parcela).
        run setUnitOfMeasure (output RowObjectDefault.un).
        run setDeliveryDate  (output RowObjectDefault.data-entrega).
        run setSituation     (output RowObjectDefault.situacao).

    end.
    /* Defaults de leave de campos (criaá∆o e modificaá∆o) */
    else do:
    
        if  avail RowObject then do:

            create RowObjectDefault.
            buffer-copy RowObject to RowObjectDefault.
        end.
    end.

    /* Regras de neg¢cio para sugest∆o de valores defaults */
    case pFieldName:
        when "it-codigo"        then run leaveItCodigo    (output table RowObjectDefault).
        when "cod-estabel"      then run leaveCodEstabel  (output table RowObjectDefault).
        when "quantidade"       then do:
            /*-- Somente para pedidos emergenciais --*/ 
            if  iNumPedido <> 0 then
                run leaveQuantidades (input pType,
                                      output table RowObjectDefault).
        end.
        when "qtd-sal-forn"     then do:
            /*-- Somente para pedidos emergenciais --*/ 
            if  iNumPedido <> 0 then
                run leaveQuantidades (input pType,
                                      output table RowObjectDefault).
        end.
        when "data-entrega"     then run leaveCodEstabel  (output table RowObjectDefault).
    end case.

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDeliveryDate DBOProgram 
PROCEDURE setDeliveryDate :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir a data de entrega da parcela da ordem de compra.
  Parameters:  pDataEntrega....: data de entrega da parcela
  Notes:       
------------------------------------------------------------------------------*/

    def output param pDataEntrega     like prazo-compra.data-entrega initial today     no-undo.

    DEF VAR nova-dt AS DATE NO-UNDO.

    FIND FIRST param-compra NO-LOCK NO-ERROR.

    {cdp/finditemfornecestab.i RowObject.it-codigo iCodEmitente c-CodEstabel}

    IF  AVAIL item-fornec-estab 
    AND item-fornec-estab.ativo THEN DO:
        assign dias-ressup = item-fornec-estab.tempo-ressup.
    END.
    ELSE DO:
        {cdp/finditemfornec.i RowObject.it-codigo iCodEmitente}

        IF  AVAIL item-fornec 
        AND item-fornec.ativo THEN DO:
            assign dias-ressup = item-fornec.tempo-ressup.
        END.
        ELSE DO:
            {cdp/finditemuniestab.i RowObject.it-codigo c-CodEstabel}

            if  avail item-uni-estab then
                assign dias-ressup = item-uni-estab.res-int-comp + item-uni-estab.res-for-comp.
            else do:
                for first item fields(it-codigo res-int-comp res-for-comp) 
                    where item.it-codigo = RowObject.it-codigo no-lock: end.
                if  avail item then 
                    assign dias-ressup = item.res-int-comp + item.res-for-comp.
            end.
        END.
    END.

    /* considera somente dias £teis */
    IF AVAIL param-compra AND substring(param-compra.char-1,136,1) = "1" THEN DO:  
       assign nova-dt = today.
       {inbo/boin356.i2 "c-CodEstabel"}        
    END.
    IF (AVAIL param-compra AND substring(param-compra.char-1,136,1) = " ") 
       OR l-erro-calend THEN
       ASSIGN nova-dt = today + dias-ressup.

    assign pDataEntrega = nova-dt.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setParameters DBOProgram 
PROCEDURE setParameters :
/*------------------------------------------------------------------------------
  Purpose:     Recebe atravÇs da temp-table ttParametros os parÉmetros necess†rios
               a execuá∆o dos mÇtodos de setDefaults, mas que n∆o podem ser 
               transportados atravÇs da temp-table RowObject.
  Parameters:  ttParametros.: temp-table genÇrica contendo o campo e o valor
                              correspondente para a execuá∆o dos mÇtodos de
                              setDefaults.
  Notes:       
------------------------------------------------------------------------------*/

    def input param table for ttParametros.

    /* inicilizaá∆o dos parÉmetros */
    assign c-CodEstabel = "".

    for each ttParametros:

        case ttParametros.campo:

            when "cod-estabel" then
                assign c-CodEstabel = ttParametros.valor.

            when "cod-emitente" then
                assign iCodEmitente = int(ttParametros.valor).

            when "numero-ordem" then
                assign iNumeroOrdem = int(ttParametros.valor).

            when "num-pedido" then
                assign iNumPedido = int(ttParametros.valor).

        end case.
    end.
              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setScheduleSeq DBOProgram 
PROCEDURE setScheduleSeq :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir a seqÅància da pr¢xima parcela.
  Parameters:  pParcela: retorna c¢digo da pr¢xima parcela da ordem de compra.
  Notes:       
------------------------------------------------------------------------------*/

    def output param pParcela like prazo-compra.parcela no-undo.

    find last prazo-compra
        where prazo-compra.numero-ordem = RowObject.numero-ordem no-lock no-error.
    if  avail prazo-compra then
        assign pParcela = prazo-compra.parcela + 1.
    else
        assign pParcela = 1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setUnitOfMeasure DBOProgram 
PROCEDURE setUnitOfMeasure :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir unidade de medida para a entrega da ordem de compra.
  Parameters:  pUn: unidade de medida
  Notes:       
------------------------------------------------------------------------------*/

    def output param pUn       like it-requisicao.un no-undo.

    {cdp/findparammat.i}
    if  avail param-mat then do:

        if  param-mat.ind-sit-un = 2 then do: /* Default Item */

            {cdp/finditem.i RowObject.it-codigo}
            if  avail item then
                assign pUn = item.un.

        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSituation DBOProgram 
PROCEDURE setSituation :
/*------------------------------------------------------------------------------
  Purpose:     Sugerir a situacao da parcelas
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    define output parameter pSituation as integer no-undo.

    /*-- Pedido Emergencial --*/
    if  iNumPedido <> 0 then
        assign pSituation = 2. /*-- Confirmada --*/
    else 
        assign pSituation = 1. /*-- Nao Confirmada --*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME








