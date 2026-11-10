PROCEDURE PITransUpsert:

/*PARAMETERS - BEGIN*/

    DEFINE INPUT  PARAMETER pTranAction    AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pTranEvent     AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pRowidMDFE     AS ROWID       NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt_log_erro.


/*PARAMETERS - END*/


/*LOCAL VARIABLES - BEGIN*/
    

RUN pi-limpa-temp-tables.
/*LOCAL VARIABLES - END*/


/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */
FIND FIRST mdfe-docto NO-LOCK
     WHERE rowid(mdfe-docto) = pRowidMDFE NO-ERROR.
IF AVAILABLE mdfe-docto THEN DO:
    RUN pi-carrega-docto.
END.

RUN cdp/cd0360b.p (INPUT mdfe-docto.cod-estab,
                   INPUT "MDF-e":U,
                   OUTPUT cTpTrans).

RUN cdp/cd0029a.p (output l-integr-totvs-colab).

IF  cTpTrans = "TSS":U
OR  cTpTrans = "TC2":U
OR  cTpTrans = "TC":U THEN
    RUN pi-integra-XML.
ELSE
    RUN PIUpsert (INPUT  pTranEvent             ,
                  INPUT  pTranAction            ,
                  INPUT TABLE ttcondutor        ,
                  INPUT TABLE ttdisp            ,
                  INPUT TABLE ttinfCT           ,
                  INPUT TABLE ttinfCTe          ,
                  INPUT TABLE ttinfEmbComb      ,
                  INPUT TABLE ttinfMunCarrega   ,
                  INPUT TABLE ttinfMunDescarga  ,
                  INPUT TABLE ttinfNF           ,
                  INPUT TABLE ttinfNFe          ,
                  INPUT TABLE ttinfPercurso     ,
                  INPUT TABLE ttinfTermCarreg   ,
                  INPUT TABLE ttinfTermDescarreg,
                  INPUT TABLE ttinfUnidCarga    ,
                  INPUT TABLE ttinfUnidCarga_00 ,
                  INPUT TABLE ttinfUnidCarga_01 ,
                  INPUT TABLE ttinfUnidCarga_02 ,
                  INPUT TABLE ttinfUnidTransp   ,
                  INPUT TABLE ttinfUnidTransp_00,
                  INPUT TABLE ttinfUnidTransp_01,
                  INPUT TABLE ttinfUnidTransp_02,
                  INPUT TABLE ttlacres          ,
                  INPUT TABLE ttlacUnidCarga    ,
                  INPUT TABLE ttlacUnidCarga_00 ,
                  INPUT TABLE ttlacUnidCarga_01 ,
                  INPUT TABLE ttlacUnidCarga_02 ,
                  INPUT TABLE ttlacUnidTransp   ,
                  INPUT TABLE ttlacUnidTransp_00,
                  INPUT TABLE ttlacUnidTransp_01,
                  INPUT TABLE ttlacUnidTransp_02,
                  INPUT TABLE ttMDFe            ,
                  INPUT TABLE ttvag             ,
                  INPUT TABLE ttveicReboque     ,
                  INPUT TABLE ttCGCAutoriza     , /*Novas TAGS*/
                  OUTPUT TABLE tt_log_erro      ).


/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.






PROCEDURE pi-carrega-docto.
    DEFINE VARIABLE i-aux                            AS INTEGER         NO-UNDO.
    DEFINE VARIABLE d-total-icms-st                  AS DECIMAL         NO-UNDO.
    DEFINE VARIABLE d-total-icms                     AS DECIMAL         NO-UNDO.
    DEFINE VARIABLE c-cod-uf-ibge                    AS CHARACTER       NO-UNDO.
    DEFINE VARIABLE i-mult-nfe                       AS INTEGER         NO-UNDO.
    DEFINE VARIABLE i-count-nfe                      AS INTEGER         NO-UNDO.
    DEFINE VARIABLE i-soma-mod-nfe                   AS INTEGER         NO-UNDO.
    DEFINE VARIABLE i-dig-ver-nfe                    AS INTEGER         NO-UNDO.
    DEFINE VARIABLE i-niv-trib-icms                  AS INTEGER         NO-UNDO.
    DEFINE VARIABLE c-niv-trib-icms                  AS CHARACTER       NO-UNDO.
    DEFINE VARIABLE i-codigo-orig                    AS INTEGER         NO-UNDO.
    DEFINE VARIABLE i-codigo-orig-estab              AS INTEGER INIT ?  NO-UNDO.
    DEFINE VARIABLE c-chave-acesso-adicional-nfe     AS CHARACTER       NO-UNDO.
    DEFINE VARIABLE p-dh-formatada                   AS CHARACTER       NO-UNDO.

    DEF BUFFER bf-natur-oper-it FOR natur-oper.

    &IF '{&bf_dis_versao_ems}' >= '2.04' 
    AND '{&bf_dis_versao_ems}' < '2.08' &THEN
        &GLOBAL-DEFINE log-icms-substto-antecip SUBSTRING(bf-natur-oper-it.char-1,147,1) = "1"
    &ENDIF
    
    &IF '{&bf_dis_versao_ems}' >= '2.08' &THEN
        &GLOBAL-DEFINE log-icms-substto-antecip bf-natur-oper-it.log-icms-substto-antecip
    &ENDIF


    FIND FIRST mdfe-param NO-LOCK
         WHERE mdfe-param.cod-estabel = mdfe-docto.cod-estab NO-ERROR.

    FIND FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = mdfe-docto.cod-estab NO-ERROR.


    FIND FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = estabelec.cod-emitente NO-ERROR.


    FOR FIRST b-unid-feder-est FIELDS (&if '{&bf_dis_versao_ems}' >= '2.07':U &then cod-uf-ibge &else char-1 &endif) NO-LOCK
        WHERE b-unid-feder-est.pais   = estabelec.pais
          AND b-unid-feder-est.estado = estabelec.estado:
    END.

    FOR FIRST b-cidade-est FIELDS(pais &IF '{&BF_DIS_VERSAO_EMS}' >= "2.07":U &THEN cdn-munpio-ibge &ELSE int-2 &ENDIF)
        WHERE b-cidade-est.cidade = estabelec.cidade
          AND b-cidade-est.estado = estabelec.estado
          AND b-cidade-est.pais   = estabelec.pais   NO-LOCK:
    END.

    ASSIGN c-endereco = IF estabelec.endereco <> "" THEN estabelec.endereco ELSE emitente.endereco.

    IF  INDEX(c-endereco,CHR(ASC("§"))) > 0 THEN /* Retirar caracter especial */
        ASSIGN c-endereco = REPLACE(c-endereco,CHR(ASC("§")),"").


    RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.

    RUN pi-trata-endereco IN h-cdapi704 (INPUT  c-endereco,
                                         OUTPUT c-rua,
                                         OUTPUT c-nro,
                                         OUTPUT c-comp).

    IF  c-nro = "" THEN
        ASSIGN c-nro = "S/N".

    /*--- TRATAMENTO FONE - Sefaz aceita somente n£meros, e apenas 11 caracters -> DDD12345678 ---*/
    ASSIGN c-fone = "".

    DO  i-cont = 1 TO LENGTH(emitente.telefone[1]):

        /* Nao considerar o primeiro zero do telefone, caso inicie com 0 (DDD iniciando com 0 ou nro de telefone incorreto) */
        IF  i-cont = 1
        AND LOOKUP(SUBSTRING(emitente.telefone[1],i-cont,1),"0") > 0 THEN NEXT.

        IF  LOOKUP(SUBSTRING(emitente.telefone[1],i-cont,1),"0,1,2,3,4,5,6,7,8,9") > 0 THEN
            ASSIGN c-fone = c-fone + SUBSTRING(emitente.telefone[1],i-cont,1).
    END.
    /*---*/


    CREATE ttMDFe.
    ASSIGN ttMdfe.ttMDFeID   = 1
           ttMDFe.tpAmb      = STRING(mdfe-param.idi-ambien-mdfe)
           ttMdfe.tpEmit     = "2"  /* O MDF-e sempre vai ser gerado para 2 - Transportador de Carga Propria, pois nÆo estamos considerando transportadoras*/
           ttMDFe.cMDF       = mdfe-docto.cod-chave-mdfe
           ttMdfe.cDV        = SUBSTRING(mdfe-docto.cod-chave-mdfe, LENGTH(mdfe-docto.cod-chave-mdfe),1) WHEN LENGTH(mdfe-docto.cod-chave-mdfe) > 0
           ttMdfe.cMDFE      = SUBSTRING(mdfe-docto.cod-chave-mdfe,36,8)
           ttMdfe.MOD        = "58"
           ttMdfe.serie      = STRING(INT(mdfe-docto.cod-ser-mdfe))  /* Para retirar zeros … esquerda */
           ttMdfe.nMDF       = STRING(INT(mdfe-docto.cod-num-mdfe))  /* Para retirar zeros … esquerda */
           ttMdfe.modal      = STRING(mdfe-docto.cod-mod-frete)
           ttMDFe.procEmi    = "0"
           ttMDFe.verProc    = mdfe-param.cod-vers-mdfe
           ttMdfe.tpEmis     = STRING(mdfe-param.idi-tip-emis-mdfe)
           ttMDFe.CNPJ       = UPPER(estabelec.cgc)
           ttMDFe.IE         = estabelec.ins-estadual
           ttMDFe.IE         = REPLACE(ttMdfe.IE,"-","")
           ttMDFe.IE         = REPLACE(ttMdfe.IE,".","")
           ttMDFe.IE         = REPLACE(ttMdfe.IE,"/","")
           ttMDFe.IE         = REPLACE(ttMdfe.IE,"~\","")
           ttMDFe.IE         = REPLACE(ttMdfe.IE,",","")
           ttMDFe.IE         = (IF ttMdfe.IE <> ?
                                THEN ttMdfe.IE
                                ELSE "")
           ttMDFe.xNome      = estabelec.nome
           ttMDFe.xFant      = emitente.nome-abrev WHEN AVAIL emitente
           ttMDFe.xLgr       = c-rua
           ttMDFe.nro        = c-nro
           ttMDFe.xCpl       = c-comp
           ttMDFe.xBairro    = estabelec.bairro
           ttMDFe.cMun       = IF  estabelec.pais = "Brasil":U
                               THEN (&if '{&bf_dis_versao_ems}' >= '2.07':U
                                     &then IF AVAIL b-cidade-est THEN STRING(b-cidade-est.cdn-munpio-ibge) ELSE ""
                                     &else IF AVAIL b-cidade-est THEN STRING(b-cidade-est.int-2)           ELSE "" &endif)
                               ELSE "9999999"
           ttMDFe.xMun       = (IF estabelec.pais <> "Brasil":U
                                THEN "Exterior"
                                ELSE estabelec.cidade)
           ttMDFe.CEP        = STRING(estabelec.cep,"99999999")
           ttMDFe.UF         = IF estabelec.estado <> ? THEN estabelec.estado ELSE ""
           ttMdfe.fone       = c-fone
           ttMDFe.cUF       = IF  estabelec.pais = "Brasil":U
                                  THEN (&if '{&bf_dis_versao_ems}' >= '2.07':U
                                        &then IF AVAIL b-unid-feder-est THEN STRING(b-unid-feder-est.cod-uf-ibge)   ELSE 'EX'
                                        &else IF AVAIL b-unid-feder-est THEN SUBSTRING(b-unid-feder-est.char-1,1,2) ELSE 'EX' &endif)
                                  ELSE "EX".

    IF mdfe-docto.cod-un-medid = "KG" THEN
         ASSIGN ttMDFe.cUnid = "01".
    ELSE ASSIGN ttMDFe.cUnid = "02".

    /*ASSIGN c-dia  = STRING(DAY(mdfe-docto.dat-emis-mdfe),"99")
           c-mes  = STRING(MONTH(mdfe-docto.dat-emis-mdfe),"99")
           c-ano  = STRING(YEAR(mdfe-docto.dat-emis-mdfe),"9999").

    ASSIGN da-tz  = DATETIME-TZ(DATE(c-dia + "/" + c-mes + "/" + c-ano), MTIME, TIMEZONE)
           c-hora = "T" + SUBSTRING(mdfe-docto.hra-emis-mdfe,1,2) + ":" +
                          SUBSTRING(mdfe-docto.hra-emis-mdfe,3,2) + ":" +
                          SUBSTRING(mdfe-docto.hra-emis-mdfe,5,2).
             /*+ SUBSTRING(STRING(da-tz),24,6)*/ .*/

    ASSIGN c-hora = SUBSTRING(mdfe-docto.hra-emis-mdfe,1,2) + ":" +
                    SUBSTRING(mdfe-docto.hra-emis-mdfe,3,2) + ":" +
                    SUBSTRING(mdfe-docto.hra-emis-mdfe,5,2).

    RUN cdp/cd0591.p (INPUT mdfe-docto.cod-estab,
                      INPUT mdfe-docto.dat-emis-mdfe,
                      INPUT c-hora,
                      INPUT NO, /* formatar hora sem aplicar o fuso */
                      OUTPUT p-dh-formatada).

    ASSIGN ttMDFe.dhEmi = SUBSTRING(p-dh-formatada,1,19).


    ASSIGN ttMDFe.UFIni = mdfe-docto.cod-uf-orig
           ttMDFe.UFFim = mdfe-docto.cod-uf-dest.

    autorizados:
    DO i-aux = 1 TO 10:
        IF SUBSTRING(mdfe-docto.cod-livre-1, ((i-aux - 1) * 20) + 1, 20) = "" THEN
            NEXT autorizados.

        CREATE ttCGCAutoriza.
        ASSIGN ttCGCAutoriza.ttMDFeID        = ttMdfe.ttMDFeID
               ttCGCAutoriza.ttCGCAutorizaID = i-aux
               ttCGCAutoriza.cgcAutoriza     = SUBSTRING(mdfe-docto.cod-livre-1, ((i-aux - 1) * 20) + 1, 20).
    END.


   /* FIND FIRST unid-feder NO-LOCK
         WHERE unid-feder.estado = mdfe-docto.cod-uf-orig NO-ERROR.
    IF AVAILABLE unid-feder THEN
        &if '{&bf_dis_versao_ems}' >= '2.07':U
                              &then string(unid-feder.cod-uf-ibge)
                              &else SUBSTRING(unid-feder.char-1,1,2) &endif.

    FIND FIRST unid-feder NO-LOCK
         WHERE unid-feder.estado = mdfe-docto.cod-uf-dest NO-ERROR.
    IF AVAILABLE unid-feder THEN
        ASSIGN ttMDFe.UFFim = &if '{&bf_dis_versao_ems}' >= '2.07':U
                              &then STRING(unid-feder.cod-uf-ibge)
                              &else SUBSTRING(unid-feder.char-1,1,2) &endif.*/

    /*Carregando informa‡äes adicionais*/
    FIND FIRST mdfe-inf-adic NO-LOCK
         WHERE mdfe-inf-adic.cod-estab    = mdfe-docto.cod-estab
           AND mdfe-inf-adic.cod-ser-mdfe = mdfe-docto.cod-ser-mdfe
           AND mdfe-inf-adic.cod-num-mdfe = mdfe-docto.cod-num-mdfe NO-ERROR.
    IF AVAILABLE mdfe-inf-adic THEN DO:
        ASSIGN ttMDFe.infCpl = mdfe-inf-adic.cod-inf-adic.
    END.

    /*Carregando munic¡pios de carregamento do Documento*/
    ASSIGN i-cont = 0.
    FOR EACH mdfe-munic-carreg NO-LOCK
        WHERE mdfe-munic-carreg.cod-estab    = mdfe-docto.cod-estab
        AND   mdfe-munic-carreg.cod-ser-mdfe = mdfe-docto.cod-ser-mdfe
        AND   mdfe-munic-carreg.cod-num-mdfe = mdfe-docto.cod-num-mdfe:

        ASSIGN i-cont = i-cont + 1.
        CREATE ttinfMunCarrega.
        ASSIGN ttinfMunCarrega.ttinfMunCarregaID = i-cont
               ttinfMunCarrega.ttMdfeID          = ttMdfe.ttMDFeID
               ttinfMunCarrega.cMunCarrega       = STRING(mdfe-munic-carreg.cod-munpio-ibge)
               ttinfMunCarrega.xMunCarrega       = mdfe-munic-carreg.nom-munpio.
    END.

    /*Carregando UF de percurso do Documento*/
    ASSIGN i-cont = 0.
    FOR EACH mdfe-percur NO-LOCK
        WHERE mdfe-percur.cod-estab    = mdfe-docto.cod-estab
        AND   mdfe-percur.cod-ser-mdfe = mdfe-docto.cod-ser-mdfe
        AND   mdfe-percur.cod-num-mdfe = mdfe-docto.cod-num-mdfe:

        ASSIGN i-cont = i-cont + 1.

        CREATE ttinfPercurso.
        ASSIGN ttinfPercurso.ttinfPercursoID = i-cont
               ttinfPercurso.ttMdfeID        = ttMdfe.ttMDFeID
               ttinfPercurso.UFPer           = mdfe-percur.cod-uf-percur.
    END.

    CASE mdfe-docto.cod-mod-frete:
        WHEN "1" THEN RUN pi-carrega-dados-rodov.
        WHEN "2" THEN RUN pi-carrega-dados-aereo.
        WHEN "3" THEN RUN pi-carrega-dados-aquav.
        WHEN "4" THEN RUN pi-carrega-dados-ferrov.
    END CASE.

    /*Carregando munic¡pios de descarregamento do Documento*/
    ASSIGN i-cont = 0.
    FOR EACH mdfe-munic-descarreg NO-LOCK
       WHERE mdfe-munic-descarreg.cod-estab    = mdfe-docto.cod-estab
         AND mdfe-munic-descarreg.cod-ser-mdfe = mdfe-docto.cod-ser-mdfe
         AND mdfe-munic-descarreg.cod-num-mdfe = mdfe-docto.cod-num-mdfe:


        CREATE ttinfMunDescarga.
        ASSIGN i-cont = i-cont + 1
               ttinfMunDescarga.ttinfMunDescargaID = i-cont
               ttinfMunDescarga.ttMDFeID           = ttMdfe.ttMDFeID
               ttinfMunDescarga.cMunDescarga       = STRING(mdfe-munic-descarreg.cod-munpio-ibge)
               ttinfMunDescarga.xMunDescarga       = mdfe-munic-descarreg.nom-munpio.
    END.

    ASSIGN i-cont-nfe = 0
           i-cont-nf  = 0
           de-valor-carga = 0
           de-peso-carga  = 0.

    FOR EACH  mdfe-nfe NO-LOCK
        WHERE mdfe-nfe.cod-estab    = mdfe-docto.cod-estab
        AND   mdfe-nfe.cod-ser-mdfe = mdfe-docto.cod-ser-mdfe
        AND   mdfe-nfe.cod-num-mdfe = mdfe-docto.cod-num-mdfe:

        ASSIGN de-valor-carga = de-valor-carga + mdfe-nfe.val-livre-1
               de-peso-carga  = de-peso-carga + mdfe-nfe.val-livre-2.

        IF mdfe-nfe.cod-livre-2 = "" /*Caso não tenha sido informado um munic descarreg, gera no primeiro munic descarreg*/
        OR mdfe-nfe.cod-livre-2 = ? THEN
            FIND FIRST ttinfMunDescarga
                 WHERE ttinfMunDescarga.ttMDFeID = ttMdfe.ttMDFeID NO-LOCK NO-ERROR.
        ELSE
            FIND FIRST ttinfMunDescarga
                 WHERE ttinfMunDescarga.ttMDFeID     = ttMdfe.ttMDFeID
                 AND   ttinfMunDescarga.cMunDescarga = mdfe-nfe.cod-livre-2 NO-LOCK NO-ERROR.

        IF NOT AVAIL ttinfMunDescarga THEN
            FIND FIRST ttinfMunDescarga
                 WHERE ttinfMunDescarga.ttMDFeID = ttMdfe.ttMDFeID NO-LOCK NO-ERROR.
        IF mdfe-nfe.cod-chave-nfe <> "" THEN DO:

            CREATE ttinfNFe.
            ASSIGN i-cont-nfe = i-cont-nfe + 1
                   ttinfNFe.chNFe              = mdfe-nfe.cod-chave-nfe
                   ttInfNfe.SegCodBarra        = IF (SUBSTRING(ttinfNFe.chNFe, 35, 1) = "2" OR SUBSTRING(ttinfNFe.chNFe, 35, 1) = "5") THEN ttinfNFe.chNFe ELSE ""
                   ttInfNfe.ttinfMunDescargaID = ttinfMunDescarga.ttinfMunDescargaID
                   ttInfNfe.ttinfNFeID         = i-cont-nfe.
            
            IF  SUBSTRING(ttinfNFe.chNFe, 35, 1) = "2" OR SUBSTRING(ttinfNFe.chNFe, 35, 1) = "5" THEN DO:
                IF (mdfe-nfe.num-livre-1 = 0 OR mdfe-nfe.num-livre-1 = 1) /*Emissor*/ THEN DO:

                    FIND FIRST nota-fiscal NO-LOCK
                        WHERE nota-fiscal.cod-estabel = mdfe-nfe.cod-estab-nfe
                        AND   nota-fiscal.serie       = mdfe-nfe.cod-ser-nfe
                        AND   nota-fiscal.nr-nota-fis = mdfe-nfe.cod-num-nfe NO-ERROR.
    
                    IF AVAIL nota-fiscal THEN DO:
    
    	                FIND FIRST b-emitente NO-LOCK
                            WHERE b-emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.
    
                        /*Busca Codigo da UF do Destinatario da Nota*/
                        IF  nota-fiscal.pais = "Brasil":U THEN
                            FOR FIRST unid-feder NO-LOCK
                                WHERE unid-feder.pais   = nota-fiscal.pais
                                  AND unid-feder.estado = nota-fiscal.estado:
        
                                ASSIGN c-cod-uf-ibge = (&if  "{&bf_dis_versao_ems}"  >=  "2.07":U
                                                        &then STRING(unid-feder.cod-uf-ibge)
                                                        &else STRING(subSTRING(unid-feder.char-1,1,2))
                                                        &endif).
                            END. /* for first unid-feder no-lock */
                        ELSE 
                            ASSIGN c-cod-uf-ibge = "99".
        
                        ASSIGN d-total-icms    = 0
                               d-total-icms-st = 0.
        
                        FOR EACH  it-nota-fisc NO-LOCK
                            WHERE it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
                            AND   it-nota-fisc.serie       = nota-fiscal.serie
                            AND   it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis,
                            FIRST bf-natur-oper-it NO-LOCK
                            WHERE bf-natur-oper-it.nat-operacao = it-nota-fisc.nat-operacao,
                            FIRST ITEM NO-LOCK
                            WHERE ITEM.it-codigo = it-nota-fisc.it-codigo:
        
                            /*ICMS Outras*/
                            ASSIGN l-icms-outras-it = (&if '{&bf_dis_versao_ems}' >= '2.08' &then
                                                       bf-natur-oper-it.log-consid-icms-outras
                                                       &else
                                                       IF SUBSTRING(bf-natur-oper-it.char-1,148,1) = "S":U THEN YES ELSE NO
                                                       &endif).
                                                       
                            FOR FIRST item-uni-estab NO-LOCK
                                 WHERE item-uni-estab.it-codigo   = it-nota-fisc.it-codigo
                                   AND item-uni-estab.cod-estabel = it-nota-fisc.cod-estabel :
        
                                IF &IF "{&bf_dis_versao_ems}" >= "2.09" &THEN 
                                   TRIM(STRING(item-uni-estab.num-origem))
                                   &ELSE 
                                   TRIM(SUBSTRING(item-uni-estab.char-2,18,3)) &ENDIF
                                   <> "":U THEN DO:
                         
                                    &IF "{&bf_dis_versao_ems}" >= "2.09" &THEN
                                        ASSIGN i-codigo-orig-estab = item-uni-estab.num-origem.
                                    &ELSE
                                        ASSIGN i-codigo-orig-estab = INT(TRIM(SUBSTRING(item-uni-estab.char-2,18,3))).
                                    &ENDIF
                                END.
                            END.    
                         
                            &IF "{&bf_dis_versao_ems}":U >= "2.09":U &THEN
                                ASSIGN i-codigo-orig = IF  it-nota-fisc.num-origem <> ? THEN  
                                                           it-nota-fisc.num-origem
                                                       ELSE IF i-codigo-orig-estab <> ? THEN
                                                               i-codigo-orig-estab
                                                            ELSE ITEM.codigo-orig.
                            &ELSE
                                IF  SUBSTRING(it-nota-fisc.char-1,180,3) <> "" THEN
                                    ASSIGN i-codigo-orig = INT(SUBSTRING(it-nota-fisc.char-1,180,3)).
                                ELSE
                                    ASSIGN i-codigo-orig = IF i-codigo-orig-estab <> ? THEN
                                                              i-codigo-orig-estab
                                                           ELSE ITEM.codigo-orig.
                            &ENDIF
        
        
                            ASSIGN i-niv-trib-icms = 0
                                   c-niv-trib-icms = "".
                        
                            RUN ftp/ft0515a.p (INPUT  ROWID(it-nota-fisc), 
                                               OUTPUT i-niv-trib-icms,      
                                               OUTPUT l-sub).
                        
                            /* CST -> Codigo da Situacao Tributaria (conforme DANFE): Codigo Origem + Nivel Tributacao ICMS */
                            ASSIGN i-niv-trib-icms = INT(STRING(i-codigo-orig) + STRING(i-niv-trib-icms, "99")) WHEN AVAIL item
                                   c-niv-trib-icms = string(i-niv-trib-icms,"999").
        
                            ASSIGN d-total-icms    = d-total-icms  + (IF  {&log-icms-substto-antecip} 
                                                                      THEN 0
                                                                      ELSE (IF (it-nota-fisc.cd-trib-icm = 1                                                                     /*Tributado*/
                                                                            OR (it-nota-fisc.cd-trib-icm = 3 AND l-icms-outras-it AND SUBSTRING(c-niv-trib-icms,2,2) <> "51":U)  /*Outras e Considera Tributos Outras na NF-e */  /*CST = 51 (DIFERIDO) NÆo deve ser considerado nos totais da Base de C lculo*/
                                                                            OR  it-nota-fisc.cd-trib-icm = 4)
                                                                            THEN it-nota-fisc.vl-icms-it
                                                                            ELSE 0))
                                   d-total-icms-st = d-total-icms-st + (IF  {&log-icms-substto-antecip}
                                                                        THEN 0
                                                                        ELSE it-nota-fisc.vl-icmsub-it).
        
                        END.
        
                        ASSIGN c-chave-acesso-adicional-nfe = /* cUF      */  STRING(INT(c-cod-uf-ibge), '99') + 
                                                              /* tpEmis   */  TRIM(SUBSTRING(ttinfNFe.chNFe, 35, 1)) +
                                                              /* CNPJ/CPF */  (if length(b-emitente.cgc) = 9 then "000" + b-emitente.cgc else UPPER(b-emitente.cgc)) +
                                                              /* vNF      */  STRING(nota-fiscal.vl-tot-nota * 100, '99999999999999') + 
                                                              /* ICMSp    */  (IF  d-total-icms > 0 
                                                                               THEN "1"
                                                                               ELSE "2") +
                                                              /* ICMSs    */  (IF  d-total-icms-st > 0
                                                                               THEN "1"
                                                                               ELSE "2") +  
                                                              /* DD       */  STRING(DAY(nota-fiscal.dt-emis-nota),"99").
        
                        ASSIGN i-mult-nfe = 2.
        
                        DO  i-count-nfe = LENGTH(c-chave-acesso-adicional-nfe) TO 1 BY -1:
                            ASSIGN i-soma-mod-nfe = i-soma-mod-nfe + ((asc(substr(c-chave-acesso-adicional-nfe,i-count-nfe,1)) - 48) * i-mult-nfe).
        
                            ASSIGN i-mult-nfe = i-mult-nfe + 1.
                            IF i-mult-nfe = 10 THEN ASSIGN i-mult-nfe = 2.
                        END.
        
                        IF i-soma-mod-nfe MODULO 11 = 0 OR
                           i-soma-mod-nfe MODULO 11 = 1 THEN ASSIGN i-dig-ver-nfe = 0.
                                                        ELSE ASSIGN i-dig-ver-nfe = 11 - (i-soma-mod-nfe MODULO 11).
        
                        ASSIGN c-chave-acesso-adicional-nfe = c-chave-acesso-adicional-nfe + STRING(i-dig-ver-nfe) /* DV */
                               ttInfNfe.SegCodBarra         = c-chave-acesso-adicional-nfe.
    
                    END.
                END.
                ELSE DO:
                    FOR FIRST unid-feder NO-LOCK
                        WHERE unid-feder.pais   = "Brasil"
                          AND unid-feder.estado = trim(SUBSTRING(mdfe-nfe.cod-livre-3,1,2)):

                        ASSIGN c-cod-uf-ibge = (&if  "{&bf_dis_versao_ems}"  >=  "2.07":U
                                                &then STRING(unid-feder.cod-uf-ibge)
                                                &else STRING(subSTRING(unid-feder.char-1,1,2))
                                                &endif).
                    END.

                    ASSIGN c-chave-acesso-adicional-nfe = /* cUF      */  STRING(INT(c-cod-uf-ibge), '99') + 
                                                          /* tpEmis   */  TRIM(SUBSTRING(ttinfNFe.chNFe, 35, 1)) +
                                                          /* CNPJ/CPF */  STRING(TRIM(REPLACE(REPLACE(REPLACE(SUBSTRING(ttinfNFe.chNFe, 7, 14),".",""),"-",""),"/","")), 'XXXXXXXXXXXX99') +
                                                          /* vNF      */  STRING(mdfe-nfe.val-livre-1 * 100, '99999999999999') + 
                                                          /* ICMSp    */  "11" +  
                                                          /* DD       */  STRING(DAY(mdfe-nfe.dat-livre-1),"99").
    
                    ASSIGN i-mult-nfe = 2.
    
                    DO  i-count-nfe = LENGTH(c-chave-acesso-adicional-nfe) TO 1 BY -1:
                        ASSIGN i-soma-mod-nfe = i-soma-mod-nfe + ((asc(substr(c-chave-acesso-adicional-nfe,i-count-nfe,1)) - 48) * i-mult-nfe).
    
                        ASSIGN i-mult-nfe = i-mult-nfe + 1.
                        IF i-mult-nfe = 10 THEN ASSIGN i-mult-nfe = 2.
                    END.
    
                    IF i-soma-mod-nfe MODULO 11 = 0 OR
                       i-soma-mod-nfe MODULO 11 = 1 THEN ASSIGN i-dig-ver-nfe = 0.
                                                    ELSE ASSIGN i-dig-ver-nfe = 11 - (i-soma-mod-nfe MODULO 11).
    
                    ASSIGN c-chave-acesso-adicional-nfe = c-chave-acesso-adicional-nfe + STRING(i-dig-ver-nfe) /* DV */
                           ttInfNfe.SegCodBarra         = c-chave-acesso-adicional-nfe.

                END.
            END.
        END.
        ELSE DO:
            CREATE ttinfNF.
            ASSIGN i-cont-nf = i-cont-nf + 1
                   ttinfNF.CNPJ                = UPPER(estabelec.cgc) /*Verificar se ‚ este ou o do cliente*/
                   ttinfNF.PIN                 = STRING(mdfe-nfe.cod-pin)
                   ttInfNF.dEmi                = mdfe-nfe.dat-livre-1
                   ttInfNF.nNF                 = STRING(mdfe-nfe.cod-num-nfe)
                   ttInfNf.serie               = STRING(mdfe-nfe.cod-ser-nfe)
                   ttInfNf.ttinfMunDescargaID  = ttinfMunDescarga.ttinfMunDescargaID
                   ttInfNf.ttinfNFID           = i-cont-nf
                   ttInfNf.UF                  = SUBSTRING(mdfe-nfe.cod-livre-3,1,2)
                   ttInfNF.vNF                 = mdfe-nfe.val-livre-2.
        END.
    END.

    ASSIGN ttMdfe.vCarga = de-valor-carga
           ttMdfe.qCarga = de-peso-carga
           ttMdfe.qCte   = '0'
           ttMDFe.qCT    = '0'
           ttMDFe.qNFe   = STRING(i-cont-nfe)
           ttMDFe.qNF    = STRING(i-cont-nf).

    IF VALID-HANDLE(h-cdapi704) THEN
        DELETE OBJECT h-cdapi704.
END.






PROCEDURE pi-carrega-dados-rodov.


    FIND FIRST mdfe-rodov NO-LOCK
         WHERE mdfe-rodov.cod-estab  = mdfe-docto.cod-estab
           AND mdfe-rodov.cod-ser-mdfe = mdfe-docto.cod-ser-mdfe
           AND mdfe-rodov.cod-num-mdfe = mdfe-docto.cod-num-mdfe NO-ERROR.

    FIND FIRST mdfe-veic NO-LOCK
         WHERE mdfe-veic.cod-inter-veic = mdfe-rodov.cod-veic NO-ERROR.
    IF AVAILABLE mdfe-veic THEN DO:

        ASSIGN ttMdfe.cInt         = mdfe-veic.cod-inter-veic
               ttMdfe.placa        = mdfe-veic.cod-placa
               ttMdfe.tara         = STRING(TRUNCATE(DEC(mdfe-veic.cod-tara    ),0),">>>>>9")   /* Para pegar apenas a parte inteira, sem decimais */
               ttMdfe.capKG        = STRING(TRUNCATE(DEC(mdfe-veic.cod-capac-kg),0),">>>>>9")   /* Para pegar apenas a parte inteira, sem decimais */
               ttMdfe.capM3        = STRING(TRUNCATE(DEC(mdfe-veic.cod-capac-m3),0),">>9")      /* Para pegar apenas a parte inteira, sem decimais */
               ttMdfe.RNTRC        = STRING(INT(mdfe-veic.cod-rntrc), "99999999")
               ttMdfe.cgcProp      = UPPER(RIGHT-TRIM(SUBSTRING(mdfe-veic.cod-livre-1,1,20)))
               ttMdfe.nomeProp     = RIGHT-TRIM(SUBSTRING(mdfe-veic.cod-livre-1,21,100))
               ttMdfe.ieProp       = RIGHT-TRIM(SUBSTRING(mdfe-veic.cod-livre-1,121,20))
               ttMdfe.ufProp       = RIGHT-TRIM(SUBSTRING(mdfe-veic.cod-livre-1,141,5))
               ttMdfe.tpProp       = SUBSTRING(mdfe-veic.cod-livre-1,146,1)
               ttMdfe.tpRod        = STRING(INT(SUBSTRING(mdfe-veic.cod-livre-1,151,1)), "99")
               ttMdfe.tpCar        = STRING(INT(SUBSTRING(mdfe-veic.cod-livre-1,156,1)), "99")
               ttMdfe.ufVeicLicenc = RIGHT-TRIM(SUBSTRING(mdfe-veic.cod-livre-1,161,5)) NO-ERROR.
    END.

    ASSIGN ttMDFe.CIOT  = ""
           i-cont       = 0.

    FOR EACH mdfe-condut NO-LOCK
       WHERE mdfe-condut.cod-estab    = mdfe-docto.cod-estab
         AND mdfe-condut.cod-ser-mdfe = mdfe-docto.cod-ser-mdfe
         AND mdfe-condut.cod-num-mdfe = mdfe-docto.cod-num-mdfe:

        CREATE ttCondutor.
        ASSIGN i-cont = i-cont + 1
               ttCondutor.cpf          = mdfe-condut.cod-cpf
               ttCondutor.ttcondutorID = i-Cont
               ttCondutor.ttMdfeID     = ttMdfe.ttMdfeID
               ttCondutor.xNome        = mdfe-condut.nom-condut.

    END.

    IF mdfe-rodov.cod-veic-1 <> "" THEN DO:
        FIND FIRST mdfe-veic NO-LOCK
             WHERE mdfe-veic.cod-inter-veic = mdfe-rodov.cod-veic-1 NO-ERROR.
        IF AVAILABLE mdfe-veic THEN DO:
            CREATE ttveicReboque.
            ASSIGN ttVeicReboque.ttveicReboqueID = 1
                   ttVeicReboque.ttMdfeID        = ttMdfe.ttMdfeID
                   ttVeicReboque.cInt            = mdfe-veic.cod-inter-veic
                   ttVeicReboque.placa           = mdfe-veic.cod-placa
                   ttVeicReboque.tara            = mdfe-veic.cod-tara
                   ttVeicReboque.capKG           = mdfe-veic.cod-capac-kg
                   ttVeicReboque.capM3           = mdfe-veic.cod-capac-m3
                   ttVeicReboque.RNTRC           = STRING(INT(mdfe-veic.cod-rntrc), "99999999")
                   ttVeicReboque.cgcProp         = UPPER(RIGHT-TRIM(SUBSTRING(mdfe-veic.cod-livre-1,1,20)))
                   ttVeicReboque.nomeProp        = RIGHT-TRIM(SUBSTRING(mdfe-veic.cod-livre-1,21,100))
                   ttVeicReboque.ieProp          = RIGHT-TRIM(SUBSTRING(mdfe-veic.cod-livre-1,121,20))
                   ttVeicReboque.ufProp          = RIGHT-TRIM(SUBSTRING(mdfe-veic.cod-livre-1,141,5))
                   ttVeicReboque.tpProp          = SUBSTRING(mdfe-veic.cod-livre-1,146,1)
                   ttVeicReboque.tpCar           = STRING(INT(SUBSTRING(mdfe-veic.cod-livre-1,156,1)), "99")
                   ttVeicReboque.ufVeicLicenc    = RIGHT-TRIM(SUBSTRING(mdfe-veic.cod-livre-1,161,5)).
        END.
    END.

    ASSIGN i-cont = 0.
    FOR EACH mdfe-pedag NO-LOCK
       WHERE mdfe-pedag.cod-estab    = mdfe-docto.cod-estab
         AND mdfe-pedag.cod-ser-mdfe = mdfe-docto.cod-ser-mdfe
         AND mdfe-pedag.cod-num-mdfe = mdfe-docto.cod-num-mdfe:

        CREATE ttdisp.
        ASSIGN i-cont = i-cont + 1
               ttdisp.CNPJForn = mdfe-pedag.cod-cnpj-fornec
               ttdisp.CNPJPg   = mdfe-pedag.cod-cnpj-pagto
               ttdisp.nCompra  = mdfe-pedag.cod-num-compra
               ttdisp.ttdispID = i-cont
               ttdisp.ttMDFeID = ttMdfe.ttMdfeID.

    END.

END PROCEDURE.




PROCEDURE pi-carrega-dados-aereo.


    FIND FIRST mdfe-aereo NO-LOCK
         WHERE mdfe-aereo.cod-estab    = mdfe-docto.cod-estab
           AND mdfe-aereo.cod-ser-mdfe = mdfe-docto.cod-ser-mdfe
           AND mdfe-aereo.cod-num-mdfe = mdfe-docto.cod-num-mdfe NO-ERROR.

    IF AVAILABLE mdfe-aereo THEN DO:

        ASSIGN ttMDFe.nac      = mdfe-aereo.cod-nacion-aero
               ttMDFe.matr     = mdfe-aereo.cod-num-aero
               ttMDFe.nVoo     = mdfe-aereo.cod-num-voo
               ttMDFe.cAerEmb  = mdfe-aereo.cod-aero-embarq
               ttMDFe.cAerDes  = mdfe-aereo.cod-aero-desembar
               ttMDFe.dVoo     = mdfe-aereo.dat-voo.

    END.


END PROCEDURE.



PROCEDURE pi-carrega-dados-aquav.

    FIND FIRST mdfe-aquav NO-LOCK
         WHERE mdfe-aquav.cod-estab    = mdfe-docto.cod-estab
           AND mdfe-aquav.cod-ser-mdfe = mdfe-docto.cod-ser-mdfe
           AND mdfe-aquav.cod-num-mdfe = mdfe-docto.cod-num-mdfe NO-ERROR.

    IF AVAILABLE mdfe-aquav THEN DO:

        ASSIGN ttMDFe.CNPJAgeNav = mdfe-aquav.cod-cnpj-agenc-naveg
               ttMDFe.tpEmb      = mdfe-aquav.cod-tip-embcacao
               ttMDFe.cEmbar     = mdfe-aquav.cod-embcacao
               ttMDFe.xEmbar     = mdfe-aquav.cod-embcacao
               ttMDFe.nViag      = mdfe-aquav.cod-num-viagem
               ttMDFe.cPrtEmb    = mdfe-aquav.cod-porto-embarq
               ttMDFe.cPrtDest   = mdfe-aquav.cod-porto-desembar.

    END.

    ASSIGN i-cont = 0.
    FOR EACH mdfe-terminal-carreg NO-LOCK
       WHERE mdfe-terminal-carreg.cod-estab = mdfe-docto.cod-estab
         AND mdfe-terminal-carreg.cod-ser-mdfe = mdfe-docto.cod-ser-mdfe
         AND mdfe-terminal-carreg.cod-num-mdfe = mdfe-docto.cod-num-mdfe:

            CREATE ttinfTermCarreg.
            ASSIGN i-cont = i-cont + 1
                   ttinfTermCarreg.ttInfTermCarregID = i-cont
                   ttinfTermCarreg.ttMdfeID          = ttMdfe.ttMdfeID
                   ttinfTermCarreg.cTermCarreg       = mdfe-terminal-carreg.cod-terminal-carreg.

    END.

    ASSIGN i-cont = 0.
    FOR EACH mdfe-terminal-descarreg NO-LOCK
       WHERE mdfe-terminal-descarreg.cod-estab = mdfe-docto.cod-estab
         AND mdfe-terminal-descarreg.cod-ser-mdfe = mdfe-docto.cod-ser-mdfe
         AND mdfe-terminal-descarreg.cod-num-mdfe = mdfe-docto.cod-num-mdfe:

            CREATE ttinfTermdescarreg.
            ASSIGN i-cont = i-cont + 1
                   ttinfTermdescarreg.ttInfTermDesCarregID = i-cont
                   ttinfTermdescarreg.ttMdfeID             = ttMdfe.ttMdfeID
                   ttinfTermdescarreg.cTermDescarreg       = mdfe-terminal-descarreg.cod-terminal-descarreg.

    END.

    ASSIGN i-cont = 0.
    FOR EACH mdfe-embcacao NO-LOCK
       WHERE mdfe-embcacao.cod-estab = mdfe-docto.cod-estab
         AND mdfe-embcacao.cod-ser-mdfe = mdfe-docto.cod-ser-mdfe
         AND mdfe-embcacao.cod-num-mdfe = mdfe-docto.cod-num-mdfe:

        CREATE ttinfEmbComb.
        ASSIGN i-cont = i-cont + 1
               ttinfEmbComb.ttinfEmbCombID = i-cont
               ttinfEmbComb.ttMdfeID       = ttMdfe.ttMdfeID
               ttinfEmbComb.cEmbComb       = mdfe-embcacao.cod-embcacao-comboio.

    END.


END PROCEDURE.



PROCEDURE pi-carrega-dados-ferrov.

    FIND FIRST mdfe-ferrovia NO-LOCK
         WHERE mdfe-ferrovia.cod-estab = mdfe-docto.cod-estab
           AND mdfe-ferrovia.cod-ser-mdfe = mdfe-docto.cod-ser-mdfe
           AND mdfe-ferrovia.cod-num-mdfe = mdfe-docto.cod-num-mdfe NO-ERROR.
    IF AVAILABLE mdfe-ferrovia THEN DO:

        ASSIGN ttMDFe.xPref   = mdfe-ferrovia.cod-prefix-trem
               ttMDFe.xOri    = mdfe-ferrovia.cod-orig-trem
               ttMDFe.xDest   = mdfe-ferrovia.cod-dest-trem
               ttMDFe.qVag    = STRING(mdfe-ferrovia.num-quant-vagao).

        ASSIGN c-dia  = STRING(day(mdfe-ferrovia.dat-liber-trem),"99")
               c-mes  = STRING(month(mdfe-ferrovia.dat-liber-trem),"99")
               c-ano  = STRING(year(mdfe-ferrovia.dat-liber-trem),"9999").

        ASSIGN da-tz  = DATETIME-TZ(DATE(c-dia + "/" + c-mes + "/" + c-ano), MTIME, TIMEZONE)
               c-hora = "T" + SUBSTRING(mdfe-docto.hra-emis-mdfe,1,2) + ":" +
                              SUBSTRING(mdfe-docto.hra-emis-mdfe,3,2) + ":" +
                              SUBSTRING(mdfe-docto.hra-emis-mdfe,5,2).
        ASSIGN ttMDFe.dhTrem  = c-ano + "-" + c-mes + "-" + c-dia + c-hora.


    END.


    ASSIGN i-cont = 0.
    FOR EACH mdfe-trem NO-LOCK
       WHERE mdfe-trem.cod-estab    = mdfe-docto.cod-estab
         AND mdfe-trem.cod-ser-mdfe = mdfe-docto.cod-ser-mdfe
         AND mdfe-trem.cod-num-mdfe = mdfe-docto.cod-num-mdfe:

        CREATE ttvag.
        ASSIGN i-cont = i-cont + 1
               ttvag.ttvagID  = i-cont
               ttvag.ttMdfeID = ttMdfe.ttMdfeID
               ttvag.serie    = STRING(mdfe-trem.cod-ser-vagao)
               ttvag.nVag     = mdfe-trem.cod-num-vagao
               ttvag.nSeq     = STRING(mdfe-trem.num-seq-vagao)
               ttvag.TU       = DECIMAL(mdfe-trem.cod-capac-tonel).

    END.

END PROCEDURE.


PROCEDURE pi-integra-XML.

    DEFINE VARIABLE h-TSSAPI             AS HANDLE NO-UNDO.
    DEFINE VARIABLE lEnvioNotaTSSOK      AS LOGICAL NO-UNDO.
    DEFINE VARIABLE hXMLMDFe             AS HANDLE      NO-UNDO.
    DEFINE VARIABLE cArquivoHistoricoXML AS CHARACTER   NO-UNDO.
    /* TOTVS COLAB 2.0 */
    
    ASSIGN lcXMLMDFe = "".

    RUN cdp/cd0360b.p (INPUT mdfe-docto.cod-estab,
                       INPUT "MDF-e",
                       OUTPUT cTpTrans ).

    /* RESETA OS VALORES */
    RUN reset IN hGenXml.

    /* SETA VALOR DE ENCODING */
    RUN setEncoding IN hGenXml ("UTF-8").

    RUN adapters/xml/ep2/axsep021imprimexml.p (INPUT hGenXml,
                                               INPUT-OUTPUT TABLE ttStack,
                                               INPUT TABLE ttcondutor,
                                               INPUT TABLE ttdisp,
                                               INPUT TABLE ttinfCT,
                                               INPUT TABLE ttinfCTe,
                                               INPUT TABLE ttinfEmbComb,
                                               INPUT TABLE ttinfMunCarrega,
                                               INPUT TABLE ttinfMunDescarga,
                                               INPUT TABLE ttinfNF,
                                               INPUT TABLE ttinfNFe,
                                               INPUT TABLE ttinfPercurso,
                                               INPUT TABLE ttinfTermCarreg,
                                               INPUT TABLE ttinfTermDescarreg,
                                               INPUT TABLE ttinfUnidCarga,
                                               INPUT TABLE ttinfUnidCarga_00,
                                               INPUT TABLE ttinfUnidCarga_01,
                                               INPUT TABLE ttinfUnidCarga_02,
                                               INPUT TABLE ttinfUnidTransp,
                                               INPUT TABLE ttinfUnidTransp_00,
                                               INPUT TABLE ttinfUnidTransp_01,
                                               INPUT TABLE ttinfUnidTransp_02,
                                               INPUT TABLE ttlacres,
                                               INPUT TABLE ttlacUnidCarga,
                                               INPUT TABLE ttlacUnidCarga_00,
                                               INPUT TABLE ttlacUnidCarga_01,
                                               INPUT TABLE ttlacUnidCarga_02,
                                               INPUT TABLE ttlacUnidTransp,
                                               INPUT TABLE ttlacUnidTransp_00,
                                               INPUT TABLE ttlacUnidTransp_01,
                                               INPUT TABLE ttlacUnidTransp_02,
                                               INPUT TABLE ttMDFe,
                                               INPUT TABLE ttvag,
                                               INPUT TABLE ttveicReboque,
                                               INPUT TABLE ttCGCAutoriza /*Novas TAGS*/ ).

    RUN generateXML IN hGenXml (OUTPUT hXMLMDFe).

    /* retirar o inicio do XML "<?xml version="1.0" encoding="utf-8" ?>" */
    /* para nao gerar erro na integra‡Æo com o TSS                       */
    hXMLMDFe:SAVE("LONGCHAR",lcXMLMDFe).

    ASSIGN lcXMLMDFe = SUBSTR(lcXMLMDFe, INDEX(lcXMLMDFe, "<MDFe xmlns=")).

    /*Totvs Colabora‡Æo 2.00*/
    IF  cTpTrans = "TC2":U THEN DO:

        EMPTY TEMP-TABLE tt-erro.

        RUN cdp/cdapi590.p (INPUT 360, /* MDF-e Î EmissÆo */
                            INPUT hXMLMDFe,
                            INPUT mdfe-docto.cod-chave-mdfe,
                            OUTPUT TABLE tt-erro).
        FOR EACH tt-erro:
            CREATE TT_LOG_ERRO.
            ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = tt-erro.cd-erro
                   TT_LOG_ERRO.TTV_DES_MSG_ERRO  = tt-erro.mensagem
                   TT_LOG_ERRO.TTV_DES_MSG_AJUDA = tt-erro.mensagem.
        END.
        RETURN "OK":U.
    END.

    FIND FIRST param-nf-estab NO-LOCK
         WHERE param-nf-estab.cod-estabel = estabelec.cod-estabel NO-ERROR.


    IF NOT VALID-HANDLE(h-TSSAPI) THEN DO:
        RUN ftp/ftapi511.p PERSISTENT SET h-TSSAPI. /*API de comunica»’o com o TSS*/
    END.

    /****** GRAVA HISTORICO XML EM DIRETORIO ******/
    ASSIGN cArquivoHistoricoXML = TRIM(mdfe-param.cod-dir-xml-histor-mdfe)
           cArquivoHistoricoXML = REPLACE(cArquivoHistoricoXML,"~\","/").

    IF  cArquivoHistoricoXML <> "" THEN DO:
        IF  NOT SUBSTR(cArquivoHistoricoXML,LENGTH(cArquivoHistoricoXML),LENGTH(cArquivoHistoricoXML) - 1) = "/"  THEN
            ASSIGN cArquivoHistoricoXML = cArquivoHistoricoXML + "/".

        ASSIGN cArquivoHistoricoXML =  cArquivoHistoricoXML
                                     + mdfe-param.cod-estabel + SUBSTR(mdfe-docto.cod-chave-mdfe,23,3) + TRIM(STRING(INTEGER(SUBSTR(mdfe-docto.cod-chave-mdfe,26,9)),">>9999999"))
                                     + "/".

        ASSIGN FILE-INFO:FILE-NAME = cArquivoHistoricoXML.
        IF  FILE-INFO:FULL-PATHNAME = ? THEN
            OS-CREATE-DIR value(cArquivoHistoricoXML) NO-ERROR. /* cria o diretorio caso nao exista */

        ASSIGN cArquivoHistoricoXML =   cArquivoHistoricoXML
                                      + STRING(YEAR(TODAY),"9999")              /* ex: 2010   (Ano)       */
                                      + STRING(MONTH(TODAY),"99")               /* ex: 05     (Mes Maio)  */
                                      + STRING(DAY(TODAY),"99")                 /* ex: 01     (Dia)       */
                                      + REPLACE(STRING(TIME,"HH:MM:SS"),":","") /* Ex: 140105 (14h01m05s) */
                                      + ".xml":U.

        hXMLMDFe:SAVE ('FILE', cArquivoHistoricoXML) NO-ERROR.
    END.
    /*** FIM - GRAVA HISTORICO XML EM DIRETORIO ***/


    RUN setTSSURL IN h-TSSAPI (&if "{&bf_dis_versao_ems}" >= "2.08" &then
                                   TRIM(param-nf-estab.cod-url-ws-tss)
                               &else
                                   TRIM(SUBSTR(param-nf-estab.cod-livre-1,1,100))
                               &endif).
                               
    RUN setTSSAuthParam IN h-TSSAPI (INPUT 1,
                                     INPUT "*",
                                     INPUT param-nf-estab.cod-estabel,
                                     INPUT param-nf-estab.cod-url-ws-tss).
    
    EMPTY TEMP-TABLE ttNFETSS.
    EMPTY TEMP-TABLE ttNFETSSRet.
    EMPTY TEMP-TABLE ttNFES4.
    EMPTY TEMP-TABLE TT_LOG_ERRO.

    CREATE ttNFETSS.
    ASSIGN ttNFETSS.ID  = ttMDFe.cMDF
           ttNFETSS.XML = lcXMLMDFe.

    RUN NFESBRA_REMESSA IN h-TSSAPI (param-nf-estab.ind-empresa,
                                     INPUT BUFFER ttNFETSS:HANDLE,
                                     INPUT BUFFER ttNFETSSRet:HANDLE,
                                     YES). /* Criptografa XML BASE64 - Yes/No */

    ASSIGN cReturnValue = RETURN-VALUE.

    RUN disconnectTss IN h-TSSAPI ("NFESBRA").

    IF  cReturnValue <> "OK" THEN DO:
        CREATE TT_LOG_ERRO.
        ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 36370.

        /*Busca Mensagem*/
        RUN utp/ut-msgs.p (INPUT "MSG":U,
                           INPUT 36370,
                           INPUT "[TSS REMESSA]" + "~~" + cReturnValue).
        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE.

        /*Busca Help */
        RUN utp/ut-msgs.p (INPUT "HELP":U,
                           INPUT 36370,
                           INPUT "[TSS REMESSA]" + "~~" + cReturnValue).
        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_AJUDA = RETURN-VALUE.
    END.
    ELSE DO:
        FOR EACH ttNFETSSRet:
            IF  TRIM(ttNFETSSRet.STR) = TRIM(ttMDFe.cMDF) THEN
                ASSIGN lEnvioNotaTSSOK = YES.
        END.

        IF  NOT lEnvioNotaTSSOK THEN DO:
            /* NAO CRIOU A NOTA NO TSS, VERIFICAR ATRAVES DO METODO SCHEMA QUAL FOI O MOTIVO DE REJEICAO DA NOTA */
            EMPTY TEMP-TABLE ttNFETSS.

            CREATE ttNFETSS.
            ASSIGN ttNFETSS.ID  = ttMDFe.cMDF
                   ttNFETSS.XML = lcXMLMDFe.

            RUN NFESBRA_SCHEMA  IN h-TSSAPI (param-nf-estab.ind-empresa,
                                             INPUT BUFFER ttNFETSS:HANDLE,
                                             INPUT BUFFER ttNFES4:HANDLE,
                                             YES). /* Criptografa XML BASE64 - Yes/No */
            ASSIGN cReturnValue = RETURN-VALUE.

            RUN disconnectTss IN h-TSSAPI ("NFESBRA").

            IF  cReturnValue <> "OK" THEN DO:

                CREATE TT_LOG_ERRO.
                ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 36370.

                /*Busca Mensagem*/
                RUN utp/ut-msgs.p (INPUT "MSG":U,
                                   INPUT 36370,
                                   INPUT "[TSS SCHEMA]" + "~~" + cReturnValue).
                ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE.

                /*Busca Help */
                RUN utp/ut-msgs.p (INPUT "HELP":U,
                                   INPUT 36370,
                                   INPUT "[TSS SCHEMA]" + "~~" + cReturnValue).
                ASSIGN TT_LOG_ERRO.TTV_DES_MSG_AJUDA = RETURN-VALUE.

            END.
            ELSE DO:
                FOR EACH ttNFES4
                    WHERE ttNFES4.MENSAGEM <> "":

                    CREATE TT_LOG_ERRO.
                    ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 36372.

                    /*Busca Mensagem*/
                    RUN utp/ut-msgs.p (INPUT "MSG":U,
                                       INPUT 36372,
                                       INPUT mdfe-docto.cod-num-mdfe + "~~" + ttNFES4.MENSAGEM).
                    ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE.

                    /*Busca Help */
                    RUN utp/ut-msgs.p (INPUT "HELP":U,
                                       INPUT 36372,
                                       INPUT mdfe-docto.cod-num-mdfe + "~~" + ttNFES4.MENSAGEM).
                    ASSIGN TT_LOG_ERRO.TTV_DES_MSG_AJUDA = RETURN-VALUE.

                    IF AVAIL mdfe-docto THEN DO:
                        /*Ao dar erro de estrutura, estava sendo salvo o retorno, porem não estava mostrando a mensagem*/
                        FOR LAST  mdfe-ret EXCLUSIVE-LOCK
                            WHERE mdfe-ret.cod-estab    = mdfe-docto.cod-estab
                            AND   mdfe-ret.cod-ser-mdfe = mdfe-docto.cod-ser-mdfe
                            AND   mdfe-ret.cod-num-mdfe = mdfe-docto.cod-num-mdfe
                            AND   (TRIM(mdfe-ret.cod-msg) = ""
                                    OR  mdfe-ret.cod-msg  = ?):

                            ASSIGN mdfe-ret.cod-livre-1 = "36372"
                                   mdfe-ret.cod-livre-2 = TT_LOG_ERRO.TTV_DES_MSG_ERRO.

                        END.
                    END.
                END.
            END. /* ELSE DO: IF  RETURN-VALUE <> "OK" THEN DO: */
        END. /* IF  NOT lEnvioNotaTSSOK THEN DO: */
    END. /* ELSE DO: IF  RETURN-VALUE <> "OK" THEN DO: */

    IF  VALID-HANDLE(h-TSSAPI) THEN DO:
        DELETE PROCEDURE h-TSSAPI.
        ASSIGN h-TSSAPI = ?.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-limpa-temp-tables.
EMPTY TEMP-TABLE ttcondutor.
EMPTY TEMP-TABLE ttdisp.
EMPTY TEMP-TABLE ttinfCT.
EMPTY TEMP-TABLE ttinfCTe.
EMPTY TEMP-TABLE ttinfEmbComb.
EMPTY TEMP-TABLE ttinfMunCarrega.
EMPTY TEMP-TABLE ttinfMunDescarga.
EMPTY TEMP-TABLE ttinfNF.
EMPTY TEMP-TABLE ttinfNFe.
EMPTY TEMP-TABLE ttinfPercurso.
EMPTY TEMP-TABLE ttinfTermCarreg.
EMPTY TEMP-TABLE ttinfTermDescarreg.
EMPTY TEMP-TABLE ttinfUnidCarga.
EMPTY TEMP-TABLE ttinfUnidCarga_00.
EMPTY TEMP-TABLE ttinfUnidCarga_01.
EMPTY TEMP-TABLE ttinfUnidCarga_02.
EMPTY TEMP-TABLE ttinfUnidTransp.
EMPTY TEMP-TABLE ttinfUnidTransp_00.
EMPTY TEMP-TABLE ttinfUnidTransp_01.
EMPTY TEMP-TABLE ttinfUnidTransp_02.
EMPTY TEMP-TABLE ttlacres.
EMPTY TEMP-TABLE ttlacUnidCarga.
EMPTY TEMP-TABLE ttlacUnidCarga_00.
EMPTY TEMP-TABLE ttlacUnidCarga_01.
EMPTY TEMP-TABLE ttlacUnidCarga_02.
EMPTY TEMP-TABLE ttlacUnidTransp.
EMPTY TEMP-TABLE ttlacUnidTransp_00.
EMPTY TEMP-TABLE ttlacUnidTransp_01.
EMPTY TEMP-TABLE ttlacUnidTransp_02.
EMPTY TEMP-TABLE ttMDFe.
EMPTY TEMP-TABLE ttvag.
EMPTY TEMP-TABLE ttveicReboque.
EMPTY TEMP-TABLE tt_log_erro.


END PROCEDURE.
