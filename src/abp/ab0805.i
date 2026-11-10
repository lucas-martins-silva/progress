/*************************************************************************************************
** AB0805.i - Integra‡Æo com as tabelas de Abastecimento/Lubrificacao
*************************************************************************************************/

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaFrotas DBOProgram 
PROCEDURE piAtualizaFrotas :    
    define buffer bf-item-frota for item.
        
    /** Item deve ser debito direto **/
    if  can-find(first bf-item-frota 
                 where bf-item-frota.it-codigo  = {1}.it-codigo
                 and   bf-item-frota.tipo-contr = 4 no-lock) then do: 

        /** Pr‚-api do programa que faz a manutencao nas tabelas do Produto Frotas **/
        run abp/ab0805a.p (INPUT {1}.cod-emitente,
                           INPUT {1}.nro-docto,
                           INPUT {1}.serie-docto,
                           INPUT {1}.nat-operacao,
                           INPUT {1}.sequencia,
                           INPUT TABLE tt-mab-item-abastec-lubrific,
                           OUTPUT TABLE RowErrors).
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetValFrota DBOProgram 
PROCEDURE SetValFrota :    
    define input parameter table for tt-mab-item-abastec-lubrific.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
