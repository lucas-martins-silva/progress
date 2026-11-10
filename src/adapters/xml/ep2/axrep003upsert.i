
EMPTY TEMP-TABLE RowErrors NO-ERROR.

IF  ttInutilDocument.cStat <> "104":U THEN DO:

    ASSIGN c-serie = IF ttInutilDocument.serie <> "000":U then string(int(ttInutilDocument.serie)) else "":U.

    FOR EACH estabelec  NO-LOCK
        WHERE estabelec.cgc = ttInutilDocument.CNPJ
        &IF "{&bf_dis_versao_ems}":U >= "2.07":U &THEN
        and   estabelec.idi-tip-emis-nf-eletro > 1    
        &else
        AND   INT(SUBSTR(estabelec.char-1,168,1)) > 1
        &endif ,
         EACH nota-fiscal NO-LOCK
        WHERE nota-fiscal.cod-estabel  = estabelec.cod-estabel 
          AND nota-fiscal.serie        = c-serie  
          AND nota-fiscal.nr-nota-fis >= trim(string(integer(ttInutilDocument.nNFIni),">>9999999"))
          AND nota-fiscal.nr-nota-fis <= trim(string(integer(ttInutilDocument.nNFFin),">>9999999")):

        RUN ftp/ft0911.p (INPUT ROWID(nota-fiscal),
                          INPUT ttInutilDocument.cStat,
                          INPUT ttInutilDocument.nProt).
    END.
END.
