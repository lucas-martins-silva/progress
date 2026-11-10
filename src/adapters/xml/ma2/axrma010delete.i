CREATE tt-familia.
ASSIGN tt-familia.fm-codigo = MaterialFamilyCode
       tt-familia.descricao = MaterialFamilyDescription
       tt-familia.un        = UnitOfMeasureCode.


if  search("cep/ceapi018.r") = ? and search("cep/ceapi018.p") = ? then do:
        CREATE tt_log_erro.
        ASSIGN tt_log_erro.ttv_num_cod_erro   = 4
               tt_log_erro.ttv_des_msg_ajuda  = "Programa execut†vel n∆o foi encontrado: cep/ceapi018.p"
               tt_log_erro.ttv_des_msg_erro   = "Programa execut†vel n∆o foi encontrado: cep/ceapi018.p".
end.
else do:
    RUN cep/ceapi018.p(INPUT  TABLE tt-familia,
                       INPUT  cTranAction,
                       OUTPUT TABLE RowErrors).
    
    
    FOR EACH RowErrors NO-LOCK:
        CREATE tt_log_erro.
        ASSIGN tt_log_erro.ttv_num_cod_erro   = RowErrors.ErrorNumber     
               tt_log_erro.ttv_des_msg_ajuda  = RowErrors.ErrorHelp
               tt_log_erro.ttv_des_msg_erro   = RowErrors.ErrorDescription.
    END.
end.

