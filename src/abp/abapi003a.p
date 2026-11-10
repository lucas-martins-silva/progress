/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ABAPI003A 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i abapi003a MAB}
&ENDIF


/******************************************************************************
**
**       PROGRAMA: ABAPI003A.p
**
**       DATA....: Fevereiro de 2005
**
**       AUTOR...: Fluer° Clovis Rohweder - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Validaá∆o da Atualizaá∆o Quilometragem
**
*******************************************************************************/
DEFINE TEMP-TABLE RowErrorsAux NO-UNDO
        FIELD ErrorSequence    AS INTEGER
        FIELD ErrorNumber      AS INTEGER
        FIELD ErrorDescription AS CHARACTER
        FIELD ErrorParameters  AS CHARACTER
        FIELD ErrorType        AS CHARACTER
        FIELD ErrorHelp        AS CHARACTER
        FIELD ErrorSubType     AS CHARACTER.

/*Vari†veis para c†lculo */
DEFINE VARIABLE deKmPossivel    AS DECIMAL NO-UNDO.
DEFINE VARIABLE deKmPossivelSec AS DECIMAL NO-UNDO.
DEFINE VARIABLE deConsumoTotal  AS DECIMAL NO-UNDO.
DEFINE VARIABLE iValParam       AS INTEGER NO-UNDO.
DEFINE VARIABLE deValDataHora   AS DECIMAL FORMAT "999999999999":U  NO-UNDO.
DEFINE VARIABLE deDifHod        AS DECIMAL NO-UNDO.
DEFINE VARIABLE iNumDias        AS INTEGER NO-UNDO.
DEFINE VARIABLE deConsPadr      AS DECIMAL NO-UNDO.
DEFINE VARIABLE deConsPadrSec   AS DECIMAL NO-UNDO.
DEFINE VARIABLE lUsaContSec     AS LOGICAL NO-UNDO.
DEFINE VARIABLE lTemModelxAtiv  AS LOGICAL NO-UNDO.
    
/*Calcula data hora invertida*/
{abp/ab9000.i }

DEFINE VARIABLE cReturn         AS CHARACTER NO-UNDO.

DEFINE INPUT  PARAMETER pOrigem     AS INTEGER                       NO-UNDO. /* 1 Abastecimento, 2 Pneu, 3 Manutená∆o */
DEFINE INPUT  PARAMETER pValHod     AS DECIMAL FORMAT ">,>>>,>>9.99" NO-UNDO. 
DEFINE INPUT  PARAMETER pValHodSec  AS DECIMAL FORMAT ">,>>>,>>9.99" NO-UNDO.
&IF "{&mguni_version}" >= "2.071" &THEN
DEFINE INPUT  PARAMETER pEmpresa    LIKE empresa.ep-codigo           NO-UNDO.
&ELSE
DEFINE INPUT  PARAMETER pEmpresa    AS INTEGER                       NO-UNDO.
&ENDIF
DEFINE INPUT  PARAMETER peqpto      AS CHARACTER                     NO-UNDO.
DEFINE INPUT  PARAMETER pData       AS DATE                          NO-UNDO.
DEFINE INPUT  PARAMETER pHora       AS CHARACTER                     NO-UNDO.
DEFINE INPUT  PARAMETER pAtividade  LIKE mab-ativid.cod-ativid       NO-UNDO.
DEFINE OUTPUT PARAMETER pValContAnt AS DECIMAL FORMAT ">,>>>,>>9.99" NO-UNDO.
DEFINE OUTPUT PARAMETER pPerRod     AS DECIMAL FORMAT ">,>>>,>>9.99" NO-UNDO.
DEFINE OUTPUT PARAMETER pMaxPer     AS DECIMAL                       NO-UNDO.

/* Validaá∆o para API rodar Persistente */
IF  this-procedure:PERSISTENT THEN RETURN 'ok':u.

RUN validaQuilometragem (INPUT  pOrigem,
                         INPUT  pValHod,
                         INPUT  pValHodSec,
                         INPUT  pEmpresa,
                         INPUT  peqpto,
                         INPUT  pData,
                         INPUT  pHora,
                         INPUT  pAtividade,
                         OUTPUT pValContAnt,
                         OUTPUT pPerRod,
                         OUTPUT pMaxPer).

ASSIGN cReturn = RETURN-VALUE.
RETURN cReturn.

PROCEDURE validaQuilometragem:
    DEFINE INPUT  PARAMETER pOrigem     AS INTEGER                       NO-UNDO. /* 1 Abastecimento, 2 Pneu, 3 Manutená∆o */
    DEFINE INPUT  PARAMETER pValHod     AS DECIMAL FORMAT ">,>>>,>>9.99" NO-UNDO. 
    DEFINE INPUT  PARAMETER pValHodSec  AS DECIMAL FORMAT ">,>>>,>>9.99" NO-UNDO. 
&IF "{&mguni_version}" >= "2.071" &THEN
    DEFINE INPUT  PARAMETER pEmpresa    LIKE empresa.ep-codigo           NO-UNDO.
&ELSE
    DEFINE INPUT  PARAMETER pEmpresa    AS INTEGER                       NO-UNDO.
&ENDIF
    DEFINE INPUT  PARAMETER peqpto      AS CHARACTER                     NO-UNDO.
    DEFINE INPUT  PARAMETER pData       AS DATE                          NO-UNDO.
    DEFINE INPUT  PARAMETER pHora       AS CHARACTER                     NO-UNDO.
    DEFINE INPUT  PARAMETER pAtividade  LIKE mab-ativid.cod-ativid       NO-UNDO.
    DEFINE OUTPUT PARAMETER pValContAnt AS DECIMAL FORMAT ">,>>>,>>9.99" NO-UNDO.
    DEFINE OUTPUT PARAMETER pPerRod     AS DECIMAL FORMAT ">,>>>,>>9.99" NO-UNDO.
    DEFINE OUTPUT PARAMETER pMaxPer     AS DECIMAL                       NO-UNDO.    

    /* Busca parametro % Aceitaá∆o Consumo (param 14) ex: 20% */
    FOR FIRST mab-param FIELDS(cdn-param des-valor)
        WHERE mab-param.cdn-param = 14 NO-LOCK:
        ASSIGN iValParam = INT(mab-param.des-valor).
    END.
    /** Converte hora da ficha para invertida **/
    RUN converteParaHoraInvertida (INPUT string(pData,"99/99/9999"),
                                   INPUT pHora,
                                   OUTPUT deValDataHora).
    /** Busca Equipamento da ficha **/
    FOR FIRST mab-eqpto
        WHERE mab-eqpto.ep-codigo = pEmpresa 
        AND   mab-eqpto.cod-eqpto = pEqpto NO-LOCK:
        /** Zera vari†veis para in°cio do c†lculo **/
        ASSIGN deKmPossivel   = 0
               deDifHod       = 0
               iNumDias       = 0
               deConsumoTotal = 0
               pValContAnt    = 0
               pPerRod        = 0
               pMaxPer        = 0
               lUsaContSec    = NO
               lTemModelxAtiv = NO.

        /** Valida se atividade foi informada na ficha **/
        IF  TRIM(pAtividade) <> "" THEN DO:
            IF can-find(FIRST mab-consu-model
                        WHERE mab-consu-model.cod-model      = mab-eqpto.cod-model
                        AND   mab-consu-model.cod-ativid     = trim(pAtividade) NO-LOCK) THEN DO:
                ASSIGN lTemModelxAtiv = YES.
            END.
        END.
        /* Equipamento Motorizado */
        IF mab-eqpto.idi-tip-eqpto = 1 THEN DO: 
            /* Busca o ultimo historico do combustivel */
            FOR LAST mab-histor-combust
                WHERE mab-histor-combust.ep-codigo      = mab-eqpto.ep-codigo
                AND   mab-histor-combust.cod-eqpto      = mab-eqpto.cod-eqpto
                AND   mab-histor-combust.dat-inicial   <= pData 
                AND   mab-histor-combust.idi-tip-consu >  1 NO-LOCK: /* 1 Sem Consumo */
                /** Percurso por Quantidade Ex: KM/L (quantos KM fiz com 1 litro) **/
                IF mab-histor-combust.idi-tip-consu = 2 THEN
                    ASSIGN deKmPossivel = mab-histor-combust.val-consu-padr * mab-histor-combust.val-capac-tanque
                           deConsPadr   = mab-histor-combust.val-consu-padr.
                /** Quantidade por Percurso Ex: L/H (quantos litro gastei em 1 hora) **/
                ELSE 
                    ASSIGN deKmPossivel = mab-histor-combust.val-capac-tanque / mab-histor-combust.val-consu-padr 
                           deConsPadr   =  mab-histor-combust.val-consu-padr.
                /** Guarda Secund†rio **/
                IF mab-eqpto.log-cont-sec THEN DO:
                    /** Percurso por Quantidade Ex: KM/L (quantos KM fiz com 1 litro) **/
                    IF  mab-histor-combust.num-livre-1 = 2 THEN
                        ASSIGN deKmPossivelSec = mab-histor-combust.val-livre-1 * mab-histor-combust.val-capac-tanque
                               deConsPadrSec   = mab-histor-combust.val-livre-1.
                    /** Quantidade por Percurso Ex: L/H (quantos litro gastei em 1 hora) **/
                    ELSE
                        ASSIGN deKmPossivelSec = mab-histor-combust.val-capac-tanque / mab-histor-combust.val-livre-1
                               deConsPadrSec   = mab-histor-combust.val-livre-1.
                END.
            END.
            /** Se Tem Consumo por Atividade no Modelo deste equipamennto, ignora o consumo padr∆o do hist¢rico de combust°vel **/
            IF lTemModelxAtiv AND AVAIL mab-histor-combust AND pOrigem = 1 THEN DO:
                /* Busca o ultimo historico do combustivel */
                FOR FIRST mab-consu-model
                    WHERE mab-consu-model.cod-model = mab-eqpto.cod-model
                    AND   mab-consu-model.cod-ativid  = pAtividade NO-LOCK:
                    /** Percurso por Quantidade Ex: KM/L (quantos KM fiz com 1 litro) **/
                    IF  mab-histor-combust.idi-tip-consu = 2 THEN
                        ASSIGN deKmPossivel = mab-consu-model.val-consu-padr * mab-histor-combust.val-capac-tanque
                               deConsPadr   = mab-consu-model.val-consu-padr.
                    /** Quantidade por Percurso Ex: L/H (quantos litro gastei em 1 hora) **/
                    ELSE 
                        ASSIGN deKmPossivel = mab-histor-combust.val-capac-tanque / mab-consu-model.val-consu-padr 
                               deConsPadr   = mab-consu-model.val-consu-padr.
                    /** Guarda Secund†rio **/
                    IF mab-eqpto.log-cont-sec THEN DO:
                        /* num-livre-1 Referente ao campo idi-tip-consu-sec */
                        /* val-livre-1 referente ao campo val-consu-sec */
                        /** Percurso por Quantidade Ex: KM/L (quantos KM fiz com 1 litro) **/
                        IF  mab-histor-combust.num-livre-1 = 2 THEN
                            ASSIGN deKmPossivelSec = mab-consu-model.val-consu-sec * mab-histor-combust.val-capac-tanque
                                   deConsPadrSec   = mab-consu-model.val-consu-sec.
                        /** Quantidade por Percurso Ex: L/H (quantos litro gastei em 1 hora) **/
                        ELSE
                            ASSIGN deKmPossivelSec = mab-histor-combust.val-capac-tanque / mab-consu-model.val-consu-sec
                                   deConsPadrSec   = mab-consu-model.val-consu-sec.
                    END.
                END.
            END.
            /** Calcula Uso Real Rodado pelo equipamento (Hodìmetro / Hor°metro) **/
            FOR first mab-item-abastec
                where mab-item-abastec.ep-codigo = mab-eqpto.ep-codigo
                and   mab-item-abastec.cod-eqpto = mab-eqpto.cod-eqpto
                and   mab-item-abastec.log-abastec-prim
                and   mab-item-abastec.val-dat-hora-invrtda < deValDataHora NO-LOCK:
            END.
            IF AVAIL mab-item-abastec THEN DO:
                /** Busca Apontamento anterior para comparaá∆o **/
                for last  mab-item-abastec fields(num-docto)
                    where mab-item-abastec.ep-codigo = mab-eqpto.ep-codigo
                    and   mab-item-abastec.cod-eqpto = mab-eqpto.cod-eqpto
                    and   mab-item-abastec.log-abastec-prim
                    and   mab-item-abastec.val-dat-hora-invrtda < deValDataHora no-lock:
                    for first mab-abastec-lubrific
                        where mab-abastec-lubrific.num-docto = mab-item-abastec.num-docto no-lock:

                        ASSIGN deConsumoTotal = deKmPossivel + (deKmPossivel * (iValParam / 100))
                               pMaxPer        = deConsumoTotal
                               /*Compara com hodìmetro do £ltimo abastecimento */
                               deDifHod       = pValHod - mab-abastec-lubrific.val-hodom-horim
                               pValContAnt    = mab-abastec-lubrific.val-hodom-horim
                               pPerRod        = pValHod - mab-abastec-lubrific.val-hodom-horim.
                        /*Comparando os valores */
                        IF deDifHod > deConsumoTotal THEN 
                           RETURN "NOK":U.

                        /*C†lcula o consumo total possivel de acordo com os parametros*/
                        IF mab-eqpto.log-cont-sec AND pOrigem <> 2 THEN DO:
                            ASSIGN deConsumoTotal = deKmPossivelSec + (deKmPossivelSec * (iValParam / 100))
                                   pMaxPer        = deConsumoTotal
                                   /*Compara com hodìmetro do £ltimo abastecimento */
                                   deDifHod       = pValHodSec - mab-abastec-lubrific.val-hodom-horim-sec
                                   pValContAnt    = mab-abastec-lubrific.val-hodom-horim-sec
                                   pPerRod        = pValHodSec - mab-abastec-lubrific.val-hodom-horim-sec.
                            /*Comparando os valores */
                            IF deDifHod > deConsumoTotal THEN DO:
                                ASSIGN lUsaContSec = YES.
                                RETURN "NOK":U.
                            END.
                        END.
                    END.
                end.
            end.
            else DO:
                /*C†lcula o consumo total possivel de acordo com os parametros*/
                ASSIGN deConsumoTotal = deKmPossivel + (deKmPossivel * (iValParam / 100))
                       pMaxPer        = deConsumoTotal
                       /** Compara com hodìmetro inicial do equipamento **/
                       deDifHod       = pValHod - mab-eqpto.val-hodom-horim-inicial
                       pValContAnt    = mab-eqpto.val-hodom-horim-inicial
                       pPerRod        = pValHod - mab-eqpto.val-hodom-horim-inicial.
                /* Comparando os valores */
                IF deDifHod > deConsumoTotal THEN 
                   RETURN "NOK":U.

                IF mab-eqpto.log-cont-sec AND pOrigem <> 2 THEN DO:
                    /*C†lcula o consumo total possivel de acordo com os parametros*/
                    ASSIGN deConsumoTotal = deKmPossivelSec + (deKmPossivelSec * (iValParam / 100))
                           pMaxPer        = deConsumoTotal
                           /** Compara com hodìmetro inicial do equipamento **/
                           deDifHod       = pValHodSec - mab-eqpto.val-hodom-horim-sec
                           pValContAnt    = mab-eqpto.val-hodom-horim-sec
                           pPerRod        = pValHodSec - mab-eqpto.val-hodom-horim-sec.
                    /*Comparando os valores */
                    IF deDifHod > deConsumoTotal THEN DO:
                        ASSIGN lUsaContSec = YES.
                        RETURN "NOK":U.
                    END.
                END.
            END.
        END.
        /* Eqpto nao motorizado */ 
        ELSE DO:
            /** Busca cadastro do modelo para validar m†ximo a percorrer di†rio **/
            FOR FIRST mab-model
                WHERE mab-model.cod-model = mab-eqpto.cod-model NO-LOCK:
                /** Verifica se existe vida anterior a ficha que est† sendo inclu°da **/
                IF CAN-FIND(FIRST mab-movto-km-eqpto
                            WHERE mab-movto-km-eqpto.ep-codigo = mab-eqpto.ep-codigo
                            and   mab-movto-km-eqpto.cod-eqpto = mab-eqpto.cod-eqpto
                            and   mab-movto-km-eqpto.val-dat-hora-invrtda < deValDataHora NO-LOCK) THEN DO:
                    /** Busca vida anterior para validar quanto percorreu desde £ltimo hist¢rico **/
                    FOR LAST mab-movto-km-eqpto
                        WHERE mab-movto-km-eqpto.ep-codigo            = mab-eqpto.ep-codigo
                        and   mab-movto-km-eqpto.cod-eqpto            = mab-eqpto.cod-eqpto
                        and   mab-movto-km-eqpto.val-dat-hora-invrtda < deValDataHora NO-LOCK:
                        /** Valida Contador prim†rio **/
                        ASSIGN iNumDias    = IF (pData - mab-movto-km-eqpto.dat-movto <= 0) THEN 1 ELSE pData - mab-movto-km-eqpto.dat-movto
                               pValContAnt = mab-movto-km-eqpto.val-hodom-horim
                               pPerRod     = pValHod - mab-movto-km-eqpto.val-hodom-horim
                               deDifHod    = iNumDias * mab-model.val-consu-previs.
                        IF deDifHod > pValHod THEN 
                           RETURN "NOK":U.
                        /** Valida Contador Secund†rio **/
                        IF mab-eqpto.log-cont-sec AND pOrigem <> 2 THEN DO:
                            ASSIGN iNumDias    = IF (pData - mab-movto-km-eqpto.dat-movto <= 0) THEN 1 ELSE pData - mab-movto-km-eqpto.dat-movto
                                   pValContAnt = mab-movto-km-eqpto.val-livre-1 /* Referente ao campo val-hodom-horim-sec */
                                   pPerRod     = pValHod - mab-movto-km-eqpto.val-livre-1 /* Referente ao campo val-hodom-horim-sec */
                                   deDifHod    = iNumDias * mab-model.val-consu-previs.
                            IF deDifHod > pValHodSec THEN DO:
                                ASSIGN lUsaContSec = YES.
                                RETURN "NOK":U.
                            END.
                        END.
                    END.
                END.
                ELSE DO:
                    /** Valida Contador prim†rio **/
                    ASSIGN iNumDias    = IF (pData - mab-eqpto.dat-inicial <= 0) THEN 1 ELSE pData - mab-eqpto.dat-inicial
                           pValContAnt = mab-eqpto.val-hodom-horim-inicial
                           pPerRod     = pValHod - mab-eqpto.val-hodom-horim-inicial
                           deDifHod    = iNumDias * mab-model.val-consu-previs.
                    IF deDifHod > pValHod THEN 
                       RETURN "NOK":U.
                    /** Valida Contador Secund†rio **/
                    IF mab-eqpto.log-cont-sec AND pOrigem <> 2 THEN DO:
                        ASSIGN iNumDias    = IF (pData - mab-eqpto.dat-inicial <= 0) THEN 1 ELSE pData - mab-eqpto.dat-inicial
                               pValContAnt = mab-eqpto.val-hodom-horim-sec 
                               pPerRod     = pValHod - mab-eqpto.val-hodom-horim-sec
                               deDifHod    = iNumDias * mab-model.val-consu-previs.
                        IF deDifHod > pValHodSec THEN DO:
                            ASSIGN lUsaContSec = YES.
                            RETURN "NOK":U.
                        END.
                    END.
                END.
            END.
        END. /** else motorizado **/
    END. /** mab-eqpto **/
    /** Caso n∆o ocorreu nenhum erro, chegou ao final da procedure e retorna OK **/
    RETURN "OK":U.

END PROCEDURE.

PROCEDURE validaAtividade:
&IF "{&mguni_version}" >= "2.071" &THEN
    DEFINE INPUT  PARAMETER pEmpresa          LIKE empresa.ep-codigo           NO-UNDO.
&ELSE
    DEFINE INPUT  PARAMETER pEmpresa          AS INTEGER                       NO-UNDO.
&ENDIF
    DEFINE INPUT  PARAMETER peqpto            AS CHARACTER                     NO-UNDO.
    DEFINE INPUT  PARAMETER pAtividade        LIKE mab-ativid.cod-ativid       NO-UNDO.
    DEFINE OUTPUT PARAMETER cModelo           AS CHARACTER                     NO-UNDO.
    DEFINE OUTPUT PARAMETER cRetornoAtividade AS LOGICAL                       NO-UNDO.

    ASSIGN cRetornoAtividade = NO.

    /** S¢ realiza a validaá∆o, se foi informada atividade na ficha **/
    IF TRIM(pAtividade) <> "" THEN DO:
        FOR FIRST mab-eqpto
            WHERE mab-eqpto.ep-codigo = pEmpresa
            AND   mab-eqpto.cod-eqpto = peqpto NO-LOCK:
            /** Guarda modelo para exibir na pergunta **/
            ASSIGN cModelo = mab-eqpto.cod-model.
            /** Se encontrou o relacionamento, n∆o exibir† a pergunta **/
            FOR FIRST mab-consu-model
                WHERE mab-consu-model.cod-model  = mab-eqpto.cod-model
                AND   mab-consu-model.cod-ativid = trim(pAtividade) NO-LOCK:
                ASSIGN cRetornoAtividade  = YES.
            END.
        END.
    END.
    /** Caso atividade esteja em branco, n∆o faz a pergunta **/
    ELSE DO:
        ASSIGN cRetornoAtividade = YES.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE retornaLogical:
    DEFINE OUTPUT PARAMETER plUsaContSec     AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER plTemModelxAtiv  AS LOGICAL NO-UNDO.

    ASSIGN plUsaContSec    = lUsaContSec
           plTemModelxAtiv = lTemModelxAtiv.

    RETURN "OK":U.
END PROCEDURE.

   

