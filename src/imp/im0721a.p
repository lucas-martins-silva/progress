/* *****************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0721A 2.00.00.001 } /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0721a MIM}
&ENDIF

/*****************************************************************************
**
** IM0721A - Integraá∆o entre Importaá∆o e Contas Ö Pagar (EMS)
**
** Objetivo: Geraá∆o de Titulos de Antecipaá∆o no Contas a Pagar                 
**
******************************************************************************/

{imp/im0721a.i}  /* Definiá‰es de variaveis, temp-tables, forms */
{imp/imapi012.i1} /* Definiá‰es de temp-tables */
{imp/imapi012.i2 NEW SHARED}  /* ttErrosIntegracao */
{method/dbotterr.i} /* RowErrors */
{cdp/cd9900.i5} /*pi-busca-portador-modalidade */
{include/i_dbvers.i} /*Include de PrÇ-Processadores*/

/********************** DEFINICAO PARAMETROS *******************************/
def input param raw-param as raw no-undo. 
def input param table for tt-raw-digita.
/***************************************************************************/

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita NO-LOCK:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

FIND FIRST param-global NO-LOCK NO-ERROR.
ASSIGN i-empresa-prin = param-global.empresa-prin
       i-seq = 0.

ASSIGN l-primeiro    = YES
       l-imprime-tit = NO
       l-imprime-err = NO.
  
FOR EACH tt-digita EXCLUSIVE-LOCK:    
    FIND adiant-despes-parc  where rowid(adiant-despes-parc) = tt-digita.r-adiant no-lock no-error.
    IF AVAIL adiant-despes-parc THEN DO:       
       /* Verifica apenas no primeiro pois ser† sempre o mesmo emitente */
       IF l-primeiro THEN DO:
          ASSIGN l-primeiro = NO.
          find emitente
              where emitente.cod-emitente = adiant-despes-parc.cdn-emitente no-lock no-error. 
          if  avail emitente then do:
              assign i-tp-rec-padrao = emitente.tp-rec-padrao.
              run pi-busca-portador-modalidade (buffer emitente,
                                                output i-portador-emit,
                                                output i-modalidade-emit).
          end.
       END.
       /*** Busca cotacao da data de emiss∆o ***/
       {cdp/cd9600.i adiant-despes-parc.cdn-moeda adiant-despes-parc.dat-emissao de-cotacao}
     
       CREATE ttTitulos.
       ASSIGN ttTitulos.codEmpresa     = i-empresa-prin
              ttTitulos.codEstabel     = adiant-despes-parc.cod-estabel
              ttTitulos.numIdAdiant    = adiant-despes-parc.cdd-adiant   
              ttTitulos.datTransacao   = adiant-despes-parc.dtm-criac
              ttTitulos.numMoeda       = adiant-despes-parc.cdn-moeda
              ttTitulos.codEspecie     = adiant-despes-parc.cod-espec-docto
              ttTitulos.cdnFornecedor  = adiant-despes-parc.cdn-emitente             
              ttTitulos.codSerie       = adiant-despes-parc.cod-ser-docto
              ttTitulos.codRefer       = adiant-despes-parc.cod-refer
              ttTitulos.nroDocto       = adiant-despes-parc.cod-tit-ap
              ttTitulos.Parcela        = adiant-despes-parc.cod-parcela
              ttTitulos.datEmissao     = adiant-despes-parc.dat-emissao
              ttTitulos.datVencto      = adiant-despes-parc.dat-vencto
              ttTitulos.numMoeda       = adiant-despes-parc.cdn-moeda
              ttTitulos.valTitulo      = adiant-despes-parc.val-adiant-moed
              ttTitulos.valCotacao     = de-cotacao   
              ttTitulos.codPortador    = string(i-portador-emit)  
              ttTitulos.codModalidade  = string(i-modalidade-emit) 
              ttTitulos.cdnTpDespRec   = i-tp-rec-padrao
              ttTitulos.desHistorico   = '':U
              ttTitulos.codPlanoCta    = '':U
              ttTitulos.codCtaCtbl     = '':U
              ttTitulos.codPlanoCCusto = '':U
              ttTitulos.codCentroCusto = '':U
              ttTitulos.codUnidNegoc   = '':U
              ttTitulos.logGerado      = NO
              ttTitulos.codModulo      = "APB":U
              ttTitulos.codTipoReg     = "IMPL":U.     
     
        /* API de geraá∆o do t°tulo de antecipaá∆o */
        RUN imp/imapi012.p (INPUT-OUTPUT TABLE ttTitulos,
                            INPUT-OUTPUT TABLE ttImptoTitulos,
                            OUTPUT       TABLE ttErrosIntegracao).
     
       /* Grava erros que retornaram da integraá∆o APB */
       FOR EACH ttErrosIntegracao:
           ASSIGN i-seq = i-seq + 1
                  l-imprime-err = YES.
           CREATE tt-bo-erro.
           ASSIGN tt-bo-erro.sequencia     = i-seq 
                  tt-bo-erro.cod-estabel   = adiant-despes-parc.cod-estabel  
                  tt-bo-erro.cdd-adiant    = adiant-despes-parc.cdd-adiant   
                  tt-bo-erro.parcela       = adiant-despes-parc.cod-parcela
                  tt-bo-erro.cod-refer     = adiant-despes-parc.cod-refer
                  tt-bo-erro.num-erro      = ttErrosIntegracao.numMensagem
                  tt-bo-erro.descricao     = ttErrosIntegracao.desMsgErro
                  tt-bo-erro.ajuda         = ttErrosIntegracao.desMsgAjuda
                  tt-bo-erro.tipo          = "ERROR":U.
       END.       

       /* Se n∆o encontrou erro atualiza flag "gerou t°tulo AP" */
       IF NOT CAN-FIND(FIRST ttErrosIntegracao) THEN DO:
          FIND ttTitulos 
               WHERE ttTitulos.codEstabel = adiant-despes-parc.cod-estabel  
               AND   ttTitulos.codRefer   = adiant-despes-parc.cod-refer NO-LOCK NO-ERROR.
          IF AVAIL ttTitulos  THEN DO:
             ASSIGN l-imprime-tit = YES.
             CREATE tt-titulo-gerado.
             ASSIGN tt-titulo-gerado.cod-estabel  = ttTitulos.codEstabel  
                    tt-titulo-gerado.cod-refer    = ttTitulos.codRefer
                    tt-titulo-gerado.cdn-emitente = ttTitulos.cdnFornecedor
                    tt-titulo-gerado.cod-esp      = ttTitulos.codEspecie
                    tt-titulo-gerado.serie        = ttTitulos.codSerie
                    tt-titulo-gerado.cod-tit-ap   = ttTitulos.nroDocto
                    tt-titulo-gerado.parcela      = ttTitulos.Parcela.
 
             FIND b-adiant-despes-parc
                  WHERE b-adiant-despes-parc.cod-estabel =  adiant-despes-parc.cod-estabel
                  AND   b-adiant-despes-parc.cod-refer   =  adiant-despes-parc.cod-refer EXCLUSIVE-LOCK NO-ERROR.
             IF AVAIL b-adiant-despes-parc THEN
                 ASSIGN b-adiant-despes-parc.log-gerou-tit-ap = YES.
             RELEASE b-adiant-despes-parc.
          END.
       END.
    END.
END. /*FOR EACH tt-digita*/

/* Cria arquivo de conferància da geraá∆o*/
IF l-imprime-tit OR l-imprime-err THEN DO:
    {include/i-rpvar.i}
    {include/i-rpcab.i}

    FIND FIRST tt-param      NO-LOCK NO-ERROR.
    FIND FIRST param-global  NO-LOCK NO-ERROR.

    assign c-empresa    = param-global.grupo
           c-programa   = "IM0721":U
           c-versao     = "1.00"
           c-revisao    = "000".

    {include/i-rpout.i}

    view frame f-cabec.
    view frame f-rodape.

    /* Gerou t°tulos de antecipaá∆o */
    IF l-imprime-tit THEN DO:
        {utp/ut-liter.i "T°tulos_de_Antecipaá∆o_Gerados_no_Contas_a_Pagar" *}
        ASSIGN c-titulo = TRIM(RETURN-VALUE).
        DISP STRING("--------------------------- " + c-titulo + " ------------------------------------------------------- ") 
            FORMAT "X(118)" WITH STREAM-IO WIDTH 120 Frame f-disp-cab-1.
        RUN utp/ut-trfrrp.p (INPUT FRAME f-disp-cab-1:HANDLE).
        put skip(1).
        FOR EACH tt-titulo-gerado
            BREAK BY tt-titulo-gerado.cod-refer:

            DISP tt-titulo-gerado.cod-estabel
                 tt-titulo-gerado.cod-refer
                 tt-titulo-gerado.cdn-emitente
                 tt-titulo-gerado.cod-esp
                 tt-titulo-gerado.serie
                 tt-titulo-gerado.cod-tit-ap
                 tt-titulo-gerado.parcela
                 with frame f-layout2.
            down with frame f-layout2.

        END.
    END.

    /* N∆o gerou t°tulos de antecipaá∆o */
    IF l-imprime-err THEN DO:
        {utp/ut-liter.i "T°tulos_de_Antecipaá∆o_N∆o_Gerados_no_Contas_a_Pagar" *}
        ASSIGN c-titulo1 = TRIM(RETURN-VALUE).
        DISP STRING("--------------------------- " + c-titulo1 + "  ----------------------------------------------------- ") 
            FORMAT "X(118)" WITH STREAM-IO WIDTH 120 Frame f-disp-cab-2.
        RUN utp/ut-trfrrp.p (INPUT FRAME f-disp-cab-2:HANDLE).
        put skip(1).
        FOR EACH tt-bo-erro
            BREAK BY tt-bo-erro.sequencia:

            DISP tt-bo-erro.cod-estabel
                 tt-bo-erro.cdd-adiant
                 tt-bo-erro.cod-refer
                 tt-bo-erro.sequencia
                 tt-bo-erro.num-erro
                 tt-bo-erro.descricao
                with frame f-layout1.
           down with frame f-layout1.
        END.
    END.   
END.
VIEW FRAME f-rodape.
OUTPUT CLOSE.
                                 
                                                                                                                                                       
                                                                                       
                                                                             
