/* ---------------------------------------------------------------------------------------------------
   Autor      : Jade
   Data       : 07/02/2001
   Objetivo   :     
   Parametros : {1} ROWID DA CONTROLE-PRCO
--------------------------------------------------------------------------------- */   

        FOR EACH tt-epc:
            DELETE tt-epc.
        end.
        create tt-epc.
        assign tt-epc.cod-event     = "consulta-preco-item".
               tt-epc.cod-parameter = "TABLE-ROWID".
               tt-epc.val-parameter = string({1}).

        {include/i-epc201.i "consulta-preco-item"}

        FIND tt-epc WHERE
             tt-epc.cod-parameter = "tt-precos.manual-autom" NO-ERROR.
        IF AVAIL tt-epc THEN
           ASSIGN tt-precos.manual-autom = tt-epc.val-parameter.

/***********************************************************************/
