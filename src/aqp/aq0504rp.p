/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0504RP LIBERADO}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AQ0504RP MAQ}
&ENDIF

/******************************************************************************
**
**       Programa: AQ0504RP.P
**
**       Data....: 04/04/2016.
**
**       Objetivo: Relatório de diferenças e rejeições das carga
**                 M¢dulo Aquisi‡Æo de Produtos Rurais.
** 
******************************************************************************/
{utp/ut-glob.i}
{include/tt-edit.i}
{include/i-rpvar.i} 
{cdp/cd0031.i}  /* seguranca por estabelecimento */

/* ************************  TEMP-TABLES DEFINITIONS ********************** */    
{aqp/aq0504.i1}

/* ************************  DEFINITIONS ********************************* */
DEFINE VARIABLE h-utapi033 AS HANDLE NO-UNDO.

IF NOT VALID-HANDLE(h-utapi033) THEN
    RUN utp/utapi033.p PERSISTENT SET h-utapi033.
    
{include/i_prdvers.i} /* Versão Produto */        
    
/* ************************  PARAMETERS DEFINITIONS ********************** */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.   

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  

RUN pi-inicializar IN h-acomp (INPUT c-titulo-relat).

ASSIGN c-programa     = "AQ0504":U
       c-versao       = "I.00":U
       c-revisao      = "001":U
       c-sistema      = RETURN-VALUE
       c-rodape       = "TOTVS - ":U + c-programa  +  " - V:":U + c-versao.
       c-rodape       = FILL("-", 132 - LENGTH(c-rodape)) + c-rodape.
       
FIND FIRST param-global NO-LOCK NO-ERROR.
IF AVAIL param-global THEN
    ASSIGN c-empresa  = param-global.grupo.  

FIND FIRST tt-param NO-ERROR.
IF NOT AVAIL tt-param THEN RETURN "NOK":U.
 
RUN pi-executar IN THIS-PROCEDURE.

RUN pi-finalizar IN h-acomp.

RETURN "OK":U.

/******************************* PROCEDURES ***********************************/
PROCEDURE pi-executar:
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-prepare                AS CHARACTER NO-UNDO.
    DEFINE VARIABLE d-val-perc-variac-amaior AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE d-val-perc-variac-amenor AS DECIMAL   NO-UNDO.
    
    DEFINE VARIABLE d-val-min                AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE d-val-max                AS DECIMAL   NO-UNDO.
    
    DEFINE VARIABLE qh-carg-rural            AS HANDLE    NO-UNDO.
    DEFINE VARIABLE bh-carg-rural            AS HANDLE    NO-UNDO.
    DEFINE VARIABLE bh-liber-carg            AS HANDLE    NO-UNDO.
    
    ASSIGN bh-carg-rural = BUFFER carg-rural:HANDLE
           bh-liber-carg = BUFFER liber-carg:HANDLE.
    
    CREATE QUERY qh-carg-rural.
    qh-carg-rural:SET-BUFFERS(bh-carg-rural).
    
    /* rejeicao */
    IF tt-param.emissao = 2 THEN
        qh-carg-rural:ADD-BUFFER(bh-liber-carg).
        
    ASSIGN c-prepare = "FOR EACH carg-rural NO-LOCK":U + 
                         " WHERE carg-rural.dat-trans   >= DATE('":U + TRIM(STRING(tt-param.dt-trans-ini)) + "') ":U +
                         "   AND carg-rural.dat-trans   <= DATE('":U + TRIM(STRING(tt-param.dt-trans-fim)) + "') " +
                         "   AND carg-rural.num-carg    >= ":U  + TRIM(STRING(tt-param.num-carg-ini))      + 
                         "   AND carg-rural.num-carg    <= ":U  + TRIM(STRING(tt-param.num-carg-fim))      + 
                         "   AND carg-rural.cod-transp  >= ":U  + TRIM(STRING(tt-param.cod-transp-ini))    + 
                         "   AND carg-rural.cod-transp  <= ":U  + TRIM(STRING(tt-param.cod-transp-fim))    +
                         "   AND carg-rural.cod-estabel >= '":U + TRIM(STRING(tt-param.cod-estab-ini))     + "'":U + 
                         "   AND carg-rural.cod-estabel <= '":U + TRIM(STRING(tt-param.cod-estab-fim))     + "'":U +
                         "   AND carg-rural.cod-rota    >= '":U + TRIM(STRING(tt-param.cod-rota-ini))      + "'":U + 
                         "   AND carg-rural.cod-rota    <= '":U + TRIM(STRING(tt-param.cod-rota-fim))      + "'":U + 
                         "   AND carg-rural.it-codigo   >= '":U + TRIM(STRING(tt-param.it-codigo-ini))     + "'":U + 
                         "   AND carg-rural.it-codigo   <= '":U + TRIM(STRING(tt-param.it-codigo-fim))     + "'":U + 
                         "   AND carg-rural.cdn-sit     >= 5":U.
    /* rejeicao */
    IF tt-param.emissao = 2 THEN
        ASSIGN c-prepare = c-prepare + 
                           ",   EACH liber-carg NO-LOCK":U + 
                           "   WHERE liber-carg.num-carg = carg-rural.num-carg":U +
                           "     AND liber-carg.codigo-rejei >= ":U + TRIM(STRING(tt-param.codigo-rejei-ini)) +
                           "     AND liber-carg.codigo-rejei <= ":U + TRIM(STRING(tt-param.codigo-rejei-fim)) +
                           "     AND liber-carg.codigo-rejei > 0":U.

    qh-carg-rural:QUERY-PREPARE(c-prepare).        
    qh-carg-rural:QUERY-OPEN.   
    
    EMPTY TEMP-TABLE tt-carga NO-ERROR.
    
    REPEAT:
        qh-carg-rural:GET-NEXT().
        IF qh-carg-rural:QUERY-OFF-END THEN LEAVE.
        
        {cdp/cd0031a.i bh-carg-rural:BUFFER-FIELD('cod-estabel':U):BUFFER-VALUE} /* seguranca por estabelecimento */
        
        RUN pi-acompanhar IN h-acomp (INPUT c-titulo-coluna-default[6] + " - ":U + STRING(bh-carg-rural:BUFFER-FIELD('num-carg':U):BUFFER-VALUE)).
        
        IF tt-param.cons-toler THEN DO:
            FOR FIRST item-estab-rural FIELDS(val-perc-variac-amaior val-perc-variac-amenor) NO-LOCK
                WHERE item-estab-rural.it-codigo   = bh-carg-rural:BUFFER-FIELD('it-codigo':U):BUFFER-VALUE
                  AND item-estab-rural.cod-estabel = bh-carg-rural:BUFFER-FIELD('cod-estabel':U):BUFFER-VALUE: END.
            IF AVAIL item-estab-rural THEN DO:    
            
                ASSIGN d-val-perc-variac-amaior = bh-carg-rural:BUFFER-FIELD('qtd-coleta':U):BUFFER-VALUE * (item-estab-rural.val-perc-variac-amaior / 100)
                       d-val-perc-variac-amenor = bh-carg-rural:BUFFER-FIELD('qtd-coleta':U):BUFFER-VALUE * (item-estab-rural.val-perc-variac-amenor / 100).
                       
                ASSIGN d-val-min =  bh-carg-rural:BUFFER-FIELD('qtd-coleta':U):BUFFER-VALUE - d-val-perc-variac-amenor
                       d-val-max =  bh-carg-rural:BUFFER-FIELD('qtd-coleta':U):BUFFER-VALUE + d-val-perc-variac-amaior.
                       
                /* se estiver dentro do percentual de variacao não mostra no relatorio */
                IF NOT(bh-carg-rural:BUFFER-FIELD('qtd-aferid':U):BUFFER-VALUE <  d-val-min  OR 
                       bh-carg-rural:BUFFER-FIELD('qtd-aferid':U):BUFFER-VALUE >  d-val-max) THEN NEXT.

            END.
        END.
        
        CREATE tt-carga.
        ASSIGN tt-carga.cod-transp    = bh-carg-rural:BUFFER-FIELD('cod-transp':U):BUFFER-VALUE
               tt-carga.it-codigo     = bh-carg-rural:BUFFER-FIELD('it-codigo':U):BUFFER-VALUE
               tt-carga.cod-estabel   = bh-carg-rural:BUFFER-FIELD('cod-estabel':U):BUFFER-VALUE
               tt-carga.cod-rota      = bh-carg-rural:BUFFER-FIELD('cod-rota':U):BUFFER-VALUE
               tt-carga.dat-trans     = bh-carg-rural:BUFFER-FIELD('dat-trans':U):BUFFER-VALUE
               tt-carga.num-carg      = bh-carg-rural:BUFFER-FIELD('num-carg':U):BUFFER-VALUE             
               tt-carga.cod-placa     = bh-carg-rural:BUFFER-FIELD('cod-placa':U):BUFFER-VALUE
               tt-carga.km-rodados    = bh-carg-rural:BUFFER-FIELD('val-hodom-final':U):BUFFER-VALUE - bh-carg-rural:BUFFER-FIELD('val-hodom-inicial':U):BUFFER-VALUE
               tt-carga.qtd-coleta    = bh-carg-rural:BUFFER-FIELD('qtd-coleta':U):BUFFER-VALUE
               tt-carga.qtd-aferid    = bh-carg-rural:BUFFER-FIELD('qtd-aferid':U):BUFFER-VALUE
               tt-carga.dif-qtde      = bh-carg-rural:BUFFER-FIELD('qtd-aferid':U):BUFFER-VALUE - bh-carg-rural:BUFFER-FIELD('qtd-coleta'):BUFFER-VALUE
               tt-carga.valor-frete   = bh-carg-rural:BUFFER-FIELD('val-frete':U):BUFFER-VALUE
               tt-carga.vl-frete-qtde = tt-carga.valor-frete / bh-carg-rural:BUFFER-FIELD('qtd-coleta':U):BUFFER-VALUE WHEN bh-carg-rural:BUFFER-FIELD('qtd-coleta':U):BUFFER-VALUE > 0.
        
        /* NOME TRANSPORTADOR */
        FOR FIRST transporte FIELDS (nome) NO-LOCK
            WHERE transporte.cod-transp = bh-carg-rural:BUFFER-FIELD('cod-transp':U):BUFFER-VALUE:
            ASSIGN tt-carga.nome = transporte.nome.
        END.
        
        /* TIPO VEICULO */
        FOR FIRST mdfe-veic FIELDS(cdn-tip-veic) NO-LOCK 
            WHERE mdfe-veic.cod-inter-veic = bh-carg-rural:BUFFER-FIELD('cod-inter-veic':U):BUFFER-VALUE:
            ASSIGN tt-carga.cdn-tip-veic = mdfe-veic.cdn-tip-veic.
        END.
        
        IF tt-param.emissao = 1 THEN DO:
            /* QUANTIDADE REJEITADA */
            FOR EACH liber-carg FIELDS(val-quant) NO-LOCK
               WHERE liber-carg.num-carg = bh-carg-rural:BUFFER-FIELD('num-carg':U):BUFFER-VALUE
                 AND liber-carg.codigo-rejei <> 0:
                ASSIGN tt-carga.qtd-rej = tt-carga.qtd-rej + liber-carg.val-quant.             
            END.
        END.
        
        /* Campos rejeicao */
        IF tt-param.emissao = 2 THEN DO:
           ASSIGN tt-carga.cdn-compart  = bh-liber-carg:BUFFER-FIELD('cdn-compart':U):BUFFER-VALUE
                  tt-carga.codigo-rejei = bh-liber-carg:BUFFER-FIELD('codigo-rejei':U):BUFFER-VALUE
              &IF "{&product_version}" >= "12.1.C":U &THEN /* 12.1.13 */
                  tt-carga.motivo-rejei = bh-liber-carg:BUFFER-FIELD('cod-obs':U):BUFFER-VALUE
              &ELSE    
                  tt-carga.motivo-rejei = SUBSTR(bh-liber-carg:BUFFER-FIELD('cod-livre-1':U):BUFFER-VALUE, 1, 50)
              &ENDIF    
                  tt-carga.qtd-rej      = bh-liber-carg:BUFFER-FIELD('val-quant':U):BUFFER-VALUE.                  
            FOR FIRST cod-rejeicao FIELDS(descricao) NO-LOCK
                WHERE cod-rejeicao.codigo-rejei = bh-liber-carg:BUFFER-FIELD('codigo-rejei':U):BUFFER-VALUE: 
                ASSIGN tt-carga.desc-rejei = cod-rejeicao.descricao.
            END.
        END.
    END.
    
    RUN pi-gera-planilha IN THIS-PROCEDURE.
    
    RETURN "OK":U.
END PROCEDURE.




/******************************* PROCEDURES ***********************************/
PROCEDURE pi-gera-planilha:
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE qh             AS HANDLE    NO-UNDO.
    DEFINE VARIABLE bh             AS HANDLE    NO-UNDO.   
    
    DEFINE VARIABLE i-coluna       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-colunas      AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-format       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-data-type    AS CHARACTER NO-UNDO.

    DEFINE VARIABLE c-valor-coluna AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-campo        AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-largura      AS CHARACTER NO-UNDO.

    ASSIGN i-colunas = IF tt-param.emissao = 1 THEN EXTENT(c-titulo-coluna-dif) ELSE EXTENT(c-titulo-coluna-rej).    
    
    CREATE BUFFER bh FOR TABLE "tt-carga":U.
    CREATE QUERY qh .
    qh:SET-BUFFERS(bh).
    
    {utp/ut-liter.i Gerando_planilha * }
    RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE).
    
    DO i-coluna = 1 TO i-colunas:    
    
        ASSIGN c-largura = REPLACE(STRING(d-largura-coluna[i-coluna] * 5.6),",",".").
        
        IF tt-param.emissao = 1 THEN DO:
            ASSIGN c-valor-coluna = c-titulo-coluna-dif[i-coluna]
                   c-campo        = c-campo-dif[i-coluna].
        END.
        ELSE DO: 
            ASSIGN c-valor-coluna = c-titulo-coluna-rej[i-coluna]
                   c-campo        = c-campo-rej[i-coluna].
            /* Aumenta largura da ultima coluna */
            IF i-coluna = i-colunas THEN 
                ASSIGN c-largura = STRING(40 * 5.6).
        END.
        
        ASSIGN c-format    = STRING(bh:BUFFER-FIELD(c-campo):FORMAT)
               c-data-type = bh:BUFFER-FIELD(c-campo):DATA-TYPE.
        
        /* formato data de ser passado para character devido a restricoes da api que gera planilha */
        IF c-data-type = "date" THEN 
            ASSIGN c-format    = " ":U
                   c-data-type = "character":U.
                      
        
        /* Formato character deve ser passado em branco para a planilha */
        IF bh:BUFFER-FIELD(c-campo):DATA-TYPE = "character":U THEN 
            ASSIGN c-format = " ":U.
            
        /* cria colunas planilha */
        RUN piColumn IN h-utapi033 (INPUT i-coluna,
                                    INPUT c-data-type, 
                                    INPUT c-valor-coluna, 
                                    INPUT c-format, 
                                    INPUT c-largura).
    END.
    
    qh:QUERY-PREPARE("FOR EACH tt-carga":U). 
    qh:FORWARD-ONLY.  
    qh:QUERY-OPEN(). 

    REPEAT:
        qh:GET-NEXT().
        IF qh:QUERY-OFF-END THEN LEAVE.
        
        RUN piNewLine IN h-utapi033.
        
        DO i-coluna = 1 TO i-colunas:
        
            ASSIGN c-campo = IF tt-param.emissao = 1 THEN c-campo-dif[i-coluna] ELSE c-campo-rej[i-coluna].            
        
            RUN piLine IN h-utapi033(INPUT i-coluna, INPUT bh:BUFFER-FIELD(c-campo):BUFFER-VALUE).
        END.
    END.
    RUN pi-imprime-parametros-planilha IN THIS-PROCEDURE.
    RUN piProcessa                     IN h-utapi033 (INPUT-OUTPUT tt-param.arquivo, INPUT "AQ0504":U, INPUT c-titulo-relat).
    
    IF VALID-HANDLE(h-utapi033) THEN 
        DELETE OBJECT h-utapi033.

    RETURN "OK":U.
END PROCEDURE.



PROCEDURE pi-imprime-parametros-planilha PRIVATE:
/*------------------------------------------------------------------------------
  Purpose: imprimir parametros utilizados para geracao do relatorio.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
    DEFINE VARIABLE c-lbl-ate         AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE iParamColumnWidth AS INTEGER EXTENT 2 NO-UNDO.   

    {utp/ut-liter.i at‚ *}
    ASSIGN c-lbl-ate = RETURN-VALUE.   

    CREATE tt-param-planilha. 
    ASSIGN tt-param-planilha.descricao = c-label-param[1] /* SELE€ÇO */
           tt-param-planilha.valor     = ''.
           
    CREATE tt-param-planilha.               
    ASSIGN tt-param-planilha.descricao = c-label-param[2] /* Transportador */
           tt-param-planilha.valor     = STRING(tt-param.cod-transp-ini) + " ":U + c-lbl-ate + " ":U + STRING(tt-param.cod-transp-fim).

    CREATE tt-param-planilha.               
    ASSIGN tt-param-planilha.descricao = c-label-param[3] /* Data_Trans */
           tt-param-planilha.valor     = STRING(tt-param.dt-trans-ini) + " ":U + c-lbl-ate + " ":U + STRING(tt-param.dt-trans-fim).


    CREATE tt-param-planilha.               
    ASSIGN tt-param-planilha.descricao = c-label-param[4] /* Estab */
           tt-param-planilha.valor     = tt-param.cod-estab-ini + " ":U + c-lbl-ate + " ":U + tt-param.cod-estab-fim.
    
 
    CREATE tt-param-planilha.               
    ASSIGN tt-param-planilha.descricao = c-label-param[5] /* Rota */
           tt-param-planilha.valor     = tt-param.cod-rota-ini + " ":U + c-lbl-ate + " ":U + tt-param.cod-rota-fim.
 
    CREATE tt-param-planilha.               
    ASSIGN tt-param-planilha.descricao = c-label-param[6] /* Item */
           tt-param-planilha.valor     = tt-param.it-codigo-ini + " ":U + c-lbl-ate + " ":U + tt-param.it-codigo-fim.

    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-label-param[7] /* Rejeição */
           tt-param-planilha.valor     = STRING(tt-param.codigo-rejei-ini) + " ":U + c-lbl-ate + " ":U + STRING(tt-param.codigo-rejei-fim).
    
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-label-param[8] /* Carga */
           tt-param-planilha.valor     = STRING(tt-param.num-carg-ini) + " ":U + c-lbl-ate + " ":U + STRING(tt-param.num-carg-fim). 
           
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = '':U
           tt-param-planilha.valor     = '':U.

    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-label-param[9] /* PAR¶METROS */
           tt-param-planilha.valor     = '':U.
           
    
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-label-param[10] /* Emissão */
           tt-param-planilha.valor     = IF tt-param.emissao = 1 THEN c-label-param[11] ELSE c-label-param[12].

    {utp/ut-liter.i Sim/NÆo * }
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-label-param[13] /* Considera_Tolerância */
           tt-param-planilha.valor     = STRING(tt-param.cons-toler, RETURN-VALUE).
           
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-label-param[15] /* Arquivo_de_saída */
           tt-param-planilha.valor     = tt-param.arquivo.

    ASSIGN iParamColumnWidth[1] = 100
           iParamColumnWidth[2] = 200.

    RUN setParamColumnWidth IN h-utapi033 (INPUT iParamColumnWidth).
    RUN setTTParam          IN h-utapi033 (INPUT TABLE tt-param-planilha).

    RETURN "OK":U.
END PROCEDURE.