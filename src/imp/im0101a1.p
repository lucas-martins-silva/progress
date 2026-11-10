USING rep.imp.*.
/*********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**    
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
********************************************************************************/
{include/i-prgvrs.i IM0101A1 2.00.00.058 } /*** "010058" 05/10/2026 08:04:06 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0101a1 MIM}
&ENDIF

&GLOBAL-DEFINE vcod-espec-padr desp-imp.cod-espec-padr

{cdp/cdcfgmat.i}                       /* Definicao de pre-processadores */
{cdp/cdcfgdis.i}                       /* Definicao de pre-processadores */
{include/boerrtab.i}                   /* tt-bo-erro          */
{imp/im0101.i tt-parametros}           /* tt-parametros (aux) */
{cxbo/bocx230.i tt-desp-embarque}      /* tt-desp-embarque    */
{inbo/boin090.i tt-docum-est-orig}     /* tt-docum-est-orig   */
{imp/im0091.i}                         /* tt-desp-rateio      */
{imp/im0101a1.i}                       /* tt-item-doc-est-nota, tt-docum-est-nova */
{rep/re1904a.i}                        /* tt-item-rateio      */
{cxbo/bocx090.i tt-docum-est-cex}      /* tt-docum-est-cex    */
{cxbo/bocx100.i tt-item-doc-est-cex }  /* tt-item-doc-est-cex */
{inbo/boin090.i tt-docum-est-orig-aux} /* nf principal todos embarques */
{include/i-epc200.i im0101a1}          /** Upc **/
{cdp/cd9590.i}                         /* Unidade de neg¢cio */
{cdp/cd9701.i}                         /* Defini‡Æo/atribui‡Æo da vari vel l-mult-natur-receb -> Usa multiplas naturezas no recebimento */
{imp/im9070.i}                         /* Configurador de Tributos */
{rep/reapi190a.i}                      /* Definicao das temp-tables utilizadas pela api reapi190 - EMS*/
{cdp/cd4305.i1}                        /* Definicao das temp-tables TT-DOCTO, TT-IT-DOCTO E TT-IT-IMPOSTO */    
{cdp/cd4300.i3}                        /* tratamento atributo livre */
{rep/re1001a.i50}                      /*Vari veis m¢dulo de importa‡Æo*/
{cxbo/bocx310a.i tt-selecao-despesa}
{rep/imp/utilizaImpostosMonitor.i}
{inbo/boin01126.i tt-docum-est-tribut}
{inbo/boin01126.i tt-docum-est-tribut-aux}

DEFINE TEMP-TABLE tt-docum-est-2 NO-UNDO
    FIELD serie-docto  LIKE docum-est.serie-docto  
    FIELD nro-docto    LIKE docum-est.nro-docto    
    FIELD cod-emitente LIKE docum-est.cod-emitente 
    FIELD nat-operacao LIKE docum-est.nat-operacao 
    FIELD embarque     like docum-est.embarque
    INDEX embarque embarque.

DEFINE TEMP-TABLE tt-docum-est-aux       NO-UNDO LIKE docum-est.
DEFINE TEMP-TABLE tt-item-doc-est-aux    NO-UNDO LIKE item-doc-est.
DEFINE TEMP-TABLE tt-item-doc-est-tribut NO-UNDO LIKE item-doc-est-tribut.

DEFINE INPUT PARAMETER TABLE FOR tt-docum-est-2.

DEF BUFFER bf-docum-est                FOR docum-est.
DEF BUFFER bf-docto-estoq-nfe-imp      FOR docto-estoq-nfe-imp.
DEF BUFFER bf-item-docto-estoq-nfe-imp FOR item-docto-estoq-nfe-imp.
DEF BUFFER bf-tt-item-doc-est-cex      FOR tt-item-doc-est-cex.

DEF TEMP-TABLE tt-dupli-apagar-cex NO-UNDO
    FIELD cod-emitente      LIKE dupli-apagar-cex.cod-emitente
    FIELD nat-operacao      LIKE dupli-apagar-cex.nat-operacao
    FIELD serie-docto       LIKE dupli-apagar-cex.serie-docto
    FIELD nro-docto         LIKE dupli-apagar-cex.nro-docto
    FIELD cod-emitente-desp LIKE dupli-apagar-cex.cod-emitente-desp
    FIELD cod-desp          LIKE docum-est-cex.cod-desp /* nao existe cod-desp no dupli-apagar-cex no EMS 2.03 */
    FIELD mo-codigo         LIKE dupli-apagar-cex.mo-codigo
    FIELD dt-vencim         LIKE dupli-apagar-cex.dt-vencim
    FIELD tp-despesa        LIKE dupli-apagar-cex.tp-despesa
    FIELD vl-a-pagar        LIKE dupli-apagar-cex.vl-a-pagar
    FIELD vl-a-pagar-mo     LIKE dupli-apagar-cex.vl-a-pagar-mo
    FIELD cod-esp           LIKE dupli-apagar-cex.cod-esp
    INDEX codigo
        serie-docto
        nro-docto
        cod-emitente
        nat-operacao
        cod-desp
        cod-emitente-desp
    INDEX data
        cod-emitente-desp
        dt-vencim.

DEFINE TEMP-TABLE tt-docum-est-nfe NO-UNDO LIKE tt-docum-est.

DEFINE VARIABLE c-acomp           AS   CHARACTER                   NO-UNDO.
DEFINE VARIABLE c-espec-padr      AS   CHARACTER FORMAT "x(2)":U   NO-UNDO.
DEFINE VARIABLE cDi               AS   CHARACTER FORMAT "x(20)":U  NO-UNDO.
DEFINE VARIABLE dataDi            AS   DATE                        NO-UNDO.
DEFINE VARIABLE de-tot-val-fcp    AS   DECIMAL                     NO-UNDO.
DEFINE VARIABLE de-tot-base-fcp   AS   DECIMAL                     NO-UNDO.
DEFINE VARIABLE h-cd4338          AS   HANDLE                      NO-UNDO.
DEFINE VARIABLE h-bocx310         AS   HANDLE                      NO-UNDO.
DEFINE VARIABLE h-im0091          AS   HANDLE                      NO-UNDO.
DEFINE VARIABLE h-imapi017        AS   HANDLE                      NO-UNDO.
DEFINE VARIABLE h-reapi190b       AS   HANDLE                      NO-UNDO.
DEFINE VARIABLE i-seq-erro        AS   INTEGER                     NO-UNDO.
DEFINE VARIABLE i-seq-aux         AS   INTEGER                     NO-UNDO.
DEFINE VARIABLE l-nota-rateio     AS   LOGICAL                     NO-UNDO.
DEFINE VARIABLE l-procedimento-ok AS   LOGICAL                     NO-UNDO.
DEFINE VARIABLE dat-tipo-dia      LIKE calen-coml.tipo-dia         NO-UNDO. /*CD9020.i7*/
DEFINE VARIABLE de-vl-icm         LIKE docum-est.icm-deb-cre       NO-UNDO. 
DEFINE VARIABLE de-base-icm       LIKE docum-est.base-icm          NO-UNDO.
DEFINE VARIABLE de-base-ipi       LIKE docum-est.base-ipi          NO-UNDO. 
DEFINE VARIABLE de-vl-ipi         LIKE docum-est.ipi-deb-cre       NO-UNDO.
DEFINE VARIABLE de-base-subs      LIKE docum-est.base-subs         NO-UNDO.
DEFINE VARIABLE de-vl-subs        LIKE docum-est.vl-subs           NO-UNDO.
DEFINE VARIABLE de-valor-ipi-unid LIKE item.valor-ipi-beb          NO-UNDO.
DEFINE VARIABLE de-valor-un-pis         AS DEC FORMAT ">>>9.99999" NO-UNDO.
DEFINE VARIABLE de-valor-un-cofins      AS DEC FORMAT ">>>9.99999" NO-UNDO.
DEFINE VARIABLE l-utilizaImpostoMonitor AS LOGICAL INITIAL NO      NO-UNDO.
DEFINE VARIABLE l-NT2024002             AS LOGICAL INITIAL NO      NO-UNDO.
DEFINE VARIABLE l-avisou-parcela99      AS LOGICAL INITIAL NO      NO-UNDO.
DEFINE VARIABLE h-reapi428              AS   HANDLE                NO-UNDO.
DEFINE VARIABLE lSujTribMonofasica      AS LOGICAL INITIAL NO      NO-UNDO.

ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-NT2024002" AND funcao.ativo).

PROCEDURE setTtDespTotaisEmbarquesMult:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-desp-totais-embarques-mult.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE loadParameters:
/*------------------------------------------------------------------------------
  Purpose:     Carrega os parƒmetros iniciais
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-parametros.
    DEFINE INPUT PARAMETER TABLE FOR tt-parametros-aux.
    DEFINE INPUT PARAMETER TABLE FOR tt-docum-est-orig.
    DEFINE INPUT PARAMETER TABLE FOR tt-desp-rateio.
    DEFINE INPUT PARAMETER TABLE FOR tt-ordens-totais.
    DEFINE INPUT PARAMETER TABLE FOR tt-selecao-despesa.
    
    FIND FIRST tt-parametros        NO-ERROR.
    FIND FIRST tt-parametros-aux    NO-ERROR.
    FIND FIRST param-global NO-LOCK NO-ERROR.

    FOR EACH tt-docum-est-orig:
        CREATE tt-docum-est-orig-aux.
        BUFFER-COPY tt-docum-est-orig TO tt-docum-est-orig-aux.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE generateTT-docum-est:
/*------------------------------------------------------------------------------
  Purpose:     Cria‡Æo temp-table tt-docum-est para documento de entrada
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-via-transp AS INTEGER NO-UNDO.
    
    /** Inicializa via de tranporte **/
    ASSIGN i-via-transp = 1. /* Rodoviario */
    
    FIND FIRST tt-docum-est-orig NO-ERROR.

    CREATE tt-docum-est.
    ASSIGN tt-docum-est.cod-emitente   = tt-parametros.cod-emitente-desp
           tt-docum-est.uf             = tt-parametros.estado-emit
           tt-docum-est.nat-operacao   = tt-parametros.nat-operacao
           tt-docum-est.nro-docto      = tt-parametros.nro-docto
           tt-docum-est.serie-docto    = tt-parametros.serie
           tt-docum-est.cod-estabel    = /*tt-docum-est-orig.cod-estabel*/ tt-parametros.cod-estabel /*pode-se receber a complementar diferente do estabelecimento do embarque principal*/
           tt-docum-est.dt-emissao     = tt-parametros.da-emissao
           tt-docum-est.dt-trans       = tt-parametros.da-trans
           tt-docum-est.dt-venc-icm    = tt-parametros.da-venc-icm       
           tt-docum-est.dt-venc-ipi    = tt-parametros.da-venc-ipi
           tt-docum-est.estab-fisc     = tt-parametros.estab-fisc
           tt-docum-est.usuario        = tt-parametros.usuario           
           tt-docum-est.ct-transit     = tt-parametros.ct-transit 
           tt-docum-est.sc-transit     = tt-parametros.sc-transit 
           tt-docum-est.cod-observa    = tt-parametros.cod-observacao
           tt-docum-est.embarque       = ""
           tt-docum-est.nff            = NO
           tt-docum-est.valor-embal    = 0
           tt-docum-est.pais-origem    = "RE1001":U
           tt-docum-est.efetua-calculo = 0
           tt-docum-est.esp-docto      = 21
           tt-docum-est.rec-fisico     = NO
           tt-docum-est.origem         = "I":U
           tt-docum-est.via-transp     = i-via-transp
           tt-docum-est.mod-frete      = 1
           tt-docum-est.cotacao-dia    = tt-parametros-aux.cotacao-dia
           tt-docum-est.tot-peso       = 0.       
           
       
    ASSIGN tt-docum-est.cod-chave-aces-nf-eletro = tt-parametros.chave-nfe.
       
    &IF "{&bf_mat_versao_ems}" >= "2.09" &THEN
        ASSIGN tt-docum-est.cod-item-serv = tt-parametros.cod-item-serv.
    &ELSE
        OVERLAY(tt-docum-est.char-1,176,16) = tt-parametros.cod-item-serv.
    &ENDIF

    IF NOT CAN-FIND(FIRST tt-docum-est) THEN
        RETURN "NOK":U.
    
    IF AVAIL tt-parametros
    AND TRIM(tt-parametros.cod-ibge-orig) <> ""
    AND TRIM(tt-parametros.cod-ibge-orig) <> ?
    AND TRIM(tt-parametros.cod-ibge-dest) <> ""
    AND TRIM(tt-parametros.cod-ibge-dest) <> ? THEN DO:

        FIND FIRST tt-docum-est-aux
             WHERE tt-docum-est-aux.cod-emitente = tt-parametros.cod-emitente
               AND tt-docum-est-aux.nro-docto    = tt-parametros.nro-docto
               AND tt-docum-est-aux.serie-docto  = tt-parametros.serie
               AND tt-docum-est-aux.nat-operacao = tt-parametros.nat-operacao NO-LOCK NO-ERROR.
    
        IF NOT AVAIL tt-docum-est-aux THEN DO:
            CREATE tt-docum-est-aux.
            ASSIGN tt-docum-est-aux.cod-emitente           = tt-parametros.cod-emitente
                   tt-docum-est-aux.nro-docto              = tt-parametros.nro-docto
                   tt-docum-est-aux.serie-docto            = tt-parametros.serie
                   tt-docum-est-aux.nat-operacao           = tt-parametros.nat-operacao
                   OVERLAY(tt-docum-est-aux.char-2,236,10) = tt-parametros.cod-ibge-dest
                   OVERLAY(tt-docum-est-aux.char-2,246,10) = tt-parametros.cod-ibge-orig.
        END.
        ELSE
            ASSIGN OVERLAY(tt-docum-est-aux.char-2,236,10) = tt-parametros.cod-ibge-dest
                   OVERLAY(tt-docum-est-aux.char-2,246,10) = tt-parametros.cod-ibge-orig.
    END.
        
    RUN generateNumeroDocumento (INPUT tt-docum-est.cod-estabel,
                                 INPUT tt-docum-est.serie,
                                 INPUT tt-docum-est.cod-emitente,
                                 INPUT tt-docum-est.nat-operacao,
                                 INPUT tt-parametros.i-pais-impto-usuario,
                                 INPUT tt-parametros-aux.imp-nota,
                                 INPUT-OUTPUT tt-docum-est.nro-docto).

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    
    ASSIGN tt-docum-est.embarque = tt-docum-est.nro-docto.
    
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-gera-tt-it-docto:
/*------------------------------------------------------------------------------
  Purpose:     Cria Temp-table para c lculo do imposto
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    CREATE tt-it-docto.

    ASSIGN tt-it-docto.seq-tt-it-docto = tt-item-doc-est.sequencia  
           tt-it-docto.ct-codigo       = tt-item-doc-est.ct-codigo    
           tt-it-docto.sc-codigo       = tt-item-doc-est.sc-codigo
           tt-it-docto.cod-emitente    = tt-docum-est.cod-emitente           
           tt-it-docto.nr-nota         = tt-docum-est.nro-docto
           tt-it-docto.serie           = tt-docum-est.serie           
           tt-it-docto.nat-operacao    = tt-docum-est.nat-operacao
           tt-it-docto.cod-estabel     = tt-docum-est.cod-estabel
           tt-it-docto.calcula         = YES           
           tt-it-docto.nr-sequencia    = tt-item-doc-est.sequencia
           tt-it-docto.quantidade      = 0
           tt-it-docto.vl-frete        = 0            
           tt-it-docto.vl-despes-it    = 0
           tt-it-docto.vl-embalagem    = 0
           tt-it-docto.vl-seguro       = 0
           tt-it-docto.calcula         = YES                      
           tt-it-docto.it-codigo       = tt-item-doc-est.it-codigo
           tt-it-docto.nro-comp        = tt-item-doc-est.nro-comp
           tt-it-docto.serie-comp      = tt-item-doc-est.serie-comp
           tt-it-docto.nat-comp        = tt-item-doc-est.nat-comp
           tt-it-docto.seq-comp        = tt-item-doc-est.seq-comp
           tt-it-docto.class-fiscal    = tt-item-doc-est.class-fiscal
           tt-it-docto.data-comp       = tt-item-doc-est.data-comp
           tt-it-docto.nr-ord-prod     = tt-item-doc-est.nr-ord-prod
           tt-it-docto.numero-ordem    = 0
           tt-it-docto.parcela         = 0
           tt-it-docto.cod-refer       = tt-item-doc-est.cod-refer
           tt-it-docto.encerra-pa      = tt-item-doc-est.encerra-pa
           tt-it-docto.item-pai        = tt-item-doc-est.item-pai
           tt-it-docto.cod-roteiro     = tt-item-doc-est.cod-roteiro
           tt-it-docto.op-codigo       = tt-item-doc-est.op-codigo
           tt-it-docto.narrativa       = tt-item-doc-est.narrativa
           tt-it-docto.desconto        = tt-item-doc-est.desconto
           tt-it-docto.per-des-item    = 0
           tt-it-docto.vl-preuni       = tt-item-doc-est.preco-total
           tt-it-docto.vl-preori       = tt-item-doc-est.preco-total
           tt-it-docto.vl-merc-liq     = tt-item-doc-est.preco-total
           tt-it-docto.vl-merc-ori     = tt-item-doc-est.preco-total
           tt-it-docto.char-1          = "im0101a":U.
          
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-gera-tt-it-imposto:
/*------------------------------------------------------------------------------
  Purpose:     Cria Temp-table para c lculo dos impostos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-cd-trib-iss AS INTEGER NO-UNDO.
    
    /* Nota de Servicos */
    ASSIGN i-cd-trib-iss = 1.

    IF tt-parametros.cod-observacao = 4 THEN DO:
        
        /* Determina tributacao do ISS */
        RUN cdp/cd4304.p (INPUT  tt-item-doc-est.cd-trib-iss,
                          INPUT  tt-parametros-aux.cd-trib-iss,
                          OUTPUT i-cd-trib-iss).
    
        ASSIGN tt-item-doc-est.cd-trib-iss = i-cd-trib-iss.
                            
        IF i-cd-trib-iss <> 2 AND i-cd-trib-iss <> 3 THEN DO:
            
            ASSIGN i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgind item-doc-est cd-trib-iss 1}
            CREATE tt-bo-erro.
            ASSIGN tt-bo-erro.parametros = TRIM(RETURN-VALUE).
            {utp/ut-liter.i do_Item * L}
            ASSIGN tt-bo-erro.parametros = tt-bo-erro.parametros + " " + TRIM(RETURN-VALUE) + " " + tt-item-doc-est.it-codigo. 

            RUN utp/ut-msgs.p (INPUT "msg":U, INPUT 158, INPUT tt-bo-erro.parametros).

            ASSIGN tt-bo-erro.i-sequen   = i-seq-erro
                   tt-bo-erro.cd-erro    = 158
                   tt-bo-erro.mensagem   = RETURN-VALUE.

            RETURN "NOK":U.
        END.
    END.
    ELSE
        ASSIGN tt-item-doc-est.cd-trib-iss    = i-cd-trib-iss
                 tt-item-doc-est.aliquota-iss = 0
                 tt-item-doc-est.base-iss     = 0.

    IF NOT AVAIL natur-oper THEN
        FIND FIRST natur-oper
             WHERE natur-oper.nat-operacao = tt-parametros.nat-operacao NO-LOCK NO-ERROR.

    CREATE tt-it-imposto.
    ASSIGN tt-it-imposto.seq-tt-it-docto = tt-it-docto.seq-tt-it-docto
           tt-it-imposto.ind-icm-ret     = NO
           tt-it-imposto.cd-trib-icm     = tt-item-doc-est.cd-trib-icm
           tt-it-imposto.cd-trib-ipi     = tt-item-doc-est.cd-trib-ipi
           tt-it-imposto.cd-trib-iss     = i-cd-trib-iss
           tt-it-imposto.aliquota-icm    = tt-item-doc-est.aliquota-icm
           tt-it-imposto.aliquota-ipi    = tt-item-doc-est.aliquota-ipi           
           tt-it-imposto.aliquota-iss    = tt-item-doc-est.aliquota-iss
           tt-it-imposto.perc-red-icm    = natur-oper.perc-red-icm
           tt-it-imposto.perc-red-ipi    = natur-oper.perc-red-ipi.
           
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-gera-tt-docto:
/*------------------------------------------------------------------------------
  Purpose:     Cabecalho utilizado para calculos de impostos no Recebimento 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    CREATE tt-docto.
    ASSIGN tt-docto.seq-tt-docto    = 1
           tt-docto.dt-trans        = tt-docum-est.dt-trans
           tt-docto.ind-tip-nota    = 8
           tt-docto.cod-estabel     = tt-docum-est.cod-estabel
           tt-docto.serie           = tt-docum-est.serie-docto
           tt-docto.nr-nota         = tt-docum-est.nro-docto
           tt-docto.cod-emitente    = tt-docum-est.cod-emitente
           tt-docto.nat-operacao    = tt-docum-est.nat-operacao
           tt-docto.dt-emis-nota    = tt-docum-est.dt-trans
           tt-docto.nome-abrev      = tt-parametros-aux.nome-abrev
           tt-docto.usuario         = tt-docum-est.usuario
           tt-docto.inc-seq         = tt-parametros-aux.inc-seq
           tt-docto.seq-item-um     = tt-parametros-aux.seq-item-um
           tt-docto.estado          = tt-parametros-aux.estado-estab
           tt-docto.cidade          = tt-parametros-aux.cidade
           tt-docto.pais            = tt-parametros-aux.pais
           tt-docto.cod-des-merc    = IF tt-parametros-aux.consum-final THEN 2 /* Consumo */ ELSE 1 /* Industralizacao */
           tt-docto.esp-docto       = tt-docum-est.esp-docto
           tt-docto.cod-msg         = tt-parametros-aux.cod-mensagem
           tt-docto.cod-portador    = tt-parametros-aux.portador
           tt-docto.modalidade      = tt-parametros-aux.modalidade
           tt-docto.ind-lib-nota    = YES
           tt-docto.perc-desco1     = IF tt-docum-est.tot-desconto <> 0 THEN 1 ELSE 0.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE calculateImpostos:
/*------------------------------------------------------------------------------
  Purpose:     Calcula os impostos para os itens
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE de-preco-total  LIKE tt-item-doc-est.preco-total       NO-UNDO.
    DEFINE VARIABLE de-base-pis     LIKE item-doc-est.base-pis             NO-UNDO.
    DEFINE VARIABLE de-valor-pis    LIKE item-doc-est.valor-pis            NO-UNDO.
    DEFINE VARIABLE de-valor-cofins LIKE item-doc-est.val-cofins           NO-UNDO.
    DEFINE VARIABLE de-base-cofins  LIKE item-doc-est.val-base-calc-cofins NO-UNDO.
    
    FIND FIRST tt-docum-est NO-ERROR.
    
    RUN pi-gera-tt-docto.
    
    FIND FIRST tt-docto NO-ERROR.
    
    FOR EACH tt-item-doc-est:    
        
        RUN pi-gera-tt-it-docto.

        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        
        FIND FIRST tt-it-docto
             WHERE tt-it-docto.nr-sequencia = tt-item-doc-est.sequencia NO-ERROR.
            
        RUN pi-gera-tt-it-imposto.

        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.

        FIND FIRST tt-it-imposto 
             WHERE tt-it-imposto.seq-tt-it-docto = tt-it-docto.seq-tt-it-docto NO-ERROR.
        
        IF tt-item-doc-est.base-ipi <> 0 THEN /* Somente atualiza os valores da tt-it-docto quando a desp-imp incidir no IPI */
            ASSIGN tt-it-docto.vl-preuni   = tt-item-doc-est.base-ipi
                   tt-it-docto.vl-preori   = tt-item-doc-est.base-ipi
                   tt-it-docto.vl-merc-liq = tt-item-doc-est.base-ipi
                   tt-it-docto.vl-merc-ori = tt-item-doc-est.base-ipi.
    
        /** Calculo a base e o valor do IPI **/
        RUN cdp/cd4306.p ( tt-it-docto.seq-tt-it-docto,
                           1,                                    /* Natureza Entrada */
                           tt-parametros-aux.natur-oper-char-2,  /* Frete Base IPI   */
                           NO,                                   /* Nota Comercio    */
                           INPUT        TABLE tt-docto,
                           INPUT        TABLE tt-it-docto,
                           INPUT-OUTPUT TABLE tt-it-imposto).
                           
        IF tt-item-doc-est.base-icm <> 0 THEN  /* Somente atualiza os valores da tt-it-docto quando a desp-imp incidir no ICMS */
            ASSIGN tt-it-docto.vl-preuni   = tt-item-doc-est.base-icm
                   tt-it-docto.vl-preori   = tt-item-doc-est.base-icm
                   tt-it-docto.vl-merc-liq = tt-item-doc-est.base-icm
                   tt-it-docto.vl-merc-ori = tt-item-doc-est.base-icm.                          
        
        /** Calcula a base e o valor do ISS **/
        IF tt-docum-est.cod-observa = 4 THEN
            RUN cdp/cd4307.p (INPUT tt-it-docto.seq-tt-it-docto,
                              INPUT 1,   /* Natureza Entrada */
                              INPUT YES, /* Base pelo Bruto  */
                              INPUT TABLE tt-it-docto,
                              INPUT-OUTPUT TABLE tt-it-imposto).

        RUN pi-calculate-piscofins (INPUT 0,
                                    INPUT 0,
                                    INPUT 0,
                                    INPUT 0,                                  
                                    INPUT 0,
                                    INPUT 0,
                                    INPUT 0,
                                    OUTPUT de-base-pis,
                                    OUTPUT de-valor-pis,
                                    OUTPUT de-base-cofins,
                                    OUTPUT de-valor-cofins).
        
        FIND FIRST tt-it-imposto
             WHERE tt-it-imposto.seq-tt-it-docto = tt-it-docto.seq-tt-it-docto NO-ERROR.
          
        ASSIGN tt-item-doc-est.base-icm        = tt-it-imposto.vl-bicms-it
               tt-item-doc-est.valor-icm       = tt-it-imposto.vl-icms-it
               tt-item-doc-est.icm-ntrib       = tt-it-imposto.vl-icmsnt-it
               tt-item-doc-est.icm-outras      = tt-it-imposto.vl-icmsou-it
               tt-item-doc-est.base-ipi        = tt-it-imposto.vl-bipi-it
               tt-item-doc-est.valor-ipi       = tt-it-imposto.vl-ipi-it
               tt-item-doc-est.ipi-ntrib       = tt-it-imposto.vl-ipint-it
               tt-item-doc-est.ipi-outras      = tt-it-imposto.vl-ipiou-it
               tt-item-doc-est.base-iss        = tt-it-imposto.vl-biss-it
               tt-item-doc-est.valor-iss       = tt-it-imposto.vl-iss-it
               tt-item-doc-est.iss-ntrib       = tt-it-imposto.vl-issnt-it
               tt-item-doc-est.iss-outras      = tt-it-imposto.vl-issou-it
               tt-item-doc-est.base-pis        = de-base-pis
               tt-item-doc-est.valor-pis       = de-valor-pis
               tt-item-doc-est.aliquota-pis    = tt-parametros.aliquota-pis
               tt-item-doc-est.aliquota-cofins = tt-parametros.aliquota-cofins
               tt-item-doc-est.cd-trib-pis     = tt-parametros.i-tributacao-pis
               tt-item-doc-est.valor-cofins    = de-valor-cofins
               tt-item-doc-est.base-cofins     = de-base-cofins
               tt-item-doc-est.cd-trib-cofins  = tt-parametros.i-tributacao-cofins.
    
        /** Acumula totais **/
        ASSIGN tt-docum-est.valor-mercad      = tt-docum-est.valor-mercad
                                              + tt-item-doc-est.preco-total
               tt-parametros-aux.valor-duplic = tt-parametros-aux.valor-duplic
                                              + tt-item-doc-est.valor-ipi.
    END.

    /** Calcula base e o valor ICMS **/
    FIND LAST tt-docto NO-ERROR.
    
    
    /* Calcula a base e o valor do ICMS */
    RUN rep/re1906.p ( tt-docto.seq-tt-docto,
                       YES,                /* ICMS */
                       NO,                 /* Subst. Tributaria */
                       YES,                /* ICMS Complementar */
                       INPUT        TABLE tt-docto,
                       INPUT        TABLE tt-it-docto,
                       INPUT-OUTPUT TABLE tt-it-imposto).
    
    /* INFORMANDO ICMS NOS ITENS DA NOTA */                   
    FOR EACH tt-it-docto
        USE-INDEX codigo:  

        FIND FIRST tt-it-imposto 
             WHERE tt-it-imposto.seq-tt-it-docto = tt-it-docto.seq-tt-it-docto NO-ERROR.
    
        FIND FIRST tt-item-doc-est 
             WHERE tt-item-doc-est.cod-emitente = tt-it-docto.cod-emitente 
               AND tt-item-doc-est.nro-docto    = tt-it-docto.nr-nota 
               AND tt-item-doc-est.serie-docto  = tt-it-docto.serie 
               AND tt-item-doc-est.nat-operacao = tt-it-docto.nat-operacao 
               AND tt-item-doc-est.sequencia    = tt-it-docto.nr-sequencia NO-ERROR.
        
        ASSIGN tt-item-doc-est.base-icm    = tt-it-imposto.vl-bicms-it
               tt-item-doc-est.valor-icm   = tt-it-imposto.vl-icms-it
               tt-item-doc-est.icm-ntrib   = tt-it-imposto.vl-icmsnt-it
               tt-item-doc-est.icm-outras  = tt-it-imposto.vl-icmsou-it
               tt-item-doc-est.icm-complem = tt-it-imposto.icm-complem
               tt-it-docto.vl-preuni       = tt-item-doc-est.base-iss WHEN tt-item-doc-est.base-iss > 0
               tt-it-docto.vl-preori       = tt-item-doc-est.base-iss WHEN tt-item-doc-est.base-iss > 0
               tt-it-docto.vl-merc-liq     = tt-item-doc-est.base-iss WHEN tt-item-doc-est.base-iss > 0
               tt-it-docto.vl-merc-ori     = tt-item-doc-est.base-iss WHEN tt-item-doc-est.base-iss > 0.

        IF tt-it-imposto.vl-bicms-compl <> 0 OR tt-it-imposto.icm-complem <> 0 THEN DO:
            
            FIND FIRST tt-docum-est-aux
                 WHERE tt-docum-est-aux.cod-emitente = tt-item-doc-est.cod-emitente
                   AND tt-docum-est-aux.nro-docto    = tt-item-doc-est.nro-docto
                   AND tt-docum-est-aux.serie-docto  = tt-item-doc-est.serie-docto
                   AND tt-docum-est-aux.nat-operacao = tt-item-doc-est.nat-operacao NO-LOCK NO-ERROR.

            /* Totalizando base e valor do ICMS complementar */
            IF NOT AVAIL tt-docum-est-aux THEN DO:
                CREATE tt-docum-est-aux.
                ASSIGN tt-docum-est-aux.cod-emitente           = tt-it-docto.cod-emitente
                       tt-docum-est-aux.nro-docto              = tt-it-docto.nr-nota
                       tt-docum-est-aux.serie-docto            = tt-it-docto.serie
                       tt-docum-est-aux.nat-operacao           = tt-it-docto.nat-operacao
                       tt-docum-est-aux.icm-complem            = tt-item-doc-est.icm-complem           /* valor */
                       OVERLAY(tt-docum-est-aux.char-2,191,20) = STRING(tt-it-imposto.vl-bicms-compl). /* base */
            END.
            ELSE
                ASSIGN tt-docum-est-aux.icm-complem            = tt-docum-est-aux.icm-complem + tt-item-doc-est.icm-complem                              /* valor */
                       OVERLAY(tt-docum-est-aux.char-2,191,20) = STRING( DEC(SUBSTRING(tt-docum-est-aux.char-2,191,20)) + tt-it-imposto.vl-bicms-compl). /* base */

            IF NOT CAN-FIND(FIRST tt-item-doc-est-aux
                            WHERE tt-item-doc-est-aux.cod-emitente           = tt-item-doc-est.cod-emitente
                              AND tt-item-doc-est-aux.nro-docto              = tt-it-docto.nr-nota     
                              AND tt-item-doc-est-aux.serie-docto            = tt-it-docto.serie       
                              AND tt-item-doc-est-aux.nat-operacao           = tt-it-docto.nat-operacao
                              AND tt-item-doc-est-aux.sequencia              = tt-it-docto.nr-sequencia) THEN DO:

                /* Temp-table enviada a reapi190b para popular o campo da item-doc-est */
                CREATE tt-item-doc-est-aux.
                ASSIGN tt-item-doc-est-aux.cod-emitente           = tt-item-doc-est.cod-emitente
                       tt-item-doc-est-aux.nro-docto              = tt-it-docto.nr-nota
                       tt-item-doc-est-aux.serie-docto            = tt-it-docto.serie
                       tt-item-doc-est-aux.nat-operacao           = tt-it-docto.nat-operacao
                       tt-item-doc-est-aux.sequencia              = tt-it-docto.nr-sequencia
                       OVERLAY(tt-item-doc-est-aux.char-2,860,20) = STRING(tt-it-imposto.vl-bicms-compl). /* base icms complementar - item */
            END.
        END.
    END. /* FOR EACH tt-it-docto */

    IF VALID-HANDLE(h-cd4338) THEN DO:
        DELETE PROCEDURE h-cd4338.
        ASSIGN h-cd4338 = ?.
    END.
    
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE generateTT-item-doc-est:
/*------------------------------------------------------------------------------
  Purpose:     Cria‡Æo da temp-table tt-item-doc-est
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-sequencia         AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-cod-emitente-desp AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-cod-cond-pag      AS INTEGER NO-UNDO.
    
    FOR FIRST embarque-imp FIELDS (declaracao-import data-di)
        WHERE embarque-imp.cod-estabel = tt-parametros.cod-estabel
          AND embarque-imp.embarque    = tt-parametros.embarque NO-LOCK: END.

    IF NOT AVAIL embarque-imp THEN NEXT.

    ASSIGN cDi    = embarque-imp.declaracao-import
           dataDi = embarque-imp.data-di.

    FIND FIRST tt-docum-est-orig NO-ERROR.

    /*M¢dulo de importa‡Æo*/
    {cdp/cd4300.i4 "yes" tt-docum-est-orig.char-1}
    {rep/re1001a.i51 "yes"}
    /*M¢dulo de importa‡Æo*/

    FOR LAST item-doc-est FIELDS(sequencia) {cdp/cd8900.i item-doc-est tt-docum-est} NO-LOCK: END.

    IF AVAIL item-doc-est THEN
        ASSIGN i-sequencia = item-doc-est.sequencia + tt-parametros-aux.inc-seq.
    ELSE DO:

        FOR LAST tt-item-doc-est FIELDS(sequencia) {cdp/cd8900.i tt-item-doc-est tt-docum-est} NO-LOCK: END.

        IF AVAIL tt-item-doc-est THEN
            ASSIGN i-sequencia = tt-item-doc-est.sequencia + tt-parametros-aux.inc-seq.
        ELSE
            ASSIGN i-sequencia = tt-parametros-aux.seq-item-um.
    END.
    
    FOR EACH item-doc-est {cdp/cd8900.i item-doc-est tt-docum-est-orig} NO-LOCK:

        FIND FIRST tt-desp-rateio
             WHERE tt-desp-rateio.numero-ordem = item-doc-est.numero-ordem
               AND tt-desp-rateio.parcela      = item-doc-est.parcela NO-LOCK NO-ERROR.

        IF NOT AVAIL tt-desp-rateio THEN
            NEXT.        
            
        FIND FIRST tt-ordens-totais
             WHERE tt-ordens-totais.numero-ordem = item-doc-est.numero-ordem
               AND tt-ordens-totais.parcela    = item-doc-est.parcela NO-LOCK NO-ERROR.

        IF NOT AVAIL tt-ordens-totais THEN
            NEXT.

        FOR FIRST item FIELDS(aliquota-iss cd-trib-iss)
            WHERE item.it-codigo = item-doc-est.it-codigo NO-LOCK: END.
    
        CREATE tt-item-doc-est.
        ASSIGN tt-item-doc-est.it-codigo         = item-doc-est.it-codigo
               tt-item-doc-est.cod-refer         = item-doc-est.cod-refer
               tt-item-doc-est.encerra-pa        = item-doc-est.encerra-pa
               tt-item-doc-est.nr-ord-prod       = item-doc-est.nr-ord-prod
               tt-item-doc-est.ct-codigo         = item-doc-est.ct-codigo
               tt-item-doc-est.sc-codigo         = item-doc-est.sc-codigo
               tt-item-doc-est.cod-roteiro       = item-doc-est.cod-roteiro
               tt-item-doc-est.op-codigo         = item-doc-est.op-codigo
               tt-item-doc-est.item-pai          = item-doc-est.item-pai
               tt-item-doc-est.baixa-ce          = item-doc-est.baixa-ce
               tt-item-doc-est.preco-total       = 0
               tt-item-doc-est.peso-liquido      = 0
               tt-item-doc-est.class-fiscal      = item-doc-est.class-fiscal
               tt-item-doc-est.aliquota-ipi      = tt-parametros.aliquota-ipi
               tt-item-doc-est.aliquota-icm      = tt-parametros.aliquota-icm
               tt-item-doc-est.valor-subs        = 0
               tt-item-doc-est.aliquota-iss      = item.aliquota-iss
               tt-item-doc-est.cd-trib-iss       = item.cd-trib-iss
               tt-item-doc-est.narrativa         = ""
               tt-item-doc-est.serie-comp        = tt-docum-est-orig.serie-docto
               tt-item-doc-est.nro-comp          = tt-docum-est-orig.nro-docto
               tt-item-doc-est.nat-comp          = tt-docum-est-orig.nat-operacao
               tt-item-doc-est.seq-comp          = item-doc-est.sequencia
               tt-item-doc-est.data-comp         = tt-docum-est-orig.dt-emissao
               tt-item-doc-est.serie-docto       = tt-docum-est.serie-docto
               tt-item-doc-est.nro-docto         = tt-docum-est.nro-docto
               tt-item-doc-est.cod-emitente      = tt-docum-est.cod-emitente
               tt-item-doc-est.nat-operacao      = tt-docum-est.nat-operacao
               tt-item-doc-est.sequencia         = i-sequencia
               i-sequencia                       = i-sequencia + tt-parametros-aux.inc-seq
               tt-item-doc-est.ind-icm-ret       = NO. /*ICMS retido na fonte*/
               
        IF l-nt2024002 THEN 
            RUN create-tb-wt-it-impostoCBSIBS (INPUT tt-item-doc-est.sequencia).
            
        IF l-mat-unid-negoc THEN
            ASSIGN tt-item-doc-est.cod-unid-negoc  = item-doc-est.cod-unid-negoc.
               
        /*Se a tributa‡Æo estiver marcada como "Reduzida"(Im0101 - pasta parametros),
         ‚ necess rio que a nota fiscal complementar respeite a tributa‡Æo do ICMS
         dos itens conforme a nota fiscal Principal */
        IF tt-parametros.i-tributacao-icm = 4 THEN
            ASSIGN tt-item-doc-est.cd-trib-icm = item-doc-est.cd-trib-icm.
        ELSE
            ASSIGN tt-item-doc-est.cd-trib-icm = tt-parametros.i-tributacao-icm.

        ASSIGN tt-item-doc-est.cd-trib-ipi = tt-parametros.i-tributacao-ipi.
        
               
        FIND FIRST rat-lote {cdp/cd8900.i rat-lote item-doc-est }
               AND rat-lote.sequencia = item-doc-est.sequencia NO-LOCK NO-ERROR.

        IF AVAIL rat-lote THEN
            ASSIGN tt-item-doc-est.cod-depos    = rat-lote.cod-depos
                   tt-item-doc-est.cod-localiz  = rat-lote.cod-localiz
                   tt-item-doc-est.lote         = rat-lote.lote
                   tt-item-doc-est.dt-vali-lote = rat-lote.dt-vali-lote.
        ELSE
            ASSIGN tt-item-doc-est.cod-depos    = item-doc-est.cod-depos
                   tt-item-doc-est.cod-localiz  = item-doc-est.cod-localiz
                   tt-item-doc-est.lote         = item-doc-est.lote
                   tt-item-doc-est.dt-vali-lote = item-doc-est.dt-vali-lote.

        
        IF l-mat-unid-negoc AND l-unidade-negocio THEN
            RUN generateTT-unid-neg-nota.
        
        FOR EACH  tt-desp-rateio
            WHERE tt-desp-rateio.numero-ordem = item-doc-est.numero-ordem
            AND   tt-desp-rateio.parcela      = item-doc-est.parcela
            USE-INDEX codigo:

            FOR FIRST desp-imp FIELDS(inc-base-ipi inc-base-icm int-2 inc-val-duplic log-incid-base-pis-val log-incid-base-cofins-val)
                WHERE desp-imp.cod-desp = tt-desp-rateio.cod-desp NO-LOCK:

                IF tt-desp-rateio.val-desp = ? THEN
                    ASSIGN tt-desp-rateio.val-desp = 0.
    
                IF desp-imp.inc-base-ipi THEN
                    ASSIGN tt-item-doc-est.base-ipi = tt-item-doc-est.base-ipi 
                                                    + ((tt-desp-rateio.val-desp * item-doc-est.quantidade) / tt-ordens-totais.quantidade).
                IF desp-imp.inc-base-icm THEN
                    ASSIGN tt-item-doc-est.base-icm = tt-item-doc-est.base-icm
                                                    + ((tt-desp-rateio.val-desp * item-doc-est.quantidade) / tt-ordens-totais.quantidade).
                /** Incide Base Pis **/
                IF desp-imp.log-incid-base-pis-val THEN
                    ASSIGN tt-item-doc-est.base-pis = tt-item-doc-est.base-pis
                                                    + ((tt-desp-rateio.val-desp * item-doc-est.quantidade) / tt-ordens-totais.quantidade).

                /** Incide Base Cofins **/
                IF desp-imp.log-incid-base-cofins-val THEN
                    ASSIGN tt-item-doc-est.base-cofins = tt-item-doc-est.base-cofins
                                                       + ((tt-desp-rateio.val-desp * item-doc-est.quantidade) / tt-ordens-totais.quantidade).

                /** Incide Base ISS **/                                                
                IF desp-imp.int-2 = 1 THEN
                    ASSIGN tt-item-doc-est.base-iss = tt-item-doc-est.base-iss
                                                    + ((tt-desp-rateio.val-desp * item-doc-est.quantidade) / tt-ordens-totais.quantidade).
                /** Acumula Valor Duplicatas **/
                IF desp-imp.inc-val-duplic THEN
                    ASSIGN tt-parametros-aux.valor-duplic = tt-parametros-aux.valor-duplic
                                                          + ((tt-desp-rateio.val-desp * item-doc-est.quantidade) / tt-ordens-totais.quantidade).

                ASSIGN tt-parametros-aux.valor-mercad = tt-parametros-aux.valor-mercad
                                                      + tt-desp-rateio.val-desp.
            END.

            ASSIGN tt-item-doc-est.preco-total = tt-item-doc-est.preco-total
                                               + ((tt-desp-rateio.val-desp * item-doc-est.quantidade) / tt-ordens-totais.quantidade).

            ASSIGN i-cod-emitente-desp = tt-parametros.cod-emitente-desp
                   i-cod-cond-pag      = tt-parametros-aux.cod-cond-pag.

            
            FIND FIRST tt-selecao-despesa
                 WHERE tt-selecao-despesa.cod-estabel = tt-parametros.cod-estabel
                   AND tt-selecao-despesa.embarque    = TRIM(c-embarque)
                   AND tt-selecao-despesa.cod-desp    = tt-desp-rateio.cod-desp NO-ERROR.

            ASSIGN i-cod-emitente-desp = tt-selecao-despesa.cod-emitente-desp
                   i-cod-cond-pag      = tt-selecao-despesa.cond-pagto. 

            FIND FIRST tt-docum-est-cex
                 WHERE tt-docum-est-cex.cod-desp = tt-desp-rateio.cod-desp 
                   AND tt-docum-est-cex.cod-emitente-desp = tt-selecao-despesa.cod-emitente-desp NO-ERROR.

            IF NOT AVAIL tt-docum-est-cex THEN DO:

                CREATE tt-docum-est-cex.
                ASSIGN tt-docum-est-cex.serie-docto          = tt-item-doc-est.serie-docto
                       tt-docum-est-cex.nro-docto            = STRING(tt-item-doc-est.nro-docto)
                       tt-docum-est-cex.cod-emitente         = tt-item-doc-est.cod-emitente
                       tt-docum-est-cex.nat-operacao         = tt-item-doc-est.nat-operacao
                       tt-docum-est-cex.cod-emitente-desp    = i-cod-emitente-desp
                       tt-docum-est-cex.cod-desp             = tt-desp-rateio.cod-desp        
                       tt-docum-est-cex.cod-cond-pag         = i-cod-cond-pag
                       tt-docum-est-cex.mo-codigo            = 0
                       tt-docum-est-cex.cotacao              = 1
                       OVERLAY(tt-docum-est-cex.char-1,1,20) = TRIM(SUBSTR(tt-docum-est-orig.char-1,1,20)). /* utilizado na setObservacao e apagado */
            END.

            ASSIGN tt-docum-est-cex.val-desp             = IF  tt-docum-est-cex.val-desp = ? THEN 0 
                                                           ELSE tt-docum-est-cex.val-desp + ((tt-desp-rateio.val-desp * item-doc-est.quantidade) / tt-ordens-totais.quantidade).
            CREATE tt-item-doc-est-cex.
            ASSIGN tt-item-doc-est-cex.serie-docto       = tt-item-doc-est.serie-docto      
                   tt-item-doc-est-cex.nro-docto         = STRING(tt-item-doc-est.nro-docto)
                   tt-item-doc-est-cex.cod-emitente      = tt-item-doc-est.cod-emitente     
                   tt-item-doc-est-cex.nat-operacao      = tt-item-doc-est.nat-operacao     
                   tt-item-doc-est-cex.sequencia         = tt-item-doc-est.sequencia        
                   tt-item-doc-est-cex.cod-emitente-desp = i-cod-emitente-desp
                   tt-item-doc-est-cex.cod-desp          = tt-desp-rateio.cod-desp
                   tt-item-doc-est-cex.mo-codigo         = 0
                   tt-item-doc-est-cex.cotacao           = 1
                   tt-item-doc-est-cex.embarque          = TRIM(c-embarque)
                   tt-item-doc-est-cex.cod-estabel       = tt-parametros.cod-estabel
                   tt-item-doc-est-cex.num-seq-orig      = item-doc-est.sequencia
                   tt-item-doc-est-cex.dat-cotac         = tt-parametros.da-cotacao
                   tt-item-doc-est-cex.val-desp          = IF tt-item-doc-est-cex.val-desp = ? THEN 0
                                                           ELSE tt-item-doc-est-cex.val-desp + ((tt-desp-rateio.val-desp * item-doc-est.quantidade) / tt-ordens-totais.quantidade).
        END.
    END.

    IF NOT CAN-FIND(FIRST tt-item-doc-est) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE generateTT-dupli-apagar:
/*------------------------------------------------------------------------------
  Purpose:     Cria‡Æo da temp-table tt-dupli-apagar
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE da-data         AS   DATE    EXTENT 12              NO-UNDO.
    DEFINE VARIABLE da-partida      AS   DATE                           NO-UNDO.
    DEFINE VARIABLE dt-vencim       AS   DATE    FORMAT "99/99/9999":U  NO-UNDO.
    DEFINE VARIABLE i-ind           AS   INTEGER                        NO-UNDO.
    DEFINE VARIABLE de-vl-apagar    LIKE dupli-apagar.vl-a-pagar        NO-UNDO.
    DEFINE VARIABLE de-vl-apagar-mo LIKE dupli-apagar.vl-a-pagar        NO-UNDO.
    
    FIND FIRST tt-docum-est NO-ERROR.
    
    IF NOT tt-parametros-aux.emite-duplic THEN
        RETURN "OK":U.
    
    IF tt-parametros-aux.valor-duplic <= 0 THEN
        RETURN "OK":U.
    
    
    IF tt-parametros-aux.natureza = 3 OR tt-parametros-aux.natureza = 4 THEN DO:
        
        IF tt-parametros-aux.mo-codigo <> 0 THEN DO:
            RUN cdp/cd0812.p (INPUT 0,
                              INPUT tt-parametros-aux.mo-codigo,
                              INPUT tt-parametros-aux.valor-duplic,
                              INPUT tt-parametros.da-cotacao,
                              OUTPUT tt-parametros-aux.valor-duplic-me).
        END.
    END.
    
    IF tt-parametros-aux.valor-duplic-me = ? THEN
        ASSIGN tt-parametros-aux.valor-duplic-me = 0.
        
    FOR FIRST emitente FIELDS(ven-domingo ven-sabado ven-feriado)
        WHERE emitente.cod-emitente = tt-parametros.cod-emitente-desp NO-LOCK: END.

    FOR FIRST cond-pagto
        WHERE cond-pagto.cod-cond-pag = tt-parametros-aux.cod-cond-pag NO-LOCK:
    END.

    IF NOT AVAIL cond-pagto THEN NEXT.
    
    ASSIGN da-data    = TODAY
           da-partida = tt-parametros-aux.da-partida.
   
    {cdp/cd9020.i7 tt-parametros.cod-estabel} /* calculo data de vencimento */                
    
    DO i-ind = 1 TO cond-pagto.num-parcelas:

		IF i-ind > 99 THEN
			RUN pi-avisa-parcela99.
    
        IF da-data[i-ind] < TODAY THEN
            ASSIGN dt-vencim = TODAY.
        ELSE
            ASSIGN dt-vencim = da-data[i-ind].
    
        CREATE tt-dupli-apagar.
        ASSIGN tt-dupli-apagar.cod-emitente  = tt-parametros.cod-emitente-desp
               tt-dupli-apagar.dt-vencim     = dt-vencim
               tt-dupli-apagar.nat-operacao  = tt-parametros.nat-operacao
               tt-dupli-apagar.nro-docto     = tt-docum-est.nro-docto
               tt-dupli-apagar.parcela       = (IF i-ind <= 99 THEN STRING(INT(i-ind),"99":U)
													ELSE STRING(INT(i-ind)))
               tt-dupli-apagar.serie-docto   = tt-parametros.serie
               tt-dupli-apagar.nr-duplic     = tt-docum-est.nro-docto
               tt-dupli-apagar.tp-despesa    = tt-parametros-aux.tp-despesa
               tt-dupli-apagar.cod-esp       = tt-parametros-aux.esp-tit-rec
               tt-dupli-apagar.vl-a-pagar    = tt-parametros-aux.valor-duplic    * cond-pagto.per-pg-dup[i-ind] / 100
               tt-dupli-apagar.vl-a-pagar-mo = tt-parametros-aux.valor-duplic-me * cond-pagto.per-pg-dup[i-ind] / 100.
        
        IF tt-parametros-aux.natureza = 3 OR tt-parametros-aux.natureza = 4 THEN
            ASSIGN tt-dupli-apagar.mo-codigo = tt-parametros-aux.mo-codigo.
    END.
    
    FOR EACH tt-dupli-apagar:

        ASSIGN de-vl-apagar    = de-vl-apagar    + tt-dupli-apagar.vl-a-pagar
               de-vl-apagar-mo = de-vl-apagar-mo + tt-dupli-apagar.vl-a-pagar-mo.
    END.
    
    IF de-vl-apagar <> tt-parametros-aux.valor-duplic THEN DO:
        FIND LAST tt-dupli-apagar NO-ERROR.

        ASSIGN tt-dupli-apagar.vl-a-pagar = tt-dupli-apagar.vl-a-pagar + (tt-parametros-aux.valor-duplic - de-vl-apagar).
    END.
    
    IF de-vl-apagar-mo <> tt-parametros-aux.valor-duplic-me THEN DO:
        FIND LAST tt-dupli-apagar NO-ERROR.

        ASSIGN tt-dupli-apagar.vl-a-pagar-mo = tt-dupli-apagar.vl-a-pagar-mo + (tt-parametros-aux.valor-duplic-me - de-vl-apagar-mo).
    END.
    
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE generateTT-dupli-apagar-cex:
/*------------------------------------------------------------------------------
  Purpose:     Cria‡Æo das duplicatas das despesas
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE de-dup-tot              LIKE dupli-apagar.vl-a-pagar     NO-UNDO.
    DEFINE VARIABLE de-dup-tot-mo           LIKE dupli-apagar.vl-a-pagar     NO-UNDO.    
    DEFINE VARIABLE de-val-desp             LIKE dupli-apagar-cex.vl-a-pagar NO-UNDO.
    DEFINE VARIABLE de-val-desp-mo          LIKE dupli-apagar-cex.vl-a-pagar NO-UNDO.
    DEFINE VARIABLE de-total-dup            LIKE dupli-apagar.vl-a-pagar     NO-UNDO.
    DEFINE VARIABLE de-total-dup-mo         LIKE dupli-apagar.vl-a-pagar     NO-UNDO.
    DEFINE VARIABLE i-ind                   AS   INTEGER                     NO-UNDO.
    DEFINE VARIABLE da-data                 AS   DATE    EXTENT 12           NO-UNDO.
    DEFINE VARIABLE i-parcela               AS   INTEGER                     NO-UNDO.
    DEFINE VARIABLE c-cod-estabel           LIKE estabelec.cod-estabel       NO-UNDO.
    DEFINE VARIABLE c-embarque              AS   CHARACTER FORMAT "x(20)":U  NO-UNDO.
    DEFINE VARIABLE i-cod-emitente-desp-ant AS   INTEGER                     NO-UNDO.

    IF NOT tt-parametros-aux.emite-duplic THEN
        RETURN "OK":U.
    
    EMPTY TEMP-TABLE tt-dupli-apagar-cex.
    
    FIND FIRST tt-docum-est NO-ERROR.
    FIND FIRST docum-est NO-LOCK OF tt-docum-est no-error.

    IF AVAIL docum-est THEN DO:

        FIND FIRST param-imp
             WHERE param-imp.cod-estabel = docum-est.cod-estabel NO-LOCK NO-ERROR.

        FOR EACH docum-est-cex 
           WHERE docum-est-cex.serie-docto   = docum-est.serie-docto
             AND docum-est-cex.nro-docto     = docum-est.nro-docto
             AND docum-est-cex.cod-emitente = docum-est.cod-emitente
             AND docum-est-cex.nat-operacao = docum-est.nat-operacao NO-LOCK
            USE-INDEX codigo:
               
            /* Testa se despesa incide no valor da duplicata */
            FIND FIRST desp-imp
                 WHERE desp-imp.cod-desp = docum-est-cex.cod-desp NO-LOCK NO-ERROR.

            IF AVAIL desp-imp AND NOT desp-imp.inc-val-duplic THEN
                NEXT.
               
            FIND FIRST emitente
                 WHERE emitente.cod-emitente = docum-est-cex.cod-emitente-desp NO-LOCK NO-ERROR.
                
            FIND FIRST tt-desp-totais-embarques-mult
                 WHERE tt-desp-totais-embarques-mult.cod-desp          = docum-est-cex.cod-desp 
                   AND tt-desp-totais-embarques-mult.cod-emitente-desp = docum-est-cex.cod-emitente-desp NO-ERROR.

            IF NOT AVAIL tt-desp-totais-embarques-mult THEN
                NEXT.        
        
            IF AVAIL param-imp THEN
                ASSIGN c-espec-padr = param-imp.esp-tit-rec.
            
            FOR FIRST desp-imp NO-LOCK
                WHERE desp-imp.cod-desp = docum-est-cex.cod-desp
                  AND {&vcod-espec-padr} <> "":
                
                ASSIGN c-espec-padr = {&vcod-espec-padr}.
            END.
        
            FOR EACH  item-doc-est-cex
                WHERE item-doc-est-cex.serie-docto       = docum-est-cex.serie-docto
                AND   item-doc-est-cex.nro-docto         = docum-est-cex.nro-docto
                AND   item-doc-est-cex.cod-emitente      = docum-est-cex.cod-emitente
                AND   item-doc-est-cex.nat-operacao      = docum-est-cex.nat-operacao
                AND   item-doc-est-cex.cod-emitente-desp = docum-est-cex.cod-emitente-desp          
                AND   item-doc-est-cex.cod-desp          = docum-est-cex.cod-desp
                AND   item-doc-est-cex.mo-codigo         = docum-est-cex.mo-codigo NO-LOCK
                USE-INDEX codigo:

                ASSIGN c-embarque    = item-doc-est-cex.embarque   
                       c-cod-estabel = item-doc-est-cex.cod-estabel.
                
                FIND FIRST item-doc-est 
                     WHERE item-doc-est.serie-docto   = item-doc-est-cex.serie-docto
                       AND item-doc-est.nro-docto = item-doc-est-cex.nro-docto
                       AND item-doc-est.cod-emitente  = item-doc-est-cex.cod-emitente
                       AND item-doc-est.nat-operacao  = item-doc-est-cex.nat-operacao
                       AND item-doc-est.sequencia     = item-doc-est-cex.sequencia NO-LOCK NO-ERROR.
                      
                ASSIGN de-val-desp    = item-doc-est-cex.val-desp
                       de-val-desp-mo = item-doc-est-cex.val-desp.
                
                IF tt-desp-totais-embarques-mult.mo-codigo <> 0 THEN DO:
                    RUN cdp/cd0812.p (INPUT  0,
                                      INPUT  tt-desp-totais-embarques-mult.mo-codigo,
                                      INPUT  de-val-desp,
                                      INPUT  item-doc-est-cex.dat-cotac,
                                      OUTPUT de-val-desp-mo).
                END.

                IF de-val-desp-mo = ? THEN
                    ASSIGN de-val-desp-mo = 0.

                FIND FIRST ordem-compra
                     WHERE ordem-compra.numero-ordem = item-doc-est.numero-ordem NO-LOCK NO-ERROR.
                 
                FIND FIRST cond-pagto
                     WHERE cond-pagto.cod-cond-pag = docum-est-cex.cod-cond-pag NO-LOCK NO-ERROR.
                               
                IF NOT AVAIL cond-pagto THEN DO:

                    FIND FIRST cond-especif-cex
                         WHERE cond-especif-cex.num-pedido        = ordem-compra.num-pedido
                           AND cond-especif-cex.cod-emitente-desp = docum-est-cex.cod-emitente-desp
                           AND cond-especif-cex.cod-desp          = docum-est-cex.cod-desp NO-LOCK NO-ERROR.

                    IF NOT AVAIL cond-especif-cex THEN
                        NEXT.
                    ELSE DO:
                        /* Condicao especifica de pagamento */
                        DO i-ind = 1 TO 6:
                            IF cond-especif-cex.data-pagto[i-ind] <> ? THEN DO:

                                CREATE tt-dupli-apagar-cex.
                                ASSIGN tt-dupli-apagar-cex.cod-emitente      = docum-est-cex.cod-emitente
                                       tt-dupli-apagar-cex.nat-operacao      = docum-est.nat-operacao
                                       tt-dupli-apagar-cex.serie-docto       = docum-est.serie-docto
                                       tt-dupli-apagar-cex.nro-docto         = docum-est.nro-docto
                                       tt-dupli-apagar-cex.cod-emitente-desp = docum-est-cex.cod-emitente-desp
                                       tt-dupli-apagar-cex.cod-desp          = docum-est-cex.cod-desp                               
                                       tt-dupli-apagar-cex.mo-codigo         = tt-desp-totais-embarques-mult.mo-codigo
                                       tt-dupli-apagar-cex.dt-vencim         = cond-especif-cex.data-pagto[i-ind]
                                       tt-dupli-apagar-cex.tp-despesa        = tt-desp-totais-embarques-mult.tp-despesa
                                       tt-dupli-apagar-cex.vl-a-pagar        = de-val-desp
                                                                             * cond-especif-cex.perc-pagto[i-ind] / 100
                                       tt-dupli-apagar-cex.vl-a-pagar-mo     = de-val-desp-mo
                                                                             * cond-especif-cex.perc-pagto[i-ind] / 100
                                       tt-dupli-apagar-cex.cod-esp           = c-espec-padr.
                            END.
                        END.
                    END.
                END.
                ELSE DO:

                    ASSIGN da-data = TODAY.

                    FOR FIRST historico-embarque FIELDS (cod-itiner)
                        WHERE historico-embarque.cod-estabel = tt-parametros-aux.cod-estabel
                        AND   historico-embarque.embarque    = c-embarque NO-LOCK: END.

                    FOR FIRST itinerario FIELDS (cod-itiner)
                        WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-LOCK: END.

                    IF NOT AVAIL itinerario THEN NEXT.

                    FOR FIRST historico-embarque FIELDS (dt-efetiva)
                        WHERE historico-embarque.cod-estabel   = tt-parametros-aux.cod-estabel
                        AND   historico-embarque.embarque      = c-embarque
                        AND   historico-embarque.cod-itiner    = itinerario.cod-itiner
                        AND   historico-embarque.cod-pto-contr = tt-desp-totais-embarques-mult.cod-pto-contr NO-LOCK: END. 

                    IF AVAIL historico-embarque THEN DO:

                        IF historico-embarque.dt-efetiva = ? THEN
                            ASSIGN da-partida = historico-embarque.dt-ult-previsao.
                        ELSE
                            ASSIGN da-partida = historico-embarque.dt-efetiva.
                    END.
                    ELSE
                        ASSIGN da-partida = docum-est.dt-emissao.
                                            
                    {cdp/cd9020.i7 docum-est.cod-estabel x}
                                            
                    DO i-ind = 1 TO cond-pagto.num-parcelas:
                    
                        IF da-data[i-ind] < TODAY THEN
                            ASSIGN da-data[i-ind] = docum-est.dt-emissao.
        
                        CREATE tt-dupli-apagar-cex.
                        ASSIGN tt-dupli-apagar-cex.cod-emitente      = docum-est-cex.cod-emitente
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
                               tt-dupli-apagar-cex.cod-esp           = c-espec-padr.
                    END.
                END.
            END. /* FOR EACH item-doc-est-cex */
            
            /** Ajuste das diferen‡as do total das duplicatas de despesas com o valor da despesa **/
            ASSIGN de-dup-tot    = 0
                   de-dup-tot-mo = 0.    

            FOR EACH tt-dupli-apagar-cex
               WHERE tt-dupli-apagar-cex.serie-docto       = docum-est.serie-docto
                 AND tt-dupli-apagar-cex.nro-docto         = docum-est.nro-docto
                 AND tt-dupli-apagar-cex.cod-emitente      = docum-est-cex.cod-emitente
                 AND tt-dupli-apagar-cex.nat-operacao      = docum-est.nat-operacao
                 AND tt-dupli-apagar-cex.cod-desp          = docum-est-cex.cod-desp
                 AND tt-dupli-apagar-cex.cod-emitente-desp = docum-est-cex.cod-emitente-desp
                USE-INDEX codigo:

                ASSIGN de-dup-tot    = de-dup-tot    + tt-dupli-apagar-cex.vl-a-pagar 
                       de-dup-tot-mo = de-dup-tot-mo + tt-dupli-apagar-cex.vl-a-pagar-mo.
            END.
        
            IF docum-est-cex.val-desp <> de-dup-tot THEN DO:

                FIND LAST tt-dupli-apagar-cex
                    WHERE tt-dupli-apagar-cex.serie-docto       = docum-est.serie-docto
                      AND tt-dupli-apagar-cex.nro-docto         = docum-est.nro-docto
                      AND tt-dupli-apagar-cex.cod-emitente      = docum-est-cex.cod-emitente
                      AND tt-dupli-apagar-cex.nat-operacao      = docum-est.nat-operacao
                      AND tt-dupli-apagar-cex.cod-desp          = docum-est-cex.cod-desp
                      AND tt-dupli-apagar-cex.cod-emitente-desp = docum-est-cex.cod-emitente-desp NO-ERROR.

                IF AVAIL tt-dupli-apagar-cex THEN
                    ASSIGN tt-dupli-apagar-cex.vl-a-pagar = tt-dupli-apagar-cex.vl-a-pagar + ( docum-est-cex.val-desp - de-dup-tot ).
            END.
            
            IF tt-desp-totais-embarques-mult.val-desp-mo <> de-dup-tot-mo THEN DO:
                
                FIND LAST tt-dupli-apagar-cex
                    WHERE tt-dupli-apagar-cex.serie-docto       = docum-est.serie-docto
                      AND tt-dupli-apagar-cex.nro-docto         = docum-est.nro-docto
                      AND tt-dupli-apagar-cex.cod-emitente      = docum-est-cex.cod-emitente
                      AND tt-dupli-apagar-cex.nat-operacao      = docum-est.nat-operacao
                      AND tt-dupli-apagar-cex.cod-desp          = docum-est-cex.cod-desp
                      AND tt-dupli-apagar-cex.cod-emitente-desp = docum-est-cex.cod-emitente-desp NO-ERROR.

                IF AVAIL tt-dupli-apagar-cex THEN
                    ASSIGN tt-dupli-apagar-cex.vl-a-pagar-mo = tt-dupli-apagar-cex.vl-a-pagar-mo + ( tt-desp-totais-embarques-mult.val-desp-mo - de-dup-tot-mo ).
            END.
        END. /* FOR EACH docum-est-cex */
        
        /* Correcao dos valores criados para a duplicata de despesas */
        /* Organiza conforme fornecedor e data de vencimento */
        FOR EACH tt-dupli-apagar-cex NO-LOCK 
            BREAK BY tt-dupli-apagar-cex.cod-emitente-desp
                  BY tt-dupli-apagar-cex.cod-esp
                  BY tt-dupli-apagar-cex.dt-vencim
                  BY tt-dupli-apagar-cex.tp-despesa
                  BY tt-dupli-apagar-cex.mo-codigo:
            
            IF tt-dupli-apagar-cex.cod-emitente-desp <> i-cod-emitente-desp-ant 
            OR i-cod-emitente-desp-ant = 0 THEN DO:
                
                ASSIGN i-parcela               = 0
                       i-cod-emitente-desp-ant = tt-dupli-apagar-cex.cod-emitente-desp. 
                
                FOR EACH embarq-import-docto 
                   WHERE embarq-import-docto.cod-embarq = TRIM(c-embarque)
                     AND embarq-import-docto.cod-estab  = TRIM(c-cod-estabel) NO-LOCK:

                    FOR EACH dupli-apagar FIELDS(parcela) NO-LOCK
                       WHERE dupli-apagar.nro-docto    = embarq-import-docto.cod-docto 
                         AND dupli-apagar.serie-docto  = embarq-import-docto.cod-ser-docto
                         AND dupli-apagar.cod-emitente = embarq-import-docto.cdn-emitente 
                         AND dupli-apagar.nat-operacao = embarq-import-docto.cod-natur-operac:
                        
                        IF INT(dupli-apagar.parcela) > i-parcela THEN
                            ASSIGN i-parcela = INT(dupli-apagar.parcela).
                    END. 
                
                    FOR EACH dupli-apagar-cex FIELDS(parcela) NO-LOCK
                       WHERE dupli-apagar-cex.nro-docto    = embarq-import-docto.cod-docto 
                         AND dupli-apagar-cex.serie-docto  = embarq-import-docto.cod-ser-docto
                         AND dupli-apagar-cex.cod-emitente = embarq-import-docto.cdn-emitente 
                         AND dupli-apagar-cex.nat-operacao = embarq-import-docto.cod-natur-operac:

                         IF INT(dupli-apagar-cex.parcela) > i-parcela THEN
                             ASSIGN i-parcela = INT(dupli-apagar-cex.parcela).
                    END.
                    
                    FOR EACH rat-docum FIELDS(serie-docto nro-docto cod-emitente nat-operacao)
                       WHERE rat-docum.nf-serie    = embarq-import-docto.cod-ser-docto
                         AND rat-docum.nf-nro      = embarq-import-docto.cod-docto
                         AND rat-docum.nf-emitente = embarq-import-docto.cdn-emitente
                         AND rat-docum.nf-nat-oper = embarq-import-docto.cod-natur-operac NO-LOCK USE-INDEX nf-docto:

                        FOR EACH dupli-apagar FIELDS(parcela) NO-LOCK
                            WHERE dupli-apagar.nro-docto    = rat-docum.nro-docto 
                              AND dupli-apagar.serie-docto  = rat-docum.serie-docto
                              AND dupli-apagar.cod-emitente = rat-docum.cod-emitente 
                              AND dupli-apagar.nat-operacao = rat-docum.nat-operacao:

                             IF INT(dupli-apagar.parcela) > i-parcela THEN
                                 ASSIGN i-parcela = INT(dupli-apagar.parcela).
                        END.      
                    
                        FOR EACH dupli-apagar-cex  FIELDS(parcela) NO-LOCK
                           WHERE dupli-apagar-cex.nro-docto    = rat-docum.nro-docto 
                             AND dupli-apagar-cex.serie-docto  = rat-docum.serie-docto
                             AND dupli-apagar-cex.cod-emitente = rat-docum.cod-emitente 
                             AND dupli-apagar-cex.nat-operacao = rat-docum.nat-operacao:

                             IF INT(dupli-apagar-cex.parcela) > i-parcela THEN
                                 ASSIGN i-parcela = INT(dupli-apagar-cex.parcela).         
                        END.
                    END.
                END. /* FOR EACH embarq-import-docto */
            END.
        
            IF FIRST-OF(tt-dupli-apagar-cex.cod-emitente-desp)
            OR FIRST-OF(tt-dupli-apagar-cex.cod-esp) 
            OR FIRST-OF(tt-dupli-apagar-cex.dt-vencim)
            OR FIRST-OF(tt-dupli-apagar-cex.tp-despesa)
            OR FIRST-OF(tt-dupli-apagar-cex.mo-codigo) THEN 
                ASSIGN de-total-dup    = 0
                       de-total-dup-mo = 0
                       i-parcela       = i-parcela + 1.
			
			IF i-parcela > 99 THEN
				RUN pi-avisa-parcela99.
        
            ASSIGN de-total-dup    = de-total-dup    + tt-dupli-apagar-cex.vl-a-pagar
                   de-total-dup-mo = de-total-dup-mo + tt-dupli-apagar-cex.vl-a-pagar-mo. 
                   
            IF LAST-OF(tt-dupli-apagar-cex.cod-emitente-desp)
            OR LAST-OF(tt-dupli-apagar-cex.cod-esp) 
            OR LAST-OF(tt-dupli-apagar-cex.dt-vencim)
            OR LAST-OF(tt-dupli-apagar-cex.tp-despesa)
            OR LAST-OF(tt-dupli-apagar-cex.mo-codigo) THEN DO:

                FIND FIRST dupli-apagar-cex 
                     WHERE dupli-apagar-cex.serie-docto       = tt-dupli-apagar-cex.serie-docto 
                       AND dupli-apagar-cex.nro-docto         = tt-dupli-apagar-cex.nro-docto 
                       AND dupli-apagar-cex.cod-emitente      = tt-dupli-apagar-cex.cod-emitente
                       AND dupli-apagar-cex.nat-operacao      = tt-dupli-apagar-cex.nat-operacao
                       AND dupli-apagar-cex.cod-emitente-desp = tt-dupli-apagar-cex.cod-emitente-desp
                       AND dupli-apagar-cex.cod-esp           = tt-dupli-apagar-cex.cod-esp
                       AND dupli-apagar-cex.tp-despesa        = tt-dupli-apagar-cex.tp-despesa
                       AND dupli-apagar-cex.parcela           = (IF i-parcela <= 99 THEN STRING(INT(i-parcela),"99":U)
																	ELSE STRING(INT(i-parcela))) EXCLUSIVE-LOCK NO-ERROR.

                IF NOT AVAIL dupli-apagar-cex THEN DO:
        
                    CREATE dupli-apagar-cex.
                    ASSIGN dupli-apagar-cex.cod-emitente      = tt-dupli-apagar-cex.cod-emitente
                           dupli-apagar-cex.dt-vencim         = tt-dupli-apagar-cex.dt-vencim
                           dupli-apagar-cex.nat-operacao      = tt-dupli-apagar-cex.nat-operacao
                           dupli-apagar-cex.nro-docto         = tt-dupli-apagar-cex.nro-docto
                           dupli-apagar-cex.cod-emitente-desp = tt-dupli-apagar-cex.cod-emitente-desp                   
                           dupli-apagar-cex.parcela           = (IF i-parcela <= 99 THEN STRING(INT(i-parcela),"99":U)
																		ELSE STRING(INT(i-parcela)))
                           dupli-apagar-cex.serie-docto       = tt-dupli-apagar-cex.serie-docto
                           dupli-apagar-cex.nr-duplic         = tt-dupli-apagar-cex.nro-docto
                           dupli-apagar-cex.tp-despesa        = tt-dupli-apagar-cex.tp-despesa
                           dupli-apagar-cex.cod-esp           = tt-dupli-apagar-cex.cod-esp
                           dupli-apagar-cex.mo-codigo         = tt-dupli-apagar-cex.mo-codigo
                           dupli-apagar-cex.dt-emissao        = tt-docum-est.dt-emissao
                           dupli-apagar-cex.dt-trans          = tt-docum-est.dt-trans.
                END.

                ASSIGN dupli-apagar-cex.vl-a-pagar-mo = dupli-apagar-cex.vl-a-pagar-mo + de-total-dup-mo
                       dupli-apagar-cex.vl-a-pagar    = dupli-apagar-cex.vl-a-pagar    + de-total-dup.
            END.
        END. /* FOR EACH tt-dupli-apagar-cex */
    END. /* AVAIL docum-est */
    
    FOR EACH tt-epc WHERE tt-epc.cod-event = "Retencao-Imposto-NFC":U:
        DELETE tt-epc.
    END.
    
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "Retencao-Imposto-NFC":U
           tt-epc.cod-parameter = "r-docum-est":U
           tt-epc.val-parameter = STRING(ROWID(docum-est)).
    
    {include/i-epc201.i "Retencao-Imposto-NFC"} /* Chamada EPC */
    
    RETURN "OK":U.
END PROCEDURE.


procedure generateNumeroDocumento:
/*------------------------------------------------------------------------------
  Purpose:     Valida/Gera proximo numero do documento
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT        PARAMETER c-cod-estabel         LIKE estabelec.cod-estabel  NO-UNDO.
    DEFINE INPUT        PARAMETER c-serie-docto         LIKE docum-est.serie-docto  NO-UNDO.
    DEFINE INPUT        PARAMETER i-cod-emitente        LIKE docum-est.cod-emitente NO-UNDO.
    DEFINE INPUT        PARAMETER c-nat-operacao        LIKE docum-est.nat-operacao NO-UNDO.
    DEFINE INPUT        PARAMETER i-pais-impto-usuario  AS   INTEGER                NO-UNDO.
    DEFINE INPUT        PARAMETER l-imp-nota            LIKE natur-oper.imp-nota    NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER c-nro-docto           LIKE docum-est.nro-docto    NO-UNDO.
    
    IF NOT AVAIL param-global THEN
        FIND FIRST param-global NO-LOCK NO-ERROR.
    
    IF NOT param-global.modulo-ft 
    OR NOT l-imp-nota THEN DO:

        IF CAN-FIND(FIRST docum-est             
                    WHERE docum-est.serie-docto  = c-serie-docto 
                      AND docum-est.nro-docto    = c-nro-docto
                      AND docum-est.cod-emitente = i-cod-emitente
                      AND docum-est.nat-operacao = c-nat-operacao) THEN DO:

            ASSIGN i-seq-erro = i-seq-erro + 1.

            CREATE tt-bo-erro.
            ASSIGN tt-bo-erro.parametros = string(c-nro-docto).

            RUN utp/ut-msgs.p (INPUT "msg":U, INPUT 1878, INPUT STRING(c-nro-docto)).

            ASSIGN tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 1878
                   tt-bo-erro.mensagem = RETURN-VALUE.

            RETURN "NOK":U.
        END.

        RETURN "OK":U.
    END.    
    
    FOR FIRST serie FIELDS(forma-emis)
        WHERE serie.serie = c-serie-docto NO-LOCK:
    END.
    
    /* Emissao = 1/yes - Automatica 2/no - Manual */ 
    IF serie.forma-emis = 2  THEN
        RETURN "OK":U.
        
    FOR FIRST ser-estab FIELDS(nr-ult-nota)
        WHERE ser-estab.serie       = c-serie-docto
          AND ser-estab.cod-estabel = c-cod-estabel NO-LOCK:
    END.
    
    IF NOT AVAIL ser-estab THEN DO:

        ASSIGN i-seq-erro = i-seq-erro + 1.

        CREATE tt-bo-erro.

        RUN utp/ut-msgs.p (INPUT "msg":U, INPUT 6514, INPUT "").

        ASSIGN tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 6514
               tt-bo-erro.mensagem = RETURN-VALUE.

        RETURN "NOK":U.
    END.
    
    IF c-nro-docto = "" THEN DO:

        IF i-pais-impto-usuario = 1 THEN
            ASSIGN c-nro-docto = STRING(INT(ser-estab.nr-ult-nota) + 1,"9999999":U).
        ELSE
            ASSIGN c-nro-docto = STRING(INT(ser-estab.nr-ult-nota) + 1).
        
        IF CAN-FIND(FIRST docum-est
                    WHERE docum-est.serie-docto  = c-serie-docto
                      AND docum-est.nro-docto    = c-nro-docto
                      AND docum-est.cod-emitente = i-cod-emitente
                      AND docum-est.nat-operacao = c-nat-operacao) THEN DO:

            ASSIGN i-seq-erro = i-seq-erro + 1.

            CREATE tt-bo-erro.
            ASSIGN tt-bo-erro.parametros = STRING(c-nro-docto).

            RUN utp/ut-msgs.p (INPUT "msg":U, INPUT 5569,INPUT tt-bo-erro.parametros).

            ASSIGN tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 5569
                   tt-bo-erro.mensagem = RETURN-VALUE.

            RETURN "NOK":U.
        END.
    
        ASSIGN i-seq-erro = i-seq-erro + 1.
        CREATE tt-bo-erro.

        ASSIGN tt-bo-erro.parametros = STRING(c-nro-docto).

        RUN utp/ut-msgs.p (INPUT "msg":U, INPUT 52512, INPUT tt-bo-erro.parametros).

        ASSIGN tt-bo-erro.i-sequen     = 1
               tt-bo-erro.cd-erro      = 52512
               tt-bo-erro.mensagem     = RETURN-VALUE
               tt-bo-erro.errorsubtype = "information":U.
    END.
    
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE createDespesasImp:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    FOR EACH tt-docum-est-cex:

        FIND FIRST docum-est-cex OF tt-docum-est-cex
             WHERE docum-est-cex.cod-cond-pag = tt-docum-est-cex.cod-cond-pag EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAIL docum-est-cex THEN DO:

            CREATE docum-est-cex.
            BUFFER-COPY tt-docum-est-cex EXCEPT val-desp r-rowid TO docum-est-cex.    
        END.

        ASSIGN docum-est-cex.val-desp = docum-est-cex.val-desp + tt-docum-est-cex.val-desp.
    END.
    
    FOR EACH tt-item-doc-est-cex:

        CREATE item-doc-est-cex.
        BUFFER-COPY tt-item-doc-est-cex EXCEPT r-rowid TO item-doc-est-cex.
    END.
    
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE updateDocumento:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST tt-docum-est NO-ERROR.

    FOR EACH tt-docum-est-orig-aux:

        FIND FIRST docum-est 
             WHERE docum-est.serie-docto  = tt-docum-est-orig-aux.serie-docto 
               AND docum-est.nro-docto    = tt-docum-est-orig-aux.nro-docto
               AND docum-est.cod-emitente = tt-docum-est-orig-aux.cod-emitente
               AND docum-est.nat-operacao = tt-docum-est-orig-aux.nat-operacao EXCLUSIVE-LOCK NO-ERROR.

        ASSIGN docum-est.ind-rateio = YES.

        /*M¢dulo de importa‡Æo*/
        {cdp/cd4300.i4 "yes" tt-docum-est-orig-aux.char-1}
        {rep/re1001a.i51 "yes"}
        
        FOR FIRST embarque-imp FIELDS (declaracao-import data-di)
            WHERE embarque-imp.cod-estabel = tt-docum-est-orig-aux.cod-estabel
            AND   embarque-imp.embarque    = TRIM(c-embarque) NO-LOCK:

            FIND FIRST bf-docum-est 
                 WHERE bf-docum-est.serie-docto  = tt-docum-est.serie-docto 
                   AND bf-docum-est.nro-docto    = tt-docum-est.nro-docto
                   AND bf-docum-est.cod-emitente = tt-docum-est.cod-emitente
                   AND bf-docum-est.nat-operacao = tt-docum-est.nat-operacao    EXCLUSIVE-LOCK NO-ERROR.

            IF AVAIL bf-docum-est THEN
                ASSIGN bf-docum-est.declaracao-import  = embarque-imp.declaracao-import.
        END.
        
        /** A NF complementar podera ter mais de um embarque e podera ter
            mais de uma nf original. Devera existir um reg rat-docum para cada nf original **/
        CREATE rat-docum.
        ASSIGN rat-docum.cod-emitente = tt-docum-est.cod-emitente
               rat-docum.nat-operacao = tt-docum-est.nat-operacao 
               rat-docum.nro-docto    = tt-docum-est.nro-docto 
               rat-docum.serie-docto  = tt-docum-est.serie-docto        
               rat-docum.nf-emitente  = tt-docum-est-orig-aux.cod-emitente
               rat-docum.nf-nat-oper  = tt-docum-est-orig-aux.nat-operacao 
               rat-docum.nf-nro       = tt-docum-est-orig-aux.nro-docto
               rat-docum.nf-serie     = tt-docum-est-orig-aux.serie-docto.
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE updateItemDocumento:
/*------------------------------------------------------------------------------
  Purpose:     Atualiza‡Æo informa‡äes do item ap¢s cria‡Æo dos mesmos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUFFER b-item-doc-est FOR item-doc-est.
    
    FIND FIRST tt-docum-est-orig NO-ERROR.

    IF NOT VALID-HANDLE(h-cdapi995) THEN 
        RUN cdp/cdapi995.p PERSISTENT SET h-cdapi995.

    FOR EACH tt-item-doc-est:

        FIND FIRST item-doc-est
             WHERE item-doc-est.serie-docto  = tt-item-doc-est.serie-docto
               AND item-doc-est.nro-docto    = tt-item-doc-est.nro-docto
               AND item-doc-est.cod-emitente = tt-item-doc-est.cod-emitente 
               AND item-doc-est.nat-operacao = tt-item-doc-est.nat-operacao 
               AND item-doc-est.sequencia    = tt-item-doc-est.sequencia EXCLUSIVE-LOCK NO-ERROR.
         
        ASSIGN item-doc-est.preco-unit[1] = item-doc-est.preco-total[1]
               item-doc-est.emite-comp    = tt-docum-est-orig.cod-emitente
               item-doc-est.lote          = tt-item-doc-est.lote
               item-doc-est.cod-localiz   = tt-item-doc-est.cod-localiz 
               item-doc-est.cod-depos     = tt-item-doc-est.cod-depos
               item-doc-est.dt-vali-lote  = tt-item-doc-est.dt-vali-lote.

        /** Na geracao da nf complementar com multiplos embarques vao existir varios 
            documentos originais. Desta forma sera preciso encontrar a nf original de 
            cada item da nf complementar **/
        
        FIND FIRST tt-item-doc-est-cex
            WHERE  tt-item-doc-est-cex.serie-docto  = item-doc-est.serie-docto      
            AND    tt-item-doc-est-cex.nro-docto    = item-doc-est.nro-docto
            AND    tt-item-doc-est-cex.cod-emitente = item-doc-est.cod-emitente     
            AND    tt-item-doc-est-cex.nat-operacao = item-doc-est.nat-operacao     
            AND    tt-item-doc-est-cex.sequencia    = item-doc-est.sequencia NO-LOCK NO-ERROR.

        /* Nota fiscal original do embarque */
        FIND FIRST tt-docum-est-2
             WHERE tt-docum-est-2.embarque = tt-item-doc-est-cex.embarque NO-LOCK NO-ERROR.
        
        IF AVAIL tt-docum-est-2 THEN
            ASSIGN item-doc-est.emite-comp = tt-docum-est-2.cod-emitente. 
        
        FIND FIRST b-item-doc-est
             WHERE b-item-doc-est.serie-docto  = item-doc-est.serie-comp
             AND   b-item-doc-est.nro-docto    = item-doc-est.nro-comp
             AND   b-item-doc-est.cod-emitente = item-doc-est.emite-comp
             AND   b-item-doc-est.nat-operacao = item-doc-est.nat-comp 
             AND   b-item-doc-est.sequencia    = item-doc-est.seq-comp EXCLUSIVE-LOCK NO-ERROR.
                   
        IF AVAIL b-item-doc-est            AND 
           b-item-doc-est.num-ord-inv <> 0 THEN
            ASSIGN item-doc-est.num-ord-inv    = b-item-doc-est.num-ord-inv.
        
        /* Grava as al¡quotas com 4 decimais */
        RUN grava-aliquotas IN h-cdapi995 (INPUT "item-doc-est",
                                           INPUT item-doc-est.serie-docto + "/" + 
                                                 item-doc-est.nro-docto + "/" + 
                                                 string(item-doc-est.cod-emitente) + "/" + 
                                                 item-doc-est.nat-operacao + "/" + 
                                                 string(item-doc-est.sequencia), 
                                           INPUT tt-parametros.aliquota-pis, 
                                           INPUT tt-parametros.aliquota-cofins).
        
    END.

    /** Unidade de Negocio **/
    FIND FIRST tt-item-rateio NO-LOCK NO-ERROR.

    IF AVAIL tt-item-rateio THEN
        RUN rep/re1904a.p (INPUT TABLE tt-item-rateio).

    IF VALID-HANDLE(h-cdapi995) THEN DO:
       DELETE PROCEDURE h-cdapi995.
       ASSIGN h-cdapi995 = ?.
    END.            
    
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE updateDespesas:
/*------------------------------------------------------------------------------
  Purpose:     Passa para Recebidas todas as despesas consideradas na nota fiscal complementar
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    FOR EACH tt-selecao-despesa,
        EACH desp-embarque OF tt-selecao-despesa EXCLUSIVE-LOCK:

        ASSIGN desp-embarque.log-despes-ja-recbda = YES.
    end.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE generateDocumento:
/*------------------------------------------------------------------------------
  Purpose:     Gera‡Æo do Documento
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    CREATE tt-versao-integr.
    ASSIGN tt-versao-integr.cod-versao-integracao = 004.
        
    IF NOT VALID-HANDLE(h-reapi190b) THEN
        RUN rep/reapi190b.p PERSISTENT SET h-reapi190b.

    FOR EACH tt-docum-est.
        CREATE tt-docum-est-nova.
        BUFFER-COPY tt-docum-est TO tt-docum-est-nova.
    END.
    
    FOR EACH tt-item-doc-est.
        CREATE tt-item-doc-est-nova.
        BUFFER-COPY tt-item-doc-est TO tt-item-doc-est-nova.
    END.

    RUN settt-docum-est-like   IN h-reapi190b (INPUT TABLE tt-docum-est-aux).
    RUN setTT-item-doc-est-aux IN h-reapi190b (INPUT TABLE tt-item-doc-est-aux).
    
    RUN execute IN h-reapi190b (INPUT  TABLE tt-versao-integr,
                                INPUT  TABLE tt-docum-est-nova,
                                INPUT  TABLE tt-item-doc-est-nova,
                                INPUT  TABLE tt-dupli-apagar,
                                INPUT  TABLE tt-dupli-imp,
                                INPUT  TABLE tt-unid-neg-nota,
                                OUTPUT TABLE tt-erro).

    IF VALID-HANDLE(h-reapi190b) THEN DO:
        DELETE PROCEDURE h-reapi190b.
        ASSIGN h-reapi190b = ?.
    END.

    /*  *** ICMS incide total da Nota Fiscal***   */
    /*  *** Considera ICMS como despesa na Nota Fiscal de Entrada no Recebimento*** */
    IF NOT CAN-FIND(FIRST tt-erro) THEN DO:
        
        RUN piInicializaHandle.

        IF NOT VALID-HANDLE(h-acomp) THEN
            RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

        FOR EACH tt-docum-est:
            
            FIND FIRST natur-oper WHERE natur-oper.nat-operacao = tt-docum-est.nat-operacao NO-LOCK NO-ERROR.
            FIND FIRST docum-est EXCLUSIVE-LOCK OF tt-docum-est NO-ERROR.
    
            IF AVAIL docum-est THEN DO:
                
                RUN pi-config-tributos-embarque. /* Configurador de Tributos - im9070.i2 */
                
                IF AVAIL natur-oper
                     AND (natur-oper.log-incid-icms-tot-nfr OR natur-oper.log-icms-despes-import-nfr) THEN DO:
                    
                    IF natur-oper.log-incid-icms-tot-nfr THEN
                        ASSIGN docum-est.tot-valor = docum-est.tot-valor + docum-est.icm-deb-cre.
                    
                    IF natur-oper.log-icms-despes-import-nfr THEN
                        ASSIGN docum-est.valor-outras = docum-est.valor-outras + docum-est.icm-deb-cre
                               docum-est.despesa-nota = docum-est.despesa-nota + docum-est.icm-deb-cre.
                END.
                
                IF NOT VALID-HANDLE(h-reapi428) THEN 
                    RUN rep/reapi428.p PERSISTENT SET h-reapi428.
                        
                RUN retornaMensagemNatur IN h-reapi428 (INPUT ROWID(docum-est),
                                                        OUTPUT docum-est.obs-infcpl,
                                                        OUTPUT docum-est.obs-infadfisco).
            
            END.
            
            IF AVAIL natur-oper AND natur-oper.log-icms-despes-import-nfr THEN DO:

                FOR EACH item-doc-est FIELDS(despesas valor-icm) EXCLUSIVE-LOCK
                   WHERE item-doc-est.serie-docto  = tt-docum-est.serie-docto
                     AND item-doc-est.nro-docto    = tt-docum-est.nro-docto
                     AND item-doc-est.cod-emitente = tt-docum-est.cod-emitente
                     AND item-doc-est.nat-operacao = tt-docum-est.nat-operacao:
                    
                    ASSIGN item-doc-est.despesas[1] = item-doc-est.despesas[1] + item-doc-est.valor-icm[1].
                END.
            END.
        END.

        RUN piFinalizaHandle.

        IF  VALID-HANDLE(h-reapi428) THEN DO:
            DELETE PROCEDURE h-reapi428 NO-ERROR.
            ASSIGN h-reapi428 = ?.
        END.
        
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-finalizar IN h-acomp.
    END.
    
    FOR EACH tt-erro:
        ASSIGN i-seq-erro = i-seq-erro + 1.

        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = tt-erro.cd-erro
               tt-bo-erro.mensagem = tt-erro.mensagem.
    END.

    IF CAN-FIND(FIRST tt-erro) THEN
        RETURN "NOK":U.
        
    RUN updateDocumento.

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RUN updateItemDocumento.

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    
    RUN updateDespesas.

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RUN createDespesasImp.

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    IF l-nt2024002 THEN DO:
        RUN createItemDocEstTribut.
        
        FOR EACH tt-docum-est:        
            RUN createDocumEstTribut.
        END.
    END.
    
    RUN atualizaNFe-layout200 (INPUT TABLE tt-docum-est).
    
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE generateTT-unid-neg-nota:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    FOR EACH unid-neg-nota FIELDS ( serie-docto  nro-docto      cod-emitente   
                                    nat-operacao cod_unid_negoc perc-unid-neg
                                    sequencia )
       WHERE unid-neg-nota.serie-docto  = item-doc-est.serie-docto
         AND unid-neg-nota.nro-docto    = item-doc-est.nro-docto
         AND unid-neg-nota.cod-emitente = item-doc-est.cod-emitente
         AND unid-neg-nota.nat-operacao = item-doc-est.nat-operacao
         AND unid-neg-nota.sequencia    = item-doc-est.sequencia NO-LOCK
        USE-INDEX nota:
         
        CREATE tt-unid-neg-nota.
        ASSIGN tt-unid-neg-nota.serie-docto     = tt-item-doc-est.serie-docto
               tt-unid-neg-nota.nro-docto       = tt-item-doc-est.nro-docto
               tt-unid-neg-nota.cod-emitente    = tt-item-doc-est.cod-emitente
               tt-unid-neg-nota.nat-operacao    = tt-item-doc-est.nat-operacao
               tt-unid-neg-nota.sequencia       = tt-item-doc-est.sequencia
               tt-unid-neg-nota.cod_unid_negoc  = unid-neg-nota.cod_unid_negoc
               tt-unid-neg-nota.perc-unid-neg   = unid-neg-nota.perc-unid-neg.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE atualizaNFe-layout200:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-docum-est-nfe .

    DEFINE VARIABLE c-versao-layout   AS   CHARACTER                  NO-UNDO.
    DEFINE VARIABLE c-embarque-nfe    LIKE embarque-imp.embarque      NO-UNDO.
    DEFINE VARIABLE c-cod-estabel-nfe LIKE embarque-imp.cod-estabel   NO-UNDO.
    DEFINE VARIABLE i-sequencia-nfe   LIKE item-doc-est-cex.sequencia NO-UNDO.

     FIND FIRST tt-docum-est-nfe NO-ERROR.

     FIND FIRST estabelec
          WHERE estabelec.cod-estabel = tt-docum-est-nfe.cod-estabel NO-LOCK NO-ERROR.

     IF AVAIL estabelec THEN
         ASSIGN c-versao-layout = estabelec.des-vers-layout.
    
    IF c-versao-layout >= "2.00":U THEN DO:

        FIND FIRST rat-docum
             WHERE rat-docum.serie-docto  = tt-docum-est-nfe.serie-docto
               AND rat-docum.nro-docto    = tt-docum-est-nfe.nro-docto
               AND rat-docum.cod-emitente = tt-docum-est-nfe.cod-emitente
               AND rat-docum.nat-oper     = tt-docum-est-nfe.nat-operacao NO-LOCK NO-ERROR.
        
        IF AVAIL rat-docum THEN DO:
            FIND FIRST bf-docum-est
                 WHERE bf-docum-est.serie-docto  = rat-docum.nf-serie   
                   AND bf-docum-est.nro-docto    = rat-docum.nf-nro     
                   AND bf-docum-est.cod-emitente = rat-docum.nf-emitente
                   AND bf-docum-est.nat-operacao = rat-docum.nf-nat-oper NO-LOCK NO-ERROR.
            
            IF AVAIL bf-docum-est THEN DO:
                FIND FIRST bf-docto-estoq-nfe-imp
                     WHERE bf-docto-estoq-nfe-imp.cod-ser-docto    = bf-docum-est.serie-docto 
                       AND bf-docto-estoq-nfe-imp.cod-docto        = bf-docum-est.nro-docto   
                       AND bf-docto-estoq-nfe-imp.cdn-emitente     = bf-docum-est.cod-emitente
                       AND bf-docto-estoq-nfe-imp.cod-natur-operac = bf-docum-est.nat-operacao NO-LOCK NO-ERROR.

                CREATE docto-estoq-nfe-imp.
                BUFFER-COPY bf-docto-estoq-nfe-imp EXCEPT cod-ser-docto cod-docto cdn-emitente cod-natur-operac TO docto-estoq-nfe-imp.
                ASSIGN docto-estoq-nfe-imp.cod-ser-docto    = tt-docum-est-nfe.serie-docto 
                       docto-estoq-nfe-imp.cod-docto        = tt-docum-est-nfe.nro-docto   
                       docto-estoq-nfe-imp.cdn-emitente     = tt-docum-est-nfe.cod-emitente
                       docto-estoq-nfe-imp.cod-natur-operac = tt-docum-est-nfe.nat-operacao.

                FOR EACH bf-item-docto-estoq-nfe-imp NO-LOCK
                    WHERE bf-item-docto-estoq-nfe-imp.cod-ser-docto    = bf-docto-estoq-nfe-imp.cod-ser-docto   
                      AND bf-item-docto-estoq-nfe-imp.cod-docto        = bf-docto-estoq-nfe-imp.cod-docto       
                      AND bf-item-docto-estoq-nfe-imp.cdn-emitente     = bf-docto-estoq-nfe-imp.cdn-emitente    
                      AND bf-item-docto-estoq-nfe-imp.cod-natur-operac = bf-docto-estoq-nfe-imp.cod-natur-operac
                       BY num-seq:
                                                            
                    FIND FIRST tt-item-doc-est
                         WHERE tt-item-doc-est.serie-docto   = tt-docum-est-nfe.serie-docto 
                           AND tt-item-doc-est.nro-docto     = tt-docum-est-nfe.nro-docto   
                           AND tt-item-doc-est.cod-emitente  = tt-docum-est-nfe.cod-emitente
                           AND tt-item-doc-est.nat-operacao  = tt-docum-est-nfe.nat-operacao
                           AND tt-item-doc-est.sequencia     > i-sequencia-nfe NO-LOCK NO-ERROR.

                    IF AVAIL tt-item-doc-est THEN 
                        ASSIGN i-sequencia-nfe = tt-item-doc-est.sequencia.
                    
                    IF NOT CAN-FIND(FIRST item-docto-estoq-nfe-imp
                                    WHERE item-docto-estoq-nfe-imp.cod-ser-docto    = tt-docum-est-nfe.serie-docto
                                      AND item-docto-estoq-nfe-imp.cod-docto        = tt-docum-est-nfe.nro-docto
                                      AND item-docto-estoq-nfe-imp.cdn-emitente     = tt-docum-est-nfe.cod-emitente
                                      AND item-docto-estoq-nfe-imp.cod-natur-operac = tt-docum-est-nfe.nat-operacao
                                      AND item-docto-estoq-nfe-imp.num-seq          = i-sequencia-nfe) THEN DO:
                    
                        CREATE item-docto-estoq-nfe-imp.
                        BUFFER-COPY bf-item-docto-estoq-nfe-imp EXCEPT cod-ser-docto cod-docto cdn-emitente cod-natur-operac num-seq TO item-docto-estoq-nfe-imp.
                        ASSIGN item-docto-estoq-nfe-imp.cod-ser-docto     = tt-docum-est-nfe.serie-docto 
                               item-docto-estoq-nfe-imp.cod-docto         = tt-docum-est-nfe.nro-docto   
                               item-docto-estoq-nfe-imp.cdn-emitente      = tt-docum-est-nfe.cod-emitente
                               item-docto-estoq-nfe-imp.cod-natur-operac  = tt-docum-est-nfe.nat-operacao
                               item-docto-estoq-nfe-imp.num-seq           = if i-sequencia-nfe <> 0 then i-sequencia-nfe else bf-item-docto-estoq-nfe-imp.num-seq
                               item-docto-estoq-nfe-imp.val-base          = 0
                               item-docto-estoq-nfe-imp.val-desc          = 0
                               item-docto-estoq-nfe-imp.val-iof           = 0
                               item-docto-estoq-nfe-imp.val-despesa       = 0
                               item-docto-estoq-nfe-imp.val-impto-import  = 0.
                    END.
                END.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-calculate-piscofins:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER d-val-unit-pis      AS DECIMAL NO-UNDO.
    DEFINE INPUT  PARAMETER val-reduc-pis       AS DECIMAL NO-UNDO.
    DEFINE INPUT  PARAMETER d-val-unit-cofins   AS DECIMAL NO-UNDO.
    DEFINE INPUT  PARAMETER val-reduc-cofins    AS DECIMAL NO-UNDO.    
    DEFINE INPUT  PARAMETER val-despesa         AS DECIMAL NO-UNDO.
    DEFINE INPUT  PARAMETER val-desconto        AS DECIMAL NO-UNDO.
    DEFINE INPUT  PARAMETER quantidade          AS DECIMAL NO-UNDO.
    DEFINE OUTPUT PARAMETER val-base-pis        AS DECIMAL NO-UNDO.
    DEFINE OUTPUT PARAMETER valor-pis           AS DECIMAL NO-UNDO.
    DEFINE OUTPUT PARAMETER val-base-cofins     AS DECIMAL NO-UNDO.
    DEFINE OUTPUT PARAMETER valor-cofins        AS DECIMAL NO-UNDO.

    DEFINE BUFFER bfNatureza FOR natur-oper.

    FIND FIRST bfNatureza NO-LOCK
         WHERE bfNatureza.nat-operacao = tt-parametros.nat-operacao NO-ERROR.

    IF NOT VALID-HANDLE (h-cd4338) THEN
        RUN cdp/cd4338.p PERSISTENT SET h-cd4338.

    ASSIGN val-base-pis     = 0
           valor-pis        = 0
           val-base-cofins  = 0
           valor-cofins     = 0.    

    IF tt-item-doc-est.base-pis > 0 THEN DO:    

        RUN pi-calcula-pis IN h-cd4338 (INPUT tt-parametros.i-tributacao-pis,
                                        INPUT tt-parametros.aliquota-pis,
                                        INPUT d-val-unit-pis,
                                        INPUT val-reduc-pis,
                                        INPUT tt-parametros.i-tributacao-ipi,
                                        INPUT tt-parametros.aliquota-ipi,
                                        INPUT tt-item-doc-est.base-pis, /*Valor total*/
                                        INPUT val-despesa,
                                        INPUT val-desconto,
                                        INPUT quantidade,
                                        BUFFER bfNatureza,
                                        OUTPUT val-base-pis,
                                        OUTPUT valor-pis).
    END.     

    IF tt-item-doc-est.base-cofins > 0 THEN DO:

        RUN pi-calcula-cofins IN h-cd4338 (INPUT tt-parametros.i-tributacao-cofins,
                                           INPUT tt-parametros.aliquota-cofins,
                                           INPUT d-val-unit-cofins,
                                           INPUT val-reduc-cofins,
                                           INPUT tt-parametros.i-tributacao-ipi,
                                           INPUT tt-parametros.aliquota-ipi,                                           
                                           INPUT tt-item-doc-est.base-cofins, /*Valor total*/
                                           INPUT val-despesa,     
                                           INPUT val-desconto,
                                           INPUT quantidade,
                                           BUFFER bfNatureza,
                                           OUTPUT val-base-cofins,
                                           OUTPUT valor-cofins).        
    END.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE getTT-bo-erro:
/*------------------------------------------------------------------------------
  Purpose:     Retorna erros
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE getTT-docum-est-im0101a1:
/*------------------------------------------------------------------------------
  Purpose:     Envia tt-docum-est nos casos em que nao e informado o nro-docto em tela
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR tt-docum-est.

    FIND FIRST tt-docum-est NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE setObservacao:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-embarque-aux AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i-cod-desp-aux AS INTEGER   NO-UNDO.
    DEFINE VARIABLE l-primeiro     AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE c-trad-lit-di  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-trad-lit-emb AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-desc-desp    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-return       AS CHARACTER NO-UNDO.

    {utp/ut-liter.i Conforme_DI * L}
    ASSIGN c-trad-lit-di = RETURN-VALUE.
    
    {utp/ut-liter.i Embarque * L}
    ASSIGN c-trad-lit-emb = RETURN-VALUE.
    
    FIND FIRST tt-docum-est EXCLUSIVE-LOCK NO-ERROR.

    IF NOT VALID-HANDLE(h-bocx310) THEN
        RUN cxbo/bocx310.p PERSISTENT SET h-bocx310.

    IF AVAIL tt-docum-est THEN DO:

        FOR EACH tt-docum-est-cex 
           WHERE tt-docum-est-cex.serie        = tt-docum-est.serie-docto
             AND tt-docum-est-cex.nro-docto    = tt-docum-est.nro-docto
             AND tt-docum-est-cex.cod-emitente = tt-docum-est.cod-emitente
             AND tt-docum-est-cex.nat-operacao = tt-docum-est.nat-operacao EXCLUSIVE-LOCK
            BREAK BY tt-docum-est-cex.char-1
                  BY tt-docum-est-cex.cod-desp:

            IF c-embarque-aux <> SUBSTRING(tt-docum-est-cex.char-1,1,20) THEN
                ASSIGN c-embarque-aux = SUBSTRING(tt-docum-est-cex.char-1,1,20)
                       l-primeiro     = YES.
            ELSE
                ASSIGN l-primeiro = NO.

            ASSIGN i-cod-desp-aux = tt-docum-est-cex.cod-desp.

            FOR FIRST embarque-imp FIELDS (declaracao-import data-di embarque)
                WHERE embarque-imp.cod-estabel = tt-parametros.cod-estabel
                  AND embarque-imp.embarque    = SUBSTRING(tt-docum-est-cex.char-1,1,20) NO-LOCK: END.

            IF NOT AVAIL embarque-imp THEN NEXT.

            FIND FIRST desp-imp  
                 WHERE desp-imp.cod-desp = tt-docum-est-cex.cod-desp NO-LOCK NO-ERROR.

            RUN findDespesa IN h-bocx310 (INPUT tt-docum-est.cod-estabel,
                                          INPUT tt-docum-est.embarque,
                                          INPUT tt-docum-est-cex.cod-desp,
                                          OUTPUT c-return).

            IF c-return = "":U THEN
                RUN getCharField IN h-bocx310(INPUT "descricao":U, OUTPUT c-desc-desp).
            ELSE 
                ASSIGN c-desc-desp = desp-imp.descricao.

            /* Imprime Nota Fiscal */
            IF desp-imp.log-1 THEN DO:
    
               IF l-primeiro THEN
                   ASSIGN tt-docum-est.observacao = tt-docum-est.observacao  
                                                    + c-trad-lit-di + ": ":U + embarque-imp.declaracao-import
                                                    + " - ":U                + STRING(embarque-imp.data-di)  
                                                    + " - ":U + c-trad-lit-emb + ": ":U + embarque-imp.embarque  
                                                    + " | ":U
                                                    + STRING(desp-imp.cod-desp) + "-":U
                                                    + c-desc-desp + " / ":U
                                                    + TRIM(STRING(tt-docum-est-cex.val-desp,">>>>>,>>>,>>9.99999":U)).
                                                    
               ELSE
                   ASSIGN tt-docum-est.observacao = tt-docum-est.observacao
                                                    + " | ":U
                                                    + STRING(desp-imp.cod-desp) + "-":U
                                                    + c-desc-desp + " / ":U
                                                    + TRIM(STRING(tt-docum-est-cex.val-desp,">>>>>,>>>,>>9.99999":U)).
            END.
            ELSE
                IF l-primeiro THEN
                    ASSIGN tt-docum-est.observacao = tt-docum-est.observacao  
                                                   + c-trad-lit-di + ": ":U   + embarque-imp.declaracao-import
                                                   + " - ":U                  + STRING(embarque-imp.data-di)  
                                                   + " - ":U + c-trad-lit-emb + ": ":U + embarque-imp.embarque.

            IF NOT CAN-FIND(FIRST tt-docum-est-cex
                            WHERE tt-docum-est-cex.serie                  = tt-docum-est.serie-docto 
                              AND tt-docum-est-cex.nro-docto              = tt-docum-est.nro-docto   
                              AND tt-docum-est-cex.cod-emitente           = tt-docum-est.cod-emitente
                              AND tt-docum-est-cex.nat-operacao           = tt-docum-est.nat-operacao
                              AND SUBSTRING(tt-docum-est-cex.char-1,1,20) = c-embarque-aux
                              AND tt-docum-est-cex.cod-desp               > i-cod-desp-aux) THEN
                ASSIGN tt-docum-est.observacao = tt-docum-est.observacao + CHR(10).



            ASSIGN OVERLAY(tt-docum-est-cex.char-1,1,20) = "".
            
        END.

        IF tt-parametros.observacao <> "" THEN
            ASSIGN tt-docum-est.observacao = tt-docum-est.observacao + " - ":U + tt-parametros.observacao.
    END.

    IF VALID-HANDLE(h-bocx310) THEN DO:
        DELETE PROCEDURE h-bocx310.
        ASSIGN h-bocx310 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE create-tb-wt-it-impostoCBSIBS:
    DEF INPUT PARAM p-sequencia AS INTEGER NO-UNDO.
    
    FIND FIRST tb-wt-it-impostoCBSIBS EXCLUSIVE-LOCK 
         WHERE tb-wt-it-impostoCBSIBS.seq-wt-docto    = 1
           AND tb-wt-it-impostoCBSIBS.seq-wt-it-docto = p-sequencia NO-ERROR.
    IF NOT AVAIL tb-wt-it-impostoCBSIBS THEN DO:
        CREATE tb-wt-it-impostoCBSIBS.
        ASSIGN tb-wt-it-impostoCBSIBS.seq-wt-docto    = 1
               tb-wt-it-impostoCBSIBS.seq-wt-it-docto = p-sequencia.
    END.

    ASSIGN tb-wt-it-impostoCBSIBS.aliquota-ibsuf  = tt-parametros.aliquota-ibsuf
           tb-wt-it-impostoCBSIBS.aliquota-ibsmun = tt-parametros.aliquota-ibsmun
           tb-wt-it-impostoCBSIBS.aliquota-cbs    = tt-parametros.aliquota-cbs
           tb-wt-it-impostoCBSIBS.aliquota-is     = tt-parametros.aliquota-is
           tb-wt-it-impostoCBSIBS.perc-red-ibsuf  = tt-parametros.perc-red-ibsuf
           tb-wt-it-impostoCBSIBS.perc-red-ibsmun = tt-parametros.perc-red-ibsmun
           tb-wt-it-impostoCBSIBS.perc-red-cbs    = tt-parametros.perc-red-cbs.

    RETURN "OK":U.
END PROCEDURE.

/*PROCEDURE pi-config-tributos-embarque: */
    {imp/im9070.i2} 
/* END PROCEDURE. */

PROCEDURE createItemDocEstTribut:

    FOR EACH tt-item-doc-est-tribut:
        FIND FIRST item-doc-est-tribut EXCLUSIVE-LOCK
             WHERE item-doc-est-tribut.cod-serie-docto    = tt-item-doc-est-tribut.cod-serie-docto    
             AND   item-doc-est-tribut.cod-num-docto      = tt-item-doc-est-tribut.cod-num-docto      
             AND   item-doc-est-tribut.cdn-emitente       = tt-item-doc-est-tribut.cdn-emitente   
             AND   item-doc-est-tribut.cod-natur-operac   = tt-item-doc-est-tribut.cod-natur-operac   
             AND   item-doc-est-tribut.num-seq            = tt-item-doc-est-tribut.num-seq      
             AND   item-doc-est-tribut.nom-trib           = tt-item-doc-est-tribut.nom-trib               
             AND   item-doc-est-tribut.cod-campo          = tt-item-doc-est-tribut.cod-campo NO-ERROR.
        IF NOT AVAIL item-doc-est-tribut THEN DO:
           CREATE item-doc-est-tribut.
           ASSIGN item-doc-est-tribut.cod-serie-docto     = tt-item-doc-est-tribut.cod-serie-docto
                  item-doc-est-tribut.cod-num-docto       = tt-item-doc-est-tribut.cod-num-docto
                  item-doc-est-tribut.cdn-emitente        = tt-item-doc-est-tribut.cdn-emitente
                  item-doc-est-tribut.cod-natur-operac    = tt-item-doc-est-tribut.cod-natur-operac
                  item-doc-est-tribut.num-seq             = tt-item-doc-est-tribut.num-seq
                  item-doc-est-tribut.nom-trib            = tt-item-doc-est-tribut.nom-trib
                  item-doc-est-tribut.cod-campo           = tt-item-doc-est-tribut.cod-campo.
        END.
    
        ASSIGN item-doc-est-tribut.cod-conteudo = tt-item-doc-est-tribut.cod-conteudo.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE createDocumEstTribut:
    DEF VAR h-boin01126 AS HANDLE NO-UNDO.

    IF NOT VALID-HANDLE(h-boin01126) THEN
        RUN inbo/boin01126.p PERSISTENT SET h-boin01126.
    
    RUN createTotaisDocumEstTribut IN h-boin01126 (INPUT tt-docum-est.serie-docto,
                                                   INPUT tt-docum-est.nro-docto,
                                                   INPUT tt-docum-est.cod-emitente,
                                                   INPUT tt-docum-est.nat-operacao,
                                                   OUTPUT TABLE tt-docum-est-tribut).
    RUN setConstraintOfDocumEst IN h-boin01126 (INPUT tt-docum-est.serie-docto,
                                                INPUT tt-docum-est.nro-docto,
                                                INPUT tt-docum-est.cod-emitente,
                                                INPUT tt-docum-est.nat-operacao).
    RUN openQueryStatic in h-boin01126 (INPUT "OfDocumEst":U).
    
    FOR EACH tt-docum-est-tribut:
        
        RUN emptyRowObject  IN h-boin01126.
        EMPTY TEMP-TABLE tt-docum-est-tribut-aux.
        CREATE tt-docum-est-tribut-aux.
        BUFFER-COPY tt-docum-est-tribut TO tt-docum-est-tribut-aux.

        RUN goToKey IN h-boin01126 (INPUT tt-docum-est-tribut-aux.cod-serie-docto,
                                    INPUT tt-docum-est-tribut-aux.cod-num-docto,
                                    INPUT tt-docum-est-tribut-aux.cdn-emitente,
                                    INPUT tt-docum-est-tribut-aux.cod-natur-operac,
                                    INPUT tt-docum-est-tribut-aux.nom-trib,
                                    input tt-docum-est-tribut-aux.cod-campo).
                                    
        IF  RETURN-VALUE = "OK":U THEN DO:
            RUN emptyRowErrors IN h-boin01126.
            RUN setRecord IN h-boin01126 (INPUT TABLE tt-docum-est-tribut-aux).
            RUN updateRecord IN h-boin01126.
        END.
        ELSE DO:
            RUN emptyRowErrors IN h-boin01126.
            RUN setRecord IN h-boin01126 (INPUT TABLE tt-docum-est-tribut-aux).
            RUN createRecord IN h-boin01126.
        END.
    END.
    
    IF VALID-HANDLE(h-boin01126) THEN DO:
        DELETE PROCEDURE h-boin01126.
        ASSIGN h-boin01126 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-avisa-parcela99:

    IF l-avisou-parcela99 THEN
        RETURN "OK":U.

    ASSIGN l-avisou-parcela99 = YES.

    RUN utp/ut-msgs.p (INPUT "msg":U, INPUT 58206, INPUT "").

    ASSIGN i-seq-erro = i-seq-erro + 1.

    CREATE tt-bo-erro.
    ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
           tt-bo-erro.cd-erro      = 58206
           tt-bo-erro.mensagem     = RETURN-VALUE
           tt-bo-erro.errorsubtype = "information":U.

    RETURN "OK":U.
END PROCEDURE.

/* IM0101A1 */

