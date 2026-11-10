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
{include/i-prgvrs.i BOIN082CA 2.00.00.024 } /*** "010024" 17/06/2025 16:40:45 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN082CA MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : BOIN082CA.P
    Purpose    : O DBO (Datasul Business Objects) ≤ um programa PROGRESS
                 que cont≤m a lΩgica de negΩcio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      : BO com procedures que fazem algum tipo de c†lculo.
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiªío ---*/
&GLOBAL-DEFINE DBOName cotacao-item
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName cotacao-item
&GLOBAL-DEFINE TableLabel cotacao-item
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S¢ a DBO principal (boin082.p) est† com as funá‰es de inclui (createRecord), 
**  modifica (updateRecord) e elimina (deleteRecord) habilitadas, 
**  porque S‡ nela foram implementadas as triggers do dicion†rio.
**  Para desabilitar as procedures foram usados os prÇ-processadores abaixo.
**  A procedure validateRecord dessa DBO n∆o deve ser usada.
*********************************************************************************/
&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0


/*--- Include com definiªío da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diretΩrio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idºntico ao nome do DBO mas com
      extensío .i ---*/
      
{utp/ut-glob.i}      
{inbo/boin082.i RowObject}
{include/i-epc200.i boin082ca}

/*--- Include com definiªío da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraªío da definiªío da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiªío
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/*  Vari†veis utilizados nas procedures  */
   def var de-perc-aux    as dec     format ">>9,99999" no-undo.
   def var eCotacao       as dec     no-undo.
   def var eValorPresente as decimal no-undo.
   def var daConvG        as date    no-undo.
   def var daData         as date    no-undo.
   def var deValorOrig    as dec     no-undo.
   def var deIndice       as dec     no-undo.
   def var deConver       as dec     no-undo.   
   def var iMoedaG        as int     no-undo.
   def var lPrecoBruto    as log     no-undo.
   def var lConvG         as log     no-undo.
   def var l-preco-bruto  as log     no-undo. /* declarado c/ "-" pois Ç utilizado dentro de includes*/
   DEF VAR de-indice      AS DEC     NO-UNDO.
/*Include utilizada para a validaá∆o de casas decimais usada na 
  procedure calculaValorIpi*/

{cep/ce1234.i}

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
         HEIGHT             = 14.25
         WIDTH              = 39.86.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcIndiceCotacaoItem DBOProgram 
PROCEDURE calcIndiceCotacaoItem :
/*------------------------------------------------------------------------------
  Purpose:  O mÇtodo verifica se o item Ç um debito direto e se a unidade de medida informada na cotaªío
            Ç diferente da unidade de medida informada na parcela, isso para buscar o fator de convers∆o
            na tabela de convers∆o (tab-conv-un). Caso o item n∆o seja debito direto, o programa irˇ buscar 
            o fator de convers∆o do relacionamento item/fornecedor.
            O fator de convers∆o Ç utilizado para converter a quantidade da ordem de compra, que estˇ na  
            unidade de medida interna da empresa  para unidade de medida do fornecedor.
            E tambÇm Ç utilizado para converter o preáo informado na cotaá∆o, que est† na unidade de medida 
            do fornecedor para unidade de medida interna da empresa.    
  Parameters: 
            ipar1 : Rowobject : tabela cotacao-item
            ipar2 : pcItem    : c¢dgigo do item
            opar3 : pdeIndice : qtidade de ordem de compra converitda
  Notes:       
------------------------------------------------------------------------------*/

    def input  param table      for Rowobject.
    def input  param pcItem     as char no-undo.
    def output param pdeIndice  as dec no-undo.  
    
    ASSIGN de-indice = 1.
    find first Rowobject no-lock no-error.
    
    for first ordem-compra fields(numero-ordem) where 
         ordem-compra.numero-ordem = Rowobject.numero-ordem 
         no-lock: end.
    FIND FIRST param-compra NO-LOCK NO-ERROR.

    for first item fields(it-codigo tipo-contr) where 
         item.it-codigo = pcItem 
         no-lock: end.
         
    for first item-fornec fields(it-codigo    cod-emitente ativo 
                                 fator-conver num-casa-dec unid-med-for) where 
         item-fornec.it-codigo    = item.it-codigo and
         item-fornec.cod-emitente = Rowobject.cod-emitente and
         item-fornec.ativo          no-lock: end.

    if  item.tipo-contr = 4 and avail ordem-compra and not avail item-fornec then do:
        for first prazo-compra fields(numero-ordem un) where 
            prazo-compra.numero-ordem = ordem-compra.numero-ordem no-lock: end.

        IF AVAIL prazo-compra THEN DO:
            if Rowobject.un <> prazo-compra.un then do:
                find tab-conv-un where
                     tab-conv-un.un           = prazo-compra.un and
                     tab-conv-un.unid-med-for = Rowobject.un no-lock no-error.
                  ASSIGN deConver = if avail tab-conv-un
                                   then (1 / (exp(10, tab-conv-un.num-casa-dec)) * tab-conv-un.fator-conver)
                                   else 1.
            end.
            else DO:
                assign /*pdeIndice = 1*/
                       deConver = 1.
            END.
        END.
        ELSE DO:
                 assign /*pdeIndice = 1*/
                        deConver = 1.
        END.
    end.
    ELSE DO:
        
        IF AVAIL param-compra 
             AND param-compra.log-multi-unid-medid  
             AND AVAIL item-fornec 
             AND item-fornec.unid-med-for <> RowObject.un THEN DO:
             /*Utiliza M£ltiplas Unidades de Medida
               Se unidade da item-fornec <> unidade da cotaá∆o, busca fator de convers∆o conforme a unidade da cotaá∆o*/
            FOR FIRST item-fornec-umd FIELDS(fator-conver num-casa-dec)
                WHERE item-fornec-umd.it-codigo = item-fornec.it-codigo
                  AND item-fornec-umd.cod-emitente = item-fornec.cod-emitente
                  AND item-fornec-umd.unid-med-for = RowObject.un 
                  AND item-fornec-umd.log-ativo NO-LOCK: END.
            assign /*pdeIndice = if avail item-fornec-umd 
                           then item-fornec-umd.fator-conver / exp(10, item-fornec-umd.num-casa-dec)
                           else 1.*/
                   deConver = if avail item-fornec-umd
                               then (1 / (exp(10, item-fornec-umd.num-casa-dec)) * item-fornec-umd.fator-conver)
                               else 1.
        END.
        ELSE DO:
            assign /*pdeIndice = if avail item-fornec 
                               then item-fornec.fator-conver / exp(10, item-fornec.num-casa-dec)
                               else 1*/
                   deConver = if avail item-fornec
                               then (1 / (exp(10, item-fornec.num-casa-dec)) * item-fornec.fator-conver)
                               else 1.
        END.
    END.

    ASSIGN de-indice = deConver.
    
    for first prazo-compra fields(numero-ordem un) where 
              prazo-compra.numero-ordem = ordem-compra.numero-ordem 
              no-lock: end.
    if avail prazo-compra AND Rowobject.un <> prazo-compra.un then do:
        {cdp/cd9950.i prazo-compra.un Rowobject.un Rowobject.cod-emitente}
    END.
    ASSIGN pdeIndice = de-indice.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaCotacaoMoeda DBOProgram 
PROCEDURE calculaCotacaoMoeda :
/*------------------------------------------------------------------------------
  Purpose: Calcula a cotaá∆o da moeda em uma determinada 
           data atravÇs do programa cd0812.  
  Parameters:
            ipar3 : piMoCodigo      : C¢digo da Moeda da cotaá∆o  
            ipar4 : piMoedaConv     : C¢digo da Moeda selecionada pelo usu†rio
            ipar1 : pdePrecoUnit    : Preªo unitˇrio da cotaá∆o
            ipar2 : pdaDataCotacao  : Data da cotaá∆o
            opar5 : pdeValorCotacao : Valor Cotacao Convertida 
  Notes:       
------------------------------------------------------------------------------*/

    def input  param piMoCodigo      as int  no-undo.
    def input  param piMoedaConv     as int  no-undo.
    def input  param pdePrecoUnit    as dec  no-undo.
    def input  param pdaDataCotacao  as date no-undo.
    def output param pdeValorCotacao as dec  no-undo.

   find moeda where 
        moeda.mo-codigo = piMoCodigo 
        no-lock no-error.
        
    if  available moeda then do:        
      run cdp/cd0812.p (input  pimocodigo,
                        input  piMoedaConv,
                        input  pdePrecoUnit,
                        input  pdaDataCotacao,
                        output pdeValorCotacao).
    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaPrecoConv DBOProgram 
PROCEDURE calculaPrecoConv :
/*------------------------------------------------------------------------------
  Purpose:     
    Calcula Preáo Convertido
  Parameters:  
    ipar1 : pi-mo-codigo    : c¢digo da moeda (tabela cotacao-item)
    ipar2 : pi-moeda-g      : c¢digo da moeda (tela parÉmetros)
    ipar3 : pda-conv-g      : data conversao da moeda (tela de parÉmetros)
    ipar4 : pde-preco-uni   : preáo unit†rio
    opar5 : pde-preco-conv  : preáo convertido
  Notes:       
------------------------------------------------------------------------------*/
def input  param pi-mo-codigo   as int  no-undo.
def input  param pi-moeda-g     as int  no-undo.
def input  param pda-conv-g      as date no-undo.
def input  param pde-preco-unit as dec  no-undo.
def output param pde-preco-conv as dec  no-undo.

 if pi-mo-codigo = pi-moeda-g then 
  assign pde-preco-conv = pde-preco-unit.
 else 
  run cdp/cd0812.p (input pi-mo-codigo, input pi-moeda-g, 
                    input pde-preco-unit, input pda-conv-g, 
                    output pde-preco-conv).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaPrecoFornecConv DBOProgram 
PROCEDURE calculaPrecoFornecConv :
/*------------------------------------------------------------------------------
  Purpose: 
    Calcula o preco fornec convertido       
  Parameters:  
    ipar1 : pi-mo-codigo          : c¢digo da moeda
    ipar2 : pde-preco-fornec      : preáo fornec
    ipar3 : pi-moeda-g            : moeda 
    ipar4 : pda-conv-g            : data conv
    opar5 : pde-preco-fornec-conv : preáo fornec convertido
  Notes:       
------------------------------------------------------------------------------*/
def input  param pi-mo-codigo          as int     no-undo.
def input  param pde-preco-fornec      as decimal no-undo.
def input  param pi-moeda-g            as int     no-undo.
def input  param pda-conv-g            as date    no-undo.
def output param pde-preco-fornec-conv as decimal no-undo.

 if pi-mo-codigo = pi-moeda-g then
  assign pde-preco-fornec-conv = pde-preco-fornec.
 else 
  run cdp/cd0812.p (input pi-mo-codigo, input pi-moeda-g, 
                    input pde-preco-fornec, input pda-conv-g, 
                    output pde-preco-fornec-conv).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaPrecoMat DBOProgram 
PROCEDURE calculaPrecoMat :
/*------------------------------------------------------------------------------
  Purpose:     
    Calcula preáo mat
  Parameters: 
    ipar1 : pi-cod-cond-pag     : cod-cond-pag (tabela cotacao-item)
    ipar2 : pde-valor-taxa      : valor-taxa (tabela cotacao-item)
    ipar3 : pi-nr-dias-taxa     : nr-dias-taxa (tabela cotacao-item)
    opar4 : pde-preco-mat       : preco mat
  Notes:       
------------------------------------------------------------------------------*/
def input  param pi-cod-cond-pag as int no-undo.
def input  param pde-valor-taxa  as dec no-undo.
def input  param pi-nr-dias-taxa as int no-undo.
def input  param pde-preco-unit  as dec no-undo.
def output param pde-preco-mat   as dec no-undo.

assign pde-preco-mat = pde-preco-unit.

run ccp/cc9020.p (input  no,
                  input  pi-cod-cond-pag,
                  input  pde-valor-taxa,
                  input  pi-nr-dias-taxa,
                  input  pde-preco-mat,
                  output pde-preco-mat).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaPrecoMatConv DBOProgram 
PROCEDURE calculaPrecoMatConv :
/*------------------------------------------------------------------------------
  Purpose:     
    Calcula preáo mat conv 
  Parameters: 
    ipar1 : pi-mo-codigo        : c¢digo da moeda (tabela cotacao-item)
    ipar2 : pi-moeda-g          : c¢digo da moeda (tela de parÉmetros)
    ipar3 : pde-preco-mat       : preco mat
    ipar4 : pda-conv-g          : data convers∆o (tela de parÉmetros)
    opra5 : pde-preco-conv-mat  : preáo mat conv
  Notes:       
------------------------------------------------------------------------------*/
def input  param pi-mo-codigo       as int  no-undo.
def input  param pi-moeda-g         as int  no-undo.
def input  param pde-preco-mat      as dec  no-undo.
def input  param pda-conv-g         as date no-undo.
def output param pde-preco-mat-conv as dec  no-undo.

 if pi-mo-codigo = pi-moeda-g then
  assign pde-preco-mat-conv = pde-preco-mat.
 else 
  run cdp/cd0812.p (input pi-mo-codigo, input pi-moeda-g, 
                    input pde-preco-mat, input pda-conv-g, 
                    output pde-preco-mat-conv).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaPrecoTotalCotConv DBOProgram 
PROCEDURE calculaPrecoTotalCotConv :
/*------------------------------------------------------------------------------
  Purpose:    
    Calcula preco tolal cot conv  
  Parameters:  
    ipar1 : pi-mo-codigo        : c¢digo da moeda (tabela cotaá∆o-item)
    ipar2 : pi-moeda-g          : c¢digo da moeda (tela de parÉmetros)
    ipar3 : pde-preco-unit      : preáo unit†rio
    ipar4 : pda-conv-g          : data convers∆o (tela de parÉmetros)
    ipar5 : pi-numero-ordem     : n£mero da ordem (tabela cotaá∆o-item)
    opar6 : pde-preco-total-cot : preáo total cotaá∆o
  Notes:       
------------------------------------------------------------------------------*/
def input  param pi-mo-codigo        as int no-undo.
def input  param pi-moeda-g          as int no-undo.
def input  param pde-preco-unit      as dec no-undo.
def input  param pda-conv-g          as date no-undo.
def input  param pi-numero-ordem     as int no-undo.
def output param pde-preco-total-cot as dec no-undo.

for first ordem-compra fields(numero-ordem qt-solic mo-codigo) where 
    ordem-compra.numero-ordem = pi-numero-ordem no-lock: end.

assign pde-preco-total-cot = 0.

if avail ordem-compra then 
 if pi-mo-codigo = pi-moeda-g then
  assign pde-preco-total-cot = fn_ajust_dec((pde-preco-unit * ordem-compra.qt-solic),ordem-compra.mo-codigo).
 else do:
  run cdp/cd0812.p (input pi-mo-codigo, input pi-moeda-g, 
                    input pde-preco-unit, input pda-conv-g, 
                    output pde-preco-total-cot).
  
  assign pde-preco-total-cot = fn_ajust_dec((pde-preco-total-cot * ordem-compra.qt-solic),pi-mo-codigo).                 
 end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaPrecoUnit DBOProgram 
PROCEDURE calculaPrecoUnit :
/*------------------------------------------------------------------------------
  Purpose:     
    Calcula preco unit†rio
  Parameters:  
    ipar1 : pr-cotacao-item    : rowid atual da tabela cotacao-item
    opar2 : pde-pre-unit       : preáo unit†rio 
    opra3 : pde-valor-ipi      : valor ipi
  Notes:       
------------------------------------------------------------------------------*/
def input  param pr-cotacao-item  as rowid   no-undo.
def output param pde-preco-unit   as decimal no-undo.
def output param pde-valor-ipi    as decimal no-undo.
 
 for first cotacao-item fields(pre-unit-for  aliquota-ipi mo-codigo 
                               perc-descto data-cotacao preco-unit
                               cod-cond-pag  valor-taxa   nr-dias-taxa) where 
     rowid(cotacao-item) = pr-cotacao-item no-lock: end.


 run calculaValorIpi (output pde-valor-ipi).
 
 if cotacao-item.pre-unit-for >= pde-valor-ipi then
    assign pde-preco-unit = cotacao-item.pre-unit-for - pde-valor-ipi.
 else   
    assign pde-preco-unit = 0.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaPrecoUnitario DBOProgram 
PROCEDURE calculaPrecoUnitario :
/*------------------------------------------------------------------------------
  Purpose:     
    Calcula preco unit†rio
    Parameters:  
    ipar1 : prCotacaoItem    : rowid atual da tabela cotacao-item
    opar2 : pePrecoUnit      : preáo unit†rio
  Notes:       
------------------------------------------------------------------------------*/
def input  param prCotacaoItem  as rowid   no-undo.
def output param pePrecoUnit    as decimal no-undo.
 
    for first cotacao-item fields(pre-unit-for  aliquota-ipi mo-codigo 
                               perc-descto data-cotacao preco-unit
                               cod-cond-pag  valor-taxa   nr-dias-taxa) where 
        rowid(cotacao-item) = prCotacaoItem no-lock: end.

    if cotacao-item.mo-codigo <> 0 then do:
        run cdp/cd0812.p (input cotacao-item.mo-codigo, input 0, input 1,
                          input cotacao-item.data-cotacao, output eCotacao).
        if eCotacao = ? then
            assign eCotacao = 0.
    end.
    else
        assign eCotacao = 1.
 
    assign eValorPresente = cotacao-item.preco-unit * eCotacao.
 
    run ccp/cc9020.p (input  no,
                      input  cotacao-item.cod-cond-pag,
                      input  cotacao-item.valor-taxa,
                      input  cotacao-item.nr-dias-taxa,
                      input  eValorPresente,
                      output eValorPresente).
 
    assign pePrecoUnit = eValorPresente.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaPrecoUnitFornecedorCotacao DBOProgram 
PROCEDURE calculaPrecoUnitFornecedorCotacao:
/*------------------------------------------------------------------------------
  Purpose: Calcula o preáo unitˇrio do Fornecedor para
           cotaá‰es de ordens de compra
  Parameters: ipar1  : piNumeroOrdem          : Número da Ordem  
              iopar2 : table for rowObject : Tabela de dados da cotaªío
  Notes:       
------------------------------------------------------------------------------*/
    def input param  plLeavePercentual as log no-undo.
    def input param  piNumeroOrdem     as int no-undo.
    def input-output param table       for rowObject.

    
    
    find first rowObject exclusive-lock no-error.
    /*-----------------------------------------------------------------*/
    /* Include i-epc200.i2: Criacao de registro para temp-table tt-epc */
    for each tt-epc where tt-epc.cod-event = "BaseDesconto":
        delete tt-epc.
    end.

    {include/i-epc200.i2 &CodEvent='"BaseDesconto"'
                         &CodParameter='"rowidtable'"
                         &ValueParameter="string(rowObject.r-rowid)"}
                         
    /* Include i-epc201.i: Chamada do programa de EPC */
    {include/i-epc201.i "BaseDesconto"}
    if  return-value = "NOK":U then do:
        undo, return "NOK":U.
    end.
    /*-----------------------------------------------------------------*/

    FOR FIRST tt-epc
        WHERE tt-epc.cod-event   = "BaseDesconto"
          AND tt-epc.cod-parameter = "LeavePercentual":
        IF tt-epc.val-parameter = 'YES' THEN
            ASSIGN plLeavePercentual = YES.
        IF tt-epc.val-parameter = 'NO' THEN
            ASSIGN plLeavePercentual = NO.

    END.  
    
    if not plLeavePercentual then do:
        
        /** Evento On Leave do campo de-valor-desconto do UIB **/
        assign de-perc-aux = (rowObject.valor-descto * 100) / rowObject.preco-fornec.
        if  de-perc-aux >= 0 and de-perc-aux < 100 then
            assign rowObject.perc-descto = de-perc-aux.
        if  de-perc-aux >= 100 then
            assign rowObject.perc-descto = 99.99999.
    end.
    else do:
        assign rowObject.valor-descto = (rowObject.preco-fornec * rowObject.perc-descto ) / 100.
    end.
    IF AVAIL param-compra THEN 
        assign lPrecoBruto = (param-compra.ipi-sobre-preco = 1).

    IF rowObject.numero-ordem > 0 THEN DO:
        RUN indiceConversaoUnidMed (input piNumeroOrdem,
                                    input rowObject.un,
                                    output deIndice).
    END.
    ELSE DO:
        RUN indiceConversaoUnidMedDesvinc (input piNumeroOrdem,
                                           input rowObject.un,
                                           input rowObject.cod-emitente,
                                           output deIndice).
    END.
    assign l-preco-bruto = lPrecoBruto.

   
    {cdp/cd9300.i rowObject}  /* C†lculo de preáos */

    /*-----------------------------------------------------------------*/
    /* Include i-epc200.i2: Criacao de registro para temp-table tt-epc */
    for each tt-epc where tt-epc.cod-event = "AfterDesconto":
        delete tt-epc.
    end.

    {include/i-epc200.i2 &CodEvent='"AfterDesconto"'
                         &CodParameter='"handle"'
                         &ValueParameter="string(this-procedure)"}
                        
    {include/i-epc200.i2 &CodEvent='"AfterDesconto"'
                         &CodParameter='"table"'
                         &ValueParameter='"rowObject"'}

    {include/i-epc200.i2 &CodEvent='"AfterDesconto"'
                         &CodParameter='"r-rowid"'
                         &ValueParameter='" "'}
                         
     /* Include i-epc201.i: Chamada do programa de EPC */
    {include/i-epc201.i "AfterDesconto"}
    if  return-value = "NOK":U then do:
        undo, return "NOK":U.
    end.
    /*-----------------------------------------------------------------*/
   
    return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaUnitConv DBOProgram 
PROCEDURE calculaUnitConv :
/*------------------------------------------------------------------------------
  Purpose:     
    Calcula Unidade de convers∆o.
  Parameters: 
    ipar1 : pi-mo-codigo       : codigo da moeda
    ipar2 : pi-moeda-g         : moeda
    ipar3 : pde-pre-unit-for   : preco unit fornec
    ipar4 : pda-conv-g         : data convers∆o
    opar5 : pde-unit-conv      : unidade de convers∆o   
  Notes:       
------------------------------------------------------------------------------*/
def input  param pi-mo-codigo      as int  no-undo.
def input  param pi-moeda-g        as int  no-undo.
def input  param pde-pre-unit-for  as dec  no-undo.
def input  param pda-conv-g        as date no-undo.
def output param pde-unit-conv     as dec  no-undo.

 if pi-mo-codigo = pi-moeda-g then
  assign pde-unit-conv = pde-pre-unit-for.
 else 
  run cdp/cd0812.p (input pi-mo-codigo, input pi-moeda-g, 
                    input pde-pre-unit-for, input pda-conv-g, 
                    output pde-unit-conv).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaValorConv DBOProgram 
PROCEDURE calculaValorConv :
/*------------------------------------------------------------------------------
  Purpose:     
    Calcula valor ipi convertido.
  Parameters:
    ipar1 : pi-mo-codigo    : c¢digo da moeda (tabela cotacao-item)
    ipar2 : pi-moeda-g      : c¢digo da moeda (tela de parÉmetros)
    ipar3 : pde-valor-ipi   : valor ipi
    ipar4 : pda-conv-g      : data convers∆o (tela de parÉmetros)
    opar5 : pde-valor-conv  : valor ipi convertido.
  Notes:       
------------------------------------------------------------------------------*/
def input  param pi-mo-codigo   as int  no-undo.
def input  param pi-moeda-g     as int  no-undo.
def input  param pde-valor-ipi  as dec  no-undo.
def input  param pda-conv-g     as date no-undo.
def output param pde-valor-conv as dec  no-undo.

 if pi-mo-codigo = pi-moeda-g then
  assign pde-valor-conv = pde-valor-ipi.
 else 
  run cdp/cd0812.p (input pi-mo-codigo, input pi-moeda-g, 
                    input pde-valor-ipi, input pda-conv-g, 
                    output pde-valor-conv).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaValorIpi DBOProgram 
PROCEDURE calculaValorIpi :
/*------------------------------------------------------------------------------
  Purpose:     
    Calcula valor IPI
  Parameters:  
    opar1 : pde-valo-ipi : valor ipi
  Notes:       
------------------------------------------------------------------------------*/
/*-------------ParÉmetros-----------------------*/
def output param pde-valor-ipi  as decimal no-undo.

/*-------------VariavÇis locais-----------------*/
def var l-preco-bruto as logical no-undo.
def var de-val-orig   as decimal no-undo.


if avail param-compra then do:
    if  param-compra.ipi-sobre-preco = 1 then 
        assign l-preco-bruto = yes.
    else 
        assign l-preco-bruto = no.
end. 
else 
    assign l-preco-bruto = no.
   
if  l-preco-bruto = no then do:
    assign pde-valor-ipi = fn_ajust_dec(((cotacao-item.pre-unit-for * cotacao-item.aliquota-ipi) /
                          (100 + cotacao-item.aliquota-ipi)),cotacao-item.mo-codigo).
end.
else do:
    if  cotacao-item.perc-descto > 0 then 
        assign de-val-orig = (cotacao-item.pre-unit-for * 100) / 
                             (100 - cotacao-item.perc-descto).
    else                                             
        assign de-val-orig = cotacao-item.pre-unit-for.
    assign pde-valor-ipi = fn_ajust_dec(((de-val-orig * cotacao-item.aliquota-ipi) / 
                          (100 + cotacao-item.aliquota-ipi)),cotacao-item.mo-codigo).
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE indiceConversaoUnidMed DBOProgram 
PROCEDURE indiceConversaoUnidMed :
/*------------------------------------------------------------------------------
  Purpose: Calcula o °ndice de convers∆o da unidade de
           medida para cotaá‰es da Ordem.   
  Parameters: 
            ipar1 : piNumeroOrdem  : N£mero da Ordem
            ipar2 : pcUn           : Unidade de medida da cotaá∆o
            opar3 : pdeIndice      : °ndice de Convers∆o
  Notes:       
------------------------------------------------------------------------------*/

    def input  param piNumeroOrdem as int  no-undo.
    def input  param pcUn           as char no-undo.
    def output param pdeIndice      as dec  no-undo.
  
    FIND FIRST param-compra NO-LOCK NO-ERROR.
    for first ordem-compra fields(numero-ordem it-codigo cod-emitente) where
         ordem-compra.numero-ordem = piNumeroOrdem
         no-lock: end.
    
    for first item fields(it-codigo tipo-contr) where 
         item.it-codigo = ordem-compra.it-codigo
         no-lock: end.
    
    assign pdeIndice = 1
           de-indice = 1.    
    
    if avail item then do:
        for first prazo-compra fields(numero-ordem un) where 
                prazo-compra.numero-ordem = ordem-compra.numero-ordem 
                no-lock: end.
        if avail prazo-compra AND pcUn <> prazo-compra.un then do:
            {cdp/cd9950.i prazo-compra.un pcUn ordem-compra.cod-emitente}
            ASSIGN pdeIndice = de-indice.
        END.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE indiceConversaoUnidMedIDesvinc DBOProgram 
PROCEDURE indiceConversaoUnidMedDesvinc :
/*------------------------------------------------------------------------------
  Purpose: Calcula o °ndice de convers∆o da unidade de
           medida para cotaá‰es desvinculada (sem ordem de compra).   
  Parameters: 
            ipar1 : pcItCodigo     : C¢digo do item
            ipar2 : pcUn           : Unidade de medida da cotaá∆o
            ipar3 : piCodEmitente  : C¢digo do emitente
            opar4 : pdeIndice      : °ndice de Convers∆o
  Notes:       
------------------------------------------------------------------------------*/

    def input  param pcItCodigo     as char no-undo.
    def input  param pcUn           as char no-undo.
    DEF INPUT  PARAM piCodEmitente  AS INT  NO-UNDO.
    def output param pdeIndice      as dec  no-undo.

    FIND FIRST param-compra NO-LOCK NO-ERROR.
    
    for first item fields(it-codigo tipo-contr) where 
         item.it-codigo = pcItCodigo
         no-lock: end.
    
    assign pdeIndice = 1
           de-indice = 1.    
    
    if avail item then do:
        if avail item AND pcUn <> item.un then do:
            {cdp/cd9950.i item.un pcUn piCodEmitente}
            ASSIGN pdeIndice = de-indice.
        END.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inicializaPrecoconvIPI DBOProgram 
PROCEDURE inicializaPrecoconvIPI :
/*------------------------------------------------------------------------------
  Purpose:   Inicializa os valores preªo-conv e I.P.I. dependendo 
             do rowid passado pela tabela cotacao-item.
  Parameters: 
              ipar1  :   prCotacaoItem   : Recebe valor do r-rowid do registro da tabela cotacao-item.
              ipar2  :   plConvG         : Recebe o valor no = cotacao e yes = atual cforme par≥metro.
              ipar3  :   piMoedaG        : Recebe o valor do codigo da moeda cforme par≥metro.
              iopar4 :   pdaConvG        : Recebe o valor da data para conversío cforme par≥metro. 
              iopar5 :   pdeValorIPI     : Retorna o valor do campo I.P.I para o browse.
              iopar6 :   pdePrecoConv    : Retorna o valor do campo Preªo para o browse. 
              iopar7 :   pdePrecoUnit    : Retorna o valor do preªo Convertido para o browse.
  Notes:       
------------------------------------------------------------------------------*/

    def input  parameter prCotacaoItem as rowid   no-undo. 
    def input  parameter plConvG       as logical no-undo.
    def input  parameter piMoedaG      as int     no-undo.
    def input  parameter pdaConvG      as date    no-undo.
    def output parameter pdeValorIPI   as decimal no-undo.
    def output parameter pdePrecoConv  as decimal no-undo.
    def output parameter pdePrecoUnit  as decimal no-undo.

    for first cotacao-item fields(data-cotacao  preco-unit aliquota-ipi 
                                  perc-descto mo-codigo) where
         rowid(cotacao-item) = prCotacaoItem 
         no-lock: end.

    if avail cotacao-item then do:
          assign daData = if  plConvG
                          then cotacao-item.data-cotacao
                          else pdaConvG.

        if lPrecoBruto = no then do:
            assign pdeValorIPI = (cotacao-item.preco-unit
                               *  cotacao-item.aliquota-ipi)
                               / (100 + cotacao-item.aliquota-ipi).
        end.
        else do:
            if cotacao-item.perc-descto > 0 then
                assign deValorOrig = (cotacao-item.preco-unit * 100)
                                   / (100 - cotacao-item.perc-descto).
            else
                assign deValorOrig = cotacao-item.preco-unit.
    
            assign pdeValorIPI = (deValorOrig
                                * cotacao-item.aliquota-ipi)
                                / (100 + cotacao-item.aliquota-ipi).
        end.
    
        assign  pdePrecoUnit = cotacao-item.preco-unit - pdeValorIPI.
    
        if cotacao-item.mo-codigo = piMoedaG then
            assign pdePrecoConv = cotacao-item.preco-unit.
        else do:
            run "cdp/cd0812.p" (input cotacao-item.mo-codigo,
                                input piMoedaG,input cotacao-item.preco-unit,
                                input daData,output pdePrecoConv).
            run "cdp/cd0812.p" (input cotacao-item.mo-codigo,
                                input piMoedaG,input pdeValorIPI,
                                input daData,output pdeValorIPI).
            run "cdp/cd0812.p" (input cotacao-item.mo-codigo,
                                input piMoedaG,input pdePrecoUnit,
                                input daData,output pdePrecoUnit).
        end.
        
        if pdePrecoConv = ? then assign pdePrecoConv = 0.
        if pdeValorIPI = ? then assign pdeValorIPI = 0.
        if pdePrecoUnit = ? then assign pdePrecoUnit = 0.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaCalcPrecoMatCotacaoItem DBOProgram 
PROCEDURE retornaCalcPrecoMatCotacaoItem :
/*------------------------------------------------------------------------------
  Purpose:  C†lculo do Preco do Material sem Taxa Financeira   
  Parameters:        
             ipar1 : prCotacaoItem : Rowid da tabela Cotacao-Item
             ipar2 : piCodCondPag  : C´digo da condiØ o de pagto da cotacao item
             ipar3 : pdeValorTaxa  : Valor da taxa da cotacao item     
             ipar4 : pdePrecoUnit  : PreØo unitòrio da cotacao item   
             ipar5 : pdePrecoMat   : Preco do material da cotacao item com taxa   
             opar6 : pdePrecoMat   : Preco do Material sem Taxa Financeira
             opar7 : pcMarca       : Seleciona cotacao com tentativa de aprovaØ o
  Notes:       
------------------------------------------------------------------------------*/

        def input  param prCotacaoItem as rowid no-undo.
        def input  param piCodCondPag  as int   no-undo.
        def input  param pdeValorTaxa  as dec   no-undo.
        def input  param piNrDiasTaxa  as int   no-undo.
        def input  param pdePrecoUnit  as dec   no-undo.
        def output param pdePrecoMat   as dec   no-undo.
        def output param pcMarca       as char  no-undo.

        assign pdePrecoMat = pdePrecoUnit  .
        
        run ccp/cc9020.p (input  no,
                          input  piCodCondPag,
                          input  pdeValorTaxa,
                          input  piNrDiasTaxa,
                          input  pdePrecoMat,
                          output pdePrecoMat).
        
        for first cotacao-item fields(log-1) where 
             rowid(cotacao-item) = prCotacaoItem 
             no-lock: end.
        if avail cotacao-item and cotacao-item.log-1 = yes then
          assign pcMarca = "*".
        else
          assign pcMarca = "".                 
          
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaPrecoConvertidoCotacao DBOProgram 
PROCEDURE retornaPrecoConvertidoCotacao :
/*------------------------------------------------------------------------------
  Purpose:    Converte preáo da Cotacao de acordo com a moeda parametrizada.
              Converte o preáo da Cotacao.
  Parameters: 
              ipar1  : prChaveOrdem         : Rowid da tabela Ordem-compra
              ipar2  : prChaveCotacao       : Rowid da tabela Cotacao
              ipar3  : piMoedaG             : Moeda a ser convertido o preáo 
              ipar4  : pdataConvG           : Data da convers∆o
              ipar5  : plConvG              : Convers∆o (cotaá∆o ou atual)
              opar6  : pdePrecoConv         : Preco convertido 
              opar7  : pdePrecoFornecConv   : Preco fornecedor convertido
              opar8  : pdePrecoMat          : Preco material 
              opar9  : pdePrecoMatConv      : Preco material convertido
              opar10 : pdePrecoTotalCot     : Preco total da cotaá∆o
              opar11 : pdePrecoUnit         : Valor do preco unit†rio
              opar12 : pdeUnitConv          : Preco unit†rio convertido
              opar13 : pdeValorConv         : Valor IPI convertido
              opar14 : pdeValorIPI          : Valor IPI  
  Notes:       
------------------------------------------------------------------------------*/

   def input  parameter prChaveOrdem       as rowid.
   def input  parameter prChaveCotacao     as rowid. 
   def input  parameter piMoedaG           as int     no-undo.
   def input  parameter pdataConvG         as date    no-undo. 
   def input  parameter plConvG            as logical no-undo. 
   def output parameter pdePrecoConv       as decimal no-undo.
   def output parameter pdePrecoFornecConv as decimal no-undo.
   def output parameter pdePrecoMat        as decimal no-undo.
   def output parameter pdePrecoMatConv   as decimal no-undo.
   def output parameter pdePrecoTotalCot   as decimal no-undo.
   def output parameter pdePrecoUnit       as decimal no-undo.
   def output parameter pdeUnitConv        as decimal no-undo.
   def output parameter pdeValorConv       as decimal no-undo.
   def output parameter pdeValorIPI        as decimal no-undo.

   assign iMoedaG = piMoedaG
          daConvG = pdataConvG
          lConvG  = plConvG.

   for first ordem-compra fields(numero-ordem qt-solic) where 
        rowid(ordem-compra) = prChaveOrdem 
        no-lock: end.

   for first cotacao-item fields (pre-unit-for aliquota-ipi mo-codigo    
                                  perc-descto  data-cotacao preco-unit
                                  cod-cond-pag valor-taxa   nr-dias-taxa
                                  preco-fornec) where
        rowid(cotacao-item) = prChaveCotacao
        no-lock: end.
   
   assign pdePrecoTotalCot = 0.

   if avail param-compra then do:
     if param-compra.ipi-sobre-preco = 1 
        then assign lPrecoBruto = yes.
     else assign lPrecoBruto = no.
   end. 
   else 
     assign lPrecoBruto = no.
 
   if lPrecoBruto = no then do:
      assign pdeValorIPI = (cotacao-item.pre-unit-for * cotacao-item.aliquota-ipi) /
                              (100 + cotacao-item.aliquota-ipi).
   end.
   else do:
      if cotacao-item.perc-descto > 0 then 
         assign deValorOrig = (cotacao-item.pre-unit-for * 100) / 
                              (100 - cotacao-item.perc-descto).
      else                                             
         assign deValorOrig = cotacao-item.pre-unit-for.
 
         assign pdeValorIPI = (deValorOrig * cotacao-item.pre-unit-for) / 
                                 (100 + cotacao-item.aliquota-ipi).
   
   end.

   assign pdePrecoMat = cotacao-item.preco-unit.
 
   run ccp/cc9020.p (input  no,
                     input  cotacao-item.cod-cond-pag,
                     input  cotacao-item.valor-taxa,
                     input  cotacao-item.nr-dias-taxa,
                     input  pdePrecoMat,
                     output pdePrecoMat).

  

   if cotacao-item.pre-unit-for >= pdeValorIPI then
       assign pdePrecoUnit = cotacao-item.pre-unit-for - pdeValorIPI.

   if cotacao-item.mo-codigo = iMoedaG then do:
      assign pdePrecoConv       = pdePrecoUnit
             pdePrecoFornecConv = cotacao-item.preco-fornec
             pdePrecoMatConv   = pdePrecoMat
             pdePrecoTotalCot   = (cotacao-item.preco-unit * ordem-compra.qt-solic)
             pdeUnitConv        = cotacao-item.pre-unit-for
             pdeValorConv       = pdeValorIPI.
   end.
   else do:
      run cdp/cd0812.p (input  cotacao-item.mo-codigo,
                        input  iMoedaG, 
                        input  pdePrecoUnit,
                        input  daConvG, 
                        output pdePrecoConv).
      run cdp/cd0812.p (input  cotacao-item.mo-codigo,
                        input  iMoedaG,  
                        input  cotacao-item.preco-fornec,
                        input  daConvG, 
                        output pdePrecoFornecConv).
      run cdp/cd0812.p (input  cotacao-item.mo-codigo,
                        input  iMoedaG, 
                        input  cotacao-item.preco-unit,
                        input  daConvG, 
                        output pdePrecoTotalCot).
      assign pdePrecoTotalCot = (pdePrecoTotalCot * ordem-compra.qt-solic).
      run cdp/cd0812.p (input  cotacao-item.mo-codigo,
                        input  iMoedaG, 
                        input  cotacao-item.pre-unit-for, 
                        input  daConvG, 
                        output pdeUnitConv).
      run cdp/cd0812.p (input  cotacao-item.mo-codigo, 
                        input  iMoedaG, 
                        input  pdeValorIPI, 
                        input  daConvG, 
                        output pdeValorConv).
      run cdp/cd0812.p (input  cotacao-item.mo-codigo,
                        input  iMoedaG, 
                        input  pdePrecoMat, 
                        input  daConvG, 
                        output pdePrecoMatConv).
   end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

