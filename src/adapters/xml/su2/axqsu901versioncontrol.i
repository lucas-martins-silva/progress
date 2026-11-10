
      /* FAZER AQUI TRATAMENTO DE CONTROLE DE VERSAO ADEQUADO! */
    
    /* ********* EXECUCAO DAS PI - BEGIN ********* */
    if (cTranAction = "qry":U) then do:
        run PIQuery. /* consulta */

        /* AQUI!! IMPLEMENTAR O TRATAMENTO DA CONSULTA SOLICITADA E AP‡S EXECUTAR O MêTODO PARA PREPARAÄ«O DA MENSAGEM DE ENVIO*/
          /*CHAMADA A PI DE MONTAGEM DO ENVIO DA MENSAGEM */
        run PIQueryReturnType (input PONumber,
                               INPUT iStatus).

        /* inclui os registros encontrados durante a consulta na mensagem de retorno */
        run setQueryReturnContent in hMessageHandler (INPUT hQueryReturnContent).

        
    end.
    
    /* OBTEM UMA MENSAGEM DE RETORNO - SENDO ELA DE ERRO OU DE CONFIRMACAO */
    run getReturnMessage in hMessageHandler (output hOutputXML).
    /* ********* EXECU«√O DAS PI - END ********* */


