/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0001A 2.00.01.017 } /*** "010117" 27/08/2024 08:50:25 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc0001a MBC}
&ENDIF

/*******************************************************************************
**
**   Programa..: bc0001a.p
**
**   Vers∆o....: 02.00.00 - Datasul
**
**   Objetivo..: Programa de Inicializaá∆o do COLETA DE DADOS EMS 2.0x
**
*********************************************************************************/

{include/i-lgcode.i}
{cdp/cdcfgint.i}

DEFINE TEMP-TABLE tt-transacoes-padrao NO-UNDO
            FIELD cd-trans        LIKE bc-tipo-trans.cd-trans         /* Codigo Transacao */
            FIELD descricao-por   LIKE bc-tipo-trans.descricao        /* Descricao*/
            FIELD descricao-eng   LIKE bc-tipo-trans.descricao        /* Descricao*/
            FIELD descricao-spa   LIKE bc-tipo-trans.descricao        /* Descricao*/
            FIELD api-atualizacao LIKE bc-tipo-trans.api-atualizacao  /* Programa Efetivacao */
            FIELD prog-altera     LIKE bc-tipo-trans.prog-altera      /* Programa Alteracao Transacao */
            FIELD prog-etiq       LIKE bc-tipo-trans.prog-etiq        /* Programa Impressao Etiqueta */
            FIELD prog-import     LIKE bc-tipo-trans.prog-import      /* Programa Importacao */
            FIELD prog-criacao    LIKE bc-tipo-trans.prog-criacao     /* Programa Criacao Transacao */
            FIELD prog-leitura    LIKE bc-tipo-trans.prog-leitura     /* Programa Leitura */
            FIELD p-prog-char     LIKE bc-prog-trans.cod_prog_dtsul.  /**/

DEFINE VARIABLE i-cont  AS INTEGER NO-UNDO.
DEFINE VARIABLE h-acomp AS HANDLE  NO-UNDO.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
{utp/ut-liter.i Inicializaá∆o_do_Coleta_de_Dados *}
RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE ).

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "Contagem"
        tt-transacoes-padrao.descricao-por   = "Contagem C°clica"
        tt-transacoes-padrao.descricao-eng   = "Cyclic Count"
        tt-transacoes-padrao.descricao-spa   = "Conteo C°clico"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9002c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9002a.p"
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = "bcp/bc9002b.p"
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9002.p"
        tt-transacoes-padrao.p-prog-char     = "bc9002".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "Etiq-avu"
        tt-transacoes-padrao.descricao-por   = "Etiquetas Avulsas"
        tt-transacoes-padrao.descricao-eng   = "Separate Slips"
        tt-transacoes-padrao.descricao-spa   = "Etiquetas Separadas"
        tt-transacoes-padrao.api-atualizacao = ""
        tt-transacoes-padrao.prog-altera     = "bcp/bc0803.w"
        tt-transacoes-padrao.prog-etiq       = "bcp/bcapi002.p"
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = "bcp/bc0801.w"
        tt-transacoes-padrao.prog-leitura    = "bcp/bc0801.w"
        tt-transacoes-padrao.p-prog-char     = "bc0801".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "Etiq-rec"
        tt-transacoes-padrao.descricao-por   = "Etiquetas do Recebimento"
        tt-transacoes-padrao.descricao-eng   = "Reciving Slips"
        tt-transacoes-padrao.descricao-spa   = "Etiquetas de Recebimiento"
        tt-transacoes-padrao.api-atualizacao = ""
        tt-transacoes-padrao.prog-altera     = "bcp/bc0803.w"
        tt-transacoes-padrao.prog-etiq       = "bcp/bcapi002.p"
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = "rep/re0801.p"
        tt-transacoes-padrao.prog-leitura    = ""
        tt-transacoes-padrao.p-prog-char     = "re1001".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "Etiq-fat"
        tt-transacoes-padrao.descricao-por   = "Etiquetas do Faturamento"
        tt-transacoes-padrao.descricao-eng   = "Account Slips"
        tt-transacoes-padrao.descricao-spa   = "Etiquetas de Facturacion"
        tt-transacoes-padrao.api-atualizacao = ""
        tt-transacoes-padrao.prog-altera     = "bcp/bc0803.w"
        tt-transacoes-padrao.prog-etiq       = "bcp/bcapi002.p"
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = "ftp/ft0513cl.p"
        tt-transacoes-padrao.prog-leitura    = ""
        tt-transacoes-padrao.p-prog-char     = "ft0513".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "Rep-item"
        tt-transacoes-padrao.descricao-por   = "Reporte por Item (Repetitivo)"
        tt-transacoes-padrao.descricao-eng   = "Item Report (Repetitive)"
        tt-transacoes-padrao.descricao-spa   = "Reporte por Item (Repetitivo)"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9006c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9006a.p"
        tt-transacoes-padrao.prog-etiq       = "bcp/bcapi002.p"
        tt-transacoes-padrao.prog-import     = "bcp/bc9006b.p"
        tt-transacoes-padrao.prog-criacao    = "cpp/cp0301cl.p"
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9006.p"
        tt-transacoes-padrao.p-prog-char     = "bc9006".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "Reporte"
        tt-transacoes-padrao.descricao-por   = "Reporte de Produá∆o"
        tt-transacoes-padrao.descricao-eng   = "Production Report"
        tt-transacoes-padrao.descricao-spa   = "Reporte de Producci¢n"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9003c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9003a.p"
        tt-transacoes-padrao.prog-etiq       = "bcp/bcapi002.p"
        tt-transacoes-padrao.prog-import     = "bcp/bc9003b.p"
        tt-transacoes-padrao.prog-criacao    = "cpp/cp0301cl.p"
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9003.p"
        tt-transacoes-padrao.p-prog-char     = "bc9003".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "Req-MCP"
        tt-transacoes-padrao.descricao-por   = "Requisiá∆o de Materiais"
        tt-transacoes-padrao.descricao-eng   = "Materials Requisition"
        tt-transacoes-padrao.descricao-spa   = "Solicitaci¢n de Materiales"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9004c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9004a.p"
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = "bcp/bc9004b.p"
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9004.p"
        tt-transacoes-padrao.p-prog-char     = "bc9004".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "TransfMa"
        tt-transacoes-padrao.descricao-por   = "Transferància Materiais - V2"
        tt-transacoes-padrao.descricao-eng   = "Materials Transference - V2"
        tt-transacoes-padrao.descricao-spa   = "Transferencia Materiales - V2"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9005c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9005a.p"
        tt-transacoes-padrao.prog-etiq       = "bcp/bcapi002.p"
        tt-transacoes-padrao.prog-import     = "bcp/bc9005b.p"
        tt-transacoes-padrao.prog-criacao    = "cep/ce0206a.p "
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9005.p"
        tt-transacoes-padrao.p-prog-char     = "bc9005".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "Embarque"
        tt-transacoes-padrao.descricao-por   = "Aviso de Embarque"
        tt-transacoes-padrao.descricao-eng   = "Embark Advise"
        tt-transacoes-padrao.descricao-spa   = "Sapiente de Embarcarse"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9008c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9008a.p"
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = "bcp/bc9008b.p"
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9008.p"
        tt-transacoes-padrao.p-prog-char     = "bc9008".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "Etq-PrdL"
        tt-transacoes-padrao.descricao-por   = "Etiquetas Ordem Prod.Listagem"
        tt-transacoes-padrao.descricao-eng   = "Report Production Order Label"
        tt-transacoes-padrao.descricao-spa   = "Etiqueta Ordem Prod.Listagem"
        tt-transacoes-padrao.api-atualizacao = ""
        tt-transacoes-padrao.prog-altera     = "bcp/bc0803.w"
        tt-transacoes-padrao.prog-etiq       = "bcp/bcapi002.p"
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = "bcp/bc0305cp.p"
        tt-transacoes-padrao.prog-leitura    = ""
        tt-transacoes-padrao.p-prog-char     = "cp0305".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "Etq-PrdS"
        tt-transacoes-padrao.descricao-por   = "Etiquetas Ordem Prod.Sumarizad"
        tt-transacoes-padrao.descricao-eng   = "Summary Production Order Label"
        tt-transacoes-padrao.descricao-spa   = "Etiq Ordem Prod. Sintetizaci¢n"
        tt-transacoes-padrao.api-atualizacao = ""
        tt-transacoes-padrao.prog-altera     = "bcp/bc0803.w"
        tt-transacoes-padrao.prog-etiq       = "bcp/bcapi002.p"
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = "bcp/bc0305cp.p"
        tt-transacoes-padrao.prog-leitura    = ""
        tt-transacoes-padrao.p-prog-char     = "cp0304".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "Codigo2D"
        tt-transacoes-padrao.descricao-por   = "C¢digo 2D"
        tt-transacoes-padrao.descricao-eng   = "Code 2D"
        tt-transacoes-padrao.descricao-spa   = "C¢digo 2D"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc0110c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc0110a.p"
        tt-transacoes-padrao.prog-etiq       = "bcp/bcapi018.p"
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = "ftp/ft0513bd.p"
        tt-transacoes-padrao.prog-leitura    = "bcp/bc0110.p"
        tt-transacoes-padrao.p-prog-char     = "bc0110".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "Req-OM"
        tt-transacoes-padrao.descricao-por   = "Requisiá∆o Ordem de Manutená∆o"
        tt-transacoes-padrao.descricao-eng   = "Maintenance Order Requisition"
        tt-transacoes-padrao.descricao-spa   = "Solicit. Ordem Mantenimiento"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9011c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9011a.p"
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9011.p"
        tt-transacoes-padrao.p-prog-char     = "bc9011".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMEnt001"
        tt-transacoes-padrao.descricao-por   = "Entrada Carga WMS"
        tt-transacoes-padrao.descricao-eng   = "WMS Load Receipt"
        tt-transacoes-padrao.descricao-spa   = "Entrada Carga WMS"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9015c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9015a.p"
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9015.p"
        tt-transacoes-padrao.p-prog-char     = "bc9015".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMEnt002"
        tt-transacoes-padrao.descricao-por   = "Conferància WMS"
        tt-transacoes-padrao.descricao-eng   = "WMS Check"
        tt-transacoes-padrao.descricao-spa   = "Conferencia WMS"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9016c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9016a.p"
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9016.p"
        tt-transacoes-padrao.p-prog-char     = "bc9016".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMEnt003"
        tt-transacoes-padrao.descricao-por   = "Armazenamento WMS"
        tt-transacoes-padrao.descricao-eng   = "WMS Storage"
        tt-transacoes-padrao.descricao-spa   = "Almacenamiento WMS"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9017c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9017a.p"
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9017.p"
        tt-transacoes-padrao.p-prog-char     = "bc9017".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMSai001"
        tt-transacoes-padrao.descricao-por   = "Picking WMS"
        tt-transacoes-padrao.descricao-eng   = "WMS Picking"
        tt-transacoes-padrao.descricao-spa   = "Picking WMS"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9018c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9018a.p"
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9018.p"
        tt-transacoes-padrao.p-prog-char     = "bc9018".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMSai002"
        tt-transacoes-padrao.descricao-por   = "Packing WMS"
        tt-transacoes-padrao.descricao-eng   = "WMS Packing"
        tt-transacoes-padrao.descricao-spa   = "Packing WMS"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9019c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9019a.p"
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9019.p"
        tt-transacoes-padrao.p-prog-char     = "bc9019".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMSai003"
        tt-transacoes-padrao.descricao-por   = "Ressuprimento WMS"
        tt-transacoes-padrao.descricao-eng   = "WMS Replenishment"
        tt-transacoes-padrao.descricao-spa   = "Reaprovisionamento WMS"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9020c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9020a.p"
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9020.p"
        tt-transacoes-padrao.p-prog-char     = "bc9020".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMSai004"
        tt-transacoes-padrao.descricao-por   = "Devoluá∆o Picking WMS"
        tt-transacoes-padrao.descricao-eng   = "WMS Picking Return"
        tt-transacoes-padrao.descricao-spa   = "Devoluci¢n Picking WMS"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9021c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9021a.p"
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9021.p"
        tt-transacoes-padrao.p-prog-char     = "bc9021".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMSai005"
        tt-transacoes-padrao.descricao-por   = "Packing List WMS"
        tt-transacoes-padrao.descricao-eng   = "WMS Packing List"
        tt-transacoes-padrao.descricao-spa   = "Remito WMS"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9022c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9022a.p"
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9022.p"
        tt-transacoes-padrao.p-prog-char     = "bc9022".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMOut001"
        tt-transacoes-padrao.descricao-por   = "Transf Endereáo WMS (Agrup)"
        tt-transacoes-padrao.descricao-eng   = "WMS Transfer Address(Grouping)"
        tt-transacoes-padrao.descricao-spa   = "Transf Endereáo WMS (Agrup)"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9025c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9025a.p"
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9025.p"
        tt-transacoes-padrao.p-prog-char     = "bc9025".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMOut002"
        tt-transacoes-padrao.descricao-por   = "Consulta Endereáo WMS"
        tt-transacoes-padrao.descricao-eng   = "WMS Bin Inquiry"
        tt-transacoes-padrao.descricao-spa   = "Consulta Direcci¢n WMS"
        tt-transacoes-padrao.api-atualizacao = ""
        tt-transacoes-padrao.prog-altera     = ""
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9023.p"
        tt-transacoes-padrao.p-prog-char     = "bc9023".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMOut003"
        tt-transacoes-padrao.descricao-por   = "Invent†rio WMS"
        tt-transacoes-padrao.descricao-eng   = "WMS Count"
        tt-transacoes-padrao.descricao-spa   = "Inventario WMS"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9024c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9024a.p"
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9024.p"
        tt-transacoes-padrao.p-prog-char     = "bc9024".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMOut004"
        tt-transacoes-padrao.descricao-por   = "Etiquetas de embalagem WMS"
        tt-transacoes-padrao.descricao-eng   = "WMS Labels of packing"
        tt-transacoes-padrao.descricao-spa   = "Etiquetas de embalaje WMS"
        tt-transacoes-padrao.api-atualizacao = ""
        tt-transacoes-padrao.prog-altera     = "bcp/bc0803.w"
        tt-transacoes-padrao.prog-etiq       = "bcp/bcapi002.p"
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = "bcp/bc9026.w"
        tt-transacoes-padrao.prog-leitura    = "bcp/bc0801.w"
        tt-transacoes-padrao.p-prog-char     = "".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMOut006"
        tt-transacoes-padrao.descricao-por   = "Montagem de pallet WMS"
        tt-transacoes-padrao.descricao-eng   = "WMS Assembly of pallet"
        tt-transacoes-padrao.descricao-spa   = "Montaje de pallet WMS"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9027c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9027a.p"
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9027.p"
        tt-transacoes-padrao.p-prog-char     = "bc9027".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMOut013"
        tt-transacoes-padrao.descricao-por   = "Despaletizaá∆o WMS"
        tt-transacoes-padrao.descricao-eng   = "WMS Depalletisation"
        tt-transacoes-padrao.descricao-spa   = "Despaletizaci¢n WMS"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9037c.p"
        tt-transacoes-padrao.prog-altera     = ""
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9037.p"
        tt-transacoes-padrao.p-prog-char     = "bc9037".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMOut014"
        tt-transacoes-padrao.descricao-por   = "Etiquetas Avulsas"
        tt-transacoes-padrao.descricao-eng   = "Separate Slips"
        tt-transacoes-padrao.descricao-spa   = "Etiquetas Separadas"
        tt-transacoes-padrao.api-atualizacao = ""
        tt-transacoes-padrao.prog-altera     = ""
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = ""
        tt-transacoes-padrao.p-prog-char     = "".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMOut005"
        tt-transacoes-padrao.descricao-por   = "Transf entre Depositos WMS"
        tt-transacoes-padrao.descricao-eng   = "WMS Transf among Warehouses"
        tt-transacoes-padrao.descricao-spa   = "Transf entre Almacenes WMS"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9030c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9030a.p"
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9030.p"
        tt-transacoes-padrao.p-prog-char     = "bc9030".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMEnt004"
        tt-transacoes-padrao.descricao-por   = "Armazenamento por serial WMS"
        tt-transacoes-padrao.descricao-eng   = "WMS Storage by serial"
        tt-transacoes-padrao.descricao-spa   = "Almacenamiento por Serial WMS"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9029c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9029a.p"
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9029.p"
        tt-transacoes-padrao.p-prog-char     = "bc9029".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMEnt005"
        tt-transacoes-padrao.descricao-por   = "Reporte por serial WMS"
        tt-transacoes-padrao.descricao-eng   = "WMS Report  by serial"
        tt-transacoes-padrao.descricao-spa   = "Reporte por Serial WMS"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9028c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9028a.p"
        tt-transacoes-padrao.prog-etiq       = "bcp/bcapi002.p"
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = "cpp/cp0301cl.p"
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9028.p"
        tt-transacoes-padrao.p-prog-char     = "bc9028".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMOut008"
        tt-transacoes-padrao.descricao-por   = "Consulta Local WMS"
        tt-transacoes-padrao.descricao-eng   = "WMS Local Consultation"
        tt-transacoes-padrao.descricao-spa   = "Consulta Local WMS"
        tt-transacoes-padrao.api-atualizacao = ""
        tt-transacoes-padrao.prog-altera     = ""
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9039.p"
        tt-transacoes-padrao.p-prog-char     = "bc9039".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMSai009"
        tt-transacoes-padrao.descricao-por   = "Picking / Packing WMS"
        tt-transacoes-padrao.descricao-eng   = "WMS Picking / Packing"
        tt-transacoes-padrao.descricao-spa   = "Picking / Packing WMS"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9033c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9033a.p"
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9033.p"
        tt-transacoes-padrao.p-prog-char     = "bc9033".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "ENV-CLP"
        tt-transacoes-padrao.descricao-por   = "Solicitar Produá∆o OPC"
        tt-transacoes-padrao.descricao-eng   = "OPC Production Request"
        tt-transacoes-padrao.descricao-spa   = "Solicitaci¢n Producci¢n OPC"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9036c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9031a.w"
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = ""
        tt-transacoes-padrao.p-prog-char     = "".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "REP-CLP1"
        tt-transacoes-padrao.descricao-por   = "Reporte Produá∆o OPC"
        tt-transacoes-padrao.descricao-eng   = "OPC Production Report"
        tt-transacoes-padrao.descricao-spa   = "Reporte de Producci¢n OPC"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9031c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9031a.w"
        tt-transacoes-padrao.prog-etiq       = "bcp/bcapi002.p"
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = "cpp/cp0301cl.p"
        tt-transacoes-padrao.prog-leitura    = ""
        tt-transacoes-padrao.p-prog-char     = "bc9031".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "REP-CLP2"
        tt-transacoes-padrao.descricao-por   = "Reporte Produá∆o OPC - Item"
        tt-transacoes-padrao.descricao-eng   = "OPC Production Report - Item"
        tt-transacoes-padrao.descricao-spa   = "Reporte de Producci¢n OPC - Item"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9032c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9031a.w"
        tt-transacoes-padrao.prog-etiq       = "bcp/bcapi002.p"
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = "cpp/cp0301cl.p"
        tt-transacoes-padrao.prog-leitura    = ""
        tt-transacoes-padrao.p-prog-char     = "bc9032".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "REP-CLP3"
        tt-transacoes-padrao.descricao-por   = "Reporte Ordem de Produá∆o OPC"
        tt-transacoes-padrao.descricao-eng   = "OPC Order Production Report"
        tt-transacoes-padrao.descricao-spa   = "Reporte Ordem de Producci¢n OPC"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9035c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9031a.w"
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = ""
        tt-transacoes-padrao.p-prog-char     = "bc9035".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "PAR-CLP"
        tt-transacoes-padrao.descricao-por   = "Parada de M†quina OPC"
        tt-transacoes-padrao.descricao-eng   = "OPC Device Stop"
        tt-transacoes-padrao.descricao-spa   = "Parada de M†quina OPC"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9034c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9034a.w"
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = ""
        tt-transacoes-padrao.p-prog-char     = "bc9034".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "BCREN001"
        tt-transacoes-padrao.descricao-por   = "Alteraá∆o C¢digo Item(CD0205)"
        tt-transacoes-padrao.descricao-eng   = "Change Item Code (CD0205)"
        tt-transacoes-padrao.descricao-spa   = "Cambio C¢digo ÷tem"
        tt-transacoes-padrao.api-atualizacao = ""
        tt-transacoes-padrao.prog-altera     = "bcp/bc9040a.w"
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = "bcp/bc8001.p"
        tt-transacoes-padrao.prog-leitura    = ""
        tt-transacoes-padrao.p-prog-char     = "bc8001".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMOut009"
        tt-transacoes-padrao.descricao-por   = "Consulta Saldo Endereáo WMS"
        tt-transacoes-padrao.descricao-eng   = "WMS Bin Balance Inquiry"
        tt-transacoes-padrao.descricao-spa   = "Consulta Saldo Direcci¢n WMS"
        tt-transacoes-padrao.api-atualizacao = ""
        tt-transacoes-padrao.prog-altera     = ""
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9041.p"
        tt-transacoes-padrao.p-prog-char     = "bc9041".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMOut010"
        tt-transacoes-padrao.descricao-por   = "Convocaá∆o Ativa"
        tt-transacoes-padrao.descricao-eng   = "Active Call"
        tt-transacoes-padrao.descricao-spa   = "Convocaci¢n Activa"
        tt-transacoes-padrao.api-atualizacao = ""
        tt-transacoes-padrao.prog-altera     = ""
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9044.p"
        tt-transacoes-padrao.p-prog-char     = "bc9044".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMEnt006"
        tt-transacoes-padrao.descricao-por   = "Armazenamento Packing"
        tt-transacoes-padrao.descricao-eng   = "Package Storage"
        tt-transacoes-padrao.descricao-spa   = "Almacenamiento Packing"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9042d.p"
        tt-transacoes-padrao.prog-altera     = ""
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9042.p"
        tt-transacoes-padrao.p-prog-char     = "bc9042".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMSai006"
        tt-transacoes-padrao.descricao-por   = "Separaá∆o Packing"
        tt-transacoes-padrao.descricao-eng   = "Package Picking"
        tt-transacoes-padrao.descricao-spa   = "Separaci¢n Packing"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9043d.p"
        tt-transacoes-padrao.prog-altera     = ""
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9043.p"
        tt-transacoes-padrao.p-prog-char     = "bc9043".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMEnt007"
        tt-transacoes-padrao.descricao-por   = "Conferància Recebimento"
        tt-transacoes-padrao.descricao-eng   = "Reciving Check"
        tt-transacoes-padrao.descricao-spa   = "Conferencia Recebimiento"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9045c.p"
        tt-transacoes-padrao.prog-altera     = ""
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9045.p"
        tt-transacoes-padrao.p-prog-char     = "bc9045".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMOut011"
        tt-transacoes-padrao.descricao-por   = "Liberaá∆o de Transferància"
        tt-transacoes-padrao.descricao-eng   = "Release Transfer"
        tt-transacoes-padrao.descricao-spa   = "Liberaci¢n de Transferencia"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9046c.p"
        tt-transacoes-padrao.prog-altera     = ""
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9046.p"
        tt-transacoes-padrao.p-prog-char     = "bc9046".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMOut012"
        tt-transacoes-padrao.descricao-por   = "Etiqueta Padr∆o Endereáo WMS"
        tt-transacoes-padrao.descricao-eng   = "WMS Standard Address Label"
        tt-transacoes-padrao.descricao-spa   = "Est†ndar Etiqueta direcci¢n WMS"
        tt-transacoes-padrao.api-atualizacao = ""
        tt-transacoes-padrao.prog-altera     = ""
        tt-transacoes-padrao.prog-etiq       = "bcp/bcapi002.p"
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = "bcp/bc9047.w"
        tt-transacoes-padrao.prog-leitura    = ""
        tt-transacoes-padrao.p-prog-char     = "".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMSai010"
        tt-transacoes-padrao.descricao-por   = "Conferància Packing"
        tt-transacoes-padrao.descricao-eng   = "Conferància Packing"
        tt-transacoes-padrao.descricao-spa   = "Conferància Packing"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9036c.p"
        tt-transacoes-padrao.prog-altera     = ""
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9036.p"
        tt-transacoes-padrao.p-prog-char     = "bc9036".

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMSai011"
        tt-transacoes-padrao.descricao-por   = "Interface - Picking Doc WMS"
        tt-transacoes-padrao.descricao-eng   = "Interface - Picking Doc WMS"
        tt-transacoes-padrao.descricao-spa   = "Interface - Picking Doc WMS"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9018c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9018a.p"
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9049.p"
        tt-transacoes-padrao.p-prog-char     = "bc9049".


CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "TransMCP"
        tt-transacoes-padrao.descricao-por   = "Transfere Produá∆o"
        tt-transacoes-padrao.descricao-eng   = "Production Transfer"
        tt-transacoes-padrao.descricao-spa   = "Transferencia para producci¢n"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9051c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9051a.p"
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = "bcp/bc9051b.p"
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9051.p"
        tt-transacoes-padrao.p-prog-char     = "bc9051".


CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMOut015"
        tt-transacoes-padrao.descricao-por   = "Consulta Caixa WMS"
        tt-transacoes-padrao.descricao-eng   = "WMS Box Consultation"
        tt-transacoes-padrao.descricao-spa   = "Consulta de caja WMS"
        tt-transacoes-padrao.api-atualizacao = ""
        tt-transacoes-padrao.prog-altera     = ""
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9038.p"
        tt-transacoes-padrao.p-prog-char     = "bc9038".
        

CREATE  tt-transacoes-padrao.
ASSIGN  tt-transacoes-padrao.cd-trans        = "WMOut016"
        tt-transacoes-padrao.descricao-por   = "Conferància Packing"
        tt-transacoes-padrao.descricao-eng   = "Packing Conference"
        tt-transacoes-padrao.descricao-spa   = "Conferencia de Empaque"
        tt-transacoes-padrao.api-atualizacao = "bcp/bc9036c.p"
        tt-transacoes-padrao.prog-altera     = "bcp/bc9036a.p"
        tt-transacoes-padrao.prog-etiq       = ""
        tt-transacoes-padrao.prog-import     = ""
        tt-transacoes-padrao.prog-criacao    = ""
        tt-transacoes-padrao.prog-leitura    = "bcp/bc9036.p"
        tt-transacoes-padrao.p-prog-char     = "bc9036".                
        
/* Inicializaá∆o da Tabela param-bc */

FIND FIRST param-bc EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAIL param-bc THEN
   CREATE param-bc.
    
ASSIGN param-bc.tp-etiq-padrao             = 99
       param-bc.tipo-etiq-total            = 99
       param-bc.pto-decimal                = YES
       param-bc.int-1                      = 3
       param-bc.char-1                     = "|"   /* Delimitador de campos na importaá∆o  */
       param-bc.nome-dir-etiq              = "c:/spool"
       param-bc.cod_servid_exec_import     = ""
       param-bc.cod_servid_exec_atualiz    = ""
       param-bc.ind-sistema                = 1.

/* Inicializaá∆o da Tabela bc-param-mat */

FIND FIRST bc-param-mat EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAIL bc-param-mat THEN
   CREATE bc-param-mat.

ASSIGN bc-param-mat.nr-contagem = 1.

FOR EACH tt-transacoes-padrao:
   RUN pi-acompanhar IN h-acomp (INPUT tt-transacoes-padrao.cd-trans ).
   
   FIND FIRST bc-tipo-trans
        WHERE bc-tipo-trans.cd-trans = tt-transacoes-padrao.cd-trans EXCLUSIVE-LOCK NO-ERROR.   
   IF NOT AVAIL bc-tipo-trans THEN
       CREATE bc-tipo-trans.

   ASSIGN bc-tipo-trans.cd-trans        = TRIM(tt-transacoes-padrao.cd-trans)
          &IF "{&language-code}" = "POR" &THEN
             bc-tipo-trans.descricao    = TRIM(tt-transacoes-padrao.descricao-por)
          &ENDIF
          &IF "{&language-code}" = "ING" &THEN
             bc-tipo-trans.descricao    = TRIM(tt-transacoes-padrao.descricao-eng)
          &ENDIF
          &IF "{&language-code}" = "ESP" &THEN
             bc-tipo-trans.descricao    = TRIM(tt-transacoes-padrao.descricao-spa)
          &ENDIF
          bc-tipo-trans.prog-altera     = TRIM(tt-transacoes-padrao.prog-altera)
          bc-tipo-trans.prog-etiq       = TRIM(tt-transacoes-padrao.prog-etiq)
          bc-tipo-trans.api-atualizacao = TRIM(tt-transacoes-padrao.api-atualizacao)
          bc-tipo-trans.prog-import     = TRIM(tt-transacoes-padrao.prog-import)
          bc-tipo-trans.prog-criacao    = TRIM(tt-transacoes-padrao.prog-criacao)
          bc-tipo-trans.prog-leitura    = TRIM(tt-transacoes-padrao.prog-leitura)
          bc-tipo-trans.char-1          = TRIM(tt-transacoes-padrao.cd-trans)
          bc-tipo-trans.tipo-etiq-total = 00.

   /*Verifica informaá‰es para o tipo de transaá∆o de etiqueta de endereáos padr∆o WMS*/
   IF bc-tipo-trans.cd-trans = "WMOut012" THEN DO:
       ASSIGN bc-tipo-trans.imp-apos-trans = YES.
       /*Verifica se o tipo de etiqueta endereáo WMS foi importados para
         atualizar as informaá‰es do tipo etiqueta para o tipo de transaá∆o*/
       IF CAN-FIND(FIRST tipo-etiqueta WHERE tipo-etiqueta.tipo-etiq = 9999) THEN
          ASSIGN bc-tipo-trans.tipo-etiq       = 9999
                 bc-tipo-trans.tipo-etiq-total = 9999
                 bc-tipo-trans.int-2           = 3.
   END.
   
   /* As transaá‰es WMS Devem estar todas com o campo Atualiza On-Line e Mostra Erros On-Line habilitadas,
      conforme treinamento, manual de referencia e caracteristicas das transaá‰es */
   IF SUBSTRING(TRIM(tt-transacoes-padrao.cd-trans),1,2) = "WM" THEN
      ASSIGN bc-tipo-trans.atualiza-on-line  = YES
             bc-tipo-trans.erros-on-line     = YES.
   
   /* criar bc-prog-trans do programa de Criacao de Transaáao */
   DO ON ERROR UNDO, NEXT:
      FIND FIRST bc-prog-trans
           WHERE bc-prog-trans.cd-trans       = TRIM(tt-transacoes-padrao.cd-trans)
             AND bc-prog-trans.cod_prog_dtsul = TRIM(tt-transacoes-padrao.p-prog-char) EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAIL bc-prog-trans THEN
         IF TRIM(tt-transacoes-padrao.p-prog-char) <> "" THEN
            CREATE bc-prog-trans.
         ELSE
             UNDO, NEXT.
      
      ASSIGN bc-prog-trans.cd-trans       = TRIM(tt-transacoes-padrao.cd-trans)
             bc-prog-trans.cod_prog_dtsul = TRIM(tt-transacoes-padrao.p-prog-char)
             bc-prog-trans.situacao-trans = YES.
   END.
   
   /* criar bc-prog-trans do programa de Criacao de Transaáao na vers∆o caracter */   
   DO ON ERROR UNDO, NEXT:
      FIND FIRST bc-prog-trans
           WHERE bc-prog-trans.cd-trans       = TRIM(tt-transacoes-padrao.cd-trans)
             AND bc-prog-trans.cod_prog_dtsul = TRIM(tt-transacoes-padrao.p-prog-char) EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAIL bc-prog-trans THEN
         IF TRIM(tt-transacoes-padrao.p-prog-char) <> "" THEN
            CREATE bc-prog-trans.
         ELSE
             UNDO, NEXT.
      
      ASSIGN bc-prog-trans.cd-trans       = TRIM(tt-transacoes-padrao.cd-trans)
             bc-prog-trans.cod_prog_dtsul = TRIM(tt-transacoes-padrao.p-prog-char)
             bc-prog-trans.situacao-trans = YES.
   END.
      
   /* criar bc-prog-trans do programa de Leitura de Transaáao */   
   DO ON ERROR UNDO, NEXT:
      FIND FIRST bc-prog-trans
           WHERE bc-prog-trans.cd-trans       = TRIM(tt-transacoes-padrao.cd-trans)
             AND bc-prog-trans.cod_prog_dtsul = TRIM(tt-transacoes-padrao.p-prog-char) EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAIL bc-prog-trans THEN
         IF TRIM(tt-transacoes-padrao.p-prog-char) <> "" THEN
            CREATE bc-prog-trans.
         ELSE
             UNDO, NEXT.
      
      ASSIGN bc-prog-trans.cd-trans       = TRIM(tt-transacoes-padrao.cd-trans)
             bc-prog-trans.cod_prog_dtsul = TRIM(tt-transacoes-padrao.p-prog-char)
             bc-prog-trans.situacao-trans = YES.
   END.
   
   /* Inicializaá∆o da Tabela bc-tipo-backflush */   
   FIND FIRST bc-tipo-backflush
        WHERE bc-tipo-backflush.cd-trans = TRIM(tt-transacoes-padrao.cd-trans) EXCLUSIVE-LOCK NO-ERROR.
   IF NOT AVAIL bc-tipo-backflush THEN
      CREATE bc-tipo-backflush.
   
   ASSIGN bc-tipo-backflush.cd-trans                  = TRIM(tt-transacoes-padrao.cd-trans)
          bc-tipo-backflush.motivo-backflush          = 1
          bc-tipo-backflush.baixa-reserva             = 1
          bc-tipo-backflush.muda-status               = NO
          bc-tipo-backflush.codigo-rejei              = 0
          bc-tipo-backflush.cod-cta-ctbl-aplic-unif   = ""
          bc-tipo-backflush.cod-ccusto-aplic-unif     = ""
          bc-tipo-backflush.cod-cta-ctbl-refugo-unif  = ""
          bc-tipo-backflush.cod-ccusto-refugo-unif    = "".
END.

{utp/ut-liter.i Finalizando *}
RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE ).

/* Inicializaá∆o da Tabela tipo-etiqueta */

FIND FIRST tipo-etiqueta
     WHERE tipo-etiqueta.tipo-etiq = 99 EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAIL tipo-etiqueta THEN
   CREATE tipo-etiqueta.

{utp/ut-liter.i "Etiqueta Padr∆o Datasul" * L}
ASSIGN tipo-etiqueta.tipo-etiq        = 99
       tipo-etiqueta.titulo           = TRIM(RETURN-VALUE)
       tipo-etiqueta.ind-tipo-destino = 1.

/* Inicializaá∆o da Tabela seq-tipo-etiqueta */

{bcp/bc0001.i1} /* Uni∆o das Inclides i01cl016.i, i02cl016.i, i03cl016.i    */
ASSIGN i-cont  = 0.

FOR EACH seq-tipo-etiqueta 
   WHERE seq-tipo-etiqueta.tipo-etiq = 99:
   DELETE seq-tipo-etiqueta.
END.

DO i-cont = 1 TO NUM-ENTRIES(c-lista):
   FIND FIRST seq-tipo-etiqueta
        WHERE seq-tipo-etiqueta.tipo-etiq = 99 
          AND seq-tipo-etiqueta.sequencia = i-cont EXCLUSIVE-LOCK NO-ERROR.
   IF NOT AVAIL seq-tipo-etiqueta THEN DO:
      CREATE seq-tipo-etiqueta.
      ASSIGN seq-tipo-etiqueta.tipo-etiq = 99
             seq-tipo-etiqueta.sequencia = i-cont
             seq-tipo-etiqueta.cod-campo = i-cont * 1000 + i-cont
             seq-tipo-etiqueta.char-1    = SUBSTRING(ENTRY(i-cont,c-lista),33,21)
             seq-tipo-etiqueta.int-1     = (IF SUBSTRING(seq-tipo-etiqueta.char-1,1,2) = "X(" THEN 1
                                            ELSE IF SUBSTRING(seq-tipo-etiqueta.char-1,1,2) = ">>" THEN 2 ELSE 0).
   END.
END.

RUN bcp/bc0001c.p.

RUN pi-finalizar IN h-acomp.

