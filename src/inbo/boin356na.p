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
{include/i-prgvrs.i BOIN356NA 2.00.00.020 } /*** "010020" 17/06/2025 16:40:48 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin356na MUT}
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
&GLOBAL-DEFINE DBOVersion 20000000
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


/******************************ATENCAO*************************************
 Pre-processador abaixo responsavel por distinguir o produto que
 esta executando o componente ( Magnus ou EMS ). 
 Se estiver definida a variavel bf-mat-comex 
 ( &if defined(bf-mat-comex) &then  &endif ), significa que o produto
 chamador e o Magnus se n∆o, EMS. Utilizado pelo produto Comercio Exterior
**************************************************************************/ 
/* Definicao de pre-processadores - Magnus ou EMS */
{cdp/cdcfgmat.i}

/* Include com prÇ-processadores que diferenciam releases */
{cdp/cdcfgman.i}

/* Include com prÇ-processadores que diferenciam releases */
{cdp/cdcfgman.i}
{include/i_dbvers.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def buffer b-prazo for prazo-compra.
def buffer b-ordem for ordem-compra.

/********* Multi-Planta ***********/
def var i-tipo-movto as integer no-undo.
def var l-cria as logical no-undo.

{cdp/cd7300.i1}
{cdp/cd7300.i2}
{mpp/mpapi011.i}
{cdp/cd9730.i "new"} /* define temp-table t-invest */
/************** Fim ***************/

def var iNumOrdem  as int no-undo initial 0.
def var iNumPedido as int no-undo initial 0.
def var rChave     as rowid no-undo.
def var rChavePai  as rowid no-undo.
def var rChave-aux as rowid no-undo.
def var iParcI     as int no-undo initial 0.
def var iParcF     as int no-undo initial 999.
def var lNaoCon    as logical no-undo initial yes.
def var lConfir    as logical no-undo initial yes.
def var lCotada    as logical no-undo initial yes.
def var lElimin    as logical no-undo initial yes.
def var lEmCotacao as logical no-undo initial yes.
def var lTermin    as logical no-undo initial yes.
def var dDataEntrega    as date    no-undo initial &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF.
def var dDataEntregaFim as date    no-undo init 12/31/9999.
def var icod-comprado   as char    no-undo.
def var h-boin356       as handle  no-undo.
def var c-seg-usuario   as char    no-undo.

/* Integraá∆o Investimento */
def var h-boiv037       as handle  no-undo.
def var h-boiv028       as handle  no-undo.

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
         HEIGHT             = 1.85
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


{method/svc/autentic/autentic.i 
            &vUserName="c-seg-usuario"}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaParcelaPrazoCompra DBOProgram 
PROCEDURE eliminaParcelaPrazoCompra :
/*---
  Parameters:
     ipar1 : p-c-seg-usuario  : nome usuario corrente
     ipar2 : r-pedido-compr : rowid pedido de compra corrente
     ipar3 : r-row-ordem    : rowid ordem de compra
     ipar4 : r-prazo-comp   : rowid prazo compra
     ipar5 : c-motivo       : texto referente ao motivo da eliminaá∆o
---*/
    &if defined(bf-mat-comex) &then            
    &else     
        def input param p-c-seg-usuario  as char  no-undo.
        def input param r-pedido-compr as rowid no-undo.
        def input param r-row-ordem    as rowid no-undo.
        def input param r-prazo-comp   as rowid no-undo.
        def input param c-motivo       as char  no-undo.

        def var r-gerencial   as rowid no-undo.
        def var c-gerencial   as char  no-undo.
        def var l-elimina-ord as log   no-undo.
        def var c-literal-obs as char  no-undo.
        def var de-tot-quant-parc as dec no-undo.
        def var h-boin356ca   as handle no-undo.
        DEF VAR c-elimina     AS CHAR FORMAT "x(2000)" NO-UNDO.


        find first param-compra no-lock no-error.
        find first param-global no-lock no-error.

        find prazo-compra where rowid(prazo-compra) = r-prazo-comp   exclusive-lock no-error.
        find ordem-compra where rowid(ordem-compra) = r-row-ordem    exclusive-lock no-error.
        for first pedido-compr where 
            rowid(pedido-compr) = r-pedido-compr no-lock: end.

        for first item fields(it-codigo un) where 
            item.it-codigo = ordem-compra.it-codigo no-lock: end.
        for first emitente fields(cod-emitente prog-emit nome-abrev) where
            emitente.cod-emitente = ordem-compra.cod-emitente no-lock: end.

        if  param-global.modulo-ge then do:
            assign r-gerencial = rowid(prazo-compra)
                   c-gerencial = "elim-parcela".
            run gep/ge0102a.p(input r-gerencial, input 12).
        end.

        assign prazo-compra.situacao    = 4
               prazo-compra.usuario-alt = {cdp/cd7777.i}
               prazo-compra.data-alter  = today.               

        if param-global.modulo-in and
           ordem-compra.num-ord-inv <> 0 then do:
           run ivbo/boiv037.p persistent set h-boiv037.
           run DeleteProgEntr in h-boiv037 (input rowid(prazo-compra), 
                                            input-output table RowErrors).
           delete procedure h-boiv037.                                 
        end.              

        /*------------------------------------------ */    
        &if  "{&mgadm_version}" >= "2.04" &then
             /*API de Execucao Orcamentaria*/
    
             RUN cdp/cdapi183.p (INPUT ROWID(prazo-compra), /*rowid prazo-compra*/
                                 INPUT TABLE rowobject,     /*rowid do registro alterado*/
                                 INPUT 5,                   /*funcao: 1-BeforeDeleteRecord da Prazo-Compra*/
                                 OUTPUT TABLE Rowerrors APPEND).   /*tt que retorna erro*/
        &endif 
        assign ordem-compra.qt-acum-nec = ordem-compra.qt-acum-nec 
                                        - prazo-compra.quantidade.
               ordem-compra.qt-acum-nec = if  ordem-compra.qt-acum-nec < 0  
                                          then 0
                                          else ordem-compra.qt-acum-nec.

        if  pedido-compr.nr-contrato = 0 then do:
            for first comprador fields(cod-comprado corporativo) where 
                 comprador.cod-comprado = ordem-compra.cod-comprado no-lock: end.
            if  comprador.corporativo = no or param-compra.compra-centr then do:
                for first emitente fields(cod-emitente prog-emit nome-abrev) where
                     emitente.cod-emitente = pedido-compr.cod-emitente no-lock: end.
                if avail emitente and emitente.prog-emit = no then do:
                    find current emitente exclusive-lock.
                    assign emitente.prog-emit = yes.
                end.
            end.
        end.    
        assign l-elimina-ord = not (can-find (first b-prazo where 
                                               b-prazo.numero-ordem = ordem-compra.numero-ordem
                                               and b-prazo.situacao <> 4)).

        {utp/ut-liter.i Eliminaá∆o_de_Parcelas mcc R}
        assign c-literal-obs = return-value.
        create alt-ped.
        assign alt-ped.data         = today
               alt-ped.hora         = string(time,"HH:MM:SS")
               alt-ped.usuario      = {cdp/cd7777.i}
               alt-ped.num-pedido   = ordem-compra.num-pedido
               alt-ped.numero-ordem = ordem-compra.numero-ordem
               alt-ped.parcela      = prazo-compra.parcela
               alt-ped.nome-abrev   = emitente.nome-abrev
               alt-ped.cod-cond-pag = ?
               alt-ped.preco        = ?
               alt-ped.quantidade   = ?
               alt-ped.data-entrega = ?
               alt-ped.observacao   = "# " + c-literal-obs.
        if  param-global.modulo-pl or param-global.modulo-pi then do:
            /*usado p/planejamento*/
            run cdp/cd7000.p (input 0, input ordem-compra.it-codigo, input ordem-compra.cod-estabel).
        end.

        &if defined(bf_mat_compras_edi) &then
            /* Atualiza dados do pedido e da ordem
               possibilitando extrair novamente
               os dados do pedido no EDI         */
            assign ordem-compra.gera-edi = yes.   
            find first pedido-compr
                 where pedido-compr.num-pedido = ordem-compra.num-pedido exclusive-lock no-error.
                 if avail pedido-compr then 
                    assign pedido-compr.gera-edi = yes.
            find current pedido-compr no-lock no-error.
        &endif    

        if  l-elimina-ord then do:
            &if defined(bf_mat_contratos) &then
            if  ordem-compra.nr-contrato = 0 then do:
            &else
            if  ordem-compra.nr-contrato = "" then do:
            &endif
                assign ordem-compra.situacao = 4
                       ordem-compra.usuario = {cdp/cd7777.i}
                       ordem-compra.data-atualiz = today
                       ordem-compra.hora-atualiz = string(time,"hh:mm:ss")
                       ordem-compra.comentarios  = c-motivo.

               find current pedido-compr exclusive-lock.        

               IF ("{&mgadm_dbtype}" <> "PROGRESS") THEN DO:
                   ASSIGN c-elimina = pedido-compr.mot-elimina + chr(10) + 
                          chr(10) + "== " + "Usu†rio" + ": " + c-seg-usuario + 
                          " = " + "Ordem Eliminada" + ": " + string(ordem-compra.numero-ordem) + 
                          " = " + "Data:" + ": " + string(today,"99/99/9999") + " ======="
                          + chr(10) + c-motivo.       
        
                   assign pedido-compr.mot-elimina  = substring(c-elimina,1,2000).
               END.
               ELSE
                   assign pedido-compr.mot-elimina  = pedido-compr.mot-elimina + chr(10) + 
                          chr(10) + "== " + "Usu†rio" + ": " + c-seg-usuario + 
                          " = " + "Ordem Eliminada" + ": " + string(ordem-compra.numero-ordem) + 
                          " = " + "Data:" + ": " + string(today,"99/99/9999") + " ======="
                          + chr(10) + c-motivo.       

                if param-global.modulo-in and
                   ordem-compra.num-ord-inv <> 0 then do:
                   run ivbo/boiv028.p persistent set h-boiv028.
                   run DeleteOrdPed in h-boiv028 (input rowid(ordem-compra), 
                                                  input-output table RowErrors).
                   delete procedure h-boiv028.
                end.  

                {utp/ut-liter.i Eliminaá∆o_de_Ordens mcc R}
                assign c-literal-obs = return-value.
                create alt-ped.
                assign alt-ped.data = today
                       alt-ped.hora = string(time,"HH:MM:SS")
                       alt-ped.usuario = {cdp/cd7777.i}
                       alt-ped.num-pedido = ordem-compra.num-pedido
                       alt-ped.numero-ordem = ordem-compra.numero-ordem
                       alt-ped.nome-abrev   = emitente.nome-abrev
                       alt-ped.cod-cond-pag = ?
                       alt-ped.preco        = ?
                       alt-ped.quantidade   = ?
                       alt-ped.data-entrega = ?
                       alt-ped.observacao   = "# " + c-literal-obs.

                &if defined(bf_mat_compras_edi) &then
                    /* Atualiza dados do pedido e da ordem
                       possibilitando extrair novamente
                       os dados do pedido no EDI         */
                    assign ordem-compra.gera-edi = yes.   
                    find first pedido-compr
                         where pedido-compr.num-pedido = ordem-compra.num-pedido exclusive-lock no-error.
                         if avail pedido-compr then 
                            assign pedido-compr.gera-edi = yes.
                    find current pedido-compr no-lock no-error.
                &endif    

                for first b-ordem fields(num-pedido situacao) where 
                    b-ordem.num-pedido = pedido-compr.num-pedido and
                    b-ordem.situacao <> 4 no-lock: end.
                if  not available b-ordem then do:
                    find current pedido-compr exclusive-lock.
                    assign pedido-compr.situacao = 3.                    
                    assign pedido-compr.mot-elimina  = pedido-compr.mot-elimina + chr(10) + 
                          chr(10) + "== " + "Usu†rio" + ": " + c-seg-usuario + 
                          " = " + "Pedido Eliminado" + " = " + "Data:" + ": " 
                          + string(today,"99/99/9999") + " ==" + chr(10) + c-motivo.

                    {utp/ut-liter.i Eliminaá∆o_de_Pedidos mcc R}
                    assign c-literal-obs = return-value.
                    create alt-ped.
                    assign alt-ped.data = today
                           alt-ped.hora = string(time,"HH:MM:SS")
                           alt-ped.usuario    = {cdp/cd7777.i}
                           alt-ped.num-pedido = pedido-compr.num-pedido
                           alt-ped.nome-abrev = emitente.nome-abrev
                           alt-ped.cod-cond-pag = ?
                           alt-ped.preco        = ?
                           alt-ped.quantidade   = ?
                           alt-ped.data-entrega = ?
                           alt-ped.observacao = "# " + c-literal-obs.

                    &if defined(bf_mat_compras_edi) &then
                        /* Atualiza dados do pedido e da ordem
                           possibilitando extrair novamente
                           os dados do pedido no EDI         */
                        assign ordem-compra.gera-edi = yes.   
                        find first pedido-compr
                             where pedido-compr.num-pedido = ordem-compra.num-pedido exclusive-lock no-error.
                             if avail pedido-compr then 
                                assign pedido-compr.gera-edi = yes.
                        find current pedido-compr no-lock no-error.
                    &endif    

                end.
            end.
            else do:
                for last b-prazo fields(numero-ordem parcela      un  
                                        nome-abrev   pedido-clien nr-sequencia) where 
                    b-prazo.numero-ordem = ordem-compra.numero-ordem no-lock: end.

                for each rowObject:
                    delete rowObject.
                end.

                create rowObject.
                assign rowObject.parcela      = if not avail b-prazo then 1
                                                   else b-prazo.parcela + 1
                       rowObject.quantidade   = 0
                       rowObject.quant-saldo  = 0
                       rowObject.qtd-do-forn  = 0
                       rowObject.qtd-sal-forn  = 0
                       rowObject.it-codigo    = ordem-compra.it-codigo
                       rowObject.un           = if not avail b-prazo then item.un
                                                   else b-prazo.un
                       rowObject.data-entrega = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
                       rowObject.nome-abrev   = if not avail b-prazo then ""
                                                   else b-prazo.nome-abrev
                       rowObject.pedido-clien = if not avail b-prazo then ""
                                                   else b-prazo.pedido-clien
                       rowObject.nr-sequencia = if not avail b-prazo then 0
                                                   else b-prazo.nr-sequencia
                       rowObject.data-orig    = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
                       rowObject.numero-ordem = ordem-compra.numero-ordem
                       rowObject.situacao     = ordem-compra.situacao
                       rowObject.nr-contrato  = ordem-compra.nr-contrato
                       rowObject.cod-alter    = no.

                       RUN inbo/boin356.p persistent set h-boin356.
                       RUN openQueryStatic in h-boin356 ("Main":U).
                       run validateCreate in h-boin356 (input  table rowObject,
                                                        output table RowErrors,
                                                        output r-prazo-comp).
                       delete procedure h-boin356.

                       find prazo-compra where rowid(prazo-compra) = r-prazo-comp NO-LOCK no-error.
            end.
        end.
        else do:
            find current pedido-compr exclusive-lock no-error.
            assign pedido-compr.mot-elimina  = pedido-compr.mot-elimina + chr(10) + 
                   chr(10) + "== " + "Usu†rio" + ": " + c-seg-usuario + 
                   " = " + "Parcela Eliminada" + ": " + string(prazo-compra.parcela) + " - " 
                   + string(ordem-compra.numero-ordem) + 
                   " = " + "Data:" + ": " + string(today,"99/99/9999") + " =="
                   + chr(10) + c-motivo.
        end.

        if  ordem-compra.situacao = 2 then do:
            find first prazo-compra
                 where prazo-compra.numero-ordem = ordem-compra.numero-ordem
                   and prazo-compra.situacao     <> 6
                   and prazo-compra.situacao     <> 4 no-lock no-error.
            if  not available prazo-compra then do:                
                if  ordem-compra.nr-contrato = 0 then
                    assign ordem-compra.situacao = 6.
                else do:
                    for last b-prazo fields(numero-ordem parcela      un 
                                            nome-abrev   pedido-clien nr-sequencia) where 
                        b-prazo.numero-ordem = ordem-compra.numero-ordem no-lock: end.

                    for each rowObject:
                        delete rowObject.
                    end.

                    create rowObject.
                    assign rowObject.parcela      = if not avail b-prazo then 1
                                                        else b-prazo.parcela + 1
                           rowObject.quantidade   = 0
                           rowObject.quant-saldo  = 0
                           rowObject.qtd-do-forn  = 0
                           rowObject.qtd-sal-forn  = 0
                           rowObject.it-codigo    = ordem-compra.it-codigo
                           rowObject.un           = if not avail b-prazo then item.un
                                                       else b-prazo.un
                           rowObject.data-entrega = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
                           rowObject.nome-abrev   = if not avail b-prazo then ""
                                                       else b-prazo.nome-abrev
                           rowObject.pedido-clien = if not avail b-prazo then ""
                                                       else b-prazo.pedido-clien
                           rowObject.nr-sequencia = if not avail b-prazo then 0
                                                       else b-prazo.nr-sequencia
                           rowObject.data-orig    = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF
                           rowObject.numero-ordem = ordem-compra.numero-ordem
                           rowObject.situacao     = ordem-compra.situacao
                           rowObject.nr-contrato  = ordem-compra.nr-contrato
                           rowObject.cod-alter    = no.

                           RUN inbo/boin356.p persistent set h-boin356.
                           RUN openQueryStatic in h-boin356 ("Main":U).
                           run validateCreate in h-boin356 (input  table rowObject,
                                                            output table RowErrors,
                                                            output r-prazo-comp).
                           delete procedure h-boin356.

                           find prazo-compra where rowid(prazo-compra) = r-prazo-comp NO-LOCK no-error.
                end. 
            end.
        end.

        RUN inbo/boin356ca.p PERSISTENT SET h-boin356ca.
        RUN totalizaQuantidadeParcelasOrdem in h-boin356ca (input ordem-compra.numero-ordem,
                                                            output de-tot-quant-parc).
        DELETE PROCEDURE h-boin356ca.
                         h-boin356ca = ?.
        assign ordem-compra.qt-solic = de-tot-quant-parc.

        return "OK":U.
    &endif            
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
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "usuario-alt":U THEN ASSIGN pFieldValue = RowObject.usuario-alt.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "pedido-clien":U THEN ASSIGN pFieldValue = RowObject.pedido-clien.        
        &if defined(bf_mat_contratos) &then
        &else 
            WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato. 
        &endif      
        &if defined(bf-mat-comex) &then            
            WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.        
            WHEN "natureza":U THEN ASSIGN pFieldValue = RowObject.natureza.        
            WHEN "u-char-1":U THEN ASSIGN pFieldValue = RowObject.u-char-1.
            WHEN "u-char-2":U THEN ASSIGN pFieldValue = RowObject.u-char-2.        
        &else 
            WHEN "cc-codigo":U THEN ASSIGN pFieldValue = RowObject.cc-codigo. 
            WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.     
            WHEN "es-codigo":U THEN ASSIGN pFieldValue = RowObject.es-codigo.
            WHEN "item-cotacao":U THEN ASSIGN pFieldValue = RowObject.item-cotacao.
        &endif        
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
        WHEN "data-alter":U THEN ASSIGN pFieldValue = RowObject.data-alter.
        WHEN "data-entrega":U THEN ASSIGN pFieldValue = RowObject.data-entrega.
        WHEN "data-orig":U THEN ASSIGN pFieldValue = RowObject.data-orig.
        &if defined(bf-mat-comex) &then            
        &else
            WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
            WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.        
        &endif        
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
        WHEN "qtd-a-ped-forn":U THEN ASSIGN pFieldValue = RowObject.qtd-a-ped-forn.
        WHEN "qtd-do-forn":U THEN ASSIGN pFieldValue = RowObject.qtd-do-forn.
        WHEN "qtd-rec-forn":U THEN ASSIGN pFieldValue = RowObject.qtd-rec-forn.
        WHEN "qtd-rej-forn":U THEN ASSIGN pFieldValue = RowObject.qtd-rej-forn.
        WHEN "qtd-sal-forn":U THEN ASSIGN pFieldValue = RowObject.qtd-sal-forn.
        WHEN "quant-a-ped":U THEN ASSIGN pFieldValue = RowObject.quant-a-ped.
        WHEN "quant-receb":U THEN ASSIGN pFieldValue = RowObject.quant-receb.
        WHEN "quant-rejeit":U THEN ASSIGN pFieldValue = RowObject.quant-rejeit.
        WHEN "quant-saldo":U THEN ASSIGN pFieldValue = RowObject.quant-saldo.
        WHEN "quantid-orig":U THEN ASSIGN pFieldValue = RowObject.quantid-orig.
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
        WHEN "rendimento":U THEN ASSIGN pFieldValue = RowObject.rendimento.
        WHEN "concentracao":U THEN ASSIGN pFieldValue = RowObject.concentracao.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
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
        WHEN "hora":U THEN ASSIGN pFieldValue = RowObject.hora.
        WHEN "MRP":U THEN ASSIGN pFieldValue = RowObject.MRP.
        WHEN "nr-alt-data":U THEN ASSIGN pFieldValue = RowObject.nr-alt-data.
        WHEN "nr-alt-quant":U THEN ASSIGN pFieldValue = RowObject.nr-alt-quant.
        WHEN "nr-entrega":U THEN ASSIGN pFieldValue = RowObject.nr-entrega.
        WHEN "nr-sequencia":U THEN ASSIGN pFieldValue = RowObject.nr-sequencia.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "parcela":U THEN ASSIGN pFieldValue = RowObject.parcela.
        &if defined(bf_mat_contratos) &then
          when "nr-contrato" then ASSIGN pFieldValue = RowObject.nr-contrato.
        &endif                
        &if defined(bf-mat-comex) &then    
            WHEN "cc-codigo":U THEN ASSIGN pFieldValue = RowObject.cc-codigo.                
        &else
            WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.        
            WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.  
            WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
            WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.   
            WHEN "natureza":U THEN ASSIGN pFieldValue = RowObject.natureza.   
            WHEN "nr-estrut":U THEN ASSIGN pFieldValue = RowObject.nr-estrut.
            WHEN "nr-estrut-filha":U THEN ASSIGN pFieldValue = RowObject.nr-estrut-filha.                                        
        &endif                
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ORDEM
  Parameters:
               retorna valor dos campos do °ndice ORDEM
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then    
    &else
        DEFINE OUTPUT PARAMETER pnumero-ordem LIKE prazo-compra.numero-ordem NO-UNDO.
        DEFINE OUTPUT PARAMETER pparcela LIKE prazo-compra.parcela NO-UNDO.

        /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
              retornada flag "NOK":U ---*/
        IF NOT AVAILABLE RowObject THEN
           RETURN "NOK":U.

        ASSIGN pnumero-ordem = RowObject.numero-ordem
               pparcela = RowObject.parcela.

        RETURN "OK":U.
    &endif
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
        WHEN "cod-alter":U THEN ASSIGN pFieldValue = RowObject.cod-alter.
        WHEN "cons-mrp":U THEN ASSIGN pFieldValue = RowObject.cons-mrp.
        WHEN "cons-pmp":U THEN ASSIGN pFieldValue = RowObject.cons-pmp.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        &if defined(bf-mat-comex) &then    
        &else
            WHEN "expectativa":U THEN ASSIGN pFieldValue = RowObject.expectativa.        
            WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
            WHEN "ordem-emitida":U THEN ASSIGN pFieldValue = RowObject.ordem-emitida.            
        &endif        
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
    &if defined(bf-mat-comex) &then    
    &else
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
    &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice ORDEM
  Parameters:
               recebe valor dos campos do °ndice ORDEM
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnumero-ordem LIKE prazo-compra.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER pparcela LIKE prazo-compra.parcela NO-UNDO.

    for first bfprazo-compra fields(numero-ordem parcela) WHERE
        bfprazo-compra.numero-ordem = pnumero-ordem AND
        bfprazo-compra.parcela = pparcela
        NO-LOCK: end.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inputTable DBOProgram 
PROCEDURE inputTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*
  Permite o recebimento da tabela de dados (Prazo-Compra)
  ParÉmetros:
  ipar1 : table for rowObject : Tabela de Dados
*/
 def input param table for rowObject.
 find first rowObject no-error.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then do:
           run openQueryStatic (input "main":U).
        end.   
        &if defined(bf-mat-comex) &then    
        &else        
            when 7 then do:
               run openQueryStatic (input "byNumOrdembyParcela":U).
            end.
        &endif
    end. /*end case*/
   RETURN "OK":U.     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerybyNumOrdembyParcela DBOProgram 
PROCEDURE openQuerybyNumOrdembyParcela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then    
    &else
        open query {&QueryName} for each {&TableName} where
                                         {&TableName}.numero-ordem = iNumOrdem and 
                                         {&TableName}.data-entrega >= dDataEntrega and 
                                         {&TableName}.data-entrega <= dDataEntregaFim and
                                         {&TableName}.parcela >= iParcI  and 
                                         {&TableName}.parcela <= iParcF  and 
                                         (({&TableName}.situacao   = 1 and lNaoCon) OR 
                                         ({&TableName}.situacao    = 2 and lConfir) OR 
                                         ({&TableName}.situacao    = 3 and lCotada) OR 
                                         ({&TableName}.situacao    = 4 and lElimin) OR 
                                         ({&TableName}.situacao    = 5 and lEmCotacao) OR 
                                         ({&TableName}.situacao    = 6 and lTermin)) no-lock
                                         indexed-reposition.
    &endif                                         
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint7 DBOProgram 
PROCEDURE setConstraint7 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if defined(bf-mat-comex) &then    
    &else
        def input param p-numero-ordem as int no-undo.
        run setConstraintNumOrdem (input p-numero-ordem).
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNumOrdem DBOProgram 
PROCEDURE setConstraintNumOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*Par∆metros:
           ipar1  : piNumOrdem : Numero da ordem corrente da interface.
*/

    &if defined(bf-mat-comex) &then    
    &else
        def input param piNumOrdem as int no-undo.

        assign iNumOrdem = piNumOrdem.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCreateOld DBOProgram 
PROCEDURE validateCreateOld :
/******************************ATENCAO*************************************
O NOME DESSA PROCEDURE FOI ALTERADO.
SE VC ESTµ MANUTENINDO O PROGRAMA QUE A UTILIZA, 
MUDE O NOME DA PROCEDURE E PASSE ESSA PROCEDURE PARA A BOIN356,
PARA QUE POSSAMOS ELIMINAR ESSA BOIN356NA.

Data do Coment†rio: 13/07.
Prazo para Mudanáa: 13/08. (Ap¢s essa data essa procedure ser† eliminada)

Corrija nessa procedure a chamada "run executeCreatePedEmerg.",
pois essa procedure n∆o existe.

**************************************************************************/ 

/*------------------------------------------------------------------------------
  Purpose:     
   Valida criaá∆o da tabela/duplicidade de registro.
  Parameters:
   ipar1 : table for rowObject : Tabela de dados
   opar2 : table for tt-erro   : Tabela de erros
   opar3 : r-chave             : Rowid do registro criado
  Notes:       
------------------------------------------------------------------------------*/
   def input  param table   for RowObject.
   def output param table   for RowErrors.
   def output param r-chave as rowid no-undo.

   for each RowErrors:
       delete RowErrors.
   end.

   IF NOT CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN do:
       for first prazo-compra fields(nome-abrev   pedido-clien nr-sequencia
                                     numero-ordem parcela) where
            prazo-compra.nome-abrev   = rowObject.nome-abrev   and
            prazo-compra.pedido-clien = rowObject.pedido-clien and
            prazo-compra.nr-sequencia = rowObject.nr-sequencia and
            prazo-compra.numero-ordem = rowObject.numero-ordem and
            prazo-compra.parcela = rowObject.parcela
            no-lock: end.
        if avail prazo-compra then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-prazo-de-compra AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Prazo_de_Compra" *}
            ASSIGN c-lbl-liter-prazo-de-compra = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="8"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter-prazo-de-compra"}
        end.    
    end. 

    IF NOT CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN do:
        run executeCreatePedEmerg.  /* in h-boin274vl.p. */
        assign r-chave = to-rowid(return-value).
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDeleteOld DBOProgram 
PROCEDURE validateDeleteOld :
/******************************ATENCAO*************************************
O NOME DESSA PROCEDURE FOI ALTERADO.
SE VC ESTµ MANUTENINDO O PROGRAMA QUE A UTILIZA, 
MUDE O NOME DA PROCEDURE E PASSE ESSA PROCEDURE PARA A BOIN356,
PARA QUE POSSAMOS ELIMINAR ESSA BOIN356NA.

Data do Coment†rio: 13/07.
Prazo para Mudanáa: 13/08. (Ap¢s essa data essa procedure ser† eliminada)
**************************************************************************/ 

/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    **  Valida Delete
    */
    def input-output parameter r-chave as rowid.
    def output parameter table for RowErrors.

    /* Desabilita as Triggers */ 
    ON DELETE OF prazo-compra OVERRIDE DO:
    END.

    find {&TABLENAME} where rowid({&TABLENAME}) = r-chave exclusive-lock no-error.
    if avail {&TABLENAME} then do:               
        IF NOT CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) 
           THEN do:
                /** run executeDelete. **/
                assign rChave-aux = rowid({&TABLENAME}).

                RUN inbo/boin356.p persistent set h-boin356.
                RUN openQueryStatic in h-boin356 ("Main":U).
                RUN validateDelete in h-boin356 (input-output rChave-aux, output table RowErrors).
                delete procedure h-boin356.
           end.
    end.

    get next {&QUERYNAME} no-lock no-wait.

    if not avail {&TABLENAME} then do:
       get prev {&QUERYNAME} no-lock no-wait.
    end.
    assign r-chave = rowid({&TABLENAME}).

    return "".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

    &if defined(bf-mat-comex) &then    
    &else
        DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

        /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
              executadas ---*/
        /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
        /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do
              include: method/svc/errors/inserr.i ---*/
        /*--- Inclua aqui as validaá‰es ---*/

        /*--- Verifica ocorrància de erros ---*/
        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
            RETURN "NOK":U.

        RETURN "OK":U.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


