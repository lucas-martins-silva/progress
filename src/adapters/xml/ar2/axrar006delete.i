CREATE tt-grup-estoque.
ASSIGN tt-grup-estoque.ge-codigo = InventoryGroupCode
       tt-grup-estoque.descricao = InventoryGroupDescription.

if  search("cep/ceapi019.r") = ? and search("cep/ceapi019.p") = ? then do:
        CREATE tt_log_erro.
        ASSIGN tt_log_erro.ttv_num_cod_erro   = 4
               tt_log_erro.ttv_des_msg_ajuda  = "Programa execut†vel n∆o foi encontrado: cep/ceapi019.p"
               tt_log_erro.ttv_des_msg_erro   = "Programa execut†vel n∆o foi encontrado: cep/ceapi019.p".
end.
else do:

    RUN cep/ceapi019.p(INPUT  TABLE tt-grup-estoque,
                       INPUT  cTranAction,
                       OUTPUT TABLE RowErrors).

    FOR EACH RowErrors NO-LOCK:
        CREATE tt_log_erro.
        ASSIGN tt_log_erro.ttv_num_cod_erro   = RowErrors.ErrorNumber     
               tt_log_erro.ttv_des_msg_ajuda  = RowErrors.ErrorHelp
               tt_log_erro.ttv_des_msg_erro   = RowErrors.ErrorDescription.
    END.
end.
