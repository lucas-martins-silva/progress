PROCEDURE pi-localiza-tabelas:
    
    DEF VAR l-uf-iest AS LOGICAL INITIAL NO NO-UNDO.
    
    ASSIGN cCodEstabel = nota-fiscal.cod-estabel.
    
    RUN pi-localiza-tabelas-ttEmit.
	
	    /* IEST local de entrega */                                    
    ASSIGN l-uf-iest = CAN-FIND(FIRST funcao NO-LOCK                                             
                                   WHERE funcao.cd-funcao = ("spp-uf-iest-" + estabelec.estado)
                                     AND funcao.ativo = yes).                                        
    {dibo/bodi317.i10 spp-uf-iest l-uf-iest AXSEP037upsert.i3}

    
    FOR FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = nota-fiscal.cod-emitente:
    END.

    ASSIGN i-natureza = emitente.natureza.

    IF i-natureza = 1       AND 
       CONNECTED ("emsgra") THEN DO:

        RUN ggp/ggapi111.p (INPUT  nota-fiscal.cod-entrega,
                            INPUT  nota-fiscal.cod-emitente,
                            OUTPUT i-natureza).

    END.
    
    ASSIGN l-prod-rural = NO.
    IF i-natureza = 1 AND
      (emitente.atividade = "Rural" OR 
       emitente.atividade = "Fisica" OR 
       emitente.atividade = "Física") THEN
       ASSIGN l-prod-rural = YES.
    FOR FIRST bf-natur-oper-nf NO-LOCK
        WHERE bf-natur-oper-nf.nat-operacao = nota-fiscal.nat-operacao:
    END.

    IF  AVAIL bf-natur-oper-nf THEN DO:
        
        &if '{&bf_dis_versao_ems}' >= '2.05':U &then
            FOR FIRST cfop-natur NO-LOCK
                WHERE cfop-natur.cod-cfop = &if defined(bf_dis_formato_CFOP) &then bf-natur-oper-nf.cod-cfop &else SUBSTR(bf-natur-oper-nf.char-1,45,10) &endif:
            END.
        &else
            FOR FIRST ped-curva NO-LOCK
                WHERE ped-curva.it-codigo = &if defined(bf_dis_formato_CFOP) &then bf-natur-oper-nf.cod-cfop &else SUBSTR(bf-natur-oper-nf.char-1,45,10) &endif
                  AND ped-curva.vl-aberto = 620:
            END.
        &endif
    END.

    FOR FIRST cond-pagto FIELDS (descricao cod-vencto cod-cond-pag) NO-LOCK 
        WHERE cond-pagto.cod-cond-pag = nota-fiscal.cod-cond-pag:
    END.

    FOR FIRST ser-estab FIELDS (&if '{&bf_dis_versao_ems}' >= '2.07':U &then log-nf-eletro idi-format-emis-danfe nom-model-danfe &else char-1 &endif) NO-LOCK
        WHERE ser-estab.serie       = nota-fiscal.serie
          AND ser-estab.cod-estabel = nota-fiscal.cod-estabel:
    END.

    FOR FIRST bf-pais NO-LOCK
        WHERE bf-pais.nome-pais = emitente.pais:
    END.

    FOR FIRST estab-uf
        WHERE estab-uf.cod-estabel = nota-fiscal.cod-estabel
          AND estab-uf.estado      = IF l-uf-iest THEN emitente.estado ELSE nota-fiscal.estado NO-LOCK:
    END.

    FOR FIRST bf-cidade-emit FIELDS(pais &if '{&BF_DIS_VERSAO_EMS}' >= "2.07":U &then cdn-munpio-ibge &else int-2 &endif)
        WHERE bf-cidade-emit.cidade = emitente.cidade
          AND bf-cidade-emit.estado = emitente.estado
          AND bf-cidade-emit.pais   = emitente.pais   NO-LOCK:
    END.
    
    FOR FIRST bf-cidade-entrega FIELDS(pais cidade &if '{&BF_DIS_VERSAO_EMS}' >= "2.07":U &then cdn-munpio-ibge &else int-2 &endif)
        WHERE bf-cidade-entrega.cidade = nota-fiscal.cidade
          AND bf-cidade-entrega.estado = nota-fiscal.estado
          AND bf-cidade-entrega.pais   = nota-fiscal.pais   NO-LOCK:
    END.

    FOR FIRST bf-unid-feder-emit FIELDS (&if '{&bf_dis_versao_ems}' >= '2.07':U &then cod-uf-ibge &else char-1 &endif) NO-LOCK
        WHERE bf-unid-feder-emit.pais   = emitente.pais
          AND bf-unid-feder-emit.estado = emitente.estado:
    END.

    FOR FIRST para-fat NO-LOCK: 
    END.

    FOR FIRST bf-nota-fisc-adc-nfe NO-LOCK
        WHERE bf-nota-fisc-adc-nfe.cod-estab        = nota-fiscal.cod-estabel
        AND   bf-nota-fisc-adc-nfe.cod-serie        = nota-fiscal.serie
        AND   bf-nota-fisc-adc-nfe.cod-nota-fisc    = nota-fiscal.nr-nota-fis
        AND   bf-nota-fisc-adc-nfe.cdn-emitente     = nota-fiscal.cod-emitente
        AND   bf-nota-fisc-adc-nfe.cod-natur-operac = nota-fiscal.nat-operacao
        AND   bf-nota-fisc-adc-nfe.idi-tip-dado     = 20: /*CD4035 - Op‡Æo "Informa‡äes Adcionais NF-e" */
    END.

END PROCEDURE.
