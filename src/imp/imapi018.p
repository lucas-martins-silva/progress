/********************************************************************************
** Copyright TOTVS S.A. (2017)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquenarrativar meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

{include/i-prgvrs.i IMAPI018 2.00.00.013} /*** "010013" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i imapi018 MIM}
&ENDIF

/*****************************************************************************
**
**       Programa: imapi018.p       
**
**       Data....: 06/2019  
**
**       Autor...: SQUAD - DMANSUPCEX  
**
**       Objetivo: Geraá∆o de dados de importaá∆o para itens controlados pela 
**                 pol°cia federal
** 
*******************************************************************************/
{ftp/ft0536.i}
{cpp/cpapi027.i}

DEFINE INPUT  PARAMETER pc-cod-estabel       LIKE estabelec.cod-estabel        NO-UNDO.
DEFINE INPUT  PARAMETER p-it-codigo-org-ctrl LIKE item-orgao-control.it-codigo NO-UNDO.
DEFINE INPUT  PARAMETER pi-per-ano           AS   INTEGER                      NO-UNDO.
DEFINE INPUT  PARAMETER pi-per-mes           AS   INTEGER                      NO-UNDO.
DEFINE INPUT  PARAMETER pTipoRegistro        AS   CHARACTER                    NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-dados.
DEFINE OUTPUT PARAMETER TABLE FOR tt-bo-erro.

DEFINE VARIABLE c-chave-docum-est    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-chave-item-doc-est AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-id-pai             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dt-ini               AS DATE        NO-UNDO.
DEFINE VARIABLE dt-fim               AS DATE        NO-UNDO.
DEFINE VARIABLE i-mes-fim            AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-ano-fim            AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-forma-importa      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-qtd-prod          AS DECIMAL     NO-UNDO.

/*Unidade de Medida*/
DEFINE VARIABLE c-desc-aux        AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-nossa-unid      AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-unid-forn       AS CHARACTER NO-UNDO.
DEFINE VARIABLE h-boin176         AS HANDLE    NO-UNDO.

DEFINE TEMP-TABLE ttFormatLine NO-UNDO
    FIELD cInfo   AS CHARACTER
    FIELD iIniPos AS INTEGER 
    FIELD iLength AS INTEGER.

DEFINE BUFFER bf-pais FOR pais.

/* Vari†veis para preenchimento do arquivo */
{imp/imapi018.i}

FUNCTION fnTpTransp RETURNS CHARACTER (modalid-frete AS CHARACTER):

   /* 0 - Contrataá∆o de frete por conta do remetente (CIF)    */
   /* 1 - Contrataá∆o de frete por conta do destinat†rio (FOB) */
   /* 2 - Contrataá∆o de frete por conta de terceiros          */
   /* 3 - Contrataá∆o de frete por conta do remetente          */
   /* 4 - Contrataá∆o de frete por conta do destinat†rio       */
   /* 9 - Sem ocorrància de transporte                         */

   /*******************************************
      I - Pr¢prio Importador
      T - Terceirizada Nacional
      F - Fornecedor/Terceirizada Internacional
   *******************************************/
    CASE INTEGER(modalid-frete):
        WHEN 0 OR WHEN 3 THEN RETURN "F":U.
        WHEN 1 OR WHEN 4 THEN RETURN "I":U.
        WHEN 2 THEN DO:
            IF AVAIL bf-pais AND bf-pais.cod-internacional-pais = 1 THEN
                RETURN "T":U.
            ELSE
                RETURN "F":U.
        END.
        WHEN 9 THEN RETURN "":U.
        OTHERWISE RETURN "":U.
    END CASE.    
END FUNCTION.

FUNCTION fnNCM RETURNS CHARACTER ():
   IF pTipoRegistro = "PR":U
   OR pTipoRegistro = "SC":U THEN DO:
        RETURN pTipoRegistro + item-orgao-control.cod-agpf + REPLACE(SUBSTRING(item-orgao-control.cod-livre-1,1,40),".","").
   END.
   ELSE IF pTipoRegistro = "PC":U THEN DO:
       RETURN pTipoRegistro + SUBSTRING(item-orgao-control.cod-livre-1,1,40).
   END.

END FUNCTION.

FIND FIRST estabelec NO-LOCK 
     WHERE estabelec.cod-estabel = pc-cod-estabel NO-ERROR.

IF NOT AVAIL estabelec THEN
    RETURN "NOK":U.

FIND FIRST item-orgao-control NO-LOCK 
     WHERE item-orgao-control.it-codigo = p-it-codigo-org-ctrl
       AND item-orgao-control.log-item-agpf NO-ERROR.

IF NOT AVAIL item-orgao-control THEN
    RETURN "NOK":U.

FOR FIRST ITEM FIELDS (politica)
    WHERE ITEM.it-codigo = p-it-codigo-org-ctrl NO-LOCK:
END.

/* C†lcula o in°cio do pr¢ximo màs */
IF pi-per-mes = 12 THEN
    ASSIGN i-mes-fim = 1
           i-ano-fim = pi-per-ano + 1.
ELSE
    ASSIGN i-mes-fim = pi-per-mes + 1
           i-ano-fim = pi-per-ano.

ASSIGN dt-ini            = DATE(pi-per-mes, 1, pi-per-ano)
       dt-fim            = (DATE(i-mes-fim, 1, i-ano-fim)) - 1
       c-tipo-mvi        = "MVI":U
       c-operacao        = "I":U
       c-tipo-tra        = "TRA":U
       c-tipo-tri        = "TRI":U
       c-tipo-ter        = "TER":U
       c-tipo-nf         = "NF":U
       c-codigo-operacao = "E":U.

EMPTY TEMP-TABLE tt-dados.

IF NOT VALID-HANDLE (h-boin176) THEN                                          
    RUN inbo/boin176.p PERSISTENT SET h-boin176.     

docum-est:
FOR EACH docum-est NO-LOCK 
   WHERE docum-est.cod-estabel = pc-cod-estabel
     AND docum-est.dt-emissao >= dt-ini
     AND docum-est.dt-emissao <= dt-fim:

    /* Desconsidera a nota: 
     * Se n∆o for nota de importaá∆o OU
     * Documento n∆o atualizado OU 
     * Nota m∆e que n∆o gera primeira remessa */
    IF ((NOT (docum-est.nat-operacao BEGINS "3":U)) OR   
        (not docum-est.ce-atual) OR
        (docum-est.idi-nf-simples-remes = 1 AND substring(docum-est.char-1,209,1) <> "S":U)) THEN 
        NEXT.

    /* Se n∆o houver documento de importaá∆o, desconsidera */
    FIND FIRST embarq-import-docto NO-LOCK
         WHERE embarq-import-docto.cod-ser-docto    = docum-est.serie-docto  
           AND embarq-import-docto.cod-docto        = docum-est.nro-docto    
           AND embarq-import-docto.cdn-emitente     = docum-est.cod-emitente 
           AND embarq-import-docto.cod-natur-operac = docum-est.nat-operacao NO-ERROR.
    IF NOT AVAIL embarq-import-docto THEN
        NEXT docum-est.

    FOR FIRST docto-estoq-nfe-imp FIELDS (des-decla-import dat-decla-import cod-livre-1) NO-LOCK
        WHERE docto-estoq-nfe-imp.cod-ser-docto    = docum-est.serie-docto 
          AND docto-estoq-nfe-imp.cod-docto        = docum-est.nro-docto   
          AND docto-estoq-nfe-imp.cdn-emitente     = docum-est.cod-emitente
          AND docto-estoq-nfe-imp.cod-natur-operac = docum-est.nat-operacao:
    END. 

    /* Desconsidera documento com forma de importaá∆o diferente de por conta pr¢pria */
    IF AVAIL docto-estoq-nfe-imp THEN DO:
        IF SUBSTRING(docto-estoq-nfe-imp.cod-livre-1,23,2) > "0":U THEN
            ASSIGN c-forma-importa = STRING(INT(SUBSTRING(docto-estoq-nfe-imp.cod-livre-1,23,2))).
        ELSE 
            ASSIGN c-forma-importa = "1":U.

        IF c-forma-importa <> "1":U THEN
            NEXT.
    END.
    ELSE 
        NEXT.

    FOR FIRST natur-oper FIELDS (cod-cfop) NO-LOCK
        WHERE natur-oper.nat-operacao = docum-est.nat-operacao:
    END.

    /* Desconsidera se n∆o for nota de entrada */
    IF  NOT AVAIL natur-oper OR (integer(substring(natur-oper.cod-cfop,1,1)) <> 3 ) THEN
        NEXT.

    /* Desconsidera se a nota n∆o tem o item em quest∆o */
    IF NOT CAN-FIND(FIRST item-doc-est 
                    WHERE item-doc-est.serie-docto  = docum-est.serie-docto 
                      AND item-doc-est.nro-docto    = docum-est.nro-docto 
                      AND item-doc-est.cod-emitente = docum-est.cod-emitente 
                      AND item-doc-est.nat-operacao = docum-est.nat-operacao
                      AND item-doc-est.it-codigo    = p-it-codigo-org-ctrl) THEN
        NEXT.

    /* Desconsidera se Nota m∆e que gera primeira remessa e n∆o tem informaá∆o de ordem em algum item */
    IF ((docum-est.idi-nf-simples-remes = 1 AND substring(docum-est.char-1,209,1) = "S":U)) AND
        NOT CAN-FIND(FIRST item-doc-est 
                     WHERE item-doc-est.serie-docto  = docum-est.serie-docto 
                       AND item-doc-est.nro-docto    = docum-est.nro-docto 
                       AND item-doc-est.cod-emitente = docum-est.cod-emitente 
                       AND item-doc-est.nat-operacao = docum-est.nat-operacao
                       AND item-doc-est.it-codigo    = p-it-codigo-org-ctrl 
                       AND item-doc-est.numero-ordem <> 0) THEN
        NEXT.

    FOR FIRST emitente FIELDS (nome-emit pais nome-abrev) NO-LOCK 
        WHERE emitente.cod-emitente = docum-est.cod-emitente:
        FOR FIRST pais FIELDS (cod-pais-siscomex) NO-LOCK 
            WHERE pais.nome-pais = emitente.pais:
        END.
    END.

    FOR FIRST transporte FIELDS(cgc nome pais) WHERE transporte.nome-abrev = docum-est.nome-transp NO-LOCK:
        FOR FIRST bf-pais FIELDS (cod-internacional-pais) 
            WHERE bf-pais.nome-pais = transporte.pais NO-LOCK:
        END.
    END.

    FOR FIRST loc-entr FIELD(cgc nom-razao-social endereco)
        WHERE loc-entr.cod-entrega = docum-est.cod-entrega
        AND   loc-entr.nome-abrev  = emitente.nome-abrev NO-LOCK:
    END.

    FOR FIRST cidade FIELDS (cdn-munpio-ibge)
        WHERE cidade.cidade = docum-est.cidade
          AND cidade.estado = docum-est.uf
          AND cidade.pais   = docum-est.pais NO-LOCK:
    END.

    /* Informaá‰es a n°vel de nota */
    ASSIGN c-chave-docum-est          = c-operacao + "|" + 
                                        docum-est.serie-docto         + "|":U + 
                                        string(docum-est.nro-docto)    + "|":U + 
                                        string(docum-est.cod-emitente) + "|":U + 
                                        docum-est.nat-operacao
           c-id-pais-adq              = IF AVAIL pais THEN cod-pais-siscomex ELSE "":U
           c-razao-social-adq         = IF AVAIL emitente THEN emitente.nome-emit ELSE "":U
           c-numero-di                = IF AVAIL docto-estoq-nfe-imp THEN docto-estoq-nfe-imp.des-decla-import ELSE "":U
           c-dt-di                    = IF AVAIL docto-estoq-nfe-imp THEN STRING(docto-estoq-nfe-imp.dat-decla-import, "99/99/9999") ELSE "":U
           c-responsavel-armazenagem  = "":U
           c-responsavel-transporte   = fnTpTransp(SUBSTRING(docum-est.char-2,143,8))
           c-local-entrega            = IF AVAIL loc-entr AND loc-entr.endereco = docum-est.endereco THEN "I":U ELSE "T":U
           c-cpf-cnpf-transp          = IF AVAIL transporte THEN transporte.cgc ELSE "":U
           c-razao-socal-transp       = IF AVAIL transporte THEN transporte.nome ELSE "":U
           c-cpf-cnpf-ter-transp      = IF AVAIL loc-entr THEN loc-entr.cgc ELSE "":U
           c-razao-socal-ter-transp   = IF AVAIL loc-entr THEN loc-entr.nom-razao-social ELSE "":U
           c-endereco-transp          = docum-est.endereco
           c-cep-transp               = STRING(docum-est.cep,"99.999-999":U)
           c-num-endereco-transp      = "":U
           c-compl-endereco-transp    = "":U
           c-bairro-local-retirada    = docum-est.bairro
           c-uf-local-retirada        = docum-est.uf
           c-municipio-local-retirada = IF AVAIL cidade THEN STRING(cidade.cdn-munpio-ibge) ELSE "":U
           c-numero-nf                = docum-est.nro-docto
           c-dat-nf                   = STRING(docum-est.dt-emissao, "99/99/9999").

    
    /* Modalidade de frete - Terceirizada Nacional */
    IF c-responsavel-transporte = "T":U THEN DO:
        /* 
        * Subseá∆o Respons†vel pelo Transporte - Nacional (TRA) 
        */
        EMPTY TEMP-TABLE ttFormatLine.
        ASSIGN c-linha = "":U.
        {imp/imapi018.i3}
    
        FOR EACH ttFormatLine:
            RUN piCreateLine IN THIS-PROCEDURE (INPUT ttFormatLine.cInfo,
                                                INPUT ttFormatLine.iIniPos,
                                                INPUT ttFormatLine.iLength).
        END.
        {imp/imapi018.i2 "'TRA'" "c-chave-docum-est"}
        /* FIM - Subseá∆o Respons†vel pelo Transporte - Nacional (TRA) */
    END.
    ELSE IF c-responsavel-transporte = "F":U THEN DO:
        /* Modalidade de frete - Terceirizada Internacional */
        /* 
         * Subseá∆o Respons†vel pelo Transporte - Internacional (TRI) 
         */
        EMPTY TEMP-TABLE ttFormatLine.
        ASSIGN c-linha = "":U.
        {imp/imapi018.i7}
    
        FOR EACH ttFormatLine:
            RUN piCreateLine IN THIS-PROCEDURE (INPUT ttFormatLine.cInfo,
                                                INPUT ttFormatLine.iIniPos,
                                                INPUT ttFormatLine.iLength).
        END.
        {imp/imapi018.i2 "'TRI'" "c-chave-docum-est"}
        /* FIM - Subseá∆o Respons†vel pelo Transporte - Internacional(TRI) */
    END.   

    /* 
     * Subseá∆o Local de Entrega (TER) 
     */
    EMPTY TEMP-TABLE ttFormatLine.
    ASSIGN c-linha = "":U.
    {imp/imapi018.i4}

    FOR EACH ttFormatLine:
        RUN piCreateLine IN THIS-PROCEDURE (INPUT ttFormatLine.cInfo,
                                            INPUT ttFormatLine.iIniPos,
                                            INPUT ttFormatLine.iLength).
    END.
    {imp/imapi018.i2 "'TER'" "c-chave-docum-est"}
    /* FIM - Subseá∆o Local de Entrega (TER) */

    /* 
     * Subseá∆o Nota Fiscal (NF) 
     */
    EMPTY TEMP-TABLE ttFormatLine.
    ASSIGN c-linha = "":U.
    {imp/imapi018.i5}

    FOR EACH ttFormatLine:
        RUN piCreateLine IN THIS-PROCEDURE (INPUT ttFormatLine.cInfo,
                                            INPUT ttFormatLine.iIniPos,
                                            INPUT ttFormatLine.iLength).
    END.
    {imp/imapi018.i2 "'NF'" "c-chave-docum-est"}
    /* FIM - Subseá∆o Nota Fiscal (NF) */
                    
    RUN setConstraintOfDocumEst IN h-boin176 (INPUT docum-est.cod-emitente,  
                                              INPUT docum-est.serie-docto,   
                                              INPUT docum-est.nro-docto,     
                                              INPUT docum-est.nat-operacao). 
                                                                     
    RUN openQueryStatic IN h-boin176 (INPUT "OfDocumEst":U) NO-ERROR.     

    RUN findDocumento IN h-boin176 (INPUT docum-est.cod-emitente,
                                    INPUT docum-est.serie-docto,
                                    INPUT docum-est.nro-docto,
                                    INPUT docum-est.nat-operacao).
                    
    FOR EACH item-doc-est NO-LOCK
       WHERE item-doc-est.serie-docto  = docum-est.serie-docto 
         AND item-doc-est.nro-docto    = docum-est.nro-docto 
         AND item-doc-est.cod-emitente = docum-est.cod-emitente 
         AND item-doc-est.nat-operacao = docum-est.nat-operacao
         AND item-doc-est.it-codigo    = p-it-codigo-org-ctrl:

         /* Desconsidera se Nota m∆e que gera primeira remessa e n∆o tem informaá∆o de ordem */
        IF ((docum-est.idi-nf-simples-remes = 1 AND substring(docum-est.char-1,209,1) = "S":U)) AND
            (item-doc-est.numero-ordem = 0) THEN
            NEXT.

        FOR FIRST licenciam-import-oc FIELDS(licenca-import dat-livre-1) NO-LOCK
             WHERE licenciam-import-oc.numero-ordem = item-doc-est.numero-ordem 
               AND licenciam-import-oc.parcela      = item-doc-est.parcela:
        END.
        
        FOR FIRST embarque-imp FIELDS (embarque cdn-pto-embarq) NO-LOCK
            WHERE embarque-imp.cod-estabel   = pc-cod-estabel
              AND embarque-imp.embarque      = embarq-import-docto.cod-embarq:

            FOR FIRST historico-embarque FIELDS (dt-efetiva) NO-LOCK
                WHERE historico-embarque.cod-estabel   = pc-cod-estabel
                  AND historico-embarque.embarque      = embarque-imp.embarque
                  AND historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-embarq:
            END.
        END.

        /*Busca da unidade de medida Interna*/
        run getUnidadeMedida IN h-boin176 (INPUT item-doc-est.it-codigo,
                                           input " ":U, 
                                           input item-doc-est.numero-ordem,
                                           input item-doc-est.parcela,
                                           output c-desc-aux,
                                           output c-unid-forn).

       assign c-nossa-unid = c-desc-aux.

        /* Informaá‰es a n°vel de item */
        ASSIGN c-chave-item-doc-est       = c-operacao                     + "|":U + 
                                            docum-est.serie-docto          + "|":U + 
                                            string(docum-est.nro-docto)    + "|":U + 
                                            string(docum-est.cod-emitente) + "|":U + 
                                            docum-est.nat-operacao         + "|":U + 
                                            string(item-doc-est.sequencia)
               c-id-pai                   = docum-est.serie-docto          + "|":U + 
                                            string(docum-est.nro-docto)    + "|":U + 
                                            string(docum-est.cod-emitente) + "|":U + 
                                            docum-est.nat-operacao         
               c-numero-li                = IF AVAIL licenciam-import-oc THEN licenciam-import-oc.licenca-import ELSE "":U
               c-dt-restricao-embarque    = IF AVAIL licenciam-import-oc THEN STRING(licenciam-import-oc.dat-livre-1, "99/99/9999") ELSE "":U
               c-dt-co-embarque           = IF AVAIL historico-embarque THEN STRING(historico-embarque.dt-efetiva, "99/99/9999") ELSE "":U               
               c-ncm                      = fnNCM()
               c-concentracao             = STRING(item-orgao-control.cdd-concentr-agpf)
               c-densidade                = STRING(item-orgao-control.cdd-densidade-agpf, "99.99")
               de-qtd-prod                = fnQuantidadePF(item-doc-est.it-codigo, c-nossa-unid, item-doc-est.quantidade)
               c-quantidade               = string(de-qtd-prod ,">>>,>>>,>>9.999":U)
               c-unidade-medida           = substring(item-orgao-control.cod-unid-medid-agpf,1,1).

        /*
         * Seá∆o Movimentaá∆o Internacional de Produtos Qu°micos (MVI) 
         */
        EMPTY TEMP-TABLE ttFormatLine.
        ASSIGN c-linha = "":U.
        {imp/imapi018.i1}

        FOR EACH ttFormatLine:
            RUN piCreateLine IN THIS-PROCEDURE (INPUT ttFormatLine.cInfo,
                                                INPUT ttFormatLine.iIniPos,
                                                INPUT ttFormatLine.iLength).
        END.
        
        {imp/imapi018.i2 "'MVI'" "c-chave-item-doc-est"}
        /* Fim - Seá∆o Movimentaá∆o Internacional de Produtos Qu°micos (MVI) */

        /* 
         * Subseá∆o Nota Fiscal (NF) - ITEM (NFI)
         */
        EMPTY TEMP-TABLE ttFormatLine.
        ASSIGN c-linha = "":U.
        {imp/imapi018.i6}

        FOR EACH ttFormatLine:
            RUN piCreateLine IN THIS-PROCEDURE (INPUT ttFormatLine.cInfo,
                                                INPUT ttFormatLine.iIniPos,
                                                INPUT ttFormatLine.iLength).
        END.
        {imp/imapi018.i2 "'NFI'" "c-chave-item-doc-est"}
        ASSIGN tt-dados.id-pai     = c-id-pai
               tt-dados.qt-produto = de-qtd-prod.
        /* FIM - Subseá∆o Nota Fiscal (NF) - ITEM (NFI) */

    END.
END.

IF  VALID-HANDLE(h-boin176) THEN DO:
	RUN beforeDestroy IN h-boin176.
    DELETE PROCEDURE h-boin176.
    ASSIGN h-boin176 = ?.
END.

PROCEDURE piCreateLine:
/*------------------------------------------------------------------------------
  Purpose: Gera linha formatada (preenche a vari†vel c-linha)
  Parameters: cInfo (input - character): Informaá∆o a ser inserida
              iInitialPosition (input - integer): Posiá∆o inicial da informaá∆o
              iLength (input - integer): N£mero de posiá‰es que a informaá∆o 
                                         deve ocupar
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER cInfo            AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER iInitialPosition AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER iLength          AS INTEGER   NO-UNDO.

    IF cInfo = ? THEN
        ASSIGN cInfo = "":U.

    ASSIGN OVERLAY(c-linha, iInitialPosition, iLength) = cInfo.

    RETURN "OK":U.
END PROCEDURE.


