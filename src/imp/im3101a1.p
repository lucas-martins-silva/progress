/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM3101A1 2.00.00.035 } /*** "010035" 23/09/2025 14:33:38 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im3101a1 MIM}
&ENDIF
 
/***** DEFINI€ÇO INCLUDES *****/
{utp/ut-glob.i}
{cdp/cdcfgmat.i}
{cdp/cd9590.i} /* Unidade de neg¢cio */
{cdp/cd4300.i3} /* tratamento atributo livre */
{cxbo/bocx230.i tt-desp-embarque}      
{cxbo/bocx090.i tt-docum-est-cex}      
{cxbo/bocx100.i tt-item-doc-est-cex }  
{cxbo/bocx310a.i tt-selecao-despesa}  
{imp/im3101.i} /*tt-impostos-despesa*/
{imp/im0100x.i tt-parametros}
{imp/im0091.i}                         /* tt-desp-rateio      */
{include/boerrtab.i}                   /* tt-bo-erro          */
{include/i-epc200.i im3101a1}
{inbo/boin090.i tt-docum-est}
{inbo/boin090.i tt-docum-est-orig}     
{inbo/boin090.i tt-docum-est-orig-aux} /* nf principal todos embarques */
{inbo/boin366.i tt-rat-docum}
{inbo/boin176.i tt-item-doc-est}
{inbo/boin092.i tt-dupli-apagar}
{inbo/boin567.i tt-dupli-imp}
{method/dbotterr.i} 
{inbo/boin01066.i tt-docto-estoq-internac}
/******************************/
/*Include para ajuste de decimal*/
{cdp/cd1234.i}

/***** DEFINI€ÇO TEMP-TABLES *****/
DEFINE TEMP-TABLE tt-pryext-item-docto-estoq NO-UNDO
    FIELD cod-ser-docto          like item-doc-est.serie-docto
    FIELD cod-docto              like item-doc-est.nro-docto
    FIELD cdn-emitente           like item-doc-est.cod-emitente
    FIELD cod-natur-operac       like item-doc-est.nat-operacao
    FIELD num-seq                like item-doc-est.sequencia
    FIELD cod-item               like item-doc-est.it-codigo
    FIELD log-iva-inclui         AS LOG
    FIELD val-preco-unit-isento  AS DECIMAL FORMAT ">>>,>>>,>>9.99999"
    FIELD val-preco-unit-com-iva AS DECIMAL FORMAT ">>>,>>>,>>9.99999"
    INDEX codigo IS PRIMARY UNIQUE
          cod-ser-docto         
          cod-docto             
          cdn-emitente          
          cod-natur-operac      
          num-seq               
          cod-item.

DEFINE TEMP-TABLE tt-item-doc-est-cex-internac NO-UNDO LIKE item-doc-est-cex-internac
       FIELD r-rowid AS ROWID.

{inbo/boin759.i tt-impto-item-docto}
{inbo/boin759.i tt-impto-item-docto-aux}

DEFINE TEMP-TABLE tt-erro NO-UNDO
	FIELD identif-segment AS CHAR
	FIELD cd-erro         AS INTEGER
	FIELD desc-erro       AS CHAR FORMAT "x(80)".

DEF TEMP-TABLE tt-unid-neg-nota NO-UNDO
    FIELD registro              AS   INT
    FIELD cod-emitente          LIKE unid-neg-nota.cod-emitente
    FIELD serie-docto           LIKE unid-neg-nota.serie-docto
    FIELD nro-docto             LIKE unid-neg-nota.nro-docto
    FIELD nat-operacao          LIKE unid-neg-nota.nat-operacao
    FIELD sequencia             LIKE unid-neg-nota.sequencia
    FIELD cod_unid_negoc        LIKE unid-neg-nota.cod_unid_negoc
    FIELD perc-unid-neg         LIKE unid-neg-nota.perc-unid-neg
    INDEX documento IS PRIMARY
          serie-docto
          nro-docto
    	  cod-emitente
    	  nat-operacao
          sequencia
          cod_unid_negoc.

def temp-table tt-dupli-apagar-cex no-undo
        field cod-emitente      like dupli-apagar-cex.cod-emitente
        field nat-operacao      like dupli-apagar-cex.nat-operacao
        field serie-docto       like dupli-apagar-cex.serie-docto
        field nro-docto         like dupli-apagar-cex.nro-docto
        field cod-emitente-desp like dupli-apagar-cex.cod-emitente-desp
        field cod-desp          like docum-est-cex.cod-desp /* nao existe cod-desp no dupli-apagar-cex no EMS 2.03 */
        field mo-codigo         like dupli-apagar-cex.mo-codigo
        field dt-vencim         like dupli-apagar-cex.dt-vencim
        field tp-despesa        like dupli-apagar-cex.tp-despesa
        field vl-a-pagar        like dupli-apagar-cex.vl-a-pagar
        field vl-a-pagar-mo     like dupli-apagar-cex.vl-a-pagar-mo
        FIELD cod-esp           LIKE dupli-apagar-cex.cod-esp
        FIELD cod-estabel       LIKE dupli-apagar-cex.cod-estabel
        index codigo
            serie-docto
            nro-docto
            cod-emitente
            nat-operacao
            cod-desp
            cod-emitente-desp
        index data
            cod-emitente-desp
            dt-vencim.

/******************************/

/***** DEFINI€ÇO VARIµVEIS LOCAIS *****/
DEF VAR i-seq-erro       AS INTEGER                    NO-UNDO.
DEF VAR c-moeda          LIKE docum-est.mo-codigo      NO-UNDO.
DEF VAR de-cotacao       LIKE docum-est.cotacao-dia    NO-UNDO.
DEF VAR d-valor-desp     AS DECIMAL FORMAT '>>>>>,>>>,>>9.99999'     NO-UNDO.
DEF VAR d-tot-imp        AS DECIMAL FORMAT '>>>>>,>>>,>>9.99999'     NO-UNDO.
DEF VAR dval-impto       AS DECIMAL     NO-UNDO.
DEF VAR dval-base        AS DECIMAL     NO-UNDO.
DEF VAR h-bopy2005       AS HANDLE      NO-UNDO.
DEF VAR h-boec022        AS HANDLE      NO-UNDO.
DEF VAR h-boin01066      AS HANDLE      NO-UNDO.

DEF VAR c-espec-padr AS CHAR FORMAT "x(2)" NO-UNDO.

&IF  '{&bf_mat_versao_ems}' >= '2.06' &THEN
    &GLOBAL-DEFINE vcod-espec-padr desp-imp.cod-espec-padr
&ELSE
    &GLOBAL-DEFINE vcod-espec-padr SUBSTRING(desp-imp.char-1,14,2)
&ENDIF


def var dat-tipo-dia   like calen-coml.tipo-dia no-undo. /*CD9020.i7*/

{rep/re1001a.i50} /*Vari veis m¢dulo de importa‡Æo*/
{local/arg/arg0020.i} /*tt-imposto para a localiza‡Æo Argentina*/
DEF BUFFER bf-docum-est                FOR docum-est.
/******************************/

/** loadParameters **/
PROCEDURE loadParameters:
    DEF INPUT PARAMETER TABLE FOR tt-parametros.
    DEF INPUT PARAMETER TABLE FOR tt-parametros-aux.
    DEF INPUT PARAMETER TABLE FOR tt-docum-est-orig.
    DEF INPUT PARAMETER TABLE FOR tt-desp-rateio.
    DEF INPUT PARAMETER TABLE FOR tt-ordens-totais.
    DEF INPUT PARAMETER TABLE FOR tt-selecao-despesa.
    DEF INPUT PARAMETER TABLE FOR tt-impostos-despesa.
    
    FIND FIRST tt-parametros             NO-ERROR.
    FIND FIRST tt-parametros-aux         NO-ERROR.
    FIND FIRST param-global      NO-LOCK NO-ERROR.
    
    FOR EACH tt-docum-est-orig:
        create tt-docum-est-orig-aux.
        buffer-copy tt-docum-est-orig to tt-docum-est-orig-aux.
    END.
    RETURN "OK":U.
END PROCEDURE.


/*****************************************/
/** generateTT-docum-est **/
procedure generateTT-docum-est:
    DEFINE VARIABLE c-periodo AS CHARACTER  FORMAT "x(10)":U NO-UNDO.
    DEFINE VARIABLE c-retorno AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-nro-docto LIKE docum-est.nro-docto NO-UNDO.
    ASSIGN c-retorno = "OK":U.

    CREATE tt-docum-est.
    ASSIGN tt-docum-est.cod-emitente         = tt-parametros.cod-emitente-desp
           tt-docum-est.cod-estabel          = tt-parametros.cod-estabel
           tt-docum-est.estab-fisc           = tt-parametros.estab-fisc
           tt-docum-est.serie-docto          = tt-parametros.serie
           tt-docum-est.nat-operacao         = tt-parametros.nat-operacao
           tt-docum-est.esp-docto            = 21 
           tt-docum-est.cod-observa          = tt-parametros.cod-observacao
           tt-docum-est.dt-trans             = tt-parametros.da-trans
           tt-docum-est.dt-emissao           = tt-parametros.da-emissao
           tt-docum-est.uf                   = tt-parametros.estado-emit
           tt-docum-est.ct-transit           = tt-parametros.ct-transit
           tt-docum-est.sc-transit           = tt-parametros.sc-transit     
           tt-docum-est.nff                  = tt-parametros.nff
           tt-docum-est.valor-embal-me       = 0
           tt-docum-est.valor-frete-me       = 0
           tt-docum-est.valor-mercad-me      = 0
           tt-docum-est.valor-outras-me      = 0
           tt-docum-est.valor-seguro-me      = 0
           tt-docum-est.observacao           = tt-parametros.observacao
           tt-docum-est.nro-docto            = tt-parametros.nro-docto
           tt-docum-est.usuario              = tt-parametros.usuario.   

    FIND natur-oper WHERE
         natur-oper.nat-operacao = tt-parametros.nat-operacao NO-LOCK NO-ERROR.
    IF AVAIL natur-oper THEN
        ASSIGN tt-docum-est.sit-docum = if tt-docum-est.nff or
                                 (not tt-docum-est.nff and
                                  not natur-oper.emite-duplic)
                                  then 1 
                                  else 2.

    IF  NOT CAN-FIND(FIRST tt-docum-est) THEN
        RETURN "NOK":U.

    RUN generateNumeroDocumento (INPUT        tt-docum-est.cod-estabel,
                                 INPUT        tt-docum-est.serie,
                                 INPUT        tt-docum-est.cod-emitente,
                                 INPUT        tt-docum-est.nat-operacao,
                                 INPUT        tt-parametros.i-pais-impto-usuario,
                                 INPUT        tt-parametros-aux.imp-nota,
                                 INPUT-OUTPUT tt-docum-est.nro-docto).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    ASSIGN OVERLAY(tt-docum-est.char-1,1,20) = tt-docum-est.nro-docto.

    FOR FIRST embarque-imp FIELDS (cod-via-transp declaracao-import)
        WHERE embarque-imp.cod-estabel = tt-parametros.cod-estabel
          AND embarque-imp.embarque    = tt-parametros.embarque NO-LOCK: 
        ASSIGN tt-docum-est.via-transp = embarque-imp.cod-via-transp.
    END.

    FIND FIRST tt-selecao-despesa NO-ERROR.
    IF AVAIL tt-selecao-despesa THEN DO:
        ASSIGN tt-docum-est.mo-codigo = tt-selecao-despesa.moeda
               c-moeda                = tt-selecao-despesa.moeda   
               c-periodo              = STRING(YEAR(tt-parametros.da-cotacao),'9999') 
                                      + STRING(MONTH(tt-parametros.da-cotacao),'99').
        
        IF tt-parametros.d-cotacao = 0 THEN DO:
            FOR FIRST cotacao FIELDS(cotacao) NO-LOCK
                WHERE cotacao.mo-codigo   = tt-selecao-despesa.moeda
                  AND cotacao.ano-periodo = c-periodo:
                ASSIGN tt-docum-est.cotacao-dia = cotacao.cotacao[DAY(tt-parametros.da-cotacao)]
                       de-cotacao               = tt-docum-est.cotacao-dia.
            END.
        END.
        ELSE DO:
            ASSIGN tt-docum-est.cotacao-dia = tt-parametros.d-cotacao
                   de-cotacao               = tt-parametros.d-cotacao.
        END.
    END.
    
    /* Localiza‡Æo Equador */
    IF  i-pais-impto-usuario = 21 THEN DO:      

        ASSIGN c-nro-docto     = STRING(tt-parametros.cod-estabel-ats,"999") + STRING(tt-parametros.cdn-pto-emis,"999") + tt-docum-est.nro-docto.
      
        IF NOT VALID-HANDLE (h-boec022) THEN
            RUN local/ecu/ec2bo/boec022.p PERSISTENT SET h-boec022.
      
        RUN openQueryStatic IN h-boec022 (INPUT 'Main':U).
        RUN isDoctoSaida    IN h-boec022 (INPUT NO).
        RUN pi-valida-dados IN h-boec022 (INPUT tt-docum-est.cod-emitente,
                                          INPUT tt-docum-est.nat-operacao,
                                          INPUT tt-docum-est.serie,
                                          INPUT c-nro-docto,
                                          INPUT tt-parametros.cod-autoriz-sri,
                                          INPUT tt-parametros.dat-autoriz,
                                          INPUT STRING(tt-parametros.cod-estabel-ats,"999"),
                                          INPUT STRING(tt-parametros.cdn-pto-emis,"999"),
                                          INPUT NO,
                                          INPUT IF tt-docum-est.nff = YES THEN 6 ELSE 1,
                                          INPUT tt-docum-est.dt-emissao,
                                          INPUT YES,
                                          OUTPUT TABLE RowErrors).
      
        IF CAN-FIND(FIRST RowErrors) THEN DO:
            FOR LAST tt-bo-erro BY tt-bo-erro.i-sequen:
                ASSIGN i-seq-erro = tt-bo-erro.i-sequen.
            END.
      
            FOR EACH rowerrors:
                CREATE tt-bo-erro.
                ASSIGN i-seq-erro              = i-seq-erro + 1
                       tt-bo-erro.parametros   = ""
                       tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = rowerrors.errornumber
                       tt-bo-erro.mensagem     = rowerrors.errordescription
                       tt-bo-erro.errorsubtype = "error".
            END.
        
            ASSIGN c-retorno = "NOK":U. 
        END.

        IF VALID-HANDLE(h-boec022) THEN DO:
            RUN destroy IN h-boec022.
            ASSIGN h-boec022 = ?.
        END.
    END.

    RETURN  c-retorno. 
END PROCEDURE.
/*****************************************/

/** generateNumeroDocumento **/
procedure generateNumeroDocumento:
    
    DEF INPUT        PARAMETER c-cod-estabel        LIKE estabelec.cod-estabel  NO-UNDO.
    DEF INPUT        PARAMETER c-serie-docto        LIKE docum-est.serie-docto  NO-UNDO.
    DEF INPUT        PARAMETER i-cod-emitente       LIKE docum-est.cod-emitente NO-UNDO.
    DEF INPUT        PARAMETER c-nat-operacao       LIKE docum-est.nat-operacao NO-UNDO.
    DEF INPUT        PARAMETER i-pais-impto-usuario AS INTEGER                  NO-UNDO.
    DEF INPUT        PARAMETER l-imp-nota           LIKE natur-oper.imp-nota    NO-UNDO.
    DEF INPUT-OUTPUT PARAMETER c-nro-docto          LIKE docum-est.nro-docto    NO-UNDO.
    
    IF NOT AVAIL param-global THEN 
        FIND FIRST param-global NO-LOCK NO-ERROR.

    IF NOT param-global.modulo-ft 
    OR NOT l-imp-nota THEN DO:
        IF CAN-FIND(FIRST docum-est             
                    WHERE docum-est.serie-docto  = c-serie-docto 
                      AND docum-est.nro-docto    = c-nro-docto
                      AND docum-est.cod-emitente = i-cod-emitente
                      AND docum-est.nat-operacao = c-nat-operacao) THEN DO:

            RUN pi-gera-erro (INPUT "MSG":U,
                              INPUT 1878,
                              INPUT c-nro-docto,
                              INPUT "").
            RETURN "NOK":U.
        END.
        RETURN "OK":U.   
    END.
    
    FOR FIRST serie FIELDS(forma-emis)
        WHERE serie.serie = c-serie-docto NO-LOCK:
    END.
    
    IF serie.forma-emis = 2 /* Manual */ THEN
        RETURN "OK":U.
        
    FOR FIRST ser-estab FIELDS(nr-ult-nota)
        WHERE ser-estab.serie       = c-serie-docto
          AND ser-estab.cod-estabel = c-cod-estabel NO-LOCK:
    END.
    
    IF NOT AVAIL ser-estab THEN DO:
        RUN pi-gera-erro (INPUT "MSG":U,
                          INPUT 6514,
                          INPUT "",
                          INPUT "").
        RETURN "NOK":U.
    END.
        
    IF c-nro-docto = "" THEN DO:

        ASSIGN c-nro-docto = STRING(INT(ser-estab.nr-ult-nota) + 1).

        IF CAN-FIND(FIRST docum-est
                    WHERE docum-est.serie-docto  = c-serie-docto 
                      AND docum-est.nro-docto    = c-nro-docto
                      AND docum-est.cod-emitente = i-cod-emitente
                      AND docum-est.nat-operacao = c-nat-operacao) THEN DO:

            RUN pi-gera-erro (INPUT "MSG":U,
                              INPUT 5569,
                              INPUT STRING(c-nro-docto),
                              INPUT "").
            RETURN "NOK":U.
        END.
    
        RUN pi-gera-erro (INPUT "MSG":U,
                          INPUT 6511,
                          INPUT STRING(c-nro-docto),
                          INPUT "information").
    END.
    
    RETURN "OK":U.
END PROCEDURE.
/*****************************************/

/** generateTT-item-doc-est **/
PROCEDURE generateTT-item-doc-est:

    DEF VAR i-sequencia         AS INTEGER NO-UNDO.
    DEF VAR i-cod-emitente-desp AS INTEGER NO-UNDO.
    DEF VAR i-cod-cond-pag      AS INTEGER NO-UNDO.
    DEF VAR i-taxa-iva          LIKE tipo-tax.tax-perc NO-UNDO.
    DEF VAR i-imposto           AS INT NO-UNDO.
    DEF VAR de-valor-total-desp AS DEC     NO-UNDO.
    DEF VAR i-cod-desp          AS INT     NO-UNDO.
    DEF VAR i-ordem             LIKE item-doc-est.numero-ordem NO-UNDO.
    DEF VAR i-parc              LIKE item-doc-est.parcela      NO-UNDO.
    DEF VAR d-qtd-item-orig     LIKE item-doc-est.quantidade   NO-UNDO.

    FIND FIRST tt-docum-est      NO-ERROR.
    ASSIGN tt-docum-est.observacao = tt-docum-est.observacao 
                                   + " - Embarque: " + tt-parametros.embarque
                                   + " - "           + tt-parametros.observacao.

    FIND FIRST tt-docum-est-orig NO-ERROR.
    
    FOR LAST item-doc-est FIELDS(sequencia) {cdp/cd8900.i item-doc-est tt-docum-est} NO-LOCK: END.
    IF  AVAIL item-doc-est THEN 
        ASSIGN i-sequencia = item-doc-est.sequencia + tt-parametros-aux.inc-seq.
    ELSE DO:
        FOR LAST tt-item-doc-est FIELDS(sequencia) {cdp/cd8900.i tt-item-doc-est tt-docum-est} no-lock: END.
        IF  AVAIL tt-item-doc-est THEN
            ASSIGN i-sequencia = tt-item-doc-est.sequencia + tt-parametros-aux.inc-seq.
        ELSE
            ASSIGN i-sequencia = tt-parametros-aux.seq-item-um.
    END.
    
    FOR EACH item-doc-est {cdp/cd8900.i item-doc-est tt-docum-est-orig} NO-LOCK:

        IF  tt-docum-est-orig.idi-nf-simples-remes = 1 THEN DO:
        
            FIND FIRST ordens-embarque NO-LOCK
                 WHERE ordens-embarque.cod-estabel  = tt-docum-est-orig.cod-estabel 
                   AND ordens-embarque.embarque     = trim(SUBSTRING(tt-docum-est-orig.char-1,1,20))
                   AND ordens-embarque.numero-ordem = item-doc-est.num-ord-import
                   AND ordens-embarque.parcela      = item-doc-est.num-parc-import NO-ERROR.
                   
            IF NOT AVAIL ordens-embarque THEN NEXT.
        
            ASSIGN i-ordem         = item-doc-est.num-ord-import  
                   i-parc          = item-doc-est.num-parc-import
                   d-qtd-item-orig = ordens-embarque.quantidade.                               
                   
        END.
        ELSE DO:
            ASSIGN i-ordem         = item-doc-est.numero-ordem
                   i-parc          = item-doc-est.parcela
                   d-qtd-item-orig = item-doc-est.quantidade.           
        END.


      FIND FIRST tt-desp-rateio 
          WHERE tt-desp-rateio.numero-ordem = i-ordem
            AND tt-desp-rateio.parcela      = i-parc NO-ERROR.
      IF  NOT AVAIL tt-desp-rateio THEN
          NEXT.
          
      FIND FIRST tt-ordens-totais
          WHERE tt-ordens-totais.numero-ordem = i-ordem
            AND tt-ordens-totais.parcela      = i-parc  NO-ERROR.
      IF  NOT AVAIL tt-ordens-totais THEN
          NEXT.


     /*acerto do um centavo*/
        ASSIGN de-valor-total-desp = 0.

        FOR EACH  tt-desp-rateio EXCLUSIVE-LOCK                                         
            WHERE tt-desp-rateio.numero-ordem = i-ordem 
              AND tt-desp-rateio.parcela      = i-parc      
            BREAK BY tt-desp-rateio.numero-ordem
                  BY tt-desp-rateio.parcela:  
    
            ASSIGN de-valor-total-desp = de-valor-total-desp + tt-desp-rateio.val-desp.
    
            IF de-valor-total-desp <> 0 THEN LEAVE.
    
            IF LAST-OF(tt-desp-rateio.numero-ordem) AND de-valor-total-desp = 0 THEN DO:           
                ASSIGN tt-desp-rateio.val-desp = 0.01
                       i-cod-desp              = tt-desp-rateio.cod-desp. 
    
                FIND FIRST tt-selecao-despesa
                    WHERE  tt-selecao-despesa.cod-estabel = tt-parametros.cod-estabel
                      AND  tt-selecao-despesa.embarque    = trim(substring(tt-docum-est-orig.char-1,1,20))
                      AND  tt-selecao-despesa.cod-desp    = tt-desp-rateio.cod-desp     NO-ERROR.
    
                IF AVAIL tt-selecao-despesa AND tt-selecao-despesa.moeda <> 0 THEN DO:
                    IF tt-parametros.d-cotacao = 0 THEN
                        RUN cdp/cd0812.p (INPUT  0,
                                          INPUT  tt-selecao-despesa.moeda,
                                          INPUT  tt-desp-rateio.val-desp,
                                          INPUT  tt-parametros.da-cotacao,
                                          OUTPUT tt-desp-rateio.val-desp-mo).
                    ELSE
                        RUN cdp/cd0812a.p (INPUT  0,
                                           INPUT  tt-selecao-despesa.moeda,
                                           INPUT  tt-desp-rateio.val-desp,
                                           INPUT  tt-parametros.d-cotacao,
                                           OUTPUT tt-desp-rateio.val-desp-mo).
                END.                          
                ELSE
                    ASSIGN tt-desp-rateio.val-desp-mo = 0.01.
            END.
        END.

        IF de-valor-total-desp = 0 THEN
            FOR EACH  tt-desp-rateio EXCLUSIVE-LOCK                                         
                WHERE tt-desp-rateio.cod-desp = i-cod-desp 
                BREAK BY tt-desp-rateio.val-desp DESC:
    
                ASSIGN tt-desp-rateio.val-desp = tt-desp-rateio.val-desp - 0.01.

                FIND FIRST tt-selecao-despesa
                    WHERE  tt-selecao-despesa.cod-estabel = tt-parametros.cod-estabel
                      AND  tt-selecao-despesa.embarque    = trim(substring(tt-docum-est-orig.char-1,1,20))
                      AND  tt-selecao-despesa.cod-desp    = tt-desp-rateio.cod-desp     NO-ERROR.

                IF AVAIL tt-selecao-despesa AND tt-selecao-despesa.moeda <> 0 THEN DO:
                    IF tt-parametros.d-cotacao = 0 THEN
                        RUN cdp/cd0812.p (INPUT  0,
                                          INPUT  tt-selecao-despesa.moeda, 
                                          INPUT  tt-desp-rateio.val-desp,
                                          INPUT  tt-parametros.da-cotacao,
                                          OUTPUT tt-desp-rateio.val-desp-mo).
                    ELSE
                        RUN cdp/cd0812a.p (INPUT  0,
                                           INPUT  tt-selecao-despesa.moeda, 
                                           INPUT  tt-desp-rateio.val-desp,
                                           INPUT  tt-parametros.d-cotacao,
                                           OUTPUT tt-desp-rateio.val-desp-mo).
                END.                      
                ELSE
                    ASSIGN tt-desp-rateio.val-desp-mo = tt-desp-rateio.val-desp-mo - 0.01.
                LEAVE.    
            END.
        /* fim acerto um centavo */

        FOR FIRST ITEM FIELDS(class-fiscal tipo-contr ct-codigo sc-codigo tipo-con-est)
            WHERE item.it-codigo = item-doc-est.it-codigo NO-LOCK: 
        END.


        CREATE tt-item-doc-est.
        ASSIGN tt-item-doc-est.serie-docto       = tt-docum-est.serie-docto
               tt-item-doc-est.nro-docto         = tt-docum-est.nro-docto   
               tt-item-doc-est.cod-emitente      = tt-docum-est.cod-emitente
               tt-item-doc-est.nat-operacao      = tt-docum-est.nat-operacao
               tt-item-doc-est.sequencia         = i-sequencia
               i-sequencia                       = i-sequencia + tt-parametros-aux.inc-seq
               tt-item-doc-est.serie-comp        = tt-docum-est-orig.serie-docto
               tt-item-doc-est.nro-comp          = tt-docum-est-orig.nro-docto
               tt-item-doc-est.nat-comp          = tt-docum-est-orig.nat-operacao
               tt-item-doc-est.it-codigo         = item-doc-est.it-codigo
               tt-item-doc-est.cod-refer         = item-doc-est.cod-refer
               tt-item-doc-est.seq-comp          = item-doc-est.sequencia
               tt-item-doc-est.ct-codigo         = item-doc-est.ct-codigo
               tt-item-doc-est.sc-codigo         = item-doc-est.sc-codigo
               tt-item-doc-est.numero-ordem      = 0
               tt-item-doc-est.num-pedido        = 0
               tt-item-doc-est.parcela           = 0
               tt-item-doc-est.num-event-contrat = 0
               tt-item-doc-est.log-fifo-oc       = NO
               tt-item-doc-est.encerra-pa        = NO
               tt-item-doc-est.baixa-ce          = YES
               tt-item-doc-est.nr-ord-produ      = 0
               tt-item-doc-est.item-pai          = ""
               tt-item-doc-est.cod-roteiro       = ""
               tt-item-doc-est.op-codigo         = 0
               tt-item-doc-est.qt-etiquetas      = 0
               tt-item-doc-est.qt-do-forn        = 0
               tt-item-doc-est.un                = item-doc-est.un
               tt-item-doc-est.quantidade        = 0
               tt-item-doc-est.desconto          = 0
               tt-item-doc-est.peso-liquido      = 0
               tt-item-doc-est.class-fiscal      = item.class-fiscal.                       


        /* Nota complementar mÆe tem lote gen‚rico */
        IF tt-docum-est-orig.idi-nf-simples-remes = 1 and
           (item.tipo-con-est = 2 OR 
            item.tipo-con-est = 3 OR
            item.tipo-con-est = 4) THEN DO:
            ASSIGN tt-item-doc-est.lote = "LNSRMX".

            IF item.tipo-con-est = 3 OR item.tipo-con-est = 4 THEN
                ASSIGN tt-item-doc-est.dt-vali-lote = 12/31/9999.
        END.


        IF i-pais-impto-usuario = 9 /* Paraguai */ THEN DO:
            CREATE tt-pryext-item-docto-estoq.
            ASSIGN tt-pryext-item-docto-estoq.cod-ser-docto    = tt-item-doc-est.serie-docto
                   tt-pryext-item-docto-estoq.cod-docto        = tt-item-doc-est.nro-docto
                   tt-pryext-item-docto-estoq.cdn-emitente     = tt-item-doc-est.cod-emitente
                   tt-pryext-item-docto-estoq.cod-natur-operac = tt-item-doc-est.nat-operacao
                   tt-pryext-item-docto-estoq.num-seq          = tt-item-doc-est.sequencia
                   tt-pryext-item-docto-estoq.cod-item         = tt-item-doc-est.it-codigo
                   tt-pryext-item-docto-estoq.log-iva-inclui   = YES.                        
        END.
        
        IF  l-unidade-negocio
        AND l-mat-unid-negoc THEN DO:
            ASSIGN tt-item-doc-est.cod-unid-negoc  = item-doc-est.cod-unid-negoc.
            
            FOR EACH unid-neg-nota FIELDS ( serie-docto  nro-docto      cod-emitente   
                                            nat-operacao cod_unid_negoc perc-unid-neg
                                            sequencia )
                                   USE-INDEX nota 
                WHERE unid-neg-nota.serie-docto  = item-doc-est.serie-docto
                  AND unid-neg-nota.nro-docto    = item-doc-est.nro-docto
                  AND unid-neg-nota.cod-emitente = item-doc-est.cod-emitente
                  AND unid-neg-nota.nat-operacao = item-doc-est.nat-operacao
                  AND unid-neg-nota.sequencia    = item-doc-est.sequencia NO-LOCK :
    
                CREATE tt-unid-neg-nota.
                ASSIGN tt-unid-neg-nota.serie-docto     = tt-item-doc-est.serie-docto
                       tt-unid-neg-nota.nro-docto       = tt-item-doc-est.nro-docto
                       tt-unid-neg-nota.cod-emitente    = tt-item-doc-est.cod-emitente
                       tt-unid-neg-nota.nat-operacao    = tt-item-doc-est.nat-operacao
                       tt-unid-neg-nota.sequencia       = tt-item-doc-est.sequencia
                       tt-unid-neg-nota.cod_unid_negoc  = unid-neg-nota.cod_unid_negoc
                       tt-unid-neg-nota.perc-unid-neg   = unid-neg-nota.perc-unid-neg.
            END.
        END.
           

        FOR EACH  tt-desp-rateio
            WHERE tt-desp-rateio.numero-ordem = i-ordem
              AND tt-desp-rateio.parcela      = i-parc
            USE-INDEX codigo:
    
            FOR FIRST desp-imp FIELDS(inc-base-ipi inc-base-icm int-2 inc-val-duplic inc-base-ipi char-1)
                WHERE desp-imp.cod-desp = tt-desp-rateio.cod-desp NO-LOCK:
    
                IF  tt-desp-rateio.val-desp = ? THEN 
                    ASSIGN tt-desp-rateio.val-desp = 0.
      
                IF tt-desp-rateio.val-desp-mo = ? THEN
                    ASSIGN tt-desp-rateio.val-desp-mo = 0.

                IF  tt-desp-rateio.val-desp-isento = ? THEN 
                    ASSIGN tt-desp-rateio.val-desp-isento = 0.
      
                IF tt-desp-rateio.val-desp-isento-mo = ? THEN
                    ASSIGN tt-desp-rateio.val-desp-isento-mo = 0.

                IF i-pais-impto-usuario <> 9 /* Paraguai */ THEN
                    ASSIGN tt-desp-rateio.val-desp-isento    = 0
                           tt-desp-rateio.val-desp-isento-mo = 0.

                /** Acumula Valor Duplicatas **/
                IF  desp-imp.inc-val-duplic THEN
                    ASSIGN tt-parametros-aux.valor-duplic = tt-parametros-aux.valor-duplic
                                                          + (((tt-desp-rateio.val-desp-mo + tt-desp-rateio.val-desp-isento-mo) * d-qtd-item-orig) / tt-ordens-totais.quantidade).
                
                ASSIGN tt-parametros-aux.valor-mercad = tt-parametros-aux.valor-mercad + tt-desp-rateio.val-desp-mo + tt-desp-rateio.val-desp-isento-mo.
            END.

            ASSIGN tt-item-doc-est.preco-total[1] = tt-item-doc-est.preco-total[1]
                                                  + (((tt-desp-rateio.val-desp + tt-desp-rateio.val-desp-isento) * d-qtd-item-orig) / tt-ordens-totais.quantidade)
                   tt-item-doc-est.preco-unit[1]  = tt-item-doc-est.preco-total[1]
                   tt-item-doc-est.preco-total-me = tt-item-doc-est.preco-total-me
                                                  + (((tt-desp-rateio.val-desp-mo + tt-desp-rateio.val-desp-isento-mo) * d-qtd-item-orig) / tt-ordens-totais.quantidade)
                   tt-item-doc-est.preco-unit-me  = tt-item-doc-est.preco-total-me
                   i-cod-emitente-desp            = tt-parametros.cod-emitente-desp
                   i-cod-cond-pag                 = tt-parametros-aux.cod-cond-pag.                   
            
            FIND FIRST tt-selecao-despesa
                WHERE  tt-selecao-despesa.cod-estabel = tt-parametros.cod-estabel
                  AND  tt-selecao-despesa.embarque    = trim(substring(tt-docum-est-orig.char-1,1,20))
                  AND  tt-selecao-despesa.cod-desp    = tt-desp-rateio.cod-desp     NO-ERROR.
    
            ASSIGN i-cod-emitente-desp = tt-selecao-despesa.cod-emitente-desp
                   i-cod-cond-pag      = tt-selecao-despesa.cond-pagto. 

            IF i-pais-impto-usuario = 9 /* Paraguai */ THEN DO:
                IF tt-desp-rateio.val-desp-mo > 0 THEN DO:
                    FIND FIRST despes-embarq-internac 
                         where despes-embarq-internac.cod-estabel       = tt-selecao-despesa.cod-estabel
                           and despes-embarq-internac.embarque          = tt-selecao-despesa.embarque
                           and despes-embarq-internac.cod-itiner        = tt-selecao-despesa.cod-itiner
                           and despes-embarq-internac.cod-pto-contr     = tt-selecao-despesa.cod-pto-contr
                           and despes-embarq-internac.cod-desp          = tt-selecao-despesa.cod-desp
                           and despes-embarq-internac.cod-emitente-desp = tt-selecao-despesa.cod-emitente-desp no-lock no-error.

                   IF AVAIL despes-embarq-internac THEN DO:
                       FIND FIRST tipo-tax WHERE tipo-tax.cod-tax = despes-embarq-internac.cdn-imposto NO-LOCK NO-ERROR.
                       IF AVAIL tipo-tax THEN DO:
                           ASSIGN i-taxa-iva = 1 + (tipo-tax.tax-perc / 100).

                           FIND FIRST tt-impto-item-docto
                                WHERE tt-impto-item-docto.serie-docto   = tt-item-doc-est.serie-docto 
                                  AND tt-impto-item-docto.nro-docto     = string(tt-item-doc-est.nro-docto)
                                  AND tt-impto-item-docto.cod-emitente  = tt-item-doc-est.cod-emitente
                                  AND tt-impto-item-docto.nat-operacao  = tt-item-doc-est.nat-operacao
                                  AND tt-impto-item-docto.num-seq       = tt-item-doc-est.sequencia 
                                  AND tt-impto-item-docto.cdn-imposto   = tipo-tax.cod-tax NO-ERROR.
                           IF NOT AVAIL tt-impto-item-docto THEN DO:
                               CREATE tt-impto-item-docto.
                               ASSIGN tt-impto-item-docto.serie-docto   = tt-item-doc-est.serie-docto      
                                      tt-impto-item-docto.nro-docto     = string(tt-item-doc-est.nro-docto)
                                      tt-impto-item-docto.cod-emitente  = tt-item-doc-est.cod-emitente     
                                      tt-impto-item-docto.nat-operacao  = tt-item-doc-est.nat-operacao     
                                      tt-impto-item-docto.num-seq       = tt-item-doc-est.sequencia        
                                      tt-impto-item-docto.cdn-imposto   = tipo-tax.cod-tax.
                           END.
            
                           ASSIGN tt-impto-item-docto.perc-imposto = tipo-tax.tax-perc
                                  tt-impto-item-docto.val-impto    = tt-impto-item-docto.val-impto 
                                                                   + (((tt-desp-rateio.val-desp * d-qtd-item-orig) / tt-ordens-totais.quantidade) * (tipo-tax.tax-perc / 100)).
                       END.
                       ELSE
                           ASSIGN i-taxa-iva = 1.                           
                   END.
                END.

                ASSIGN tt-pryext-item-docto-estoq.val-preco-unit-isento  = tt-pryext-item-docto-estoq.val-preco-unit-isento  + ((tt-desp-rateio.val-desp-isento-mo * d-qtd-item-orig) / tt-ordens-totais.quantidade)
                       tt-pryext-item-docto-estoq.val-preco-unit-com-iva = tt-pryext-item-docto-estoq.val-preco-unit-com-iva + ((tt-desp-rateio.val-desp-mo * i-taxa-iva * d-qtd-item-orig) / tt-ordens-totais.quantidade).
            END.
    
            /** CRIA€ÇO DESPESAS DE IMPORTA€ÇO **/
            FIND FIRST tt-docum-est-cex
                WHERE tt-docum-est-cex.serie-docto       = tt-item-doc-est.serie-docto
                  AND tt-docum-est-cex.nro-docto         = string(tt-item-doc-est.nro-docto)
                  AND tt-docum-est-cex.cod-emitente      = tt-item-doc-est.cod-emitente
                  AND tt-docum-est-cex.nat-operacao      = tt-item-doc-est.nat-operacao
                  AND tt-docum-est-cex.cod-emitente-desp = i-cod-emitente-desp
                  AND tt-docum-est-cex.cod-desp          = tt-desp-rateio.cod-desp NO-ERROR.
            IF NOT AVAIL tt-docum-est-cex THEN DO:
                CREATE tt-docum-est-cex.
                ASSIGN tt-docum-est-cex.serie-docto       = tt-item-doc-est.serie-docto
                       tt-docum-est-cex.nro-docto         = string(tt-item-doc-est.nro-docto)
                       tt-docum-est-cex.cod-emitente      = tt-item-doc-est.cod-emitente
                       tt-docum-est-cex.nat-operacao      = tt-item-doc-est.nat-operacao
                       tt-docum-est-cex.cod-emitente-desp = i-cod-emitente-desp
                       tt-docum-est-cex.cod-desp          = tt-desp-rateio.cod-desp.
            END.
    
            ASSIGN tt-docum-est-cex.cod-cond-pag      = i-cod-cond-pag
                   tt-docum-est-cex.mo-codigo         = 0
                   tt-docum-est-cex.cotacao           = 1
                   tt-docum-est-cex.val-desp          = if   tt-docum-est-cex.val-desp = ? then 0 
                                                        else tt-docum-est-cex.val-desp + (((tt-desp-rateio.val-desp + tt-desp-rateio.val-desp-isento) * d-qtd-item-orig) / tt-ordens-totais.quantidade).
    
            FIND FIRST tt-item-doc-est-cex
                 WHERE tt-item-doc-est-cex.serie-docto       = tt-item-doc-est.serie-docto      
                   AND tt-item-doc-est-cex.nro-docto         = string(tt-item-doc-est.nro-docto)
                   AND tt-item-doc-est-cex.cod-emitente      = tt-item-doc-est.cod-emitente     
                   AND tt-item-doc-est-cex.nat-operacao      = tt-item-doc-est.nat-operacao     
                   AND tt-item-doc-est-cex.sequencia         = tt-item-doc-est.sequencia        
                   AND tt-item-doc-est-cex.cod-emitente-desp = i-cod-emitente-desp
                   AND tt-item-doc-est-cex.cod-desp          = tt-desp-rateio.cod-desp NO-ERROR.

            /* Cria somente se valor da item-doc-est-cex for maior que 0 */
            IF (((tt-desp-rateio.val-desp + tt-desp-rateio.val-desp-isento)* d-qtd-item-orig) / tt-ordens-totais.quantidade) > 0 THEN DO:

                IF NOT AVAIL tt-item-doc-est-cex THEN DO:
                    CREATE tt-item-doc-est-cex.
                    ASSIGN tt-item-doc-est-cex.serie-docto       = tt-item-doc-est.serie-docto      
                           tt-item-doc-est-cex.nro-docto         = string(tt-item-doc-est.nro-docto)
                           tt-item-doc-est-cex.cod-emitente      = tt-item-doc-est.cod-emitente     
                           tt-item-doc-est-cex.nat-operacao      = tt-item-doc-est.nat-operacao     
                           tt-item-doc-est-cex.sequencia         = tt-item-doc-est.sequencia        
                           tt-item-doc-est-cex.cod-emitente-desp = i-cod-emitente-desp
                           tt-item-doc-est-cex.cod-desp          = tt-desp-rateio.cod-desp.              
                END.
        
                ASSIGN tt-item-doc-est-cex.mo-codigo         = 0
                       tt-item-doc-est-cex.cotacao           = 1
                       tt-item-doc-est-cex.embarque          = trim(substring(tt-docum-est-orig.char-1,1,20))
                       tt-item-doc-est-cex.cod-estabel       = tt-docum-est-orig.cod-estabel
                       tt-item-doc-est-cex.num-seq-orig      = item-doc-est.sequencia
                       tt-item-doc-est-cex.dat-cotac         = tt-parametros.da-cotacao
                       tt-item-doc-est-cex.val-desp          = if   tt-item-doc-est-cex.val-desp = ? then 0
                                                           else tt-item-doc-est-cex.val-desp + (((tt-desp-rateio.val-desp + tt-desp-rateio.val-desp-isento)* d-qtd-item-orig) / tt-ordens-totais.quantidade).

                IF i-pais-impto-usuario = 9 /* Paraguai */ THEN DO:
                
                    FIND FIRST tt-item-doc-est-cex-internac
                         WHERE tt-item-doc-est-cex-internac.serie-docto       = tt-item-doc-est.serie-docto      
                           AND tt-item-doc-est-cex-internac.nro-docto         = string(tt-item-doc-est.nro-docto)
                           AND tt-item-doc-est-cex-internac.cod-emitente      = tt-item-doc-est.cod-emitente     
                           AND tt-item-doc-est-cex-internac.nat-operacao      = tt-item-doc-est.nat-operacao     
                           AND tt-item-doc-est-cex-internac.sequencia         = tt-item-doc-est.sequencia        
                           AND tt-item-doc-est-cex-internac.cod-emitente-desp = i-cod-emitente-desp
                           AND tt-item-doc-est-cex-internac.cod-desp          = tt-desp-rateio.cod-desp NO-ERROR. 
    
                    IF NOT AVAIL item-doc-est-cex-internac THEN DO:
                        CREATE tt-item-doc-est-cex-internac.
                        ASSIGN tt-item-doc-est-cex-internac.serie-docto       = tt-item-doc-est.serie-docto      
                               tt-item-doc-est-cex-internac.nro-docto         = string(tt-item-doc-est.nro-docto)
                               tt-item-doc-est-cex-internac.cod-emitente      = tt-item-doc-est.cod-emitente     
                               tt-item-doc-est-cex-internac.nat-operacao      = tt-item-doc-est.nat-operacao     
                               tt-item-doc-est-cex-internac.sequencia         = tt-item-doc-est.sequencia        
                               tt-item-doc-est-cex-internac.cod-emitente-desp = i-cod-emitente-desp
                               tt-item-doc-est-cex-internac.cod-desp          = tt-desp-rateio.cod-desp.
                    END.
    
                    FIND FIRST tt-selecao-despesa
                        WHERE  tt-selecao-despesa.cod-estabel = tt-parametros.cod-estabel
                          AND  tt-selecao-despesa.embarque    = trim(substring(tt-docum-est-orig.char-1,1,20))
                          AND  tt-selecao-despesa.cod-desp    = tt-desp-rateio.cod-desp     NO-ERROR.
    
                    
                    ASSIGN i-taxa-iva = 1
                           i-imposto  = 0.
    
                    IF tt-desp-rateio.val-desp-mo > 0 THEN DO:
                        FIND FIRST despes-embarq-internac 
                             where despes-embarq-internac.cod-estabel       = tt-selecao-despesa.cod-estabel
                               and despes-embarq-internac.embarque          = tt-selecao-despesa.embarque
                               and despes-embarq-internac.cod-itiner        = tt-selecao-despesa.cod-itiner
                               and despes-embarq-internac.cod-pto-contr     = tt-selecao-despesa.cod-pto-contr
                               and despes-embarq-internac.cod-desp          = tt-selecao-despesa.cod-desp
                               and despes-embarq-internac.cod-emitente-desp = tt-selecao-despesa.cod-emitente-desp no-lock no-error.
    
                       IF AVAIL despes-embarq-internac THEN DO:
                           FIND FIRST tipo-tax WHERE tipo-tax.cod-tax = despes-embarq-internac.cdn-imposto NO-LOCK NO-ERROR.
                           IF AVAIL tipo-tax THEN 
                               ASSIGN i-taxa-iva = 1 + (tipo-tax.tax-perc / 100)
                                      i-imposto  = tipo-tax.cod-tax.                       
                       END.
                    END.
    
                    ASSIGN tt-item-doc-est-cex-internac.val-preco-unit         = IF tt-item-doc-est-cex-internac.val-preco-unit = ? THEN 0
                                                                                 ELSE tt-item-doc-est-cex-internac.val-preco-unit + ((tt-desp-rateio.val-desp * d-qtd-item-orig) / tt-ordens-totais.quantidade)
                           tt-item-doc-est-cex-internac.val-preco-unit-isento  = IF tt-item-doc-est-cex-internac.val-preco-unit-isento = ? THEN 0
                                                                                 ELSE tt-item-doc-est-cex-internac.val-preco-unit-isento + ((tt-desp-rateio.val-desp-isento * d-qtd-item-orig) / tt-ordens-totais.quantidade)
                           tt-item-doc-est-cex-internac.val-preco-unit-com-iva = IF tt-item-doc-est-cex-internac.val-preco-unit-com-iva = ? THEN 0
                                                                                 ELSE tt-item-doc-est-cex-internac.val-preco-unit-com-iva + ((tt-desp-rateio.val-desp * i-taxa-iva * d-qtd-item-orig) / tt-ordens-totais.quantidade)
                           tt-item-doc-est-cex-internac.cdn-imposto            = i-imposto.                        
                END.
            END.
        END.  /* for each tt-desp-rateio */


    END.
    
    IF  NOT CAN-FIND(FIRST tt-item-doc-est) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.
/*****************************************/

/** generateTT-rat-docum **/
PROCEDURE generateTT-rat-docum:
    
    FOR EACH tt-docum-est-orig:
        /** BUSCA NF PRINCIPAL **/
        FOR FIRST docum-est FIELDS (ind-rateio)
            WHERE docum-est.serie-docto  = tt-docum-est-orig.serie-docto 
              AND docum-est.nro-docto    = tt-docum-est-orig.nro-docto
              AND docum-est.cod-emitente = tt-docum-est-orig.cod-emitente
              AND docum-est.nat-operacao = tt-docum-est-orig.nat-operacao EXCLUSIVE-LOCK:

            ASSIGN docum-est.ind-rateio = YES.
        END.
        
        CREATE tt-rat-docum.
        ASSIGN tt-rat-docum.cod-emitente = tt-docum-est.cod-emitente
               tt-rat-docum.nat-operacao = tt-docum-est.nat-operacao 
               tt-rat-docum.nro-docto    = tt-docum-est.nro-docto 
               tt-rat-docum.serie-docto  = tt-docum-est.serie-docto      
               tt-rat-docum.nf-emitente  = tt-docum-est-orig.cod-emitente
               tt-rat-docum.nf-nat-oper  = tt-docum-est-orig.nat-operacao 
               tt-rat-docum.nf-nro       = tt-docum-est-orig.nro-docto
               tt-rat-docum.nf-serie     = tt-docum-est-orig.serie-docto.
    END.

    RETURN "OK":U.
END PROCEDURE.
/*****************************************/

/** setTtDespTotaisEmbarquesMult **/
PROCEDURE setTtDespTotaisEmbarquesMult:
    DEF INPUT PARAMETER TABLE FOR tt-desp-totais-embarques-mult.
        
    RETURN "OK":U.
END PROCEDURE.
/*****************************************/

/** generateTT-dupli-apagar **/
PROCEDURE generateTT-dupli-apagar:
    DEF VAR da-data         AS DATE   extent 12           NO-UNDO.
    DEF VAR da-partida      AS DATE                       NO-UNDO.
    DEF VAR dt-vencim       AS DATE   format "99/99/9999" NO-UNDO.
    DEF VAR i-ind           AS INTEGER                    NO-UNDO.
    DEF VAR de-vl-apagar    LIKE dupli-apagar.vl-a-pagar  NO-UNDO.
    DEF VAR de-vl-apagar-mo LIKE dupli-apagar.vl-a-pagar  NO-UNDO.

    FIND FIRST tt-docum-est NO-ERROR.
    
    IF  NOT tt-parametros-aux.emite-duplic THEN
        RETURN "OK":U.
    
    IF  tt-parametros-aux.valor-duplic <= 0 THEN
        RETURN "OK":U.
    
    IF tt-parametros.d-cotacao = 0 THEN
        RUN cdp/cd0812.p (INPUT  0,
                          INPUT  tt-parametros-aux.mo-codigo,
                          INPUT  tt-parametros-aux.valor-duplic,
                          INPUT  tt-parametros.da-cotacao,
                          OUTPUT tt-parametros-aux.valor-duplic-me).
    ELSE
        RUN cdp/cd0812a.p (INPUT  0,
                           INPUT  tt-parametros-aux.mo-codigo,
                           INPUT  tt-parametros-aux.valor-duplic,
                           INPUT  tt-parametros.d-cotacao,
                           OUTPUT tt-parametros-aux.valor-duplic-me).     
    
    IF  tt-parametros-aux.valor-duplic-me = ? THEN
        ASSIGN tt-parametros-aux.valor-duplic-me = 0.
        
    FOR FIRST emitente FIELDS(ven-domingo ven-sabado ven-feriado)
        WHERE emitente.cod-emitente = tt-parametros.cod-emitente-desp NO-LOCK: 
    END.

    FOR FIRST cond-pagto
        WHERE cond-pagto.cod-cond-pag = tt-parametros-aux.cod-cond-pag NO-LOCK:
    END.
    IF NOT AVAIL cond-pagto THEN NEXT.
    
    ASSIGN da-data    = TODAY
           da-partida = tt-parametros-aux.da-partida.
   
    {cdp/cd9020.i7 tt-parametros.cod-estabel} /* calculo data de vencimento */                
        
    DO  i-ind = 1 TO cond-pagto.num-parcelas:    
    
        IF  da-data[i-ind] < TODAY THEN
            ASSIGN dt-vencim = TODAY.
        ELSE
            ASSIGN dt-vencim = da-data[i-ind].
            
        CREATE tt-dupli-apagar.
        ASSIGN tt-dupli-apagar.cod-emitente  = tt-parametros.cod-emitente-desp
               tt-dupli-apagar.dt-vencim     = dt-vencim
               tt-dupli-apagar.dt-emissao    = tt-parametros.da-emissao
               tt-dupli-apagar.dt-trans      = tt-parametros.da-trans
               tt-dupli-apagar.nat-operacao  = tt-parametros.nat-operacao
               tt-dupli-apagar.nro-docto     = tt-docum-est.nro-docto
               tt-dupli-apagar.parcela       = string(i-ind)
               tt-dupli-apagar.serie-docto   = tt-parametros.serie
               tt-dupli-apagar.nr-duplic     = tt-docum-est.nro-docto
               tt-dupli-apagar.tp-despesa    = tt-parametros-aux.tp-despesa
               tt-dupli-apagar.cod-esp       = tt-parametros-aux.esp-tit-rec
               tt-dupli-apagar.mo-codigo     = c-moeda
               tt-dupli-apagar.vl-a-pagar    = tt-parametros-aux.valor-duplic
                                             * cond-pagto.per-pg-dup[i-ind] / 100
               tt-dupli-apagar.vl-a-pagar-mo = tt-parametros-aux.valor-duplic-me
                                             * cond-pagto.per-pg-dup[i-ind] / 100.
    END.
    
    FOR EACH tt-dupli-apagar:
        ASSIGN de-vl-apagar    = de-vl-apagar    + tt-dupli-apagar.vl-a-pagar
               de-vl-apagar-mo = de-vl-apagar-mo + tt-dupli-apagar.vl-a-pagar-mo.
    END.
    
    IF  de-vl-apagar <> tt-parametros-aux.valor-duplic THEN DO:
        FIND LAST tt-dupli-apagar NO-ERROR.
        ASSIGN tt-dupli-apagar.vl-a-pagar = tt-dupli-apagar.vl-a-pagar 
                                          + (tt-parametros-aux.valor-duplic - de-vl-apagar).
    END.
    
    IF  de-vl-apagar-mo <> tt-parametros-aux.valor-duplic-me THEN DO:
        FIND LAST tt-dupli-apagar NO-ERROR.
        ASSIGN tt-dupli-apagar.vl-a-pagar-mo = tt-dupli-apagar.vl-a-pagar-mo 
                                             + (tt-parametros-aux.valor-duplic-me - de-vl-apagar-mo).
    END.

    FOR EACH tt-dupli-apagar:
        {rep/re1001c.i50}  /* vari veis e informa‡äes utilizadas pelo re1001c.i51 */        

        assign i-mo-codigo      = tt-dupli-apagar.mo-codigo  
               de-vl-a-pagar-mo = tt-dupli-apagar.vl-a-pagar-mo
               de-vl-descto-mo  = 0.           
        
        {rep/re1001c.i51 "no"}                    
        {cdp/cd4300.i4  "no" tt-dupli-apagar.char-1}   
    END.
    
    RETURN "OK":U.
END PROCEDURE.
/*****************************************/

procedure generateTT-dupli-apagar-cex:

    /** Cria‡Æo das duplicatas das despesas **/
    def var de-dup-tot              like dupli-apagar.vl-a-pagar     no-undo.
    def var de-dup-tot-mo           like dupli-apagar.vl-a-pagar     no-undo.    
    def var de-val-desp             like dupli-apagar-cex.vl-a-pagar no-undo.
    def var de-val-desp-mo          like dupli-apagar-cex.vl-a-pagar no-undo.
    def var de-total-dup            like dupli-apagar.vl-a-pagar     no-undo.
    def var de-total-dup-mo         like dupli-apagar.vl-a-pagar     no-undo.
    def var i-ind                   as int                           no-undo.
    def var da-data                 as date                          no-undo extent 12.
    def var i-parcela               as int                           no-undo.
    def var c-cod-estabel           LIKE estabelec.cod-estabel       NO-UNDO.
    def var c-embarque              as character format "x(20)":U    no-undo.

    DEF VAR i-cod-emitente-desp-ant AS INT NO-UNDO.
    
    if  not tt-parametros-aux.emite-duplic then
        return "OK":U.
    
    for each tt-dupli-apagar-cex:
        delete tt-dupli-apagar-cex.
    end.
    
    find first tt-docum-est no-error.
    find docum-est NO-LOCK of tt-docum-est no-error.
    if  avail docum-est then do:

        find param-imp
            where param-imp.cod-estabel = docum-est.cod-estabel no-lock no-error.

        for each  docum-est-cex 
            where docum-est-cex.serie-docto   = docum-est.serie-docto
            &if defined(bf-mat-comex) &then          
                and   docum-est-cex.nro-docto = string(docum-est.nro-docto)
            &else
                and   docum-est-cex.nro-docto = docum-est.nro-docto       
            &endif 
            and   docum-est-cex.cod-emitente  = docum-est.cod-emitente
            and   docum-est-cex.nat-operacao  = docum-est.nat-operacao no-lock
            USE-INDEX codigo:
               
            /* Testa se despesa incide no valor da duplicata */
            find desp-imp
                where desp-imp.cod-desp = docum-est-cex.cod-desp no-lock no-error.
            if  avail desp-imp
            and not desp-imp.inc-val-duplic then
                next.
               
            find emitente
                where emitente.cod-emitente = docum-est-cex.cod-emitente-desp no-lock no-error.
                
            find tt-desp-totais-embarques-mult
                where tt-desp-totais-embarques-mult.cod-desp          = docum-est-cex.cod-desp 
                and   tt-desp-totais-embarques-mult.cod-emitente-desp = docum-est-cex.cod-emitente-desp no-error.
            if  not avail tt-desp-totais-embarques-mult then
                next.        
        
            IF  AVAIL param-imp THEN
                ASSIGN c-espec-padr = param-imp.esp-tit-rec.
    
            
            FOR FIRST desp-imp NO-LOCK
                WHERE desp-imp.cod-desp = docum-est-cex.cod-desp
                  AND {&vcod-espec-padr} <> "":
                
                ASSIGN c-espec-padr = {&vcod-espec-padr}.
            END.
            
        
            for each  item-doc-est-cex
                where item-doc-est-cex.serie-docto       = docum-est-cex.serie-docto
                and   item-doc-est-cex.nro-docto         = docum-est-cex.nro-docto
                and   item-doc-est-cex.cod-emitente      = docum-est-cex.cod-emitente
                and   item-doc-est-cex.nat-operacao      = docum-est-cex.nat-operacao
                and   item-doc-est-cex.cod-emitente-desp = docum-est-cex.cod-emitente-desp          
                and   item-doc-est-cex.cod-desp          = docum-est-cex.cod-desp
                and   item-doc-est-cex.mo-codigo         = docum-est-cex.mo-codigo no-lock
                USE-INDEX codigo:

                assign c-embarque    = item-doc-est-cex.embarque   
                       c-cod-estabel = item-doc-est-cex.cod-estabel.
        
                find item-doc-est 
                    where item-doc-est.serie-docto   = item-doc-est-cex.serie-docto
                    &if defined(bf-mat-comex) &then 
                        and   item-doc-est.nro-docto = int(item-doc-est-cex.nro-docto)
                    &else
                        and   item-doc-est.nro-docto = item-doc-est-cex.nro-docto
                    &endif
                    and   item-doc-est.cod-emitente  = item-doc-est-cex.cod-emitente
                    and   item-doc-est.nat-operacao  = item-doc-est-cex.nat-operacao
                    and   item-doc-est.sequencia     = item-doc-est-cex.sequencia no-lock no-error.             
                      
                assign de-val-desp    = item-doc-est-cex.val-desp
                       de-val-desp-mo = item-doc-est-cex.val-desp.
                
                if  tt-desp-totais-embarques-mult.mo-codigo <> 0 then do:
                    IF tt-parametros.d-cotacao = 0 THEN
                        run cdp/cd0812.p (input 0,
                                          input tt-desp-totais-embarques-mult.mo-codigo,
                                          input de-val-desp,
                                          &if '{&bf_mat_versao_ems}' >= '2.06' &then
                                              input item-doc-est-cex.dat-cotac,
                                          &else
                                              input item-doc-est-cex.data-1,
                                          &endif
                                          output de-val-desp-mo).
                    ELSE
                        run cdp/cd0812a.p (input 0,
                                           input tt-desp-totais-embarques-mult.mo-codigo,
                                           input de-val-desp,
                                           input tt-parametros.d-cotacao,
                                           output de-val-desp-mo).
                end.

                if  de-val-desp-mo = ? then
                    assign de-val-desp-mo = 0.

                find ordem-compra
                    where ordem-compra.numero-ordem = item-doc-est.numero-ordem no-lock no-error.
                 
                find cond-pagto
                    where cond-pagto.cod-cond-pag = docum-est-cex.cod-cond-pag no-lock no-error.

                if  not avail cond-pagto then do:
                    find cond-especif-cex
                        where cond-especif-cex.num-pedido        = ordem-compra.num-pedido
                        and   cond-especif-cex.cod-emitente-desp = docum-est-cex.cod-emitente-desp
                        and   cond-especif-cex.cod-desp          = docum-est-cex.cod-desp no-lock no-error.
                    if  not avail cond-especif-cex then 
                        next.
                    else do:
                        /* Condicao especifica de pagamento */
                        do  i-ind = 1 to 6:
                            if  cond-especif-cex.data-pagto[i-ind] <> ? then do:                    
                                create tt-dupli-apagar-cex.
                                assign tt-dupli-apagar-cex.cod-emitente      = docum-est-cex.cod-emitente
                                       tt-dupli-apagar-cex.nat-operacao      = docum-est.nat-operacao
                                       tt-dupli-apagar-cex.serie-docto       = docum-est.serie-docto                               
                                       &if defined(bf-mat-comex) &then                     
                                           tt-dupli-apagar-cex.nro-docto     = string(docum-est.nro-docto)                               
                                       &else
                                           tt-dupli-apagar-cex.nro-docto     = docum-est.nro-docto                              
                                       &endif 
                                       tt-dupli-apagar-cex.cod-emitente-desp = docum-est-cex.cod-emitente-desp
                                       tt-dupli-apagar-cex.cod-desp          = docum-est-cex.cod-desp                               
                                       tt-dupli-apagar-cex.mo-codigo         = tt-desp-totais-embarques-mult.mo-codigo
                                       tt-dupli-apagar-cex.dt-vencim         = cond-especif-cex.data-pagto[i-ind]
                                       &IF  "{&bf_mat_versao_ems}" < "2.062" &THEN
                                       tt-dupli-apagar-cex.tp-despesa        = emitente.tp-desp-padrao
                                       &ELSE
                                       tt-dupli-apagar-cex.tp-despesa        = tt-desp-totais-embarques-mult.tp-despesa
                                       &ENDIF
                                       tt-dupli-apagar-cex.vl-a-pagar        = de-val-desp
                                                                             * cond-especif-cex.perc-pagto[i-ind] / 100
                                       tt-dupli-apagar-cex.vl-a-pagar-mo     = de-val-desp-mo
                                                                             * cond-especif-cex.perc-pagto[i-ind] / 100
                                       tt-dupli-apagar-cex.cod-esp           = c-espec-padr
                                       tt-dupli-apagar-cex.cod-estabel       = docum-est.cod-estabel.
                            end.
                        end.
                    end.
                end.
                else do:        
                    assign da-data    = today.

                    for first historico-embarque fields (cod-itiner)
                        where historico-embarque.cod-estabel = tt-parametros-aux.cod-estabel
                        and   historico-embarque.embarque    = c-embarque no-lock: end.

                    for first itinerario fields (cod-itiner)
                        where itinerario.cod-itiner = historico-embarque.cod-itiner no-lock: end.

                    IF NOT AVAIL itinerario THEN NEXT.

                    for first historico-embarque fields (dt-efetiva)
                        where historico-embarque.cod-estabel   = tt-parametros-aux.cod-estabel
                        and   historico-embarque.embarque      = c-embarque
                        and   historico-embarque.cod-itiner    = itinerario.cod-itiner
                        and   historico-embarque.cod-pto-contr = tt-desp-totais-embarques-mult.cod-pto-contr no-lock: end. 
                    if  avail historico-embarque then do:
                        if  historico-embarque.dt-efetiva = ? then
                            assign da-partida = historico-embarque.dt-ult-previsao.
                        else
                            assign da-partida = historico-embarque.dt-efetiva.
                    end.
                    else
                        assign da-partida = docum-est.dt-emissao.

                    {cdp/cd9020.i7 docum-est.cod-estabel x}

                    do  i-ind = 1 to cond-pagto.num-parcelas:
                        
                        if  da-data[i-ind] < today then 
                            assign da-data[i-ind] = docum-est.dt-emissao.

                        create tt-dupli-apagar-cex.
                        assign tt-dupli-apagar-cex.cod-emitente      = docum-est-cex.cod-emitente
                               tt-dupli-apagar-cex.nat-operacao      = docum-est.nat-operacao
                               tt-dupli-apagar-cex.serie-docto       = docum-est.serie-docto                               
                               tt-dupli-apagar-cex.nro-docto         = docum-est.nro-docto                               
                               tt-dupli-apagar-cex.cod-emitente-desp = docum-est-cex.cod-emitente-desp                
                               tt-dupli-apagar-cex.cod-desp          = docum-est-cex.cod-desp
                               tt-dupli-apagar-cex.mo-codigo         = tt-desp-totais-embarques-mult.mo-codigo                       
                               tt-dupli-apagar-cex.dt-vencim         = da-data[i-ind]
                               tt-dupli-apagar-cex.tp-despesa        = tt-desp-totais-embarques-mult.tp-despesa
                               tt-dupli-apagar-cex.vl-a-pagar        = de-val-desp 
                                                                     * cond-pagto.per-pg-dup[i-ind] / 100   
                               tt-dupli-apagar-cex.vl-a-pagar-mo     = de-val-desp-mo 
                                                                     * cond-pagto.per-pg-dup[i-ind] / 100
                               tt-dupli-apagar-cex.cod-esp           = c-espec-padr
                               tt-dupli-apagar-cex.cod-estabel       = docum-est.cod-estabel.
                    end.

                end.
            end.    
            
            /** Ajuste das diferen‡as do total das duplicatas de despesas com o valor da despesa **/
            assign de-dup-tot    = 0
                   de-dup-tot-mo = 0.    
            for each  tt-dupli-apagar-cex
                where tt-dupli-apagar-cex.serie-docto       = docum-est.serie-docto
                and   tt-dupli-apagar-cex.nro-docto         = docum-est.nro-docto
                and   tt-dupli-apagar-cex.cod-emitente      = docum-est-cex.cod-emitente
                and   tt-dupli-apagar-cex.nat-operacao      = docum-est.nat-operacao
                and   tt-dupli-apagar-cex.cod-desp          = docum-est-cex.cod-desp
                and   tt-dupli-apagar-cex.cod-emitente-desp = docum-est-cex.cod-emitente-desp
                USE-INDEX codigo:

                assign de-dup-tot    = de-dup-tot 
                                     + tt-dupli-apagar-cex.vl-a-pagar 
                       de-dup-tot-mo = de-dup-tot-mo 
                                     + tt-dupli-apagar-cex.vl-a-pagar-mo.
            end.
        
            if  docum-est-cex.val-desp <> de-dup-tot then do:
                find last tt-dupli-apagar-cex
                    where tt-dupli-apagar-cex.serie-docto       = docum-est.serie-docto
                    and   tt-dupli-apagar-cex.nro-docto         = docum-est.nro-docto
                    and   tt-dupli-apagar-cex.cod-emitente      = docum-est-cex.cod-emitente
                    and   tt-dupli-apagar-cex.nat-operacao      = docum-est.nat-operacao
                    and   tt-dupli-apagar-cex.cod-desp          = docum-est-cex.cod-desp
                    and   tt-dupli-apagar-cex.cod-emitente-desp = docum-est-cex.cod-emitente-desp no-error.        
                if  avail tt-dupli-apagar-cex then
                    assign tt-dupli-apagar-cex.vl-a-pagar    = tt-dupli-apagar-cex.vl-a-pagar
                                                          + ( docum-est-cex.val-desp - de-dup-tot ).
            end.
            
            if  tt-desp-totais-embarques-mult.val-desp-mo <> de-dup-tot-mo then do:
                find last tt-dupli-apagar-cex
                    where tt-dupli-apagar-cex.serie-docto       = docum-est.serie-docto
                    &if defined(bf-mat-comex) &then                                 
                        and   tt-dupli-apagar-cex.nro-docto     = string(docum-est.nro-docto)
                    &else
                        and   tt-dupli-apagar-cex.nro-docto     = docum-est.nro-docto
                    &endif
                    and   tt-dupli-apagar-cex.cod-emitente      = docum-est-cex.cod-emitente
                    and   tt-dupli-apagar-cex.nat-operacao      = docum-est.nat-operacao
                    and   tt-dupli-apagar-cex.cod-desp          = docum-est-cex.cod-desp
                    and   tt-dupli-apagar-cex.cod-emitente-desp = docum-est-cex.cod-emitente-desp no-error.
                if  avail tt-dupli-apagar-cex then
                    assign tt-dupli-apagar-cex.vl-a-pagar-mo = tt-dupli-apagar-cex.vl-a-pagar-mo
                                                             + ( tt-desp-totais-embarques-mult.val-desp-mo - de-dup-tot-mo ).
            end.
        end.
        
        /* Correcao dos valores criados para a duplicata de despesas */
        /* Organiza conforme fornecedor e data de vencimento */
        for each tt-dupli-apagar-cex no-lock 
            break by tt-dupli-apagar-cex.cod-emitente-desp
                  by tt-dupli-apagar-cex.cod-esp
                  by tt-dupli-apagar-cex.dt-vencim
                  by tt-dupli-apagar-cex.tp-despesa
                  by tt-dupli-apagar-cex.mo-codigo:

            IF  tt-dupli-apagar-cex.cod-emitente-desp <> i-cod-emitente-desp-ant
            OR  i-cod-emitente-desp-ant = 0 THEN DO:
                ASSIGN i-parcela = 0
                       i-cod-emitente-desp-ant = tt-dupli-apagar-cex.cod-emitente-desp.
            END.

            if  first-of(tt-dupli-apagar-cex.cod-emitente-desp)
            or  first-of(tt-dupli-apagar-cex.cod-esp) 
            or  first-of(tt-dupli-apagar-cex.dt-vencim)
            or  first-of(tt-dupli-apagar-cex.tp-despesa)
            or  first-of(tt-dupli-apagar-cex.mo-codigo)            
            then 
                assign de-total-dup    = 0
                       de-total-dup-mo = 0
                       i-parcela       = i-parcela + 1.

            assign de-total-dup    = de-total-dup 
                                   + tt-dupli-apagar-cex.vl-a-pagar
                   de-total-dup-mo = de-total-dup-mo 
                                   + tt-dupli-apagar-cex.vl-a-pagar-mo. 
                   
            IF  LAST-OF(tt-dupli-apagar-cex.cod-emitente-desp)
            OR  LAST-OF(tt-dupli-apagar-cex.cod-esp) 
            OR  LAST-OF(tt-dupli-apagar-cex.dt-vencim)
            OR  LAST-OF(tt-dupli-apagar-cex.tp-despesa)
            OR  LAST-OF(tt-dupli-apagar-cex.mo-codigo)             
            THEN DO:
                find dupli-apagar-cex 
                    where dupli-apagar-cex.serie-docto       = tt-dupli-apagar-cex.serie-docto 
                    and   dupli-apagar-cex.nro-docto         = tt-dupli-apagar-cex.nro-docto 
                    and   dupli-apagar-cex.cod-emitente      = tt-dupli-apagar-cex.cod-emitente
                    and   dupli-apagar-cex.nat-operacao      = tt-dupli-apagar-cex.nat-operacao
                    and   dupli-apagar-cex.cod-emitente-desp = tt-dupli-apagar-cex.cod-emitente-desp
                    AND   dupli-apagar-cex.cod-esp           = tt-dupli-apagar-cex.cod-esp
                    AND   dupli-apagar-cex.tp-despesa        = tt-dupli-apagar-cex.tp-despesa
                    and   dupli-apagar-cex.parcela           = string(i-parcela) exclusive-lock no-error.
                if  not avail dupli-apagar-cex then do:
        
                    create dupli-apagar-cex.
                    assign dupli-apagar-cex.cod-emitente      = tt-dupli-apagar-cex.cod-emitente
                           dupli-apagar-cex.dt-vencim         = tt-dupli-apagar-cex.dt-vencim
                           dupli-apagar-cex.nat-operacao      = tt-dupli-apagar-cex.nat-operacao
                           dupli-apagar-cex.nro-docto         = tt-dupli-apagar-cex.nro-docto
                           dupli-apagar-cex.cod-emitente-desp = tt-dupli-apagar-cex.cod-emitente-desp                   
                           dupli-apagar-cex.parcela           = string(i-parcela)
                           dupli-apagar-cex.serie-docto       = tt-dupli-apagar-cex.serie-docto
                           dupli-apagar-cex.nr-duplic         = tt-dupli-apagar-cex.nro-docto
                           dupli-apagar-cex.tp-despesa        = tt-dupli-apagar-cex.tp-despesa
                           dupli-apagar-cex.cod-esp           = tt-dupli-apagar-cex.cod-esp
                           dupli-apagar-cex.mo-codigo         = tt-dupli-apagar-cex.mo-codigo
                           dupli-apagar-cex.dt-emissao        = tt-docum-est.dt-emissao
                           dupli-apagar-cex.dt-trans          = tt-docum-est.dt-trans
                           dupli-apagar-cex.cod-estabel       = tt-dupli-apagar-cex.cod-estabel.
                end.
                assign dupli-apagar-cex.vl-a-pagar-mo = dupli-apagar-cex.vl-a-pagar-mo
                                                      + de-total-dup-mo
                       dupli-apagar-cex.vl-a-pagar    = dupli-apagar-cex.vl-a-pagar
                                                      + de-total-dup
                       dupli-apagar-cex.valor-a-pagar-me = dupli-apagar-cex.vl-a-pagar.
            end.
        end.
    end.
    
    /***********************************************************************/
    FOR EACH tt-epc WHERE tt-epc.cod-event = "Retencao-Imposto-NFC":U:
        DELETE tt-epc.
    END.
    
    /* Criacao temp-table tt-epc */
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "Retencao-Imposto-NFC":U
           tt-epc.cod-parameter = "r-docum-est":U
           tt-epc.val-parameter = STRING(ROWID(docum-est)).
    
    /* Chamada EPC */
    {include/i-epc201.i "Retencao-Imposto-NFC"}
    /***********************************************************************/
    
    return "OK":U.

end procedure.
/** generateDocumento **/
PROCEDURE generateDocumento:
    DEFINE VARIABLE c-param AS CHARACTER   NO-UNDO.

    RUN rep/reapi316b.p (INPUT  "ADD":U,
                         INPUT  TABLE tt-docum-est,
                         INPUT  TABLE tt-rat-docum,
                         INPUT  TABLE tt-item-doc-est,
                         INPUT  TABLE tt-dupli-apagar,
                         INPUT  TABLE tt-dupli-imp,
                         OUTPUT TABLE tt-erro).
    FOR EACH tt-erro:
        ASSIGN i-seq-erro = i-seq-erro + 1.
        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = tt-erro.cd-erro
               tt-bo-erro.mensagem = tt-erro.desc-erro.
    END.

    IF  CAN-FIND(FIRST tt-erro) THEN
        RETURN "NOK":U.
       
    RUN updateDocumento.
    IF  RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RUN updateItemDocumento.
    IF  RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    
    RUN updateDespesas.
    IF  RETURN-VALUE = "NOK" THEN
        RETURN "NOK".

    RUN updateDuplicatas.
    IF  RETURN-VALUE = "NOK" THEN
        RETURN "NOK".

    RUN createDespesasImp.
    IF  RETURN-VALUE = "NOK":U then
        RETURN "NOK":U.

    RUN createImpostos.
    IF  RETURN-VALUE = "NOK":U then
        RETURN "NOK":U.

    IF  l-mat-unid-negoc 
    AND l-unidade-negocio THEN DO:
        RUN createUnidNegNota.
        IF  RETURN-VALUE = "NOK":U then
            RETURN "NOK":U.
    END.
    
    FIND FIRST tt-docum-est NO-ERROR.
    ASSIGN c-param = tt-docum-est.serie-docto + "~~" +
                     string(tt-docum-est.nro-docto) + "~~" +
                     string(tt-docum-est.cod-emitente) + "~~" +
                     tt-docum-est.nat-operacao.
    RETURN "OK":U.
END PROCEDURE.
/*****************************************/

/** updateDocumento **/
PROCEDURE updateDocumento:
    
    find first tt-docum-est no-error.
    for each tt-docum-est-orig-aux:
        find docum-est 
            where docum-est.serie-docto  = tt-docum-est-orig-aux.serie-docto 
            and   docum-est.nro-docto    = tt-docum-est-orig-aux.nro-docto
            and   docum-est.cod-emitente = tt-docum-est-orig-aux.cod-emitente
            and   docum-est.nat-operacao = tt-docum-est-orig-aux.nat-operacao exclusive-lock no-error.
        &if defined(bf-mat-comex) &then
            assign docum-est.log-1      = yes.
        &else
            assign docum-est.ind-rateio = yes.
        &endif    

        /*M¢dulo de importa‡Æo*/
        {cdp/cd4300.i4 "yes" tt-docum-est-orig-aux.char-1}
        {rep/re1001a.i51 "yes"}
        /*M¢dulo de importa‡Æo*/
        FOR FIRST embarque-imp FIELDS (declaracao-import data-di)
            WHERE embarque-imp.cod-estabel = tt-docum-est-orig-aux.cod-estabel
            AND   embarque-imp.embarque    = TRIM(c-embarque) NO-LOCK:
            FIND bf-docum-est 
                WHERE bf-docum-est.serie-docto  = tt-docum-est.serie-docto 
                AND   bf-docum-est.nro-docto    = tt-docum-est.nro-docto
                AND   bf-docum-est.cod-emitente = tt-docum-est.cod-emitente
                AND   bf-docum-est.nat-operacao = tt-docum-est.nat-operacao    EXCLUSIVE-LOCK NO-ERROR.
            IF  AVAIL bf-docum-est THEN DO:

                ASSIGN bf-docum-est.declaracao-import    = embarque-imp.declaracao-import
                       OVERLAY(bf-docum-est.char-1,1,20) = tt-docum-est.nro-docto.

                /* Localiza‡Æo Equador */
                IF  i-pais-impto-usuario = 21 THEN DO:
                           
                    IF NOT VALID-HANDLE (h-boec022) THEN
                        RUN local/ecu/ec2bo/boec022.p PERSISTENT SET h-boec022.
                    
                    RUN openQueryStatic  IN h-boec022(INPUT 'Main':U).
                    
                    RUN createDoctoEstoq IN h-boec022(INPUT tt-docum-est.cod-emitente,
                                                      INPUT tt-docum-est.nat-operacao,
                                                      INPUT tt-docum-est.serie-docto,
                                                      INPUT tt-docum-est.nro-docto,
                                                      INPUT tt-parametros.cod-autoriz-sri,
                                                      INPUT tt-parametros.dat-autoriz,
                                                      INPUT tt-parametros.cod-estabel-ats,
                                                      INPUT tt-parametros.cdn-pto-emis,
                                                      INPUT NO,
                                                      INPUT IF bf-docum-est.nff THEN 6 ELSE 1).
                    
                    IF VALID-HANDLE(h-boec022) THEN DO:
                        RUN destroy IN h-boec022.
                        ASSIGN h-boec022 = ?.
                    END.
                END.
            END.
        END.
        
        /** A nf complementar podera ter mais de um embarque e podera ter
            mais de uma nf original. Devera existir um reg rat-docum para 
            cada nf original **/
        create rat-docum.
        assign rat-docum.cod-emitente = tt-docum-est.cod-emitente
               rat-docum.nat-operacao = tt-docum-est.nat-operacao 
               rat-docum.nro-docto    = tt-docum-est.nro-docto 
               rat-docum.serie-docto  = tt-docum-est.serie-docto        
               rat-docum.nf-emitente  = tt-docum-est-orig-aux.cod-emitente
               rat-docum.nf-nat-oper  = tt-docum-est-orig-aux.nat-operacao 
               rat-docum.nf-nro       = tt-docum-est-orig-aux.nro-docto
               rat-docum.nf-serie     = tt-docum-est-orig-aux.serie-docto.
    end.

    RETURN "OK":U.
END PROCEDURE.
/*****************************************/

/** updateItemDocumento **/
PROCEDURE updateItemDocumento:
    
    EMPTY TEMP-TABLE tt-impto-item-docto-aux.
    
    FOR EACH tt-item-doc-est:
        IF i-pais-impto-usuario = 9 /* Paraguai */ THEN DO:

            FIND FIRST tt-pryext-item-docto-estoq 
                 WHERE tt-pryext-item-docto-estoq.cod-ser-docto    = tt-item-doc-est.serie-docto
                   AND tt-pryext-item-docto-estoq.cod-docto        = tt-item-doc-est.nro-docto
                   AND tt-pryext-item-docto-estoq.cdn-emitente     = tt-item-doc-est.cod-emitente
                   AND tt-pryext-item-docto-estoq.cod-natur-operac = tt-item-doc-est.nat-operacao
                   AND tt-pryext-item-docto-estoq.num-seq          = tt-item-doc-est.sequencia
                   AND tt-pryext-item-docto-estoq.cod-item         = tt-item-doc-est.it-codigo NO-LOCK NO-ERROR.

            /* Cria somente se existir valor tributado */
            IF AVAIL tt-pryext-item-docto-estoq AND tt-pryext-item-docto-estoq.val-preco-unit-com-iva <> 0 THEN DO:

                IF NOT VALID-HANDLE(h-bopy2005) THEN 
                    RUN local/pry/bopy2005.p PERSISTENT SET h-bopy2005.
            
                RUN pi-atualiza-campos IN h-bopy2005 (INPUT tt-pryext-item-docto-estoq.cod-ser-docto,
                                                      INPUT tt-pryext-item-docto-estoq.cod-docto,
                                                      INPUT tt-pryext-item-docto-estoq.cdn-emitente,
                                                      INPUT tt-pryext-item-docto-estoq.cod-natur-operac,
                                                      INPUT tt-pryext-item-docto-estoq.num-seq,
                                                      INPUT tt-pryext-item-docto-estoq.cod-item,
                                                      INPUT tt-pryext-item-docto-estoq.log-iva-inclui,
                                                      INPUT tt-pryext-item-docto-estoq.val-preco-unit-isento, 
                                                      INPUT tt-pryext-item-docto-estoq.val-preco-unit-com-iva, 
                                                      INPUT tt-item-doc-est.numero-ordem).
                RUN destroy IN h-bopy2005.
                ASSIGN h-bopy2005 = ?.

            END.
        END.

    END. 

    RETURN "OK":U.
END PROCEDURE.
/*****************************************/

/** updateDespesas **/
PROCEDURE updateDespesas:
    FOR EACH tt-selecao-despesa,
        EACH desp-embarque OF tt-selecao-despesa EXCLUSIVE-LOCK:
        ASSIGN desp-embarque.log-despes-ja-recbda = YES.
    END.

    RETURN "OK":U.
END PROCEDURE.
/*****************************************/

/** updateDuplicatas **/
PROCEDURE updateDuplicatas:
    
    FOR EACH tt-dupli-apagar,
        EACH dupli-apagar OF tt-dupli-apagar:

        ASSIGN dupli-apagar.cod-esp = tt-parametros-aux.esp-tit-rec.
    END.

    RETURN "OK":U.
END PROCEDURE.
/*****************************************/

/** createDespesasImp **/
PROCEDURE createDespesasImp:
    
    FOR EACH tt-docum-est-cex:
        FIND FIRST docum-est-cex OF tt-docum-est-cex EXCLUSIVE-LOCK
            WHERE docum-est-cex.cod-cond-pag = tt-docum-est-cex.cod-cond-pag NO-ERROR.
        
        IF  NOT AVAIL docum-est-cex THEN DO:
            CREATE docum-est-cex.
            BUFFER-COPY tt-docum-est-cex EXCEPT val-desp r-rowid TO docum-est-cex.    
            
            ASSIGN docum-est-cex.val-desp = docum-est-cex.val-desp + tt-docum-est-cex.val-desp
                  &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
                   docum-est-cex.idi-sit-despes = 1
                  &ELSE
                   docum-est-cex.int-1 = 1
                  &ENDIF.
        END.
    END.
    
    FOR EACH tt-item-doc-est-cex:
        CREATE item-doc-est-cex.
        BUFFER-COPY tt-item-doc-est-cex EXCEPT r-rowid TO item-doc-est-cex.
        
        ASSIGN &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
                item-doc-est-cex.idi-sit-despes = 1
               &ELSE
                item-doc-est-cex.int-1 = 1
               &ENDIF.
    END.
    
    FOR EACH tt-item-doc-est-cex-internac:
        CREATE item-doc-est-cex-internac.
        BUFFER-COPY tt-item-doc-est-cex-internac EXCEPT r-rowid TO item-doc-est-cex-internac.
    END.
    
    RETURN "OK":U.
END PROCEDURE.
/*****************************************/

/** createImpostos **/
PROCEDURE createImpostos:
    
    DEFINE VARIABLE de-valor-total-desp AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v-val-impto-merc-ext LIKE impto-item-docto.val-impto-merc-ext     NO-UNDO.
    DEFINE VARIABLE v-val-base-me        LIKE impto-item-docto.val-base-me            NO-UNDO.
    
    EMPTY TEMP-TABLE tt-impto-item-docto.
    find first tt-docum-est no-error.
    find docum-est NO-LOCK of tt-docum-est no-error.
    if  avail docum-est then do:

       FOR EACH  impto-item-docto EXCLUSIVE-LOCK
            WHERE impto-item-docto.cod-emitente = docum-est.cod-emitente
            AND   impto-item-docto.serie-docto  = docum-est.serie-docto
            AND   impto-item-docto.nat-operacao = docum-est.nat-operacao
            AND   impto-item-docto.nro-docto    = docum-est.nro-docto:
            DELETE impto-item-docto.
        END.

        ASSIGN de-valor-total-desp = 0.
        FOR each  item-doc-est-cex no-lock
            where item-doc-est-cex.serie-docto       = docum-est.serie-docto
            and   item-doc-est-cex.nro-docto         = docum-est.nro-docto
            and   item-doc-est-cex.cod-emitente      = docum-est.cod-emitente
            and   item-doc-est-cex.nat-operacao      = docum-est.nat-operacao 
            USE-INDEX codigo:
            ASSIGN de-valor-total-desp = de-valor-total-desp + item-doc-est-cex.val-desp.
        END.

        FOR EACH tt-impostos-despesa:
            FOR each  item-doc-est-cex
                where item-doc-est-cex.serie-docto       = docum-est.serie-docto
                and   item-doc-est-cex.nro-docto         = docum-est.nro-docto
                and   item-doc-est-cex.cod-emitente      = docum-est.cod-emitente
                and   item-doc-est-cex.nat-operacao      = docum-est.nat-operacao no-lock
                USE-INDEX codigo:

                FIND FIRST tt-impto-item-docto
                    WHERE tt-impto-item-docto.serie-docto   = item-doc-est-cex.serie-docto 
                      AND tt-impto-item-docto.nro-docto     = string(item-doc-est-cex.nro-docto)
                      AND tt-impto-item-docto.cod-emitente  = item-doc-est-cex.cod-emitente
                      AND tt-impto-item-docto.nat-operacao  = item-doc-est-cex.nat-operacao
                      AND tt-impto-item-docto.num-seq       = item-doc-est-cex.sequencia 
                      AND tt-impto-item-docto.cdn-imposto   = tt-impostos-despesa.cod-tax NO-ERROR.

                IF NOT AVAIL tt-impto-item-docto THEN DO:
                    CREATE tt-impto-item-docto.
                    ASSIGN tt-impto-item-docto.serie-docto  = item-doc-est-cex.serie-docto      
                           tt-impto-item-docto.nro-docto    = string(item-doc-est-cex.nro-docto)
                           tt-impto-item-docto.cod-emitente = item-doc-est-cex.cod-emitente     
                           tt-impto-item-docto.nat-operacao = item-doc-est-cex.nat-operacao     
                           tt-impto-item-docto.num-seq      = item-doc-est-cex.sequencia        
                           tt-impto-item-docto.cdn-imposto  = tt-impostos-despesa.cod-tax
                           tt-impto-item-docto.perc-imposto = tt-impostos-despesa.tax-perc.
                END.
                ASSIGN tt-impto-item-docto.val-impto = fn_ajust_dec(tt-impto-item-docto.val-impto 
                                                                    + (tt-impostos-despesa.vl-imposto * (item-doc-est-cex.val-desp  / de-valor-total-desp)),0)
                       tt-impto-item-docto.val-base  = fn_ajust_dec(tt-impto-item-docto.val-base 
                                                                    + (tt-impostos-despesa.vl-base * (item-doc-est-cex.val-desp / de-valor-total-desp)),0).
            END.

            ASSIGN dval-base  = 0
                   dval-impto = 0.
            FOR EACH  tt-impto-item-docto WHERE tt-impto-item-docto.cdn-imposto = tt-impostos-despesa.cod-tax:
                ASSIGN dval-impto = dval-impto + tt-impto-item-docto.val-impto
                       dval-base  =  dval-base + tt-impto-item-docto.val-base.
            END.
            IF dval-base - tt-impostos-despesa.vl-base <> 0 THEN DO:
                FIND FIRST  tt-impto-item-docto WHERE tt-impto-item-docto.cdn-imposto = tt-impostos-despesa.cod-tax NO-ERROR.
                IF AVAIL tt-impto-item-docto THEN
                    ASSIGN tt-impto-item-docto.val-base = tt-impto-item-docto.val-base + ((dval-base - tt-impostos-despesa.vl-base) * -1).
            END.
            IF dval-impto - tt-impostos-despesa.vl-imposto <> 0 THEN DO:
                FIND FIRST tt-impto-item-docto WHERE tt-impto-item-docto.cdn-imposto = tt-impostos-despesa.cod-tax NO-ERROR.
                IF AVAIL tt-impto-item-docto THEN
                    ASSIGN tt-impto-item-docto.val-impto = tt-impto-item-docto.val-impto + ((dval-impto - tt-impostos-despesa.vl-imposto) * -1).
            END.
        END.
    END.

    FOR EACH tt-impto-item-docto:
        
        IF NOT CAN-FIND(FIRST impto-item-docto 
                        WHERE impto-item-docto.cod-emitente = tt-impto-item-docto.cod-emitente
                        AND   impto-item-docto.serie-docto  = tt-impto-item-docto.serie-docto
                        AND   impto-item-docto.nat-operacao = tt-impto-item-docto.nat-operacao
                        AND   impto-item-docto.nro-docto    = tt-impto-item-docto.nro-docto
                        AND   impto-item-docto.num-seq      = tt-impto-item-docto.num-seq
                        AND   impto-item-docto.cdn-imposto  = tt-impto-item-docto.cdn-imposto) THEN DO:
            CREATE impto-item-docto.
            BUFFER-COPY tt-impto-item-docto EXCEPT val-impto-merc-ext TO impto-item-docto.
    
            IF tt-parametros.d-cotacao = 0 THEN DO:
                RUN cdp/cd0812.p (INPUT  0,
                                  INPUT  c-moeda,
                                  INPUT  tt-impto-item-docto.val-impto,
                                  INPUT  tt-parametros.da-cotacao,
                                  OUTPUT impto-item-docto.val-impto-merc-ext).

                RUN cdp/cd0812.p (INPUT  0,
                                  INPUT  c-moeda,
                                  INPUT  tt-impto-item-docto.val-base,
                                  INPUT  tt-parametros.da-cotacao,
                                  OUTPUT impto-item-docto.val-base-me).
            END.
            ELSE DO:
                RUN cdp/cd0812a.p (INPUT  0,
                                   INPUT  c-moeda,
                                   INPUT  tt-impto-item-docto.val-impto,
                                   INPUT  tt-parametros.d-cotacao,
                                   OUTPUT impto-item-docto.val-impto-merc-ext).

                RUN cdp/cd0812a.p (INPUT  0,
                                   INPUT  c-moeda,
                                   INPUT  tt-impto-item-docto.val-base,
                                   INPUT  tt-parametros.d-cotacao,
                                   OUTPUT impto-item-docto.val-base-me).
            END.
        END.
    END.

    
    FOR EACH tt-impostos-despesa:
        
        ASSIGN v-val-impto-merc-ext = 0
               v-val-base-me        = 0.
        
        FOR EACH tt-impto-item-docto NO-LOCK
            WHERE  tt-impto-item-docto.cdn-imposto   = tt-impostos-despesa.cod-tax,
            FIRST impto-item-docto NO-LOCK
                WHERE impto-item-docto.cod-emitente = tt-impto-item-docto.cod-emitente
                AND   impto-item-docto.serie-docto  = tt-impto-item-docto.serie-docto
                AND   impto-item-docto.nat-operacao = tt-impto-item-docto.nat-operacao
                AND   impto-item-docto.nro-docto    = tt-impto-item-docto.nro-docto
                AND   impto-item-docto.num-seq      = tt-impto-item-docto.num-seq
                AND   impto-item-docto.cdn-imposto  = tt-impto-item-docto.cdn-imposto:
                ASSIGN v-val-impto-merc-ext = v-val-impto-merc-ext + impto-item-docto.val-impto-merc-ext
                       v-val-base-me        = v-val-base-me        + impto-item-docto.val-base-me.
        END.
    
        IF v-val-impto-merc-ext - tt-impostos-despesa.vl-imposto-me <> 0 THEN DO:
            FIND FIRST  tt-impto-item-docto
                WHERE  tt-impto-item-docto.cdn-imposto   = tt-impostos-despesa.cod-tax NO-ERROR.
            
            IF AVAIL tt-impto-item-docto THEN DO:
                FIND FIRST impto-item-docto EXCLUSIVE-LOCK
                    WHERE impto-item-docto.cod-emitente = tt-impto-item-docto.cod-emitente
                      AND impto-item-docto.serie-docto  = tt-impto-item-docto.serie-docto
                      AND impto-item-docto.nat-operacao = tt-impto-item-docto.nat-operacao
                      AND impto-item-docto.nro-docto    = tt-impto-item-docto.nro-docto
                      AND impto-item-docto.num-seq      = tt-impto-item-docto.num-seq
                      AND impto-item-docto.cdn-imposto  = tt-impto-item-docto.cdn-imposto NO-ERROR.
                IF AVAIL impto-item-docto THEN
                    ASSIGN impto-item-docto.val-impto-merc-ext = impto-item-docto.val-impto-merc-ext + ((v-val-impto-merc-ext - tt-impostos-despesa.vl-imposto-me) * -1).
            END.
        END.

        IF v-val-base-me - tt-impostos-despesa.vl-base-me <> 0 THEN DO:
            FIND FIRST tt-impto-item-docto
                 WHERE tt-impto-item-docto.cdn-imposto = tt-impostos-despesa.cod-tax NO-ERROR.
            
            IF AVAIL tt-impto-item-docto THEN DO:
                FIND FIRST impto-item-docto EXCLUSIVE-LOCK
                    WHERE impto-item-docto.cod-emitente = tt-impto-item-docto.cod-emitente
                      AND impto-item-docto.serie-docto  = tt-impto-item-docto.serie-docto
                      AND impto-item-docto.nat-operacao = tt-impto-item-docto.nat-operacao
                      AND impto-item-docto.nro-docto    = tt-impto-item-docto.nro-docto
                      AND impto-item-docto.num-seq      = tt-impto-item-docto.num-seq
                      AND impto-item-docto.cdn-imposto  = tt-impto-item-docto.cdn-imposto NO-ERROR.
                IF AVAIL impto-item-docto THEN
                    ASSIGN impto-item-docto.val-base-me = impto-item-docto.val-base-me + ((v-val-base-me - tt-impostos-despesa.vl-base-me) * -1).
            END.
        END.
    END.    

    RETURN "OK":U.
END PROCEDURE.
/*****************************************/

/** createUnidNegNota **/
PROCEDURE createUnidNegNota:

    FOR EACH tt-item-doc-est,
        EACH tt-unid-neg-nota
        WHERE tt-unid-neg-nota.serie-docto  = tt-item-doc-est.serie-docto
          AND tt-unid-neg-nota.nro-docto    = tt-item-doc-est.nro-docto
          AND tt-unid-neg-nota.cod-emitente = tt-item-doc-est.cod-emitente
          AND tt-unid-neg-nota.nat-operacao = tt-item-doc-est.nat-operacao
          AND tt-unid-neg-nota.sequencia    = tt-item-doc-est.sequencia:
        
        IF NOT CAN-FIND(FIRST unid-neg-nota
                        WHERE unid-neg-nota.serie-docto    = tt-unid-neg-nota.serie-docto 
                          AND unid-neg-nota.nro-docto      = tt-unid-neg-nota.nro-docto   
                          AND unid-neg-nota.cod-emitente   = tt-unid-neg-nota.cod-emitente
                          AND unid-neg-nota.nat-operacao   = tt-unid-neg-nota.nat-operacao
                          AND unid-neg-nota.sequencia      = tt-unid-neg-nota.sequencia  
                          AND unid-neg-nota.cod_unid_negoc = tt-unid-neg-nota.cod_unid_negoc) THEN DO:
            CREATE unid-neg-nota.
            BUFFER-COPY tt-unid-neg-nota TO unid-neg-nota.
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.
/*****************************************/

/** pi-gera-erro **/
PROCEDURE pi-gera-erro:
    DEF INPUT PARAM p-tipo-msg   AS CHAR NO-UNDO.
    DEF INPUT PARAM p-nro-msg    AS INT  NO-UNDO.
    DEF INPUT PARAM p-parametros AS CHAR NO-UNDO.
    DEF INPUT PARAM p-subtype    AS CHAR NO-UNDO.

    RUN utp/ut-msgs.p (INPUT p-tipo-msg,
                       INPUT p-nro-msg,
                       INPUT p-parametros).
    
    CREATE tt-bo-erro.
    ASSIGN i-seq-erro              = i-seq-erro + 1
           tt-bo-erro.parametros   = p-parametros
           tt-bo-erro.i-sequen     = i-seq-erro
           tt-bo-erro.cd-erro      = p-nro-msg
           tt-bo-erro.mensagem     = RETURN-VALUE
           tt-bo-erro.errorsubtype = p-subtype.

    RETURN "OK":U.
END PROCEDURE.
/*****************************************/

/** getTT-docum-est-im3101a1 **/
PROCEDURE getTT-docum-est-im3101a1:
    DEFINE OUTPUT PARAMETER TABLE FOR tt-docum-est.

    FIND FIRST tt-docum-est NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.
/*****************************************/

/** getTT-bo-erro **/
PROCEDURE getTT-bo-erro:
    DEF OUTPUT PARAMETER TABLE FOR tt-bo-erro.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piTotalizaDocumento:

    FOR EACH tt-docum-est NO-LOCK:

        ASSIGN tt-docum-est.valor-mercad    = 0
               tt-docum-est.valor-mercad-me = 0.

        FOR EACH  tt-item-doc-est 
            WHERE tt-item-doc-est.serie-docto  = tt-docum-est.serie-docto
              AND tt-item-doc-est.nro-docto    = tt-docum-est.nro-docto
              AND tt-item-doc-est.cod-emitente = tt-docum-est.cod-emitente 
              AND tt-item-doc-est.nat-operacao = tt-docum-est.nat-operacao EXCLUSIVE-LOCK:
            ASSIGN tt-docum-est.valor-mercad = tt-docum-est.valor-mercad + tt-item-doc-est.preco-total[1].                
        END.       
        
        IF c-moeda <> 0 THEN DO:
            IF tt-parametros.d-cotacao = 0 THEN
                RUN cdp/cd0812.p (INPUT  0,
                                  INPUT  c-moeda,
                                  INPUT  tt-docum-est.valor-mercad,
                                  INPUT  tt-parametros.da-cotacao,
                                  OUTPUT tt-docum-est.valor-mercad-me).
            ELSE
                RUN cdp/cd0812a.p (INPUT  0,
                                   INPUT  c-moeda,
                                   INPUT  tt-docum-est.valor-mercad,
                                   INPUT  tt-parametros.d-cotacao,
                                   OUTPUT tt-docum-est.valor-mercad-me).    
        END.                      
        ELSE 
            ASSIGN tt-docum-est.valor-mercad-me = tt-docum-est.valor-mercad.

        ASSIGN tt-docum-est.tot-valor-me = tt-docum-est.valor-mercad-me + tt-docum-est.despesa-nota-me.
                

    END.

    RETURN "OK":U.
END PROCEDURE.

