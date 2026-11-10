/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0116A 2.00.00.014}
{cdp/cdcfgmnt.i} /* Versäes EMS MNT */
{cdp/cd9911.i}  /* Varifica Unidade Neg¢cio */
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0116a MAB}
&ENDIF


/*****************************************************************************************
       abp/ab0116a.p - Carrega a TEMP-TABLE DE PAR¶METROS
******************************************************************************************/
{include/i_fnctrad.i} /** Multi Idioma **/

{abp/ab0116.i} /* defini‡Æo da temp-table ttParam */

DEFINE OUTPUT PARAM TABLE FOR ttParam. 
DEFINE VARIABLE i-cont  as integer             no-undo.
DEFINE VARIABLE c-lista as CHARACTER           no-undo.
DEFINE VARIABLE c-aux1  as CHARACTER extent 16 NO-UNDO.
DEFINE VARIABLE c-aux2  as CHARACTER extent 16 NO-UNDO.
DEFINE VARIABLE c-aux3  AS CHARACTER           NO-UNDO.

DEFINE VARIABLE c-item  as CHARACTER FORMAT "x(200)" extent 16 NO-UNDO INITIAL ["Indica quais os custos dos gastos gerais serÆo enviados na integra‡Æo de custos com o Agroind£stria.",
                                                                              "Indica se a deprecia‡Æo ser  enviada na integra‡Æo de custos com o Agroind£stria",
                                                                              "Indica se o c¢digo do funcion rio a ser utilizado ser  a matr¡cula ou o c¢digo de pessoa f¡sica",
                                                                              "Indica se gera vida de equipamento atrav‚s dos movimentos de pneus utilizando o contador informado",
                                                                              "Integra Nota Fiscal com Frotas",
                                                                              "Habilita Requisi‡Æo Eletr“nica para Ordens de Manuten‡Æo",
                                                                              "Gera Narrativa Completa para Fichas de Abastecimento",
                                                                              "Tipo de Integra‡Æo do Frotas com o Estoque do EMS (Gera‡Æo de Requisi‡Æo)",
                                                                              "Indica se permite ou nÆo o termino da OM com solicita‡äes ou requisi‡äes em aberto",
                                                                              "Indica quais integra‡äes o sistema ter  com sistemas de rastreamento.",
                                                                              "Gera Narrativa Completa para Movimento de Estoque Gerado pelo Movimento de Pneus",
                                                                              "Indica o Tipo de Integra‡Æo com o M¢dulo de Patrim“nio",
                                                                              "Realiza o Recebimento da transa‡Æo de Funcion rios realizados no FT1500 com Unidade de Neg¢cio.",
                                                                              "Realiza a Intregra‡Æo com Mobile.",
                                                                              "Integra com Execu‡Æo Or‡ament ria?",
                                                                              "Permite definir crit‚rio/regra de sequˆncia da busca e defini‡Æo do centro de custo do documento para aprova‡Æo no MLA"].

DEFINE VARIABLE c-Label as CHARACTER FORMAT "x(40)" extent 16 NO-UNDO INITIAL ["Integra‡Æo Gastos Gerais (GGF)",
                                                                              "Integra Deprecia‡Æo",
                                                                              "C¢digo Funcion rio Utilizado",
                                                                              "Uso prim rio equipamento no pneu",
                                                                              "Integra Nota Fiscal com Frotas",
                                                                              "Habilita Requisi‡Æo Eletr“nica",
                                                                              "Gera Narrativa",
                                                                              "Tipo Integra‡Æo EMS",
                                                                              "Permite Terminar OM",
                                                                              "Integra Sistema Rastreamento",
                                                                              "Gerar Narrativa Movimento de Pneus",
                                                                              "Tipo de Integra‡Æo Patrim“nio",
                                                                              "Recebimento Cadastro Funcion rio",
                                                                              "Habilita Integra‡Æo com Mobile",
                                                                              "Execu‡Æo Or‡ament ria",
                                                                              "Aprova‡Æo MLA - Busca do Centro de Custo"].

EMPTY TEMP-TABLE  ttParam.

{utp/ut-liter.i NÆo}
assign c-aux3 = trim(return-value).
do i-cont = 1 to EXTENT(c-item):
    {utp/ut-liter.i NÆo}
    assign c-aux3 = c-aux3 + "," + trim(return-value).
END.
Do i-cont = 1 to EXTENT(c-item):
    IF NOT CAN-FIND(mab-param-integr WHERE 
                    mab-param-integr.cdn-param = i-cont) THEN DO:

        run utp/ut-liter.p (input c-item[i-cont],
                            input "*",
                            input "R").
        ASSIGN c-aux1[i-cont] = RETURN-VALUE.

        run utp/ut-liter.p (input c-label[i-cont],
                            input "*",
                            input "R").
        ASSIGN c-aux2[i-cont] = RETURN-VALUE.

        create mab-param-integr.
        assign mab-param-integr.cdn-param       = i-cont
               mab-param-integr.des-label-param = substring(c-aux2[i-cont], 1, 40)
               mab-param-integr.des-param       = substring(c-aux1[i-cont], 1, 200)
               mab-param-integr.des-valor       = IF i-cont = 1 THEN c-aux3 ELSE IF i-cont = 4 THEN "2":U ELSE "":U.
        IF i-cont = 2 OR i-cont = 7 THEN
            ASSIGN mab-param-integr.des-valor = "1".
        IF  i-cont = 5 THEN DO:
            FIND FIRST funcao
                 WHERE funcao.cd-funcao = "spp-mab-nf":U EXCLUSIVE-LOCK NO-ERROR.
        END.
        IF  i-cont = 6 THEN DO:
            FIND FIRST funcao
                 WHERE funcao.cd-funcao = "spp-int-req-om":U EXCLUSIVE-LOCK NO-ERROR.
        END.
        IF  i-cont = 5 OR i-cont = 6 THEN DO:
            IF  AVAIL funcao THEN DO:
                IF  funcao.ativo THEN
                    ASSIGN mab-param-integr.des-valor = "1":U.
                ELSE
                    ASSIGN mab-param-integr.des-valor = "2":U.
            END.
            ELSE
                ASSIGN mab-param-integr.des-valor = "2":U.
        END.
        IF i-cont = 8 THEN DO:
            FOR FIRST mab-param
                WHERE mab-param.cdn-param = 11 EXCLUSIVE-LOCK:
                ASSIGN mab-param-integr.des-valor = mab-param.des-valor.
                /** Atualiza campo livre para definir que a altera‡Æo dos parametros j  ocorreu **/
                ASSIGN mab-param.log-livre-1      = YES.
                /** Define os novos labels e descri‡äes do parametro 11 **/
                run utp/ut-liter.p (input "Consistir Fichas Abastecimento e Lubrifica‡Æo",
                                    input "*",
                                    input "R").
                ASSIGN mab-param.des-label-param  = RETURN-VALUE
                       mab-param.des-param        = RETURN-VALUE
                       mab-param.des-valor        = IF mab-param.des-valor = "1" OR mab-param.des-valor = "2" THEN "1" ELSE "2".
            END.
        END.
        if i-cont = 9 then do:
            assign mab-param-integr.des-valor = "1".
        end.
        IF i-cont = 10 THEN DO:
            {utp/ut-liter.i NÆo}
            ASSIGN mab-param-integr.des-valor = trim(return-value) + ",":U + trim(return-value) + ",":U + trim(return-value) + ",":U + trim(return-value) + ",":U.
        END.
        if i-cont = 11 THEN
            ASSIGN mab-param-integr.des-valor = "2".

        IF i-cont = 12 THEN DO:
            /** Busca mab-param" **/
            FOR FIRST mab-param
                WHERE mab-param.cdn-param = 35 EXCLUSIVE-LOCK:
                /** Atualiza campo livre para definir que a altera‡Æo dos parƒmetros j  ocorreu **/
                ASSIGN mab-param.log-livre-1 = YES.
                /** Define novo label do parametro 35 **/
                RUN utp/ut-liter.p (INPUT "Integra‡Æo Patrim“nio (ver AB0116)",
                                    INPUT "*",
                                    INPUT "R").
                ASSIGN mab-param.des-label-param  = TRIM(RETURN-VALUE).

                IF mab-param.des-valor = "1" THEN DO:
                    {utp/ut-liter.i NÆo}
                END. 
                ELSE DO:
                    {utp/ut-liter.i Sim}
                END.
                ASSIGN mab-param-integr.des-valor = TRIM(RETURN-VALUE) + ",".
                {utp/ut-liter.i NÆo}
                ASSIGN mab-param-integr.des-valor = mab-param-integr.des-valor + TRIM(RETURN-VALUE) + ",1,"
                       mab-param.des-valor        = "".
            END.
        END.

        IF i-cont = 13 THEN
            ASSIGN mab-param-integr.des-valor = "2,1".

        IF i-cont = 14 THEN
            ASSIGN mab-param-integr.des-valor = "2".
        IF i-cont = 15 THEN DO:
            {utp/ut-liter.i NÆo}
            ASSIGN mab-param-integr.des-valor = trim(return-value) + ",":U + trim(return-value) + ",":U + trim(return-value) + ",":U +
                                                trim(return-value) + ",":U + trim(return-value) + ",":U.
        END.


        /******************************************************************************************************************
         A sequencia numerica pode ser alterada pelo usuario, mas a descri‡Æo dos crit‚rios tem sua sequencia fixa.
             Parametros PadrÆo do Crit‚rio/regra: "1,2,3,4"
            --------------------------------------------------------------------------------
            | Sequencia Crit‚rio  | Descri‡Æo dos Crit‚rios de busca  
            --------------------------------------------------------------------------------
            | 1                   | Primeira Posi‡Æo: Centro de Custo da Conta da OM                 
            | 2                   | Segunda Posi‡Æo: Centro de Custo do Solicitante                  
            | 3                   | Terceira Posi‡Æo: Centro de Custo da Conta de Despesa da OM      
            | 4                   | Quarta Posi‡Æo: Centro de Custo do Equipamento                   
            --------------------------------------------------------------------------------
        ********************************************************************************************************************/

        IF  i-cont = 16 THEN DO:
            ASSIGN mab-param-integr.des-valor = "1,2,3,4".
        END.

    END.
    ELSE DO:
        /** Realiza a Tradu‡Æo MultiIdioma para Labels e Descri‡äes **/
        FOR FIRST mab-param-integr
            WHERE mab-param-integr.cdn-param = i-cont EXCLUSIVE-LOCK:
            run utp/ut-liter.p (input mab-param-integr.des-label-param,
                                input "*",
                                input "R").

            ASSIGN mab-param-integr.des-label-param = RETURN-VALUE.

            run utp/ut-liter.p (input mab-param-integr.des-param,
                                input "*",
                                input "R").

            assign mab-param-integr.des-param = RETURN-VALUE.
        END.
    END.
END.

FOR each mab-param-integr EXCLUSIVE-LOCK:
    CREATE ttParam.
    assign ttParam.cdn-param       =  mab-param-integr.cdn-param
           ttParam.des-label-param =  mab-param-integr.des-label-param
           ttParam.des-param       =  mab-param-integr.des-param
           ttParam.des-valor       =  mab-param-integr.des-valor.
END.

/*----------------------------------------------------------------------------------*/
/* Se tabela parƒmetros do sistema de manuten‡Æo industrial nÆo estiver sido criada */
/* deve-se cri -la e deixar os campos em branco para que se possa cadastrar os      */
/* n¡veis de TAG                                                                    */
/*----------------------------------------------------------------------------------*/

IF not can-find(first param-mi) then do:
    create param-mi.
END.

RETURN "OK":U.
