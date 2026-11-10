/********************************* Padr∆o *************************************/
{utp/ut-liter.i RELAT‡RIO_GERENCIAL_DE_IMPORTAÄ«O *}
assign c-titulo-relat = return-value.
{utp/ut-liter.i IMPORTAÄ«O MIM}

/********************************* Local **************************************/
/* Traduá∆o f-relat */
DEFINE VARIABLE c-label-titulo  AS CHARACTER FORMAT "x(19)":U NO-UNDO.
DEFINE VARIABLE c-lbl-destino   AS CHARACTER FORMAT "x(7)":U  NO-UNDO.

{utp/ut-liter.i DOCUMENTO_IMPRESSO *}
assign c-label-titulo = return-value.
{utp/ut-liter.i Destino: *}
assign c-lbl-destino = return-value.

/* Traduá∆o f-selecao */ 
DEFINE VARIABLE c-titulo-s      AS CHARACTER FORMAT "x(10)":U NO-UNDO.
DEFINE VARIABLE c-lbl-dados-imp AS CHARACTER FORMAT "x(30)":U NO-UNDO.
DEFINE VARIABLE c-lbl-dados-emb AS CHARACTER FORMAT "x(30)":U NO-UNDO.
DEFINE VARIABLE c-lbl-dados-ped AS CHARACTER FORMAT "x(30)":U NO-UNDO.

DEFINE VARIABLE c-lbl-estabel   AS CHARACTER FORMAT "x(16)":U NO-UNDO.
DEFINE VARIABLE c-lbl-estab-emb AS CHARACTER FORMAT "x(16)":U NO-UNDO.
DEFINE VARIABLE c-lbl-estab-ped AS CHARACTER FORMAT "x(16)":U NO-UNDO.
DEFINE VARIABLE c-lbl-proc-imp  AS CHARACTER FORMAT "x(16)":U NO-UNDO.
DEFINE VARIABLE c-lbl-emit-proc AS CHARACTER FORMAT "x(16)":U NO-UNDO.
DEFINE VARIABLE c-lbl-dt-emis   AS CHARACTER FORMAT "x(16)":U NO-UNDO.

DEFINE VARIABLE c-lbl-embarq    AS CHARACTER FORMAT "x(16)":U NO-UNDO.
DEFINE VARIABLE c-lbl-di-sis    AS CHARACTER FORMAT "x(16)":U NO-UNDO.
DEFINE VARIABLE c-lbl-di-ems    AS CHARACTER FORMAT "x(16)":U NO-UNDO.
DEFINE VARIABLE c-lbl-dt-di     AS CHARACTER FORMAT "x(16)":U NO-UNDO.

DEFINE VARIABLE c-lbl-pedido    AS CHARACTER FORMAT "x(16)":U NO-UNDO.
DEFINE VARIABLE c-lbl-ordem     AS CHARACTER FORMAT "x(16)":U NO-UNDO.
DEFINE VARIABLE c-lbl-emit-ped  AS CHARACTER FORMAT "x(16)":U NO-UNDO.
DEFINE VARIABLE c-lbl-dt-ped    AS CHARACTER FORMAT "x(16)":U NO-UNDO.

{utp/ut-liter.i SELEÄ«O: *}
assign c-titulo-s = return-value.
{utp/ut-liter.i Dados_Processo_Imp *}
assign c-lbl-dados-imp = return-value.
{utp/ut-liter.i Dados_Embarque/DI *}
assign c-lbl-dados-emb = return-value.
{utp/ut-liter.i Dados_Pedido/Ordem_Compra *}
assign c-lbl-dados-ped = return-value.

{utp/ut-liter.i "Estabel:" *}                   
assign c-lbl-estabel = return-value
       c-lbl-estab-emb = c-lbl-estabel
       c-lbl-estab-ped = c-lbl-estabel.   
         
{utp/ut-liter.i Processo_Imp: *}                  
assign c-lbl-proc-imp  = return-value.
{utp/ut-liter.i Fornecedor: *}                  
assign c-lbl-emit-proc = return-value.
{utp/ut-liter.i Data_Emiss∆o: *}                  
assign c-lbl-dt-emis  = return-value.
{utp/ut-liter.i Embarque: *}              
assign c-lbl-embarq = return-value. 
{utp/ut-liter.i DI_Siscomex: *}              
assign c-lbl-di-sis = return-value. 
{utp/ut-liter.i DI_EMS: *}              
assign c-lbl-di-ems = return-value. 
{utp/ut-liter.i Data_DI: *}              
assign c-lbl-dt-di = return-value. 
{utp/ut-liter.i Pedido: *}              
assign c-lbl-pedido = return-value. 
{utp/ut-liter.i Ordem_Compra: *}              
assign c-lbl-ordem = return-value. 
{utp/ut-liter.i Fornecedor: *}                  
assign c-lbl-emit-ped = return-value.
{utp/ut-liter.i Data_Pedido: *}              
assign c-lbl-dt-ped = return-value. 

/* Traduá∆o f-parametros */
DEFINE VARIABLE c-titulo-p         AS CHARACTER FORMAT "x(10)" NO-UNDO.
DEFINE VARIABLE c-lbl-detalhar     AS CHARACTER FORMAT "x(10)" NO-UNDO.

DEFINE VARIABLE c-lbl-pedcomp      AS CHARACTER FORMAT "x(25)" NO-UNDO.
DEFINE VARIABLE c-lbl-procimp      AS CHARACTER FORMAT "x(25)" NO-UNDO.
DEFINE VARIABLE c-lbl-fornec       AS CHARACTER FORMAT "x(25)" NO-UNDO.
DEFINE VARIABLE c-lbl-ordcomp      AS CHARACTER FORMAT "x(25)" NO-UNDO.
DEFINE VARIABLE c-lbl-parcela      AS CHARACTER FORMAT "x(25)" NO-UNDO.
DEFINE VARIABLE c-lbl-item         AS CHARACTER FORMAT "x(25)" NO-UNDO.
DEFINE VARIABLE c-lbl-declimp      AS CHARACTER FORMAT "x(25)" NO-UNDO.
DEFINE VARIABLE c-lbl-adicdi       AS CHARACTER FORMAT "x(25)" NO-UNDO.
DEFINE VARIABLE c-lbl-acompdi      AS CHARACTER FORMAT "x(25)" NO-UNDO.
DEFINE VARIABLE c-lbl-embimp       AS CHARACTER FORMAT "x(25)" NO-UNDO.
DEFINE VARIABLE c-lbl-acompemb     AS CHARACTER FORMAT "x(25)" NO-UNDO.
DEFINE VARIABLE c-lbl-docto        AS CHARACTER FORMAT "x(25)" NO-UNDO.
DEFINE VARIABLE c-lbl-itdocto      AS CHARACTER FORMAT "x(25)" NO-UNDO.
DEFINE VARIABLE c-lbl-despitemdoc  AS CHARACTER FORMAT "x(25)" NO-UNDO.
DEFINE VARIABLE c-lbl-movestoq     AS CHARACTER FORMAT "x(25)" NO-UNDO.
DEFINE VARIABLE c-lbl-duplic       AS CHARACTER FORMAT "x(40)" NO-UNDO.
DEFINE VARIABLE c-lbl-despimp      AS CHARACTER FORMAT "x(25)" NO-UNDO.
DEFINE VARIABLE c-lbl-dupdesp      AS CHARACTER FORMAT "x(25)" NO-UNDO.
DEFINE VARIABLE c-lbl-nfcompl      AS CHARACTER FORMAT "x(25)" NO-UNDO.
        
DEFINE VARIABLE c-lbl-envia-doct   AS CHARACTER FORMAT "x(23)" NO-UNDO. 
DEFINE VARIABLE c-lbl-destinatario AS CHARACTER FORMAT "x(21)" NO-UNDO. 
DEFINE VARIABLE c-lbl-utiliza-lay  AS CHARACTER FORMAT "x(33)" NO-UNDO. 
DEFINE VARIABLE c-lbl-layout-p     AS CHARACTER FORMAT "x(14)" NO-UNDO.
DEFINE VARIABLE c-lbl-sobrepor     AS CHARACTER FORMAT "x(32)" NO-UNDO. 
DEFINE VARIABLE c-lbl-destino-text AS CHARACTER FORMAT "x(8)"  NO-UNDO.
DEFINE VARIABLE c-lbl-proces-relac AS CHARACTER FORMAT "x(23)" NO-UNDO.
 
{utp/ut-liter.i PAR∂METROS: *}
assign c-titulo-p = return-value.
{utp/ut-liter.i Detalhar *}
assign c-lbl-detalhar = return-value.

{utp/ut-liter.i Pedido_de_Compra: *}                       
assign c-lbl-pedcomp  = return-value.
{utp/ut-liter.i Processo_de_Importaá∆o: *}                       
assign c-lbl-procimp  = return-value.
{utp/ut-liter.i Fornecedor: *}                       
assign c-lbl-fornec   = return-value.
{utp/ut-liter.i Ordem_de_Compra: *}                       
assign c-lbl-ordcomp  = return-value.
{utp/ut-liter.i Parcelas: *}                       
assign c-lbl-parcela  = return-value.
{utp/ut-liter.i Item: *}                       
assign c-lbl-item     = return-value.
{utp/ut-liter.i Declaraá∆o_de_Importaá∆o: *}                       
assign c-lbl-declimp  = return-value.
{utp/ut-liter.i Adiá‰es_da_DI: *}                       
assign c-lbl-adicdi   = return-value.
{utp/ut-liter.i Acompanhamento_da_DI: *}                       
assign c-lbl-acompdi  = return-value.
{utp/ut-liter.i Embarque_de_Importaá∆o: *}                       
assign c-lbl-embimp   = return-value.
{utp/ut-liter.i Acompanhamento_Embarque: *}                       
assign c-lbl-acompemb = return-value.
{utp/ut-liter.i Documentos: *}                       
assign c-lbl-docto    = return-value.
{utp/ut-liter.i Itens_do_Documento: *}                       
assign c-lbl-itdocto  = return-value.
{utp/ut-liter.i Despesas_Item_Documento: *}                       
assign c-lbl-despitemdoc = return-value.
{utp/ut-liter.i Estoque: *}                       
assign c-lbl-movestoq = return-value.
{utp/ut-liter.i Duplicatas_do_Fornecedor_da_Mercadoria: *}                       
assign c-lbl-duplic   = return-value.
{utp/ut-liter.i Despesas_de_Importaá∆o: *}                       
assign c-lbl-despimp  = return-value.
{utp/ut-liter.i Duplicatas_de_Despesas: *}                       
assign c-lbl-dupdesp  = return-value.
{utp/ut-liter.i Nota_Fiscal_Complementar: *}                       
assign c-lbl-nfcompl  = return-value.

{utp/ut-liter.i Envia_Docto_via_E-mail: *} 
assign c-lbl-envia-doct = return-value. 
{utp/ut-liter.i Destinat†rios_E-mail: *} 
assign c-lbl-destinatario = return-value. 
{utp/ut-liter.i Utiliza_Layout_Padr∆o_do_Usu†rio: *} 
assign c-lbl-utiliza-lay = return-value. 
{utp/ut-liter.i Layout_Padr∆o: *} 
assign c-lbl-layout-p = return-value. 
{utp/ut-liter.i Sobrepor_arquivos_j†_existentes: *} 
assign c-lbl-sobrepor   = return-value. 
{utp/ut-liter.i Destino: *} 
assign c-lbl-destino-text = return-value. 

/* Traduá∆o f-impressao */                               
DEFINE VARIABLE c-titulo-imp      AS CHARACTER FORMAT "x(9)"  NO-UNDO.
DEFINE VARIABLE c-lbl-usuario     AS CHARACTER FORMAT "x(8)" NO-UNDO.
DEFINE VARIABLE c-lbl-destino-txt AS CHARACTER FORMAT "x(8)" NO-UNDO.

{utp/ut-liter.i IMPRESS«O: *}
assign c-titulo-imp = return-value.
{utp/ut-liter.i Usu†rio: *} 
assign c-lbl-usuario  = return-value.
{utp/ut-liter.i Destino: *} 
assign c-lbl-destino-txt  = return-value.
