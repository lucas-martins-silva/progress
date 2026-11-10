/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEFT003 2.00.00.011 } /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aneft003 MAN}
&ENDIF

/******************************************************************************
**  Programa: aneft003.p
**  Funcao  : Sender de Naturezas de Operacao
**  Data    : 09/2002
**  Autor   : Jean Renato
******************************************************************************/

/* Todos os programas que forem exclusivos do projeto NeoGrid (b2b), somente
   rodarao em clientes com versao do Progress igual ou superior a 8. E' um
   pre-requisito para instalar o sistema.
   O programa abaixo foi digitado no editor da 9, por isso apresenta as
   quebras de linha. */

{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}

DEF INPUT PARAM p-rowid        AS ROWID                   NO-UNDO.
DEF INPUT PARAM c-cod-estabel  LIKE estabelec.cod-estabel NO-UNDO.
DEF INPUT PARAM i-cod-emitente LIKE emitente.cod-emitente NO-UNDO.

DEF VAR c-root                       AS CHAR   NO-UNDO. 
DEF VAR c-message                    AS CHAR   NO-UNDO.
DEF VAR c-UpdateFiscalOperation      AS CHAR   NO-UNDO.
DEF VAR c-FiscalOperationCollection  AS CHAR   NO-UNDO.
DEF VAR c-FiscalOperationInformation AS CHAR   NO-UNDO.
DEF VAR c-campo                      AS CHAR   NO-UNDO.
DEF VAR c-FromRole                   AS CHAR   NO-UNDO.
DEF VAR c-ToRole                     AS CHAR   NO-UNDO.
DEF VAR h-boin245                    AS HANDLE NO-UNDO.
DEF VAR de-pc-pis                    AS DECIMAL FORMAT ">9.9999" NO-UNDO.
DEF VAR de-pc-cofins                 AS DECIMAL FORMAT ">9.9999" NO-UNDO.

 DEF VAR h-cdapi995    AS HANDLE NO-UNDO.


{adapters/neogrid/include/anein004.i} /*sender*/

RUN pi-cabecalho-msg.

run inbo/boin245.p persistent set h-boin245.

IF NOT VALID-HANDLE(h-cdapi995) THEN
    RUN cdp/cdapi995.p PERSISTENT SET h-cdapi995.

IF  p-rowid <> ? THEN DO:
    FIND natur-oper WHERE ROWID(natur-oper) = p-rowid NO-LOCK NO-ERROR.
    IF  AVAIL natur-oper THEN
        RUN pi-corpo-msg.
END.
ELSE
    FOR EACH natur-oper NO-LOCK:
        RUN pi-corpo-msg.
    END.


delete procedure h-boin245.

IF VALID-HANDLE(h-cdapi995) THEN DO:
    RUN pi-finalizar in h-cdapi995.
    ASSIGN h-cdapi995 = ?.
END.

RUN pi-rodape-msg.
WRITExml().

PROCEDURE pi-cabecalho-msg:
    ASSIGN c-root = CreateNeoGridDoc("UpdateFiscalOperation","1.01.001","1")
           c-message = AddElement(c-root,"Message")
           c-UpdateFiscalOperation = AddElement(c-message,"UpdateFiscalOperation")
           c-FiscalOperationCollection = AddElement(c-UpdateFiscalOperation,"FiscalOperationCollection")
           c-FromRole = AddElement(c-UpdateFiscalOperation,"FromRole")
           c-ToRole = AddElement(c-UpdateFiscalOperation,"ToRole").
END PROCEDURE.

PROCEDURE pi-corpo-msg:

    DEF VAR i-ind-entreg-futur   AS INT    NO-UNDO.
    DEF VAR i-oper-entrega-fatur AS INT    NO-UNDO.
    DEF VAR c-oper-entrega-fatur AS CHAR   NO-UNDO.
    DEF VAR l-ind-entfut         AS LOG    NO-UNDO.
    DEF VAR l-ind-est-qtd        AS LOG    NO-UNDO.


   
     ASSIGN i-ind-entreg-futur = IF SUBSTR(natur-oper.char-1,1,5) = "1":U THEN 1
                                 ELSE 2
            l-ind-entfut       = natur-oper.ind-entfut
            l-ind-est-qtd      = natur-oper.ind-est-qtd.


    RUN convertOperationType IN h-boin245 (INPUT 2,
                                           INPUT-OUTPUT i-oper-entrega-fatur,
                                           INPUT-OUTPUT i-ind-entreg-futur,
                                           INPUT-OUTPUT l-ind-entfut,
                                           INPUT-OUTPUT l-ind-est-qtd).

    CASE i-oper-entrega-fatur:
        WHEN 1 THEN 
            ASSIGN c-oper-entrega-fatur = "Nenhum/Faturamento Presente".
        WHEN 2 THEN 
            ASSIGN c-oper-entrega-fatur = "Faturamento Antecipado".
        WHEN 3 THEN 
            ASSIGN c-oper-entrega-fatur = "Remessa de Faturamento Antecipado".
        WHEN 4 THEN 
            ASSIGN c-oper-entrega-fatur = "Faturamento com Entrega Futura".
        WHEN 5 THEN 
            ASSIGN c-oper-entrega-fatur = "Remessa de Entrega Futura".
        OTHERWISE 
            ASSIGN c-oper-entrega-fatur = "Nenhum/Faturamento Presente".
    END CASE.

    DEF VAR c-tipo-base-iss AS CHAR NO-UNDO.
    &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN  
        DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao001 = {varinc/var00074.i 4 INT(SUBSTRING(natur-oper.char-2,21,5))}.
        RUN utp/ut-liter.p (INPUT REPLACE(TRIM(cauxtraducao001)," ","_"),
                            INPUT "",
                            INPUT "").
        ASSIGN  c-tipo-base-iss = RETURN-VALUE.
    &ELSE 
        ASSIGN c-tipo-base-iss = {varinc/var00074.i 4 INT(SUBSTRING(natur-oper.char-2,21,5))}.
    &ENDIF  

    RUN recupera-aliquotas IN h-cdapi995 (INPUT "natur-oper",
                                         INPUT natur-oper.nat-operacao,
                                         OUTPUT de-pc-pis,
                                         OUTPUT de-pc-cofins).

    IF de-pc-pis    = 0 THEN ASSIGN de-pc-pis    = natur-oper.perc-PIS[1].
    IF de-pc-cofins = 0 THEN ASSIGN de-pc-cofins = natur-oper.per-fin-soc[1].

    ASSIGN c-FiscalOperationInformation = AddElement(c-FiscalOperationCollection,"FiscalOperationInformation")
           c-campo = AddEleChar(c-FiscalOperationInformation,"FiscalOperation",natur-oper.nat-operacao)
           c-campo = AddEleChar(c-FiscalOperationInformation,"FiscalOperationDescription",natur-oper.denominacao)
           c-campo = AddEleInt(c-FiscalOperationInformation,"InvoiceType",IF natur-oper.ind-entfut = YES THEN 1
                                                                          ELSE 2)
           c-campo = AddEleInt(c-FiscalOperationInformation,"ExternalImprovement",IF natur-oper.terceiros
                                                                                  AND natur-oper.oper-terc = 1 THEN 1
                                                                                  ELSE 2)
           c-campo = AddEleChar(c-FiscalOperationInformation,"ReturnOf",natur-oper.nat-comp)
           c-campo = AddEleChar(c-FiscalOperationInformation, "tipo", ENTRY(natur-oper.tipo,{ininc/i06in245.i 3}))
           c-campo = AddEleChar(c-FiscalOperationInformation,"nat-ativa", IF natur-oper.nat-ativa = YES THEN "Sim"
                                                                          ELSE "NÆo")
           c-campo = AddEleChar(c-FiscalOperationInformation,"especie-doc",natur-oper.especie-doc)
           c-campo = AddEleChar(c-FiscalOperationInformation, "mercado", ENTRY(natur-oper.mercado,{ininc/i02in245.i 3}))
           c-campo = AddEleInt(c-FiscalOperationInformation,"cod-canal-venda",natur-oper.cod-canal-venda)
           c-campo = AddEleInt(c-FiscalOperationInformation,"cod-mensagem",natur-oper.cod-mensagem)
           c-campo = AddEleChar(c-FiscalOperationInformation,"formato-cfop",IF SUBSTR(natur-oper.char-2,78,7) <> "" THEN 
                                                                                SUBSTR(natur-oper.char-2,78,7) /* "9.99","9.99.9" ou "9.99.99" */
                                                                            ELSE "9.99")
           c-campo = AddEleChar(c-FiscalOperationInformation,"cod-cfop",&IF DEFINED(bf_dis_formato_CFOP) &THEN natur-oper.cod-cfop
                                                                        &ELSE IF SUBSTR(natur-oper.char-1,45,10) = "" THEN ""
                                                                              ELSE TRIM(SUBSTR(natur-oper.char-1,45,10))
                                                                        &ENDIF).
    ASSIGN c-campo = AddEleInt(c-FiscalOperationInformation,"modelo-doc-of",natur-oper.cd-situacao)
           c-campo = AddEleChar(c-FiscalOperationInformation,"modelo-cupom-fiscal",SUBSTR(natur-oper.char-2,76,2))
           c-campo = AddEleChar(c-FiscalOperationInformation,"cod-esp",natur-oper.cod-esp)
           c-campo = AddEleInt(c-FiscalOperationInformation,"tp-rec-desp",natur-oper.tp-rec-desp)
           c-campo = AddEleChar(c-FiscalOperationInformation,"transf",IF natur-oper.transf = YES THEN "Sim"
                                                                      ELSE "NÆo")
           c-campo = AddEleChar(c-FiscalOperationInformation,"gerar-nota-faturamento",IF natur-oper.imp-nota = YES THEN "Sim"
                                                                                      ELSE "NÆo")
           c-campo = AddEleChar(c-FiscalOperationInformation,"nota-rateio",IF natur-oper.nota-rateio = YES THEN "Sim"
                                                                           ELSE "NÆo")
           c-campo = AddEleChar(c-FiscalOperationInformation,"nota-propria",IF natur-oper.int-1 = 1 THEN "Sim"
                                                                            ELSE "NÆo")
           c-campo = AddEleChar(c-FiscalOperationInformation,"nota-comercio",IF natur-oper.log-2 = YES THEN "Sim"
                                                                             ELSE "NÆo")
           c-campo = AddEleChar(c-FiscalOperationInformation,"venda-ativo",IF natur-oper.venda-ativo = YES THEN "Sim"
                                                                           ELSE "NÆo")
           c-campo = AddEleChar(c-FiscalOperationInformation,"venda-ambulante",IF natur-oper.int-2 = 1 THEN "Sim"
                                                                               ELSE "NÆo")
           c-campo = AddEleChar(c-FiscalOperationInformation,"gera-dev-valor",IF SUBSTR(natur-oper.char-2,88,5) = "1" THEN "Sim"
                                                                              ELSE "NÆo")
           c-campo = AddEleChar(c-FiscalOperationInformation,"log-oper-triang",&IF DEFINED(bf_mat_oper_triangular) &THEN
                                                                                 IF natur-oper.log-oper-triang = YES THEN "Sim"
                                                                                 ELSE "NÆo"
                                                                               &ELSE ""
                                                                               &ENDIF).
    ASSIGN c-campo = AddEleChar(c-FiscalOperationInformation,"log-natureza-bonif",&IF DEFINED(bf_dis_desc_bonif) &THEN
                                                                                     IF natur-oper.log-natureza-bonif = YES THEN "Sim"
                                                                                     ELSE "NÆo"
                                                                                  &ELSE ""
                                                                                  &ENDIF)
           c-campo = AddEleChar(c-FiscalOperationInformation,"cod-natur-oper-bonif",&IF DEFINED(bf_dis_desc_bonif) &THEN 
                                                                                         natur-oper.cod-natur-oper-bonif
                                                                                    &ELSE ""
                                                                                    &ENDIF)
           c-campo = AddEleChar(c-FiscalOperationInformation,"terceiros",IF natur-oper.terceiros = YES THEN "Sim"
                                                                         ELSE "NÆo")
    .
    &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN 
        DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao002 = {ininc/i04in245.i 3}.
        RUN utp/ut-list.p (INPUT-OUTPUT cauxtraducao002).
        ASSIGN c-campo = AddEleChar(c-FiscalOperationInformation,"tp-oper-terc",ENTRY(natur-oper.tp-oper-terc, cAuxTraducao002)).
    &ELSE 
        ASSIGN c-campo = AddEleChar(c-FiscalOperationInformation,"tp-oper-terc",ENTRY(natur-oper.tp-oper-terc,{ininc/i04in245.i 3})).
    &ENDIF 
ASSIGN  c-campo = AddEleChar(c-FiscalOperationInformation,"log-vl-it-terc",IF SUBSTR(natur-oper.char-2,36,5) = "1" THEN "Sim"
                                                                           ELSE "NÆo")
        c-campo = AddEleDeci(c-FiscalOperationInformation,"variacao-valor", natur-oper.dec-1)
        c-campo = AddEleChar(c-FiscalOperationInformation,"tipo-compra", &IF "{&bf_mat_natur_compra_re}" = "yes"
                                                                          OR "{&bf_mat_oper_triangular}" = "yes" &THEN  
                                                                               ENTRY(natur-oper.tipo-compra,{ininc/i09in245.i 3})
                                                                         &ELSE ""
                                                                         &ENDIF)
             c-campo = AddEleChar(c-FiscalOperationInformation,"baixa-estoq",IF natur-oper.baixa-estoq = YES THEN "Sim"
                                                                             ELSE "NÆo")
             c-campo = AddEleChar(c-FiscalOperationInformation,"oper-ent-fut-fat-antec",c-oper-entrega-fatur)
             c-campo = AddEleChar(c-FiscalOperationInformation,"tipo-base-ipi", {varinc/var00074.i 4 INT(SUBSTRING(natur-oper.char-2,11,1))})
             c-campo = AddEleChar(c-FiscalOperationInformation,"frete-base-ipi",IF SUBSTR(natur-oper.char-2,6,5) = "1" THEN "Sim"
                                                                                ELSE "NÆo")
             c-campo = AddEleChar(c-FiscalOperationInformation,"cd-vinc-ipi",natur-oper.cd-vinc).
      &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN  
          DEFINE VARIABLE cAuxTraducao003 AS CHARACTER NO-UNDO.
          ASSIGN cAuxTraducao003 = {ininc/i10in172.i 3}.
          RUN utp/ut-list.p (INPUT-OUTPUT cauxtraducao003).
          ASSIGN c-campo = AddEleChar(c-FiscalOperationInformation,"cd-trib-ipi",ENTRY(natur-oper.cd-trib-ipi, cAuxTraducao003)).
      &ELSE 
          ASSIGN c-campo = AddEleChar(c-FiscalOperationInformation,"cd-trib-ipi",ENTRY(natur-oper.cd-trib-ipi,{ininc/i10in172.i 3})).
      &ENDIF 
      ASSIGN c-campo = AddEleDeci(c-FiscalOperationInformation,"perc-red-ipi",natur-oper.perc-red-ipi)
             c-campo = AddEleChar(c-FiscalOperationInformation,"ipi-base-icms",IF SUBSTR(natur-oper.char-2,1,5) = "1" THEN "Sim"
                                                                               ELSE "NÆo")
             c-campo = AddEleChar(c-FiscalOperationInformation,"ipi-icm-out",IF natur-oper.ipi-icm-out = YES THEN "Sim"
                                                                             ELSE "NÆo")
             c-campo = AddEleChar(c-FiscalOperationInformation,"ipi-total-nota",IF SUBSTR(natur-oper.char-2,16,5) = "1" THEN "Sim"
                                                                                ELSE "NÆo")
             c-campo = AddEleChar(c-FiscalOperationInformation,"ipi-outros-subs",IF SUBSTR(natur-oper.char-2,46,5) = "1" THEN "Sim"
                                                                                 ELSE "NÆo").
      ASSIGN c-campo = AddEleChar(c-FiscalOperationInformation,"escrituracao-ipi-fretes",IF natur-oper.usa-pick = YES THEN "Sim"
                                                                                         ELSE "NÆo")
             c-campo = AddEleChar(c-FiscalOperationInformation,"estorna-ipi",IF natur-oper.manut-ipi = YES THEN "Sim"
                                                                             ELSE "NÆo")
             c-campo = AddEleChar(c-FiscalOperationInformation,"tipo-base-iss", c-tipo-base-iss).
      &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN  
          DEFINE VARIABLE cAuxTraducao004 AS CHARACTER NO-UNDO.
          ASSIGN cAuxTraducao004 = {ininc/i11in172.i 3}.
          RUN utp/ut-list.p (INPUT-OUTPUT cauxtraducao004).
          ASSIGN c-campo = AddEleChar(c-FiscalOperationInformation,"cd-trib-iss",ENTRY(natur-oper.cd-trib-iss, cAuxTraducao004)).
      &ELSE 
          ASSIGN c-campo = AddEleChar(c-FiscalOperationInformation,"cd-trib-iss",ENTRY(natur-oper.cd-trib-iss,{ininc/i11in172.i 3})).
      &ENDIF 
      ASSIGN c-campo = AddEleDeci(c-FiscalOperationInformation,"perc-red-iss", natur-oper.perc-red-iss)
             c-campo = AddEleChar(c-FiscalOperationInformation,"nat-vinculada", natur-oper.nat-vinculada)
             c-campo = AddEleChar(c-FiscalOperationInformation,"tipo-base-icms", ENTRY(natur-oper.merc-base-icms, {ininc/i05in245.i 3}))
             c-campo = AddEleChar(c-FiscalOperationInformation,"cd-trib-icm", ENTRY(natur-oper.cd-trib-icm, {ininc/i01in245.i 3}))
             c-campo = AddEleDeci(c-FiscalOperationInformation,"aliquota-icm", natur-oper.aliquota-icm)
             c-campo = AddEleDeci(c-FiscalOperationInformation,"aliq-icm-com", natur-oper.aliq-icm-com)
             c-campo = AddEleChar(c-FiscalOperationInformation,"tp-base-icm", natur-oper.tp-base-icm)
             c-campo = AddEleChar(c-FiscalOperationInformation,"estorna-icms",IF natur-oper.manut-icm = YES THEN "Sim"
                                                                              ELSE "NÆo")
             c-campo = AddEleDeci(c-FiscalOperationInformation,"per-desc-icms", natur-oper.per-des-icms)
             c-campo = AddEleDeci(c-FiscalOperationInformation,"desc-icms-zf", DECIMAL(SUBSTR(natur-oper.char-2,66,5)))
             c-campo = AddEleDeci(c-FiscalOperationInformation,"perc-red-icm", natur-oper.perc-red-icm)
             c-campo = IF INT(natur-oper.dec-2) = 1 THEN 
                       AddEleChar(c-FiscalOperationInformation,"destino-reducao", ENTRY(INT(natur-oper.dec-2), {varinc/var00071.i 3}))
                       ELSE AddEleChar(c-FiscalOperationInformation,"destino-reducao", ENTRY(2, {varinc/var00071.i 3}))
             c-campo = AddEleChar(c-FiscalOperationInformation,"subs-trib",IF natur-oper.subs-trib = YES THEN "Sim"
                                                                           ELSE "NÆo")
             c-campo = AddEleDeci(c-FiscalOperationInformation,"icms-subs-trib", natur-oper.icms-subs-trib)
             c-campo = AddEleChar(c-FiscalOperationInformation,"ind-it-icms",IF natur-oper.ind-it-icms = YES THEN "Sim"
                                                                             ELSE "NÆo")
             c-campo = AddEleChar(c-FiscalOperationInformation,"icms-outros-subs",IF SUBSTR(natur-oper.char-2,51,5) = "1" THEN "Sim"
                                                                                  ELSE "NÆo").
      ASSIGN c-campo = AddEleChar(c-FiscalOperationInformation,"gera-credito-subs",IF SUBSTR(natur-oper.char-2,56,5) = "1" THEN "Sim"
                                                                                   ELSE "NÆo")
             c-campo = AddEleChar(c-FiscalOperationInformation,"diminui-subs-total-frete",IF natur-oper.usa-nota-ent= YES THEN "Sim"
                                                                                          ELSE "NÆo")
             c-campo = AddEleChar(c-FiscalOperationInformation,"consum-final",IF natur-oper.consum-final= YES THEN "Sim"
                                                                              ELSE "NÆo")
             c-campo = AddEleChar(c-FiscalOperationInformation,"icms-suspenso",IF natur-oper.ind-it-sub-dif = YES THEN "Sim"
                                                                               ELSE "NÆo")
             c-campo = AddEleChar(c-FiscalOperationInformation,"icms-diferido",IF natur-oper.ind-it-sub-dif= ? THEN "Sim"
                                                                               ELSE "NÆo")
             c-campo = AddEleChar(c-FiscalOperationInformation,"nao-trib-icms",IF natur-oper.ind-tipo-vat = YES THEN "Sim"
                                                                               ELSE "NÆo")
             c-campo = AddEleChar(c-FiscalOperationInformation,"credito-ciap",&IF DEFINED(bf_dis_ciap) &THEN
                                                                                  IF natur-oper.credito-ciap = YES THEN "Sim"
                                                                                  ELSE "NÆo"
                                                                                &ELSE ""
                                                                               &ENDIF)
             c-campo = AddEleChar(c-FiscalOperationInformation,"log-acum-ciap",&IF DEFINED(bf_dis_ciap) &THEN
                                                                                   IF natur-oper.log-acum-ciap = YES THEN "Sim"
                                                                                   ELSE "NÆo"
                                                                                 &ELSE ""
                                                                               &ENDIF).
     ASSIGN c-campo = AddEleChar(c-FiscalOperationInformation,"narrativa",natur-oper.narrativa)
            c-campo = AddEleChar(c-FiscalOperationInformation,"ind-imprenda",IF natur-oper.ind-imprenda = YES THEN "Sim"
                                                                               ELSE "NÆo")
             c-campo = AddEleChar(c-FiscalOperationInformation,"retem-inss-fonte",IF SUBSTR(natur-oper.char-2,71,5) = "1" THEN "Sim"
                                                                                  ELSE "NÆo")
             c-campo = AddEleChar(c-FiscalOperationInformation,"cd-trib-ii", IF INT(SUBSTRING(natur-oper.char-1,10,2)) > 0 THEN 
                                                                             ENTRY(INT(SUBSTRING(natur-oper.char-1,10,2)), {ininc/i10in172.i 3})
                                                                             ELSE "")
             c-campo = AddEleDeci(c-FiscalOperationInformation,"perc-inss",&IF '{&bf_dis_versao_ems}' >= '2.04' &THEN DEC(SUBSTR(natur-oper.char-1,40,5))
                                                                           &ELSE ?
                                                                           &ENDIF)
             c-campo = AddEleDeci(c-FiscalOperationInformation,"perc-pis-interno",de-pc-pis)
             c-campo = AddEleDeci(c-FiscalOperationInformation,"perc-pis-externo",natur-oper.perc-PIS[2])
             c-campo = AddEleDeci(c-FiscalOperationInformation,"perc-pis-ate-31-10-2002",DECIMAL(SUBSTR(natur-oper.char-1,76,5)))
             c-campo = AddEleChar(c-FiscalOperationInformation,"cd-trib-pis", ENTRY(INT(SUBSTR(natur-oper.char-1,86,1)), {ininc/i11in172.i 3}))
             c-campo = AddEleDeci(c-FiscalOperationInformation,"perc-fin-soc-interno",de-pc-cofins).
      ASSIGN c-campo = AddEleDeci(c-FiscalOperationInformation,"perc-fin-soc-externo",natur-oper.per-fin-soc[2])
             c-campo = AddEleDeci(c-FiscalOperationInformation,"per-fin-soc-ate-31-10-2002",DECIMAL(SUBSTR(natur-oper.char-1,81,5)))              
             c-campo = AddEleChar(c-FiscalOperationInformation,"cd-trib-cofins",ENTRY(INT(SUBSTR(natur-oper.char-1,87,1)), {ininc/i11in172.i 3})) 

       &IF '{&bf_dis_versao_ems}' >= '2.062' &THEN 
             c-campo = AddEleChar(c-FiscalOperationInformation,"log-deduz-desc-zfm-tot-nf",IF natur-oper.log-deduz-desc-zfm-tot-nf THEN "Sim" ELSE "NÆo")
             c-campo = AddEleDeci(c-FiscalOperationInformation,"val-perc-desc-pis-zfm",natur-oper.val-perc-desc-pis-zfm)
             c-campo = AddEleDeci(c-FiscalOperationInformation,"val-perc-desc-cofins-zfm",natur-oper.val-perc-desc-cofins-zfm)
       &ELSE
             c-campo = AddEleChar(c-FiscalOperationInformation,"log-deduz-desc-zfm-tot-nf",if SUBSTR(natur-oper.char-1,109,1) = "S":U THEN "Sim" ELSE "NÆo")
             c-campo = AddEleDeci(c-FiscalOperationInformation,"val-perc-desc-pis-zfm",DEC(SUBSTR(natur-oper.char-1,110,8)))
             c-campo = AddEleDeci(c-FiscalOperationInformation,"val-perc-desc-cofins-zfm",DEC(SUBSTR(natur-oper.char-1,118,8)))
       &ENDIF.

END PROCEDURE.

PROCEDURE pi-rodape-msg:
    ASSIGN c-campo = AddEleChar(c-FromRole,"LegacyLocationIdentifier",c-cod-estabel)
           c-campo = AddEleChar(c-FromRole,"GlobalPartnerRoleClassificationCode","SELLER")
           c-campo = AddEleChar(c-ToRole,"LegacyLocationIdentifier",c-cod-estabel)
           c-campo = AddEleChar(c-ToRole,"GlobalPartnerRoleClassificationCode","BUYER").
END PROCEDURE.
