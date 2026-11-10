&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOFunction 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN714AT 2.00.00.022 } /*** "010022" 03/12/2025 11:42:02 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN714AT MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : dbofun.p
    Purpose    : O DBO Function (Datasul Business Objects) Ç um programa 
                 PROGRESS que contÇm a l¢gica de neg¢cio.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BODI714AT 
&GLOBAL-DEFINE DBOVersion 1
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName rma
&GLOBAL-DEFINE TableLabel

{cdp/cdcfgmat.i} /* Include com prÇ-processadores de vers∆o */

    
&GLOBAL-DEFINE TRUE-log-pedido-rma  rma.log-ped-rma = YES

/* RMA */
&GLOBAL-DEFINE rma.cod-nota-debito        rma.cod-nota-fisc-db
&GLOBAL-DEFINE rma.cod-serie-nota-debito  rma.cod-serie-nota-debito
&GLOBAL-DEFINE rma.cod-remito             rma.cod-remito
&GLOBAL-DEFINE rma.cod-serie-remito       rma.cod-serie-remito
/* Ped Venda */
&GLOBAL-DEFINE tt-ped-venda.cod-rma       tt-ped-venda.cod-rma 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin714.i RowObject}

/* Definiá∆o de Handles */
def var h-bodi317in       as handle no-undo.
def var h-bodi317int      as handle no-undo.
def var h-bodi317sd       as handle no-undo.
def var h-bodi317pr       as handle no-undo.
def var h-bodi317va       as handle no-undo.
def var h-bodi317ef       as handle no-undo.
def var h-bodi317im1br    as handle no-undo.
def var h-acomp           as handle no-undo.

def var bo-ped-venda-sdf  as handle no-undo.
def var bo-ped-item-sdf   as handle no-undo.
def var bo-ped-venda      as handle no-undo.
def var bo-ped-item       as handle no-undo.
def var bo-ped-repre      as handle no-undo.

/* Definiá∆o de Vari†veis */
def var l-somente-despesa   as log          no-undo.
def var l-first-credit-note as log init yes no-undo.

/* Definiá∆o de Streams */
def stream s-resultado.

/* Definiá∆o de temp-tables */
def temp-table tt-despesa-rma no-undo like rma-desp.

def temp-table tt-ped-venda   no-undo like ped-venda
    field r-rowid as rowid.

def temp-table tt-ped-item   no-undo like ped-item
    field r-rowid as rowid.

def temp-table tt-notas-geradas-impressao no-undo
    field rw-nota-fiscal as   rowid
    field nr-nota        like nota-fiscal.nr-nota-fis.
    
{inbo/boin714at.i1} /* temp-tables dos documentos gerados */

{dibo/bodi317ef.i1} /* tt-notas-geradas */

{ftp/ftapi063.i}    /* temp-table de remitos */

{dibo/bodi159.i2 tt-ped-param}

/* Includes padr‰es */
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOFunction



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOFunction
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOFunction ASSIGN
         HEIGHT             = 2.29
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOFunction 
/* ************************* Included-Libraries *********************** */

{method/dbofun.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOFunction 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkIfCreditednReturnedQtyAreFilled DBOFunction 
PROCEDURE checkIfCreditednReturnedQtyAreFilled :
/*------------------------------------------------------------------------------
  Purpose: Verificar se existe algum item com quantidades destinadas a devoluá∆o 
           e/ou crÇdito inferiores Ö quantidade j† recebida.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF NOT AVAIL rowObject THEN 
    RETURN "NOK":U.
  
  /* Caso algum item possua quantidades ainda n∆o devidamente preenchidas */
  IF CAN-FIND (FIRST rma-item WHERE 
                     rma-item.cod-estabel = rowObject.cod-estabel and
                     rma-item.cod-rma     = rowObject.cod-rma     and
                     ((rma-item.qtd-devolver + rma-item.qtd-creditada) < 
                      (rma-item.qtd-a-receber - rma-item.qtd-cancelada))) THEN
     RETURN "NOK":U.                       
     
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CreditNoteGeneration DBOFunction 
PROCEDURE CreditNoteGeneration :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Definiá∆o de ParÉmetros */
def input param p-c-cod-rma     like rma.cod-rma     no-undo.
def input param p-c-cod-estabel like rma.cod-estabel no-undo.

/* Definiá∆o de Vari†veis */
def var i-seq-wt-docto              as int  no-undo.
def var l-proc-ok-aux               as log  no-undo.
def var c-serie-formada             as char no-undo.
def var c-ultimo-metodo-exec        as char no-undo.
def var l-mais-de-uma-nota-original as log  no-undo.
def var c-nota-original             as char no-undo.
def var c-serie-original            as char no-undo.
def var l-possui-impressao-aut      as log  no-undo.

/* Localiza tabela RMA */
if  not avail rma or
    (rma.cod-rma     <> p-c-cod-rma and
    rma.cod-estabel <> p-c-cod-estabel) then do:

    find first rma where
               rma.cod-rma     = p-c-cod-rma and
               rma.cod-estabel = p-c-cod-estabel no-error.
end.

if  avail rma then do:

    do trans:

        /* Retorna a sÇrie formada para os EUA */
        run buscaSerieEstadosUnidos in h-bodi317int (input rma.cod-nat-operacao-nc,
                                                     output c-serie-formada,
                                                     output l-proc-ok-aux).

        for each rma-item where
                 rma-item.cod-rma        = rma.cod-rma     and
                 rma-item.cod-estabel    = rma.cod-estabel and
                 rma-item.qtd-creditada <> 0 no-lock
            break by rma-item.cod-nota-fis-orig:

            if first-of(rma-item.cod-nota-fis-orig) then do:
                /* Limpa tabela de erros das BO's */
                run emptyRowErrors in h-bodi317in.

                for each rowErrors:
                    delete rowErrors.
                end.

                assign c-nota-original  = rma-item.cod-nota-fis-orig
                       c-serie-original = rma-item.cod-serie-orig.   

            end.

            if  last-of(rma-item.cod-nota-fis-orig) then do:
                /* Cria tabela WT-DOCTO */

                run criaWtDocto in h-bodi317sd (input  c-seg-usuario,
                                                input  rma.cod-estabel,
                                                input  c-serie-formada,
                                                input  1,
                                                input  rma.cdn-emitente,
                                                input  ?,
                                                input  4,    /* Nota de CrÇdito */
                                                input  3201, /* Programa de Manutená∆o do RMA */
                                                input  today,
                                                input  0,
                                                input  rma.cod-nat-operacao-nc,
                                                input  ?,
                                                output i-seq-wt-docto,
                                                output l-proc-ok-aux).

                run devolveErrosbodi317sd in h-bodi317sd (output c-ultimo-metodo-exec,
                                                          output table RowErrors).

                IF  not l-proc-ok-aux THEN do:

                    for each rowerrors:
                        create tt-erros-nc.
                        assign tt-erros-nc.cod-erro  = rowerrors.errorNumber
                               tt-erros-nc.cod-param = rowerrors.errorParameters.

                        delete rowErrors.
                    end.

                    undo, return no-apply.
                end.

                if  c-nota-original  <> "" or
                    c-serie-original <> "" THEN DO:
                    
                    FIND nota-fiscal NO-LOCK
                        WHERE nota-fiscal.cod-estabel = rma.cod-estabel
                          AND nota-fiscal.serie       = c-serie-original
                          AND nota-fiscal.nr-nota-fis = c-nota-original NO-ERROR.
                    
                    RUN setCurrency IN h-bodi317int (INPUT nota-fiscal.mo-codigo,
                                                     INPUT nota-fiscal.vl-taxa-exp).

                    /* Atualiza as Informaá‰es da Nota Origial na tabela WT-DOCTO */
                    run UpdateWtDoctoWithOriginalInvoice in h-bodi317int (input i-seq-wt-docto,
                                                                          input c-nota-original,
                                                                          input c-serie-original,
                                                                          input 100,
                                                                          input 0,
                                                                          INPUT NO,
                                                                          input no,
                                                                          INPUT "",
                                                                          output l-proc-ok-aux).
                END.                                                                          
                ELSE
                    /* As informaá‰es ser∆o atualizadas pelo cliente */
                    run UpdateWtDoctoWithOriginalInvoice in h-bodi317int (input i-seq-wt-docto,
                                                                          input "",
                                                                          input "",
                                                                          input 0,
                                                                          input 0,
                                                                          INPUT NO,
                                                                          input no,
                                                                          INPUT "",
                                                                          output l-proc-ok-aux).
        
                run devolveErrosbodi317int in h-bodi317int (output c-ultimo-metodo-exec,
                                                            output table RowErrors).
        
                if  not l-proc-ok-aux then do:
        
                    for each rowerrors:
                        create tt-erros-nc.
                        assign tt-erros-nc.cod-erro  = rowerrors.errorNumber
                               tt-erros-nc.cod-param = rowerrors.errorParameters.
        
                        delete rowErrors.
                    end.
        
                    undo, return no-apply.
                end.
        
                /* Atualiza as Informaá‰es do RMA na tabela WT-DOCTO */
        
                run UpdateWtDoctoWithRMADocument in h-bodi317int (input i-seq-wt-docto,
                                                                  input rowid(rma),
                                                                  output l-proc-ok-aux).
        
                run devolveErrosbodi317int in h-bodi317int (output c-ultimo-metodo-exec,
                                                            output table RowErrors).
                IF  not l-proc-ok-aux THEN do:
        
                    for each rowerrors:
                        create tt-erros-nc.
                        assign tt-erros-nc.cod-erro  = rowerrors.errorNumber
                               tt-erros-nc.cod-param = rowerrors.errorParameters.
        
                        delete rowErrors.
                    end.
                            
                    undo, return no-apply.
                end.    
                
                /*** Inicio Tratamento exclusivo liberado para a Brasseagle ***/
                if  can-find (funcao where funcao.cd-funcao = "spp-desp-rma-ncr"
                                     and   funcao.ativo     = yes) then do:

                    empty temp-table tt-despesa-rma.

                    if  l-first-credit-note then do:
                        assign l-first-credit-note = no.
                        /* Criar as despesas relacionadas ao RMA */         
                        for each rma-desp where
                                 rma-desp.cod-rma     = rma.cod-rma and
                                 rma-desp.cod-estabel = rma.cod-estabel no-lock:            
                            
                            if  not can-find (tt-despesa-rma 
                                               where tt-despesa-rma.cod-despesa = rma-desp.cod-despesa
                                               and   tt-despesa-rma.cod-estabel = rma-desp.cod-estabel
                                               and   tt-despesa-rma.cod-rma     = rma-desp.cod-rma) then do:
                                create tt-despesa-rma.
                                assign tt-despesa-rma.cod-despesa  = rma-desp.cod-despesa
                                       tt-despesa-rma.cod-rma      = rma-desp.cod-rma
                                       tt-despesa-rma.cod-estabel  = rma-desp.cod-estabel
                                       tt-despesa-rma.val-despesa  = rma-desp.val-despesa
                                       tt-despesa-rma.val-per-desp = rma-desp.val-per-desp.
                            end.
                        end.
                    end.

                    /* Envia a tabela de despesas para BO que farˇ a geraá∆o na tabela wt-desp-nota */         
                    run InputTTDespesaRMA in h-bodi317int (input table tt-despesa-rma,
                                                           output l-proc-ok-aux).
                end.
                /*** Fim Tratamento exclusivo liberado para a Brasseagle ***/
        
                /* Gera Itens da NC com base nos Itens do RMA */
                run generateItemsOfCreditNoteRMA in h-bodi317int (input i-seq-wt-docto,
                                                                  input rma.cod-rma,
                                                                  input rma.cod-estabel,
                                                                  output l-proc-ok-aux).
        
                run devolveErrosbodi317int in h-bodi317int (output c-ultimo-metodo-exec,
                                                            output table RowErrors).
                IF  not l-proc-ok-aux THEN do:
        
                    for each rowerrors:
                        create tt-erros-nc.
                        assign tt-erros-nc.cod-erro  = rowerrors.errorNumber
                               tt-erros-nc.cod-param = rowerrors.errorParameters.
        
                        delete rowErrors.
                    end.
                            
                    undo, return no-apply.
                end.    
        
                /* Realiza as validaá‰es e prepara os dados para o faturamento */
                run confirmaCalculoInternacional in h-bodi317int(input  i-seq-wt-docto,
                                                                 output l-proc-ok-aux).
        
                run devolveErrosbodi317int in h-bodi317int (output c-ultimo-metodo-exec,
                                                            output table RowErrors).
                IF  not l-proc-ok-aux THEN do:
        
                    for each rowerrors:
                        create tt-erros-nc.
                        assign tt-erros-nc.cod-erro  = rowerrors.errorNumber
                               tt-erros-nc.cod-param = rowerrors.errorParameters.
        
                        delete rowErrors.
                    end.
                            
                    undo, return no-apply.
                end.
        
                /* Efetiva as informaá‰es da tabelas tempor†rias nas tabelas NOTA-FISCAL e relacionadas */
                run dibo/bodi317ef.p persistent set h-bodi317ef.
        
                run emptyRowErrors in h-bodi317in.
                run emptyRowErrors in h-bodi317int.
                run setaHandlesBOS in h-bodi317ef (input h-bodi317pr,
                                                   input h-bodi317sd,
                                                   input h-bodi317im1br, 
                                                   input h-bodi317va).
        
                run efetivaNota in h-bodi317ef (input  i-seq-wt-docto,
                                                input  yes,
                                                output l-proc-ok-aux).
        
                run devolveErrosbodi317ef in h-bodi317ef (output c-ultimo-metodo-exec,
                                                          output table RowErrors).
        
                IF  not l-proc-ok-aux THEN do:
                    for each rowerrors:
                        create tt-erros-nc.
                        assign tt-erros-nc.cod-erro  = rowerrors.errorNumber
                               tt-erros-nc.cod-param = rowerrors.errorParameters.
        
                        delete rowErrors.
                    end.
        
                    undo, return no-apply.
                end.
        
                run buscaTTNotasGeradas in h-bodi317ef (output l-proc-ok-aux,
                                                        output table tt-notas-geradas).
        
                /* Se houver impressao automatica imprime as notas fiscais */
                run possuiImpressaoAutomatica in h-bodi317ef (output l-possui-impressao-aut).
        
                if  l-possui-impressao-aut then do:
        
                    for each tt-notas-geradas-impressao:
                        delete tt-notas-geradas-impressao.
                    end.
                    for each tt-notas-geradas:
                        create tt-notas-geradas-impressao.
                        assign tt-notas-geradas-impressao.rw-nota-fiscal = tt-notas-geradas.rw-nota-fiscal
                               tt-notas-geradas-impressao.nr-nota        = tt-notas-geradas.nr-nota.
                    end.
                    run ftp/ft2018.w (input table tt-notas-geradas-impressao).
                end.
        
                /* Cria a tabela que vai indicar as notas de crÇdito geradas */
                for each tt-notas-geradas:
                    create tt-nc-geradas.
                    assign tt-nc-geradas.rw-nota-fiscal = tt-notas-geradas.rw-nota-fiscal.
                end.
        
                delete procedure h-bodi317ef.
        
                
                /*----------------------------------------------*/
                /* Atualizaá∆o do n£mero e sÇrie da Nota no RMA */
                /*----------------------------------------------*/
                /* Conforme FO 856228 - Foresight               */
                /*----------------------------------------------*/
                
                /* Atualiza o flag NC na tabela RMA */
                FIND FIRST tt-notas-geradas NO-ERROR.
                IF AVAIL tt-notas-geradas THEN
                   run updateFlagCreditNoteRMA in h-bodi317int (input rowid(rma),
                                                                INPUT tt-notas-geradas.nr-nota,
                                                                INPUT c-serie-formada,
                                                                output l-proc-ok-aux).
            end.
        end.
    end.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DebitNoteGeneration DBOFunction 
PROCEDURE DebitNoteGeneration :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param p-c-cod-rma     like rma.cod-rma     no-undo.
def input param p-c-cod-estabel like rma.cod-estabel no-undo.

/* Definiá∆o de Vari†veis */
def var i-seq-wt-docto              as int  no-undo.
def var l-proc-ok-aux               as log  no-undo.
def var c-serie-formada             as char no-undo.
def var c-ultimo-metodo-exec        as char no-undo.
def var l-mais-de-uma-nota-original as log  no-undo.
def var c-nota-original             as char no-undo.
def var c-serie-original            as char no-undo.
def var l-possui-impressao-aut      as log  no-undo.

/* Localiza tabela RMA */
if  not avail rma or
    (rma.cod-rma     <> p-c-cod-rma and
    rma.cod-estabel <> p-c-cod-estabel) then do:

    find first rma where
               rma.cod-rma     = p-c-cod-rma and
               rma.cod-estabel = p-c-cod-estabel no-error.
end.

if  avail rma then do:

    do trans:

        run emptyRowErrors in h-bodi317in.

        for each rowErrors:
            delete rowErrors.
        end.

        /* Retorna a sÇrie dos EUA */
        run buscaSerieEstadosUnidos in h-bodi317int (input rma.cod-nat-operacao-nd,
                                                     output c-serie-formada,
                                                     output l-proc-ok-aux).

        /* Cria tabela WT-DOCTO */
        run criaWtDocto in h-bodi317sd (input  c-seg-usuario,
                                        input  rma.cod-estabel,
                                        input  c-serie-formada,
                                        input  1,
                                        input  rma.cdn-emitente,
                                        input  ?,
                                        input  3,    /* Nota de DÇbito */
                                        input  3201, /* Programa de Manutená∆o do RMA */
                                        input  today,
                                        input  0,
                                        input  rma.cod-nat-operacao-nd,
                                        input  ?,
                                        output i-seq-wt-docto,
                                        output l-proc-ok-aux).

        run devolveErrosbodi317sd in h-bodi317sd (output c-ultimo-metodo-exec,
                                                  output table RowErrors).        

        IF  not l-proc-ok-aux THEN DO:

            for each rowerrors:
                create tt-erros-nd.
                assign tt-erros-nd.cod-erro  = rowerrors.errorNumber
                       tt-erros-nd.cod-param = rowerrors.errorParameters.

                delete rowErrors.
            end.

            undo, return no-apply.
        END.

        /* A nota de dÇbito n∆o possui nota original, as informaá‰es vem do emitente */

        run UpdateWtDoctoWithOriginalInvoice in h-bodi317int (input i-seq-wt-docto,
                                                              input "",
                                                              input "",
                                                              input 100,
                                                              input 0,
                                                              INPUT NO,
                                                              input l-somente-despesa,
                                                              INPUT "",
                                                              output l-proc-ok-aux).

        run devolveErrosbodi317int           in h-bodi317int (output c-ultimo-metodo-exec,
                                                              output table RowErrors).

        if  not l-proc-ok-aux then do:
            for each rowerrors:
                create tt-erros-nd.
                assign tt-erros-nd.cod-erro  = rowerrors.errorNumber
                       tt-erros-nd.cod-param = rowerrors.errorParameters.
                       
                delete rowErrors.
            end.                    

            undo, return no-apply.
        end.

        /* Atualiza as Informaá‰es do RMA na tabela wt-docto */
        run UpdateWtDoctoWithRMADocument in h-bodi317int (input i-seq-wt-docto,
                                                          input rowid(rma),
                                                          output l-proc-ok-aux).

        run devolveErrosbodi317int in h-bodi317int (output c-ultimo-metodo-exec,
                                                    output table RowErrors).

        IF  not l-proc-ok-aux THEN DO:
        
            for each rowerrors:
                create tt-erros-nd.
                assign tt-erros-nd.cod-erro  = rowerrors.errorNumber
                       tt-erros-nd.cod-param = rowerrors.errorParameters.
                       
                delete rowErrors.
            end.

            undo, return no-apply.
        end.

        IF NOT CAN-FIND (funcao WHERE funcao.cd-funcao = "spp-desp-rma-ncr"
                                AND funcao.ativo = YES)  THEN DO:
            /* Criar as despesas relacionadas ao RMA */
            for each rma-desp where
                     rma-desp.cod-rma     = rma.cod-rma and
                     rma-desp.cod-estabel = rma.cod-estabel no-lock:            
                
                create tt-despesa-rma.
                assign tt-despesa-rma.cod-despesa  = rma-desp.cod-despesa
                       tt-despesa-rma.cod-rma      = rma-desp.cod-rma
                       tt-despesa-rma.cod-estabel  = rma-desp.cod-estabel
                       tt-despesa-rma.val-despesa  = rma-desp.val-despesa
                       tt-despesa-rma.val-per-desp = rma-desp.val-per-desp.
            end.
            /* Envia a tabela de despesas para BO que far† a geraá∆o na tabela wt-desp-nota */
            run InputTTDespesaRMA in h-bodi317int (input table tt-despesa-rma,
                                                   output l-proc-ok-aux).
            run generateItemsOfDebitNoteRMA in h-bodi317int (input i-seq-wt-docto,
                                                            input rowid(rma),
                                                            output l-proc-ok-aux).

        END.
        ELSE DO:
            /* Gera Itens da ND com base nos valores de reestocagem e despesas */
            if  not l-somente-despesa then do:
    
                run generateItemsOfDebitNoteRMA in h-bodi317int (input i-seq-wt-docto,
                                                                 input rowid(rma),
                                                                 output l-proc-ok-aux).
            end.
            else do:
    
                run generateItemOfExpenseInvoinve in h-bodi317int (input i-seq-wt-docto,
                                                                   output l-proc-ok-aux).
            end.                                                       
        END.

        run devolveErrosbodi317int  in h-bodi317int (output c-ultimo-metodo-exec,
                                                     output table RowErrors).

        IF  not l-proc-ok-aux THEN DO:

            for each rowerrors:
                create tt-erros-nd.
                assign tt-erros-nd.cod-erro = rowerrors.errorNumber
                       tt-erros-nd.cod-param    = rowerrors.errorParameters.


                delete rowErrors.
            end.            

            undo, return no-apply.
        END.    

        /* Realiza as validaá‰es e prepara os dados para o faturamento */
        run confirmaCalculoInternacional in h-bodi317int(input  i-seq-wt-docto,
                                                         output l-proc-ok-aux).

        run devolveErrosbodi317int in h-bodi317int (output c-ultimo-metodo-exec,
                                                    output table RowErrors).

        IF  not l-proc-ok-aux THEN DO:
            for each rowerrors:
                create tt-erros-nd.
                assign tt-erros-nd.cod-erro  = rowerrors.errorNumber
                       tt-erros-nd.cod-param = rowerrors.errorParameters.
                       
                delete rowErrors.
            end.                    

            undo, return no-apply.
        end.

        /* Efetiva as informaá‰es da tabelas tempor†rias nas tabelas NOTA-FISCAL e relacionadas */    
        run dibo/bodi317ef.p persistent set h-bodi317ef.

        run emptyRowErrors in h-bodi317in.
        run emptyRowErrors in h-bodi317int.
        run setaHandlesBOS in h-bodi317ef (input h-bodi317pr,
                                           input h-bodi317sd, 
                                           input h-bodi317im1br, 
                                           input h-bodi317va).

        run efetivaNota in h-bodi317ef (input  i-seq-wt-docto,
                                        input  yes,
                                        output l-proc-ok-aux).

        run devolveErrosbodi317ef in h-bodi317ef (output c-ultimo-metodo-exec,
                                                  output table RowErrors).

        IF  not l-proc-ok-aux THEN DO:

            for each rowerrors:
                create tt-erros-nd.
                assign tt-erros-nd.cod-erro = rowerrors.errorNumber
                       tt-erros-nd.cod-param    = rowerrors.errorParameters.

                delete rowErrors.
            end.

            undo, return no-apply.
        end.

        run buscaTTNotasGeradas in h-bodi317ef (output l-proc-ok-aux,
                                                output table tt-notas-geradas).

        /* Se houver impress∆o autom†tica imprime as notas fiscais */
        run possuiImpressaoAutomatica in h-bodi317ef (output l-possui-impressao-aut).

        if  l-possui-impressao-aut then do:

            for each tt-notas-geradas-impressao:
                delete tt-notas-geradas-impressao.
            end.

            for each tt-notas-geradas:
                create tt-notas-geradas-impressao.
                assign tt-notas-geradas-impressao.rw-nota-fiscal = tt-notas-geradas.rw-nota-fiscal
                       tt-notas-geradas-impressao.nr-nota        = tt-notas-geradas.nr-nota.
            end.

            run ftp/ft2018.w (input table tt-notas-geradas-impressao).
        end.

        for each tt-notas-geradas:
            create tt-nd-geradas.
            assign tt-nd-geradas.rw-nota-fiscal = tt-notas-geradas.rw-nota-fiscal.
        end.

        delete procedure h-bodi317ef.

        /*----------------------------------------------*/
        /* Atualizaá∆o do n£mero e sÇrie da Nota no RMA */
        /*----------------------------------------------*/
        /* Conforme FO 856228 - Foresight               */
        /*----------------------------------------------*/

        /* Atualiza o flag ND na tabela RMA */
        FIND FIRST tt-notas-geradas NO-ERROR.
        IF AVAIL tt-notas-geradas THEN
           run updateFlagDebitNoteRMA in h-bodi317int (input rowid(rma),
                                                       INPUT tt-notas-geradas.nr-nota,
                                                       INPUT c-serie-formada,
                                                       output l-proc-ok-aux).

    end.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteErrors DBOFunction 
PROCEDURE deleteErrors :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

for each rowErrors:
    delete rowErrors.
end.

for each tt-erros-nc:
    delete tt-erros-nc.
end.

for each tt-erros-nd:
    delete tt-erros-nd.
end.

for each tt-erros-pv:
    delete tt-erros-pv.
end.

for each tt-erros-rd:
    delete tt-erros-rd.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DevolutionPckSlipGeneration DBOFunction 
PROCEDURE DevolutionPckSlipGeneration :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Definiá∆o de ParÉmetros */
def input param p-c-cod-rma     as char no-undo.
def input param p-c-cod-estabel as char no-undo.

/* Definiá∆o de Vari†veis */
def var i-seq-rmt            as int    no-undo.
def var l-proc-ok-aux        as log    no-undo.

/* Localiza RMA */
if  not avail rma or
    (rma.cod-rma     <> p-c-cod-rma and
    rma.cod-estabel <> p-c-cod-estabel) then do:

    find first rma where
               rma.cod-rma     = p-c-cod-rma and
               rma.cod-estabel = p-c-cod-estabel no-error.
end.

/* Localiza Tabelas Relacionadas */

for first emitente fields (cod-emitente nome-abrev cod-canal-venda) where
          emitente.cod-emitente = rma.cdn-emitente no-lock:
end.

do trans:

    create tt-remito.
    assign tt-remito.marca           = "X"
           tt-remito.nr-remito       = "1" /* Na FTAPI063 o n£mero Ç buscado da tabela SER-ESTAB */
           tt-remito.nome-abrev      = emitente.nome-abrev
           tt-remito.identific       = c-seg-usuario
           tt-remito.dt-remito       = today
           tt-remito.cod-estabel     = rma.cod-estabel
           tt-remito.serie           = para-fat.serie-pad-remito
           tt-remito.cod-canal-venda = emitente.cod-canal-venda
           tt-remito.cod-situacao    = 1
           tt-remito.nat-operacao    = rma.cod-nat-operacao-nd
           tt-remito.cidade-cif      = tt-remito.cidade-cif
           tt-remito.cond-redespa    = tt-remito.cond-redespa
           tt-remito.cod-entrega     = rma.cod-entrega
           tt-remito.endereco        = rma.des-endereco
           tt-remito.bairro          = rma.nom-bairro
           tt-remito.cidade          = rma.nom-cidade
           tt-remito.uf              = rma.nom-estado
           tt-remito.pais            = rma.nom-pais
           tt-remito.cep             = rma.cod-cep
           tt-remito.caixa-postal    = rma.cod-caixa-postal
           tt-remito.ind-atualizado  = yes
           tt-remito.nome-trans      = rma.cod-transp
           tt-remito.ind-ori-doc     = 4 /* RMA */
           tt-remito.cod-rma         = rma.cod-rma.

    for each rma-item where
             rma-item.cod-rma       = rma.cod-rma     and
             rma-item.cod-estabel   = rma.cod-estabel and
             rma-item.qtd-devolver <> 0 no-lock:

        /* Localiza o £ltimo item do remito para setar o n£mero da sequencia */
        find last tt-it-remito where
                  tt-it-remito.nr-remito   = tt-remito.nr-remito and
                  tt-it-remito.serie       = tt-remito.serie     and
                  tt-it-remito.cod-estabel = tt-remito.cod-estabel no-lock no-error.

        if  avail tt-it-remito then
            assign i-seq-rmt = i-seq-rmt + 10.
        else
            assign i-seq-rmt = 10.

        create tt-it-remito.
        assign tt-it-remito.marca         = "X"
               tt-it-remito.nr-remito     = tt-remito.nr-remito
               tt-it-remito.cod-estabel   = tt-remito.cod-estabel
               tt-it-remito.serie         = tt-remito.serie
               tt-it-remito.nr-seq-item   = i-seq-rmt
               tt-it-remito.it-codigo     = rma-item.cod-item
               tt-it-remito.cod-refer     = rma-item.cod-refer               
               tt-it-remito.nome-abrev    = tt-remito.nome-abrev
               tt-it-remito.un            = rma-item.cod-un
               tt-it-remito.nat-operacao  = tt-remito.nat-operacao
               tt-it-remito.cod-transacao = 1
               tt-it-remito.nr-pedcli     = "" /* Remito sem pedido */
               tt-it-remito.qt-pedida     = rma-item.qtd-devolver
               tt-it-remito.cod-situacao  = 1.

        for each rma-it-dep where
                 rma-it-dep.cod-rma     = rma-item.cod-rma     and
                 rma-it-dep.cod-estabel = rma-item.cod-estabel and
                 rma-it-dep.cod-item    = rma-item.cod-item    and
                 rma-it-dep.num-sequencia = rma-item.num-sequencia no-lock:

            create tt-it-dep-remito.
            assign tt-it-dep-remito.nr-remito    = tt-it-remito.nr-remito
                   tt-it-dep-remito.serie        = tt-it-remito.serie
                   tt-it-dep-remito.cod-estabel  = tt-it-remito.cod-estabel
                   tt-it-dep-remito.nome-abrev   = tt-it-remito.nome-abrev
                   tt-it-dep-remito.cod-depos    = rma-it-dep.cod-depos
                   tt-it-dep-remito.cod-localiz  = rma-it-dep.cod-localiz
                   tt-it-dep-remito.it-codigo    = tt-it-remito.it-codigo
                   tt-it-dep-remito.nr-seq-item  = tt-it-remito.nr-seq-item
                   tt-it-dep-remito.nr-serlote   = rma-it-dep.lote
                   tt-it-dep-remito.qt-pedida    = rma-it-dep.qtd-a-receber
                   tt-it-dep-remito.un           = tt-it-remito.un.
        end.
    end.

    run ftp/ftapi063.p (input-output table tt-remito,
                        input-output table tt-it-remito,
                        input-output table tt-it-dep-remito,
                        output       table tt-rem-gerado,
                        input        no ).

    /* Remitos Gerados */
    for each tt-rem-gerado:

        find remito where rowid(remito) = tt-rem-gerado.rw-remito no-lock no-error.

        if  avail remito then do:

            create tt-rd-gerados.
            assign tt-rd-gerados.rw-remito = rowid(remito)
                   tt-rd-gerados.nr-remito = remito.nr-remito.

        end.
    end.

    /* Se encontrou pelo menos um remito gerado ent∆o atualiza a situaá∆o de Remito da RMA */
    if  can-find (first tt-rem-gerado) then do:

        /*------------------------------------------------*/
        /* Atualizaá∆o do n£mero e sÇrie do Remito no RMA */
        /*------------------------------------------------*/
        /* Conforme FO 856228 - Foresight                 */
        /*------------------------------------------------*/

        /* Atualiza o flag RD na tabela RMA */
        FIND FIRST tt-remito NO-ERROR.
        IF AVAIL tt-remito THEN
           run updateFlagDevolutionPckSlip in h-bodi317int (input rowid(rma),
                                                            INPUT remito.nr-remito,
                                                            INPUT tt-remito.serie,
                                                            output l-proc-ok-aux).

    end.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE finishDBOs DBOFunction 
PROCEDURE finishDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    run finalizaBOS in h-bodi317in.

    if  valid-handle(bo-ped-item) then do:
        delete procedure bo-ped-item.
        assign bo-ped-item = ?.
    end.    

    if  valid-handle(bo-ped-item-sdf) then do:
        delete procedure bo-ped-item-sdf.
        assign bo-ped-item-sdf = ?.
    end.

    if  valid-handle(bo-ped-venda) then do:
        delete procedure bo-ped-venda.
        assign bo-ped-venda = ?.
    end.    

    if  valid-handle(bo-ped-venda-sdf) then do:
        delete procedure bo-ped-venda-sdf.
        assign bo-ped-venda-sdf = ?.
    end.

    if  valid-handle(bo-ped-repre) then do:
        delete procedure bo-ped-repre.
        assign bo-ped-repre = ?.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InputRowObject DBOFunction 
PROCEDURE InputRowObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param table for rowObject.

  FIND FIRST rowObject NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OutputCreatedTables DBOFunction 
PROCEDURE OutputCreatedTables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def output param table for tt-nc-geradas.
def output param table for tt-nd-geradas.
def output param table for tt-pv-gerados.
def output param table for tt-rd-gerados.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OutputRowErrors DBOFunction 
PROCEDURE OutputRowErrors :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def output param table for rowErrors.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OutputRowObject DBOFunction 
PROCEDURE OutputRowObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def output param table for rowObject.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SalesOrderGeneration DBOFunction 
PROCEDURE SalesOrderGeneration :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Definiá∆o de ParÉmetros */
def input param p-c-cod-rma     as char no-undo.
def input param p-c-cod-estabel as char no-undo.

/* Definiá∆o de Vari†veis */
def var i-pedido     as int  no-undo.
def var i-seq-item   as int  no-undo.

/* Localiza RMA */
if  not avail rma or
    (rma.cod-rma     <> p-c-cod-rma and
     rma.cod-estabel <> p-c-cod-estabel) then do:

    find first rma where
               rma.cod-rma     = p-c-cod-rma and
               rma.cod-estabel = p-c-cod-estabel no-lock no-error.
end.

do trans:

    /* Cria tabela de parÉmetros para criaá∆o do pedido de venda/item do pedido de venda */
    create tt-ped-param.
    assign tt-ped-param.relacao-item-cli     = yes
           tt-ped-param.tp-relacao-item-cli  = 1
           tt-ped-param.qtde-un-medida-cli   = yes
           tt-ped-param.multiplicar-qtde     = yes
           tt-ped-param.atribuir-preco-comp  = no
           tt-ped-param.tp-exp-nat-oper      = 1
           tt-ped-param.tp-exp-dt-entrega    = 1
           tt-ped-param.exp-nat-cons-final   = no
           tt-ped-param.exp-nat-cod-mensagem = yes
           tt-ped-param.atualizar-entregas   = yes
           tt-ped-param.arredondar-qtde-lote = no
           tt-ped-param.gerar-proc-exp       = no
           tt-ped-param.itinerario           = 1.
 
    /* Cria tabela tempor†ria do pedido de venda para troca */
    create tt-ped-venda.    

    /* Retorna N£mero do Pedido de Venda do cliente */
    run setDefaultOrderNumber in bo-ped-venda-sdf (output i-pedido).

    find first emitente where
               emitente.cod-emitente = rma.cdn-emitente no-lock no-error.

    assign tt-ped-venda.nr-pedido   = i-pedido
           tt-ped-venda.nr-pedcli   = string(i-pedido)
           tt-ped-venda.nome-abrev  = emitente.nome-abrev
           tt-ped-venda.log-cotacao = no
           {&tt-ped-venda.cod-rma}  = rma.cod-rma.

    /* Atualizaá∆o de Registros */
    run inputTable         in bo-ped-venda-sdf (input table tt-ped-venda).
    run setDefaultCustomer in bo-ped-venda-sdf.
    run outputTable        in bo-ped-venda-sdf (output table tt-ped-venda).    

    find first tt-ped-venda no-error.
    assign tt-ped-venda.origem = 1.    

    /* Atualizaá∆o das Informaá‰es do RMA do Pedido de Venda */
    run inputTable    in bo-ped-venda-sdf (input table tt-ped-venda).
    run setDefaultRMA in bo-ped-venda-sdf (input rma.cod-rma,
                                           input rma.cod-estabel).       

    /* ê necess†rio rodar novamente o procedimento de central de vendas, pois o estabelecimento
       pode ter sido alterado com as informaá‰es do RMA */    

    run setDefaultCentralSales in bo-ped-venda-sdf.
    run outputTable            in bo-ped-venda-sdf (output table tt-ped-venda).
    
    /* Efetiva as informaá‰es da tabela tempor†ria na tabela PED-VENDA */

    run emptyRowErrors  in bo-ped-venda.
    run openQueryStatic in bo-ped-venda (input "Default":U).
    run setRecord       in bo-ped-venda (input table tt-ped-venda).
    run createRecord    in bo-ped-venda.
   
    run getRowErrors   in bo-ped-venda (output table RowErrors).    

    if  can-find(first RowErrors where
                       RowErrors.ErrorSubType = "Error":U) THEN DO:

        for each rowerrors:
            create tt-erros-pv.
            assign tt-erros-pv.cod-erro  = rowerrors.errorNumber
                   tt-erros-pv.cod-param = rowerrors.errorParameters.

            delete rowErrors.
        end.

        undo, return no-apply.
    END.

    /* Gera Representantes */
    run dibo/bodi157.p persistent set bo-ped-repre.
    find first tt-ped-venda no-error.
    run getRowid in bo-ped-venda (output tt-ped-venda.r-rowid).
    run createOrdersRepresentatives in bo-ped-repre(input tt-ped-venda.r-rowid).    

    delete procedure bo-ped-repre.
    assign bo-ped-repre = ?.

    /* Instancia BO de defaults dos itens do pedido de venda */
    if  not valid-handle(bo-ped-item-sdf) then
        run dibo/bodi154sdf.p persistent set bo-ped-item-sdf.    

    /* Localiza a tabela tempor†ria do pedido de venda criado */
    find first tt-ped-venda no-error.

    /* Cria os itens do pedido de venda com base nos itens de troca */
    for each rma-it-troca where
             rma-it-troca.cod-rma     = rma.cod-rma     and
             rma-it-troca.cod-estabel = rma.cod-estabel and
             rma-it-troca.cod-pedcli  = "" exclusive-lock:

        /* Elimina a tabela tempor†ria dos itens */
        for each tt-ped-item:
            delete tt-ped-item.
        end.

        /* Localiza o item do rma que originou a troca */
        find first rma-item where
                   rma-item.cod-rma       = rma-it-troca.cod-rma     and
                   rma-item.cod-estabel   = rma-it-troca.cod-estabel and
                   rma-item.num-sequencia = rma-it-troca.num-sequencia no-lock no-error.

        if  avail rma-item then do:            

            /* Procura o £ltimo item criado para o pedido para saber qual a sequencia que o item
               deve ser criado */
            find last ped-item where
                      ped-item.nr-pedcli  = tt-ped-venda.nr-pedcli and
                      ped-item.nome-abrev = tt-ped-venda.nome-abrev no-lock no-error.
            if  avail ped-item then
                assign i-seq-item = i-seq-item + 10.
            else
                assign i-seq-item = 10.            

            /* Cria tabela tempor†ria dos itens do pedido */
            create tt-ped-item.
            assign tt-ped-item.nome-abrev    = tt-ped-venda.nome-abrev
                   tt-ped-item.nr-pedcli     = tt-ped-venda.nr-pedcli
                   tt-ped-item.nr-sequencia  = i-seq-item
                   tt-ped-item.it-codigo     = rma-it-troca.cod-item
                   tt-ped-item.cod-refer     = rma-it-troca.cod-refer
                   tt-ped-item.qt-pedida     = rma-it-troca.qtd-pedida
                   &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
                   tt-ped-item.qt-un-fat     = rma-it-troca.qtd-pedida * (rma-item.dec-ftconv-unest / exp(10, rma-item.num-casa-dec-unest))
                   &else
                   tt-ped-item.qt-un-fat     = rma-it-troca.qtd-pedida / (rma-item.dec-ftconv-unest / exp(10, rma-item.num-casa-dec-unest))
                   &ENDIF
                   tt-ped-item.des-un-medida = rma-it-troca.cod-un
                   tt-ped-item.qt-log-aloca  = 0
                   tt-ped-item.vl-preori     = rma-it-troca.val-preuni
                   tt-ped-item.vl-pretab     = rma-it-troca.val-pretab
                   tt-ped-item.nr-tabpre     = rma-it-troca.cod-tabpre.
            
            /* Executa a criaá∆o dos defaults */
            run inputTable in bo-ped-item-sdf (input table tt-ped-item).
            run setDefaultItem in bo-ped-item-sdf.
            run outputTable in bo-ped-item-sdf (output table tt-ped-item).
    
            /* Grava informaá‰es na tabela */
            find first tt-ped-item no-error.
            assign tt-ped-item.ind-origem-fator = 2.

            /* Atualizaá∆o das Informaá‰es do RMA do Item do Pedido de Venda */
            run inputTable        in bo-ped-item-sdf (input table tt-ped-item).            

            run setDefaultItemRMA in bo-ped-item-sdf (input rowid(rma-it-troca)).

            run outputTable       in bo-ped-item-sdf (output table tt-ped-item).
            find first tt-ped-item no-error.

            /* Efetiva as informaá‰es da tabela tempor†ria na tabela PED-ITEM */
            
            run openQueryStatic in bo-ped-item (input "Default":U).
            run inputRowParam   in bo-ped-item (input table tt-ped-param).
            run emptyRowErrors  in bo-ped-item.
            run setRecord       in bo-ped-item (input table tt-ped-item).
            run createRecord    in bo-ped-item.
            run getRowErrors    in bo-ped-item (output table RowErrors).
    
            if  can-find(first RowErrors where
                               RowErrors.ErrorSubType = "Error":U) THEN DO:
        
                for each rowerrors:
                    create tt-erros-pv.
                    assign tt-erros-pv.cod-erro  = rowerrors.errorNumber
                           tt-erros-pv.cod-param = rowerrors.errorParameters.
        
                    delete rowErrors.
                end.
        
                undo, return no-apply.
            END.

            /* Grava o n£mero do pedido de venda gerado no RMA-IT-TROCA */
            find first tt-ped-item no-error.
            assign rma-it-troca.cod-pedcli  = tt-ped-item.nr-pedcli
                   rma-it-troca.num-seq-ped = tt-ped-item.nr-sequencia.
        end.
    end.    
    
    find first tt-ped-venda no-error.
    find first ped-venda where
               ped-venda.nr-pedcli  = tt-ped-venda.nr-pedcli and
               ped-venda.nome-abrev = tt-ped-venda.nome-abrev no-lock no-error.
    if  avail ped-venda then do:           
        create tt-pv-gerados.
        assign tt-pv-gerados.rw-ped-venda = rowid(ped-venda)
               tt-pv-gerados.nr-pedido    = ped-venda.nr-pedcli.
    end.    

    /* Se encontrou pelo menos um pedido de venda gerado
    ** ent∆o atualiza situaá∆o de Pedido de Venda no RMA */
    if  can-find(first tt-pv-gerados) then do:
        /* Atualiza o flag PV na tabela RMA */
        find current rma exclusive-lock no-error.
        if  avail rma THEN
            assign {&TRUE-log-pedido-rma}.
    end.

    if  valid-handle(bo-ped-item) then do:
        delete procedure bo-ped-item.
        assign bo-ped-item = ?.
    end.

    if  valid-handle(bo-ped-item-sdf) then do:
        delete procedure bo-ped-item-sdf.
        assign bo-ped-item-sdf = ?.
    end.    
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE seta-acompanhamento DBOFunction 
PROCEDURE seta-acompanhamento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-l-seta as log no-undo.

/* Inicializa o acompanhamento*/
if  p-l-seta then do:
    run utp/ut-acomp.p persistent set h-acomp.
    run pi-inicializar        in h-acomp (input "Atualizaá∆o da RMA").
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Atualizando_RMA" *}
    run pi-acompanhar         in h-acomp (input RETURN-VALUE).
    run pi-desabilita-cancela in h-acomp.
end.
else do:
    /* Finaliza o acompanhamento */
    if  valid-handle(h-acomp) then
        run pi-finalizar in h-acomp.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startDBOs DBOFunction 
PROCEDURE startDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Inicializa DBO's utilizadas para geraá∆o das notas fiscais */
    run dibo/bodi317in.p  persistent set h-bodi317in.
    run dibo/bodi317int.p persistent set h-bodi317int.

    run emptyRowErrors in h-bodi317in.
    run emptyRowErrors in h-bodi317int.    
    
    run inicializaBOs in h-bodi317in (output h-bodi317pr,
                                      output h-bodi317sd,
                                      output h-bodi317im1br,
                                      output h-bodi317va).


    run setaHandlesBOS in h-bodi317int (input h-bodi317pr,
                                        input h-bodi317sd, 
                                        input h-bodi317im1br, 
                                        input h-bodi317va).
                                      
    
    /* Inicializa as DBO's utilizadas para geraá∆o dos pedidos de venda */
    run dibo/bodi159sdf.p persistent set bo-ped-venda-sdf.
    run dibo/bodi159.p    persistent set bo-ped-venda.
    run dibo/bodi154sdf.p persistent set bo-ped-item-sdf.
    run dibo/bodi154.p    persistent set bo-ped-item.
    
    
    /* Inicializa as DBO's utilizadas para geraá∆o dos remitos de devoluá∆o */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRMA DBOFunction 
PROCEDURE updateRMA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Definiá∆o de parÉmetros */
def input param p-c-cod-rma     as char no-undo.
def input param p-c-cod-estabel as char no-undo.

/* Definiá∆o de vari†veis */
def var l-proc-ok-aux as log    no-undo.
def var h-re32013     as handle no-undo.

def var l-nota-debito      as log init no no-undo.
def var l-nota-credito     as log init no no-undo.
def var l-pedido-venda     as log init no no-undo.
def var l-remito-devolucao as log init no no-undo.

find first para-fat no-lock no-error.

/* Inicializa DBO's utilizadas para geraá∆o das notas fiscais */
run startDBOs.

/* Inicializa o Acompanhamento */
run seta-acompanhamento (input yes).

/* Elimina Temp-Tables */
run deleteErrors.

/* Processamento - Geraá∆o dos Documentos*/

find first rma where
           rma.cod-rma     = p-c-cod-rma and
           rma.cod-estabel = p-c-cod-estabel no-error.

if  avail rma and
          rma.cdn-situacao = 5 then do:

    /****** NOTA DE CRêDITO ******/    

    if rma.cod-nota-fisc-ncredito = "" then do: /* Ainda n∆o gerou NC */

        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Gerando_Nota_de_CrÇdito._RMA" *}
        run pi-acompanhar in h-acomp (input RETURN-VALUE + ": " + rma.cod-rma).

        /* Se existem quantidades a creditar ser† gerada uma nota de crÇdito */

        if can-find (first rma-item where
                           rma-item.cod-rma         = rma.cod-rma     and
                           rma-item.cod-estabel     = rma.cod-estabel and
                           rma-item.qtd-creditada  <> 0) then do:

            assign l-nota-credito = yes.

            /* N∆o pode gerar nota de crÇdito se existirem erros na nota de dÇbito
               Erro 27267: Este erro Ç uma exceá∆o */

            find first tt-erros-nd where
                       tt-erros-nd.cod-erro <> 27267 no-error.

            if  not avail tt-erros-nd then
                run CreditNoteGeneration (input rma.cod-rma,
                                          input rma.cod-estabel).
            else do:

                /* Existiu algum erro na ND e n∆o poder† ser gerada a NC */
                create tt-erros-nc.
                assign tt-erros-nc.cod-erro  = 27280
                       tt-erros-nc.cod-param = "".
            end.
        end.
    end.
    else do:
        create tt-erros-nc.
        assign tt-erros-nc.cod-erro  = 27268
               tt-erros-nc.cod-param = "".
    end.

    /****** NOTA DE DêBITO ******/

    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Gerando_Nota_de_DÇbito._RMA" *}
    run pi-acompanhar in h-acomp (input RETURN-VALUE + ": " + rma.cod-rma).

    /* Se ainda n∆o gerou ND */
    if {&rma.cod-nota-debito} = "" then do:

        /* Gera Nota de DÇbito com o valor da restocagem ou das Despesas do RMA */
        if can-find (first rma-item where
                           rma-item.cod-rma               = rma.cod-rma     and
                           rma-item.cod-estabel           = rma.cod-estabel and
                           (rma-item.val-restocagem      <> 0 OR 
                            rma-item.val-perc-restocagem <> 0)) then do:

            assign l-nota-debito = yes.

            assign l-somente-despesa = no. /* A nota n∆o ser† somente de despesa porque
                                              existem valores de reestocagem gravados no
                                              item do RMA */

            run DebitNoteGeneration (input rma.cod-rma,
                                     input rma.cod-estabel).
        end.

        IF NOT CAN-FIND (funcao WHERE funcao.cd-funcao = "spp-desp-rma-ncr"
                                AND   funcao.ativo = YES) THEN DO:

            IF NOT can-find (first rma-item where
                   rma-item.cod-rma               = rma.cod-rma     and
                   rma-item.cod-estabel           = rma.cod-estabel and
                   (rma-item.val-restocagem      <> 0 OR 
                    rma-item.val-perc-restocagem <> 0)) then do:

                /* Sen∆o achou, porÇm encontrou despesas relacionadas ao RMA, tambÇm vai gerar ND*/
                find first rma-desp where
                           rma-desp.cod-rma     = rma.cod-rma and
                           rma-desp.cod-estabel = rma.cod-estabel no-lock no-error.
    
                if  avail rma-desp then do:
    
                    assign l-nota-debito = yes.
                    
                    assign l-somente-despesa = yes. /* A nota ser† somente de despesa porque n∆o
                                                       existem valores de reestocagem gravados no 
                                                       item do RMA */
    
                    run DebitNoteGeneration (input rma.cod-rma,
                                             input rma.cod-estabel).
                end.
            end.
        END.

    end.
    else do:
        /* Nota de DÇbito j† gerada para a RMA. */
        create tt-erros-nd.
        assign tt-erros-nd.cod-erro  = 27267
               tt-erros-nd.cod-param = "".
    end.

    /****** E-MAIL ******/

    /* Para Nota de DÇbito */
    if  (l-nota-debito and {&rma.cod-nota-debito} <> "") then do:
    
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Enviando_E-mail" *}
        run pi-acompanhar in h-acomp (input RETURN-VALUE + ".").

        /* Envia e-mail para nota de dÇbito gerada */
        if  rma.log-e-mail-notas then
            run sendEmailRMA in h-bodi317int (input  rowid(rma),
                                              input  9,
                                              output l-proc-ok-aux).
    end.

    /* Para Nota de CrÇdito */
    if  (l-nota-credito and rma.cod-nota-fisc-ncredito <> "") then do:
    
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Enviando_E-mail" *}
        run pi-acompanhar in h-acomp (input RETURN-VALUE + ".").

        /* Envia e-mail para nota de crÇdito gerada */
        if  rma.log-e-mail-notas then
            run sendEmailRMA in h-bodi317int (input  rowid(rma),
                                              input  10,
                                              output l-proc-ok-aux).
    end.

    /****** REMITO DE DEVOLUÄ«O ******/

    if  {&rma.cod-remito} = "" then do:
    
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Gerando_Remito_de_Devoluá∆o._RMA" *}
        run pi-acompanhar in h-acomp (input RETURN-VALUE + ": " + rma.cod-rma).

        /* Se existem quantidades a devolver ser† gerado o remito de devoluá∆o */
        if can-find (first rma-item where
                           rma-item.cod-rma         = rma.cod-rma     and
                           rma-item.cod-estabel     = rma.cod-estabel and
                           rma-item.qtd-devolver   <> 0) then do:

            assign l-remito-devolucao = yes.

            run DevolutionPckSlipGeneration (input rma.cod-rma,
                                             input rma.cod-estabel).
        end.
    end.
    else do:
        create tt-erros-rd.
        assign tt-erros-rd.cod-erro  = 27270
               tt-erros-rd.cod-param = "".
    end.

    /****** PEDIDO DE VENDA ******/

    /* Se encontra algum item de troca para o RMA, gera pedido de venda */
    if  can-find (first rma-it-troca where
                        rma-it-troca.cod-rma       = rma.cod-rma     and
                        rma-it-troca.cod-estabel   = rma.cod-estabel and
                        rma-it-troca.cod-pedcli     = "") then do:

        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Gerando_Pedido_de_Venda._RMA" *}
        run pi-acompanhar in h-acomp (input RETURN-VALUE + ": " + rma.cod-rma).
        
        assign l-pedido-venda = yes.

        run SalesOrderGeneration (input rma.cod-rma,
                                  input rma.cod-estabel).
    end.

    /****** ATUALIZAÄ«O DO STATUS DO RMA ******/

    /* Atualiza o Status do RMA para Encerrado */
    if  ((l-nota-debito      and {&rma.cod-nota-debito}          <> "") or not l-nota-debito)      and
        ((l-nota-credito     and rma.cod-nota-fisc-ncredito      <> "") or not l-nota-credito)     and
        ((l-remito-devolucao and {&rma.cod-remito}               <> "") or not l-remito-devolucao) and
        ((l-pedido-venda     and {&TRUE-log-pedido-rma})                or not l-pedido-venda) then do:
      
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Atualizando_Status_da_RMA" *}
        run pi-acompanhar in h-acomp (input RETURN-VALUE + ".").

        run updateStatusRMA in h-bodi317int (input rma.cod-rma,
                                             input rma.cod-estabel,
                                             output l-proc-ok-aux).
    end.                                                 
    
    if ((l-nota-debito      and {&rma.cod-nota-debito}          <> "") or can-find (first tt-erros-nd)) or
       ((l-nota-credito     and rma.cod-nota-fisc-ncredito      <> "") or can-find (first tt-erros-nc)) or
       ((l-remito-devolucao and {&rma.cod-remito}               <> "") or can-find (first tt-erros-rd)) or 
       ((l-pedido-venda     and {&TRUE-log-pedido-rma})                or can-find (first tt-erros-pv)) then do:
        
        /****** RELAT‡RIO DE ACOMPANHAMENTO ******/
    
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Gerando_Relat¢rio_de_Acompanhamento" *}
        run pi-acompanhar in h-acomp (input RETURN-VALUE + ".").
        run rep/re32013.w persistent set h-re32013 (input table tt-erros-nc,
                                                    input table tt-erros-nd,
                                                    input table tt-erros-pv,
                                                    input table tt-erros-rd,
                                                    input table tt-nc-geradas,
                                                    input table tt-nd-geradas,
                                                    input table tt-pv-gerados,
                                                    input table tt-rd-gerados,
                                                    input rma.cod-rma).
        run initializeRun in h-re32013.
    end.
    
    

end.

/* Finaliza Acompanhamento */
run seta-acompanhamento (input no).

/* Inicializa DBO's utilizadas para geraá∆o das notas fiscais */
run finishDBOs.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


