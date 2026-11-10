/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0503RP LIBERADO}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AQ0503RP MAQ}
&ENDIF

/******************************************************************************
**
**       Programa: AQ0503RP.P
**
**       Data....: 30/03/2016.
**
**       Objetivo: Cálculo Frete Coleta 
**                 M¢dulo Aquisi‡Æo de Produtos Rurais.
** 
******************************************************************************/
{utp/ut-glob.i}
{include/tt-edit.i}
{include/i-rpvar.i} 

{cdp/cd0031.i}  /* seguranca por estabelecimento */


/* ************************  TEMP-TABLES DEFINITIONS ********************** */    
DEFINE TEMP-TABLE tt-preco-frete-coleta NO-UNDO
    LIKE preco-frete-coleta
    FIELD valor-frete-pagar     AS DECIMAL
    FIELD valor-frete-padrao    AS DECIMAL
    FIELD n-abrang-certas AS INTEGER INITIAL 0 COLUMN-LABEL "Abrang" FORMAT "9"
    FIELD peso            AS INTEGER INITIAL 0 COLUMN-LABEL "Peso"   FORMAT "9".  
    
{aqp/aq0503.i} /*  tt-param - tt-digita - tt-raw-digita */

/* ************************  DEFINITIONS ********************************* */
DEFINE VARIABLE d-val-frete           AS DECIMAL NO-UNDO.
DEFINE VARIABLE l-regra-especifica    AS LOGICAL NO-UNDO.
DEFINE VARIABLE i-n-abrang-certas-aux AS INTEGER NO-UNDO.
DEFINE VARIABLE d-peso-aux            AS INTEGER NO-UNDO.
DEFINE VARIABLE i-cont                AS INTEGER NO-UNDO.
    
DEFINE BUFFER bf-carg-rural FOR carg-rural.   
    
/* ************************  PARAMETERS DEFINITIONS ********************** */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.   

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

{utp/ut-liter.i C lculo_Frete_Coleta}
RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

ASSIGN c-programa     = "AQ0503":U
       c-versao       = "I.00":U
       c-revisao      = "001":U
       c-sistema      = RETURN-VALUE
       c-rodape       = "TOTVS - ":U + c-programa  +  " - V:":U + c-versao.
       c-rodape       = FILL("-", 132 - LENGTH(c-rodape)) + c-rodape.
       
FIND FIRST param-global NO-LOCK NO-ERROR.
IF AVAIL param-global THEN
    ASSIGN c-empresa  = param-global.grupo. 

FIND FIRST tt-param NO-ERROR.
 
RUN pi-executar IN THIS-PROCEDURE.

RUN pi-finalizar IN h-acomp.

/* Geracao de planilha */
IF tt-param.lista-detalhado THEN
    RUN aqp/aq0503b.p(INPUT TABLE tt-param, INPUT TABLE tt-carga-preco).
ELSE 
    RUN aqp/aq0503a.p(INPUT TABLE tt-param, INPUT TABLE tt-carga-preco).
    


RETURN "OK":U.

/******************************* PROCEDURES ***********************************/
PROCEDURE pi-executar:
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-carga-preco NO-ERROR.
    
    FOR EACH carg-rural NO-LOCK
       WHERE carg-rural.dat-trans   >= tt-param.dt-trans-ini
         AND carg-rural.dat-trans   <= tt-param.dt-trans-fim
         AND carg-rural.cod-transp  >= tt-param.cod-transp-ini
         AND carg-rural.cod-transp  <= tt-param.cod-transp-fim
         AND carg-rural.cod-estabel >= tt-param.cod-estab-ini
         AND carg-rural.cod-estabel <= tt-param.cod-estab-fim     
         AND carg-rural.cod-rota    >= tt-param.cod-rota-ini
         AND carg-rural.cod-rota    <= tt-param.cod-rota-fim 
         AND carg-rural.it-codigo   >= tt-param.it-codigo-ini
         AND carg-rural.it-codigo   <= tt-param.it-codigo-fim
         AND carg-rural.cod-placa   >= tt-param.cod-placa-ini
         AND carg-rural.cod-placa   <= tt-param.cod-placa-fim:
         
        {cdp/cd0031a.i carg-rural.cod-estabel} /* seguranca por estabelecimento */
        
        FOR FIRST mdfe-veic FIELDS(cdn-tip-veic qtd-capac-vol) NO-LOCK 
            WHERE mdfe-veic.cod-inter-veic = carg-rural.cod-inter-veic:
            
            RUN pi-acompanhar IN h-acomp (INPUT c-acomp[1] + " - ":U + STRING(carg-rural.num-carg)).
            
            CREATE tt-carga-preco.
            BUFFER-COPY carg-rural TO tt-carga-preco NO-ERROR.
            ASSIGN tt-carga-preco.cdn-tip-veic  = mdfe-veic.cdn-tip-veic
                   tt-carga-preco.qtd-capac-vol = mdfe-veic.qtd-capac-vol
                   tt-carga-preco.dif-qtde      = carg-rural.qtd-aferid - carg-rural.qtd-coleta.                   
                   
            FOR FIRST tip-veic-transp FIELDS(des-tip-veic) NO-LOCK
                WHERE tip-veic-transp.cdn-tip-veic = mdfe-veic.cdn-tip-veic:
                ASSIGN tt-carga-preco.des-tip-veic = tip-veic-transp.des-tip-veic.
            END.
                   
            FOR FIRST transporte FIELDS(nome) NO-LOCK
                WHERE transporte.cod-transp = carg-rural.cod-transp:
                ASSIGN tt-carga-preco.nome = transporte.nome.
            END.
            
            FOR FIRST rota-coleta FIELDS(val-percur des-rota) NO-LOCK
                WHERE rota-coleta.cod-rota = carg-rural.cod-rota:
                ASSIGN tt-carga-preco.des-rota   = rota-coleta.des-rota
                       tt-carga-preco.val-percur = rota-coleta.val-percur.                
            END.            
            /* Busca quantidade reprovada da carga */
            FOR EACH liber-carg FIELDS(val-quant idi-aprova) NO-LOCK
               WHERE liber-carg.num-carg = carg-rural.num-carg:
                IF liber-carg.idi-aprova = 3 THEN /* Reprovado */
                    ASSIGN tt-carga-preco.qtd-reprovada = tt-carga-preco.qtd-reprovada + liber-carg.val-quant.               
            END.
            
            FOR EACH naocfedade-carg FIELDS(cdn-naocfedade) NO-LOCK
               WHERE naocfedade-carg.num-carg = carg-rural.num-carg:
               FOR EACH dest-cust-naocfedade FIELDS(cod-propried val-dest) NO-LOCK
                  WHERE dest-cust-naocfedade.cdn-naocfedade = naocfedade-carg.cdn-naocfedade:                  
                  /* SE A PROPRIEADE ESTIVER EM BRANCO, O PENALIZADO É TRANSPORTADOR */
                  IF dest-cust-naocfedade.cod-propried = "" THEN
                      ASSIGN tt-carga-preco.val-debit-transp = tt-carga-preco.val-debit-transp + dest-cust-naocfedade.val-dest.
               END.
            END.
            
            FOR EACH produt-carg FIELDS(cdn-produt-rural cdn-produt-resp cdn-motiv-nao-coleta) NO-LOCK
               WHERE produt-carg.num-carg = carg-rural.num-carg
                 AND produt-carg.cdn-produt-resp = produt-carg.cdn-produt-rural:
                
                ASSIGN tt-carga-preco.qtd-pto-col     = tt-carga-preco.qtd-pto-col     + 1
                       tt-carga-preco.qtd-pto-col-bon = tt-carga-preco.qtd-pto-col-bon + 1.
                       
                /*Caso o ponto não tenha sido coletado, não recebe bonus */
                IF produt-carg.cdn-motiv-nao-coleta > 0 THEN
                    ASSIGN tt-carga-preco.qtd-pto-col-bon  = tt-carga-preco.qtd-pto-col-bon - 1.                    
            END.
            
            /* Salva o número de pontos coletados (sem considerar penalizações )*/
            ASSIGN tt-carga-preco.num-pto-coletados = tt-carga-preco.qtd-pto-col-bon.
            
        END.
    END. /* for each carg-rural*/
    
    /* Calcula frete somente para cargas encerradas */
    FOR EACH tt-carga-preco:
    
        RUN pi-acompanhar IN h-acomp (INPUT c-acomp[2] + " - " + STRING(tt-carga-preco.num-carg)).
        
        ASSIGN l-regra-especifica = NO.
        
        RUN pi-criar-tt-preco-frete-coleta IN THIS-PROCEDURE(OUTPUT l-regra-especifica).
        
        IF l-regra-especifica THEN DO: 
            RUN pi-calcula-valor-frete IN THIS-PROCEDURE.
        END.
        ELSE DO:
            FOR EACH tt-preco-frete-coleta:               
                /* caso nao encontre uma regra especifica, faz a verificacao de abrangencias certas e peso */
                IF NOT l-regra-especifica THEN DO:                            
                    IF tt-preco-frete-coleta.cod-rota = tt-carga-preco.cod-rota THEN
                        ASSIGN tt-preco-frete-coleta.n-abrang-certas = tt-preco-frete-coleta.n-abrang-certas + 1
                               tt-preco-frete-coleta.peso            = tt-preco-frete-coleta.peso            + 1.

                    IF tt-preco-frete-coleta.cod-transp = tt-carga-preco.cod-transp THEN
                        ASSIGN tt-preco-frete-coleta.n-abrang-certas = tt-preco-frete-coleta.n-abrang-certas + 1
                               tt-preco-frete-coleta.peso            = tt-preco-frete-coleta.peso            + 2.

                    IF tt-preco-frete-coleta.cdn-tip-veic = mdfe-veic.cdn-tip-veic THEN
                        ASSIGN tt-preco-frete-coleta.n-abrang-certas = tt-preco-frete-coleta.n-abrang-certas + 1
                               tt-preco-frete-coleta.peso            = tt-preco-frete-coleta.peso            + 3.

                    IF tt-preco-frete-coleta.it-codigo = tt-carga-preco.it-codigo THEN
                        ASSIGN tt-preco-frete-coleta.n-abrang-certas = tt-preco-frete-coleta.n-abrang-certas + 1
                               tt-preco-frete-coleta.peso            = tt-preco-frete-coleta.peso            + 4.            
                END.
            END.
            
            /* REGRAS PARA SELECIONAR PRECO CONSIDERANDO NUMERO DE ABRANGENCIAS CERTAS */
            ASSIGN i-cont                = 0
                   d-peso-aux            = 0
                   i-n-abrang-certas-aux = 0.
                   
            FOR EACH tt-preco-frete-coleta 
                  BY tt-preco-frete-coleta.n-abrang-certas DESC:   
                  
                IF tt-preco-frete-coleta.n-abrang-certas > i-n-abrang-certas-aux  THEN
                    ASSIGN i-n-abrang-certas-aux  = tt-preco-frete-coleta.n-abrang-certas.
                IF tt-preco-frete-coleta.n-abrang-certas < i-n-abrang-certas-aux  THEN
                    DELETE tt-preco-frete-coleta.
                ELSE
                    ASSIGN i-cont = i-cont + 1.
            END.
            IF i-cont = 1 THEN DO:                  
               RUN pi-calcula-valor-frete IN THIS-PROCEDURE.
            END.
            ELSE DO:            
                /* REGRAS PARA SELECIONAR PRECO CONSIDERANDO PESO DA REGRA */
                FOR EACH tt-preco-frete-coleta 
                      BY tt-preco-frete-coleta.peso DESC:
                    IF tt-preco-frete-coleta.peso > d-peso-aux THEN
                        ASSIGN d-peso-aux = tt-preco-frete-coleta.peso.
                    IF tt-preco-frete-coleta.peso < d-peso-aux THEN
                        DELETE tt-preco-frete-coleta.
                END.
                RUN pi-calcula-valor-frete IN THIS-PROCEDURE.
            END.
        END.
    END.
   
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-criar-tt-preco-frete-coleta:   
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pl-regra-especifica AS LOGICAL NO-UNDO.
    
    DEFINE VARIABLE l-criar-regra AS LOGICAL NO-UNDO.
    
    EMPTY TEMP-TABLE tt-preco-frete-coleta NO-ERROR.
    
    IF CAN-FIND(FIRST preco-frete-coleta 
                WHERE preco-frete-coleta.cod-estabel      = tt-carga-preco.cod-estabel
                  AND preco-frete-coleta.cod-rota         = tt-carga-preco.cod-rota     
                  AND preco-frete-coleta.cod-transp       = tt-carga-preco.cod-transp   
                  AND preco-frete-coleta.cdn-tip-veic     = tt-carga-preco.cdn-tip-veic 
                  AND preco-frete-coleta.it-codigo        = tt-carga-preco.it-codigo
                  AND preco-frete-coleta.dat-inic-vigenc <= tt-carga-preco.dat-trans
                  AND preco-frete-coleta.dat-fim-vigenc  >= tt-carga-preco.dat-trans) THEN DO: 
                  
        FOR FIRST preco-frete-coleta NO-LOCK
            WHERE preco-frete-coleta.cod-estabel      = tt-carga-preco.cod-estabel
              AND preco-frete-coleta.cod-rota         = tt-carga-preco.cod-rota     
              AND preco-frete-coleta.cod-transp       = tt-carga-preco.cod-transp   
              AND preco-frete-coleta.cdn-tip-veic     = tt-carga-preco.cdn-tip-veic 
              AND preco-frete-coleta.it-codigo        = tt-carga-preco.it-codigo
              AND preco-frete-coleta.dat-inic-vigenc <= tt-carga-preco.dat-trans
              AND preco-frete-coleta.dat-fim-vigenc  >= tt-carga-preco.dat-trans: 
              
            CREATE tt-preco-frete-coleta.
            BUFFER-COPY preco-frete-coleta TO tt-preco-frete-coleta NO-ERROR.
            ASSIGN pl-regra-especifica = YES.
        END.
    END.
    ELSE DO:
        FOR EACH preco-frete-coleta NO-LOCK
           WHERE preco-frete-coleta.cod-estabel      = tt-carga-preco.cod-estabel
             AND preco-frete-coleta.dat-inic-vigenc <= tt-carga-preco.dat-trans
             AND preco-frete-coleta.dat-fim-vigenc  >= tt-carga-preco.dat-trans:
              
            IF (preco-frete-coleta.cod-rota <> "*" AND 
                preco-frete-coleta.cod-rota <> tt-carga-preco.cod-rota) THEN NEXT.
                
            IF (preco-frete-coleta.cod-transp <> 0 AND 
                preco-frete-coleta.cod-transp <> tt-carga-preco.cod-transp) THEN NEXT.
                 
            IF (preco-frete-coleta.cdn-tip-veic <> 0 AND
                preco-frete-coleta.cdn-tip-veic <> tt-carga-preco.cdn-tip-veic) THEN NEXT.
                 
            IF (preco-frete-coleta.it-codigo <> "*" AND
                preco-frete-coleta.it-codigo <> tt-carga-preco.it-codigo) THEN NEXT.
                 
            CREATE tt-preco-frete-coleta.
            BUFFER-COPY preco-frete-coleta TO tt-preco-frete-coleta NO-ERROR.
            
        END.
    END.
    
    ASSIGN tt-carga-preco.km-rodados    = tt-carga-preco.val-hodom-final - tt-carga-preco.val-hodom-inicial
           tt-carga-preco.km-bonif      = tt-carga-preco.km-rodados
           tt-carga-preco.desc-sit-carg = {ininc/i01in00961.i 04 tt-carga-preco.cdn-sit}.
    
    IF CAN-FIND(FIRST produt-carg 
                WHERE produt-carg.num-carg = tt-carga-preco.num-carg
                  AND produt-carg.idi-nao-coleta = 3) THEN DO: /* REPROVADO */
         ASSIGN tt-carga-preco.km-bonif        = 0
                tt-carga-preco.qtd-pto-col-bon = 0
                tt-carga-preco.motiv-nao-coleta = {ininc/i01in00965.i 04 3}
                tt-carga-preco.idi-nao-coleta   = 3.
    END.
    ELSE IF CAN-FIND(FIRST produt-carg 
                     WHERE produt-carg.num-carg       = tt-carga-preco.num-carg
                       AND produt-carg.idi-nao-coleta = 1) THEN DO: /*PENDENTE*/ 
                  
        ASSIGN tt-carga-preco.km-bonif         = 0
               tt-carga-preco.qtd-pto-col-bon  = 0
               tt-carga-preco.motiv-nao-coleta = {ininc/i01in00965.i 04 1}
               tt-carga-preco.idi-nao-coleta   = 1.
    END.
    ELSE IF CAN-FIND(FIRST produt-carg 
                     WHERE produt-carg.num-carg       = tt-carga-preco.num-carg
                       AND produt-carg.idi-nao-coleta = 2) THEN DO: /* APROVADO */
                       
         ASSIGN tt-carga-preco.motiv-nao-coleta = {ininc/i01in00965.i 04 2}
                tt-carga-preco.idi-nao-coleta   = 2.
    END.
    
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-calcula-valor-frete:
/*------------------------------------------------------------------------------
  Purpose: Calcular o valor do frete para carga com a regra selecionada
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE d-valor-km           AS DECIMAL NO-UNDO.
    DEFINE VARIABLE d-valor-padrao-rota  AS DECIMAL NO-UNDO.
    DEFINE VARIABLE d-valor-quant        AS DECIMAL NO-UNDO.
    DEFINE VARIABLE d-valor-frete-pagar  AS DECIMAL NO-UNDO.
    DEFINE VARIABLE d-valor-frete-padrao AS DECIMAL NO-UNDO.
    DEFINE VARIABLE d-valor-bonus        AS DECIMAL NO-UNDO.
    DEFINE VARIABLE d-valor-bonus-padrao AS DECIMAL NO-UNDO.
    
    FOR FIRST tt-preco-frete-coleta:    
        /* ATUALIZA VALORES DE BONUS PARA CALCULO DO FRETE */ 
        ASSIGN tt-carga-preco.val-unit-bonus-pto-col = tt-preco-frete-coleta.val-unit-bonus-pto-col
               tt-carga-preco.val-unit-bonus-km      = tt-preco-frete-coleta.val-unit-bonus-km.
    
    
        /* CALCULA FRETE SE A CARGA ESTIVER ENCERRADA E TODAS AS NC'S ESTIVEREM RESOLVIDAS */
        IF tt-carga-preco.cdn-sit = 5 /* Carga encerrada */
        AND NOT CAN-FIND(FIRST naocfedade-carg WHERE naocfedade-carg.num-carg = tt-carga-preco.num-carg 
                           AND naocfedade-carg.idi-tip-naocfedade = 3 /*NAO COLETA */ 
                           AND naocfedade-carg.cdn-sit <> 3) THEN DO: /* naocfedade-carg.cdn-sit => 3 => RESOLVIDO */
        
            ASSIGN d-valor-km           = (tt-carga-preco.val-hodom-final - tt-carga-preco.val-hodom-inicial) * tt-preco-frete-coleta.val-unit-frete-km
                   d-valor-padrao-rota  = tt-carga-preco.val-percur * tt-preco-frete-coleta.val-unit-frete-km
                   d-valor-quant        = tt-carga-preco.qtd-coleta * tt-preco-frete-coleta.val-unit-frete-quant
                   d-valor-bonus        = (tt-carga-preco.qtd-pto-col-bon * tt-carga-preco.val-unit-bonus-pto-col) + (tt-carga-preco.km-bonif * tt-carga-preco.val-unit-bonus-km)
                   d-valor-bonus-padrao = (tt-carga-preco.qtd-pto-col-bon * tt-carga-preco.val-unit-bonus-pto-col) + (tt-carga-preco.val-percur * tt-carga-preco.val-unit-bonus-km).
            
            
            
            
            
                   /*Valor frete pagar = (KM Rodados x Preço Unit KM) + (Qtde Coletada x Preço Unit Qtde) + Preço Fixo*/  
            ASSIGN d-valor-frete-pagar                      = d-valor-km + d-valor-quant  + tt-preco-frete-coleta.val-fix-frete + d-valor-bonus
                  /*Valor frete pagar = (KM Padrao da Rota x Preço Unit KM) + (Qtde Coletada x Preço Unit Qtde) + Preço Fixo*/  
                   d-valor-frete-padrao                     = d-valor-padrao-rota + d-valor-quant  + tt-preco-frete-coleta.val-fix-frete + d-valor-bonus-padrao
                   tt-preco-frete-coleta.valor-frete-pagar  = d-valor-frete-pagar
                   tt-preco-frete-coleta.valor-frete-padrao = d-valor-frete-padrao. 
        END.
        
        RUN pi-atualiza-tt-carga-preco IN THIS-PROCEDURE.
        
        IF tt-param.atualiza-frete-carg THEN
            RUN pi-atualiza-valor-frete-carga IN THIS-PROCEDURE(INPUT tt-carga-preco.num-carg, INPUT d-valor-frete-pagar).    
     END.  
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-atualiza-tt-carga-preco:
/*------------------------------------------------------------------------------
  Purpose: Atualizar campos da regra de preco encontrada para a carga
           na temp-table de tt-carga-preco para ser enviado para planilha.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN tt-carga-preco.val-unit-frete-km    = tt-preco-frete-coleta.val-unit-frete-km
           tt-carga-preco.val-unit-frete-quant = tt-preco-frete-coleta.val-unit-frete-quant
           tt-carga-preco.val-fix-frete        = tt-preco-frete-coleta.val-fix-frete 
           tt-carga-preco.valor-frete-pagar    = tt-preco-frete-coleta.valor-frete-pagar
           tt-carga-preco.valor-frete-padrao   = tt-preco-frete-coleta.valor-frete-padrao
           tt-carga-preco.dat-inic-vigenc      = tt-preco-frete-coleta.dat-inic-vigenc 
           tt-carga-preco.dat-fim-vigenc       = tt-preco-frete-coleta.dat-fim-vigenc         
           tt-carga-preco.vl-frete-qtde        = tt-preco-frete-coleta.valor-frete-pagar / tt-carga-preco.qtd-coleta WHEN tt-carga-preco.qtd-coleta    > 0
           tt-carga-preco.percent-ocup         = (tt-carga-preco.qtd-coleta / tt-carga-preco.qtd-capac-vol) * 100    WHEN tt-carga-preco.qtd-capac-vol > 0  
           tt-carga-preco.lt-km                = tt-carga-preco.qtd-coleta / tt-carga-preco.km-rodados               WHEN tt-carga-preco.km-rodados    > 0           
           tt-carga-preco.val-liq-frete        = tt-preco-frete-coleta.valor-frete-pagar - tt-carga-preco.val-debit-transp .                      
           
    ASSIGN tt-carga-preco.regra-utiliz  = REPLACE(c-regra[1], "&1":U, tt-preco-frete-coleta.cod-estabel             ) + " / ":U + 
                                          REPLACE(c-regra[2], "&2":U, tt-preco-frete-coleta.cod-rota                ) + " / ":U + 
                                          REPLACE(c-regra[3], "&3":U, STRING(tt-preco-frete-coleta.cod-transp)      ) + " / ":U + 
                                          REPLACE(c-regra[4], "&4":U, STRING(tt-preco-frete-coleta.cdn-tip-veic)    ) + " / ":U + 
                                          REPLACE(c-regra[5], "&5":U, tt-preco-frete-coleta.it-codigo               ) + " / ":U + 
                                          REPLACE(c-regra[6], "&6":U, STRING(tt-preco-frete-coleta.dat-inic-vigenc )) + " / ":U +
                                          REPLACE(c-regra[7], "&7":U, STRING(tt-preco-frete-coleta.dat-fim-vigenc )). 
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-atualiza-valor-frete-carga:
/*------------------------------------------------------------------------------
  Purpose: Atualizar valor calculado do frete na carga rural
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-num-carg  AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER pi-val-frete AS DECIMAL NO-UNDO.  
    
    FOR FIRST bf-carg-rural FIELDS(val-frete) EXCLUSIVE-LOCK
        WHERE bf-carg-rural.num-carg = pi-num-carg:        
        ASSIGN bf-carg-rural.val-frete = pi-val-frete.
    END.  
    
    RETURN "OK":U.
END PROCEDURE.
