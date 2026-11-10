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
{include/i-prgvrs.i BOIN356CA 2.00.00.025 } /*** "010025" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin356ca MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName prazo-compra
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName prazo-compra
&GLOBAL-DEFINE TableLabel prazo-compra
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S¢ a DBO principal (boin356.p) est† com as funá‰es de inclui (createRecord), 
**  modifica (updateRecord) e elimina (deleteRecord) habilitadas, 
**  porque S‡ nela foram implementadas as triggers do dicion†rio.
**  Para desabilitar as procedures foram usados os prÇ-processadores abaixo.
**  A procedure validateRecord dessa DBO n∆o deve ser usada.
*********************************************************************************/
&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
{inbo/boin356.i RowObject}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}

def var dias-ressup      as integer no-undo.
def var nova-dt        as date    no-undo.
def var h-boin356vl    as handle  no-undo.
def var de-indice      as dec     no-undo.
DEF VAR l-erro-calend  AS LOG     NO-UNDO.
def var i-cont       as int    no-undo.

/* Include com pr≤-processadores de Materiais */
{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE BUFFER b-prazo        FOR prazo-compra.
DEFINE BUFFER b-prazo-compra FOR prazo-compra.
DEFINE BUFFER b-ordem        FOR ordem-compra.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram



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
         HEIGHT             = 1.79
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



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaNumeroTotalParcelas DBOProgram 
PROCEDURE calculaNumeroTotalParcelas :
/*------------------------------------------------------------------------------
  Purpose:     Conta quantas parcelas existem na Ordem utilizando um buffer 
               para n∆o desposicionar um poss°vel registro em manutená∆o
  Parameters:  
               ipar1 : pNumeroOrdem : N£mero da Ordem
               opar2 : piQuantParc  : N£mero de Parcelas na Ordem
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pNumeroOrdem AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER piQuantParc  AS INTEGER NO-UNDO. 

     for each b-prazo-compra fields(numero-ordem) where 
              b-prazo-compra.numero-ordem = pNumeroOrdem no-lock:
         assign piQuantParc = piQuantParc + 1.
     end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaProximaParcelaPrazoCompra DBOProgram 
PROCEDURE calculaProximaParcelaPrazoCompra :
/*------------------------------------------------------------------------------
  Purpose:     Calcula o n£mero da pr¢xima parcela a ser inclu°da
  Parameters:  
               ipar1 : piNumeroOrdem : N£mero da Ordem
               ipar2 : pcItCodigo    : C¢digo do Item da Ordem
               ipar3 : pcCodEstabel  : C¢digo do Estabelecimento
               ipar4 : piCodEmitente : C¢digo do Fornecedor
               opar5 : piParcela     : Pr¢xima Parcela
               opar6 : pcUn          : Unidade de Medida da Èltima Parcela
               oper7 : pdt-entrega   : Data de Entrega
  Notes:       
------------------------------------------------------------------------------*/
 /* DEVE SER EXECUTADO ANTES O MêTODO SETRECORD */
    DEFINE INPUT  PARAMETER piNumeroOrdem AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER pcItCodigo    AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pcCodEstabel  AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER piCodEmitente AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER piParcela     AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pcUn          AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-entrega   AS DATE      NO-UNDO.

    define variable ICONT   as integer no-undo. 

    FIND FIRST param-compra NO-LOCK NO-ERROR.

    find last rowObject 
        where rowObject.numero-ordem = piNumeroOrdem no-lock no-error.  
    if  avail rowObject and rowObject.parcela < 99999 then
        assign piParcela = rowObject.parcela + 1
               pcUn      = rowObject.un.
    else do:
        if  available rowObject then do:
            do  ICONT = 1 to 99999:
                if  not can-find (rowObject where
                                  rowObject.numero-ordem = piNumeroOrdem and
                                  rowObject.parcela = iCONT) then do:
                    assign piParcela = ICONT.
                    leave.
                end.
                else do:
                    if  ICONT = 99999 then
                        leave.
                end.
            end.
        end.
        else
            assign piParcela = 1.

        /* UN Default */
        &if defined(bf_dis_default_un) &then
            for first item fields(it-codigo un) where 
                item.it-codigo = pcItCodigo no-lock: end.
            if  avail item 
                then assign pcUn = item.un.
                else assign pcUn = "".
        &endif
    end.

    if  piParcela > 1 
    and pcUn = "":U then do:
        for first bfPrazo-compra fields(numero-ordem un)
             where bfPrazo-compra.numero-ordem = piNumeroOrdem no-lock: end.
        assign pcUN = if avail bfPrazo-compra then bfPrazo-compra.un else "":U.
    end.

    for first item-fornec-estab FIELDS(it-codigo cod-estabel cod-emitente ativo tempo-ressup)
        WHERE item-fornec-estab.it-codigo    = pcItCodigo 
        AND   item-fornec-estab.cod-estabel  = pcCodEstabel
        AND   item-fornec-estab.cod-emitente = piCodEmitente
        AND   item-fornec-estab.ativo no-lock:
    END.
    IF  AVAIL item-fornec-estab THEN
        assign dias-ressup = item-fornec-estab.tempo-ressup.
    ELSE DO:
        for first item-fornec FIELDS(it-codigo cod-emitente ativo tempo-ressup)
            WHERE item-fornec.it-codigo    = pcItCodigo 
            AND   item-fornec.cod-emitente = piCodEmitente 
            AND   item-fornec.ativo no-lock:
        END.
        IF  AVAIL item-fornec THEN
            assign dias-ressup = item-fornec.tempo-ressup.
        ELSE DO:
            for first item-uni-estab fields(it-codigo cod-estabel res-cq-comp res-int-comp res-for-comp) 
                where item-uni-estab.cod-estabel = pcCodEstabel         and
                      item-uni-estab.it-codigo   = pcItCodigo no-lock:  end.
            if avail item-uni-estab then 
               assign dias-ressup = /* item-uni-estab.res-cq-comp + */ item-uni-estab.res-int-comp + item-uni-estab.res-for-comp.
            else do:
                 for first item fields(it-codigo res-int-comp res-for-comp) where 
                     item.it-codigo = pcItCodigo no-lock: end.
                 if avail item then 
                    assign dias-ressup = /* item.res-cq-comp + */ item.res-int-comp + item.res-for-comp.
            end.
        END.
    END.
    
    /* considera somente dias £teis */
    IF AVAIL param-compra AND substring(param-compra.char-1,136,1) = "1" THEN DO:  
       ASSIGN nova-dt = today. 
       {inbo/boin356.i2 "pcCodEstabel"} 
    END.
    IF (AVAIL param-compra AND substring(param-compra.char-1,136,1) = " ") 
       OR l-erro-calend THEN
       ASSIGN nova-dt = today + dias-ressup.

    assign pdt-entrega = nova-dt.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaQuantParcelaPrazoCompra DBOProgram 
PROCEDURE calculaQuantParcelaPrazoCompra :
/*------------------------------------------------------------------------------
  Purpose:     Calcula a quantidade restante para inclus∆o de uma nova parcela
  Parameters:  
               ipar1 : pcParam        : add ou mod?
               ipar2 : piNumeroOrdem  : N£mero da Ordem
               ipar3 : pdeQtSolic     : Quantidade Solicitada da Ordem
               opar4 : pdeQuantidade  : Quantidade Restante
  Notes:       
------------------------------------------------------------------------------*/
 /* DEVE SER EXECUTADO ANTES O MêTODO SETRECORD */
    DEFINE INPUT  PARAMETER pcParam       AS char    NO-UNDO.
    DEFINE INPUT  PARAMETER piNumeroOrdem AS INTEGER NO-UNDO.
    DEFINE INPUT  PARAMETER pdeQtSolic    AS DECIMAL NO-UNDO.
    DEFINE OUTPUT PARAMETER pdeQuantidade AS DECIMAL NO-UNDO.

    DEFINE VARIABLE de-total-item         AS DECIMAL NO-UNDO.

    assign de-total-item = 0.
    for each rowObject fields(numero-ordem quantidade) where 
             rowObject.numero-ordem = piNumeroOrdem no-lock:
       assign de-total-item = de-total-item + rowObject.quantidade.
    end.      
    
    if (pdeQtSolic - de-total-item > 0) then do:
        if pdeQtSolic - de-total-item > 9999999.9999 then
           assign pdeQuantidade = 9999999.
        else
           assign pdeQuantidade = pdeQtSolic - de-total-item.
    end.       

    if pcParam = "mod" and pdeQuantidade > 0 then do:
        find first rowObject no-error.
        find ordem-compra where 
             ordem-compra.numero-ordem = piNumeroOrdem no-lock no-error.
    
        RUN inbo/boin356vl.p PERSISTENT SET h-boin356vl.
        RUN pi-indice in h-boin356vl (input  ordem-compra.it-codigo,
                                      input  ordem-compra.cod-emitente,
                                      input  ordem-compra.numero-ordem,
                                      output de-indice).
        DELETE PROCEDURE h-boin356vl.
                         h-boin356vl = ?.

        assign pdeQuantidade = pdeQuantidade * de-indice.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH prazo-compra NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaAtrasoPrazoCompra DBOProgram 
PROCEDURE retornaAtrasoPrazoCompra :
/*------------------------------------------------------------------------------
  Purpose:     
    Retorna o n£mero de dias em que a entrega do 
    material est† atrasada.
  Parameters:  
    ipar1 : pi-num-ordem : N£mero da ordem corrente
    ipar2 : pi-parcela   : N£mero da parcela corrente
    opar3 : pi-atraso    : N£mero de dias em que a entrega do material est† atrasada    
  Notes:       
------------------------------------------------------------------------------*/
   
def input  parameter pi-num-ordem as int no-undo.
def input  parameter pi-parcela   as int no-undo.
def output parameter pi-atraso    as int no-undo.

    for first prazo-compra fields(numero-ordem parcela data-entrega) where 
        prazo-compra.numero-ordem = pi-num-ordem and
        prazo-compra.parcela      = pi-parcela
        no-lock: end.
    if avail prazo-compra then do: 
      if  prazo-compra.data-entrega < today then 
         assign  pi-atraso = today - prazo-compra.data-entrega. 
       else pi-atraso = 0.  
    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaQtdeToteDtEntregaOrdemCompra DBOProgram 
PROCEDURE retornaQtdeToteDtEntregaOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
  Este mÈtodo tem a funÁ„o de retornar a quantidade 
  total da ordem de compra e a data de entrega da parcela, 
  caso a ordem de compra possua somente uma parcela,
  caso contr·rio ser· retornado a string "Parcelada".
  Par‚metros:
  opar1 : d-qunatidade : Quantidade total da ordem de compra 
  opar2 : c-entrega    : Data de entrega da parcela
*/  
def input  param piNumero-ordem as int no-undo.
def output param pdQuantidade   as decimal no-undo.
def output param pcEntrega      as char    no-undo.

def var i-contador as int no-undo.

assign i-contador   = 0
       pdQuantidade = 0.
       
for each prazo-compra fields (numero-ordem quantidade data-entrega) where 
    prazo-compra.numero-ordem = piNumero-ordem no-lock:
    assign i-contador = i-contador + 1
           pdQuantidade = pdQuantidade +  prazo-compra.quantidade.
    if i-contador = 1 then
         assign pcEntrega = string(prazo-compra.data-entrega,"99/99/9999").
end.

{utp/ut-liter.i Parcelada * c}
if i-contador > 1 then
    assign pcEntrega = TRIM(string(RETURN-VALUE)).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE totalizaQuantidadeParcelasOrdem DBOProgram 
PROCEDURE totalizaQuantidadeParcelasOrdem :
/*------------------------------------------------------------------------------
  Purpose:     Calcula a quantidade total das parcelas da ordem utilizando um 
               buffer para n∆o desposicionar um poss°vel registro em manutená∆o
  Parameters:  
               ipar1 : pNumeroOrdem  : N£mero da Ordem
               opar2 : pdeTotParcela : Quantidade Total da Ordem
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pNumeroOrdem  AS INTEGER NO-UNDO. 
    DEFINE OUTPUT PARAMETER pdeTotParcela AS DECIMAL NO-UNDO.
    
      for each b-prazo-compra fields(numero-ordem situacao quantidade) where 
               b-prazo-compra.numero-ordem = pNumeroOrdem and
               b-prazo-compra.situacao <> 4 no-lock:
          assign pdeTotParcela = pdeTotParcela + b-prazo-compra.quantidade.
      end.
      
    RETURN "OK":U.      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


