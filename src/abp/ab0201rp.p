/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0201RP 2.00.00.003}  /*** "010003" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0201rp MAB}
&ENDIF



{include/i_fnctrad.i}
{include/i-epc200.i ab0201rp}
DEFINE TEMP-TABLE ttRelat NO-UNDO
    FIELD ep-codigo-atu      LIKE mab-eqpto.ep-codigo
    FIELD cod-eqpto-atu      LIKE mab-eqpto.cod-eqpto
    FIELD des-model          LIKE mab-model.des-model
    FIELD ep-codigo-new      LIKE mab-eqpto.ep-codigo
    FIELD cod-eqpto-new      LIKE mab-eqpto.cod-eqpto
    FIELD des-erro           AS CHARACTER FORMAT "x(48)".
    
define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    field modelo           AS char format "x(35)":U
    field l-habilitaRtf    as LOG.


define temp-table tt-digita no-undo
    field ep-codigo-atu          LIKE mab-eqpto.ep-codigo
    FIELD cod-eqpto-atu          LIKE mab-eqpto.cod-eqpto
    FIELD des-model              LIKE mab-model.des-model
    field ep-codigo-new          LIKE mab-eqpto.ep-codigo
    FIELD cod-eqpto-new          LIKE mab-eqpto.cod-eqpto
    index id ep-codigo-atu cod-eqpto-atu ep-codigo-new cod-eqpto-new .
    
def temp-table tt-raw-digita
   field raw-digita      as raw.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

RAW-TRANSFER raw-param TO tt-param.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER raw-digita TO tt-digita.
END.
    
DEFINE VARIABLE h-acomp AS HANDLE     NO-UNDO.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Troca Codigo Equipamento").
RUN pi-desabilita-cancela IN h-acomp.
blk_digita:
FOR EACH tt-digita NO-LOCK:
    CREATE ttRelat.
    ASSIGN ttRelat.ep-codigo-atu = tt-digita.ep-codigo-atu
           ttRelat.cod-eqpto-atu = tt-digita.cod-eqpto-atu
           ttRelat.ep-codigo-new = tt-digita.ep-codigo-new
           ttRelat.cod-eqpto-new = tt-digita.cod-eqpto-new
           ttRelat.des-model     = tt-digita.des-model.
   
    IF ttRelat.cod-eqpto-atu = "" THEN DO:
        {utp/ut-liter.i "Equipamento Atual em branco" *}
        ASSIGN ttRelat.des-erro = RETURN-VALUE.
        NEXT.
    END.
    IF ttRelat.cod-eqpto-new = "" THEN DO:
        {utp/ut-liter.i "Equipamento Novo em branco" *}
        ASSIGN ttRelat.des-erro = RETURN-VALUE.
        NEXT.
    END.


&IF "{&mguni_version}" >= "2.071" &THEN
    IF ttRelat.ep-codigo-new <= "" OR ttRelat.ep-codigo-atu <= "" THEN DO:
&ELSE
    IF ttRelat.ep-codigo-new <=0 OR ttRelat.ep-codigo-atu <=0 THEN DO:
&ENDIF
        {utp/ut-liter.i "Empresa deve ser maior do que zero" *}
        ASSIGN ttRelat.des-erro = RETURN-VALUE.
        NEXT.
    END.

    FOR FIRST empresa WHERE ep-codigo = ttRelat.ep-codigo-new NO-LOCK:
    END.
    
    IF NOT AVAIL empresa THEN DO:
        {utp/ut-liter.i "Empresa Nova nÆo cadastrada" *}
        ASSIGN ttRelat.des-erro = RETURN-VALUE.
        NEXT.
    END.

    FOR FIRST mab-eqpto WHERE mab-eqpto.ep-codigo = tt-digita.ep-codigo-new
                          AND mab-eqpto.cod-eqpto = tt-digita.cod-eqpto-new NO-LOCK:
    END.
    IF NOT AVAIL mab-eqpto THEN DO:
        FOR First mab-eqpto WHERE mab-eqpto.ep-codigo = tt-digita.ep-codigo-atu
                              AND mab-eqpto.cod-eqpto = tt-digita.cod-eqpto-atu EXCLUSIVE-LOCK:
        END.
        IF AVAIL mab-eqpto THEN DO:
            RUN converte(INPUT mab-eqpto.ep-codigo,
                         INPUT tt-digita.ep-codigo-new,
                         INPUT mab-eqpto.cod-eqpto, 
                         INPUT tt-digita.cod-eqpto-new).
        
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Tabela_Equipamento" *}
            RUN pi-acompanhar IN h-acomp (INPUT trim(mab-eqpto.cod-eqpto) + " - " + RETURN-VALUE).
             ASSIGN mab-eqpto.ep-codigo = tt-digita.ep-codigo-new  
                    mab-eqpto.cod-eqpto = tt-digita.cod-eqpto-new. 
            {utp/ut-liter.i "Alterado com Sucesso" *}
            ASSIGN ttRelat.des-erro = RETURN-VALUE.

        END.
        ELSE DO:
             {utp/ut-liter.i "Equipamento inexistente" *}
             ASSIGN ttRelat.des-erro  = RETURN-VALUE
                    ttRelat.des-model = RETURN-VALUE.
        END.
    END.
    ELSE DO:
        {utp/ut-liter.i "Novo c¢digo j  existe" *}
        ASSIGN ttRelat.des-erro = RETURN-VALUE.
    END.
END.
RUN pi-finalizar IN h-acomp.

{abp/ab0201.i}

RETURN "OK":U.

PROCEDURE converte :
    DISABLE TRIGGERS FOR LOAD OF mab-histor-ativid.
    DISABLE TRIGGERS FOR LOAD OF mmv-tar-ord-manut.
    DISABLE TRIGGERS FOR LOAD OF mpn-pneu.
    
    DEFINE INPUT PARAM ep-codigo-atu LIKE mab-eqpto.ep-codigo.
    DEFINE INPUT PARAM ep-codigo-new LIKE mab-eqpto.ep-codigo.
    DEFINE INPUT PARAM c-eqpto-atu   LIKE mab-eqpto.cod-eqpto.
    DEFINE INPUT PARAM c-eqpto-new   LIKE mab-eqpto.cod-eqpto.
    
    RUN tabelasAbastecimento(INPUT ep-codigo-atu, INPUT ep-codigo-new,
                             INPUT c-eqpto-atu,   INPUT c-eqpto-new).
    
    RUN tabelasPneus        (INPUT ep-codigo-atu, INPUT ep-codigo-new,
                             INPUT c-eqpto-atu,   INPUT c-eqpto-new).
                            
    RUN tabelasManutencao   (INPUT ep-codigo-atu, INPUT ep-codigo-new,
                             INPUT c-eqpto-atu,   INPUT c-eqpto-new).
                            
    RUN tabelasAnaliseOleo  (INPUT ep-codigo-atu, INPUT ep-codigo-new,
                             INPUT c-eqpto-atu,   INPUT c-eqpto-new).
                            
    RUN tabelasGerencial    (INPUT ep-codigo-atu, INPUT ep-codigo-new,
                             INPUT c-eqpto-atu,   INPUT c-eqpto-new).
                            
    RUN tabelasDocumentos   (INPUT ep-codigo-atu, INPUT ep-codigo-new,
                             INPUT c-eqpto-atu,   INPUT c-eqpto-new).
                            
    RUN tabelasComponentes  (INPUT ep-codigo-atu, INPUT ep-codigo-new,
                             INPUT c-eqpto-atu,   INPUT c-eqpto-new).
                            
    RUN tabelasEspecifico   (INPUT ep-codigo-atu, INPUT ep-codigo-new,
                             INPUT c-eqpto-atu,   INPUT c-eqpto-new).
    
END PROCEDURE.

PROCEDURE tabelasAbastecimento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM i-ep-codigo-atu LIKE mab-eqpto.ep-codigo NO-UNDO.
    DEFINE INPUT PARAM i-ep-codigo-new LIKE mab-eqpto.ep-codigo NO-UNDO.
    DEFINE INPUT PARAM c-cod-eqpto-atu LIKE mab-eqpto.cod-eqpto NO-UNDO.
    DEFINE INPUT PARAM c-cod-eqpto-new LIKE mab-eqpto.cod-eqpto NO-UNDO.
    
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Tabelas_Abastecimento" *}
    RUN pi-acompanhar IN h-acomp (INPUT string(trim(c-cod-eqpto-atu)) + " - " + RETURN-VALUE). 
    /***********************************************************
    ** Atualizacao do equipamento em todas as tabelas
    ***********************************************************/
    /** ABASTECIMENTO **/
                    /* mab-comptmento-eqpto */
                    /* mab-configur-eixo    */
                    /* mab-eqpto-caract     */
                    /* mab-histor-combust   */
                    /* mab-period-manut     */
                    /* mab-histor-ativid    */
                    /* mab-programac-event  */
                    /* mab-abastec-lubrific */
                    /* mab-reserva-implto   */
                    /* mab-viagem           */
                    /* mab-reserva          */
                    /* mab-viagem-implto    */
                    /* mab-item-abastec     */
                    /* mab-item-lubrific    */
                    /* mab-movto-event      */
                    /* mab-movto-km-eqpto   */
                    /* mab-movto-remon      */
                    /* mab-relac-eqpto-sub-sist*/
    
    FOR EACH mab-comptmento-eqpto
        where mab-comptmento-eqpto.ep-codigo =  i-ep-codigo-atu
          AND mab-comptmento-eqpto.cod-eqpto =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
        
        ASSIGN mab-comptmento-eqpto.ep-codigo = i-ep-codigo-new
               mab-comptmento-eqpto.cod-eqpto = trim(c-cod-eqpto-new) no-error.
    end.
    
    FOR EACH mab-configur-eixo
        where mab-configur-eixo.ep-codigo    =  i-ep-codigo-atu
          AND mab-configur-eixo.cod-eqpto    =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
       ASSIGN mab-configur-eixo.ep-codigo    =  i-ep-codigo-new
              mab-configur-eixo.cod-eqpto    =  trim(c-cod-eqpto-new) No-error.
    end.
    
    FOR EACH mab-eqpto-caract
        where mab-eqpto-caract.ep-codigo =  i-ep-codigo-atu
          AND mab-eqpto-caract.cod-eqpto =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
       ASSIGN mab-eqpto-caract.ep-codigo =  i-ep-codigo-new 
              mab-eqpto-caract.cod-eqpto =  trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mab-histor-ativid
       where mab-histor-ativid.ep-codigo =  i-ep-codigo-atu
         AND mab-histor-ativid.cod-eqpto =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
      ASSIGN mab-histor-ativid.ep-codigo =  i-ep-codigo-new
             mab-histor-ativid.cod-eqpto =  trim(c-cod-eqpto-new) NO-ERROR.
    end.
    FOR EACH mab-histor-combust
        where mab-histor-combust.ep-codigo =  i-ep-codigo-atu
          AND mab-histor-combust.cod-eqpto =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
       ASSIGN mab-histor-combust.ep-codigo =  i-ep-codigo-new
              mab-histor-combust.cod-eqpto =  trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mab-period-manut
       where mab-period-manut.ep-codigo =  i-ep-codigo-atu 
         AND mab-period-manut.cod-eqpto =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
      ASSIGN mab-period-manut.ep-codigo =  i-ep-codigo-new
             mab-period-manut.cod-eqpto =  trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mab-programac-event
        where  mab-programac-event.ep-codigo =  i-ep-codigo-atu
           AND mab-programac-event.cod-eqpto =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mab-programac-event.ep-codigo =  i-ep-codigo-new
               mab-programac-event.cod-eqpto =  trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mab-relac-eqpto-sub-sist
        where  mab-relac-eqpto-sub-sist.ep-codigo =  i-ep-codigo-atu
          AND  mab-relac-eqpto-sub-sist.cod-eqpto =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mab-relac-eqpto-sub-sist.ep-codigo =  i-ep-codigo-new
               mab-relac-eqpto-sub-sist.cod-eqpto =  trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mab-abastec-lubrific
         where mab-abastec-lubrific.ep-codigo =  i-ep-codigo-atu
           AND mab-abastec-lubrific.cod-eqpto =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mab-abastec-lubrific.ep-codigo =  i-ep-codigo-new
               mab-abastec-lubrific.cod-eqpto =  trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mab-item-abastec
        where mab-item-abastec.ep-codigo  =  i-ep-codigo-atu
          AND mab-item-abastec.cod-eqpto  =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
       ASSIGN mab-item-abastec.ep-codigo  =  i-ep-codigo-new  
               mab-item-abastec.cod-eqpto =  trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mab-item-lubrific
        WHERE mab-item-lubrific.ep-codigo =  i-ep-codigo-atu
          AND mab-item-lubrific.cod-eqpto =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mab-item-lubrific.ep-codigo = i-ep-codigo-new
               mab-item-lubrific.cod-eqpto =  trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mab-movto-event
        where mab-movto-event.ep-codigo =  i-ep-codigo-atu
          AND mab-movto-event.cod-eqpto =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mab-movto-event.ep-codigo = i-ep-codigo-new
               mab-movto-event.cod-eqpto =  trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mab-movto-km-eqpto
        where  mab-movto-km-eqpto.ep-codigo = i-ep-codigo-atu
          AND  mab-movto-km-eqpto.cod-eqpto = c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mab-movto-km-eqpto.ep-codigo = i-ep-codigo-new
               mab-movto-km-eqpto.cod-eqpto = trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mab-movto-remon
        where  mab-movto-remon.ep-codigo = i-ep-codigo-atu
          AND  mab-movto-remon.cod-eqpto = c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mab-movto-remon.ep-codigo = i-ep-codigo-new
               mab-movto-remon.cod-eqpto = trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mab-reserva
        WHERE  mab-reserva.ep-codigo =  i-ep-codigo-atu 
          AND  mab-reserva.cod-eqpto =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mab-reserva.ep-codigo =  i-ep-codigo-new
               mab-reserva.cod-eqpto =  trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mab-reserva-implto
        where  mab-reserva-implto.ep-codigo = i-ep-codigo-atu
          AND  mab-reserva-implto.cod-eqpto = c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mab-reserva-implto.ep-codigo = i-ep-codigo-new
               mab-reserva-implto.cod-eqpto = trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mab-viagem
        where  mab-viagem.ep-codigo  =  i-ep-codigo-atu
          AND  mab-viagem.cod-eqpto  =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mab-viagem.ep-codigo  =  i-ep-codigo-new
               mab-viagem.cod-eqpto  =  trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mab-viagem-implto
        where  mab-viagem-implto.ep-codigo = i-ep-codigo-atu
          AND  mab-viagem-implto.cod-eqpto = c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mab-viagem-implto.ep-codigo = i-ep-codigo-new
               mab-viagem-implto.cod-eqpto = trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mab-unid-negoc-eqpto
        WHERE mab-unid-negoc-eqpto.ep-codigo = i-ep-codigo-atu
          AND mab-unid-negoc-eqpto.cod-eqpto = c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mab-unid-negoc-eqpto.ep-codigo = i-ep-codigo-new
               mab-unid-negoc-eqpto.cod-eqpto = TRIM(c-cod-eqpto-new) NO-ERROR.
    END.

    FOR EACH mab-unid-negoc-histor-ativid
        WHERE  mab-unid-negoc-histor-ativid.ep-codigo = i-ep-codigo-atu
          AND  mab-unid-negoc-histor-ativid.cod-eqpto = c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mab-unid-negoc-histor-ativid.ep-codigo = i-ep-codigo-new
               mab-unid-negoc-histor-ativid.cod-eqpto = TRIM(c-cod-eqpto-new) NO-ERROR.
    END.

END PROCEDURE.

PROCEDURE tabelasAnaliseOleo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAM i-ep-codigo-atu LIKE mab-eqpto.ep-codigo NO-UNDO.
DEFINE INPUT PARAM i-ep-codigo-new LIKE mab-eqpto.ep-codigo NO-UNDO.
DEFINE INPUT PARAM c-cod-eqpto-atu LIKE mab-eqpto.cod-eqpto NO-UNDO.
DEFINE INPUT PARAM c-cod-eqpto-new LIKE mab-eqpto.cod-eqpto NO-UNDO.

/* Inicio -- Projeto Internacional */
{utp/ut-liter.i "Tabelas_Amostra_Oleo" *}
RUN pi-acompanhar IN h-acomp (INPUT trim(c-cod-eqpto-atu) + " - " + RETURN-VALUE).
/** AMOSTRA OLEO **/
                    /* mao-amostra-oleo */
FOR EACH mao-amostra-oleo
    WHERE  mao-amostra-oleo.ep-codigo =  i-ep-codigo-atu
      AND  mao-amostra-oleo.cod-eqpto =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
    ASSIGN mao-amostra-oleo.ep-codigo =  i-ep-codigo-new
           mao-amostra-oleo.cod-eqpto =  trim(c-cod-eqpto-new) no-error.
END.

END PROCEDURE.

PROCEDURE tabelasComponentes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM i-ep-codigo-atu LIKE mab-eqpto.ep-codigo NO-UNDO.
    DEFINE INPUT PARAM i-ep-codigo-new LIKE mab-eqpto.ep-codigo NO-UNDO.
    DEFINE INPUT PARAM c-cod-eqpto-atu LIKE mab-eqpto.cod-eqpto NO-UNDO.
    DEFINE INPUT PARAM c-cod-eqpto-new LIKE mab-eqpto.cod-eqpto NO-UNDO.
    
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Tabelas_Componentes" *}
    RUN pi-acompanhar IN h-acomp (INPUT trim(c-cod-eqpto-atu) + " - " + RETURN-VALUE).
    /** COMPONENTES **/
                        /* mco-compon       */
                        /* mco-compon       */
                        /* mco-movto-compon */
    FOR EACH mco-compon
        where  mco-compon.ep-codigo-inicial =  i-ep-codigo-atu
          AND  mco-compon.cod-eqpto-inicial =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mco-compon.ep-codigo-inicial =  i-ep-codigo-new
               mco-compon.cod-eqpto-inicial =  trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mco-compon
        where  mco-compon.ep-codigo-atual =  i-ep-codigo-atu
          AND  mco-compon.cod-eqpto-atual =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mco-compon.ep-codigo-atual =  i-ep-codigo-new
               mco-compon.cod-eqpto-atual =  trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mco-movto-compon
        where mco-movto-compon.ep-codigo  = i-ep-codigo-atu 
          AND mco-movto-compon.cod-eqpto  = c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mco-movto-compon.ep-codigo = i-ep-codigo-new 
               mco-movto-compon.cod-eqpto = trim(c-cod-eqpto-new) no-error.
    end.
    
END PROCEDURE.
                                                                     
PROCEDURE tabelasDocumentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM i-ep-codigo-atu LIKE mab-eqpto.ep-codigo NO-UNDO.
    DEFINE INPUT PARAM i-ep-codigo-new LIKE mab-eqpto.ep-codigo NO-UNDO.
    DEFINE INPUT PARAM c-cod-eqpto-atu LIKE mab-eqpto.cod-eqpto NO-UNDO.
    DEFINE INPUT PARAM c-cod-eqpto-new LIKE mab-eqpto.cod-eqpto NO-UNDO.
    
    
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Tabelas_Documentos" *}
    RUN pi-acompanhar IN h-acomp (INPUT trim(c-cod-eqpto-atu) + " - " + RETURN-VALUE).
    /** MANUTENCAO DOCUMENTOS **/
                        /* mnd-movto-infracao */
                        /* mnd-movto-proces   */
    FOR EACH mnd-movto-infracao
       where mnd-movto-infracao.ep-codigo =  i-ep-codigo-atu 
         AND mnd-movto-infracao.cod-eqpto =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
      ASSIGN mnd-movto-infracao.ep-codigo =  i-ep-codigo-new
             mnd-movto-infracao.cod-eqpto =  trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mnd-movto-proces
        where  mnd-movto-proces.ep-codigo =  i-ep-codigo-atu
          AND  mnd-movto-proces.cod-eqpto =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mnd-movto-proces.ep-codigo =  i-ep-codigo-new
               mnd-movto-proces.cod-eqpto =  trim(c-cod-eqpto-new) no-error.
    end.

END PROCEDURE.

PROCEDURE tabelasEspecifico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAM i-ep-codigo-atu LIKE mab-eqpto.ep-codigo NO-UNDO.
DEFINE INPUT PARAM i-ep-codigo-new LIKE mab-eqpto.ep-codigo NO-UNDO.
DEFINE INPUT PARAM c-cod-eqpto-atu LIKE mab-eqpto.cod-eqpto NO-UNDO.
DEFINE INPUT PARAM c-cod-eqpto-new LIKE mab-eqpto.cod-eqpto NO-UNDO.

/* Inicio -- Projeto Internacional */
{utp/ut-liter.i "Tabelas_Especificos" *}
RUN pi-acompanhar IN h-acomp (INPUT trim(c-cod-eqpto-atu) + " - " + RETURN-VALUE).
/** ESPECIFICO **/
/*CHAMADA DE UPC PARA TABELAS ESPECÖFICAS*/

for each tt-epc
   where tt-epc.cod-event = "ALTERA-COD-EQPTO":
   delete tt-epc.
end.

create tt-epc.
assign tt-epc.cod-event     = "ALTERA-COD-EQPTO"
       tt-epc.cod-parameter = "ep-codigo-atu"
       tt-epc.val-parameter = string(i-ep-codigo-atu).

create tt-epc.
assign tt-epc.cod-event     = "ALTERA-COD-EQPTO"
       tt-epc.cod-parameter = "cod-eqpto-atu"
       tt-epc.val-parameter = c-cod-eqpto-atu.

create tt-epc.
assign tt-epc.cod-event     = "ALTERA-COD-EQPTO"
       tt-epc.cod-parameter = "ep-codigo-new"
       tt-epc.val-parameter = string(i-ep-codigo-new).

create tt-epc.
assign tt-epc.cod-event     = "ALTERA-COD-EQPTO"
       tt-epc.cod-parameter = "cod-eqpto-new"
       tt-epc.val-parameter = c-cod-eqpto-new.

{include/i-epc201.i "ALTERA-COD-EQPTO"}


END PROCEDURE.

PROCEDURE tabelasGerencial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM i-ep-codigo-atu LIKE mab-eqpto.ep-codigo NO-UNDO.
    DEFINE INPUT PARAM i-ep-codigo-new LIKE mab-eqpto.ep-codigo NO-UNDO.
    DEFINE INPUT PARAM c-cod-eqpto-atu LIKE mab-eqpto.cod-eqpto NO-UNDO.
    DEFINE INPUT PARAM c-cod-eqpto-new LIKE mab-eqpto.cod-eqpto NO-UNDO.
    
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Tabelas_Gerencial" *}
    RUN pi-acompanhar IN h-acomp (INPUT trim(c-cod-eqpto-atu) + " - " + RETURN-VALUE).
    /** GERENCIAL **/
                        /* mgf-eqpto-implto     */
                        /* mgf-eqpto-implto     */
                        /* mgf-quant-transp     */
                        /* mgf-cust-eqpto       */
                        /* mgf-eqpto-cust-event */
    FOR EACH mgf-eqpto-implto
        where  mgf-eqpto-implto.ep-codigo-eqpto = i-ep-codigo-atu
          AND  mgf-eqpto-implto.cod-eqpto       = c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mgf-eqpto-implto.ep-codigo-eqpto = i-ep-codigo-new
               mgf-eqpto-implto.cod-eqpto       = trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mgf-eqpto-implto
        where  mgf-eqpto-implto.ep-codigo-implto = i-ep-codigo-atu
          AND  mgf-eqpto-implto.cod-implto       =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mgf-eqpto-implto.ep-codigo-implto = i-ep-codigo-new
               mgf-eqpto-implto.cod-implto       =  trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mgf-cust-eqpto
        where  mgf-cust-eqpto.ep-codigo =  i-ep-codigo-atu
          AND  mgf-cust-eqpto.cod-eqpto =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mgf-cust-eqpto.ep-codigo =  i-ep-codigo-new
               mgf-cust-eqpto.cod-eqpto =  trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mgf-eqpto-cust-event
        where  mgf-eqpto-cust-event.ep-codigo =  i-ep-codigo-atu
          AND  mgf-eqpto-cust-event.cod-eqpto =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mgf-eqpto-cust-event.ep-codigo =  i-ep-codigo-new
               mgf-eqpto-cust-event.cod-eqpto =  trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mgf-quant-transp
        where mgf-quant-transp.ep-codigo  =  i-ep-codigo-atu
          AND mgf-quant-transp.cod-eqpto  =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mgf-quant-transp.ep-codigo  =  i-ep-codigo-new
               mgf-quant-transp.cod-eqpto =  trim(c-cod-eqpto-new) no-error.
    end.
    
END PROCEDURE.
        
PROCEDURE tabelasManutencao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM i-ep-codigo-atu LIKE mab-eqpto.ep-codigo NO-UNDO.
    DEFINE INPUT PARAM i-ep-codigo-new LIKE mab-eqpto.ep-codigo NO-UNDO.
    DEFINE INPUT PARAM c-cod-eqpto-atu LIKE mab-eqpto.cod-eqpto NO-UNDO.
    DEFINE INPUT PARAM c-cod-eqpto-new LIKE mab-eqpto.cod-eqpto NO-UNDO.
    
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Tabelas_Manutencao_Mecanica" *}
    RUN pi-acompanhar IN h-acomp (INPUT trim(c-cod-eqpto-atu) + " - " + RETURN-VALUE).
    /** MANUTENCAO MECANICA **/
                        /* mmv-eqpto-plano        */
                        /* mmv-eqpto-grp-eqpto    */
                        /* mmv-movto-mater        */
                        /* mmv-eqpto-calend-plano */
                        /* mmv-movto-ord          */
                        /* mmv-tar-ord-manut      */
                        /* mmv-ord-manut          */
    FOR EACH mmv-eqpto-plano
        where  mmv-eqpto-plano.ep-codigo =  i-ep-codigo-atu
          AND  mmv-eqpto-plano.cod-eqpto =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mmv-eqpto-plano.ep-codigo =  i-ep-codigo-new
               mmv-eqpto-plano.cod-eqpto =  trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mmv-eqpto-grp-eqpto
        where mmv-eqpto-grp-eqpto.ep-codigo  =  i-ep-codigo-atu
          AND mmv-eqpto-grp-eqpto.cod-eqpto  =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mmv-eqpto-grp-eqpto.ep-codigo =  i-ep-codigo-new
               mmv-eqpto-grp-eqpto.cod-eqpto =  trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mmv-eqpto-calend-plano
        where mmv-eqpto-calend-plano.ep-codigo  =  i-ep-codigo-atu
          AND mmv-eqpto-calend-plano.cod-eqpto  =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mmv-eqpto-calend-plano.ep-codigo =  i-ep-codigo-new
               mmv-eqpto-calend-plano.cod-eqpto =  trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mmv-movto-mater
        WHERE mmv-movto-mater.ep-codigo  =  i-ep-codigo-atu
          AND mmv-movto-mater.cod-eqpto  =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mmv-movto-mater.ep-codigo =  i-ep-codigo-new
               mmv-movto-mater.cod-eqpto =  trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mmv-movto-ord
        WHERE mmv-movto-ord.ep-codigo  =  i-ep-codigo-atu 
          AND mmv-movto-ord.cod-eqpto  =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mmv-movto-ord.ep-codigo =  i-ep-codigo-new 
               mmv-movto-ord.cod-eqpto =  trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mmv-ord-manut
        where mmv-ord-manut.ep-codigo  =  i-ep-codigo-atu
          AND mmv-ord-manut.cod-eqpto  =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mmv-ord-manut.ep-codigo =  i-ep-codigo-new
               mmv-ord-manut.cod-eqpto =  trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mmv-tar-ord-manut
        where  mmv-tar-ord-manut.ep-codigo =  i-ep-codigo-atu
          AND  mmv-tar-ord-manut.cod-eqpto =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mmv-tar-ord-manut.ep-codigo =  i-ep-codigo-new
               mmv-tar-ord-manut.cod-eqpto =  trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH programac-ativ-param
        WHERE programac-ativ-param.idi-cod-param = 10 /* Equipamento*/
          AND programac-ativ-param.des-val-param = c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN programac-ativ-param.des-val-param = TRIM(c-cod-eqpto-new) NO-ERROR.
    END.

END PROCEDURE.

PROCEDURE tabelasPneus :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM i-ep-codigo-atu LIKE mab-eqpto.ep-codigo NO-UNDO.
    DEFINE INPUT PARAM i-ep-codigo-new LIKE mab-eqpto.ep-codigo NO-UNDO.
    DEFINE INPUT PARAM c-cod-eqpto-atu LIKE mab-eqpto.cod-eqpto NO-UNDO.
    DEFINE INPUT PARAM c-cod-eqpto-new LIKE mab-eqpto.cod-eqpto NO-UNDO.
    
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Tabelas_Pneus" *}
    RUN pi-acompanhar IN h-acomp (INPUT trim(c-cod-eqpto-atu) + " - " + RETURN-VALUE).
    /** PNEUS **/
                    /* mpn-pneu               */
                    /* mpn-pneu               */
                    /* mpn-histor-layout-eixo */
                    /* mpn-eqpto-serv         */
                    /* mpn-hora-estimad       */
                    /* mpn-movto-pneu         */
                    /* mpn-movto-pneu         */
    FOR EACH mpn-pneu
        where mpn-pneu.ep-codigo-ini  =  i-ep-codigo-atu 
          AND mpn-pneu.cod-eqpto-ini  =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mpn-pneu.ep-codigo-ini =  i-ep-codigo-new
               mpn-pneu.cod-eqpto-ini =  trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mpn-pneu
        where mpn-pneu.ep-codigo-atu  =  i-ep-codigo-atu 
          AND mpn-pneu.cod-eqpto-atu  =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mpn-pneu.ep-codigo-atu =  i-ep-codigo-new
               mpn-pneu.cod-eqpto-atu =  trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mpn-eqpto-serv
        where mpn-eqpto-serv.ep-codigo  =  i-ep-codigo-atu
          AND mpn-eqpto-serv.cod-eqpto  =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mpn-eqpto-serv.ep-codigo =  i-ep-codigo-new
               mpn-eqpto-serv.cod-eqpto =  trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mpn-histor-layout-eixo
        where mpn-histor-layout-eixo.ep-codigo  = i-ep-codigo-atu
          AND mpn-histor-layout-eixo.cod-eqpto  = c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mpn-histor-layout-eixo.ep-codigo = i-ep-codigo-new
               mpn-histor-layout-eixo.cod-eqpto = trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mpn-hora-estimad
        where mpn-hora-estimad.ep-codigo  = i-ep-codigo-atu
          AND mpn-hora-estimad.cod-eqpto  = c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mpn-hora-estimad.ep-codigo = i-ep-codigo-new
               mpn-hora-estimad.cod-eqpto = trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mpn-movto-pneu
        where mpn-movto-pneu.ep-codigo-ori =  i-ep-codigo-atu
          AND mpn-movto-pneu.cod-eqpto-ori =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mpn-movto-pneu.ep-codigo-ori =  i-ep-codigo-new
               mpn-movto-pneu.cod-eqpto-ori =  trim(c-cod-eqpto-new) no-error.
    end.
    FOR EACH mpn-movto-pneu
        where mpn-movto-pneu.ep-codigo-des =  i-ep-codigo-atu
          AND mpn-movto-pneu.cod-eqpto-des =  c-cod-eqpto-atu EXCLUSIVE-LOCK:
        ASSIGN mpn-movto-pneu.ep-codigo-des =  i-ep-codigo-new
               mpn-movto-pneu.cod-eqpto-des =  trim(c-cod-eqpto-new) no-error.
    end.

END PROCEDURE.

