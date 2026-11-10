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
{include/i-prgvrs.i BOIN274CA 2.00.00.015} /*** "010015" 23/11/2023 16:19:44  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin274ca MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      : Bo com finalidade de aplicar c†lculos nas ordens de compra
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName ordem-compra
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName ordem-compra
&GLOBAL-DEFINE TableLabel ordem-compra
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S¢ a DBO principal (boin274.p) est† com as funá‰es de inclui (createRecord), 
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
{inbo/boin274.i RowObject}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}

{cdp/cdcfgmat.i}  /* Include com prÇ-processadores que indicam mudanáas na base */


/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

    def var daData          as date format "99/99/9999" init today no-undo.
    def var daDataConversao as date no-undo.
    def var deValorOrig     as dec  no-undo.
    def var deValorIPI      as dec  no-undo.
    def var deAliquotaIPI   as dec  no-undo.
    def var dePrecoUnit     as dec  no-undo.
    def var iValor          as int  no-undo.
    def var lPrecoBruto     as log  no-undo.

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
         HEIGHT             = 16.43
         WIDTH              = 58.6.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcNotaNomeRealFornOrdemCompraItemForne DBOProgram 
PROCEDURE calcNotaNomeRealFornOrdemCompraItemForne :
/*------------------------------------------------------------------------------
  Purpose:     
    Inicializa os valores de Numero da nota, Nome Abrev, Real e Forn a partir do cod-emitente da tabela item-fornec
  Parameters:  
    ipar1 : pr-item-fornec : rowid do registro da tabela item-fornec
    opar2 : pc-numero-nota : retorna o valor numero da nota da tabela recebimento cforme r-rowid da tabela item-fornec
    opar3 : pc-nome-abrev  : retorna o valor nome abrev da tabela emitente cforme r-rowid tabela item-fornec
    opar4 : pi-r-real      : retorna o valor r-real a partir do r-rowid da tabela item-fornec
    opar5 : pi-r-forn      : retorna o valor r-forn a partir do r-rowid da tabela item-fornec  
  Notes:       
------------------------------------------------------------------------------*/

def input  param pr-item-fornec as rowid no-undo.
def output param pc-numero-nota  as char no-undo.
def output param pc-nome-abrev   as char no-undo.
def output param pi-r-real       as int  no-undo.
def output param pi-r-forn       as int  no-undo.

find first item-fornec where rowid(item-fornec) = pr-item-fornec no-lock no-error.

find first ordem-compra where ordem-compra.cod-emitente = item-fornec.cod-emitente no-lock no-error.

    find emitente where emitente.cod-emitente = ordem-compra.cod-emitente 
        no-lock no-error.

    assign pc-nome-abrev = if avail emitente then emitente.nome-abrev else "":U.
        
    find last recebimento 
        where recebimento.num-pedido   = ordem-compra.num-pedido
        and   recebimento.numero-ordem = ordem-compra.numero-ordem no-lock no-error.
    if available recebimento then
        assign pi-r-real = recebimento.data-movto - ordem-compra.data-emissao
               pi-r-forn = recebimento.data-movto - ordem-compra.data-pedido
               pc-numero-nota = recebimento.numero-nota.
    else
        assign pi-r-real = 0
               pi-r-forn = 0
               pc-numero-nota = "0".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaPrecoIPIOrdemCompra DBOProgram 
PROCEDURE calculaPrecoIPIOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose: Esse mÇtodo tem como objetivo calcular o preáo do material,
           o valor do ipi e o preáo liquido da ordem de compra.    
  Parameters:
            ipar1 : prRowidOrdem        : rowid do registro da tabela ordem-compra
            ipar2 : plConvG             : data p/ convers∆o - ATUAL ou COTAÄ«O 
            ipar3 : pdaConvG            : data de convers∆o
            ipar4 : piMoedaG            : moeda a ser convertido o preáo do material
            opar5 : pdePrecoUnitMatLiq  : preáo unit†rio do material incluso IPI
            opar6 : pdePrecoUnitMat     : preáo unit†rio do material sem IPI
            opar7 : pdeValorIPI         : valor do IPI   
  Notes:       
------------------------------------------------------------------------------*/

    def input  param prRowidOrdem        as rowid no-undo.
    def input  param plConvG             as log   no-undo.
    def input  param pdaConvG            as date  no-undo.
    def input  param piMoedaG            as int   no-undo.
    def output param pdePrecoUnitMatLiq as dec   no-undo.
    def output param pdePrecoUnitMat     as dec   no-undo.
    def output param pdeValorIPI          as dec   no-undo.
         
    find ordem-compra where 
         rowid(ordem-compra) = prRowidOrdem
         no-lock no-error.
         
   if avail ordem-compra then do:      
    find first param-compra no-lock no-error.
    if avail param-compra then
        assign lPrecoBruto = (param-compra.ipi-sobre-preco = 1).
    
    if plConvG then
        daData = ordem-compra.data-cotacao.
    else
        daData = pdaConvG.
     
    if lPrecoBruto = no then do:
       assign pdeValorIPI = (ordem-compra.preco-unit
                          *  ordem-compra.aliquota-ipi)
                          / (100 + ordem-compra.aliquota-ipi).
    end.
    else do:
        if ordem-compra.perc-descto > 0 then
            assign deValorOrig = (ordem-compra.preco-unit * 100)
                               / (100 - ordem-compra.perc-descto).
        else
            assign deValorOrig = ordem-compra.preco-unit.
     
        assign pdeValorIPI = (deValorOrig
                           * ordem-compra.aliquota-ipi)
                           / (100 + ordem-compra.aliquota-ipi).
    end.
     
    assign pdePrecoUnitMat = ordem-compra.preco-unit - pdeValorIPI.
     
    if ordem-compra.mo-codigo = piMoedaG then
        pdePrecoUnitMatLiq = ordem-compra.preco-unit.
    else do:
        run "cdp/cd0812.p" (input ordem-compra.mo-codigo,
                            input piMoedaG,
                            input ordem-compra.preco-unit,
                            input daData,
                            output pdePrecoUnitMatLiq).
        run "cdp/cd0812.p" (input ordem-compra.mo-codigo,
                            input piMoedaG,
                            input pdePrecoUnitMat,
                            input daData,
                            output pdePrecoUnitMat).
        run "cdp/cd0812.p" (input ordem-compra.mo-codigo,
                            input piMoedaG,
                            input pdeValorIPI,
                            input daData,
                            output pdeValorIPI).
    end.
  end.    
    if pdePrecoUnitMatLiq = ? then pdePrecoUnitMatLiq = 0.
    if pdePrecoUnitMat     = ? then pdePrecoUnitMat     = 0.
    if pdeValorIPI          = ? then pdeValorIPI          = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaPrecoIpiQtdeOrdemCompra DBOProgram 
PROCEDURE calculaPrecoIpiQtdeOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose: Calcula Preáo, Aliquota I.P.I. e Quantidade da Ordem-compra.    
  Parameters:
            ipar1 : prOrdemCompra : Rowid do Registro da Tabela Ordem-compra.
            ipar2 : plConvG       : Armazena Data para Convers∆o, podendo ser YES para Cotaá∆o e NO para Atual.
            ipar3 : pdaConvGl     : Data de Convers∆o.
            ipar4 : piMoedaGl     : C¢digo da Moeda.
            opar5 : pdePrecoUnit  : Retorna o Valor do Campo Preáo para o Browse.
            opar6 : pdeValorIPI   : Retorna o Valor do Campo I.P.I. para o Browse.
            opar7 : pdeQuantidade : Retorna o Valor da Quantidade para o Browse.          
  Notes:       
------------------------------------------------------------------------------*/
      
       def input  param prOrdemCompra as rowid no-undo.
       def input  param plConvG       as log   no-undo.
       def input  param pdaConvGl     as date  no-undo.
       def input  param piMoedaGl     as int   no-undo.
       def output param pdePrecoUnit  as dec   no-undo.
       def output param pdeValorIPI   as dec   no-undo.
       def output param pdeQuantidade as dec   no-undo.
       
       find first ordem-compra where
            rowid(ordem-compra) = prOrdemCompra
            no-lock no-error.
       
       if plConvG then
          daData = ordem-compra.data-cotacao.
       else
          daData = pdaConvGl.
       
       if lPrecoBruto = no then do:
            assign pdeValorIPI = (ordem-compra.preco-unit
                                 *  ordem-compra.aliquota-ipi)
                                 / (100 + ordem-compra.aliquota-ipi).
       end.
       else do:
             if ordem-compra.perc-descto > 0 then
                assign deValorOrig = (ordem-compra.preco-unit * 100)
                                     / (100 - ordem-compra.perc-descto).
             else
                assign deValorOrig = ordem-compra.preco-unit.
       
             assign pdeValorIPI = (deValorOrig
                                  * ordem-compra.aliquota-ipi)
                                  / (100 + ordem-compra.aliquota-ipi).
       end.
       
       assign pdePrecoUnit = ordem-compra.preco-unit - pdeValorIPI.
       
       if ordem-compra.mo-codigo = piMoedaGl then
          dePrecoUnit = ordem-compra.preco-unit.
       else do:
               run "cdp/cd0812.p" (input ordem-compra.mo-codigo,
                                   input piMoedaGl,input ordem-compra.preco-unit,
                                   input daData,output dePrecoUnit).
               run "cdp/cd0812.p" (input ordem-compra.mo-codigo,
                                   input piMoedaGl,input pdeValorIPI,
                                   input daData,output pdeValorIPI).
               run "cdp/cd0812.p" (input ordem-compra.mo-codigo,
                                   input piMoedaGl,input pdePrecoUnit,
                                   input daData,output pdePrecoUnit).
       end.
       if dePrecoUnit = ? then dePrecoUnit = 0.
       if pdeValorIPI = ? then pdeValorIPI = 0.
       if pdePrecoUnit = ? then pdePrecoUnit = 0.
       find first emitente where ordem-compra.cod-emitente =
         emitente.cod-emitente no-lock no-error.
         pdeQuantidade = 0.
        for each prazo-compra where prazo-compra.numero-ordem =
          ordem-compra.numero-ordem no-lock:
          pdeQuantidade = pdeQuantidade + prazo-compra.quantidade.
        end.
        
       case iValor:
            when 1 then assign pdePrecoUnit  = pdePrecoUnit.
            when 2 then assign pdeValorIPI   = pdeValorIPI.
            when 3 then assign pdeQuantidade = pdeQuantidade.
       end case.            

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaPrecoIpiQtdeOrdemCompraItemFornec DBOProgram 
PROCEDURE calculaPrecoIpiQtdeOrdemCompraItemFornec :
/*------------------------------------------------------------------------------
  Purpose:     
    Retorna os valores preáo,I.P.I. e quantidade dependendo do rowid passado pela tabela item-fornec.
  Parameters:  
    ipar1 : pr-item-fornec    : Recebe valor do r-rowid do registro da tabela item-fornec.
    ipar2 : pi-moeda-g        : Recebe o valor do codigo da moeda cforme parÉmetro.
    ipar3 : pda-conv-g        : Recebe o valor da data para convers∆o cforme parÉmetro. 
    opar5 : pde-preco-unit   : Retorna o valor do campo Preáo para o browse. 
    opar6 : pde-valor-ipi    : Retorna o valor do campo I.P.I para o browse.
    opar7 : p-de-quanitidade : Retorna o valor do campo Qtde  para o browse.
  Notes:         
------------------------------------------------------------------------------*/

def input  parameter pr-item-fornec  as rowid   no-undo.
def input  parameter pi-moeda-g      as integer no-undo.
def input  parameter l-preco-bruto   as logical no-undo.  
def input  parameter pda-conv-g      as date    no-undo.
def output parameter pde-preco-unit  as decimal no-undo.
def output parameter pde-valor-ipi   as decimal no-undo.
def output parameter pde-quantidade  as decimal no-undo.
def var de-val-orig     as decimal format ">>>>>>>>>>>>>>9,99".
def var da-data         like cotacao-item.data-cotacao.
def var de-preco-unit   like ordem-compra.preco-unit label "Preco Un"
                        format "zzzzzzzz9.9999".
define var l-tabela-g as log init no no-undo.
                         
assign l-tabela-g = if l-preco-bruto then yes else no.                         
                         
find first item-fornec where rowid(item-fornec) = pr-item-fornec no-lock no-error.

find first ordem-compra where ordem-compra.cod-emitente = item-fornec.cod-emitente no-lock no-error.

if avail ordem-compra then do:    
    find first param-compra where param-compra.cod-cond-pag = ordem-compra.cod-cond-pag no-lock no-error.
        if  avail param-compra then
            assign l-preco-bruto = param-compra.ipi-sobre-preco = 1.
        else 
            assign l-preco-bruto = no.
end.

find last ordem-compra where ordem-compra.cod-emitente = item-fornec.cod-emitente and ordem-compra.it-codigo = item-fornec.it-codigo and ordem-compra.num-pedido <> 0 SHARE-LOCK .

if avail ordem-compra then do:
    if l-preco-bruto = no then do:
       assign pde-valor-ipi = (ordem-compra.preco-unit
                          *  ordem-compra.aliquota-ipi)
                          / (100 + ordem-compra.aliquota-ipi).
    end.
    else do:
        if ordem-compra.perc-descto > 0 then
            assign de-val-orig = (ordem-compra.preco-unit * 100)
                               / (100 - ordem-compra.perc-descto).
        else
            assign de-val-orig = ordem-compra.preco-unit.
     
        assign pde-valor-ipi = (de-val-orig
                           * ordem-compra.aliquota-ipi)
                           / (100 + ordem-compra.aliquota-ipi).
    end.
      
    assign pde-preco-unit = ordem-compra.preco-unit - pde-valor-ipi 
           da-data      = if l-tabela-g then ordem-compra.data-cotacao
                          else pda-conv-g.
    
    if ordem-compra.mo-codigo = pi-moeda-g then
        de-preco-unit = ordem-compra.preco-unit.
    else do:
        run "cdp/cd0812.p" (input ordem-compra.mo-codigo,
             input pi-moeda-g,input ordem-compra.preco-unit,
             input da-data,output de-preco-unit).
        run "cdp/cd0812.p" (input ordem-compra.mo-codigo,
             input pi-moeda-g,input pde-valor-ipi,
             input da-data,output pde-valor-ipi).
        run "cdp/cd0812.p" (input ordem-compra.mo-codigo,
             input pi-moeda-g,input pde-preco-unit,
             input da-data,output pde-preco-unit).
    end.
end.

if de-preco-unit = ? then de-preco-unit = 0.
if pde-valor-ipi = ? then pde-valor-ipi = 0.
if pde-preco-unit = ? then pde-preco-unit = 0.
 
pde-quantidade = 0.

for each prazo-compra where prazo-compra.numero-ordem =
    ordem-compra.numero-ordem no-lock:
   pde-quantidade = pde-quantidade + prazo-compra.quantidade.

end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaValorUnitarioIPIOrdemCompra DBOProgram 
PROCEDURE calculaValorUnitarioIPIOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose: Caso haja IPI aplica a al≠quota sobre o valor unitˇrio.
           Caso a moeda para convers∆o seja diferente da moeda
           corrente, converte para a moeda desejada.    
  Parameters: 
            ipar1 : pdePrecoUnit   : Preáo unitˇrio da cotaá∆o
            ipar2 : pdaDataCotacao : Data da cotaá∆o
            ipar3 : pdaAliquotaIPI : Al°quota de IPI a ser aplicada na cotaá∆o
            ipar4 : pdePercDescto  : Percentual de desconto da cotaá∆o
            ipar5 : piMoCodigo     : C¢digo da Moeda da cotaá∆o
            ipar6 : piFatorConv    : Fator para data de convers∆o: 1 - Data da Cotaá∆o , 2 - Definida pelo usuˇrio
            ipar7 : pdaDataConv    : Data de convers∆o selecionada pelo usu†rio
            ipar8 : piMoedaConv    : C¢digo da Moeda selecionada pelo usuˇrio
            ipar9 : pdePrecoBruto  : Preáo bruto?
            opar10: pdeValorIPI    : Valor IPI
  
  Notes:       
------------------------------------------------------------------------------*/

    def input  param pdePrecoUnit   as dec  no-undo.
    def input  param pdaDataCotacao as date no-undo.
    def input  param pdaAliquotaIPI as dec  no-undo.
    def input  param pdePercDescto  as dec  no-undo.
    def input  param piMoCodigo     as int  no-undo.
    def input  param piFatorConv    as int  no-undo.
    def input  param pdaDataConv    as date no-undo.
    def input  param piMoedaConv    as int  no-undo.
    def input  param pdePrecoBruto  as char no-undo.
    def output param pdeValorIPI    as dec  no-undo.

     assign  daDataConversao = if piFatorConv = 1 then
                               pdaDataCotacao
                               else pdaDataConv.

     if pdePrecoBruto = "no" then do:
        assign pdeValorIPI = (pdePrecoUnit * pdaAliquotaIPI) /
                               (100 + pdaAliquotaIPI).
     end.
     else do:
             if pdePercDescto > 0 then
                assign deValorOrig = (pdePrecoUnit * 100) /
                                      (100 - pdePercDescto).
             else
                assign deValorOrig = pdePrecoUnit.

             assign pdeValorIPI = (deValorOrig * pdaAliquotaIPI) /
                                  (100 + pdaAliquotaIPI).
     end.

     if piMoCodigo <> piMoedaConv then
       run cdp/cd0812.p (input piMoCodigo,
                         input piMoedaConv,
                         input pdeValorIPI,
                         input daDataConversao,
                         output pdeValorIPI).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaValorUnitarioOrdemCompra DBOProgram 
PROCEDURE calculaValorUnitarioOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:  Calcula o valor Unit†rio da Ordem de compra.
            Caso haja IPI aplica a al°quota sobre o valor unitˇrio.
            Caso a moeda para convers∆o seja diferente da moeda
            corrente, converte para a moeda desejada.   
  Parameters: 
              ipar1  : pdPrecoUnit        : Preáo unit†rio da cotaá∆o
              ipar2  : pdaDataCotacao     : Data da cotaá∆o
              ipar3  : pdeAliquotaIPI     : Al°quota de IPI a ser aplicada na cotaá∆o
              ipar4  : pdePercDescto      : Percentual de desconto da cotaá∆o
              ipar5  : piMoCodigo         : CΩdigo da Moeda da cotaá∆o
              ipar6  : piFatorConv        : Fator para data de convers∆o: 1 - Data da Cotaá∆o , 2 - Definida pelo usu†rio
              ipar7  : pdaDataConv        : Data de convers∆o selecionada pelo usu†rio
              ipar8  : piMoedaConv        : C¢digo da Moeda selecionada pelo usu†rio
              ipar9  : pcPrecoBruto       : Preáo bruto?
              opar10 : pdeValorUnitOrdem  : Valor unit†rio j† calculado 
  
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pdPrecoUnit       as dec  no-undo.
    def input  param pdaDataCotacao    as date no-undo.
    def input  param pdeAliquotaIPI    as dec  no-undo.
    def input  param pdePercDescto     as dec  no-undo.
    def input  param piMoCodigo        as int  no-undo.
    def input  param piFatorConv       as int  no-undo.
    def input  param pdaDataConv       as date no-undo.
    def input  param piMoedaConv       as int  no-undo.
    def input  param pcPrecoBruto      as char no-undo.
    def output param pdeValorUnitOrdem as dec  no-undo.

     assign  daDataConversao = if piFatorConv = 1 then
                                  pdaDataCotacao
                                  else pdaDataConv.

     if pcPrecoBruto = "no" then do:
        assign deValorIPI = (pdPrecoUnit * pdeAliquotaIPI) /
                               (100 + pdeAliquotaIPI).
     end.
     else do:
             if pdePercDescto > 0 then
                assign deValorOrig = (pdPrecoUnit * 100) /
                                      (100 - pdePercDescto).
             else
                assign deValorOrig = pdPrecoUnit.

             assign deValorIPI = (deValorOrig * pdeAliquotaIPI) /
                                  (100 + pdeAliquotaIPI).
     end.

     assign pdeValorUnitOrdem = pdPrecoUnit - deValorIPI.

     if piMoCodigo <> piMoedaConv then
        run "cdp/cd0812.p" (input piMoCodigo,
                            input piMoedaConv,
                            input pdeValorUnitOrdem,
                            input daDataConversao,
                            output pdeValorUnitOrdem).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE converteValorOrdemCompra DBOProgram 
PROCEDURE converteValorOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose: Caso a moeda para convers∆o seja diferente da moeda
           corrente, converte para a moeda desejada.   
  Parameters: 
            ipar1 : pdePrecoUnit   : Preáo unit†rio da cotaá∆o
            ipar2 : pdaDataCotacao : Data da cotaá∆o
            ipar3 : piMoCodigo     : C¢digo da Moeda da cotaá∆o
            ipar4 : piFatorConv    : Fator para data de convers∆o: 1 - Data da Cotaá∆o , 2 - Definida pelo usu†rio
            ipar5 : pdaDataConv    : Data de convers∆o selecionada pelo usu†rio
            ipar6 : piMoedaConv    : C¢digo da Moeda selecionada pelo usu†rio
            opar7 : pdeValorOrdem  : Valor Ordem
  
  Notes:       
------------------------------------------------------------------------------*/

    def input  param pdePrecoUnit   as dec  no-undo.
    def input  param pdaDataCotacao as date no-undo.
    def input  param piMoCodigo     as int  no-undo.
    def input  param piFatorConv    as int  no-undo.
    def input  param pdaDataConv    as date no-undo.
    def input  param piMoedaConv    as int  no-undo.
    def output param pdeValorOrdem  as dec  no-undo.
                                  
     assign  daDataConversao = if piFatorConv = 1 then
                               pdaDataCotacao
                               else pdaDataConv.

     if piMoCodigo <> piMoedaConv then
       run cdp/cd0812.p (input piMoCodigo,
                         input piMoedaConv,
                         input pdePrecoUnit,
                         input daDataConversao,
                         output pdeValorOrdem).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaPrazoEntregaOrdemCompra DBOProgram 
PROCEDURE retornaPrazoEntregaOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:  Retorna 0 (zero) para o campo prazo-entrega se o prazo
            cadastrado for menor que zero.    
  Parameters: 
             iopar1 : piEntrega : retorna zero ou o mesmo valor do "input"
  Notes:       
------------------------------------------------------------------------------*/
    def input-output param piEntrega as int no-undo.

        if piEntrega < 0 then
           piEntrega = 0.
        else
           piEntrega = piEntrega.
           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaPrecosOrdemCompra DBOProgram 
PROCEDURE retornaPrecosOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:  Converte preáo da Ordem de acordo com a moeda parametrizada.
            Calcula o preáo da Ordem sem o IPI.     
  Parameters:
              ipar1 : plConG       : Convers∆o "cotaá∆o ou atual (radio-set)
              ipar2 : pdaConvG     : Data da convers∆o
              ipar3 : piMoedaG     : Moeda a ser convertido o preªo
              opar4 : pdePreco     : Preco ordem
              opar5 : pdeAliqIPI   : Aliquota IPI
              opar6 : pdeValorIPI  : Valor do IPI
              opar7 : pdePrecoUnit : Preco unit†rio da ordem
              opar8 : pdePrecoOrig : Preco original da ordem
              opar9 : pcNumeroNota : Numero da nota da ordem
              opar10: pcDescMoeda  : Descricao da moeda parametrizada
              opar11: pdaDataMovto : Data do movimento
  Notes:       
------------------------------------------------------------------------------*/
    def input  parameter prOrdem       as rowid no-undo.
    def input  parameter plConG        as log   no-undo.
    def input  parameter pdaConvG      as date  no-undo.
    def input  parameter piMoedaG      as int   no-undo.
    def input  parameter pTpDespesa    as int   no-undo.
    def output parameter pdePreco      as dec   format ">>>>>,>>>,>>9.99999" no-undo.
    def output parameter pdeAliqIPI    as dec   no-undo.
    def output parameter pdeValorIPI   as dec   no-undo.
    def output parameter pdePrecoUnit  as dec   no-undo.
    def output parameter pdePrecoOrig  as dec   no-undo.
    def output parameter pcNumeroNota  as char  no-undo.
    def output parameter pcDescMoeda   as char  no-undo.
    def output parameter pdaDataMovto  as date  no-undo.
    def output parameter pcDescTpDespesa as char format "x(30)".

    find first ordem-compra where
         rowid(ordem-compra) = prOrdem no-lock no-error.    
    if  avail ordem-compra then do:
        assign pdeAliqIPI = ordem-compra.aliquota-ipi.
        if  ordem-compra.qt-acum-rec > 0 then do: 
            for last recebimento field (num-pedido numero-ordem data-movto numero-nota)
               where recebimento.num-pedido   = ordem-compra.num-pedido
               and   recebimento.numero-ordem = ordem-compra.numero-ordem
               no-lock: end.
            if avail recebimento then do:
             assign pdaDataMovto = recebimento.data-movto
                    pcNumeroNota   = recebimento.numero-nota.
          end.
          else do:
             assign pcNumeroNota = ""
                    pdaDataMovto = ?.
            end.
        end.
        find moeda where moeda.mo-codigo = piMoedaG no-lock no-error.
        if avail moeda then
             assign pcDescMoeda = moeda.descricao.

        for first tipo-rec-desp fields (descricao)
            where tipo-rec-desp.tp-codigo = pTpDespesa no-lock: end.
        if  available tipo-rec-desp then 
            assign pcDescTpDespesa = tipo-rec-desp.descricao.
        else 
            assign pcDescTpDespesa = "":U.
        
        if  ordem-compra.situacao <> 1 and ordem-compra.situacao <> 5 then do:
             assign daData = if plConG then ordem-compra.data-cotacao
                                          else pdaConvG.

             if lPrecoBruto = no then
                assign pdeValorIPI = (ordem-compra.preco-unit
                                    *  ordem-compra.aliquota-ipi)
                                    / (100 + ordem-compra.aliquota-ipi).
            else do:
                if ordem-compra.perc-descto > 0 then
                   assign deValorOrig = (ordem-compra.preco-unit * 100)
                                      / (100 - ordem-compra.perc-descto).
                else
                   assign deValorOrig = ordem-compra.preco-unit.

                assign pdeValorIPI = (deValorOrig
                                    * ordem-compra.aliquota-ipi)
                                    / (100 + ordem-compra.aliquota-ipi).
             end.

             assign pdePreco      = ordem-compra.preco-unit - pdeValorIPI
                    pdePrecoUnit = ordem-compra.preco-unit
                    pdePrecoOrig = ordem-compra.preco-orig.                   

             if ordem-compra.mo-codigo <> piMoedaG then do:
                run cdp/cd0812.p (input  ordem-compra.mo-codigo,
                                  input  piMoedaG,
                                  input  pdePreco,
                                  input  daData,
                                  output pdePreco).
                run cdp/cd0812.p (input  ordem-compra.mo-codigo,
                                  input  piMoedaG,
                                  input  pdeValorIPI,
                                  input  daData,
                                  output pdeValorIPI).
                run cdp/cd0812.p (input  ordem-compra.mo-codigo,
                                  input  piMoedaG,
                                  input  pdePrecoUnit,
                                  input  daData,
                                  output pdePrecoUnit).
                run cdp/cd0812.p (input  ordem-compra.mo-codigo,
                                  input  piMoedaG,
                                  input  pdePrecoOrig,
                                  input  daData,
                                  output pdePrecoOrig).
             end.
             if pdePreco       = ? then pdePreco      = 0.
             if deAliquotaIPI  = ? 
             or pdePreco       = 0 then pdeAliqIPI    = 0.             
             if pdePreco       = 0 then deAliquotaIPI = 0.
             if pdeValorIPI    = ? then pdeValorIPI   = 0.
             if pdePrecoUnit   = ? then pdePrecoUnit  = 0.
             if pdePrecoOrig   = ? then pdePrecoOrig  = 0.
        end.
        else
             assign pdePrecoUnit   = 0
                    pdePreco       = 0
                    deAliquotaIPI  = 0
                    pdeValorIPI    = 0
                    pdePrecoOrig   = 0
                    pdeAliqIPI     = 0.
    end.


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
    OPEN QUERY {&QueryName} FOR EACH ordem-compra NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "nr-tab":U THEN ASSIGN pFieldValue = RowObject.nr-tab.
        WHEN "contato":U THEN ASSIGN pFieldValue = RowObject.contato.
        WHEN "usuario":U THEN ASSIGN pFieldValue = RowObject.usuario.
        WHEN "dep-almoxar":U THEN ASSIGN pFieldValue = RowObject.dep-almoxar.
        WHEN "hora-atualiz":U THEN ASSIGN pFieldValue = RowObject.hora-atualiz.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "item-pai":U THEN ASSIGN pFieldValue = RowObject.item-pai.
        &IF "{&mguni_version}" >= "2.071" &THEN
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "requisitante":U THEN ASSIGN pFieldValue = RowObject.requisitante.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        &if defined(bf_mat_contratos) &then
        &else 
            WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato. 
        &endif      
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-comprado":U THEN ASSIGN pFieldValue = RowObject.cod-comprado.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "cod-roteiro":U THEN ASSIGN pFieldValue = RowObject.cod-roteiro.
        WHEN "comentarios":U THEN ASSIGN pFieldValue = RowObject.comentarios.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-atualiz":U THEN ASSIGN pFieldValue = RowObject.data-atualiz.
        WHEN "data-cotacao":U THEN ASSIGN pFieldValue = RowObject.data-cotacao.
        WHEN "data-emissao":U THEN ASSIGN pFieldValue = RowObject.data-emissao.
        WHEN "data-pedido":U THEN ASSIGN pFieldValue = RowObject.data-pedido.
        WHEN "dat-ordem":U THEN ASSIGN pFieldValue = RowObject.dat-ordem.
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "valor-descto":U THEN ASSIGN pFieldValue = RowObject.valor-descto.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "ind-reajuste":U THEN ASSIGN pFieldValue = RowObject.ind-reajuste.
        WHEN "perc-descto":U THEN ASSIGN pFieldValue = RowObject.perc-descto.
        WHEN "perc-sales-tax":U THEN ASSIGN pFieldValue = RowObject.perc-sales-tax.
        WHEN "perc-vat":U THEN ASSIGN pFieldValue = RowObject.perc-vat.
        WHEN "pre-unit-for":U THEN ASSIGN pFieldValue = RowObject.pre-unit-for.
        WHEN "preco-fornec":U THEN ASSIGN pFieldValue = RowObject.preco-fornec.
        WHEN "preco-orig":U THEN ASSIGN pFieldValue = RowObject.preco-orig.
        WHEN "preco-unit":U THEN ASSIGN pFieldValue = RowObject.preco-unit.
        WHEN "qt-acum-dev":U THEN ASSIGN pFieldValue = RowObject.qt-acum-dev.
        WHEN "qt-acum-nec":U THEN ASSIGN pFieldValue = RowObject.qt-acum-nec.
        WHEN "qt-acum-rec":U THEN ASSIGN pFieldValue = RowObject.qt-acum-rec.
        WHEN "qt-solic":U THEN ASSIGN pFieldValue = RowObject.qt-solic.
        WHEN "saldo-emb":U THEN ASSIGN pFieldValue = RowObject.saldo-emb.
        WHEN "saldo-gi":U THEN ASSIGN pFieldValue = RowObject.saldo-gi.
        WHEN "valor-frete":U THEN ASSIGN pFieldValue = RowObject.valor-frete.
        WHEN "valor-taxa":U THEN ASSIGN pFieldValue = RowObject.valor-taxa.
        WHEN "aliquota-icm":U THEN ASSIGN pFieldValue = RowObject.aliquota-icm.
        WHEN "aliquota-ipi":U THEN ASSIGN pFieldValue = RowObject.aliquota-ipi.
        WHEN "aliquota-iss":U THEN ASSIGN pFieldValue = RowObject.aliquota-iss.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "num-id-documento":U THEN ASSIGN pFieldValue = RowObject.num-id-documento.
        WHEN "num-ord-inv":U THEN ASSIGN pFieldValue = RowObject.num-ord-inv.
        WHEN "num-pedido":U THEN ASSIGN pFieldValue = RowObject.num-pedido.
        WHEN "num-processo-mp":U THEN ASSIGN pFieldValue = RowObject.num-processo-mp.
        WHEN "num-seq-item":U THEN ASSIGN pFieldValue = RowObject.num-seq-item.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "op-codigo":U THEN ASSIGN pFieldValue = RowObject.op-codigo.
        WHEN "op-seq":U THEN ASSIGN pFieldValue = RowObject.op-seq.
        WHEN "ordem-servic":U THEN ASSIGN pFieldValue = RowObject.ordem-servic.
        WHEN "cota-ordem":U THEN ASSIGN pFieldValue = RowObject.cota-ordem.
        WHEN "seq-evento":U THEN ASSIGN pFieldValue = RowObject.seq-evento.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "sit-ordem-contrat":U THEN ASSIGN pFieldValue = RowObject.sit-ordem-contrat.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        WHEN "tp-despesa":U THEN ASSIGN pFieldValue = RowObject.tp-despesa.
        &IF "{&mguni_version}" < "2.071" &THEN
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "linha":U THEN ASSIGN pFieldValue = RowObject.linha.
        WHEN "origem":U THEN ASSIGN pFieldValue = RowObject.origem.
        WHEN "pend-aprov":U THEN ASSIGN pFieldValue = RowObject.pend-aprov.
        WHEN "prazo-entreg":U THEN ASSIGN pFieldValue = RowObject.prazo-entreg.
        WHEN "natureza":U THEN ASSIGN pFieldValue = RowObject.natureza.
        WHEN "nr-alt-preco":U THEN ASSIGN pFieldValue = RowObject.nr-alt-preco.
        &if defined(bf_mat_contratos) &then
          when "nr-contrato" then ASSIGN pFieldValue = RowObject.nr-contrato.
        &endif
        WHEN "nr-dias-taxa":U THEN ASSIGN pFieldValue = RowObject.nr-dias-taxa.
        WHEN "nr-ord-orig":U THEN ASSIGN pFieldValue = RowObject.nr-ord-orig.
        WHEN "nr-processo":U THEN ASSIGN pFieldValue = RowObject.nr-processo.
        WHEN "nr-requisicao":U THEN ASSIGN pFieldValue = RowObject.nr-requisicao.
        WHEN "nr-seq-contr":U THEN ASSIGN pFieldValue = RowObject.nr-seq-contr.
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-maq-origem":U THEN ASSIGN pFieldValue = RowObject.cod-maq-origem.
        WHEN "cod-transp":U THEN ASSIGN pFieldValue = RowObject.cod-transp.
        WHEN "codigo-icm":U THEN ASSIGN pFieldValue = RowObject.codigo-icm.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice COMPRADOR
  Parameters:
               retorna valor dos campos do °ndice COMPRADOR
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-comprado LIKE ordem-compra.cod-comprado NO-UNDO.
    DEFINE OUTPUT PARAMETER pnumero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcod-comprado = RowObject.cod-comprado.
    ASSIGN pnumero-ordem = RowObject.numero-ordem.

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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "ordem-emitida":U THEN ASSIGN pFieldValue = RowObject.ordem-emitida.
        WHEN "cons-pmp":U THEN ASSIGN pFieldValue = RowObject.cons-pmp.
        WHEN "taxa-financ":U THEN ASSIGN pFieldValue = RowObject.taxa-financ.
        WHEN "expectativa":U THEN ASSIGN pFieldValue = RowObject.expectativa.
        WHEN "frete":U THEN ASSIGN pFieldValue = RowObject.frete.
        WHEN "impr-ficha":U THEN ASSIGN pFieldValue = RowObject.impr-ficha.
        WHEN "ind-extrac":U THEN ASSIGN pFieldValue = RowObject.ind-extrac.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "reaj-tabela":U THEN ASSIGN pFieldValue = RowObject.reaj-tabela.
        WHEN "codigo-ipi":U THEN ASSIGN pFieldValue = RowObject.codigo-ipi.
        WHEN "cons-mrp":U THEN ASSIGN pFieldValue = RowObject.cons-mrp.
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
               retorna status do processo
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


