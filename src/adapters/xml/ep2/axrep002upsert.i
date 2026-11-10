
EMPTY TEMP-TABLE RowErrors NO-ERROR.

IF  ttNfeRet.cStat <> "104":U THEN DO:

    ASSIGN c-serie = IF substr(ttNfeRet.chNFe,23,3) <> "000":U then string(int(substr(ttNfeRet.chNFe,23,3))) else "".
    
    FOR EACH estabelec NO-LOCK 
        WHERE estabelec.cgc = substr(ttNfeRet.chNFe,7,14) 
        &IF "{&bf_dis_versao_ems}":U >= "2.07":U &THEN
        and   estabelec.idi-tip-emis-nf-eletro > 1    
        &else
        AND   INT(SUBSTR(estabelec.char-1,168,1)) > 1
        &endif ,
        FIRST nota-fiscal NO-LOCK
        WHERE nota-fiscal.cod-estabel = estabelec.cod-estabel 
          AND nota-fiscal.serie       = c-serie
          AND nota-fiscal.nr-nota-fis = trim(string(integer(substring(ttNfeRet.chNFe,26,9)),">>9999999")):
        
        RUN ftp/ft0911.p (INPUT ROWID(nota-fiscal),
                          INPUT ttNfeRet.cStat,
                          INPUT ttNfeRet.nProt).
    END.
END.
